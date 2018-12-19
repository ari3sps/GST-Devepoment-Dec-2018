If exists(Select * from sysobjects where [name]='USP_REP_ANNEXURE46' and xtype='P')
Begin
	Drop Procedure USP_REP_ANNEXURE46
End
go

/*
EXECUTE USP_REP_ANNEXURE46'','','','04/01/2014','03/31/2015','','','RAW1                                              ','',0,0,'','','','','','','','','2014-2015',''

*/
-- =============================================
-- Author:		Pankaj B.
-- Create date: 27-12-2014
-- Description:	This Stored procedure is useful to generate Annexure-46
-- Modify date: 
-- Modified By: 
-- Modify date: 
-- Remark:
-- =============================================
create PROCEDURE [dbo].[USP_REP_ANNEXURE46]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(60)
AS
DECLARE @FCON AS NVARCHAR(2000)
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
,@VMAINFILE='M',@VITFILE='I',@VACFILE=' '
,@VDTFLD ='DATE'
,@VLYN=@LYN
,@VEXPARA=NULL
,@VFCON =@FCON OUTPUT

--set arithabort off
--set ansi_warnings off
print @EXPARA
DECLARE @POS INT,@IT_NAME VARCHAR(50),@RATIO decimal(8,2)
if(charindex('[ITEM_NAME=',@EXPARA)>0)
begin
SET @POS=CHARINDEX('[ITEM_NAME=',@EXPARA)
SET @IT_NAME=SUBSTRING(@EXPARA,@POS+11,CHARINDEX(']',@EXPARA,@pos)-(@pos+11))
END
	
if(charindex('[RATIO=',@EXPARA)>0)
begin
SET @POS=CHARINDEX('[RATIO=',@EXPARA)
print @pos
SET @RATIO=CAST(SUBSTRING(@EXPARA,@POS+7,CHARINDEX(']',@EXPARA,@pos)-(@pos+7)) AS DECIMAL(8,2))
END

print @RATIO
SELECT ENTRY_TY,BCODE=(CASE WHEN EXT_VOU=1 THEN BCODE_NM ELSE ENTRY_TY END),STAX_ITEM INTO #LCODE FROM LCODE 

SELECT IT.IT_NAME,A.IT_CODE, 
OPBAL=sum(CASE WHEN A.ENTRY_TY ='OS' AND  (A.DATE between @SDATE and @edate) THEN A.QTY ELSE 0 END)+sum(CASE WHEN A.ENTRY_TY NOT IN('OB') AND (A.PMKEY='+')AND  A.DATE<@SDATE THEN A.QTY ELSE 0 END)-sum(CASE WHEN A.ENTRY_TY NOT IN('OB') AND (A.PMKEY='-')  AND  A.DATE<@SDATE THEN A.QTY ELSE 0 END),
RQTY=sum(CASE WHEN LC.BCODE IN ('PT','AR') AND A.PMKEY='+' AND A.DATE>=@SDATE THEN A.QTY ELSE 0 END),
IPQTY=sum(CASE WHEN LC.BCODE IN ('IP') AND A.PMKEY='-' AND A.DATE>=@SDATE THEN A.QTY ELSE 0 END),
FGITEM=CAST('' AS VARCHAR(50)),
RATIO=CAST(0 AS DECIMAL(12,3))
INTO #STKL_VW_ITEM 
FROM STKL_VW_ITEM A
INNER JOIN STKL_VW_MAIN B ON (A.TRAN_CD=B.TRAN_CD AND A.ENTRY_TY=B.ENTRY_TY)
INNER JOIN #LCODE LC ON (A.ENTRY_TY=LC.ENTRY_TY)
INNER JOIN IT_MAST IT ON (IT.IT_CODE=A.IT_CODE)
WHERE LC.BCODE IN ('OS','PT','IP','AR') AND B.[RULE] IN ('MODVATABLE','CT-1','CT-2','CT-3','EOU EXPORT') and A.date<@EDATE AND A.DC_NO='' AND IT.IT_NAME=@SIT AND IT.[TYPE]='Raw Material'
GROUP BY IT.IT_NAME,A.IT_CODE
 
UPDATE A SET 
A.FGITEM=(CASE WHEN @IT_NAME<>'' THEN @IT_NAME WHEN ISNULL(IT.EIT_NAME,'')<>'' THEN IT.EIT_NAME ELSE '' END),
A.RATIO=cast((CASE WHEN @RATIO <>0 THEN A.IPQTY/@RATIO WHEN  CAST(D.RMQTY/B.FGQTY AS DECIMAL(12,3))<>0 THEN A.IPQTY/CAST(D.RMQTY/B.FGQTY AS DECIMAL(12,3)) ELSE 0 END) as decimal(12,3))
FROM #STKL_VW_ITEM A
LEFT OUTER JOIN BOMDET D ON (D.RmitemId=A.IT_CODE)
LEFT OUTER JOIN BOMHEAD B ON (B.BOMID=D.BOMID)
LEFT OUTER JOIN IT_MAST IT ON (IT.IT_NAME=B.ITEM)

SELECT * FROM #STKL_VW_ITEM 
