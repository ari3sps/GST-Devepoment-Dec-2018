IF EXISTS(SELECT XTYPE FROM SYSOBJECTS WHERE XTYPE='P' AND name ='USP_REP_MH_SALESANNEX')
BEGIN
 DROP PROCEDURE USP_REP_MH_SALESANNEX
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXECUTE USP_REP_MH_SALESANNEX'','','','04/01/2015','03/31/2016','','','','',0,0,'','','','','','','','','2015-2016',''
*/
-- =============================================
-- Author: Sumit Gavate
-- Create date: 18-03-2016
-- Description: This Stored procedure is useful to generate sales ANNEXURE Report for Maharashtra State
-- Modify date: 
-- Modified By: 
-- Modify date:
-- =============================================

CREATE PROCEDURE [dbo].[USP_REP_MH_SALESANNEX]
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
,@VSDATE=NULL,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='M',@VITFILE=Null,@VACFILE='AC'
,@VDTFLD ='DATE'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

DECLARE @SQLCOMMAND NVARCHAR(MAX)
DECLARE @PER NUMERIC(12,2),@AMTA1 NUMERIC(15,2),@AMTA2 NUMERIC(15,2),@AMTA3 NUMERIC(15,2),@AMTA4 NUMERIC(15,2),
		@AMTA5 NUMERIC(15,2),@AMTA6 NUMERIC(15,2),@AMTA7 NUMERIC(15,2),@AMTA8 NUMERIC(15,2),@AMTA9 NUMERIC(15,2)
DECLARE @BHENT CHAR(2),@Inv_No CHAR(6),@Date SMALLDATETIME,@S_tax CHAR(20),@VATTYPECD VARCHAR(250),@U_Imporm VARCHAR(250),
		@Fld_name CHAR(20),@HeadDetail Bit,@TableName CHAR(20),@St_Type CHAR(15),@U_PSI Bit,@Form_no CHAR(3),
		@FldExits VARCHAR(10)
DECLARE @stax_item SMALLINT,@net_op SMALLINT,@LnVar INT

SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=99.999,AMT1=9999999999.99,AMT2=9999999999.99,AMT3=9999999999.99,AMT4=9999999999.99,AMT5=9999999999.99,
AMT6=9999999999.99,AMT7=9999999999.99,AMT8=9999999999.99,AMT9=9999999999.99,M.inv_sr,M.INV_NO,M.DATE,Tran_cd=SPACE(5),Tran_Desc=SPACE(200),RAction = SPACE(50),
Ret_Frm_no = SPACE(25),AC1.S_TAX INTO #MHSALSANNEX FROM STACDET A INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID) WHERE 1=2

Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)
IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
Begin	------Fetch Records from Multi Co. Data
	 Set @MultiCo = 'YES'
	 EXECUTE USP_REP_MULTI_CO_DATA
	  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
	 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
	 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
	 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
	 ,@MFCON = @MCON OUTPUT
	 SET @SQLCOMMAND='Insert InTo #FORM_LP1 Select * from '+@MCON
	 EXECUTE SP_EXECUTESQL @SQLCOMMAND
	 ---Drop Temp Table 
	 SET @SQLCOMMAND='Drop Table '+@MCON
	 EXECUTE SP_EXECUTESQL @SQLCOMMAND
End
else
Begin ------Fetch Single Co. Data
	 Set @MultiCo = 'NO'
	 EXECUTE USP_REP_SINGLE_CO_DATA_VAT
	  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
	 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
	 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
	 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
	 ,@MFCON = @MCON OUTPUT
End
INSERT INTO #MHSALSANNEX(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,AMT4,AMT5,AMT6,AMT7,AMT8,AMT9,Inv_no,Date,Tran_cd,Tran_Desc,RAction,Ret_Frm_no,S_tax)
VALUES (1,'1','A',0,0,0,0,0,0,0,0,0,0,'','','','','','','')

