���    { /z �                     �K    %           �      {   Nc5A    �/  ��  � �! � frmTDSAcknowledge��  � � U  FORMNO PRANGE FRMTDSACKNOWLEDGE� @:                 0
   m                   PLATFORM   C                  UNIQUEID   C	   
               TIMESTAMP  N   
               CLASS      M                  CLASSLOC   M!                  BASECLASS  M%                  OBJNAME    M)                  PARENT     M-                  PROPERTIES M1                  PROTECTED  M5                  METHODS    M9                  OBJCODE    M=                 OLE        MA                  OLE2       ME                  RESERVED1  MI                  RESERVED2  MM                  RESERVED3  MQ                  RESERVED4  MU                  RESERVED5  MY                  RESERVED6  M]                  RESERVED7  Ma                  RESERVED8  Me                  USER       Mi                                                                                                                                                                                                                                                                                          COMMENT Screen                                                                                              WINDOWS _2FU0PTV9R 957244355      /  F      ]                          �      �                       WINDOWS _2FU0PTV9S1094811849�  �          2        Y"                  �8                           WINDOWS _2FU0PTV9T 957179237 9      9  9  (9  =9                                                           WINDOWS _2FU0PTV9U 957253974�9      �9  �9  �9  :                                                           WINDOWS _2FU0PTV9V 957253974�:      �:  �:  �:  �:                                                           WINDOWS _2FU0PTV9W 957253974k;      x;  �;  �;  �;                                                           WINDOWS _2FU0PTV9X 957253974><      K<  X<  f<  {<                                                           WINDOWS _2FU0PTV9Y1094811467=      "=  1=  >=  S=      �=  �@                                               WINDOWS _2FU0PTVA11094811467�A      �A  �A  �A  �A      AB  KE                                               WINDOWS _2FU0PTVA21094811467�E      F  F  (F  =F      �F  �I                                               WINDOWS _2FU0PTVA31094811467rJ      �J  �J  �J  �J      ,K  6N                                               WINDOWS _2FU0PTVA4 957253928�N      �N  O  O  %O                                                           WINDOWS _2FU0PTVA5 957253928�O      �O  �O  P  P                                                           WINDOWS _2FU0PTVAB 957253989�P      �P  Q  Q  $Q                                                           COMMENT RESERVED                                �Q                                                            R                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 VERSION =   3.00      dataenvironment      dataenvironment      Dataenvironment      _Top = 220
Left = 1
Width = 520
Height = 200
DataSource = .NULL.
Name = "Dataenvironment"
      1      2      basefrm      $..\..\vudyogsdk\class\standardui.vcx      form      UEFRM_TDSACKN      �Height = 162
Width = 342
DoCreate = .T.
BorderStyle = 2
Caption = "Tds Acknowledgement"
MaxButton = .F.
WindowState = 0
notrefresh = .F.
pformno = .F.
pcurryear = 
pcquarter = 
Name = "UEFRM_TDSACKN"
     CPROCEDURE Unload
=Barstat(.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.)
ENDPROC
PROCEDURE QueryUnload
if thisform.editmode
	res = messagebox('Do you want to save changes first?',3+64,vumess)
	if res = 6
		thisform.saveit
	endif
	if res = 2
		nodefault
		return .f.
	endif
endif
if TbrDesktop.restore()
	nodefault					&& Cancel Exiting ....
	return .f.
endif
ENDPROC
PROCEDURE modify
with thisform
	tbrdesktop.flag=.t.
	.notrefresh = .t.
	=barstat(.f.,.f.,.f.,.f.,.f.,.f.,.t.,.t.,.f.,.f.,.f.,.f.,.t.,.t.)
	.addmode = .f.
	.editmode =.t.
	.act_deact(.t.)
	.lockscreen = .t.
	.refresh()
	.lockscreen = .f.
	tbrdesktop.flag=.f.
	.text1.setfocus
endwith
ENDPROC
PROCEDURE cancel
*!*	if cursorgetprop('Buffering','_tdsacknow') = 5
*!*		select _tdsacknow
*!*		=tablerevert(.t.)
*!*	endif
with thisform
	.act_deact(.f.)
	.addmode  = .f.
	.editmode = .f.
	=barstat(.f.,.f.,.f.,.f.,.f.,.f.,.f.,.t.,.f.,.f.,.f.,.f.,.t.,.t.)
	.notrefresh = .f.
	.refresh()
*!*		TbrDesktop.visible = .t.
*!*		TbrDesktop.enabled = .t.
*!*		TbrDesktop.refresh()
ENDWITH

ENDPROC
PROCEDURE addnew
return

ENDPROC
PROCEDURE Activate
with thisform
	if type("TbrDesktop") = "O"
		TbrDesktop.visible = .t.
		TbrDesktop.enabled = .t.
		TbrDesktop.refresh()
		if !.addmode and !.editmode
			=barstat(.f.,.f.,.f.,.f.,.f.,.f.,.f.,thisform.editbutton,.f.,.f.,.f.,.f.,.t.,.t.)
		else
			=barstat(.f.,.f.,.f.,.f.,.f.,.f.,.t.,.t.,.f.,.f.,.f.,.f.,.t.,.t.)
			TbrDesktop.refresh()
		endif
	endif
endwith
ENDPROC
PROCEDURE Init
Parameters vFormNo,pRange &&Rup add vFormNo
vFormNo=RTRIM(vFormNo)
lrange=pRange
Set NullDisplay To ""
&&PUBLIC curryear,cquarter Rup New Property pCurrYear,pCQuarter 

With Thisform
	.Caption="TDS Form "+vFormNo +" Acknowledgement Details"
	.platform = mVu_Backend
	.pFormNo=vFormNo &&Rup
	.addmode = .F.
	.editmode = .F.
	.Mainalias= "TdsAcknow_vw"
	.Maintbl="TdsAcknow"
	.Mainfld="Acknow_no"
	.MainCond = .F.
	.nHandle=0
	.notrefresh = .f.
	.Createstdobjects()
	.co_dtbase=company.dbname

	.sqlconobj.assignedrights(lrange,.DataSessionId)
	.pCurrYear = RIGHT(STR(YEAR(company.sta_dt)),4)+'-'+RIGHT(STR(YEAR(company.end_dt)),4)
	If Val(company.vcolor) <> 0 And Iscolor() = .T.
		.BackColor=Val(company.vcolor)
		.setall('backcolor',val(company.vcolor),'SHAPE' )
		.setall('backcolor',val(company.vcolor),'commandbutton')
		.setall('disabledbackcolor',val(company.vcolor),'commandbutton')
	Endif

	thisform.label7.Caption=thisform.pCurrYear

	Local _TdsAcknow,TdsAckString

	&&&Loading Table TdsAcknow as _TdsAcknow
	TdsAckString="Select name from sysobjects where xtype = 'U' and name = 'TdsAcknow'"
	mRet=Thisform.sqlconobj.Dataconn("EXE",company.dbname,TdsAckString,"_TdsAcknow","thisform.nHandle",Thisform.DataSessionId)
	If mRet > 0
		Select _tdsacknow
		If Reccount() # 0
*!*				TdsAckString="Select l_yn,quarter,acknow_no from TdsAcknow where l_yn = ?ThisForm.pCurrYear order by quarter " &&Rup
			TdsAckString="Select l_yn,quarter,acknow_no,FormNo from TdsAcknow where FormNo=?vFormNo and l_yn = ?ThisForm.pCurrYear order by quarter "
			mRet=Thisform.sqlconobj.Dataconn("EXE",company.dbname,TdsAckString,"_TdsAcknow","thisform.nHandle",Thisform.DataSessionId)
			If mRet > 0
				Sele _TdsAcknow
			ENDIF
		ELSE	&&&Creating Table TdsAcknow if not Present
*!*				TdsAckString="Create Table TdsAcknow (L_yn VarChar (9), Quarter VarChar(1), Acknow_no VarChar(50))" &&Rup
			TdsAckString="Create Table TdsAcknow (L_yn VarChar (9), Quarter VarChar(1), Acknow_no VarChar(50),FormNo Varchar(10))"
			mRet=Thisform.sqlconobj.Dataconn("EXE",company.dbname,TdsAckString,"","thisform.nHandle",Thisform.DataSessionId)
			If mRet > 0		&&&Loading Table TdsAcknow as _TdsAcknow
*!*					TdsAckString="Select l_yn,quarter,acknow_no from TdsAcknow where l_yn = ?ThisForm.pCurrYear order by quarter " &&Rup
				TdsAckString="Select l_yn,quarter,acknow_no,FormNo from TdsAcknow where FormNo=?vFormNo and l_yn = ?ThisForm.pCurrYear order by quarter "
				mRet=Thisform.sqlconobj.Dataconn("EXE",company.dbname,TdsAckString,"_TdsAcknow","thisform.nHandle",Thisform.DataSessionId)
				If mRet > 0
					Sele _TdsAcknow
				endif
			ELSE
				RETURN .f.
			ENDIF
		ENDIF
	ELSE
		RETURN .f.
	endif
	mRet=Thisform.sqlconobj.sqlconnclose("thisform.nHandle")
	If mRet <= 0
		Return .F.
	Endif

	SELECT _TdsAcknow
	GO top
	SCAN WHILE !EOF()
		DO case
			CASE _TdsAcknow.quarter = '1'
		thisform.text1.Value = _TdsAcknow.acknow_no
			CASE _TdsAcknow.quarter = '2'
		thisform.text2.Value = _TdsAcknow.acknow_no
			CASE _tdsacknow.quarter = '3'
		thisform.text3.Value = _TdsAcknow.acknow_no
			CASE _Tdsacknow.quarter = '4'
		thisform.text4.Value = _tdsAcknow.acknow_no
		endcase
		SELECT _tdsacknow
	ENDSCAN
	.Refresh()
	.act_deact(.f.)
	tbrdesktop.flag=.t.
	.lockscreen = .t.
	.refresh
	.lockscreen = .f.
Endwith
ENDPROC
PROCEDURE act_deact
parameters mflag
with thisform
	.setall('enabled',mflag,'Checkbox' )
	.setall('enabled',mflag,'textbox' )
	.setall('enabled',mflag,'commandbutton')
endwith
ENDPROC
PROCEDURE saveit
Local _tdsacknow,lcstr
****Item Type updation if not in master

FOR n = 1 TO 4

	ThisForm.pCQuarter = ALLTRIM(STR(n))
	cacknowno = IIF(n=1,thisform.text1.Value,IIF(n=2,thisform.text2.Value,IIF(n=3,thisform.text3.Value,thisform.text4.Value)))
*!*		lcStr="select acknow_no from tdsacknow where quarter = ?ThisForm.pCQuarter and l_yn= ?ThisForm.pCurrYear" &&Rup
	lcStr="select acknow_no from tdsacknow where FormNo=?thisform.pFormNo and quarter = ?ThisForm.pCQuarter and l_yn= ?ThisForm.pCurrYear"
	nretval = Thisform.sqlconobj.dataconn([EXE],company.dbname,lcStr,"_tdsacknow","This.Parent.nHandle",Thisform.DataSessionId)
	If nretval<=0
		Return .F.
	ENDIF
	Select _tdsacknow
	If Reccount() # 0 
*!*			IF !EMPTY(cacknowno) && Commented Add Blank Records Of Quarter, if any &&&&Hetal Dt 12/08/08
*!*				lcStr	= " Update tdsacknow set acknow_no = ?cacknowno Where quarter = ?ThisForm.pCQuarter and l_yn= ?ThisForm.pCurrYear" &&Rup
			lcStr	= " Update tdsacknow set acknow_no = ?cacknowno Where FormNo=?thisform.pFormNo and quarter = ?ThisForm.pCQuarter and l_yn= ?ThisForm.pCurrYear"
			nretval = Thisform.sqlconobj.dataconn([EXE],company.dbname,lcStr,"_tdsacknow","This.Parent.nHandle",Thisform.DataSessionId)
			If nretval<=0
				Return .F.
			ENDIF
*!*			ELSE
*!*				lcStr	= " Delete from tdsacknow Where quarter = ?ThisForm.pCQuarter and l_yn= ?ThisForm.pCurrYear"
*!*				nretval = Thisform.sqlconobj.dataconn([EXE],company.dbname,lcStr,"_tdsacknow","This.Parent.nHandle",Thisform.DataSessionId)
*!*				If nretval<=0
*!*					Return .F.
*!*				ENDIF
*!*			endif
	ELSE
		IF !EMPTY(cacknowno)
*!*				lcStr	= " Insert into tdsacknow (quarter,acknow_no,l_yn) Values(?cquarter,?cacknowno,?ThisForm.pCurrYear)" &&Rup
			lcStr	= " Insert into tdsacknow (quarter,acknow_no,l_yn,FormNo) Values(?ThisForm.pcquarter,?cacknowno,?ThisForm.pCurrYear,?thisform.pFormNo)"
			nretval = Thisform.sqlconobj.dataconn([EXE],company.dbname,lcStr,"Mtypemas","This.Parent.nHandle",Thisform.DataSessionId)
			If nretval<=0
				Return .F.
			ENDIF
		endif
	ENDIF
next
WITH thisform

	.act_deact(.F.)
	.addmode  = .F.
	.editmode = .F.
	.notrefresh = .f.
*!*		Select _tdsacknow
*!*		If CursorGetProp("Buffering",'_tdsacknow')=5
*!*			=Tableupdate(.T.)
*!*		Endif
	=barstat(.F.,.F.,.F.,.F.,.F.,.F.,.F.,.T.,.F.,.F.,.F.,.F.,.T.,.T.)
ENDWITH
mRet=Thisform.sqlconobj.sqlconnclose("thisform.nHandle")
If mRet <= 0
	Return .F.
ENDIF
*!*	MESSAGEBOX('Record Saved',0+64,'Udyog I-Tax',020)
MESSAGEBOX('Record Saved',0+64,vumess,020)
*!*	thisform.Release

ENDPROC
     l���    S  S                        ��	   %   �      �  �             �  U    ��C--------------�  �� U  BARSTAT�  %��  � ��� �8 T� �C�" Do you want to save changes first?�C� �x�� %�� ���c �
 ��  � � � %�� ���� � �� B�-�� � � %�C� � ��� � �� B�-�� � U  THISFORM EDITMODE RES VUMESS SAVEIT
 TBRDESKTOP RESTORE�  ���  ��� � T� � �a�� T�� �a�� ��C------aa----aa� �� T�� �-�� T�� �a�� ��Ca�� �� T�� �a�� ��C��	 �� T�� �-�� T� � �-�� ���
 � � �� U  THISFORM
 TBRDESKTOP FLAG
 NOTREFRESH BARSTAT ADDMODE EDITMODE	 ACT_DEACT
 LOCKSCREEN REFRESH TEXT1 SETFOCUSg  ���  ��` � ��C-�� �� T�� �-�� T�� �-�� ��C-------a----aa� �� T�� �-�� ��C�� �� �� U  THISFORM	 ACT_DEACT ADDMODE EDITMODE BARSTAT
 NOTREFRESH REFRESH  B� U  �  ���  ��� � %�C�
 TbrDesktopb� O��� � T� � �a�� T� � �a�� ��C� � �� %��� 
� �� 
	��� � ��C-------�  � ----aa� �� �� � ��C------aa----aa� �� ��C� � �� � � �� U	  THISFORM
 TBRDESKTOP VISIBLE ENABLED REFRESH ADDMODE EDITMODE BARSTAT
 EDITBUTTONa 4�  � � T�  �C�  V�� T� �� �� G�(��  �� ��� ��Z�7 T�� ��	 TDS Form �  �  Acknowledgement Details�� T�� �� �� T�� ��  �� T�� �-�� T��	 �-�� T��
 �� TdsAcknow_vw�� T�� ��	 TdsAcknow�� T�� ��	 Acknow_no�� T�� �-�� T�� �� �� T�� �-�� ��C�� �� T�� �� � �� ��C � �� �� � ��/ T�� �CCC� � iZ�R� -CCC� � iZ�R�� %�C� � g� � C:a	��7� T�� �C� � g��' ��C�	 backcolorC� � g� SHAPE�� ��/ ��C�	 backcolorC� � g� commandbutton�� ��7 ��C� disabledbackcolorC� � g� commandbutton�� �� � T� � � �� � �� �� � �Q T� ��D Select name from sysobjects where xtype = 'U' and name = 'TdsAcknow'��J T�  �C� EXE� �  � �
 _TdsAcknow� thisform.nHandle� � � � �! �� %��  � ���� F� � %�CN� ���� T� ��z Select l_yn,quarter,acknow_no,FormNo from TdsAcknow where FormNo=?vFormNo and l_yn = ?ThisForm.pCurrYear order by quarter ��J T�  �C� EXE� �  � �
 _TdsAcknow� thisform.nHandle� � � � �! �� %��  � ��� F� � � ���t T� ��g Create Table TdsAcknow (L_yn VarChar (9), Quarter VarChar(1), Acknow_no VarChar(50),FormNo Varchar(10))��@ T�  �C� EXE� �  � �  � thisform.nHandle� � � � �! �� %��  � ����� T� ��z Select l_yn,quarter,acknow_no,FormNo from TdsAcknow where FormNo=?vFormNo and l_yn = ?ThisForm.pCurrYear order by quarter ��J T�  �C� EXE� �  � �
 _TdsAcknow� thisform.nHandle� � � � �! �� %��  � ���� F� � � ��� B�-�� � � ��� B�-�� �' T�  �C� thisform.nHandle� � �" �� %��  � ��/� B�-�� � F� � #)� ~+�C+
��� H�Z�� �� �# � 1���� T� �$ �% �� �& �� �� �# � 2���� T� �' �% �� �& �� �� �# � 3���� T� �( �% �� �& �� �� �# � 4��� T� �) �% �� �& �� � F� � � ��C��* �� ��C-��+ �� T�, �- �a�� T��. �a�� ���* � T��. �-�� �� U/  VFORMNO PRANGE LRANGE THISFORM CAPTION PLATFORM MVU_BACKEND PFORMNO ADDMODE EDITMODE	 MAINALIAS MAINTBL MAINFLD MAINCOND NHANDLE
 NOTREFRESH CREATESTDOBJECTS	 CO_DTBASE COMPANY DBNAME	 SQLCONOBJ ASSIGNEDRIGHTS DATASESSIONID	 PCURRYEAR STA_DT END_DT VCOLOR	 BACKCOLOR SETALL LABEL7
 _TDSACKNOW TDSACKSTRING MRET DATACONN SQLCONNCLOSE QUARTER TEXT1 VALUE	 ACKNOW_NO TEXT2 TEXT3 TEXT4 REFRESH	 ACT_DEACT
 TBRDESKTOP FLAG
 LOCKSCREEN�  4�  � ��� ��� �$ ��C� enabled �  � Checkbox�� ��# ��C� enabled �  � textbox�� ��) ��C� enabled �  � commandbutton�� �� �� U  MFLAG THISFORM SETALLx ��  � � �� ���(������ T� � �CC� Z���[ T� �C� �� � � � �9 C� �� � � � �! C� �� � �	 � �	 � �
 � 666��� T� ��~ select acknow_no from tdsacknow where FormNo=?thisform.pFormNo and quarter = ?ThisForm.pCQuarter and l_yn= ?ThisForm.pCurrYear��M T� �C� EXE� �  � �
 _tdsacknow� This.Parent.nHandle� � � � � �� %�� � ���� B�-�� � F�  � %�CN� ����� T� �ً  Update tdsacknow set acknow_no = ?cacknowno Where FormNo=?thisform.pFormNo and quarter = ?ThisForm.pCQuarter and l_yn= ?ThisForm.pCurrYear��M T� �C� EXE� �  � �
 _tdsacknow� This.Parent.nHandle� � � � � �� %�� � ���� B�-�� � ��� %�C� �
����� T� �ك  Insert into tdsacknow (quarter,acknow_no,l_yn,FormNo) Values(?ThisForm.pcquarter,?cacknowno,?ThisForm.pCurrYear,?thisform.pFormNo)��K T� �C� EXE� �  � � Mtypemas� This.Parent.nHandle� � � � � �� %�� � ���� B�-�� � � � �� ��� ��� ��C-�� �� T�� �-�� T�� �-�� T�� �-�� ��C-------a----aa� �� ��' T� �C� thisform.nHandle� � � �� %�� � ��P� B�-�� �! ��C� Record Saved�@� ��x�� U 
 _TDSACKNOW LCSTR N THISFORM	 PCQUARTER	 CACKNOWNO TEXT1 VALUE TEXT2 TEXT3 TEXT4 NRETVAL	 SQLCONOBJ DATACONN COMPANY DBNAME DATASESSIONID	 ACT_DEACT ADDMODE EDITMODE
 NOTREFRESH BARSTAT MRET SQLCONNCLOSE VUMESS Unload,     �� QueryUnloadT     �� modifyD    �� cancelc    �� addnew    �� Activate    �� InitA    ��	 act_deactx    �� saveit     ��1 �2 �� A A q A A A q A 2 � � � �� � � � � � � � A 2 � � � � �� � D 3 A 3 � �� � � ��� �� A A A 2 � � � � � q� � � � �qq� � � � b��1q�qA b� �q r�q A � Br�q A � q A A � q A qq A r Q � � QaQaQaQaA q A � � � � � � A 2 q � A1�A 2 � sB���q A q �	�q A � 	�q A A A A � � � � � �A qq A 3                       S         u   �        �  �         �  K  #   )   h  p  5   +   �     9   9     M  H   �   m    �   �   *  8  �    )   S                        +notrefresh
pformno
pcurryear
pcquarter
      shape      shape      Shape1      UEFRM_TDSACKN      Top = 3
Left = 3
Height = 157
Width = 337
BackStyle = 0
FillStyle = 1
SpecialEffect = 0
ZOrderSet = 0
Name = "Shape1"
      label      label      Label1      UEFRM_TDSACKN      �AutoSize = .T.
FontSize = 8
BackStyle = 0
Caption = "First"
Height = 16
Left = 13
Top = 42
Width = 23
ZOrderSet = 1
Name = "Label1"
      label      label      Label2      UEFRM_TDSACKN      �AutoSize = .T.
FontSize = 8
BackStyle = 0
Caption = "Second"
Height = 16
Left = 13
Top = 70
Width = 39
ZOrderSet = 2
Name = "Label2"
      label      label      Label3      UEFRM_TDSACKN      �AutoSize = .T.
FontSize = 8
BackStyle = 0
Caption = "Third"
Height = 16
Left = 13
Top = 98
Width = 26
ZOrderSet = 3
Name = "Label3"
      label      label      Label4      UEFRM_TDSACKN      �AutoSize = .T.
FontSize = 8
BackStyle = 0
Caption = "Fourth"
Height = 16
Left = 13
Top = 126
Width = 33
ZOrderSet = 4
Name = "Label4"
      textbox      textbox      Text1      UEFRM_TDSACKN      qHeight = 21
Left = 79
MaxLength = 50
SpecialEffect = 2
Top = 40
Width = 253
ZOrderSet = 5
Name = "Text1"
     PROCEDURE Valid
*!*	IF !EMPTY(thisform.text1.Value)
*!*		IF !EMPTY(thisform.text2.Value)
*!*			IF thisform.text1.Value = thisform.text2.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*		IF !EMPTY(thisform.text3.Value)
*!*			IF thisform.text1.Value = thisform.text3.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*		IF !EMPTY(thisform.text4.Value)
*!*			IF thisform.text1.Value = thisform.text4.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*	endif
ENDPROC
      ����    �   �                         q^   %   3       H      B           �  U    U   Valid,     ��1 @1                       �      )   �                         textbox      textbox      Text2      UEFRM_TDSACKN      qHeight = 21
Left = 79
MaxLength = 50
SpecialEffect = 2
Top = 68
Width = 253
ZOrderSet = 6
Name = "Text2"
     PROCEDURE Valid
*!*	IF !EMPTY(thisform.text2.Value)
*!*		IF !EMPTY(thisform.text3.Value)
*!*			IF thisform.text2.Value = thisform.text3.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*		IF !EMPTY(thisform.text4.Value)
*!*			IF thisform.text2.Value = thisform.text4.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*		IF !EMPTY(thisform.text1.Value)
*!*			IF thisform.text2.Value = thisform.text1.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*	endif
ENDPROC
      ����    �   �                         q^   %   3       H      B           �  U    U   Valid,     ��1 @1                       �      )   �                         textbox      textbox      Text3      UEFRM_TDSACKN      qHeight = 21
Left = 79
MaxLength = 50
SpecialEffect = 2
Top = 96
Width = 253
ZOrderSet = 7
Name = "Text3"
     PROCEDURE Valid
*!*	IF !EMPTY(thisform.text3.Value)
*!*		IF !EMPTY(thisform.text4.Value)
*!*			IF thisform.text3.Value = thisform.text4.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*		IF !EMPTY(thisform.text1.Value)
*!*			IF thisform.text3.Value = thisform.text1.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*		IF !EMPTY(thisform.text2.Value)
*!*			IF thisform.text3.Value = thisform.text2.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*	endif
ENDPROC
      ����    �   �                         q^   %   3       H      B           �  U    U   Valid,     ��1 @1                       �      )   �                         textbox      textbox      Text4      UEFRM_TDSACKN      rHeight = 21
Left = 79
MaxLength = 50
SpecialEffect = 2
Top = 124
Width = 253
ZOrderSet = 8
Name = "Text4"
     PROCEDURE Valid
*!*	IF !EMPTY(thisform.text4.Value)
*!*		IF !EMPTY(thisform.text1.Value)
*!*			IF thisform.text4.Value = thisform.text1.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*		IF !EMPTY(thisform.text2.Value)
*!*			IF thisform.text4.Value = thisform.text2.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*		IF !EMPTY(thisform.text3.Value)
*!*			IF thisform.text4.Value = thisform.text3.Value
*!*			=MESSAGEBOX('Acknowledgement No Should be different for all quarters',0+16,"Visual iTax")
*!*			RETURN .f.
*!*			endif
*!*		endif
*!*	endif
ENDPROC
      ����    �   �                         q^   %   3       H      B           �  U    U   Valid,     ��1 @1                       �      )   �                         label      label      Label5      UEFRM_TDSACKN      �AutoSize = .T.
FontBold = .T.
FontSize = 8
Alignment = 0
BackStyle = 0
Caption = "Quarter's"
Height = 16
Left = 13
Top = 14
Width = 54
ZOrderSet = 9
Name = "Label5"
      label      label      Label6      UEFRM_TDSACKN      �AutoSize = .T.
FontBold = .T.
FontSize = 8
Alignment = 0
BackStyle = 0
Caption = "TDS Acknowledgement No(s)."
Height = 16
Left = 79
Top = 14
Width = 166
ZOrderSet = 10
Name = "Label6"
      label      label      Label7      UEFRM_TDSACKN      �AutoSize = .T.
FontBold = .T.
FontSize = 8
BackStyle = 0
Caption = "."
Height = 16
Left = 256
Top = 14
Width = 5
Name = "Label7"
      BArial, 0, 8, 5, 14, 11, 29, 3, 0
Arial, 0, 9, 5, 15, 12, 32, 3, 0
0	   m                   PLATFORM   C                  UNIQUEID   C	   
               TIMESTAMP  N   
               CLASS      M                  CLASSLOC   M!                  BASECLASS  M%                  OBJNAME    M)                  PARENT     M-                  PROPERTIES M1                  PROTECTED  M5                  METHODS    M9                  OBJCODE    M=                 OLE        MA                  OLE2       ME                  RESERVED1  MI                  RESERVED2  MM                  RESERVED3  MQ                  RESERVED4  MU                  RESERVED5  MY                  RESERVED6  M]                  RESERVED7  Ma                  RESERVED8  Me                  USER       Mi                                                                                                                                                                                                                                                                                          COMMENT Class                                                                                               WINDOWS _20E0O8ZGW 911629295u      �  �      �      �  �          _  l  �          Q               COMMENT RESERVED                        A                                                                 WINDOWS _20E0O8ZGW 913667855`      {  l            �  Z(          J  W  �          <               COMMENT RESERVED                        -                                                                 WINDOWS _20T0ZFDV9 914658114�      x  
      �      �  *          �  �  �          �  �           WINDOWS _20T0ZFE2M 914658114�      �  �  {  �                                                           WINDOWS _20T0ZFE4D 914658114�  �  x  ^  O                                                             COMMENT RESERVED                        �      �                                                            .�                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 VERSION =   3.00      !Arial, 0, 9, 5, 15, 12, 32, 3, 0
      standfrm      Pixels      Class      1      form      standfrm      Ynhandle SQL - Connection handle
ofrmfrom Main form property object
*createstdobjects 
      �DataSession = 2
Height = 250
Width = 375
ShowWindow = 1
DoCreate = .T.
AutoCenter = .T.
BorderStyle = 3
Caption = ""
ControlBox = .T.
Closable = .F.
MaxButton = .F.
MinButton = .F.
WindowType = 1
nhandle = 0
ofrmfrom = 
Name = "standfrm"
      form      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      basefrm      Pixels      Class      1      form      basefrm      form      !Arial, 0, 9, 5, 15, 12, 32, 3, 0
      frmpbar      Pixels      Progress bar class      Class      3      form      frmpbar     .Top = 26
Left = 13
BackColor = 255,255,255
BorderColor = 0,128,255
value = 0
smooth = .T.
barcolor = 12937777
play = .F.
sizeadjust = .T.
Name = "Ctl32_progressbar1"
lblControlNameH.Name = "lblControlNameH"
tmrControlTimer.Name = "tmrControlTimer"
lblControlNameV.Name = "lblControlNameV"
      frmpbar      Ctl32_progressbar1      control      ctl32_progressbar.vcx      ctl32_progressbar      �AutoSize = .T.
FontBold = .T.
FontSize = 8
BackStyle = 0
Caption = "Refreshing data......."
Height = 16
Left = 14
Top = 8
Width = 110
ForeColor = 255,0,0
Name = "Lblinfo"
      frmpbar      Lblinfo      label      label      oshowprogress
lblcation
*initproc 
*progressbarexec 
*cleaprogressbar 
*showpbar 
*incpbar 
*setcation 
     ����    �  �                        ��	   %   �      �  $   �          �  U  5  G]� ��C� Please wait...!�  � �� ��C�  � �� U  THIS	 SETCATION SHOWPBAR�  4�  � %��  �d��% � ��C� � �� �� � %�� � -��� � T� � � �� � � �  �� �� ���(��d������y � �� ��C� � �� � � U  MVALUE THIS CLEAPROGRESSBAR SHOWPROGRESS CTL32_PROGRESSBAR1 VALUE A REFRESH  T�  � �a�� ��C�  � �� U  THIS SHOWPROGRESS RELEASE  T�  � �a�� U  THIS VISIBLEO ! ��  Q� INTEGER� Q� INTEGER� �� ��  �(�� ��H � ��C�� � �� �� U  FNUM SNUM I THIS PROGRESSBAREXEC  ��  � T� � � ��  �� U  LABLCAPTION THIS LBLINFO CAPTION)  T�  � ��  � �� T�  � ��  � �� U  THIS MINWIDTH WIDTH	 MINHEIGHT HEIGHT  U  	  G] � U   initproc,     �� progressbarexec�     �� cleaprogressbarm    �� showpbar�    �� incpbar�    ��	 setcationI    �� Load�    �� Init�    �� Release�    ��1 a �� 3 q � � !��A � A A 3 � � 3 � 3 qA 3 q 13 114 4 a 1                       X         ~   l        �  �        �  �          r        �  �  %      �     *   !   ;  =  0   "   [  h  4    )   �                       sPROCEDURE initproc
SET CURSOR OFF
THIS.setcation([Please wait...!])
THIS.showpbar()

ENDPROC
PROCEDURE progressbarexec
PARAMETERS MValue
IF MValue > 100
	THIS.CleaProgressBar()
ELSE
	IF THIS.showProgress = .F.
		THIS.ctl32_progressbar1.VALUE = THIS.ctl32_progressbar1.VALUE + MValue
		FOR a=1 TO 100 STEP 1
		ENDFOR
		THIS.REFRESH()
	ENDIF
ENDIF

ENDPROC
PROCEDURE cleaprogressbar
THIS.showProgress = .T.
THIS.RELEASE()

ENDPROC
PROCEDURE showpbar
THIS.VISIBLE = .T.

ENDPROC
PROCEDURE incpbar
LPARAMETERS Fnum AS INTEGER, Snum AS INTEGER
FOR i = Fnum TO Snum
	THIS.ProgressBarExec(1)
ENDFOR

ENDPROC
PROCEDURE setcation
LPARA Lablcaption
THIS.Lblinfo.CAPTION = Lablcaption

ENDPROC
PROCEDURE Load
This.MinWidth = This.Width
This.MinHeight = This.Height


ENDPROC
PROCEDURE Init


ENDPROC
PROCEDURE Release
SET CURSOR ON
ENDPROC
      form     PROCEDURE createstdobjects
*:*****************************************************************************
*:        Methods: Createstdobjects
*:         System: UDYOG ERP
*:         Author: RND Team.
*:  Last modified: 15-Feb-2007
*:			AIM  : Create UDYOG ERP Standard object and UI
*:*****************************************************************************
WITH THISFORM
	IF TYPE("Thisform.ofrmfrom") = "O"
		.BACKCOLOR = .ofrmfrom.BACKCOLOR
		IF .ofrmfrom.EDITMODE .OR. .ofrmfrom.ADDMODE
			.SETALL("enabled",.T.,"textbox")
			.SETALL("enabled",.T.,"checkbox")
			.SETALL("enabled",.T.,"combobox")
		ELSE
			.SETALL("enabled",.F.,"textbox")
			.SETALL("enabled",.F.,"checkbox")
			.SETALL("enabled",.F.,"combobox")
		ENDIF
		SET DATASESSION TO .ofrmfrom.DATASESSIONID
	ENDIF
	.ADDOBJECT("sqlconobj","sqlconnudobj")
	.ADDOBJECT("_stuffObject","_stuff")
	._stuffObject._objectPaint()
	.ICON = icopath
ENDWITH

ENDPROC
PROCEDURE Activate
=barstat(.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.)

ENDPROC
     )nhandle SQL - Connection handle
addmode TRUE is Addmode
editmode TRUE is Edit mode
co_dtbase Active company database
maincond Main condition for SQL-String
mainfld Main fields [Primary fields]
maintbl Maintbl is <SERVER TABLE> 
mainalias Mainalias is <VFP Cursor>
addbutton
editbutton
deletebutton
istoolbar Is use standard tool bar
platform
printbutton
previewbutton
ldefaenv
*createstdobjects Create standard UDYOG ERP object.
*addnew Add new entry method
*modify Modify/Alter records method
*delete Delete Record Method
*saveit Save / Update Record Method
*cancel Cancel records method
*loc 
*find Find records Method
*copy 
*printing Printing Method
*stdactivate Udyog standard activate method
*stdqunload Udyog standard Query unload
*act_deact 
*defaenv Default environment
     �Height = 59
Width = 328
ShowWindow = 2
ShowInTaskBar = .F.
DoCreate = .T.
AutoCenter = .T.
BorderStyle = 1
Caption = ""
ControlBox = .F.
Closable = .F.
HalfHeightCaption = .F.
MaxButton = .F.
MinButton = .F.
Movable = .T.
Visible = .F.
ClipControls = .F.
DrawWidth = 0
TitleBar = 0
WindowType = 0
AlwaysOnTop = .T.
BackColor = 235,235,235
ContinuousScroll = .F.
Themes = .F.
BindControls = .F.
showprogress = .F.
lblcation = .F.
Name = "frmpbar"
     R���    9  9                        uZ   %   �      �     �          �  U  � ���  ����% %�C� Thisform.ofrmfromb� O��?� T�� ��� � �� %��� � � �� � ��� �  ��C� enableda� textbox�� ��! ��C� enableda� checkbox�� ��! ��C� enableda� combobox�� �� �,�  ��C� enabled-� textbox�� ��! ��C� enabled-� checkbox�� ��! ��C� enabled-� combobox�� �� � G�(��� � �� �& ��C�	 sqlconobj� sqlconnudobj�� ��# ��C� _stuffObject� _stuff�� �� ��C�� �	 �� T��
 �� �� �� U  THISFORM	 BACKCOLOR OFRMFROM EDITMODE ADDMODE SETALL DATASESSIONID	 ADDOBJECT _STUFFOBJECT _OBJECTPAINT ICON ICOPATH  ��C--------------�  �� U  BARSTAT createstdobjects,     �� Activate^    ��1 � Q!�� A � A a1� � A 3 �2                       �        �        )   9                       �DataSession = 2
Height = 250
Width = 375
ShowWindow = 1
DoCreate = .T.
ShowTips = .T.
AutoCenter = .T.
BorderStyle = 3
Caption = ""
ControlBox = .T.
FontSize = 8
WindowType = 0
nhandle = 0
addmode = .F.
editmode = .F.
co_dtbase = 
maincond = .F.
mainfld = 
maintbl = 
mainalias = 
addbutton = .F.
editbutton = .F.
deletebutton = .F.
istoolbar = .T.
platform = .F.
printbutton = .F.
previewbutton = .F.
ldefaenv = .T.
Name = "basefrm"
     	hPROCEDURE createstdobjects
*:*****************************************************************************
*:        Methods: Createstdobjects
*:         System: UDYOG ERP
*:         Author: RND Team.
*:  Last modified: 15-Feb-2007
*:			AIM  : Create UDYOG ERP Standard object and UI
*:*****************************************************************************
WITH THISFORM
	IF TYPE("Company") = "O"
		.BACKCOLOR = VAL(Company.vcolor)
		.co_dtbase = Company.DBname
		.platform = mvu_backend
		.ICON = icopath
	ENDIF
	.defaenv()
	.ADDOBJECT("sqlconobj","sqlconnudobj")
	.ADDOBJECT("_stuffObject","_stuff")
	._stuffObject._objectPaint()
ENDWITH

ENDPROC
PROCEDURE printing
LPARAMETERS tcviewprint as Character 

ENDPROC
PROCEDURE stdactivate
*:*****************************************************************************
*:        Methods: Stdactivate
*:         System: UDYOG ERP
*:         Author: RND Team.
*:  Last modified: 15-Feb-2007
*:			AIM  : Create UDYOG ERP Standard Tool bar control method
*:*****************************************************************************
WITH THISFORM
	IF TYPE("tbrDesktop") = "O" AND .Istoolbar
		IF ! .addmode AND ! .editmode
			=barstat(.T.,.T.,.T.,.T.,.F.,.F.,.AddButton,.EditButton,.DeleteButton,.F.,.F.,.F.,.T.,.T.)
		ELSE
			=barstat(.F.,.F.,.F.,.F.,.F.,.F.,.T.,.T.,.F.,.F.,.F.,.F.,.T.,.T.)
		ENDIF
		tbrDesktop.REFRESH()
	ENDIF
	.REFRESH()
ENDWITH

ENDPROC
PROCEDURE stdqunload
*:*****************************************************************************
*:        Methods: Stdqunload
*:         System: UDYOG ERP
*:         Author: RND Team.
*:  Last modified: 15-Feb-2007
*:			AIM  : Standard Query unload Method when Istoolbar is TRUE
*:*****************************************************************************
IF TYPE("tbrDesktop") = "O" AND THISFORM.Istoolbar
	IF tbrDesktop.RESTORE()
		NODEFA
		RETU .F.
	ENDIF
	IF ! tbrDesktop.FLAG
		NODEFA
		RETU .F.
	ENDIF
	=barstat(.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.,.F.)
ENDIF

ENDPROC
PROCEDURE defaenv
IF THIS.lDefaenv
	SET DELETED ON
	SET DATE British
	SET CENTURY ON
	SET TALK OFF
	SET SAFETY OFF
	SET STATUS OFF
	SET NULL ON
	SET NULLDISPLAY TO ''
	SET STRICTDATE TO 0
ENDIF


ENDPROC
PROCEDURE Activate
THISFORM.stdactivate()
ENDPROC
PROCEDURE QueryUnload
THISFORM.Stdqunload()

ENDPROC
     3���                              ��   %   t      q  8             �  U  �  ���  ��� � %�C� Companyb� O��h � T�� �C� � g�� T�� �� � �� T�� �� �� T�� ��	 �� � ��C��
 ��& ��C�	 sqlconobj� sqlconnudobj�� ��# ��C� _stuffObject� _stuff�� �� ��C�� � �� �� U  THISFORM	 BACKCOLOR COMPANY VCOLOR	 CO_DTBASE DBNAME PLATFORM MVU_BACKEND ICON ICOPATH DEFAENV	 ADDOBJECT _STUFFOBJECT _OBJECTPAINT  ��  Q�	 CHARACTER� U  TCVIEWPRINT�  ���  ��� �& %�C�
 tbrDesktopb� O� �� 	��� � %��� 
� �� 
	��l �! ��Caaaa--�� �� �� ---aa� �� �� � ��C------aa----aa� �� � ��C� �	 �� � ��C��	 �� �� U
  THISFORM	 ISTOOLBAR ADDMODE EDITMODE BARSTAT	 ADDBUTTON
 EDITBUTTON DELETEBUTTON
 TBRDESKTOP REFRESH� ( %�C�
 tbrDesktopb� O� �  � 	��� � %�C� � ��D � �� B�-�� � %�� � 
��d � �� B�-�� � ��C--------------� �� � U  THISFORM	 ISTOOLBAR
 TBRDESKTOP RESTORE FLAG BARSTAT`  %��  � ��Y � G � G� British� G � G2� G.� G0� Gw � G�(��  �� G�(�� �� � U  THIS LDEFAENV BRITISH  ��C�  � �� U  THISFORM STDACTIVATE  ��C�  � �� U  THISFORM
 STDQUNLOAD createstdobjects,     �� printing�    �� stdactivate�    ��
 stdqunload�    �� defaenv�    �� Activate    �� QueryUnloadJ    ��1 � �1� � A � a1� A 3 A3 � a�� �A � A � A 3 �A q A A q A �A 3 a � a a a a a � � A 4 � 2 � 2                       �        �  �          �        �    0   (   2  �  E   4   	  $	  T   6   F	  ]	  W    )                     0   m                   PLATFORM   C                  UNIQUEID   C	   
               TIMESTAMP  N   
               CLASS      M                  CLASSLOC   M!                  BASECLASS  M%                  OBJNAME    M)                  PARENT     M-                  PROPERTIES M1                  PROTECTED  M5                  METHODS    M9                  OBJCODE    M=                 OLE        MA                  OLE2       ME                  RESERVED1  MI                  RESERVED2  MM                  RESERVED3  MQ                  RESERVED4  MU                  RESERVED5  MY                  RESERVED6  M]                  RESERVED7  Ma                  RESERVED8  Me                  USER       Mi                                                                                                                                                                                                                                                                                          COMMENT Class                                                                                               WINDOWS _1O61C2TAZ 878941401n      +
  {      �  �  �  (          X  e  �          J               COMMENT RESERVED                        �                                                                   WINDOWS _1NS0MG7JU 911641408U        d      �    �r  �3          ?  L  W%          1               WINDOWS _1NS0MG7JU 879059833      �  �  �  �
  �
                                                       WINDOWS _1O403W86Q 911641408�
      �
  �
  �  8
  �    �                                               WINDOWS _1O603XLBF 863702772�      �  �  �  �  }                                                       COMMENT RESERVED                                                                                            ޷                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 VERSION =   3.00      ctl32_progressbar      Pixels      Class      4      control      ctl32_progressbar      TRUE     AutoSize = .T.
FontName = "Tahoma"
FontSize = 8
FontStrikethru = .F.
FontUnderline = .F.
Anchor = 7
BackStyle = 0
Caption = "ctl32_ProgressBar"
Height = 96
Left = 0
Top = 18
Width = 16
ForeColor = 0,0,128
Rotation = 90
Name = "lblControlNameV"
      ctl32_progressbar      lblControlNameV      label      label      TRUE     ���    �   �                         �   %   �       �      �           �  U  E  %��  � � � �� � B� �# T�  � � ��  � � �  � � �� U  THIS PARENT HWND VALUE STEP Timer,     ��1 qA A 22                       |       )   �                         �PROCEDURE Timer
If This.Parent.HWnd = 0 Then
  Return
Endif

This.Parent.Value = This.Parent.Value + This.Parent.Step

ENDPROC
      ctl32_progressbar      ctl32_progressbarlabel      wctl32_name
ctl32_version
ctl32_update^
ctl32_declares^
ctl32_bytestostr^
ctl32_init^
ctl32_bind^
ctl32_unbind^
      Pixels      Class      1      label      ctl32_progressbarlabel     Z_memberdata XML Metadata for customizable properties
buddycontrol Especifies the full name of the ctl32_ProgressBar control to bind this label to. For example: ThisForm.ctl32_ProgressBar1
labelstyle Especifies the Style used to display numbers in label text. N: Number, P: Percent, B: Bytes/KB/MB/GB
labelcaption Especifies the text to display in the label. Any text can be entered, keywords <<Value>> and <<Maximum>> will be replaced by the progressbar respective values.
ctl32_name
ctl32_version
*ctl32_update 
*ctl32_declares 
*ctl32_bytestostr 
*ctl32_init 
*ctl32_bind 
*ctl32_unbind 
     (FontName = "Tahoma"
FontSize = 8
Alignment = 1
BorderStyle = 0
Caption = "ctl32_ProgressBar_Label"
Height = 16
Width = 300
_memberdata = 
buddycontrol = 
labelstyle = N
labelcaption = <<Value>>
ctl32_name = ctl32_ProgressBarLabel
ctl32_version = 1.1
Name = "ctl32_progressbarlabel"
      label      gTop = 0
Left = -25
Height = 23
Width = 23
Enabled = .F.
Interval = 100
Name = "tmrControlTimer"
      tmrControlTimer      timer      timer      TRUE      �FontName = "Tahoma"
FontSize = 8
FontStrikethru = .F.
FontUnderline = .F.
Anchor = 7
BackStyle = 0
Caption = "ctl32_ProgressBar"
Height = 15
Left = 6
Top = 1
Width = 89
ForeColor = 0,0,128
Name = "lblControlNameH"
      ctl32_progressbar      lblControlNameH      label      label      control     ����    �  �                        �q   %   �      �  @   `          �  U  p %�C�  � ��� � B� �# %�C� This.LabelStyleb� C��w �6 R,:��' LabelStyle Property must be Character: Ct�� B� � �� � � � H�� ��� ��  � � N��C�1 T� �CC�  � � .Value�� 999,999,999,999_��3 T� �CC�  � � .Maximum�� 999,999,999,999_��3 T� �CC�  � � .Minimum�� 999,999,999,999_�� ��  � � P����' T� �CC�  � � .Percent�� 999%_�� T� �� 100%�� T� �� 0%�� ��  � � B��!�# T� �CC�  � � .Value��  � ��% T� �CC�  � � .Maximum��  � ��% T� �CC�  � � .Minimum��  � �� 2���1 T� �CC�  � � .Value�� 999,999,999,999_��3 T� �CC�  � � .Maximum�� 999,999,999,999_��3 T� �CC�  � � .Minimum�� 999,999,999,999_�� � T� ��  � ��) T� �C� �	 <<Value>>C� ���
����+ T� �C� � <<Maximum>>C� ���
����+ T� �C� � <<Minimum>>C� ���
���� T�  �	 �� ��
 ��  �
 � U  THIS BUDDYCONTROL LCVALUE	 LCMAXIMUM	 LCCAPTION
 LABELSTYLE	 LCMINIMUM CTL32_BYTESTOSTR LABELCAPTION CAPTION REFRESH. + |�� StrFormatByteSizeA� shlwapi���� U  STRFORMATBYTESIZEA SHLWAPI}  ��  � �� � T�� �C�dX�� ��C ��  �� C�� >� �� T�� �C�� ��� T�� �C�� C�� >�=�� B�C�� ��� U  QDW PSZBUF STRFORMATBYTESIZEA1  T�  � ��  ��
 ��  � �
 ��  � �
 ��  � � U  THIS CAPTION CTL32_DECLARES
 CTL32_BIND CTL32_UPDATE�  %�C�  � �
��| � %�C�  � b� U��J �  T�  � ��	 ThisForm.�  � �� �. ��CC�  � �� VALUE�  � CTL32_UPDATE��� � U  THIS BUDDYCONTROLE  %�C�  � �
��> �+ ��CC�  � �� VALUE�  � CTL32_UPDATE�� � U  THIS BUDDYCONTROL 
 ��  � � U  THIS
 CTL32_INIT 
 ��  � � U  THIS CTL32_UNBIND ctl32_update,     �� ctl32_declares    �� ctl32_bytestostrk    ��
 ctl32_init    ��
 ctl32_bind{    �� ctl32_unbind    �� Inits    �� Destroy�    ��1 !A A 2aA A � � R11Rq� R1QQ� 11B ���� 3 �2 q r �2�� 2 � � � 3 1qA �B 3 1�A 2 � 3 � 2                            "   <  �  -   $   �  �  3   ,   �  !  C   1   B  &	  K   8   I	  �	  V   <   �	  �	  [   >   
  
  _    )   �                       
$PROCEDURE ctl32_update
If Empty(This.BuddyControl)
  Return
Endif

If Type("This.LabelStyle") <> [C]
  WAIT ([LabelStyle Property must be Character: ] + Program()) WINDOW nowait
  Return
Endif

Local lcValue, lcMaximum, lcCaption
Do Case

Case This.LabelStyle = "N"	&& Value
  lcValue = Transform((Evaluate(This.BuddyControl + ".Value")),"999,999,999,999")
  lcMaximum = Transform((Evaluate(This.BuddyControl + ".Maximum")),"999,999,999,999")
  lcMinimum = Transform((Evaluate(This.BuddyControl + ".Minimum")),"999,999,999,999")

Case This.LabelStyle = "P"	&& Percent
  lcValue = Transform(Evaluate(This.BuddyControl + ".Percent"),"999%")
  lcMaximum = "100%"
  lcMinimum = "0%"

Case This.LabelStyle = "B"	&& Bytes
  lcValue = This.ctl32_bytestostr(Evaluate(This.BuddyControl + ".Value"))
  lcMaximum = This.ctl32_bytestostr(Evaluate(This.BuddyControl + ".Maximum"))
  lcMinimum = This.ctl32_bytestostr(Evaluate(This.BuddyControl + ".Minimum"))

Otherwise	&& same as "N"
  lcValue = Transform((Evaluate(This.BuddyControl + ".Value")),"999,999,999,999")
  lcMaximum = Transform((Evaluate(This.BuddyControl + ".Maximum")),"999,999,999,999")
  lcMinimum = Transform((Evaluate(This.BuddyControl + ".Minimum")),"999,999,999,999")

Endcase

lcCaption = This.LabelCaption
lcCaption = Strtran(lcCaption ,"<<Value>>",Alltrim(lcValue),1,10,1)
lcCaption = Strtran(lcCaption ,"<<Maximum>>",Alltrim(lcMaximum),1,10,1)
lcCaption = Strtran(lcCaption ,"<<Minimum>>",Alltrim(lcMinimum),1,10,1)

This.Caption = lcCaption
This.Refresh

ENDPROC
PROCEDURE ctl32_declares
DECLARE INTEGER StrFormatByteSizeA IN shlwapi;
	INTEGER qdw,;
	STRING @ pszBuf,;
	INTEGER uiBufSize
ENDPROC
PROCEDURE ctl32_bytestostr
LPARAMETERS qdw

LOCAL pszBuf

m.pszBuf = SPACE(100)

StrFormatByteSizeA(m.qdw, @m.pszBuf, Len(m.pszBuf))

m.pszBuf = ALLTRIM(m.pszBuf)

* Remove chr(0)
m.pszBuf = Left(m.pszBuf,Len(m.pszBuf)-1)

RETURN ALLTRIM(m.pszBuf)
ENDPROC
PROCEDURE ctl32_init
This.Caption = ""

This.ctl32_Declares
This.ctl32_Bind
This.ctl32_Update

ENDPROC
PROCEDURE ctl32_bind
If Not Empty(This.BuddyControl) Then
  If Type(This.BuddyControl) = [U] Then
    This.BuddyControl = [ThisForm.] + This.BuddyControl
  Endif

  Bindevent(Evaluate(This.BuddyControl),"VALUE",This,"CTL32_UPDATE",1)

Endif

ENDPROC
PROCEDURE ctl32_unbind
If Not Empty(This.BuddyControl) Then
  Unbindevent(Evaluate(This.BuddyControl),"VALUE",This,"CTL32_UPDATE")
Endif
ENDPROC
PROCEDURE Init
This.ctl32_Init

ENDPROC
PROCEDURE Destroy
This.ctl32_Unbind

ENDPROC
     Actl32_hwnd^
ctl32_dwexstyle^
ctl32_lpclassname^
ctl32_dwstyle^
ctl32_parenthwnd^
ctl32_hinstance^
ctl32_creating^
ctl32_name
ctl32_hmenu^
ctl32_lpparam^
ctl32_lpwindowname^
ctl32_oldstep^
ctl32_version
ctl32_hwnds^
ctl32_left^
ctl32_top^
ctl32_width^
ctl32_height^
builderx
ctl32_resize^
step_assign^
minimum_assign^
maximum_assign^
marquee_assign^
visible_assign^
ctl32_create^
ctl32_destroy^
ctl32_declaredlls^
ctl32_bindevents^
ctl32_unbindevents^
marqueespeed_assign^
hwnd_access^
value_access^
value_assign^
percent_access^
smooth_assign^
backcolor_assign^
barcolor_assign^
play_assign^
scrolling_assign^
percent_assign^
max_assign^
min_assign^
hwnd_assign^
orientation_assign^
vertical_assign^
themes_assign^
ctl32_themes^
flat_assign^
bordercolor_assign^
instatusbar_assign^
StatusBarText^
Picture^
BackStyle^
Click^
ControlCount^
Controls^
DblClick^
ColorSource^
Drag^
DragDrop^
DragIcon^
DragMode^
DragOver^
GotFocus^
LostFocus^
MiddleClick^
MouseDown^
MouseEnter^
MouseIcon^
MouseLeave^
MouseMove^
MousePointer^
MouseUp^
MouseWheel^
OLECompleteDrag^
OLEDrag^
OLEDragDrop^
OLEDragMode^
OLEDragOver^
OLEDragPicture^
OLEDropEffects^
OLEDropHasData^
OLEDropMode^
OLEGiveFeedback^
OLESetData^
OLEStartDrag^
Objects^
RightClick^
Style^
BorderWidth^
ForeColor^
AddProperty^
ActiveControl^
Draw^
Enabled^
HelpContextID^
Move^
Moved^
Refresh^
ResetToDefault^
Resize^
SaveAsClass^
SetFocus^
ShowWhatsThis^
SpecialEffect^
TabStop^
ToolTipText^
WhatsThisHelpID^
WriteExpression^
WriteMethod^
     Nctl32_hwnd CreateWindowEx return value.
ctl32_dwexstyle CreateWindowEx parameter.
ctl32_lpclassname CreateWindowEx parameter.
ctl32_dwstyle CreateWindowEx parameter.
ctl32_parenthwnd CreateWindowEx parameter.
ctl32_hinstance CreateWindowEx parameter.
ctl32_creating
minimum Specifies the lower limit of the value property. Must be a positive or negative number smaller than Maximum
maximum Specifies the upper limit of the value property. Must be a positive or negative number larger than minimum.
vertical Specifies if the progressbar is vertical or horizontal.
_memberdata XML Metadata for customizable properties
step Determines the value to use in the stepit method. Can be a positive or negative value.
marquee Especifies if the marquee style is active. When set to true, the Smooth property is set to false to avoid wrong display of bars when using XP with no themes.
ctl32_name Name of the control class
marqueespeed Specifies the speed of the marquee bar, in milliseconds.
hwnd Specifies the Window handle of the Control.
value Specifies the current value of the control.
percent Specifies the percent of the value property relative to the total of maximum - minimum. 
repeat Specifies if the controls rolls over to minimum when value reaches maximum. Use it with Play to display a self updating progressbar.
smooth Specifies if the progressbar is shown using segments, or using a continuous bar.
parenthwnd Especifies the handle of the parent window of the control.
ctl32_hmenu CreateWindowEx parameter.
ctl32_lpparam CreateWindowEx parameter.
ctl32_lpwindowname CreateWindowEx parameter.
barcolor Specifies the color of the progress bar. A value of -1 resets color to system default. Backcolor specifies the color of the background, a value of -1 resets color to system default.
play When True, fires the StepIt method every 100 milliseconds. To set the speed, change the value of the step property.
max For compatibility only. Use Maximum property instead.
min For compatibility only. Use Minimum property instead.
scrolling For compatibility only. Use Smooth property instead.
orientation For compatibility only. Use Vertical  property instead. 0: Horizontal, 1:Vertical
ctl32_oldstep Saves old Step value when the StepIt method is called with a parameter.
sizeadjust Adjusts Width/Height of Horizontal/Vertical ProgressBar so that bars show even and complete at the end/top. Use only with Themes applied in Windows XP.
themes Determines if Themes are used for the control. (Windows XP).
ctl32_version
ctl32_hwnds Static window hwnd
flat Especifies if the flat style is active.
ctl32_left
ctl32_top
ctl32_width
ctl32_height
builderx
instatusbar
ctl32_flat
ctl32_xp
*ctl32_resize Bound to Form.Resize
*step_assign 
*minimum_assign 
*maximum_assign 
*marquee_assign 
*visible_assign 
*ctl32_create 
*ctl32_destroy 
*ctl32_declaredlls DLL declarations.
*ctl32_bindevents Binds events.
*ctl32_unbindevents 
*marqueespeed_assign 
*stepit Increments the value of the control by the amount specified in step. If a numeric parameter is passed, that value is used instead of the value set in the step property.
*hwnd_access 
*value_access 
*value_assign 
*percent_access 
*smooth_assign 
*backcolor_assign 
*barcolor_assign 
*play_assign 
*scrolling_assign 
*percent_assign 
*max_assign 
*min_assign 
*hwnd_assign 
*reset Resets the Value property to the Minimum value.
*orientation_assign 
*vertical_assign 
*themes_assign 
*ctl32_themes Bound to Form.Themes
*flat_assign 
*bordercolor_assign 
*instatusbar_assign 
*repeat_assign 
*width_assign 
*height_assign 
*u_strtolong 
     >����    �>  �>                        �X(   %   �3      "<  e  X7          �  U  0  %��  � a� �  � � ��$ � B� � ���  ��)� %��� a��� �4 ��C�� � �� ��� ��� ���	 ��� �� T��
 ������ T�� ������ T�� ��� ��� T�� ���	 ��� �� T��
 ��� �� T�� ��� �� T�� ��� �� T�� ���	 �� �$ ��C�� � ��
 �� �� �� �� �� �� U  THIS CTL32_CREATING
 CTL32_HWND
 CTL32_FLAT SETWINDOWPOS CTL32_HWNDS LEFT TOP WIDTH HEIGHT
 CTL32_LEFT	 CTL32_TOP CTL32_WIDTH CTL32_HEIGHT�  ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � T� � ���  �� ��C� � �� � � � �� U  VNEWVAL THIS STEP SENDMESSAGEN
 CTL32_HWND�  ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � T� � ���  �� T� � ���  �� %�� � � � ��� � T� � �� � �� �  ��C� � �� � � � � �� U  VNEWVAL THIS MINIMUM MIN VALUE SENDMESSAGEN
 CTL32_HWND MAXIMUM�  ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � T� � ���  �� T� � ���  �� %�� � � � ��� � T� � �� � �� �  ��C� � �� � � � � �� U  VNEWVAL THIS MAXIMUM MAX VALUE SENDMESSAGEN
 CTL32_HWND MINIMUM ��  � %�C�	 m.vNewValb� N��] � %���  � ��D � T��  �-�� �Y � T��  �a�� � � %�C�	 m.vNewValb� L��� �- ��C� Parameter must be Logical: Ct��x�� B� � T� � ���  �� %�� � a��� � T� � �-�� � %�� � � ��� ��C� � �� ��C� � �� � U  VNEWVAL THIS MARQUEE PLAY
 CTL32_HWND CTL32_DESTROY CTL32_CREATEN ��  � %�C�	 m.vNewValb� N��] � %���  � ��D � T��  �-�� �Y � T��  �a�� � � %�C�	 m.vNewValb� L��� �- ��C� Parameter must be Logical: Ct��x�� B� � T� � ���  �� %�� � � ��� � B� � %�� � a��� ��C� � �� �� ��C� � �� �� �G� ��C� � � � �� ��C� � � � �� � U  VNEWVAL THIS VISIBLE
 CTL32_HWND SHOWWINDOWX CTL32_HWNDS� ���  ���� %��� �� � B� � T�� �a�� T�� ��� �� %��� a��� � %��� -�	 C� � ��� � T�� �a�� T�� �-�� � %��� -��� � T�� �a�� � � %��� a���� T�� �� �� T��	 �� static�� T��
 ��  �� T�� �C�
   @�	   ��� T�� �� �� T�� �C�� ���� �� T�� �� ��O T�� �C�� ��	 ��
 �� �� ��� ��� ��� ��� �� �� �� � �� %��� � ����F ��C� Error Creating Common Control � static�  Window��� �x�� � � �� � T�� �� �� T��	 �� msctls_progress32�� T��
 ��  �� T�� �C�
   @�	   ��� %��� a���� T�� ������ T�� ������ T�� ��� ��� T�� ��� ��� T�� ��� �� ��� T�� ��� �� T�� ��� �� T�� ��� �� T�� ��� �� T�� ��� �� � %��� a��#� T�� �C�� ���� � %��� a��L� T�� �C�� ���� � %��� a�	 ��  � ���� T�� �C�� ���� � T�� �� �� T�� �C�� ���� �� T�� �� ��A T��! �C�� ��	 ��
 �� �� �� �� ��  �� �� �� �� � �� %���! � ��L�A ��C� Error Creating Common Control ��	 �  Window��� �x�� � %��� ��� ��" � T�" ��  � �� %��# � -���� T�" �-�� � %�C��
]� 0���� T�" �-�� � %�C� � ���� T�" �-�� � %��" ���� ��C�  �% ���$ �� �� ��C�  �% ��  �$ �� � � T��& ���' �� T��( ���) �� T��* ���* �� T��+ ���+ �� T��, ���, �� T��- ���- �� T��. ���. �� T��/ ���/ �� T��0 ���0 �� T�� �-�� �� U1  THIS CTL32_CREATING
 CTL32_FLAT FLAT INSTATUSBAR CTL32_XP ISTHEMEACTIVE THEMES CTL32_DWEXSTYLE CTL32_LPCLASSNAME CTL32_LPWINDOWNAME CTL32_DWSTYLE CTL32_HMENU CTL32_HINSTANCE GETWINDOWLONG CTL32_PARENTHWND CTL32_LPPARAM CTL32_HWNDS CREATEWINDOWEX LEFT TOP WIDTH HEIGHT
 CTL32_NAME LNPARENTHWND
 CTL32_LEFT	 CTL32_TOP CTL32_WIDTH CTL32_HEIGHT MARQUEE SMOOTH VERTICAL ORIENTATION
 CTL32_HWND
 LUSETHEMES THISFORM SETWINDOWTHEME HWND MIN MINIMUM MAX MAXIMUM STEP VALUE MARQUEESPEED PLAY	 BACKCOLOR BARCOLOR VISIBLEC  ��C� � �  �� ��C� � �  �� T� � �� �� T� � �� �� U  DESTROYWINDOW THIS
 CTL32_HWND CTL32_HWNDS  ��  ���� � ��C��  ���� T�� �C��  ����4 %�C��  � CallWindowProc��� ���� ��� �) |�� CallWindowProc� user32������ �: %�C��  � ChildWindowFromPoint��� ���� ��� �+ |�� ChildWindowFromPoint� user32���� �4 %�C��  � CreateWindowEx��� ���� ��i�7 |�� CreateWindowEx� user32������������� �3 %�C��  � DestroyWindow��� ���� ����  |�� DestroyWindow� user32�� �3 %�C��  � GetClientRect��� ���� ���# |�� GetClientRect� user32��� �1 %�C��  � GetSysColor��� ���� ��m� |�� GetSysColor� user32�� �3 %�C��  � GetWindowLong��� ���� ����" |�� GetWindowLong� user32��� �* %�CC�JgCC�Jg�d�
