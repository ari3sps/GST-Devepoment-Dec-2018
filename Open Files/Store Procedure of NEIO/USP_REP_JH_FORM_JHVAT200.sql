if EXISTS(SELECT XTYPE,NAME FROM SYSOBJECTS WHERE XTYPE='P' AND name ='USP_REP_JH_FORM_JHVAT200')
BEGIN
	DROP PROCEDURE USP_REP_JH_FORM_JHVAT200
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
EXECUTE USP_REP_JH_FORM_JHVAT200'','','','04/01/2015','03/31/2016','','','','',0,0,'','','','','','','','','2015-2016',''
*/

-- =============================================  
-- Author   : G.PrashanthReddy
-- Create date: 5/04/2012  
-- Description: This Stored procedure is useful to generate Jharkand VAT Form 200
-- Modified By: SURAJ KUMAWAT
-- Modify date: 08-08-2015
-- Remark:  Chaanges did as per new vattble procedure and USP_REP_SINGLE_CO_DATA
-- =============================================  
CREATE PROCEDURE [dbo].[USP_REP_JH_FORM_JHVAT200]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE SMALLDATETIME,@EDATE SMALLDATETIME  
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
  
DECLARE @SQLCOMMAND NVARCHAR(4000)  
DECLARE @RATE NUMERIC(12,2),@AMTA1 NUMERIC(12,2),@AMTB1 NUMERIC(12,2),@AMTC1 NUMERIC(12,2),@AMTD1 NUMERIC(12,2),@AMTE1 NUMERIC(12,2),@AMTF1 NUMERIC(12,2),@AMTG1 NUMERIC(12,2),@AMTH1 NUMERIC(12,2),@AMTI1 NUMERIC(12,2),@AMTJ1 NUMERIC(12,2),@AMTK1 NUMERIC(12,2),@AMTL1 NUMERIC(12,2),@AMTM1 NUMERIC(12,2),@AMTN1 NUMERIC(12,2),@AMTO1 NUMERIC(12,2)  
DECLARE @AMTA2 NUMERIC(12,2),@AMTB2 NUMERIC(12,2),@AMTC2 NUMERIC(12,2),@AMTD2 NUMERIC(12,2),@AMTE2 NUMERIC(12,2),@AMTF2 NUMERIC(12,2),@AMTG2 NUMERIC(12,2),@AMTH2 NUMERIC(12,2),@AMTI2 NUMERIC(12,2),@AMTJ2 NUMERIC(12,2),@AMTK2 NUMERIC(12,2),@AMTL2 NUMERIC(12,2),@AMTM2 NUMERIC(12,2),@AMTN2 NUMERIC(12,2),@AMTO2 NUMERIC(12,2)  
DECLARE @AMTA3 NUMERIC(12,2),@NARR1 VARCHAR(20)
DECLARE @PER NUMERIC(12,2),@TAXAMT NUMERIC(12,2),@CHAR INT,@LEVEL NUMERIC(12,2)--, @S_Tax VARCHAR(20)
Declare @TAXONAMT as numeric(12,2),@TAXAMT1 as numeric(12,2),@ITEMAMT as numeric(12,2),@INV_NO as varchar(10),@DATE as smalldatetime,@PARTY_NM as varchar(50),@ADDRESS as varchar(100),@ITEM as varchar(50),@FORM_NM as varchar(30),@S_TAX as varchar(30),@QTY as numeric(18,2),@u_chqdt as smalldatetime

SELECT DISTINCT AC_NAME=SUBSTRING(AC_NAME1,2,CHARINDEX('"',SUBSTRING(AC_NAME1,2,100))-1) INTO #VATAC_MAST FROM STAX_MAS WHERE AC_NAME1 NOT IN ('"SALES"','"PURCHASES"') AND ISNULL(AC_NAME1,'')<>''
INSERT INTO #VATAC_MAST SELECT DISTINCT AC_NAME=SUBSTRING(AC_NAME1,2,CHARINDEX('"',SUBSTRING(AC_NAME1,2,100))-1) FROM STAX_MAS WHERE AC_NAME1 NOT IN ('"SALES"','"PURCHASES"') AND ISNULL(AC_NAME1,'')<>''
 

Declare @NetEff as numeric (12,2), @NetTax as numeric (12,2)

