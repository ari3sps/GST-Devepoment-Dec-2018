DROP VIEW [lac_multi_vw]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Create date: 
-- Description:	This View contains All Transaction __AcDet Tables and is used for  Reports.
-- Modification Date/By/Reason: 27/07/2011 Rupesh Prajapati. Change date as u_cldt for ObAcDet TKT-8968
-- Remark: 
-- =============================================

CREATE VIEW [lac_multi_vw]
AS
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.ARACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.BPACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.BRACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.CNACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.CPACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.CRACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.DCACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.DNACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.EPACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.EQACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.ESACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.IIACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.IPACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.IRACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.JVACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr,u_cldt, l_yn, Re_all, Disc, 
			Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.OBACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.OSACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.OPACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.PCACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.POACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.PRACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.PTACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.SOACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.SQACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.SRACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.SSACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.STACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.SBACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,0 as FCID,0 as fcamount,0 as fcexrate,0 as FCRE_ALL,0 as fcdisc,0 as fctds	--birendra
FROM         dbo.SDACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, CONVERT(SmallDateTime, 
                      SPACE(8)) AS u_cldt, l_yn, Re_all, Disc, Tds,compid
					,FCID,fcamount,fcexrate,FCRE_ALL,fcdisc,fctds	--birendra
FROM         dbo.TRACDET
UNION ALL
SELECT     Tran_cd, entry_ty, date, doc_no, AC_ID,ACSERIAL, ac_name, amount, amt_ty, dept, cate, inv_sr, inv_no, oac_name, clause, narr, u_cldt, l_yn, Re_all, Disc, 
                      Tds,compid
					,0 as FCID,0 as fcamount,0 as fcexrate,0 as FCRE_ALL,0 as fcdisc,0 as fctds	--birendra
FROM         dbo.ACDET
GO