ףp=
@
��O�3 %�C��  � IsThemeActive��� ���� ��K�$ |�� IsThemeActive� uxtheme.Dll� � �1 %�C��  � PostMessage��� ���� ����$ |�� PostMessage� user32����� �2 %�C��  � RedrawWindow��� ���� ���& |�� RedrawWindow� user32����� �2 %�C��  � SendMessageN��� ���� ��n�4 |�� SendMessage� user32Q� SendMessageN����� �3 %�C��  � SetWindowLong��� ���� ����$ |�� SetWindowLong� user32���� �2 %�C��  � SetWindowPos��� ���� ��*�+ |�� SetWindowPos� user32�������� �* %�CC�JgCC�Jg�d�
ףp=
@
����4 %�C��  � SetWindowTheme��� ���� ����& |�� SetWindowTheme� UxTheme���� � �1 %�C��  � ShowWindowX��� ���� ���. |��
 ShowWindow� user32Q� ShowWindowX��� � U  LADLLS LNLEN CALLWINDOWPROC USER32 CHILDWINDOWFROMPOINT CREATEWINDOWEX DESTROYWINDOW GETCLIENTRECT GETSYSCOLOR GETWINDOWLONG ISTHEMEACTIVE UXTHEME DLL POSTMESSAGE REDRAWWINDOW SENDMESSAGE SENDMESSAGEN SETWINDOWLONG SETWINDOWPOS SETWINDOWTHEME
 SHOWWINDOW SHOWWINDOWX� * ��C�  � RESIZE�  � CTL32_RESIZE���' ��C�  � TOP�  � CTL32_RESIZE���( ��C�  � LEFT�  � CTL32_RESIZE���* ��C� � THEMES�  � CTL32_THEMES��� U  THIS THISFORM�  %��  � � �� � B� �' ��C�  � RESIZE�  � CTL32_RESIZE��$ ��C�  � TOP�  � CTL32_RESIZE��% ��C�  � LEFT�  � CTL32_RESIZE��' ��C� � THEMES�  � CTL32_THEMES�� U  THIS
 CTL32_HWND THISFORM�  ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � T� � ���  �� ��C� � �
