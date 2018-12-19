DROP VIEW [GSTR2_VW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [GSTR2_VW]
AS

SELECT 
/* --- Commentned by Suraj Kumawat date on 24-08-2017 
ST_TYPE = (case when Cons_st_type IN('INTRASTATE','INTERSTATE','') and Cons_SUPP_TYPE  not in('Export','Import','SEZ','EOU') AND  ISNULL(POS,'') = (select TOP 1 state from vudyog..co_mast where dbname = DB_NAME()) THEN 'INTRASTATE'
when Cons_st_type IN('INTRASTATE','INTERSTATE','') and Cons_SUPP_TYPE not in('Export','Import','SEZ','EOU') AND  (ISNULL(POS,'') <> (select state from vudyog..co_mast where dbname = DB_NAME())) THEN 'INTERSTATE' ELSE Cons_ST_TYPE  END)
*/ 
ST_TYPE = Cons_ST_TYPE
,SUPP_TYPE =Cons_SUPP_TYPE
,GSTIN = isnull(Cons_gstin,'')
,*  FROM (

--- Self Inovice 
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER 
,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0) as SGST_PER,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,ORG_INVNO=H.inv_no, ORG_DATE=H.date  
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT,ISNULL(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT,isnull(h.net_amt,0) as net_amt,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt,isnull(D.COMRPCESS,0) As CessRT_amt
,'Taxable' as LineRule  
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS,AmendDate = (case when DATEDIFF(MM,H.DATE,H.AmendDAte) > 0 then h.AmendDate else ''  end )
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE ='' 
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =''
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN  end)
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN else  seller_ac.GSTIN  end) --- Added by Suraj kumawat date on 26-08-2017 
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END)
 ,AVL_ITC = ISNULL(D.ECredit,0)
 , '' as beno , '' as BEDT
 ,d.gstrate ,'' as portcode ,h.OLDGSTIN
 ,orgbeno = '',orgbedt = ''
FROM STMAIN H INNER JOIN
  STITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id) WHERE H.entry_ty ='UB'
UNION ALL 

/* Amendment for self inovice details */
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER 
,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0) as SGST_PER,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,ORG_INVNO=H.inv_no, ORG_DATE=H.date  
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT,ISNULL(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT,isnull(h.net_amt,0) as net_amt,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt,isnull(D.COMRPCESS,0) As CessRT_amt
,'Taxable' as LineRule  
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS,AmendDate = ''
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE ='' 
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =''
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN  end)
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN else  seller_ac.GSTIN  end) --- Added by Suraj kumawat date on 26-08-2017 
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END)  --- Added by suraj Kumawat date on 26-08-2017 
 ,AVL_ITC = ISNULL(D.ECredit,0)
 , '' as beno , '' as BEDT
 ,d.gstrate ,'' as portcode ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM STMAINAM H INNER JOIN
  STITEMAM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id) WHERE H.entry_ty ='UB'
  
union all 
--- Purchase Transaction
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE 
,D.IT_CODE,D.QTY,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT
,isnull(d.SGST_PER,0) as SGST_PER,isnull(D.SGST_AMT,0)as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0)as IGST_AMT
,ORG_INVNO=(case when ISNULL(AMD.pinvno,'') <> ''  then  AMD.pinvno else H.pinvno end), ORG_DATE=(case when ISNULL(AMD.Pinvdt,'') <> ''  then  AMD.Pinvdt else H.Pinvdt  end)
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT 
,isnull(D.GRO_AMT,0) as GRO_AMT,isnull(h.net_amt,0)as net_amt,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt
,isnull(D.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS,AmendDate = (case when DATEDIFF(MM,H.DATE,H.AmendDAte) > 0 then h.AmendDate else ''  end )
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin = (case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN end)
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN else  seller_ac.GSTIN end) 
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS 
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END) --- Added by Suraj Kumawat date on 26-08-2017
 ,AVL_ITC = ISNULL(D.ECredit,0), H.beno , H.BEDT  
 ,d.gstrate
 ,portcode=isnull(H.portcode,'')
 ,h.OLDGSTIN
 ,orgbeno =amd.BENO,orgbedt = amd.BEDT
