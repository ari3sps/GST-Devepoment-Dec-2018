If exists(Select * from sysobjects where [name]='USP_REP_MHFORM231' and xtype='P')
Begin
	Drop Procedure USP_REP_MHFORM231
End
go
 -- =============================================
 -- Author:		Pankaj M Borse.
 -- Create date: 30/08/2014
 -- Description: This Stored procedure is useful to generate MH VAT FORM 231
 -- Modify date: 17/08/2015, by GAURAV R. TANNA for the Bug-26697
  -- Modify date: 27/08/2015, by Suraj for the Bug-26697
 -- =============================================
 create PROCEDURE [dbo].[USP_REP_MHFORM231]
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
 Declare @FCON as NVARCHAR(2000),@VSAMT DECIMAL(14,2),@VEAMT DECIMAL(14,2)
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
 ,@VMAINFILE='M',@VITFILE=NULL,@VACFILE=NULL
 ,@VDTFLD ='DATE'
 ,@VLYN=NULL
 ,@VEXPARA=@EXPARA
 ,@VFCON =@FCON OUTPUT
 
 DECLARE @SQLCOMMAND NVARCHAR(4000)
 DECLARE @RATE NUMERIC(12,2),@AMTA1 NUMERIC(12,2),@AMTB1 NUMERIC(12,2),@AMTC1 NUMERIC(12,2),@AMTD1 NUMERIC(12,2),@AMTE1 NUMERIC(12,2),@AMTF1 NUMERIC(12,2),@AMTG1 NUMERIC(12,2),@AMTH1 NUMERIC(12,2),@AMTI1 NUMERIC(12,2),@AMTJ1 NUMERIC(12,2),@AMTK1 NUMERIC(12,2),@AMTL1 NUMERIC(12,2),@AMTM1 NUMERIC(12,2),@AMTN1 NUMERIC(12,2),@AMTO1 NUMERIC(12,2)
 DECLARE @AMTA2 NUMERIC(12,2),@AMTB2 NUMERIC(12,2),@AMTC2 NUMERIC(12,2),@AMTD2 NUMERIC(12,2),@AMTE2 NUMERIC(12,2),@AMTF2 NUMERIC(12,2),@AMTG2 NUMERIC(12,2),@AMTH2 NUMERIC(12,2),@AMTI2 NUMERIC(12,2),@AMTJ2 NUMERIC(12,2),@AMTK2 NUMERIC(12,2),@AMTL2 NUMERIC(12,2),@AMTM2 NUMERIC(12,2),@AMTN2 NUMERIC(12,2),@AMTO2 NUMERIC(12,2)
 DECLARE @PER NUMERIC(12,2),@TAXAMT NUMERIC(12,2),@CHAR INT,@LEVEL NUMERIC(12,2)
 
SELECT DISTINCT AC_NAME=SUBSTRING(AC_NAME1,2,CHARINDEX('"',SUBSTRING(AC_NAME1,2,100))-1) INTO #VATAC_MAST FROM STAX_MAS WHERE AC_NAME1 NOT IN ('"SALES"','"PURCHASES"') AND ISNULL(AC_NAME1,'')<>''
INSERT INTO #VATAC_MAST SELECT DISTINCT AC_NAME=SUBSTRING(AC_NAME1,2,CHARINDEX('"',SUBSTRING(AC_NAME1,2,100))-1) FROM STAX_MAS WHERE AC_NAME1 NOT IN ('"SALES"','"PURCHASES"') AND ISNULL(AC_NAME1,'')<>''
 

Declare @NetEff as numeric (12,2), @NetTax as numeric (12,2)



---Temporary Cursor2
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=99.999,AMT1=NET_AMT,AMT2=M.TAXAMT,AMT3=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),STM.FORM_NM,AC1.S_TAX
,AC1.CITY,CAST('' AS VARCHAR(100)) AS RAOSNO,CAST('' AS SMALLDATETIME) AS RAODT --Added by Priyanka on 26092013
INTO #FORM221
FROM PTACDET A 
INNER JOIN STMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
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

		----SET @SQLCOMMAND='Select * from '+@MCON
		-----EXECUTE SP_EXECUTESQL @SQLCOMMAND
		--SET @SQLCOMMAND='Insert InTo  VATTBL Select * from '+@MCON
		--EXECUTE SP_EXECUTESQL @SQLCOMMAND
		-----Drop Temp Table 
		--SET @SQLCOMMAND='Drop Table '+@MCON
		--EXECUTE SP_EXECUTESQL @SQLCOMMAND
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

		--SET @SQLCOMMAND='Select * from '+@MCON
		-----EXECUTE SP_EXECUTESQL @SQLCOMMAND
		--SET @SQLCOMMAND='Insert InTo  VATTBL Select * from '+@MCON
		--EXECUTE SP_EXECUTESQL @SQLCOMMAND
		-----Drop Temp Table 
		--SET @SQLCOMMAND='Drop Table '+@MCON
		--EXECUTE SP_EXECUTESQL @SQLCOMMAND
	End
-----
--SELECT * from VATTBL where (Date Between @Sdate and @Edate) and bhent in('ST','SR')
-----

--->PART 1-5 
 SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0 

--5(a)Gross turnover of sales including taxes as well as turnover of non sales transaction like Values of Branch/Consignment transfers and job work charges etc.
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('ST') 
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) 
VALUES (1,'5','A',0,@AMTA1,0,0,'','','') 


