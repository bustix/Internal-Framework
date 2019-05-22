#include-once
#include "THREAD_Core.au3"

;Global $oTHREAD = _CreateTHREADObject() ;Object var to use in the main script - global initialiser

Func _CreateTHREADObject()	; create XML Class
	Local $THREAD_Object_Creation = _ShortObjectCreater("[THREAD Object]", "Create Threads out of functions."&@CRLF&"Call .__showdetails('methodname/property') for more informations.")

; main functions
	$THREAD_Object_Creation.create	()
	$THREAD_Object_Creation.method	("tStart",				"_THREAD_Start" )
	$THREAD_Object_Creation.method	("tStop",				"_THREAD_Delete" )
	$THREAD_Object_Creation.prop	("tCount")
	$THREAD_Object_Creation.prop	("tResult")

	Return $THREAD_Object_Creation.save()
EndFunc