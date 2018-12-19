if exists(select XTYPE,name from sysobjects where xtype='p' and name ='USP_REP_HR_FORMLS2')
begin
	drop procedure USP_REP_HR_FORMLS2
end
go 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXECUTE USP_REP_HR_FORMLS2'','','','04/01/2015','03/31/2016','','','','',0,0,'','','','','','','','','2015-2016',''
*/
-- =============================================
-- Author:		Hetal L Patel
-- Create date: 16/05/2007
-- Description:	This Stored procedure is useful to generate HR VAT FORM LS 02
-- Modify date: 16/05/2007
-- Modified By: Sandeep Shah
-- Modify date: 30/11/2010
-- Remark:Modified store procedure with valid Data of the format
-- Modified By: Sandeep Shah
-- Modify date: 13/12/2010
-- Remark:Modified store procedure for VAT Multicompany.
-- Modified By: Suraj Kumawat
-- Modify date: 14/05/2015
-- Remark:as per new storeprocedure related vattbl .
-- =============================================
create PROCEDURE [dbo].[USP_REP_HR_FORMLS2]
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
/*Commneted by Suraj Kumawat date on 14-05-2015 sTART*/
--DECLARE @FCON AS NVARCHAR(2000)
--EXECUTE   USP_REP_FILTCON 

--@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
--,@VSDATE=NULL,@VEDATE=@EDATE
--,@VSAC =@SAC,@VEAC =@EAC
--,@VSIT=@SIT,@VEIT=@EIT
--,@VSAMT=@SAMT,@VEAMT=@EAMT
--,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
--,@VSCATE =@SCATE,@VECATE =@ECATE
--,@VSWARE =@SWARE,@VEWARE  =@EWARE
--,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
--,@VMAINFILE='M',@VITFILE=Null,@VACFILE='AC'
--,@VDTFLD ='DATE'
--,@VLYN=Null
--,@VEXPARA=@EXPARA
--,@VFCON =@FCON OUTPUT
/*Commneted by Suraj Kumawat date on 14-05-2015 End*/

--DECLARE @SQLCOMMAND NVARCHAR(4000)
DECLARE @RATE NUMERIC(12,2),@AMTA1 NUMERIC(12,2),@AMTB1 NUMERIC(12,2),@AMTC1 NUMERIC(12,2),@AMTD1 NUMERIC(12,2),@AMTE1 NUMERIC(12,2),@AMTF1 NUMERIC(12,2),@AMTG1 NUMERIC(12,2),@AMTH1 NUMERIC(12,2),@AMTI1 NUMERIC(12,2),@AMTJ1 NUMERIC(12,2),@AMTK1 NUMERIC(12,2),@AMTL1 NUMERIC(12,2),@AMTM1 NUMERIC(12,2),@AMTN1 NUMERIC(12,2),@AMTO1 NUMERIC(12,2)
--DECLARE @AMTA2 NUMERIC(12,2),@AMTB2 NUMERIC(12,2),@AMTC2 NUMERIC(12,2),@AMTD2 NUMERIC(12,2),@AMTE2 NUMERIC(12,2),@AMTF2 NUMERIC(12,2),@AMTG2 NUMERIC(12,2),@AMTH2 NUMERIC(12,2),@AMTI2 NUMERIC(12,2),@AMTJ2 NUMERIC(12,2),@AMTK2 NUMERIC(12,2),@AMTL2 NUMERIC(12,2),@AMTM2 NUMERIC(12,2),@AMTN2 NUMERIC(12,2),@AMTO2 NUMERIC(12,2)
DECLARE @PER NUMERIC(12,2),@TAXAMT NUMERIC(12,2),@CHAR INT,@LEVEL NUMERIC(12,2)
/*Commented by suraj Kumawat on date 14-05-2015 start*/
--SELECT DISTINCT AC_NAME=SUBSTRING(AC_NAME1,2,CHARINDEX('"',SUBSTRING(AC_NAME1,2,100))-1) INTO #VATAC_MAST FROM STAX_MAS WHERE AC_NAME1 NOT IN ('"SALES"','"PURCHASES"') AND ISNULL(AC_NAME1,'')<>''
--INSERT INTO #VATAC_MAST SELECT DISTINCT AC_NAME=SUBSTRING(AC_NAME1,2,CHARINDEX('"',SUBSTRING(AC_NAME1,2,100))-1) FROM STAX_MAS WHERE AC_NAME1 NOT IN ('"SALES"','"PURCHASES"') AND ISNULL(AC_NAME1,'')<>''
 --Declare @NetEff as numeric (12,2), @NetTax as numeric (12,2)