--5(b)Less:-Value of goods return (inclusive of tax),including reduction of sale price on account of rate difference and discount.
select @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b inner join stmain c on (b.tran_cd=c.tran_cd) 
where  b.BHENT in ('ST') and (c.u_gcssr=1 OR  c.u_choice=1 ) AND (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a

SELECT @AMTA2=isnull(SUM(NET_AMT),0)   FROM 
(select b.net_amt from vattbl b 
where  b.BHENT in ('SR') and  (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a


SELECT @AMTB2=isnull(SUM(NET_AMT),0)   FROM 
(select b.net_amt from vattbl b 
where  b.BHENT in ('CN') and  (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @AMTB1=@AMTA1+@AMTA2+@AMTB2

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES 
(1,'5','B',0,@AMTB1,0,0,'','','') 


--5(C)Less:-Net Tax amount (Tax included in sales shown in (a) above less tax included in (b)above)
SELECT @AMTA1=isnull(SUM(B.TAXAMT),0)  from vattbl b where  b.BHENT in ('ST') and b.ST_TYPE='LOCAL'

select @AMTB1=isnull(SUM(a.TAXAMT),0)  from vattbl A 
inner join stmain c on (A.tran_cd=c.tran_cd) 
where  A.BHENT in ('ST') and (c.u_gcssr=1 OR  c.u_choice=1 ) AND (C.DATE BETWEEN @SDATE AND @EDATE)   

SELECT @AMTA2=isnull(SUM(B.TAXAMT),0)  from vattbl b where  b.BHENT in ('SR') and b.ST_TYPE='LOCAL'

SELECT @AMTB2=isnull(SUM(B.TAXAMT),0) FROM vattbl b where  b.BHENT in ('CN') and b.ST_TYPE='LOCAL'

SET @AMTA1=ISNULL(@AMTA1,0)
SET @AMTA2=ISNULL(@AMTA2,0)
SET @AMTB1=ISNULL(@AMTB1,0)
SET @AMTB2=ISNULL(@AMTB2,0)

INSERT INTO #FORM221(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT)
VALUES (1,'5','C',0,@AMTA1-(@AMTA2+@AMTB1+@AMTB2),0,0,'','','')

--5(D)Less:-Value of Branch / Consignment transfers within the state if tax is to be paid by an Agent.
SELECT @AMTA1=SUM(A.NET_AMT) FROM 
(select net_amt from vattbl 
where  BHENT='ST' and ST_TYPE='LOCAL'  AND (U_IMPORM IN ('Branch Transfer','Consignment Transfer')) AND (DATE BETWEEN @SDATE AND @EDATE)
group by tran_cd,net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES 
(1,'5','D',0,@AMTA1,0,0,'','','') 
 
--5(DA)Less:-Sales u/s 8(1) i.e. interstate sales including Central sales tax, Sales in the course of imports, exports and value of Branch / Consignment transfers outside the state
SELECT @AMTA1=sum(a.NET_AMT) from
(select net_amt from vattbl 
where  BHENT='ST' and ST_TYPE in ('OUT OF STATE','OUT OF COUNTRY') 
group by tran_cd,net_amt,dbname)a

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES
(1,'5','DA',0,@AMTA1,0,0,'','','') 
 
--5(DB)Turnover of export sales u/s 5(1) of the CST Act 1956 included in Box(e)
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0) FROM 
(select net_amt from vattbl 
WHERE  ST_TYPE in ('OUT OF COUNTRY')  AND BHENT='ST' and U_IMPORM='Export Out of India' group by tran_cd,net_amt,dbname)a

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES
(1,'5','DB',0,@AMTA1,0,0,'','','') 
 
--5(E)Turnover of sales in the course of import u/s 5(2) of the CST Act 1956 included in Box(e)
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0) FROM 
(select net_amt from vattbl 
WHERE ST_TYPE='OUT OF COUNTRY' AND BHENT='ST' and U_IMPORM='High Sea Sales' group by tran_cd,net_amt,dbname)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
 INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES 
(1,'5','E',0,@AMTA1,0,0,'','','')
 
--5(F)Less:-Sales of tax-free goods specified in schedule 'A' of MVAT Act
-- commented by suraj  for bug-26679
--SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
--(select b.net_amt from vattbl b 
--where  b.BHENT='ST' and b.vattype='Schedule A' 
--group by b.tran_cd,b.net_amt)a

-- added by suraj  for bug-26679

SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b inner join IT_MAST c on b.It_code=c.It_code
where  b.BHENT='ST' and c.U_SHCODE in('Schedule A','Schedule-A')
group by b.tran_cd,b.net_amt)a


SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES 
(1,'5','F',0,@AMTA1,0,0,'','','')
 
--5(G)Less:-Sales of taxable goods fully exempted u/s 41 and u/s 8 other than sales under section 8(1) and covered in Box 5(e)
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0) from
(select net_amt from vattbl 
where  BHENT='ST' and ST_TYPE='LOCAL'  AND TAX_NAME in ('EXEMPTED','') AND (DATE BETWEEN @SDATE AND @EDATE)
group by tran_cd,net_amt)a
set @AMTA1=isnull(@AMTA1,0)

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES
(1,'5','G',0,@AMTA1,0,0,'','','')
 
--5(H)Less:-Labour charges/Job work charges
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT='LR' 
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES 
(1,'5','H',0,@AMTA1,0,0,'','','') 

--5(I)Less:-Other allowable deductions,if any
--SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
--(select b.net_amt from vattbl b 
--where  B.Bhent = 'ST' and B.u_imporm = 'Branch Transfer' and B.Tax_name = ' '
--group by b.tran_cd,b.net_amt)a
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

-- Added by Gaurav R. Tanna for the Bug :        -start
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES
--(1,'5','I',0,0,0,0,'','','')

SELECT @AMTA1=0,@AMTB1=0
    
SELECT @AMTA1=Sum(A.tot_nontax) FROM STITEM A  
WHERE A.Date Between @SDATE And @EDATE  
    
SELECT @AMTB1=Sum(A.tot_nontax) FROM STMAIN A  
WHERE A.Date Between @SDATE And @EDATE  
           
Set @AMTA1 = IsNull(@AMTA1,0)   
Set @AMTB1 = IsNull(@AMTB1,0)   
        
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES
(1,'5','I',0,(@AMTA1+@AMTB1),0,0,'','','')

Set @AMTA1 = 0
Set @AMTB1 = 0
-- Added by Guarav R. Tanna for the Bug :          - End    
    
 
--5(J)Balance : Net turnover of Sales liable to tax [a-(b+c+d+e+f+g+h+i)]
 SELECT @AMTA2=AMT1 FROM #FORM221  WHERE  PARTSR='5' AND SRNO='A'
 SELECT @AMTA1=SUM(isnull(AMT1,0)) FROM #FORM221  WHERE  PARTSR='5' AND SRNO IN ('B','C','D','DA','DB','E','F','G','H','I')
 SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
 SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END

 INSERT INTO #FORM221
 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES 
 (1,'5','J',0,@AMTA2-@AMTA1,0,0,'','','') 
 
 --6 Computation of Sales tax payable under the MVAT Act
-----Total of 5(a) less Total of 5(j) for the period
-- SELECT @AMTA2=SUM(isnull(AMT1,0)) FROM #FORM221  WHERE (PART=1) AND (PARTSR='5') AND SRNO IN ('A')
 
-- SET @AMTA2=(CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END)-@AMTA1
 
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'5','K',0,@AMTA2,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'5','K',0,@AMTA2,0,0,'','','') --Added by Priyanka on 26092013
 
 
-- --->PART 1-5 ST_TYPE='LOCAL','OUT OF STATE' for the period
-- -->---PART 6

---Tax & Taxable Amount of Sales for the period
-- SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0 
-- SET @CHAR=65
-- DECLARE  CUR_FORM221 CURSOR FOR 
-- select distinct level1 from stax_mas where ST_TYPE='LOCAL'--CHARINDEX('VAT',TAX_NAME)>0
-- OPEN CUR_FORM221
-- FETCH NEXT FROM CUR_FORM221 INTO @PER
-- WHILE (@@FETCH_STATUS=0)
-- BEGIN
--	if @per = 0
--		begin
--			SELECT @AMTA1=isnull(SUM(NET_AMT),0) FROM VATTBL where bhent = 'ST' AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '' And ac_name not like '%Rece%' and U_imporm <> 'Purchase Return'
--			SELECT @AMTB1=isnull(SUM(TAXAMT),0)  FROM VATTBL where bhent = 'ST' AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '' And ac_name not like '%Rece%' and U_imporm <> 'Purchase Return'
--			SELECT @AMTC1=isnull(SUM(NET_AMT),0) FROM VATTBL where bhent = 'SR' AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '' AND PER=@PER 
--			SELECT @AMTD1=isnull(SUM(TAXAMT),0)  FROM VATTBL where bhent = 'SR' AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '' AND PER=@PER
--		end
--	else
--		begin
--			SELECT @AMTA1=isnull(SUM(NET_AMT),0) FROM VATTBL where bhent = 'ST' AND (DATE BETWEEN @SDATE AND @EDATE) and ac_name not like '%Rece%' And S_tax <> '' AND PER=@PER and U_imporm <> 'Purchase Return'
--			SELECT @AMTB1=isnull(SUM(TAXAMT),0)  FROM VATTBL where bhent = 'ST' AND (DATE BETWEEN @SDATE AND @EDATE) and ac_name not like '%Rece%' And S_tax <> '' AND PER=@PER and U_imporm <> 'Purchase Return'
--			SELECT @AMTC1=isnull(SUM(NET_AMT),0) FROM VATTBL where bhent = 'SR' AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '' AND PER=@PER
--			SELECT @AMTD1=isnull(SUM(TAXAMT),0)  FROM VATTBL where bhent = 'SR' AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '' AND PER=@PER
--		end
	
----  Print @Per
----  Print 'PT'
----  Print @AMTA1
----  Print @AMTB1
----  Print 'PR'
----  Print @AMTC1
----  Print @AMTD1
----  Print 'EP'
------  Print @AMTF1
------  Print @AMTF2
----  Print 'DN'
----  Print @AMTG1
----  Print @AMTG2
----  Print 'ST P Ret'
----  Print @AMTH1
----  Print @AMTH2
--  --Sales Invoices
--  SET @AMTA1=ISNULL(@AMTA1,0)
--  SET @AMTB1=ISNULL(@AMTB1,0)
 
--  --Return Invoices
--  SET @AMTC1=ISNULL(@AMTC1,0)
--  SET @AMTD1=ISNULL(@AMTD1,0)

--  --Net Effect
--  Set @NetEFF = @AMTA1-(@AMTB1+(@AMTC1-@AMTD1))
--  --Set @NetEFF = (@AMTA1-@AMTB1)-(@AMTC1-@AMTD1)
--  Set @NetTAX = (@AMTB1)-(@AMTD1)

--  if @nettax <> 0
--	  begin
--		  INSERT INTO #FORM221
--		  --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
--		  --(1,'6',CHAR(@CHAR),@PER,@NETEFF,@NETTAX,0,'') --Commented by Priyanka on 26092013
--		  (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
--		  (1,'6',CHAR(@CHAR),@PER,@NETEFF,@NETTAX,0,'','','') --Added by Priyanka on 26092013
--		--  (1,'6',CHAR(@CHAR),@PER,@AMTA1-@AMTB1,@AMTB1,0)
		  
--		--  SET @AMTJ1=@AMTJ1+@AMTA1 --TOTAL TAXABLE AMOUNT
--		--  SET @AMTK1=@AMTK1+@AMTB1 --TOTAL TAX
--		  SET @AMTJ1=@AMTJ1+@NETEFF --TOTAL TAXABLE AMOUNT
--		  SET @AMTK1=@AMTK1+@NETTAX --TOTAL TAX
--		  SET @CHAR=@CHAR+1
--	  end

--  FETCH NEXT FROM CUR_FORM221 INTO @PER
-- END
-- CLOSE CUR_FORM221
-- DEALLOCATE CUR_FORM221
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,Party_nm) 
SELECT 1,'6','',A.PER,isnull(SUM(CASE WHEN A.BHENT='ST' THEN A.VATONAMT ELSE -A.VATONAMT END),0),isnull(SUM(CASE WHEN A.BHENT='ST' THEN A.TAXAMT ELSE -A.TAXAMT END),0),'' FROM VATTBL A WHERE A.BHENT IN ('ST','SR','CN') AND A.st_type='LOCAL' AND A.TAX_NAME LIKE '%VAT%' GROUP BY A.PER


SELECT @AMTA1=SUM(AMT1) FROM #FORM221 WHERE PARTSR='6'
SELECT @AMTA2=SUM(AMT2) FROM #FORM221 WHERE PARTSR='6'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,Party_nm) VALUES 
(1,'6','Z',0,@AMTA1,@AMTA2,'')


--  --<---PART 6
-- -->---PART 7
-- SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0

-----Net Amount of Purchases/Retruns for the period
-- SELECT @AMTA1=isnull(SUM(NET_AMT),0) from (select distinct tran_cd,bhent,NET_AMT from VATTBL where (DATE BETWEEN @SDATE AND @EDATE) And BHENT in ('PT','EP','CN')) b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','A',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','A',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013

------Net Amount of Purchase Return for the period
-- SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,NET_AMT from VATTBL where (DATE BETWEEN @SDATE AND @EDATE) And (BHENT in('PR','DN') or (Bhent='ST' And U_Imporm = 'Purchase Return'))) b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','B',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','B',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013

