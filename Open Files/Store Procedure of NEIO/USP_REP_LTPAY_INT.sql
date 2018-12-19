DROP PROCEDURE [USP_REP_LTPAY_INT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shrikant S.
-- Create date: 02/07/2010
-- Description:	This Stored procedure is Used for Interest Statement Report
-- Modify date: 
-- Modified By: satish pal
-- Modify date: 04/04/2012
-- Remark:Updated for bug-3159 date 04/04/2012
-- =============================================

CREATE PROCEDURE [USP_REP_LTPAY_INT]  
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(200)
AS
Declare @FCON as NVARCHAR(2000),@SQLCOMMAND as NVARCHAR(4000)

EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=null,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='MN',@VITFILE=Null,@VACFILE='AC'
,@VDTFLD ='DATE'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

Declare @DR_INT Decimal(7,2),@CR_INT Decimal(7,2),@DR_DAYS INT,@CR_DAYS INT,@DEPEND_ON bit

SELECT 
AC.TRAN_CD,AC.ENTRY_TY,AC.DATE,AC.AMOUNT,AC.AMT_TY
,MN.L_YN,MN.DUE_DT,AC_MAST.I_RATE
,AC_MAST.AC_ID,AC_MAST.AC_NAME
INTO #AC_BAL1
FROM LAC_VW AC
INNER JOIN AC_MAST  ON (AC.AC_ID = AC_MAST.AC_ID)
INNER JOIN LMAIN_VW MN ON (AC.TRAN_CD = MN.TRAN_CD AND AC.ENTRY_TY = MN.ENTRY_TY) 
WHERE 1=2


SET @SQLCOMMAND='INSERT INTO #AC_BAL1 SELECT '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'AC.TRAN_CD,AC.ENTRY_TY,AC.DATE,AC.AMOUNT,AC.AMT_TY'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',MN.L_YN,MN.DUE_DT,AC_MAST.I_RATE'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',AC_MAST.AC_ID,AC_MAST.AC_NAME'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'FROM LAC_VW AC'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'INNER JOIN AC_MAST  ON (AC.AC_ID = AC_MAST.AC_ID)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'INNER JOIN LMAIN_VW MN ON (AC.TRAN_CD = MN.TRAN_CD AND AC.ENTRY_TY = MN.ENTRY_TY) '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND


DELETE FROM #AC_BAL1 WHERE 
DATE < (SELECT TOP 1 DATE FROM #AC_BAL1 WHERE ENTRY_TY IN ('OB') AND L_YN = @LYN)
AND AC_NAME IN (SELECT AC_NAME FROM #AC_BAL1 WHERE ENTRY_TY IN ('OB') AND L_YN = @LYN GROUP BY AC_NAME) 


SELECT AC_NAME,AC_ID,TRAN_CD,ENTRY_TY,I_RATE,DATE,row_number() over (order by AC_ID,date,Case when Entry_ty='OB' THEN 'A' ELSE 'B' END ) as rownum
,OPBAL=CASE WHEN (ENTRY_TY='OB' OR DATE<=@SDATE) THEN (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END
,DAMT=CASE WHEN NOT (ENTRY_TY='OB' OR DATE<=@SDATE) AND AMT_TY='DR' THEN AMOUNT ELSE 0 END
,CAMT=CASE WHEN NOT (ENTRY_TY='OB' OR DATE<=@SDATE) AND AMT_TY='CR' THEN AMOUNT ELSE 0 END
,BALAMT=CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END
,Days=0,toDate=@Edate
INTO #AC_BAL2 FROM #AC_BAL1
ORDER BY AC_NAME,AC_ID

--select * from #AC_BAL2
--select *,row_number() over (order by date asc) as rownum from #AC_BAL2 order by ac_name, date

Declare @Ac_Name Varchar(60),@Date Smalldatetime,@mAc_Name Varchar(60),@mDate Smalldatetime,@rownum Numeric
Declare accCursor cursor for 
Select Ac_Name,Date,rownum From #AC_BAL2 Order by Ac_Name,Date
--Select Distinct Ac_Name,Date From #AC_BAL2 Order by Ac_Name,Date
Open accCursor
Fetch Next From accCursor Into @Ac_Name,@Date ,@rownum 
---Commented by satish pal for bug-3159 date-04/04/2012--Start
------------While @@Fetch_Status=0
------------Begin
------------	set @mDate=0
------------	Select top 1 @mDate=Date From #AC_BAL2 Where Ac_Name=@Ac_Name and rownum >@rownum Order by Date
------------	if Not(year(@mDate)<=1900)
------------		Begin
------------			Update #AC_BAL2 set toDate=@mDate Where Ac_name=@Ac_Name and rownum=@rownum
------------		End
------------	Fetch Next From accCursor Into @Ac_Name,@Date ,@rownum 
------------End
------------Close accCursor
------------Deallocate accCursor
While @@Fetch_Status=0
Begin
	set @mDate=0
	Select top 1 @mDate=Date From #AC_BAL2 Where Ac_Name=@Ac_Name and rownum >@rownum Order by Date
	if Not(year(@mDate)<=1900)
		Begin
			if @date<@sdate
			begin
				Update #AC_BAL2 set toDate=@mDate Where Ac_name=@Ac_Name and rownum<=@rownum 
			end
			else
			begin
				Update #AC_BAL2 set toDate=@mDate Where Ac_name=@Ac_Name and rownum=@rownum 
			End
		End
		else
		begin
			if @date<@sdate
			begin
				Update #AC_BAL2 set toDate=@eDate Where Ac_name=@Ac_Name and rownum<=@rownum 
			end
		end
	Fetch Next From accCursor Into @Ac_Name,@Date ,@rownum 
End
Close accCursor
Deallocate accCursor
----Update #AC_BAL2 set Days=datediff(d,date,toDate)+case when (date=@sdate and date<>todate) then 1 else 0 end--Commented by satish pal
--Update #AC_BAL2 set Days=datediff(d,date,toDate)

---Select *,Interest=0.00,Period=convert(varChar(10),date,103)+'-'+convert(varChar(10),toDate,103) Into #AC_BAL3 from #AC_BAL2----Commented by satish pal
---Order by AC_name,Date------Commented by satish pal
--(Balamt * i_rate/100)/dbo.DaysofYear(dbo.finYear(Date)) 
Select *,Interest=0.00,Period=convert(varChar(10),case when date<@sdate then @sdate else date end,103)+'-'+convert(varChar(10),case when toDate<@sdate then @sdate else toDate end ,103) Into #AC_BAL3 from #AC_BAL2 
Order by AC_name,Date
---Commented by satish pal for bug-3159 date-04/04/2012--End


Select AC_NAME,AC_ID,TRAN_CD=0,ENTRY_TY='A',I_RATE
,DATE=@SDATE,rownum=0,OPBAL=SUM(BALAMT),DAMT=0,CAMT=0,BALAMT=SUM(BALAMT),Days=0,toDate,Interest=sum(Interest)
,Period --Changed vy satish
INTO #AC_BAL4 FROM #AC_BAL3  
Where Date < @Sdate 
Group By AC_NAME,AC_ID,i_rate,toDate,Period
Union All
Select * From #AC_BAL3 Where Date Between @Sdate and @Edate
Update #AC_BAL4 set Days=datediff(d,date,toDate)+case when (date=@sdate and date<>todate) then 1 else 0 end---added by satish pal for bug-3159

--Update #AC_BAL4 set toDate=isnull(a.date,@Edate) from #AC_BAL4 b Left join  
--			(Select Date=Min(Date),Ac_id from #AC_BAL4 Where Date Between @Sdate and @Edate and Entry_ty<>'A' Group by Ac_id) 
--				a on (a.ac_id=b.ac_id)
--				Where b.entry_ty='A'

Select iden=IDENTITY (int, 1, 1),* Into #AC_BAL5 From #AC_BAL4 Order By Ac_name,Date



declare @iden Numeric(8,0),@balamt Numeric(18,2),@ac_name1 Varchar(100),@sum Numeric(18,2)
set @sum=0
Declare sumBal Cursor for
Select iden,ac_name,balamt from #AC_BAL5

Open sumBal
Fetch Next From sumBal Into @iden,@ac_name,@balamt
set @ac_name1=@ac_name
set @sum=@sum+@balamt
While @@Fetch_status=0
Begin
	print @sum
	Update #AC_BAL5 set balamt=@sum Where iden=@iden
	Fetch Next From sumBal Into @iden,@ac_name,@balamt
	if @ac_name1<>@ac_name
	Begin
		set @ac_name1=@ac_name
		set @sum=0
	End
	set @ac_name1=@ac_name
	set @sum=@sum+@balamt
End
Close sumBal
Deallocate sumBal

Update #AC_BAL5 set Interest=(Balamt * i_rate/100)/dbo.DaysofYear(dbo.finYear(Date))* Days 

select * from #AC_BAL5


DROP TABLE #AC_BAL1
DROP TABLE #AC_BAL2
DROP TABLE #AC_BAL3
DROP TABLE #AC_BAL4
DROP TABLE #AC_BAL5
GO