FROM PTMAIN H INNER JOIN
  PTITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id) 
  LEFT OUTER JOIN PTMAINAM AMD ON(H.entry_ty =AMD.ENTRY_TY AND H.Tran_cd =AMD.TRAN_CD )
  --WHERE H.entry_ty IN('PT','P1')  --Commented by Priyanka B on 07122018 for Bug-31930
  
/*Purchase Transaction Amend details */
 Union all
 SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE 
,D.IT_CODE,D.QTY,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT
,isnull(d.SGST_PER,0) as SGST_PER,isnull(D.SGST_AMT,0)as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0)as IGST_AMT
,ORG_INVNO=H.inv_no, ORG_DATE=H.date
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT 
,isnull(D.GRO_AMT,0) as GRO_AMT,isnull(h.net_amt,0)as net_amt,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt
,isnull(D.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS,AmendDate = ''
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin = (case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN end)
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN else  seller_ac.GSTIN end) 
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS 
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END) --- Added by Suraj Kumawat date on 26-08-2017
 ,AVL_ITC = ISNULL(D.ECredit,0), H.beno , h.BEDT
 ,d.gstrate
 ,portcode=isnull(H.portcode,'')
 ,h.OLDGSTIN
 ,orgbeno = '',orgbedt = ''
FROM PTMAINAM H INNER JOIN
  PTITEMAM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id)
  --WHERE H.entry_ty IN('PT','P1')  --Commented by Priyanka B on 07122018 for Bug-31930
  
---Purchase Return Transaction
UNION ALL
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D.IT_CODE,D.QTY
,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0) as SGST_PER
,isnull(D.SGST_AMT,0)as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
---,d.sbillno as ORG_INVNO, d.sbdate as ORG_DATE
 ,(case when isnull(amd.inv_no,'') = '' then d.sbillno else amd.inv_no end ) as ORG_INVNO
 ,(case when isnull(amd.date,'') = '' then d.sbdate else amd.date end ) as ORG_DATE
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT
,isnull(D.GRO_AMT,0) as GRO_AMT,isnull(h.net_amt,0) as net_amt,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt,isnull(D.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS
 ,AmendDate = (case when DATEDIFF(MM,H.DATE,H.AmendDAte) > 0 then h.AmendDate else ''  end )
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN end)
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN else  seller_ac.GSTIN end)
 --,pos_std_cd =PT.GSTSCODE,pos = PT.gststate 
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate 
 ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when isnull(amd.inv_no,'') = '' then H.INV_NO else amd.inv_no end ) as pinvno 
 ,(case when isnull(amd.date,'') = '' then H.date else amd.date end ) as pinvdt,H.TRANSTATUS
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END)
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT
 ,d.gstrate ,'' as portcode 
 ---h.OLDGSTIN
 ,OLDGSTIN = (case when isnull(h.OLDGSTIN,'') = '' then (case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN end) else h.OLDGSTIN end )
 ,orgbeno = '',orgbedt = ''
 FROM PRMAIN H INNER JOIN
  PRITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id)
  left outer join PRMAINAM amd on(h.Entry_ty = amd.entry_ty and h.Tran_cd =amd.tran_cd)
  --INNER JOIN PRITREF REF ON (D.entry_ty = REF.entry_ty AND D.Tran_cd = REF.Tran_cd AND D.itserial =REF.Itserial)
  --INNER JOIN PTMAIN PT ON (REF.Itref_tran =PT.Tran_cd AND REF.rentry_ty=PT.entry_ty)
  
/*Amendment details of Purchase Return Transaction*/
UNION ALL
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D.IT_CODE,D.QTY
,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0) as SGST_PER
,isnull(D.SGST_AMT,0)as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,d.sbillno as ORG_INVNO, d.sbdate as ORG_DATE
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT
,isnull(D.GRO_AMT,0) as GRO_AMT,isnull(h.net_amt,0) as net_amt,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt,isnull(D.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS
 ,AmendDate = ''
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN end)
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN else  seller_ac.GSTIN end)
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,H.INV_NO as pinvno ,H.date as pinvdt,H.TRANSTATUS 
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END) --- Added by Suraj Kumawat date on 26-08-2017
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT
 ,d.gstrate ,'' as portcode ,
 ---'' as OLDGSTIN
 OLDGSTIN =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN end)
 ,orgbeno = '',orgbedt = ''
 FROM PRMAINAM H INNER JOIN
  PRITEMAM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id)