-- ---Net Amount of Direct Import Purchases for the period
-- SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,NET_AMT from VATTBL where (DATE BETWEEN @SDATE AND @EDATE) And (BHENT in ('PT','EP','CN')) AND U_IMPORM='Direct Imports') b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','C',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','C',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013

-----Net Amount of High Seas Purchases for the period 
-- SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,NET_AMT from VATTBL where (DATE BETWEEN @SDATE AND @EDATE) AND (BHENT in ('PT','EP','CN')) And U_IMPORM='High Seas Purchases') b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','D',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','D',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013

-----Net Amount of Inter States Purchase i.e Out of State for the period against CST
-- SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,NET_AMT from VATTBL    where (DATE BETWEEN @SDATE AND @EDATE) AND (BHENT in ('PT','EP','CN') ) And ST_TYPE='OUT OF STATE' and tax_name <> '' AND U_IMPORM <>'Branch Transfer' 
-- AND tax_name <> 'Form H' --Added by Priyanka on 26092013
-- ) b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','E',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','E',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013
 
-- --Added by Priyanka on 23092013--start
----Purchase Against Form H7(e)(1)
-- SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,NET_AMT from VATTBL    where (DATE BETWEEN @SDATE AND @EDATE) AND (BHENT in ('PT','EP','CN') ) And tax_name = 'Form H') b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES
-- (1,'7','EA',0,@AMTA1,0,0,'','','')
----Added by Priyanka on 23092013--end

-----Net Amount of Inter States Purchase as Branch Tranfer for the period
-- SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,NET_AMT from VATTBL where ST_TYPE='OUT OF STATE'  AND U_IMPORM='Branch Transfer' AND (BHENT in ('PT','EP','CN')) AND (DATE BETWEEN @SDATE AND @EDATE) And Tax_name in(' ','NO-TAX')) b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','F',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
--  (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','F',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013
 
-----Net Amount of Purchases as Local Branch Transfer Within the States for the period
-- SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,NET_AMT from VATTBL where ST_TYPE='LOCAL'  AND U_IMPORM='Branch Transfer' AND (BHENT in ('PT','EP','CN')) AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name <> ' ') b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','G',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','G',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013
 
-----Net Amount of Unregistered Purchases for the period i.e is without Sales Tax No./Tin No.
--  SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,NET_AMT from VATTBL where ST_TYPE='LOCAL'  AND TAX_NAME <> ''  AND (ISNULL(S_TAX,' ')=' ') AND (BHENT in ('PT','EP','CN')) AND (DATE BETWEEN @SDATE AND @EDATE) AND TAX_NAME <> '') b
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','H',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','H',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013
 
-----Net Amount of Purchase not Eligible for set off
--SELECT @AMTA1=isnull(SUM(VATONAMT),0) from (select distinct tran_cd,bhent,VATONAMT from VATTBL where (Date Between @Sdate and @Edate) and Bhent in('EP','PT','CN') and TAX_NAME In('','NO-TAX') and U_imporm = '') b
--SELECT @AMTB1=isnull(SUM(NET_AMT),0) from (select distinct tran_cd,bhent,Net_Amt from VATTBL where (Date Between @Sdate and @Edate) and isnull(tax_name,'') in('','NO-TAX' ) and (Bhent in('PR','DN') or (Bhent='ST' And U_Imporm = 'Purchase Return'))) b

