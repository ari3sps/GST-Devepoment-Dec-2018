DROP VIEW [itSrTrn_vw]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [itSrTrn_vw]
AS
SELECT     Entry_ty, Date, Tran_cd, inv_no, Itserial, It_code, Qty, REntry_ty, RDate, RTran_cd, Rinv_no, RItserial, Rqty, Dc_No, iTran_cd, pmKey, WARE_NM, WARE_NMFR
FROM         dbo.it_SrTrn
UNION ALL
SELECT     Entry_ty, Date, Tran_cd, inv_no, Itserial, It_code, Qty, REntry_ty, RDate, RTran_cd, Rinv_no, RItserial, Rqty, Dc_No, iTran_cd, pmKey, WARE_NM, WARE_NMFR
FROM         dbo.StkResrvSrTrn
GO