---Debit Note Transaction
UNION ALL
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,0.00 as QTY
,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0)as CGST_AMT
,isnull(d.SGST_PER,0) as SGST_PER,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,ORG_INVNO= (case when isnull(AMD.pinvno,'') = '' and isnull(AMD.inv_no,'')= '' then  d.sbillno else (case when ISNULL(amd.PINVNO,'') = '' then amd.inv_no else amd.PINVNO end ) end)
,ORG_DATE= (case when isnull(AMD.PINVDT,'') = '' and isnull(AMD.DATE,'')= '' then  d.sbdate else (case when ISNULL(amd.PINVDT,'') = '' then amd.DATE else amd.PINVDT end ) end)
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt ,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt,isnull(D.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '',H.AGAINSTGS,AmendDate = (case when DATEDIFF(MM,H.DATE,H.AmendDAte) > 0 then h.AmendDate else ''  end )
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN  else  Cons_ac.GSTIN  end)
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN  else  seller_ac.GSTIN  end)
 ,pos_std_cd =H.GSTSCODE,pos = H.GSTState ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END)
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT
 ,d.gstrate
 ,'' as portcode  ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
 FROM DNMAIN H INNER JOIN
  DNITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id)
  LEFT OUTER JOIN DNMAINAM AMD ON (H.Tran_cd =AMD.TRAN_CD  AND H.entry_ty =AMD.ENTRY_TY)
  WHERE H.AGAINSTGS IN('PURCHASES','SERVICE PURCHASE BILL')
  
  
/*Amendment table details for Debit Note Transaction*/
UNION ALL
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,0.00 as QTY
,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0)as CGST_AMT
,isnull(d.SGST_PER,0) as SGST_PER,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,d.sbillno as ORG_INVNO, d.sbdate as ORG_DATE
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt ,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt,isnull(D.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '',H.AGAINSTGS,AmendDate = ''
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN  else  Cons_ac.GSTIN  end)
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN  else  seller_ac.GSTIN  end)
 ,pos_std_cd =H.GSTSCODE,pos = H.GSTState ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END)
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT
 ,d.gstrate
 ,'' as portcode  ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
 FROM DNMAINAM H INNER JOIN
  DNITEMAM D ON (H.ENTRY_TY = D.ENTRY_TY AND H.TRAN_CD = D.TRAN_CD) INNER JOIN
  IT_MAST IT ON (D.IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id) WHERE H.AGAINSTGS IN('PURCHASES','SERVICE PURCHASE BILL')
  

---Credit Note Transaction
UNION ALL
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,0.00 as QTY
,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0) as SGST_PER
,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
---,d.sbillno as ORG_INVNO, d.sbdate as ORG_DATE
,ORG_INVNO= (case when isnull(AMD.pinvno,'') = '' and isnull(AMD.inv_no,'')= '' then  d.sbillno else (case when ISNULL(amd.PINVNO,'') = '' then amd.inv_no else amd.PINVNO end ) end)
,ORG_DATE= (case when isnull(AMD.PINVDT,'') = '' and isnull(AMD.DATE,'')= '' then  d.sbdate else (case when ISNULL(amd.PINVDT,'') = '' then amd.DATE else amd.PINVDT end ) end)
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt,isnull(D.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '',H.AGAINSTGS,AmendDate = (case when DATEDIFF(MM,H.DATE,H.AmendDAte) > 0 then h.AmendDate else ''  end )
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN  end) 	---Added by Suraj kumawat date on 2-08-2017 
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN else  seller_ac.GSTIN  end) 	---Added by Suraj kumawat date on 2-08-2017 
 ,pos_std_cd =H.GSTSCODE,pos = H.GSTState ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS 
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Service' end) else 'Ineligible for ITC' END) --- Added by Suraj Kumawat date on 26-08-2017
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT  --Added by Prajakta B. On 22082017
 ,d.gstrate
 ,'' as portcode  
 ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM CNMAIN H INNER JOIN
  CNITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id) 
  LEFT OUTER JOIN CNMAINAM AMD ON (H.Tran_cd =AMD.TRAN_CD AND H.entry_ty =amd.entry_ty)
  WHERE H.AGAINSTGS IN('PURCHASES','SERVICE PURCHASE BILL')
