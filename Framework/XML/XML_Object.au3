#include-once
#include "XML_Core.au3"

Global $oXML ;Object var to use in the main script - global initialiser
_CreateXMLObject()

Func _CreateXMLObject()	; create XML Class
	Local $XML_Object_Creation = _ShortObjectCreater("[XML Object]", "Send POST/GET Requests or Translate Text."&@CRLF&"Call .__showdetails('methodname/property') for more informations.")

; main functions
	$XML_Object_Creation.create	()
	$XML_Object_Creation.method	("start", 						"_XML_Startup", "Start the XML Object" & @CRLF & "Usage:	$object.start()" )
	$XML_Object_Creation.method	("post", 						"_XML_Post" )
	$XML_Object_Creation.method	("get", 						"_XML_Get" )
	$XML_Object_Creation.method	("action", 						"_XML_Action" )
	$XML_Object_Creation.method	("_send", 						"_XML_SendWithAgent" )
	$XML_Object_Creation.method	("response",					"_XML_ResponseText" )
	$XML_Object_Creation.method	("agent", 						"_XML_Agent" )
	$XML_Object_Creation.method	("close", 						"_XML_Close" )

	$XML_Object_Creation.method	("setResponse", 				"_XML_SetResponseText" )
	$XML_Object_Creation.method	("getResponse", 				"_XML_GetResponseText" )
	$XML_Object_Creation.method	("setURL", 						"_XML_SetURL" )
	$XML_Object_Creation.method	("getURL", 						"_XML_GetURL" )
	$XML_Object_Creation.method	("close", 						"_XML_Close" )

; translate functions
	$XML_Object_Creation.method	("gTranslate",					"_XML_GoogleTranslateText" )
	$XML_Object_Creation.method	("setTranslateResult",			"_XML_SetGoogleTranslateResult" )
	$XML_Object_Creation.method	("getTranslateResult",			"_XML_GetGoogleTranslateResult" )
	$XML_Object_Creation.prop	("_translateResult")

	$XML_Object_Creation.method	("cleanTranslateResult",		"__XML_CleanTranslateResult" )
	$XML_Object_Creation.method	("_setCleanTranslationResult",	"_XML_SetCleanTranslateResult" )
	$XML_Object_Creation.method	("_getCleanTranslationResult",	"_XML_GetCleanTranslateResult" )
	$XML_Object_Creation.prop	("_cleanTranslateResult")

	$XML_Object_Creation.method	("getLastTranslateURL",			"_XML_GetLastTranslateURL" )

; encoding / decondig
	$XML_Object_Creation.method	("encodeURI",					"_XML_EncodeURI" )
	$XML_Object_Creation.method	("setEncode",					"_XML_SetEncodeURI" )
	$XML_Object_Creation.method	("getEncode",					"_XML_GetEncodeURI" )
	$XML_Object_Creation.method	("decodeURI",					"_XML_DecodeURI" )
	$XML_Object_Creation.prop	("_encode")
	$XML_Object_Creation.prop	("_decode")
	$XML_Object_Creation.prop	("tUrl")

; coding
	$XML_Object_Creation.method	("setCookie", 					"_XML_SetCookie" )
	$XML_Object_Creation.method	("getCookie", 					"_XML_GetCookie" )
	$XML_Object_Creation.method	("getSetCookie",				"_XML_GetSetCookie" )
	$XML_Object_Creation.method	("cLogin",						"_XML_LoginWithCookie" )
	$XML_Object_Creation.prop	("_cookie")

	$XML_Object_Creation.prop	("url")
	$XML_Object_Creation.prop	("_XML_OBJECT")
	$XML_Object_Creation.prop	("_response")

; create XML Object
	$oXML = $XML_Object_Creation.save()
	$XML_Object_Creation = "" ;free up space
EndFunc