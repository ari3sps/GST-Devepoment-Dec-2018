DROP PROCEDURE [USP_ENT_OpStItemAllocation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ruepesh Prajapati.
-- Create date: 16/05/2007
-- Description:	This Stored procedure is useful in Pickup OP entries from work order.
-- Modify date: 16/05/2007
-- Modified By/Date/Reason: Rupesh 11/02/10 checking for DC_NO
-- Updated By Pankaj B.:Bug-22827 on 04-07-2014
-- Remark:
-- =============================================
create PROCEDURE [USP_ENT_OpStItemAllocation] 
@ENTRY_TY  VARCHAR(2),@TRAN_CD  INT,@IT_CODE int,@SDATE SMALLDATETIME,@ProdCode varchar(10)
AS

SELECT 0 as sel,A.ENTRY_TY,A.TRAN_CD,A.DATE,A.IT_CODE,A.BATCHNO,A.MFGDT,A.EXPDT,A.ITSERIAL,B.INV_NO,B.CATE,C.IT_NAME
--,ORGQTY=QTY,ADJQTY=QTY,BALQTY=QTY,QTY -- Commented by Pankaj B. on 04-07-2014 for Bug-22827 
,ORGQTY=QTY,ADJQTY=QTY,BALQTY=QTY,QTY,a.lastqc_dt -- Added by Pankaj B. on 04-07-2014 for Bug-22827 
INTO #BALITEM
FROM STKL_VW_ITEM A
INNER JOIN STKL_VW_MAIN B ON (A.ENTRY_TY=B.ENTRY_TY AND A.TRAN_CD=B.TRAN_CD)
INNER JOIN IT_MAST C ON (A.IT_CODE=C.IT_CODE)
WHERE 1=2
DECLARE @SQLCOMMAND NVARCHAR(4000)
SET @SQLCOMMAND='INSERT INTO #BALITEM'

if rtrim(ltrim(@ProdCode))='QC'
begin
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'SELECT 0 as sel,A.ENTRY_TY,A.TRAN_CD,A.DATE,A.IT_CODE,A.BATCHNO,A.MFGDT,A.EXPDT,A.ITSERIAL,B.INV_NO,B.CATE,C.IT_NAME'
--SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',ORGQTY=QcAceptQTY,ADJQTY=0,BALQTY=QcAceptQTY,QTY=0'-- Commented by Pankaj B. on 04-07-2014 for Bug-22827 
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',ORGQTY=QcAceptQTY,ADJQTY=0,BALQTY=QcAceptQTY,QTY=0,a.lastqc_dt'-- Added by Pankaj B. on 04-07-2014 for Bug-22827 
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'FROM STKL_VW_ITEM A'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'INNER JOIN STKL_VW_MAIN B ON (A.ENTRY_TY=B.ENTRY_TY AND A.TRAN_CD=B.TRAN_CD)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'INNER JOIN IT_MAST C ON (A.IT_CODE=C.IT_CODE)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'WHERE A.PMKEY='+'''+'''+' AND C.TYPE LIKE'+CHAR(39)+'%FINISHED%'+CHAR(39)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'AND A.DC_NO='+''''''
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'AND C.IT_CODE ='+cast(@IT_CODE as varchar)
SET @SQLCOMMAND =RTRIM(@SQLCOMMAND)+' '+'AND A.DATE< ='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)
end
else
begin
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'SELECT 0 as sel,A.ENTRY_TY,A.TRAN_CD,A.DATE,A.IT_CODE,A.BATCHNO,A.MFGDT,A.EXPDT,A.ITSERIAL,B.INV_NO,B.CATE,C.IT_NAME'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+',ORGQTY=QTY,ADJQTY=0,BALQTY=QTY,QTY=0,'''''
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'FROM STKL_VW_ITEM A'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'INNER JOIN STKL_VW_MAIN B ON (A.ENTRY_TY=B.ENTRY_TY AND A.TRAN_CD=B.TRAN_CD)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'INNER JOIN IT_MAST C ON (A.IT_CODE=C.IT_CODE)'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'WHERE A.PMKEY='+'''+'''+' AND C.TYPE LIKE'+CHAR(39)+'%FINISHED%'+CHAR(39)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'AND A.DC_NO='+''''''
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'AND C.IT_CODE ='+cast(@IT_CODE as varchar)
SET @SQLCOMMAND =RTRIM(@SQLCOMMAND)+' '+'AND A.DATE< ='+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)
end

PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND

SELECT AENTRY_TY,ATRAN_CD,AITSERIAL,AQTY=SUM(AQTY) INTO #projectitref FROM  projectitref WHERE (1=2) GROUP BY AENTRY_TY,ATRAN_CD,AITSERIAL 
SET @SQLCOMMAND='INSERT INTO #projectitref'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'SELECT AENTRY_TY,ATRAN_CD,AITSERIAL,AQTY=SUM(QTY)  FROM  projectitref ' 
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'WHERE  NOT (ENTRY_TY ='+char(39)+@ENTRY_TY+char(39)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'AND TRAN_CD ='+cast(@TRAN_CD as varchar)+')'
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+'GROUP BY AENTRY_TY,ATRAN_CD,AITSERIAL'
PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND


UPDATE A SET  A.ADJQTY=ISNULL(B.AQTY,0),A.BALQTY=A.ORGQTY-ISNULL(B.AQTY,0) FROM #BALITEM A INNER JOIN #projectitref B ON (A.ENTRY_TY=B.AENTRY_TY AND A.TRAN_CD=B.ATRAN_CD AND A.ITSERIAL=B.AITSERIAL)
delete from #BALITEM where BALQTY=0

-- Added by Pankaj B. on 04-07-2014 for Bug-22827 start
if rtrim(ltrim(@ProdCode))='QC' 
begin
set @SQLCOMMAND='set dateformat DMY delete from #BALITEM where lastqc_dt >'+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)+''
print @SQLCOMMAND
EXECUTE sp_executesql @SQLCOMMAND 
end
-- Added by Pankaj B. on 04-07-2014 for Bug-22827 End

SELECT * FROM #BALITEM
GO