/*Amendment details of Credit Note Transaction*/
UNION ALL
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,0.00 as QTY
,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0) as SGST_PER
,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,d.sbillno as ORG_INVNO, d.sbdate as ORG_DATE
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt,D.CCESSRATE as Cess_per,isnull(D.COMPCESS,0) as Cess_amt,isnull(D.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '',H.AGAINSTGS,AmendDate = ''
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN else  Cons_ac.GSTIN  end) 	
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN else  seller_ac.GSTIN  end) 	
 ,pos_std_cd =H.GSTSCODE,pos = H.GSTState ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS 
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Service' end) else 'Ineligible for ITC' END) --- Added by Suraj Kumawat date on 26-08-2017
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT  
 ,d.gstrate
 ,'' as portcode
 ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM CNMAINAM H INNER JOIN
  CNITEMAM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id) WHERE H.AGAINSTGS IN('PURCHASES','SERVICE PURCHASE BILL')
  
---Service Purchase Bill
UNION ALL
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY
,isnull(d.u_asseamt,0)  AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0) as SGST_PER
,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,ORG_INVNO=case when isnull(amd.pinvno,'')= '' then  H.Pinvno else amd.pinvno end , ORG_DATE=case when isnull(amd.pinvdt,'')= '' then  H.pinvdt else amd.pinvdt end
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0)as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt,'' as Cess_per,0.00 as Cess_amt,0.00 As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS,AmendDate = (case when DATEDIFF(MM,H.DATE,H.AmendDAte) > 0 then h.AmendDate else ''  end )
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN  else  Cons_ac.GSTIN end) 	---Added by Suraj kumawat date on 2-08-2017 
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN  else  seller_ac.GSTIN end) 	---Added by Suraj kumawat date on 2-08-2017 
 ,pos_std_cd =H.GSTSCODE,pos = H.GSTState ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS 
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END) --- Added by Suraj Kumawat date on 26-08-2017
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT  
 ,d.gstrate
 ,'' as portcode  
 ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM EPMAIN H INNER JOIN
  EPITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id)
  left outer join epmainam amd on (h.Tran_cd =amd.tran_cd and h.entry_ty = amd.entry_ty)
  