�� � � �� U  VNEWVAL THIS MARQUEESPEED SENDMESSAGEN
 CTL32_HWND@ ��  � �� � %�C� m.lnValb� N��; � T��  �� � �� �) %�� � -� � � ��  � � 	��l � B� �) %�� � -� � � ��  � � 	��� � B� � %���  � � ��� � T� � �� � �� T� � ���  �� �� � T� � �� �� � ��C� �
 �� � �	 �� %�� � � ��9� T� � �� � �� � U  LNVAL	 LNOLDSTEP THIS STEP REPEAT VALUE MAXIMUM MINIMUM CTL32_OLDSTEP SENDMESSAGEN
 CTL32_HWND  B��  � �� U  THIS
 CTL32_HWNDe  ��  � %�� � a��+ � T��  �� � �� �S �  T��  �C� � �� � � �� � B���  �� U  NVALUE THIS CTL32_CREATING VALUE SENDMESSAGEN
 CTL32_HWNDU ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � %�� � -��� � %���  � � ��� � B� � %���  � � ��� � B� � �� %���  � � ��� � T��  �� � �� � %���  � � ��� T��  �� � �� � � T� � ���  �� %�� � � ��N� ��C� � � ��  � � �� � U	  VNEWVAL THIS REPEAT MAXIMUM MINIMUM VALUE HWND SENDMESSAGEN
 CTL32_HWND. + B�C�d�  � �  � C�  � �  � 8�� U  THIS VALUE MINIMUM MAXIMUM�  ��  � %�C�	 m.vNewValb� N��] � %���  � ��D � T��  �-�� �Y � T��  �a�� � � %�C�	 m.vNewValb� L��� �- ��C� Parameter must be Logical: Ct��x�� B� � T� � ���  �� %�� � � ��� � ��C� � �� ��C� � �� � U  VNEWVAL THIS SMOOTH
 CTL32_HWND CTL32_DESTROY CTL32_CREATE�  ��  � %�C�	 m.vNewValb� N��W �3 ��C�' Parameter for BackColor must be Numeric�x�� � %���  ���� ��� � T��  ������ � %���  ������ � T��  ��
      ��A�� � T� � ���  �� ��C� � � � � � � �� B� U  VNEWVAL THIS	 BACKCOLOR SENDMESSAGEN
 CTL32_HWND�  ��  � %�C�	 m.vNewValb� N��V �2 ��C�& Parameter for BarColor must be Numeric�x�� � %���  ���� ��� � T��  ������ � %���  ������ � T��  �C�� �� � T� � ���  �� ��C� � �	� � � � �� B� U  VNEWVAL GETSYSCOLOR THIS BARCOLOR SENDMESSAGEN
 CTL32_HWND, ��  � %�C�	 m.vNewValb� N��] � %���  � ��D � T��  �-�� �Y � T��  �a�� � � %�C�	 m.vNewValb� L��� �- ��C� Parameter must be Logical: Ct��x�� B� � %���  a�	 � � a	��� � B� � T� � ���  �� %�� � a��� T� � �� � �� � T� � � �� � �� U  VNEWVAL THIS MARQUEE PLAY VALUE MINIMUM TMRCONTROLTIMER ENABLED�  ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � T� � ���  �� %�� � � ��� � T� � �-�� �� � T� � �a�� � U  VNEWVAL THIS SROLLING	 SCROLLING SMOOTH  ��  � B� U  VNEWVAL�  ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � T� � ���  �� T� � ���  �� U  VNEWVAL THIS MAX MAXIMUM�  ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � T� � ���  �� T� � ���  �� U  VNEWVAL THIS MIN MINIMUM  ��  � B� U  VNEWVAL  T�  � ��  � �� U  THIS VALUE MINIMUM�  ��  � %�C�	 m.vNewValb� N��U �- ��C� Parameter must be Numeric: Ct��x�� B� � T� � ���  �� %�� � � ��� � T� � �-�� �� � T� � �a�� � U  VNEWVAL THIS ORIENTATION VERTICAL8 ��  � %�C�	 m.vNewValb� N��] � %���  � ��D � T��  �-�� �Y � T��  �a�� � � %�C�	 m.vNewValb� L��� �- ��C� Parameter must be Logical: Ct��x�� B� � T� � ���  �� %�� � a��� � T� � ���� �� � T� � �� �� � %�� � � ��1� ��C� � �� ��C� � �� � U  VNEWVAL THIS VERTICAL ORIENTATION
 CTL32_HWND CTL32_DESTROY CTL32_CREATE ��  � %�� � -�� � B� � %�C�	 m.vNewValb� N��w � %���  � ��^ � T��  �-�� �s � T��  �a�� � � %�C�	 m.vNewValb� L��� �- ��C� Parameter must be Logical: Ct��x�� B� � T� � ���  �� %�� � � ��� � B� � ��C� � �� ��C� � �� U  VNEWVAL THIS CTL32_XP THEMES HWND CTL32_DESTROY CTL32_CREATE  T�  � �� � �� U  THIS THEMES THISFORM�  ��  � %�C�	 m.vNewValb� N��] � %���  � ��D � T��  �-�� �Y � T��  �a�� � � %�C�	 m.vNewValb� L��� �- ��C� Parameter must be Logical: Ct��x�� B� � T� � ���  �� %�� � � ��� � ��C� � �� ��C� � �� � U  VNEWVAL THIS FLAT
 CTL32_HWND CTL32_DESTROY CTL32_CREATEL  ��  � %���  �����3 � T��  �C� � � �^�� � T� � ���  �� U  VNEWVAL THIS BORDERCOLOR  ��  � T� � ���  �� U  VNEWVAL THIS INSTATUSBAR�  ��  � %�C�	 m.vNewValb� N��] � %���  � ��D � T��  �-�� �Y � T��  �a�� � � %�C�	 m.vNewValb� L��� �- ��C� Parameter must be Logical: Ct��x�� B� � T� � ���  �� U  VNEWVAL THIS REPEAT�  ��  � T� � ���  �� ��� �� � %��� a��{ � %��� � � �� -��w �% T�� �C�� ��� T���� � � �� U  VNEWVAL THIS WIDTH
 SIZEADJUST ORIENTATION VERTICAL�  ��  � T� � ���  �� ��� �� � %��� a��{ � %��� �� �� a��w �% T�� �C�� ��� T���� � � �� U  VNEWVAL THIS HEIGHT
 SIZEADJUST ORIENTATION VERTICAL/  4�  � T�� �C��  � 4RS���� B��� �� U 	 TCLONGSTR LNRETVAL� 4�  � T� � � ��  �� T� � � ��  �� T� � �� �� ��� ����) %�CC�JgCC�Jg�d�
ףp=
@�� � T�� �-�� �� � T�� �a�� � %�C� ThisFormb� O���c ��C�T USAGE: _Screen.Newobject("oProgressBar","ctl32_progressbar","ctl32_progressbar.vcx")��x�� B� � %��� a� C�t� 	��=� B� � ��C�� �� %�C�t� ��m� T��	 ���  �� ��� %��
 � ����� T��	 ��
 � �� ��� T� �CC�  �Q�� ��C�
 � � � �� T�� �CC� ��\�� �� T�� �CC� ��\�� �� T�� �CC� �	�\�� �� T�� �CC� ��\�� ��	 ��� �	 ��� �	 ��� �	 ��� � T�� �C�� �� �8�� T�� �C�� �� �8��! T��	 �C�
 �  ��  �� � �� � �% %��� � � Form�	 ��	 � 	���� B� �  %��
 � �9� � �� a��� T�� �-�� � %��� a���� %��� �� �� a��q�% T�� �C�� ��� T���� ���% T�� �C�� ��� T���� � � ��C��  �� ��C��! �� �� U"  TNPARENTHWND THIS LBLCONTROLNAMEH CAPTION LBLCONTROLNAMEV	 BACKSTYLE CTL32_XP INSTATUSBAR CTL32_DECLAREDLLS CTL32_PARENTHWND THISFORM
 SHOWWINDOW HWND LPRECT GETCLIENTRECT LNLEFT U_STRTOLONG LNTOP LNRIGHT LNBOTTOM LNPOINTY LNPOINTX CHILDWINDOWFROMPOINT PARENT	 BASECLASS NAME VISIBLE
 SIZEADJUST ORIENTATION VERTICAL HEIGHT WIDTH CTL32_BINDEVENTS CTL32_CREATE  ��C�  � �� U  THIS CTL32_DESTROY ctl32_resize,     �� step_assign�    �� minimum_assign�    �� maximum_assign�    �� marquee_assign�    �� visible_assignN    �� ctl32_create�    �� ctl32_destroy�    �� ctl32_declaredlls8    �� ctl32_bindevents|    �� ctl32_unbindevents6    �� marqueespeed_assign    �� stepit�    �� hwnd_access~    �� value_access�    �� value_assignK    �� percent_access�    �� smooth_assignE    �� backcolor_assign�    �� barcolor_assign�     �� play_assign�!    �� scrolling_assignF#    �� percent_assign $    ��
 max_assign;$    ��
 min_assign�$    �� hwnd_assign}%    �� reset�%    �� orientation_assign�%    �� vertical_assign�&    �� themes_assign'(    �� ctl32_themes�)    �� flat_assign�)    �� bordercolor_assign�*    �� instatusbar_assigna+    �� repeat_assign�+    �� width_assign�,    �� height_assignC-    �� u_strtolong.    �� InitO.    �� Destroy�3    ��1 A A � F� � 11� � � � � A GB 4 t ��A A "�3 t ��A A "!s1A 3 t ��A A "!s1A 5 q �1� � � A A ��A A ""� A C� � A 3 v �1� � � A A ��A A "BA A "11� 11A 4 p� � A A � � �� � A � A A � A� �� q� �#aA B s � �� �� � 11� � � � � A QA QA �QA � r� #A � q "� A R� A "� A � !� AA B � � � � � � � � � � B 3 3 � QB�A ��A B}A 2A 23A �A 2#A �1AA A EA "eA "EA 2DA "�A �AdA A �A 3 �q��5 BA A rAQq6 s ��A A "�5 t r �!A �B A �B A c1!� A �C1A : � 3 t #!� A � 2 t ��A A "bA A bA A � b!A b!A B "C�A 7 �5 q �1� � � A A ��A A "C� � A 4 z �1A bA BqA "�C 3 z �!A bA B1A "�B 3 q �1� � � A A ��A A �A A ""1A b3 q ��A A "B� � � A 3 q A 2 q ��A A "!3 q ��A A "!2 q A 2 14 q ��A A "B� � � A 4 q �1� � � A A ��A A ""� A C� � A 3 q "A A �1� � � A A ��A A "BA A � � 4 12 t �1� � � A A ��A A "B� � A 3 q B�A "3 q "3 q �1� � � A A ��A A "3 q "� �QA A A 3 q "� �QA A A 3 r �� 3 w 21� �� � � A �1A A �A A � � A� CA����� � � � ��A A RA A � A �Q� QA A � � B 4 � 4                       n        �  �  ,      �  �  =   (   �  �  T   4   	  �
  m   I     �  �   a   �  "  �   �   )"  �"  �  �   �"  �.  �  �   /  �/    �   �/  �0      )1  Q2  ,    n2  66  =  #  X6  �6  l  %  �6  8  q  -  .8  �:  �  F  �:  %;  �  H  I;  �<  �  Z  =  d?  �  h  �?  �A  �  v  �A  �C    �  �C  �D  +  �  �D  E  <  �  3E  �E  @  �  F  �F  L  �  �F  �F  W  �  G  0G  [  �  YG  XH  `  �  ~H  J  r  �  �J  sL  �  �  �L  �L  �  �  �L  �N  �  �  �N  +O  �    TO  �O  �    �O  �P  �    !Q   R  �    DR  FS     '  hS  �S    +  T  %[    c  C[  ][  h   )   �>                       [hPROCEDURE ctl32_resize
