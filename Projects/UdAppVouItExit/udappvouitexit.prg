***-->Code is used to give 50% accounting effect for Capital Goods in Purchase Entry. &&Rup.
_curvouobj = _Screen.ActiveForm
*!*	If Main_vw.Entry_ty="PT" And [vuexc] $ vchkprod And !Empty(Main_vw.U_RG23CNO)
*!*	If Inlist(main_vw.entry_ty,"PT","P1") And ([vuexc] $ vchkprod Or [vuser] $ vchkprod) And !Empty(main_vw.u_rg23cno) &&Rup 13Sep09 &&vasant081009

&& Commented by Shrikant S. on 29/09/2016 for GST		&& Start
*!*	*!*	If Inlist(main_vw.entry_ty,"PT","P1") And ([vuexc] $ vchkprod Or [vuser] $ vchkprod) And !([vutex] $ vchkprod) And !Empty(main_vw.u_rg23cno) && Changed By Sachin N. S. 21/01/2011 for TKT-5878
*!*	*!*		_mrecno=Reccount()
*!*	*!*		_uet_alias = Alias()
*!*	*!*	*** Added by Shrikant S. on 17/05/2010 for TKT-997 *** Start
*!*	*!*		Local cPer,mAmount,mviewField,mtot_duty,mtot_add,mfieldName,cacname,acname
*!*	*!*		cacname=''
*!*	*!*		acname=''
*!*	*!*		mviewField=''
*!*	*!*		mfieldName=''

*!*	*!*		Store 0 To cPer,mtot_duty,mtot_add,mAmount
*!*	*!*		Select * From dcmast_vw Where Code="E" Order By corder Into Cursor tmpDcmast

*!*	*!*		Select tmpDcmast
*!*	*!*		Index On Alltrim(fld_nm) Tag fld_nm
*!*	*!*		Do While !Eof()
*!*	*!*			acname=Evaluate(tmpDcmast.dac_name)
*!*	*!*	*!*			If !Empty(tmpDcmast.fld_nm)		&& Added By Sachin N. S. on 21/01/2011 for TKT-5878
*!*	*!*			cracname=Evaluate(tmpDcmast.crac_name)
*!*	*!*			If Seek(fld_nm,'tmpDcmast','FLD_NM')
*!*	*!*				mviewField='main_vw.'+fld_nm
*!*	*!*				mfieldName='main_vw.'+tmpDcmast.cfieldName
*!*	*!*				cPer=Evaluate(Evl(cramtexpr,Str(0)))

*!*	*!*	&& Added by Shrikant S. on 13/06/2016 for Bug-28110		&& Start
*!*	*!*				mAmount=0
*!*	*!*				If main_vw.Date >= Ctod("01/04/2016")
*!*	*!*					Select Item_vw
*!*	*!*					lnrecno=Iif(!Eof(),Recno(),0)
*!*	*!*					mitemfld='Item_vw.'+tmpDcmast.fld_nm
*!*	*!*					Select Item_vw
*!*	*!*					Scan
*!*	*!*						cPer=Iif(Item_vw.Rate <=10000,100,50)
*!*	*!*						If tmpDcmast.cRRound_off=.T.
*!*	*!*							mAmount=mAmount+Iif(cPer>=100,&mitemfld ,Floor((&mitemfld * cPer)/100))
*!*	*!*						Else
*!*	*!*							mAmount=mAmount+Iif(cPer>=100,&mitemfld ,Round((&mitemfld * cPer)/100,company.Deci))
*!*	*!*						Endif
*!*	*!*						Select Item_vw
*!*	*!*					Endscan

