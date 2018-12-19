set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go












-- =============================================
-- Author:		Ruepesh Prajapati
-- Create date: 16/05/2007
-- Description:	This Stored procedure is useful to generate Excise Duty Available Report.
-- Modify date: 16/05/2007
-- Modified By: Satish pal   
-- Modify date: 08/10/2011
-- Remark: for tkt-9649
-- =============================================

ALTER PROCEDURE [dbo].[USP_REP_ltpay_int]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE DATETIME
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

Declare @brENTRIES as VARCHAR(50),@brENTRY_TY as VARCHAR(50)
Set @BRENTRY_TY = '"BR"'+'"CR"'

DECLARE BR_cursor CURSOR FOR
		SELECT entry_ty FROM lcode
		WHERE bcode_nm in ('BR','CR')
	OPEN br_cursor
	FETCH NEXT FROM br_cursor into @brentries
	WHILE @@FETCH_STATUS = 0
	BEGIN
	   Set @brENTRY_TY = @brENTRY_TY +',"'+@brentries+'"'
	   FETCH NEXT FROM br_cursor into @brentries
	END
	CLOSE br_cursor
	DEALLOCATE br_cursor
---Comment by Satish pal dt. 08/10/2011 for tkt-9649
		------select ac_mast.mailname,stmain.inv_no as u_sbillno,'Interest' as item ,mainall_vw.new_all as u_recdamt,
		------stmain.date as u_sdate,stmain.due_dt as u_sduedt,lmain_vw.date as u_brdate,stmain.net_amt as u_sbillamt,
		------lmain_vw.net_amt , ((mainall_vw.new_all*(stmain.u_intr_per/100))/365)*convert(int,(lmain_vw.date-stmain.due_dt)) as int_amount,
		------u_ltdays=convert(int,(lmain_vw.date-stmain.due_dt)),stmain.U_INTR_PER as u_intper 
		------into #Lt_pay from lmain_vw inner join mainall_vw on lmain_vw.tran_cd=mainall_vw.tran_cd 
		------left join lac_vw 
		------on lac_vw.tran_cd=mainall_vw.main_tran and lac_vw.acserial=mainall_vw.acseri_all 
		------inner join stmain on stmain.tran_cd=lac_vw.tran_cd 
		------inner join ac_mast on ac_mast.ac_id=stmain.ac_id where lmain_vw.entry_ty IN ('BR','CR')
		------and lmain_vw.date between @sdate and @edate and ac_mast.mailname between @sac and @eac

---End by Satish pal dt. 08/10/2011 for tkt-9649
--Added by Satish pal dt. 08/10/2011 for tkt-9649
select ac_mast.mailname,stmain.inv_no as u_sbillno,'Interest' as item ,mainall_vw.new_all as u_recdamt,
stmain.date as u_sdate,stmain.due_dt as u_sduedt,lmain_vw.date as u_brdate,stmain.net_amt as u_sbillamt,
lmain_vw.net_amt , ((mainall_vw.new_all*((case when stmain.u_intr_per>0 then stmain.u_intr_per else ac_mast.i_rate end)/100))/365)*convert(int,(lmain_vw.date-stmain.due_dt)) as int_amount, 
u_ltdays=convert(int,(lmain_vw.date-stmain.due_dt)),(case when stmain.u_intr_per>0 then stmain.u_intr_per else ac_mast.i_rate end) as u_intper
into #Lt_pay from lmain_vw 
inner join mainall_vw on lmain_vw.tran_cd=mainall_vw.tran_cd and lmain_vw.entry_ty=mainall_vw.entry_ty 
left join lac_vw on lac_vw.tran_cd=mainall_vw.main_tran and lac_vw.entry_ty=mainall_vw.entry_all and lac_vw.acserial=mainall_vw.acseri_all 
inner join stmain on stmain.tran_cd=lac_vw.tran_cd and stmain.entry_ty=lac_vw.Entry_ty 
inner join ac_mast on ac_mast.ac_id=stmain.ac_id 
where lmain_vw.entry_ty IN ('BR','CR')
and lmain_vw.date between @sdate and @edate and ac_mast.mailname between @sac and @eac

---end by Satish pal dt. 08/10/2011 for tkt-9649
 
--PRINT  @brENTRY_TY
--

select * from #lt_pay where u_ltdays>0 order by ac_mast.mailname,u_sdate


--drop table #lt_pay







