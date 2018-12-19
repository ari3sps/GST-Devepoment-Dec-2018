&&Changes has been done as per TKT-6470 (Multilanguage support - Tested with English & Japanese Language) on 24/02/2011
&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
Lparameters _ltDatasessionid,_lttype,_ltpara1,_ltpara2,_ltpara3
If Type('_ltDatasessionid') = 'L'
	_ltDatasessionid = _Screen.ActiveForm.DataSessionId
Endif

Set DataSession To _ltDatasessionid
Set Deleted On
_ltpara1a = ''
_ltpara2a = ''
_ltpara3a = ''
If Type('_ltpara1') != 'C'
	_ltpara1 = ''
Endif
If Type('_ltpara2') != 'C'
	_ltpara2 = ''
Endif
If Type('_ltpara3') != 'C'
	_ltpara3 = ''
Endif
_ltpara1a = Alltrim(_ltpara1)
_ltpara2a = Alltrim(_ltpara2)
_ltpara3a = Alltrim(_ltpara3)
_ltpara4a = Iif(Type('_ltpara1') = 'C',Alltrim(_ltpara1),'')+Iif(Type('_ltpara2') = 'C',Alltrim(_ltpara2),'')+Iif(Type('_ltpara3') = 'C',Alltrim(_ltpara3),'')
_UnqVal = .F.
_UnqVal = GlobalObj.GetPropertyVal('UnqVal')
If Type('ueReadRegMe.UnqVal') <> 'N' And Type('_UnqVal') <> 'C'
	Return .F.
Else
	_UnqVal = Substr(Dec(_UnqVal),2,8)
	If (ueReadRegMe.UnqVal != (Val(Substr(_UnqVal,2,1)+Substr(_UnqVal,1,1)+Substr(_UnqVal,4,1)+Substr(_UnqVal,3,1)+Substr(_UnqVal,6,1)+Substr(_UnqVal,5,1)+Substr(_UnqVal,8,1)+Substr(_UnqVal,7,1)) * 3))
		Return .F.
	Endif
Endif
Private usquarepass,mudprodcode, mprodtitle		&& Changed by Sachin N. S. on 13/04/2018 for Installer
usquarepass = Upper(Dec(NewDecry(GlobalObj.GetPropertyVal('EncryptId'),'Ud*_yog*\+1993')))
mudprodcode = Dec(NewDecry(GlobalObj.GetPropertyVal("UdProdCode"),'Ud*yog+1993'))
mprodtitle = GlobalObj.GetPropertyVal("ProductTitle")		&& Added by Sachin N. S. on 13/04/2018 for Installer

***** Added by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working -- Start
Local _varname1
_varname1 = '_ProdCode'+Sys(3)
&_varname1 = Cast(GlobalObj.GetPropertyVal("udProdCode") As Varbinary(250))
***** Added by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working -- End


