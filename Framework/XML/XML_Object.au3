#include-once
#include "XML_Core.au3"

Global $oXML ;Object var to use in the main script - global initialiser
_CreateXMLObject()

Func _CreateXMLObject()	; create XML Class
	Local $XML_Object_Creation = _ShortObjectCreater("[XML Object]", "Send POST/GET Requests or Translate Text."&@CRLF&"Call .__showdetails('methodname/property') for more informations.")

; main functions
	$XML_Object_Creation.create	()
	$XML_Object_Creation.method	("start", 						"_XML_Startup", 			"Start the XML Object" & @CRLF & "Usage:	$object.start()" )
	$XML_Object_Creation.method	("post", 						"_XML_oPost",				"Create a POST command" )
	$XML_Object_Creation.method	("get", 						"_XML_oGet",				"Create a GET command" )
	$XML_Object_Creation.method	("action", 						"_XML_oAction", 			"Create a POST or a GET command" )
	$XML_Object_Creation.method	("_send", 						"_XML_SendWithAgent", 		"Sends the opened request with the optional to add an different requestHeader" )
	$XML_Object_Creation.method	("response",					"_XML_ResponseText",		"Get response test after SEND/_SEND" )
	$XML_Object_Creation.method	("responseHeader",				"_XML_ResponseHeader",		"Get response header after SEND/_SEND" )
	$XML_Object_Creation.method	("close", 						"_XML_Close",				"Shutdown XML Object - can be reused" )
	$XML_Object_Creation.prop	("_XML_OBJECT")

; error function
	$XML_Object_Creation.method	("_setError", 					"_XML_SetError",			"Set Error property _errorText, _errorNum, _errorExt" )
	$XML_Object_Creation.method	("_getError", 					"_XML_GetErrorText",		"Get Error Text property _errorText" )
	$XML_Object_Creation.method	("_getErrorNum", 				"_XML_GetErrorNum",			"Get Error Number property _errorNum" )
	$XML_Object_Creation.method	("_getErrorExt", 				"_XML_GetErrorExt",			"Get Error Extended property _errorExt" )
	$XML_Object_Creation.prop	("_errorText")
	$XML_Object_Creation.prop	("_errorNum")
	$XML_Object_Creation.prop	("_errorExt")

; response text get/set + property
	$XML_Object_Creation.method	("setResponse", 				"_XML_SetResponseText" )
	$XML_Object_Creation.method	("getResponse", 				"_XML_GetResponseText" )
	$XML_Object_Creation.prop	("_response")

;response header get/set + property
	$XML_Object_Creation.method	("setResponseHeader", 			"_XML_SetResponseHeader" )
	$XML_Object_Creation.method	("getResponseHeader", 			"_XML_GetResponseHeader" )
	$XML_Object_Creation.prop	("_responseHeader")

;url get/set + property
	$XML_Object_Creation.method	("setUrl", 						"_XML_SetURL" )
	$XML_Object_Creation.method	("getUrl", 						"_XML_GetURL" )
	$XML_Object_Creation.prop	("url")


;set translate url + translate tUrl property
	$XML_Object_Creation.method	("gTranslate",					"_XML_GoogleTranslateText" )
	$XML_Object_Creation.prop	("tUrl")

;set/get translate result property
	$XML_Object_Creation.method	("setTranslateResult",			"_XML_SetGoogleTranslateResult" )
	$XML_Object_Creation.method	("getTranslateResult",			"_XML_GetGoogleTranslateResult" )
	$XML_Object_Creation.prop	("_translateResult")

;[INTERNAL] clean translate result
	$XML_Object_Creation.method	("cleanTranslateResult",		"__XML_CleanTranslateResult" )
	$XML_Object_Creation.method	("_setCleanTranslationResult",	"_XML_SetCleanTranslateResult" )
	$XML_Object_Creation.method	("_getCleanTranslationResult",	"_XML_GetCleanTranslateResult" )
	$XML_Object_Creation.prop	("_cleanTranslateResult")

	$XML_Object_Creation.method	("getLastTranslateURL",			"_XML_GetLastTranslateURL" )

; encode - set/get + property
	$XML_Object_Creation.method	("encodeURI",					"_XML_EncodeURI" )
	$XML_Object_Creation.method	("setEncode",					"_XML_SetEncodeURI" )
	$XML_Object_Creation.method	("getEncode",					"_XML_GetEncodeURI" )
	$XML_Object_Creation.prop	("_encode")

; decode - set/get + property
	$XML_Object_Creation.method	("decodeURI",					"_XML_DecodeURI" )
	$XML_Object_Creation.method	("setDecode",					"_XML_SetDecodeURI" )
	$XML_Object_Creation.method	("getDecode",					"_XML_GetDecodeURI" )
	$XML_Object_Creation.prop	("_decode")

; request header + property
	$XML_Object_Creation.method	("requestHeader", 				"_XML_SetRequestHeader" )
	$XML_Object_Creation.prop	("_requestHeader")

; cookie get/set + property
	$XML_Object_Creation.method	("setCookie", 					"_XML_SetCookie" )
	$XML_Object_Creation.method	("getCookie", 					"_XML_GetCookie" )
	$XML_Object_Creation.prop	("_cookie")


; [INTERNAL] cookie functions
	$XML_Object_Creation.method	("_generateRandomCookie",		"_XML_GenerateRandomCookie" )
	$XML_Object_Creation.method	("_getRandCookie",				"_XML_SetGeneratedRandomCookie" )
	$XML_Object_Creation.method	("_setRandCookie",				"_XML_GetGeneratedRandomCookie" )
	$XML_Object_Creation.prop	("__rCookie")

	$XML_Object_Creation.method	("getSetCookie",				"_XML_GetSetCookie" )

	$XML_Object_Creation.method	("cLogin",						"_XML_LoginWithCookie" )



; create XML Object
	$oXML = $XML_Object_Creation.save()
	$XML_Object_Creation = "" ;free up space
EndFunc