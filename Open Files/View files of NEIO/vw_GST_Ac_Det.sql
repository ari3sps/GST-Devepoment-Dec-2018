DROP VIEW [vw_GST_Ac_Det]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [vw_GST_Ac_Det]
AS

SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         BPAcDet ac 
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         BRAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,cast('' as datetime) as u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         CNAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         CPAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,cast('' as datetime) as u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         CRAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,cast('' as datetime) as u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         DNAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,cast('' as datetime) as u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         EPAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         JVAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         OBAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         OSAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,cast('' as datetime) as u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         PCAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,cast('' as datetime) as u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         PRAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         PTAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         SRAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         STAcdet ac
UNION ALL
SELECT     ac.entry_ty, ac.Tran_cd, ac.AcSerial, ac.date, ac.Ac_id, ac.Amount, ac.Amt_Ty, ac.L_Yn
,ac.doc_no,ac.u_cldt  --Added by Priyanka B on 26062018 for Bug-31664, 31666 & 31667
FROM         SBAcdet ac
GO
