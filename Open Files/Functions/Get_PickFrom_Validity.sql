DROP FUNCTION [Get_PickFrom_Validity]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [Get_PickFrom_Validity](@Validty varchar(250),@cSep Char(1))returns varchar(250)asBEGIN	DECLARE @Entry_Ty VARCHAR(2),@cPickfrom VARCHAR(500),@nLoop INT,@nSubstrVal INT	SELECT @nLoop = 0 ---,@Validty = 'EQ / SQ /SO /BP / BR /SB'	SELECT @Validty = REPLACE(@Validty,'/','')	SELECT @Validty = REPLACE(@Validty,' ','')	SELECT @nLoop = LEN(@Validty),@nSubstrVal = 1,@cPickfrom = ''	IF @nLoop <> 0	BEGIN		SELECT @nLoop = @nLoop/2		WHILE @nLoop <> 0		BEGIN			set @Entry_Ty='' --Birendra : Bug-4930 on 29/06/2012			SELECT @Entry_Ty = Entry_Ty FROM Lcode WHERE Entry_Ty = SUBSTRING(@Validty,@nSubstrVal,2)--			IF @Entry_Ty is not null 			IF isnull(@Entry_Ty,'')<>'' --Birendra : Bug-4930 on 29/06/2012			BEGIN				SELECT @cPickfrom = @cPickfrom + @Entry_Ty	+ @cSep			END			SELECT @nLoop = @nLoop-1,@nSubstrVal = @nSubstrVal+2		END	ENDRETURN @cPickfromEND
GO
