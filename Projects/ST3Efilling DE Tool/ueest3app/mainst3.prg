*:*****************************************************************************
*:        Program: Main
*:         System: Udyog Software
*:         Author: Rupesh
*:  Last modified: 
*:			AIM  : Call ueest3.exe
*:*****************************************************************************
LOCAL fpath
fpath=""

oWSHELL = CREATEOBJECT("WScript.Shell")
IF VARTYPE(oWSHELL) <> "O"
	MESSAGEBOX("WScript.Shell Object Creation Error...",16,VuMess)
	RETURN .F.
ENDIF

fpath=STRTRAN(apath,' ','<*#*>')
vicopath=STRTRAN(icopath,' ','<*#*>')

SqlConObj = NEWOBJECT('SqlConnUdObj','SqlConnection',xapps)
mvu_user1 = SqlConObj.dec(SqlConObj.ondecrypt(mvu_user))
mvu_pass1 = SqlConObj.dec(SqlConObj.ondecrypt(mvu_pass))
_ShellExec = fpath+"ueST3DataTool.exe " +ALLTRIM(company.dbname)+" "+ALLTRIM(mvu_server)+" "+ALLTRIM(mvu_user1)+" "+ALLTRIM(mvu_pass1)+" "+ALLTRIM(fpath)+" "+ALLTRIM(str(company.compid))+" "+ALLTRIM(vicopath)
ON ERROR 
aa=oWSHELL.Run(_ShellExec,1,.t.)
SqlConObj = NULL
mvu_user1 = NULL
mvu_pass1 = NULL


RELEASE SqlConObj,mvu_user1,mvu_pass1,oWSHELL
Clear Events