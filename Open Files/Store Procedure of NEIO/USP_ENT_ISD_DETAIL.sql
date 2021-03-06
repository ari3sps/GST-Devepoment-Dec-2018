DROP PROCEDURE [USP_ENT_ISD_DETAIL]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [USP_ENT_ISD_DETAIL]
@Entry_ty Varchar(2),@Tran_cd Numeric(6,0),@Date Smalldatetime
as 
Select Sel=Convert(Bit,0),l.code_nm,m.Entry_ty,m.Tran_cd
,it.Serty,am.ac_name,m.inv_no,m.date,i.itserial
,i.CGST_AMT,i.SGST_AMT,i.IGST_AMT
,aCGST_AMT=Isnull(i.cgst_amt,0),aSGST_AMT=Isnull(i.sgst_amt,0),aIGST_AMT=isnull(i.igst_amt,0)
,alloc_cgst=Isnull(id.acgst,0),alloc_sgst=Isnull(id.asgst,0),alloc_igst=isnull(id.aigst,0)
,bal_cgst=Isnull(i.cgst_amt,0)-Isnull(id.acgst,0),bal_sgst=Isnull(i.sgst_amt,0)-Isnull(id.asgst,0),bal_igst=isnull(i.igst_amt,0)-isnull(id.aigst,0)
,adj_cgst=CONVERT(Numeric(15,2),0),adj_sgst=CONVERT(Numeric(15,2),0),adj_igst=CONVERT(Numeric(15,2),0)
,it.it_name,it.it_code
From 
vw_GST_Item i
Inner Join vw_GST_Main m on (m.Tran_cd=i.Tran_cd and m.Entry_ty=i.entry_ty)
Inner Join AC_MAST am on (m.ac_id=am.Ac_id) 
Inner Join It_mast it On (it.It_code=i.It_Code)
Inner Join Lcode l on (l.Entry_ty=m.Entry_ty)
Left Join (Select entry_ty,tran_cd,Itserial='',acgst=SUM(acgst),asgst=SUM(asgst),aigst=SUM(aigst) from gstalloc where Date <=@Date group by entry_ty,tran_cd) g on (g.Entry_ty=m.Entry_ty and g.Tran_cd=m.Tran_cd )
Left Join (sELECT aentry_ty,atran_cd,aitserial,acgst=sum(acgst),asgst=sum(asgst),aigst=sum(aigst) from isdalloc Where Date <=@Date and Not (Entry_ty=@Entry_ty and Tran_cd=@Tran_cd) group by aentry_ty,atran_cd,aitserial) id on (id.aEntry_ty=m.entry_ty and id.aTran_cd=m.tran_cd and id.aitserial=i.ItSerial)
Where it.isService=1
and m.Entry_ty in ('E1')

and m.date<=@Date
GO