/* Amend details of Service Purchase Bill*/ 
UNION ALL
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY
,isnull(d.u_asseamt,0)  AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0) as SGST_PER
,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,ORG_INVNO=H.inv_no, ORG_DATE=H.date  
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0) as SGSRT_AMT,isnull(D.IGSRT_AMT,0)as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt,'' as Cess_per,0.00 as Cess_amt,0.00 As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS,AmendDate = ''
 ,Cons_ac_name =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.mailname else  Cons_ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.SUPP_TYPE else  Cons_ac.SUPP_TYPE end)
 ,seller_SUPP_TYPE =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.SUPP_TYPE else  seller_ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.st_type else  Cons_ac.st_type end)
 ,seller_st_type =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.st_type else  seller_ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.GSTIN  else  Cons_ac.GSTIN end) 	---Added by Suraj kumawat date on 2-08-2017 
 ,seller_gstin =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.GSTIN  else  seller_ac.GSTIN end) 	---Added by Suraj kumawat date on 2-08-2017 
 ,pos_std_cd =H.GSTSCODE,pos = H.GSTState ,Cons_pos =(case WHEN isnull(H.scons_id, 0) > 0 then  Cons_sp.state else  Cons_ac.state end)
 ,seller_pos =(case WHEN isnull(H.sAc_id, 0) > 0 then  seller_sp.state else  seller_ac.state  end)
 ,Cons_PANNO = Cons_ac.i_tax,seller_PANNO = seller_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,H.TRANSTATUS 
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN (case when IT.Isservice = 0  then (case when IT.type = 'Machinery/Stores' then 'Capital Goods' else 'Input Goods' end) else 'Input Services' end) else 'Ineligible for ITC' END) --- Added by Suraj Kumawat date on 26-08-2017
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT  
 ,d.gstrate  ,'' as portcode   ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM EPMAINAM H INNER JOIN
  EPITEMAM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  shipto Cons_sp ON (Cons_sp.ac_id = h.Cons_id and Cons_sp.shipto_id = h.scons_id ) LEFT OUTER JOIN
  ac_mast Cons_ac ON (h.cons_id = Cons_ac.ac_id) LEFT OUTER JOIN
  shipto seller_sp ON (seller_sp.ac_id = h.Ac_id and seller_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN
  ac_mast seller_ac ON (h.Ac_id = seller_ac.ac_id)
  
  
--- ISD RECEIPT & Credit Note 
UNION ALL 
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY,0.00  AS Taxableamt
,isnull(d.CGST_PER,0)as CGST_PER,isnull(D.CGST_AMT,0)as CGST_AMT ,isnull(d.SGST_PER,0)as SGST_PER,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,'' as ORG_INVNO, '' as ORG_DATE,0.00 AS CGSRT_AMT, 0.00 AS SGSRT_AMT,0.00 AS IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt,'' as Cess_per,isnull(d.COMPCESS,0)  as Cess_amt,0.00 As CessRT_amt,'' AS LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '','' AS AGAINSTGS,AmendDate = ''
 ,Cons_ac_name = AC.ac_name
 ,Cons_SUPP_TYPE =ac.SUPP_TYPE
 ,seller_SUPP_TYPE =ac.SUPP_TYPE
 ,Cons_st_type =ac.st_type
 ,seller_st_type =ac.st_type
 ,Cons_gstin = ac.GSTIN  ,seller_gstin = ac.GSTIN  	
 ,pos_std_cd ='',pos = '',Cons_pos =''
 ,seller_pos =''
 ,Cons_PANNO = ac.i_tax,seller_PANNO = ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,0 as TRANSTATUS 
 ,gstype =(CASE WHEN ISNULL(D.ECredit,0) = 1 THEN 'Input Services' else 'Ineligible for ITC' END)
 ,AVL_ITC = ISNULL(D.ECredit,0), '' as beno , '' as BEDT  --Added by Prajakta B. On 22082017
 ,d.gstrate
 ,'' as portcode  
 ,'' AS OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM JVMAIN H INNER JOIN
  JVITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
  ac_mast ac ON (h.Ac_id = ac.ac_id)  WHERE H.entry_ty IN('J6','J8')
union all 
---Bank Payment Transaction
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY,isnull(d.u_asseamt,0) AS Taxableamt
,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0)as SGST_PER,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,ORG_INVNO=SPACE(50), cast('' as datetime ) as ORG_DATE
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0)as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT 
,isnull(D.GRO_AMT,0) as GRO_AMT,isnull(h.net_amt,0) as net_amt,'' as Cess_per,isnull(d.COMPCESS,0) as Cess_amt,isnull(d.COMRPCESS,0) As CessRT_amt,D.LineRule   --Added By Prajakta b. On 12082017
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '',h.AGAINSTGS
,AmendDate =(case when DATEDIFF(MM,H.DATE,H.AmendDAte) > 0 then h.AmendDate else ''  end )
 ,Cons_ac_name =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.mailname else  ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.Supp_type else  ac.Supp_type  end)
 ,buyer_SUPP_TYPE =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.SUPP_TYPE else  ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.st_type else  ac.st_type end)
 ,buyer_st_type =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.st_type else  ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(h.sAc_id, 0) > 0 then buyer_sp.GSTIN  else  ac.GSTIN  end)
 ,buyer_gstin =(case WHEN isnull(h.sAc_id, 0) > 0 then buyer_sp.GSTIN else  ac.GSTIN end) 
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate 
 ,Cons_pos =buyer_sp.state 
 ,buyer_pos =buyer_sp.state
 ,Cons_PANNO = ac.i_tax,buyer_PANNO = ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,0 as TRANSTATUS 
 ,gstype =''
 ,AVL_ITC = 0, '' as beno , '' as BEDT 
 ,d.gstrate
 ,'' as portcode 
 ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM BPMAIN H INNER JOIN
	  BPITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
	  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
	 shipto buyer_sp ON (buyer_sp.ac_id = h.Ac_id and buyer_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN	  
	  ac_mast ac ON (h.Ac_id  = ac.ac_id) WHERE H.TDSPAYTYPE = 2 AND H.ENTRY_TY ='BP'

UNION ALL 
/*Bank Payment amd details*/
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY,isnull(d.u_asseamt,0) AS Taxableamt
,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT,isnull(d.SGST_PER,0)as SGST_PER,isnull(D.SGST_AMT,0) as SGST_AMT,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0) as IGST_AMT
,ORG_INVNO=SPACE(50), cast('' as datetime ) as ORG_DATE
,isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0)as SGSRT_AMT,isnull(D.IGSRT_AMT,0) as IGSRT_AMT 
,isnull(D.GRO_AMT,0) as GRO_AMT,isnull(h.net_amt,0) as net_amt,'' as Cess_per,isnull(d.COMPCESS,0) as Cess_amt,isnull(d.COMRPCESS,0) As CessRT_amt,D.LineRule   --Added By Prajakta b. On 12082017
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '',h.AGAINSTGS
,AmendDate = ''
 ,Cons_ac_name =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.mailname else  ac.ac_name end)
 ,Cons_SUPP_TYPE =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.Supp_type else  ac.Supp_type  end)
 ,buyer_SUPP_TYPE =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.SUPP_TYPE else  ac.SUPP_TYPE end)
 ,Cons_st_type =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.st_type else  ac.st_type end)
 ,buyer_st_type =(case WHEN isnull(h.sAc_id, 0) > 0 then  buyer_sp.st_type else  ac.st_type end)
 ,Cons_gstin =(case WHEN isnull(h.sAc_id, 0) > 0 then buyer_sp.GSTIN  else  ac.GSTIN  end)
 ,buyer_gstin =(case WHEN isnull(h.sAc_id, 0) > 0 then buyer_sp.GSTIN else  ac.GSTIN end) 
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate 
 ,Cons_pos =buyer_sp.state 
 ,buyer_pos =buyer_sp.state
 ,Cons_PANNO = ac.i_tax,buyer_PANNO = ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt,0 as TRANSTATUS 
 ,gstype =''
 ,AVL_ITC = 0, '' as beno , '' as BEDT 
 ,d.gstrate
 ,'' as portcode 
 ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM BPMAINAM H INNER JOIN
	  BPITEMAM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
	  IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
	 shipto buyer_sp ON (buyer_sp.ac_id = h.Ac_id and buyer_sp.shipto_id = h.sAc_id) LEFT OUTER JOIN	  
	  ac_mast ac ON (h.Ac_id  = ac.ac_id) WHERE H.TDSPAYTYPE = 2 AND H.ENTRY_TY ='BP'

