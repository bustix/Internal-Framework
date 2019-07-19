#include-once
#include "Object_Error_Manager_Core.au3"

;Global $oOBJECTTEMPLATE = _CreateOBJECTTEMPLATEObject() ;Object var to use in the main script - global initialiser

Func _CreateOBJECTTEMPLATEObject()	; create XML Class
	Local $OBJECTTEMPLATE_Creation = _ShortObjectCreater("[OBJECTTEMPLATE Object]", "description"&@CRLF&"Call .__showdetails('methodname/property') for more informations.")

; main functions
	$OBJECTTEMPLATE_Creation.create	()
	$OBJECTTEMPLATE_Creation.method	("",				"" )
	$OBJECTTEMPLATE_Creation.method	("",				"" )
	$OBJECTTEMPLATE_Creation.prop	("")
	$OBJECTTEMPLATE_Creation.prop	("")

	Return $OBJECTTEMPLATE_Creation.save()
EndFunc