* If we are in the Control Init Stage, or
* we do not have a handle to the Control yet, just return:
If This.ctl32_Creating = .T. Or This.Ctl32_hWnd = 0 Then
  Return
Endif

* Else, resize the Control Window to its container size:

#Define SWP_NOZORDER			0x4

With This

  If .ctl32_Flat = .T. Then
    SetWindowPos(.Ctl32_hWnds, 0,;
      .Left + 1, ;
      .Top + 1, ;
      .Width - 2, ;
      .Height - 2, ;
      SWP_NOZORDER)
      
    .ctl32_Left = -2
    .ctl32_Top = -2
    .ctl32_Width = .Width + 2
    .ctl32_Height = .Height + 2
  Else
    .ctl32_Left = .Left
    .ctl32_Top = .Top
    .ctl32_Width = .Width
    .ctl32_Height = .Height
  Endif .ctl32_Flat = .T.

  SetWindowPos(.Ctl32_hWnd, 0,;
    .ctl32_Left, ;
    .ctl32_Top, ;
    .ctl32_Width, ;
    .ctl32_Height, ;
    SWP_NOZORDER)

Endwith


ENDPROC
PROCEDURE step_assign
#Define WM_USER					0x400
#Define PBM_SETSTEP				(WM_USER+4)

LPARAMETERS vNewVal