*!*	*!*					If lnrecno>0
*!*	*!*						Select Item_vw
*!*	*!*						Go lnrecno
*!*	*!*					Endif
*!*	*!*					Select main_vw
*!*	*!*					mAmount=Iif(mAmount <= &mviewField,&mviewField-mAmount,mAmount)
*!*	*!*				Else
*!*	*!*	&& Added by Shrikant S. on 13/06/2016 for Bug-28110		&& End
*!*	*!*	&& Added By Shrikant S. for Bug-13884 on 18/05/2013		&& Start
*!*	*!*					If tmpDcmast.cRRound_off=.T.
*!*	*!*						mAmount=Iif(Iif(cPer!=0,cPer,coadditional.cgoodsper)>=100,&mviewField ,Floor((&mviewField * Iif(cPer!=0,cPer,coadditional.cgoodsper))/100))
*!*	*!*					Else
*!*	*!*						mAmount=Iif(Iif(cPer!=0,cPer,coadditional.cgoodsper)>=100,&mviewField ,Round((&mviewField * Iif(cPer!=0,cPer,coadditional.cgoodsper))/100,company.Deci))
*!*	*!*					Endif
*!*	*!*	&& Added By Shrikant S. for Bug-13884 on 18/05/2013		&& End
*!*	*!*	*!*				mAmount=Iif(Iif(cPer!=0,cPer,coadditional.cgoodsper)>=100,&mviewField ,Floor((&mviewField * Iif(cPer!=0,cPer,coadditional.cgoodsper))/100))		&& Added by Shrikant S. on 29/06/2010 for TKT-2725	&&Commented By Shrikant S. on 18/05/2013 for Bug-13884
*!*	*!*	*!*				mAmount=IIF(Iif(cPer!=0,cPer,coadditional.cgoodsper)>=100,&mviewField ,ROUND((&mviewField * Iif(cPer!=0,cPer,coadditional.cgoodsper))/100,0))	 && Commented by Shrikant S. on 29/06/2010 for TKT-2725
*!*	*!*	*!*				mAmount=Round((&mviewField * Iif(cPer!=0,cPer,coadditional.cgoodsper))/100,0)	&& Commented by Shrikant S. on 01/06/2010
*!*	*!*					mAmount=Iif(mAmount <= &mviewField,&mviewField-mAmount,mAmount)
*!*	*!*				Endif				&& Added by Shrikant S. on 13/06/2016 for Bug-28110

*!*	*!*				mtot_duty=mtot_duty+mAmount
*!*	*!*				Replace &mfieldName With mAmount In main_vw
*!*	*!*				Replace &mviewField With &mviewField-mAmount
*!*	*!*				If _curvouobj.accountpage = .T.
*!*	*!*					Select acdet_vw
*!*	*!*					If Seek(acname,'AcDet_vw','Ac_name')
*!*	*!*						Replace amount With amount - mAmount In acdet_vw
*!*	*!*						_curvouobj.addposting(mAmount ,cracname,'DR')
*!*	*!*						Replace u_cldt With main_vw.u_cldt In acdet_vw && Added by Shrikant S. for TKT-1476
*!*	*!*					Endif
*!*	*!*				Endif
*!*	*!*				Select tmpDcmast
*!*	*!*			Endif
*!*	*!*	*!*			endif
*!*	*!*			If !Eof()
*!*	*!*				Skip
*!*	*!*			Endif
*!*	*!*		Enddo
*!*	*!*		Replace tot_examt With main_vw.tot_examt - mtot_duty,;
*!*	*!*			tot_add With main_vw.tot_add + mtot_duty In main_vw

*!*	*!*		If Used('tmpDcmast')
*!*	*!*			Select tmpDcmast
*!*	*!*			Use
*!*	*!*		Endif
*!*	*!*	*** Added by Shrikant S. on 17/05/2010 for TKT-997 *** End

*!*	*!*	*!*		SELECT main_vw
*!*	*!*	*!*		mexamt = ROUND((main_vw.examt * coadditional.cgoodsper)/100,0)
*!*	*!*	*!*		mcessamt = ROUND((main_vw.u_cessamt * coadditional.cgoodsper)/100,0)
*!*	*!*	*!*		mcvdamt = ROUND((main_vw.u_cvdamt * coadditional.cgoodsper)/100,0)
*!*	*!*	*!*		mhcessamt = ROUND((main_vw.u_hcesamt * coadditional.cgoodsper)/100,0)
*!*	*!*	*!*		mbcdamt = ROUND((main_vw.bcdamt * coadditional.cgoodsper)/100,0)

*!*	*!*	*!*		&&vasant081009
*!*	*!*	*!*		mexamt     = IIF(mexamt > main_vw.examt-mexamt,mexamt,main_vw.examt-mexamt)
*!*	*!*	*!*		mcessamt   = IIF(mcessamt > main_vw.u_cessamt-mcessamt,mcessamt,main_vw.u_cessamt-mcessamt)
*!*	*!*	*!*		mcvdamt    = IIF(mcvdamt > main_vw.u_cvdamt-mcvdamt,mcvdamt,main_vw.u_cvdamt-mcvdamt)
*!*	*!*	*!*		mhcessamt  = IIF(mhcessamt > main_vw.u_hcesamt-mhcessamt,mhcessamt,main_vw.u_hcesamt-mhcessamt)
*!*	*!*	*!*		mbcdamt    = IIF(mbcdamt > main_vw.bcdamt-mbcdamt,mbcdamt,main_vw.bcdamt-mbcdamt)
*!*	*!*	*!*		&&vasant081009

