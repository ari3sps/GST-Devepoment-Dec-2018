���    E D                     �~    %                       uP�<    ��  ��  �' %�� \DATEPICKER.CC� Classvf
��B � G~(�
 datepicker� �% %��
 \VOUCLASS.CC� Classvf
��} � G~(� VOUCLASS� � � frmcurrmast��  � U  TNRANGE
 DATEPICKER VOUCLASS FRMCURRMAST0
   m                   PLATFORM   C                  UNIQUEID   C	   
               TIMESTAMP  N   
               CLASS      M                  CLASSLOC   M!                  BASECLASS  M%                  OBJNAME    M)                  PARENT     M-                  PROPERTIES M1                  PROTECTED  M5                  METHODS    M9                  OBJCODE    M=                 OLE        MA                  OLE2       ME                  RESERVED1  MI                  RESERVED2  MM                  RESERVED3  MQ                  RESERVED4  MU                  RESERVED5  MY                  RESERVED6  M]                  RESERVED7  Ma                  RESERVED8  Me                  USER       Mi                                                                                                                                                                                                                                                                                          COMMENT Screen                                                                                              WINDOWS _26N0Q1979 926115298      /  F      ]                          �      �                       WINDOWS _26N0Q197A1018981777�  �          +          h                  
                           WINDOWS _26N0RE50I1018980983I       V   c   l                                                               WINDOWS _26N0Q1979 926767458�       �   �   !  !                                                           WINDOWS _26N0Q197A1018981777�!      �!  �!  �!  "          �"                                               WINDOWS _26N0Q1979 926767458�#      �#  �#  $  $                                                           WINDOWS _26N0Q197A 927045900�$      �$  �$  �$  %                                                           WINDOWS _26N0RE50J 926767458�%      �%  �%  �%  �%                                                           WINDOWS _26N0RE50K 927045900|&      �&  �&  �&  �&                                                           WINDOWS _26N0RE50L1018981777T'      i'  ~'  �'  �'          (                                               WINDOWS _26Z150B82 927045900,      $,  1,  ?,  R,                                                           COMMENT RESERVED                                �,                                                            -%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 VERSION =   3.00      dataenvironment      dataenvironment      Dataenvironment      YTop = 0
Left = 0
Width = 0
Height = 0
DataSource = .NULL.
Name = "Dataenvironment"
      1      1      basefrm      %..\..\u2\usquare\class\standardui.vcx      form      FRMCURRMAST      �DataSession = 1
Height = 104
Width = 304
DoCreate = .T.
BorderStyle = 1
Caption = "Currency Master"
MaxButton = .F.
ncurrid = .F.
stretchflg = .F.
lcmdcurrclk = .F.
curonmouse = .F.
Name = "FRMCURRMAST"
      Vncurrid
stretchflg
lcmdcurrclk
curonmouse
*getlastrecord 
*createcontrolsource 
     ����    �  �                        x�   %   �                          �  U  � ��  � %�C� curr_mast_vw�
���O T�  ��B  select top 1 curr_mast.* from curr_mast order by currencyid desc ��O T� �C� EXE� �  �  � curr_mast_vw� this.parent.nHandle� � � � � �� %�� � ���* T� �C� this.parent.nHandle� � � �� %�� � ��� B�-�� � � ��� %�C� �	 �
����_ T�  ��R  select curr_mast.* from curr_mast where curr_mast.currencyid = ?thisform.ncurrid ��N T� �C� EXE� �  �  � curr_mast_1� this.parent.nHandle� � � � � �� %�� � ��~�* T� �C� this.parent.nHandle� � � �� %�� � ��7� B�-�� � F�
 � %�� � 
� � � 
	��c� � � �C� curr_mast_1&�� � � � F�
 � #6� U  CQUERY MRET THISFORM	 SQLCONOBJ DATACONN COMPANY DBNAME DATASESSIONID SQLCONNCLOSE NCURRID CURR_MAST_VW ADDMODE EDITMODE ALL{ * T�  � � �� curr_mast_vw.currencycd��( T�  � � �� curr_mast_vw.currdesc��& T�  � � �� curr_mast_vw.symbol�� U  THISFORM TXTCURRENCYCD CONTROLSOURCE TXTCURRDESC	 TXTSYMBOLA F�  �
 ��Ca��� #)� F�  � %�C�  � ���v �0 ��C� Currency Code cannot be Empty.�� �x�� ��C� � � �� B�-�� � %�� � ����Z T� ��M Select currencycd From Curr_Mast Where currencycd = ?Curr_Mast_Vw.currencycd ��F T� �C� EXE� �  � � _DupIt� Thisform.nhandle� � � �	 �
 �� %�� � ���� F� � %�C� _DupItN� ����8 ��C�& Currency Code is already been entered.�� �x�� ��C� � � �� B�-�� �' T� �C� thisform.nhandle� �	 � �� %�� � ���� B�-�� � � � F�  �( p� curr_mast_vw�� �� � ���C� ���
 ��Ca��� ��� ��)� T� �� �� H�Y�%� �� � ��,�H T� �C�	 curr_mast� 'currencyid'�  � Curr_Mast_Vw� � �  ��	 � ��? T� �C� EXE� �  � �  � thisform.nhandle� � a��	 �
 �� %�� � ����' T� �C� thisform.nhandle� �	 � �� %�� � ��b�" ��C� RollBack Error!!�� �x�� B�-�� �. ��C� Error Occured While Saving!!�� �x�� B�-�� �(�r T� �C� EXE� � �/ select ident_current('curr_mast') as currencyid� Code� thisform.nHandle� � � �	 �
 �� T� � �� � �� � �� � ��%�n T� �C�	 curr_mast� 'currencyid','currencycd'�  � Curr_Mast_Vw� � � currencyid = C�  � _�  ��	 � ��? T� �C� EXE� �  � �  � thisform.nhandle� � a��	 �
 �� %�� � ����' T� �C� thisform.nhandle� �	 � �� %�� � ��[�" ��C� RollBack Error!!�� �x�� B�-�� �. ��C� Error Occured While Saving!!�� �x�� B�-�� �!�r T� �C� EXE� � �/ select ident_current('curr_mast') as currencyid� Code� thisform.nHandle� � � �	 �
 �� T� � �� � �� � � �� %�� � ����' T� �C� thisform.nhandle� �	 � �� %�� � ��}� B�-�� ���  ��C� Entry Saved�@� ��x�� �' T� �C� thisform.nhandle� �	 � �� � ��� ��-� ��C-�� �� T��  �a�� T��! �a�� T�� �-�� T�� �-�� ��C�" �# �$ �� �� ��C� �% �� U&  CURR_MAST_VW
 CURRENCYCD VUMESS THISFORM TXTCURRENCYCD SETFOCUS ADDMODE LCSTR MRET	 SQLCONOBJ DATACONN COMPANY DBNAME DATASESSIONID _DUPIT SQLCONNCLOSE COMPID
 LNHSHANDLE LCINSSTR	 GENINSERT PLATFORM RB _SQLROLLBACK MLNCODE NCURRID CODE
 CURRENCYID EDITMODE	 GENUPDATE CM
 _SQLCOMMIT	 ACT_DEACT DELETEBUTTON PRINTBUTTON
 TBRDESKTOP BTNBTM CLICK REFRESHH< T�  �C�% Do you want to delete this Currency ?�$� �x�� %��  ���T � B�-�� � F� � T� �� � ��G T� ��4 select currencyid From curr_rate Where currencyid = C� _��A T� �C� EXE�
 �  � �  � thisform.nhandle� � a� � �	 �� %�� � ��S�D ��C�2 Error occured while deleting details Information!!�� �x�� B�-�� �< T� ��) Delete From curr_mast Where currencyid = C� _��A T� �C� EXE�
 �  � �  � thisform.nhandle� � a� � �	 �� %�� � ��0�D ��C�2 Error occured while deleting details Information!!�� �x�� B�-�� � %�� � ����' T� �C� thisform.nhandle� � � �� %�� � ���� B�-�� ���" ��C� Entry Deleted�@� ��x�� �' T� �C� thisform.nhandle� � � �� � ��� ��A� ��C-�� �� T�� �a�� T�� �a�� T�� �-�� T�� �-�� ��C� � � �� ��C�� �� �� U  YESNO VUMESS CURR_MAST_VW MCURRID
 CURRENCYID CSELESTR NRET THISFORM	 SQLCONOBJ DATACONN COMPANY DBNAME DATASESSIONID CDELESTR CM
 _SQLCOMMIT MRET SQLCONNCLOSE	 ACT_DEACT DELETEBUTTON PRINTBUTTON ADDMODE EDITMODE
 TBRDESKTOP BTNBTM CLICK REFRESH� ' ��Caaaa--� � � � � � ---aa�  �� T� � �-�� T� � �-�� F� �
 ��Ca��� ��� ��� � ��C� �	 �
 �� T�� �-�� T�� �-�� �� ��C� � �� ��C� � �� U  BARSTAT THISFORM	 ADDBUTTON
 EDITBUTTON DELETEBUTTON ADDMODE EDITMODE CURR_MAST_VW
 TBRDESKTOP BTNBTM CLICK GETLASTRECORD REFRESHf  T�  � �a�� T�  � �-�� ��Ca�  � �� F� �	 � � T� �� �� �
 ��Ca��� ��C�  � �� U	  THISFORM ADDMODE EDITMODE	 ACT_DEACT CURR_MAST_VW ALL LCCURRID
 CURRENCYID REFRESH�  ��  � ��� ��� �# T�� � �� � Bmp\loc-on.Gif��$ T�� � �� � Bmp\loc-Off.Gif�� T�� � ��  �� T�� � ��  �� T�� � ��  
�� T��	 �
 ��  �� �� %�� � -��� � T� � � ��  �� �� � T� � � �-�� � U  LACT THISFORM CMDCURRENCY PICTURE APATH DISABLEDPICTURE TXTCURRDESC ENABLED	 TXTSYMBOL LABEL4 VISIBLE EDITMODE TXTCURRENCYCD�  %��  � 
� �  � 
	��~ � %�C� curr_mast_vw���z � %��  � 
��[ � T�  � �� � �� � T�  � �-�� ��C�  � �� � �	 ��C��� U  THISFORM ADDMODE EDITMODE LCMDCURRCLK NCURRID CURR_MAST_VW
 CURRENCYID GETLASTRECORD ��  � T� ��  �� T� � �-�� ��� ��� � T�� �� Curr_Mast_Vw�� T�� ��	 Curr_Mast�� T�� ��
 CurrencyId�� T�� �-�� T�� �-�� ��C��	 �� ��C �  � � ��
 � �� �� G�(��  �� %�C� TbrToolsb� O��� � T� � �-�� � ��C-� � �� U  TNRANGE LRANGE THISFORM
 STRETCHFLG	 MAINALIAS MAINTBL MAINFLD ADDMODE EDITMODE CREATESTDOBJECTS	 SQLCONOBJ ASSIGNEDRIGHTS DATASESSIONID TBRTOOLS VISIBLE	 ACT_DEACT� 	 ��C��� %��  � -��F � T�  � �a�� ��C� � � �� ��C�  � �� � %��  � 
� �  � 
	��� �' ��Caaaa--�  �	 �  �
 �  � ---aa� �� �� � ��C------aa----aa� �� � U  THISFORM
 STRETCHFLG
 TBRDESKTOP BTNBTM CLICK CREATECONTROLSOURCE ADDMODE EDITMODE BARSTAT	 ADDBUTTON
 EDITBUTTON DELETEBUTTON:  T�  � �-�� T�  � �a�� ��Ca�  � �� ��C�  � �� U  THISFORM ADDMODE EDITMODE	 ACT_DEACT REFRESH getlastrecord,     �� createcontrolsourceS    �� saveit    �� delete�    �� cancel-    �� addnewg    ��	 act_deact+    �� Refresh�    �� Init�    �� ActivateE    �� modify�    ��1 q ����q A A � 1���q A q �Q A qA A A q Q 4 ��a2 s � Q r !q A �aq ��q A qq A A A t �� � � � ��q!q A �q � !1A ��q!q A �q � !1A B A qq � A qA � � � � � � A � 3 �q A r rAq A �Aq A qq � !A qA � � � � � � � A 4 q� � q � � � � A � � 5 � � � q � � Q � � 4 q � 1A!A $1� A 4 ��1A � � A A � 3 q � � � �q�� � � �A � �� A � 3 � !� � A �q� �A 3 � � � � 2  )   �                        shape      shape      w      FRMCURRMAST      \Top = 1
Left = 1
Height = 102
Width = 302
BackStyle = 0
SpecialEffect = 0
Name = "w"
      label      label      Label1      FRMCURRMAST      �AutoSize = .T.
FontBold = .T.
FontSize = 8
BackStyle = 0
Caption = "Currency Code"
Height = 16
Left = 14
Top = 15
Width = 85
TabIndex = 1
Name = "Label1"
      textbox      textbox      txtcurrencycd      FRMCURRMAST      �FontSize = 8
Format = "!@"
Height = 23
Left = 113
MaxLength = 4
SpecialEffect = 1
TabIndex = 2
Top = 12
Width = 161
BorderColor = 128,128,128
Name = "txtcurrencycd"
     ���    �   �                         u   %   �                           �  U  W  F�  � %�C�  � ���P �0 ��C� Currency Code Cannot be Empty.�� �x�� B�-�� � U  CURR_MAST_VW
 CURRENCYCD VUMESS Valid,     ��1 q !q A 2  )   �                         label      label      Label2      FRMCURRMAST      �AutoSize = .T.
FontBold = .T.
FontSize = 8
BackStyle = 0
Caption = "Description"
Height = 16
Left = 14
Top = 42
Width = 65
TabIndex = 3
Name = "Label2"
      textbox      textbox      txtcurrdesc      FRMCURRMAST      �FontSize = 8
Height = 23
Left = 113
SpecialEffect = 1
TabIndex = 4
Top = 39
Width = 161
BorderColor = 128,128,128
Name = "txtcurrdesc"
      label      label      Label3      FRMCURRMAST      �AutoSize = .T.
FontBold = .T.
FontSize = 8
BackStyle = 0
Caption = "Symbol"
Height = 16
Left = 14
Top = 69
Width = 43
TabIndex = 5
Name = "Label3"
      textbox      textbox      	txtsymbol      FRMCURRMAST      �FontSize = 8
Height = 23
Left = 113
SpecialEffect = 1
TabIndex = 6
Top = 66
Width = 161
BorderColor = 128,128,128
Name = "txtsymbol"
      commandbutton      commandbutton      cmdcurrency      FRMCURRMAST      oTop = 12
