DROP PROCEDURE [Usp_Lmain_View]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [Usp_Lmain_View]
as
declare @tblName varchar(20),@SqlStr nvarchar(4000)
set @sqlStr=' '
set @tblName=''
select entry_ty,date,doc_no,cate,dept,party_nm,inv_no,inv_sr,l_yn,gro_amt,net_amt,[rule],up_reall=0,re_all=0,user_name into #temp from main where 1=2
declare curTables cursor for
select name from sysobjects where name like '%MAIN' and type='U'
open curTables
fetch next from curTables into @tblName
while @@fetch_status=0
begin
	print @tblName
	set @sqlStr = 'insert into #temp select entry_ty,date,doc_no,cate,dept,party_nm,inv_no,inv_sr,l_yn,gro_amt,net_amt,[rule],up_reall,re_all,user_name from '+@tblName
	exec sp_sqlexec @sqlstr
	fetch next from curTables into @tblName
end
close curTables
deallocate curTables
select * from #temp
drop table #temp
GO
