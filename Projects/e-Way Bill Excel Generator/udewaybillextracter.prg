Para pRange
Set Date TO BRITISH
Set Century On
Set Deleted On
If ! "\datepicker." $ Lower(Set("Classlib"))
	Set Classlib To apath+"class\datepicker.vcx" Additive
Endif

Do Form udFrmeWayBillExtracter