----Temporary Cursor1
SELECT BHENT='PT',M.INV_NO,M.Date,A.AC_NAME,A.AMT_TY,STM.TAX_NAME,SET_APP=ISNULL(SET_APP,0),STM.ST_TYPE,M.NET_AMT,M.GRO_AMT,TAXONAMT=M.GRO_AMT+M.TOT_DEDUC+M.TOT_TAX+M.TOT_EXAMT+M.TOT_ADD,PER=STM.LEVEL1,MTAXAMT=M.TAXAMT,TAXAMT=A.AMOUNT,STM.FORM_NM,PARTY_NM=AC1.AC_NAME,AC1.S_TAX,M.U_IMPORM
,ADDRESS=LTRIM(AC1.ADD1)+ ' ' + LTRIM(AC1.ADD2) + ' ' + LTRIM(AC1.ADD3),M.TRAN_CD,VATONAMT=99999999999.99,Dbname=space(20),ItemType=space(1),It_code=999999999999999999-999999999999999999,ItSerial=Space(5)
,narr =SPACE(2001)
INTO #FORMVAT_JH200_A
FROM PTACDET A 
INNER JOIN PTMAIN M ON (A.ENTRY_TY=M.ENTRY_TY AND A.TRAN_CD=M.TRAN_CD)
INNER JOIN STAX_MAS STM ON (M.TAX_NAME=STM.TAX_NAME)
INNER JOIN AC_MAST AC ON (A.AC_NAME=AC.AC_NAME)
INNER JOIN AC_MAST AC1 ON (M.AC_ID=AC1.AC_ID)
WHERE 1=2 --A.AC_NAME IN ( SELECT AC_NAME FROM #VATAC_MAST)

alter table #FORMVAT_JH200_A add recno int identity

---Temporary Cursor2
SELECT PART=3,PARTSR='AAA',SRNO='AAA',RATE=9999999999.999,AMT1=NET_AMT,AMT2=M.TAXAMT,AMT3=M.TAXAMT,
M.INV_NO,M.DATE,PARTY_NM=AC1.AC_NAME,ADDRESS=Ltrim(AC1.Add1)+' '+Ltrim(AC1.Add2)+' '+Ltrim(AC1.Add3),STM.FORM_NM,AC1.S_TAX
,narr =SPACE(2001)
,AMT5=M.net_amt,AMT6=M.net_amt,AMT7=M.net_amt,AMT8=M.net_amt,narr1 =SPACE(20) INTO #FORMVAT_JH200

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

		--SET @SQLCOMMAND='Select * from '+@MCON
		---EXECUTE SP_EXECUTESQL @SQLCOMMAND
		SET @SQLCOMMAND='Insert InTo  #FORMVAT_JH200_A Select * from '+@MCON
		EXECUTE SP_EXECUTESQL @SQLCOMMAND
		---Drop Temp Table 
		SET @SQLCOMMAND='Drop Table '+@MCON
		EXECUTE SP_EXECUTESQL @SQLCOMMAND
	End
else
	Begin ------Fetch Single Co. Data
		 Set @MultiCo = 'NO'
		 --- EXECUTE USP_REP_SINGLE_CO_DATA_VAT --commented by suraj kumawat date on 08-08-2015
		 EXECUTE USP_REP_SINGLE_CO_DATA_VAT
		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, @EXPARA
		 ,@MFCON = @MCON OUTPUT
	End
--- 8.Inter-State 'Arrivals' otherwise than by way of sales from other states
-- Still Pending

SET @AMTA1=0
SET @AMTA2=0
SET @PER  =0

SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code )  WHERE A.BHENT='PT'
and( A.date between @SDATE and @EDATE)  AND B.U_SHCODE NOT IN('Schedule I','Schedule-I','Schedule II','Schedule-II') 
AND A.ST_TYPE ='OUT OF STATE' AND B.U_GVTYPE <> 'VAT Fuel'

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','A',@PER,@AMTA1,@AMTA2,0,'')

--9 Inter-State purchases u/s 3(a) of CST ACT 1956

--Pending for consultancy discussion

SET @AMTA1=0
SET @AMTA2=0
set @PER = 0
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','B',@PER,@AMTA1,@AMTA2,0,'')

--10 Inter-State purchases u/s 3(b) of CST ACT 1956
--Pendig for consultancy discussion
SET @AMTA1=0
SET @AMTA2=0
set @PER = 0

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','C',@PER,@AMTA1,@AMTA2,0,'')

--11.'Imports' from outside the Country

SET @AMTA1=0
SET @AMTA2=0
set @PER = 0
SELECT @AMTA1=ISNULL(SUM(VATONAMT),0),@AMTA2=ISNULL(SUM(TAXAMT),0) FROM VATTBL WHERE BHENT ='P1'
AND (DATE BETWEEN @SDATE AND @EDATE)
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','D',@PER,@AMTA1,0,0,'')

--12.Purchases of Exempted Goods(Schedule-I)

SET @AMTA1=0
SET @AMTA2=0
set @PER = 0
SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code )  WHERE A.BHENT='PT'
and( A.date between @SDATE and @EDATE)  AND B.U_SHCODE IN('Schedule I','Schedule-I') and a.TAX_NAME ='Exempted'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','E',@PER,@AMTA1,@AMTA2,0,'')  

--13.Purchase from unregistered dealers/persons 

SET @AMTA1=0
SET @AMTA2=0
set @PER = 0
SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0) FROM VATTBL A  INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE BHENT='PT'
and( A.date between @SDATE and @EDATE)  AND A.S_TAX ='' AND B.U_SHCODE not IN('Schedule I','Schedule-I','Schedule II','Schedule-II')
 AND B.U_GVTYPE <> 'VAT Fuel' and A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','F',@PER,@AMTA1,0,0,'')  

--14 Non-creditable purchases from registered dealers/persons 

--Pending for consultancy discussion.
SET @AMTA1=0
SET @AMTA2=0
set @PER = 0
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','G',@PER,0,0,0,'')  

--15.Purchases by dealers exempted u/s 57 of the Act

SET @AMTA1=0
SET @AMTA2=0
set @PER = 0

SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0) FROM VATTBL A  INNER JOIN IT_MAST B ON  (A.IT_CODE=B.IT_CODE) WHERE BHENT='PT' 
and( A.date between @SDATE and @EDATE) and A.ST_TYPE in('LOCAL','') AND A.TAX_NAME ='EXEMPTED'  
AND B.U_SHCODE not IN('Schedule I','Schedule-I','Schedule II','Schedule-II') AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','H',@PER,@AMTA1,0,0,'')  

