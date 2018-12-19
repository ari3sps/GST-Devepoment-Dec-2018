DROP PROCEDURE [Usp_Alert_Out_Payment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ramya.
-- Create date: 24/09/2011
-- Description:	This Stored procedure is useful to generate ACCOUNTS Unallocated payments and receipts for Alert Master.
-- =============================================

CREATE PROCEDURE [Usp_Alert_Out_Payment]
@CommanPara varchar(8000) 
AS  

DECLARE @Fcond_Alert AS NVARCHAR(2000),@VSAMT DECIMAL(14,4),@VEAMT DECIMAL(14,4)

EXECUTE [Usp_Rep_FiltCond_Alert]
@CommanPara
,@VMAINFILE='A',@VITFILE='A',@VACFILE=' '
,@It_Mast= '',@Ac_Mast= 'AC_MAST'
,@vFcond_Alert =@Fcond_Alert OUTPUT
print '@Fcond_Alert '+@Fcond_Alert

if isnull(@Fcond_Alert,'')=''
begin
	set @Fcond_Alert=' WHERE 1=1 '
end

DELETE FROM ALERT_UNALLOCATED

DECLARE @SQLCOMMAND NVARCHAR(4000),@VCOND NVARCHAR(1000)

SET @SQLCOMMAND='INSERT INTO ALERT_UNALLOCATED '
SET @SQLCOMMAND =@SQLCOMMAND+'SELECT LCODE.CODE_NM,AC.INV_NO,AC.DATE,AC.AC_NAME AS PARTY_NM,AC.AMOUNT AS NET_AMT,'
SET @SQLCOMMAND =@SQLCOMMAND+'RE_ALL AS NEW_ALL,(AC.AMOUNT-RE_ALL) AS BALANCE'
SET @SQLCOMMAND =@SQLCOMMAND+' '+'FROM LAC_VW AC '
SET @SQLCOMMAND =@SQLCOMMAND+' '+'INNER JOIN AC_MAST ON (AC_MAST.AC_ID=AC.AC_ID)'
SET @SQLCOMMAND =@SQLCOMMAND+' '+'INNER JOIN LCODE ON (AC.ENTRY_TY=LCODE.ENTRY_TY)'
SET @SQLCOMMAND =@SQLCOMMAND+' '+@Fcond_Alert
SET @SQLCOMMAND =@SQLCOMMAND+' '+'AND AC.ENTRY_TY IN (''BR'',''BP'',''DN'',''CN'',''JV'',''CP'',''CR'') '
SET @SQLCOMMAND =@SQLCOMMAND+' '+'AND AC.AMOUNT<>AC.RE_ALL'
SET @SQLCOMMAND =@SQLCOMMAND+' '+'ORDER BY AC.ENTRY_TY,AC.DATE,AC.AC_NAME'

PRINT @SQLCOMMAND 
EXECUTE SP_EXECUTESQL @SQLCOMMAND

SELECT [Entry Type],[Invoice No],Date,[Party Name],[Net Amount],[Allocated Amount],[Balance] FROM ALERT_UNALLOCATED
GO