*!*	*!*	*!*		REPLACE u_rg23cpay WITH mexamt,u_rgcespay WITH mcessamt,u_cvdpay WITH mcvdamt,u_hcespay WITH mhcessamt,bcdpay WITH mbcdamt IN main_vw
*!*	*!*	*!*		REPLACE examt WITH examt-mexamt,;
*!*	*!*	*!*			u_cessamt WITH u_cessamt-mcessamt,;
*!*	*!*	*!*			u_cvdamt WITH u_cvdamt-mcvdamt,;
*!*	*!*	*!*			u_hcesamt WITH u_hcesamt-mhcessamt;
*!*	*!*	*!*			bcdamt WITH bcdamt-mbcdamt IN main_vw
*!*	*!*	*!*		REPLACE tot_examt WITH main_vw.tot_examt - (mexamt+mcessamt+mcvdamt+mhcessamt+mbcdamt),;
*!*	*!*	*!*			tot_add WITH main_vw.tot_add + (mexamt+mcessamt+mcvdamt+mhcessamt+mbcdamt) IN main_vw

*!*	*!*	*!*		IF _curvouobj.accountpage = .T.
*!*	*!*	*!*			SELECT acdet_vw
*!*	*!*	*!*			IF SEEK('BALANCE WITH EXCISE RG23C','AcDet_vw','Ac_name')
*!*	*!*	*!*				REPLACE amount WITH amount - mexamt IN acdet_vw
*!*	*!*	*!*				_curvouobj.addposting(mexamt,'EXCISE CAPITAL GOODS PAYABLE A/C','DR')
*!*	*!*	*!*			ENDIF
*!*	*!*	*!*			IF SEEK('BALANCE WITH CESS SURCHARGE RG23C','AcDet_vw','Ac_name')
*!*	*!*	*!*				REPLACE amount WITH amount - mcessamt IN acdet_vw
*!*	*!*	*!*				_curvouobj.addposting(mcessamt,'CESS CAPITAL GOODS PAYABLE A/C','DR')
*!*	*!*	*!*			ENDIF
*!*	*!*	*!*			IF SEEK('BALANCE WITH CVD RG23C','AcDet_vw','Ac_name')
*!*	*!*	*!*				REPLACE amount WITH amount - mcvdamt IN acdet_vw
*!*	*!*	*!*				_curvouobj.addposting(mcvdamt,'CVD CAPITAL GOODS PAYABLE A/C','DR')
*!*	*!*	*!*			ENDIF
*!*	*!*	*!*			IF SEEK('BALANCE WITH HCESS RG23C','AcDet_vw','Ac_name')
*!*	*!*	*!*				REPLACE amount WITH amount - mhcessamt IN acdet_vw
*!*	*!*	*!*				_curvouobj.addposting(mhcessamt,'H CESS CAPITAL GOODS PAYABLE A/C','DR')
*!*	*!*	*!*			ENDIF
*!*	*!*	*!*			IF SEEK('BALANCE WITH BCD RG23C','AcDet_vw','Ac_name')
*!*	*!*	*!*				REPLACE amount WITH amount - mbcdamt IN acdet_vw
*!*	*!*	*!*				_curvouobj.addposting(mbcdamt,'BCD CAPITAL GOODS PAYABLE A/C','DR')
*!*	*!*	*!*			ENDIF
*!*	*!*	*!*		ENDIF

*!*	*!*		If !Empty(_uet_alias)
*!*	*!*			Select (_uet_alias)
*!*	*!*		Endif
*!*	*!*		If Betw(_mrecno,1,Reccount())
*!*	*!*			Go _mrecno
*!*	*!*		Endif

*!*	*!*	Endif
*!*	*!*	***<---Code is used to give 50% accounting effect for Capital Goods in Purchase Entry. &&Rup.
&& Commented by Shrikant S. on 29/09/2016 for GST		&& End


***** Added By Sachin N. S. on 20/12/2010 for New Installer ***** Start
If [vutex] $ vchkprod
	If Type('main_vw.cons_id') = 'N'
		If main_vw.cons_id = 0
			Replace cons_id With main_vw.ac_id In main_vw
		Endif
	Endif
	If Type('main_vw.scons_id') = 'N'