--16.Stock transfers from branches or by a Principal or by an Agent within State***
SET @AMTA1=0
SET @AMTA2=0
set @PER = 0
SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.IT_CODE=B.It_code) 
WHERE BHENT='PT' AND U_IMPORM in('Consignment Transfer','Branch Transfer')
and( date between @SDATE and @EDATE) and A.ST_TYPE in('LOCAL','') AND B.U_SHCODE NOT IN('Schedule I','Schedule-I','Schedule II','Schedule-II') 
AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','I',@PER,@AMTA1,0,0,'')  

--17.Input tax Credit brought forward from the preceeding JVAT 200[BOX 53] 
	--Pending for Consultancy discussion.
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','J',@PER,0,0,0,'')  

--18.Eligible ITC on Purchases of Capital Goods : as per JVAT 406***
--Pending for consultancy discuss 
SET @AMTA1=0
SET @AMTA2=0
set @PER = 0
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','K',@PER,@AMTA1,0,0,'')  

--19.1% Rate Purchases(Goods listed in Part-A of schedule-II)
SET @AMTA1=0
SET @AMTA2=0
SET @PER  =0
SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0),@AMTA2=ISNULL(SUM(A.TAXAMT),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.IT_CODE=B.It_code) WHERE A.BHENT='PT' 
and( A.date between @SDATE and @EDATE) and A.PER=1 AND  B.U_SHCODE IN('Schedule II','Schedule-II')
AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','M',@PER,@AMTA1,@AMTA2,0,'')  

--20.5% Rate Purchases(Goods listed in Part-B/C of Schedule-II) wef 07.05.2011
SET @AMTA1=0
SET @AMTA2=0
SET @PER  =0
SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0),@AMTA2=ISNULL(SUM(A.TAXAMT),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.IT_CODE=B.It_code) WHERE A.BHENT='PT' 
and( A.date between @SDATE and @EDATE) and A.PER=5 AND  B.U_SHCODE IN('Schedule II','Schedule-II')
AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','N',@PER,@AMTA1,@AMTA2,0,'')

---21.10% Rate Purchases(Goods listed in Part-F of Schedule-II) wef 07.05.2011
SET @AMTA1=0
SET @AMTA2=0
SET @PER  =0
SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0),@AMTA2=ISNULL(SUM(A.TAXAMT),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.IT_CODE=B.It_code) WHERE A.BHENT='PT' 
and( A.date between @SDATE and @EDATE) and A.PER=10 AND  B.U_SHCODE IN('Schedule II','Schedule-II') AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','O',@PER,@AMTA1,@AMTA2,0,'')  


---22.14% Rate Purchases(Goods listed in Part-D of Schedule-II) wef 07.05.2011
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
SELECT @AMTA1=ISNULL(SUM(A.VATONAMT),0),@AMTA2=ISNULL(SUM(A.TAXAMT),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.IT_CODE=B.It_code) WHERE A.BHENT='PT' 
and( A.date between @SDATE and @EDATE) and A.PER=14 AND  B.U_SHCODE IN('Schedule II','Schedule-II') AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','P',@PER,@AMTA1,@AMTA2,0,'') 
---23.'Apportion' of eligible input tax credit as completed***(Attach Annexure-'A')
--Pending for consultancy discuss 
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'2','Q',@PER,0,0,0,'')  

--Part-1             
--24
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0

Select @AMTA2=isnull(Sum(amt2),0) From #FORMVAT_JH200 where PART =1 and PARTSR='2'
INSERT INTO #FORMVAT_JH200(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES (1,'2','R',0,@AMTA1,@AMTA2,0,'')

