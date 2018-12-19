IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usp_DataImport_DC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Usp_DataImport_DC]
Go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



CREATE procedure [dbo].[Usp_DataImport_DC]
@Code Varchar(3),@fName varchar(100),@Loc_Code Varchar(7),@Tbl Varchar (50)
as 
Begin -- 1)
	Declare @SqlCommand nvarchar(4000),@SqlCommand1 nvarchar(4000),@UpdateSqlTmp nvarchar(4000),@UpdateSql nvarchar(4000),@fld_Name varchar(60),@Table_Names Varchar (100),@Table_Name Varchar (100), @pos int
	Declare @TblFldList as VARCHAR(50)
	Declare @UpdateStmt nvarchar(1000),@FilterCondition nvarchar(1000),@SqlCommnad nvarchar(4000)
	declare @Sdate varchar(10),@Edate varchar(10)
	set @Sdate =''
	set @Edate =''
	--set @Table_Names='PTMain,PTItem,PTAcDet,PTItRef,PTMall'
	set @Table_Names=@Tbl
	
	Set @TblFldList = '##TblFldList'+(SELECT substring(rtrim(ltrim(str(RAND( (DATEPART(mm, GETDATE()) * 100000 )
					+ (DATEPART(ss, GETDATE()) * 1000 )
					+ DATEPART(ms, GETDATE())) , 20,15))),3,20) as No)
	select * into #lcode_vw from lcode where entry_ty='DC' -- Lcode View 
		
--	select * from #lcode_vw
	--print @TblFldList
	--execute USP_DataImport_GetFiledSchema @Code,@fName,'PTMain,PTItem,PTAcDet,PTItRef,PTMall',@TblFldList
	execute USP_DataImport_GetFiledSchema @Code,@fName,@Table_Names,@TblFldList
	print 'a '+@TblFldList

	set @Table_Names=@Table_Names+','
	set @pos=2
	
	while (@pos>1)
	begin -- 2)
		set @pos=charindex(',',@Table_Names)
		set @Table_Name=substring(@Table_Names,0,@pos)
		print @pos
		set @Table_Names=substring(@Table_Names,@pos+1,len(@Table_Names)-@pos)

		set @SqlCommand=''
		set @UpdateSql=''
		if (@Table_Name<>'')
		begin -- 3)
			if substring(@Table_Name,3,4)='Item'
			begin
				set @UpdateSqlTmp='Update a set a.it_code=b.it_code  from '+@Table_Name+'_'+@fName+ ' a inner join it_mast b on (a.item=b.it_name)'
				Print '5. '+@UpdateSqlTmp
				EXECUTE SP_EXECUTESQL @UpdateSqlTmp
			end

			Print 'XXXXXXX   ***   XXXXXXX   '+@Table_Name+'XXXXXXX   ***   XXXXXXX   '
			Declare Cur_DataImp1 Cursor for select UpdateStmt,FilterCondition from ImpDataTableUpdate where Code=@Code and TableName=@Table_Name order by updOrder
			open Cur_DataImp1
			fetch next from Cur_DataImp1 into @UpdateStmt,@FilterCondition
			while (@@Fetch_Status=0)
			begin
				set @SqlCommnad='Update '+@Table_Name+' Set '+rtrim(@UpdateStmt) +' Where '+rtrim(@FilterCondition)
				Print '??'
				--print @SqlCommnad
				--execute sp_executesql @SqlCommnad
				fetch next from Cur_DataImp1 into @UpdateStmt,@FilterCondition
			end
			close Cur_DataImp1
			DeAllocate Cur_DataImp1

			set @SqlCommand1 ='Declare cur_AcMast cursor for select distinct Fld_Name from '+@TblFldList+' where Tbl_Name='+char(39)+@Table_Name+'_'+@fName+char(39)
--			Print '1. '
--			print @SqlCommand1
			execute sp_executesql @SqlCommand1
			open cur_AcMast
			fetch next from cur_AcMast into  @fld_Name
			while (@@fetch_Status=0)	
			begin
				
				set @UpdateSql=rtrim(@UpdateSql)+',a.['+@fld_name+']=b.['+@fld_name+']'
				set @SqlCommand=rtrim(@SqlCommand)+',['+@fld_Name+']'
				
				fetch next from cur_AcMast into  @fld_Name

			end
			close cur_AcMast
			deallocate cur_AcMast
			
		
			--print 'aaa '+@SqlCommand
			if (@SqlCommand<>'')
			begin -- 4)
				set @SqlCommand=substring(@SqlCommand,2,len(@SqlCommand)-1)
				set @UpdateSql=substring(@UpdateSql,2,len(@UpdateSql)-1)

				set @SqlCommand=' insert into '+@Table_Name+' ('+rtrim(@SqlCommand)+',DataImport'+') '+' Select '+rtrim(@SqlCommand)+',DataExport1 from '+@Table_Name+'_'+@fName