--SET @AMTB1= ISNULL(@AMTB1,0)
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
--		--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','L',0,@AMTA1-@AMTB1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','L',0,@AMTA1-@AMTB1,0,0,'','','') --Added by Priyanka on 26092013
-- --(1,'7','I',0,@AMTA1,0,0,'')
 
-----Net Amount of Purchase Exempted from tax 
--SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,Net_Amt from VATTBL where  (DATE BETWEEN @SDATE AND @EDATE) And BHENT in ('PT','EP','CN') AND isnull(tax_name,'')='EXEMPTED') b 
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','J',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','J',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013

----Net Amount of Purchase Tax Free Agricultural goods
-- SELECT @AMTA1=SUM(isnull(NET_AMT,0)) from (select distinct a.tran_cd,a.bhent,a.Net_Amt from VATTBL a
-- inner join ptmain pt on (a.tran_cd=pt.tran_cd)
-- where  (a.DATE BETWEEN @SDATE AND @EDATE) And a.BHENT='PT' AND isnull(a.tax_name,'')=''
-- AND pt.VATMTYPE='Sales - Tax Free' --Added by Priyanka on 24092013
-- ) b 
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','K',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','K',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013
 
-----Net Amount of Purchase other deduction /Expense Purchases, if any
-- SELECT @AMTB1=SUM(isnull(NET_AMT,0)) from (select distinct tran_cd,bhent,Net_Amt from VATTBL where (DATE BETWEEN @SDATE AND @EDATE) And BHENT in ('PT','EP','CN') AND tax_name='Labour Charg') b
-- select @AMTB2=sum( isnull(((QTY*RATE)*(100-u_vatonp))/100,0) ) from epitem i where (date between @sdate and @edate) and (u_vatonp>0 and u_vatonp<100) and tax_name <> ''--7L 2.1 

-- SET @AMTB1=CASE WHEN @AMTB1 IS NULL THEN 0 ELSE @AMTB1 END
-- SET @AMTB2=CASE WHEN @AMTB2 IS NULL THEN 0 ELSE @AMTB2 END
-- SET @AMTC1=@AMTB1+@AMTB2
-- SET @AMTC1=CASE WHEN @AMTC1 IS NULL THEN 0 ELSE @AMTC1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','I',0,@AMTC1,0,0,'') --Commented by Priyanka on 26092013
--  (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','I',0,@AMTC1,0,0,'','','') --Added by Priyanka on 26092013
-- --(1,'7','L',0,@AMTC1,0,0,'')

-----Total of 7 (b+c+d+e+f+g+h+i+j+k+l)
-- SELECT @AMTA1=SUM(isnull(AMT1,0)) FROM #FORM221  WHERE (PART=1) AND (PARTSR='7') AND SRNO IN ('B','C','D','E','F','G','H','I','J','K','L')
-- SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','M',0,@AMTA1,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','M',0,@AMTA1,0,0,'','','') --Added by Priyanka on 26092013
 
-----Total of 7(a) - 7(M) Amount Eligible for tax
-- SELECT @AMTA2=SUM(isnull(AMT1,0)) FROM #FORM221  WHERE (PART=1) AND (PARTSR='7') AND SRNO IN ('A')
 
