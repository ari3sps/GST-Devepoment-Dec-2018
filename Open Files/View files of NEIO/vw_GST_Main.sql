DROP VIEW [vw_GST_Main]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [vw_GST_Main]
AS
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
             m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id,cons_id=0,scons_id=0,m.Inv_sr,U_CLDT=Case when Entry_ty='RV' then m.date else m.u_cldt end,amenddate
             ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         BPMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT,
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id,cons_id=0,scons_id=0,m.Inv_sr ,m.date as U_CLDT,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         BRMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT,
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id,cons_id,scons_id,m.Inv_sr,U_CLDT =(case when m.AGAINSTGS in('SERVICE PURCHASE BILL','PURCHASES')then m.U_CLDT else m.date end),amenddate
                      ,AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         CNMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id=0,cons_id=0,scons_id=0,m.Inv_sr,m.date as U_CLDT,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         CPMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id=0,cons_id=0,scons_id=0,m.Inv_sr,m.DATE as U_CLDT,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         CRMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id,cons_id=0,scons_id=0,m.Inv_sr,U_CLDT =(case when m.AGAINSTGS in('SERVICE PURCHASE BILL','PURCHASES')then m.U_CLDT else m.date end),amenddate
                      ,AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         DNMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id,cons_id=0,scons_id=0,m.Inv_sr,m.date as U_CLDT,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         EPMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id=0,cons_id=0,scons_id=0,m.Inv_sr,U_CLDT=(CASE WHEN  ENTRY_TY = 'GA' THEN ADJ_DATE ELSE U_CLDT END),amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         JVMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, SGST_AMT=0, CGST_AMT=0, 
                      IGST_AMT=0, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id=0,cons_id=0,scons_id=0,m.Inv_sr,U_CLDT,amenddate=0
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         OBMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, SGST_AMT=0, CGST_AMT=0, 
                      IGST_AMT=0, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id=0,cons_id=0,scons_id=0,m.Inv_sr,U_CLDT,amenddate=0
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         OSMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, SGST_AMT=0, CGST_AMT=0, 
                      IGST_AMT=0, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,sac_id=0,cons_id=0,scons_id=0,m.Inv_sr,M.DATE as U_CLDT,amenddate=0
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         PCMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,m.sac_id,m.cons_id,m.scons_id,m.Inv_sr
                      --,m.U_CLDT  --Commented by Priyanka B on 31052018 for Bug-31578
					, M.DATE as U_CLDT  --Modified by Priyanka B on 31052018 for Bug-31578
                      ,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         PRMAIN m
Union all
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,m.sac_id,m.cons_id,m.scons_id,m.Inv_sr
                      --,m.U_CLDT  --Commented by Priyanka B on 04042018 for AU 13.0.6
                      ,M.DATE as U_CLDT  --Added by Priyanka B on 04042018 for AU 13.0.6
                      ,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         PTMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,m.sac_id,m.cons_id,m.scons_id,m.Inv_sr,m.Date as U_CLDT,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         SRMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,m.sac_id,m.cons_id,m.scons_id,m.Inv_sr,m.date as U_CLDT,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         STMAIN m
UNION All
SELECT     m.Entry_ty, m.Tran_cd, m.Ac_Id, m.DATE,m.Inv_no, m.Pinvdt, m.Pinvno, m.tot_deduc, m.tot_add, m.SGST_AMT, m.CGST_AMT, 
                      m.IGST_AMT, m.tot_examt, m.taxamt, m.tot_nontax, m.tot_fdisc, m.Gro_Amt, m.Net_Amt,m.party_nm,m.sac_id,m.cons_id,m.scons_id,m.Inv_sr,m.date as U_CLDT,amenddate
                      ,'' as AGAINSTGS  --Added by Priyanka B on 28052018 for Bug-31569
FROM         SBMAIN m
GO