--				set @SqlCommand=rtrim(@SqlCommand)+' where '+char(39)+@Loc_Code+char(39)+'+sEntry_ty+cast(Tran_cd as Varchar) not in (Select distinct DataImport From '+@Table_Name+')'
				set @SqlCommand=rtrim(@SqlCommand)+' where DataExport1 not in (Select distinct DataImport From '+@Table_Name+')'

				set @UpdateSql='Update a set '+rtrim(@UpdateSql)+' from '+@Table_Name+' a inner join '+@Table_Name+'_'+@fName+' b on (a.DataImport=b.DataExport1) where isnull(a.dataexport,'''')='''''
				Print '2. '
				
				print ' Update Statement:- '+@UpdateSql 
				EXECUTE SP_EXECUTESQL @UpdateSql	
				Print '2a. '
				print ' Insert Statement:- '+ @SqlCommand			
				EXECUTE SP_EXECUTESQL @SqlCommand

----xxxxx Main xxxxx----
				if substring(@Table_Name,3,4)='Main'
				begin  -- 5)
					set @UpdateSql='Update a set a.ac_id=isnull(b.ac_id,0),
												 a.cons_id=isnull(b.ac_id,0)
												 from '+@Table_Name+' a
												 inner join DCmain_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
												 inner join ac_mast b on (a.party_nm=b.ac_name)'
					Print '3.a ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql

					set @UpdateSql='Update a set a.scons_id=isnull(c.shipto_id,0)
												 from '+@Table_Name+' a
												 inner join DCmain_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
												 inner join shipto c on (e.Scons_Name=c.location_id)'
					Print '3.b ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
												 
					set @UpdateSql='Update a set a.sac_id=isnull(d.shipto_id,0)
												 from '+@Table_Name+' a
												 inner join DCmain_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
												 inner join shipto d on (e.sac_name=d.location_id)'
					Print '3.c ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql

					set @UpdateSql='Update a set a.MANUAC_id=isnull(j.ac_id,0)
												 from '+@Table_Name+' a
												 inner join DCmain_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
												 inner join ac_mast j on (e.MANUAC_name=j.ac_name)'
					Print '3.d ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
												 
					set @UpdateSql='Update a set a.MANUSAC_id=isnull(f.shipto_id,0)
												 from '+@Table_Name+' a
												 inner join DCmain_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
												 inner join shipto f on (e.MANUSAC_name=f.location_id)'
					Print '3.e ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
												
					set @UpdateSql='Update a set a.SUPPAC_id=isnull(g.ac_id,0)
												 from '+@Table_Name+' a
												 inner join DCmain_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
												 inner join ac_mast g on (e.SUPPAC_name=g.ac_name)'
					Print '3.f ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql

					set @UpdateSql='Update a set a.SUPPSAC_id=isnull(h.shipto_id,0)
												 from '+@Table_Name+' a
												 inner join DCmain_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
												 inner join shipto h on (e.SUPPSAC_name=h.location_id)'

					Print '3.g ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql

					set @UpdateSql='Update dcmain set cons_id=0  where cons_id is null'
					Print 'Update for Nulls 1 : ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
					set @UpdateSql='Update dcmain set scons_id=0  where scons_id is null'
					Print 'Update for Nulls 1 : ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql

					set @UpdateSql='Update dcmain set sac_id=0  where sac_id is null'
					Print 'Update for Nulls 1 : ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
					set @UpdateSql='Update dcmain set MANUAC_id=0  where MANUAC_id is null'
					Print 'Update for Nulls 1 : ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
					set @UpdateSql='Update dcmain set MANUSAC_id=0  where MANUSAC_id is null'
					Print 'Update for Nulls 1 : ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
					set @UpdateSql='Update dcmain set SUPPAC_id=0  where SUPPAC_id is null'
					Print 'Update for Nulls 1 : ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
					set @UpdateSql='Update dcmain set SUPPSAC_id=0  where SUPPSAC_id is null'
					Print 'Update for Nulls 1 : ' +@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql


--					set @UpdateSql='Update a set a.ac_id=b.ac_id,
--												 a.cons_id=b.ac_id,
--												 a.scons_id=c.shipto_id,
--												 a.sac_id=d.shipto_id,												 
--												 a.MANUAC_id=j.ac_id,
--												 a.MANUSAC_id=f.shipto_id,
--												 a.SUPPAC_id=g.ac_id,
--												 a.SUPPSAC_id=h.shipto_id
--												 from '+@Table_Name+' a
--												 inner join DCmain_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
--												 inner join ac_mast b on (a.party_nm=b.ac_name)
--												 inner join shipto c on (e.Scons_Name=c.location_id)
--												 inner join shipto d on (e.sac_name=d.location_id)
--												 inner join ac_mast j on (e.MANUAC_name=j.ac_name)
--												 inner join shipto f on (e.MANUSAC_name=f.location_id)
--												 inner join ac_mast g on (e.SUPPAC_name=g.ac_name)
--												 inner join shipto h on (e.SUPPSAC_name=h.location_id)'
--
--					Print '3. ' +@UpdateSql
--					EXECUTE SP_EXECUTESQL @UpdateSql
						
				end -- 5)
----xxxxx Main xxxxx----

----xxxxx Item xxxxx----
				if substring(@Table_Name,3,4)='Item'
				begin -- 5a)
