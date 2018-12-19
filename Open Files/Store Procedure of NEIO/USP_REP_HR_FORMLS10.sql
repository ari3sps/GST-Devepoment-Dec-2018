If Exists(Select xType,Name from Sysobjects where xType='P' and Name='USP_REP_HR_FORMLS10')

Begin
	Drop PROCEDURE USP_REP_HR_FORMLS10
End
Go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
EXECUTE USP_REP_HR_FORMLS10'','','','04/01/2011','03/31/2016','','','','',0,0,'','','','','','','','','2011-2016',''
*/

-- =============================================
-- Author:		Hetal L Patel
-- Create date: 16/05/2007
-- Description:	This Stored procedure is useful to generate HR VAT FORM LS 10
-- Modify date: 16/05/2007
-- Modified By: Sandeep Shah
-- Modify date: 22/09/2010
-- Remark:      Validate Add 4 th part and classification ratewise data.
--              Modify structure of Temp cursor --1 for rectified data validation.
-- Modified By: GAURAV R. TANNA for the Bug-
-- Modify date: 19/05/2015
-- =============================================
CREATE PROCEDURE [dbo].[USP_REP_HR_FORMLS10]
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

DECLARE @SQLCOMMAND NVARCHAR(4000)

---Temporary Cursor1
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=99.999,AMT1=M.NET_AMT,AMT2=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,AC1.S_TAX,INVNO=SPACE(20),M.DATE AS INVDT,M.U_IMPORM
,AMT3=M.TAXAMT
INTO #FORMLS10_Temp
FROM SRACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2


---Temporary Cursor2
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=99.999,AMT1=M.NET_AMT,AMT2=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,AC1.S_TAX,INVNO=SPACE(20),M.DATE AS INVDT,M.U_IMPORM
,AMT3=M.TAXAMT,SLNO=99999
INTO #FORMLS10
FROM SRACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2

Declare @MultiCo  VarChar(3), @PER Numeric (14,2), @AMTA1 Numeric (14,2), @AMTA2 Numeric (14,2), @AMTA3 Numeric (14,2)
Declare @MCON as NVARCHAR(2000)

IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
	Begin	------Fetch Records from Multi Co. Data
		 Set @MultiCo = 'YES'
		-- EXECUTE USP_REP_MULTI_CO_DATA
		--  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		-- ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		-- ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		-- ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		-- ,@MFCON = @MCON OUTPUT

		----SET @SQLCOMMAND='Select * from '+@MCON
		-----EXECUTE SP_EXECUTESQL @SQLCOMMAND
		--SET @SQLCOMMAND='Insert InTo #FORM_LP8 Select * from '+@MCON
		--EXECUTE SP_EXECUTESQL @SQLCOMMAND
		-----Drop Temp Table 
		--SET @SQLCOMMAND='Drop Table '+@MCON
		--EXECUTE SP_EXECUTESQL @SQLCOMMAND
	End
