If Exists(Select [name] From SysObjects Where xType='P' and [name]='USP_REp_GSTR1_JSON')
Begin
	Drop Procedure USP_REp_GSTR1_JSON
End
/****** Object:  StoredProcedure [dbo].[USP_REp_GSTR1_JSON]    Script Date: 07/17/2018 17:35:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--set dateformat dmy execute USP_REp_GSTR1_JSON '01/04/2018','31/03/2019','cdnur',0
Create  Procedure [dbo].[USP_REp_GSTR1_JSON]
(
	@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME,@SecCode varchar(10),@Summary bit
)
As
Begin
	Declare @SqlCommand nvarchar(4000)
	--SET DATEFormat dmy
	--Print @EDATE
	Select Entry_Ty,BCode_Nm=(Case When isNull(BCode_Nm,'')='' Then Entry_Ty Else BCode_Nm End) InTo #lCode From LCode

	Select Part='11AAAA',ctin=cast('' as varchar(15)),inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=cast('' as varchar(2))
	,rchrg=Cast('' as varchar(1)),inv_typ=Cast('' as varchar(5))
	,num=cast(0 as int),txval=m.Net_Amt,rt=cast (0 as Decimal(10,3)),camt=m.Net_Amt,samt=m.Net_Amt,iamt=m.Net_Amt,csamt=m.Net_Amt
	,etin=cast('' as varchar(15)),sply_ty=cast('' as varchar(10)),Typ=cast('' as varchar(100))
	,ntty=cast('' as varchar(1)),nt_num=cast('' as varchar(15)),nt_dt=cast('' as SmallDateTime),rsn=cast('' as varchar(1)),p_gst=cast('' as varchar(1))
	,exp_typ=cast('' as varchar(10)),sbpcode=cast('' as varchar(20)),sbnum=cast('' as varchar(15)),sbdt=cast('' as SmallDateTime)
	,ad_amt=cast (0 as Decimal(10,2))
	,hsn_sc=cast('' as varchar(10)),[desc]=cast('' as varchar(4000)),uqc=cast('' as varchar(30)), qty=cast (0 as Decimal(15,3))
	,doc_num=cast (0 as int),doc_typ=cast('' as varchar(100)),[to]=cast('' as varchar(16)),[from]=cast('' as varchar(16)),totnum=cast (0 as int),cancel=cast (0 as int),net_issue=cast (0 as int)
	,expt_amt=cast (0 as Decimal(11,2)),nil_amt=cast (0 as Decimal(11,2)),ngsup_amt=cast (0 as Decimal(11,2)),oinum=cast('' as varchar(15)),oidt=cast('' as SmallDateTime),ont_num=cast('' as varchar(15)),ont_dt=cast('' as SmallDateTime),omon=cast('' as varchar(6))
	,Sec=Cast('' as varchar(10))
	Into #TblB2B
	From StMain m  
	Where 1=2
	
	If @SecCode='B2B' or @SecCode='All'
	Begin
	/*4A. Supplies other than those (i) attracting reverse charge and (ii) supplies made through e-commerce operator*/	
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,Sec) 
		Select distinct Part='4A',ctin=(case when isnull(ac.GSTIN,'')<>'' then ac.GSTIN else ac.UID end),inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2B'
		From StMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')=''  and (m.date between @SDATE and @EDATE) and ac.st_type <> 'Out of country'
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and (case when isnull(ac.GSTIN,'')<>'' then ac.GSTIN else ac.UID end) <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''  --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.entry_ty in('ST','S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,ac.UID
		Union /*Amendment*/
		Select distinct Part='4A',ctin=(case when isnull(ac.GSTIN,'')<>'' then ac.GSTIN else ac.UID end),inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2B'
		From StMainAm m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItemAm i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (m.[Date] between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and (case when isnull(ac.GSTIN,'')<>'' then ac.GSTIN else ac.UID end) <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''  --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.entry_ty in('ST','S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,ac.UID 
		/*Service Start*/
		union 
		Select distinct Part='4A',ctin=(case when isnull(ac.GSTIN,'')<>'' then ac.GSTIN else ac.UID end),inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2B'
		From SBMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')=''  and (m.date between @SDATE and @EDATE) and ac.st_type <> 'Out of country'
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and (case when isnull(ac.GSTIN,'')<>'' then ac.GSTIN else ac.UID end) <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''  --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt) > 0
		and m.entry_ty in('S1')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,ac.UID
		Union /*Amendment*/
		Select distinct Part='4A',ctin=(case when isnull(ac.GSTIN,'')<>'' then ac.GSTIN else ac.UID end),inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2B'
		From SBMainAm m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBItemAm i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (m.[Date] between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and (case when isnull(ac.GSTIN,'')<>'' then ac.GSTIN else ac.UID end)<>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''  --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt ) > 0
		and m.entry_ty in('S1') 
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,ac.UID
		/*Service End*/

	/*4B. Supplies attracting tax on reverse charge basis*/
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,Sec) 
		Select distinct Part='4B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='Y',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2B'
		From StMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')=''  and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) > 0  
		and m.entry_ty in('ST','S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per
		union /*Amendment*/
		Select distinct Part='4B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='Y',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2B'
		From StMainAm m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItemAm i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) > 0  
		and m.entry_ty in('ST','S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per
		/*Service Start*/
		Union
		Select distinct Part='4B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='Y',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2B'
		From SBMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')=''  and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt ) > 0  
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per
		union /*Amendment*/
		Select distinct Part='4B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='Y',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2B'
		From SBMAINAM m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEMAM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt ) > 0  
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per
		/*Service End*/

	/*4C. Supplies made through e-commerce operator attracting TCS (operator wise, rate wise) */
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,Sec) 
		Select distinct Part='4C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=isnull(eComAc.gstin,'') ,'B2B'
		From StMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')=''  and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable' and isnull(eComAc.gstin,'') <>''  --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.entry_ty in('ST','S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,isnull(eComAc.gstin,'')
		union /*Amendment*/
		Select distinct Part='4C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=isnull(eComAc.gstin,'') ,'B2B'
		From StMainAm m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItemAm i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable' and isnull(eComAc.gstin,'') <>''  --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.entry_ty in('ST','S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,isnull(eComAc.gstin,'')
		/*Service Start */
		Union 
		Select distinct Part='4C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin=isnull(eComAc.gstin,'') ,'B2B'
		From SBMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')=''  and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable' and isnull(eComAc.gstin,'') <>''  --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt ) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt ) > 0
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,isnull(eComAc.gstin,'')
		union /*Amendment*/
		Select distinct Part='4C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin=isnull(eComAc.gstin,'') ,'B2B'
		From SBMAINAM m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEMAM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable' and isnull(eComAc.gstin,'') <>''  --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt ) > 0
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,isnull(eComAc.gstin,'')
		/*Service End*/

		---6B. Supplies made to SEZ unit or SEZ Developer
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,Sec) 
		Select distinct Part='6B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ=(Case when m.ExpoType='With IGST' Then 'SEWP' Else 'SEWOP' End)
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2B'
		From StMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')='' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('SEZ') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = '' 
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,m.ExpoType
		union /*Amendment*/
		Select distinct Part='6B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ=(Case when m.ExpoType='With IGST' Then 'SEWP' Else 'SEWOP' End)
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2B'
		From StMainAm m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItemAm i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('SEZ') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = '' 
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,m.ExpoType
		/*Service Start*/
		union
		Select distinct Part='6B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ=(Case when m.ExpoType='With IGST' Then 'SEWP' Else 'SEWOP' End)
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2B'
		From SBMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')='' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('SEZ') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = '' 
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.ExpoType
		union /*Amendment*/
		Select distinct Part='6B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ=(Case when m.ExpoType='With IGST' Then 'SEWP' Else 'SEWOP' End)
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2B'
		From SBMAINAM m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEMAM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('SEZ') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = '' 
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.ExpoType
		/*Service End*/
		
		----6C. Deemed exports
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,Sec) 
		Select distinct Part='6C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='DE'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2B'
		From StMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')='' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,m.ExpoType
		union /*Amendment*/
		Select distinct Part='6C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='DE'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2B'
		From StMainAm m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItemAm i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,m.ExpoType
		/*Service Start*/
		Union
		Select distinct Part='6C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='DE'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2B'
		From SBMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  isnull(m.amenddate,'')='' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.ExpoType
		union /*Amendment*/
		Select distinct Part='6C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='DE'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2B'
		From SBMAINAM m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEMAM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.ExpoType
		/*Service End*/
	end /*B2B End */

	If @SecCode='B2BA' or @SecCode='All'
	Begin
	/*4A. Supplies other than those (i) attracting reverse charge and (ii) supplies made through e-commerce operator*/	
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,oinum,oidt,Sec) 
		Select distinct Part='9A-4A',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=''
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From StMain m
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '') 
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''  --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,ma.Inv_No,ma.[Date]
		/*Service Start*/
		Union
		Select distinct Part='9A-4A',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin=''
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From SBMAIN m
		Inner Join SBMAINAM ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '') 
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''  --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt ) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt) > 0
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,ma.Inv_No,ma.[Date]
		/*Service Start*/	
		

	/*4B. Supplies attracting tax on reverse charge basis*/
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,oinum,oidt,Sec) 
		Select distinct Part='9A-4B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='Y',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=''
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From StMain m
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)   and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '') 
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) > 0  
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,ma.Inv_No,ma.[Date]
		/*Service Start*/
		Union
		Select distinct Part='9A-4B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='Y',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin=''
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From SBMAIN m
		Inner Join SBMAINAM ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)   and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '') 
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt) > 0  
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,ma.Inv_No,ma.[Date]
		/*Service End*/
		
		/*4C. Supplies made through e-commerce operator attracting TCS (operator wise, rate wise) */
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,oinum,oidt,Sec) 
		Select distinct Part='9A-4C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=isnull(eComAc.gstin,'') 
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From StMain m
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)   and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable' and isnull(eComAc.gstin,'') <>''  --AND it.HSNCODE <> ''
		and (cGSRt_Amt + sGSRt_Amt  + iGSRt_Amt + i.COMRPCESS) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,isnull(eComAc.gstin,''),ma.Inv_No,ma.[Date]
		/*Service Start*/
		Union
		Select distinct Part='9A-4C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='R'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin=isnull(eComAc.gstin,'') 
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From SBMAIN m
		Inner Join SBMAINAM ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)   and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  
		and ac.supp_type IN ('Registered','Compounding','E-Commerce') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable' and isnull(eComAc.gstin,'') <>''  --AND it.HSNCODE <> ''
		and (i.cGSRt_Amt + i.sGSRt_Amt  + i.iGSRt_Amt) = 0  and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt) > 0
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,isnull(eComAc.gstin,''),ma.Inv_No,ma.[Date]
		/*Service End*/
		
		---6B. Supplies made to SEZ unit or SEZ Developer
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,oinum,oidt,Sec) 
		Select distinct Part='9A-6B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ=(Case when m.ExpoType='With IGST' Then 'SEWP' Else 'SEWOP' End)
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=''
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From StMain m
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  and (isnUll(ac.GSTIN,'')<> '')
		and ac.supp_type IN ('SEZ') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = '' 
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,m.ExpoType,ma.Inv_No,ma.[Date]
		/*Service Start*/
		Union
		Select distinct Part='9A-6B',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ=(Case when m.ExpoType='With IGST' Then 'SEWP' Else 'SEWOP' End)
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin=''
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From SBMAIN m
		Inner Join SBMAINAM ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SbItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  and (isnUll(ac.GSTIN,'')<> '')
		and ac.supp_type IN ('SEZ') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = '' 
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.ExpoType,ma.Inv_No,ma.[Date]
		/*Service End*/
	
	    --6C. Deemed exports
		Insert Into #TblB2B
		(Part,ctin,inum,idt,Val,POS,rchrg,inv_typ,num,txval,rt,camt,samt,iamt,csamt,etin,oinum,oidt,Sec) 
		Select distinct Part='9A-6C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='DE'
		,num=99,txval=sum(i.u_asseamt),rt=cGST_Per+sGST_Per+iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=''
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From StMain m
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  and (isnUll(ac.GSTIN,'')<> '') 
		and ac.supp_type IN ('EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.entry_ty in('ST','S1','EI') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,cGST_Per+sGST_Per+iGST_Per,m.ExpoType,ma.Inv_No,ma.[Date]
		/*Service Start*/
		Union
		Select distinct Part='9A-6C',ctin=ac.GSTIN,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,POS=st.Gst_State_Code
		,rchrg='N',inv_typ='DE'
		,num=99,txval=sum(i.u_asseamt),rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),iamt=sum(i.iGST_Amt),0 as csamt
		,etin=''
		,oinum=ma.Inv_No,oidt=ma.[Date]
		,'B2BA'
		From SBMAIN m
		Inner Join SBMAINAM ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  and (isnUll(ac.GSTIN,'')<> '') 
		and ac.supp_type IN ('EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.entry_ty in('S1') --Bug 31625
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.ExpoType,ma.Inv_No,ma.[Date]
		/*Service End*/
	end /*B2BA End */

	-----------------------------------------------------------------------------------------------------------------------------------
	If @SecCode='B2CL' or @SecCode='All'
	Begin
		--- 5A. Outward supplies (other than supplies made through e-commerce operator, rate wise)
		Insert Into #TblB2B
		(Part,pos,inum,idt,Val,num,txval,rt,iamt,csamt,etin,Sec)
		 Select distinct Part='5A',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=iGST_Per,iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2CL'
		From StMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where    isnull(m.amenddate,'')='' and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('ST')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,iGST_Per
		union /*Amendment*/
		Select distinct Part='5A',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=iGST_Per,iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2CL'
		From StMainAm m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItemAm i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('ST')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,iGST_Per
		/*Service Start*/
		union
		 Select distinct Part='5A',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=i.iGST_Per,iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2CL'
		From SBMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where    isnull(m.amenddate,'')='' and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('S1')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,i.iGST_Per
		union /*Amendment*/
		Select distinct Part='5A',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=i.iGST_Per,iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2CL'
		From SBMAINAM m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEMAM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('S1')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,i.iGST_Per
		/*Service End*/
		
		--- 5B. Supplies made through e-commerce operator attracting TCS (operator wise, rate wise) GSTIN of e-commerce operator
		Insert Into #TblB2B
		(Part,pos,inum,idt,Val,num,txval,rt,iamt,csamt,etin,Sec)
		 Select distinct Part='5B',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=iGST_Per,iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=isnull(eComAc.gstin,''),'B2CL'
		From StMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where   isnull(m.amenddate,'')='' and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') <> ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('ST')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,iGST_Per,isnull(eComAc.gstin,'')
		union /*Amendment*/
		Select distinct Part='5A',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=iGST_Per,iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin='','B2CL'
		From StMainAm m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItemAm i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('ST')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,iGST_Per
		/*Service Start*/
		union
		Select distinct Part='5B',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=i.iGST_Per,iamt=sum(i.iGST_Amt),0 as csamt
		,etin=isnull(eComAc.gstin,''),'B2CL'
		From SBMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where   isnull(m.amenddate,'')='' and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') <> ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('S1')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,i.iGST_Per,isnull(eComAc.gstin,'')
		union /*Amendment*/
		Select distinct Part='5A',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=i.iGST_Per,iamt=sum(i.iGST_Amt),0 as csamt
		,etin='','B2CL'
		From SBMAINAM m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEMAM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('S1')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,i.iGST_Per
		/*Service End*/
	End 
	/* End B2CL*/
	-----------------------------------------------------------------------------------------------------------------------------------	
	If @SecCode='B2CLA' or @SecCode='All'
	Begin   
		--- 5A. Outward supplies (other than supplies made through e-commerce operator, rate wise)
		Insert Into #TblB2B
		(Part,pos,inum,idt,Val,num,txval,rt,iamt,csamt,etin,oinum,oidt,Sec)
		 Select distinct Part='9A-5A',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=iGST_Per,iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=''
		,ma.Inv_No,ma.[Date]
		,'B2CLA'
		From StMain m
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where   (isnull(m.amenddate,'') between @SDATE and @EDATE) 
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('ST')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,iGST_Per,ma.Inv_No,ma.[Date],ma.Inv_No,ma.[Date]
		/*Service Start*/
		union
		 Select distinct Part='9A-5A',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=i.iGST_Per,iamt=sum(i.iGST_Amt),0 as csamt
		,etin=''
		,ma.Inv_No,ma.[Date]
		,'B2CLA'
		From SBMAIN m
		Inner Join SBMAINAM ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where   (isnull(m.amenddate,'') between @SDATE and @EDATE) 
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') = ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('S1')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,i.iGST_Per,ma.Inv_No,ma.[Date],ma.Inv_No,ma.[Date]
		/*Service End*/

		--- 5B. Supplies made through e-commerce operator attracting TCS (operator wise, rate wise) GSTIN of e-commerce operator
		Insert Into #TblB2B
		(Part,pos,inum,idt,Val,num,txval,rt,iamt,csamt,etin,oinum,oidt,Sec)
		 Select distinct Part='9A-5B',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=iGST_Per,iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,etin=isnull(eComAc.gstin,'')
		,ma.Inv_No,ma.[Date]
		,'B2CLA'
		From StMain m
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd) 
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE) 
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') <> ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('ST')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,iGST_Per,isnull(eComAc.gstin,''),ma.Inv_No,ma.[Date]
		/*Service Start*/
		union
		 Select distinct Part='9A-5B',POS=st.Gst_State_Code,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt
		,num=99,txval=sum(i.u_asseamt),rt=i.iGST_Per,iamt=sum(i.iGST_Amt),0 as csamt
		,etin=isnull(eComAc.gstin,'')
		,ma.Inv_No,ma.[Date]
		,'B2CLA'
		From SBMAIN m
		Inner Join SBMAINAM ma on (m.Tran_cd=ma.Tran_Cd) 
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join SBITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE) 
		and ac.supp_type IN ('Unregistered') 
		and i.LineRule = 'Taxable'  and isnull(eComAc.gstin,'') <> ''   --AND it.HSNCODE <> ''
		and m.net_amt >250000 and (i.iGST_Amt) > 0
		and m.entry_ty in ('S1')
		Group By m.Inv_No,m.[Date],m.Net_Amt,st.Gst_State_Code,i.iGST_Per,isnull(eComAc.gstin,''),ma.Inv_No,ma.[Date]
		/*Service End*/

	End /* End B2CLA*/ 
	If @SecCode='B2CS' or @SecCode='All'
	Begin
		--/*7. Taxable supplies (Net of debit notes and credit notes) to Unregistered persons other than the supplies covered in Table 5 
		--  7A. Intra-State supplies
		--  7A (1). Consolidated rate wise outward supplies [including supplies made through e-commerce operator attracting TCS] */ 
		--Insert Into #TblB2B
		--(Part,sply_ty,txval,typ,etin,pos,rt,iamt,camt,samt,csamt,Sec)
		-- Select distinct Part='7'
		-- --,sply_ty=(Case When m.iGST_Amt>0 Then 'INTRA' Else 'INTER' End)  --Commented by Prajakta B. on 25052018
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End)  --Modified by Prajakta B. on 25052018
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=iGST_Per+cGST_Per+sGST_Per,iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		-- ,'B2CS'
		--From StMain m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where isnull(m.amenddate,'')='' and (m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
	 --   --and i.LineRule = 'Taxable'  --and isnull(eComAc.gstin,'') <> ''   --AND it.HSNCODE <> ''
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('ST')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,iGST_Per+cGST_Per+sGST_Per
		--Union /*Amendment*/
		--Select distinct Part='7'
		-- --,sply_ty=(Case When m.iGST_Amt>0 Then 'INTRA' Else 'INTER' End)  --Commented by Prajakta B. on 25052018
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End)  --Modified by Prajakta B. on 25052018
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=iGST_Per+cGST_Per+sGST_Per,iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		-- ,'B2CS'
		--From StMainAm m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join StItemAm i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where (m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
	 --   --and i.LineRule = 'Taxable'  --and isnull(eComAc.gstin,'') <> ''   --AND it.HSNCODE <> ''
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('ST')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,iGST_Per+cGST_Per+sGST_Per
		--/*Service Start*/
		--union 
		-- Select distinct Part='7'
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End)
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=i.iGST_Per+i.cGST_Per+i.sGST_Per,iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),0 as csamt
		-- ,'B2CS'
		--From SbMain m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join SbItem i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where isnull(m.amenddate,'')='' and (m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
	 ----   and i.LineRule = 'Taxable'  
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('S1')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,i.iGST_Per+i.cGST_Per+i.sGST_Per
		--Union /*Amendment*/
		--Select distinct Part='7'
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End) 
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=i.iGST_Per+i.cGST_Per+i.sGST_Per,iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),0 as csamt
		-- ,'B2CS'
		--From SBMainAm m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join SBITEMAM i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where (m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
	 ----   and i.LineRule = 'Taxable' 
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('S1')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,i.iGST_Per+i.cGST_Per+i.sGST_Per
		--/*Service End*/
		--/*Debit Note Start*/
		--union 
		-- Select distinct Part='7'
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End)
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=i.iGST_Per+i.cGST_Per+i.sGST_Per,iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=SUM(i.COMPCESS)
		-- ,'B2CS'
		--From DNMAIN m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join DNITEM i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where isnull(m.amenddate,'')='' and 
		--(m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('D6','GD')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,i.iGST_Per+i.cGST_Per+i.sGST_Per
		--Union /*Amendment*/
		--Select distinct Part='7'
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End) 
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=i.iGST_Per+i.cGST_Per+i.sGST_Per,iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=SUM(i.COMPCESS)
		-- ,'B2CS'
		--From DNMAINAM m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join DNITEMAM i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where (m.date between @SDATE and @EDATE)
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('D6','GD')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,i.iGST_Per+i.cGST_Per+i.sGST_Per
		--/*Debit Note End */
		--/*Credit Note Start*/
		--union 
		-- Select distinct Part='7'
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End)
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=i.iGST_Per+i.cGST_Per+i.sGST_Per,iamt=sum(-i.iGST_Amt),camt=sum(-i.cGST_Amt),samt=sum(-i.sGST_Amt),csamt=SUM(-i.COMPCESS)
		-- ,'B2CS'
		--From CNMAIN m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join CNITEM i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where isnull(m.amenddate,'')='' and (m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and m.entry_ty in('c6','Gc')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,i.iGST_Per+i.cGST_Per+i.sGST_Per
		--Union /*Amendment*/
		--Select distinct Part='7'
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End) 
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=i.iGST_Per+i.cGST_Per+i.sGST_Per,iamt=sum(-i.iGST_Amt),camt=sum(-i.cGST_Amt),samt=sum(-i.sGST_Amt),csamt=SUM(-i.COMPCESS)
		-- ,'B2CS'
		--From CNMAINAM m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join CNITEMAM i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where (m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('c6','Gc')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,i.iGST_Per+i.cGST_Per+i.sGST_Per
		--/*Credit Note End */
		--/*Sale Return Start*/
		--union 
		-- Select distinct Part='7'
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End)
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=i.iGST_Per+i.cGST_Per+i.sGST_Per,iamt=sum(-i.iGST_Amt),camt=sum(-i.cGST_Amt),samt=sum(-i.sGST_Amt),csamt=SUM(-i.COMPCESS)
		-- ,'B2CS'
		--From SRMAIN m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join SRITEM i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where isnull(m.amenddate,'')='' and (m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('SR')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,i.iGST_Per+i.cGST_Per+i.sGST_Per
		--Union /*Amendment*/
		--Select distinct Part='7'
		-- ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End) 
		-- ,txval=sum(i.u_asseamt)
		-- ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		-- ,etin=isnull(eComAc.gstin,'')
		-- ,POS=st.Gst_State_Code
		-- ,rt=i.iGST_Per+i.cGST_Per+i.sGST_Per,iamt=sum(-i.iGST_Amt),camt=sum(-i.cGST_Amt),samt=sum(-i.sGST_Amt),csamt=SUM(-i.COMPCESS)
		-- ,'B2CS'
		--From SRMAINAM m
		--inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		--Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		--Inner Join SRITEMAM i on (m.Tran_cd=i.Tran_Cd)
		--Inner Join [State] st on (m.GSTState=st.[State])
		--Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		--Where (m.date between @SDATE and @EDATE)
		--and ac.supp_type IN ('Unregistered') 
		----and m.net_amt <=250000 
		----and ac.st_type  in ('Intrastate','Interstate')
		--and ( (ac.st_type  in ('Interstate')  and (m.net_amt <=250000) )  or ac.st_type  in ('Intrastate') )--RUP
		--and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		--and m.entry_ty in('SR')
		--Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,i.iGST_Per+i.cGST_Per+i.sGST_Per
		--/*Sales Return End */
	/* GSTR_VW DATA STORED IN TEMPORARY TABLE*/
	SELECT DISTINCT HSN_CODE, CAST(HSN_DESC AS VARCHAR(250)) AS HSN_DESC INTO #HSN FROM HSN_MASTER  --Added by Priyanka B on 01122017 for Bug-30975

	SELECT RATE1= (case when (isnull(A.CGST_PER,0)+isnull(A.SGST_PER,0)) >0  then (isnull(A.CGST_PER,0)+isnull(A.SGST_PER,0))
						when (isnull(A.IGST_PER,0)) > 0 then (isnull(A.IGST_PER,0)) else isnull(A.gstrate,0) end)
			,igst_amt1=ISNULL(a.igst_amt,0),cgst_amt1=ISNULL(a.cgst_amt,0),sGST_AMT1=isnull(a.sGST_AMT,0),CESS_AMT1 =isnull(a.CESS_AMT,0)
			,igsrt_amt1=ISNULL(a.IGSRT_AMT,0),cgsrt_amt1=ISNULL(a.CGSRT_AMT,0),sGSrT_AMT1=isnull(a.SGSRT_AMT,0),CESSR_AMT1 =isnull(a.CessR_amt,0)
			,Ecomgstin = isnull(ac.gstin,'')
			,A.*
			,HSN_DESC=ISNULL((SELECT TOP 1 HSN_DESC FROM #HSN WHERE HSN_CODE = A.HSNCODE),'')  --Added by Priyanka B on 01122017 for Bug-30975
	INTO #GSTR1TBL 
	FROM GSTR1_VW A
	left join ac_mast ac on (A.ecomac_id=ac.ac_id)
	WHERE (A.DATE BETWEEN @SDATE AND @EDATE) and A.AMENDDATE=''

	SELECT * 
	INTO #tempTbl1 
	FROM (
			select A.entry_ty,A.Tran_cd,A.Itserial,A.rentry_ty,A.Itref_tran,A.Ritserial,B.net_amt,B.INV_NO 
			from SRITREF A inner JOIN GSTR1_VW B ON (A.rentry_ty =B.ENTRY_TY AND A.Itref_tran =B.Tran_cd  AND A.Ritserial =B.ITSERIAL)
		UNION ALL
			select A.entry_ty,A.Tran_cd,A.Itserial,A.rentry_ty,A.Itref_tran,A.Ritserial,B.net_amt,B.INV_NO
			from OTHITREF A inner JOIN GSTR1_VW B ON (A.rentry_ty =B.ENTRY_TY AND A.Itref_tran =B.Tran_cd  AND A.Ritserial =B.ITSERIAL) 
		)A 
	
	select * INTO #TEMP1 
	FROM (
			SELECT  *
			from #GSTR1TBL  
			where  entry_ty in('gc','c6','gd','d6','sr')  
			and (Entry_ty + QUOTENAME(Tran_cd)) in(select (Entry_ty + QUOTENAME(Tran_cd)) from #tempTbl1 where net_amt <=250000)
		UNION ALL 
			select *
			from #GSTR1TBL  
			where  entry_ty in('S1','ST') AND net_amt <=250000 
	) AA
	
	
	Insert Into #TblB2B
	(Part,sply_ty,txval,typ,etin,pos,rt,iamt,camt,samt,csamt,Sec)
	Select * 
	from (
			select Part='7' ,sply_ty=(Case When m.ST_TYPE ='INTERSTATE' Then 'INTER' Else 'INTRA' End)
			,txval =sum((case when entry_ty in('ST','S1','D6','GD') THEN +(taxableamt)ELSE - (taxableamt) END ))
			,typ=(Case When isnull(Ecomgstin,'')<>'' Then 'E' Else 'OE' End)
			,etin=isnull(Ecomgstin,''),POS=pos_std_cd,rt=rate1
			,iamt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(igst_amt1) ELSE - (igst_amt1) END ))
			,camt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(cgst_amt1) ELSE - (cgst_amt1) END ))
			,samt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(sGST_AMT1) ELSE - (SGST_AMT1) END ))
			,csamt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(CESS_AMT1) ELSE - (CESS_AMT1) END ))
			,'B2CS' as Sec
			from #GSTR1TBL  m
			where Entry_ty in('ST','S1','GC','C6','GD','D6','SR') and m.ST_TYPE ='Intrastate' and m.SUPP_TYPE ='Unregistered' 
			AND (CGST_AMT+SGST_AMT+IGST_AMT+cess_amt) > 0
			group by rate1,pos_std_cd,M.ST_TYPE,Ecomgstin
		)aa
	where (camt+samt+iamt+csamt) > 0
	
	union
	
	Select * 
	from (
			select Part='7',sply_ty=(Case When m.ST_TYPE ='INTERSTATE' Then 'INTER' Else 'INTRA' End)
			,txval =sum((case when entry_ty in('ST','S1','D6','GD') THEN +(taxableamt)ELSE - (taxableamt) END ))
			,typ=(Case When isnull(Ecomgstin,'')<>'' Then 'E' Else 'OE' End)
			,etin=isnull(Ecomgstin,''),POS=pos_std_cd,rt=rate1
			,iamt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(IGST_AMT1) ELSE - (IGST_AMT1) END ))
			,camt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(CGST_AMT1) ELSE - (CGST_AMT1) END ))
			,samt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(SGST_AMT1) ELSE - (SGST_AMT1) END ))
			,csamt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(cess_amt1) ELSE - (cess_amt1) END ))
			,'B2CS' as Sec
			from #GSTR1TBL m
			where Entry_ty in('ST','S1','GC','C6','GD','D6','SR') and m.st_type = 'Intrastate' and m.GSTIN = 'Unregistered'	and Ecomgstin <> ''
			AND (CGST_AMT1+SGST_AMT1+IGST_AMT1+cess_amt1) > 0
			group by rate1,pos_std_cd,M.ST_TYPE,Ecomgstin
		)aa	
	where (camt+samt+iamt+csamt) > 0

	union
	
	Select * 
	from (
			select Part='7',sply_ty=(Case When m.ST_TYPE ='INTERSTATE' Then 'INTER' Else 'INTRA' End)
			,txval = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(taxableamt)ELSE - (taxableamt) END ))
			,typ=(Case When isnull(Ecomgstin,'')<>'' Then 'E' Else 'OE' End)
			,etin=isnull(Ecomgstin,''),POS=pos_std_cd,rt=RATE1
			,iamt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(IGST_AMT1) ELSE - (IGST_AMT1) END ))
			,camt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(CGST_AMT1) ELSE - (CGST_AMT1) END ))
			,samt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(SGST_AMT1) ELSE - (SGST_AMT1) END ))
			,csamt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(cess_amt1) ELSE - (cess_amt1) END ))
			,'B2CS' as Sec
			from #TEMP1 m
			where Entry_ty in('st','s1','gc','c6','gd','d6','sr') and m.ST_TYPE ='Interstate' and Ecomgstin = ''
			and m.SUPP_TYPE ='Unregistered' AND (CGST_AMT1+SGST_AMT1+IGST_AMT1+cess_amt1) > 0 
			group by rate1,pos_std_cd,M.ST_TYPE,Ecomgstin
		)aa	
	where (camt+samt+iamt+csamt) > 0
	
	union
	
	Select * 
	from (
			select Part='7',sply_ty=(Case When m.ST_TYPE ='INTERSTATE' Then 'INTER' Else 'INTRA' End)
			,txval = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(taxableamt)ELSE - (taxableamt) END ))
			,typ=(Case When isnull(Ecomgstin,'')<>'' Then 'E' Else 'OE' End)
			,etin=isnull(Ecomgstin,''),POS=pos_std_cd,rt=RATE1
			,iamt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(IGST_AMT1) ELSE - (IGST_AMT1) END ))
			,camt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(CGST_AMT1) ELSE - (CGST_AMT1) END ))
			,samt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(SGST_AMT1) ELSE - (SGST_AMT1) END ))
			,csamt = sum((case when entry_ty in('ST','S1','D6','GD') THEN +(cess_amt1) ELSE - (cess_amt1) END ))
			,'B2CS' as Sec
			from #TEMP1 m
			where Entry_ty in('ST','S1','GC','C6','GD','D6','SR') and m.st_type ='Interstate' and Ecomgstin <> ''
			and m.gstin = 'Unregistered' AND HSNCODE <> '' AND (CGST_AMT1+SGST_AMT1+IGST_AMT1+cess_amt1) > 0 
			group by rate1,pos_std_cd,M.ST_TYPE,Ecomgstin
		)aa	
	where (camt+samt+iamt+csamt) > 0
	
	End /* End B2C*/

	If @SecCode='B2CSA' or @SecCode='All'
	Begin
		/*7. Taxable supplies (Net of debit notes and credit notes) to Unregistered persons other than the supplies covered in Table 5 
		  7A. Intra-State supplies
		  7A (1). Consolidated rate wise outward supplies [including supplies made through e-commerce operator attracting TCS] */
		  
		Insert Into #TblB2B
		(Part,sply_ty,txval,typ,etin,pos,rt,iamt,camt,samt,csamt,oinum,oidt,omon,Sec)
		 Select distinct Part='10-7A'
		 --,sply_ty=(Case When m.iGST_Amt>0 Then 'INTRA' Else 'INTER' End)  --Commented by Prajakta B. on 25052018
		 ,sply_ty=(Case When m.iGST_Amt>0 Then 'INTER' Else 'INTRA' End)  --Modified by Prajakta B. on 25052018
		 ,txval=sum(i.u_asseamt)
		 ,typ=(Case When isnull(eComAc.gstin,'')<>'' Then 'E' Else 'OE' End)
		 ,etin=isnull(eComAc.gstin,'')
		 ,POS=st.Gst_State_Code
		 ,rt=iGST_Per+cGST_Per+sGST_Per,iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		 ,ma.Inv_No,ma.[Date]
		 ,omon=cast(month(ma.[Date]) as varchar(2))+cast(Year(ma.[Date]) as varchar(4))
		 ,'B2CSA'
		From StMain m 
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd) 
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id)
		Left Join Ac_Mast eComAc on (eComAc.Ac_Id=m.eComAc_Id)
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE) 
		and ac.supp_type IN ('Unregistered') 
	    and i.LineRule = 'Taxable'  --and isnull(eComAc.gstin,'') <> ''   --AND it.HSNCODE <> ''
		and m.net_amt <=250000 and (i.iGST_Amt+i.cGST_Amt+i.sGST_Amt) > 0
		and ac.st_type  in ('Intrastate','Interstate') and m.entry_ty='ST'
		Group By m.iGST_Amt,isnull(eComAc.gstin,''),st.Gst_State_Code,iGST_Per+cGST_Per+sGST_Per,ma.Inv_No,ma.[Date]
		

	End /* End B2CA*/

	If @SecCode='CDNR' or @SecCode='All'
	Begin
	/*9B. Debit Note and Credit Note - Registered*/
	Insert Into #TblB2B
		(Part,ctin,ntty,nt_num,nt_dt,rsn,p_gst,inum,idt,val,num,rt,txval,iamt,camt,samt,csamt,Sec)
		Select distinct Part='9B',ctin=ac.GSTIN,ntty='D',nt_num=m.Inv_No,nt_dt=m.[Date],rsn=Left(U_GPRICE,1),p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		,'CDNR'
		From DNMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join DNItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce','SEZ','EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.AGAINSTGS in ('SALES','Service Invoice')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.U_GPRICE,i.SBillNo,i.SbDate
		Union
		Select distinct Part='9B',ctin=ac.GSTIN,ntty='C',nt_num=m.Inv_No,nt_dt=m.[Date],rsn=Left(U_GPRICE,1),p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		,'CDNR'
		From CNMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join CNItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce','SEZ','EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  --AND it.HSNCODE <> ''
		and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.AGAINSTGS in ('SALES','Service Invoice')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.U_GPRICE,i.SBillNo,i.SbDate
		Union
		Select distinct Part='9B',ctin=ac.GSTIN,ntty='C',nt_num=m.Inv_No,nt_dt=m.[Date],'' as rsn,p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		,'CDNR'
		From SRMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join SRITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce','SEZ','EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  --AND it.HSNCODE <> ''
		and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.cGST_Per+i.sGST_Per+i.iGST_Per,i.SBillNo,i.SbDate
		/* RRG START*/
		Union
		Select distinct Part='9B',ctin=ac.GSTIN,ntty='R',nt_num=m.Inv_No,nt_dt=m.[Date],rsn='',p_gst='N'
		,inum=m.PAYMENTNO,idt=br.date,Val=m.Net_Amt,num=99,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		,'CDNR'
		From BPMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join BPItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join BRMAIN br on(m.PAYMENTNO=br.inv_no)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Registered','Compounding','E-Commerce','SEZ','EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'  --AND it.HSNCODE <> ''
		and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0 and m.entry_ty='RV'
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.PAYMENTNO,br.date

		/* RRG End*/

	End /*CDNR*/
	If @SecCode='CDNRA' or @SecCode='All'
	Begin
	/*9B. Debit Note and Credit Note - Registered*/
		Insert Into #TblB2B
		(Part,ctin,ntty,nt_num,nt_dt,rsn,p_gst,inum,idt,val,num,rt,txval,iamt,camt,samt,csamt,ont_num,ont_dt,Sec)  
		Select distinct Part='9C-9B',ctin=ac.GSTIN,ntty='D',nt_num=m.Inv_No,nt_dt=m.[Date],rsn=Left(m.U_GPRICE,1),p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		,ma.Inv_No,ma.[Date]
		,'CDNRA'
		From DNMain m 
		Inner Join DnMainAm ma on (m.Tran_cd=ma.Tran_Cd) 
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join DNItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  
		and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')
		and ac.supp_type IN ('Registered','Compounding','E-Commerce','SEZ','EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.AGAINSTGS in ('SALES','Service Invoice')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.U_GPRICE,i.SBillNo,i.SbDate,ma.Inv_No,ma.[Date]

		/*rrg start*/
		union 
		Select distinct Part='9C-9B',ctin=ac.GSTIN,ntty='C',nt_num=m.Inv_No,nt_dt=m.[Date],rsn=Left(m.U_GPRICE,1),p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		,ma.Inv_No,ma.[Date]
		,'CDNRA'
		From CNMain m 
		Inner Join CNMainAm ma on (m.Tran_cd=ma.Tran_Cd) 
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join CNItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  
		and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')
		and ac.supp_type IN ('Registered','Compounding','E-Commerce','SEZ','EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		and m.AGAINSTGS in ('SALES','Service Invoice')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.U_GPRICE,i.SBillNo,i.SbDate,ma.Inv_No,ma.[Date]
		union 
		Select distinct Part='9C-9B',ctin=ac.GSTIN,ntty='C',nt_num=m.Inv_No,nt_dt=m.[Date],'' as rsn,p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		,ma.Inv_No,ma.[Date]
		,'CDNRA'
		From SRMAIN m 
		Inner Join SRMAINAM ma on (m.Tran_cd=ma.Tran_Cd) 
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join SRITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  
		and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')
		and ac.supp_type IN ('Registered','Compounding','E-Commerce','SEZ','EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.cGST_Per+i.sGST_Per+i.iGST_Per,i.SBillNo,i.SbDate,ma.Inv_No,ma.[Date]
		
		union 

		Select distinct Part='9C-9B',ctin=ac.GSTIN,ntty='R',nt_num=m.Inv_No,nt_dt=m.[Date],rsn='',p_gst='N'
		,inum=m.PAYMENTNO,idt=br.date,Val=m.Net_Amt,num=99,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),camt=sum(i.cGST_Amt),samt=sum(i.sGST_Amt),csamt=sum(i.COMPCESS)
		,ma.Inv_No,ma.[Date]
		,'CDNRA'
		From BPMain m 
		Inner Join BPMainAm ma on (m.Tran_cd=ma.Tran_Cd) 
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join BPITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join BRMAIN br on(m.PAYMENTNO=br.inv_no)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)  
		and ac.st_type <> 'Out of country' and (isnUll(ac.GSTIN,'')<> '')
		and ac.supp_type IN ('Registered','Compounding','E-Commerce','SEZ','EOU') 
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0 and m.entry_ty='RV'
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.PAYMENTNO,br.date,ma.Inv_No,ma.[Date]
		/*rrg END*/

	End /*CDNRA*/
	
	If @SecCode='CDNUR' or @SecCode='All'
	Begin
	
	SELECT * 
	INTO #tempTbl2 
	FROM (
			select A.entry_ty,A.Tran_cd,A.Itserial,A.rentry_ty,A.Itref_tran,A.Ritserial,B.net_amt,B.INV_NO 
			from SRITREF A inner JOIN GSTR1_VW B ON (A.rentry_ty =B.ENTRY_TY AND A.Itref_tran =B.Tran_cd  AND A.Ritserial =B.ITSERIAL)
		UNION ALL
			select A.entry_ty,A.Tran_cd,A.Itserial,A.rentry_ty,A.Itref_tran,A.Ritserial,B.net_amt,B.INV_NO
			from OTHITREF A inner JOIN GSTR1_VW B ON (A.rentry_ty =B.ENTRY_TY AND A.Itref_tran =B.Tran_cd  AND A.Ritserial =B.ITSERIAL) 
		)A 
	

	/*9B. Debit Note and Credit Note - Unregistered*/
	Insert Into #TblB2B
		(Part,typ,ntty,nt_num,nt_dt,rsn,p_gst,inum,idt,val,num,rt,txval,iamt,csamt,pos,Sec)
		Select distinct Part='9B',typ=(Case when m.ExpoType='With IGST' Then 'EXPWOP' Else 'B2CL' End)
		,ntty='D',nt_num=m.Inv_No,nt_dt=m.[Date],rsn=Left(U_GPRICE,1),p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS),POS=st.Gst_State_Code
		,'CDNUR'
		From DNMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join DNItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where (isnUll(ac.GSTIN,'')<> '')  and (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') and ac.st_type='Interstate' 
		and (m.Entry_ty + QUOTENAME(m.Tran_cd)) in(select (Entry_ty + QUOTENAME(Tran_cd)) from #tempTbl2 where net_amt > 250000)
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and m.AGAINSTGS in ('SALES','Service Invoice')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.iGST_Per,m.U_GPRICE,i.SBillNo,i.SbDate,m.ExpoType,st.Gst_State_Code
		
		Union
		
		Select distinct Part='9B',typ=(Case when m.ExpoType='With IGST' Then 'EXPWOP' Else 'B2CL' End)
		,ntty='C',nt_num=m.Inv_No,nt_dt=m.[Date],rsn=Left(U_GPRICE,1),p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS),st.Gst_State_Code
		,'CDNUR'
		From CNMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join CNItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered') and ac.st_type='Interstate' 
		and (m.Entry_ty + QUOTENAME(m.Tran_cd)) in(select (Entry_ty + QUOTENAME(Tran_cd)) from #tempTbl2 where net_amt > 250000)
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and m.AGAINSTGS in ('SALES','Service Invoice')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.iGST_Per,m.U_GPRICE,i.SBillNo,i.SbDate,m.ExpoType,st.Gst_State_Code
		
		/*Sales Return Start For Bug 31625*/
		union
		
		Select distinct Part='9B','' as typ
		,ntty='D',nt_num=m.Inv_No,nt_dt=m.[Date],'' as rsn,p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS),POS=st.Gst_State_Code
		,'CDNUR'
		From SRMAIN m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join SRITEM i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where (m.date between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered')  and ac.st_type='Interstate' 
		and (m.Entry_ty + QUOTENAME(m.Tran_cd)) in(select (Entry_ty + QUOTENAME(Tran_cd)) from #tempTbl2 where net_amt > 250000)
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.iGST_Per,i.SBillNo,i.SbDate,st.Gst_State_Code
		/*Sales Return End For Bug 31625*/
	End /*CDNUR*/
	
	If @SecCode='CDNURA' or @SecCode='All'
	Begin
	/*9B. Debit Note and Credit Note - Unregistered*/
	Insert Into #TblB2B
		(Part,typ,ntty,nt_num,nt_dt,rsn,p_gst,inum,idt,val,num,rt,txval,iamt,csamt,pos,ont_num,ont_dt,Sec)
		Select distinct Part='10-9B',typ=(Case when m.ExpoType='With IGST' Then 'EXPWOP' Else 'B2CL' End)
		,ntty='D',nt_num=m.Inv_No,nt_dt=m.[Date],rsn=Left(m.U_GPRICE,1),p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS),POS=st.Gst_State_Code
		,ma.Inv_No,ma.[Date]
		,'CDNURA'
		From DNMain m
		Inner Join DnMainAm ma on (m.Tran_cd=ma.Tran_Cd)   
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join DNItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where (isnUll(ac.GSTIN,'')<> '')  and (isnull(m.amenddate,'') between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered')  and ac.st_type='Interstate' and m.net_amt>250000
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and m.AGAINSTGS in ('SALES','Service Invoice')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.iGST_Per,m.U_GPRICE,i.SBillNo,i.SbDate,m.ExpoType,st.Gst_State_Code,ma.Inv_No,ma.[Date]

		/*RRG Start */
		union

		Select distinct Part='10-9B',typ=(Case when m.ExpoType='With IGST' Then 'EXPWOP' Else 'B2CL' End)
		,ntty='C',nt_num=m.Inv_No,nt_dt=m.[Date],rsn=Left(m.U_GPRICE,1),p_gst='N'
		,inum=i.SBillNo,idt=i.SbDate,Val=m.Net_Amt,num=99,rt=i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS),POS=st.Gst_State_Code
		,ma.Inv_No,ma.[Date]
		,'CDNURA'
		From CNMain m
		Inner Join CNMainAm ma on (m.Tran_cd=ma.Tran_Cd)   
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join CNItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where (isnUll(ac.GSTIN,'')<> '')  and (isnull(m.amenddate,'') between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered')  and ac.st_type='Interstate' and m.net_amt>250000
		and ac.gstin <>'' AND i.LineRule = 'Taxable'   --AND it.HSNCODE <> ''
		and m.AGAINSTGS in ('SALES','Service Invoice')
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.iGST_Per,m.U_GPRICE,i.SBillNo,i.SbDate,m.ExpoType,st.Gst_State_Code,ma.Inv_No,ma.[Date]

		union 
		
		Select distinct Part='10-9B',typ=(Case when m.ExpoType='With IGST' Then 'EXPWOP' Else 'B2CL' End)
		,ntty='R',nt_num=m.Inv_No,nt_dt=m.[Date],rsn='',p_gst='N'
		,inum=m.PAYMENTNO,idt=br.date,Val=m.Net_Amt,num=99,rt=i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS),POS=st.Gst_State_Code
		,ma.Inv_No,ma.[Date]
		,'CDNURA'
		From BPMain m
		Inner Join BPMainAm ma on (m.Tran_cd=ma.Tran_Cd)   
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join BPItem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join BRMAIN br on(m.PAYMENTNO=br.inv_no)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where (isnUll(ac.GSTIN,'')<> '')  and (isnull(m.amenddate,'') between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered')  and ac.st_type='Interstate' and m.net_amt>250000
		and ac.gstin <>'' AND i.LineRule = 'Taxable' and m.entry_ty='RV'  --AND it.HSNCODE <> '' 
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.iGST_Per,m.PAYMENTNO,br.date,m.ExpoType,st.Gst_State_Code,ma.Inv_No,ma.[Date]
	
	union

		Select distinct Part='10-9B','' as typ
		,ntty='R',nt_num=m.Inv_No,nt_dt=m.[Date],rsn='',p_gst='N'
		,'' as inum,idt=br.date,Val=m.Net_Amt,num=99,rt=i.iGST_Per
		,txval=sum(i.u_asseamt),iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS),POS=st.Gst_State_Code
		,ma.Inv_No,ma.[Date]
		,'CDNURA'
		From SRMAIN m
		Inner Join SRMAINAM ma on (m.Tran_cd=ma.Tran_Cd)   
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join sritem i on (m.Tran_cd=i.Tran_Cd)
		Inner Join SRMAIN br on(m.inv_no=br.inv_no)
		Inner Join [State] st on (m.GSTState=st.[State])
		Inner Join [It_Mast] it on (i.It_Code=It.It_Code)
		Where (isnUll(ac.GSTIN,'')<> '')  and (isnull(m.amenddate,'') between @SDATE and @EDATE)
		and ac.supp_type IN ('Unregistered')  and ac.st_type='Interstate' and m.net_amt>250000
		and ac.gstin <>'' AND i.LineRule = 'Taxable' and m.entry_ty='SR'  
		Group By ac.GSTIN,m.Inv_NO,m.[Date],m.Net_Amt,i.iGST_Per,br.date,st.Gst_State_Code,ma.Inv_No,ma.[Date]
		/*RRG end */

	End /*CDNURA*/
	If @SecCode='EXP' or @SecCode='All'
	Begin
	/*6A. Export Invoices*/	
		Insert Into #TblB2B
		(Part,exp_typ,inum,idt,val,sbpcode,sbnum,sbdt,txval,rt,iamt,csamt,Sec)
 		Select distinct Part='6A',exp_typ=(Case when m.ExpoType='With IGST' Then 'WPAY' Else 'WOPAY' End)
		,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,sbpcode=m.PORTCODE,sbnum=m.u_VESSEL,sbdt=m.U_SBDT
		,txval=sum(i.u_asseamt),rt=iGST_Per,iamt=sum(i.iGST_Amt),csamt=sum(i.COMPCESS)
		,Sec='EXP'
		From StMain m
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Where  (m.date between @SDATE and @EDATE)
		and ac.st_type = 'Out of country' --and ac.supp_type IN ('Export') 
		and i.LineRule = 'Taxable'  --AND it.HSNCODE <> ''
		Group By m.Inv_NO,m.[Date],m.Net_Amt,m.ExpoType,m.PORTCODE,m.u_VESSEL,m.U_SBDT,iGST_Per
	End

	/*rrg*/
	If @SecCode='EXPA' or @SecCode='All'
	Begin
		Insert Into #TblB2B
		(Part,exp_typ,inum,idt,val,sbpcode,sbnum,sbdt,txval,rt,iamt,csamt,oinum,oidt,Sec) 
 		Select distinct Part='9-6A',exp_typ=(Case when m.ExpoType='With IGST' Then 'WPAY' Else 'WOPAY' End)
		,inum=m.Inv_NO,idt=m.[Date],Val=m.Net_Amt,sbpcode=m.PORTCODE,sbnum=m.u_VESSEL,sbdt=m.U_SBDT
		,txval=sum(i.u_asseamt),rt=iGST_Per,iamt=sum(m.iGST_Amt),csamt=sum(COMPCESS)
		,ma.Inv_No,ma.[Date]
		,Sec='B2BA-EXP'
		From StMain m
		Inner Join StMainAm ma on (m.Tran_cd=ma.Tran_Cd)
		inner join Ac_Mast ac on (m.Ac_Id=Ac.Ac_id) 
		Inner Join StItem i on (m.Tran_cd=i.Tran_Cd)
		Where  (m.date between @SDATE and @EDATE)
		and ac.st_type = 'Out of country' --and ac.supp_type IN ('Export') 
		and i.LineRule = 'Taxable'  --AND it.HSNCODE <> ''
		Group By m.Inv_NO,m.[Date],m.Net_Amt,m.ExpoType,m.PORTCODE,m.u_VESSEL,m.U_SBDT,iGST_Per,ma.Inv_No,ma.[Date]
		END
		/*rrg*/
	If @SecCode='AT' or @SecCode='All'
	Begin
		/*11A. Advance Tax */

				Select REntry_Ty,ItRef_Tran,rt=TaxRate,ad_amt=sum(ta.[Taxable]),iamt=sum(ta.iGST_Amt),camt=sum(ta.cGST_Amt),samt=sum(ta.sGST_Amt),csamt=sum(ta.COMPCESS)
				Into #TaxAllocation
				From TaxAllocation ta
				inner Join StMain m on (m.entry_ty=ta.Entry_ty and m.Tran_cd=ta.Tran_cd)
				Where  (date between @SDATE and @EDATE)
				Group By REntry_Ty,ItRef_Tran,TaxRate
				
				--Select * From #TaxAllocation

				Insert Into #TblB2B (Part,pos,sply_ty,rt,ad_amt,iamt,camt,samt,csamt,Sec)
				
				select a,POS,sply_ty,rt,SUM(ad_amt),SUM(iamt),SUM(camt),SUM(samt),SUM(csamt),Sec from (--Add by Rupesh G. on 27/08/2018 for installer
				--Select '11A',POS=st.Gst_State_Code Comment By Rupesh G on 27/08/2018 for Installer
				Select a='11A',POS=st.Gst_State_Code
				--,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTRA' Else 'INTER' End) --Commented by Prajakta B on 01062018 
				,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTER' Else 'INTRA' End) --Modified by Prajakta B on 01062018 
				,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,ad_amt=sum(isnull(i.u_asseamt,0))-sum(isnull(ta.ad_amt,0)),iamt=sum(isnull(i.iGST_Amt,0))-sum(isnull(ta.iamt,0)),camt=sum(isnull(i.cGST_Amt,0))-sum(isnull(ta.camt,0)),samt=sum(isnull(i.sGST_Amt,0))-sum(isnull(ta.samt,0)),csamt=sum(isnull(i.COMPCESS,0))-sum(isnull(ta.csamt,0))
				,Sec='AT'
				From BRMain m
				Inner join BRItem i on (m.Tran_cd=i.Tran_cd)
				Inner Join [State] st on (m.GSTState=st.[State])
				Left Join #TaxAllocation ta on (m.Entry_Ty=ta.REntry_Ty and m.Tran_Cd=ta.ItRef_Tran and (i.cGST_Per+i.sGST_Per+i.iGST_Per)=ta.rt)
				Where  (m.date between @SDATE and @EDATE)
				and m.TdsPayType=2 
				and i.LineRule = 'Taxable'--AND it.HSNCODE <> ''
				and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
				Group By st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per--,m.TdsPayType
				
				union
				
				--Select '11A',POS=st.Gst_State_Code Comment By Rupesh G on 27/08/2018 for Installer
				Select a='11A',POS=st.Gst_State_Code
				--,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTRA' Else 'INTER' End) --Commented by Prajakta B on 01062018 
				,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTER' Else 'INTRA' End) --Modified by Prajakta B on 01062018 
				,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,ad_amt=sum(isnull(i.u_asseamt,0))-sum(isnull(ta.ad_amt,0)),iamt=sum(isnull(i.iGST_Amt,0))-sum(isnull(ta.iamt,0)),camt=sum(isnull(i.cGST_Amt,0))-sum(isnull(ta.camt,0)),samt=sum(isnull(i.sGST_Amt,0))-sum(isnull(ta.samt,0)),csamt=sum(isnull(i.COMPCESS,0))-sum(isnull(ta.csamt,0))
				,Sec='AT'
				From CRMAIN m
				Inner join CRITEM i on (m.Tran_cd=i.Tran_cd)
				Inner Join [State] st on (m.GSTState=st.[State])
				Left Join #TaxAllocation ta on (m.Entry_Ty=ta.REntry_Ty and m.Tran_Cd=ta.ItRef_Tran and (i.cGST_Per+i.sGST_Per+i.iGST_Per)=ta.rt)
				Where  (m.date between @SDATE and @EDATE)
				and m.TdsPayType=2 
				and i.LineRule = 'Taxable'--AND it.HSNCODE <> ''
				and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
				Group By st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per--,m.TdsPayType
				
				)tempTbl1 Group By a,POS,sply_ty,rt,sec--Add by Rupesh G. on 27/08/2018 for installer
	End
	If @SecCode='ATA' or @SecCode='All'
	Begin
		/*Amn 11A. Advance Tax */

				Select REntry_Ty,ItRef_Tran,rt=TaxRate,ad_amt=sum(ta.[Taxable]),iamt=sum(ta.iGST_Amt),camt=sum(ta.cGST_Amt),samt=sum(ta.sGST_Amt),csamt=sum(ta.COMPCESS)
				Into #TaxAllocationa
				From TaxAllocation ta
				inner Join StMain m on (m.entry_ty=ta.Entry_ty and m.Tran_cd=ta.Tran_cd)
				Where  (date between @SDATE and @EDATE)
				Group By REntry_Ty,ItRef_Tran,TaxRate
				
				--Select * From #TaxAllocation

				Insert Into #TblB2B (Part,pos,sply_ty,rt,ad_amt,iamt,camt,samt,csamt,omon,Sec)
				Select '11A-A',POS=st.Gst_State_Code
				--,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTRA' Else 'INTER' End) --Commented by Prajakta B on 01062018 
				,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTER' Else 'INTRA' End) --Modified by Prajakta B on 01062018 
				,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,ad_amt=sum(isnull(i.u_asseamt,0))-sum(isnull(ta.ad_amt,0)),iamt=sum(isnull(i.iGST_Amt,0))-sum(isnull(ta.iamt,0)),camt=sum(isnull(i.cGST_Amt,0))-sum(isnull(ta.camt,0)),samt=sum(isnull(i.sGST_Amt,0))-sum(isnull(ta.samt,0)),csamt=sum(isnull(i.COMPCESS,0))-sum(isnull(ta.csamt,0))
				,omon=cast(month(ma.[Date]) as varchar(2))+cast(Year(ma.[Date]) as varchar(4))
				,Sec='ATA'
				From BRMain m
				Inner join BRMainAm ma on (m.Tran_cd=ma.Tran_cd)
				Inner join BRItem i on (m.Tran_cd=i.Tran_cd)
				Inner Join [State] st on (m.GSTState=st.[State])
				Left Join #TaxAllocationa ta on (m.Entry_Ty=ta.REntry_Ty and m.Tran_Cd=ta.ItRef_Tran and (i.cGST_Per+i.sGST_Per+i.iGST_Per)=ta.rt)
				Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)
				and m.TdsPayType=2 
				and i.LineRule = 'Taxable'--AND it.HSNCODE <> ''
				and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
				Group By st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.TdsPayType,cast(month(ma.[Date]) as varchar(2))+cast(Year(ma.[Date]) as varchar(4))
				--Update #TblB2B Set omon='0'+omon Where [Part]='11A-A' and Len(omon)=5
			
				union
				
				Select '11A-A',POS=st.Gst_State_Code
				--,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTRA' Else 'INTER' End) --Commented by Prajakta B on 01062018 
				,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTER' Else 'INTRA' End) --Modified by Prajakta B on 01062018 
				,rt=i.cGST_Per+i.sGST_Per+i.iGST_Per,ad_amt=sum(isnull(i.u_asseamt,0))-sum(isnull(ta.ad_amt,0)),iamt=sum(isnull(i.iGST_Amt,0))-sum(isnull(ta.iamt,0)),camt=sum(isnull(i.cGST_Amt,0))-sum(isnull(ta.camt,0)),samt=sum(isnull(i.sGST_Amt,0))-sum(isnull(ta.samt,0)),csamt=sum(isnull(i.COMPCESS,0))-sum(isnull(ta.csamt,0))
				,omon=cast(month(ma.[Date]) as varchar(2))+cast(Year(ma.[Date]) as varchar(4))
				,Sec='ATA'
				From CRMAIN m
				Inner join CRMAINAM ma on (m.Tran_cd=ma.Tran_cd)
				Inner join CRITEM i on (m.Tran_cd=i.Tran_cd)
				Inner Join [State] st on (m.GSTState=st.[State])
				Left Join #TaxAllocationa ta on (m.Entry_Ty=ta.REntry_Ty and m.Tran_Cd=ta.ItRef_Tran and (i.cGST_Per+i.sGST_Per+i.iGST_Per)=ta.rt)
				Where  (isnull(m.amenddate,'') between @SDATE and @EDATE)
				and m.TdsPayType=2 
				and i.LineRule = 'Taxable'--AND it.HSNCODE <> ''
				and (i.cGST_Amt + i.sGST_Amt  + i.iGST_Amt + i.COMPCESS) > 0
				Group By st.Gst_State_Code,i.cGST_Per+i.sGST_Per+i.iGST_Per,m.TdsPayType,cast(month(ma.[Date]) as varchar(2))+cast(Year(ma.[Date]) as varchar(4))
				
				Update #TblB2B Set omon='0'+omon Where [Part]='11A-A' and Len(omon)=5
	End

	If @SecCode='TXPD' or @SecCode='All'
	Begin
		/*11B. Advance Tax */

				Insert Into #TblB2B (Part,pos,sply_ty,rt,ad_amt,iamt,camt,samt,csamt,Sec)
				Select '11B',POS=st.Gst_State_Code
				--,sply_ty=(Case When sum(isnull(i.iGST_Amt,0))>0 Then 'INTRA' Else 'INTER' End) --Commented by Prajakta B on 01062018 
				,sply_ty=(Case When sum(isnull(ta.iGST_Amt,0))>0 Then 'INTER' Else 'INTRA' End) --Modified by Prajakta B on 01062018 
				,rt=ta.TaxRate,ad_amt=ta.Taxable,iamt=sum(ta.iGST_Amt),camt=sum(ta.cGST_Amt),samt=sum(ta.sGST_Amt),csamt=sum(ta.COMPCESS)
				,Sec='TXPD'
				From TaxAllocation ta 
				inner join StMain m on (ta.Entry_Ty=m.Entry_Ty and ta.Tran_Cd=m.Tran_Cd)
				inner join BrMain br on (ta.REntry_Ty=br.Entry_Ty and ta.Itref_Tran=br.Tran_Cd)
				Inner Join [State] st on (m.GSTState=st.[State])
				Where  (m.date between @SDATE and @EDATE)
				and    (br.date < @SDATE )
				and (ta.cGST_Amt + ta.sGST_Amt  + ta.iGST_Amt + ta.COMPCESS) > 0
				Group By st.Gst_State_Code,ta.TaxRate,ta.Taxable
	End
	If @SecCode='NIL' or @SecCode='All'
	Begin
		/*8. Nil rated, exempted and non GST outward supplies*/

				--Insert Into #TblB2B (Part,num,hsn_sc,desc,uqc,qty,val,txval,iamt,camt,samt,csamt,Sec)
				--Insert Into #TblB2B (Part,doc_num,doc_typ,num,to,from,totnum,cancel,net_issue,Sec)
				
				Insert Into #TblB2B (Part,sply_ty,expt_amt,nil_amt,ngsup_amt,Sec)
				Select '8'
				--,Sply_ty=(Case When i.st_type='INTERSTATE' Then 'INTR' Else 'INTRA' End)--Commented by Prajakta B. 01062018
				,Sply_ty=(Case When i.st_type='INTERSTATE' Then 'INTER' Else 'INTRA' End)--modified by Prajakta B. 01062018
				+(Case When i.Supp_Type in ('Registered','SEZ','EOU','Compounding','E-Commerce','Export') Then 'B2B' Else 'B2C' End)
				,expt_amt=Sum((Case When i.LineRule='Exempted' THen i.TaxableAmt Else 0 End)*(Case When l.BCode_Nm='CN' Then -1 Else 1 End))
				,nil_amt=Sum((Case When i.LineRule='Nil Rated' THen i.TaxableAmt Else 0 End)*(Case When l.BCode_Nm='CN' Then -1 Else 1 End))  
				,ngsup_amt=Sum((Case When i.LineRule='Non GST' THen i.TaxableAmt Else 0 End)*(Case When l.BCode_Nm='CN' Then -1 Else 1 End))  
				,Sec='Nil'                      
				From  [GSTR1_VW] i
				Inner Join #LCode l on (i.Entry_Ty=l.Entry_ty)
				Where  (i.date between @SDATE and @EDATE) 
				and l.BCode_Nm in ('ST','DN','CN') 
				and i.LineRule in ('Exempted','Nil Rated','Non GST') 
				Group By --(Case When i.st_type='INTERSTATE' Then 'INTR' Else 'INTRA' End)--Commented by Prajakta B. 01062018
				(Case When i.st_type='INTERSTATE' Then 'INTER' Else 'INTRA' End)--modified by Prajakta B. 01062018
				+(Case When i.Supp_Type in ('Registered','SEZ','EOU','Compounding','E-Commerce','Export') Then 'B2B' Else 'B2C' End)

	End
	If @SecCode='HSN' or @SecCode='All'
	Begin
		/*12. HSN-Wise Summary of Outward Supplies*/
				--Insert Into #TblB2B (Part,doc_num,doc_typ,num,to,from,totnum,cancel,net_issue,Sec)
				Insert Into #TblB2B (Part,num,hsn_sc,[desc],uqc,qty,val,txval,iamt,camt,samt,csamt,Sec)
				Select '12'
				,num=99,hsn_sc=i.HSNCode--,[Desc]=(Case When isNull(cast(itm.It_Desc as Varchar(4000)),'')='' Then itm.It_Name Else cast(itm.It_Desc as Varchar(4000)) End)
				,[Desc]=hm.HSN_Desc 
				,i.uqc,qty=sum((case when entry_ty in('EI','ST','GD','S1','D6') THEN +(qty) ELSE - (qty) END ))
				,Val=sum((case when entry_ty in('EI','ST','GD','S1','D6') THEN +(GRO_AMT)ELSE -(GRO_AMT) END ))
				,taxval =sum((case when entry_ty in('EI','ST','GD','S1','D6') THEN +(TAXABLEAMT)ELSE - (TAXABLEAMT) END ))
				,iamt= sum((case when entry_ty in('EI','ST','GD','S1','D6') THEN +(IGST_AMT) ELSE - (IGST_AMT) END ))
				,cAmt = sum((case when entry_ty in('EI','ST','GD','S1','D6') THEN +(CGST_AMT) ELSE - (CGST_AMT) END ))
				,sAmt = sum((case when entry_ty in('EI','ST','GD','S1','D6') THEN +(SGST_AMT) ELSE - (SGST_AMT) END ))
				,csamt = sum((case when entry_ty in('EI','ST','GD','S1','D6') THEN +(cess_amt) ELSE - (cess_amt) END ))
				,Sec='HSN'                      
				From  [GSTR1_VW] i
				inner Join It_Mast itm on (i.It_Code=itm.It_Code)
				inner join HSN_Master hm on(i.hsncode=hm.HSN_Code)
				where (i.date between @SDATE and @EDATE)  and Entry_ty in('ST','EI','SR','GC','GD','S1','C6','D6') AND i.HSNCODE <> ''
				 and isnull(i.AmendDate,'')=''
				Group by i.HSNCODE,uqc,--(Case When isNull(cast(itm.It_Desc as Varchar(4000)),'')='' Then itm.It_Name Else cast(itm.It_Desc as Varchar(4000)) End)
				hm.HSN_Desc--added for Bug 31625
				order by i.HSNCODE,--(Case When isNull(cast(itm.It_Desc as Varchar(4000)),'')='' Then itm.It_Name Else cast(itm.It_Desc as Varchar(4000)) End)
				i.uqc,hm.HSN_Desc--added for Bug 31625

	End
	If @SecCode='DOCISSUE' or @SecCode='All'
	Begin
		/*13. Document Issued*/
		
				Insert Into #TblB2B (Part,doc_num,doc_typ,num,[from],[to],totnum,cancel,net_issue,Sec)
				Select part='13',doc_num=0
				,Case 
				When l.Entry_ty='ST' Then 'Invoices for outward supply' 
				When l.Entry_ty='PT' Then 'Invoices for inward supply from unregistered person'
				When l.Entry_ty='DN' Then 'Debit Note'	
				When l.Entry_ty='CN' Then 'Credit Note'
				When l.Entry_ty='BR' Then 'Receipt voucher'
				--When l.BCode_Nm='BP' Then 'Payment Voucher'
				When l.Entry_ty='BP' Then 'Payment Voucher' --added for bug 31625
				When l.Entry_TY='LI' Then 'Delivery Challan for job work'
				When l.Entry_TY='' Then 'Delivery Challan for supply on approval'
				When l.Entry_ty='RV' Then 'Refund Voucher'  --added for bug 31625
				when (l.Entry_ty='IL' OR (l.Entry_ty='DC' and ISNULL(m.MTRNTYPE,'')='Branch Transfer') )
				then 'Delivery Challan in cases other than by way of supply (excluding at S no. 9 to 11) '
				else ''
				End
				,num=0
				,[From]=Min(M.Inv_No)
				,[to]=Max(M.Inv_No)
				,totNum=(sum((Case when acm.Ac_Name !='CANCELLED.' then 1 else 0 end)))
				,cancel=(sum((Case when acm.Ac_Name ='CANCELLED.' then 1 else 0 end)))
				,net_issue=(sum((Case when acm.Ac_Name !='CANCELLED.' then 1 else 0 end)) - sum((Case when acm.Ac_Name='CANCELLED.' then 1 else 0 end)))
				,Sec='DOCISSUE'
				From LMAIN_VW M
				Inner Join #lCode l on (M.Entry_ty=l.Entry_ty)
				inner Join Ac_Mast acm on (M.Ac_Id=acm.Ac_Id)
				Where (M.date between @SDATE and @EDATE) and l.entry_ty in('ST','PT','DN','CN','BR','BP','LI','RV','IL','DC')
				Group By l.BCode_Nm,l.Entry_TY,(Case when acm.Ac_Name !='CANCELLED.' then 1 else 0 end),m.MTRNTYPE
				--Revised Invoice,Refund voucher,Delivery Challan in case of liquid gas
 
	End

	
	if (@Summary=0)
	Begin
		Select * From #TblB2B Order By Sec,ctin,POS,idt,inum,rchrg,inv_typ,rt
	end
	Else
	Begin
		Select TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE),SrNo=cast(0 as Int),Part=Cast('' as varchar(10)),Sec=Cast('' as varchar(10)),RecCount=cast(0 as Int),Val=cast(0 as Decimal(13,2)),txval=cast(0 as Decimal(13,2)),camt=cast(0 as Decimal(13,2)),samt=cast(0 as Decimal(13,2)),iamt=cast(0 as Decimal(13,2)),csamt=cast(0 as Decimal(13,2))
		,nil_amt=cast(0 as Decimal(13,2)),expt_amt=cast(0 as Decimal(13,2)),ngsup_amt=cast(0 as Decimal(13,2))
		,totnum=cast(0 as Int),cancel=cast(0 as Int),net_issue=cast(0 as Int)
		into #TblB2B_Sum
		From #TblB2B
		Where 1=2

			Select sec,Part,cntSec=Count(Sec),(Val),ad_amt,TxVal=Sum(TxVal),CAmt=Sum(CAmt),SAmt=Sum(SAmt),IAmt=Sum(IAmt),CSAmt=Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			into #TblSum
			From #TblB2B
			Group By Sec,inum,part,val,ad_amt
			
			--select * from #TblSum
						
		If @SecCode='B2B' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 1,Sec='B2B',Part='4A4B4C6B6C',Count(cntSec),sum(Val),Sum(TxVal),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Part in ('4A','4B','4C','6B','6C')
		End	
		
		If @SecCode='B2CL' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 2,Sec='B2CL',Part='5A5B',Count(cntSec),sum(Val),Sum(TxVal),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Part in ('5A','5B')
		End
		
		If @SecCode='CDNR' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 3,Sec='CDNR',Part='9BR',Count(cntSec),sum(Val),Sum(TxVal),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec in ('CDNR')
		End
		If @SecCode='CDNUR' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 4,Sec='CDNUR',Part='9BU',Count(cntSec),sum(Val),Sum(TxVal),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec in ('CDNUR')
			Group By Sec
		End
		If @SecCode='EXP' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 5,Sec='EXP',Part='6A',Count(cntSec),sum(Val),Sum(TxVal),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Part in ('6A')
			Group By Sec
		End
		If @SecCode='B2CS' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 6,Sec='B2CS',Part='7',Count(cntSec),Val=Sum(Val)+Sum(CAmt)+Sum(SAmt)+Sum(IAmt)+Sum(CSAmt),Sum(TxVal),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Part in ('7')
			Group By Sec
		End

		If @SecCode='NIL' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,nil_amt,expt_amt,ngsup_amt)
			Select 7,Sec='NIL',Part='8',RecCount=1,sum(nil_amt),sum(expt_amt),sum(ngsup_amt)
			From #TblB2B
			Where 	Sec='Nil'		
		End
		
		If @SecCode='AT' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 8,Sec='AT',Part='11A',Count(cntSec),sum(val),Sum(ad_amt),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec='AT' 
			Group By Sec
		End
		If @SecCode='TXPD' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 9,Sec='TXPD',Part='11B',Count(cntSec),sum(val),Sum(ad_amt),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec='TXPD' 
			Group By Sec
		End
		If @SecCode='HSN' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,val,txval,iamt,camt,samt,CSAmt,TaxYear,TaxMonth)
			Select 10,Sec='HSN',Part='12',Count(cntSec),Sum(val),Sum(txval),Sum(iamt),sum(camt),sum(samt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec='HSN' 
			Group By Sec
		End
		If @SecCode='DOCISSUE' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,totnum,cancel,net_issue)
			Select 11,Sec='DOCISSUE',Part='13',Count(Sec),Sum(totnum),Sum(cancel),Sum(net_issue)
			From #TblB2B
			Where Sec='DOCISSUE' 
			Group By Sec
		End
		If @SecCode='B2BA' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,val,txval,iamt,camt,samt,CSAmt,TaxYear,TaxMonth)
			Select 12,Sec='B2BA',Part='9A',Count(cntSec),sum(Val),Sum(TxVal),Sum(iamt),sum(camt),sum(samt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec='B2BA'
			Group By Sec
		End
		--If @SecCode='B2CLA' or @SecCode='All'
		--Begin
		--	Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,val,txval,iamt,CSAmt,TaxYear,TaxMonth)
		--	Select 13,Sec='B2CLA',Part='9A',Count(Sec),sum(Val),Sum(TxVal),Sum(iamt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
		--	From #TblB2B
		--	Where Sec='B2CLA'
		--	Group By Sec
		--End
		If @SecCode='B2CLA' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,val,txval,iamt,CSAmt,TaxYear,TaxMonth)
			Select 14,Sec='B2CLA',Part='9A',Count(cntSec),sum(Val),Sum(TxVal),Sum(iamt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec='B2CLA'
			Group By Sec
		End
		If @SecCode='CDNRA' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 15,Sec='CDNRA',Part='9CR',Count(cntSec),sum(Val),Sum(TxVal),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec in ('CDNRA')
			Group By Sec
		End
		If @SecCode='CDNURA' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 16,Sec='CDNURA',Part='9CU',Count(cntSec),sum(Val),Sum(TxVal),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec in ('CDNURA')
			Group By Sec
		End
		If @SecCode='B2BA-EXP' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 17,Sec='B2BA-EXP',Part='6A',Count(cntSec),sum(Val),Sum(TxVal),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec in ('B2BA-EXP')
			Group By Sec
		End
		If @SecCode='B2CSA' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 18,Sec='B2CSA',Part='10',Count(cntSec),sum(Val),Sum(TxVal),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec in ('B2CSA')
			Group By Sec
		End
		--If @SecCode='B2CSA' or @SecCode='All'
		--Begin
		--	Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
		--	Select 19,Sec='B2CSA',Part='10',Count(Sec),sum(Val),Sum(TxVal),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
		--	From #TblB2B
		--	Where Sec in ('B2CSA')
		--	Group By Sec
		--End
		If @SecCode='ATA' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 20,Sec='ATA',Part='11A',Count(cntSec),sum(Val),Sum(ad_amt),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec='ATA' 
			Group By Sec
		End
		If @SecCode='TXPDA' or @SecCode='All'
		Begin
			Insert into #TblB2B_Sum (SrNo,Sec,Part,RecCount,Val,TxVal,CAmt,SAmt,IAmt,CSAmt,TaxYear,TaxMonth) 
			Select 21,Sec='TXPDA',Part='11B',Count(cntSec),sum(Val),Sum(ad_amt),Sum(CAmt),Sum(SAmt),Sum(IAmt),Sum(CSAmt),TaxYear=Year(@EDATE),TaxMonth=Month(@EDATE)
			From #TblSum
			Where Sec='TXPDA' 
			Group By Sec
		End

		Select * From #TblB2B_Sum Order By SrNo
	End

	

	--Execute USP_REP_GSTR1_JSON  '2018/03/01','2018/03/30','All'

End