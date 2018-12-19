DROP PROCEDURE [USP_REP_EMP_PF_DEDUCTION_DETAILS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Ramya
-- Create date: 05/03/2012
-- Description:	This is useful for Employee Pf Details Report
-- Modify date: 06/02/2013
-- Modify By : Archana K.
-- Description : Bug-8633- Added Statutory Details fields.  
-- Remark     :
-- =============================================

CREATE PROCEDURE [USP_REP_EMP_PF_DEDUCTION_DETAILS]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(1000)
AS
BEGIN
DECLARE @FCON AS NVARCHAR(2000)
EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=null
,@VEDATE=null
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='e',@VITFILE='',@VACFILE=' '
,@VDTFLD =''
,@VLYN =NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

if(@FCON='')
begin
	set @FCON=' where 1=1'
end 	
set @FCON=replace(@FCON,'Dept','Department')
set @FCON=replace(@FCON,'Cate','Category')
print @FCON
Declare @SQLCOMMAND as NVARCHAR(4000)
	


Declare @Pay_Year varchar(30),@Pay_Month int,@cPay_Month varchar(30),@EmpNm varchar(100)
Declare @POS INT

--Set @EXPARA='[Pay_Year=2012][Pay_Month=January][EmpNm=Rup]'
if(charindex('[Pay_Year=',@EXPARA)>0)
begin
SET @POS=CHARINDEX(']',@EXPARA)
	SET @POS=CHARINDEX(']',@EXPARA)
	SET @Pay_Year=SUBSTRING(@EXPARA,11,@POS-11)
	print @Pay_Year
end 	

if(charindex('[Pay_Month=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[Pay_Month=',@EXPARA)
	SET @cPay_Month=SUBSTRING(@EXPARA,@POS+11,len(@EXPARA)-@pos)
	SET @cPay_Month=replace(@cPay_Month,'[Pay_Month=','')
	SET @POS=CHARINDEX(']',@cPay_Month)
	SET @cPay_Month=SUBSTRING(@cPay_Month,1,@pos)
	SET @cPay_Month=replace(@cPay_Month,']','')
	print @cPay_Month
end

if(charindex('[EmpNm=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[EmpNm=',@EXPARA)
	SET @EmpNm=SUBSTRING(@EXPARA,@POS+7,len(@EXPARA)-@pos)
	SET @EmpNm=replace(@EmpNm,']','')
	Print @EmpNm
end

PRINT @Pay_Year
print @cPay_Month
print @EmpNm
Select @Pay_Month =
     case  @cPay_Month 
        when 'January' then 1 
        when 'February' then 2	
		when 'March' then 3 
		when 'April' then 4 
		when 'May' then 5 
		when 'June' then 6 
		when 'July' then 7 
		when 'August' then 8 
		when 'September' then 9 
		when 'October' then 10 
		when 'November' then 11
		when 'December' then 12 end


--Set @SqlCommand='select P.EmployeeCode,P.Pay_Month,p.Pay_Year,P.BasicAmt,P.PfEmpE,P.PfEmpR,P.EPSAmt,E.PFNO,E.EmployeeName,M.LOP'--Commented by Archana K. on 06/02/13 for Bug-8633 
Set @SqlCommand='select P.EmployeeCode,P.Pay_Month,p.Pay_Year,P.BasicAmt,P.PfEmpE,P.PfEmpR,P.EPSAmt,E.PFNO,E.EmployeeName,M.LOP,l.Loc_desc,l.PF_Code,l.PF_Sign' --Changed by Archana K. on 06/02/13 for Bug-8633(Added Loc_desc,PF_Code,PF_Sign Fields) 
Set @SqlCommand=Rtrim(@SqlCommand)+' '+'from  emp_monthly_payroll P' 
Set @SqlCommand=Rtrim(@SqlCommand)+' '+'Left Join Employeemast E on(P.EmployeeCode=E.EmployeeCode)'
Set @SqlCommand=Rtrim(@SqlCommand)+' '+'Left Join emp_monthly_muster M on(P.EmployeeCode=M.EmployeeCode and m.Pay_Year=p.Pay_Year and m.Pay_Month=p.Pay_Month)'
Set @SqlCommand=Rtrim(@SqlCommand)+' '+'Left Join loc_master l on(e.loc_code=l.loc_code)' --Added by Archana K. on 06/02/13 for Bug-8633
Set @SqlCommand=Rtrim(@SqlCommand)+' '+@FCON
Set @SqlCommand=Rtrim(@SqlCommand)+' '+'and (PfEmpE<>0) '
if(@Pay_Year<>'')
begin
	Set @SqlCommand=Rtrim(@SqlCommand)+' '+'and (p.Pay_Year='+char(39)+@Pay_Year+char(39)+')'
end	
if(@Pay_Month<>0)
begin
	Set @SqlCommand=Rtrim(@SqlCommand)+' '+'and (p.Pay_Month='+Cast(@Pay_Month as varchar)+')'
end	
if(@EmpNm<>'')
begin
	Set @SqlCommand=Rtrim(@SqlCommand)+' '+'and (e.EmployeeName='+char(39)+@EmpNm+char(39)+')'
end	
Set @SqlCommand=Rtrim(@SqlCommand)+' '+'ORDER BY p.Pay_Year,p.Pay_Month,p.EmployeeCode,l.PF_Code'--Changed by Archana K. on 06/02/13 for Bug-8633

print @SqlCommand
Execute Sp_ExecuteSql @SqlCommand


END
GO