else
	Begin ------Fetch Single Co. Data
		 Set @MultiCo = 'NO'
		-- EXECUTE USP_REP_SINGLE_CO_DATA
		--  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		-- ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		-- ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		-- ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		-- ,@MFCON = @MCON OUTPUT

		----SET @SQLCOMMAND='Select * from '+@MCON
		-----EXECUTE SP_EXECUTESQL @SQLCOMMAND
		--SET @SQLCOMMAND='Insert InTo #FORM_LP8 Select * from '+@MCON
		--EXECUTE SP_EXECUTESQL @SQLCOMMAND
		-----Drop Temp Table 
		--SET @SQLCOMMAND='Drop Table '+@MCON
		--EXECUTE SP_EXECUTESQL @SQLCOMMAND
		
		INSERT INTO #FORMLS10_Temp (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM)
		select 1,'1','A', level1=isnull(stm.level1,0),a.ac_name, a.s_tax, sum(pr.gro_amt-(pr.TAXAMT+pr.TOT_NONTAX)) as taxonamt, 
		pr.inv_no, pr.date,ref.rinv_no, ref.rdate, Sum(p.gro_amt-(p.TAXAMT+p.TOT_NONTAX)) as staxonamt, 
		u_imporm=case when a.st_type='LOCAL' then CASE WHEN a.s_tax <> '' THEN 'Local Sale – VAT' ELSE 'Local Sale – Others' END else CASE WHEN a.st_type='OUT OF STATE' THEN 'Inter-State Sale' ELSE 'Export Sale' END end 
		from SRITEM pr
		left join SRITREF ref on (ref.entry_ty = pr.entry_ty And ref.Tran_cd = pr.tran_cd And ref.It_code = pr.It_code)
		left join STITEM p on (p.entry_ty = ref.rentry_ty And ref.itref_tran = p.tran_cd And ref.It_code = p.It_code)
		left join STMAIN pm on (pm.entry_ty = ref.rentry_ty And ref.itref_tran = pm.tran_cd)
		left join stax_mas stm on (stm.entry_ty = p.entry_ty And stm.Tax_name = p.tax_name)
		inner join ac_mast a on (pr.ac_id = a.ac_id)
		where (pr.DATE BETWEEN @SDATE AND @EDATE)
		group by a.ac_name, a.s_tax, pr.inv_no, pr.date, stm.level1, ref.rinv_no, ref.rdate, a.st_type
		order by a.ac_name, a.s_tax, pr.inv_no, pr.date
		
		INSERT INTO #FORMLS10_Temp (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM)
		select 1,'2','A', level1=isnull(stm.level1,0), a.ac_name, a.s_tax, sum(di.gro_amt-(di.TAXAMT+di.TOT_NONTAX)) as taxonamt, 
		di.inv_no, di.date,	dn.u_pinvno, dn.u_pinvdt, Sum(dn.u_slamt) as staxonamt, 
		u_imporm=case when a.st_type='LOCAL' then CASE WHEN a.s_tax <> '' THEN 'Local Sale – VAT' ELSE 'Local Sale – Others' END else CASE WHEN a.st_type='OUT OF STATE' THEN 'Inter-State Sale' ELSE 'Export Sale' END end 
		from CNITEM di
		left join stax_mas stm on (stm.entry_ty = di.entry_ty And stm.Tax_name = di.tax_name)
		left join CNMAIN dn on (dn.entry_ty = di.entry_ty And dn.tran_cd = di.tran_cd)
		inner join ac_mast a on (di.ac_id = a.ac_id)
		where (di.DATE BETWEEN @SDATE AND @EDATE) And dn.U_GPRICE = 'Escalation'
		group by a.ac_name, a.s_tax, di.inv_no, di.date, stm.level1, dn.u_pinvno, dn.u_pinvdt, a.st_type
		order by a.ac_name, a.s_tax, di.inv_no, di.date
			                 
				
		INSERT INTO #FORMLS10_Temp (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM)
		select 1,'3','A', level1=isnull(stm.level1,0), a.ac_name, a.s_tax, sum(di.gro_amt-(di.TAXAMT+di.TOT_NONTAX)) as taxonamt, 
		di.inv_no, di.date,	dn.u_pinvno, dn.u_pinvdt, Sum(dn.u_slamt) as staxonamt, 
		u_imporm=case when a.st_type='LOCAL' then CASE WHEN a.s_tax <> '' THEN 'Local Sale – VAT' ELSE 'Local Sale – Others' END else CASE WHEN a.st_type='OUT OF STATE' THEN 'Inter-State Sale' ELSE 'Export Sale' END end 
		from DNITEM di
		left join stax_mas stm on (stm.entry_ty = di.entry_ty And stm.Tax_name = di.tax_name)
		left join DNMAIN dn on (dn.entry_ty = di.entry_ty And dn.tran_cd = di.tran_cd)
		inner join ac_mast a on (di.ac_id = a.ac_id)
		where (di.DATE BETWEEN @SDATE AND @EDATE) And dn.U_GPRICE = 'De Escalation'
		group by a.ac_name, a.s_tax, di.inv_no, di.date, stm.level1, dn.u_pinvno, dn.u_pinvdt, a.st_type
		order by a.ac_name, a.s_tax, di.inv_no, di.date
	End

