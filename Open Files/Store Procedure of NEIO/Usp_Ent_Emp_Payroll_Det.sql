DROP PROCEDURE [Usp_Ent_Emp_Payroll_Det]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Created By : Rupesh Prajapati
-- Create date: 19/03/2012
-- Description:	This Stored Procedure is used by Employee Report for getting Earning & Deduction Details
-- Remark	  : 
-- Modified By and Date : Rupesh,08/02/2013, Bug-7980
-- Modified By and Date : Sachin,18/12/2013, Bug-20963
-- Modified By and Date : Sachin,04/02/2014, Bug-21307
-- =============================================
CREATE PROCEDURE [Usp_Ent_Emp_Payroll_Det]
--@Tran_Cd int,@LastDate SmallDateTime,@Entry_Ty Varchar(2)
@Tran_Cd int,@LastDate SmallDateTime,@Entry_Ty Varchar(2),@AEMode bit		-- Changed by Sachin N. S. on 18/12/2013 Bug-20963
AS
BEGIN
	Declare @FCON as NVARCHAR(2000)
	DECLARE @fld_nm VARCHAR(30),@Short_Nm VARCHAR(60),@SqlCommand NVARCHAR(4000)
	Set @SqlCommand='Select sel=cast((Case when '+@Entry_Ty+'_Trn_Cd<>0 then ''1'' else ''0'' end)  as bit),b.EmployeeName,b.EmployeeCode,a.NetPayment as NetPay,a.GrossPayment as GrossPay'
	
	
	DECLARE @ParmDefinition nvarchar(500);
	if @Entry_Ty='PP'
	Begin
		Declare cur_EmpPayHead cursor for Select a.Fld_Nm,a.Short_Nm From Emp_Pay_Head_Master a inner join Emp_Pay_Head b on (a.HeadTypeCode=b.HeadTypeCode) order by b.SortOrd,a.SortOrd
		open cur_EmpPayHead
		Fetch next from cur_EmpPayHead into @Fld_Nm	,@Short_Nm
		while(@@Fetch_Status=0)
		begin
			print  @Fld_Nm	+' '+@Short_Nm
			set @SqlCommand=rtrim(@SqlCommand)+','+rtrim(@Fld_Nm)--+' as ['+rtrim(@Short_Nm)+']'
			print @SqlCommand
			Fetch next from cur_EmpPayHead into @Fld_Nm	,@Short_Nm
		end
		Close cur_EmpPayHead
		Deallocate  cur_EmpPayHead
	End
	If @Entry_Ty='TH'
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' ,TdsAmt'
	end

	If @Entry_Ty='FH'
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' ,PFEmpR,PFEmpE,EPSAmt,VEPFAmt,PFAdChg,EDLIContr,EDLIAdChg'
	end
	If @Entry_Ty='RH'
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' ,PTaxAmt'
	end
	If @Entry_Ty='EH'
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' ,ESICEmpE,ESICEmpR'
	end

--	set @SqlCommand=rtrim(@SqlCommand)+',Pay_Year,Pay_Month,cPay_Month=DateName(mm,mnthLastDt) From Emp_Monthly_Payroll a inner join EmployeeMast b on (a.EmployeeCode=b.EmployeeCode) Where '
--	set @SqlCommand=rtrim(@SqlCommand)+',Pay_Year,Pay_Month,cPay_Month=DateName(mm,mnthLastDt), b.Loc_Code, c.Loc_Desc '
--	set @SqlCommand=rtrim(@SqlCommand)+' From Emp_Monthly_Payroll a inner join EmployeeMast b on (a.EmployeeCode=b.EmployeeCode) inner join Loc_Master c on (b.Loc_Code=c.Loc_Code) Where '	-- Changed by Sachin N. S. on 18/12/2013 for Bug-20963

	set @SqlCommand=rtrim(@SqlCommand)+',Pay_Year,Pay_Month,cPay_Month=DateName(mm,mnthLastDt), b.Loc_Code, c.Loc_Desc, d.ac_name as emp_AcName'		-- Changed by Sachin N. S. on 03/02/2014 for Bug-21307
	set @SqlCommand=rtrim(@SqlCommand)+' From Emp_Monthly_Payroll a inner join EmployeeMast b on (a.EmployeeCode=b.EmployeeCode) inner join Loc_Master c on (b.Loc_Code=c.Loc_Code) '	-- Changed by Sachin N. S. on 03/02/2014 for Bug-21307
	set @SqlCommand=rtrim(@SqlCommand)+' left outer join ac_mast d on b.ac_id=d.ac_id where '		-- Added by Sachin N. S. on 03/02/2014 for Bug-21307
	
	if (@Tran_Cd=0)
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' a.'+@Entry_Ty+'_Trn_Cd=0 and a.mnthLastDt<='+char(39)+Cast(@LastDate as Varchar)+Char(39)
	End
	else
	begin
		set @SqlCommand=rtrim(@SqlCommand)+' ( a.'+@Entry_Ty+'_Trn_Cd=0 or a.'+@Entry_Ty+'_Trn_Cd='+cast(@Tran_Cd as varchar)+')'
		set @SqlCommand=rtrim(@SqlCommand)+' and  a.mnthLastDt<='+char(39)+Cast(@LastDate as Varchar)+Char(39)
	end
	If @Entry_Ty='TH'
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' And a.TdsAmt<>0'
	end
	If @Entry_Ty='FH'
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' And a.PFEmpE+a.PFEmpR+a.EPSAmt<>0'
	end
	If @Entry_Ty='RH'
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' And a.PTaxAmt<>0'
	end

	If @Entry_Ty='EH'
	Begin
		set @SqlCommand=rtrim(@SqlCommand)+' And a.ESICEmpE+a.ESICEmpR<>0'
	end
--	set @SqlCommand=rtrim(@SqlCommand)+' order by a.Pay_Year,a.Pay_Month,a.EmployeeCode' 
	set @SqlCommand=rtrim(@SqlCommand)+' order by a.Pay_Year,a.Pay_Month,c.Loc_Desc,a.EmployeeCode'		-- Changed by Sachin N. S. on 18/12/2013 for Bug-20963
	print @SqlCommand
	Execute Sp_ExecuteSql @SqlCommand
	--execute Usp_Ent_Emp_Payroll_Det 0,'2012/07/10','FH'
	--Select a.*,E.EmployeeName,E.DepartMent,E.Category,L.Loc_Desc From #EmpPayHead a inner join EmployeeMast e on (a.EmployeeCode=e.EmployeeCode) left join Loc_Master l on (e.Loc_Code=l.Loc_Code) order by l.Loc_Desc,E.Department,E.Category,E.EmployeeName
	
END
GO