--Select @AMTA1=Round(Sum(Net_Amt),0) From #FORMVAT_JH200_A where (Date Between @Sdate and @Edate) And Bhent = 'ST' And U_imporm <> 'Purchase Return'
--Set @AMTA1 = ISNULL(@AMTA1,0)
--INSERT INTO #FORMVAT_JH200
--(PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES
--(1,'1','B',0,25,0,0,'')


-----sale part 

--25.Inter-State 'Export' sales u/s 5(1) & 5(3) of CST Act 
---
SET @AMTA1 = 0
SELECT @AMTA1=isnull(SUM(A.vatonamt),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code)
inner join stmain c on (a.bhent= c.entry_ty and a.tran_cd =c.tran_cd) where A.BHENT ='ST'
and A.TAX_NAME <> 'Exempted' and (a.date between @SDATE and @EDATE)  and A.ST_TYPE ='OUT OF STATE' AND B.U_SHCODE NOT IN('Schedule-I','Schedule-II','Schedule I','Schedule II')
AND B.U_GVTYPE <>'VAT Fuel' and c.u_nt ='FOR EXPORT'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','A',0,@AMTA1,0,0,'') 

--26.Inter-State Branch Transfers/Consignment Sales (Exempt Transactions) 
SET @AMTA1 = 0
SELECT @AMTA1=isnull(SUM(A.vatonamt),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) where A.BHENT ='ST' AND A.U_IMPORM IN('Branch Transfer','Consignment Transfer')
and A.TAX_NAME ='Exempted' and (date between @SDATE and @EDATE)  and A.ST_TYPE ='OUT OF STATE' AND B.U_SHCODE NOT IN('Schedule-I','Schedule-II','Schedule I','Schedule II')
AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','B',0,@AMTA1,0,0,'')  

--27.Inter-State Sales to the registered dealers u/s 3(a) read with the Section 8(1) of the CST Act 1956 
SET @AMTA1 = 0
SELECT @AMTA1=isnull(SUM(a.vatonamt),0) FROM VATTBL a inner join IT_MAST b on (a.It_code =b.It_code)  where a.BHENT ='ST' AND a.U_IMPORM NOT IN('Branch Transfer','Consignment Transfer')
and a.TAX_NAME <> 'Exempted' and (a.date between @SDATE and @EDATE)  and a.ST_TYPE ='OUT OF STATE' AND a.S_TAX <> '' AND B.U_SHCODE NOT IN('Schedule-I','Schedule-II','Schedule I','Schedule II')
AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','C',0,@AMTA1,0,0,'')  

--28.Inter-State Sales to the unregistered dealers u/s 3(a) read with the Section 8(2) of the CST Act 1956 
SET @AMTA1 = 0
SELECT @AMTA1=isnull(SUM(a.vatonamt),0) FROM VATTBL a inner join it_mast b on (a.It_code =b.It_code ) where a.BHENT ='ST' AND a.U_IMPORM NOT IN('Branch Transfer','Consignment Transfer')
and a.TAX_NAME <> 'Exempted' and (a.date between @SDATE and @EDATE)  and a.ST_TYPE ='OUT OF STATE' AND a.S_TAX = '' AND B.U_SHCODE NOT IN('Schedule-I','Schedule-II','Schedule I','Schedule II')
AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','D',@PER,@AMTA1,0,0,'')

--29.Inter-State Sales u/s 3(b) of the CST Act 1956 
---Pending for consultancy discuss
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','E',@PER,0,0,0,'') 

--30.Stock transfers to the branches or to a Principal to the Agent within State**** 
SET @AMTA1= 0 
SELECT @AMTA1=isnull(SUM(A.VATONAMT),0) FROM VATTBL A inner join it_mast b on (a.It_code =b.it_code) 
where A.BHENT ='ST' AND A.U_IMPORM IN('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','') and A.TAX_NAME <> 'Exempted'
 and (A.date between @SDATE and @EDATE) AND B.U_SHCODE NOT IN('Schedule I','Schedule-I','Schedule II','Schedule-II')
 AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','F',0,@AMTA1,0,0,'')

-- 31.Sale of Exempted Goods (Schedule-I Goods)
SET @AMTA1= 0 
SELECT @AMTA1=isnull(SUM(A.VATONAMT),0) FROM VATTBL A inner join it_mast b on (a.It_code =b.it_code) 
where A.BHENT ='ST' AND A.U_IMPORM NOT IN('Branch Transfer','Consignment Transfer')
and A.TAX_NAME = 'Exempted' and (A.date between @SDATE and @EDATE) AND B.U_SHCODE IN('Schedule I','Schedule-I')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','G',@PER,@AMTA1,0,0,'')  

--32.Sale of Goods by the dealers/persons exempted u/s 57 of the Act
SET @AMTA1= 0 
SELECT @AMTA1=isnull(SUM(A.VATONAMT),0) FROM VATTBL A inner join it_mast b on (a.It_code =b.it_code) 
where A.BHENT ='ST' AND A.U_IMPORM NOT IN('Branch Transfer','Consignment Transfer')
and A.TAX_NAME = 'Exempted' and (A.date between @SDATE and @EDATE) 
AND B.U_SHCODE not IN('Schedule I','Schedule-I' ,'Schedule II','Schedule-II') AND A.S_TAX =''
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','H',@PER,@AMTA1,0,0,'')  

--33.Sale of Goods to the dealers/persons exempted u/s 57 of the Act
SET @AMTA1= 0 
SELECT @AMTA1=isnull(SUM(A.VATONAMT),0) FROM VATTBL A inner join it_mast b on (a.It_code =b.it_code) 
where A.BHENT ='ST' AND A.U_IMPORM NOT IN('Branch Transfer','Consignment Transfer')
and A.TAX_NAME = 'Exempted' and (A.date between @SDATE and @EDATE) 
AND B.U_SHCODE not IN('Schedule I','Schedule-I' ,'Schedule II','Schedule-II') AND A.S_TAX <> ''

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','I',0,@AMTA1,0,0,'')
 
--34.Purchase Tax u/s 10 
----Pending for consultancy discuss
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','J',@PER,0,0,0,'')

---35.Taxable sales @1%(Goods listed in Part-A of Sch-II)
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
SELECT @AMTA1=isnull(SUM(A.VATONAMT),0),@AMTA2=isnull(SUM(A.TAXAMT),0) FROM VATTBL A inner join it_mast b on (a.It_code =b.it_code) 
where A.BHENT ='ST'  and PER =1
and (A.date between @SDATE and @EDATE) AND B.U_SHCODE IN('Schedule II','Schedule-II') AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','L',@PER,@AMTA1,@AMTA2,0,'')  

--36.Taxable sales @5%(Goods listed in Part-B/C of Schedule-II)wef.07.05.2011
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
SELECT @AMTA1=isnull(SUM(A.VATONAMT),0),@AMTA2=isnull(SUM(A.TAXAMT),0) FROM VATTBL A inner join it_mast b on (a.It_code =b.it_code) 
where A.BHENT ='ST'  and PER =5
and (A.date between @SDATE and @EDATE) AND B.U_SHCODE IN('Schedule II','Schedule-II') AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','M',@PER,@AMTA1,@AMTA2,0,'')  

--37.Taxable sales @10%(Goods listed in Part-D of Schedule-II)wef.07.05.2011

SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
SELECT @AMTA1=isnull(SUM(A.VATONAMT),0),@AMTA2=isnull(SUM(A.TAXAMT),0) FROM VATTBL A inner join it_mast b on (a.It_code =b.it_code) 
where A.BHENT ='ST'  and PER =10
and (A.date between @SDATE and @EDATE) AND B.U_SHCODE IN('Schedule II','Schedule-II') AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','N',@PER,@AMTA1,@AMTA2,0,'')

--38.Taxable sales @14%(Goods listed in Part-D of Schedule-II)wef.07.05.2011
SET @AMTA1=0
SET @AMTA2=0
SET @PER=0
SELECT @AMTA1=isnull(SUM(A.VATONAMT),0),@AMTA2=isnull(SUM(A.TAXAMT),0) FROM VATTBL A inner join it_mast b on (a.It_code =b.it_code)
where A.BHENT ='ST'  and PER =14
and (A.date between @SDATE and @EDATE) AND B.U_SHCODE IN('Schedule II','Schedule-II') AND B.U_GVTYPE <>'VAT Fuel'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','O',@PER,@AMTA1,@AMTA2,0,'')  

--39 
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA2=SUM(AMT2) FROM #FORMVAT_JH200 WHERE PART=1 AND PARTSR =3 AND SRNO IN('J','L','M','N','O')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','P',@PER,@AMTA1,@AMTA2,0,'')
--40
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=SUM(AMT2) FROM #FORMVAT_JH200 WHERE PART=1 AND PARTSR =3 AND SRNO IN('J','L','M','N','O')
Select @AMTA2=isnull(Sum(amt2),0) From #FORMVAT_JH200 where PART =1 and PARTSR='2' and srno <>'R'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','Q',@PER,0,(@AMTA1-@AMTA2),0,'')
--41 
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA2=SUM(AMT2) FROM #FORMVAT_JH200 WHERE PART=1 AND PARTSR =3 AND SRNO IN('J','L','M','N','O')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'3','R',@PER,@AMTA1,@AMTA2,0,'')  


--Part-4
--42.Add: The Amount of Tax: Payable on sales of Goods Specifird in Part -E of Schedule II
-- (a) Taxable Purchases/Transfers of Goods specified in Part-E of Schedule-II : Petrol
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%PETROL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER =0 AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'4','A',@PER,@AMTA1,0,0,'')  

