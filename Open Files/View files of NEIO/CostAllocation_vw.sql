DROP VIEW [CostAllocation_vw]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [CostAllocation_vw]
AS
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.stcall
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.cpcall
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.OBCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.BPCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.BRCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.CNCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.CRCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.DNCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.EPCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.IICALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.IRCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.JVCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.OSCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.PTCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.PCCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.PRCALL
union all
SELECT     Entry_ty, date, doc_no, inv_no, tran_cd, Ac_name, ac_id, inv_sr, l_yn, date_all, compid, cost_cen_id, cost_cen_name, amount
FROM         dbo.SRCALL
GO
