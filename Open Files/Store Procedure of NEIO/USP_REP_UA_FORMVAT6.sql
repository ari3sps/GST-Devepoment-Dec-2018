IF EXISTS (SELECT XTYPE, NAME FROM SYSOBJECTS WHERE XTYPE = 'P' AND NAME = 'USP_REP_UA_FORMVAT6')
BEGIN
	DROP PROCEDURE USP_REP_UA_FORMVAT6
END
GO
set ANSI_NULLS ON
GO
set QUOTED_IDENTIFIER ON
go

-- EXECUTE USP_REP_UA_FORMVAT6'','','','04/01/2013','03/31/2016','','','','',0,0,'','','','','','','','','2013-2016',''
-- =============================================        
-- Author   : Hetal L Patel        
-- Create date: 16/05/2007        
-- Description: This Stored procedure is useful to generate Rajashtan Form VAT - 6 (Challan) Report.        
-- Modify date: 16/05/2007        
-- Modified By: Gaurav R. Tanna, Bug-26400
-- Modify date: 18/06/2015       
-- Remark:        
-- =============================================        
CREATE PROCEDURE [dbo].[USP_REP_UA_FORMVAT6]        
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


Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)
IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
	Begin	------Fetch Records from Multi Co. Data
		 Set @MultiCo = 'YES'
		 
	End
else
	Begin ------Fetch Single Co. Data
		 Set @MultiCo = 'NO'
		 EXECUTE USP_REP_SINGLE_CO_DATA_VAT
		  @TMPAC, @TMPIT, @SPLCOND, @SDATE, @EDATE
		 ,@SAC, @EAC, @SIT, @EIT, @SAMT, @EAMT
		 ,@SDEPT, @EDEPT, @SCATE, @ECATE,@SWARE
		 ,@EWARE, @SINV_SR, @EINV_SR, @LYN, ''
		 ,@MFCON = @MCON OUTPUT
		 		 
		 --select A.TRAN_CD,A.AC_NAME, A.DATE, A.NET_AMT, B.U_CHALNO, B.BANK_NM, B.CHEQ_NO, B.U_CHQDT, B.DRAWN_ON, B.U_NATURE, M.S_TAX AS BRANCH FROM VATTBL A 
		 --INNER JOIN BPMAIN B ON (B.ENTRY_TY = A.BHENT AND B.TRAN_CD = A.TRAN_CD)
		 --INNER JOIN AC_MAST M ON (B.BANK_NM = M.AC_NAME)
		 --WHERE A.BHENT = 'BP' AND (A.DATE between @SDATE and @EDATE) AND A.AC_NAME IN ('VAT PAYABLE', 'CST PAYABLE')
		 
		 SELECT A.U_CHALNO, A.U_CHALDT, A.BANK_NM,  A.PARTY_NM, A.CHEQ_NO, A.U_CHQDT, M.S_TAX AS BRANCH, A.DRAWN_ON,
	 	 (
	 	 SELECT IsNull(Sum(B.GRO_AMT),0) FROM BPMAIN B
		 WHERE A.U_CHALNO = B.U_CHALNO AND A.U_CHALDT = B.U_CHALDT AND A.BANK_NM = B.BANK_NM AND  A.PARTY_NM = B.PARTY_NM
		 AND B.U_NATURE = '' 
		 AND A.CHEQ_NO = B.CHEQ_NO AND A.U_CHQDT = B.U_CHQDT AND A.DRAWN_ON = B.DRAWN_ON
		 ) AS TAXAMT,
		 (
		 SELECT IsNull(Sum(C.GRO_AMT),0) FROM BPMAIN C
		 WHERE A.U_CHALNO = C.U_CHALNO AND A.U_CHALDT = C.U_CHALDT AND A.BANK_NM = C.BANK_NM AND  A.PARTY_NM = C.PARTY_NM
		 AND C.U_NATURE = 'REGISTRATION FEES'
		 AND A.CHEQ_NO = C.CHEQ_NO AND A.U_CHQDT = C.U_CHQDT AND A.DRAWN_ON = C.DRAWN_ON
		 ) AS REGIAMT,
		 (
		 SELECT IsNull(Sum(D.GRO_AMT),0) FROM BPMAIN D
		 WHERE A.U_CHALNO = D.U_CHALNO AND A.U_CHALDT = D.U_CHALDT AND A.BANK_NM = D.BANK_NM AND  A.PARTY_NM = D.PARTY_NM
		 AND D.U_NATURE Not in ('', 'REGISTRATION FEES','Interest','Penalty')
		 AND A.CHEQ_NO = D.CHEQ_NO AND A.U_CHQDT = D.U_CHQDT AND A.DRAWN_ON = D.DRAWN_ON
		 ) AS OTHERAMT,
		 (
		 SELECT IsNull(Sum(E.GRO_AMT),0) FROM BPMAIN E
		 WHERE A.U_CHALNO = E.U_CHALNO AND A.U_CHALDT = E.U_CHALDT AND A.BANK_NM = E.BANK_NM AND  A.PARTY_NM = E.PARTY_NM
		 AND E.U_NATURE = 'Interest'
		 AND A.CHEQ_NO = E.CHEQ_NO AND A.U_CHQDT = E.U_CHQDT AND A.DRAWN_ON = E.DRAWN_ON
		 ) AS INTAMT,
		 (
		 SELECT IsNull(Sum(F.GRO_AMT),0) FROM BPMAIN F
		 WHERE A.U_CHALNO = F.U_CHALNO AND A.U_CHALDT = F.U_CHALDT AND A.BANK_NM = F.BANK_NM AND  A.PARTY_NM = F.PARTY_NM
		 AND F.U_NATURE = 'Penalty'
		 AND A.CHEQ_NO = F.CHEQ_NO AND A.U_CHQDT = F.U_CHQDT AND A.DRAWN_ON = F.DRAWN_ON
		 ) AS PENALTAMT
		 FROM BPMAIN A
		 INNER JOIN AC_MAST M ON (A.BANK_NM = M.AC_NAME)
		 WHERE (A.DATE BETWEEN @SDATE AND @EDATE)
		 GROUP BY A.U_CHALNO, A.U_CHALDT, A.BANK_NM,  A.PARTY_NM, A.CHEQ_NO, A.U_CHQDT, M.S_TAX, A.DRAWN_ON
	End
-----
END