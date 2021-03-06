DROP PROCEDURE [Usp_DataImport_TempTableCreation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Usp_DataImport_TempTableCreation]
@fNname varchar(600),@Table_Name Varchar (100)
,@tTable_Name Varchar (100)
as 
Begin
Declare @SqlCommand nvarchar(1000)
set @fNname=replace(@fNname,'\\','\')

print @fNname

DECLARE @xmlDocument XML 
DECLARE @docHandle int
Declare @ParmDefinition nvarchar(100)

--if exists(select [Name] from sysobjects where [name]=@tTable_Name and xType='U')
--begin
--	set @SqlCommand='drop table '+@tTable_Name
--	print @SqlCommand
--	execute sp_executesql @sqlcommand
--end

set @ParmDefinition = N'@xml XML OUTPUT' 
set @SqlCommand='SELECT @xml=CONVERT(xml, BulkColumn, 1) FROM OPENROWSET(Bulk '+char(39)+@fNname+char(39)+', SINGLE_BLOB) [rowsetresults]'
print @sqlcommand
execute sp_executesql @sqlcommand,@ParmDefinition,@xml=@xmlDocument output;
select @xmlDocument

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument

set @ParmDefinition = N'@doc1 int' 
set @SqlCommand='Insert Into '+@tTable_Name+' SELECT * FROM OPENXML(@doc1, N'+char(39)+'/'+@Table_Name+'/'+@Table_Name+char(39)+')  WITH '+@tTable_Name
--set @SqlCommand=' SELECT *  FROM OPENXML(@doc1, N'+char(39)+'/'+@Table_Name+'/'+@Table_Name+char(39)+')  WITH '+@tTable_Name
--set @SqlCommand='SELECT *    FROM OPENXML(@doc1, N'+char(39)+'/'+@Table_Name+'/'+@Table_Name+char(39)+')  WITH '+@Table_Name
print @SqlCommand
execute sp_executesql @sqlcommand,@ParmDefinition,@doc1=@docHandle

--	if(@fNam
--update Imp_Master set Code='AM',Decription='Account_Master',ImpFileNm='AC_MAST'
--<<Ac_Mast##KeyFld<AC_Name>##ExcludeFld<Ac_Id,State_Id,City_Id,Country_Id>##FName<AC_MAST>>><<shipto##KeyFld<Mail_Name,Location_ID>##ExcludeFld<state_id,city_id,country_id,ac_id,shipto_id>##FName<ShipTo>>>
--	declare @Code Varchar(3),@Tables Varchar(1000)
--	--select * from imp_master
--	
--	declare Cur_Imp cursor for select Code,Tables from imp_master order by (Case when Category='Master' then 'a' else 'b' end)
--	open Cur_Imp
--	fetch next from Cur_Imp into @Code,@Tables 
--	while (@@fetch_status=0)
--	begin
--		print @Code
--		print @Tables
--		
--		fetch next from Cur_Imp into @Code,@Tables 
--	end
--	close Cur_Imp
--	deallocate Cur_Imp

end
GO