--Sales
SELECT @Fld_name = '',@SQLCOMMAND = '',@FldExits = '',@stax_item = 0,@net_op = 0
select @stax_item = stax_item,@net_op = net_op from lcode where entry_ty = 'ST'
Select DISTINCT @Fld_name = RTRIM(LTRIM(fld_nm)),@HeadDetail = att_file from DCMAST where head_nm like '%Labour%' AND Entry_ty = 'ST'
SET @SQLCOMMAND = 'INSERT INTO #MHSALSANNEX SELECT 2,''1'',''A'',0,Comp1,TaxAmt,0,Comp2,Tax_free,Exemp_Amt,LabChrgs,OthChrgs,Gro_Amt,inv_sr,inv_no,date,'
SET @SQLCOMMAND = @SQLCOMMAND + 'Tran_cd,Tran_desc,RAction,Ret_Frm_no,S_tax FROM ('
SET @SQLCOMMAND = @SQLCOMMAND + ' SELECT A.BHENT,A.inv_sr,A.Inv_no,A.Date,A.S_Tax,A.U_PSI,A.St_type,A.Tran_cd,A.Tran_desc,''   '' RAction,'
SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN U_PSI = 1 THEN ''234'' ELSE CASE WHEN St_Type IN (''LOCAL'','''') THEN ''231'' ELSE ''CST'' END END as Ret_Frm_No,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Comp1),0) as Comp1,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.TaxAmt),0) as TaxAmt,ISNULL(SUM(A.Comp2),0) as Comp2,ISNULL(SUM(A.Tax_free),0) as Tax_free,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Exemp_Amt),0) as Exemp_Amt,ISNULL(SM.LabChrgs,0) as LabChrgs,ISNULL(SM.OthChrgs,0) as OthChrgs,'
if @net_op = 1
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + 'ROUND('
END
SET @SQLCOMMAND = @SQLCOMMAND + ' (ISNULL(SUM(A.Comp1),0) + ISNULL(SUM(A.TaxAmt),0) + ISNULL(SUM(A.Comp2),0) + ISNULL(SUM(A.Tax_free),0) + '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Exemp_Amt),0) + ISNULL(SM.LabChrgs,0) + ISNULL(SM.OthChrgs,0)) '
if @net_op = 1
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ',0)'
END
SET @SQLCOMMAND = @SQLCOMMAND + ' As Gro_Amt FROM (Select ISNULL(A.Per,0) as Per,ISNULL(AC.S_Tax,'''') as S_Tax,ISNULL(AC.U_PSI,0) as U_PSI,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(AC.St_type,'''') as St_type,CASE WHEN ISNULL(S.U_Imporm,'''') = ''Composition u/s 42(3) or (3A)'' THEN '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE CASE WHEN ISNULL(A.tax_name,'''') <> '''' AND '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(A.tax_name,'''') NOT like ''%Exempted%'' AND ISNULL(S.U_Imporm,'''') <> ''Composition u/s 42 (1) or (2) or (4)'' '
SET @SQLCOMMAND = @SQLCOMMAND + ' THEN ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END end as Comp1,'
SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN ISNULL(A.tax_name,'''') <> '''' AND ISNULL(A.tax_name,'''') NOT like ''%Exempted%'' THEN '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN 'ISNULL(S.TaxAmt,0)' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as TaxAmt,CASE WHEN ISNULL(S.U_Imporm,'''') = ''Composition u/s 42 (1) or (2) or (4)'' THEN '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 end as Comp2,'
SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN ISNULL(A.Per,0) = 0 AND (ISNULL(A.tax_name,'''') = '''' OR ISNULL(A.tax_name,'''') like ''%Exempted%'') AND '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(S.U_Imporm,'''') NOT IN (''Exempted Sales u/s 41 & 8'',''Composition u/s 42(3) or (3A)'','
SET @SQLCOMMAND = @SQLCOMMAND + ' ''Composition u/s 42 (1) or (2) or (4)'') THEN ISNULL(SUM(A.Gro_Amt),0) - '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as Tax_free,CASE WHEN ISNULL(S.U_Imporm,'''') = ''Exempted Sales u/s 41 & 8'' '
SET @SQLCOMMAND = @SQLCOMMAND + ' AND ISNULL(A.tax_name,'''') like ''%Exempted%'' THEN ISNULL(SUM(A.Gro_Amt),0) - '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as Exemp_Amt,ISNULL(A.BHENT,'''') as BHENT,ISNULL(S.inv_sr,'''') as inv_sr,ISNULL(A.Inv_no,'''') as Inv_no,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(A.Date,'''') as Date,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(tc.Tran_cd,'''') as Tran_cd,ISNULL(tc.Tran_desc,'''') as Tran_desc FROM VATTBL A '
SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN STMAIN S ON (A.BHENT = S.Entry_ty AND A.INV_NO = S.inv_no AND A.Date = S.Date AND A.TRAN_CD = S.Tran_cd) '
SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN VATCDMST tc on (REPLACE(REPLACE(LTRIM(rtrim(tc.Tran_cd)) + LTRIM(rtrim(tc.Tran_desc)),'' '',''''),''-'','''') '
SET @SQLCOMMAND = @SQLCOMMAND + ' = REPLACE(REPLACE(LTRIM(rtrim(S.VATTYPECD)),''-'',''''),'' '','''') and TC.ENTRY_TY = S.ENTRY_TY) INNER JOIN STITEM SI ON '
SET @SQLCOMMAND = @SQLCOMMAND + ' (A.BHENT = SI.Entry_ty AND A.INV_NO = SI.inv_no AND A.TRAN_CD = SI.Tran_cd AND A.It_code = SI.It_Code '
SET @SQLCOMMAND = @SQLCOMMAND + ' AND A.ItSerial = SI.itserial) INNER JOIN Ac_Mast AC on (A.Ac_Id = AC.Ac_id) WHERE A.BHENT = ''ST'' '
SET @SQLCOMMAND = @SQLCOMMAND + ' AND (S.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.BHENT,S.inv_sr,A.Inv_no,A.Date,S.U_Imporm,A.tax_name,A.PER,tc.Tran_cd,tc.Tran_desc,'
SET @SQLCOMMAND = @SQLCOMMAND + ' AC.S_Tax,AC.St_type,AC.U_PSI,S.Tot_tax,S.Tot_nontax,S.tot_add,S.Tot_fdisc,S.Tot_deduc'
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN ',S.TaxAmt' ELSE ',S.TaxAmt' END + ') A '

IF EXISTS(select DISTINCT Entry_ty from DCMAST where Entry_ty IN ('ST'))
BEGIN
	IF @HeadDetail = 1
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN (SELECT A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,ISNULL(A.' + RTRIM(LTRIM(@Fld_name)) + ',0) as LabChrgs, '
		SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL((A.Tot_nontax + '
		IF EXISTS(SELECT * FROM sys.columns  WHERE Name = N'u_rg23cno' AND Object_ID = Object_ID(N'STMAIN'))
		BEGIN
		   SET @FldExits = 'TRUE'
		   SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN LTRIM(RTRIM(A.u_rg23cno)) = '''' THEN 0 ELSE 0 END) - '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + ' 0) - '
			SET @FldExits = 'FALSE'
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ' (A.Tot_fdisc),0) - ISNULL(A.'
		if @stax_item = 0
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) as OthChrgs FROM STMAIN A '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) + ISNULL(SUM(B.tot_nontax),0) as OthChrgs FROM STMAIN A '
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN STITEM B ON (A.Entry_Ty = B.Entry_ty AND A.inv_sr = B.inv_sr AND A.INV_NO = B.inv_no AND A.TRAN_CD = B.Tran_cd)'
		SET @SQLCOMMAND = @SQLCOMMAND + ' WHERE A.VATTYPECD <> '' '' AND A.Entry_Ty = ''ST'' AND  '
		SET @SQLCOMMAND = @SQLCOMMAND + ' (A.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
		SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,A.ULABCHRGS,A.Tot_nontax,A.Tot_fdisc,A.Tot_deduc'
		IF @FldExits = 'TRUE'
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + ',A.u_rg23cno '
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ')SM ON (A.BHENT = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
	END
	ELSE
	BEGIN
		if @stax_item = 0
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + 'INNER JOIN (SELECT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,ISNULL(SUM(Tot_fdisc),0) - ISNULL(SUM('
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + '),0) as OthChrgs FROM STITEM WHERE VATTYPECD <> '' '' AND '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + 'INNER JOIN (SELECT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,ISNULL(SUM((Tot_nontax) - (Tot_fdisc)),0) - ISNULL(SUM('
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + '),0) + ISNULL(SUM(tot_nontax),0) as OthChrgs FROM STITEM WHERE VATTYPECD <> '' '' AND '		
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ' Entry_Ty = ''ST'' AND (DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
		SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY Entry_ty,Inv_no,Tran_cd,Date '
		SET @SQLCOMMAND = @SQLCOMMAND + ' )SM ON (A.BHENT = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
	END
END
ELSE
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN (SELECT A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,ISNULL(A.' + RTRIM(LTRIM(@Fld_name)) + ',0) as LabChrgs, '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL((A.Tot_nontax + '
	IF EXISTS(SELECT * FROM sys.columns  WHERE Name = N'u_rg23cno' AND Object_ID = Object_ID(N'STMAIN'))
	BEGIN
	   SET @FldExits = 'TRUE'
	   SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN LTRIM(RTRIM(A.u_rg23cno)) = '''' THEN 0 ELSE 0 END) - '
	END
	ELSE
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ' ) - '
		SET @FldExits = 'FALSE'
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ' (A.Tot_fdisc),0) - ISNULL(A.'
	SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) + ISNULL(SUM(B.tot_nontax),0) as OthChrgs FROM STMAIN A '
	SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN STITEM B ON (A.Entry_Ty = B.Entry_ty AND A.inv_sr = B.inv_sr AND A.INV_NO = B.inv_no AND A.TRAN_CD = B.Tran_cd)'
	SET @SQLCOMMAND = @SQLCOMMAND + ' WHERE A.VATTYPECD <> '' '' AND A.Entry_Ty = ''ST'' AND  '
	SET @SQLCOMMAND = @SQLCOMMAND + ' (A.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
	SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,A.ULABCHRGS,A.Tot_nontax,A.tot_add,A.Tot_fdisc,A.Tot_deduc'
	IF @FldExits = 'TRUE'
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ',A.u_rg23cno '
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ')SM ON (A.BHENT = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
END
SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.BHENT,A.inv_sr,A.Inv_no,A.Date,A.S_Tax,A.U_PSI,A.St_type,A.Tran_cd,A.Tran_desc '
IF EXISTS(select DISTINCT Entry_ty from DCMAST where Entry_ty IN ('ST'))
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ',LabChrgs,OthChrgs'
END
SET @SQLCOMMAND = @SQLCOMMAND + ' ) B ORDER BY Tran_cd,Tran_desc,Date,Inv_no,S_Tax '
PRINT @SQLCOMMAND
EXECUTE sp_executesql @SQLCOMMAND

--Sales Return
SELECT @Fld_name = '',@SQLCOMMAND = '',@FldExits = '',@stax_item = 0,@net_op = 0
select @stax_item = stax_item,@net_op = net_op from lcode where entry_ty = 'SR'
Select DISTINCT @Fld_name = RTRIM(LTRIM(fld_nm)),@HeadDetail = att_file from DCMAST where head_nm like '%Labour%' AND Entry_ty = 'SR'
SET @SQLCOMMAND = 'INSERT INTO #MHSALSANNEX SELECT 2,''1'',''A'',0,Comp1,TaxAmt,0,Comp2,Tax_free,Exemp_Amt,LabChrgs,OthChrgs,Gro_Amt,inv_sr,inv_no,date,'
SET @SQLCOMMAND = @SQLCOMMAND + 'Tran_cd,Tran_desc,RAction,Ret_Frm_no,S_tax FROM ('
SET @SQLCOMMAND = @SQLCOMMAND + ' SELECT A.BHENT,A.inv_sr,A.Inv_no,A.Date,A.S_Tax,A.U_PSI,A.St_type,A.Tran_cd,A.Tran_desc,''   '' RAction,'
SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN U_PSI = 1 THEN ''234'' ELSE CASE WHEN St_Type IN (''LOCAL'','''') THEN ''231'' ELSE ''CST'' END END as Ret_Frm_No,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Comp1),0) as Comp1,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.TaxAmt),0) as TaxAmt,ISNULL(SUM(A.Comp2),0) as Comp2,ISNULL(SUM(A.Tax_free),0) as Tax_free,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Exemp_Amt),0) as Exemp_Amt,ISNULL(SM.LabChrgs,0) as LabChrgs,ISNULL(SM.OthChrgs,0) as OthChrgs,'
if @net_op = 1
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + 'ROUND('
END
SET @SQLCOMMAND = @SQLCOMMAND + ' (ISNULL(SUM(A.Comp1),0) + ISNULL(SUM(A.TaxAmt),0) + ISNULL(SUM(A.Comp2),0) + ISNULL(SUM(A.Tax_free),0) + '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Exemp_Amt),0) + ISNULL(SM.LabChrgs,0) + ISNULL(SM.OthChrgs,0)) '
if @net_op = 1
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ',0)'
END
SET @SQLCOMMAND = @SQLCOMMAND + ' As Gro_Amt FROM (Select ISNULL(A.Per,0) as Per,ISNULL(AC.S_Tax,'''') as S_Tax,ISNULL(AC.U_PSI,0) as U_PSI,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(AC.St_type,'''') as St_type,CASE WHEN ISNULL(S.U_Imporm,'''') = ''Composition u/s 42(3) or (3A)'' THEN '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE CASE WHEN ISNULL(A.tax_name,'''') <> '''' AND '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(A.tax_name,'''') NOT like ''%Exempted%'' AND ISNULL(S.U_Imporm,'''') <> ''Composition u/s 42 (1) or (2) or (4)'' '
SET @SQLCOMMAND = @SQLCOMMAND + ' THEN ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END end as Comp1,'
SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN ISNULL(A.tax_name,'''') <> '''' AND ISNULL(A.tax_name,'''') NOT like ''%Exempted%'' THEN '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN 'ISNULL(S.TaxAmt,0)' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as TaxAmt,CASE WHEN ISNULL(S.U_Imporm,'''') = ''Composition u/s 42 (1) or (2) or (4)'' THEN '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 end as Comp2,'
SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN ISNULL(A.Per,0) = 0 AND (ISNULL(A.tax_name,'''') = '''' OR ISNULL(A.tax_name,'''') like ''%Exempted%'') AND '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(S.U_Imporm,'''') NOT IN (''Exempted Sales u/s 41 & 8'',''Composition u/s 42(3) or (3A)'','
SET @SQLCOMMAND = @SQLCOMMAND + ' ''Composition u/s 42 (1) or (2) or (4)'') THEN ISNULL(SUM(A.Gro_Amt),0) - '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as Tax_free,CASE WHEN ISNULL(S.U_Imporm,'''') = ''Exempted Sales u/s 41 & 8'' '
SET @SQLCOMMAND = @SQLCOMMAND + ' AND ISNULL(A.tax_name,'''') like ''%Exempted%'' THEN ISNULL(SUM(A.Gro_Amt),0) - '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(S.Tot_tax,0) + ISNULL(S.tot_add,0) - ISNULL(S.Tot_deduc,0) '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 1 THEN ' - ISNULL(SUM(SI.tot_nontax),0) ' ELSE '' END 
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as Exemp_Amt,ISNULL(A.BHENT,'''') as BHENT,ISNULL(S.inv_sr,'''') as inv_sr,ISNULL(A.Inv_no,'''') as Inv_no,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(A.Date,'''') as Date,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(tc.Tran_cd,'''') as Tran_cd,ISNULL(tc.Tran_desc,'''') as Tran_desc FROM VATTBL A '
SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN SRMAIN S ON (A.BHENT = S.Entry_ty AND A.INV_NO = S.inv_no AND A.Date = S.Date AND A.TRAN_CD = S.Tran_cd) '
SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN VATCDMST tc on (REPLACE(REPLACE(LTRIM(rtrim(tc.Tran_cd)) + LTRIM(rtrim(tc.Tran_desc)),'' '',''''),''-'','''') '
SET @SQLCOMMAND = @SQLCOMMAND + ' = REPLACE(REPLACE(LTRIM(rtrim(S.VATTYPECD)),''-'',''''),'' '','''') and TC.ENTRY_TY = S.ENTRY_TY) INNER JOIN SRITEM SI ON '
SET @SQLCOMMAND = @SQLCOMMAND + ' (A.BHENT = SI.Entry_ty AND A.INV_NO = SI.inv_no AND A.TRAN_CD = SI.Tran_cd AND A.It_code = SI.It_Code '
SET @SQLCOMMAND = @SQLCOMMAND + ' AND A.ItSerial = SI.itserial) INNER JOIN Ac_Mast AC on (A.Ac_Id = AC.Ac_id) WHERE A.BHENT = ''SR'' '
SET @SQLCOMMAND = @SQLCOMMAND + ' AND (S.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.BHENT,S.inv_sr,A.Inv_no,A.Date,S.U_Imporm,A.tax_name,A.PER,tc.Tran_cd,tc.Tran_desc,'
SET @SQLCOMMAND = @SQLCOMMAND + ' AC.S_Tax,AC.St_type,AC.U_PSI,S.Tot_tax,S.Tot_nontax,S.tot_add,S.Tot_fdisc,S.Tot_deduc'
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN ',S.TaxAmt' ELSE ',S.TaxAmt' END + ') A '

IF EXISTS(select DISTINCT Entry_ty from DCMAST where Entry_ty IN ('SR'))
BEGIN
	IF @HeadDetail = 1
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN (SELECT A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,ISNULL(A.' + RTRIM(LTRIM(@Fld_name)) + ',0) as LabChrgs, '
		SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL((A.Tot_nontax + '
		IF EXISTS(SELECT * FROM sys.columns  WHERE Name = N'u_rg23cno' AND Object_ID = Object_ID(N'SRMAIN'))
		BEGIN
		   SET @FldExits = 'TRUE'
		   SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN LTRIM(RTRIM(A.u_rg23cno)) = '''' THEN 0 ELSE 0 END) - '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + ' 0) - '
			SET @FldExits = 'FALSE'
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ' (A.Tot_fdisc),0) - ISNULL(A.'
		if @stax_item = 0
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) as OthChrgs FROM SRMAIN A '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) + ISNULL(SUM(B.tot_nontax),0) as OthChrgs FROM SRMAIN A '
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN SRITEM B ON (A.Entry_Ty = B.Entry_ty AND A.inv_sr = B.inv_sr AND A.INV_NO = B.inv_no AND A.TRAN_CD = B.Tran_cd)'
		SET @SQLCOMMAND = @SQLCOMMAND + ' WHERE A.VATTYPECD <> '' '' AND A.Entry_Ty = ''SR'' AND  '
		SET @SQLCOMMAND = @SQLCOMMAND + ' (A.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
		SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,A.ULABCHRGS,A.Tot_nontax,A.Tot_fdisc,A.Tot_deduc'
		IF @FldExits = 'TRUE'
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + ',A.u_rg23cno '
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ')SM ON (A.BHENT = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
	END
	ELSE
	BEGIN
		if @stax_item = 0
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + 'INNER JOIN (SELECT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,ISNULL(SUM(Tot_fdisc),0) - ISNULL(SUM('
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + '),0) as OthChrgs FROM SRITEM WHERE VATTYPECD <> '' '' AND '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + 'INNER JOIN (SELECT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,ISNULL(SUM((Tot_nontax) - (Tot_fdisc)),0) - ISNULL(SUM('
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + '),0) + ISNULL(SUM(tot_nontax),0) as OthChrgs FROM SRITEM WHERE VATTYPECD <> '' '' AND '		
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ' Entry_Ty = ''SR'' AND (DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
		SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY Entry_ty,Inv_no,Tran_cd,Date '
		SET @SQLCOMMAND = @SQLCOMMAND + ' )SM ON (A.BHENT = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
	END
END
ELSE
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN (SELECT A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,ISNULL(A.' + RTRIM(LTRIM(@Fld_name)) + ',0) as LabChrgs, '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL((A.Tot_nontax + '
	IF EXISTS(SELECT * FROM sys.columns  WHERE Name = N'u_rg23cno' AND Object_ID = Object_ID(N'SRMAIN'))
	BEGIN
	   SET @FldExits = 'TRUE'
	   SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN LTRIM(RTRIM(A.u_rg23cno)) = '''' THEN 0 ELSE 0 END) - '
	END
	ELSE
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ' ) - '
		SET @FldExits = 'FALSE'
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ' (A.Tot_fdisc),0) - ISNULL(A.'
	SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) + ISNULL(SUM(B.tot_nontax),0) as OthChrgs FROM SRMAIN A '
	SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN SRITEM B ON (A.Entry_Ty = B.Entry_ty AND A.inv_sr = B.inv_sr AND A.INV_NO = B.inv_no AND A.TRAN_CD = B.Tran_cd)'
	SET @SQLCOMMAND = @SQLCOMMAND + ' WHERE A.VATTYPECD <> '' '' AND A.Entry_Ty = ''SR'' AND  '
	SET @SQLCOMMAND = @SQLCOMMAND + ' (A.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
	SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,A.ULABCHRGS,A.Tot_nontax,A.tot_add,A.Tot_fdisc,A.Tot_deduc'
	IF @FldExits = 'TRUE'
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ',A.u_rg23cno '
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ')SM ON (A.BHENT = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
END
SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.BHENT,A.inv_sr,A.Inv_no,A.Date,A.S_Tax,A.U_PSI,A.St_type,A.Tran_cd,A.Tran_desc '
IF EXISTS(select DISTINCT Entry_ty from DCMAST where Entry_ty IN ('SR'))
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ',LabChrgs,OthChrgs'
END
SET @SQLCOMMAND = @SQLCOMMAND + ' ) B ORDER BY Tran_cd,Tran_desc,Date,Inv_no,S_Tax '
PRINT @SQLCOMMAND
EXECUTE sp_executesql @SQLCOMMAND

--Credit Note
SELECT @Fld_name = '',@SQLCOMMAND = '',@stax_item = 0,@net_op = 0
select @stax_item = stax_item,@net_op = net_op from lcode where entry_ty IN('CN')
Select DISTINCT @Fld_name = RTRIM(LTRIM(fld_nm)),@HeadDetail = att_file from DCMAST where head_nm like '%Labour%' AND Entry_ty IN('CN')
SET @SQLCOMMAND = ' INSERT INTO #MHSALSANNEX SELECT 2,''1'',''A'',0,Comp1,TaxAmt,0,Comp2,Tax_free,Exemp_Amt,LabChrgs,OthChrgs,Gro_Amt,inv_sr,inv_no,date,'
SET @SQLCOMMAND = @SQLCOMMAND + ' Tran_cd,Tran_desc,RAction,Ret_Frm_no,S_tax FROM ('
SET @SQLCOMMAND = @SQLCOMMAND + ' SELECT A.Entry_Ty,A.inv_sr,A.Inv_no,A.Date,A.S_Tax,A.U_PSI,A.St_type,A.Tran_cd,A.Tran_desc,''   '' RAction,'
SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN U_PSI = 1 THEN ''234'' ELSE CASE WHEN St_Type IN (''LOCAL'','''') THEN ''231'' ELSE ''CST'' END END as Ret_Frm_No,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Comp1),0) as Comp1,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.TaxAmt),0) as TaxAmt,ISNULL(SUM(A.Comp2),0) as Comp2,ISNULL(SUM(A.Tax_free),0) as Tax_free,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Exemp_Amt),0) as Exemp_Amt,ISNULL(SM.LabChrgs,0) as LabChrgs,ISNULL(SM.OthChrgs,0) as OthChrgs,'
if @net_op = 1
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + 'ROUND('
END
SET @SQLCOMMAND = @SQLCOMMAND + ' (ISNULL(SUM(A.Comp1),0) + ISNULL(SUM(A.TaxAmt),0) + ISNULL(SUM(A.Comp2),0) + ISNULL(SUM(A.Tax_free),0) + '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Exemp_Amt),0) + ISNULL(SM.LabChrgs,0) + ISNULL(SM.OthChrgs,0))'
if @net_op = 1
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ',0)'
END
SET @SQLCOMMAND = @SQLCOMMAND + ' As Gro_Amt FROM (Select ISNULL(STM.level1,0) as level1,ISNULL(AC.S_Tax,'''') as S_Tax,ISNULL(AC.U_PSI,0) as U_PSI,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(AC.St_type,'''') as St_type,CASE WHEN ISNULL(S.U_Imporm,'''') = ''Composition u/s 42(3) or (3A)'' THEN'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(S.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(S.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE CASE WHEN ISNULL(S.tax_name,'''') <> '''' AND ISNULL(S.tax_name,'''') '
SET @SQLCOMMAND = @SQLCOMMAND + ' NOT like ''%Exempted%'' AND ISNULL(S.U_Imporm,'''') <> ''Composition u/s 42 (1) or (2) or (4)'' THEN '
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(S.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(S.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END end as Comp1,CASE WHEN ISNULL(S.tax_name,'''') <> '''' AND ISNULL(S.tax_name,'''') NOT '
SET @SQLCOMMAND = @SQLCOMMAND + ' like ''%Exempted%'' THEN ISNULL(SUM(S.TaxAmt),0) ELSE 0 END as TaxAmt,CASE WHEN ISNULL(S.U_Imporm,'''') = '
SET @SQLCOMMAND = @SQLCOMMAND + ' ''Composition u/s 42 (1) or (2) or (4)'' THEN ISNULL(SUM(S.Gro_Amt),0) - '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(S.TaxAmt),0)' END + ' ELSE 0 end as Comp2,'
SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN ISNULL(STM.level1,0) = 0 AND (ISNULL(S.tax_name,'''') = '''' OR ISNULL(S.tax_name,'''') like ''%Exempted%'')'
SET @SQLCOMMAND = @SQLCOMMAND + ' AND ISNULL(S.U_Imporm,'''') '
SET @SQLCOMMAND = @SQLCOMMAND + ' NOT IN(''Exempted Sales u/s 41 & 8'',''Composition u/s 42(3) or (3A)'',''Composition u/s 42 (1) or (2) or (4)'') '
SET @SQLCOMMAND = @SQLCOMMAND + ' THEN ISNULL(SUM(S.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(S.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as Tax_free,CASE WHEN ISNULL(S.U_Imporm,'''') = '
SET @SQLCOMMAND = @SQLCOMMAND + ' ''Exempted Sales u/s 41 & 8'' AND ISNULL(S.tax_name,'''') like ''%Exempted%'' THEN ISNULL(SUM(S.Gro_Amt),0) - '
SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(S.TaxAmt),0)' END
SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as Exemp_Amt,ISNULL(S.Entry_Ty,'''') as Entry_Ty,ISNULL(S.inv_sr,'''') as inv_sr,ISNULL(S.Inv_no,'''') as Inv_no,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(S.Date,'''') as Date,'
SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(tc.Tran_cd,'''') as Tran_cd,ISNULL(tc.Tran_desc,'''') as Tran_desc FROM CNMAIN S '
SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN VATCDMST tc on (REPLACE(REPLACE(LTRIM(rtrim(tc.Tran_cd)) + LTRIM(rtrim(tc.Tran_desc)),'' '',''''),''-'','''') '
SET @SQLCOMMAND = @SQLCOMMAND + ' = REPLACE(REPLACE(LTRIM(rtrim(S.VATTYPECD)),''-'',''''),'' '','''') AND tc.Entry_ty = S.Entry_Ty) INNER JOIN Ac_Mast AC on (S.Ac_Id = AC.Ac_id) '
SET @SQLCOMMAND = @SQLCOMMAND + ' LEFT OUTER JOIN STAX_MAS STM ON (S.TAX_NAME = STM.TAX_NAME And S.Entry_ty = STM.Entry_ty) WHERE S.Entry_Ty IN(''CN'') '
SET @SQLCOMMAND = @SQLCOMMAND + ' AND (S.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY S.Entry_Ty,S.inv_sr,S.Inv_no,S.Date,S.U_Imporm,S.tax_name,'
SET @SQLCOMMAND = @SQLCOMMAND + ' STM.Level1,tc.Tran_cd,tc.Tran_desc,AC.S_Tax,AC.St_type,AC.U_PSI) A '

IF EXISTS(select DISTINCT Entry_ty from DCMAST where Entry_ty IN('CN'))
BEGIN
	IF @HeadDetail = 1
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN (SELECT DISTINCT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,ISNULL(' + RTRIM(LTRIM(@Fld_name)) + ',0) as LabChrgs, '
		SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL((Tot_nontax + tot_add) - (Tot_fdisc + Tot_deduc),0) - ISNULL('
		SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) as OthChrgs FROM CNMAIN WHERE VATTYPECD <> '' '' AND '
		SET @SQLCOMMAND = @SQLCOMMAND + ' Entry_Ty IN(''CN'') AND (DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
		SET @SQLCOMMAND = @SQLCOMMAND + ' )SM ON (A.Entry_Ty = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
	END
	ELSE
	BEGIN
		if @stax_item = 0
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + 'INNER JOIN (SELECT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,ISNULL(SUM((tot_add) - (Tot_fdisc + Tot_deduc)),0) - ISNULL(SUM('
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + '),0) as OthChrgs FROM CNITEM WHERE VATTYPECD <> '' '' AND '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + 'INNER JOIN (SELECT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,ISNULL(SUM((Tot_nontax + tot_add) - (Tot_fdisc + Tot_deduc)),0) - ISNULL(SUM('
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + '),0) as OthChrgs FROM CNITEM WHERE VATTYPECD <> '' '' AND '
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ' Entry_Ty IN(''CN'') AND (DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
		SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY Entry_ty,inv_sr,Inv_no,Tran_cd,Date '
		SET @SQLCOMMAND = @SQLCOMMAND + ' )SM ON (A.Entry_Ty = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
	END
END
ELSE
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN (SELECT DISTINCT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,0 as LabChrgs, '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL((Tot_nontax + tot_add) - (Tot_fdisc + Tot_deduc),0) - ISNULL('
	SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) as OthChrgs FROM CNMAIN WHERE VATTYPECD <> '' '' AND '
	SET @SQLCOMMAND = @SQLCOMMAND + ' Entry_Ty IN(''CN'') AND (DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
	SET @SQLCOMMAND = @SQLCOMMAND + ' )SM ON (A.Entry_Ty = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
END
SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_Ty,A.inv_sr,A.Inv_no,A.Date,A.S_Tax,A.U_PSI,A.St_type,A.Tran_cd,A.Tran_desc '
IF EXISTS(select DISTINCT Entry_ty from DCMAST where Entry_ty IN('CN'))
BEGIN
	SET @SQLCOMMAND = @SQLCOMMAND + ',LabChrgs,OthChrgs'
END
SET @SQLCOMMAND = @SQLCOMMAND + ' ) B ORDER BY Tran_cd,Tran_desc,Date,Inv_no,S_Tax '
PRINT @SQLCOMMAND
EXECUTE sp_executesql @SQLCOMMAND

--Extra Credit Note Entry (With Item Wise)
SET @LnVar = 0
WHILE (@LnVar <= 3)
BEGIN
	SELECT @Fld_name = '',@SQLCOMMAND = '',@FldExits = '',@stax_item = 0,@net_op = 0
	Set @Bhent = CASE WHEN @LnVar = 0 THEN 'C2' ELSE CASE WHEN @LnVar = 1 THEN 'C3' ELSE CASE WHEN @LnVar = 2 THEN 'C4'
		ELSE CASE WHEN @LnVar = 3 THEN 'C5' ELSE '' END END END END
	select @stax_item = stax_item,@net_op = net_op from lcode where entry_ty IN(@Bhent)
	Select DISTINCT @Fld_name = RTRIM(LTRIM(fld_nm)),@HeadDetail = att_file from DCMAST where head_nm like '%Labour%' AND Entry_ty IN(@Bhent)
	SET @SQLCOMMAND = 'INSERT INTO #MHSALSANNEX SELECT 2,''1'',''A'',0,Comp1,TaxAmt,0,Comp2,Tax_free,Exemp_Amt,LabChrgs,OthChrgs,Gro_Amt,inv_sr,inv_no,date,'
	SET @SQLCOMMAND = @SQLCOMMAND + 'Tran_cd,Tran_desc,RAction,Ret_Frm_no,S_tax FROM ('
	SET @SQLCOMMAND = @SQLCOMMAND + ' SELECT A.Entry_ty,A.inv_sr,A.Inv_no,A.Date,A.S_Tax,A.U_PSI,A.St_type,A.Tran_cd,A.Tran_desc,'
	SET @SQLCOMMAND = @SQLCOMMAND + '''   '' RAction,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN U_PSI = 1 THEN ''234'' ELSE CASE WHEN St_Type IN (''LOCAL'','''') THEN ''231'' ELSE ''CST'' END END as Ret_Frm_No,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Comp1),0) as Comp1,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.TaxAmt),0) as TaxAmt,ISNULL(SUM(A.Comp2),0) as Comp2,ISNULL(SUM(A.Tax_free),0) as Tax_free,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Exemp_Amt),0) as Exemp_Amt,ISNULL(SM.LabChrgs,0) as LabChrgs,ISNULL(SM.OthChrgs,0) as OthChrgs,'
	if @net_op = 1
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + 'ROUND('
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ' (ISNULL(SUM(A.Comp1),0) + ISNULL(SUM(A.TaxAmt),0) + ISNULL(SUM(A.Comp2),0) + ISNULL(SUM(A.Tax_free),0) + '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Exemp_Amt),0) + ISNULL(SM.LabChrgs,0) + ISNULL(SM.OthChrgs,0))'
	if @net_op = 1
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ',0)'
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ' As Gro_Amt FROM (Select ISNULL(STM.Level1,0) as Per,ISNULL(AC.S_Tax,'''') as S_Tax,ISNULL(AC.U_PSI,0) as U_PSI,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(AC.St_type,'''') as St_type,CASE WHEN ISNULL(' + CASE WHEN @stax_item = 0 THEN 'A' ELSE 'D' END + '.U_Imporm,'''') = ''Composition u/s 42(3) or (3A)'' THEN'
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
	SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(A.Tot_tax,0) + ISNULL(A.tot_add,0) - ISNULL(A.Tot_deduc,0) ELSE CASE WHEN ISNULL(A.tax_name,'''') <> '''' AND '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(A.tax_name,'''') NOT like ''%Exempted%'' AND ISNULL(' + CASE WHEN @stax_item = 0 THEN 'A' ELSE 'D' END + '.U_Imporm,'''') <> ''Composition u/s 42 (1) or (2) or (4)'' '
	SET @SQLCOMMAND = @SQLCOMMAND + ' THEN ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
	SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(A.Tot_tax,0) + ISNULL(A.tot_add,0) - ISNULL(A.Tot_deduc,0) ELSE 0 END end as Comp1,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN ISNULL(A.tax_name,'''') <> '''' AND ISNULL(A.tax_name,'''') NOT like ''%Exempted%'' THEN '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.TaxAmt),0) '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ELSE 0 END as TaxAmt,CASE WHEN ISNULL(' + CASE WHEN @stax_item = 0 THEN 'A' ELSE 'D' END + '.U_Imporm,'''') = ''Composition u/s 42 (1) or (2) or (4)'' THEN '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
	SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(A.Tot_tax,0) + ISNULL(A.tot_add,0) - ISNULL(A.Tot_deduc,0) ELSE 0 end as Comp2,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN ISNULL(STM.Level1,0) = 0 AND (ISNULL(A.tax_name,'''') = '''' OR ISNULL(A.tax_name,'''') like ''%Exempted%'') AND '
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(' + CASE WHEN @stax_item = 0 THEN 'A' ELSE 'D' END + '.U_Imporm,'''') NOT IN (''Exempted Sales u/s 41 & 8'',''Composition u/s 42(3) or (3A)'','
	SET @SQLCOMMAND = @SQLCOMMAND + ' ''Composition u/s 42 (1) or (2) or (4)'') THEN ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
	SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(A.Tot_tax,0) + ISNULL(A.tot_add,0) - ISNULL(A.Tot_deduc,0) ELSE 0 END as Tax_free,CASE WHEN ISNULL(' + CASE WHEN @stax_item = 0 THEN 'A' ELSE 'D' END + '.U_Imporm,'''') = ''Exempted Sales u/s 41 & 8'' '
	SET @SQLCOMMAND = @SQLCOMMAND + ' AND ISNULL(A.tax_name,'''') like ''%Exempted%'' THEN ISNULL(SUM(A.Gro_Amt),0) - ' + CASE WHEN @stax_item = 0 THEN '0' ELSE 'ISNULL(SUM(A.TaxAmt),0)' END
	SET @SQLCOMMAND = @SQLCOMMAND + ' + ISNULL(A.Tot_tax,0) + ISNULL(A.tot_add,0) - ISNULL(A.Tot_deduc,0) ELSE 0 END as Exemp_Amt,ISNULL(A.Entry_ty,'''') as Entry_ty,ISNULL(A.inv_sr,'''') as inv_sr,ISNULL(A.Inv_no,'''') as Inv_no,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(A.Date,'''') as Date,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL(tc.Tran_cd,'''') as Tran_cd,ISNULL(tc.Tran_desc,'''') as Tran_desc FROM ' + CASE WHEN @stax_item = 0 THEN 'CNMAIN' ELSE 'CNITEM' END + ' A '
	if @stax_item = 1
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + 'INNER JOIN CNMAIN D ON (A.Entry_ty = D.Entry_ty AND A.Tran_cd = D.Tran_cd AND A.inv_sr = D.inv_sr AND A.inv_no = D.Inv_no) '
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ' LEFT OUTER JOIN STAX_MAS STM ON (A.TAX_NAME = STM.TAX_NAME And A.Entry_ty = STM.Entry_ty) '
	SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN VATCDMST tc on (REPLACE(REPLACE(LTRIM(rtrim(tc.Tran_cd)) + LTRIM(rtrim(tc.Tran_desc)),'' '',''''),''-'','''') '
	SET @SQLCOMMAND = @SQLCOMMAND + ' = REPLACE(REPLACE(LTRIM(rtrim(' + CASE WHEN @stax_item = 0 THEN 'A' ELSE 'D' END + '.VATTYPECD)),''-'',''''),'' '','''') AND tc.Entry_ty = A.Entry_Ty) '
	SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN Ac_Mast AC on (A.Ac_Id = AC.Ac_id) WHERE A.Entry_ty IN('''+ @Bhent + ''') '
	SET @SQLCOMMAND = @SQLCOMMAND + ' AND (A.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
	SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_ty,A.inv_sr,A.Inv_no,A.Date,' + CASE WHEN @stax_item = 0 THEN 'A' ELSE 'D' END + '.U_Imporm,A.tax_name,STM.Level1,tc.Tran_cd,tc.Tran_desc,'
	SET @SQLCOMMAND = @SQLCOMMAND + ' AC.S_Tax,AC.St_type,AC.U_PSI,A.Tot_tax,A.Tot_nontax,A.tot_add,A.Tot_fdisc,A.Tot_deduc'
	SET @SQLCOMMAND = @SQLCOMMAND + CASE WHEN @stax_item = 0 THEN ',A.TaxAmt' ELSE ',D.TAXAMT' END + ') A '

	IF EXISTS(select DISTINCT Entry_ty from DCMAST where Entry_ty IN(@Bhent))
	BEGIN
		IF @HeadDetail = 1
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN (SELECT A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,ISNULL(A.' + RTRIM(LTRIM(@Fld_name)) + ',0) as LabChrgs, '
			SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL((A.Tot_nontax + '
			IF EXISTS(SELECT * FROM sys.columns  WHERE Name = N'u_rg23cno' AND Object_ID = Object_ID(N'CNMAIN'))
			BEGIN
			   SET @FldExits = 'TRUE'
			   SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN LTRIM(RTRIM(A.u_rg23cno)) = '''' THEN 0 ELSE 0 END) - '
			END
			ELSE
			BEGIN
				SET @SQLCOMMAND = @SQLCOMMAND + ' 0) - '
				SET @FldExits = 'FALSE'
			END
			SET @SQLCOMMAND = @SQLCOMMAND + ' (A.Tot_fdisc),0) - ISNULL(A.'
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) + ISNULL(SUM(B.tot_nontax),0) as OthChrgs FROM CNMAIN A '
			SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN CNITEM B ON (A.Entry_Ty = B.Entry_ty AND A.inv_sr = B.inv_sr AND A.INV_NO = B.inv_no AND A.TRAN_CD = B.Tran_cd)'
			SET @SQLCOMMAND = @SQLCOMMAND + ' WHERE A.VATTYPECD <> '' '' AND A.Entry_Ty IN('''+ @Bhent + ''') AND  '
			SET @SQLCOMMAND = @SQLCOMMAND + ' (A.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
			SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,A.ULABCHRGS,A.Tot_nontax,A.Tot_fdisc'
			IF @FldExits = 'TRUE'
			BEGIN
				SET @SQLCOMMAND = @SQLCOMMAND + ',A.u_rg23cno '
			END
			SET @SQLCOMMAND = @SQLCOMMAND + ')SM ON (A.Entry_ty = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + 'INNER JOIN (SELECT Entry_ty,inv_sr,Inv_no,Tran_cd,Date,ISNULL(SUM((Tot_nontax) - (Tot_fdisc)),0) - ISNULL(SUM('
			SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + '),0) + ISNULL(SUM(tot_nontax),0) as OthChrgs FROM CNITEM WHERE VATTYPECD <> '' '' AND '
			SET @SQLCOMMAND = @SQLCOMMAND + ' Entry_Ty IN('''+ @Bhent + ''') AND (DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
			SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY Entry_ty,inv_sr,Inv_no,Tran_cd,Date '
			SET @SQLCOMMAND = @SQLCOMMAND + ' )SM ON (A.Entry_ty = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
		END
	END
	ELSE
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN (SELECT A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,ISNULL(A.' + RTRIM(LTRIM(@Fld_name)) + ',0) as LabChrgs, '
		SET @SQLCOMMAND = @SQLCOMMAND + ' ISNULL((A.Tot_nontax + '
		IF EXISTS(SELECT * FROM sys.columns  WHERE Name = N'u_rg23cno' AND Object_ID = Object_ID(N'CNMAIN'))
		BEGIN
		   SET @FldExits = 'TRUE'
		   SET @SQLCOMMAND = @SQLCOMMAND + ' CASE WHEN LTRIM(RTRIM(A.u_rg23cno)) = '''' THEN 0 ELSE 0 END) - '
		END
		ELSE
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + ' ) - '
			SET @FldExits = 'FALSE'
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ' (A.Tot_fdisc),0) - ISNULL(A.'
		SET @SQLCOMMAND = @SQLCOMMAND + RTRIM(LTRIM(@Fld_name)) + ',0) + ISNULL(SUM(B.tot_nontax),0) as OthChrgs FROM CNMAIN A '
		SET @SQLCOMMAND = @SQLCOMMAND + ' INNER JOIN CNITEM B ON (A.Entry_Ty = B.Entry_ty AND A.inv_sr = B.inv_sr AND A.INV_NO = B.inv_no AND A.TRAN_CD = B.Tran_cd)'
		SET @SQLCOMMAND = @SQLCOMMAND + ' WHERE A.VATTYPECD <> '' '' AND A.Entry_Ty IN('+@Bhent+') AND  '
		SET @SQLCOMMAND = @SQLCOMMAND + ' (A.DATE BETWEEN '''+cast(@SDATE as varchar(11))+''' AND '''+cast(@EDATE as varchar(11))+''')'
		SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_ty,A.inv_sr,A.Inv_no,A.Tran_cd,A.Date,A.ULABCHRGS,A.Tot_nontax,A.Tot_fdisc'
		IF @FldExits = 'TRUE'
		BEGIN
			SET @SQLCOMMAND = @SQLCOMMAND + ',A.u_rg23cno '
		END
		SET @SQLCOMMAND = @SQLCOMMAND + ')SM ON (A.Entry_ty = SM.Entry_ty AND A.inv_sr = SM.inv_sr AND A.INV_NO = SM.inv_no AND A.Date = SM.date) '
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ' GROUP BY A.Entry_ty,A.inv_sr,A.Inv_no,A.Date,A.S_Tax,A.U_PSI,A.St_type,A.Tran_cd,A.Tran_desc '
	IF EXISTS(select DISTINCT Entry_ty from DCMAST where Entry_ty IN(@Bhent))
	BEGIN
		SET @SQLCOMMAND = @SQLCOMMAND + ',LabChrgs,OthChrgs'
	END
	SET @SQLCOMMAND = @SQLCOMMAND + ' ) B ORDER BY Tran_cd,Tran_desc,Date,Inv_no,S_Tax '
	PRINT @SQLCOMMAND
	EXECUTE sp_executesql @SQLCOMMAND
	SET @LnVar = @LnVar + 1
END

Select @AMTA1 = ISNULL(SUM(Amt1),0),@AMTA2 = ISNULL(SUM(Amt2),0),@AMTA3 = ISNULL(SUM(Amt3),0),@AMTA4 = ISNULL(SUM(Amt4),0),@AMTA5 = ISNULL(SUM(Amt5),0),
	   @AMTA6 = ISNULL(SUM(Amt6),0),@AMTA7 = ISNULL(SUM(Amt7),0),@AMTA8 = ISNULL(SUM(Amt8),0),@AMTA9 = ISNULL(SUM(Amt9),0) FROM #MHSALSANNEX

Update #MHSALSANNEX SET Amt1 = @AMTA1,Amt2 = @AMTA2,Amt3 = @AMTA3,Amt4 = @AMTA4,Amt5 = @AMTA5,Amt6 = @AMTA6,Amt7 = @AMTA7,Amt8 = @AMTA8,Amt9 = @AMTA9
WHERE PART = 1 AND PARTSR = '1'

SELECT PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,AMT4,AMT5,AMT6,AMT7,AMT8,AMT9,INV_NO,DATE,Tran_cd,Tran_Desc,RAction,Ret_Frm_no,S_TAX FROM 
#MHSALSANNEX order by Tran_cd,Tran_desc,cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int),date,Inv_no

END