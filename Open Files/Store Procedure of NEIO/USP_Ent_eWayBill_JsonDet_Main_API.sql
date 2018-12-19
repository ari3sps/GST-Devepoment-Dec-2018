If Exists(Select [Name] From SysObjects Where xType='P' and [Name]='USP_Ent_eWayBill_JsonDet_Main_API')
Begin
	Drop Procedure USP_Ent_eWayBill_JsonDet_Main_API
End
Go

-- =============================================
-- Author:		Ruepesh Prajapati
-- Create date: 08/01/2017
-- Description:	This Stored procedure is useful for eWayBill Json Deatails
-- Modify By/date/Reason: 
-- Remark:
-- =============================================
Create  Procedure [dbo].[USP_Ent_eWayBill_JsonDet_Main_API]
(
	@TrnName varchar(100),@Inv_No varchar(30) 
	,@InvDate SmallDatetime
	,@Compid int  --Added by Priyanka B on 06022018 for Bug-31240
	
)
As
Begin

Declare @SqlCommand nvarchar(MAX)
Select GSTIN,Co_Name,MailName=Left(Mailname,100),Add1=cast(rtrim(Add1) as varchar(50)),Add2=cast(rtrim(Add2) as varchar(50))
,Add3=cast(rtrim(Add3) as varchar(50)),CITY,Zip,cm.state,Gst_State_Code=Cast(st.Gst_State_Code as varchar)
into #Co_mast 
From vudyog..Co_mast cm
Left Join vudyog..state st on (cm.state=st.state)
where cm.CompId=@Compid  --Modified by Priyanka B on 06022018 for Bug-31240

Select 	genMode='Excel',userGstin=Cast('' as varchar(30)), supplyType1=Cast('' as varchar(30)),subsupplyType1=Cast('' as varchar(50))
,docType1=Cast('' as varchar(30)),docNo=Cast('' as varchar(30))
,docDate=convert(varchar,'',105)  --Modified by Priyanka B on 06022018 for Bug-31240
,fromGstin=Cast('' as varchar(30)),fromTrdName=Cast('' as varchar(100))
,fromAddr1=Cast('' as varchar(100)),fromAddr2=Cast('' as varchar(100)),fromPlace=Cast('' as varchar(50))
,fromPincode=Cast('' as varchar(30)),fromStateCode=Cast('' as varchar(50)),toGstin=Cast('' as varchar(30))
,toTrdName=Cast('' as varchar(100)),toAddr1=Cast('' as varchar(100)),toAddr2=Cast('' as varchar(100)),toPlace=Cast('' as varchar(50))
,toPincode=Cast('' as varchar(30)),toStateCode=Cast('' as varchar(50))
,totalValue=Cast(0 as Decimal(12,2)),cgstValue=Cast(0 as Decimal(12,2)),sgstValue=Cast(0 as Decimal(12,2))
,igstValue=Cast(0 as Decimal(12,2)),cessValue=Cast(0 as Decimal(12,2)),transMode1=Cast('' as varchar(20))
,transDistance=Cast('' as varchar(30)),transporterName=Cast('' as varchar(100)),transporterId=Cast('' as varchar(30))
,transDocNo=Cast('' as varchar(30))
,transDocDate=convert(varchar,'',105)  --Modified by Priyanka B on 06022018 for Bug-31240
,vehicleNo=Cast('' as varchar(30))
,supplyType='O',subsupplyType=Cast('' as varchar(30)),docType='INV' --Rup
,transMode=Cast('' as varchar(30))
,actFromStateCode=Cast('' as varchar(50))			--Added By Shrikant S. on 18/05/2018 for Bug-31516
,actToStateCode=Cast('' as varchar(50))				--Added By Shrikant S. on 18/05/2018 for Bug-31516
,vehicleType=Cast('' as varchar(30))				--Added By Shrikant S. on 18/05/2018 for Bug-31516
,totInvValue=Cast(0 as Decimal(18,2))				--Added By Shrikant S. on 18/05/2018 for Bug-31516
,mainHsnCode=Cast('' as varchar(30))				--Added By Shrikant S. on 18/05/2018 for Bug-31516
into #eWayBillJson where 1=2