-- SET @AMTA2=(CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END)-@AMTA1
 
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'7','N',0,@AMTA2,0,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'7','N',0,@AMTA2,0,0,'','','') --Added by Priyanka on 26092013
-- --<---PART 7
-- -->---PART 8
-- SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0 
-- SET @CHAR=65
-- DECLARE  CUR_FORM221 CURSOR FOR 
-- select distinct level1 from stax_mas where ST_TYPE='LOCAL'--CHARINDEX('VAT',TAX_NAME)>0
-- OPEN CUR_FORM221
-- FETCH NEXT FROM CUR_FORM221 INTO @PER
-- WHILE (@@FETCH_STATUS=0)
-- BEGIN
--  if @per = 0
--	Begin
--		SELECT @AMTA1=isnull(SUM(VATONAMT),0) FROM (select distinct tran_cd,bhent,vatonamt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PT' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '') b
--		SELECT @AMTB1=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PT' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '' 
--		SELECT @AMTC1=isnull(SUM(VATONAMT),0) FROM (select distinct tran_cd,bhent,vatonamt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PR' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '') b
--		SELECT @AMTD1=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PR' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> ''
--		SELECT @AMTF1=isnull(SUM(VATONAMT),0) FROM (select distinct tran_cd,bhent,vatonamt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='EP' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '') b
--		SELECT @AMTF2=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='EP' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> ''
--		SELECT @AMTG1=isnull(SUM(VATONAMT),0) FROM (select distinct tran_cd,bhent,vatonamt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='DN' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '') b
--		SELECT @AMTG2=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='DN' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> ''
--		SELECT @AMTH1=isnull(SUM(NET_AMT),0) FROM (select distinct tran_cd,bhent,net_amt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='ST' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '' AND U_IMPORM = 'Purchase Return') b
--		SELECT @AMTH2=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='ST' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) and Tax_name like '%Margin%' And S_tax <> '' AND U_IMPORM = 'Purchase Return' 
--	End
--  else
--	Begin
--		SELECT @AMTA1=isnull(SUM(Net_AMT),0) FROM (select distinct tran_cd,bhent,net_amt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PT' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '') b
--		SELECT @AMTB1=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PT' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '' 
--		SELECT @AMTC1=isnull(SUM(VATONAMT),0) FROM (select distinct tran_cd,bhent,vatonamt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PR' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '') b
--		SELECT @AMTD1=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PR' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '' 
--		SELECT @AMTF1=isnull(SUM(VATONAMT),0) FROM (select distinct tran_cd,bhent,vatonamt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='EP' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '') b
--		SELECT @AMTF2=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='EP' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '' 
--		SELECT @AMTG1=isnull(SUM(VATONAMT),0) FROM (select distinct tran_cd,bhent,vatonamt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='DN' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '') b
--		SELECT @AMTG2=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='DN' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '' 
--		SELECT @AMTH1=isnull(SUM(NET_AMT),0) FROM (select distinct tran_cd,bhent,net_amt from VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='ST' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '' AND U_IMPORM = 'Purchase Return') b
--		SELECT @AMTH2=isnull(SUM(TAXAMT),0)   FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='ST' AND PER=@PER AND (DATE BETWEEN @SDATE AND @EDATE) And S_tax <> '' AND U_IMPORM = 'Purchase Return' 
--	End

--  --Purchase Invoice
--  SET @AMTA1=ISNULL(@AMTA1,0)
--  SET @AMTB1=ISNULL(@AMTB1,0)
--  --Return Invoice
--  SET @AMTC1=ISNULL(@AMTC1,0)
--  SET @AMTD1=ISNULL(@AMTD1,0)
--  --Expense Purchase Invoice
--  SET @AMTF1=ISNULL(@AMTF1,0)
--  SET @AMTF2=ISNULL(@AMTF2,0)
--  --Debit Note Invoice
--  SET @AMTG1=ISNULL(@AMTG1,0)
--  SET @AMTG2=ISNULL(@AMTG2,0)
--  --Sales Invoice Where U_imporm = 'Purchase Return'
--  SET @AMTH1=ISNULL(@AMTH1,0)
--  SET @AMTH2=ISNULL(@AMTH2,0)

----Net Effect
----DIN   Set @NetEFF = ((@AMTA1 - @AMTB1) + (@AMTF1 - @AMTF2) - (@AMTC1 - @AMTD1) - (@AMTG1 - @AMTG2) - (@AMTH1 - @AMTH2)) 
--  Set @NetEFF = ((@AMTA1 - @AMTB1) + (@AMTF1 ) - (@AMTC1 - @AMTD1) - (@AMTG1 - @AMTG2) - (@AMTH1 - @AMTH2)) 
----PRINT @NetEFF 
-----Set @NetEFF = ((@AMTA1 - @AMTB1) + (@AMTE1 - @AMTF1)) - (@AMTC1 - @AMTD1)
--  Set @NetTAX = (@AMTB1 + @AMTF2) - @AMTD1 - @AMTG2 - @AMTH2

--  if @nettax <> 0
--	  Begin
--		  INSERT INTO #FORM221
--		  --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
--		  --(1,'8',CHAR(@CHAR),@PER,@NETEFF,@NETTAX,0,'') --Commented by Priyanka on 26092013
--		  (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
--		  (1,'8',CHAR(@CHAR),@PER,@NETEFF,@NETTAX,0,'','','') --Added by Priyanka on 26092013
--		--  (1,'8',CHAR(@CHAR),@PER,@AMTA1-@AMTB1,@AMTB1,0)
		  
--		--  SET @AMTM1=@AMTM1+@AMTA1 --TOTAL TAXABLE AMOUNT
--		--  SET @AMTO1=@AMTO1+@AMTB1 --TOTAL TAX
--		  SET @AMTM1=@AMTM1+@NETEFF --TOTAL TAXABLE AMOUNT
--		  SET @AMTO1=@AMTO1+@NETTAX --TOTAL TAX
--		  SET @CHAR=@CHAR+1
--	  end
--  FETCH NEXT FROM CUR_FORM221 INTO @PER
-- END
-- CLOSE CUR_FORM221
-- DEALLOCATE CUR_FORM221
 
-- INSERT INTO #FORM221
-- --(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES --Commented by Priyanka on 26092013
-- --(1,'8','Z',0,@AMTM1,@AMTO1,0,'') --Commented by Priyanka on 26092013
-- (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm,RAOSNO,RAODT) VALUES --Added by Priyanka on 26092013
-- (1,'8','Z',0,@AMTM1,@AMTO1,0,'','','') --Added by Priyanka on 26092013
---- (1,'8','Z',0,@AMTM1-@AMTO1,@AMTO1,0)
--------------**************************
----7(a) Turnover of purchases should also include value of Branch Transfers / Consignment Transfers received and job work charges 
--SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
--(select b.net_amt from vattbl b 
--where  b.BHENT in ('PT','EP') AND (b.DATE BETWEEN @SDATE AND @EDATE)   
--group by b.tran_cd,b.net_amt)a
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'7','A',0,@AMTA1,0,0,'')

--7(b) ,Raw Material Sale,Branch Transfer,Purchase Return
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('PR') AND (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a

SELECT @AMTA2=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('ST') AND b.U_IMPORM ='Purchase Return' and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a

SELECT @AMTB1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('DN') and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','B',0,@AMTA1+@AMTA2+@AMTB1,0,0,'')

-- 7(c) Direct Import
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('PT') and  b.ST_TYPE='OUT OF COUNTRY' AND b.U_IMPORM='Direct Imports' and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','C',0,@AMTA1,0,0,'')

-- 7(d) Import(High Seas Purchases)
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('PT') and  b.ST_TYPE='OUT OF COUNTRY' AND b.U_IMPORM='High Seas Purchases' and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','D',0,@AMTA1,0,0,'')

-- 7(e) Inter State purchase (Excluding FOrm H)
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('PT') and  b.ST_TYPE='OUT OF STATE' AND b.U_IMPORM='' and form_nm not in ('FORM H','H FORM') and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','E',0,@AMTA1,0,0,'')

-- 7(e1) Purchase of taxable goods(either local or interstate) Against Form H
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('PT') and  b.ST_TYPE in ('OUT OF STATE','LOCAL') AND b.U_IMPORM='' and form_nm  in ('FORM H','H FORM') and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','E1',0,@AMTA1,0,0,'')

-- 7(f) Interstate Branch/Consignment Transfer
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b		
where  b.BHENT in ('PT') and  b.ST_TYPE='OUT OF STATE' AND b.U_IMPORM in ('Branch Transfer','Consignment Transfer') and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','F',0,@AMTA1,0,0,'')

-- 7(g) within state Branch/Consignment Transfer
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('PT') and  b.ST_TYPE='LOCAL' AND b.U_IMPORM in ('Branch Transfer','Consignment Transfer') and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','G',0,@AMTA1,0,0,'')

-- 7(h) within state purchase of taxable goods from unregistered dealer
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('PT') and  b.ST_TYPE='LOCAL' and b.tax_name like '%VAT%' and b.s_tax='' and (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','H',0,@AMTA1,0,0,'')

-- 7(i) purchase of taxable goods from registered dealer and which are not eligible for set off
SELECT @AMTA1=isnull(SUM(NET_AMT),0) FROM VATTBL WHERE ST_TYPE='LOCAL' AND BHENT='PT' AND (DATE BETWEEN @SDATE AND @EDATE) AND TAX_NAME='EXEMPTED'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','I',0,@AMTA1,0,0,'')

-- 7(j) within state purchase of taxable good which are fully exempted 
set @AMTA1 = 0
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT='PT' and b.ST_TYPE='LOCAL' and b.tax_name in ('EXEMPTED','') AND (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','J',0,@AMTA1,0,0,'') -- (NOT KNOW)

-- 7(k) within state purchases of tax free goods specified in schedule A	
--commented by suraj for bug-26679
--SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
--(select b.net_amt from vattbl b 
--where  b.BHENT='PT' and b.ST_TYPE='LOCAL' and b.vattype='Schedule A' AND (b.DATE BETWEEN @SDATE AND @EDATE)   
--group by b.tran_cd,b.net_amt)a
--added by suraj for bug-26679
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b inner join IT_MAST c on b.It_code =c.It_code 
where  b.BHENT='PT' and b.ST_TYPE='LOCAL' and c.U_SHCODE in('Schedule A','Schedule-A') AND (b.DATE BETWEEN @SDATE AND @EDATE)
group by b.tran_cd,b.net_amt)a

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','K',0,@AMTA1,0,0,'')

-- 7(l) Other allowable reduction if any
--SELECT @AMTA1=isnull(SUM(AMT1),0) FROM #FORM221  WHERE (PART=1) AND (PARTSR='10B') AND SRNO IN ('B','C','D','E','F','G','H','I','J','K','L')
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

-- Added by Gaurav R. Tanna for the Bug :        -start
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'7','L',0,0,0,0,'') -- (NOT KNOW)

SELECT @AMTA1=0,@AMTB1=0
    
SELECT @AMTA1=Sum(A.tot_nontax) FROM PTITEM A  
WHERE A.Date Between @SDATE And @EDATE  
    
SELECT @AMTB1=Sum(A.tot_nontax) FROM PTMAIN A  
WHERE A.Date Between @SDATE And @EDATE  
           
Set @AMTA1 = IsNull(@AMTA1,0)   
Set @AMTB1 = IsNull(@AMTB1,0)   
        
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','L',0,(@AMTA1+@AMTB1),0,0,'')

Set @AMTA1 = 0
Set @AMTB1 = 0
-- Added by Guarav R. Tanna for the Bug :          - End    


---- 7(m) within state purchase of taxble good from register dealers eligible for set off [a-(b+c+d+e+f+g+h+i+j+k+l)]
--SELECT @AMTA1=isnull(SUM(AMT1),0) FROM #FORM221  WHERE PARTSR='7' AND SRNO IN ('B','C','D','E','F','G','H','I','J','K','L')
--SELECT @AMTA2=isnull(SUM(AMT1),0) FROM #FORM221  WHERE  PARTSR='7' AND SRNO='A'

--SET @AMTA2=(CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END)-@AMTA1

--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'7','M',0,@AMTA2-@AMTA1,0,0,'')

-- 7A Computation of purchase tax payable on the purchases effected during this period 
SELECT @AMTA1=0,@AMTB1=0,@AMTC1=0,@AMTD1=0,@AMTE1=0,@AMTF1=0,@AMTG1=0,@AMTH1=0,@AMTI1=0,@AMTJ1=0,@AMTK1=0,@AMTL1=0,@AMTM1=0,@AMTN1=0,@AMTO1=0 

INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,PARTY_NM) 
select 1,'7A','',it.rate_per,sum( CASE WHEN A.BHENT='PT' THEN a.gro_amt ELSE -ISNULL(a.gro_amt,0) END),cast((sum( CASE WHEN A.BHENT='PT' THEN a.gro_amt ELSE -ISNULL(a.gro_amt,0) END)*it.rate_per)/100 as decimal(12,2)),''  from vattbl a--(SELECT NET_AMT,it_code,bhent,vattype FROM VATTBL GROUP BY tran_cd,net_amt,it_code,bhent,vattype) A
inner JOIN vatmaster IT ON(IT.vatcategory=A.vattype )
WHERE A.BHENT in ('PT','PR','DN')  and (a.date between it.sdate and it.edate) and IT.STATE_CODE=15 and A.TAX_NAME LIKE '%VAT%' and A.ST_TYPE='LOCAL' AND A.S_TAX<>''
group by it.rate_per

select @AMTA1=SUM(AMT1),@AMTA2=SUM(AMT2) FROM #FORM221 WHERE PARTSR='7A' 
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @AMTB1=@AMTA1+@AMTA2 -- FOR 7(A)
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7A','Z',0,@AMTA1,@AMTA2,0,'')

--7(a) Turnover of purchases should also include value of Branch Transfers / Consignment Transfers received and job work charges 
SELECT @AMTA1=isnull(SUM(a.NET_AMT),0)  from 
(select b.net_amt from vattbl b 
where  b.BHENT in ('PT') AND (b.DATE BETWEEN @SDATE AND @EDATE)   
group by b.tran_cd,b.net_amt)a
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','A',0,@AMTA1+@AMTB1,0,0,'')

-- 7(m) within state purchase of taxble good from register dealers eligible for set off [a-(b+c+d+e+f+g+h+i+j+k+l)]
SELECT @AMTA1=isnull(SUM(AMT1),0) FROM #FORM221  WHERE PARTSR='7' AND SRNO IN ('B','C','D','E','E1','F','G','H','I','J','K','L')
SELECT @AMTA2=isnull(SUM(AMT1),0) FROM #FORM221  WHERE  PARTSR='7' AND SRNO='A'
SET @AMTA2=ISNULL(@AMTA2,0)
SET @AMTA1=ISNULL(@AMTA1,0)

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'7','M',0,@AMTA2-@AMTA1,0,0,'')

--8 Tax rate wise break up within the state purchase from register dealers eligible for set-off as per box 11(m) above
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,PARTY_NM) 
select 1,'8','',A.PER,sum(CASE WHEN A.BHENT='PT' THEN a.vatonamt ELSE -ISNULL(a.vatonamt,0) END),SUM(CASE WHEN A.BHENT='PT' THEN a.taxamt ELSE -ISNULL(a.taxamt,0) END),''  from vattbl a--(SELECT NET_AMT,it_code,bhent,vattype FROM VATTBL GROUP BY tran_cd,net_amt,it_code,bhent,vattype) A
WHERE A.BHENT IN ('PT','PR','DN') and A.TAX_NAME LIKE '%VAT%'   and st_type='LOCAL' AND S_TAX<>''
group by A.PER

update A SET A.AMT1=A.AMT1+B.AMT1,A.AMT2=A.AMT2+B.AMT2 FROM #FORM221 A,#FORM221 B
WHERE A.PARTSR='8' AND B.PARTSR='7A' AND (A.RATE=B.RATE)


select @AMTA1=SUM(AMT1),@AMTA2=SUM(AMT2) FROM #FORM221 WHERE PARTSR='8' 
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'8','Z',0,@AMTA1,@AMTA2,0,'')


