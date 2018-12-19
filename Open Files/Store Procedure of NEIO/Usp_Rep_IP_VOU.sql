DROP PROCEDURE [Usp_Rep_IP_VOU]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- CREATE : Birendra Prasad
-- DATE: 24/07/2012
-- DESCRIPTION:	THIS STORED PROCEDURE IS USEFUL TO GENERATE IP Slip from Input to production transaction.
-- REMARK:
-- =============================================

Create PROCEDURE  [Usp_Rep_IP_VOU] 
@ENTRYCOND NVARCHAR(254)
AS
BEGIN
	--->ENTRY_TY AND TRAN_CD SEPARATION
		DECLARE @ENT VARCHAR(2),@TRN INT,@POS1 INT,@POS2 INT,@POS3 INT--,@ENTRYCOND NVARCHAR(254)
		PRINT @ENTRYCOND
		SET @POS1=CHARINDEX('''',@ENTRYCOND,1)+1
		SET @ENT= SUBSTRING(@ENTRYCOND,@POS1,2)
		SET @POS2=CHARINDEX('=',@ENTRYCOND,CHARINDEX('''',@ENTRYCOND,@POS1))+1
		SET @POS3=CHARINDEX('=',@ENTRYCOND,CHARINDEX('''',@ENTRYCOND,@POS2))+1
		SET @TRN= SUBSTRING(@ENTRYCOND,@POS2,@POS2-@POS3)
	---<---ENTRY_TY AND TRAN_CD SEPARATION

--------
SELECT IPMAIN.INV_SR,IPMAIN.ENTRY_TY,IPMAIN.TRAN_CD,IPMAIN.INV_NO,IPMAIN.DATE,IPITEM.QTY,IPITEM.RATE,IPITEM.GRO_AMT,
IT_MAST.IT_NAME,IT_MAST.RATEUNIT,It_Desc=(CASE WHEN ISNULL(it_mast.it_alias,'')='' THEN it_mast.it_name ELSE it_mast.it_alias END)
,stkl.batchno,stkl.mfgdt,stkl.expdt,stkl.supbatchno,stkl.supmfgdt,stkl.supexpdt
 FROM IPMAIN INNER JOIN IPITEM ON (IPMAIN.TRAN_CD=IPITEM.TRAN_CD) INNER JOIN IT_MAST ON (IPITEM.IT_CODE=IT_MAST.IT_CODE)
left join othitref on (othitref.entry_ty=ipitem.entry_ty and othitref.tran_cd=ipitem.tran_cd and othitref.itserial=ipitem.itserial)
left join (select a.Entry_ty,a.tran_cd,a.itserial,a.batchno,a.mfgdt,a.expdt,a.supbatchno,a.supmfgdt,a.supexpdt from stkl_vw_item a inner join lcode b on (a.entry_ty=b.entry_ty) where b.inv_stk='+'  ) stkl on (stkl.entry_ty=othitref.rentry_ty and stkl.tran_cd=othitref.itref_tran and stkl.itserial=othitref.ritserial)
 WHERE IPMAIN.ENTRY_TY=@ENT and IPMAIN.TRAN_CD=@TRN ORDER BY IPMAIN.INV_SR,IPMAIN.INV_NO,CAST(IPITEM.ITSERIAL AS INT)
--------
END
GO
