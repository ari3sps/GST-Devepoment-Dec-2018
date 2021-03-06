DROP PROCEDURE [USP_REP_SERVICETAX_PAYABLE]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ruepesh Prajapati.
-- Create date: 11/07/2008
-- Description:	This Stored procedure is useful to generate Service Tax Input Credit Payable Report.
-- Modification Date/By/Reason: 11/09/2009 Rupesh Prajapati. Modified for Imported Service. EpMain entry.
-- Remark:
-- =============================================

CREATE procedure [USP_REP_SERVICETAX_PAYABLE]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(60)= null
AS
Begin
	Declare @FCON as NVARCHAR(2000),@SQLCOMMAND as NVARCHAR(4000)
	select m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty,rdate=m.date ,a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,taxable_amt=m.gro_amt+m.tot_deduc+m.tot_tax 
	,bSrTax=m.net_amt
	,bESrTax=m.net_amt
	,bHSrTax=m.net_amt
	,aSrTax=m.net_amt
	,aESrTax=m.net_amt
	,aHSrTax=m.net_amt
	into #serpay
	from bracdet ac 
	inner join brmain m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd) 
	inner join ac_mast a on (m.ac_id=a.ac_id) 
	inner join ac_mast aa on (ac.ac_id=aa.ac_id) 
	WHERE 1=2

	
	EXECUTE USP_REP_FILTCON 
	@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
	,@VSDATE=@SDATE,@VEDATE=@EDATE
	,@VSAC =@SAC,@VEAC =@EAC
	,@VSIT=@SIT,@VEIT=@EIT
	,@VSAMT=@SAMT,@VEAMT=@EAMT
	,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
	,@VSCATE =@SCATE,@VECATE =@ECATE
	,@VSWARE =@SWARE,@VEWARE  =@EWARE
	,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
	,@VMAINFILE='mall',@VITFILE=Null,@VACFILE='AC'
	,@VDTFLD ='DATE'
	,@VLYN=Null
	,@VEXPARA=@EXPARA
	,@VFCON =@FCON OUTPUT

	

	set @sqlcommand='insert into #serpay select m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty,rdate=mall.date'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,taxable_amt=m.gro_amt+m.tot_deduc+m.tot_tax'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bSrTax=m.serbamt'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bESrTax=m.sercamt'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bHSrTax=m.serhamt'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aSrTax=sum(case when aa.typ='+'''Output Service Tax'''+' then mall.tds else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aESrTax=sum(case when aa.typ='+'''Output Service Tax-Ecess'''+' then mall.tds else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aHSrTax=sum(case when aa.typ='+'''Output Service Tax-Hcess'''+' then mall.tds else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+' from sbacdet ac'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join sbmain m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast a on (m.ac_id=a.ac_id)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast aa on (ac.ac_id=aa.ac_id)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join mainall_vw mall on (m.entry_ty=mall.entry_all and m.tran_cd=mall.main_tran and ac.acserial=mall.acseri_all)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+rtrim(@fcon)
	set @sqlcommand=rtrim(@sqlcommand)+' '+'and aa.typ like '+'''%out%serv%'''+' and ac.amt_ty='+'''CR'''
	set @sqlcommand=rtrim(@sqlcommand)+' '+'group by m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,m.gro_amt,m.tot_deduc,m.tot_tax,mall.date,m.serbamt,m.sercamt,m.serhamt'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'order by m.serty,m.date,m.tran_cd'
	print  @sqlcommand
	EXECUTE SP_EXECUTESQL @SQLCOMMAND
	

	EXECUTE USP_REP_FILTCON 
	@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
	,@VSDATE=@SDATE,@VEDATE=@EDATE
	,@VSAC =@SAC,@VEAC =@EAC
	,@VSIT=@SIT,@VEIT=@EIT
	,@VSAMT=@SAMT,@VEAMT=@EAMT
	,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
	,@VSCATE =@SCATE,@VECATE =@ECATE
	,@VSWARE =@SWARE,@VEWARE  =@EWARE
	,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
	,@VMAINFILE='m',@VITFILE=Null,@VACFILE='AC'
	,@VDTFLD ='DATE'
	,@VLYN=Null
	,@VEXPARA=@EXPARA
	,@VFCON =@FCON OUTPUT

	set @sqlcommand='insert into #serpay select m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty,rdate=m.date ,a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,taxable_amt=m.gro_amt+m.tot_deduc+m.tot_tax '
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bSrTax=0'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bESrTax=0'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bHSrTax=0'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aSrTax=sum(case when aa.typ='+'''Service Tax Payable'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aESrTax=sum(case when aa.typ='+'''Service Tax Payable-Ecess'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aHSrTax=sum(case when aa.typ='+'''Service Tax Payable-Hcess'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'from bracdet ac '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join brmain m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast a on (m.ac_id=a.ac_id) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast aa on (ac.ac_id=aa.ac_id) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+rtrim(@fcon)
	set @sqlcommand=rtrim(@sqlcommand)+' '+'and aa.typ like '+'''%Service%Payable%'''+' and ac.amt_ty='+'''CR'''+'  and m.tdspaytype=2'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'group by m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty ,a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,m.gro_amt,m.tot_deduc,m.tot_tax,m.date order by m.serty,m.date,m.tran_cd'
	
	print  @sqlcommand
	EXECUTE SP_EXECUTESQL @SQLCOMMAND

	set @sqlcommand='insert into #serpay select m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty,rdate=m.date ,a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,taxable_amt=m.gro_amt+m.tot_deduc+m.tot_tax '
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bSrTax=0'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bESrTax=0'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bHSrTax=0'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aSrTax=sum(case when aa.typ='+'''Service Tax Payable'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aESrTax=sum(case when aa.typ='+'''Service Tax Payable-Ecess'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aHSrTax=sum(case when aa.typ='+'''Service Tax Payable-Hcess'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'from cracdet ac '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join crmain m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast a on (m.ac_id=a.ac_id) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast aa on (ac.ac_id=aa.ac_id) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+rtrim(@fcon)
	set @sqlcommand=rtrim(@sqlcommand)+' '+'and aa.typ like '+'''%Service%Payable%'''+' and ac.amt_ty='+'''CR'''+'  and m.tdspaytype=2'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'group by m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty ,a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,m.gro_amt,m.tot_deduc,m.tot_tax,m.date order by m.serty,m.date,m.tran_cd'
	print  @sqlcommand
	EXECUTE SP_EXECUTESQL @SQLCOMMAND

	set @sqlcommand='insert into #serpay select m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty,rdate=m.date ,a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,taxable_amt=m.gro_amt+m.tot_deduc+m.tot_tax '
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bSrTax=m.serbamt'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bESrTax=m.sercamt'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',bHSrTax=m.serhamt'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aSrTax=sum(case when aa.typ='+'''Service Tax Payable'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aESrTax=sum(case when aa.typ='+'''Service Tax Payable-Ecess'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+',aHSrTax=sum(case when aa.typ='+'''Service Tax Payable-Hcess'''+' then amount  else 0 end)'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'from epacdet ac '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join epmain m on (ac.entry_ty=m.entry_ty and ac.tran_cd=m.tran_cd) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast a on (m.ac_id=a.ac_id) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+'inner join ac_mast aa on (ac.ac_id=aa.ac_id) '
	set @sqlcommand=rtrim(@sqlcommand)+' '+rtrim(@fcon)
	set @sqlcommand=rtrim(@sqlcommand)+' '+'and aa.typ like '+'''%Service%Payable%'''+' and ac.amt_ty='+'''CR'''--+'  and m.tdspaytype=2'
	set @sqlcommand=rtrim(@sqlcommand)+' '+'group by m.entry_ty,m.tran_cd,m.date,m.inv_no,m.serty ,a.ac_name,a.add1,a.add2,a.add3,a.SREGN,m.net_amt,m.gro_amt,m.tot_deduc,m.tot_tax,m.date,m.serbamt,m.sercamt,m.serhamt order by m.serty,m.date,m.tran_cd'
	print  @sqlcommand
	EXECUTE SP_EXECUTESQL @SQLCOMMAND

	SELECT * FROM #serpay where asrtax > 0
	DROP TABLE  #serpay
	
END
GO