*!*			If main_vw.scons_id = 0		&& Commented By shrikant S. on 301113 for Bug-20574
		If main_vw.scons_id = 0 And main_vw.cons_id=main_vw.ac_id	&& Added By shrikant S. on 301113 for Bug-20574
			Replace scons_id With main_vw.sac_id In main_vw
		Endif
	Endif
Endif
***** Added By Sachin N. S. on 20/12/2010 for New Installer ***** End
&& Added By Shrikant S. on 20/12/2011 for Bug-870	&& Start

*!*	If "vuexc" $ vchkprod  And Inlist(main_vw.entry_ty ,"LR","IL")
If ("vuexc" $ vchkprod  And Inlist(main_vw.entry_ty ,"LR","IL","RE")) Or ("vuinv" $ vchkprod  And Inlist(main_vw.entry_ty ,"RE"))	&& Changed by Sachin N. S. on 02/09/2015 for Bug-26722
	If  _curvouobj.AddMode Or _curvouobj.EditMode
		If !Used('rmdet_Vw')
			Messagebox('Entry cannot be saved without Issue Allocation...',64,vumess)
			Return .F.
		Else
			lexit=.F.
			Select Item_vw
			mrecno=Iif(!Eof(),Recno(),0)
			Go Top
			Select rmdet_Vw
			If Reccount()>0
				Select Item_vw
				Scan
					Select rmdet_Vw
					Go Top
*!*						Count For entry_ty=Item_vw.entry_ty And Tran_cd=Item_vw.Tran_cd And ItSerial=Item_vw.ItSerial To itemcnt		&& Commented by Shrikant S. on 28/03/2018 for Bug-31120
*!*						Count For entry_ty=Item_vw.entry_ty And Tran_cd=Item_vw.Tran_cd And ItSerial=Item_vw.ItSerial And qty_used >0 To itemcnt	&& Added by Shrikant S. on 28/03/2018 for Bug-31120  &&Commented by Priyanka B on 22112018 for Bug-31874
					Count For entry_ty=Item_vw.entry_ty And Tran_cd=Item_vw.Tran_cd And ItSerial=Item_vw.ItSerial And (qty_used+wastage+procwaste) > 0 To itemcnt	&& Added by Shrikant S. on 28/03/2018 for Bug-31120  &&Modified by Priyanka B on 22112018 for Bug-31874
					If itemcnt>0
						itemcnt=0
						Select Item_vw
						Loop
					Else
						lexit=.T.
						Exit
					Endif
				Endscan
			Else
				lexit=.T.
			Endif
			If lexit=.T.
&& Messagebox("Entry cannot be saved without Issue Allocation "+Iif(!Empty(Alltrim(Item_vw.Item))," for "+Alltrim(Item_vw.Item)+" and line item "+Alltrim(Item_vw.item_no),"")+"...",64,vumess) && Commented by Suraj Kumawat date on 27-05-2017 for GST ....
*!*					Messagebox("Entry cannot be saved without Issue Allocation "+Iif(!Empty(Alltrim(Item_vw.Item))," for "+Alltrim(Item_vw.Item)+" and line goods "+Alltrim(Item_vw.item_no),"")+"...",64,vumess) && Added by Suraj Kumawat date on 27-05-2017 for GST  &&Commented by Priyanka B on 22112018 for Bug-31874
				Messagebox("Entry cannot be saved without Issue/Wastage/Process Loss Allocation "+Iif(!Empty(Alltrim(Item_vw.Item))," for "+Alltrim(Item_vw.Item)+" and line goods "+Alltrim(Item_vw.item_no),"")+"...",64,vumess) && Added by Suraj Kumawat date on 27-05-2017 for GST  &&Modified by Priyanka B on 22112018 for Bug-31874
				Select Item_vw
				Return .F.
			Endif

			Select Item_vw
			If mrecno > 0
				Go mrecno
			Endif

		Endif
	Endif
Endif
&& Added By Shrikant S. on 20/12/2011 for Bug-870	&& End