/*Commented by suraj Kumawat on date 14-05-2015 end*/
----Temporary Cursor1
SELECT BHENT='PT',M.INV_NO,M.Date,A.AC_NAME,A.AMT_TY,STM.TAX_NAME,SET_APP=ISNULL(SET_APP,0),STM.ST_TYPE,M.NET_AMT,M.GRO_AMT,TAXONAMT=M.GRO_AMT+M.TOT_DEDUC+M.TOT_TAX+M.TOT_EXAMT+M.TOT_ADD,PER=STM.LEVEL1,MTAXAMT=M.TAXAMT,TAXAMT=A.AMOUNT,STM.FORM_NM,PARTY_NM=AC1.AC_NAME,AC1.S_TAX,M.U_IMPORM
,ADDRESS=LTRIM(AC1.ADD1)+ ' ' + LTRIM(AC1.ADD2) + ' ' + LTRIM(AC1.ADD3),M.TRAN_CD,VATONAMT=99999999999.99,Dbname=space(20),ItemType=space(1),It_code=999999999999999999-999999999999999999,ItSerial=Space(5)
INTO #FORM_LS2
FROM PTACDET A 
INNER JOIN PTMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2 --A.AC_NAME IN ( SELECT AC_NAME FROM #VATAC_MAST)
alter table #FORM_LS2 add recno int identity

---Temporary Cursor2
/*Commented by Suraj Kumawat date on 14-05-2015 Start*/
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=99.999,AMT1=NET_AMT,AMT2=M.TAXAMT,AMT3=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),
STM.FORM_NM,AC1.S_TAX,Item=space(50),Qty=9999999999999999999.9999--,PINV_NO=space(20)
INTO #FORMLS2
FROM PTACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2
/*Commented by Suraj Kumawat date on 14-05-2015 Start*/
Declare @MCON as NVARCHAR(2000)
/*Commented by Suraj Kumawat date on 14-05-2015 Start*/
--Declare @MultiCo	VarChar(3)
--Declare @MCON as NVARCHAR(2000)
--IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
--	Begin	------Fetch Records from Multi Co. Data
--		 Set @MultiCo = 'YES'
--		 EXECUTE USP_REP_MULTI_CO_DATA
--		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
--		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
--		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
--		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
--		 ,@MFCON = @MCON OUTPUT

--		--SET @SQLCOMMAND='Select * from '+@MCON
--		---EXECUTE SP_EXECUTESQL @SQLCOMMAND
--		SET @SQLCOMMAND='Insert InTo  #FORM_LS2 Select * from '+@MCON
--		EXECUTE SP_EXECUTESQL @SQLCOMMAND
--		---Drop Temp Table 
--		SET @SQLCOMMAND='Drop Table '+@MCON
--		EXECUTE SP_EXECUTESQL @SQLCOMMAND

--	End
--else
--	Begin ------Fetch Single Co. Data
--		 Set @MultiCo = 'NO'
--		 EXECUTE USP_REP_SINGLE_CO_DATA
--		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
--		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
--		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
--		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
--		 ,@MFCON = @MCON OUTPUT

--		--SET @SQLCOMMAND='Select * from '+@MCON
--		---EXECUTE SP_EXECUTESQL @SQLCOMMAND
--		SET @SQLCOMMAND='Insert InTo #FORM_LS2 Select * from '+@MCON
--		EXECUTE SP_EXECUTESQL @SQLCOMMAND
--		---Drop Temp Table 
--		SET @SQLCOMMAND='Drop Table '+@MCON
--		EXECUTE SP_EXECUTESQL @SQLCOMMAND

--	End
/*Commented by Suraj Kumawat date on 14-05-2015 End*/

