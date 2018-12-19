DROP PROCEDURE [USP_REP_EMP_FORM24Q_1stJul2013]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shrikant S.
-- Create date: 28/09/2013
-- Description:	This Stored procedure is useful to generate TDS Form 24Q Challan and Annexure both Report.
-- Modified By:Date:Reason: 
-- Remark:
-- =============================================
Create PROCEDURE [USP_REP_EMP_FORM24Q_1stJul2013]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(60)= null
AS
Begin
	SET QUOTED_IDENTIFIER OFF
	Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2),@EmployeeCode Varchar(30),@mEmployeeCode Varchar(30)

	DECLARE @SQLCOMMAND NVARCHAR(4000),@VCOND NVARCHAR(2000),@FDATE VARCHAR(10),@RcNo varchar(15)

	EXECUTE   USP_REP_FILTCON 
	@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
	,@VSDATE=@SDATE
	,@VEDATE=@EDATE
	,@VSAC =@SAC,@VEAC =@EAC
	,@VSIT=@SIT,@VEIT=@EIT
	,@VSAMT=@SAMT,@VEAMT=@EAMT
	,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
	,@VSCATE =@SCATE,@VECATE =@ECATE
	,@VSWARE =@SWARE,@VEWARE  =@EWARE
	,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
	,@VMAINFILE='M',@VITFILE='',@VACFILE='AC'
	,@VDTFLD ='U_CLDT'
	,@VLYN =NULL
	,@VEXPARA=@EXPARA
	,@VFCON =@FCON OUTPUT

	declare @date smalldatetime,@u_chalno varchar(10),@u_chaldt smalldatetime,@section varchar(10),@mentry_ty varchar(10),@mtran_cd varchar(10),@csrno numeric(10),@dsrno numeric(10),@csrno1 numeric(10)
	declare @date1 smalldatetime,@u_chalno1 varchar(10),@section1 varchar(10),@mentry_ty1 varchar(10),@mtran_cd1 varchar(10)
	set @RcNo=''
	if charindex('RCNO1=',@EXPARA)>0
	begin	
		set @RcNo=substring(@EXPARA,charindex('RCNO1=',@EXPARA)+6,15)
	end 
	/*Challan Details--->*/
	SELECT DISTINCT SVC_CATE,SECTION=SEC_CODE INTO #TDSMASTER FROM TDSMASTER 

	Select m.Entry_Ty,m.Tran_Cd,EmployeeCode=space(15),EmployeeName=space(100),PAN=space(15),m.cheq_no,m.u_chalno,m.u_chaldt,m.bsrcode  /*m.entry_ty,m.tran_cd,ac.acserial,mall.new_all,*/
	,m.svc_cate,m.TDSonAmt,m.date,tm.section,tdspay=m.net_amt
	,TDSAmt=mall.new_all,scamt=mall.new_all,ecamt=mall.new_all,hcamt=mall.new_all
	,aTotAmt=mall.new_all,atdsamt=mall.new_all,ascamt=mall.new_all,aecamt=mall.new_all
	,ddate=m.Date,DepoDate=m.date
	,taTotAmt=mall.new_all,interest=mall.new_all,othersamt=mall.new_all
	,DED_RATE=cast(0 as decimal(12,4))
	,depbybook='N',paidbybook='N',reasonfor=space(90)
	--,mall.entry_all,mall.main_tran /*,mall.acseri_all*/
	,main_tran=m.Tran_Cd
	,csrno=99999,dsrno=99999,RcNo=''
	into #etds24q
	from tdsmain_vw m
	inner join lac_vw ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd) 
	inner join mainall_vw mall on (ac.entry_ty=mall.entry_ty and ac.tran_cd=mall.tran_cd and ac.acserial=mall.acserial)
	inner join ac_mast on (ac_mast.ac_id=ac.ac_id)
	inner join #TDSMASTER tm on (m.svc_cate=tm.svc_cate)
	where 1=2


	set @SqlCommand = 'insert into #etds24q Select m.Entry_Ty,m.Tran_Cd,mnp.EmployeeCode,EmployeeName=(case when isnull(em.pMailName,'''')='''' then em.EmployeeName else em.pMailName end),em.PAN,m.cheq_no,m.u_chalno,m.u_chaldt,m.bsrcode' /*m.entry_ty,m.tran_cd,ac.acserial,mall.new_all,*/
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',svc_cate='''',TDSonAmt=0,m.date,section=''92B'',tdspay=m.net_amt'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',TDSAmt=mnp.TDSAmt'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',scamt=0'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',ecamt=0'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',hcamt=0'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',aTotAmt=(case when mnp.th_trn_cd<>0 then mnp.TDSAmt else 0 end)'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',aTDSAmt=(case when mnp.th_trn_cd<>0 then mnp.TDSAmt else 0 end)'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',ascamt=0'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',aecamt=0'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',ddate=mpm.Date,DepoDate=m.date'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',taTotAmt=0,interest=0,othersamt=0'
	SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',DED_RATE=0'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',depbybook=''N'',paidbybook=''N'',reasonfor='''' '
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',main_tran=mpm.Tran_Cd'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+',csrno=0,dsrno=0,RcNo='''''
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'from BpMain m '
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join BpAcDet ac on (m.entry_ty=ac.entry_ty and m.tran_cd=ac.tran_cd)' 
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join Emp_Monthly_Payroll mnp on (m.entry_ty=mnp.TH_Ent_TY and m.tran_cd=mnp.TH_Trn_Cd)'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join MpMain mpm on (mnp.Tran_cd=mpm.Tran_Cd)'
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join EmployeeMast em on (em.EmployeeCode=mnp.EmployeeCode)'
	--set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join ac_mast ac_mast1 on (ac_mast1.ac_id=ac.ac_id)' 
	set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join ac_mast on (ac_mast.ac_id=m.ac_id)' 
	--set @SqlCommand=RTRIM(@SqlCommand)+' '+'inner join TDSMASTER tm on (''"''+rtrim(ac.Ac_Name)+''"''=tm.TdsPosting)'  
	set @SqlCommand=RTRIM(@SqlCommand)+' '+rtrim(@fcon)
	set @SqlCommand=RTRIM(@SqlCommand)+' '+' and ac.ac_name = ''TDS (192-B) ON PAYABLE A/C'''
	PRINT @SQLCOMMAND
	EXECUTE SP_EXECUTESQL @SQLCOMMAND
	/*<---Challan Details*/
	/*-->Update cSrNo*/
	print 'r'
	select @u_chalno1='' ,@section1='',@mentry_ty1='',@mtran_cd1=0
	select @csrno=0,@dsrno=0
	declare cur_etds24q cursor for select u_chaldt,date,u_chalno,section from #etds24q order by u_chaldt,u_chalno,section
	open cur_etds24q
	fetch next from cur_etds24q into @u_chaldt,@date,@u_chalno,@section
	while(@@fetch_status=0)
	begin
		if (@u_chalno1<>@u_chalno or @section1<>@section)	
		begin
			set @csrno=@csrno+1
			select @u_chalno1=@u_chalno,@section1=@section
		end
		update #etds24q set csrno=@csrno where (u_chalno=@u_chalno) and (section=@section)
		fetch next from cur_etds24q into @u_chaldt,@date,@u_chalno,@section
	end
	close cur_etds24q
	deallocate cur_etds24q
	print 'r1--------'

	/*<--Update cSrNo*/
	/*--->dSrNo*/
	--select csrno,EmployeeCode from #etds24q order by csrno,main_tran,EmployeeCode 
	set @mEmployeeCode=''
	declare cur_etds24q cursor for select csrno,EmployeeCode from #etds24q order by csrno,EmployeeCode 
	open cur_etds24q
	fetch next from cur_etds24q into @csrno,@EmployeeCode
	set @csrno1=@csrno
	set @dsrno=0
	while(@@fetch_status=0)
	begin
		--print '@csrno'
		--print @csrno
		--print @mEmployeeCode+ ' '+@EmployeeCode
		if (   @csrno1=@csrno )
		begin
			if not (@mEmployeeCode=@EmployeeCode )
			begin
				set @dsrno=@dsrno+1
				--print 'chg1'
				--print @dsrno
				select @mEmployeeCode=@EmployeeCode
			end 
		end
		else
		begin
			set @dsrno=1
			set @csrno1=@csrno
			if not ( @mEmployeeCode=@EmployeeCode )
			begin
				--print 'chg1'
				select @mEmployeeCode=@EmployeeCode
			end 
		end
		update #etds24q set dsrno=@dsrno where EmployeeCode=@mEmployeeCode and csrno=@csrno
		fetch next from cur_etds24q into @csrno,@EmployeeCode
	end
	close cur_etds24q
	deallocate cur_etds24q
	/*<---dSrNo*/
	
	select csrno,tatotamt=sum(atotamt) into #t3 from #etds24q group by csrno
	update a set a.tatotamt=b.tatotamt from #etds24q a inner join #t3 b on (a.csrno=b.csrno)
	Select Ded_Code='',Net_Amt='',*,i_tax=PAN,ded_refno='',Interest2=Convert(Numeric(10,2),0),Otheramt2=Convert(Numeric(10,2),0),fees=Convert(Numeric(10,2),0),minor_head=200,party_nm=employeename,certino='' From #etds24q order by csrno,dsrno
end
GO