Declare @PARTY_NM VARCHAR(100), @S_TAX VARCHAR(20), @INV_NO VARCHAR(20), @DATE SMALLDATETIME
Declare @INVNO VARCHAR(20), @INVDT VARCHAR(20), @U_IMPORM VARCHAR(30)
Declare @PARTSR VARCHAR(2)

SET @PARTSR = '' 
SET @PARTY_NM = ''
SET @S_TAX = ''
SET @INV_NO = ''
SET @DATE = ''
SET @INVNO = ''
SET @INVDT = ''
SET @U_IMPORM = ''

SET @AMTA1 = 0
SET @AMTA2 = 0

Declare cur_FORMLS10_1 cursor for
SELECT PARTSR, PARTY_NM,S_TAX,INV_NO,DATE,Sum(AMT1) As AMT1,INVNO,INVDT,Sum(AMT2) As AMT2,U_IMPORM
FROM #FORMLS10_Temp
WHERE PART = 1 AND PARTSR in ('1','2','3')
GROUP BY PARTSR, PARTY_NM,S_TAX,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM
ORDER BY PARTSR, PARTY_NM,S_TAX,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM

OPEN CUR_FORMLS10_1
FETCH NEXT FROM CUR_FORMLS10_1 INTO @PARTSR, @PARTY_NM,@S_TAX,@INV_NO,@DATE,@AMTA1,@INVNO,@INVDT,@AMTA2,@U_IMPORM
WHILE (@@FETCH_STATUS=0)
BEGIN

	INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM,SLNO) 
	VALUES  (1,@PARTSR,'A',0,@PARTY_NM,@S_TAX,@AMTA1,@INV_NO,@DATE,@INVNO,@INVDT,@AMTA2,@U_IMPORM,0)  
					
	FETCH NEXT FROM CUR_FORMLS10_1 INTO @PARTSR, @PARTY_NM,@S_TAX,@INV_NO,@DATE,@AMTA1,@INVNO,@INVDT,@AMTA2,@U_IMPORM
END
CLOSE CUR_FORMLS10_1
DEALLOCATE CUR_FORMLS10_1

Declare @nSRNO Numeric (5)

Declare cur_FORMLS10_2 cursor for
SELECT U_IMPORM, RATE, 
AMT1=SUM(CASE WHEN PART=1 AND PARTSR='1' THEN AMT1 ELSE 0 END),
AMT2=SUM(CASE WHEN PART=1 AND PARTSR='2' THEN AMT1 ELSE 0 END),
AMT3=SUM(CASE WHEN PART=1 AND PARTSR='3' THEN AMT1 ELSE 0 END)
FROM #FORMLS10_Temp
WHERE PART = 1 AND PARTSR in ('1','2','3')
GROUP BY U_IMPORM, RATE
ORDER BY U_IMPORM, RATE

Declare @SRNO VARCHAR(3), @U_TYPE VARCHAR(100)
SET @SRNO = ''
SET @nSRNO = 0
SET @U_TYPE = ''
print 'start'
OPEN CUR_FORMLS10_2
FETCH NEXT FROM CUR_FORMLS10_2 INTO @U_IMPORM,@PER,@AMTA1,@AMTA2,@AMTA3
WHILE (@@FETCH_STATUS=0)
BEGIN

	SET @SRNO = ''
	
	IF @U_IMPORM = 'Local Sale – VAT'
		BEGIN
			SET @SRNO = 'A'
		END
	ELSE IF @U_IMPORM = 'Local Sale – Others'
		BEGIN
			SET @SRNO = 'A'
		END
	ELSE IF @U_IMPORM = 'Inter-State Sale'
		BEGIN
			SET @SRNO = 'B'
		END
	ELSE IF @U_IMPORM = 'Export Sale'
		BEGIN
			SET @SRNO = 'C'
		END		
	ELSE IF @U_IMPORM = 'Import Sale'
		BEGIN
			SET @SRNO = 'D'
		END

	IF RTRIM(@U_TYPE) != RTRIM(@U_IMPORM)
			
		BEGIN
			PRINT @NSRNO
			SET @nSRNO = 0
		END	
	ELSE
		BEGIN
			SET @nSRNO = 1
		END
		PRINT @NSRNO
	
	INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,U_IMPORM,AMT1,AMT2,AMT3, SLNO)
	VALUES  (1,'4',@SRNO,@PER,'',@U_IMPORM,@AMTA1,@AMTA2,@AMTA3, @NsRnO)  
	

	SET @U_TYPE = @U_IMPORM
	
	FETCH NEXT FROM CUR_FORMLS10_2 INTO @U_IMPORM,@PER,@AMTA1,@AMTA2,@AMTA3
	