/*Added by Suraj Kumawat date on 14-05-2015*/
 EXECUTE USP_REP_SINGLE_CO_DATA_VAT
  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
 ,@MFCON = @MCON OUTPUT

-----
-----SELECT * from #form221_1 where (Date Between @Sdate and @Edate) and Bhent in('EP','PT','CN') and TAX_NAME In('','NO-TAX') and U_imporm = ''
-----
/*Commneted by Suraj Kumawat date on 14-05-2015 Start*/
--SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0 
--SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0 
/*Commneted by Suraj Kumawat date on 14-05-2015 End*/
SET @CHAR=65
Declare @TAXONAMT as numeric(12,2),@TAXAMT1 as numeric(12,2),@ITEMAMT as numeric(12,2),@INV_NO as varchar(10),@DATE as smalldatetime,@PARTY_NM as varchar(50),@ADDRESS as varchar(100),@ITEM as varchar(50),@FORM_NM as varchar(30),@S_TAX as varchar(30),@QTY as numeric(18,4),@PINV_NO AS VARCHAR(20)
SELECT @TAXONAMT=0,@TAXAMT1 =0,@ITEMAMT =0,@PINV_NO='',@INV_NO ='',@DATE ='',@PARTY_NM ='',@ADDRESS ='',@ITEM ='',@FORM_NM='',@S_TAX ='',@QTY=0
--Part LS -1 
SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0 
SET @CHAR=65
SELECT @TAXONAMT=0,@TAXAMT1 =0,@ITEMAMT =0,@PINV_NO='',@INV_NO ='',@DATE ='',@PARTY_NM ='',@ADDRESS ='',@ITEM ='',@FORM_NM='',@S_TAX ='',@QTY=0
--PART 1
/*Commented by suraj Kumawat date on 15-05-2015 Start*/
--Declare cur_formls2bb cursor for
--SELECT distinct A.PER,TAXONAMT=VATONAMT,A.TAXAMT,ITEMAMT=e.gro_amt,A.INV_NO,A.DATE,A.PARTY_NM,ADDRESS=RTRIM (SAC.MAILNAME)+' '+rTRIM(SAC.ADD1)+' '+RTRIM(SAC.ADD2)+'  '+RTRIM(SAC.ADD3),E.ITEM,H.FORM_NO,A.S_TAX,E.QTY
--FROM #FORM_LS2 A
--Inner Join VATITEM_VW e On(A.Bhent = e.Entry_ty And A.Tran_cd = e.Tran_cd and a.it_code=e.it_code and a.itserial=e.itserial)
--INNER JOIN VATMAIN_VW H ON A.BHENT=H.ENTRY_TY AND A.TRAN_CD=H.TRAN_cD
--INNER JOIN AC_MAST SAC ON SAC.AC_ID =H.AC_ID
--inner join stax_mas st on (st.tax_name=A.tax_name)
--WHERE A.ST_TYPE='OUT OF STATE' AND A.BHENT='ST'  AND (A.DATE BETWEEN @SDATE AND @EDATE)
--ORDER BY A.INV_NO
/*Commneted by suraj kumawat date on 15-05-2015 end */