If type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

THIS.Step = m.vNewVal

* Set Step Value
SendMessageN(This.ctl32_hwnd, PBM_SETSTEP , THIS.Step, 0)

ENDPROC
PROCEDURE minimum_assign
#Define WM_USER					0x400
#Define PBM_SETRANGE32			(WM_USER+6)

Lparameters vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

This.Minimum = m.vNewVal
This.Min = m.vNewVal

* If actual Value is less than new Minimum, set value to new Minimum
If This.Value < This.Minimum Then
  This.Value =  This.Minimum
Endif

* Set Minimum and Maximum values:
SendMessageN(This.ctl32_hwnd, PBM_SETRANGE32, This.Minimum, This.maximum)

ENDPROC
PROCEDURE maximum_assign
#Define WM_USER					0x400
#Define PBM_SETRANGE32			(WM_USER+6)

Lparameters vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

This.Maximum = m.vNewVal
This.Max = m.vNewVal

* If actual Value is greater than new Maximum, set value to new Maximum
If This.Value > This.Maximum Then
  This.Value =  This.Maximum
Endif

* Set Minimum and Maximum values:
SendMessageN(This.ctl32_hwnd, PBM_SETRANGE32, This.Minimum, This.Maximum)



ENDPROC
PROCEDURE marquee_assign
Lparameters vNewVal