union all
---Cash Payment Transaction
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT
,isnull(d.SGST_PER,0) as SGST_PER,isnull(D.SGST_AMT,0)as SGST_AMT ,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0)as IGST_AMT
,ORG_INVNO=SPACE(50), cast('' as datetime ) as ORG_DATE,
isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0)as SGSRT_AMT ,isnull(D.IGSRT_AMT,0) as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt,'' as Cess_per,isnull(d.COMPCESS,0) as Cess_amt,isnull(d.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '',h.AGAINSTGS,AmendDate = (case when DATEDIFF(MM,H.DATE,H.AmendDAte) > 0 then h.AmendDate else ''  end )
 ,Cons_ac_name =Cons_ac.ac_name
 ,Cons_SUPP_TYPE =Cons_ac.SUPP_TYPE
 ,buyer_SUPP_TYPE =Cons_ac.SUPP_TYPE
 ,Cons_st_type =Cons_ac.st_type
 ,buyer_st_type =Cons_ac.st_type
 ,Cons_gstin =(CASE WHEN ISNULL(Cons_ac.GSTIN,'')='' THEN Cons_ac.UID ELSE Cons_ac.GSTIN END)
 ,buyer_gstin =(CASE WHEN ISNULL(Cons_ac.GSTIN,'')='' THEN Cons_ac.UID ELSE Cons_ac.GSTIN END)
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate 
 ,Cons_pos =Cons_ac.state 
 ,buyer_pos =Cons_ac.state
 ,Cons_PANNO = Cons_ac.i_tax,buyer_PANNO = Cons_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt, 0 as TRANSTATUS 
 ,gstype = ''
 ,AVL_ITC = 0, '' as beno , '' as BEDT
 ,d.gstrate
 ,'' as portcode
 ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM CPMAIN H INNER JOIN
      CPITEM D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
      IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
      ac_mast Cons_ac ON (h.Ac_id = Cons_ac.ac_id)  WHERE H.TDSPAYTYPE = 2 AND H.ENTRY_TY ='CP'

/* amd Cash payment advance */
Union all
SELECT  H.Entry_ty, H.Tran_cd, D.ITSERIAL, H.INV_NO, H.DATE,D .IT_CODE,D.QTY,isnull(d.u_asseamt,0) AS Taxableamt,isnull(d.CGST_PER,0) as CGST_PER,isnull(D.CGST_AMT,0) as CGST_AMT
,isnull(d.SGST_PER,0) as SGST_PER,isnull(D.SGST_AMT,0)as SGST_AMT ,isnull(d.IGST_PER,0) as IGST_PER,isnull(D.IGST_AMT,0)as IGST_AMT
,ORG_INVNO=SPACE(50), cast('' as datetime ) as ORG_DATE,
isnull(D.CGSRT_AMT,0) as CGSRT_AMT, isnull(D.SGSRT_AMT,0)as SGSRT_AMT ,isnull(D.IGSRT_AMT,0) as IGSRT_AMT ,isnull(D.GRO_AMT,0) as GRO_AMT
,isnull(h.net_amt,0) as net_amt,'' as Cess_per,isnull(d.COMPCESS,0) as Cess_amt,isnull(d.COMRPCESS,0) As CessRT_amt,D.LineRule
,h.inv_sr,h.l_yn
,IT.s_unit as uqc ,IT.IT_NAME,(CASE WHEN IT.Isservice = 0 THEN 'Goods' WHEN IT.Isservice = 1 THEN 'Services' ELSE '' END) AS Isservice, IT.HSNCODE
,RevCharge = '',h.AGAINSTGS,AmendDate = ''
 ,Cons_ac_name =Cons_ac.ac_name
 ,Cons_SUPP_TYPE =Cons_ac.SUPP_TYPE
 ,buyer_SUPP_TYPE =Cons_ac.SUPP_TYPE
 ,Cons_st_type =Cons_ac.st_type
 ,buyer_st_type =Cons_ac.st_type
 ,Cons_gstin =(CASE WHEN ISNULL(Cons_ac.GSTIN,'')='' THEN Cons_ac.UID ELSE Cons_ac.GSTIN END)
 ,buyer_gstin =(CASE WHEN ISNULL(Cons_ac.GSTIN,'')='' THEN Cons_ac.UID ELSE Cons_ac.GSTIN END)
 ,pos_std_cd =h.GSTSCODE,pos = h.gststate 
 ,Cons_pos =Cons_ac.state 
 ,buyer_pos =Cons_ac.state
 ,Cons_PANNO = Cons_ac.i_tax,buyer_PANNO = Cons_ac.i_tax
 ,(case when h.pinvno <> ''  then  h.pinvno else H.INV_NO end) as pinvno ,(case when h.pinvdt <> ''  then  h.pinvdt else H.date end) as pinvdt, 0 as TRANSTATUS 
 ,gstype = ''
 ,AVL_ITC = 0, '' as beno , '' as BEDT
 ,d.gstrate
 ,'' as portcode
 ,h.OLDGSTIN 
 ,orgbeno = '',orgbedt = ''
FROM CPMAINam H INNER JOIN
      CPITEMam D ON (H.ENTRY_TY = D .ENTRY_TY AND H.TRAN_CD = D .TRAN_CD) INNER JOIN
      IT_MAST IT ON (D .IT_CODE = IT.IT_CODE) LEFT OUTER JOIN
      ac_mast Cons_ac ON (h.Ac_id = Cons_ac.ac_id)  WHERE H.TDSPAYTYPE = 2 AND H.ENTRY_TY ='CP')AA
GO
