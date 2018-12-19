IF EXISTS(SELECT * FROM SYSOBJECTS WHERE [NAME]='USP_GETEMAILDETAILS' AND XTYPE='P')
BEGIN
	DROP PROCEDURE USP_GETEMAILDETAILS
END
GO
Create PROCEDURE USP_GETEMAILDETAILS
@ACID INT,
@ACNAME VARCHAR(100)
AS
SELECT rtrim(EMAIL) as Email FROM AC_MAST WHERE AC_NAME=@ACNAME