If Type("m.vNewVal") = [N] Then
  If m.vNewVal = 0 Then
    m.vNewVal = .F.
  Else
    m.vNewVal = .T.
  Endif
ENDIF

If Type("m.vNewVal") <> [L] Then
  Messagebox([Parameter must be Logical: ] + Program(), 16)
  Return
Endif

This.Marquee = m.vNewVal

If This.Marquee = .T. Then
  This.Play = .F.
Endif

* Marquee change needs to recreate Control
If This.ctl32_hwnd <> 0 Then
  This.ctl32_Destroy()
  This.ctl32_Create()
Endif

ENDPROC
PROCEDURE visible_assign
#Define SW_HIDE					0
#Define SW_SHOW					5
#Define SW_SHOWNA				8
#Define SW_SHOWDEFAULT			10

Lparameters vNewVal

If Type("m.vNewVal") = [N] Then
  If m.vNewVal = 0 Then
    m.vNewVal = .F.
  Else
    m.vNewVal = .T.
  Endif
ENDIF

If Type("m.vNewVal") <> [L] Then
  Messagebox([Parameter must be Logical: ] + Program(), 16)
  Return
Endif

This.Visible = m.vNewVal

If This.ctl32_HWnd = 0 Then
  Return
ENDIF

If This.Visible  = .T. Then
  ShowWindowX(This.Ctl32_HWnds, SW_SHOWNA)
  ShowWindowX(This.Ctl32_HWnd, SW_SHOWNA)
Else
  ShowWindowX(This.Ctl32_HWnds, SW_HIDE)
  ShowWindowX(This.Ctl32_HWnd, SW_HIDE)
Endif


ENDPROC
PROCEDURE ctl32_create
#Define WS_EX_CLIENTEDGE		0x200
#Define WS_EX_WINDOWEDGE		0x100
#Define WS_EX_OVERLAPPEDWINDOW	Bitor(WS_EX_WINDOWEDGE, WS_EX_CLIENTEDGE)
#Define WS_EX_STATICEDGE	0x20000

#Define WS_CHILD				0x40000000
#Define WS_VISIBLE				0x10000000
#Define WS_CLIPSIBLINGS			0x4000000
#Define WS_BORDER				0x800000

#Define WM_NCPAINT				0x85

#Define GWL_HINSTANCE			-6
#Define GWL_EXSTYLE				-20
#Define GWL_STYLE				-16

#Define PBS_SMOOTH				0x1			&& Comctl32.dll Version 4.7 or later
#Define PBS_VERTICAL			0x4			&& Comctl32.dll Version 4.7 or later
#Define PBS_MARQUEE				0x8			&& Comctl32.dll version 6

#Define WM_USER					0x400
#Define CCM_FIRST				0x2000
#Define CCM_SETBKCOLOR			(CCM_FIRST + 1)

#Define PBM_DELTAPOS			(WM_USER+3)
#Define PBM_GETPOS				(WM_USER+8)
#Define PBM_GETRANGE			(WM_USER+7)
#Define PBM_SETBARCOLOR			(WM_USER+9)
#Define PBM_SETBKCOLOR			CCM_SETBKCOLOR
#Define PBM_SETPOS				(WM_USER+2)
#Define PBM_SETRANGE			(WM_USER+1)
#Define PBM_SETRANGE32			(WM_USER+6)
#Define PBM_SETSTEP				(WM_USER+4)
#Define PBM_STEPIT				(WM_USER+5)
#Define PBM_SETMARQUEE  		(WM_USER+10)

#Define SW_HIDE					0
#Define SW_SHOW					5
#Define SW_SHOWNA				8