END
CLOSE CUR_FORMLS10_2
DEALLOCATE CUR_FORMLS10_2


SET @AMTA1 = 0
SELECT @AMTA1=Count(PART) from #FORMLS10 WHERE PART = 1 AND PARTSR='1'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

IF @AMTA1 = 0
   BEGIN
		INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM,SLNO) 
		VALUES  (1,'1','A',0,'','',0,'','','','',0,'',0)  
   END

SET @AMTA1 = 0
SELECT @AMTA1=Count(PART) from #FORMLS10 WHERE PART = 1 AND PARTSR='2'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

IF @AMTA1 = 0
   BEGIN
		INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM, SLNO) 
		VALUES  (1,'2','A',0,'','',0,'','','','',0,'',0)  
   END

SET @AMTA1 = 0
SELECT @AMTA1=Count(PART) from #FORMLS10 WHERE PART = 1 AND PARTSR='3'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

IF @AMTA1 = 0
   BEGIN
		INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM, SLNO) 
		VALUES  (1,'3','A',0,'','',0,'','','','',0,'',0)  
   END

SET @AMTA1 = 0
SELECT @AMTA1=Count(PART) from #FORMLS10 WHERE PART = 1 AND PARTSR='4' AND SRNO='A'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

IF @AMTA1 = 0
   BEGIN
		INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM, SLNO) 
		VALUES  (1,'4','A',0,'','',0,'','','','',0,'',0)  
   END

SET @AMTA1 = 0
SELECT @AMTA1=Count(PART) from #FORMLS10 WHERE PART = 1 AND PARTSR='4' AND SRNO='B'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

IF @AMTA1 = 0
   BEGIN
		INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM, SLNO) 
		VALUES  (1,'4','B',0,'','',0,'','','','',0,'',0)  
   END

SET @AMTA1 = 0
SELECT @AMTA1=Count(PART) from #FORMLS10 WHERE PART = 1 AND PARTSR='4' AND SRNO='C'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

IF @AMTA1 = 0
   BEGIN
		INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM, SLNO) 
		VALUES  (1,'4','C',0,'','',0,'','','','',0,'',0)  
   END

SET @AMTA1 = 0
SELECT @AMTA1=Count(PART) from #FORMLS10 WHERE PART = 1 AND PARTSR='4' AND SRNO='D'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

IF @AMTA1 = 0
   BEGIN
		INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,PARTY_NM,S_TAX,AMT1,INV_NO,DATE,INVNO,INVDT,AMT2,U_IMPORM, SLNO) 
		VALUES  (1,'4','D',0,'','',0,'','','','',0,'',0)  
   END

--SET @AMTA1 = 0
--SELECT @AMTA1=Count(PART) from #FORMLS10 WHERE PART = 2 AND PARTSR='4'
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

--IF @AMTA1 = 0
--   BEGIN
--		INSERT INTO #FORMLS10 (PART,PARTSR,SRNO,RATE,U_IMPORM,AMT1,AMT2,AMT3) 
--		VALUES  (2,'4','A',0,'',0,0,0)  
--   END

Update #FORMLS10 set  PART = isnull(Part,0) , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
		             RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), 
					 AMT3 = isnull(AMT3,0), SLNO = isnull(SLNO,0), INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''), 
					 INVNO = isnull(INVNO,''), INVDT = isnull(INVDT,''), 
					 PARTY_NM = isnull(Party_nm,''), S_TAX = isnull(S_tax,''),
				  	 U_IMPORM = ISNULL(U_IMPORM,'')

SELECT * FROM #FORMLS10 order by cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int),SRNO
END
--Print 'HR VAT FORM LP 08'
