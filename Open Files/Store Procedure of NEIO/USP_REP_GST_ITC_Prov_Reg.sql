If Exists(Select [name] From SysObjects Where xType='P' and [name]='USP_REP_GST_ITC_Prov_Reg')
Begin
	Drop Procedure USP_REP_GST_ITC_Prov_Reg
End

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ruepesh Prajapati.
-- Create date: 18/06/2018
-- Description:	This Stored procedure is useful to generate GST ITC Provisional Register Report.
-- Modification Date/By/Reason: 
-- =============================================
Create PROCEDURE [dbo].[USP_REP_GST_ITC_Prov_Reg] 
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
SET QUOTED_IDENTIFIER OFF 
DECLARE @FDATE NVARCHAR(10),@OBACID INT
--SELECT @FDATE=CASE WHEN DBDATE=1 THEN 'DATE' ELSE 'U_CLDT' END FROM MANUFACT
Set @FDATE='Date'
SELECT @OBACID=AC_ID FROM AC_MAST WHERE AC_NAME='OPENING BALANCES '
Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2)
declare @t table(num int)



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
,@VMAINFILE='STKL_VW_MAIN',@VITFILE='STKL_VW_ITEM',@VACFILE='vw_GST_Ac_Det '
,@VDTFLD =@FDATE
,@VLYN =NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

IF  CHARINDEX('STKL_VW_MAIN.U_CLDT', @FCON)<>0
BEGIN
	SET @FCON=REPLACE(@FCON, 'STKL_VW_MAIN.U_CLDT','vw_GST_Ac_Det.U_CLDT')
END


DECLARE @ENTRY_TY CHAR(2),@DATE SMALLDATETIME,@DOC_NO CHAR(5),@AC_ID INT,@AMOUNT NUMERIC(15,2),@AMT_TY CHAR(2),@U_CLDT SMALLDATETIME,@TRAN_CD INT,@TTRAN_CD INT,@OPBAL1 NUMERIC(15,2),@RECEIPT1 NUMERIC(15,2),@ISSUE1 NUMERIC(15,2),@BALANCE1 NUMERIC(15,2),@OPBAL2 NUMERIC(15,2),@RECEIPT2 NUMERIC(15,2),@ISSUE2 NUMERIC(15,2),@BALANCE2 NUMERIC(15,2),@OPBAL3 NUMERIC(15,2),@RECEIPT3 NUMERIC(15,2),@ISSUE3 NUMERIC(15,2),@BALANCE3 NUMERIC(15,2),@OPBAL4 NUMERIC(15,2),@RECEIPT4 NUMERIC(15,2) ,@ISSUE4 NUMERIC(15,2),@BALANCE4 NUMERIC(15,2),@AC_ID5 NUMERIC(15,2),@OPBAL5 NUMERIC(15,2),@RECEIPT5 NUMERIC(15,2) ,@ISSUE5 NUMERIC(15,2),@BALANCE5 NUMERIC(15,2),@OPBAL6 NUMERIC(15,2),@RECEIPT6 NUMERIC(15,2) ,@ISSUE6 NUMERIC(15,2),@BALANCE6 NUMERIC(15,2),@OPBAL7 NUMERIC(15,2),@RECEIPT7 NUMERIC(15,2) ,@ISSUE7 NUMERIC(15,2),@BALANCE7 NUMERIC(15,2),@OPBAL8 NUMERIC(15,2),@RECEIPT8 NUMERIC(15,2) ,@ISSUE8 NUMERIC(15,2),@BALANCE8 NUMERIC(15,2),@OPBAL9 NUMERIC(15,2),@RECEIPT9 NUMERIC(15,2) ,@ISSUE9 NUMERIC(15,2),@BALANCE9 NUMERIC(15,2),@EXDATE SMALLDATETIME
DECLARE @MAC_ID INT,@MDATE SMALLDATETIME,@OPBAL NUMERIC(15,2),@RECEIPT NUMERIC(15,2),@ISSUE NUMERIC(15,2),@BALANCE NUMERIC(15,2),@V1 NUMERIC(10)
DECLARE @FINAC NVARCHAR(500)
DECLARE @SQLCOMMAND NVARCHAR(4000)
DECLARE @FCOND CHAR(1)
DECLARE @CACID INT,@ACID1 INT,@ACID2 INT,@ACID3 INT,@ACID4 INT,@ACID5 INT,@ACID6 INT,@ACID7 INT,@ACID8 INT,@ACID9 INT,@ACID10 INT, @TRAW NUMERIC(10),@CAC_NAME VARCHAR(60),@AC_NAME1 VARCHAR(60),@AC_NAME2 VARCHAR(60),@AC_NAME3 VARCHAR(60),@AC_NAME4 VARCHAR(60),@AC_NAME5 VARCHAR(60),@AC_NAME6 VARCHAR(60),@AC_NAME7 VARCHAR(60),@AC_NAME8 VARCHAR(60),@AC_NAME9 VARCHAR(60)
DECLARE @VCOND VARCHAR(1000),@VST INT,@VEND INT,@FACNM VARCHAR(500),@I INT 

