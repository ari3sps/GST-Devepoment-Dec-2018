If Exists(Select [name] From SysObjects Where xtype='P' and [Name]='USP_REP_CG_FORM17')
Begin
	Drop Procedure USP_REP_CG_FORM17
End
Go
/*
    EXECUTE USP_REP_CG_FORM17 '','','','04/01/2010','03/31/2019','','','','',0,0,'','','','','','','','','2013-2014',''
*/
CREATE PROCEDURE [dbo].[USP_REP_CG_FORM17]
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
BEGIN
SET NOCOUNT ON
Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2)
EXECUTE  USP_REP_FILTCON 
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

---- Temprory Table Creation.
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=99.999,AMT1=CAST('0' AS NUMERIC(20,2)),AMT2=CAST('0' AS NUMERIC(20,2)),AMT3=CAST('0' AS NUMERIC(20,2)),
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),STM.FORM_NM,AC1.S_TAX
,STM.RFORM_NM,CAST('0' AS NUMERIC(20,2)) AS AMT4,CAST('0' AS NUMERIC(20,2)) AS AMT5 
,TAX_NAME=CAST('' AS VARCHAR(12)),n.item,EIT_NAME=CAST('' AS VARCHAR(50)),CONTTAX=CAST(0 AS DECIMAL(12,2)),CTYPE=CAST('' AS VARCHAR(2)) 
INTO #VAT__CG_FORM17
FROM PTACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
inner join stitem n on (m.tran_cd=n.tran_cd) 
WHERE 1=2

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

	End
else
	Begin ------Fetch Single Co. Data
		 Set @MultiCo = 'NO'
		 EXECUTE USP_REP_SINGLE_CO_DATA_vat
		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		 ,@MFCON = @MCON OUTPUT

	End


