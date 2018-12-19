DROP PROCEDURE [USP_REP_EPCG_REDEMP]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- CREATED BY:	  AJAY JAISWAL
-- CREATE DATE:   04/09/2012
-- DESCRIPTION:	  THIS STORED PROCEDURE IS USEFUL TO GENERATE DATA FOR EPCG REDEMPTION REPORT.
-- MODIFIED BY:   
-- MODIFIED DATE: 
-- =============================================

CREATE PROCEDURE   [USP_REP_EPCG_REDEMP]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA AS VARCHAR(1000)= NULL
AS
  
DECLARE @FCON AS VARCHAR(1000)

EXECUTE   USP_REP_FILTCON 
@VTMPAC =@TMPAC,@VTMPIT =@TMPIT,@VSPLCOND =@SPLCOND
,@VSDATE=NULL
 ,@VEDATE=@EDATE
,@VSAC =@SAC,@VEAC =@EAC
,@VSIT=@SIT,@VEIT=@EIT
,@VSAMT=@SAMT,@VEAMT=@EAMT
,@VSDEPT=@SDEPT,@VEDEPT=@EDEPT
,@VSCATE =@SCATE,@VECATE =@ECATE
,@VSWARE =@SWARE,@VEWARE  =@EWARE
,@VSINV_SR =@SINV_SR,@VEINV_SR =@SINV_SR
,@VMAINFILE='STMAIN',@VITFILE=NULL,@VACFILE=NULL
,@VDTFLD ='DATE'
,@VLYN =NULL
,@VEXPARA=@EXPARA 
,@VFCON =@FCON OUTPUT

IF @FCON IS NOT NULL OR @FCON <> ''
BEGIN
	SET @FCON = @FCON 
END

declare @m_thirdparty_exp decimal(16,2),@m_deemed_exp decimal(16,2),@m_bygrp_comp decimal(16,2),@m_rnd_services decimal(16,2)
,@str varchar(100),@len int,@i int
set @str = @EXPARA
set @len = len(@str)
set @i = 1
while @i <= 4
begin
	if @i = 1	
	begin
		select @m_thirdparty_exp = cast(substring(@str,0,charindex(',',@str)) as decimal(16,2))
		select @str = (substring(@str,charindex(',',@str)+1,@len))
	end
	if @i = 2	
	begin
		select @m_deemed_exp = cast(substring(@str,0,charindex(',',@str)) as decimal(16,2))
		select @str = (substring(@str,charindex(',',@str)+1,@len))
	end
	if @i = 3	
	begin
		select @m_bygrp_comp = cast(substring(@str,0,charindex(',',@str)) as decimal(16,2))
		select @str = (substring(@str,charindex(',',@str)+1,@len))
	end
	if @i = 4
	begin
		select @m_rnd_services = @str
	end
	set @i = @i + 1
end

DECLARE @SQLCOMMAND NVARCHAR(4000),@VCOND NVARCHAR(2000)
DECLARE @U_BASDUTY NUMERIC(12,2),@U_CESSPER NUMERIC(12,2),@U_HCESPER NUMERIC(12,2)	

SET @SQLCOMMAND='SELECT STMAIN.INV_SR, STMAIN.TRAN_CD, STMAIN.ENTRY_TY, STMAIN.INV_NO, STMAIN.DATE, STMAIN.U_SBNO'
SET @SQLCOMMAND=@SQLCOMMAND+', STMAIN.U_SBDT, STMAIN.U_FOBSB, STMAIN.NET_AMT, STMAIN.CTNO, STMAIN.CTDATE, STITEM.U_FRT'
SET @SQLCOMMAND=@SQLCOMMAND+', STMAIN.ARENO, STMAIN.AREDATE, STMAIN.LORR_RECNO, STMAIN.LORR_RECDT, STMAIN.RAIL_RECNO'
SET @SQLCOMMAND=@SQLCOMMAND+', EPCG_MAST.SECTOR_NM, STMAIN.RAIL_RECDT, STITEM.U_INS'
SET @SQLCOMMAND=@SQLCOMMAND+', STMAIN.NARR, CURR_MAST.CURRENCYCD'
SET @SQLCOMMAND=@SQLCOMMAND+',' + convert(varchar(1000),@m_thirdparty_exp) + ' as thirdparty_exp,' + convert(varchar(1000),@m_deemed_exp) + ' as deemed_exp,' + convert(varchar(1000),@m_bygrp_comp) + ' as bygrp_comp,' + convert(varchar(1000),@m_rnd_services) + ' as rnd_services '
SET @SQLCOMMAND=@SQLCOMMAND+' FROM STMAIN  INNER JOIN STITEM ON (STMAIN.TRAN_CD=STITEM.TRAN_CD)'
SET @SQLCOMMAND=@SQLCOMMAND+' INNER JOIN IT_MAST ON (STITEM.IT_CODE=IT_MAST.IT_CODE)'
SET @SQLCOMMAND=@SQLCOMMAND+' INNER JOIN CURR_MAST ON (STMAIN.FCID = CURR_MAST.CURRENCYID)'
SET @SQLCOMMAND=@SQLCOMMAND+' INNER JOIN AC_MAST ON (AC_MAST.AC_ID=STMAIN.AC_ID)'
SET @SQLCOMMAND=@SQLCOMMAND+' LEFT JOIN AC_MAST AC_MAST1 ON (AC_MAST1.AC_NAME=STMAIN.U_DELIVER)'
SET @SQLCOMMAND=@SQLCOMMAND+' LEFT JOIN EPCG_MAST ON (EPCG_MAST.LICEN_NO=STMAIN.LICEN_NO)'
SET @SQLCOMMAND=@SQLCOMMAND+RTRIM(@FCON)
SET @SQLCOMMAND=@SQLCOMMAND+' AND STMAIN.ENTRY_TY = ''EI'''
PRINT @SQLCOMMAND
EXECUTE SP_EXECUTESQL @SQLCOMMAND
GO
