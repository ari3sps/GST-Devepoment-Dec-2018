If exists(Select * from sysobjects where [name]='USP_REP_MHFORM704_LETTER_OF_SUBMISSION' and xtype='P')
Begin
	Drop Procedure USP_REP_MHFORM704_LETTER_OF_SUBMISSION
End
go

-- =============================================
-- Author:		Pankaj M Borse.
-- Create date: 23/08/2014
-- Description:	This Stored procedure is useful to generate MH VAT FORM 704 Letter Of Submission
-- Modify date: 23/08/2014
-- =============================================
CREATE PROCEDURE [dbo].[USP_REP_MHFORM704_LETTER_OF_SUBMISSION]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(500)= null
AS
BEGIN
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
,@VMAINFILE='M',@VITFILE=NULL,@VACFILE=NULL
,@VDTFLD ='DATE'
,@VLYN=NULL
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT
print '123'
print @EXPARA
Declare @AUDIT_NM varchar(50),@CERTI_BY varchar(50),@Auditor_Firm varchar(50),@Transation_Id varchar(15),@N_autho VARCHAR(50),@Designation VARCHAR(25)
Declare @POS INT,@Emailid varchar(30),@mobileno varchar(10),@Place varchar(15),@Audit_DT varchar(10)
if(charindex('[Auditor_name=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX(']',@EXPARA)
	SET @AUDIT_NM=SUBSTRING(@EXPARA,15,@POS-15)
end 	
PRINT len(RTRIM(@EXPARA))
if(charindex('[Certified_By=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[Certified_By=',@EXPARA)
	SET @CERTI_BY=SUBSTRING(@EXPARA,@POS+14,CHARINDEX(']',@EXPARA,@pos)-(@pos+14))
end 

if(charindex('[Auditor_Firm=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[Auditor_Firm=',@EXPARA)
	SET @Auditor_Firm=SUBSTRING(@EXPARA,@POS+14,CHARINDEX(']',@EXPARA,@pos)-(@pos+14))
end 

if(charindex('[Transation_Id=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[Transation_Id=',@EXPARA)
	SET @Transation_Id=SUBSTRING(@EXPARA,@POS+15,CHARINDEX(']',@EXPARA,@pos)-(@pos+15))
end 

if(charindex('[N_autho=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[N_autho=',@EXPARA)
	SET @N_autho=SUBSTRING(@EXPARA,@POS+9,CHARINDEX(']',@EXPARA,@pos)-(@pos+9))
end 

if(charindex('[Designation=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[Designation=',@EXPARA)
	SET @Designation=SUBSTRING(@EXPARA,@POS+13,CHARINDEX(']',@EXPARA,@pos)-(@pos+13))
end 
if(charindex('[Emailid=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[Emailid=',@EXPARA)
	SET @Emailid=SUBSTRING(@EXPARA,@POS+9,CHARINDEX(']',@EXPARA,@pos)-(@pos+9))
end 
if(charindex('[mobileno=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[mobileno=',@EXPARA)
	SET @mobileno=SUBSTRING(@EXPARA,@POS+10,CHARINDEX(']',@EXPARA,@pos)-(@pos+10))
end 

if(charindex('[Place=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[Place=',@EXPARA)
	SET @Place=SUBSTRING(@EXPARA,@POS+7,CHARINDEX(']',@EXPARA,@pos)-(@pos+7))
end 
if(charindex('[Audit_DT=',@EXPARA)>0)
begin
	SET @POS=CHARINDEX('[Audit_DT=',@EXPARA)
	SET @Audit_DT=SUBSTRING(@EXPARA,@POS+10,CHARINDEX(']',@EXPARA,@pos)-(@pos+10))
end 
DECLARE @SQLCOMMAND NVARCHAR(4000)
DECLARE @RATE NUMERIC(12,2),@AMTA1 NUMERIC(12,2),@AMTB1 NUMERIC(12,2),@AMTC1 NUMERIC(12,2),@AMTD1 NUMERIC(12,2),@AMTE1 NUMERIC(12,2),@AMTF1 NUMERIC(12,2),@AMTG1 NUMERIC(12,2),@AMTH1 NUMERIC(12,2),@AMTI1 NUMERIC(12,2),@AMTJ1 NUMERIC(12,2),@AMTK1 NUMERIC(12,2),@AMTL1 NUMERIC(12,2),@AMTM1 NUMERIC(12,2),@AMTN1 NUMERIC(12,2),@AMTO1 NUMERIC(12,2)
DECLARE @AMTA2 NUMERIC(12,2),@AMTB2 NUMERIC(12,2),@AMTC2 NUMERIC(12,2),@AMTD2 NUMERIC(12,2),@AMTE2 NUMERIC(12,2),@AMTF2 NUMERIC(12,2),@AMTG2 NUMERIC(12,2),@AMTH2 NUMERIC(12,2),@AMTI2 NUMERIC(12,2),@AMTJ2 NUMERIC(12,2),@AMTK2 NUMERIC(12,2),@AMTL2 NUMERIC(12,2),@AMTM2 NUMERIC(12,2),@AMTN2 NUMERIC(12,2),@AMTO2 NUMERIC(12,2)
DECLARE @PER NUMERIC(12,2),@TAXAMT NUMERIC(12,2),@CHAR INT,@LEVEL NUMERIC(12,2)

Declare @NetEff as numeric (12,2), @NetTax as numeric (12,2)
SELECT PARTSR='AAA',SRNO='AAA',AMT1=CAST('0' AS NUMERIC(20,2)),AMT2=CAST('0' AS NUMERIC(20,2)),AMT3=CAST('0' AS NUMERIC(20,2)),
M.INV_NO,M.DATE,PARTY_NM=AC.AC_NAME,ADDRESS=Ltrim(AC.Add1),ACT=SPACE(10)
INTO #FORM704
FROM PTACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
WHERE 1=2

-- 2.Acceptance of Auditor's Recommendations by the dealer :
-- 2. i) Pay additional tax liability of Rs.
SELECT @AMTA1=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='VAT PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Pay additional tax liability'
SELECT @AMTA2=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='CST PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Pay additional tax liability'
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('2','A',@AMTA1,@AMTA2,'')

-- 2. ii)Pay back excess refund received of Rs.
SELECT @AMTA1=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='VAT PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Pay back excess refund received'
SELECT @AMTA2=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='CST PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Pay back excess refund received'
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('2','B',@AMTA1,@AMTA2,'')

-- 2. iii)Claim additional refund of Rs.			
SELECT @AMTA1=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='VAT PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Claim additional refund'
SELECT @AMTA2=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='CST PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Claim additional refund'
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('2','C',@AMTA1,@AMTA2,'')

-- 2. iv)Reduce the claim of refund  of Rs.			
SELECT @AMTA1=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='VAT PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Reduce the claim of refund'
SELECT @AMTA2=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='CST PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Reduce the claim of refund'
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('2','D',@AMTA1,@AMTA2,'')

-- 2. v)Reduce tax liability of Rs.			
SELECT @AMTA1=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='VAT PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Reduce tax liability'
SELECT @AMTA2=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='CST PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Reduce tax liability'
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('2','E',@AMTA1,@AMTA2,'')


-- 2. vi)Revise closing balance of CQB of Rs.			
SELECT @AMTA1=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='VAT PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Revise closing balance of CQB'
SELECT @AMTA2=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='CST PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Revise closing balance of CQB'
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('2','F',@AMTA1,@AMTA2,'')

-- 2. vii)Pay interest under-section 30(2) of Rs.			
SELECT @AMTA1=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='VAT PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Pay interest under-section 30(2)'
SELECT @AMTA2=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='CST PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Pay interest under-section 30(2)'
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('2','G',@AMTA1,@AMTA2,'')

-- 2. viii)Pay interest under-section 30(4) of Rs. 			
SELECT @AMTA1=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='VAT PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Pay interest under-section 30(4)'
SELECT @AMTA2=ISNULL(SUM(A.NET_AMT),0) FROM JVMAIN A WHERE A.PARTY_NM='CST PAYABLE' AND A.ENTRY_TY='J4' AND A.VAT_ADJ='Pay interest under-section 30(4)'
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('2','H',@AMTA1,@AMTA2,'')

-- 3.Reasons for Non acceptance 
INSERT INTO #FORM704(PARTSR,SRNO,AMT1,AMT2,PARTY_NM) VALUES ('3','a',0,0,'')

-- 4.As a result of the report of audit under section 61, I have paid as follows
INSERT INTO #FORM704(PARTSR,SRNO,INV_NO,AMT1,DATE,PARTY_NM,ADDRESS,ACT)
select '4','',A.U_CHALNO,A.NET_AMT,A.DATE,A.BANK_NM,B.S_TAX,CASE WHEN A.PARTY_NM='VAT PAYABLE' THEN 'VAT' ELSE 'CST' END FROM BPMAIN A
INNER JOIN AC_MAST B ON (A.BANK_NM=B.AC_NAME) 
WHERE A.PARTY_NM IN ('VAT PAYABLE','CST PAYABLE')
 


SELECT AUDIT_NM=@AUDIT_NM,certi_by=@CERTI_BY,Auditor_Firm=@Auditor_Firm,Transation_Id=@Transation_Id,N_autho=@N_autho,
Designation=@Designation,Emailid=@Emailid,mobileno=@mobileno,Place=@Place,Audit_DT=@Audit_DT, * FROM #FORM704
END