---(b) Taxable Purchases/Transfers of Goods specified in Part-E of Schedule-II : Diesel
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%DIESEL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER =0  AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'4','B',@PER,@AMTA1,0,0,'')  

---(c) Taxable Purchases/Transfers of Goods specified in Part-E of Schedule-II : ATF
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%ATF%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER =0  AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'4','C',@PER,@AMTA1,0,0,'')  

---(d) Taxable Purchases of Goods specified in Part-E of Schedule-II : IMFL
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%IMFL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER =0  AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'4','D',@PER,@AMTA1,0,0,'')  

---(e) Taxable Purchases of Goods specified in Part-E of Schedule-II : Country liquor
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%COUNTRY LIQUOR%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER =0 AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'4','E',@PER,@AMTA1,0,0,'')  

---(f) Taxable Purchases of Goods specified in Part-E of Schedule-II : Other goods
--- Pending for consutancy discuss
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'4','F',@PER,0,0,0,'')  

--Part-5
---(a) Tax Paid Purchases of Goods specified in Part-E of Schedule-II : Petrol
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%PETROL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'5','A',@PER,@AMTA1,@AMTA2,0,'')  

--(b) Tax Paid Purchases of Goods specified in Part-E of Schedule-II : Diesel
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%DIESEL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'5','B',@PER,@AMTA1,@AMTA2,0,'')  


--(c) Tax Paid Purchases of Goods specified in Part-E of Schedule-II : ATF
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%ATF%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'5','C',@PER,@AMTA1,@AMTA2,0,'')  

---(d) Tax Paid Purchases of Goods specified in Part-E of Schedule-II : IMFL
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%IMFL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'5','D',@PER,@AMTA1,@AMTA2,0,'')  

----(e) Tax Paid Purchases of Goods specified in Part-E of Schedule-II: Country liquor
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='PT' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%COUNTRY LIQUOR%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'5','E',@PER,@AMTA1,@AMTA2,0,'')  
---(f) Tax Paid Purchases of Goods specified in Part-E of Schedule-II : Other goods
 ---Pending for consultancy discuss 
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'5','F',@PER,0,0,0,'')  


--Part-6
--(a) Taxable Sales of Goods specified in Part-E of Schedule-II : Petrol- oil companies to another oil company 
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%PETROL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER = 0  AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','A',@PER,@AMTA1,0,0,'')  

---(b) Taxable Sales of Goods specified in Part-E of Schedule-II : Diesel- oil companies to another oil company
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%DIESEL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER = 0  AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','B',@PER,@AMTA1,0,0,'')  