-- 9(a)Within the State purchases of taxable goods from registered dealers eligible for set-off as per Box 12
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'9','A',0,@AMTA1,@AMTA2,0,'')


---- 9(b)The corresponding purchase price of (sch C,D & E) goods
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'9','B',0,0,0,0,'')

---- 9(b)Less:-Reduction in the amount of set off u/r 53(2) of the corresponding purchase price of (Sch B) goods
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'9','BA',0,0,0,0,'')

---- 9(c)Less:-Reduction in the amount of set-off  under any other sub rule of Rule 53
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'9','C',0,0,0,0,'')


--9(b)The corresponding purchase price of (sch C,D & E) goods
--9(b)Less:-Reduction in the amount of set off u/r 53(2) of the corresponding purchase price of (Sch B) goods
--9(c)Less:-Reduction in the amount of set-off  under any other sub rule of Rule 53

SELECT @AMTA1=0, @AMTB1 = 0, @AMTC1=0, @AMTD1 = 0
SELECT @AMTA2=0, @AMTB2 = 0, @AMTC2=0, @AMTD2 = 0

SELECT @AMTA1=Sum(VATONAMT), @AMTB1=Sum(TAXAMT) FROM Vattbl 
INNER JOIN IT_MAST ON VATTBL.It_code = IT_MAST.It_code 
WHERE IT_MAST.U_SHCODE in ('SCHEDULE C','SCHEDULE D','SCHEDULE E','SCH C','SCH D','SCH E', 'C', 'D', 'E') AND BHENT in ('PT') 
AND (DATE BETWEEN @SDATE AND @EDATE)
Set @AMTA1 = IsNull(@AMTA1,0)   
Set @AMTB1 = IsNull(@AMTB1,0)   


SELECT @AMTA2=Sum(VATONAMT), @AMTB2=Sum(TAXAMT) FROM Vattbl 
INNER JOIN IT_MAST ON VATTBL.It_code = IT_MAST.It_code 
WHERE IT_MAST.U_SHCODE in ('SCHEDULE B','SCH B', 'B') AND BHENT in ('PT') 
AND (DATE BETWEEN @SDATE AND @EDATE)
Set @AMTA2 = IsNull(@AMTA2,0)   
Set @AMTB2 = IsNull(@AMTB2,0)