DECLARE @AMTA1 DECIMAL(18,2),@AMTA2 DECIMAL(18,2),@AMTA3 DECIMAL(18,2),@AMTA4 DECIMAL(18,2),@AMTA5 DECIMAL(18,2)
---1. Turnover
SET @AMTA1 = 0
SELECT @AMTA1 =ISNULL(SUM(case when bhent ='st' then GRO_AMT else -GRO_AMT end),0) FROM VATTBL WHERE BHENT in('ST','sr','cn') AND (DATE BETWEEN @SDATE AND @EDATE ) and ST_TYPE ='Out of state'  and tax_name like '%C.S.T%' AND PER = 2 
SET @AMTA2 = 0
SELECT @AMTA2 =ISNULL(SUM(case when bhent ='st' then GRO_AMT else -GRO_AMT end),0) FROM VATTBL WHERE BHENT in('ST','sr','cn') AND (DATE BETWEEN @SDATE AND @EDATE ) and ST_TYPE ='Out of state'  AND PER <> 2 
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','A',0,@AMTA1,@AMTA2,0,'')
---2. Taxable turnover
SET @AMTA1 = 0
SELECT @AMTA1 =ISNULL(SUM(case when bhent ='st' then GRO_AMT else -GRO_AMT end),0) FROM VATTBL WHERE BHENT in('ST','sr','cn') AND (DATE BETWEEN @SDATE AND @EDATE )  and  ST_TYPE ='Out of state'  and tax_name like '%C.S.T%' AND PER = 2  AND TAXAMT <> 0
SET @AMTA2 = 0
SELECT @AMTA2 =ISNULL(SUM(case when bhent ='st' then GRO_AMT else -GRO_AMT end),0) FROM VATTBL WHERE BHENT in('ST','sr','cn') AND (DATE BETWEEN @SDATE AND @EDATE ) and ST_TYPE ='Out of state'   AND TAXAMT <> 0 AND PER <> 2 and tax_name like '%C.S.T%'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','B',0,@AMTA1,@AMTA2,0,'')  
---3. Tax payable
SET @AMTA1 = 0
SELECT @AMTA1 =ISNULL(SUM(case when bhent ='st' then TAXAMT  else -TAXAMT  end),0) FROM VATTBL WHERE BHENT in('ST','sr','cn') AND (DATE BETWEEN @SDATE AND @EDATE )  and ST_TYPE ='Out of state'   and tax_name like '%C.S.T%' AND PER = 2 
AND U_IMPORM !='Tax payable under section 13(5)' AND TAXAMT <> 0
SET @AMTA2 = 0
SELECT @AMTA2 =ISNULL(SUM(case when bhent ='st' then TAXAMT  else -TAXAMT  end),0) FROM VATTBL WHERE BHENT in('ST','sr','cn') AND (DATE BETWEEN @SDATE AND @EDATE )  and ST_TYPE ='Out of state'   AND PER <> 2  and tax_name like '%C.S.T%'
AND U_IMPORM !='Tax payable under section 13(5)' AND TAXAMT <> 0
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','C',0,@AMTA1,@AMTA2,0,'')  
---4. Tax payable under section 13(5)
SET @AMTA1 = 0
SELECT @AMTA1 =ISNULL(SUM(case when bhent ='st' then TAXAMT  else -TAXAMT  end),0) FROM VATTBL WHERE BHENT in('ST','sr','CN') AND (DATE BETWEEN @SDATE AND @EDATE )  and ST_TYPE ='Out of state' and U_IMPORM ='Tax payable under section 13(5)'   and tax_name like '%C.S.T%' AND PER = 2 AND TAXAMT <> 0 
SET @AMTA2 = 0
SELECT @AMTA2 =ISNULL(SUM(case when bhent ='st' then TAXAMT  else -TAXAMT  end),0) FROM VATTBL WHERE BHENT in('ST','sr','CN') AND (DATE BETWEEN @SDATE AND @EDATE ) and ST_TYPE ='Out of state'  and U_IMPORM ='Tax payable under section 13(5)'  AND PER <> 2 AND TAXAMT <> 0  and tax_name like '%C.S.T%'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','D',0,@AMTA1,@AMTA2,0,'')  
---5. Taxable purchase price
SET @AMTA1 = 0
SELECT @AMTA1 =ISNULL(SUM(case when bhent ='PT' then VATONAMT  else -VATONAMT  end),0) FROM VATTBL WHERE BHENT in('PT','Pr','DN') AND (DATE BETWEEN @SDATE AND @EDATE ) and ST_TYPE ='Out of state'   and tax_name like '%C.S.T%' AND PER = 2
SET @AMTA2 = 0
SELECT @AMTA2 =ISNULL(SUM(case when bhent ='PT' then VATONAMT  else -VATONAMT  end),0) FROM VATTBL WHERE BHENT in('PT','PR','DN') AND (DATE BETWEEN @SDATE AND @EDATE ) and ST_TYPE ='Out of state'    AND PER <> 2  and tax_name like '%C.S.T%'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','E',0,@AMTA1,@AMTA2,0,'') 
---6.Purchase tax payable
SET @AMTA1 = 0
SELECT @AMTA1 =ISNULL(SUM(case when bhent ='PT' then TAXAMT  else -TAXAMT  end),0) FROM VATTBL WHERE BHENT in('PT','PR','DN') AND (DATE BETWEEN @SDATE AND @EDATE ) and ST_TYPE ='Out of state'    and tax_name like '%C.S.T%' AND PER = 2
SET @AMTA2 = 0
SELECT @AMTA2 =ISNULL(SUM(case when bhent ='PT' then TAXAMT  else -TAXAMT  end),0) FROM VATTBL WHERE BHENT in('PT','PR','DN') AND (DATE BETWEEN @SDATE AND @EDATE ) and ST_TYPE ='Out of state'    AND PER <> 2  and tax_name like '%C.S.T%'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','F',0,@AMTA1,@AMTA2,0,'')  
---7. Total tax payable
SET @AMTA1 = 0
SET @AMTA2 = 0
SET @AMTA3 = 0
SET @AMTA4 = 0
SELECT @AMTA1 =ISNULL(SUM(AMT1),0),@AMTA2 =ISNULL(SUM(AMT2),0) FROM #VAT__CG_FORM17 WHERE PART = 1 AND PARTSR ='1' AND SRNO IN('C','D','F')
----SELECT @AMTA3 =ISNULL(SUM(AMT1),0),@AMTA4 =ISNULL(SUM(AMT2),0) FROM #VAT__CG_FORM17 WHERE PART = 1 AND PARTSR ='1' AND SRNO ='F'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','G',0,(@AMTA1+@AMTA3),(@AMTA2+@AMTA4),0,'')  
---8. Interest payable if any
SET @AMTA1 = 0
select @AMTA1 =isnull(SUM(net_amt),0) from BPMAIN where entry_ty ='bp' and u_nature ='interest' and party_nm ='CST payable'
and  ( date between @SDATE and @EDATE )
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','H',0,@AMTA1,0,0,'')  
---9. Input tax rebate
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','I',0,0,0,0,'')  
 --(i) claimed