* START Version 1.2
#Define HWND_TOP				0
#Define SWP_NOMOVE				0x2
#Define SWP_NOSIZE				0x1
* END Version 1.2

#Define SW_SHOWDEFAULT			10

#Define COLOR_HIGHLIGHT         13
#Define COLOR_BTNFACE           15

#Define PS_SOLID				0
#Define COLOR_WINDOW            5
#Define COLOR_BTNFACE           15

With This

	If .ctl32_Creating Then
		Return
	Endif

	* We enter Initialization Stage... (checked by ctl32_Resize)
	.ctl32_Creating = .T.

	* If Win98 or Themes off, set flat for statusbar
	.ctl32_Flat = .Flat
	If .InStatusBar = .T. Then
		If .ctl32_XP = .F. Or isThemeActive() = 0 Then
			.ctl32_Flat = .T.
			.Themes = .F.
		Endif
		If .Themes = .F. Then
			.ctl32_Flat = .T.
		Endif
	Endif

	* Create Static window to hold progressbar if needed
	If .ctl32_Flat = .T. Then
		*Define parameters for static createwindowex:
		.ctl32_dwExStyle = 0
		.ctl32_lpClassName = [static]
		.ctl32_lpWindowName = ""
		.ctl32_dwStyle = Bitor(WS_CHILD, WS_CLIPSIBLINGS)

		.ctl32_hMenu = 0
		.ctl32_hInstance = GetWindowLong(.ctl32_ParentHWnd, GWL_HINSTANCE)
		.ctl32_lpParam = 0

		.ctl32_hwnds = CreateWindowEx( ;
			.ctl32_dwExStyle, ;
			.ctl32_lpClassName, ;
			.ctl32_lpWindowName, ;
			.ctl32_dwStyle, ;
			.Left + 1, .Top + 1, .Width - 2, .Height - 2,;
			.ctl32_ParentHWnd,;
			.ctl32_hMenu, ;
			.ctl32_hInstance, ;
			.ctl32_lpParam)

		* If the handle to the Control is 0 then we have a problem!
		If .ctl32_hwnds = 0
			Messagebox([Error Creating Common Control ] + [static] + [ Window], 0+16, .ctl32_name)
		Endif

	Endif

	* Define parameters for progressbar createwindowex:
	Local lnParentHWnd

	.ctl32_dwExStyle = 0
	.ctl32_lpClassName = [msctls_progress32]
	.ctl32_lpWindowName = ""
	.ctl32_dwStyle = Bitor(WS_CHILD, WS_CLIPSIBLINGS)

	If .ctl32_Flat = .T. Then
		.ctl32_Left = -2
		.ctl32_Top = -2
		.ctl32_Width = .Width + 2
		.ctl32_Height = .Height + 2
		m.lnParentHWnd = .ctl32_hwnds
	Else
		.ctl32_Left = .Left
		.ctl32_Top = .Top
		.ctl32_Width = .Width
		.ctl32_Height = .Height
		m.lnParentHWnd = .ctl32_ParentHWnd
	Endif .ctl32_Flat = .T.

	* Setup Control specific Styles:
	* Marquee
	If .Marquee = .T. Then
		.ctl32_dwStyle = Bitor(.ctl32_dwStyle, PBS_MARQUEE)
	Endif

	* Smooth
	If .Smooth = .T.
		.ctl32_dwStyle = Bitor(.ctl32_dwStyle, PBS_SMOOTH)
	Endif

	* Orientation
	If .Vertical = .T. Or .Orientation <> 0 Then
		.ctl32_dwStyle = Bitor(.ctl32_dwStyle, PBS_VERTICAL)
	Endif

	.ctl32_hMenu = 0

	.ctl32_hInstance = GetWindowLong(.ctl32_ParentHWnd, GWL_HINSTANCE)

	.ctl32_lpParam = 0

	.ctl32_hwnd = CreateWindowEx( ;
		.ctl32_dwExStyle, ;
		.ctl32_lpClassName, ;
		.ctl32_lpWindowName, ;
		.ctl32_dwStyle, ;
		.ctl32_Left, .ctl32_Top, .ctl32_Width, .ctl32_Height, ;
		m.lnParentHWnd,;
		.ctl32_hMenu, ;
		.ctl32_hInstance, ;
		.ctl32_lpParam)

	* If the handle to the Control is 0 then we have a problem!
	If .ctl32_hwnd = 0
		Messagebox([Error Creating Common Control ] + .ctl32_lpClassName + [ Window], 0+16, .ctl32_name)
	Endif

	* Set Theme
	If .ctl32_XP Then
		Local lUseThemes

		lUseThemes = This.Themes

		If Thisform.Themes = .F. Then
			lUseThemes = .F.
		Endif

		If Sys(2700) = "0" Then
			lUseThemes = .F.
		Endif

		If isThemeActive() = 0 Then
			lUseThemes = .F.
		Endif

		If lUseThemes Then
			SetWindowTheme(This.HWnd, Null, Null)
		Else
			SetWindowTheme(This.HWnd, Null, "")
		Endif

	Endif

	* Set Control Minimum and Maximum values:
	.Min = .Minimum
	.Max = .Maximum

	* Set Control Step Value
	.Step = .Step

	* Set Control Value to the Container Value property
	.Value = .Value

	* Set MarqueeSpeed Value
	.MarqueeSpeed = .MarqueeSpeed

	* Set Play state
	.Play = .Play

	* Set Colors
	.BackColor = .BackColor
	.BarColor = .BarColor

	* Set Visible state
	.Visible = .Visible

	* We finish Initialization State
	.ctl32_Creating = .F.

Endwith

ENDPROC
PROCEDURE ctl32_destroy

* Release Control:
DestroyWindow(This.Ctl32_HWnd)
DestroyWindow(This.Ctl32_HWnds)

This.Ctl32_HWnd = 0
This.Ctl32_HWnds = 0

ENDPROC
PROCEDURE ctl32_declaredlls
Local laDLLs[1], lnLen

Adlls( laDLLs )
m.lnLen = Alen( laDLLs, 1 )

