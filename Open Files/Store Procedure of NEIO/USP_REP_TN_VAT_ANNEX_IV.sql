If Exists(Select [name] From SysObjects Where xtype='P' and [Name]='USP_REP_TN_VAT_ANNEX_IV')
Begin
	Drop Procedure USP_REP_TN_VAT_ANNEX_IV
End
GO
/*
EXECUTE USP_REP_TN_VAT_ANNEX_IV'','','','04/01/2015','03/31/2016','','','','',0,0,'','','','','','','','','2015-2016',''
*/
-- =============================================
-- Author:		Hetal L Patel
-- Create date: 01/06/2009	
-- Description:	This Stored procedure is useful to generate Tamilnadu VAT - FORM Annexure Report.
-- Modify date: 08/06/2009
-- Modified By: Dinesh & Hetal
-- Modified By: Gaurav R. Tanna for Bug-24984 (Blank information is coming in some columns)
-- Modify date: 23/12/2014
-- Modified By: Gaurav R. Tanna for Bug-26176
-- Modify date: 19/05/2015
---Modify Date : 21-12-2015 -For the bug-27444 by Suraj K.
-- Modified By: Sumit Gavate for Bug-26176
-- Modify date: 18/01/2016
-- Remark:
-- =============================================
CREATE Procedure [dbo].[USP_REP_TN_VAT_ANNEX_IV]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(60)= NULL
AS
Declare @FCON as NVARCHAR(2000),@fld_list NVARCHAR(2000)
EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=@SDATE,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='M',@VITFILE=Null,@VACFILE='i'
,@VDTFLD ='DATE'
,@VLYN=Null
,@VEXPARA=@EXPARA
,@VFCON =@FCON OUTPUT

DECLARE @TAXABLE_AMT NUMERIC(14,2),@taxamt numeric(14,2)
set @FCON=rtrim(@FCON)
select part=1,srno1=3, it_desc=convert(varchar(256),itm.it_desc),acm.ac_name,acm.s_tax,commodity_code=space(100)
--- ,taxable_amt=i.gro_amt+i.BCDAMT+i.U_CESSAMT+i.U_HCESAMT+i.EXAMT+i.U_CVDAMT ----For the bug-27444 
,taxable_amt=m.net_amt ---For the bug-27444
,taxamt=i.taxamt, m.inv_no, m.date
,st.tax_name,st.level1,st.st_type ,m.u_imporm
into #tn_vat_Annexure
from ptitem i  
inner join ptmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd) 
inner join ac_mast acm on (i.ac_id=acm.ac_id) 
inner join it_mast itm on (i.it_code=itm.it_code) 
inner join stax_mas st on (st.tax_name=i.tax_name)
where 1=2
declare @sqlcommand nvarchar(4000)
Declare @MultiCo	VarChar(3)
Declare @MCON as NVARCHAR(2000)
IF Exists(Select A.ID From SysObjects A Inner Join SysColumns B On(A.ID = B.ID) Where A.[Name] = 'STMAIN' And B.[Name] = 'DBNAME')
	Begin	------Fetch Records from Multi Co. Data
		Set @MultiCo = 'YES'
		
	End
