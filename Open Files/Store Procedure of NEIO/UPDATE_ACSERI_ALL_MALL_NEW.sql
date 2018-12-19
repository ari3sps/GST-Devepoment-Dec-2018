DROP PROCEDURE [UPDATE_ACSERI_ALL_MALL_NEW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [UPDATE_ACSERI_ALL_MALL_NEW]
as
SELECT DISTINCT ENTRY_ALL,TBLACDET =(CASE WHEN EXT_VOU=0 THEN L.ENTRY_TY ELSE L.BCODE_NM END)+'ACDET' INTO #ENTRY_TABLE FROM PTMALL M INNER JOIN LCODE L ON (M.ENTRY_ALL=L.ENTRY_TY) WHERE 1=2

DECLARE @TBLNM VARCHAR(30),@SQLCOMMAND NVARCHAR(1000),@SQLCOMMAND1 NVARCHAR(1000),@FETCH_STATUS_M INT ,@AC_ID INT,@TBLACDET VARCHAR(30)
DECLARE @TRAN_CD INT,@AC_NAME VARCHAR(100),@COUNT INT,@MTRAN_CD INT ,@ACSERIAL VARCHAR(5)
declare cur_tblnm cursor for
select [name] from sysobjects where [name] like '__MALL' and type='u' and id in (select id from syscolumns where [name]='acserial')
open  cur_tblnm
fetch next from cur_tblnm into @TBLNM
SET @FETCH_STATUS_M=@@FETCH_STATUS
WHILE (@FETCH_STATUS_M=0)
BEGIN
	DELETE FROM #ENTRY_TABLE
	SET @TBLACDET=SUBSTRING(@TBLNM,1,2)+'ACDET'	
	SET @SQLCOMMAND='INSERT INTO #ENTRY_TABLE '
	SET @SQLCOMMAND=LTRIM(@SQLCOMMAND)+'SELECT DISTINCT ENTRY_ALL,TBLACDET=(CASE WHEN EXT_VOU=0 THEN L.ENTRY_TY ELSE L.BCODE_NM END)+'+'''ACDET'''+' FROM '+@TBLNM+' M INNER JOIN LCODE L ON (M.ENTRY_ALL=L.ENTRY_TY) '
	PRINT @SQLCOMMAND
	EXECUTE SP_EXECUTESQL @SQLCOMMAND
	
	DECLARE CUR_TBLACDET CURSOR FOR  SELECT TBLACDET FROM #ENTRY_TABLE
	OPEN CUR_TBLACDET
	FETCH NEXT FROM CUR_TBLACDET INTO @TBLACDET
	WHILE (@@FETCH_STATUS=0)
	BEGIN
		PRINT @TBLNM
		PRINT @TBLACDET
		IF (EXISTS(SELECT [NAME] FROM SYSOBJECTS WHERE [NAME]=@TBLACDET AND [TYPE]='U') AND EXISTS(SELECT [NAME] FROM SYSOBJECTS WHERE [NAME]=@TBLNM AND [TYPE]='U') )
		BEGIN
			SET @SQLCOMMAND1='UPDATE A SET A.ACSERI_ALL=B.ACSERIAL FROM '+RTRIM(@TBLNM)+' A INNER JOIN '+@TBLACDET+' B ON (A.ENTRY_ALL=B.ENTRY_TY AND A.MAIN_TRAN=B.TRAN_CD AND A.AC_ID=B.AC_ID) WHERE isnull(A.acserial,space(1))=space(1)'
						  --  UPDATE A SET A.ACSERI_ALL=B.ACSERIAL FROM         BPMALL    A INNER JOIN       PTACDET B ON (A.ENTRY_ALL=B.ENTRY_TY AND A.MAIN_TRAN=B.TRAN_CD AND A.AC_ID=B.AC_ID) 
			PRINT @SQLCOMMAND1
		EXECUTE SP_EXECUTESQL @SQLCOMMAND1
		END 	
		FETCH NEXT FROM CUR_TBLACDET INTO @TBLACDET
	END
	CLOSE CUR_TBLACDET
	DEALLOCATE CUR_TBLACDET

	fetch next from cur_tblnm into @TBLNM
	SET @FETCH_STATUS_M=@@FETCH_STATUS
END
close cur_tblnm
deallocate cur_tblnm

--TO CROSS CHECK RUN FOLLOWING QUERY
--SELECT A.ENTRY_TY,B.ENTRY_TY,A.TRAN_CD,B.TRAN_CD,A.AC_ID,B.AC_ID,A.ACSERIAL,B.ACSERIAL FROM LAC_VW A INNER JOIN MAINALL_VW B ON (A.ENTRY_TY=B.ENTRY_TY AND A.TRAN_CD=B.TRAN_CD AND A.AC_ID=B.AC_ID) WHERE A.ACSERIAL<>B.ACSERIAL
--RESULT MUST BE ZERO ROWS
GO
