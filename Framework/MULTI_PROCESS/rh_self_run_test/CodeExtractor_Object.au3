#include-once
#include "ResourcesEx.au3"
;#include "ResourcesEx_PE.au3"
#include "CodeExtractor_Core.au3"

;Global $oCE = _CreateCodeExtractorObject() ;Object var to use in the main script - global initialiser

Func _CreateCodeExtractorObject()	; create XML Class
	Local $CodeExtractor_Creation = _ShortObjectCreater("[CodeExtractor Object]", "description"&@CRLF&"Call .__showdetails('methodname/property') for more informations.")

; main functions
	$CodeExtractor_Creation.create	()
	$CodeExtractor_Creation.method	("extractSource",		"_CodeExtractor_ExtractSource" )
	$CodeExtractor_Creation.method	("saveSource",			"_CodeExtractor_SaveSourceToFile" )
	$CodeExtractor_Creation.method	("destroyAll",			"_CodeExtractor_destroyAll" )


	$CodeExtractor_Creation.method	("setfSavePath",		"_CodeExtractor_SetCurrentFileSavePath" )
	$CodeExtractor_Creation.method	("getfSavePath",		"_CodeExtractor_GetCurrentFileSavePath" )
	$CodeExtractor_Creation.prop	("_CodeExtractFilePath")

	$CodeExtractor_Creation.method	("setSource",			"_CodeExtractor_SetCurrentSource" )
	$CodeExtractor_Creation.method	("getSource",			"_CodeExtractor_GetCurrentSource" )
	$CodeExtractor_Creation.prop	("_SourceCode")

	$CodeExtractor_Creation.method	("_setfName",			"__CodeExtractor_SetFileName" )
	$CodeExtractor_Creation.method	("_getfName",			"__CodeExtractor_GetFileName" )
	$CodeExtractor_Creation.prop	("_FileName")

	$CodeExtractor_Creation.method	("getError",			"_CodeExtractor_GetError" )
	$CodeExtractor_Creation.method	("_setError",			"_CodeExtractor_SetError" )			; internal
	$CodeExtractor_Creation.method	("_getErrorText",		"_CodeExtractor_GetErrorText" )		; internal
	$CodeExtractor_Creation.method	("_getErrorNum",		"_CodeExtractor_GetErrorNum" )		; internal
	$CodeExtractor_Creation.method	("_getErrorExt",		"_CodeExtractor_GetErrorExt" )		; internal
	$CodeExtractor_Creation.method	("_incError", 			"_CodeExtractor_IncError" )			; internal
	$CodeExtractor_Creation.prop	("_errorText")												; internal
	$CodeExtractor_Creation.prop	("_errorNum")												; internal
	$CodeExtractor_Creation.prop	("_errorExt")												; internal
	$CodeExtractor_Creation.prop	("_errorCount")												; internal

	Return $CodeExtractor_Creation.save()
EndFunc