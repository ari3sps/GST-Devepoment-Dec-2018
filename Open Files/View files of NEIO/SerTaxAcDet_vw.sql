DROP VIEW [SerTaxAcDet_vw]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ruepesh Prajapati
-- Create date: 
-- Description:	This View is used in Service Tax Reports.
-- Modification Date/By/Reason: 28/07/2010 Rupesh Prajapati. TKT-794 GTA Add inv_sr column.
-- Modification Date/By/Reason: 13/10/2011 Rupesh Prajapati. TKT-9722 add Sales Transaction
-- Modification Date/By/Reason: 14/06/2012 Sandeep Shah. bug-4574 Remove the space of u_cldt column from obacdet table
-- Modification Date/By/Reason: 22/09/2012 Sachin N. S. Bug-5164 -- Added new Service Tax Serial No. (ServTxSrNo)
-- Modification Date/By/Reason: 18/07/2014. Vasant M. S. Bug 23384 (Issue In Service Tax Credit Register) - -->Bug23384
-- Remark: 
-- =============================================
CREATE view [SerTaxAcDet_vw]
as
select entry_ty,tran_cd,ac_id,date,date as u_cldt,serty,amount,amt_ty ,acserial, space(10) as ServTxSrNo from epacdet		-->Bug23384
union all
select entry_ty,tran_cd,ac_id,date,u_cldt,serty,amount,amt_ty,acserial, space(10) as ServTxSrNo from bpacdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt=space(1),serty,amount,amt_ty,acserial, space(10) as ServTxSrNo from cpacdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt=space(1),serty,amount,amt_ty,acserial, space(10) as ServTxSrNo from sbacdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt=space(1),serty,amount,amt_ty,acserial, Space(10) as ServTxSrNo from sdacdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt=space(1),serty,amount,amt_ty,acserial, Space(10) as ServTxSrNo from bracdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt=space(1),serty,amount,amt_ty,acserial, Space(10) as ServTxSrNo from cracdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt,serty,amount,amt_ty,acserial,  ServTxSrNo from JVacdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt,serty='',amount,amt_ty,acserial, ServTxSrNo from IRacdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt,serty='',amount,amt_ty,acserial, Space(10) as ServTxSrNo from OBacdet
union all
select entry_ty,tran_cd,ac_id,date,u_cldt=date,serty='',amount,amt_ty,acserial,  ServTxSrNo from Stacdet
union all 
select entry_ty,tran_cd,ac_id,date,date as u_cldt,serty='',amount,amt_ty ,acserial, space(10) as ServTxSrNo from ptacdet		-->Bug 30825
GO
