DROP FUNCTION [FixAsset2QDt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [FixAsset2QDt]
(@l_yn Varchar(10))
returns smalldatetime
as
Begin
	return convert(smalldatetime,('10/01/'+left(ltrim(rtrim(@l_yn)),4)))
End
GO
