DROP PROCEDURE [USP_REP_1_PRICELIST]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [USP_REP_1_PRICELIST] 
@SAC AS VARCHAR(100),@EAC AS VARCHAR(100),@SIT AS VARCHAR(100),@EIT AS VARCHAR(100)
AS
DECLARE @AC_ID NUMERIC(9),@AC_GROUP_ID1 NUMERIC(9),@GNAME1 VARCHAR(60),@AC_GROUP_ID2 NUMERIC(9),@GNAME2 VARCHAR(60),@AC_GROUP_ID3 NUMERIC(9),@GNAME3 VARCHAR(60)
SELECT DISTINCT AC_ID=AC_GROUP_ID,AC_GROUP_ID1=AC_GROUP_ID,AC_GROUP_ID2=AC_GROUP_ID,AC_GROUP_ID3=AC_GROUP_ID,GNAME1=[GROUP],GNAME2=[GROUP],GNAME3=[GROUP] INTO #1JRTMP FROM AC_MAST WHERE 1=2


--DECLARE  C1JRTMP CURSOR FOR 
--SELECT  DISTINCT AC_ID FROM JVACDET
--ORDER BY AC_ID
--OPEN C1JRTMP
--FETCH NEXT FROM C1JRTMP INTO @AC_ID
--WHILE @@FETCH_STATUS=0
--BEGIN
--	SELECT @AC_GROUP_ID1=AC_GROUP_ID,@GNAME1=[GROUP] FROM AC_MAST WHERE AC_ID=@AC_ID
--	SELECT @AC_GROUP_ID2=GAC_ID,@GNAME2=[GROUP] FROM AC_GROUP_MAST WHERE AC_GROUP_ID=@AC_GROUP_ID1
--	SELECT @AC_GROUP_ID3=GAC_ID,@GNAME3=[GROUP] FROM AC_GROUP_MAST WHERE AC_GROUP_ID=@AC_GROUP_ID2
--	INSERT INTO #1JRTMP ( AC_ID,AC_GROUP_ID1,AC_GROUP_ID2,AC_GROUP_ID3,GNAME1,GNAME2,GNAME3) VALUES (@AC_ID,@AC_GROUP_ID1,@AC_GROUP_ID2,@AC_GROUP_ID3,@GNAME1,@GNAME2,@GNAME3)
--	FETCH NEXT FROM C1JRTMP INTO @AC_ID
--END
--CLOSE C1JRTMP
--DEALLOCATE C1JRTMP

select ir.it_name as [Item Description],it.rateunit as [Rate Unit],ir.it_rate as [Rate],it.type as [Item Type],a.mailname as [Party Name]
,ir.Rlevel as [Rate Level],ir.Type,(case when ir.ptype='I' then 'Goodswise' else 'Partywise' end) as [Goodswise/Partywise],a.ac_id
--,T.gname1 as [Group Level1],T.gname2 as [Group Level2],T.gname3 as [Group Level3]
from it_rate ir 
inner join it_mast it on (ir.it_code=it.it_code) 
inner join ac_mast a on(a.ac_id=ir.ac_id)
--INNER JOIN #1JRTMP T ON (IR.AC_ID=T.AC_ID)
WHERE   (ir.AC_NAME BETWEEN @SAC AND @EAC) AND (IR.IT_NAME BETWEEN @SIT AND @EIT)
GO
