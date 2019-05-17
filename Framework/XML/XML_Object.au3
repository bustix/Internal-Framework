#include-once
#include "XML_Core.au3"

Global $oXML
_CreateXMLObject()

Func _CreateXMLObject()
	;Function List
	Local $iList =	"### METHODS ###" & @CRLF & _
					"start - Start XML Obj" & @CRLF & _
					"post(url,flag) - Post Command" & @CRLF & _
					"get(url,flag) - Get Command" & @CRLF & _
					"response - Response" & @CRLF & _
					"agent(agent) - Set Agent" & @CRLF & _
					"close() - Shutdown XML" & @CRLF & @CRLF & _
					"### PROPERTYS ###" & @CRLF & _
					"url = set using url" & @CRLF & @CRLF & _
					"### INTERNAL PROPERTYS ###" & @CRLF & _
					"__obj = Address of the Object" & @CRLF & _
					"__Name = Name of the Object" & @CRLF & _
					"__Description = set using url" & @CRLF & _
					"_XML_OBJECT - INTERNAL OBJ USAGE"

	; create XML Class
	Local $XML_Object_Creation = _ShortObjectCreater("XML Object", $iList)
	$XML_Object_Creation.create	()
	$XML_Object_Creation.method	("start", 	"_XML_Startup" )
	$XML_Object_Creation.method	("post", 	"_XML_Post" )
	$XML_Object_Creation.method	("get", 	"_XML_Get" )
	$XML_Object_Creation.method	("action", 	"_XML_Action" )
	$XML_Object_Creation.method	("response","_XML_ResponseText" )
	$XML_Object_Creation.method	("agent", 	"_XML_Agent" )
	$XML_Object_Creation.method	("close", 	"_XML_Close" )
	$XML_Object_Creation.prop	("url")
	$XML_Object_Creation.prop	("_XML_OBJECT")
	$XML_Object_Creation.prop	("_response")

	; create XML Object
	$oXML = $XML_Object_Creation.save()
EndFunc



#cs
$oHTTP = _XML_Startup()
#cs
$oHTTP.Open("POST", $url, False)
$oHTTP.Send()
#ce
$oHTTP = _XML_Action($oHTTP, "POST", $url, False)
$oHTTP = _XML_Get($oHTTP,$url,False)
$sData = $oHTTP.ResponseText
ConsoleWrite( $sData )
#ce

