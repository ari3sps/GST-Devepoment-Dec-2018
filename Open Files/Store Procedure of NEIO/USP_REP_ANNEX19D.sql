DROP PROCEDURE [USP_REP_ANNEX19D]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ruepesh Prajapati.
-- Create date: 16/05/2007
-- Description:	This Stored procedure is useful to generate Excise EXPORT ANNEXEURE19A PART-IV Report.
-- Modify date: 16/05/2007
-- Modified By: 
-- Modify date: 
-- Remark:
-- =============================================

Create PROCEDURE [USP_REP_ANNEX19D]
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


DECLARE @FDATE CHAR(10),@OBACID INT
SELECT @FDATE=CASE WHEN DBDATE=1 THEN 'DATE' ELSE 'U_CLDT' END FROM MANUFACT
SELECT @OBACID=AC_ID FROM AC_MAST WHERE AC_NAME='OPENING BALANCES '

Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2)
EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=NULL
 ,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='STMAIN',@VITFILE='STITEM',@VACFILE='STACDET '
,@VDTFLD =@FDATE
,@VLYN =NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

SELECT STMAIN.TRAN_CD,STMAIN.ARENO,STMAIN.AREDATE
,STMAIN.U_EXBAMT,STMAIN.U_SBDT
,STMAIN.DATE, STMAIN.INV_NO,AC_MAST.AC_NAME,U_POED=isnull(B.U_POED,0)
FROM STMAIN INNER JOIN AC_MAST ON (STMAIN.AC_ID=AC_MAST.AC_ID) 
LEFT JOIN (SELECT ARENO,AREDATE,U_POED FROM BPMAIN WHERE ENTRY_TY='BC') B ON (STMAIN.ARENO=B.ARENO AND STMAIN.DATE=B.AREDATE)
WHERE (STMAIN.AREDESC='A.R.E.1') 
AND DATEADD(M,6,STMAIN.AREDATE) < @SDATE 
AND isnull(B.U_POED,0)=0

ORDER BY STMAIN.AREDATE,STMAIN.TRAN_CD
PRINT @SDATE
GO
