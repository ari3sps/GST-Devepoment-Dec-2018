DROP PROCEDURE [Usp_find_Miss_voucher]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Shrikant S.
-- Create date: 14/11/2009
-- Description:	This Stored procedure is useful to Missing Voucher .
-- Modified By: Priyanka B. for Bug-31183
-- Modify date: 17/01/2018
-- Remark:
-- =============================================

CREATE Procedure [Usp_find_Miss_voucher]
@TMPAC NVARCHAR(50),@TMPIT NVARCHAR(50),@SPLCOND VARCHAR(8000),@SDATE  SMALLDATETIME,@EDATE SMALLDATETIME
,@SAC AS VARCHAR(60),@EAC AS VARCHAR(60)
,@SIT AS VARCHAR(60),@EIT AS VARCHAR(60)
,@SAMT FLOAT,@EAMT FLOAT
,@SDEPT AS VARCHAR(60),@EDEPT AS VARCHAR(60)
,@SCATE AS VARCHAR(60),@ECATE AS VARCHAR(60)
,@SWARE AS VARCHAR(60),@EWARE AS VARCHAR(60)
,@SINV_SR AS VARCHAR(60),@EINV_SR AS VARCHAR(60)
,@LYN VARCHAR(20)
,@EXPARA  AS VARCHAR(200)
as

/* Searching for auto invoice generation from Lcode */
Select Entry_ty,Code_Nm,Auto_Inv,Invno_size 
Into #tmpLcode from Lcode Where auto_inv<>0

--Select * From #tmpLcode

Create Table #Miss_Vou(Entry_ty Varchar(2),Code_nm Varchar(50),Inv_sr Varchar(20),Inv_no Varchar(20),tot_Inv Varchar(4000))

/* Searching for Records from Lmain_vw for Current Year*/
Select b.Entry_ty,b.Inv_sr,b.Date,b.Inv_no,b.Doc_no,a.code_nm,a.invno_size
Into #tmpLmain  from Lmain_vw b 
Inner join #tmpLcode a on (a.entry_ty=b.entry_ty)
Where b.l_yn=@LYN and (b.date between @SDATE and @EDATE)
--and b.entry_ty='ST'
Order By b.Entry_ty,b.Inv_sr,b.Inv_no,b.Date,b.Doc_no 

--Select * From #tmpLmain

Declare @Series Varchar(20),@s_type Varchar(50),@i_prefix Varchar(10),@i_suffix Varchar(10),@invno_size int
Declare @Inv_No Varchar(20),@Inv_No1 Varchar(20),@tmpInvNo Varchar(20),@cnt Numeric,@Entry_ty Varchar(2),@Code_nm Varchar(50)
Declare @tmp Varchar(20),@MNTHFORMAT Varchar(10),@tmp_day Varchar(20),@tmp_mon Varchar(20),@tmp_day1 Varchar(20),@tmp_mon1 Varchar(20)
Declare @tmp_assign Varchar(20),@Miss_inv Varchar(20),@Date smalldatetime

/* Selecting different Entry_ty from Lcode in the Cursor Voutype_Cur ------------ Start */ 
Declare Voutype_Cur Cursor for
Select Entry_ty,Code_Nm From #tmpLcode 
Open Voutype_Cur
Fetch Next From Voutype_Cur Into @Entry_ty,@Code_Nm
While @@Fetch_Status=0
Begin	
	/* Selecting  Series from Series Master for Upper Entry type in the Cursor Series_cur ------------ Start */ 
	Declare Series_cur Cursor for
	Select distinct a.Inv_sr,b.s_type,i_prefix=Case when a.Inv_sr='' then a.Entry_ty+'/'+substring(@LYN,3,2)+substring(@LYN,8,2)+'/'  else b.i_prefix End ,b.i_suffix,a.invno_size,b.MNTHFORMAT From #tmpLmain a Inner Join Series b on (a.inv_sr=b.inv_sr) Where a.entry_ty=@Entry_ty		--Added by Shrikant S. on 06/06/2017 for GST	
	--Select distinct a.Inv_sr,b.s_type,b.i_prefix,b.i_suffix,a.invno_size,b.MNTHFORMAT From #tmpLmain a Inner Join Series b on (a.inv_sr=b.inv_sr) Where a.entry_ty=@Entry_ty		--Commented by Shrikant S. on 06/06/2017 for GST
	Open Series_cur 
	Fetch Next From Series_cur Into @Series,@s_type,@i_prefix,@i_suffix,@invno_size,@MNTHFORMAT
	While @@Fetch_Status=0
	Begin
	print '\n'
	print 'entry_ty 1 : ' + @entry_ty
	print 'invno_size 1 : ' + cast(@invno_size as varchar)
		set @tmpInvNo=Replicate('0',@invno_size)
		print 'len1'
		print 'tmpInvNo : ' + @tmpInvNo
		print len(@tmpInvNo)

		set @cnt =0
		/* Selecting  Invoice No. from #tmpLmain for Upper Invoice Series in the Cursor Invno_Cur ------------ Start */ 
		Declare Invno_Cur Cursor for
		Select Inv_no from #tmpLmain Where Inv_sr=@Series and entry_ty=@Entry_ty Order By Entry_ty,Inv_no,Date,Doc_no 
		Open Invno_Cur	
		Fetch Next From Invno_Cur Into @Inv_No1
		--set @tmp_day= substring(convert(varchar(10),@date,103),1,2)+substring(convert(varchar(10),@date,103),4,2)+substring(convert(varchar(10),@date,103),9,2)	
		set @tmp_day=Case When rtrim(@i_prefix)<>'' Then substring(rtrim(@Inv_No1),len(@i_prefix)-2+1,6) Else substring(rtrim(@Inv_No1),1,6) End
		
		set @tmp_mon=Case when rtrim(@i_prefix)<>'' then substring(rtrim(@Inv_No1),len(@i_prefix)-2+1, case when rtrim(@MNTHFORMAT)<>'' then len(rtrim(@MNTHFORMAT)) else 4 end) 
					Else substring(rtrim(@Inv_No1),0,case when rtrim(@MNTHFORMAT)<>'' then len(rtrim(@MNTHFORMAT)) else 4 end)  End