*!*	If !Inlist(Upper(mudprodcode),'USQUARE','ITAX','VUDYOGSDK','VUDYOGMFG','VUDYOGTRD','VUDYOGSERVICETAX')
*!*	If !Inlist(Upper(mudprodcode),'USQUARE','ITAX','VUDYOGSDK','VUDYOGMFG','VUDYOGTRD','VUDYOGSERVICETAX','VUDYOGGSSDK')		&& Changed by Sachin N. S. on 27/09/2016 for GST
If !Inlist(Upper(mudprodcode),'USQUARE','ITAX','VUDYOGSDK','VUDYOGMFG','VUDYOGTRD','VUDYOGSERVICETAX','VUDYOGGSSDK','UERPSDK')		&& Changed by Sachin N. S. on 06/08/2018 for Bug-31756
	Local sqlconobj,_menuretval,_menuok,_macid,_mregname
	_mregname = ''
	_macid = ''
	_mregname = Alltrim(ueReadRegMe.r_comp)
	_macid 	  = Alltrim(ueReadRegMe.r_macid)

	sqlconobj=Newobject('sqlconnudobj',"sqlconnection",xapps)
	_menunHandle = 0
	_menuretval  = 0
	_menuok	     = 'Error'
	_menuretval =sqlconobj.dataconn('EXE',company.dbname,'select 1 from manufact',"dbfmenu","_menunHandle",_ltDatasessionid)

	Do Case
		Case _lttype = 'MENU'
			msqlstr = "select newrange as EncFld from com_menu"
			msqlstr = msqlstr + " where padname = ?_ltpara1a and barname = ?_ltpara2a"
		Case _lttype = 'TRANSACTION'
			msqlstr = "select cd as EncFld from lcode"
			msqlstr = msqlstr + " where entry_ty = ?_ltpara1a"
		Case _lttype = 'REPORT'
			msqlstr = "select newgroup as EncFld from r_status"
			msqlstr = msqlstr + " where [group] = ?_ltpara1a and [desc] = ?_ltpara2a and rep_nm = ?_ltpara3a"
	Endcase
	_menuretval =sqlconobj.dataconn('EXE',company.dbname,msqlstr,"dbfmenu","_menunHandle",_ltDatasessionid)
	If _menuretval > 0
		Select dbfmenu
		Do Case
			Case Reccount() = 0
				_menuok = 'No Records Found'
			Case Reccount() > 1
				_menuok = 'Multiple Records Found'
			Otherwise
				msqlstr = NewDecry(dbfmenu.EncFld,_macid)
				
				_customized = .F.
				Do Case
					Case _lttype = 'MENU' And Left(msqlstr,9) == 'CUST:MENU'
						_customized = .T.
					Case _lttype = 'TRANSACTION' And Left(msqlstr,9) == 'CUST:TRAN'
						_customized = .T.
					Case _lttype = 'REPORT' And Left(msqlstr,11) == 'CUST:REPORT'
						_customized = .T.
				Endcase
				If _customized = .T.
					_menuok = ''
				Else
					_featureid = ''

					msqlstr = NewDecry(dbfmenu.EncFld,'Udencyogprod')

*!*						Messagebox("msqlstr : "+msqlstr)


*!*						**** To be Removed -- Start
*!*						msqlstr1 = "Select Enc,CAST('' as varchar(250)) as enc1,fenc,penc,CAST('' as varchar(250)) as fenc1,CAST('' as varchar(250)) as penc1 from Vudyog..ProdDetail "
*!*						_menuretval =sqlconobj.dataconn('EXE',company.dbname,msqlstr1,"dbfmenu","_menunHandle",_ltDatasessionid)

*!*						Select dbfmenu
*!*						Go Top
*!*						Scan
*!*							Select dbfmenu
*!*							_decdata = NewDecry(Cast(dbfmenu.Enc As Blob),'Udencyogprod')
*!*							_decdata1 = NewDecry(Cast(dbfmenu.fEnc As Blob),'Udencyogprod')
*!*							_decdata2 = NewDecry(Cast(dbfmenu.pEnc As Blob),'Udencyogprod')
*!*							If '8495' $ _decdata1
*!*								_featureid  = NewEncry(Alltrim(_decdata1),'Udencyogprod')
*!*								_featureid  = Cast(_featureid As Varbinary(250))
*!*								msqlstr1 = "Update Vudyog..ProdDetail set enc1=?_decdata,fenc1=?_decdata1,penc1=?_decdata2 where fenc = ?_featureid"
*!*								_menuretval =sqlconobj.dataconn('EXE',company.dbname,msqlstr1,"","_menunHandle",_ltDatasessionid)
*!*							Endif
*!*							Replace enc1 With _decdata, fenc1 With _decdata1, penc1 With _decdata2 In dbfmenu

*!*							Select dbfmenu
*!*						Endscan
*!*						Select dbfmenu
*!*						Copy To "E:\UDYOG\UDYOGGST\dbfmenu.dbf"
*!*						**** To be Removed -- End


					_stlen = At('~*0*~',msqlstr)
					_enlen = At('~*1*~',msqlstr)

