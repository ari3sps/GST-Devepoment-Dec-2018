DROP VIEW [LITEM_VW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [LITEM_VW] AS
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.ARITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.BPITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.BRITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.CNITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.CPITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.CRITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.DCITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.DNITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.EPITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.EQITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.ESITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.IIITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.IPITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.IRITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.JVITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.OBITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.OPITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.PCITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.POITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.PTITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.PRITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.SOITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.SQITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.SRITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.SSITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.STITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID   
FROM         dbo.TRITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.ITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.OSITEM
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.sbitem
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, itserial, dc_no, party_nm, item, qty, inv_no, ware_nm, Ac_id, It_code,re_qty,TAX_NAME,TOT_DEDUC,TOT_TAX,TOT_EXAMT,TOT_ADD,TAXAMT,TOT_NONTAX,TOT_FDISC,RATE,GRO_AMT,COMPID
FROM         dbo.sditem
GO