/*Added by suraj kumawat date on 15-05-2015 Start */
Declare cur_formls2bb cursor for
SELECT  A.PER,TAXONAMT=A.VATONAMT,A.TAXAMT,ITEMAMT=A.gro_amt,A.INV_NO,A.DATE,PARTY_NM=A.AC_NAME,A.ADDRESS,c.It_name,d.FORM_NO,A.S_TAX,b.QTY
FROM VATTBL A
Inner Join stitem b  On(A.Bhent = b.Entry_ty And A.Tran_cd = b.Tran_cd and a.it_code=b.it_code and a.itserial=b.itserial)
INNER JOIN it_mast c ON ( b.it_code=c.it_code)
left outer join stmain d on (b.tran_cd=d.tran_cd and b.entry_ty=d.entry_ty)
WHERE A.ST_TYPE='OUT OF STATE' AND A.BHENT='ST'  AND (A.DATE BETWEEN @SDATE AND @EDATE) AND A.RFORM_NM IN ('FORM C','C FORM','C','FORM-C','C-FORM','FORM - C','C - FORM')
ORDER BY A.INV_NO
/*Added by suraj kumawat date on 15-05-2015 End */
OPEN CUR_FORMLS2bb
FETCH NEXT FROM CUR_FORMLS2bb INTO @PER,@TAXONAMT,@TAXAMT,@ITEMAMT,@INV_NO,@DATE,@PARTY_NM,@ADDRESS,@ITEM,@FORM_NM,@S_TAX,@QTY
WHILE (@@FETCH_STATUS=0)
BEGIN
	SET @PER=CASE WHEN @PER IS NULL THEN 0 ELSE @PER END
	SET @TAXONAMT=CASE WHEN @TAXONAMT IS NULL THEN 0 ELSE @TAXONAMT END
	SET @TAXAMT=CASE WHEN @TAXAMT IS NULL THEN 0 ELSE @TAXAMT END
	SET @ITEMAMT=CASE WHEN @ITEMAMT IS NULL THEN 0 ELSE @ITEMAMT END
	SET @QTY=CASE WHEN @QTY IS NULL THEN 0 ELSE @QTY END
	SET @PARTY_NM=CASE WHEN @PARTY_NM IS NULL THEN '' ELSE @PARTY_NM END
	SET @PINV_NO=CASE WHEN @PINV_NO IS NULL THEN '' ELSE @PINV_NO END
	SET @INV_NO=CASE WHEN @INV_NO IS NULL THEN '' ELSE @INV_NO END
	SET @DATE=CASE WHEN @DATE IS NULL THEN '' ELSE @DATE END
	SET @ADDRESS=CASE WHEN @ADDRESS IS NULL THEN '' ELSE @ADDRESS END
	SET @ITEM=CASE WHEN @ITEM IS NULL THEN '' ELSE @ITEM END
	SET @S_TAX=CASE WHEN @S_TAX IS NULL THEN '' ELSE @S_TAX END
	SET @FORM_NM=CASE WHEN @FORM_NM IS NULL THEN '' ELSE @FORM_NM END
	INSERT INTO #FORMLS2 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,ITEM,FORM_NM,S_TAX,Qty)
	VALUES (1,'2',CHAR(@CHAR),@PER,@ITEMAMT,@TAXAMT,@TAXONAMT,@INV_NO,@DATE,@PARTY_NM,@ADDRESS,@ITEM,@FORM_NM,@S_TAX,@QTY)
	SET @CHAR=@CHAR+1
	FETCH NEXT FROM CUR_FORMLS2bb INTO @PER,@TAXONAMT,@TAXAMT,@ITEMAMT,@INV_NO,@DATE,@PARTY_NM,@ADDRESS,@ITEM,@FORM_NM,@S_TAX,@QTY
END
CLOSE CUR_FORMLS2bb
DEALLOCATE CUR_FORMLS2bb

IF NOT EXISTS(SELECT TOP 1 PART FROM #FORMLS2 WHERE PART=1)
BEGIN
	INSERT INTO #FORMLS2 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,ITEM,FORM_NM,S_TAX,Qty)
  VALUES (1,'2',CHAR(@CHAR),0,@TAXONAMT,@TAXAMT,@ITEMAMT,@INV_NO,@DATE,@PARTY_NM,@ADDRESS,@ITEM,@FORM_NM,@S_TAX,@QTY)
END

--PART 2 
--PART TWO IS  PENDING 
IF NOT EXISTS(SELECT TOP 1 PART FROM #FORMLS2 WHERE PART=2)
BEGIN
	INSERT INTO #FORMLS2 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,ITEM,FORM_NM,S_TAX,Qty)
  VALUES (2,'2',CHAR(@CHAR),0,0,0,0,'','','','','','','',0)
END

Update #formLS2 set  PART = isnull(Part,0) , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
		             RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), 
					 AMT3 = isnull(AMT3,0), INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''), 
					 PARTY_NM = isnull(Party_nm,''), ADDRESS = isnull(Address,''),
					 FORM_NM = isnull(form_nm,''), S_TAX = isnull(S_tax,'')--, Qty = isnull(Qty,0),  ITEM =isnull(item,''),


SELECT * FROM #FORMLS2 order by cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int)
END
--Print 'HR VAT FORM LS 02'