Left = 276
Height = 23
Width = 23
FontSize = 8
Caption = ""
TabIndex = 7
Name = "cmdcurrency"
     ����    �  �                        �   %   {                          �  U  { ��  � � � � � � T� ��  ��u T� ��h Select currencycd as Curr_Code, currdesc as [Desc], symbol, currencyid From curr_mast order by curr_code��L T� �C� EXE�	 �
  � � Cur_currmast� THISFORM.nHandle� � � � � �� %�� � ��� ��CCE�� �x�� B�-�� �* T� �� SELECT : Currency Master Code��� T�  �C� Cur_currmast � � curr_code+desc�
 currencyid�  �  �  �  -�  �  curr_code,Desc,symbol,currencyid�6 curr_code:Currency Code,Desc:Description,symbol:Symbol�
 currencyid� �� F� � T� � ��  ��' T� �C� thisform.nHandle� � � �� %�C� Cur_currmast���Y� Q� � � T� � �a�� ��C� � �� U  RETITEM CSQLSTR NRETVAL MRET LCCATION	 LCIT_NAME THISFORM	 SQLCONOBJ DATACONN COMPANY DBNAME DATASESSIONID VUMESS UEGETPOP CURR_MAST_VW NCURRID SQLCONNCLOSE CUR_CURRMAST LCMDCURRCLK REFRESH Click,     ��1 �� Q�q A ��s r�� A � � 2  )   �                        label      label      Label4      FRMCURRMAST      �AutoSize = .T.
FontBold = .T.
FontSize = 15
BackStyle = 0
Caption = "*"
Height = 27
Left = 101
Top = 13
Width = 10
ForeColor = 255,0,0
Name = "Label4"
      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
0
	   m                   PLATFORM   C                  UNIQUEID   C	   
               TIMESTAMP  N   
               CLASS      M                  CLASSLOC   M!                  BASECLASS  M%                  OBJNAME    M)                  PARENT     M-                  PROPERTIES M1                  PROTECTED  M5                  METHODS    M9                  OBJCODE    M=                 OLE        MA                  OLE2       ME                  RESERVED1  MI                  RESERVED2  MM                  RESERVED3  MQ                  RESERVED4  MU                  RESERVED5  MY                  RESERVED6  M]                  RESERVED7  Ma                  RESERVED8  Me                  USER       Mi                                                                                                                                                                                                                                                                                          COMMENT Class                                                                                               WINDOWS _20E0O8ZGW 911629295      $  0      @          �          F  S  \          �               COMMENT RESERVED                        �                                                                 WINDOWS _20E0O8ZGW 913667855.      :  F      U          �          ,	  9	  B	          s               COMMENT RESERVED                        <      K                                                           WINDOWS _20T0ZFDV9 914658114t      �  �      �          2          |  �  �          	             WINDOWS _20T0ZFE2M 914658114e      r    �  �                                                           WINDOWS _20T0ZFE4D 914658114[  t  �  �  �  �                                                           COMMENT RESERVED                        �                                                                  7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 VERSION =   3.00      form      form      standfrm      �DataSession = 2
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
      Class      1      Ynhandle SQL - Connection handle
ofrmfrom Main form property object
*createstdobjects 
      Pixels     "���    	  	                        �!   %   �                          �  U  � ���  ����% %�C� Thisform.ofrmfromb� O��?� T�� ��� � �� %��� � � �� � ��� �  ��C� enableda� textbox�� ��! ��C� enableda� checkbox�� ��! ��C� enableda� combobox�� �� �,�  ��C� enabled-� textbox�� ��! ��C� enabled-� checkbox�� ��! ��C� enabled-� combobox�� �� � G�(��� � �� �& ��C�	 sqlconobj� sqlconnudobj�� ��# ��C� _stuffObject� _stuff�� �� ��C�� �	 �� T��
 �� �� �� U  THISFORM	 BACKCOLOR OFRMFROM EDITMODE ADDMODE SETALL DATASESSIONID	 ADDOBJECT _STUFFOBJECT _OBJECTPAINT ICON ICOPATH  ��C--------------�  �� U  BARSTAT createstdobjects,     �� Activate^    ��1 � Q!�� A � A a1� � A 3 �2  )   	                        standfrm      !Arial, 0, 9, 5, 15, 12, 32, 3, 0
      form      form      basefrm     �DataSession = 2
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
      Class      1     )nhandle SQL - Connection handle
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
      Pixels     ����    �  �                        �W   %   t                          �  U  �  ���  ��� � %�C� Companyb� O��h � T�� �C� � g�� T�� �� � �� T�� �� �� T�� ��	 �� � ��C��
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
 stdqunload�    �� defaenv�    �� Activate    �� QueryUnloadJ    ��1 � �1� � A � a1� A 3 A3 � a�� �A � A � A 3 �A q A A q A �A 3 a � a a a a a � � A 4 � 2 � 2  )   �                        basefrm      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      form      form      frmpbar     �Height = 59
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
      Class      3      oshowprogress
lblcation
*initproc 
*progressbarexec 
*cleaprogressbar 
*showpbar 
*incpbar 
*setcation 
      Pixels      Progress bar class     +���                              ��	   %   �                          �  U  5  G]� ��C� Please wait...!�  � �� ��C�  � �� U  THIS	 SETCATION SHOWPBAR�  4�  � %��  �d��% � ��C� � �� �� � %�� � -��� � T� � � �� � � �  �� �� ���(��d������y � �� ��C� � �� � � U  MVALUE THIS CLEAPROGRESSBAR SHOWPROGRESS CTL32_PROGRESSBAR1 VALUE A REFRESH  T�  � �a�� ��C�  � �� U  THIS SHOWPROGRESS RELEASE  T�  � �a�� U  THIS VISIBLEO ! ��  Q� INTEGER� Q� INTEGER� �� ��  �(�� ��H � ��C�� � �� �� U  FNUM SNUM I THIS PROGRESSBAREXEC  ��  � T� � � ��  �� U  LABLCAPTION THIS LBLINFO CAPTION)  T�  � ��  � �� T�  � ��  � �� U  THIS MINWIDTH WIDTH	 MINHEIGHT HEIGHT  U  	  G] � U   initproc,     �� progressbarexec�     �� cleaprogressbarm    �� showpbar�    �� incpbar�    ��	 setcationI    �� Load�    �� Init�    �� Release�    ��1 a �� 3 q � � !��A � A A 3 � � 3 � 3 qA 3 q 13 114 4 a 1  )                           label      label      Lblinfo      frmpbar      �AutoSize = .T.
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
      ctl32_progressbar      ctl32_progressbar.vcx      control      Ctl32_progressbar1      frmpbar     .Top = 26
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
      frmpbar      !Arial, 0, 9, 5, 15, 12, 32, 3, 0