--		set @tmp_mon=Case When rtrim(@MNTHFORMAT)<>'' Then substring(rtrim(@Inv_No1),len(@MNTHFORMAT)+1,@invno_size) 
--						Else substring(rtrim(@Inv_No1),1,6) End
		set @cnt=1
		set @tmpInvNo=replicate('0',@invno_size-len(convert(Varchar(5),convert(Numeric,@cnt))))+convert(varchar(10),@cnt)

		PRINT 'S5'
		print 'tmp_day : ' + @tmp_day
		print 'tmp_mon : ' + @tmp_mon
		PRINT @tmp_mon
		While @@Fetch_Status=0
		Begin
--			print @Series+'-'+@Inv_No1+rtrim(@s_type)
			print @i_prefix
			Select @tmp=Case rtrim(@s_type)
						When 'DAYWISE' Then (Case When rtrim(@i_prefix)<>'' Then replace(rtrim(@i_prefix),'''','') Else '' End)+'******' 
						When 'MONTHWISE' Then (Case when rtrim(@MNTHFORMAT)<>'' then replicate('*',len(replace(rtrim(@MNTHFORMAT),'''',''))) 
						+(Case When rtrim(@i_prefix)<>'' Then replace(rtrim(@i_prefix),'''','') Else '' End) 
						else (Case When rtrim(@i_prefix)<>'' Then replace(rtrim(@i_prefix),'''','') Else '' End)
						+'****' end)
						else ''+(Case When rtrim(@i_prefix)<>'' Then replace(rtrim(@i_prefix),'''','') Else '' End) 
						End
				,@Miss_inv=Case rtrim(@s_type) 
						When 'DAYWISE' Then (Case When rtrim(@i_prefix)<>'' Then LEFT(@Inv_No1,len(replace(rtrim(@i_prefix),'''',''))+6) Else LEFT(@Inv_No1,6) End)
						When 'MONTHWISE' Then left(@Inv_No1,(Case when rtrim(@MNTHFORMAT)<>'' then len(replace(rtrim(@MNTHFORMAT),'''','')) Else 4 End)+(Case When rtrim(@i_prefix)<>'' Then LEN(replace(rtrim(@i_prefix),'''','')) Else 0 End) )
						else (Case When rtrim(@i_prefix)<>'' Then left(@Inv_No1,len(replace(rtrim(@i_prefix),'''',''))) Else '' End) End
				print 'tmp 1 : ' + @tmp			
			print @Inv_No1
			print @invno_size
			
			--Added by Priyanka B on 17012018 for Bug-31183 Start
			if rtrim(@tmp) = 'pget(P)' or rtrim(@tmp) = 'pget(S)'
			begin
				set @tmp=Case When len(@tmp)>0 Then Substring(rtrim(@Inv_No1),len(@tmp)+3,@invno_size) Else rtrim(@Inv_No1) End
			end
			else
			begin
				set @tmp=Case When len(@tmp)>0 Then Substring(rtrim(@Inv_No1),len(@tmp)+1,@invno_size) Else rtrim(@Inv_No1) End
			end
			--Added by Priyanka B on 17012018 for Bug-31183 End
			
			--set @tmp=Case When len(@tmp)>0 Then Substring(rtrim(@Inv_No1),len(@tmp)+1,@invno_size) Else rtrim(@Inv_No1) End   --Commented by Priyanka B on 16012018 for Bug-31183

			print 's1'
			print 'invno_size : ' + cast(@invno_size as varchar)
			print @tmpInvNo
			print @tmp

			if rtrim(@tmpInvNo) <> rtrim(@tmp)
			Begin
				While (convert(numeric,@tmpInvNo)<convert(numeric,@tmp))
				Begin
					print 'shrikant'
					if rtrim(@tmpInvNo) <> rtrim(@tmp)
					--print @Code_Nm+'-'+@tmpInvNo
					/* Inserting the Missing vouchers records to the Table ---------- Start */	
					insert into #Miss_Vou values (@Entry_ty,rtrim(@Code_Nm),rtrim(@Series),rtrim(@Miss_inv)+rtrim(@tmpInvNo)+rtrim(replace(rtrim(@i_suffix),'''','')),'')
					/* Inserting the Missing vouchers records to the Table ---------- End */	
					set @cnt=@cnt+1
					set @tmpInvNo=replicate('0',@invno_size-len(convert(Varchar(5),convert(Numeric,@cnt))))+convert(varchar(10),@cnt)	
					print 'dd'
				End
			End		
		Fetch Next From Invno_Cur Into @Inv_No1
		
		if rtrim(@s_type)='DAYWISE'
			Begin
				/* if s_type='DAYWISE' then setting @tmpInvNo='000000' */
				set @tmp_day1=Case When rtrim(@i_prefix)<>'' Then substring(rtrim(@Inv_No1),len(@i_prefix)-2+1,6) Else substring(rtrim(@Inv_No1),1,6) End
				print 's4'
--				print @tmp_day1
--				print @tmp_day
				if rtrim(@tmp_day)<>rtrim(@tmp_day1)
				Begin
					PRINT 'cc'
					set @tmp_day=rtrim(@tmp_day1) 
					set @cnt=0
					set @tmpInvNo=replicate('0',@invno_size-len(convert(Varchar(5),convert(Numeric,@cnt))))+convert(varchar(10),@cnt)
				End
			End			
		if rtrim(@s_type)='MONTHWISE'
			Begin
				/* if s_type='MONTHWISE' then setting @tmpInvNo='000000' */
				set @tmp_mon1=Case when rtrim(@i_prefix)<>'' then substring(rtrim(@Inv_No1),len(@i_prefix)-2+1, case when rtrim(@MNTHFORMAT)<>'' then len(rtrim(@MNTHFORMAT)) else 4 end) 
					Else substring(rtrim(@Inv_No1),0,case when rtrim(@MNTHFORMAT)<>'' then len(rtrim(@MNTHFORMAT)) else 4 end)  End
--				set @tmp_mon1=Case When rtrim(@MNTHFORMAT)<>'' Then substring(rtrim(@Inv_No1),len(@MNTHFORMAT)+1,@invno_size) 
--					Else substring(rtrim(@Inv_No1),1,@invno_size) End
				if rtrim(@tmp_mon)<>rtrim(@tmp_mon1)
				Begin
					set @tmp_mon=rtrim(@tmp_mon1) 
					set @cnt=0
					set @tmpInvNo=replicate('0',@invno_size-len(convert(Varchar(5),convert(Numeric,@cnt))))+convert(varchar(10),@cnt)
				End
			End			
	
		set @cnt=@cnt+1
		set @tmpInvNo=replicate('0',@invno_size-len(convert(Varchar(5),convert(Numeric,@cnt))))+convert(varchar(10),@cnt)
		End
		Close Invno_Cur 
		Deallocate Invno_Cur 
		/* Selecting  Invoice No. from #tmpLmain for Upper Invoice Series in the Cursor Invno_Cur ------------ End */ 
	Fetch Next From Series_cur Into @Series,@s_type,@i_prefix,@i_suffix,@invno_size,@MNTHFORMAT
	End
	Close Series_cur
	Deallocate Series_cur
	/* Selecting  Series from Series Master for Upper Entry type in the Cursor Series_cur ------------ End */ 
	Fetch Next From Voutype_Cur Into @Entry_ty,@Code_Nm
End
Close Voutype_Cur 
Deallocate Voutype_Cur 
/* Selecting different Entry_ty from Lcode in the Cursor Voutype_Cur ------------ Start */ 


--Select * From #Miss_Vou Order by code_nm,inv_sr,inv_no

Declare @tot_inv Varchar(4000)
Declare Outer_cur Cursor for 
Select distinct Entry_ty,Code_nm,Inv_sr From #Miss_Vou 
Open Outer_cur 
Fetch Next from Outer_cur Into @Entry_ty,@Code_nm,@Series
While @@Fetch_Status=0
Begin
	set @tot_inv=''
	Declare Inner_cur Cursor for 
	Select Inv_no From #Miss_Vou Where Entry_ty=@Entry_ty and Code_nm=@Code_nm and Inv_sr =@Series 
	Open Inner_cur 
	Fetch Next From Inner_cur Into @Inv_no 
	While @@Fetch_Status=0
	Begin
		set @tot_inv=@tot_inv+rtrim(@Inv_no)+', '
	Fetch Next From Inner_cur Into @Inv_no 
	End
	Close Inner_cur 
	Deallocate Inner_cur 
	Update #Miss_Vou set tot_inv =@tot_inv Where Entry_ty=@Entry_ty and Code_nm=@Code_nm and Inv_sr =@Series 
Fetch Next from Outer_cur Into @Entry_ty,@Code_nm,@Series 
End
Close Outer_cur 
Deallocate Outer_cur 

Select distinct Entry_ty,Code_nm,Inv_sr,tot_inv From #Miss_Vou 
Order by code_nm,inv_sr



Drop Table #tmpLcode
Drop Table #tmpLmain
Drop Table #Miss_Vou
GO