*!*						Messagebox("Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(msqlstr,_stlen + 5,_enlen-(_stlen+5)),''))+'~*0*~'+mudprodcode  :: "+Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(msqlstr,_stlen + 5,_enlen-(_stlen+5)),''))+'~*0*~'+mudprodcode)

					_featureid  = NewEncry(Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(msqlstr,_stlen + 5,_enlen-(_stlen+5)),''))+'~*0*~'+mudprodcode,'Udencyogprod')
					_featureid  = Cast(_featureid As Varbinary(250))
					*!*						_featureid  = Cast(_featureid As Blob)
					msqlstr = "Select Enc from Vudyog..ProdDetail where fenc = ?_featureid"
					_menuretval =sqlconobj.dataconn('EXE',company.dbname,msqlstr,"dbfmenu","_menunHandle",_ltDatasessionid)
					If _menuretval > 0
						_menuok = 'No Records Found' && Commented by Archana K. on 22/05/13 for Bug-7899
*!*							_menuok = 'This feature is not available in '+mudprodcode+'-'+Upper(GlobalObj.GetPropertyVal("ClientType"))  && Changed by Archana K. on 22/05/13 for Bug-7899
						_menuok = 'This feature is not available in '+mprodTitle+'-'+Upper(GlobalObj.GetPropertyVal("ClientType"))  && Changed by Sachin N. S. on 13/04/2018 for Installer	
						Select dbfmenu
						Go Top
						Scan
							_decdata = NewDecry(Cast(dbfmenu.Enc As Blob),'Udencyogprod')
							_stlen = 1
							_enlen = At('~*0*~',_decdata)
							_optiontype 	= Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(_decdata,_stlen,_enlen-_stlen),''))
							_stlen = At('~*0*~',_decdata)
							_enlen = At('~*1*~',_decdata)
							_featureid  	= Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(_decdata,_stlen + 5,_enlen-(_stlen+5)),''))
							_stlen = At('~*1*~',_decdata)
							_enlen = At('~*2*~',_decdata)
							_subfeatureid  	= Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(_decdata,_stlen + 5,_enlen-(_stlen+5)),''))
							_stlen = At('~*2*~',_decdata)
							_enlen = At('~*3*~',_decdata)
							_prodcode  		= Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(_decdata,_stlen + 5,_enlen-(_stlen+5)),''))
							_stlen = At('~*3*~',_decdata)
							_enlen = At('~*4*~',_decdata)
							_prodver  		= Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(_decdata,_stlen + 5,_enlen-(_stlen+5)),''))
							_stlen = At('~*4*~',_decdata)
							_enlen = At('~*5*~',_decdata)
							_servicever  	= Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(_decdata,_stlen + 5,_enlen-(_stlen+5)),''))
							_stlen = At('~*5*~',_decdata)
							_enlen = At('~*6*~',_decdata)
							_featuretype  	= Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(_decdata,_stlen + 5,_enlen-(_stlen+5)),''))
							_stlen = At('~*6*~',_decdata)
							_enlen = At('~*7*~',_decdata)
							_optionname  	= Alltrim(Iif(_stlen > 0 And _enlen > 0,Substr(_decdata,_stlen + 5,_enlen-(_stlen+5)),''))
							_customized = .F.


*!*								Messagebox("_decdata : "+_decdata)


							Do Case
								Case _lttype = 'MENU' And _optiontype = 'MENU'
									_customized = .T.
								Case _lttype = 'TRANSACTION' And _optiontype = 'TRAN'
									_customized = .T.
								Case _lttype = 'REPORT' And _optiontype = 'REPORT'
									_customized = .T.
							Endcase


*!*								Messagebox("_lttype = "+_lttype)
*!*								Messagebox("_optiontype = "+_optiontype)
*!*								
*!*								Messagebox("_prodcode : "+_prodcode)
*!*								Messagebox("vchkprod : "+vchkprod)

*!*								Messagebox("mudprodcode : "+mudprodcode)
*!*								MESSAGEBOX("_prodver : "+_prodver)
*!*								
*!*								Messagebox("Upper(GlobalObj.GetPropertyVal('ClientType')) : "+Upper(GlobalObj.GetPropertyVal("ClientType")))
*!*								MESSAGEBOX("Upper(_servicever) : "+Upper(_servicever))
*!*								
*!*								
*!*								Messagebox("_ltpara4a : "+_ltpara4a)
*!*								Messagebox("_optionname : "+_optionname)
*!*								
*!*								
*!*								MESSAGEBOX("Upper(_featuretype) : "+Upper(_featuretype) )

							If _customized = .T. And (_prodcode $ vchkprod Or _prodcode = 'vugen') And mudprodcode == _prodver ;
									AND Upper(GlobalObj.GetPropertyVal("ClientType")) == Upper(_servicever)	;
									AND Upper(_ltpara4a) == Upper(_optionname)
									