--(c) Taxable Sales of Goods specified in Part-E of Schedule-II : ATF- oil companies to another oil company
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%ATF%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER = 0  AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','C',@PER,@AMTA1,0,0,'')

---(a) Taxable Sales of Goods specified in Part-E of Schedule-II : Petrol- oil companies to the dealers.

SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%PETROL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','') AND A.U_IMPORM not in('Branch Transfer','Consignment Transfer')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','D',@PER,@AMTA1,@AMTA2,0,'')  

---(b) Taxable Sales of Goods specified in Part-E of Schedule-II : Diesel- oil companies to the dealers.
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%DIESEL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','') AND A.U_IMPORM not in('Branch Transfer','Consignment Transfer')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','E',@PER,@AMTA1,@AMTA2,0,'')

--- (c) Taxable Sales of Goods specified in Part-E of Schedule-II : ATF- oil companies to the dealers.

SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%ATF%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.U_IMPORM not in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','F',@PER,@AMTA1,@AMTA2,0,'')

---(d) Taxable Sales of Goods specified in Part-E of Schedule-II : IMFL

SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST' 
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%IMFL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','') AND A.U_IMPORM not in('Branch Transfer','Consignment Transfer')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','G',@PER,@AMTA1,@AMTA2,0,'')

---(e) Taxable Sales of Goods specified in Part-E of Schedule-II : Country liquor

SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%COUNTRY LIQUOR%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.ST_TYPE IN('LOCAL','') AND A.U_IMPORM not in('Branch Transfer','Consignment Transfer')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','H',@PER,@AMTA1,@AMTA2,0,'')
--(f) Taxable Sales of Goods specified in Part-E of Schedule-II : Other goods
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','I',@PER,0,0,0,'')  

---(g) Sales to another oil company of Petrol
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%PETROL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE NOT IN('Schedule II','Schedule-II')
and a.PER = 0 AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','J',@PER,@AMTA1,0,0,'')  

--(h) Sales to another oil company of Diesel
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%DIESEL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE NOT IN('Schedule II','Schedule-II')
and a.PER = 0  AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','K',@PER,@AMTA1,0,0,'')  

--(i) Sales to another oil company of ATF
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%ATF%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE NOT IN('Schedule II','Schedule-II')
and a.PER = 0  AND A.U_IMPORM in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','L',@PER,@AMTA1,0,0,'') 
 
--(a) Tax Paid Sales of Goods specified in Part-E of Schedule-II : Petrol
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%PETROL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE  IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.U_IMPORM NOT in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','M',@PER,@AMTA1,0,0,'')  
--(b) Tax Paid Sales of Goods specified in Part-E of Schedule-II : Diesel
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%DIESEL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE  IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.U_IMPORM NOT in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','N',@PER,@AMTA1,0,0,'')  

--(c) Tax Paid Sales of Goods specified in Part-E of Schedule-II : ATF
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0),@AMTA2=isnull(sum(A.taxamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%ATF%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE  IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.U_IMPORM NOT in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','O',@PER,@AMTA1,0,0,'')  

--(d) Tax Paid Sales of Goods specified in Part-E of Schedule-II : IMFL
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0)  FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%IMFL%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.U_IMPORM NOT in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','P',@PER,@AMTA1,0,0,'')  

--(e) Tax Paid Sales of Goods specified in Part-E of Schedule-II : Country liquor
SET @AMTA1=0
SET @AMTA2=0
SELECT @AMTA1=isnull(sum(A.vatonamt),0) FROM VATTBL A INNER JOIN IT_MAST B ON (A.It_code =B.It_code) WHERE a.BHENT ='ST'
and A.VATTYPE='VAT Fuel'  AND B.it_name LIKE '%COUNTRY LIQUOR%' AND ( A.Date BETWEEN @SDATE AND  @EDATE ) AND B.U_SHCODE IN('Schedule II','Schedule-II')
and a.PER <> 0  AND A.U_IMPORM  NOT in('Branch Transfer','Consignment Transfer') AND A.ST_TYPE IN('LOCAL','')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','Q',@PER,@AMTA1,0,0,'')
--(f) Tax Paid Sales of Goods specified in Part-E of Schedule-II : Other goods
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'6','R',@PER,0,0,0,'')  

--44


---THIS CODE FOR OUT PUT TAX PAYABLE 

SET @AMTA1=0
SET @AMTA2=0
SET @AMTB1=0
SET @AMTB2=0

---PT
Select @AMTA1=isnull(Sum(amt2),0) From #FORMVAT_JH200 where PART =1 and PARTSR='2' and srno <>'R'
---ST
SELECT @AMTA2=SUM(AMT2) FROM #FORMVAT_JH200 WHERE PART=1 AND PARTSR =3 AND SRNO IN('J','L','M','N','O')
--PT
Select @AMTB1=isnull(Sum(amt2),0) From #FORMVAT_JH200 where PART =1 and PARTSR='5' 
--ST
select @AMTB2=isnull(SUM(amt2),0) from #FORMVAT_JH200 where PART=1 and PARTSR='6' 
PRINT (@AMTA2+@AMTB2)-(@AMTA1 + @AMTB1)  --OUTPUT TAX PAYABLE

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'7','A',@PER,((@AMTA2+@AMTB2)-(@AMTA1 + @AMTB1)),0,0,'') 

 --- Pending for consultancy discuss
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'7','B',@PER,0,0,0,'')  
 --- Pending for consultancy discuss
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'7','C',@PER,0,0,0,'')  