&& Commented by Shrikant S. on 29/09/2016 for GST		&& Start
*!*	*!*	****** Added by Sachin N. S. on 15/01/2014 for Bug-21258 ****** Start
*!*	*!*	If "vuexc" $ vchkprod
*!*	*!*		If Inli(main_vw.entry_ty,'PT','P1') And Alltrim(main_vw.Rule)='MODVATABLE' And Empty(main_vw.U_rg23no) And Empty(main_vw.u_rg23cno)
*!*	*!*			Messagebox("RG23 Part II no. not generated. Cannot continue, please click on Excise button...",64,vumess)
*!*	*!*			Return .F.
*!*	*!*		Endif
*!*	*!*	Endif
*!*	*!*	****** Added by Sachin N. S. on 15/01/2014 for Bug-21258 ****** End
&& Commented by Shrikant S. on 29/09/2016 for GST		&& End

****** Added by Sachin N. S. on 15/01/2014 for Bug-21375 ****** Start
If Used('OTHITREF_VW')
	If Inli(main_vw.entry_ty,'IP')
		ItemList=""
		Select OTHITREF_VW
		Set Filter To
		=Tableupdate(.T.)

&& Added by Suraj Kumawat for Bug-30914 date on 29-11-2017	 start
		Select inter_use From lother_vw Where Alltrim(Upper(inter_use))== '.T.' And att_file == .F. And Alltrim(Upper(fld_nm))=='U_FORPICK' Into Cursor CurChkpickup
		Select CurChkpickup
		If !Eof()
			Return .T.
		Endif
&& Added by Suraj Kumawat for Bug-30914 date on 29-11-2017	 End

		Select Item_vw
		nrecno=Iif(!Eof(),Recno(),0)
		Scan
			Select Item_vw
&& aDDED bY PANKAJ B. ON 14-03-2015 FOR bUG-25365 START
			curObj = _Screen.ActiveForm
			lcStr = "Select type From it_mast where it_code= ?Item_vw.it_code"
			nretval = curObj.sqlconobj.dataconn("EXE",company.dbname,lcStr,"ITmastRAW_vw","curObj.nhandle",curObj.DataSessionId)
			If nretval < 0
				Return .F.
			Endif
			nretval=curObj.sqlconobj.sqlconnclose("curObj.nHandle")
&& aDDED bY PANKAJ B. ON 14-03-2015 FOR bUG-25365 END
			If !Inlist(Upper(ITmastRAW_vw.Type),"FINISHED","SEMI FINISHED") && aDDED bY PANKAJ B. ON 14-03-2015 FOR bUG-25365
				Select Sum(Iif(Isnull(rqty),0,rqty)) As qty From OTHITREF_VW Where entry_ty=Item_vw.entry_ty And Tran_cd=Item_vw.Tran_cd And ItSerial=Item_vw.ItSerial Into Cursor tibl
				If Item_vw.qty!=tibl.qty Or (Item_vw.qty>0 And Isnull(tibl.qty)) Or Reccount('tibl')=0
					ItemList = ItemList + Iif(!Empty(ItemList),Chr(13),'') + Padr(Alltrim(Item_vw.item_no),10,' ') + Alltrim(Item_vw.Item)
				Endif
			Endif  && aDDED bY PANKAJ B. ON 14-03-2015 FOR bUG-25365
			Select Item_vw
		Endscan
		Select Item_vw
		If nrecno!=0
			Go nrecno
		Endif
		If !Empty(ItemList)
&&Commented for Bug-26269 on 03/07/2015 Start..
*!*				=Messagebox("Quantity of some Items are not matching with the pickup quantity."+Chr(13);
*!*				+Padr("Line #",10,' ')+"Item Name"+Chr(13)+ItemList,0+64,vumess)
*!*				Return .F.
*!*			Else
*!*				Return .T.
&&Commented for Bug-26269 on 03/07/2015 End..