SET @SPLCOND=REPLACE(@SPLCOND, '`','''')
SET @VCOND=@SPLCOND
SET @VST= CHARINDEX(RTRIM('AC_NAME IN'), @VCOND ,1)
SET @FACNM=SUBSTRING(@VCOND,@VST,2000)
SET @VST= CHARINDEX(RTRIM('('), @FACNM ,1)+1
SET @VEND= CHARINDEX(RTRIM(')'), @FACNM ,1)
SET @FACNM=SUBSTRING(@FACNM,@VST,@VEND-@VST)
SET @FACNM= LTRIM(RTRIM(@FACNM))+', '
SET QUOTED_IDENTIFIER ON


SET @FINAC=CHAR(39)+@FACNM+CHAR(39)

SELECT vw_GST_Ac_Det.ENTRY_TY,vw_GST_Ac_Det.DATE,vw_GST_Ac_Det.DOC_NO,vw_GST_Ac_Det.AMT_TY,vw_GST_Ac_Det.U_CLDT,AC_ID=vw_GST_Ac_Det.AC_ID,AC_ID1=vw_GST_Ac_Det.AC_ID,OPBAL1 =vw_GST_Ac_Det.AMOUNT,RECEIPT1=vw_GST_Ac_Det.AMOUNT,ISSUE1=vw_GST_Ac_Det.AMOUNT,BALANCE1=vw_GST_Ac_Det.AMOUNT,AC_ID2=vw_GST_Ac_Det.AC_ID,OPBAL2 =vw_GST_Ac_Det.AMOUNT,RECEIPT2=vw_GST_Ac_Det.AMOUNT,ISSUE2=vw_GST_Ac_Det.AMOUNT,BALANCE2=AMOUNT,AC_ID3=vw_GST_Ac_Det.AC_ID,OPBAL3 =vw_GST_Ac_Det.AMOUNT,RECEIPT3=vw_GST_Ac_Det.AMOUNT,ISSUE3=vw_GST_Ac_Det.AMOUNT,BALANCE3=vw_GST_Ac_Det.AMOUNT,AC_ID4=vw_GST_Ac_Det.AC_ID,OPBAL4 =vw_GST_Ac_Det.AMOUNT,RECEIPT4=vw_GST_Ac_Det.AMOUNT,ISSUE4=vw_GST_Ac_Det.AMOUNT,BALANCE4=vw_GST_Ac_Det.AMOUNT,AC_ID5=vw_GST_Ac_Det.AC_ID,OPBAL5 =vw_GST_Ac_Det.AMOUNT,RECEIPT5=vw_GST_Ac_Det.AMOUNT,ISSUE5=vw_GST_Ac_Det.AMOUNT,BALANCE5=vw_GST_Ac_Det.AMOUNT,AC_ID6=vw_GST_Ac_Det.AC_ID,OPBAL6 =vw_GST_Ac_Det.AMOUNT,RECEIPT6=vw_GST_Ac_Det.AMOUNT,ISSUE6=vw_GST_Ac_Det.AMOUNT,BALANCE6=vw_GST_Ac_Det.AMOUNT,AC_ID7=vw_GST_Ac_Det.AC_ID,OPBAL7 =vw_GST_Ac_Det.AMOUNT,RECEIPT7=vw_GST_Ac_Det.AMOUNT,ISSUE7=vw_GST_Ac_Det.AMOUNT,BALANCE7=vw_GST_Ac_Det.AMOUNT,AC_ID8=vw_GST_Ac_Det.AC_ID,OPBAL8 =vw_GST_Ac_Det.AMOUNT,RECEIPT8=vw_GST_Ac_Det.AMOUNT,ISSUE8=vw_GST_Ac_Det.AMOUNT,BALANCE8=vw_GST_Ac_Det.AMOUNT,AC_ID9=vw_GST_Ac_Det.AC_ID,OPBAL9 =vw_GST_Ac_Det.AMOUNT,RECEIPT9=vw_GST_Ac_Det.AMOUNT,ISSUE9=vw_GST_Ac_Det.AMOUNT,BALANCE9=vw_GST_Ac_Det.AMOUNT,TRAN_CD=vw_GST_Ac_Det.TRAN_CD,TTRAN_CD=vw_GST_Ac_Det.TRAN_CD,EXDATE=vw_GST_Ac_Det.DATE  
INTO  #ACDET FROM vw_GST_Ac_Det JOIN STKL_VW_MAIN ON (vw_GST_Ac_Det.TRAN_CD=STKL_VW_MAIN.TRAN_CD) WHERE 1=2
SELECT vw_GST_Ac_Det.ENTRY_TY,vw_GST_Ac_Det.DATE,vw_GST_Ac_Det.DOC_NO,vw_GST_Ac_Det.AC_ID,vw_GST_Ac_Det.AMOUNT,vw_GST_Ac_Det.AMT_TY,vw_GST_Ac_Det.U_CLDT,STKL_VW_MAIN.U_INT,AC_MAST.AC_NAME,TRAN_CD=vw_GST_Ac_Det.TRAN_CD,EXDATE=vw_GST_Ac_Det.DATE  INTO #ACDET1  FROM vw_GST_Ac_Det JOIN STKL_VW_MAIN ON (vw_GST_Ac_Det.TRAN_CD=STKL_VW_MAIN.TRAN_CD)  JOIN AC_MAST ON (AC_MAST.AC_ID =vw_GST_Ac_Det.AC_ID) WHERE 1=2


---Added By Hetal Dt 11/05/09 S

Declare @tran_cd1 Int,@entry_ty1 Varchar(2)
declare @mtran_cd Int,@mentry_ty Varchar(2),@cnt int
Set @Tran_cd1 = 0
Set @Entry_ty1 = '  '
Select Tran_Cd,Entry_Ty,U_PageNo=SPACE(100) InTo #PageNo From Stkl_vw_Item Where 1=2


--Select Distinct Tran_Cd,Entry_Ty,U_Pageno from Stkl_Vw_Item Where Date Between @Sdate and @Edate and U_PageNo <> ' '

--Declare Cur_Pageno Cursor For Select Distinct Tran_Cd,Entry_Ty from Stkl_Vw_Item Where Date Between @Sdate and @Edate  ORDER BY Entry_Ty,Tran_Cd
--Open Cur_Pageno
--Fetch Next From Cur_Pageno InTo @Tran_cd,@entry_t
----
--set @mentry_ty=@entry_ty
--set @mtran_cd=@tran_cd
--set @cnt=0
--While (@@fetch_status = 0)
--Begin
--	if @mentry_ty=@entry_ty and @mtran_cd=@tran_cd
--	begin
--		set  @cnt=@cnt+1
		
--	end
--	else
--	begin
--		set @mentry_ty=@entry_ty
--		set @mtran_cd=@tran_cd
		
--	end	
--	Fetch Next From Cur_Pageno InTo @Tran_cd,@entry_ty,@u_pageno1
--end
--close Cur_Pageno
--deallocate Cur_Pageno

--if @cnt>0
--begin
--	Insert InTo #Pageno (Tran_cd,Entry_ty,U_Pageno) Values (@mTran_cd,@mEntry_ty,@U_pageno)
--end


Print 'R1'
SET @SQLCOMMAND=' INSERT INTO #ACDET1 SELECT vw_GST_Ac_Det.ENTRY_TY,vw_GST_Ac_Det.DATE,vw_GST_Ac_Det.DOC_NO,vw_GST_Ac_Det.AC_ID,vw_GST_Ac_Det.AMOUNT,vw_GST_Ac_Det.AMT_TY,vw_GST_Ac_Det.U_CLDT,STKL_VW_MAIN.U_INT,AC_MAST.AC_NAME,vw_GST_Ac_Det.TRAN_CD,vw_GST_Ac_Det.'+@FDATE+' FROM vw_GST_Ac_Det '
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+ ' JOIN STKL_VW_MAIN ON (vw_GST_Ac_Det.TRAN_CD=STKL_VW_MAIN.TRAN_CD AND vw_GST_Ac_Det.ENTRY_TY=STKL_VW_MAIN.ENTRY_TY)   JOIN AC_MAST ON (AC_MAST.AC_ID =vw_GST_Ac_Det.AC_ID) '

SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' '+RTRIM(@FCON)
SET @SQLCOMMAND=RTRIM(@SQLCOMMAND)+' ORDER BY vw_GST_Ac_Det.'+ @FDATE+',(case when vw_GST_Ac_Det.amt_ty=''DR'' then ''a'' else ''b'' end) '
PRINT @SQLCOMMAND
EXEC SP_EXECUTESQL  @SQLCOMMAND
Print 'R2'
SET @TTRAN_CD=0

SET  @ACID1=0
SET  @ACID2=0
SET  @ACID3=0
SET  @ACID4=0
SET  @ACID5=0
SET  @ACID6=0
SET  @ACID7=0
SET  @ACID8=0
SET  @ACID9=0


SET @FACNM=REPLACE(@FACNM,'''',' ')
PRINT @FACNM
SET @VST=1
SET @I=0
SET @VEND= CHARINDEX(',',@FACNM,1)

WHILE CHARINDEX(',',@FACNM,1)<>0
BEGIN
	SET @I=@I+1
	IF @I=1
	BEGIN
		SET @AC_NAME1= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID1 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME1))
		
	END
	IF @I=2
	BEGIN
		
		SET @AC_NAME2= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID2 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME2))
	END
	IF @I=3
	BEGIN
		SET @AC_NAME3= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID3 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME3))
	END
	IF @I=4
	BEGIN
		SET @AC_NAME4= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID4 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME4))
	END
	IF @I=5
	BEGIN
          		SET @AC_NAME5= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID5 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME5))
	END
	IF @I=6
	BEGIN
		SET @AC_NAME6= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID6 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME6))

	END
	IF @I=7
	BEGIN
        SET @AC_NAME7= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID7 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME7))

	END
	IF @I=8
	BEGIN
		SET @AC_NAME8= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID8 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME8))

	END
	IF @I=9
	BEGIN
	    SET @AC_NAME9= SUBSTRING(@FACNM,@VST,@VEND-@VST)
		SELECT  @ACID9 =AC_ID FROM AC_MAST WHERE LTRIM(RTRIM(AC_NAME))=LTRIM(RTRIM(@AC_NAME9))
	END
	
	SET @FACNM=SUBSTRING(@FACNM,@VEND+1,500)
	SET @VEND= CHARINDEX(',',@FACNM,1)