SET @AMTC1= (@AMTA1 * 3/100)
SET @AMTD1= (@AMTB1 * 3/100)
Set @AMTC1 = IsNull(@AMTC1,0)   
Set @AMTD1 = IsNull(@AMTD1,0)   

SET @AMTC2= (@AMTA2 * 3/100)
SET @AMTD2= (@AMTB2 * 3/100)
Set @AMTC2 = IsNull(@AMTC2,0)   
Set @AMTD2 = IsNull(@AMTD2,0)   

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'9','B',0,(@AMTA1 - @AMTC1),(@AMTB1 - @AMTD1),0,'')

-- 9(b)Less:-Reduction in the amount of set off u/r 53(2) of the corresponding purchase price of (Sch B) goods
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'9','BA',0,(@AMTA2 - @AMTC2),(@AMTB2 - @AMTD2),0,'')

-- 9(c)Less:-Reduction in the amount of set-off  under any other sub rule of Rule 53
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'9','C',0,(@AMTC1+@AMTC2),(@AMTD1+@AMTD2),0,'')


--9(d)Add:Adjustment to set-off claimed Short in earlier return
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'9','D',0,0,0,0,'')

-- 9(e)Less:Adjustment to Excess set-off claimed in earlier return
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'9','E',0,0,0,0,'')

-- 9(f)Set-off available for the period covered of this return [a-(b+c+d+e)]
select @AMTA1=AMT1,@AMTA2=AMT2 FROM #FORM221 WHERE PARTSR='9' AND SRNO='A'
select @AMTB1=SUM(AMT1),@AMTB2=SUM(AMT2) FROM #FORM221 WHERE PARTSR='9' AND SRNO IN ('B','BA','C','D','E')
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
SET @AMTB1=CASE WHEN @AMTB1 IS NULL THEN 0 ELSE @AMTB1 END
SET @AMTB2=CASE WHEN @AMTB2 IS NULL THEN 0 ELSE @AMTB2 END

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'9','F',0,@AMTA1-@AMTB1,@AMTA2-@AMTB2,0,'')



-- 10A(a)Set off available as per Box 13(f)
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10A','A',0,@AMTA2-@AMTB2,0,0,'')


-- 10(A)b Excess credit brought forward from previous tax period
DECLARE @STARTDT SMALLDATETIME,@ENDDT SMALLDATETIME,@TMONTH INT,@TYEAR INT
SET @TMONTH=DATEDIFF(M,@SDATE,@EDATE)
SET @TYEAR=DATEDIFF(YY,@SDATE,@EDATE)
SET @STARTDT=DATEADD(Y,-@TYEAR,@STARTDT)
PRINT @STARTDT
SET @STARTDT=DATEADD(M,-(@TMONTH+1),@SDATE)
PRINT @STARTDT
SET @ENDDT=DATEADD(D,-1,@SDATE)

PRINT @TMONTH
PRINT @TYEAR
PRINT @ENDDT

select @AMTA1=SUM(A.NET_AMT) FROM JVMAIN A WHERE A.ENTRY_TY='J4' AND A.VAT_ADJ='Excess credit carried forward to  subsequent tax period' AND (A.DATE BETWEEN @STARTDT AND @ENDDT)
SET @AMTA1=ISNULL(@AMTA1,0)
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'10A','B',4,@AMTA1,0,0,'')

----14(A)c Amount already paid (Details to be entered in Box 14 E)
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'10F','C',0,0,0,0,'')

--10(A)d Excess credit if any ,as per form 234,to be adjusted against the liability as per form 233
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10A','D',0,0,0,0,'')

--10(A)e Adjustment of ET paid under Maharashtra Tax on entry of goods into local areas Act,2002/Maharashtra Tax on Entery of Motor Vehicle Act into Local Areas Act 1987
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10A','E',0,0,0,0,'')

--10(A)e1 Amount of Tax collected at source u/s 31A
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10A','E1',0,0,0,0,'')

----10(A)f Refund adjustment order No(Details to be entered in Box 14F)
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE	,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'10A','F',0,0,0,0,'')


----10(A)G Total available credit(a+b+c+d+e+e1+f+g)
--select @AMTA1=SUM(AMT1) FROM #FORM221 WHERE PARTSR='10A' AND SRNO IN ('A','B','C','D','E','E1','F')
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'10A','G',0,@AMTA1,0,0,'')


--10(B)a Sales tax Payable as per Box 6 + Purchase Tax payable as per box 7A
SELECT @AMTA1=AMT2 FROM #FORM221 WHERE PART=1 AND PARTSR='6' AND SRNO='Z'
SELECT @AMTA2=AMT2 FROM #FORM221 WHERE  PARTSR='7A' AND SRNO='Z'

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','A',0,@AMTA1+@AMTA2,0,0,'')

--10(B)b Adjustment on account of MVAT payable,if any,as per return form-234 or 235 against excess credit as
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','B',0,0,0,0,'')

--10(B)c Adjustment on account of CST payable as per return for this period
select @AmtA1=isnull(Sum(TaxAmt),0) from VATTBL where St_type = 'Out of State'  and Bhent = 'ST' and tax_name like '%C.S.T%'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','C',0,@AMTA1,0,0,'')

--10(B)d Adjustment on account of ET payable under the Maharashtra Tax on Entry of Goods into Local Areas Act, 2002/
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','D',0,0,0,0,'')

--10(B)e Amount of sales tax collected in excess of the amount of sales tax payable,if any (as per Box 10A)
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','E',0,0,0,0,'')

--10(B)f Interest Payable
select @AMTA1=SUM(C.AMOUNT) FROM (select AMOUNT from JVACDET A
LEFT OUTER JOIN JVMAIN B ON (A.TRAN_CD=B.TRAN_CD) 
WHERE B.VAT_ADJ='Interest Payable' AND (A.DATE BETWEEN @SDATE AND @EDATE) GROUP BY A.TRAN_CD,A.AMOUNT)C

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','F',0,@AMTA1,0,0,'')

--10(B)f1 Late Fee Payable
select @AMTA1=SUM(C.AMOUNT) FROM (select AMOUNT from JVACDET A
LEFT OUTER JOIN JVMAIN B ON (A.TRAN_CD=B.TRAN_CD) 
WHERE B.VAT_ADJ='Late Fees Payable' AND (A.DATE BETWEEN @SDATE AND @EDATE) GROUP BY A.TRAN_CD,A.AMOUNT)C

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','F1',0,@AMTA1,0,0,'')


----10(B)g Balance: Excess credit [10A(h)-(10B(a)+10B(b)+10B(c)+10B(d)+10B(e)+10B(f)+10B(f1))]
--SELECT @AMTA2=AMT1 FROM #FORM221 where PARTSR='10A' AND SRNO='H'
--SELECT @AMTA1=isnull(SUM(AMT1),0) FROM #FORM221  WHERE (PART=1) AND (PARTSR='10B') AND SRNO IN ('A','B','C','D','E','F','F1')
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
--SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END

--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'10B','G',0,@AMTA2-@AMTA1,0,0,'')

----14(B)h Balance:Tax Payable [(10B(a)+10B(b)+14B(c)+14B(d)+10B(e)+10B(f)+10B(f1))-10A(h)]
--SELECT @AMTA1=isnull(SUM(AMT1),0) FROM #FORM221  WHERE (PART=1) AND (PARTSR='10B') AND SRNO IN ('A','B','C','D','E','F','F1')
--SELECT @AMTA2=AMT1 FROM #FORM221 where PARTSR='10A' AND SRNO='H'