--- Pending for consultancy discuss
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'7','D',@PER,0,0,0,'')  

--- Pending for consultancy discuss
---INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'7','E',@PER,0,0,0,'')  

--BALANCE VAT PAYABLE FOR THIS YEAR
set @AMTA1 = 0
select @AMTA1=isnull(SUM(amt1),0) from #FORMVAT_JH200 where PART=1 and PARTSR='7' and SRNO='A'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'7','F',@PER,@AMTA1,0,0,'')

----Payment deposit detials
	INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX) SELECT 1 AS PART
	,'8' AS PARTSR,'A' AS SRNO,0 AS RATE,0 AS AMT1,0 AS AMT2,A.NET_AMT,A.U_CHALNO,A.U_CHALDT,BANK_NM,A.U_NATURE
,'' AS FORM_NM,B.BSRCODE  FROM BPMAIN A INNER JOIN AC_MAST B ON A.BANK_NM=B.AC_NAME WHERE A.ENTRY_TY='BP' AND A.PARTY_NM='VAT PAYABLE' AND (A.DATE BETWEEN @SDATE AND @EDATE)

if not exists(select top 1 srno from #FORMVAT_JH200 where PART=1 and PARTSR='8')
begin
	INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX) 
   VALUES (1,'8','A',0,0,0,0,0,NULL,'','','','')
end

--51

SET @AMTA2=0
set @AMTA1 = 0
select @AMTA1=isnull(SUM(amt1),0) from #FORMVAT_JH200 where PART=1 and PARTSR='7' and SRNO='A'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'9','',@PER,0,(case when(@AMTA1)< 0  then ABS(@AMTA1) else 0 end),0,'')

--Part-10

----- Pending for consultancy discuss
--INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'10','A',@PER,0,0,0,'')  

----Pending for consultancy
--INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'10','B',@PER,0,0,0,'')  
----Pending for consultancy discuss.
set @AMTA1 = 0
SELECT @AMTA1=isnull(SUM(a.TAXAMT),0) FROM VATTBL a inner join IT_MAST b on (a.It_code =b.It_code)  where a.BHENT ='ST' AND a.U_IMPORM NOT IN('Branch Transfer','Consignment Transfer')
and a.TAX_NAME <> 'Exempted' and (a.date between @SDATE and @EDATE)  and a.ST_TYPE ='OUT OF STATE' AND a.S_TAX <> '' AND B.U_SHCODE NOT IN('Schedule-I','Schedule-II','Schedule I','Schedule II')
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'10','C',@PER,@AMTA1,0,0,'')  

--Pending for consultancy discuss.
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'10','D',@PER,0,0,0,'')  

--Part-11

set @AMTA1 = 0
set @AMTA2 = 0
SELECT @AMTA1=COUNT(a.VATONAMT),@AMTA2=isnull(SUM(a.VATONAMT),0) FROM VATTBL a inner join IT_MAST b on (a.It_code =b.It_code) 
 where a.BHENT ='PT' 
AND (a.date between @SDATE and @EDATE) AND LTRIM(RTRIM(REPLACE(replace(REPLACE(A.FORM_NM,'JVAT',''),'-',''),'FORM',''))) in('504G','504-G','504 G') ---='504G' -- AND A.FORM_NM='JVAT 504G'

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'11','A',@PER,0,@AMTA1,@AMTA2,'')  

--Part-12
set @AMTA1 = 0
set @AMTA2 = 0
SELECT @AMTA1=COUNT(a.VATONAMT),@AMTA2=isnull(SUM(a.VATONAMT),0) FROM VATTBL a inner join IT_MAST b on (a.It_code =b.It_code) 
 where a.BHENT ='ST' 
AND (a.date between @SDATE and @EDATE)
and LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(A.RFORM_NM,'JVAT',''),'-',''),'FORM','')))in('504B','504-B','504 B')--='504B'

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'12','',@PER,0,@AMTA1 ,@AMTA2,'')  

--Part-13
set @AMTA1 = 0
set @AMTA2 = 0
SELECT @AMTA1=COUNT(a.VATONAMT),@AMTA2=isnull(SUM(a.VATONAMT),0) FROM VATTBL a inner join IT_MAST b on (a.It_code =b.It_code)  where a.BHENT ='ST' 
and LTRIM(RTRIM(replace(REPLACE(REPLACE(A.RFORM_NM,'JVAT',''),'-',''),'FORM','')))in('504P','504-P','504 P')---='504P'
 AND (a.date between @SDATE and @EDATE) 

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'13','',@PER,0,@AMTA1,@AMTA2,'')  


--Part-14
set @AMTA1 = 0
set @AMTA2 = 0
SELECT @AMTA1=COUNT(a.VATONAMT),@AMTA2=isnull(SUM(a.VATONAMT),0) FROM VATTBL a inner join IT_MAST b on (a.It_code =b.It_code) 
 where a.BHENT ='PT' 
