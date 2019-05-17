;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_UseX64=n
#RequireAdmin
Opt("MustDeclareVars", 1)

; FAST OBJECT INCLUDE
#include "Framework\AutoItObject\FastObject.au3"

; OBJECTS INCLUDE
#include "Framework\XML\XML_Object.au3"
#Region ###	XML EXAMPLE ###
; XML EXAMPLE - WORKING
	$oXML.start();
	$oXML.url = "http://google.de"
	;$oXML.action("GET",$oXML.url);
	$oXML.get($oXML.url);
	$oXML.response()
	ConsoleWrite( $oXML.RESPONSE )
	MsgBox(0, "", $oXML.__Name & @CRLF & $oXML.__Description )
#EndRegion


Exit