--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
--SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'10B','H',0,@AMTA1-@AMTA2,0,0,'')


--10(C)a Excess credit carried forward to subsequent tax period
select @AMTA1=SUM(A.NET_AMT) FROM JVMAIN A WHERE A.ENTRY_TY='J4' AND A.VAT_ADJ='Excess credit carried forward to  subsequent tax period' AND (A.DATE BETWEEN @SDATE AND @EDATE)
SET @AMTA1=ISNULL(@AMTA1,0)
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10C','A',0,@AMTA1,0,0,'')

----10(C)b Excess credit claimed as refund in this return [Box 10B(g)-10C(a)]
--SELECT @AMTA1=AMT1 FROM #FORM221 where PARTSR='10B' AND SRNO='G'
--SELECT @AMTA2=AMT1 FROM #FORM221 where PARTSR='10C' AND SRNO='A'

--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
--SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END

--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'10C','B',0,@AMTA1-@AMTA2,0,0,'')


----10(D)a Total Amount payable as per Box 10B(h)
--SELECT @AMTA1=AMT1 FROM #FORM221 where PARTSR='10B' AND SRNO='H'
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'10D','A',0,@AMTA1,0,0,'')

----10(D)b Amount paid along with return-cum-challan(Details to be entered in Box 10A)
--SELECT @AMTA1=AMT1 FROM #FORM221 where PARTSR='10A' AND SRNO='G'
--SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

--INSERT INTO #FORM221
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
--(1,'10D','B',0,@AMTA1,0,0,'')

--10(D)c Amount paid as per Revised/Fresh Return
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10D','C',0,0,0,0,'')

Declare @TAXONAMT as numeric(12,2),@TAXAMT1 as numeric(12,2),@ITEMAMT as numeric(12,2),@INV_NO as varchar(10),@DATE as smalldatetime,@PARTY_NM as varchar(50),@ADDRESS as varchar(100),@ITEM as varchar(50),@FORM_NM as varchar(30),@S_TAX as varchar(30),@QTY as numeric(18,4)
SELECT @TAXONAMT=0,@TAXAMT =0,@ITEMAMT =0,@INV_NO ='',@DATE ='',@PARTY_NM ='',@ADDRESS ='',@ITEM ='',@FORM_NM='',@S_TAX ='',@QTY=0

-- 10(E) Details of the Amount Paid along with this return and or  Amount Already Paid.	
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,INV_NO,DATE,PARTY_NM,ADDRESS)
SELECT 1,'10E','',0,A.NET_AMT,B.U_CHALNO,A.DATE,B.BANK_NM,C.S_TAX FROM VATTBL A
INNER JOIN BPMAIN B ON (A.TRAN_CD=B.TRAN_CD)
INNER JOIN AC_MAST C ON (B.BANK_NM=C.AC_NAME) WHERE A.AC_NAME='VAT PAYABLE'
select @AMTA1=Sum(AMT1) from #form221 where Partsr = '10E'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES  (1,'10E','Z',0,@AMTA1,0,0,'')

--10(A)c Amount already paid (Details to be entered in Box 10 E)
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10A','C',0,@AMTA1,0,0,'')

-- 10(F) Details of RAO
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,INV_NO,DATE,Party_nm) 
select 1,'10F','',0,A.NET_AMT,A.RAOSNO,A.RAODT,'' FROM JVMAIN A 
WHERE ENTRY_TY='J4' AND (A.RAOSNO<>'' OR A.RAODT<>'') and A.VAT_ADJ='' and A.PARTY_NM='VAT PAYABLE' AND (A.DATE BETWEEN @SDATE AND @EDATE)

select @AMTA1=Sum(AMT1) from #form221 where Partsr = '10F'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES  (1,'10F','Z',0,@AMTA1,0,0,'')

--10(A)f Refund adjustment order No(Details to be entered in Box 14F)
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10A','F',0,@AMTA1,0,0,'')

--10(A)G Total available credit(a+b+c+d+e+e1+f+g)
select @AMTA1=SUM(AMT1) FROM #FORM221 WHERE PARTSR='10A' AND SRNO IN ('A','B','C','D','E','E1','F')
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10A','G',0,@AMTA1,0,0,'')

--10(B)g Balance: Excess credit [10A(h)-(10B(a)+10B(b)+10B(c)+10B(d)+10B(e)+10B(f)+10B(f1))]
SELECT @AMTA2=AMT1 FROM #FORM221 where PARTSR='10A' AND SRNO='G'
SELECT @AMTA1=isnull(SUM(AMT1),0) FROM #FORM221  WHERE (PART=1) AND (PARTSR='10B') AND SRNO IN ('A','B','C','D','E','F','F1')
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','G',0,@AMTA2-@AMTA1,0,0,'')

--14(B)h Balance:Tax Payable [(10B(a)+10B(b)+14B(c)+14B(d)+10B(e)+10B(f)+10B(f1))-10A(h)]
SELECT @AMTA1=isnull(SUM(AMT1),0) FROM #FORM221  WHERE (PART=1) AND (PARTSR='10B') AND SRNO IN ('A','B','C','D','E','F','F1')
SELECT @AMTA2=AMT1 FROM #FORM221 where PARTSR='10A' AND SRNO='G'

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10B','H',0,@AMTA1-@AMTA2,0,0,'')


--10(C)b Excess credit claimed as refund in this return [Box 10B(g)-10C(a)]
SELECT @AMTA1=AMT1 FROM #FORM221 where PARTSR='10B' AND SRNO='G'
SELECT @AMTA2=AMT1 FROM #FORM221 where PARTSR='10C' AND SRNO='A'

SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END
SET @AMTA2=CASE WHEN @AMTA2 IS NULL THEN 0 ELSE @AMTA2 END

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10C','B',0,@AMTA1-@AMTA2,0,0,'')

--10(D)a Total Amount payable as per Box 10B(h)
SELECT @AMTA1=AMT1 FROM #FORM221 where PARTSR='10B' AND SRNO='H'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL or @AMTA1<0 THEN 0 ELSE @AMTA1 END
INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10D','A',0,@AMTA1,0,0,'')

--10(D)b Amount paid along with return-cum-challan(Details to be entered in Box 10A)
SELECT @AMTA1=AMT1 FROM #FORM221 where PARTSR='10A' AND SRNO='G'
SET @AMTA1=CASE WHEN @AMTA1 IS NULL THEN 0 ELSE @AMTA1 END

INSERT INTO #FORM221
(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,Party_nm) VALUES
(1,'10D','B',0,@AMTA1,0,0,'')
--------------**************************
 
 
Update #form221 set  PART = isnull(Part,0) , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
		             RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), 
					 AMT3 = isnull(AMT3,0), INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''), 
					 PARTY_NM = isnull(Party_nm,''), ADDRESS = isnull(Address,''),
					 FORM_NM = isnull(form_nm,''), S_TAX = isnull(S_tax,'')--, Qty = isnull(Qty,0),  ITEM =isnull(item,''),

 SELECT * FROM #FORM221 order by case IsNumeric(partsr) 
          WHEN 1 THEN Replicate('000', 2-Len(partsr)) + partsr +'0'
          ELSE case when len(partsr)=3 then '00' else '000' end +partsr
         END,srno
 
 END

set ANSI_NULLS OFF
--Print 'MH VAT FORM 231'



