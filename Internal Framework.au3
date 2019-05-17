;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_UseX64=n
;#RequireAdmin
Opt("MustDeclareVars", 1)

;Error Handler for the Objects to prevent crashes
Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc"); Initialize

; ### FAST OBJECTS - This is to include at first.
#include "Framework\AutoItObject\FastObject.au3"

; ### UDF COVERTED-OBJECTS
#include "Framework\XML\XML_Object.au3" ; working except cookies & login untestet -> next.

; ### COPROCESS - MULTI PROCESS USAGE





#Region ###	XML EXAMPLE ### - WORKING

	;Show informations about the XML Object
	MsgBox(0, "", $oXML.__Name & @CRLF & $oXML.__Description )

	;Show informations about methods or propertys
	MsgBox(0, "", $oXML.__showdetails("code"))

	$oXML.start() ;starts the oxml object

	$oXML.url = "https://google.de" ;sets the url
	$oXML.action("GET",$oXML.url) ;performs a get command
	$oXML.response() ;saves response to .RESPONSE
	;ConsoleWrite( "![$oXML.RESPONSE] for ["&$oXML.url&"]" & @CRLF & $oXML.RESPONSE & @CRLF )

	;translate test:
	Local $trans
	$oXML.gTranslate( "hallo ich soll ein englischer text werden" )
	$trans = $oXML.getTranslateResult()

	ConsoleWrite( "!Translate:" & @CRLF & "----------------------------------------" & @CRLF & $trans & @CRLF )

	$oXML.close() ;free up memory


	$oXML.start(); reopen for another test
	Local $trans
	$oXML.gTranslate( "ich will auch übersetzt werden" )
	$trans = $oXML.getTranslateResult()
	ConsoleWrite( "!Translate2:" & @CRLF & "----------------------------------------" & @CRLF & $trans & @CRLF )
	$oXML.close() ;free up memory

#EndRegion


Exit


Func MyErrFunc()
  ConsoleWrite("! [AutoIt-COM]	We intercepted a COM Error !"    		& @CRLF & @CRLF & _
             "	err.description is: " & @TAB & $oMyError.description  		& @CRLF & _
             "	err.windescription:"   & @TAB & $oMyError.windescription 	& @CRLF & _
             "	err.number is: "       & @TAB & hex($oMyError.number,8)  	& @CRLF & _
             "	err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   	& @CRLF & _
             "	err.scriptline is: "   & @TAB & $oMyError.scriptline   		& @CRLF & _
             "	err.source is: "       & @TAB & $oMyError.source       		& @CRLF & _
             "	err.helpfile is: "       & @TAB & $oMyError.helpfile    	& @CRLF & _
             "	err.helpcontext is: " & @TAB & $oMyError.helpcontext 		& @CRLF & _
             "	@ScriptLineNumber is: "  & @TAB & @ScriptLineNumber     	& @CRLF & @CRLF _
			 )
Endfunc