AND (a.date between @SDATE and @EDATE) 
and LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(A.FORM_NM,'JVAT',''),'-',''),'FORM','')))in('504P','504-P','504 P')---='504P'
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'14','',@PER,0,@AMTA1,@AMTA2,'')  

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX,narr)
VALUES (1,'15','A',0,0,0,0,'',NULL,'Taxable @ 1%',@ADDRESS,@FORM_NM,@S_TAX,(Select ''+rtrim(B.u_vatitm)+ ','  From VATTBL A Inner Join It_mast B on (A.It_code=B.It_code) Where a.bhent in('PT','ST') and a.PER = 1 and (a.date  between @sdate and @edate) and b.u_vatitm <> '' Group by b.u_vatitm Order By b.u_vatitm For XML Path('')))

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX,narr)
VALUES (1,'15','A',0,0,0,0,'',NULL,'Taxable @ 4/5%',@ADDRESS,@FORM_NM,@S_TAX,(Select ''+rtrim(B.u_vatitm)+ ','  From VATTBL A Inner Join It_mast B on (A.It_code=B.It_code) Where a.bhent in('PT','ST') and a.PER IN(4,5) and (a.date  between @sdate and @edate) and b.u_vatitm <> '' Group by b.u_vatitm Order By b.u_vatitm For XML Path('')))

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX,narr)
VALUES (1,'15','A',0,0,0,0,'',NULL,'Taxable @ 10%/12.5%,14%',@ADDRESS,@FORM_NM,@S_TAX,(Select ''+rtrim(B.u_vatitm)+ ','  From VATTBL A Inner Join It_mast B on (A.It_code=B.It_code) Where a.bhent in('PT','ST') and a.PER IN(10,12.5,14) and (a.date  between @sdate and @edate) and b.u_vatitm <> ''  Group by b.u_vatitm Order By b.u_vatitm For XML Path('')))

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX,narr)
VALUES (1,'15','A',0,0,0,0,'',NULL,'Exempted Goods',@ADDRESS,@FORM_NM,@S_TAX,(Select ''+rtrim(B.u_vatitm)+ ','  From VATTBL A Inner Join It_mast B on (A.It_code=B.It_code) Where a.bhent in('PT','ST') and a.PER=0 and (a.date  between @sdate and @edate) and b.u_vatitm <> '' and a.TAX_NAME ='EXEMPTED' Group by b.u_vatitm Order By b.u_vatitm For XML Path('')))
	
--Part-16
INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX) select 
1 as part,'16' as partsr,'A' as srno,per,0 as TAXONAMT,isnull(sum(TAXAMT),0),isnull(sum(vatonamt),0),'' as invno
,'' as date,AC_NAME,ADDRESS,'' as FORM_NM,S_TAX from vattbl where bhent='PT' AND( DATE BETWEEN @SDATE AND @EDATE) AND PER <> 0
 group by per,AC_NAME,ADDRESS,S_TAX ORDER BY PER
if not exists(select top 1 part from #FORMVAT_JH200 where PART =1 and PARTSR ='16' )
begin
	INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,INV_NO,DATE,PARTY_NM,ADDRESS,FORM_NM,S_TAX)
	 VALUES (1,'16','A',0,0,0,0,'','','','','','')
end

INSERT INTO #FORMVAT_JH200 (PART,PARTSR,SRNO,RATE,AMT1,AMT2,AMT3,PARTY_NM) VALUES  (1,'17','',@PER,0,0,0,'')

--- following code for point no. 5 to 8 begining for the page
--TOTAL TURNOVER OF SALES SUM
PRINT 'A ' 
set @AMTA1 = 0
select @AMTA1 = isnull(SUM(vatonamt),0) from vattbl where BHENT ='ST' AND (DATE BETWEEN @sDATE AND @EDATE) 
PRINT @AMTA1
set @AMTA2 = 0 -- NON TAXABLE SALE TAX AMT 

PRINT 'C ' 
set @AMTA3 = 0 --SALES RETURN SUM
select @AMTA3 = isnull(SUM(vatonamt),0) from vattbl where BHENT ='SR' AND (DATE BETWEEN @sDATE AND @EDATE)
PRINT @AMTA3
-- total turnover of the sales
set @AMTB1 = (@AMTA1)-(@AMTA2+@AMTA3)

---
SET @NARR1 = ''
SELECT @NARR1 =(case when MAX(VATONAMT) <>0  then '' ELSE 'NIL' END) FROM VATTBL WHERE BHENT IN('PT','ST')  
AND (DATE BETWEEN @sDATE AND @EDATE)
PRINT @AMTB1

---Updating Null Values with spaces or Zeros
Update #FORMVAT_JH200 set  PART = isnull(Part,0) , Partsr = isnull(PARTSR,''), SRNO = isnull(SRNO,''),
		             RATE = isnull(RATE,0), AMT1 = isnull(AMT1,0), AMT2 = isnull(AMT2,0), 
					 AMT3 = isnull(AMT3,0), INV_NO = isnull(INV_NO,''), DATE = isnull(Date,''), 
					 PARTY_NM = isnull(Party_nm,''), ADDRESS = isnull(Address,''), 
					 FORM_NM = isnull(form_nm,''), S_TAX = isnull(S_tax,'') 
					 ,NARR1=ISNULL(@NARR1,''),AMT5=@AMTA1,AMT6=@AMTA2, AMT7=@AMTA3 ,AMT8=@AMTB1
					 

  
SELECT * FROM #FORMVAT_JH200 order by cast(substring(partsr,1,case when (isnumeric(substring(partsr,1,2))=1) then 2 else 1 end) as int)  

  
END  
