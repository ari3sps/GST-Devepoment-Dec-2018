IF EXISTS(SELECT * FROM SYSOBJECTS WHERE [NAME]='USP_ENT_EMAILCLIENT_SELECT_SEARCH' AND XTYPE='P')
BEGIN
	DROP PROCEDURE USP_ENT_EMAILCLIENT_SELECT_SEARCH
END
GO
Create Procedure USP_ENT_EMAILCLIENT_SELECT_SEARCH
As
Begin
	Select * From eMailClient
End
