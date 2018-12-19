DROP VIEW [SERTAX_VW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [SERTAX_VW]
AS
SELECT ENTRY_TY,TRAN_CD,ENTRY_ALL,MAIN_TRAN,DATE,L_YN,NEW_ALL,'' AS U_SERVICE,'' AS U_SERVCESS FROM BPMALL
UNION 
SELECT ENTRY_TY,TRAN_CD,ENTRY_ALL,MAIN_TRAN,DATE,L_YN,NEW_ALL,'' AS U_SERVICE,'' AS U_SERVCESS FROM CPMALL
UNION
SELECT ENTRY_TY,TRAN_CD,ENTRY_ALL,MAIN_TRAN,DATE,L_YN,NEW_ALL,'' AS U_SERVICE,'' AS U_SERVCESS FROM BRMALL
UNION
SELECT ENTRY_TY,TRAN_CD,ENTRY_ALL,MAIN_TRAN,DATE,L_YN,NEW_ALL,'' AS U_SERVICE,'' AS U_SERVCESS FROM CPMALL
GO