Else
	Begin	------Fetch Records from Multi Co. Data
		Set @MultiCo = 'NO'

		-->Part-4
		--
		--Modified By Sumit Gavate - Dated on 18-01-2016 for Bug-26176 Start
		execute usp_rep_Taxable_Amount_Itemwise 'P1','i',@fld_list =@fld_list OUTPUT
		set @fld_list=rtrim(@fld_list)
		set @sqlcommand='insert into #tn_vat_Annexure select part=4,srno1=1'
		set @sqlcommand=@sqlcommand+' '+',it_desc=case when CAST(ISNULL(ITM.IT_DESC,'''') AS VARCHAR) = '''' THEN itm.it_name ELSE CAST(ISNULL(ITM.IT_DESC,'''') AS VARCHAR) END,acm.ac_name,acm.s_tax,itm.hsncode'
		set @sqlcommand=@sqlcommand+' '+',taxable_amt=(i.gro_amt'+@fld_list+')'
		set @sqlcommand=@sqlcommand+' '+',taxamt=isnull(i.taxamt,0), m.inv_no, m.[date]'
		set @sqlcommand=@sqlcommand+' '+',isnull(st.tax_name,''''),st.level1,st.st_type ,m.u_imporm'
		set @sqlcommand=@sqlcommand+' '+'from ptitem i '
		set @sqlcommand=@sqlcommand+' '+'inner join ptmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd)'
		set @sqlcommand=@sqlcommand+' '+'inner join ac_mast acm on (i.ac_id=acm.ac_id)'
		set @sqlcommand=@sqlcommand+' '+'inner join it_mast itm on (i.it_code=itm.it_code)'
		set @sqlcommand=@sqlcommand+' '+'Left join stax_mas st on (st.tax_name=i.tax_name and st.entry_ty = i.entry_ty) '
		set @sqlcommand=@sqlcommand+' '+rtrim(@fcon)
		set @sqlcommand=@sqlcommand+' '+'and m.Entry_ty in (''P1'',''PT'')'
		set @sqlcommand=@sqlcommand+' '+'and acm.St_type = ''OUT OF COUNTRY'' AND m.U_IMPORM in(''Direct Imports'',''Import from Outside India'',''High Seas Purchases'') order by st.st_type'
		print @sqlcommand
		execute sp_executesql @sqlcommand
		if not exists(select * from #tn_vat_Annexure  where part=4 and srno1=1)
		begin
			insert into #tn_vat_Annexure (part,srno1,it_desc,ac_name,s_tax,commodity_code,st_type ,u_imporm,taxable_amt,tax_name,taxamt,level1,inv_no,date)
			values(4,1,'','','','','','',0,'',0,0,'','')
		end

		execute usp_rep_Taxable_Amount_Itemwise 'ST','i',@fld_list =@fld_list OUTPUT
		set @fld_list=rtrim(@fld_list)
		set @sqlcommand='insert into #tn_vat_Annexure select part=4,srno1=2'
		set @sqlcommand=@sqlcommand+' '+',it_desc=case when CAST(ISNULL(ITM.IT_DESC,'''') AS VARCHAR) = '''' THEN itm.it_name ELSE CAST(ISNULL(ITM.IT_DESC,'''') AS VARCHAR)  END,acm.ac_name,acm.s_tax,itm.hsncode'
		set @sqlcommand=@sqlcommand+' '+',taxable_amt=(i.gro_amt'+@fld_list+')'
		set @sqlcommand=@sqlcommand+' '+',taxamt=isnull(i.taxamt,0), m.u_blno as inv_no, m.u_bldt as date'
		set @sqlcommand=@sqlcommand+' '+',isnull(st.tax_name,''''),st.level1,st.st_type ,m.u_imporm'
		set @sqlcommand=@sqlcommand+' '+'from stitem i '
		set @sqlcommand=@sqlcommand+' '+'inner join stmain m on (m.entry_ty=i.entry_ty and m.tran_cd=i.tran_cd)'
		set @sqlcommand=@sqlcommand+' '+'inner join ac_mast acm on (i.ac_id=acm.ac_id)'
		set @sqlcommand=@sqlcommand+' '+'inner join it_mast itm on (i.it_code=itm.it_code)'
		set @sqlcommand=@sqlcommand+' '+'Left join stax_mas st on (st.tax_name=i.tax_name AND ST.Entry_ty = i.entry_ty) '
		set @sqlcommand=@sqlcommand+' '+rtrim(@fcon)
		set @sqlcommand=@sqlcommand+' '+'and m.Entry_ty in (''EI'',''ST'')'
		set @sqlcommand=@sqlcommand+' '+'AND m.u_imporm in(''Direct Exports'',''Export Out of India'',''High Sea Sales'') AND acm.St_type = ''OUT OF COUNTRY'''
		set @sqlcommand=@sqlcommand+' '+'order by st.st_type'
		print @sqlcommand
		execute sp_executesql @sqlcommand
		if not exists(select * from #tn_vat_Annexure  where part=4 and srno1=2)
		begin
			insert into #tn_vat_Annexure (part,srno1,it_desc,ac_name,s_tax,commodity_code,st_type ,u_imporm,taxable_amt,tax_name,taxamt,level1,inv_no,date)
			values(4,2,'','','','','','',0,'',0,0,'','')		
		end
		--Modified By Sumit Gavate - Dated on 18-01-2016 for Bug-26176 End
	End
select  * from #tn_vat_Annexure order by part,srno1,LEVEL1,IT_DESC,COMMODITY_CODE