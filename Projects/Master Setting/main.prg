Lparameters nrange
****Versioning**** && Added By Amrendra for TKT 8121 on 13-06-2011
	LOCAL _VerValidErr,_VerRetVal,_CurrVerVal
	_VerValidErr = ""
	_VerRetVal  = 'NO'
	_CurrVerVal='10.0.0.0' &&[VERSIONNUMBER]
	TRY
		_VerRetVal = AppVerChk('MASTSET',_CurrVerVal,JUSTFNAME(SYS(16)))
	CATCH TO _VerValidErr
		_VerRetVal  = 'NO'
	Endtry	
	IF TYPE("_VerRetVal")="L"
		cMsgStr="Version Error occured!"
		cMsgStr=cMsgStr+CHR(13)+"Kindly update latest version of "+GlobalObj.getPropertyval("ProductTitle")
		Messagebox(cMsgStr,64,VuMess)
		Return .F.
	ENDIF
	IF _VerRetVal  = 'NO'
		Return .F.
	Endif
****Versioning****

If Vartype(VuMess) <> [C]
	_Screen.Visible = .F.
	Messagebox("Internal Application Are Not Execute Out-Side ...",16)
	Return .F.
Endif

Do Form vouwiz With nrange