set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- =============================================
-- Author:  Hetal L. Patel
-- Create date: 16/05/2007
-- Description:	This Stored procedure is useful to generate RJ VAT FORM 07
-- Modify date: 16/05/2007
-- Modified By: 
-- Modify date: 
-- Remark:
-- =============================================
ALTER PROCEDURE [dbo].[USP_REP_RJVAT07]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(60)= NULL
AS

BEGIN
DECLARE @FCON AS NVARCHAR(2000)
EXECUTE   USP_REP_FILTCON 

@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=@SDATE,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='M',@VITFILE='M',@VACFILE='AC'
,@VDTFLD ='DATE'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT
--,@VMAINFILE='PTMAIN',@VITFILE='PTITEM',@VACFILE='AC'

--print @FCON
DECLARE @SQLCOMMAND NVARCHAR(4000)

SELECT DISTINCT AC_NAME=REPLACE(AC_NAME1,'"',''),ENTRY_TY,TAX_NAME 
INTO #STAX_MAS FROM STAX_MAS WHERE SET_APP=1 AND AC_NAME1 LIKE '%VAT%' AND ST_TYPE='LOCAL'

Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)
IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
	Begin	------Fetch Records from Multi Co. Data
		Set @MultiCo = 'YES'
		SET @SQLCOMMAND='SELECT M.ENTRY_TY,M.TRAN_CD,D.ITSERIAL,M.INV_NO,M.DATE,D.ITEM,D.QTY,D.RATE,'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'PT_VALUE=(D.U_ASSEAMT+D.TOT_EXAMT),GROSS_VAL=(D.U_ASSEAMT+D.TOT_EXAMT)+D.TAXAMT,'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'D.TAX_NAME,D.TAXAMT,AC_MAST.AC_ID,AC_MAST.AC_NAME,AC_MAST.MAILNAME,AC_MAST.S_TAX,'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'IT_MAST.[IT_DESC],IT_MAST.IT_CODE,ITEM_TYPE.[TYPE],PART=CASE WHEN ITEM_TYPE.[TYPE]<>''Machinery/Stores'' THEN 1 ELSE 2 END '
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'FROM PTMAIN M'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN PTITEM D ON (M.ENTRY_TY=D.ENTRY_TY AND M.TRAN_CD=D.TRAN_CD AND M.DBNAME=D.DBNAME)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN AC_MAST ON (M.AC_ID=AC_MAST.AC_ID AND M.DBNAME=AC_MAST.DBNAME)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN IT_MAST ON (IT_MAST.IT_CODE=D.IT_CODE AND IT_MAST.IT_CODE = D.IT_MAST)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN ITEM_TYPE ON (IT_MAST.ITTYID=ITEM_TYPE.ITTYID AND IT_MAST.DBNAME = ITEM.DBNAME)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN #STAX_MAS ON (D.TAX_NAME=#STAX_MAS.TAX_NAME AND D.ENTRY_TY=#STAX_MAS.ENTRY_TY)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+@FCON
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'ORDER BY PART,M.DATE,AC_MAST.AC_NAME,IT_MAST.IT_NAME'
	End
Else
	Begin	------Fetch Records from Single Co. Data
		Set @MultiCo = 'NO'
		SET @SQLCOMMAND='SELECT M.ENTRY_TY,M.TRAN_CD,D.ITSERIAL,M.INV_NO,M.DATE,D.ITEM,D.QTY,D.RATE,'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'PT_VALUE=(D.U_ASSEAMT+D.TOT_EXAMT),GROSS_VAL=(D.U_ASSEAMT+D.TOT_EXAMT)+D.TAXAMT,'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'D.TAX_NAME,D.TAXAMT,AC_MAST.AC_ID,AC_MAST.AC_NAME,AC_MAST.MAILNAME,AC_MAST.S_TAX,'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'IT_MAST.[IT_DESC],IT_MAST.IT_CODE,ITEM_TYPE.[TYPE],PART=CASE WHEN ITEM_TYPE.[TYPE]<>''Machinery/Stores'' THEN 1 ELSE 2 END '
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'FROM PTMAIN M'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN PTITEM D ON (M.ENTRY_TY=D.ENTRY_TY AND M.TRAN_CD=D.TRAN_CD)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN AC_MAST ON (M.AC_ID=AC_MAST.AC_ID)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN IT_MAST ON (IT_MAST.IT_CODE=D.IT_CODE)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN ITEM_TYPE ON (IT_MAST.ITTYID=ITEM_TYPE.ITTYID)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'INNER JOIN #STAX_MAS ON (D.TAX_NAME=#STAX_MAS.TAX_NAME AND D.ENTRY_TY=#STAX_MAS.ENTRY_TY)'
		SET @SQLCOMMAND=@SQLCOMMAND+' '+@FCON
		SET @SQLCOMMAND=@SQLCOMMAND+' '+'ORDER BY PART,M.DATE,AC_MAST.AC_NAME,IT_MAST.IT_NAME'
	End

--PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND

END
--Print 'RJ VAT FORM 07'

