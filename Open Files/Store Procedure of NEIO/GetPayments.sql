DROP PROCEDURE [GetPayments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [GetPayments]
@Sdate smallDatetime
As

Select a.Entry_ty,a.Tran_cd,a.Inv_no 
Into #tmpPay
From Brmain a 
Where a.Date<=@Sdate AND a.tdspaytype=2	and	a.Entry_ty in ('BR','CR')
Union all 
Select a.Entry_ty,a.Tran_cd,a.Inv_no From Crmain a 
		Where a.Date<=@Sdate AND a.tdspaytype=2 and	a.Entry_ty in ('BR','CR')


DECLARE @GRPID AS INT,@MCOND AS BIT,@LVL  AS INT,@GRP AS VARCHAR(100),@OPENTRIES as VARCHAR(50),@OPENTRY_TY as VARCHAR(50)

			SET @GRP='SUNDRY DEBTORS'
			DECLARE openingentry_cursor CURSOR FOR
				SELECT entry_ty FROM lcode
				WHERE bcode_nm = 'OB'
				OPEN openingentry_cursor
				FETCH NEXT FROM openingentry_cursor into @opentries
				WHILE @@FETCH_STATUS = 0
				BEGIN
				   Set @OPENTRY_TY = @OPENTRY_TY +','+CHAR(39)+@opentries+CHAR(39)
				   FETCH NEXT FROM openingentry_cursor into @opentries
				END
				CLOSE openingentry_cursor
				DEALLOCATE openingentry_cursor

			CREATE TABLE #ACGRPID (GACID DECIMAL(9),LVL DECIMAL(9))
			SET @LVL=0
			INSERT INTO #ACGRPID SELECT AC_GROUP_ID,@LVL  FROM AC_GROUP_MAST WHERE AC_GROUP_NAME=@GRP
			SET @MCOND=1
			WHILE @MCOND=1
			BEGIN
				IF EXISTS (SELECT AC_GROUP_ID FROM AC_GROUP_MAST WHERE GAC_ID IN (SELECT DISTINCT GACID  FROM #ACGRPID WHERE LVL=@LVL)) --WHERE LVL=@LVL
				BEGIN
					--PRINT @LVL
					INSERT INTO #ACGRPID SELECT AC_GROUP_ID,@LVL+1 FROM AC_GROUP_MAST WHERE GAC_ID IN (SELECT DISTINCT GACID  FROM #ACGRPID WHERE LVL=@LVL)
					SET @LVL=@LVL+1
				END
				ELSE
				BEGIN
					SET @MCOND=0	
				END
			END

			SELECT AC_ID,AC_NAME INTO #ACMAST FROM AC_MAST WHERE  AC_GROUP_ID IN (SELECT DISTINCT GACID FROM #ACGRPID)

Select ac.Entry_ty,ac.Tran_cd,billamount=ac.amount,ac.Date
				,recamt1=SUM(case when (AC.entry_ty=MLL.entry_all and AC.tran_cd =MLL.main_tran and AC.acserial =MLL.acseri_all and AC.AC_ID=MLL.AC_ID and MLL.date <@Sdate) then ISNULL(MLL.NEW_ALL,0)+ISNULL(MLL.TDS,0)+ISNULL(MLL.DISC,0) else 0 end) 
				,recamt2=SUM(case when (AC.entry_ty=MLL.entry_all and AC.tran_cd =MLL.main_tran and AC.acserial =MLL.acseri_all and AC.AC_ID=MLL.AC_ID and MLL.date between @Sdate and @Sdate) then ISNULL(MLL.NEW_ALL,0)+ISNULL(MLL.TDS,0)+ISNULL(MLL.DISC,0) else 0 end) 
				,a.Inv_no
				Into #tbl1
				from lmain_vw a
				Inner Join lac_vw ac ON (a.Tran_cd=ac.tran_cd and a.Entry_ty=ac.Entry_ty)
				INNER JOIN #ACMAST AM ON (ac.AC_ID=am.AC_ID)
				inner join #tmpPay b on (a.Entry_ty=b.Entry_ty and a.Tran_cd=b.Tran_cd)
				Left Join mainall_vw mll on (AC.entry_ty=MLL.entry_all and AC.tran_cd =MLL.main_tran and AC.acserial =MLL.acseri_all and AC.AC_ID=MLL.AC_ID AND MLL.DATE <=@Sdate)  --'+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)
					--Where tdspaytype=2 AND A.date <=@Sdate and a.Entry_ty in ('BR','CR')
					group by  ac.Entry_ty,ac.Tran_cd,ac.amount,ac.Date,a.Inv_no

			Select ac.Entry_ty,ac.Tran_cd,billamount=ac.amount,ac.Date
				,recamt1=sum(case when (AC.entry_ty=MLY.entry_ty and AC.tran_cd =MLY.tran_cd and AC.acserial =MLY.acserial and AC.AC_ID=MLY.AC_ID and MLY.date <@Sdate) then case when ISNULL(MLY.NEW_ALL,0) = 0 then ISNULL(MLY.TDS,0)+ISNULL(MLY.DISC,0) else ISNULL(MLY.NEW_ALL,0) end else 0 end) 
				,recamt2=sum(case when (AC.entry_ty=MLY.entry_ty and AC.tran_cd =MLY.tran_cd and AC.acserial =MLY.acserial and AC.AC_ID=MLY.AC_ID and MLY.date between @Sdate and @Sdate) then case when ISNULL(MLY.NEW_ALL,0) = 0 then ISNULL(MLY.TDS,0)+ISNULL(MLY.DISC,0) else ISNULL(MLY.NEW_ALL,0) end else 0 end) 
				,a.Inv_no
				Into #tbl2
				from lmain_vw a
				Inner Join lac_vw ac ON (a.Tran_cd=ac.tran_cd and a.Entry_ty=ac.Entry_ty)
				INNER JOIN #ACMAST AM ON (ac.AC_ID=am.AC_ID)	
				inner join #tmpPay b on (a.Entry_ty=b.Entry_ty and a.Tran_cd=b.Tran_cd)
				Left Join mainall_vw MLY on (AC.entry_ty=MLY.entry_ty and AC.tran_cd =MLY.tran_cd and AC.acserial =MLY.acserial and AC.AC_ID=MLY.AC_ID AND MLY.date_all <=@Sdate)  --AND MLy.DATE <= '+CHAR(39)+CAST(@SDATE AS VARCHAR)+CHAR(39)
					--Where tdspaytype=2 AND A.date <=@Sdate and a.Entry_ty in ('BR','CR')
					group by  ac.Entry_ty,ac.Tran_cd,ac.amount,ac.Date,a.Inv_no
			
			--select * from #tbl1
			--select * from #tbl2


			Select a.entry_ty,b.Tran_cd,a.billamount,balamt=a.billamount-a.recamt1-a.recamt2-b.recamt1-b.recamt2
			,recamt1=a.recamt1+b.recamt1
			,recamt2=a.recamt2+b.recamt2
			,a.Date,a.Inv_no
			Into #tbl3
				 From #tbl1 a
				Inner Join #tbl2 b on (a.entry_ty=b.entry_ty and a.Tran_cd=b.Tran_cd)

			delete from #tbl3 where balamt=0
			
			delete from #tbl3 where Inv_no in (Select paymentno From bpmain Where Entry_ty='RV')

Select Inv_no as [Transaction Number],Entry_ty,Tran_cd From #tbl3	



--Drop table #Alloc
Drop Table #tmpPay	

Drop Table #tbl1
Drop Table #tbl2
Drop Table #tbl3
Drop table #ACGRPID
Drop Table #ACMAST
GO