If Ascan( laDLLs, "CallWindowProc", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer CallWindowProc In user32 ;
    INTEGER lpPrevWndFunc,;
    INTEGER HWnd,;
    INTEGER msg,;
    INTEGER wParam,;
    INTEGER Lparam
ENDIF

If Ascan( laDLLs, "ChildWindowFromPoint", 1, m.lnLen , 1, 15 ) = 0
	Declare Integer ChildWindowFromPoint In user32 ;
		INTEGER hWndParent,;
		INTEGER px,;
		INTEGER py
Endif

If Ascan( laDLLs, "CreateWindowEx", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer CreateWindowEx In user32 ;
    INTEGER dwExStyle,;
    STRING lpClassName,;
    STRING lpWindowName,;
    INTEGER dwStyle,;
    INTEGER x,;
    INTEGER Y,;
    INTEGER nWidth,;
    INTEGER nHeight,;
    INTEGER hWndParent,;
    INTEGER hMenu,;
    INTEGER hInstance,;
    INTEGER lpParam
Endif

If Ascan( laDLLs, "DestroyWindow", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer DestroyWindow In user32 ;
    INTEGER HWnd
Endif

If Ascan( laDLLs, "GetClientRect", 1, m.lnLen , 1, 15 ) = 0
	Declare Integer GetClientRect In user32 ;
		INTEGER HWnd,;
		STRING @ lpRect
Endif

If Ascan( laDLLs, "GetSysColor", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer GetSysColor In user32 ;
    INTEGER nIndex
Endif

If Ascan( laDLLs, "GetWindowLong", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer GetWindowLong In user32 ;
    INTEGER HWnd, ;
    INTEGER nIndex
Endif

If Not Val(Os(3)) + Val(Os(4))/100 < 5.01 Then
	If Ascan( laDLLs, "IsThemeActive", 1, m.lnLen , 1, 15 ) = 0
		Declare Integer IsThemeActive In uxtheme.Dll
	Endif
ENDIF

If Ascan( laDLLs, "PostMessage", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer PostMessage In user32 ;
    INTEGER HWnd,;
    INTEGER Msg,;
    INTEGER wParam,;
    INTEGER Lparam
Endif

If Ascan( laDLLs, "RedrawWindow", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer RedrawWindow In user32 ;
    INTEGER HWnd,;
    STRING @ lprcUpdate,;
    INTEGER hrgnUpdate,;
    INTEGER fuRedraw
Endif

If Ascan( laDLLs, "SendMessageN", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer SendMessage In user32 as SendMessageN;
    INTEGER HWnd,;
    INTEGER Msg,;
    INTEGER wParam,;
    INTEGER Lparam
Endif

If Ascan( laDLLs, "SetWindowLong", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer SetWindowLong In user32 ;
    INTEGER HWnd,;
    INTEGER nIndex,;
    INTEGER dwNewLong
Endif

If Ascan( laDLLs, "SetWindowPos", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer SetWindowPos In user32 ;
    INTEGER HWnd,;
    INTEGER hWndInsertAfter,;
    INTEGER x,;
    INTEGER Y,;
    INTEGER cx,;
    INTEGER cy,;
    INTEGER wFlags
Endif

If NOT Val(Os(3)) + Val(Os(4))/100 < 5.01 Then
  If Ascan( laDLLs, "SetWindowTheme", 1, m.lnLen , 1, 15 ) = 0
    Declare Integer SetWindowTheme In UxTheme ;
      INTEGER HWnd,;
      String pszSubAppName,;
      String pszSubIdList
  Endif
Endif

If Ascan( laDLLs, "ShowWindowX", 1, m.lnLen , 1, 15 ) = 0
  Declare Integer ShowWindow In user32 As ShowWindowX ;
    INTEGER HWnd,;
    INTEGER nCmdShow
Endif

ENDPROC
PROCEDURE ctl32_bindevents

Bindevent(This, [RESIZE], This, [CTL32_RESIZE],1)
Bindevent(This, [TOP], This, [CTL32_RESIZE],1)
Bindevent(This, [LEFT], This, [CTL32_RESIZE],1)
Bindevent(Thisform,[THEMES],This,[CTL32_THEMES],1)



ENDPROC
PROCEDURE ctl32_unbindevents

If This.ctl32_HWnd = 0 Then
  Return
Endif

Unbindevent(This, [RESIZE], This, [CTL32_RESIZE])
Unbindevent(This, [TOP], This, [CTL32_RESIZE])
Unbindevent(This, [LEFT], This, [CTL32_RESIZE])
Unbindevent(Thisform,[THEMES],This,[CTL32_THEMES])




ENDPROC
PROCEDURE marqueespeed_assign
#Define PBS_MARQUEE				0x8			&& Comctl32.dll version 6

Lparameters vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

This.MarqueeSpeed = m.vNewVal

SendMessageN(This.Ctl32_HWnd, PBM_SETMARQUEE, 1, This.MarqueeSpeed)



ENDPROC
PROCEDURE stepit
#Define WM_USER					0x400
#Define PBM_STEPIT				(WM_USER+5)

Lparameters lnVal

Local lnOldStep

* If no numeric parameter, use actual step value:
If Type("m.lnVal") <> "N"
  m.lnVal = This.Step
Endif

If This.Repeat = .F. And This.Value + m.lnVal > This.Maximum Then
*  This.Value = This.Maximum
  Return
Endif

If This.Repeat = .F. And This.Value + m.lnVal < This.Minimum Then
*  This.Value = This.Minimum
  Return
Endif

* If parameter is different from actual step value:
If m.lnVal <> This.Step Then
  This.ctl32_OldStep = This.Step
  This.Step = m.lnVal
Else
  This.ctl32_OldStep = 0
Endif

* Send StepIt message:
SendMessageN(This.ctl32_hwnd, PBM_STEPIT, 0, 0)

*Reset Step Value if old value saved:
If This.ctl32_OldStep <> 0 Then
  This.Step = This.ctl32_OldStep
Endif

* Update Container Value Property with the position property of Control,
* forcing Access and Assign Events to fire:
*This.Value = This.Value




ENDPROC
PROCEDURE hwnd_access
* Returns the HWnd of the Control
RETURN This.Ctl32_HWnd

ENDPROC
PROCEDURE value_access
#Define WM_USER					0x400
#Define PBM_GETPOS				(WM_USER+8)

Local nValue

* If setting up Control, use Value of Container, not Value of Control
If This.ctl32_Creating = .T. Then
  m.nValue = This.Value
Else
  * Ask Control for Value to return:
  m.nValue = SendMessageN(This.ctl32_hwnd, PBM_GETPOS, 0, 0)
Endif

Return m.nValue
ENDPROC
PROCEDURE value_assign
#Define WM_USER					0x400
#Define PBM_SETPOS				(WM_USER+2)

Lparameters vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

If This.Repeat = .F.

  If m.vNewVal > This.Maximum Then
    Return
  Endif

  If m.vNewVal < This.Minimum Then
    Return
  Endif

Else

  If m.vNewVal > This.Maximum Then
    m.vNewVal = This.Minimum
  Endif

  If m.vNewVal < This.Minimum Then
    m.vNewVal = This.Maximum
  Endif

Endif

This.Value = m.vNewVal


If This.HWnd # 0 Then
  SendMessageN(This.ctl32_hwnd, PBM_SETPOS, m.vNewVal, 0)
Endif





ENDPROC
PROCEDURE percent_access
Return INT(100 * (This.Value - This.Minimum) / (ABS(This.Maximum - This.Minimum)))



ENDPROC
PROCEDURE smooth_assign
Lparameters vNewVal

If Type("m.vNewVal") = [N] Then
  If m.vNewVal = 0 Then
    m.vNewVal = .F.
  Else
    m.vNewVal = .T.
  Endif
ENDIF

If Type("m.vNewVal") <> [L] Then
  Messagebox([Parameter must be Logical: ] + Program(), 16)
  Return
Endif

This.Smooth = m.vNewVal

* Smooth change needs to recreate Control
If This.ctl32_hwnd <> 0 Then
  This.ctl32_destroy()
  This.ctl32_Create()
Endif


ENDPROC
PROCEDURE backcolor_assign
#Define WM_USER					0x400
#Define CCM_FIRST				0x2000
#Define CCM_SETBKCOLOR			(CCM_FIRST + 1)
#DEFINE CLR_DEFAULT				0xFF000000
#Define PBM_SETBARCOLOR			(WM_USER+9)
#Define PBM_SETBKCOLOR			CCM_SETBKCOLOR

#Define COLOR_BTNFACE           15

Lparameters vNewVal

If Type("m.vNewVal") <> [N]
	Messagebox([Parameter for BackColor must be Numeric])
Endif

If m.vNewVal > 16777215 Then
	m.vNewVal = -1
Endif

If m.vNewVal = -1 Then
m.vNewVal = clr_default
Endif

This.BackColor= m.vNewVal


SendMessageN(This.Ctl32_HWnd, PBM_SETBKCOLOR, 0, This.BackColor)


Return

ENDPROC
PROCEDURE barcolor_assign
#Define WM_USER					0x400
#Define CCM_FIRST				0x2000
#Define CCM_SETBKCOLOR			(CCM_FIRST + 1)

#Define PBM_SETBARCOLOR			(WM_USER+9)
#Define PBM_SETBKCOLOR			CCM_SETBKCOLOR

#Define COLOR_HIGHLIGHT         13

Lparameters vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter for BarColor must be Numeric])
Endif

If m.vNewVal > 16777215 Then
  m.vNewVal = -1
Endif

If m.vNewVal = -1 Then
  m.vNewVal = GetSysColor(COLOR_HIGHLIGHT)
Endif

This.BarColor= m.vNewVal

SendMessageN(This.Ctl32_HWnd, PBM_SETBARCOLOR, 0, This.BarColor)

Return

ENDPROC
PROCEDURE play_assign
Lparameters vNewVal

If Type("m.vNewVal") = [N] Then
  If m.vNewVal = 0 Then
    m.vNewVal = .F.
  Else
    m.vNewVal = .T.
  Endif
Endif

If Type("m.vNewVal") <> [L] Then
  Messagebox([Parameter must be Logical: ] + Program(), 16)
  Return
Endif

If m.vNewVal = .T. And This.Marquee = .T. Then
  Return
Endif

This.Play = m.vNewVal

If This.Play = .T. Then
  This.Value = This.Minimum
Endif

This.tmrControlTimer.Enabled = This.Play

ENDPROC
PROCEDURE scrolling_assign
Lparameters vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

This.Srolling = m.vNewVal

If This.Scrolling = 0 Then
  This.Smooth = .F.
Else
  This.Smooth = .T.
Endif

ENDPROC
PROCEDURE percent_assign
LPARAMETERS vNewVal
RETURN
ENDPROC
PROCEDURE max_assign
Lparameters vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

This.Max = m.vNewVal
This.Maximum = m.vNewVal

ENDPROC
PROCEDURE min_assign
LPARAMETERS vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

This.Min = m.vNewVal
This.Minimum = m.vNewVal
ENDPROC
PROCEDURE hwnd_assign
LPARAMETERS vNewVal
RETURN
ENDPROC
PROCEDURE reset
This.Value = This.Minimum


ENDPROC
PROCEDURE orientation_assign
Lparameters vNewVal

If Type("m.vNewVal") <> [N]
  Messagebox([Parameter must be Numeric: ] + Program(), 16)
  Return
Endif

This.Orientation = m.vNewVal

If This.Orientation = 0 Then
  This.Vertical = .F.
Else
  This.Vertical = .T.
Endif


ENDPROC
PROCEDURE vertical_assign
Lparameters vNewVal

If Type("m.vNewVal") = [N] Then
  If m.vNewVal = 0 Then
    m.vNewVal = .F.
  Else
    m.vNewVal = .T.
  Endif
ENDIF

If Type("m.vNewVal") <> [L] Then
  Messagebox([Parameter must be Logical: ] + Program(), 16)
  Return
Endif

This.Vertical = m.vNewVal

If This.Vertical = .T. Then
  This.Orientation = 1
Else
  This.Orientation = 0
Endif

* Vertical change needs to recreate Control
If This.ctl32_hwnd <> 0 Then
  This.ctl32_destroy()
  This.ctl32_Create()
Endif

ENDPROC
PROCEDURE themes_assign
Lparameters vNewVal

If This.ctl32_XP = .F.
	Return
Endif

If Type("m.vNewVal") = [N] Then
	If m.vNewVal = 0 Then
		m.vNewVal = .F.
	Else
		m.vNewVal = .T.
	Endif
Endif

If Type("m.vNewVal") <> [L] Then
	Messagebox([Parameter must be Logical: ] + Program(), 16)
	Return
Endif

This.Themes = m.vNewVal

If This.HWnd = 0 Then
	Return
Endif

* Window is recreated, or artifacts remain in border:
This.ctl32_Destroy()
This.ctl32_Create()


ENDPROC
PROCEDURE ctl32_themes
This.Themes = ThisForm.Themes
ENDPROC
PROCEDURE flat_assign
#Define COLOR_WINDOW            5
#Define COLOR_BTNFACE           15

Lparameters vNewVal

If Type("m.vNewVal") = [N] Then
  If m.vNewVal = 0 Then
    m.vNewVal = .F.
  Else
    m.vNewVal = .T.
  Endif
ENDIF

If Type("m.vNewVal") <> [L] Then
  Messagebox([Parameter must be Logical: ] + Program(), 16)
  Return
Endif

This.Flat = m.vNewVal

If This.ctl32_hwnd <> 0 Then
  This.ctl32_destroy()
  This.ctl32_Create()
Endif

ENDPROC
PROCEDURE bordercolor_assign
LPARAMETERS vNewVal

If m.vNewVal = -1 Then
  m.vNewVal = RGB(0,0,0)
Endif

THIS.BorderColor = m.vNewVal

ENDPROC
PROCEDURE instatusbar_assign
LPARAMETERS vNewVal
*To do: Modify this routine for the Assign method
THIS.InStatusBar = m.vNewVal

ENDPROC
PROCEDURE repeat_assign
LPARAMETERS vNewVal

If Type("m.vNewVal") = [N] Then
  If m.vNewVal = 0 Then
    m.vNewVal = .F.
  Else
    m.vNewVal = .T.
  Endif
ENDIF

If Type("m.vNewVal") <> [L] Then
  Messagebox([Parameter must be Logical: ] + Program(), 16)
  Return
Endif

THIS.Repeat = m.vNewVal

ENDPROC
PROCEDURE width_assign
Lparameters vNewVal
*To do: Modify this routine for the Assign method
This.Width = m.vNewVal

With This
	If .SizeAdjust = .T. Then
		If .Orientation = 0 Or .Vertical = .F. Then
			.Width = Round((.Width - 5)/8,0) * 8 + 5
		Endif
	Endif
Endwith

ENDPROC
PROCEDURE height_assign
Lparameters vNewVal
*To do: Modify this routine for the Assign method
This.Height = m.vNewVal

With This
	If .SizeAdjust = .T. Then
		If .Orientation = 1 Or .Vertical = .T. Then
			.Height = Round((.Height - 8)/8,0) * 8 + 5
		Endif
	Endif
Endwith

ENDPROC
PROCEDURE u_strtolong
* This function converts a String to a Long
Parameters tcLongStr

m.lnRetval = CToBin(m.tcLongStr,[4RS])

Return m.lnRetval

ENDPROC
PROCEDURE Init
*	Ctl32_ProgressBar
*	Control creado por Carlos Alloatti - calloatti@gmail.com
*	Utiliza funciones API de Windows
*	Probado con Windows XP, 98 y VFP 9
*	Versi�n  1.00 - 2005-12-01

Parameters tnparenthwnd

This.lblControlNameH.Caption = ""
This.lblControlNameV.Caption = ""
This.BackStyle = 0

With This

	If Val(Os(3)) + Val(Os(4))/100 < 5.01
		.ctl32_XP = .F.
	Else
		.ctl32_XP = .T.
	Endif

	If Type([ThisForm]) <> [O] Then
		Messagebox([USAGE: _Screen.Newobject("oProgressBar","ctl32_progressbar","ctl32_progressbar.vcx")],16)
		Return
	Endif

	If .InStatusBar = .T. And Pcount() = 0 Then
		Return
	Endif

	.ctl32_declaredlls()
	
	If Pcount() > 0 Then
		.ctl32_Parenthwnd = m.tnparenthwnd
	Else
		If Thisform.ShowWindow < 2 Then
			.ctl32_Parenthwnd = Thisform.HWnd
		Else
* find hwnd of "screen" of top level form:

			lpRect = Replicate(Chr(0), 16)
			GetClientRect(ThisForm.HWnd, @lpRect)

			m.lnLeft   = .u_StrToLong(Substr(lpRect,  1,4))
			m.lnTop    = .u_StrToLong(Substr(lpRect,  5,4))
			m.lnRight  = .u_StrToLong(Substr(lpRect,  9,4))
			m.lnBottom = .u_StrToLong(Substr(lpRect, 13,4))
			m.lnLeft
			m.lnTop
			m.lnRight
			m.lnBottom

			m.lnPointy = Int((m.lnBottom - m.lnTop) / 2)
			m.lnPointx = Int((m.lnRight - m.lnLeft) / 2)
			.ctl32_Parenthwnd= ChildWindowFromPoint(ThisForm.HWnd, m.lnPointx, m.lnPointy)
		Endif
	Endif

	If .Parent.BaseClass <> "Form" And .ctl32_Parenthwnd = 0 Then
		Return
	Endif

	If Thisform.Name = _Screen.Name  Or .InStatusBar = .T. Then
		.Visible = .F.
	Endif

	If .SizeAdjust = .T. Then
		If .Orientation = 1 Or .Vertical = .T. Then
			.Height = Round((.Height - 8)/8,0) * 8 + 5
		Else
			.Width = Round((.Width - 5)/8,0) * 8 + 5
		Endif
	Endif

	.ctl32_BindEvents()
	.ctl32_Create()

Endwith


ENDPROC
PROCEDURE Destroy
This.Ctl32_Destroy()



ENDPROC
     �Width = 301
Height = 18
ForeColor = 0,0,0
ctl32_hwnd = 0
ctl32_dwexstyle = 0
ctl32_dwstyle = 0
ctl32_parenthwnd = 0
ctl32_hinstance = 0
minimum = 0
maximum = 100
_memberdata =     3003<VFPData><memberdata name="vertical" type="property" display="Vertical" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).Vertical = NOT gObj(1).Vertical&#xA;&#xA;lnWidth = gObj(1).Height&#xA;lnHeight = gObj(1).Width&#xA;&#xA;gObj(1).Width = lnWidth&#xA;gObj(1).Height = lnHeight&#xA;" favorites="True"/><memberdata name="builderx" type="property" display="BuilderX" script="do home() + &quot;wizards\ctl32_progressbar_builder.app&quot;"/><memberdata name="flat" type="property" display="Flat" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).Flat = NOT gObj(1).Flat" favorites="True"/><memberdata name="marquee" type="property" display="Marquee" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).Marquee = NOT gObj(1).Marquee" favorites="True"/><memberdata name="marqueespeed" type="property" display="MarqueeSpeed" favorites="True"/><memberdata name="maximum" type="property" display="Maximum" favorites="True"/><memberdata name="minimum" type="property" display="Minimum" favorites="True"/><memberdata name="orientation" type="property" display="Orientation"/><memberdata name="parenthwnd" type="property" display="ParenthWnd"/><memberdata name="percent" type="property" display="Percent"/><memberdata name="play" type="property" display="Play" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).Play = NOT gObj(1).Play" favorites="True"/><memberdata name="scrolling" type="property" display="Scrolling"/><memberdata name="sizeadjust" type="property" display="SizeAdjust" favorites="True" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).SizeAdjust = NOT gObj(1).SizeAdjust"/><memberdata name="smooth" type="property" display="Smooth" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).Smooth = NOT gObj(1).Smooth"/><memberdata name="stepit" type="method" display="StepIt"/><memberdata name="builderx" type="property" display="Builderx"/><memberdata name="hwnd" type="property" display="Hwnd"/><memberdata name="step" type="property" display="Step"/><memberdata name="value" type="property" display="Value"/><memberdata name="repeat" type="property" display="Repeat" favorites="True" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).Repeat = NOT gObj(1).Repeat"/><memberdata name="reset" type="method" display="Reset"/><memberdata name="max" type="property" display="Max"/><memberdata name="min" type="property" display="Min"/><memberdata name="themes" type="property" display="Themes" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).Themes = NOT gObj(1).Themes" favorites="True"/><memberdata name="barcolor" type="property" display="BarColor" script="gnobject = Aselobj(gObj)&#xA;&#xA;lnColor = Getcolor(gObj(1).Barcolor)&#xA;&#xA;If lnColor = -1 Then&#xA;  Return&#xA;Endif&#xA;&#xA;gObj(1).Barcolor = lnColor&#xA;" favorites="True"/><memberdata name="backcolor" type="property" favorites="True"/><memberdata name="instatusbar" type="property" display="InStatusBar" script="gnobject = ASELOBJ(gObj)&#xA;&#xA;gObj(1).InStatusBar = NOT gObj(1).InStatusBar "/></VFPData>
step = 1
ctl32_name = ctl32_progressbar
marqueespeed = 100
hwnd = 0
value =     0.00000
percent = 0
parenthwnd = 0
ctl32_hmenu = 0
ctl32_lpparam = 0
ctl32_lpwindowname = ProgressBar
barcolor = -1
max = 0
min = 0
scrolling = 0
orientation = 0
ctl32_oldstep = 0
themes = .T.
ctl32_version = 2.0
ctl32_hwnds = 0
ctl32_left = 0
ctl32_top = 0
ctl32_width = 0
ctl32_height = 0
builderx = (home() + "wizards\ctl32_progressbar.app")
instatusbar = .F.
ctl32_flat = .F.
ctl32_xp = .F.
Name = "ctl32_progressbar"
tdsacknowledge.prg c:\users\rpraja~1.udy\appdata\local\temp\ tdsacknowledge.fxp .\ frmtdsacknowledge.scx frmtdsacknowledge.sct ..\..\vudyogsdk\class\ standardui.vcx standardui.vct ctl32_progressbar.vcx ctl32_progressbar.vct  )   �      =           	�   �  P   S           �  �]  P   i           �]  se     �           se  �     �           �  x�     �           x�  /z    �           