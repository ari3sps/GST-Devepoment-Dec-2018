DROP FUNCTION [MonthYear]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [MonthYear]
(@date smalldatetime)
Returns varchar(4) 
as 
Begin
	return substring(convert(varchar(50),@date,112),5,2)+substring(convert(varchar(50),@date,112),3,2)
End
GO