&&Added By Kishor A. for Bug-26269 on 03/07/2015 Start..
&& nAnswer	=Messagebox("Quantity of some Items are not matching with the pickup quantity."+Chr(13)+Chr(13)+Padr("Line #",10,' ')+"Item Name"; Commented by Suraj Kumawat date on 27-05-2017  for GST
			nAnswer	=Messagebox("Quantity of some goods are not matching with the pickup quantity."+Chr(13)+Chr(13)+Padr("Line #",10,' ')+"Item Name"; && Added  by Suraj Kumawat date on 27-05-2017  for GST
			+Chr(13)+ItemList+Chr(13)+Chr(13)+Padr('',2,' ')+"Do you want to continue without pickup?",4+32+256,'Name')

			Do Case
				Case nAnswer = 6
					Return .T.
				Case nAnswer = 7
					Return .F.
			Endcase
&&Added By Kishor A. for Bug-26269 on 03/07/2015 End..
		Endif
	Endif
&& Added by Shrikant S. on 12/08/2015 for Bug-26554		&& Start
Else
	If Inli(main_vw.entry_ty,'IP')		&& Added by Sachin N. S. on 03/09/2015 for Bug-26722
&& Added by Suraj Kumawat for Bug-30914 date on 29-11-2017	 start
		Select inter_use From lother_vw Where Alltrim(Upper(inter_use))== '.T.' And att_file == .F. And Alltrim(Upper(fld_nm))=='U_FORPICK' Into Cursor CurChkpickup
		Select CurChkpickup
		If !Eof()
			Return .T.
		Endif
&& Added by Suraj Kumawat for Bug-30914 date on 29-11-2017	 End

		ItemList=""
		Select Item_vw
		nrecno=Iif(!Eof(),Recno(),0)
		Scan
			curObj = _Screen.ActiveForm
			lcStr = "Select type From it_mast where it_code= ?Item_vw.it_code"
			nretval = curObj.sqlconobj.dataconn("EXE",company.dbname,lcStr,"ITmastRAW_vw","curObj.nhandle",curObj.DataSessionId)
			If nretval < 0
				Return .F.
			Endif
			nretval=curObj.sqlconobj.sqlconnclose("curObj.nHandle")
			If !Inlist(Upper(ITmastRAW_vw.Type),"FINISHED","SEMI FINISHED")
				ItemList = ItemList + Iif(!Empty(ItemList),Chr(13),'') + Padr(Alltrim(Item_vw.item_no),10,' ') + Alltrim(Item_vw.Item)
			Endif

			Select Item_vw
		Endscan
		Select Item_vw
		If nrecno!=0
			Go nrecno
		Endif
		If !Empty(ItemList)
&& nAnswer	=Messagebox("Quantity of some Items are not matching with the pickup quantity."+Chr(13)+Chr(13)+Padr("Line #",10,' ')+"Item Name"; && Commented by Suraj Kumawat for GST Date on 27-05-2017
			nAnswer	=Messagebox("Quantity of some goods are not matching with the pickup quantity."+Chr(13)+Chr(13)+Padr("Line #",10,' ')+"Goods Name"; && Added by Suraj Kumawat for GST Date on 27-056-2017
			+Chr(13)+ItemList+Chr(13)+Chr(13)+Padr('',2,' ')+"Do you want to continue without pickup?",4+32+256,'Name')

			Do Case
				Case nAnswer = 6
					Return .T.
				Case nAnswer = 7
					Return .F.
			Endcase
		Endif
&& Added by Shrikant S. on 12/08/2015 for Bug-26554		&& End
	Endif		&& Added by Sachin N. S. on 03/09/2015 for Bug-26722
Endif
****** Added by Sachin N. S. on 15/01/2014 for Bug-21375 ****** End

*!*	&& Added by Shrikant S. on 19/09/2018 for Installer ENT 2.0.0		&& Start
*!*	If Inli(main_vw.entry_ty,'ST','DC')
*!*		If Type('Item_vw.batchno')='C' And oGlblPrdFeat.UdChkProd('exmfgbp') And checkbatchExp()=.T.
*!*			ItemList=""
*!*			Select Item_vw
*!*			nrecno=Iif(!Eof(),Recno(),0)
*!*			Scan
*!*				curObj = _Screen.ActiveForm
*!*				lcStr = "Select type From it_mast where it_code= ?Item_vw.it_code"
*!*				nretval = curObj.sqlconobj.dataconn("EXE",company.dbname,lcStr,"ITmastRAW_vw","curObj.nhandle",curObj.DataSessionId)
*!*				If nretval < 0
*!*					Return .F.
*!*				Endif
*!*				nretval=curObj.sqlconobj.sqlconnclose("curObj.nHandle")
*!*	*!*				If !Inlist(Upper(ITmastRAW_vw.Type),"FINISHED","SEMI FINISHED")
*!*					ItemList = ItemList + Iif(!Empty(ItemList),Chr(13),'') + Padr(Alltrim(Item_vw.item_no),10,' ') + Alltrim(Item_vw.Item)
*!*				Endif

*!*				Select Item_vw
*!*			Endscan
*!*			Select Item_vw
*!*			If nrecno!=0
*!*				Go nrecno
*!*			ENDIF
*!*			If !Empty(ItemList)
*!*				nAnswer	=Messagebox("Quantity of some goods are not matching with the pickup quantity."+Chr(13)+Chr(13)+Padr("Line #",10,' ')+"Goods Name"; && Added by Suraj Kumawat for GST Date on 27-056-2017
*!*				+Chr(13)+ItemList+Chr(13)+Chr(13)+Padr('',2,' ')+"Do you want to continue without pickup?",4+32+256,'Name')

*!*				Do Case
*!*				Case nAnswer = 6
*!*					Return .T.
*!*				Case nAnswer = 7
*!*					Return .F.
*!*				ENDCASE
*!*			Endif
*!*		Endif
*!*	Endif
*!*	&& Added by Shrikant S. on 19/09/2018 for Installer ENT 2.0.0		&& End


******* Added by Sachin N. S. on 03/09/2015 for Bug-26722 -- Start
If ("vuexc" $ vchkprod  And Inlist(main_vw.entry_ty ,"RE")) Or ("vuinv" $ vchkprod  And Inlist(main_vw.entry_ty ,"RE"))	&& Changed by Sachin N. S. on 02/09/2015 for Bug-26722
	If  _curvouobj.AddMode Or _curvouobj.EditMode
		If Used('rmdet_Vw')
			Select a.ItSerial,a.item_no,a.Item,a.qty,Sum(Iif(Isnull(b.qty_used),0,b.qty_used)) As qty From Item_vw a ;
				INNER Join rmdet_Vw b On a.entry_ty=b.entry_ty And a.Tran_cd=b.Tran_cd And a.ItSerial=b.ItSerial ;
				GROUP By a.ItSerial,a.item_no,a.Item,a.qty Having (a.qty!=Sum(Iif(Isnull(b.qty_used),0,b.qty_used)));
				Into Cursor tibl
			If _Tally>0
				cItemLine=""
				Select tibl
				Scan
					Select tibl
					cItemLine = cItemLine + Iif(!Empty(cItemLine),Chr(13),'') + Padr(Alltrim(tibl.item_no),3,' ') + "-" + Alltrim(tibl.Item)
					Select tibl
				Endscan
				If !Empty(cItemLine)
&& Messagebox("The following Item quantity are not matching with the allocated quantity."+Chr(13)+cItemLine,0+16,vumess) && Commented by Suraj Kumawat Date on 27-05-2017 for GST
					Messagebox("The following Goods quantity are not matching with the allocated quantity."+Chr(13)+cItemLine,0+16,vumess) && Added by Suraj Kumawat Date on 27-05-2017 for GST
					Return .F.
				Endif
			Endif
		Endif
	Endif
Endif
******* Added by Sachin N. S. on 03/09/2015 for Bug-26722 -- End

***** Added by Sachin N. S. on 02/11/2017 for Bug-30782 -- Start
If oGlblPrdFeat.UdChkProd('vugst')
	If _curvouobj.EditMode=.T.
		cdAmendDt = Iif(Type('Main_vw.AmendDate')='T','Main_vw.AmendDate',Iif(Type('Lmc_vw.AmendDate')='T','Lmc_vw.AmendDate',Iif(Type('MainAdd_vw.AmendDate')='T','MainAdd_vw.AmendDate','')))
		If !Empty(cdAmendDt)
			If Empty(Evaluate(cdAmendDt)) Or Ttod(Evaluate(cdAmendDt))=Ctod('01/01/1900')
				If !(Year(Date())==Year(main_vw.Date) And Month(Date())=Month(main_vw.Date))		&& Added by Shrikant S. on 21/08/2018 for Installer 2.0.0
					If Messagebox("Do you want to Amend the Records?"+Chr(13)+"If 'Yes' then enter amend date and original record will stored"+Chr(13)+Replicate(" ",5)+"else"+Chr(13)+"'No' to continue saving without amendment date and no original record will be stored.",4+32,vumess) = 6
						Return .F.
					Endif
				Endi																			&& Added by Shrikant S. on 21/08/2018 for Installer 2.0.0
			Else
				If Month(Ttod(main_vw.Date)) >= Month(Ttod(Evaluate(cdAmendDt))) And Year(Ttod(main_vw.Date)) >= Year(Ttod(Evaluate(cdAmendDt)))
					Messagebox("Amendment date month should be greater than the Invoice date month.",0+64,vumess)
					Return .F.
				Else
					If Ttod(main_vw.Date)+180 < Ttod(Evaluate(cdAmendDt))
						Messagebox("Amendment date cannot be more than 180 days from the Invoice Date.",0+64,vumess)
						Return .F.
					Else
						If Messagebox("You are going to Amend the record. Once amended the invoice cannot be changed."+Chr(13)+;
								"Do you want to continue with Amendment?",4+32,vumess) = 7
							Return .F.
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif
Endif
***** Added by Sachin N. S. on 02/11/2017 for Bug-30782 -- End

&& Added by Shrikant S. on 01/06/2018 for Bug-31591		&& Start

If Type('Main_vw.Entry_ty')<>'U' And Type('main_vw.ewbqrcode')<>'U'
	If Inlist(main_vw.entry_ty,"ST","PT","AR","DC","LI","IL","LR","RL","P1","EI")
		_lcPath=Set("Procedure")
		_bcval=Iif(Type('lmc_vw.ewbn')<>'U',lmc_vw.ewbn,main_vw.ewbn)

		If !Empty(_bcval)
			If !Empty(company.gstin)
				ldateformat=Set("Date")
				ltimeformat=Set("Hours")
				Set Date Mdy
				Set Hours To 12
				lcdateval=Iif(Type('lmc_vw.EWBVFD')<>'U',Dtoc(lmc_vw.EWBVFD),Dtoc(main_vw.EWBVFD))
				lctimeval=Iif(Type('lmc_vw.EWBVFT')<>'U',Alltrim(lmc_vw.EWBVFT),Alltrim(main_vw.EWBVFT))
				_bcval=Alltrim(_bcval)+"/"+Alltrim(company.gstin)+"/"+Transform(Ctot(lcdateval+" "+lctimeval))
				If !Empty(ldateformat)
					Set Date &ldateformat
				Endif
				If !Empty(ltimeformat)
					Set Hours To &ltimeformat
				Endif
			Endif
			Set Procedure To vu_udfs In &xapps AddIt
			_mbcval=Func_QRCode(_bcval)

			Select main_vw
			Append General ewbqrcode From (_mbcval) Class Paint.Picture
			If File(_mbcval)
				Delete File (_mbcval)
			Endif
			If !Empty(_lcPath)
				Set Procedure To &_lcPath
			Endif
		Endif
	Endif
Endif
&& Added by Shrikant S. on 01/06/2018 for Bug-31591		&& End

&& Commented by Shrikant S. on 12/08/2015 for Bug-26554		&& Start
*!*	***** Added by Kishor A. on 09/06/2015 for Bug 26269 ****Start
*!*	If Inli(main_vw.entry_ty,'IP') AND _curvouobj.AddMode
*!*		ItemList=""

*!*		Ktmp_Vw=""
*!*		Ksql_str  = "select * from othitref a inner join ipitem b on (a.entry_ty=b.entry_ty and a.tran_cd = b.tran_cd and a.itserial=b.itserial) where a.Tran_cd = ?Main_vw.Tran_cd And a.Entry_ty = ?Main_vw.Entry_ty"
*!*		Ksql_con  = _curvouobj.sqlconobj.dataconn([EXE],company.dbname,Ksql_str,[Ktmp_Vw],;
*!*		"_curvouobj.nHandle",_curvouobj.DataSessionId,.T.)
*!*
*!*		SELECT * FROM item_vw a where a.Tran_cd = ?Main_vw.Tran_cd And a.Entry_ty = ?Main_vw.Entry_ty INTO CURSOR ktmp

*!*		SELECT ktmp
*!*		SCAN
*!*			IF ktmp.qty>0 AND Ktmp_Vw.Rqty<=0
*!*				   ItemList = ItemList + Iif(!Empty(ItemList),Chr(13),'') + Padr(Alltrim(ktmp.item_no),10,' ') + Alltrim(ktmp.Item)
*!*		    ENDIF
*!*		ENDSCAN
*!*
*!*			If !Empty(ItemList)
*!*				=Messagebox("Quantity of some Items are not matching with the pickup quantity."+Chr(13);
*!*					+Padr("Line #",10,' ')+"Item Name"+Chr(13)+ItemList,0+64,vumess)
*!*				Return .F.
*!*			Else
*!*				Return .T.
*!*			ENDIF
*!*	ENDIF
*!*	***** Added by Kishor A. on 09/06/2015 for Bug 26269 ****End
&& Commented by Shrikant S. on 12/08/2015 for Bug-26554		&& End