--					set @UpdateSql='Update a set a.ac_id=b.ac_id  from '+@Table_Name+' a inner join ac_mast b on (a.party_nm=b.ac_name)'
					set @UpdateSql='Update a 
										set a.ac_id=b.ac_id
										from '+@Table_Name+' a 
										inner join DCitem_'+@fName+ ' e on (a.dataimport=e.dataexport1) 
										inner join ac_mast b on (e.Ac_Name=b.ac_name)'
--										inner join shipto c on (e.manusAc_Name=c.location_id)'

					Print '4. '+@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
					set @UpdateSql='Update a set a.it_code=b.it_code  from '+@Table_Name+' a inner join it_mast b on (a.it_code=b.it_code)'
					Print '5. '+@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql

					set @SqlCommand = 'update a set a.Tran_Cd = c.Tran_cd 
					from dcitem_' +@fName+' a 
					inner join  dcmain_'+@fName+ ' b on (a.oldTran_cd=b.oldTran_cd)
					inner join dcmain c on (b.dataExport1=c.dataimport)'
					Print '6. '
					print @SqlCommand					
					EXECUTE SP_EXECUTESQL @SqlCommand
					set @SqlCommand = 'update a set a.Tran_cd=b.Tran_cd
					from dcitem a 
					inner join dcitem_'+@fName+' b on (a.dataimport=b.dataExport1)
					inner join dcmain_'+@fName+' c on(b.oldTran_cd=c.OldTran_cd)'
					Print '7. '
					print @SqlCommand
					EXECUTE SP_EXECUTESQL @SqlCommand
					---Update trancd in temp funda
				end  -- 5a)
----xxxxx Item xxxxx----

----xxxxx LItemAll xxxxx----
				if @Table_Name='LitemAll'
				begin
					Print '---must update Trans_cd '
					set @UpdateSql='update a set a.TRAN_CD=DC.TRAN_CD
						FROM  LITEMALL a INNER JOIN DCMAIN_'+@fName+' X ON (a.TRAN_CD=X.TRAN_CD)
						INNER JOIN DCMAIN DC ON (DC.DATAIMPORT=X.DATAEXPORT1)
						where a.entry_ty=''DC'''
					Print '8. '+@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
					set @UpdateSql='update a set a.pTRAN_CD=AR.TRAN_CD
						FROM LITEMALL a INNER JOIN armAIN_'+@fName+' X ON (a.pTRAN_CD=X.TRAN_CD)
						INNER JOIN arMAIN AR ON (AR.DATAIMPORT=X.DATAEXPORT1)
						where a.pentry_ty=''AR'' and a.entry_ty=''DC'''
					Print '9. '+@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
					set @UpdateSql='update a set a.rTRAN_CD=AR.TRAN_CD
						FROM LITEMALL a INNER JOIN armAIN_'+@fName+' X ON (a.rTRAN_CD=X.TRAN_CD)
						INNER JOIN arMAIN AR ON (AR.DATAIMPORT=X.DATAEXPORT1)
						where a.rentry_ty=''AR'' and a.entry_ty=''DC'''
					Print '10. '+@UpdateSql
					EXECUTE SP_EXECUTESQL @UpdateSql
				end
----xxxxx LItemAll xxxxx----

				-- Below Updating Nulls to their default Values.
				set @UpdateSql='execute Update_table_column_default_value '+char(39)+@Table_Name+char(39)+',1'
				EXECUTE SP_EXECUTESQL @UpdateSql


			end -- 4)
		end -- 3)	
	end  -- 2)

----xxxxx Doc_no Generation xxxxx----
	set @UpdateSql='select @EdateOut=max(convert(varchar(10),date,103)) from DCMAIN_'+@fName
	Print '11. '+@UpdateSql
	EXECUTE SP_EXECUTESQL @UpdateSql,N'@EdateOut varchar(10) output',@EdateOut=@Edate output
	set @UpdateSql='select @SdateOut=min(convert(varchar(10),date,103)) from DCMAIN_'+@fName
	Print '12. '+@UpdateSql
	EXECUTE SP_EXECUTESQL @UpdateSql,N'@SdateOut varchar(10) output',@SdateOut=@Sdate output
	print @Sdate
	print @Edate
	set dateformat dmy
	execute Usp_DocNo_Renumbering 'DC',@Sdate,@Edate,''
----xxxxx Doc_no Generation xxxxx----

----xxxxx Gen_Inv Updation xxxxx----	
	declare @FinYear varchar(9)
	set @UpdateSql='select distinct l_yn into ##FinYear from DCMAIN_'+@fName
	Print '13. '+@UpdateSql
	EXECUTE SP_EXECUTESQL @UpdateSql
	while exists( select top 1 l_yn from ##FinYear)
	begin
		select top 1 @FinYear=l_yn from ##FinYear
		print 'Found :' + @FinYear
		execute Usp_Gen_Inv_Updation 'DC',@FinYear
		delete from ##FinYear where l_yn=@FinYear
	end
	drop table ##FinYear
----xxxxx Gen_Inv Updation xxxxx----	
end -- 1)