END
print 'R3'
SELECT
@OPBAL1     =SUM(CASE WHEN AC_ID=@ACID1 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE1=SUM(CASE WHEN AC_ID=@ACID1 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL2     =SUM(CASE WHEN AC_ID=@ACID2 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE2=SUM(CASE WHEN AC_ID=@ACID2 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@OPBAL3     =SUM(CASE WHEN AC_ID=@ACID3 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE3=SUM(CASE WHEN AC_ID=@ACID3 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL4     =SUM(CASE WHEN AC_ID=@ACID4 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE4=SUM(CASE WHEN AC_ID=@ACID4 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL5     =SUM(CASE WHEN AC_ID=@ACID5 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE5=SUM(CASE WHEN AC_ID=@ACID5 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL6     =SUM(CASE WHEN AC_ID=@ACID6 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE6=SUM(CASE WHEN AC_ID=@ACID6 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL7     =SUM(CASE WHEN AC_ID=@ACID7 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE7=SUM(CASE WHEN AC_ID=@ACID7 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL8     =SUM(CASE WHEN AC_ID=@ACID8 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE8=SUM(CASE WHEN AC_ID=@ACID8 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END),
@OPBAL9     =SUM(CASE WHEN AC_ID=@ACID9 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END) ,
@BALANCE9=SUM(CASE WHEN AC_ID=@ACID9 THEN  (CASE WHEN AMT_TY='DR' THEN AMOUNT ELSE -AMOUNT END) ELSE 0 END)
FROM #ACDET1 WHERE ((EXDATE<@SDATE AND ENTRY_TY<>'OB') OR (EXDATE<=@SDATE AND ENTRY_TY='OB')) 

print 'R4'

SET @OPBAL1=CASE WHEN @OPBAL1 IS NULL THEN 0 ELSE @OPBAL1 END
SET @BALANCE1=CASE WHEN @BALANCE2 IS NULL THEN 0 ELSE @BALANCE1 END
SET @OPBAL2=CASE WHEN @OPBAL2 IS NULL THEN 0 ELSE @OPBAL2 END
SET @BALANCE2=CASE WHEN @BALANCE2 IS NULL THEN 0 ELSE @BALANCE2 END
SET @OPBAL3=CASE WHEN @OPBAL3 IS NULL THEN 0 ELSE @OPBAL3 END
SET @BALANCE3=CASE WHEN @BALANCE3 IS NULL THEN 0 ELSE @BALANCE3 END
SET @OPBAL4=CASE WHEN @OPBAL4 IS NULL THEN 0 ELSE @OPBAL4 END
SET @BALANCE4=CASE WHEN @BALANCE4 IS NULL THEN 0 ELSE @BALANCE4 END
SET @OPBAL5=CASE WHEN @OPBAL5 IS NULL THEN 0 ELSE @OPBAL5 END
SET @BALANCE5=CASE WHEN @BALANCE5 IS NULL THEN 0 ELSE @BALANCE5 END
SET @OPBAL6=CASE WHEN @OPBAL6 IS NULL THEN 0 ELSE @OPBAL6 END
SET @BALANCE6=CASE WHEN @BALANCE6 IS NULL THEN 0 ELSE @BALANCE6 END
SET @OPBAL7=CASE WHEN @OPBAL7 IS NULL THEN 0 ELSE @OPBAL7 END
SET @BALANCE7=CASE WHEN @BALANCE7 IS NULL THEN 0 ELSE @BALANCE7 END
SET @OPBAL8=CASE WHEN @OPBAL8 IS NULL THEN 0 ELSE @OPBAL8 END
SET @BALANCE8=CASE WHEN @BALANCE8 IS NULL THEN 0 ELSE @BALANCE8 END
SET @OPBAL9=CASE WHEN @OPBAL9 IS NULL THEN 0 ELSE @OPBAL9 END
SET @BALANCE9=CASE WHEN @BALANCE9 IS NULL THEN 0 ELSE @BALANCE9 END
print 'R5'
SET @RECEIPT1=0
SET @ISSUE1=0
SET @RECEIPT2=0
SET @ISSUE2=0
SET @RECEIPT3=0
SET @ISSUE3=0
SET @RECEIPT4=0
SET @ISSUE4=0
SET @RECEIPT5=0
SET @ISSUE5=0
SET @RECEIPT6=0
SET @ISSUE6=0
SET @RECEIPT7=0
SET @ISSUE7=0
SET @RECEIPT8=0
SET @ISSUE8=0
SET @RECEIPT9=0
SET @ISSUE9=0

SET @TTRAN_CD=@TTRAN_CD+1
print 'R6'

IF ABS(@OPBAL1)+ABS(@BALANCE1)+ABS(@OPBAL2)+ABS(@BALANCE2)+ABS(@OPBAL3)+ABS(@BALANCE3)+ABS(@OPBAL4)+ABS(@BALANCE4)+ABS(@OPBAL5)+ABS(@BALANCE5)+ABS(@OPBAL6)+ABS(@BALANCE6)+ABS(@OPBAL7)+ABS(@BALANCE7)+ABS(@OPBAL8)+ABS(@BALANCE8)+ABS(@OPBAL9)+ABS(@BALANCE9)<>0
BEGIN
	INSERT INTO #ACDET (ENTRY_TY,DATE,DOC_NO,AMT_TY,U_CLDT,AC_ID,TRAN_CD,

	AC_ID1,OPBAL1,RECEIPT1,ISSUE1,BALANCE1,
	AC_ID2,OPBAL2,RECEIPT2,ISSUE2,BALANCE2,
	AC_ID3,OPBAL3,RECEIPT3,ISSUE3,BALANCE3,
	AC_ID4,OPBAL4,RECEIPT4,ISSUE4,BALANCE4,
	AC_ID5,OPBAL5,RECEIPT5,ISSUE5,BALANCE5,
	AC_ID6,OPBAL6,RECEIPT6,ISSUE6,BALANCE6,
	AC_ID7,OPBAL7,RECEIPT7,ISSUE7,BALANCE7,
	AC_ID8,OPBAL8,RECEIPT8,ISSUE8,BALANCE8,
	AC_ID9,OPBAL9,RECEIPT9,ISSUE9,BALANCE9,
	TTRAN_CD,EXDATE
	)
	VALUES('OB',@SDATE,' ',' ',@SDATE,@OBACID,0,
	@ACID1,@OPBAL1,@RECEIPT1,@ISSUE1,@BALANCE1,
	@ACID2,@OPBAL2,@RECEIPT2,@ISSUE2,@BALANCE2,
	@ACID3,@OPBAL3,@RECEIPT3,@ISSUE3,@BALANCE3,
	@ACID4,@OPBAL4,@RECEIPT4,@ISSUE4,@BALANCE4,
	@ACID5,@OPBAL5,@RECEIPT5,@ISSUE5,@BALANCE5,
	@ACID6,@OPBAL6,@RECEIPT6,@ISSUE6,@BALANCE6,
	@ACID7,@OPBAL7,@RECEIPT7,@ISSUE7,@BALANCE7,
	@ACID8,@OPBAL8,@RECEIPT8,@ISSUE8,@BALANCE8,
	@ACID9,@OPBAL9,@RECEIPT9,@ISSUE9,@BALANCE9,
	@TTRAN_CD,@SDATE
	)
END

print 'R7'
DECLARE RG23II_CURSOR CURSOR FORWARD_ONLY  FOR 
SELECT ENTRY_TY,DATE,DOC_NO,AC_ID,AMOUNT,AMT_TY,U_CLDT,TRAN_CD,EXDATE FROM #ACDET1  WHERE (((EXDATE>=@SDATE  AND ENTRY_TY<>'OB') OR (EXDATE>@SDATE  AND ENTRY_TY='OB'))) ORDER BY EXDATE
OPEN RG23II_CURSOR
FETCH NEXT FROM RG23II_CURSOR INTO
@ENTRY_TY,@DATE,@DOC_NO,@AC_ID,@AMOUNT,@AMT_TY,@U_CLDT,@TRAN_CD,@EXDATE

IF @@FETCH_STATUS=0
BEGIN
SET @RECEIPT1=0
SET @ISSUE1=0
SET @RECEIPT2=0
SET @ISSUE2=0
SET @RECEIPT3=0
SET @ISSUE3=0
SET @RECEIPT4=0
SET @ISSUE4=0
SET @RECEIPT5=0
SET @ISSUE5=0
SET @RECEIPT6=0
SET @ISSUE6=0
SET @RECEIPT7=0
SET @ISSUE7=0
SET @RECEIPT8=0
SET @ISSUE8=0
SET @RECEIPT9=0
SET @ISSUE9=0





IF @AMT_TY='DR'
BEGIN

	IF @AC_ID=@ACID1
	BEGIN
		SET @RECEIPT1=@AMOUNT	
	END
	ELSE
	BEGIN
		IF @AC_ID=@ACID2
		BEGIN
			SET @RECEIPT2=@AMOUNT	
		END 		
		ELSE
		BEGIN
			IF @AC_ID=@ACID3
			BEGIN
				SET @RECEIPT3=@AMOUNT	
			END 	
			ELSE
			BEGIN
				IF @AC_ID=@ACID4
				BEGIN
					SET @RECEIPT4=@AMOUNT	
				END 	
				ELSE
				BEGIN
					IF @AC_ID=@ACID5
					BEGIN
						SET @RECEIPT5=@AMOUNT	
					END 	
					ELSE
					BEGIN
						IF @AC_ID=@ACID6
						BEGIN
							SET @RECEIPT6=@AMOUNT	
						END 	
						ELSE
						BEGIN
							IF @AC_ID=@ACID7
							BEGIN
								SET @RECEIPT7=@AMOUNT	
							END 	
							ELSE
							BEGIN
								IF @AC_ID=@ACID8
								BEGIN
									SET @RECEIPT8=@AMOUNT	
								END 	
								ELSE
								BEGIN
									IF @AC_ID=@ACID9
									BEGIN
										SET @RECEIPT9=@AMOUNT	
									END 	
								END
							END
						END
					END
				END
			END
		END
	END
END

IF @AMT_TY='CR'
BEGIN

	IF @AC_ID=@ACID1
	BEGIN
		SET @ISSUE1=@AMOUNT	
	END
	ELSE
	BEGIN
		IF @AC_ID=@ACID2
		BEGIN
			SET @ISSUE2=@AMOUNT	
		END 		
		ELSE
		BEGIN
			IF @AC_ID=@ACID3
			BEGIN
				SET @ISSUE3=@AMOUNT	
			END 	
			ELSE
			BEGIN
				IF @AC_ID=@ACID4
				BEGIN
					SET @ISSUE4=@AMOUNT	
				END 	
				ELSE
				BEGIN
					IF @AC_ID=@ACID5
					BEGIN
						SET @ISSUE5=@AMOUNT	
					END 	
					ELSE
					BEGIN
						IF @AC_ID=@ACID6
						BEGIN
							SET @ISSUE6=@AMOUNT	
						END 	
						ELSE
						BEGIN
							IF @AC_ID=@ACID7
							BEGIN
								SET @ISSUE7=@AMOUNT	
							END 	
							ELSE
							BEGIN
								IF @AC_ID=@ACID8
								BEGIN
									SET @ISSUE8=@AMOUNT	
								END 	
								ELSE
								BEGIN
									IF @AC_ID=@ACID9

									BEGIN

										SET @ISSUE9=@AMOUNT	
									END 	
								END
							END
						END
					END
				END
			END
		END
	END
END

SET @BALANCE1=@BALANCE1+@RECEIPT1-@ISSUE1
SET @BALANCE2=@BALANCE2+@RECEIPT2-@ISSUE2
SET @BALANCE3=@BALANCE3+@RECEIPT3-@ISSUE3
SET @BALANCE4=@BALANCE4+@RECEIPT4-@ISSUE4
SET @BALANCE5=@BALANCE5+@RECEIPT5-@ISSUE5
SET @BALANCE6=@BALANCE6+@RECEIPT6-@ISSUE6
SET @BALANCE7=@BALANCE7+@RECEIPT7-@ISSUE7
SET @BALANCE8=@BALANCE8+@RECEIPT8-@ISSUE8
SET @BALANCE9=@BALANCE9+@RECEIPT9-@ISSUE9



SET @TTRAN_CD=@TTRAN_CD+1

INSERT INTO #ACDET (ENTRY_TY,DATE,DOC_NO,AMT_TY,U_CLDT,AC_ID,TRAN_CD,
AC_ID1,OPBAL1,RECEIPT1,ISSUE1,BALANCE1,
AC_ID2,OPBAL2,RECEIPT2,ISSUE2,BALANCE2,
AC_ID3,OPBAL3,RECEIPT3,ISSUE3,BALANCE3,
AC_ID4,OPBAL4,RECEIPT4,ISSUE4,BALANCE4,
AC_ID5,OPBAL5,RECEIPT5,ISSUE5,BALANCE5,
AC_ID6,OPBAL6,RECEIPT6,ISSUE6,BALANCE6,
AC_ID7,OPBAL7,RECEIPT7,ISSUE7,BALANCE7,
AC_ID8,OPBAL8,RECEIPT8,ISSUE8,BALANCE8,
AC_ID9,OPBAL9,RECEIPT9,ISSUE9,BALANCE9,
TTRAN_CD,EXDATE
)
VALUES(@ENTRY_TY,@DATE,@DOC_NO,@AMT_TY,@U_CLDT,@AC_ID,@TRAN_CD,
@ACID1,@OPBAL1,@RECEIPT1,@ISSUE1,@BALANCE1,
@ACID2,@OPBAL2,@RECEIPT2,@ISSUE2,@BALANCE2,
@ACID3,@OPBAL3,@RECEIPT3,@ISSUE3,@BALANCE3,
@ACID4,@OPBAL4,@RECEIPT4,@ISSUE4,@BALANCE4,
@ACID5,@OPBAL5,@RECEIPT5,@ISSUE5,@BALANCE5,
@ACID6,@OPBAL6,@RECEIPT6,@ISSUE6,@BALANCE6,
@ACID7,@OPBAL7,@RECEIPT7,@ISSUE7,@BALANCE7,
@ACID8,@OPBAL8,@RECEIPT8,@ISSUE8,@BALANCE8,
@ACID9,@OPBAL9,@RECEIPT9,@ISSUE9,@BALANCE9,
@TTRAN_CD,@EXDATE
)

SET @OPBAL1=@BALANCE1
SET @OPBAL2=@BALANCE2
SET @OPBAL3=@BALANCE3
SET @OPBAL4=@BALANCE4
SET @OPBAL5=@BALANCE5
SET @OPBAL6=@BALANCE6
SET @OPBAL7=@BALANCE7
SET @OPBAL8=@BALANCE8
SET @OPBAL9=@BALANCE9

END ---@@FETCH_STATUS=0
WHILE @@FETCH_STATUS = 0
BEGIN
	FETCH NEXT FROM RG23II_CURSOR INTO
	@ENTRY_TY,@DATE,@DOC_NO,@AC_ID,@AMOUNT,@AMT_TY,@U_CLDT,@TRAN_CD,@EXDATE	
	
	IF  @@FETCH_STATUS <> 0
	BEGIN
		BREAK
	END
	

SET @RECEIPT1=0
SET @ISSUE1=0
SET @RECEIPT2=0
SET @ISSUE2=0
SET @RECEIPT3=0
SET @ISSUE3=0
SET @RECEIPT4=0
SET @ISSUE4=0
SET @RECEIPT5=0
SET @ISSUE5=0
SET @RECEIPT6=0
SET @ISSUE6=0
SET @RECEIPT7=0
SET @ISSUE7=0
SET @RECEIPT8=0
SET @ISSUE8=0
SET @RECEIPT9=0
SET @ISSUE9=0




IF @AMT_TY='DR'
BEGIN

	IF @AC_ID=@ACID1
	BEGIN
		SET @RECEIPT1=@AMOUNT	
	END
	ELSE
	BEGIN
		IF @AC_ID=@ACID2
		BEGIN
			SET @RECEIPT2=@AMOUNT	
		END 		
		ELSE
		BEGIN
			IF @AC_ID=@ACID3
			BEGIN
				SET @RECEIPT3=@AMOUNT	
			END 	
			ELSE
			BEGIN
				IF @AC_ID=@ACID4

				BEGIN
					SET @RECEIPT4=@AMOUNT	
				END 	
				ELSE
				BEGIN
					IF @AC_ID=@ACID5
					BEGIN
						SET @RECEIPT5=@AMOUNT	
					END 	
					ELSE
					BEGIN
						IF @AC_ID=@ACID6
						BEGIN
							SET @RECEIPT6=@AMOUNT	
						END 	
						ELSE
						BEGIN
							IF @AC_ID=@ACID7
							BEGIN
								SET @RECEIPT7=@AMOUNT	
							END 	
							ELSE
							BEGIN
								IF @AC_ID=@ACID8
								BEGIN
									SET @RECEIPT8=@AMOUNT	
								END 	
								ELSE
								BEGIN
									IF @AC_ID=@ACID9
									BEGIN
										SET @RECEIPT9=@AMOUNT	
									END 	
								END
							END
						END
					END
				END
			END
		END
	END
END

IF @AMT_TY='CR'
BEGIN

	IF @AC_ID=@ACID1
	BEGIN
		SET @ISSUE1=@AMOUNT	
	END
	ELSE
	BEGIN
		IF @AC_ID=@ACID2
		BEGIN
			SET @ISSUE2=@AMOUNT	
		END 		
		ELSE
		BEGIN
			IF @AC_ID=@ACID3
			BEGIN
				SET @ISSUE3=@AMOUNT	
			END 	
			ELSE
			BEGIN
				IF @AC_ID=@ACID4
				BEGIN
					SET @ISSUE4=@AMOUNT	
				END 	
				ELSE
				BEGIN

					IF @AC_ID=@ACID5
					BEGIN
						SET @ISSUE5=@AMOUNT	
					END 	
					ELSE
					BEGIN
						IF @AC_ID=@ACID6
						BEGIN
							SET @ISSUE6=@AMOUNT	
						END 	
						ELSE
						BEGIN
							IF @AC_ID=@ACID7
							BEGIN
								SET @ISSUE7=@AMOUNT	
							END 	
							ELSE
							BEGIN
								IF @AC_ID=@ACID8
								BEGIN
									SET @ISSUE8=@AMOUNT	
								END 	
								ELSE
								BEGIN
									IF @AC_ID=@ACID9

									BEGIN
										SET @ISSUE9=@AMOUNT	
									END 	
								END
							END
						END


					END
				END
			END
		END
	END



END


SET @BALANCE1=@BALANCE1+@RECEIPT1-@ISSUE1
SET @BALANCE2=@BALANCE2+@RECEIPT2-@ISSUE2
SET @BALANCE3=@BALANCE3+@RECEIPT3-@ISSUE3
SET @BALANCE4=@BALANCE4+@RECEIPT4-@ISSUE4
SET @BALANCE5=@BALANCE5+@RECEIPT5-@ISSUE5
SET @BALANCE6=@BALANCE6+@RECEIPT6-@ISSUE6

SET @BALANCE7=@BALANCE7+@RECEIPT7-@ISSUE7
SET @BALANCE8=@BALANCE8+@RECEIPT8-@ISSUE8
SET @BALANCE9=@BALANCE9+@RECEIPT9-@ISSUE9

SET @TTRAN_CD=@TTRAN_CD+1
INSERT INTO #ACDET (ENTRY_TY,DATE,DOC_NO,AMT_TY,U_CLDT,AC_ID,TRAN_CD,
AC_ID1,OPBAL1,RECEIPT1,ISSUE1,BALANCE1,
AC_ID2,OPBAL2,RECEIPT2,ISSUE2,BALANCE2,
AC_ID3,OPBAL3,RECEIPT3,ISSUE3,BALANCE3,
AC_ID4,OPBAL4,RECEIPT4,ISSUE4,BALANCE4,
AC_ID5,OPBAL5,RECEIPT5,ISSUE5,BALANCE5,
AC_ID6,OPBAL6,RECEIPT6,ISSUE6,BALANCE6,
AC_ID7,OPBAL7,RECEIPT7,ISSUE7,BALANCE7,
AC_ID8,OPBAL8,RECEIPT8,ISSUE8,BALANCE8,
AC_ID9,OPBAL9,RECEIPT9,ISSUE9,BALANCE9,
TTRAN_CD,EXDATE
)
VALUES(@ENTRY_TY,@DATE,@DOC_NO,@AMT_TY,@U_CLDT,@AC_ID,@TRAN_CD,
@ACID1,@OPBAL1,@RECEIPT1,@ISSUE1,@BALANCE1,
@ACID2,@OPBAL2,@RECEIPT2,@ISSUE2,@BALANCE2,
@ACID3,@OPBAL3,@RECEIPT3,@ISSUE3,@BALANCE3,
@ACID4,@OPBAL4,@RECEIPT4,@ISSUE4,@BALANCE4,
@ACID5,@OPBAL5,@RECEIPT5,@ISSUE5,@BALANCE5,
@ACID6,@OPBAL6,@RECEIPT6,@ISSUE6,@BALANCE6,
@ACID7,@OPBAL7,@RECEIPT7,@ISSUE7,@BALANCE7,
@ACID8,@OPBAL8,@RECEIPT8,@ISSUE8,@BALANCE8,
@ACID9,@OPBAL9,@RECEIPT9,@ISSUE9,@BALANCE9,
@TTRAN_CD,@EXDATE
)

SET @OPBAL1=@BALANCE1
SET @OPBAL2=@BALANCE2
SET @OPBAL3=@BALANCE3
SET @OPBAL4=@BALANCE4
SET @OPBAL5=@BALANCE5
SET @OPBAL6=@BALANCE6
SET @OPBAL7=@BALANCE7
SET @OPBAL8=@BALANCE8
SET @OPBAL9=@BALANCE9

END --FETCH
--

CLOSE  RG23II_CURSOR
DEALLOCATE RG23II_CURSOR


Select a.entry_ty,a.tran_cd,
	SUBSTRING(( SELECT  ', ' + rtrim(d.u_pageno)
	FROM #Pageno d   
	inner join ptitref it on (it.itref_tran=D.TRAN_CD AND it.rentry_ty=D.ENTRY_TY)
	WHERE   it.entry_ty=a.entry_ty and it.tran_cd=a.tran_cd
	order by it.date,cast(d.u_pageno as int)
	FOR
	XML PATH('')
	), 2, 4000) as u_pageno
Into #pickupNo  from #ACDET a 
Group by a.entry_ty,a.tran_cd

print @fdate
SELECT  cgrp=1
,A.ENTRY_TY,DATE=(CASE WHEN @FDATE='DATE' THEN A.DATE ELSE A.U_CLDT END),A.DOC_NO,A.AMT_TY,A.U_CLDT,A.AC_ID,C.TRAN_CD
,AC_NAME1=@AC_NAME1,A.AC_ID1,A.OPBAL1,A.RECEIPT1,A.ISSUE1,A.BALANCE1
,AC_NAME2=@AC_NAME2,A.AC_ID2,A.OPBAL2,A.RECEIPT2,A.ISSUE2,A.BALANCE2
,AC_NAME3=@AC_NAME3,A.AC_ID3,A.OPBAL3,A.RECEIPT3,A.ISSUE3,A.BALANCE3
,AC_NAME4=@AC_NAME4,A.AC_ID4,A.OPBAL4,A.RECEIPT4,A.ISSUE4,A.BALANCE4
,AC_NAME5=@AC_NAME5,A.AC_ID5,A.OPBAL5,A.RECEIPT5,A.ISSUE5,A.BALANCE5
,AC_NAME6=@AC_NAME6,A.AC_ID6,A.OPBAL6,A.RECEIPT6,A.ISSUE6,A.BALANCE6
,AC_NAME7=@AC_NAME7,A.AC_ID7,A.OPBAL7,A.RECEIPT7,A.ISSUE7,A.BALANCE7
,AC_NAME8=@AC_NAME8,A.AC_ID8,A.OPBAL8,A.RECEIPT8,A.ISSUE8,A.BALANCE8
,AC_NAME9=@AC_NAME9,A.AC_ID9,A.OPBAL9,A.RECEIPT9,A.ISSUE9,A.BALANCE9
,AC_NAME=(CASE WHEN ISNULL(s.shipto_id,0)=0 then b.ac_name else s.location_id end)
,GSTIN=(CASE WHEN ISNULL(s.shipto_id,0)=0 then b.[GSTIN] else s.[GSTIN] end)
,C.INV_NO,C.PINVNO,C.PINVDT,CAST(C.NARR AS VARCHAR(4000)) AS NARR  
,l.Code_Nm
FROM #ACDET A
LEFT JOIN STKL_VW_MAIN C ON (A.TRAN_CD=C.TRAN_CD AND A.ENTRY_TY=C.ENTRY_TY)
LEFT JOIN STMAIN ST ON (ST.TRAN_CD=C.TRAN_CD AND ST.ENTRY_TY=C.ENTRY_TY)
LEFT JOIN AC_MAST B ON (B.AC_ID=C.CONS_ID)
LEFT JOIN #Pageno D ON (A.TRAN_CD=D.TRAN_CD AND A.ENTRY_TY=D.ENTRY_TY)
LEFT JOIN #pickupNo E ON (A.TRAN_CD=E.TRAN_CD AND A.ENTRY_TY=E.ENTRY_TY) 
LEFT JOIN shipto s ON (S.shipto_id=C.SCONS_ID)
Left Join LCODE l on (l.Entry_ty=a.entry_ty)
ORDER BY TTRAN_CD

DROP TABLE #ACDET1
DROP TABLE #ACDET
SET QUOTED_IDENTIFIER ON