*!*									MESSAGEBOX(" Condition passed")
								Do Case
									Case Upper(_featuretype) == 'FREE'
										_menuok	     = ''
										Exit
									Case Upper(_featuretype) == 'PREMIUM'
										_menuok = 'Kindly Subscribe for this option'

										******* Added By Sachin N. S. on 26/05/2011 for TKT-8128 Multi-company ******* Start
										_sacVchkProd = vchkprod
										_sacVchkProd = Strtran(_sacVchkProd,'vuent','')
										_sacVchkProd = Strtran(_sacVchkProd,'vupro','')
										_sacVchkProd = Strtran(_sacVchkProd,'vuinv','')
										_sacVchkProd = Strtran(_sacVchkProd,'vuord','')
										_sacVchkProd = Strtran(_sacVchkProd,'vumcu','')
										_sacVchkProd = Strtran(_sacVchkProd,'vutds','')
										If !Empty(_sacVchkProd)
											******* Added By Sachin N. S. on 26/05/2011 for TKT-8128 Multi-company ******* End

											&&&added by satish pal for bug-14568 dated 14/06/2013 -start
											&&_newoption		= NewEncry(_mregname+'~*0*~'+_macid+'~*1*~'+_featureid+'~*2*~'+Alltrim(company.co_name),_macid)
											_newoption		= NewEncry(_mregname+'~*0*~'+_macid+'~*1*~'+_featureid+'~*2*~'+Alltrim(company.reg_co_name),_macid)
											&&&added by satish pal for bug-14568 dated 14/06/2013 -End
											msqlstr = "select enc from clientfeature"
											_menuretval =sqlconobj.dataconn('EXE',company.dbname,msqlstr,"_dbfmenu","_menunHandle",_ltDatasessionid)
											If _menuretval > 0
												Select _dbfmenu
												Delete From _dbfmenu Where Enc != _newoption
												Scan
													_menuok	     = ''
													Exit
												Endscan
											Endif
										Else		&& Added By Sachin N. S. on 26/05/2011 for TKT-8128 Multi-company ******* Start
											&&&added by satish pal for bug-14568 dated 14/06/2013 -start
											&&	msqlstr = "select distinct co_name from co_mast where UPPER(co_name) NOT LIKE 'UDYOG TESTING' AND COM_TYPE<>'M' and co_name <> ?company.co_name "
											*!*	msqlstr = "select distinct co_name from co_mast where UPPER(co_name) NOT LIKE 'UDYOG TESTING' AND COM_TYPE<>'M' and co_name <> ?company.reg_co_name "
											msqlstr = "select distinct co_name from co_mast where UPPER(co_name) NOT LIKE 'UDYOG TESTING' AND COM_TYPE<>'M' and co_name <> ?company.reg_co_name and Prodcode = ?_varname1 "		&& Changed by Sachin N. S. on 06/12/2016 for GST Vudyog Database Working
											&&&added by satish pal for bug-14568 dated 14/06/2013 -start
											_menuretval =sqlconobj.dataconn('EXE',company.dbname,msqlstr,"_comast_1","_menunHandle",_ltDatasessionid)
											If _menuretval > 0
												msqlstr = "select enc from clientfeature"
												_menuretval =sqlconobj.dataconn('EXE',company.dbname,msqlstr,"_dbfmenu","_menunHandle",_ltDatasessionid)

												Select _comast_1
												Scan
													Select _comast_1
													_newoption	= NewEncry(_mregname+'~*0*~'+_macid+'~*1*~'+_featureid+'~*2*~'+Alltrim(_comast_1.co_name),_macid)
													If _menuretval > 0
														Select _dbfmenu
														Scan
															_menuok	     = ''
															Exit
														Endscan
													Endif
													If Empty(_menuok)
														Exit
													Endif
													Select _comast_1
												Endscan
											Endif
										Endif		&& Added By Sachin N. S. on 26/05/2011 for TKT-8128 Multi-company ******* End

										*Exit		&&Changes has been done by vasant as per TKT-8292 on 04/06/2011
								Endcase
							Endif

							Select dbfmenu
						Endscan
					Endif
				Endif
		Endcase
	Endif

	=sqlconobj.sqlconnclose("_menunHandle")
	Release _menunHandle,_menuretval,usquarepass,mudprodcode
	Release _decdata,_optiontype,_featureid,_subfeatureid,_prodcode,_prodver,_servicever,_featuretype,_optionname,_newoption
	If Used("dbfmenu")
		Use In dbfmenu
	Endif
	If Used("_dbfmenu")
		Use In _dbfmenu
	Endif
	If !Empty(_menuok)
		=Messagebox(_menuok,64,vumess)
		Return .F.
	Endif
