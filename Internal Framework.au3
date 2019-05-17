;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_UseX64=n
;#RequireAdmin
Opt("MustDeclareVars", 1)

;Error Handler for the Objects to prevent crashes
Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc"); Initialize

; ### FAST OBJECT INCLUDE - This is to include at first.
#include "Framework\AutoItObject\FastObject.au3"

; ### OBJECTS INCLUDE
#include "Framework\XML\XML_Object.au3"
#Region ###	XML EXAMPLE ###
; XML EXAMPLE - WORKING
	$oXML.start();
	$oXML.url = "http://google.de"
	$oXML.action("GET",$oXML.url);
	$oXML.response()
	ConsoleWrite( "!RESPONSE: " & $oXML.RESPONSE & @CRLF )
	MsgBox(0, "", $oXML.__Name & @CRLF & $oXML.__Description )
#EndRegion


Exit


Func MyErrFunc()
  ConsoleWrite("! [AutoIt-COM Test]We intercepted a COM Error !"    		& @CRLF & @CRLF & _
             "	err.description is: " & @TAB & $oMyError.description  		& @CRLF & _
             "	err.windescription:"   & @TAB & $oMyError.windescription 	& @CRLF & _
             "	err.number is: "       & @TAB & hex($oMyError.number,8)  	& @CRLF & _
             "	err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   	& @CRLF & _
             "	err.scriptline is: "   & @TAB & $oMyError.scriptline   		& @CRLF & _
             "	err.source is: "       & @TAB & $oMyError.source       		& @CRLF & _
             "	err.helpfile is: "       & @TAB & $oMyError.helpfile    	& @CRLF & _
             "	err.helpcontext is: " & @TAB & $oMyError.helpcontext 		& @CRLF & _
             "	@ScriptLineNumber is: "  & @TAB & @ScriptLineNumber     	& @CRLF _
			 )

Endfunc