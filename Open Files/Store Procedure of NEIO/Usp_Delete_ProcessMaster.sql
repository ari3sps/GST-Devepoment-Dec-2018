DROP PROCEDURE [Usp_Delete_ProcessMaster]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [Usp_Delete_ProcessMaster]
@process_id varchar(100)
as
select distinct entry_ty,(case when ext_vou=1 then bcode_nm else entry_ty end) as bhent  
into #lcode  
from lcode   
order by bhent

select e_code,head_nm,fld_nm,(case when att_file=1 then 'main' else 'item' end) as tbl
into #lother
from lother
where head_nm = 'Process' and fld_nm='PROC_ID' and type='T'
union all
select code,head_nm,fld_nm,filename 
from mastcode m
inner join lother l on (m.code=l.e_code)
where head_nm = 'Process'
and fld_nm='PROC_ID'

select l.e_code,(case when (bhent='' and tbl='item') then 'item' 
				when (bhent='' and tbl='main') then 'main' 
				when (tbl not in ('main','item')) then tbl
				when (bhent<>'') then bhent+tbl else '' end) as tbl 
into #lother1
from #lother l
left join #lcode d on (l.e_code=d.entry_ty)

Select space(2) as entry_ty,cast('' as varchar(100)) as Proc_id into #l1 From #lother1 Where 1=2

declare @e_code varchar(2) ,@tbl varchar(10),@Proc_id varchar(100),@entry_ty varchar(2),@nentry_ty varchar(2)
declare @sqlcommand nvarchar(max)
declare curTbl cursor for 
select distinct e_code,tbl from #lother1
Open curTbl
Fetch Next From curTbl Into @e_code,@tbl
While @@FETCH_STATUS = 0
Begin
	Set @entry_ty=''	
	--select @tbl
	set @sqlcommand = 'Declare @Proc_id varchar(100) Insert into #l1 Select entry_ty='+char(39)+@e_code+char(39)+',Proc_id From '+@tbl+' Where Proc_id='+char(39)+@process_id+char(39)
	print @sqlcommand
	EXEC SP_EXECUTESQL @SQLCOMMAND	
	--Set @nentry_ty=@nentry_ty+@entry_ty
	Fetch Next From curTbl Into @e_code,@tbl
End
Close curTbl
Deallocate curTbl
select * from #l1

drop table #lcode
drop table #lother
drop table #lother1
drop table #l1

--Execute Usp_Delete_ProcessMaster 'Proc2'

--select * from processmast
--select * from bomhead
--select * from item
GO