Else
	Local sqlconobj,_menuretval,_menuok
	sqlconobj=Newobject('sqlconnudobj',"sqlconnection",xapps)
	_menunHandle = 0
	_menuretval  = 0
	_menuok	     = 'Error'
	Do Case
		Case _lttype = 'MENU'
			msqlstr = "select newrange as EncFld from com_menu"
			msqlstr = msqlstr + " where padname = ?_ltpara1a and barname = ?_ltpara2a"
		Case _lttype = 'TRANSACTION'
			msqlstr = "select cd as EncFld from lcode"
			msqlstr = msqlstr + " where entry_ty = ?_ltpara1a"
		Case _lttype = 'REPORT'
			msqlstr = "select newgroup as EncFld from r_status"
			msqlstr = msqlstr + " where [group] = ?_ltpara1a and [desc] = ?_ltpara2a and rep_nm = ?_ltpara3a"
	Endcase
	_menuretval =sqlconobj.dataconn('EXE',company.dbname,msqlstr,"dbfmenu","_menunHandle",_ltDatasessionid)
	If _menuretval > 0
		Select dbfmenu
		Do Case
			Case Reccount() = 0
				_menuok = 'No Records Found'
			Case Reccount() > 1
				_menuok = 'Multiple Records Found'
			Otherwise
				_menuok = 'No Records Found'
				msqlstr = NewDecry(dbfmenu.EncFld,'Udencyogprod')
				_customized = .F.
				Do Case
					Case _lttype = 'MENU'
						_custcode = Upper(mudprodcode+'<~*0*~>'+_ltpara1a+'<~*1*~>'+_ltpara2a)
						If Upper(Substr(msqlstr,1,Len(_custcode))) == _custcode
							_customized = .T.
						Endif
					Case _lttype = 'TRANSACTION'
						_custcode = Upper(mudprodcode+'<~*0*~>'+_ltpara1a)
						If Upper(Substr(msqlstr,1,Len(_custcode))) == _custcode
							_customized = .T.
						Endif
					Case _lttype = 'REPORT'
						_custcode = Upper(mudprodcode+'<~*0*~>'+_ltpara1a+'<~*1*~>'+_ltpara2a+'<~*2*~>'+_ltpara3a)
						If Upper(Substr(msqlstr,1,Len(_custcode))) == _custcode
							_customized = .T.
						Endif
				Endcase
				If _customized = .T.
					_menuok	     = ''
				Endif
		Endcase
	Endif
	=sqlconobj.sqlconnclose("_menunHandle")
	Release _menunHandle,_menuretval,usquarepass,mudprodcode
	If Used("dbfmenu")
		Use In dbfmenu
	Endif
	If !Empty(_menuok)
		=Messagebox(_menuok,64,vumess)
		Return .F.
	Endif
Endif
Return .T.
&&vasant16/11/2010	Changes done for VU 10 (Standard/Professional/Enterprise)
&&Changes has been done as per TKT-6470 (Multilanguage support - Tested with English & Japanese Language) on 24/02/2011