If (@TrnName='Sales')
Begin
	Set @SqlCommand='Insert Into #eWayBillJson'
	Set @SqlCommand=@SqlCommand+' Select genMode=''Excel'',userGstin=cm.GSTIN, supplyType1=''Outward'',subsupplyType1=sm.EWBSUPTYP'
	Set @SqlCommand=@SqlCommand+' ,docType1=''Tax Invoice'',docNo=m.Inv_No,docDate=(case when year(m.date)<=1900 then '''' else convert(varchar,m.date,105) end)'
	Set @SqlCommand=@SqlCommand+' ,fromGstin=cm.GSTIN,fromTrdName=cm.MailName'
	Set @SqlCommand=@SqlCommand+' ,fromAddr1=Case When isnull(sm.SHIPTO,'''')<>'''' then lm.Add1 else cm.Add1 End '
	Set @SqlCommand=@SqlCommand+' ,fromAddr2=Case When isnull(sm.SHIPTO,'''')<>'''' then lm.Add2+'' ''+lm.Add3 else cm.Add2+'' ''+Cm.Add3 end'
	Set @SqlCommand=@SqlCommand+' ,fromPlace=Case When isnull(sm.SHIPTO,'''')<>'''' then lm.City else cm.City end'
	Set @SqlCommand=@SqlCommand+' ,fromPincode=Case When isnull(sm.SHIPTO,'''')<>'''' then lm.pincode else cm.ZIP end'
	Set @SqlCommand=@SqlCommand+' ,fromStateCode=Cm.Gst_State_code'
	Set @SqlCommand=@SqlCommand+' ,toGstin=case when buyer_sp.st_type=''OUT OF COUNTRY'' OR buyer_sp.supp_type=''UNREGISTERED'' then ''URP'' ELSE buyer_sp.gstin END '  
	Set @SqlCommand=@SqlCommand+' ,toTrdName=case when buyer_sp.mailname<>'''' then buyer_sp.mailname else buyer_sp.ac_name end'
	Set @SqlCommand=@SqlCommand+' ,toAddr1=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'''') else isnull(Cons_ac.add1,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,toAddr2=(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''''))+'' ''+rtrim(isnull(Cons_sp.add3,'''')) else rtrim(isnull(Cons_ac.add2,''''))+'' ''+rtrim(isnull(Cons_ac.add3,'''')) end)'
	Set @SqlCommand=@SqlCommand+' ,toPlace=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'''') else isnull(Cons_ac.city,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,toPincode=case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''999999'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.zip,'''') else isnull(Cons_ac.zip,'''') end) END'
	Set @SqlCommand=@SqlCommand+' ,toStateCode=case when buyer_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE buyer_sp.statecode END'  
	Set @SqlCommand=@SqlCommand+' ,totalValue=sum(i.u_AsseAmt),cgstValue=sum(i.cGST_Amt),sgstValue=sum(i.sGST_Amt),igstValue=sum(i.iGST_Amt),cessValue=sum(i.CompCess),transMode1=m.u_tMode,transDistance=sm.EWBDIST,transporterName=m.u_Deli,transporterId=m.Trans_Id,transDocNo=m.U_LrNo,transDocDate=(case when year(m.u_lrdt)<=1900 then '''' else convert(varchar,m.u_lrdt,105) end),vehicleNo=m.U_VehNo'  --Modified by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',supplyType=''O'',subsupplyType=1,docType=''INV'',transMode=1' --Rup
	Set @SqlCommand=@SqlCommand+' ,actualFromStateCode=Case When isnull(sm.SHIPTO,'''')<>'''' then s.Gst_State_code else Cm.Gst_State_code End'														
	Set @SqlCommand=@SqlCommand+' ,actualToStateCode=case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'''') else isnull(Cons_ac_st.Gst_State_code,'''') end) END'
	Set @SqlCommand=@SqlCommand+',vehicleType=sm.cargo_typ,totInvValue=sum(i.u_AsseAmt)+sum(i.cGST_Amt)+sum(i.sGST_Amt)+sum(i.iGST_Amt)+sum(i.CompCess) '									--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',mainHsnCode=(Select Top 1 ISNULL(Hsncode,'''') From stitem a inner join it_mast b on (a.it_code=b.it_code) where a.ismainhsn=1 and a.Tran_cd=m.tran_cd) '	--Added By Shrikant S. on 18/05/2018 for Bug-31516	
	Set @SqlCommand=@SqlCommand+' From #Co_mast cm,StMain m'
	Set @SqlCommand=@SqlCommand+' Left Join StMainAdd sm on (m.Tran_cd=sm.Tran_Cd)'
	Set @SqlCommand=@SqlCommand+' Inner Join StItem i on (m.Tran_Cd=i.Tran_Cd)'
	Set @SqlCommand=@SqlCommand+' Inner join it_mast itm on (itm.it_code=i.it_code and itm.isservice<>1)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto Cons_sp ON (Cons_sp.ac_id = m.Cons_id and Cons_sp.shipto_id = m.scons_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast Cons_ac ON (m.cons_id = Cons_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto buyer_sp ON (buyer_sp.ac_id = m.Ac_id and buyer_sp.shipto_id = m.sAc_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast buyer_ac ON (m.Ac_id = buyer_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_ac_st on (Cons_ac_st.State=Cons_ac.State)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_sp_st on (Cons_sp_st.State=Cons_sp.State)'
	Set @SqlCommand=@SqlCommand+' Left outer Join LOC_MASTER lm on (lm.Loc_Code = sm.SHIPTO)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Left outer Join [state] s on (lm.state = s.state)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Where m.Inv_No='+Char(39)+@Inv_No+Char(39) 
	Set @SqlCommand=@SqlCommand+' and m.Date ='''+Convert(varchar(50),@InvDate)+''''
	Set @SqlCommand=@SqlCommand+' Group By cm.GSTIN,sm.EWBSUPTYP,m.Inv_No,m.Date,cm.GSTIN,cm.MailName,cm.Add1,cm.Add2,Cm.Add3,cm.City,cm.ZIP,Cm.Gst_State_Code,Cons_sp.gstin,Cons_ac.gstin,Cons_sp.mailname,Cons_ac.ac_name,Cons_sp.add1,Cons_ac.add1,Cons_sp.add2,Cons_ac.add2,Cons_sp.city,Cons_ac.city,Cons_sp.zip,Cons_ac.zip,Cons_sp_st.Gst_State_code,Cons_ac_st.Gst_State_code'  --Modified by Priyanka B on 08022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.u_tMode,sm.EWBDIST,m.u_Deli,m.Trans_Id,m.U_LrNo,m.U_LrDt,m.U_VehNo'
	Set @SqlCommand=@SqlCommand+',m.scons_id'  --Added by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',sm.SHIPTO,sm.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode,Cons_sp.Statecode'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,lm.add1,lm.add2,lm.add3,lm.City,lm.pincode,buyer_sp.gstin,cm.MailName,buyer_sp.mailname,buyer_sp.ac_name,Cons_sp.add3,Cons_ac.add3,buyer_sp.statecode,buyer_sp.st_type,buyer_sp.supp_type,Cons_sp.st_type,Cons_sp.supp_type'
	Print @SqlCommand
	Execute sp_Executesql @SqlCommand
End
If (@TrnName='Delivery Challan')
Begin
	Set @SqlCommand='Insert Into #eWayBillJson'
	Set @SqlCommand=@SqlCommand+' Select genMode=''Excel'',userGstin=cm.GSTIN, supplyType1=''Outward'',subsupplyType1=m.EWBSUPTYP,docType1=''Challan'''
	Set @SqlCommand=@SqlCommand+' ,docNo=m.Inv_No,docDate=(case when year(m.date)<=1900 then '''' else convert(varchar,m.date,105) end)'
	Set @SqlCommand=@SqlCommand+' ,fromGstin=cm.GSTIN,fromTrdName=cm.MailName'
	Set @SqlCommand=@SqlCommand+' ,fromAddr1=Case When isnull(m.SHIPTO,'''')<>'''' then lm.Add1 else cm.Add1 End '
	Set @SqlCommand=@SqlCommand+' ,fromAddr2=Case When isnull(m.SHIPTO,'''')<>'''' then lm.Add2+'' ''+lm.Add3 else cm.Add2+'' ''+Cm.Add3 end'
	Set @SqlCommand=@SqlCommand+' ,fromPlace=Case When isnull(m.SHIPTO,'''')<>'''' then lm.City else cm.City end'
	Set @SqlCommand=@SqlCommand+' ,fromPincode=Case When isnull(m.SHIPTO,'''')<>'''' then lm.pincode else cm.ZIP end'
	Set @SqlCommand=@SqlCommand+' ,fromStateCode=Cm.Gst_State_code'
	Set @SqlCommand=@SqlCommand+' ,toGstin=case when buyer_sp.st_type=''OUT OF COUNTRY'' OR buyer_sp.supp_type=''UNREGISTERED'' then ''URP'' ELSE buyer_sp.gstin END '  
	Set @SqlCommand=@SqlCommand+' ,toTrdName=case when buyer_sp.mailname<>'''' then buyer_sp.mailname else buyer_sp.ac_name end'
	Set @SqlCommand=@SqlCommand+' ,toAddr1=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'''') else isnull(Cons_ac.add1,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,toAddr2=(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''''))+'' ''+rtrim(isnull(Cons_sp.add3,'''')) else rtrim(isnull(Cons_ac.add2,''''))+'' ''+rtrim(isnull(Cons_ac.add3,'''')) end)'
	Set @SqlCommand=@SqlCommand+' ,toPlace=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'''') else isnull(Cons_ac.city,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,toPincode=case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''999999'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.zip,'''') else isnull(Cons_ac.zip,'''') end) END'
	Set @SqlCommand=@SqlCommand+' ,toStateCode=case when buyer_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE buyer_sp.statecode END'  
	Set @SqlCommand=@SqlCommand+' ,totalValue=sum(i.u_AsseAmt),cgstValue=sum(i.cGST_Amt),sgstValue=sum(i.sGST_Amt),igstValue=sum(i.iGST_Amt),cessValue=sum(i.CompCess),transMode1=m.u_tMode,transDistance=m.EWBDIST,transporterName=m.u_Deli,transporterId=m.Trans_Id,transDocNo=m.U_LrNo,transDocDate=(case when year(m.u_lrdt)<=1900 then '''' else convert(varchar,m.u_lrdt,105) end),vehicleNo=m.U_VehNo'  --Modified by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',supplyType=''O'',subsupplyType=1,docType=''CHL'',transMode=1' --Rup
	Set @SqlCommand=@SqlCommand+' ,actualFromStateCode=Case When isnull(m.SHIPTO,'''')<>'''' then s.Gst_State_code else Cm.Gst_State_code End'														--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,actualToStateCode=case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'''') else isnull(Cons_ac_st.Gst_State_code,'''') end) END'		
	Set @SqlCommand=@SqlCommand+',vehicleType=m.cargo_typ,totInvValue=sum(i.u_AsseAmt)+sum(i.cGST_Amt)+sum(i.sGST_Amt)+sum(i.iGST_Amt)+sum(i.CompCess) '									--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',mainHsnCode=(Select Top 1 ISNULL(Hsncode,'''') From dcitem a inner join it_mast b on (a.it_code=b.it_code) where a.ismainhsn=1 and a.Tran_cd=m.tran_cd) '	--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' From #Co_mast cm,DCMain m'
	Set @SqlCommand=@SqlCommand+' Inner Join DCItem i on (m.Tran_Cd=i.Tran_Cd)'
	Set @SqlCommand=@SqlCommand+' Inner join it_mast itm on (itm.it_code=i.it_code and itm.isservice<>1)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto Cons_sp ON (Cons_sp.ac_id = m.Cons_id and Cons_sp.shipto_id = m.scons_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast Cons_ac ON (m.cons_id = Cons_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto buyer_sp ON (buyer_sp.ac_id = m.Ac_id and buyer_sp.shipto_id = m.sAc_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast buyer_ac ON (m.Ac_id = buyer_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_ac_st on (Cons_ac_st.State=Cons_ac.State)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_sp_st on (Cons_sp_st.State=Cons_sp.State)'
	Set @SqlCommand=@SqlCommand+' Left outer Join LOC_MASTER lm on (lm.Loc_Code = m.SHIPTO)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Left outer Join [state] s on (lm.state = s.state)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Where m.Inv_No='+Char(39)+@Inv_No+Char(39) 
	Set @SqlCommand=@SqlCommand+' and m.Date ='''+Convert(varchar(50),@InvDate)+''''
	Set @SqlCommand=@SqlCommand+' Group By cm.GSTIN,m.EWBSUPTYP,m.Inv_No,m.Date,cm.GSTIN,cm.MailName,cm.Add1,cm.Add2,Cm.Add3,cm.City,cm.ZIP,Cm.Gst_State_Code,Cons_sp.gstin,Cons_ac.gstin,Cons_sp.mailname,Cons_ac.ac_name,Cons_sp.add1,Cons_ac.add1,Cons_sp.add2,Cons_ac.add2,Cons_sp.city,Cons_ac.city,Cons_sp.zip,Cons_ac.zip,Cons_sp_st.Gst_State_code,Cons_ac_st.Gst_State_code'  --Modified by Priyanka B on 08022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.u_tMode,m.EWBDIST,m.u_Deli,m.Trans_Id,m.U_LrNo,m.U_LrDt,m.U_VehNo'
	Set @SqlCommand=@SqlCommand+',m.scons_id'  --Added by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode,Cons_sp.Statecode'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,lm.add1,lm.add2,lm.add3,lm.City,lm.pincode,buyer_sp.gstin,cm.MailName,buyer_sp.mailname,buyer_sp.ac_name,Cons_sp.add3,Cons_ac.add3,buyer_sp.statecode,buyer_sp.st_type,buyer_sp.supp_type,Cons_sp.st_type,Cons_sp.supp_type'
	Print @SqlCommand
	Execute sp_Executesql @SqlCommand
End

If (@TrnName='Purchase')
Begin
	Set @SqlCommand='Insert Into #eWayBillJson'
	Set @SqlCommand=@SqlCommand+' Select genMode=''Excel'',userGstin=cm.GSTIN, supplyType1=''Inward'',subsupplyType1=m.EWBSUPTYP'
	Set @SqlCommand=@SqlCommand+' ,docType1=(Case when m.Entry_ty=''P1'' Then ''Bill of Entry'' Else ''Bill of Supply'' end),docNo=m.Inv_No'
	Set @SqlCommand=@SqlCommand+' ,docDate=(case when year(m.date)<=1900 then '''' else convert(varchar,m.date,105) end)'
	Set @SqlCommand=@SqlCommand+' ,fromGstin=case when buyer_sp.st_type=''OUT OF COUNTRY'' OR buyer_sp.supp_type=''UNREGISTERED'' then ''URP'' ELSE buyer_sp.gstin END '
	Set @SqlCommand=@SqlCommand+' ,fromTrdName=case when buyer_sp.mailname<>'''' then buyer_sp.mailname else buyer_sp.ac_name end'
	Set @SqlCommand=@SqlCommand+' ,fromAddr1=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'''') else isnull(Cons_ac.add1,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,fromAddr2=(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''''))+'' ''+rtrim(isnull(Cons_sp.add3,'''')) else rtrim(isnull(Cons_ac.add2,''''))+'' ''+rtrim(isnull(Cons_ac.add3,'''')) end)'
	Set @SqlCommand=@SqlCommand+' ,fromPlace=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'''') else isnull(Cons_ac.city,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,fromPincode=(case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''999999'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.zip,'''') else isnull(Cons_ac.zip,'''') end)  END)'
	Set @SqlCommand=@SqlCommand+' ,fromStateCode=(case when buyer_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.sac_id, 0) > 0 then isnull(buyer_sp.Statecode,'') else isnull(Cons_sp.Statecode,'') end) END)'
	Set @SqlCommand=@SqlCommand+' ,toGstin=cm.GSTIN'  
	Set @SqlCommand=@SqlCommand+' ,toTrdName=cm.MailName'
	Set @SqlCommand=@SqlCommand+' ,toAddr1=Case When isnull(m.SHIPTO,'''')<>'''' then lm.Add1 else cm.Add1 end'
	Set @SqlCommand=@SqlCommand+' ,toAddr2=Case When isnull(m.SHIPTO,'''')<>'''' then rtrim(lm.Add2)+'' ''+rtrim(lm.Add3) else rtrim(cm.Add2)+'' ''+rtrim(cm.Add3) END'
	Set @SqlCommand=@SqlCommand+' ,toPlace=Case When isnull(m.SHIPTO,'''')<>'''' then lm.city else cm.City end'
	Set @SqlCommand=@SqlCommand+' ,toPincode=Case When isnull(m.SHIPTO,'''')<>'''' then lm.pincode else cm.ZIP end'
	Set @SqlCommand=@SqlCommand+' ,toStateCode=cm.Gst_State_Code'  
	Set @SqlCommand=@SqlCommand+' ,totalValue=sum(i.u_AsseAmt),cgstValue=sum(i.cGST_Amt),sgstValue=sum(i.sGST_Amt),igstValue=sum(i.iGST_Amt),cessValue=sum(i.CompCess),transMode1=m.u_tMode,transDistance=m.EWBDIST,transporterName=m.u_Deli,transporterId=m.Trans_Id,transDocNo=m.U_LrNo,transDocDate=(case when year(m.u_lrdt)<=1900 then '''' else convert(varchar,m.u_lrdt,105) end),vehicleNo=m.U_VehNo'  --Modified by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',supplyType=''I'',subsupplyType=1,docType=(Case when m.Entry_ty=''P1'' Then ''BOE'' Else ''BIL'' end),transMode=1' --Rup
	Set @SqlCommand=@SqlCommand+' ,actualFromStateCode=(case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'''') else isnull(Cons_ac_st.Gst_State_code,'''') end) END)'		--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,actualToStateCode=(Case When isnull(m.SHIPTO,'''')<>'''' then s.Gst_State_code else Cm.Gst_State_code End) '														--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',vehicleType=m.cargo_typ,totInvValue=sum(i.u_AsseAmt)+sum(i.cGST_Amt)+sum(i.sGST_Amt)+sum(i.iGST_Amt)+sum(i.CompCess) '									--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',mainHsnCode=(Select Top 1 ISNULL(Hsncode,'''') From PTitem a inner join it_mast b on (a.it_code=b.it_code) where a.ismainhsn=1 and a.Tran_cd=m.tran_cd) '	--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' From #Co_mast cm,PtMain m'
	Set @SqlCommand=@SqlCommand+' Inner Join PtItem i on (m.Tran_Cd=i.Tran_Cd)'
	Set @SqlCommand=@SqlCommand+' Inner join it_mast itm on (itm.it_code=i.it_code and itm.isservice<>1)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto Cons_sp ON (Cons_sp.ac_id = m.Cons_id and Cons_sp.shipto_id = m.scons_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast Cons_ac ON (m.cons_id = Cons_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto buyer_sp ON (buyer_sp.ac_id = m.Ac_id and buyer_sp.shipto_id = m.sAc_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast buyer_ac ON (m.Ac_id = buyer_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_ac_st on (Cons_ac_st.State=Cons_ac.State)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_sp_st on (Cons_sp_st.State=Cons_sp.State)'
	Set @SqlCommand=@SqlCommand+' Left outer Join LOC_MASTER lm on (lm.Loc_Code = m.SHIPTO)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516	
	Set @SqlCommand=@SqlCommand+' Left outer Join [state] s on (lm.state = s.state)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Where m.Inv_No='+Char(39)+@Inv_No+Char(39) 
	Set @SqlCommand=@SqlCommand+' and m.Date ='''+Convert(varchar(50),@InvDate)+''''
	Set @SqlCommand=@SqlCommand+' Group By cm.GSTIN,m.EWBSUPTYP,m.Inv_No,m.Date,cm.GSTIN,cm.MailName,cm.Add1,cm.Add2,Cm.Add3,cm.City,cm.ZIP,Cm.Gst_State_Code,Cons_sp.gstin,Cons_ac.gstin,Cons_sp.mailname,Cons_ac.ac_name,Cons_sp.add1,Cons_ac.add1,Cons_sp.add2,Cons_ac.add2,Cons_sp.add3,Cons_ac.add3,Cons_sp.city,Cons_ac.city,Cons_sp.zip,Cons_ac.zip,Cons_sp_st.Gst_State_code,Cons_ac_st.Gst_State_code'  --Modified by Priyanka B on 09022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.u_tMode,m.EWBDIST,m.u_Deli,m.Trans_Id,m.U_LrNo,m.U_LrDt,m.U_VehNo'
	Set @SqlCommand=@SqlCommand+',m.scons_id,m.entry_ty'  --Added by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,lm.add1,lm.add2,lm.add3,lm.City,lm.pincode,m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode,buyer_sp.st_type,buyer_sp.supp_type,buyer_sp.gstin,buyer_sp.mailname,buyer_sp.ac_name,Cons_sp.st_type'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Print @SqlCommand
	Execute sp_Executesql @SqlCommand
End

/*		Added by Shrikant S. on 23/04/2018 for Bug-31481	Start	*/
If (@TrnName='Goods Receipt')
Begin
	Set @SqlCommand='Insert Into #eWayBillJson'
	Set @SqlCommand=@SqlCommand+' Select genMode=''Excel'',userGstin=cm.GSTIN, supplyType1=''Inward'',subsupplyType1=m.EWBSUPTYP,docType1=''Bill of Supply'''
	Set @SqlCommand=@SqlCommand+' ,docNo=m.Inv_No,docDate=(case when year(m.date)<=1900 then '''' else convert(varchar,m.date,105) end)'
	Set @SqlCommand=@SqlCommand+' ,fromGstin=case when buyer_sp.st_type=''OUT OF COUNTRY'' OR buyer_sp.supp_type=''UNREGISTERED'' then ''URP'' ELSE buyer_sp.gstin END '
	Set @SqlCommand=@SqlCommand+' ,fromTrdName=case when buyer_sp.mailname<>'''' then buyer_sp.mailname else buyer_sp.ac_name end'
	Set @SqlCommand=@SqlCommand+' ,fromAddr1=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'''') else isnull(Cons_ac.add1,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,fromAddr2=(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''''))+'' ''+rtrim(isnull(Cons_sp.add3,'''')) else rtrim(isnull(Cons_ac.add2,''''))+'' ''+rtrim(isnull(Cons_ac.add3,'''')) end)'
	Set @SqlCommand=@SqlCommand+' ,fromPlace=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'''') else isnull(Cons_ac.city,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,fromPincode=(case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''999999'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.zip,'''') else isnull(Cons_ac.zip,'''') end)  END)'
	Set @SqlCommand=@SqlCommand+' ,fromStateCode=(case when buyer_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.sac_id, 0) > 0 then isnull(buyer_sp.Statecode,'') else isnull(Cons_sp.Statecode,'') end) END)'
	Set @SqlCommand=@SqlCommand+' ,toGstin=cm.GSTIN'  
	Set @SqlCommand=@SqlCommand+' ,toTrdName=cm.MailName'
	Set @SqlCommand=@SqlCommand+' ,toAddr1=Case When isnull(m.SHIPTO,'''')<>'''' then lm.Add1 else cm.Add1 end'
	Set @SqlCommand=@SqlCommand+' ,toAddr2=Case When isnull(m.SHIPTO,'''')<>'''' then rtrim(lm.Add2)+'' ''+rtrim(lm.Add3) else rtrim(cm.Add2)+'' ''+rtrim(cm.Add3) END'
	Set @SqlCommand=@SqlCommand+' ,toPlace=Case When isnull(m.SHIPTO,'''')<>'''' then lm.city else cm.City end'
	Set @SqlCommand=@SqlCommand+' ,toPincode=Case When isnull(m.SHIPTO,'''')<>'''' then lm.pincode else cm.ZIP end'
	Set @SqlCommand=@SqlCommand+' ,toStateCode=cm.Gst_State_Code'  
	Set @SqlCommand=@SqlCommand+' ,totalValue=sum(i.u_AsseAmt),cgstValue=sum(i.cGST_Amt),sgstValue=sum(i.sGST_Amt),igstValue=sum(i.iGST_Amt),cessValue=sum(i.CompCess),transMode1=m.u_tMode,transDistance=m.EWBDIST,transporterName=m.u_Deli,transporterId=m.Trans_Id,transDocNo=m.U_LrNo,transDocDate=(case when year(m.u_lrdt)<=1900 then '''' else convert(varchar,m.u_lrdt,105) end),vehicleNo=m.U_VehNo' 
	Set @SqlCommand=@SqlCommand+',supplyType=''I'',subsupplyType=1,docType=''BIL'',transMode=1' --Rup
	Set @SqlCommand=@SqlCommand+' ,actualFromStateCode=(case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'''') else isnull(Cons_ac_st.Gst_State_code,'''') end) END)'		--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',actualToStateCode=	Case When isnull(m.SHIPTO,'''')<>'''' then s.Gst_State_code else Cm.Gst_State_code End'														--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',vehicleType=m.cargo_typ,totInvValue=sum(i.u_AsseAmt)+sum(i.cGST_Amt)+sum(i.sGST_Amt)+sum(i.iGST_Amt)+sum(i.CompCess) '									--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',mainHsnCode=(Select Top 1 ISNULL(Hsncode,'''') From aritem a inner join it_mast b on (a.it_code=b.it_code) where a.ismainhsn=1 and a.Tran_cd=m.tran_cd) '	--Added By Shrikant S. on 18/05/2018 for Bug-31516	
	Set @SqlCommand=@SqlCommand+' From #Co_mast cm,ArMain m'
	Set @SqlCommand=@SqlCommand+' Inner Join ArItem i on (m.Tran_Cd=i.Tran_Cd)'
	Set @SqlCommand=@SqlCommand+' Inner join it_mast itm on (itm.it_code=i.it_code and itm.isservice<>1)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto Cons_sp ON (Cons_sp.ac_id = m.Cons_id and Cons_sp.shipto_id = m.scons_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast Cons_ac ON (m.cons_id = Cons_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto buyer_sp ON (buyer_sp.ac_id = m.Ac_id and buyer_sp.shipto_id = m.sAc_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast buyer_ac ON (m.Ac_id = buyer_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_ac_st on (Cons_ac_st.State=Cons_ac.State)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_sp_st on (Cons_sp_st.State=Cons_sp.State)'
	Set @SqlCommand=@SqlCommand+' Left outer Join LOC_MASTER lm on (lm.Loc_Code = m.SHIPTO)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Left outer Join [state] s on (lm.state = s.state)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Where m.Inv_No='+Char(39)+@Inv_No+Char(39) 
	Set @SqlCommand=@SqlCommand+' and m.Date ='''+Convert(varchar(50),@InvDate)+''''
	Set @SqlCommand=@SqlCommand+' Group By cm.GSTIN,m.EWBSUPTYP,m.Inv_No,m.Date,cm.GSTIN,cm.MailName,cm.Add1,cm.Add2,Cm.Add3,cm.City,cm.ZIP,Cm.Gst_State_Code,Cons_sp.gstin,Cons_ac.gstin,Cons_sp.mailname,Cons_ac.ac_name,Cons_sp.add1,Cons_ac.add1,Cons_sp.add2,Cons_ac.add2,Cons_sp.add3,Cons_ac.add3,Cons_sp.city,Cons_ac.city,Cons_sp.zip,Cons_ac.zip,Cons_sp_st.Gst_State_code,Cons_ac_st.Gst_State_code'
	Set @SqlCommand=@SqlCommand+',m.u_tMode,m.EWBDIST,m.u_Deli,m.Trans_Id,m.U_LrNo,m.U_LrDt,m.U_VehNo'
	Set @SqlCommand=@SqlCommand+',m.scons_id,m.entry_ty' 
	Set @SqlCommand=@SqlCommand+',m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode'			--Added By Shrikant S. on 18/05/2018 for Bug-31516 
	Set @SqlCommand=@SqlCommand+' ,lm.add1,lm.add2,lm.add3,lm.City,lm.pincode,m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode,buyer_sp.st_type,buyer_sp.supp_type,buyer_sp.gstin,buyer_sp.mailname,buyer_sp.ac_name,Cons_sp.st_type'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Print @SqlCommand
	Execute sp_Executesql @SqlCommand
End
/*		Added by Shrikant S. on 23/04/2018 for Bug-31481	End	*/
If (@TrnName='LABOUR JOB ISSUE[V]' or @TrnName='LABOUR JOB ISSUE[IV]') /*Both 4 & 5 LI/IL*/
Begin
	Set @SqlCommand='Insert Into #eWayBillJson'
	Set @SqlCommand=@SqlCommand+' Select genMode=''Excel'',userGstin=cm.GSTIN, supplyType1=''Outward'',subsupplyType1=m.EWBSUPTYP,docType1=''Challan'''
	Set @SqlCommand=@SqlCommand+' ,docNo=m.Inv_No,docDate=(case when year(m.date)<=1900 then '''' else convert(varchar,m.date,105) end)'
	Set @SqlCommand=@SqlCommand+' ,fromGstin=cm.GSTIN,fromTrdName=cm.MailName'
	Set @SqlCommand=@SqlCommand+' ,fromAddr1=Case When isnull(m.SHIPTO,'''')<>'''' then lm.Add1 else cm.Add1 End '
	Set @SqlCommand=@SqlCommand+' ,fromAddr2=Case When isnull(m.SHIPTO,'''')<>'''' then lm.Add2+'' ''+lm.Add3 else cm.Add2+'' ''+Cm.Add3 end'
	Set @SqlCommand=@SqlCommand+' ,fromPlace=Case When isnull(m.SHIPTO,'''')<>'''' then lm.City else cm.City end'
	Set @SqlCommand=@SqlCommand+' ,fromPincode=Case When isnull(m.SHIPTO,'''')<>'''' then lm.pincode else cm.ZIP end'
	Set @SqlCommand=@SqlCommand+' ,fromStateCode=Cm.Gst_State_code'
	Set @SqlCommand=@SqlCommand+' ,toGstin=case when buyer_sp.st_type=''OUT OF COUNTRY'' OR buyer_sp.supp_type=''UNREGISTERED'' then ''URP'' ELSE buyer_sp.gstin END '  
	Set @SqlCommand=@SqlCommand+' ,toTrdName=case when buyer_sp.mailname<>'''' then buyer_sp.mailname else buyer_sp.ac_name end'
	Set @SqlCommand=@SqlCommand+' ,toAddr1=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'''') else isnull(Cons_ac.add1,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,toAddr2=(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''''))+'' ''+rtrim(isnull(Cons_sp.add3,'''')) else rtrim(isnull(Cons_ac.add2,''''))+'' ''+rtrim(isnull(Cons_ac.add3,'''')) end)'
	Set @SqlCommand=@SqlCommand+' ,toPlace=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'''') else isnull(Cons_ac.city,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,toPincode=case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''999999'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.zip,'''') else isnull(Cons_ac.zip,'''') end) END'
	Set @SqlCommand=@SqlCommand+' ,toStateCode=case when buyer_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE buyer_sp.statecode END'  
	Set @SqlCommand=@SqlCommand+' ,totalValue=sum(i.u_AsseAmt),cgstValue=sum(i.cGST_Amt),sgstValue=sum(i.sGST_Amt),igstValue=sum(i.iGST_Amt),cessValue=sum(i.CompCess),transMode1=m.u_tMode,transDistance=m.EWBDIST,transporterName=m.u_Deli,transporterId=m.Trans_Id,transDocNo=m.U_LrNo,transDocDate=(case when year(m.u_lrdt)<=1900 then '''' else convert(varchar,m.u_lrdt,105) end),vehicleNo=m.U_VehNo'  --Modified by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',supplyType=''O'',subsupplyType=1,docType=''CHL'',transMode=1' --Rup
	Set @SqlCommand=@SqlCommand+',actualFromStateCode=Case When isnull(m.SHIPTO,'''')<>'''' then s.Gst_State_code else Cm.Gst_State_code End'														--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,actualToStateCode=case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'''') else isnull(Cons_ac_st.Gst_State_code,'''') end) END'		
	Set @SqlCommand=@SqlCommand+',vehicleType=m.cargo_typ,totInvValue=sum(i.u_AsseAmt)+sum(i.cGST_Amt)+sum(i.sGST_Amt)+sum(i.iGST_Amt)+sum(i.CompCess) '									--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',mainHsnCode=(Select Top 1 ISNULL(Hsncode,'''') From iiitem a inner join it_mast b on (a.it_code=b.it_code) where a.ismainhsn=1 and a.Tran_cd=m.tran_cd) '	--Added By Shrikant S. on 18/05/2018 for Bug-31516	
	Set @SqlCommand=@SqlCommand+' From #Co_mast cm,IIMain m'
	Set @SqlCommand=@SqlCommand+' Inner Join IIItem i on (m.Tran_Cd=i.Tran_Cd)'
	Set @SqlCommand=@SqlCommand+' Inner join it_mast itm on (itm.it_code=i.it_code and itm.isservice<>1)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto Cons_sp ON (Cons_sp.ac_id = m.Cons_id and Cons_sp.shipto_id = m.scons_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast Cons_ac ON (m.cons_id = Cons_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto buyer_sp ON (buyer_sp.ac_id = m.Ac_id and buyer_sp.shipto_id = m.sAc_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast buyer_ac ON (m.Ac_id = buyer_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_ac_st on (Cons_ac_st.State=Cons_ac.State)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_sp_st on (Cons_sp_st.State=Cons_sp.State)'
	Set @SqlCommand=@SqlCommand+' Left outer Join LOC_MASTER lm on (lm.Loc_Code = m.SHIPTO)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Left outer Join [state] s on (lm.state = s.state)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Where m.Inv_No='+Char(39)+@Inv_No+Char(39) 
	Set @SqlCommand=@SqlCommand+' and m.Date ='''+Convert(varchar(50),@InvDate)+''''
	If (@TrnName='LABOUR JOB ISSUE[V]') Begin Set @SqlCommand=@SqlCommand+' and m.Entry_ty=''IL''' End 
										Else Begin Set @SqlCommand=@SqlCommand+' and m.Entry_ty=''LI''' End
	Set @SqlCommand=@SqlCommand+' Group By cm.GSTIN,m.EWBSUPTYP,m.Inv_No,m.Date,cm.GSTIN,cm.MailName,cm.Add1,cm.Add2,Cm.Add3,cm.City,cm.ZIP,Cm.Gst_State_Code,Cons_sp.gstin,Cons_ac.gstin,Cons_sp.mailname,Cons_ac.ac_name,Cons_sp.add1,Cons_ac.add1,Cons_sp.add2,Cons_ac.add2,Cons_sp.city,Cons_ac.city,Cons_sp.zip,Cons_ac.zip,Cons_sp_st.Gst_State_code,Cons_ac_st.Gst_State_code'  --Modified by Priyanka B on 09022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.u_tMode,m.EWBDIST,m.u_Deli,m.Trans_Id,m.U_LrNo,m.U_LrDt,m.U_VehNo'
	Set @SqlCommand=@SqlCommand+',m.scons_id'  --Added by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode,Cons_sp.Statecode'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,lm.add1,lm.add2,lm.add3,lm.City,lm.pincode,buyer_sp.gstin,cm.MailName,buyer_sp.mailname,buyer_sp.ac_name,Cons_sp.add3,Cons_ac.add3,buyer_sp.statecode,buyer_sp.st_type,buyer_sp.supp_type,Cons_sp.st_type'
	Print @SqlCommand
	Execute sp_Executesql @SqlCommand
End
If (@TrnName='LABOUR JOB RECEIPT[IV]' or @TrnName='LABOUR JOB RECEIPT[V]') /*Both 4 & 5 LR/RL*/
	Begin
	Set @SqlCommand='Insert Into #eWayBillJson'
	Set @SqlCommand=@SqlCommand+' Select genMode=''Excel'',userGstin=cm.GSTIN, supplyType1=''Inward'',subsupplyType1=m.EWBSUPTYP,docType1=''Challan'''
	Set @SqlCommand=@SqlCommand+' ,docNo=m.Inv_No,docDate=(case when year(m.date)<=1900 then '''' else convert(varchar,m.date,105) end)'
	Set @SqlCommand=@SqlCommand+' ,fromGstin=case when buyer_sp.st_type=''OUT OF COUNTRY'' OR buyer_sp.supp_type=''UNREGISTERED'' then ''URP'' ELSE buyer_sp.gstin END '
	Set @SqlCommand=@SqlCommand+' ,fromTrdName=case when buyer_sp.mailname<>'''' then buyer_sp.mailname else buyer_sp.ac_name end'
	Set @SqlCommand=@SqlCommand+' ,fromAddr1=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'''') else isnull(Cons_ac.add1,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,fromAddr2=(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''''))+'' ''+rtrim(isnull(Cons_sp.add3,'''')) else rtrim(isnull(Cons_ac.add2,''''))+'' ''+rtrim(isnull(Cons_ac.add3,'''')) end)'
	Set @SqlCommand=@SqlCommand+' ,fromPlace=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'''') else isnull(Cons_ac.city,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,fromPincode=(case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''999999'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.zip,'''') else isnull(Cons_ac.zip,'''') end)  END)'
	Set @SqlCommand=@SqlCommand+' ,fromStateCode=(case when buyer_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.sac_id, 0) > 0 then isnull(buyer_sp.Statecode,'') else isnull(Cons_sp.Statecode,'') end) END)'
	Set @SqlCommand=@SqlCommand+' ,toGstin=cm.GSTIN'  
	Set @SqlCommand=@SqlCommand+' ,toTrdName=cm.MailName'
	Set @SqlCommand=@SqlCommand+' ,toAddr1=Case When isnull(m.SHIPTO,'''')<>'''' then lm.Add1 else cm.Add1 end'
	Set @SqlCommand=@SqlCommand+' ,toAddr2=Case When isnull(m.SHIPTO,'''')<>'''' then rtrim(lm.Add2)+'' ''+rtrim(lm.Add3) else rtrim(cm.Add2)+'' ''+rtrim(cm.Add3) END'
	Set @SqlCommand=@SqlCommand+' ,toPlace=Case When isnull(m.SHIPTO,'''')<>'''' then lm.city else cm.City end'
	Set @SqlCommand=@SqlCommand+' ,toPincode=Case When isnull(m.SHIPTO,'''')<>'''' then lm.pincode else cm.ZIP end'
	Set @SqlCommand=@SqlCommand+' ,toStateCode=cm.Gst_State_Code'  
	
	Set @SqlCommand=@SqlCommand+' ,totalValue=sum(i.u_AsseAmt),cgstValue=sum(i.cGST_Amt),sgstValue=sum(i.sGST_Amt),igstValue=sum(i.iGST_Amt),cessValue=sum(i.CompCess),transMode1=m.u_tMode,transDistance=m.EWBDIST,transporterName=m.u_Deli,transporterId=m.Trans_Id,transDocNo=m.U_LrNo,transDocDate=(case when year(m.u_lrdt)<=1900 then '''' else convert(varchar,m.u_lrdt,105) end),vehicleNo=m.U_VehNo'  --Modified by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',supplyType=''I'',subsupplyType=1,docType=''CHL'',transMode=1' --Rup
	Set @SqlCommand=@SqlCommand+' ,actualFromStateCode=(case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'''') else isnull(Cons_ac_st.Gst_State_code,'''') end) END)'		--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',actualToStateCode=	Case When isnull(m.SHIPTO,'''')<>'''' then s.Gst_State_code else Cm.Gst_State_code End'														--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',vehicleType=m.cargo_typ,totInvValue=sum(i.u_AsseAmt)+sum(i.cGST_Amt)+sum(i.sGST_Amt)+sum(i.iGST_Amt)+sum(i.CompCess) '									--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',mainHsnCode=(Select Top 1 ISNULL(Hsncode,'''') From iritem a inner join it_mast b on (a.it_code=b.it_code) where a.ismainhsn=1 and a.Tran_cd=m.tran_cd) '	--Added By Shrikant S. on 18/05/2018 for Bug-31516	
	Set @SqlCommand=@SqlCommand+' From #Co_mast cm,IRMain m'
	Set @SqlCommand=@SqlCommand+' Inner Join IRItem i on (m.Tran_Cd=i.Tran_Cd)'
	Set @SqlCommand=@SqlCommand+' Inner join it_mast itm on (itm.it_code=i.it_code and itm.isservice<>1)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto Cons_sp ON (Cons_sp.ac_id = m.Cons_id and Cons_sp.shipto_id = m.scons_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast Cons_ac ON (m.cons_id = Cons_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto buyer_sp ON (buyer_sp.ac_id = m.Ac_id and buyer_sp.shipto_id = m.sAc_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast buyer_ac ON (m.Ac_id = buyer_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_ac_st on (Cons_ac_st.State=Cons_ac.State)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_sp_st on (Cons_sp_st.State=Cons_sp.State)'
	Set @SqlCommand=@SqlCommand+' Left outer Join LOC_MASTER lm on (lm.Loc_Code = m.SHIPTO)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Left outer Join [state] s on (lm.state = s.state)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Where m.Inv_No='+Char(39)+@Inv_No+Char(39)
	Set @SqlCommand=@SqlCommand+' and m.Date ='''+Convert(varchar(50),@InvDate)+''''
	If (@TrnName='LABOUR JOB RECEIPT[IV]') Begin Set @SqlCommand=@SqlCommand+' and m.Entry_ty=''LR''' End 
										Else Begin Set @SqlCommand=@SqlCommand+' and m.Entry_ty=''RL''' End
	Set @SqlCommand=@SqlCommand+' Group By cm.GSTIN,m.EWBSUPTYP,m.Inv_No,m.Date,cm.GSTIN,cm.MailName,cm.Add1,cm.Add2,Cm.Add3,cm.City,cm.ZIP,Cm.Gst_State_Code,Cons_sp.gstin,Cons_ac.gstin,Cons_sp.mailname,Cons_ac.ac_name,Cons_sp.add1,Cons_ac.add1,Cons_sp.add2,Cons_ac.add2,Cons_sp.add3,Cons_ac.add3,Cons_sp.city,Cons_ac.city,Cons_sp.zip,Cons_ac.zip,Cons_sp_st.Gst_State_code,Cons_ac_st.Gst_State_code'  --Modified by Priyanka B on 09022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.u_tMode,m.EWBDIST,m.u_Deli,m.Trans_Id,m.U_LrNo,m.U_LrDt,m.U_VehNo'
	Set @SqlCommand=@SqlCommand+',m.scons_id'  --Added by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,lm.add1,lm.add2,lm.add3,lm.City,lm.pincode,m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode,buyer_sp.st_type,buyer_sp.supp_type,buyer_sp.gstin,buyer_sp.mailname,buyer_sp.ac_name,Cons_sp.st_type'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Print @SqlCommand
	Execute sp_Executesql @SqlCommand
End
If (@TrnName='CREDIT NOTE')
	Begin
	
	Insert Into #eWayBillJson
	Select genMode='Excel',userGstin=cm.GSTIN
	, supplyType1=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 'Inward' else 'Outward' end),subsupplyType1=m.EWBSUPTYPC
	,docType1='Credit Note',docNo=m.Inv_No,docDate=(case when year(m.date)<=1900 then '' else convert(varchar,m.date,105) end)
	
	,fromGstin=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
				(case when buyer_sp.st_type='OUT OF COUNTRY' OR buyer_sp.supp_type='UNREGISTERED' then 'URP' ELSE buyer_sp.gstin END) ELSE cm.GSTIN END)
	,fromTrdName=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
				(case when buyer_sp.mailname<>'' then buyer_sp.mailname else buyer_sp.ac_name end) ELSE cm.MailName END )
	,fromAddr1=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
					(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'') else isnull(Cons_ac.add1,'') end) 
				ELSE (Case When isnull(m.SHIPTO,'')<>'' then lm.Add1 else cm.Add1 End)	END )
	,fromAddr2=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
					(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''))+' '+rtrim(isnull(Cons_sp.add3,'')) else rtrim(isnull(Cons_ac.add2,''))+' '+rtrim(isnull(Cons_ac.add3,'')) end)
				ELSE
					(Case When isnull(m.SHIPTO,'')<>'' then lm.Add2+' '+lm.Add3 else cm.Add2+' '+Cm.Add3 end) END)
	,fromPlace=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
					(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'') else isnull(Cons_ac.city,'') end)
				ELSE (Case When isnull(m.SHIPTO,'')<>'' then lm.City else cm.City end) END)
	,fromPincode=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
				(case when Cons_sp.st_type='OUT OF COUNTRY' THEN '999999' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.zip,'') else isnull(Cons_ac.zip,'') end)  END)
			ELSE 	(Case When isnull(m.SHIPTO,'')<>'' then lm.pincode else cm.ZIP end)   END)
	,fromState=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
						(case when buyer_sp.st_type='OUT OF COUNTRY' THEN '99' ELSE (case WHEN isnull(m.sac_id, 0) > 0 then isnull(buyer_sp.Statecode,'') else isnull(Cons_sp.Statecode,'') end) END)
					ELSE Cm.Gst_State_code END )	
	,toGstin=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then cm.GSTIN ELSE 
		(case when buyer_sp.st_type='OUT OF COUNTRY' OR buyer_sp.supp_type='UNREGISTERED' then 'URP' ELSE buyer_sp.gstin END ) END)
	,toTrdName=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then cm.MailName else
			(case when buyer_sp.mailname<>'' then buyer_sp.mailname else buyer_sp.ac_name end) END )
	,toAddr1=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
				(Case When isnull(m.SHIPTO,'')<>'' then lm.Add1 else cm.Add1 end)
			ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'') else isnull(Cons_ac.add1,'') end) END)	
	,toAddr2=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
				(Case When isnull(m.SHIPTO,'')<>'' then rtrim(lm.Add2)+' '+rtrim(lm.Add3) else rtrim(cm.Add2)+' '+rtrim(cm.Add3) END)
			ELSE
				(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''))+' '+rtrim(isnull(Cons_sp.add3,'')) else rtrim(isnull(Cons_ac.add2,''))+' '+rtrim(isnull(Cons_ac.add3,'')) end)
			END )
	,toPlace=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
					(Case When isnull(m.SHIPTO,'')<>'' then lm.city else cm.City end)
				ELSE
					(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'') else isnull(Cons_ac.city,'') end) END)
	,toPincode=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then		
					(Case When isnull(m.SHIPTO,'')<>'' then lm.pincode else cm.ZIP end)
				ELSE	
					(case when Cons_sp.st_type='OUT OF COUNTRY' THEN '99' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'') else isnull(Cons_ac_st.Gst_State_code,'') end) END)
				END)
	,toStateCode=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then Cm.Gst_State_Code else 
			(case when buyer_sp.st_type='OUT OF COUNTRY' THEN '99' ELSE buyer_sp.statecode END)	 END)
	
	,totalValue=sum(i.u_AsseAmt),cgstValue=sum(i.cGST_Amt)
	,sgstValue=sum(i.sGST_Amt),igstValue=sum(i.iGST_Amt),cessValue=sum(i.CompCess),transMode1=m.u_tMode,transDistance=m.EWBDIST
	,transporterName=m.u_Deli,transporterId=m.Trans_Id,transDocNo=m.U_LrNo
	,transDocDate=(case when year(m.u_lrdt)<=1900 then '' else convert(varchar,m.u_lrdt,105) end),vehicleNo=m.U_VehNo 
	,supplyType=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 'I' else 'O' end),subsupplyType=1,docType='CNT',transMode=1
	,actualFromStateCode=(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then 
				(case when Cons_sp.st_type='OUT OF COUNTRY' THEN '99' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'') else isnull(Cons_ac_st.Gst_State_code,'') end) END)								
			else (Case When isnull(m.SHIPTO,'')<>'' then s.Gst_State_code else Cm.Gst_State_code End) end)	
	,actualToStateCode=	(Case when m.againstgs in ('PURCHASES','SERVICE PURCHASE BILL') then (Case When isnull(m.SHIPTO,'')<>'' then s.Gst_State_code else Cm.Gst_State_code End	) else		--Added by Shrikant S. on 18/05/2018 for Bug-31516
	(case when Cons_sp.st_type='OUT OF COUNTRY' THEN '99' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'') else isnull(Cons_ac_st.Gst_State_code,'') end) END) end)				--Added by Shrikant S. on 18/05/2018 for Bug-31516

	,vehicleType=m.cargo_typ,totInvValue=sum(i.u_AsseAmt)+sum(i.cGST_Amt)+sum(i.sGST_Amt)+sum(i.iGST_Amt)+sum(i.CompCess) 									--Added by Shrikant S. on 18/05/2018 for Bug-31516
	,mainHsnCode=(Select Top 1 ISNULL(Hsncode,'''') From cnitem a inner join it_mast b on (a.it_code=b.it_code) where a.ismainhsn=1 and a.Tran_cd=m.tran_cd) 	--Added By Shrikant S. on 18/05/2018 for Bug-31516													
	From #Co_mast cm,CNMain m 
	Inner Join CNItem i on (m.Tran_Cd=i.Tran_Cd) 
	Left outer join shipto Cons_sp ON (Cons_sp.ac_id = m.Cons_id and Cons_sp.shipto_id = m.scons_id ) 
	Left outer join ac_mast Cons_ac ON (m.cons_id = Cons_ac.ac_id) 
	Left outer join shipto buyer_sp ON (buyer_sp.ac_id = m.Ac_id and buyer_sp.shipto_id = m.sAc_id) 
	Left outer join ac_mast buyer_ac ON (m.Ac_id = buyer_ac.ac_id)
	Left join State Cons_ac_st on (Cons_ac_st.State=Cons_ac.State)
	Left join State Cons_sp_st on (Cons_sp_st.State=Cons_sp.State)
	Left outer Join LOC_MASTER lm on (lm.Loc_Code = m.SHIPTO)			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Left outer Join [state] s on (lm.state = s.state)
	Where m.Inv_No=@Inv_No
	and m.Date =@InvDate
	Group By cm.GSTIN, m.EWBSUPTYPC,m.Inv_No,m.Date,cm.GSTIN,cm.MailName,cm.Add1,cm.Add2,Cm.Add3,cm.City,cm.ZIP,Cm.Gst_State_Code
	,Cons_sp.gstin,Cons_ac.gstin,Cons_sp.mailname,Cons_ac.ac_name,Cons_sp.add1,Cons_ac.add1,Cons_sp.add2,Cons_ac.add2,Cons_sp.add3,Cons_ac.add3,Cons_sp.city,Cons_ac.city
	,Cons_sp.zip,Cons_ac.zip,Cons_sp_st.Gst_State_code,Cons_ac_st.Gst_State_code,m.Net_Amt,m.u_tMode,m.EWBDIST,m.u_Deli,m.Trans_Id,m.U_LrNo,m.U_LrDt,m.U_VehNo
	,m.scons_id,m.againstgs
	,m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode			--Added By Shrikant S. on 18/05/2018 for Bug-31516			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	,lm.add1,lm.add2,lm.add3,lm.City,lm.pincode,m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode,buyer_sp.st_type,buyer_sp.supp_type,buyer_sp.gstin,buyer_sp.mailname,buyer_sp.ac_name,buyer_sp.Statecode,Cons_sp.Statecode,Cons_sp.st_type,Cons_sp.supp_type
End
If (@TrnName='Sales Return')
	Begin
	Set @SqlCommand='Insert Into #eWayBillJson'
	Set @SqlCommand=@SqlCommand+' Select genMode=''Excel'',userGstin=cm.GSTIN, supplyType1=''Inward'',subsupplyType1=m.EWBSUPTYP,docType1=''Challan'''
	Set @SqlCommand=@SqlCommand+' ,docNo=m.Inv_No,docDate=(case when year(m.date)<=1900 then '''' else convert(varchar,m.date,105) end)'
	Set @SqlCommand=@SqlCommand+' ,fromGstin=case when buyer_sp.st_type=''OUT OF COUNTRY'' OR buyer_sp.supp_type=''UNREGISTERED'' then ''URP'' ELSE buyer_sp.gstin END '
	Set @SqlCommand=@SqlCommand+' ,fromTrdName=case when buyer_sp.mailname<>'''' then buyer_sp.mailname else buyer_sp.ac_name end'
	Set @SqlCommand=@SqlCommand+' ,fromAddr1=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.add1,'''') else isnull(Cons_ac.add1,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,fromAddr2=(case WHEN isnull(m.scons_id, 0) > 0 then rtrim(isnull(Cons_sp.add2,''''))+'' ''+rtrim(isnull(Cons_sp.add3,'''')) else rtrim(isnull(Cons_ac.add2,''''))+'' ''+rtrim(isnull(Cons_ac.add3,'''')) end)'
	Set @SqlCommand=@SqlCommand+' ,fromPlace=(case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.city,'''') else isnull(Cons_ac.city,'''') end)'
	Set @SqlCommand=@SqlCommand+' ,fromPincode=(case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''999999'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp.zip,'''') else isnull(Cons_ac.zip,'''') end)  END)'
	Set @SqlCommand=@SqlCommand+' ,fromStateCode=(case when buyer_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.sac_id, 0) > 0 then isnull(buyer_sp.Statecode,'') else isnull(Cons_sp.Statecode,'') end) END)'
	Set @SqlCommand=@SqlCommand+' ,toGstin=cm.GSTIN'  
	Set @SqlCommand=@SqlCommand+' ,toTrdName=cm.MailName'
	Set @SqlCommand=@SqlCommand+' ,toAddr1=Case When isnull(m.SHIPTO,'''')<>'''' then lm.Add1 else cm.Add1 end'
	Set @SqlCommand=@SqlCommand+' ,toAddr2=Case When isnull(m.SHIPTO,'''')<>'''' then rtrim(lm.Add2)+'' ''+rtrim(lm.Add3) else rtrim(cm.Add2)+'' ''+rtrim(cm.Add3) END'
	Set @SqlCommand=@SqlCommand+' ,toPlace=Case When isnull(m.SHIPTO,'''')<>'''' then lm.city else cm.City end'
	Set @SqlCommand=@SqlCommand+' ,toPincode=Case When isnull(m.SHIPTO,'''')<>'''' then lm.pincode else cm.ZIP end'
	Set @SqlCommand=@SqlCommand+' ,toStateCode=cm.Gst_State_Code'  
	
	Set @SqlCommand=@SqlCommand+' ,totalValue=sum(i.u_AsseAmt),cgstValue=sum(i.cGST_Amt),sgstValue=sum(i.sGST_Amt),igstValue=sum(i.iGST_Amt),cessValue=sum(i.CompCess),transMode1=m.u_tMode,transDistance=m.EWBDIST,transporterName=m.u_Deli,transporterId=m.Trans_Id,transDocNo=m.U_LrNo,transDocDate=(case when year(m.u_lrdt)<=1900 then '''' else convert(varchar,m.u_lrdt,105) end),vehicleNo=m.U_VehNo'  --Modified by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',supplyType=''I'',subsupplyType=1,docType=''CHL'',transMode=1' --Rup
	Set @SqlCommand=@SqlCommand+' ,actualFromStateCode=(case when Cons_sp.st_type=''OUT OF COUNTRY'' THEN ''99'' ELSE (case WHEN isnull(m.scons_id, 0) > 0 then isnull(Cons_sp_st.Gst_State_code,'''') else isnull(Cons_ac_st.Gst_State_code,'''') end) END)'		--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',actualToStateCode=Case When isnull(m.SHIPTO,'''')<>'''' then s.Gst_State_code else Cm.Gst_State_code End'														--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',vehicleType=m.cargo_typ,totInvValue=sum(i.u_AsseAmt)+sum(i.cGST_Amt)+sum(i.sGST_Amt)+sum(i.iGST_Amt)+sum(i.CompCess) '									--Added by Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+',mainHsnCode=(Select Top 1 ISNULL(Hsncode,'''') From sritem a inner join it_mast b on (a.it_code=b.it_code) where a.ismainhsn=1 and a.Tran_cd=m.tran_cd) '	--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' From #Co_mast cm,SRMain m'
	Set @SqlCommand=@SqlCommand+' Inner Join SRItem i on (m.Tran_Cd=i.Tran_Cd)'
	Set @SqlCommand=@SqlCommand+' Inner join it_mast itm on (itm.it_code=i.it_code and itm.isservice<>1)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto Cons_sp ON (Cons_sp.ac_id = m.Cons_id and Cons_sp.shipto_id = m.scons_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast Cons_ac ON (m.cons_id = Cons_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join shipto buyer_sp ON (buyer_sp.ac_id = m.Ac_id and buyer_sp.shipto_id = m.sAc_id)'
	Set @SqlCommand=@SqlCommand+' Left outer join ac_mast buyer_ac ON (m.Ac_id = buyer_ac.ac_id)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_ac_st on (Cons_ac_st.State=Cons_ac.State)'
	Set @SqlCommand=@SqlCommand+' Left join State Cons_sp_st on (Cons_sp_st.State=Cons_sp.State)'
	Set @SqlCommand=@SqlCommand+' Left outer Join LOC_MASTER lm on (lm.Loc_Code = m.SHIPTO)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Left outer Join [state] s on (lm.state = s.state)'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' Where m.Inv_No='+Char(39)+@Inv_No+Char(39) 
	Set @SqlCommand=@SqlCommand+' and m.Date ='''+Convert(varchar(50),@InvDate)+''''
	Set @SqlCommand=@SqlCommand+' Group By cm.GSTIN,m.EWBSUPTYP,m.Inv_No,m.Date,cm.GSTIN,cm.MailName,cm.Add1,cm.Add2,Cm.Add3,cm.City,cm.ZIP,Cm.Gst_State_Code,Cons_sp.gstin,Cons_ac.gstin,Cons_sp.mailname,Cons_ac.ac_name,Cons_sp.add1,Cons_ac.add1,Cons_sp.add2,Cons_ac.add2,Cons_sp.add3,Cons_ac.add3,Cons_sp.city,Cons_ac.city,Cons_sp.zip,Cons_ac.zip,Cons_sp_st.Gst_State_code,Cons_ac_st.Gst_State_code'  --Modified by Priyanka B on 09022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.u_tMode,m.EWBDIST,m.u_Deli,m.Trans_Id,m.U_LrNo,m.U_LrDt,m.U_VehNo'
	Set @SqlCommand=@SqlCommand+',m.scons_id'  --Added by Priyanka B on 06022018 for Bug-31240
	Set @SqlCommand=@SqlCommand+',m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Set @SqlCommand=@SqlCommand+' ,lm.add1,lm.add2,lm.add3,lm.City,lm.pincode,m.SHIPTO,m.CARGO_TYP,s.Gst_State_code,m.Tran_cd,m.sac_id,buyer_sp.Statecode,buyer_sp.st_type,buyer_sp.supp_type,buyer_sp.gstin,buyer_sp.mailname,buyer_sp.ac_name,Cons_sp.st_type'			--Added By Shrikant S. on 18/05/2018 for Bug-31516
	Print @SqlCommand
	Execute sp_Executesql @SqlCommand
End

Update #eWayBillJson set subsupplyType=Case 
When subsupplyType1='Supply'  Then 1
When subsupplyType1='Import'  Then 2
When subsupplyType1='Export'  Then 3
When subsupplyType1='Job Work'  Then 4
When subsupplyType1='For Own Use'  Then 5 
When subsupplyType1='Job work Returns'  Then 6
When subsupplyType1='Sales Return'  Then 7
When subsupplyType1='SKD/CKD'  Then 	9
When subsupplyType1='Lines Sales'  Then 	10
When subsupplyType1='Recipient Not Known'  Then 	11
When subsupplyType1='Exhibition or Fairs'  Then 	12
Else 8 End
,vehicleType=case when vehicleType='Regular' then 'R'						--Added By Shrikant S. on 18/05/2018 for Bug-31516
					WHEN vehicleType='Over Dimensional Cargo' Then 'O'					--Added by Shrikant S. on 13/07/2018 for Sprint 1.0.2
					--WHEN vehicleType='Over Dimensional Cargo' Then 'ODC'					--Commented by Shrikant S. on 13/07/2018 for Sprint 1.0.2
					ELSE '' END

update #eWayBillJson Set fromPincode=0 where ISNUMERIC(fromPincode)=0
update #eWayBillJson Set toPincode=0 where ISNUMERIC(toPincode)=0
update #eWayBillJson Set transDistance=0 where ISNUMERIC(transDistance)=0
update #eWayBillJson Set transMode=(Case When transMode1='Ship' Then 4 When transMode1='Rail' Then 2 When transMode1='Air' Then 3 Else 1 End)

Update #eWayBillJson set fromTrdName=replace(fromTrdName,'"','\"'),toTrdName=replace(toTrdName,'"','\"')
Select genMode,userGstin,supplyType=CAST(supplyType AS VARCHAR(30)),subsupplyType,docType,docNo,docDate
,fromGstin,fromTrdName,fromAddr1,fromAddr2,fromPlace
,fromPincode=cast(fromPincode as Decimal(8))
,actFromStateCode=cast(actFromStateCode as Decimal(8))
,fromStateCode=cast(fromStateCode as Decimal(8))
,toGstin,toTrdName,toAddr1,toAddr2,toPlace
,toPincode=cast(toPincode as Decimal(8))
,actToStateCode=cast(actToStateCode as Decimal(8))
,toStateCode=cast(toStateCode as Decimal(8))
,totalValue,cgstValue,sgstValue,igstValue,cessValue,transMode
,transDistance=cast(transDistance as VARCHAR(20)),transporterName,transporterId,transDocNo,transDocDate,vehicleNo
--,supplyType,subsupplyType,docType
,transMode
--,vehicleType='R'
,vehicleType=isnull(vehicleType,''),totInvValue,mainHsnCode=isnull(mainHsnCode,'')
From #eWayBillJson

Drop table #Co_mast
End