SELECT @AMTA1 = ISNULL(SUM(B.AMOUNT),0) FROM JVMAIN A INNER JOIN JVACDET B ON (A.entry_ty =B.ENTRY_TY AND A.Tran_cd =B.Tran_cd AND B.amt_ty ='DR') WHERE A.entry_ty ='J4' AND A.VAT_ADJ ='Claimed'
AND  (A.date BETWEEN @SDATE AND @EDATE ) AND A.PARTY_NM ='CST PAYABLE'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','I1',0,@AMTA1,0,0,'')
--(ii) adjusted
SET @AMTA1 = 0
SELECT @AMTA1 = ISNULL(SUM(B.AMOUNT),0) FROM JVMAIN A INNER JOIN JVACDET B ON (A.entry_ty =B.ENTRY_TY AND A.Tran_cd =B.Tran_cd AND B.amt_ty ='DR') WHERE A.entry_ty ='J4' AND A.VAT_ADJ ='Adjustment Towards Refund Claim'
AND  (A.date BETWEEN @SDATE AND @EDATE ) AND A.PARTY_NM ='CST PAYABLE'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','I2',0,@AMTA1,0,0,'')  
--(iii) claimed as refund
SET @AMTA1 = 0
SELECT @AMTA1 = ISNULL(SUM(B.AMOUNT),0) FROM JVMAIN A INNER JOIN JVACDET B ON (A.entry_ty =B.ENTRY_TY AND A.Tran_cd =B.Tran_cd AND B.amt_ty ='DR') WHERE A.entry_ty ='J4' AND A.VAT_ADJ ='Refund Claim'
AND  (A.date BETWEEN @SDATE AND @EDATE ) AND A.PARTY_NM ='CST PAYABLE'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','I3',0,@AMTA1,0,0,'')
---10. Tax deducted at source u/s. 27
SET @AMTA1 = 0
SELECT @AMTA1 = ISNULL(SUM(B.AMOUNT),0) FROM JVMAIN A INNER JOIN JVACDET B ON (A.entry_ty =B.ENTRY_TY AND A.Tran_cd =B.Tran_cd AND B.amt_ty ='DR') WHERE A.entry_ty ='J4' AND A.VAT_ADJ ='Tax deducted at source u/s. 27'
AND  (A.date BETWEEN @SDATE AND @EDATE ) AND A.PARTY_NM ='CST PAYABLE'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','J',0,@AMTA1,0,0,'')  
---11. Balance payable if any
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'1','K',0,0,0,0,'')  
---12. Payment details : Challan No...... date ............
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM,INV_NO,DATE)SELECT 1,'2','A',0
,ISNULL((NET_AMT),0),0 AS AMT2, 0 AS AMT3,'' AS PARTY_NM,U_CHALNO ,U_CHALDT FROM BPMAIN WHERE entry_ty ='BP' AND  ( DATE BETWEEN @SDATE AND @EDATE )
AND party_nm ='CST PAYABLE' 
IF NOT EXISTS(SELECT TOP 1 SRNO FROM #VAT__CG_FORM17 WHERE PART = 1 AND PARTSR ='2' AND SRNO ='A'  )
BEGIN
	INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','A',0,0,0,0,'')
END
--- 13. Refund if any
---The particulars given above are true to the best of my knowledge & belief.
SET @AMTA1 = 0
SELECT @AMTA1 = ISNULL(SUM(B.AMOUNT),0) FROM JVMAIN A INNER JOIN JVACDET B ON (A.entry_ty =B.ENTRY_TY AND A.Tran_cd =B.Tran_cd AND B.amt_ty ='DR') WHERE A.entry_ty ='J4' AND A.VAT_ADJ ='Other Refund'
AND  (A.date BETWEEN @SDATE AND @EDATE ) AND A.PARTY_NM ='CST PAYABLE'
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','A',0,@AMTA1,0,0,'')

---Received quarterly return in form 17 from M/s. .............................of .................................. R.C. No. ................................... alongwith a challans details below:
INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM,INV_NO,DATE)SELECT 1,'4','A',0
,ISNULL((NET_AMT),0),0 AS AMT2, 0 AS AMT3,'' AS PARTY_NM,U_CHALNO ,U_CHALDT FROM BPMAIN WHERE entry_ty ='BP' AND  ( DATE BETWEEN @SDATE AND @EDATE )
AND party_nm ='CST PAYABLE' 
IF NOT EXISTS(SELECT TOP 1 SRNO FROM #VAT__CG_FORM17 WHERE PART = 1 AND PARTSR ='4' AND SRNO ='A'  )
BEGIN
	INSERT INTO #VAT__CG_FORM17 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'4','A',0,0,0,0,'')
END






Update #VAT__CG_FORM17 set  PART = isnull(Part,'') , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), AMT3 = isnull(AMT3,0),
INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''),PARTY_NM = isnull(Party_nm,''), ADDRESS = isnull(Address,''),
FORM_NM = isnull(form_nm,''), S_TAX = isnull(S_tax,'')--, Qty = isnull(Qty,0),  ITEM =isnull(item,''),
,RFORM_NM = isnull(rform_nm,''), AMT4 = isnull(AMT4,0), AMT5 = isnull(AMT5,0)  --Added by Priyanka on 27022014

SELECT * FROM #VAT__CG_FORM17 order by cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int), partsr,SRNO

end

set ANSI_NULLS OFF
--Print 'DL VAT FORM 16'