GIF89a  �  ���oooiii�����񥥥eee�Y���\\\���������������������ddd�����׊��yyyggg�����𠠠������fff�������Ѽ�[���{{{������bbbulhccc�������|�q^�����崴�����c��ֶ�����zzz�X����������ͷ�\}}}kkk���������������곗����������p����_sss��������љ���}t������                                                                                                                                             !�     ,       �� �� 
2"4��?3 M�L� +�N#��-FB
�&H>�@A5*K��J(9:0�)%��1D !C'��E=8	�ׂ�ւO$�Ȃ,<�� $��Anh Ta�)8�4��"AG"�H�E (\�Ȉ�2�*	  ;0
   m                 d  PLATFORM   C                  UNIQUEID   C	   
               TIMESTAMP  N   
               CLASS      M                  CLASSLOC   M!                  BASECLASS  M%                  OBJNAME    M)                  PARENT     M-                  PROPERTIES M1                  PROTECTED  M5                  METHODS    M9                  OBJCODE    M=                 OLE        MA                  OLE2       ME                  RESERVED1  MI                  RESERVED2  MM                  RESERVED3  MQ                  RESERVED4  MU                  RESERVED5  MY                  RESERVED6  M]                  RESERVED7  Ma                  RESERVED8  Me                  USER       Mi                                                                                                                                                                                                                                                                                          COMMENT Class                                                                                               WINDOWS _RH20ODKH7 829973796      '  6      A  m      �          =  J  S          _  m           COMMENT RESERVED                        zA      �A                                                           WINDOWS _18U0KAIDG 898206562�A  �A  �A  �A      B          lC          �B   C              	C  C           COMMENT RESERVED                        G      3G                                                           WINDOWS _1BQ0V2Q49 990816268\G      lG  |G      �G          �I          �H  �H  �H          HI  VI           COMMENT RESERVED                        UO      eO                                                           WINDOWS _18M0PPFE5 992180802�O      �O  �O      �O          &R          Q  Q  'Q          �Q  �Q           WINDOWS _1U1135DF3 992180802Y[      k[  }[  �[  �[          3f  �[  �e                                       COMMENT RESERVED                        �l      �l                                                           WINDOWS _RH20ODKH71000242458�l      �l  �l      m  r      �w          �r  �r  �r          �w  �w           COMMENT RESERVED                        -�      8�                                                            �b                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 VERSION =   3.00      textbox      textbox      tpk     $FontName = "Tahoma"
FontSize = 8
Alignment = 3
Value = (DATETIME())
Height = 22
Width = 115
NullDisplay = "(undefined)"
currentdatetime = 
lallowblankdate = .T.
datetype = 2
datepartinitfocus = 2
yearsellength = 4
daystart = 0
dayend = 1
monthstart = 3
monthend = 4
yearstart = 6
yearend = 9
lexitontabonly = .T.
calendar_form_ref = .NULL.
cbbutton_name = 
_memberdata = <?xml version="1.0" encoding="Windows-1252" standalone="yes"?><VFPData><memberdata name="cbbutton_name" type="property" display="cbButton_name" favorites="True"/><memberdata name="comboformref" type="property" display="comboFormRef"/></VFPData>
ampmstart = 20
hourend = 12
hourstart = 11
minuteend = 15
minutestart = 14
secondend = 18
secondstart = 17
blankdatetimestring = 19000101000000
Name = "tpk"
      �currentdatetime
daystart
dayend
monthstart
monthend
yearstart
yearend
hourend
hours24format
hourstart
minuteend
minutestart
secondend
secondstart
setyearsellength
setstartendpositions
      Class      1     currentdatetime DateTime on field entry
lallowblankdate Allow blank dates
datetype Date Type 1-{mm/dd/yy},{mm-dd-yy},{mm.dd.yy}, 2-{dd/mm/yy},{dd-mm-yy},{dd.mm.yy}, 3-(yy/mm/dd),(yy-mm-dd),(yy.mm.dd)
datepartinitfocus Date part highlighted when control receives focus: 1- Month (default), 2-Day, 3-Year
yearsellength Selected length of the year ( 2 or 4 )
daystart Day Start position
dayend Day end position
monthstart Month start position
monthend Month end position
yearstart Year start position
yearend Year end position
lupdowndisabled Flag indicating whether the Up / Down arrow keys are disabled ( +/- functionality only )
lexitontabonly Exit the control only on (Shift+)Tab
calendar_form_ref referinta la formul cu calendar
cbbutton_name
_memberdata XML Metadata for customizable properties
ampmstart
hourend
hours24format
hourstart
minuteend
minutestart
secondend
secondstart
blankdatetimestring
*datepartinitfocus_assign 
*setyearsellength Sets the year selected length
*setstartendpositions Sets the Day, Month and Year Start and End positions
*lupdowndisabled_assign 
*lexitontabonly_assign 
*dropdown Show the calendar form
*width_assign 
*height_assign 
*left_assign 
*top_assign 
*visible_assign 
*enabled_assign 
*readonly_assign 
      Pixels      -Textbox only from DatePicX classlib, modified     5����    �5  �5                         ^   %   �.                          �  U  :  ��  � %�C��  ������3 � T� � ���  �� � U  VNEWVAL THIS DATEPARTINITFOCUS�  ���  ��� � H� �� � ��� � ��: � T�� ���� ��� ���Z � T�� ���� ��� ���� � %�C� CENTURYv� ON��� � T�� ���� �� � T�� ���� � � �� U  THIS CENTURY YEARSELLENGTHD ���  ��=� H� �	� ��� ���� � T�� ���� T�� ���� T�� �� �� T�� ���� T�� ���� T�� ���� %��� ���� � T�� ��� ��� � ��� ���8� T�� �� �� T�� ���� T�� ���� T�� ���� T�� ���� T�� ���� %��� ���4� T�� ��� ��� � 2�	� T�� �� �� T�� ���� T�� ���� T�� ���� T�� ���� T�� ���� %��� ���� T�� ��� ��� T�� ��� ��� T�� ��� ��� T�� ��� ��� T�� ��� ��� � � T��	 ��	�� T��
 ���� T�� ���� T�� ���� T�� �-�� %��� ����� T��	 ���	 ��� T��
 ���
 ��� T�� ��� ��� T�� ��� ��� � T�� ���	 ��� T�� ���
 ��� T�� ��� ���2 %��� �� �� � � C� HOURSv�	��9� T�� ��� �� T�� �a�� � �� U  THIS DATETYPE DAYSTART DAYEND
 MONTHSTART MONTHEND	 YEARSTART YEAREND YEARSELLENGTH	 HOURSTART MINUTESTART SECONDSTART	 AMPMSTART HOURS24FORMAT HOUREND	 MINUTEEND	 SECONDEND HOURS5  ��  � %�C�  ��� L��. � T� � ���  �� � U  VNEWVAL THIS LUPDOWNDISABLED7  ��  � %�C��  ��� L��0 � T� � ���  �� � U  VNEWVAL THIS LEXITONTABONLY�  %��  � ���D �0 T� � �C� calendar_Form_desktop �  �  �N�� �t �( T� � �C� calendar_Form �  �  �N�� � T� � � �a�� ��C� � � �� U  THISFORM
 SHOWWINDOW THIS CALENDAR_FORM_REF ALWAYSONTOP SHOWe  ��  � %��  � � ��^ � T� � ��  ��" T� �C� this.parent.� � ��� ��C � � � �� � U  VNEWVAL THIS WIDTH
 OBUTTONREF CBBUTTON_NAME SETPOSITIONANDSIZEe  ��  � %��  � � ��^ � T� � ��  ��" T� �C� this.parent.� � ��� ��C � � � �� � U  VNEWVAL THIS HEIGHT
 OBUTTONREF CBBUTTON_NAME SETPOSITIONANDSIZEe  ��  � %��  � � ��^ � T� � ��  ��" T� �C� this.parent.� � ��� ��C � � � �� � U  VNEWVAL THIS LEFT
 OBUTTONREF CBBUTTON_NAME SETPOSITIONANDSIZEe  ��  � %��  � � ��^ � T� � ��  ��" T� �C� this.parent.� � ��� ��C � � � �� � U  VNEWVAL THIS TOP
 OBUTTONREF CBBUTTON_NAME SETPOSITIONANDSIZEd  ��  � %��  � � ��] � T� � ��  ��" T� �C� this.parent.� � ��� T� � ��  �� � U  VNEWVAL THIS VISIBLE
 OBUTTONREF CBBUTTON_NAMEp  ��  � %��  � � ��i � T� � ��  ��" T� �C� this.parent.� � ��� T� � ��  �	 � � -	�� � U  VNEWVAL THIS ENABLED
 OBUTTONREF CBBUTTON_NAME READONLYr  ��  � %��  � � ��k � T� � ��  ��" T� �C� this.parent.� � ��� T� � ��  
�
 � � -
	�� � U  VNEWVAL THIS READONLY
 OBUTTONREF CBBUTTON_NAME ENABLEDs  %�C�  � ��� D��l � %�CC�  � ��g�  � ��J � T�  � ��  � �� �h � T�  � ��  � � �� � � U  THIS VALUE BLANKDATETIMESTRING	 FORECOLOR	 BACKCOLOR PARENT  ��C�  � �� U  THIS SETFOCUSO ���  ��H� %�C�� ������ � H�0 �� � ��� ���P � T�� ���� ��� ���q � T�� ��� �� �C�� �� �� �� ���� � T�� ���� � �� �# %�C�� �� ��	 � �� �� ���� � T�� ���� � � %�C�  �
 ��� D��D� %�CC�  �
 ��g�  � ��&� T�� ��� �� �@� T�� ��� � �� � � �� U  THIS DATETYPE SELSTART	 SELLENGTH YEARSELLENGTH	 HOURSTART MINUTESTART SECONDSTART
 MONTHSTART DAYSTART VALUE BLANKDATETIMESTRING	 FORECOLOR	 BACKCOLOR PARENT" ��  � � ��� ��� H�% �� ��  � ��p � �� %��� ��L � B� � T�� �C$�� ��� � ��C�� �� ��  ���� � �� %��� ��� � B� � T�� ��� �� ��� � ��C�� �� ��  ����� %��� ��� � �� B� � %��� ����� H���� ���	 ��
 ��;� �� T��	 ���
 �� T�� ����  ���	 �� �
 ��	 �� 	��|� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��?� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ���� ���	 �� ���� �� %��� 
���� \�� {TAB}�� � 2��� �� � ��� H����� ���	 ���� �� T��	 ���� T�� ���� ���	 ��	 ��	 �	��N� �� T��	 ���� T�� ��� ��  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��R� �� T��	 ��� �� T�� ���� ���	 �� ���� �� %��� 
���� \�� {TAB}�� � 2��� �� � � ��  ����� %��� ���� �� B� � %��� ����� H����� ��� �
 ��	 �� 	��$� �� T��	 ��� �� T�� ���� ���	 �� ��X� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��\� �� T��	 ���
 �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 �� �� T�� ��� �� ���	 ��
 ���� �� %��� 
���� \��	 {BACKTAB}�� � 2��� �� � ��� H����� ��� �
 ��	 �� 	��:� �� T��	 ��� �� T�� ���� ���	 �� ��n� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� �� T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��2� �� T��	 ��� �� T�� ��� �� ���	 ��
 ��	 �� 	��q� �� T��	 ���� T�� ���� ���	 ��	 ��	 �	���� �� T��	 �� �� T�� ���� ���	 ����� �� %��� 
���� \��	 {BACKTAB}�� � 2��� �� � � �C�  ��+�=���w� ��# %��� � �  �	� �� ��A	� B� � H�R	�s� ��� ���	� H�q	�� ���	 ����	�( T�� ��� CC�� ��CC�� ����� ��� � T��	 �� �� T�� ���� ���	 ��	 ��	 �	��'
� T�� ��� ��Q �� ��� � T��	 ���� T�� ���� ���	 ��
 ��	 �� 	���
�( T�� ��� CC�� ��CC�� ����� ��� � T��	 ���� T�� ��� ��  ���	 �� �
 ��	 �� 	���
� T�� ��� ��� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��D� T�� ��� �<�� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� T�� ��� ��� ��� � T��	 ��� �� T�� ���� ���	 �� ����% T�� ��� C�� � �� ���  6�� ��� � T��	 ��� �� T�� ���� 2�� �� � ��� ����� H�(��� ���	 ���t� T�� ��� ��Q �� ��� � T��	 �� �� T�� ���� ���	 ��	 ��	 �	����( T�� ��� CC�� ��CC�� ����� ��� � T��	 ���� T�� ���� ���	 ��
 ��	 �� 	��J�( T�� ��� CC�� ��CC�� ����� ��� � T��	 ���� T�� ��� ��  ���	 �� �
 ��	 �� 	���� T�� ��� ��� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� T�� ��� �<�� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��S� T�� ��� ��� ��� � T��	 ��� �� T�� ���� ���	 �� ����% T�� ��� C�� � �� ���  6�� ��� � T��	 ��� �� T�� ���� 2��� �� � 2�s� H���o� ���	 ��
 ��5�( T�� ��� CC�� ��CC�� ����� ��� � T��	 �� �� T�� ��� ��  ���	 �� �
 ��	 �� 	����( T�� ��� CC�� ��CC�� ����� ��� � T��	 ���
 �� T�� ����  ���	 �� �
 ��	 �� 	���� T�� ��� ��Q �� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��V� T�� ��� ��� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� T�� ��� �<�� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��� T�� ��� ��� ��� � T��	 ��� �� T�� ���� ���	 �� ��c�% T�� ��� C�� � �� ���  6�� ��� � T��	 ��� �� T�� ���� 2�o� �� � � �C�  ��-����� ��# %��� � �  �	� �� ���� B� � H����� ��� ����� H���~� ���	 ���F�) T�� ��� CC�� ��CC�� ������� ��� � T��	 �� �� T�� ���� ���	 ��	 ��	 �	���� T�� ��� ��Q �� ��� � T��	 ���� T�� ����  ���	 �� �
 ��	 �� 	���) T�� ��� CC�� ��CC�� ������� ��� � T��	 ���� T�� ��� ��  ���	 �� �
 ��	 �� 	��e� T�� ��� ��� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� T�� ��� �<�� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��� T�� ��� ��� ��� � T��	 ��� �� T�� ���� ���	 �� ��r�% T�� ��� C�� � �� ���  6�� ��� � T��	 ��� �� T�� ���� 2�~� �� � ��� ���<� H���8� ���	 ����� T�� ��� ��Q �� ��� � T��	 �� �� T�� ���� ���	 ��	 ��	 �	��X�) T�� ��� CC�� ��CC�� ������� ��� � T��	 ���� T�� ����  ���	 �� �
 ��	 �� 	����) T�� ��� CC�� ��CC�� ������� ��� � T��	 ���� T�� ��� ��  ���	 �� �
 ��	 �� 	��� T�� ��� ��� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��w� T�� ��� �<�� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� T�� ��� ��� ��� � T��	 ��� �� T�� ���� ���	 �� ��,�% T�� ��� C�� � �� ���  6�� ��� � T��	 ��� �� T�� ���� 2�8� �� � 2��� H�Q��� ���	 ��
 ����) T�� ��� CC�� ��CC�� ������� ��� � T��	 �� �� T�� ��� ��  ���	 �� �
 ��	 �� 	�� �) T�� ��� CC�� ��CC�� ������� ��� � T��	 ���
 �� T�� ����  ���	 �� �
 ��	 �� 	��{� T�� ��� ��Q �� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� T�� ��� ��� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	��,� T�� ��� �<�� ��� � T��	 ��� �� T�� ����  ���	 �� �
 ��	 �� 	���� T�� ��� ��� ��� � T��	 ��� �� T�� ���� ���	 �� ����% T�� ��� C�� � �� ���  6�� ��� � T��	 ��� �� T�� ���� 2��� �� � � ��  ���>� %��� � �� 
��&� �� B� � T�� ��        ��3 ��  �/� �  �<	� C�  �A�a�P�p����� %��� ���� �� B� � �C�  �	������ ��  ����� ��  ����� ��  �����( ��  ���	 �  ���� �  ����� ��C� � �� 2�� �� � �� U  NKEYCODE NSHIFTALTCTRL THIS READONLY VALUE REFRESH SETFOCUS CURRENTDATETIME DATETYPE SELSTART
 MONTHSTART	 SELLENGTH YEAREND DAYSTART MONTHEND	 HOURSTART DAYEND MINUTESTART HOUREND SECONDSTART	 MINUTEEND	 AMPMSTART LEXITONTABONLY YEARSELLENGTH	 YEARSTART HOURS24FORMAT	 SECONDEND LUPDOWNDISABLED LALLOWBLANKDATE DROPDOWN�  ��  � � ��� ��� � ��C�� �� ��C�� �� T�� ��� �� H�J �� � ��� ���w � T� ���� T�  ��� �� ��� ���� � T� ���	 �� T�  ���
 �� 2�� � T� ���� T�  ��� �� � T�� ��  �� T�� �� �� �� U  LNSTART LNLENGTH THIS SETYEARSELLENGTH SETSTARTENDPOSITIONS CURRENTDATETIME VALUE DATEPARTINITFOCUS DAYSTART YEARSELLENGTH	 YEARSTART
 MONTHSTART SELSTART	 SELLENGTHb  %�C�  � ���0 � %��  � 
��, �	 B�� �� � �[ � %�C�  � i� ��W �	 B�� �� � � U  THIS VALUE LALLOWBLANKDATE�  ���  ��� � ��C�� �� ��C�� �� T�� �C��]��' %�C�� � � Toolbar� Column�
��� �' ��C�� � cbButton�  �   �  �� � �� T� �C� .parent.�� ��� ��C �  � � �� T� �	 ��  �	 �� � �� U
  THIS SETYEARSELLENGTH SETSTARTENDPOSITIONS CBBUTTON_NAME PARENT	 BASECLASS	 NEWOBJECT LOBTN SETPOSITIONANDSIZE VISIBLE datepartinitfocus_assign,     �� setyearsellength�     �� setstartendpositionsi    �� lupdowndisabled_assignq    �� lexitontabonly_assign�    �� dropdown$    �� width_assign    �� height_assign�    �� left_assignc    ��
 top_assign	    �� visible_assign�	    �� enabled_assignW
    �� readonly_assign    �� Refresh�    �� Clickr    �� InteractiveChange�    �� KeyPress�    �� GotFocus+    �� Valid�,    �� Init8-    ��1 q �!A 2 � � !� "� "�� � � A A A 3 � � !� � � � � � "1A "� � � � � � "1A � � � � � � � "11111A A � � � � � "1111A 211"� � A B 3 q R!A 3 q r!A 3 A� �A 3 q B!A 3 q B!A 3 q A!A 3 q B!A 3 q A!B 3 q A!�A 3 q A!�A 3 ��1� aA A 3 � 2 � a� !� "� �� A � 1� A A ��� � !A A A 3 � � � A � A A � � � A � A A � � � � A A A !� 1A � � A � � A � � A � � A � � A � � 2A � � A � A A � � !A � � �A � � A � � A � � A � � A � � 2A � � A � A A A � A A A !� �A � � 2A � � A � � A � � A � � A � � A � � 2A � !A � A A � � �A � � 2A � � A � � A � � A � � �A � � �A � � "A � !A � A A A �A 1A A � !� !�� � � �a� � � ��� � � A� � � 1� � � 1� � � 2Q� � � � A A "� !a� � � ��� � � ��� � � A� � � 1� � � 1� � � 2Q� � � � A A � � 1�� � � �� � � a� � � A� � � 1� � � 1� � � 2Q� � � � A A A RA 1A A � !� !�� � � �a� � � �� � � A� � � 1� � � 1� � � 2Q� � � � A A "� !a� � � ��� � � �� � � A� � � 1� � � 1� � � 2Q� � � � A A � � 1�� � � �� � � a� � � A� � � 1� � � 1� � � 2Q� � � � A A A �A A A A2� A A A R"""�� � A A A 3 � � � � � � !� � "� � � � � A � � A 3 !� A � a� A A 3 � � � qq�1A A 2  )   �5                        tpk      "Tahoma, 0, 8, 5, 13, 11, 21, 2, 0
      calendar_form      datepicker.vcx      form      calendar_form_desktop      �Desktop = .T.
DoCreate = .T.
WindowType = 1
AlwaysOnTop = .F.
Name = "calendar_form_desktop"
oleMonthView.Top = 0
oleMonthView.Left = 0
oleMonthView.Height = 144
oleMonthView.Width = 148
oleMonthView.Name = "oleMonthView"
      Class      1      Pixels      Mcalendar form with Desktop = .T., instantiated when parent is top level form.     ����    �  �                        /{   %                             �  U  " ��  � � � T� � ��  �� T� �  ��  �� T� � �� �� %�C�	 ToformRefb� O��o � T� � �� � �� �  %�C� toTextboxRefb� O��� � T� �  ��  � �� �( %�C� toformRef.curonmouseb� L��� � T� � �a�� � %�C�  �� C�  ��� O��� B� � �� � T� �C� �	 �� ��� ��� T��
 ��  �� T�� ���
 � ��" %�C��
 � �
� C��
 � �
	���� T� � � �C��
 � i�� T� � � �C��
 � H�� T� � � �C��
 � %�� � G1 �2 T�� ���
 � C��
 ��]C��%C�	�%� � ��# T�� �C��
 ��]C��%� � �� �� U  TOTEXTBOXREF	 TOFORMREF _DPKNAME THISFORM DPKNAME NAME
 CURONMOUSE OTOPLEVELFORM THIS GETTOPLEVELFORM
 TEXTBOXREF OLDVALUE VALUE OLEMONTHVIEW YEAR MONTH DAY TOP HEIGHT LEFT Init,     ��1 � �1A 1A �� A �A A q � � !"���A a $1PA 2  )   �                        calendar_form_desktop      !Arial, 0, 9, 5, 15, 12, 32, 3, 0
      combobox      combobox      cbbutton     <Height = 22
Width = 21
_memberdata = <?xml version="1.0" encoding="Windows-1252" standalone="yes"?><VFPData><memberdata name="odatetextbox" type="property" display="oDateTextbox"/><memberdata name="setpositionandsize" type="method" display="setPositionAndSize"/></VFPData>
odatetextbox = null
Name = "cbbutton"
      Class      1      Z_memberdata XML Metadata for customizable properties
odatetextbox
*setpositionandsize 
      Pixels      1small combo-button only, I only needed the button     ����    �  �                        &�   %   �                          �  U  Y  ��  � ��� ��R � T�� ��  � �� T�� ��  � �  � ��� T�� ��  � �� �� U 	 TOTEXTBOX THIS TOP LEFT WIDTH HEIGHTQ  ��  � � � �) %�C� Thisform.ObjClickMoveb� L��J � T� � �a�� � U  NBUTTON NSHIFT NXCOORD NYCOORD THISFORM OBJCLICKMOVE< ' %�C� thisform.curonmouseb� L��5 � T�  � �-�� � U  THISFORM
 CURONMOUSE< ' %�C� thisform.curonmouseb� L��5 � T�  � �-�� � U  THISFORM
 CURONMOUSEa " T�  �C� this.parent.� � ��� ��C�  � �� %��  � a�	 �  � -	��Z � ��C�  � �� � U  OTEXTBOX THIS ODATETEXTBOX SETFOCUS ENABLED READONLY DROPDOWN� " T�  �C� this.parent.� � ���" %�C� oTextBox.valueb� D��� �2 %�CC�  � H���
� CC�  � i�l��
��� � T�  � �C�  #�� � �/ %�C� thisform.curonmouseb� L� C�a	��� � T� � �a�� � B�C��� U  OTEXTBOX THIS ODATETEXTBOX VALUE THISFORM
 CURONMOUSE  ��  � T� � ��  � �� U  OTEXTBOX THIS ODATETEXTBOX NAMEQ  ��  � � � �) %�C� Thisform.ObjClickMoveb� L��J � T� � �-�� � U  NBUTTON NSHIFT NXCOORD NYCOORD THISFORM OBJCLICKMOVE setpositionandsize,     ��	 MouseMove�     ��	 LostFocusD    �� GotFocus�    �� DropDown�    �� When�    �� Init�    ��
 MouseLeave�    ��1 q � �A 3 1�� A 4 r� A 4 r� A 3 !� �� A 4 !!!!A A �� A � 3 q 23 1�� A 2  )   �                        cbbutton      !Arial, 0, 9, 5, 15, 12, 32, 3, 0
      form      form      calendar_form     NTop = 0
Left = 0
Height = 144
Width = 164
Desktop = .F.
ShowWindow = 1
ShowInTaskBar = .F.
DoCreate = .T.
BorderStyle = 1
Caption = "ComboForm"
Closable = .F.
KeyPreview = .T.
TitleBar = 0
WindowType = 1
AlwaysOnTop = .T.
textboxref = .NULL.
toformref = .F.
totextboxref = .F.
dpkname = .F.
Name = "calendar_form"
      Class      2      �textboxref reference to textbox
oldvalue old value, for Escape/Deactivate
toformref
totextboxref
dpkname
*gettoplevelform get top level form reference (or _screen if doesn't exist)
      Pixels      &the "always on top" form with calendar     	+���    	  	                        �   %   �                          �  U  W9 ��C� _SCREEN.ActiveFormb� O� C�9�  � � ����� H�F �G�D ��9� � �. C� _SCREEN.ActiveFormb� O� �9�  � � 	��� � T� ��9��7 �C� _SCREEN.ActiveFormb� O� �9�  � �	��� � T� ��9�  �� 2�G� �� �9� �� %�� � ���� T� �� �� !� � �� %�C� ��� O��C� T� ��9�� � �	 B�� �� U 
 ACTIVEFORM
 SHOWWINDOW	 FORMCOUNT	 LOTOPFORM LOFORM FORMS� %�C�  � �
��~� T� ��  � �� ACTIVATE WINDOW &_toformRef
1 %�C� _Screen.ActiveForm.Curonmouseb� L��z� T�9� � �-��& T� �� _Screen.ActiveForm�  � �� with &_toTextboxRef�X� %�C�� �
��T� �� �	 � T� �C�� ���� T�	 �C�� ����
 F��	 �� %�C� b� T��P�0 replace &tfldname with .value in &taliasname
 � � �� &_toTextboxRef..setfocus()
 � � U
  THISFORM	 TOFORMREF
 _TOFORMREF
 ACTIVEFORM
 CURONMOUSE _TOTEXTBOXREF DPKNAME UCONTROLSOURCE TFLDNAME
 TALIASNAME 
 ��  � � U  THIS RELEASE� ��  � � � T� � ��  �� T� �  ��  �� T� � �� �� %�C�	 ToformRefb� O��o � T� � �� � �� �  %�C� toTextboxRefb� O��� � T� �  ��  � �� �( %�C� toformRef.curonmouseb� L��� � T� � �a�� � %�C�  �� C�  ��� O��� B� � �� � T� �C� �	 �� ��� ���� T��
 ��  �� T�� ���
 � ��" %�C��
 � �
� C��
 � �
	���� T� � � �C��
 � i�� T� � � �C��
 � H�� T� � � �C��
 � %�� � � T� � � �CC$i�� T� � � �CC$H�� T� � � �CC$%�� �2 T�� ���
 � C��
 ��]C��%C�	�%� � ��# T�� �C��
 ��]C��%� � ��0 %��� �� C��%C��%�{�G�z�?����# T�� ��� C��%�{�G�z�?�� � �� U  TOTEXTBOXREF	 TOFORMREF _DPKNAME THISFORM DPKNAME NAME
 CURONMOUSE OTOPLEVELFORM THIS GETTOPLEVELFORM
 TEXTBOXREF OLDVALUE VALUE OLEMONTHVIEW YEAR MONTH DAY TOP HEIGHT LEFT WIDTHF  ��  � T� � � �� � �� T� � � �� � �� ��C� � � �� U  NSTYLE THIS OLEMONTHVIEW WIDTH HEIGHT SETFOCUS gettoplevelform,     �� Destroy�    ��
 Deactivate�    �� Init�    �� Showd    ��1 �� C� s� � D� A A A R� A B � 3 2�a�� � AA A A �A A 4 � 2 � �1A 1A �� A �A A q � � !"���� BAAB $11A PA 2 q aa2  )   	                        
olecontrol      
olecontrol      oleMonthView      calendar_form      GTop = -1
Left = -1
Height = 100
Width = 100
Name = "oleMonthView"
     
 ��ࡱ�                >  ��	                               ����        ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������R o o t   E n t r y                                               ��������                                ���{,�           O l e O b j e c t D a t a                                            ����                                        �        A c c e s s O b j S i t e D a t a                             &  ������������                                       \        C h a n g e d P r o p s                                         ������������                                       D             ����   ����      ����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������jE.#Ç���  �uM�!C4   (  L  �_�   $   �  �            \                          $   8                       651A8940-87C5-11d1-8BE3-0000F8754DA1�          (	        �        O    �   TitleBackColor 	   I
     y    TitleForeColor 	   I
   ���      �.�  p�.�p  ��. �  p�� p  &  �֛w�֛w�֛w�֛w'           �           �       �             �ͫ       �9    ��� �� ���   y ��  �� R������ � K�Q   ��$ Tahoma֛w�֛w�֛w�֛wp֛w�  �      �        .OLEObject = C:\WINDOWS\system32\mscomct2.ocx
     `���    G  G                        ��   %   g                          �  U  �  ��  � H� �� �$ �C� � ��� D�	 C� � ���_ �' T� � � � �C� � � � � �	 $��$ �C� � ��� T�	 C� � ���� �: T� � � � �C� � � � � �	 C� � �C� � ���� � �� � �
 � U  DATECLICKED THISFORM OLDVALUE THIS PARENT
 TEXTBOXREF VALUE YEAR MONTH DAY RELEASE�  ��  � H� �� �$ �C� � ��� D�	 C� � ���_ �' T� � � � �C� � � � � �	 $��$ �C� � ��� T�	 C� � ���� �: T� � � � �C� � � � � �	 C� � �C� � ���� � �� � �
 � U  DATEDBLCLICKED THISFORM OLDVALUE THIS PARENT
 TEXTBOXREF VALUE YEAR MONTH DAY RELEASE�  ��  � � � H� �� �$ �C� � ��� D�	 C� � ���g �' T� � � � �C� �	 � �
 � � $��$ �C� � ��� T�	 C� � ���� �: T� � � � �C� �	 � �
 � � C� � �C� � ���� � U 	 STARTDATE ENDDATE CANCEL THISFORM OLDVALUE THIS PARENT
 TEXTBOXREF VALUE YEAR MONTH DAY  ��  � � U  KEYCODE SHIFT! ��  � H� �� ��  ���� � H�2 �� �$ �C� � ��� D�	 C� � ���} �' T� � � � �C� � � � � �	 $��$ �C� � ��� T�	 C� � ���� �: T� � � � �C� � � � � �	 C� � �C� � ���� �
 �� �
 � ��  ���� T� � � �� � ��
 �� �
 � � U  NKEYCODE THISFORM OLDVALUE THIS PARENT
 TEXTBOXREF VALUE YEAR MONTH DAY RELEASE	 DateClick,     �� DateDblClick^    ��	 SelChange�    �� KeyDown�    �� KeyPress�    ��1 r � AqA�A � 4 r � AqA�A � 3 � � AqA�A 2 � 3 r � � AqA�A � a� A 2  )   G                        calendar_form      !Arial, 0, 9, 5, 15, 12, 32, 3, 0
      textbox      textbox      dpk     FontName = "Tahoma"
FontSize = 8
Alignment = 3
Value = (DATE())
Height = 22
Width = 64
NullDisplay = ""
currentdate = 
lallowblankdate = .T.
datetype = 2
datepartinitfocus = 2
yearsellength = 4
daystart = 0
dayend = 1
monthstart = 3
monthend = 4
yearstart = 6
yearend = 9
lexitontabonly = .T.
calendar_form_ref = .NULL.
cbbutton_name = 
_memberdata =      286<?xml version="1.0" standalone="yes"?>
<VFPData><memberdata name="cbbutton_name" type="property" display="cbButton_name" favorites="True"/><memberdata name="comboformref" type="property" display="comboFormRef"/><memberdata name="cerrmsg" type="property" display="cErrMsg"/></VFPData>

blankdatestring = 19000101
ucontrolsource = .F.
whenexpr = 
validexpr = 
cerrmsg = 
Name = "dpk"
      qcurrentdate
daystart
dayend
monthstart
monthend
yearstart
yearend
setyearsellength
setstartendpositions
      Class      1     �currentdate Date on field entry
lallowblankdate Allow blank dates
datetype Date Type 1-{mm/dd/yy},{mm-dd-yy},{mm.dd.yy}, 2-{dd/mm/yy},{dd-mm-yy},{dd.mm.yy}, 3-(yy/mm/dd),(yy-mm-dd),(yy.mm.dd)
datepartinitfocus Date part highlighted when control receives focus: 1- Month (default), 2-Day, 3-Year
yearsellength Selected length of the year ( 2 or 4 )
daystart Day Start position
dayend Day end position
monthstart Month start position
monthend Month end position
yearstart Year start position
yearend Year end position
lupdowndisabled Flag indicating whether the Up / Down arrow keys are disabled ( +/- functionality only )
lexitontabonly Exit the control only on (Shift+)Tab
calendar_form_ref referinta la formul cu calendar
cbbutton_name
_memberdata XML Metadata for customizable properties
blankdatestring
ucontrolsource
whenexpr
validexpr
cerrmsg
*datepartinitfocus_assign 
*setyearsellength Sets the year selected length
*setstartendpositions Sets the Day, Month and Year Start and End positions
*lupdowndisabled_assign 
*lexitontabonly_assign 
*dropdown afiseaza form calendr
*width_assign 
*height_assign 
*left_assign 
*top_assign 
*visible_assign 
*readonly_assign 
*enabled_assign 
*convcontrolsource 
      Pixels      -Textbox only from DatePicX classlib, modified     ]���    D  D                        ��   %   �                          �  U  :  ��  � %�C��  ������3 � T� � ���  �� � U  VNEWVAL THIS DATEPARTINITFOCUS�  ���  ��� � H� �� � ��� � ��: � T�� ���� ��� ���Z � T�� ���� ��� ���� � %�C� CENTURYv� ON��� � T�� ���� �� � T�� ���� � � �� U  THIS CENTURY YEARSELLENGTH ���  ��� H� �	� ��� ���� � T�� ���� T�� ���� T�� �� �� T�� ���� T�� ���� T�� ���� %��� ���� � T�� ��� ��� � ��� ���8� T�� �� �� T�� ���� T�� ���� T�� ���� T�� ���� T�� ���� %��� ���4� T�� ��� ��� � 2�	� T�� �� �� T�� ���� T�� ���� T�� ���� T�� ���� T�� ���� %��� ���� T�� ��� ��� T�� ��� ��� T�� ��� ��� T�� ��� ��� T�� ��� ��� � � �� U	  THIS DATETYPE DAYSTART DAYEND
 MONTHSTART MONTHEND	 YEARSTART YEAREND YEARSELLENGTH5  ��  � %�C�  ��� L��. � T� � ���  �� � U  VNEWVAL THIS LUPDOWNDISABLED7  ��  � %�C��  ��� L��0 � T� � ���  �� � U  VNEWVAL THIS LEXITONTABONLY� " T�  �CCC��� ]fC� � f�  ��� %�� � ���j �4 T� � �C� calendar_Form_desktop �  �  �  �N�� �� �, T� � �C� calendar_Form �  �  �  �N�� � T� � � �a�� ��C� � � �� U  _DPKNAME THIS THISFORM NAME
 SHOWWINDOW CALENDAR_FORM_REF ALWAYSONTOP SHOWe  ��  � %��  � � ��^ � T� � ��  ��" T� �C� this.parent.� � ��� ��C � � � �� � U  VNEWVAL THIS WIDTH
 OBUTTONREF CBBUTTON_NAME SETPOSITIONANDSIZEe  ��  � %��  � � ��^ � T� � ��  ��" T� �C� this.parent.� � ��� ��C � � � �� � U  VNEWVAL THIS HEIGHT
 OBUTTONREF CBBUTTON_NAME SETPOSITIONANDSIZEe  ��  � %��  � � ��^ � T� � ��  ��" T� �C� this.parent.� � ��� ��C � � � �� � U  VNEWVAL THIS LEFT
 OBUTTONREF CBBUTTON_NAME SETPOSITIONANDSIZEe  ��  � %��  � � ��^ � T� � ��  ��" T� �C� this.parent.� � ��� ��C � � � �� � U  VNEWVAL THIS TOP
 OBUTTONREF CBBUTTON_NAME SETPOSITIONANDSIZEd  ��  � %��  � � ��] � T� � ��  ��" T� �C� this.parent.� � ��� T� � ��  �� � U  VNEWVAL THIS VISIBLE
 OBUTTONREF CBBUTTON_NAMEr  ��  � %��  � � ��k � T� � ��  ��" T� �C� this.parent.� � ��� T� � ��  
�
 � � -
	�� � U  VNEWVAL THIS READONLY
 OBUTTONREF CBBUTTON_NAME ENABLEDp  ��  � %��  � � ��i � T� � ��  ��" T� �C� this.parent.� � ��� T� � ��  �	 � � -	�� � U  VNEWVAL THIS ENABLED
 OBUTTONREF CBBUTTON_NAME READONLY1 ���  ��*� %�C�� �
��&� �� � � T� �C�� ��� %�C� ���� �s ��C�# Please enter alias name along with C� �% field name in ucontrolsource property�0� Technical Mess.�x�� B�-�� � %�C� b� T��"� convDt = dtoc(&tConts)
. T�  � �CC� �
 01/01/1900� �  � � 6#�� � � �� U  THIS UCONTROLSOURCE TCONTS CONVDT VALUE  ���  �� � ��� � �� U  THIS CONVCONTROLSOURCE	+ ��  � � � � � � � � �	 �� %�C� nTopb� L� C� nLeftb� L� C� cSourceb� L� C� cWhenb� L� C� cValidb� L� C� cDefaultb� L� C� cErrorb� L� C� flsourceb� L� C� lTextBoxb� L���# T�
 � �CC� �
� C� �� �  6��# T�
 � �CC� �
� C� �� �  6��# T�
 � �CC� �
� C� �� �  6�� T�
 � �� �� T�
 � �� �� T�
 � ��  �� T�
 � ��      �?��* %�C� � f� D� C� � f� N���� T�
 � ���� ��� T�
 � ���� � T�
 � ��
�� T�
 � �� �� T�
 � ���� � ���
 ��� ��C�� �� ��C�� �� T� �C�
 � �� dpkcmb�� T�� �� ��' %�C�� � � Toolbar� Column�
����' ��C�� � cbButton�  �   �
 �� � �� T�  �C� .parent.�� ��� ��C �
 �  �! �� T�  �" ��
 �" �� � �� U#  NTOP NLEFT TXTWIDTH CSOURCE CWHEN CVALID CDEFAULT CERROR FLSOURCE LTEXTBOX THIS WHENEXPR	 VALIDEXPR CERRMSG VALUE LEFT TOP HEIGHT LOTHER DATA_TY WIDTH	 MAXLENGTH CONTROLSOURCE FONTSIZE SETYEARSELLENGTH SETSTARTENDPOSITIONS MCBBTNNM NAME CBBUTTON_NAME PARENT	 BASECLASS	 NEWOBJECT LOBTN SETPOSITIONANDSIZE VISIBLET T�  �C�� T� �CC+
� CO� � 6��) %�C� Thisform.ObjClickMoveb� U��l � %�� � a��h � B�a�� � � %�C� � ���� � %�� � 
��� � B�-�� � �� � %�C� � i� ��� � B�-�� � � %�C� � �
����2 %�CC� � H���
� CC� � i�l��
���� %�CC� � H���
��_�4 T� � ��$ Month should be between Jan. to Dec.�� � %�CC� � i�l��
����3 T� � ��# Year should be between 1900 to 2078�� � T� � �C�  #�� B�-�� � � %�C� � �
���� T�	 �C� � ��� %�C� _curvalb� L���� %��	 -���� %�C� � �
��`� T�
 �CC� � Λ�� ��C�
 �@� �x�� �
 F��  �� �� %�� � ����	 #�� �� � B�� � �� � � � ��� ��M� %�C�� �
��I� �� � � T� �C�� ���� T� �C�� ����
 F�� �� %�C� b� T��E�4 Replace &tFldName With This.Value In &tAliasName
 � � �� U  _CURTBL _CURREC THISFORM OBJCLICKMOVE THIS VALUE LALLOWBLANKDATE CERRMSG	 VALIDEXPR _CURVAL _CURMES VUMESS UCONTROLSOURCE TFLDNAME
 TALIASNAMED  ��  � � ��� ��= � ��C�� �� ��C�� �� T�� ��� �� �� U  LNSTART LNLENGTH THIS SETYEARSELLENGTH SETSTARTENDPOSITIONS CURRENTDATE VALUE�  ��  � �) %�C� Thisform.ObjClickMoveb� L��B � T� � �-�� � ��� ��� � %�C�� �
��� � �� � � T� �C�� ���� T� �C�� ����
 F�� �� %�C� b� T��� �4 replace &tfldname with this.value in &taliasname
 � � �� U  NKEYCODE NSHIFTALTCTRL THISFORM OBJCLICKMOVE THIS UCONTROLSOURCE TFLDNAME
 TALIASNAME  U    U   ���  ��� � T�� �� �� %��� C�
 01/01/1900#��� � %�C�� �
��� � �� � � T� �C�� ���� T� �C�� ����
 F�� �� %�C� b� T��� �) IF &tfldname = CTOD('01/01/1900')�� �, replace &tfldname with {} in &taliasname
 � � � � �� U  THIS SELSTART VALUE UCONTROLSOURCE TFLDNAME
 TALIASNAME/  %�C�  � �
��( � ��C�  � �@� �x�� � U  THIS CERRMSG VUMESS datepartinitfocus_assign,     �� setyearsellength�     �� setstartendpositionsi    �� lupdowndisabled_assign�    �� lexitontabonly_assign5    �� dropdown�    �� width_assign�    �� height_assignY    �� left_assign    ��
 top_assign�    �� visible_assigna    �� readonly_assign�    �� enabled_assign�	    �� convcontrolsource`
    �� Refresh�    �� Init�    �� Valid`    �� GotFocusT    �� KeyPress�    �� InteractiveChangeD    �� ClickK    �� WhenR    �� ErrorMessage�    ��1 q �!A 3 � � !� "� "�� � � A A A 3 � � !� � � � � � "1A "� � � � � � "1A � � � � � � � "11111A A A 3 q R!A 3 q r!A 3 "AA� �A 3 q B!A 3 q B!A 3 q A!A 3 q B!A 3 q A!A 3 q A!�A 3 q A!�A 3 � � � 1q A A��A A A 3 � � A 3 ��111��� A A � � � �� sq�1A A 3 � ��!q A A "q A � aq A A 1!�AA �1A !q A A 1"�� 1A!A � A � A � A A A � � � AAA A A 3 � � � � � 0A 3 � �� A 0� � � AAA A A 3 �1 3 � � �� � A��A A A A A 4 1QA 2  )   D                        dpk      "Tahoma, 0, 8, 5, 13, 11, 21, 2, 0
0
   m                   PLATFORM   C                  UNIQUEID   C	   
               TIMESTAMP  N   
               CLASS      M                  CLASSLOC   M!                  BASECLASS  M%                  OBJNAME    M)                  PARENT     M-                  PROPERTIES M1                  PROTECTED  M5                  METHODS    M9                  OBJCODE    M=                 OLE        MA                  OLE2       ME                  RESERVED1  MI                  RESERVED2  MM                  RESERVED3  MQ                  RESERVED4  MU                  RESERVED5  MY                  RESERVED6  M]                  RESERVED7  Ma                  RESERVED8  Me                  USER       Mi                                                                                                                                                                                                                                                                                          COMMENT Class                                                                                               WINDOWS _1SK0YLW1M 895782231      )  :      K          �          #  0  9          �               WINDOWS _1WL0UKZV2 895782231C  N  d  s    �          '                                               COMMENT RESERVED                        	                                                                 WINDOWS _1SK0YLW1M 895782236D      U  f      v          �          ?  L  U          �               WINDOWS _1SK0YLW1N 895782236z      �  �  �  �          B                                               COMMENT RESERVED                        �-      �-                                                           WINDOWS _1SK0YLW1M 895782297�-      �-  .       .          g/          �.  �.   /          Y/               WINDOWS _1WH0WR81V 895782297�3      �3  �3  �3  �3          o4                                               COMMENT RESERVED                        cA      sA                                                           WINDOWS _S050WHPLL 896558255�A      �A  �A      �A          fC          �B  �B  �B          -C  ;C           COMMENT RESERVED                        EK      TK                                                           WINDOWS _1SK0YLW1M 898210070}K      �K  �K      �K          dM          �L  �L  �L          VM               WINDOWS _1SK0YLW1O 898210070ES      ZS  oS  S  �S          T                                               COMMENT RESERVED                        `      .`                                                           WINDOWS _0NU0YJI24 913529225W`      l`  �`      �`          9a          a  "a              +a               COMMENT RESERVED                        �f      �f                                                           WINDOWS _2AL0RHEYW 944137842�f      �f   g      g          �g          �g  �g              �g               COMMENT RESERVED                        �i      �i                                                           WINDOWS _28Z0RR06H 990870114j      0j  Ej      Sj          k          �j  �j              k               COMMENT RESERVED                        t      -t                                                           WINDOWS _1Y90Z0A15 997033552Vt      kt  �t      �t          /u          u  u              !u               COMMENT RESERVED                        U�      e�                                                           WINDOWS _0NU0YIHSX1011116496��      ��  ��      ǃ          ��          ��  ��  ��          �               COMMENT RESERVED                        ��      ��                                                           WINDOWS _S050WE6S01011118272�      �   �      �          �          h�  u�  ~�          Ќ  ތ           COMMENT RESERVED                        ��      ��                                                           WINDOWS _1SK0YLW1M1012302045ͩ      ީ  �      ��          �          ��  ��  ��          ��               WINDOWS _1WL0UKZV21012302045A�  L�  b�  q�  }�  ��          ��                                               COMMENT RESERVED                        ~�      ��                                                            ��                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 VERSION =   3.00      	container      	container      	ainfodate      �Width = 198
Height = 17
BackStyle = 1
BorderWidth = 0
activeobjname = Dpk1
cerrmsg = .F.
defaexpr = .F.
validexpr = .F.
whenexpr = .F.
nheight = .F.
nwidth = .F.
csource = .F.
Name = "ainfodate"
      Class      2      Qactiveobjname
cerrmsg
defaexpr
validexpr
whenexpr
nheight
nwidth
csource
      Pixels     ����    �  �                        .�   %                             �  U  P ��  � � � � � � �! %�CC� nheightb� N� C�
��M � T�  �� �� �  %�CC� nWidthb� N� C�
��~ � T� �� �� � %�C� csourceb� C��� � T� ��  �� � %�C� cwhenb� C��� � T� ��  �� � %�C� cdefaultb� C��� T� ��  �� � %�C� cvalidb� C��,� T� ��  �� � %�C� cerrorb� C��W� T� ��  �� � T� � �� �� T� �	 �� �� T� �
 �� �� T� � �� �� T� �  ��  �� T� � �� �� T� � �� �� T� �� This.� � ��# &_curobjname..Left          = 0
# &_curobjname..Top           = 0
# &_curobjname..FontSize      = 8
 U  NHEIGHT NWIDTH CSOURCE CWHEN CDEFAULT CVALID CERROR THIS DEFAEXPR WHENEXPR	 VALIDEXPR CERRMSG _CUROBJNAME ACTIVEOBJNAME Init,     ��1 �� A � A �� A �� A �� A �� A �� A �1112  )   �                        dpk      datepicker.vcx      textbox      Dpk1      	ainfodate      �FontSize = 8
BackStyle = 0
BorderStyle = 0
Height = 18
Left = 0
Margin = 2
TabIndex = 2
Top = 0
BorderColor = 0,255,64
Name = "Dpk1"
     ����    �  �                        M    %                             �  U  y  %��  � � � �  � � ��' � B�-�� �F T�  � �CC� this.parent.nheightb� N� �  � � � C�  � � �6��I T�  � �CC� this.parent.nwidthb� N� �  � � � C�  � � �6���3 T� �CCC�  � �	 �� �  � �	 � C�  � �	 �6��� T�  �
 �� �� T� �C��� %�� 
��� B�-�� �6 %�C�" This.Parent.Parent.Text1.BackColorb� N��u� T�  � ��  � � � � �� � T� ��  �
 �� %�C� �
���� %�C� b� T����! This.Value	= Ttod(&_defvalue)
 ��� This.Value	= &_defvalue
 � � %�� � � � � ��r� %�� � a��)� B� � %�� � -��O� T� � ���� � T� � �a�� T� �CC�  � �	 ��R�� T� �� Ainfo_vw��
 F�� ��  T� �CCCO�CN�� CO� � 6�� %�C� � �
��u� T� �C� � ���� T� �C� � ����
 F�� �� T� �� � �� %�� � ��'�	 #�� �� � %�C� � .� b� L��q�) REPLACE &_curfld WITH .f. IN &_curtbl
 � �
 F�� �� %�� � ����	 #�� �� � %�C� g� ��B� T� �� Currow� �� %�C� � .� b� L���- REPLACE &_curfldnm WITH .t. IN &_curtblnm
 � T� � �� � .� �� T� � �� �� � ��  � � � � � T� � ��  ��" %�C�  �  �� C�  � �! �
	���� T�" �C�  � �! ��� %�C�" �
���� T�  �  ��" �� � � %�C�  � �# �
��n� T�" �C�  � �# ��� %�C�" �
��j� T�$ �C�" ��� %�C� _curvalb� L��N� %��$ -��J� \�� {TAB}�� � �f� T�  �  ��$ �� � � � � U%  THIS PARENT CURRENTCONTROL NAME HEIGHT NHEIGHT WIDTH NWIDTH	 _DEFVALUE CSOURCE UCONTROLSOURCE	 _DEFAWHEN	 BACKCOLOR TEXT1 THISFORM ADDMODE EDITMODE
 FLAGCANCEL SETFS SETVALUE
 LOCKSCREEN	 _CURFLDNO	 _CURTBLNM _AINFONEWREC AINFOOLDFLD _CURFLD _CURTBL _AINFOOLDREC AINFOOLDREC	 _CURFLDNM REFRESH LISTTBL VALUE DEFAEXPR _CURWVAL WHENEXPR _CURVAL� T�  �C��� %��  
��+ � �� B�� � �� � %�� � � � � ���� %�� � a�	 � � a��k � B� � T� �C� �	 ���� T�
 �C� �	 ����
 F��
 �� T� �CC+
� CO� � 6�� %�� � ���� � T� � �� � ���
 F��
 �� B�� � �� � T� � �� � ��� %�C� � � �
��w� T� �C� � � ��� %�C� �
��s� T� �C� ��� %�C� _curvalb� L��o� %�� -��k� T� �� Invalid Date�� T� �� � � �� %�C� �
��� T� �C� ��� %�C� �
��� T� �CC� Λ�� T� �CC� �
� � � � 6�� � � ��C � �  � � � ��
 F��
 �� �� %�� � ��[�	 #�� �� � B�� � �� � � � � T� �CC� � � ��R�� %�C� g� ���� T� �� Ainfo_vw�� T� �� Currow� �� %�C� � .� b� L�� �/ REPLACE &_curfldnm WITH .f. IN &_curtblnm		
 � T� � ��  �� T� � �� �� T� �� � � � ��: REPLACE &_curfldnm WITH DTOC(This.Value) IN &_curtblnm
 � �� � � � � � T� � ��  �� T� � �-�� � U  
 _DEFAVALID THIS VALUE THISFORM ADDMODE EDITMODE
 FLAGCANCEL
 CURONMOUSE _CURFLD UCONTROLSOURCE _CURTBL _CURREC SETVALUE PARENT	 VALIDEXPR _CURWVAL _CURVAL _CURMES _CURWMES CERRMSG SHOWMESSAGEBOX VUMESS	 _CURFLDNO CSOURCE	 _CURTBLNM	 _CURFLDNM AINFOOLDFLD AINFOOLDREC CONTROLSOURCE REFRESH LISTTBL SETFS?  %��  � � �  � ��8 � T�  � �a�� T�  � ���� � U  THISFORM ADDMODE EDITMODE SETFS SETVALUE�  T�  �C��� %��  
��+ � �� B�� � �� � %�C|�	� C|���� �  %�� � � � � � � ��� �# ��C� � ��� � � � � �� � � %�C|���� �  %�� � � � � � � ��� �/ ��C� � �� � � � � � � � � � �� � � U	 
 _DEFAVALID THIS VALUE THISFORM
 CUR_ACTCOL PARENT COLUMNCOUNT ACTIVATECELL
 CUR_ACTROW When,     �� Valid    �� SetFocus:    ��	 LostFocus�    ��1 q A a�1� � q A a�A A� �A A �!A A !A � �Q� 111� � A ��A A � � A 1q��A �A 1!QA A aQ� �� � A � A A A A 3 � � A � A ��A A 11� �Aq� � A qaQ� �� �1� �A A �� A � A � A A A A �1Qq��A a�A 1� A 3 �� A 3 � � A � A �1A A �A A 2  )   �                        	ainfodate      "Tahoma, 0, 8, 5, 13, 11, 21, 2, 0
      	container      	container      ainfotxt      �Width = 198
Height = 18
BorderWidth = 0
activeobjname = Text1
defaexpr = .F.
whenexpr = .F.
validexpr = .F.
cerrmsg = .F.
nheight = .F.
nwidth = .F.
csource = .F.
Name = "ainfotxt"
      Class      2      Qactiveobjname
defaexpr
whenexpr
validexpr
cerrmsg
nheight
nwidth
csource
      Pixels     ����    �  �                        "   %                             �  U    U  P ��  � � � � � � �! %�CC� nheightb� N� C�
��M � T�  �� �� �  %�CC� nWidthb� N� C�
��~ � T� �� �� � %�C� csourceb� C��� � T� ��  �� � %�C� cwhenb� C��� � T� ��  �� � %�C� cdefaultb� C��� T� ��  �� � %�C� cvalidb� C��,� T� ��  �� � %�C� cerrorb� C��W� T� ��  �� � T� � �� �� T� �	 �� �� T� �
 �� �� T� � �� �� T� �  ��  �� T� � �� �� T� � �� �� T� �� This.� � ��# &_curobjname..Left          = 0
# &_curobjname..Top           = 0
# &_curobjname..FontSize      = 8
 U  NHEIGHT NWIDTH CSOURCE CWHEN CDEFAULT CVALID CERROR THIS DEFAEXPR WHENEXPR	 VALIDEXPR CERRMSG _CUROBJNAME ACTIVEOBJNAME SetFocus,     �� Init3     ��1 3 �� A � A �� A �� A �� A �� A �� A �1112  )   �                        textbox      textbox      Text1      ainfotxt      �FontSize = 8
BackStyle = 0
BorderStyle = 0
Height = 18
Left = 0
Margin = 2
TabIndex = 2
Top = 0
Width = 198
Name = "Text1"
     k���    R  R                        g   %   �                          �  U    U    U  8  %��  � � � �  � � ��' � B�-�� �F T�  � �CC� this.parent.nheightb� N� �  � � � C�  � � �6��I T�  � �CC� this.parent.nwidthb� N� �  � � � C�  � � �6���3 T� �CCC�  � �	 �� �  � �	 � C�  � �	 �6��� T�  �
 �� �� T� �C��� %�� 
��� B�-�� �6 %�C�" This.Parent.Parent.Text1.BackColorb� N��u� T�  � ��  � � � � �� � T� ��  �
 �� %�C� �
���� This.Value	= &_defvalue
 � %�� � � � � ��1� %�� � a���� B� � %�� � -��� T� � ���� � T� � �a�� T� �CC�  � �	 ��R�� T� �� Ainfo_vw��
 F�� ��  T� �CCCO�CN�� CO� � 6�� %�C� � �
��4� T� �C� � ���� T� �C� � ����
 F�� �� T� �� � �� %�� � ����	 #�� �� � %�C� � .� b� L��0�) REPLACE &_curfld WITH .f. IN &_curtbl
 � �
 F�� �� %�� � ��\�	 #�� �� � %�C� g� ��� T� �� Currow� �� %�C� � .� b� L����- REPLACE &_curfldnm WITH .t. IN &_curtblnm
 � T� � �� � .� �� T� � �� �� � ��  � � � � � T� � ��  ��" %�C�  �  �� C�  � �! �
	���� T�" �C�  � �! ��� %�C�" �
��� T�  �  ��" �� � � %�C�  � �# �
��-� T�" �C�  � �# ��� %�C�" �
��)� T�$ �C�" ��� %�C� _curvalb� L��� %��$ -��	� \�� {TAB}�� � �%� T�  �  ��$ �� � � � � U%  THIS PARENT CURRENTCONTROL NAME HEIGHT NHEIGHT WIDTH NWIDTH	 _DEFVALUE CSOURCE CONTROLSOURCE	 _DEFAWHEN	 BACKCOLOR TEXT1 THISFORM ADDMODE EDITMODE
 FLAGCANCEL SETFS SETVALUE
 LOCKSCREEN	 _CURFLDNO	 _CURTBLNM _AINFONEWREC AINFOOLDFLD _CURFLD _CURTBL _AINFOOLDREC AINFOOLDREC	 _CURFLDNM REFRESH LISTTBL VALUE DEFAEXPR _CURWVAL WHENEXPR _CURVAL�  %�C|�	� C|���b �  %��  � � � � � � ��^ �# ��C�  � ��� � � � � �� � � %�C|���� �  %��  � � � � � � ��� �/ ��C�  � �� � � � � � � � � � �� � � U  THISFORM
 CUR_ACTCOL THIS PARENT COLUMNCOUNT ACTIVATECELL
 CUR_ACTROW?  %��  � � �  � ��8 � T�  � �a�� T�  � ���� � U  THISFORM ADDMODE EDITMODE SETFS SETVALUE� T�  �C��� %��  
��+ � �� B�� � �� � %�� � � � � ���� %�� � a�	 � � a��k � B� � T� �C� �	 ���� T�
 �C� �	 ����
 F��
 �� T� �CC+
� CO� � 6�� %�� � ���� � T� � �� � ���
 F��
 �� B�� � �� � T� � �� � ��� %�C� � � �
��x� T� �C� � � ��� %�C� �
��t� T� �C� ��� %�C� _curvalb� L��p� %�� -��l� T� �� Invalid Value�� T� �� � � �� %�C� �
��� T� �C� ��� %�C� �
��� T� �CC� Λ�� T� �CC� �
� � � � 6�� � � ��C � �  � � � ��
 F��
 �� �� %�� � ��\�	 #�� �� � B�� � �� � � � � T� �CC� � � ��R�� %�C� g� ���� T� �� Ainfo_vw�� T� �� Currow� �� %�C� � .� b� L��!�/ REPLACE &_curfldnm WITH .f. IN &_curtblnm		
 � T� � ��  �� T� � �� �� T� �� � � �	 ��4 REPLACE &_curfldnm WITH This.Value IN &_curtblnm
 � �� � � � � � T� � ��  �� T� � �-�� � U 
 _DEFAVALID THIS VALUE THISFORM ADDMODE EDITMODE
 FLAGCANCEL
 CURONMOUSE _CURFLD CONTROLSOURCE _CURTBL _CURREC SETVALUE PARENT	 VALIDEXPR _CURWVAL _CURVAL _CURMES _CURWMES CERRMSG SHOWMESSAGEBOX VUMESS	 _CURFLDNO CSOURCE	 _CURTBLNM	 _CURFLDNM AINFOOLDFLD AINFOOLDREC REFRESH LISTTBL SETFS GotFocus,     �� ErrorMessage3     �� When:     ��	 LostFocus�    �� SetFocus    �� Validy    ��1 7 6 q A a�1� � q A a�A �A �!A A !A � �Q� 111� � A ��A A � � A 1q��A �A 1!QA A aQ� �� � A � A A A A 3 �1A A �A A �1 �� A 3 � � A � A ��A A 11� �Aq� � A qaQ� �� �1� �A A �� A � A � A A A A �1Qq��A aAA 1� A 2  )   R                        ainfotxt      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      	container      	container      ainfochk      �Width = 198
Height = 17
BorderWidth = 0
activeobjname = Check1
defaexpr = .F.
whenexpr = .F.
validexpr = .F.
cerrmsg = .F.
nheight = .F.
nwidth = .F.
csource = .F.
Name = "ainfochk"
      Class      2      Qactiveobjname
defaexpr
whenexpr
validexpr
cerrmsg
nheight
nwidth
csource
      Pixels     5���                              >   %   �                          �  U  � ��  � � � � � � �! %�CC� nheightb� N� C�
��M � T�  �� �� �  %�CC� nWidthb� N� C�
��~ � T� �� �� � %�C� csourceb� C��� � T� ��  �� � %�C� cwhenb� C��� � T� ��  �� � %�C� cdefaultb� C��� T� ��  �� � %�C� cvalidb� C��,� T� ��  �� � %�C� cerrorb� C��W� T� ��  �� � T� � �� �� T� �	 �� �� T� �
 �� �� T� � �� �� T� �  ��  �� T� � �� �� T� � �� �� T� �� This.� � ��# &_curobjname..Left          = 2
# &_curobjname..Top           = 0
c &_curobjname..Height        = IIF(TYPE('this.nheight')='N',this.nheight,EVALUATE(this.nheight))
3 &_curobjname..Width     	= &_curobjname..Height
# &_curobjname..FontSize      = 8
 U  NHEIGHT NWIDTH CSOURCE CWHEN CDEFAULT CVALID CERROR THIS DEFAEXPR WHENEXPR	 VALIDEXPR CERRMSG _CUROBJNAME ACTIVEOBJNAME Init,     ��1 �� A � A �� A �� A �� A �� A �� A �111112  )                           checkbox      checkbox      Check1      ainfochk      �Top = 0
Left = 2
Height = 16
Width = 18
FontSize = 8
Alignment = 4
BackStyle = 0
Caption = ""
TabIndex = 2
Name = "Check1"
     ����    �  �                        ��   %   X                          �  U    %��  � � � �  � � ��' � B�-�� �6 %�C�" This.Parent.Parent.Text1.BackColorb� N��} � T�  � ��  � � � � �� � %�� � � � � ��� %�� �	 a��� � B� � %�� �
 -��� � T� � ���� � T� � �a�� T� �CC�  � � ��R�� T� �� Ainfo_vw��
 F�� ��  T� �CCCO�CN�� CO� � 6�� %�C� � �
���� T� �C� � ���� T� �C� � ����
 F�� �� T� �� � �� %�� � ����	 #�� �� � %�C� � .� b� L����) REPLACE &_curfld WITH .f. IN &_curtbl
 � �
 F�� �� %�� � ��%�	 #�� �� � %�C� g� ���� T� �� Currow� �� %�C� � .� b� L����- REPLACE &_curfldnm WITH .t. IN &_curtblnm
 � T� � �� � .� �� T� � �� �� � ��  � � � � � T� � ��  ��" %�C�  � �� C�  � � �
	��V� T� �C�  � � ��� %�C� �
��R� This.Value = &_curwval
 � � %�C�  � � �
�� � T� �C�  � � ��� %�C� �
���� T� �C� ��� %�C� _curvalb� L���� %�� -���� \�� {TAB}�� � ��� T�  � �� �� � � � � U  THIS PARENT CURRENTCONTROL NAME	 BACKCOLOR TEXT1 THISFORM ADDMODE EDITMODE
 FLAGCANCEL SETFS SETVALUE
 LOCKSCREEN	 _CURFLDNO CSOURCE	 _CURTBLNM _AINFONEWREC AINFOOLDFLD _CURFLD _CURTBL _AINFOOLDREC AINFOOLDREC	 _CURFLDNM REFRESH LISTTBL VALUE DEFAEXPR _CURWVAL WHENEXPR _CURVAL?  %��  � � �  � ��8 � T�  � �a�� T�  � ���� � U  THISFORM ADDMODE EDITMODE SETFS SETVALUE: %��  � � �  � ��3� %��  � a��0 � B� � T� �C� � ���� T� �C� � ����
 F�� �� T� �CC+
� CO� � 6�� %��  �	 ���� � T�  �	 ��  �	 ���
 F�� �� � T�  �	 ��  �	 ��� %�C� �
 � �
��1� T� �C� �
 � ��� %�C� �
��-� T� �C� ��� %�C� _curvalb� L��)� %�� -��%� T� �� Invalid Input�� T� �� �
 � �� %�C� �
���� T� �C� ��� %�C� �
���� T� �CC� Λ�� T� �CC� �
� � � � 6�� � � ��C � �  � �  � ��
 F�� �� �� %�� � ���	 #�� �� � B�� � �� � � � � T� �CC� �
 � ��R�� %�C� g� ���� T� �� Ainfo_vw�� T� �� Currow� �� %�C� � .� b� L����/ REPLACE &_curfldnm WITH .f. IN &_curtblnm		
 � T�  � ��  �� T�  � �� �� � �� �
 �
 �
 � � T�  � ��  �� T�  � �-�� � U  THISFORM ADDMODE EDITMODE
 FLAGCANCEL _CURFLD THIS CONTROLSOURCE _CURTBL _CURREC SETVALUE PARENT	 VALIDEXPR _CURWVAL _CURVAL _CURMES _CURWMES CERRMSG SHOWMESSAGEBOX VUMESS VALUE	 _CURFLDNO CSOURCE	 _CURTBLNM	 _CURFLDNM AINFOOLDFLD AINFOOLDREC REFRESH LISTTBL SETFS�  %�C|�	� C|���b �  %��  � � � � � � ��^ �# ��C�  � ��� � � � � �� � � %�C|���� �  %��  � � � � � � ��� �/ ��C�  � �� � � � � � � � � � �� � � U  THISFORM
 CUR_ACTCOL THIS PARENT COLUMNCOUNT ACTIVATECELL
 CUR_ACTROW When,     �� SetFocusi    �� Valid�    ��	 LostFocus9
    ��1 q A a�A �!A A !A � �Q� 111� � A ��A A � � A 1q��A �A 1!Q�A A aQ� �� � A � A A A A 3 �� A 3 �!A A 11� �Aq� A qaQ� �� �1� �A A �� A � A � A A A A �1Qq��A A 1� A 3 �1A A �A A 2  )   �                        ainfochk      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      checkbox      checkbox      chkxtra     Height = 16
Width = 18
FontSize = 8
AutoSize = .T.
Alignment = 2
BackStyle = 0
Caption = ""
PicturePosition = 14
ForeColor = 255,255,255
BackColor = 0,0,255
DisabledForeColor = 0,0,0
DisabledBackColor = 228,220,250
defaexpr = .F.
cerrmsg = .F.
Name = "chkxtra"
      Class      1      (validexpr
whenexpr
defaexpr
cerrmsg
      Pixels      #Check box for entering logical data     ����    �  �                        ��   %   �                          �  U  x# ��  � � � � � � � � %�C� ntopb� N��H � T�  �� �� � %�C� nleftb� N��r � T� �� �� � %�C� nheightb� N��� � T� �� �� � %�C� csourceb� C��� � T� ��  �� � %�C� cwhenb� C��� � T� ��  �� � %�C� cdefaultb� C��!� T� ��  �� � %�C� cvalidb� C��L� T� ��  �� � %�C� cerrorb� C��w� T� ��  �� � T� �	 �� �� T� �
 ��  �� T� � �� �� T� � �� �� T� � �� �� T� � ���� T� � �C� ��� T� � �C� ��� T� � �C� ��� T� � �C� ��� %�C� � � f� COLUMN��a� T� � �C�  � � � �  ��� � T� � ��  �� U  NTOP NLEFT NHEIGHT CSOURCE CWHEN CDEFAULT CVALID CERROR THIS LEFT TOP HEIGHT WIDTH CONTROLSOURCE FONTSIZE DEFAEXPR WHENEXPR	 VALIDEXPR CERRMSG PARENT CLASS CAPTION' %��  � � �  � �	 � � -	��x� T� �C� � ���� T� �C� � ����
 F�� �� T� �CC+
� CO� � 6�� %�C� �	 �
��d� T�
 �C� �	 ��� %�C� _curvalb� L��`� %��
 -��\� %�C� � ���� � T� �� Invalid Input�� �� T� �CC� � Λ�� � ��C � �  � �  � ��
 F�� �� �� %�� � ��L�	 #�� �� � B�� � �� � � � T�  � ��  �� � U  THISFORM ADDMODE EDITMODE THIS READONLY _CURFLD CONTROLSOURCE _CURTBL _CURREC	 VALIDEXPR _CURVAL CERRMSG _CURMES SHOWMESSAGEBOX VUMESS VALUE LISTTBL�  %��  � � �  � ��� � T�  � ��  �� %�C� � ��
 C� � �
	��\ � T� � �� � �� � %�C� � �
��� � T� �C� � ��� %�C� _curvalb� L��� � %�� -��� �	 B�� �� � �� � T� � �� �� � � � U	  THISFORM ADDMODE EDITMODE LISTTBL THIS VALUE DEFAEXPR WHENEXPR _CURVAL Init,     �� Valida    �� When�    ��1 1�� A �� A �� A �� A �� A �� A �� A �� A !!!!��A 4 q11� �1!�� !�� AA �� A � A � A A A A 3 ��1A 1!�� � A � A A A 2  )   �                        chkxtra      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      	container      	container      ainfocmd     Width = 198
Height = 17
BorderWidth = 0
activeobjname = Command1
cmdcontrol = .F.
cmdcaption = .F.
lsttable = .F.
lstcond = .F.
splchk = .F.
nheight = .F.
nwidth = .F.
defaexpr = .F.
whenexpr = .F.
validexpr = .F.
cerrmsg = .F.
Name = "ainfocmd"
      Class      2      {activeobjname
cmdcontrol
cmdcaption
lsttable
lstcond
splchk
nheight
nwidth
defaexpr
whenexpr
validexpr
cerrmsg
      Pixels     ����    �  �                        `   %   #                          �  U  / ��  � � � � � � � � �	 �
 �! %�CC� nheightb� N� C�
��] � T�  �� �� �  %�CC� nWidthb� N� C�
��� � T� �� �� � %�C� cControlb� C��� � T� ��  �� � %�C� cCaptionb� C��� � T� ��  �� � %�C�	 cLsttableb� C��� T� ��  �� � %�C� cLstcondb� C��C� T� ��  �� � %�C� cwhenb� C��m� T� ��  �� � %�C� cdefaultb� C���� T� ��  �� � %�C� cvalidb� C���� T�	 ��  �� � %�C� cerrorb� C���� T�
 ��  �� � T� � �C� ��� T� � �C� ��� T� � �C� ��� T� � �C� ��� T� � �� �� T� �  ��  �� T� � �� �� T� � �� �� T� � �� �� T� � ��	 �� T� � ��
 �� T� �� This.� � ��# &_curobjname..Left          = 1
# &_curobjname..Top           = 0
c &_curobjname..Height        = IIF(TYPE('this.nheight')='N',this.nheight,EVALUATE(this.nheight))
] &_curobjname..Width     	= IIF(TYPE('this.nwidth')='N',this.nwidth,EVALUATE(this.nwidth))
# &_curobjname..FontSize      = 8
! &_curobjname..Caption  		= []
 U  NHEIGHT NWIDTH CCONTROL CCAPTION	 CLSTTABLE CLSTCOND CSPLCHK CWHEN CDEFAULT CVALID CERROR THIS
 CMDCONTROL
 CMDCAPTION LSTTABLE LSTCOND SPLCHK DEFAEXPR WHENEXPR	 VALIDEXPR CERRMSG _CUROBJNAME ACTIVEOBJNAME Init,     ��1 �� A � A �� A �� A �� A �� A �� A �� A �� A �� A "!!!�111�12  )   �                        commandbutton      commandbutton      Command1      ainfocmd      kTop = 0
Left = 2
Height = 18
Width = 60
FontSize = 8
Caption = ".."
TabIndex = 2
Name = "Command1"
     ���    �  �                        �1   %   �
                          �  U  � %��  � � �  � ���� %��  � a��0 � B� � T� �� � � �� T� �C� ��� T� �C� ���� T�	 �C� ����
 F��	 �� T�
 �CC+
� CO� � 6�� %��  � ���� � T�  � ��  � ���
 F��	 �� � T�  � ��  � ��� T� �CC� � � ��R�� %�C� g� ���� T� �� Ainfo_vw�� T� �� Currow� �� %�C� � .� b� L����/ REPLACE &_curfldnm WITH .f. IN &_curtblnm		
 � T�  � ��  �� T�  � �� �� � �� � � � � � T�  � ��  �� T�  � �-�� � U  THISFORM ADDMODE EDITMODE
 FLAGCANCEL CCONTROL THIS PARENT
 CMDCONTROL _CURFLD _CURTBL _CURREC SETVALUE	 _CURFLDNO	 _CURTBLNM	 _CURFLDNM AINFOOLDFLD AINFOOLDREC REFRESH LISTTBL SETFS�  %��  � � � �  � � ��' � B�-�� � %�� � � � � ���� %�� � a��[ � B� � %�� � -��� � T� �	 ���� � T� �
 �a�� T� �CC�  � � ��R�� T� �� Ainfo_vw��
 F�� ��  T� �CCCO�CN�� CO� � 6�� %�C� � �
���� T� �C� � ���� T� �C� � ����
 F�� �� T� �� � �� %�� � ��Y�	 #�� �� � %�C� � .� b� L����) REPLACE &_curfld WITH .f. IN &_curtbl
 � �
 F�� �� %�� � ����	 #�� �� � %�C� g� ��t� T� �� Currow� �� %�C� � .� b� L��G�- REPLACE &_curfldnm WITH .t. IN &_curtblnm
 � T� � �� � .� �� T� � �� �� � ��  � � � � � T� � ��  �� T� ��  � � �� T� �C� ��� T� ��  �� T� �C� � ���� T� �C� � ���� %�C� b� L��� cControlv= &cControl
 � %�C� �� C�  � � �
	���� T� �C�  � � ��� %�C� �
����2 REPLACE &cControlf WITH &_curwval IN cControlt
 � � � U  THIS PARENT CURRENTCONTROL NAME THISFORM ADDMODE EDITMODE
 FLAGCANCEL SETFS SETVALUE
 LOCKSCREEN	 _CURFLDNO
 CMDCONTROL	 _CURTBLNM _AINFONEWREC AINFOOLDFLD _CURFLD _CURTBL _AINFOOLDREC AINFOOLDREC	 _CURFLDNM REFRESH LISTTBL CCONTROL	 CCONTROLV	 CCONTROLF	 CCONTROLT DEFAEXPR _CURWVAL�  T�  � �a�� T� �� � � �� T� �C� ��� T� �� � � �� T� �C� ���k � ��C� ��]��C� ��]C� ��]�� �  �	 �  �
 � � � �  � � � � � � � � � � � U  THISFORM NOVOUREFRESH CCONTROL THIS PARENT
 CMDCONTROL CCAPTION
 CMDCAPTION	 UENRENTRY ADDMODE EDITMODE NAME	 BACKCOLOR LSTTABLE LSTCOND SPLCHK?  %��  � � �  � ��8 � T�  � �a�� T�  � ���� � U  THISFORM ADDMODE EDITMODE SETFS SETVALUE�  %�C|�	��W �  %��  � � � � � � ��S �# ��C�  � ��� � � � � �� � � %�C|���� �  %��  � � � � � � ��� �/ ��C�  � �� � � � � � � � � � �� � � U  THISFORM
 CUR_ACTCOL THIS PARENT COLUMNCOUNT ACTIVATECELL
 CUR_ACTROW Valid,     �� When�    �� Click�    �� SetFocus	    ��	 LostFocus�	    ��1 �!A A 1� � �Aq� A q�1Qq��A A 1� A 3 q A �!A A !A � �Q� 111� � A ��A A � � A 1q��A �A 11� � 11A�A �Q!A A N 3 � 1� 1� �3 �� A 3 1A A �A A 2  )   �                        ainfocmd      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      commandbutton      commandbutton      cmdextra      |Height = 22
Width = 84
FontSize = 8
Caption = "\<Addl. Info"
PicturePosition = 1
PictureMargin = 2
Name = "cmdextra"
      Class      1      Pixels     \���    C  C                           %   �                          �  U  �) %�C� Thisform.NoVouRefreshb� L��7 � T�  � �a�� � %�C� � � f� COLUMN���� ���  ���� �� � F� � T� �CC+
� CO� � 6��- >� � ��C� � ��\� TC� � �\�� T�	 �a��" %�C� UeTrigVouItFire.Fxp0��� � T�	 �C�
 �� � T� �� �� T� ��� �� H�#�� �� � 0����� T� �C� EXE�� �c Select * From lother  where e_code = ?sql_var  and att_file = .f. and ingrid = .f.  order by serial� lother� thisform.nHandle�� -�� � �� 2��� T� �C� EXE�� �_ Select * From lother  where e_code = ?sql_var  and att_file = 0 and ingrid = 0 order by serial � lother� thisform.nHandle�� -�� � �� �  %�� � � C� lother�	���� F� � T� �CN�� � %�� � ����1 � ��� item_vw��C� item_vwO���� ���� �� �>� %��	 ��:�) ��C� No Additional Info. �0 � �� �� � � %�C� lother���_� Q� � � F� � %�� � ����	 #�� �� � <� � �� � U  THISFORM NOVOUREFRESH THIS PARENT CLASS _XTRAREC ITEM_VW SR_SR IN LL UETRIGVOUITFIRE SQL_REC SQL_VAR PCVTYPE MVU_BACKEND SQL_CON	 SQLCONOBJ DATACONN	 CO_DTBASE DATASESSIONID LOTHER UEEXTRA SHOWMESSAGEBOX VUMESS Click,     ��1 �� A �� q q ��� !� A � � � !2
� �	A q � A � � �A A Q� A q � A q A A 3  )   C                        cmdextra      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      commandbutton      commandbutton      
cmdreceipt      fHeight = 21
Width = 62
FontSize = 8
Caption = "Receipt"
PicturePosition = 2
Name = "cmdreceipt"
      Class      1      Pixels     4���                              �_   %   �                          �  U  ( %��9�  � � WK� C� item_vw�	���, T� �C� � �� uefrm_bomdetailsIP.scx�� %�C� 0��� T� �C�� T� �CO��? � uefrm_OpWkItemAllocation��9�  � �9�  �	 �9�  �
 � � %�C� �
��� � Select &_Malias
 � %�C� �CN���� �	 #�� �� � � � U 
 ACTIVEFORM PCVTYPE FILENM COMPANY DIR_NM _MALIAS _MRECNO UEFRM_OPWKITEMALLOCATION DATASESSIONID ADDMODE EDITMODE THISFORM Click,     ��1 ��� � � �1A A� A A A 2  )                           
cmdreceipt      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      commandbutton      commandbutton      cmdbom      �Height = 21
Width = 62
FontSize = 8
Picture = ..\bmp\finish_item.gif
Caption = "BOM"
SpecialEffect = 0
PicturePosition = 2
Name = "cmdbom"
      Class      1      Pixels     	���    �  �                        ��   %   
                          �  U  � %��  � � WK��� �* T� �C� � �� uefrm_bomdetails.scx�� %�C� 0��� � T� �C�� T� �CO��; � uefrm_bomdetails�� �	 �  �
 �  � �  � � � � %�C� �
��� � Select &_Malias
 � %�C� �CN���� �	 #�� �� � � � %��  � � DC����2 T� �C� � �� uefrm_OpStItemAllocation.scx�� %�C� 0���� T� �C�� T� �CO��9 � uefrm_OpStItemAllocation��  �
 �  � �  � �  � %�C� �
���� Select &_Malias
 � %�C� �CN�����	 #�� �� � � � %��  � � ST����2 T� �C� � �� uefrm_OpStItemAllocation.scx�� %�C� 0���� T� �C�� T� �CO��. %��  � 
� �  � 
	� C� ItRef_vw�
	��&�W T� ��& SELECT * FROM stitref where entry_ty='C� �	 �� ' and tran_cd=C� � Z��H T� �C� EXE� �  � � ItRef_vw� Thisform.nhandle�  �
 �  � � �� � %�C� ItRef_vw�����> %�C� � �
�
 C� � �
	�
 C� � �
	� � � � DC	����9 � uefrm_DcStItemAllocation��  �
 �  � �  � �  � ���9 � uefrm_OpStItemAllocation��  �
 �  � �  � �  � � �>�9 � uefrm_OpStItemAllocation��  �
 �  � �  � �  � �- %��  � 
� �  � 
	� C� ItRef_vw�	��w� Q� � � %�C� �
���� Select &_Malias
 � %�C� �CN�����	 #�� �� � � � %��  � � IP����, T� �C� � �� uefrm_bomdetailsIP.scx�� %�C� 0���� T� �C�� T� �CO��3 � uefrm_bomdetailsIP��  �
 �  � �  � �  � %�C� �
���� Select &_Malias
 � %�C� �CN�����	 #�� �� � � � %��  � � OP���, T� �C� � �� uefrm_bomdetailsOP.scx�� %�C� 0��{� T� �C�� T� �CO��3 � uefrm_bomdetailsOP��  �
 �  � �  � �  � F� � %�C� �CN���w�	 #�� �� � � � U  THISFORM PCVTYPE FILENM COMPANY DIR_NM _MALIAS _MRECNO UEFRM_BOMDETAILS MAIN_VW ENTRY_TY DATASESSIONID ADDMODE EDITMODE ITEM_VW ITEM UEFRM_OPSTITEMALLOCATION MSQLSTR TRAN_CD NRETVAL	 SQLCONOBJ DATACONN DBNAME ITREF_VW	 RENTRY_TY
 ITREF_TRAN	 RITSERIAL UEFRM_DCSTITEMALLOCATION UEFRM_BOMDETAILSIP UEFRM_BOMDETAILSOP Click,     ��1 a�� � � �1A A� A A A a!� � � �1A A� A A A a!� � � �q�A q��� �A � �A �� A 1A A� A A A c�� � � 11A A� A A A a�� � � 1t A� A A A 2  )   �                        cmdbom      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      commandbutton      commandbutton      cmdexbtn      sHeight = 22
Width = 60
FontSize = 8
Caption = ".. "
PicturePosition = 1
PictureMargin = 2
Name = "cmdexbtn"
      Class      1      Pixels     ���                              ��   %   �                          �  U  
 T�  �C�	 Procedurev�� %�C� � � BP� CP���j �6 � uetdspayment.app�� � �9� � �9� �	 �9� � � %�� vutex�
 ��� H�� ��' �� � � AR� � � � AR��B� %�C� � � f� COLUMN���( %�C� � � EXCISE�
 NON-EXCISE���� � UeEtItDetInAR�� � � �>� � UeEtDetailInAR�� � �' �� � � DC� � � � DC���� %�C� � � f� COLUMN����( %�C� � � EXCISE�
 NON-EXCISE����� � UeEtItDetInDC�� � � ��� � UeEtDetailInDC�� � �' �� � � SS� � � � SS���� %�C� � � f� COLUMN��~�( %�C� � � EXCISE�
 NON-EXCISE���z� � UeEtItDetInDC�� � � �' �� � � IR� � � � IR��3� %�C� � � f� COLUMN���( %�C� � � EXCISE�
 NON-EXCISE���	� � UeEtItDetInDC�� � � �/� � UeEtDetailInIR�� � �' �� � � GT� � � � GT��� %�C� � � f� COLUMN����( %�C� � � EXCISE�
 NON-EXCISE����� %�� � 
���� � UeEtItDetInAR�� � ��� � UeEtItDetInDC�� � � � �� � UeEtDetailInGT�� � � � �: %�� vuser�
 � � vuexc�
 
	� � vutex�
 
	���� %�C� � � PT� P1�����1 � UEFRM_PT_EXDATA1�� � �9� � �9� �	 � � � %�� vuser�
 ��� %�C� � � JV����1 � UEFRM_JV_EXDATA1�� � �9� � �9� �	 � � � %�� vuexc�
 ��g� %�C� � � ST���u�1 � UEFRM_ST_EXDATA1�� � �9� � �9� �	 � � %�C� � � VI�����1 � UEFRM_SERVICETAX�� � �9� � �9� �	 � ��9� � � � � � ��9� � � �  � � �6 %�C� � � PT� P1�� C� � ��
 MODVATABLE	��V�1 � UEFRM_PT_EXDATA1�� � �9� � �9� �	 � � %�C� � � SR�����1 � UEFRM_SR_EXDATA1�� � �9� � �9� �	 � � %�C� � � EP� SB�����1 � UEFRM_SERTAX_DET�� � �9� � �9� �	 � � %�C� � � GI���N�@ � uedutydebit.app�� � �9� � �9� �	 �9� �� RG23A�� � %�C� � � HI�����@ � uedutydebit.app�� � �9� � �9� �	 �9� �� RG23C�� � %�C� � � RR����> � uedutydebit.app�� � �9� � �9� �	 �9� �� PLA�� � %�C� � � VR���c�F � uedutydebit.app�� � �9� � �9� �	 �9� �� SERVICE TAX�� � � ��$ � F� �m T�% ��B SELECT * FROM lother WHERE att_file=1 and defa_fld =1 and e_code='C� � �� ' order by serial��F T�& �C� EXE�) �*  �% � lother� thisform.nHandle� � � �' �( �� %��& � ��D	� B�-�� � T�+ �� ��  %��& � � C� lother�	���	� F�, � T�+ �CN�� � %��+ � ���	�1 �- ��� main_vw��C� main_vwO�� � � � �
 �� � � � %�C� lother����	� Q�, � � F� � U.  VSTPROC MAIN_VW ENTRY_TY UETDSPAYMENT APP THISFORM DATASESSIONID
 ACTIVEFORM ADDMODE EDITMODE VCHKPROD PCVTYPE BEHAVE THIS PARENT CLASS RULE UEETITDETINAR UEETDETAILINAR UEETITDETINDC UEETDETAILINDC UEETDETAILINIR U_SINFO UEETDETAILINGT UEFRM_PT_EXDATA1 UEFRM_JV_EXDATA1 UEFRM_ST_EXDATA1 UEFRM_SERVICETAX VOUPAGE PAGE3 TXTNETAMOUNT REFRESH
 GRDACCOUNT UEFRM_SR_EXDATA1 UEFRM_SERTAX_DET UEDUTYDEBIT _XTRAREC SQ1 NRETVAL	 SQLCONOBJ DATACONN COMPANY DBNAME SQL_REC LOTHER UEEXTRA  ��  � � � � U  NBUTTON NSHIFT NXCOORD NYCOORD  ��  � � � � U  NBUTTON NSHIFT NXCOORD NYCOORD Click,     ��
 MouseLeave?    ��
 MouseEnter|    ��1 0��aA b� q���A � �A r���A � �A r���A A r���A � �A r���� �A A � �A A A ��A A aqA A cqA qQQA aA qA �A rA qA q�A qaA B r q �aq A � q � A � A Q� A q 4 13 12  )                           cmdexbtn      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      commandbutton      commandbutton      cmdnarr      �Height = 22
Width = 84
FontSize = 8
Caption = "Narration"
PicturePosition = 1
PictureMargin = 2
cmdcaption = .F.
lsttable = .F.
lstcond = .F.
splchk = .F.
cmdcontrol = .F.
Name = "cmdnarr"
      Class      1      3cmdcaption
lsttable
lstcond
splchk
cmdcontrol
      Pixels     ����    �  �                        0�   %   �                          �  U  ) %�C� Thisform.NoVouRefreshb� L��7 � T�  � �a�� � T� ��  � �� T� ��  � ��& %�C� thisform.cmdNarwhnb� L��� � %��  � -��� � T� �-�� T� �-�� � �b � ��C� ��]��C� ��]C� ��]�� �	 � � � �
 � � �  � � � � � � � � U  THISFORM NOVOUREFRESH _CMDNARRADDMODE ADDMODE _CMDNARREDITMODE EDITMODE	 CMDNARWHN	 UENRENTRY THIS
 CMDCONTROL NAME
 CMDCAPTION	 BACKCOLOR LSTTABLE LSTCOND SPLCHK?' ��  � � � � � � � � � %�C� ntopb� N��L � T�  �� �� � %�C� nleftb� N��v � T� �� �� � %�C� nheightb� N��� � T� �� �� � %�C� nWidthb� N��� � T� �� �� � %�C� cControlb� C��� � T� ��  �� � %�C� cCaptionb� C��'� T� ��  �� � %�C�	 cLsttableb� C��U� T� ��  �� � %�C� cLstcondb� C���� T� ��  �� � T� �-�� T�	 �
 �� �� T�	 � ��  �� T�	 � �� �� T�	 � ���� T�	 � �C� ��� T�	 � �C� ��� T�	 � �C� ��� T�	 � �C� ��� T�	 � �� �� T�	 � ��	 � �� U  NTOP NLEFT NHEIGHT NWIDTH CCONTROL CCAPTION	 CLSTTABLE CLSTCOND CSPLCHK THIS LEFT TOP HEIGHT FONTSIZE
 CMDCONTROL
 CMDCAPTION LSTTABLE LSTCOND SPLCHK CAPTION Click,     �� Init�    ��1 �� A a!� � A A &3 q�� A �� A �� A �� A �� A �� A �� A �� A � !!!!11  )   �                        cmdnarr      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      textbox      textbox      txtxtra     QFontSize = 8
BorderStyle = 0
Height = 22
Margin = 0
TabIndex = 1
Width = 100
ForeColor = 255,255,255
BackColor = 0,0,255
DisabledBackColor = 228,220,250
SelectedForeColor = 255,255,255
DisabledForeColor = 0,0,0
SelectedBackColor = 0,0,255
defaexpr = .F.
defahelp = .F.
helptype = .F.
defahelpcond = .F.
Name = "txtxtra"
      Class      1      Jwhenexpr
validexpr
cerrmsg
defaexpr
defahelp
helptype
defahelpcond
      Pixels      2textbox for getting values from user for extradata     u���    \  \                        Ft	   %   H                          �  U  � ��  �" %�� � � � � � �  	����* T� �CCC��� ]fC� � f� THISFORM���! %�� � � COMMANDBUTTON��� �C ��C � C� ��]C� ��]C� ��]�C� ��]C� ��]� � �� � %�� � � LISTBOX���� %�C� �	 �
��5�L ��C � �� �	 C� ��]C� ��]C� ��]C� ��]C� ��]�� �
 �� ���L ��C � �� � C� ��]C� ��]C� ��]C� ��]C� ��]�� �
 �� � � � U  _HELPREQ THISFORM ADDMODE EDITMODE _CUROBJNAME THIS NAME HELPTYPE GRDCMDSDCGF LISTTBL GRDLSTSDCGF DEFAHELP  U  �  %��  � � �  � ��� � T�  � ��  �� %�C� � ��
 C� � �
	��\ � T� � �� � �� � %�C� � �
��� � T� �C� � ��� %�C� _curvalb� L��� � %�� -��� �	 B�� �� � �� � T� � �� �� � � � U	  THISFORM ADDMODE EDITMODE LISTTBL THIS VALUE DEFAEXPR WHENEXPR _CURVAL�/ ��  � � � � � � � � �	 �
 � %�C� ntopb� N��T � T�  �� �� � %�C� nleftb� N��~ � T� �� �� � %�C� nheightb� N��� � T� �� �� � %�C� nWidthb� N��� � T� �� �� � %�C� csourceb� C��� T� ��  �� � %�C� cwhenb� C��+� T� ��  �� � %�C� cdefaultb� C��X� T� ��  �� � %�C� cvalidb� C���� T� ��  �� � %�C� cerrorb� C���� T� ��  �� � %�C� chelpb� C���� T�	 ��  �� � T� � ��	 �� %�C�	 �
��3�7 T�	 �CC� {�	 � � C�	 �C� {�	 �\� �	 6�� � %�C�	 cHelptypeb� C��a� T�
 ��  �� � T� � �� �� T� � ��  �� T� � �� �� T� � �� ��� T� � �� �� T� � �� �� T� � ���� T� � �C� ��� T� � �C� ��� T� � �C� ��� T� � �C� ��� T� � �C�	 ��� T� � �C�
 ��� %�C�	 Lother_vw�����I %�CC� Lother_vw.Data_Ty�f� N� CC� Lother_vw.Data_Ty�f� DE����  T� �C� Lother_vw.fld_wid���$ %�C� Lother_vw.fld_dec�� ��H�) T� �� C� Lother_vw.fld_dec����5 T� �C� 9� Q� .C� 9C� Lother_vw.fld_dec�Q�� �c� T� �C� 9� Q�� � T� � �� �� T� � �� �� � � U  NTOP NLEFT NHEIGHT NWIDTH CSOURCE CWHEN CDEFAULT CVALID CERROR CHELP	 CHELPTYPE THIS DEFAHELPCOND LEFT TOP HEIGHT WIDTH	 MAXLENGTH CONTROLSOURCE FONTSIZE DEFAEXPR WHENEXPR	 VALIDEXPR CERRMSG DEFAHELP HELPTYPE NL FORMAT	 INPUTMASK  U  � ��  � � %�� � � � � ����J %�� � � � � � � C��%	� � � � � � � � C��%	��~ � ��Ca�	 �
 �� �" %�� � � 
� � � � 
	���� %��  ������� T� �C�	 � ���� T� �C�	 � ����! T� �� � CC� f� _VW�  ��� T� �� ��~ T� �C� EXE� � � Select Distinct � �  From � �
  Order By � � _lxtrtbl� This.Parent.nHandle� � � � � ��" %�� � � C� _lxtrtbl�	��� F� � T� ��  ��7 T� �C� _lxtrtbl� Select.. �  � �  -�  �  a� �� %�C� �
��� T�	 � �� �� � �I�( ��C� No Records Found!�  � � � �� �* T� �C� This.Parent.nHandle� � � �� %�C� _lxtrtbl����� Q� � � � � %�� � � ���� %��  ������� T� � �a�� ��C� � � �� T� � �-�� � � %�� � � ���� ��� ���� %�C�  � �z����� �� ���(��� � ����A %�CCC � �� �  ��	 �! �\fCC�	 �" ��	 �! \C�   f��h� T�# ��	 �! ��� T�	 � �C � �� �  �� T�	 �! ��# �� %�CCC � �� �  �>�# ���! T�	 �$ �CCC � �� �  �>�# �� � T�� �% �C � �� �  �� %��� �& � ��P� T�� �' ��� �& �� � T��( �a�� �� !� �|� T��( �-�� � �� � %��  �� �	 �! � 	���� �� ���(��� � ����? %�CCC � �� �  ��	 �! �\fCC�	 �" ��	 �! �\f���� T�# ��	 �! ���! T�	 � �CC � �� �  ��# \�� T�	 �! ��# �� T�� �% �C � �� �  �� %��� �& � ���� T�� �' ��� �& �� � T��( �a�� �� !� ��� T��( �-�� � �� � %��  ���J� %��� �& �� ��B� T�� �& ��� �& ��� T�� �) ��� �& �� T�	 � ��� � �� T��( �a�� �� B� � �� � %��  ����� %��� �& ��� � ���� T�� �& ��� �& ��� T�� �) ��� �& �� T�	 � ��� � �� T��( �a�� �� B� � �� � %��  �� �  �	��\� %��� �& � ��X� %���( a��T� T�	 � �C�� �& �� �  �� T�� � �-��
 ��	 �* � � � � %��  ����� %��	 �! � ���� �� B� � � �� � � U+  NKEYCODE NSHIFTALTCTRL THISFORM ADDMODE EDITMODE CMDSDC VISIBLE TOP LSTSDC THIS MESSAGE LCFLD CONTROLSOURCE LCDBF	 ENTRY_TBL SQL_CON	 SQLCONOBJ DATACONN COMPANY DBNAME DATASESSIONID _LXTRTBL MACNAME UEGETPOP VALUE SHOWMESSAGEBOX VUMESS SQLCONNCLOSE
 CURONMOUSE CLICK X	 LISTCOUNT LIST SELSTART TEXT NCURPOS	 SELLENGTH DISPLAYVALUE	 LISTINDEX TOPINDEX XFOUND SELECTED	 LOSTFOCUS� %��  � � �  � ����' %�CCC� � f�=� SELE� EXEC����� T� �� ��M T� �C� EXE� �	 � � � _xtrtblw� This.Parent.nHandle�  �
 �  � � ��" %�� � � C� _xtrtblw�	��+� F� � T� �C�/��" INDEX on &_sdcflds TAG ListTbl
 T�  � �� _xtrtblw�� T� � �� COMMANDBUTTON�� �[�( ��C� No Records Found!�  � �  � �� �* T� �C� This.Parent.nHandle�  � � �� �6 %�C� � �
� CCC� � f�=� SELE� EXEC�
	���� T� � �� LISTBOX�� � ��Ca� � �� � U  THISFORM ADDMODE EDITMODE THIS DEFAHELP SQL_CON	 SQLCONOBJ DATACONN COMPANY DBNAME DATASESSIONID _XTRTBLW _SDCFLDS LISTTBL HELPTYPE SHOWMESSAGEBOX VUMESS SQLCONNCLOSE MESSAGE  U   %��  � � �  � ��� %��  � a�	 �  � a��= � B� � T� �C� � ���� T� �C� � ����
 F�� �� T�	 �CC+
� CO� � 6��6 %�C� �
 �
� CCC� �
 f�=� SELE� EXEC�
	���� T� �-�� T� �� ,C� �
 �� ,�� T� �� ,C� � �� ,�� %�C� � � ��%� T� �a�� � %�� -����* ��C� Not Found in Master�  � �  � ��
 F�� �� �� %��	 � ����	 #��	 �� � B�� � �� � � %�C� � �
��t� T� �C� � ��� %�C� _curvalb� L��p� %�� -��l� %�C� � �
��0� T� �CC� � Λ�� ��C � �  � �  � �� �
 F�� �� �� %��	 � ��\�	 #��	 �� � B�� � �� � � � ��C�  � �� ��C�  � �� T�  � ��  �� %�C� _xtrtblw����� Q� � � %�C� _xtrtblv����� Q� � � %�C� _lxtrtbl���� Q� � � � U  THISFORM ADDMODE EDITMODE
 FLAGCANCEL
 CURONMOUSE _CURFLD THIS CONTROLSOURCE _CURTBL _CURREC DEFAHELP SQL_FND	 _SDCFLDS1	 _SDCFLDS2 VALUE SHOWMESSAGEBOX VUMESS	 VALIDEXPR _CURVAL CERRMSG _CURMES GRDCMDSDCLF GRDLSTSDCLF LISTTBL _XTRTBLW _XTRTBLV _LXTRTBL Message,     �� Valid?    �� WhenF    �� Init}    ��
 RightClick	    �� KeyPress	    �� GotFocus_    �� SetFocus    ��	 LostFocus    ��1 q !�2A �1�� �A A A 3 `1 ��1A 1!�� � A � A A A 3 ��� A �� A �� A �� A �� A �� A �� A �� A �� A �� A qA �� A A!!!!!!��A�Q� 1A A A 4 P1 � ��� A !!11� �!q � qA � �A �q� A A A 1!� � A A 1� R�A��A �QQA � A A � � A A A ���A�QQA � A A � � A A A ��QA� A A A A A ��QA� A A A A A �Q�� � A A A AA A A A A A A 3 �q� �!q � !��� �A �A aqA � A 3 7 ��A A 11� �a� ��a� A � �� A � A � A A 1!�� 7A�A � A � A � A A A � � q� A q� A q� A A 2  )   \                        txtxtra      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
      	container      	container      grddate      �Width = 198
Height = 17
BackStyle = 0
BorderWidth = 0
activeobjname = Dpk1
cerrmsg = .F.
defaexpr = .F.
validexpr = .F.
whenexpr = .F.
Name = "grddate"
      Class      2      7activeobjname
cerrmsg
defaexpr
validexpr
whenexpr
      Pixels     .���                              |�   %   �                          �  U  �' ��  � � � � � � � � � %�C� ntopb� N��L � T�  �� �� � %�C� nleftb� N��v � T� �� �� � %�C� nheightb� N��� � T� �� �� � %�C� nWidthb� N��� � T� �� �� � %�C� csourceb� C��� � T� ��  �� � %�C� cwhenb� C��#� T� ��  �� � %�C� cdefaultb� C��P� T� ��  �� � %�C� cvalidb� C��{� T� ��  �� � %�C� cerrorb� C���� T� ��  �� � T�	 �
 �C� ��� T�	 � �C� ��� T�	 � �C� ��� T�	 � �C� ��� T� �� This.�	 � ��( &_curobjname..Left           = nLeft
 %�C�	 � � f� COLUMN����+ &_curobjname..Top            = nTop + 1
. &_curobjname..Height         = nHeight - 5
+ &_curobjname..Width     	 = nWidth * 8	
 �[�' &_curobjname..Top            = nTop
. &_curobjname..Height         = nHeight - 5
( &_curobjname..Width     	 = nWidth		
 �$ &_curobjname..FontSize       = 8
* &_curobjname..UControlSource = cSource
 U  NTOP NLEFT NHEIGHT NWIDTH CSOURCE CWHEN CDEFAULT CVALID CERROR THIS DEFAEXPR WHENEXPR	 VALIDEXPR CERRMSG _CUROBJNAME ACTIVEOBJNAME PARENT NAME Init,     ��1 q�� A �� A �� A �� A �� A �� A �� A �� A �� A !!!!������� q��A B�2  )                           dpk      datepicker.vcx      textbox      Dpk1      grddate     $FontName = "Arial"
FontSize = 8
BorderStyle = 0
Height = 18
Left = 0
Margin = 0
TabIndex = 2
Top = 0
ForeColor = 255,255,255
BackColor = 0,0,255
DisabledBackColor = 228,220,250
SelectedForeColor = 255,255,255
DisabledForeColor = 0,0,0
SelectedBackColor = 0,0,255
Name = "Dpk1"
     ����    �  �                        ��   %   �                          �  U  � %��  � � �  � ���� %��  � a�	 �  � a��< � B� � T� �C��� %�� 
��k � �� B�� � �� � T� �C� �	 ����
 F�� ��  T�
 �CCCO�CN�� CO� � 6�� %�C� � � �
���� T� �CC� � � ���� %�C� _curvalb� L���� %�� -���� %�C� � � ���1� T� �� Invalid Date�� �P� T� �CC� � � ���� � ��C � �  � �  � ��
 F�� �� �� %��
 � ����	 #��
 �� � B�� � �� � � � T�  � ��  �� %�CC|�0�9����� \�� {TAB}�� � � U  THISFORM ADDMODE EDITMODE
 FLAGCANCEL OBJCLICKMOVE
 _DEFAVALID THIS VALUE _CURTBL UCONTROLSOURCE _CURREC PARENT	 VALIDEXPR _CURVAL CERRMSG _CURMES SHOWMESSAGEBOX VUMESS LISTTBL3" %�C�  � � � f� COLUMN��M �  %��  � � � �  � � ��I � B�-�� � � T� �C�  � �� dpkcmb��" %�C�  � � � f� COLUMN����) This.Parent.&mcbbtnnm..Top    = 0 - 1
G This.Parent.&mcbbtnnm..Height = This.Parent.Parent.Parent.RowHeight
A This.Parent.&mcbbtnnm..Width  = This.Parent.&mcbbtnnm..Height
a This.Parent.&mcbbtnnm..Left   = (This.Parent.Parent.Width - This.Parent.&mcbbtnnm..Width) + 1
 ��, This.Parent.&mcbbtnnm..Top    = This.Top
/ This.Parent.&mcbbtnnm..Height = This.Height
A This.Parent.&mcbbtnnm..Width  = This.Parent.&mcbbtnnm..Height
: This.Parent.&mcbbtnnm..Left   = This.left + This.Width
 � T� �C��� T� ��  � �� %�C� �
��� %�C� b� T����! This.Value	= Ttod(&_defvalue)
 �� This.Value	= &_defvalue
 � � %�� �	 � � �
 ��,� T� � ��  �� %�C�  � ����� %�C�  � � �
���� T� �CC�  � � ���� %�C� �
���� T�  � �� �� � � � %�C�  � � �
��(� T� �C�  � � ��� %�C� _curvalb� L��� %�� -��� \�� {TAB}�� � �$� T�  � �� �� � � � U  THIS PARENT NAME CURRENTCONTROL MCBBTNNM	 _DEFAWHEN	 _DEFVALUE UCONTROLSOURCE THISFORM ADDMODE EDITMODE LISTTBL VALUE DEFAEXPR _CURVAL WHENEXPR Valid,     �� When�    ��1 ��A A � � A � A 1� aq�� Q�� qA �� A � A � A A A A� A A 3 "q A A �!�q� ���A � A� �A A �!aqA A A aQ�� � A � A A A 2  )   �                        grddate      !Arial, 0, 8, 5, 14, 11, 29, 3, 0
0
   m                   PLATFORM   C                  UNIQUEID   C	   
               TIMESTAMP  N   
               CLASS      M                  CLASSLOC   M!                  BASECLASS  M%                  OBJNAME    M)                  PARENT     M-                  PROPERTIES M1                  PROTECTED  M5                  METHODS    M9                  OBJCODE    M=                 OLE        MA                  OLE2       ME                  RESERVED1  MI                  RESERVED2  MM                  RESERVED3  MQ                  RESERVED4  MU                  RESERVED5  MY                  RESERVED6  M]                  RESERVED7  Ma                  RESERVED8  Me                  USER       Mi                                                                                                                                                                                                                                                                                          COMMENT Class                                                                                               WINDOWS _1O61C2TAZ 878941401      %  2      P  �      �          �              w               COMMENT RESERVED                        �                                                                   WINDOWS _1NS0MG7JU 911641408�      �  �        �      e4          �%  �%  &          W4               WINDOWS _1NS0MG7JU 879059833�p      �p  �p  q  q  r                                                       WINDOWS _1O403W86Q 911641408r      r  ,r  Cr  \r  �r      �r                                               WINDOWS _1O603XLBF 863702772�s      �s  �s  t  t  'u                                                       COMMENT RESERVED                        3u                                                                    uL                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 VERSION =   3.00      label      label      ctl32_progressbarlabel     (FontName = "Tahoma"
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
      wctl32_name
ctl32_version
ctl32_update^
ctl32_declares^
ctl32_bytestostr^
ctl32_init^
ctl32_bind^
ctl32_unbind^
      Class      1     Z_memberdata XML Metadata for customizable properties
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
      Pixels     "���    	  	                        :   %   �                          �  U  p %�C�  � ��� � B� �# %�C� This.LabelStyleb� C��w �6 R,:��' LabelStyle Property must be Character: Ct�� B� � �� � � � H�� ��� ��  � � N��C�1 T� �CC�  � � .Value�� 999,999,999,999_��3 T� �CC�  � � .Maximum�� 999,999,999,999_��3 T� �CC�  � � .Minimum�� 999,999,999,999_�� ��  � � P����' T� �CC�  � � .Percent�� 999%_�� T� �� 100%�� T� �� 0%�� ��  � � B��!�# T� �CC�  � � .Value��  � ��% T� �CC�  � � .Maximum��  � ��% T� �CC�  � � .Minimum��  � �� 2���1 T� �CC�  � � .Value�� 999,999,999,999_��3 T� �CC�  � � .Maximum�� 999,999,999,999_��3 T� �CC�  � � .Minimum�� 999,999,999,999_�� � T� ��  � ��) T� �C� �	 <<Value>>C� ���
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
 ctl32_bind{    �� ctl32_unbind    �� Inits    �� Destroy�    ��1 !A A 2aA A � � R11Rq� R1QQ� 11B ���� 3 �2 q r �2�� 2 � � � 3 1qA �B 3 1�A 2 � 3 � 2  )   	                        ctl32_progressbarlabel      control      control      ctl32_progressbar     �Width = 301
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
      Class      4     Nctl32_hwnd CreateWindowEx return value.
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
      Pixels     <d���    K<  K<                        ��(   %   �3                          �  U  0  %��  � a� �  � � ��$ � B� � ���  ��)� %��� a��� �4 ��C�� � �� ��� ��� ���	 ��� �� T��
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
 min_assign�$    �� hwnd_assign}%    �� reset�%    �� orientation_assign�%    �� vertical_assign�&    �� themes_assign'(    �� ctl32_themes�)    �� flat_assign�)    �� bordercolor_assign�*    �� instatusbar_assigna+    �� repeat_assign�+    �� width_assign�,    �� height_assignC-    �� u_strtolong.    �� InitO.    �� Destroy�3    ��1 A A � F� � 11� � � � � A GB 4 t ��A A "�3 t ��A A "!s1A 3 t ��A A "!s1A 5 q �1� � � A A ��A A ""� A C� � A 3 v �1� � � A A ��A A "BA A "11� 11A 4 p� � A A � � �� � A � A A � A� �� q� �#aA B s � �� �� � 11� � � � � A QA QA �QA � r� #A � q "� A R� A "� A � !� AA B � � � � � � � � � � B 3 3 � QB�A ��A B}A 2A 23A �A 2#A �1AA A EA "eA "EA 2DA "�A �AdA A �A 3 �q��5 BA A rAQq6 s ��A A "�5 t r �!A �B A �B A c1!� A �C1A : � 3 t #!� A � 2 t ��A A "bA A bA A � b!A b!A B "C�A 7 �5 q �1� � � A A ��A A "C� � A 4 z �1A bA BqA "�C 3 z �!A bA B1A "�B 3 q �1� � � A A ��A A �A A ""1A b3 q ��A A "B� � � A 3 q A 2 q ��A A "!3 q ��A A "!2 q A 2 14 q ��A A "B� � � A 4 q �1� � � A A ��A A ""� A C� � A 3 q "A A �1� � � A A ��A A "BA A � � 4 12 t �1� � � A A ��A A "B� � A 3 q B�A "3 q "3 q �1� � � A A ��A A "3 q "� �QA A A 3 q "� �QA A A 3 r �� 3 w 21� �� � � A �1A A �A A � � A� CA����� � � � ��A A RA A � A �Q� QA A � � B 4 � 4  )   K<                        label      label      lblControlNameH      ctl32_progressbar      �FontName = "Tahoma"
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
      TRUE      timer      timer      tmrControlTimer      ctl32_progressbar      gTop = 0
Left = -25
Height = 23
Width = 23
Enabled = .F.
Interval = 100
Name = "tmrControlTimer"
      TRUE      ����    �   �                         4S   %   �                           �  U  E  %��  � � � �� � B� �# T�  � � ��  � � �  � � �� U  THIS PARENT HWND VALUE STEP Timer,     ��1 qA A 22  )   �                         label      label      lblControlNameV      ctl32_progressbar     AutoSize = .T.
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
      TRUE      ctl32_progressbarc:\docume~1\ajaiswal\locals~1\temp\ prgcurrmast.fxp .\ frmcurrmast.scx frmcurrmast.sct ..\..\u2\usquare\class\ standardui.vcx standardui.vct ..\..\u2\usquare\bmp\ finish_item.gif datepicker.vcx datepicker.vct vouclass.vcx vouclass.vct ctl32_progressbar.vcx ctl32_progressbar.vct  )         $           	  �
  4   7           �
  �7  4   G           �7  �?  W   o           �?  �[  W   ~           �[  <^  �   �           <^  ag  W   �           ag  ��  W   �           ��  � W   �           � H� W   �           H� �� W   �           �� D W             