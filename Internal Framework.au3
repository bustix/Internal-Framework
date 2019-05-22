;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
;#RequireAdmin
#AutoIt3Wrapper_UseX64=n
Opt("MustDeclareVars", 1)

;Error Handler for the Objects to prevent crashes
Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc"); Initialize

; ### FAST OBJECTS - This is to include at first.
#include "Framework\AutoItObject\FastObject.au3"

; ### UDF COVERTED-OBJECTS
#include "Framework\XML\XML_Object.au3" ; working except cookies & login untestet -> next.

; ### UDF Create Thread
#include "Framework\MULTI_PROCESS\thread.au3\THREAD_Object.au3"

; ### COPROCESS - MULTI PROCESS USAGE

#cs
#Region ###	XML EXAMPLE ### - WORKING
	Global $oXML = _CreateXMLObject() ;Object var to use in the main script - global initialiser
	With $oXML
		Local $r
		;Show informations about the XML Object
			MsgBox(0, "", .__Name & @CRLF & .__Description )

		;Show informations about methods or propertys
			MsgBox(0, "", .__showdetails("code"))

		;Get google.de with our XML object
			.start() ;starts the oxml object
			.setUrl("https://google.de") ;sets the url
			.action("GET",.getUrl()) ;performs a get command
			._send() ;send the request
			.response() ;saves response to ._response
			ConsoleWrite( "![.getResponse()] for ["&.getUrl()&"]  [stringleft(100) to shorten result]" & @CRLF & _
							"-Result:	" & StringLeft(.getResponse(),100) & @CRLF & @CRLF )

		;translate test:
			.gTranslate	( "hallo ich soll ein englischer text werden" )
			ConsoleWrite( "![.gTranslate( 'hallo ich soll ein englischer text werden' )]:" & @CRLF & "----------------------------------------" & @CRLF & _
							"-Result:	" & .getTranslateResult() & @CRLF )
			.close()

		;translate again & restart object:
			.start()
			.gTranslate	( "ich will auch übersetzt werden" )
			ConsoleWrite( "![.gTranslate( 'ich will auch übersetzt werden' )]" & @CRLF & "----------------------------------------" & @CRLF & _
							"-Result:	" & .getTranslateResult() & @CRLF  & @CRLF )
			.close()


		;Get move to evga.com url url - start login
			Local $responseHeader 	= 'Host:translate.googleapis.com|' & _
										'User-Agent:Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0|' & _
										'Accept:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
			Local $url 				= "https://eu.evga.com/"
			.start() 						;	starts the oxml object
			.setUrl($url) 					;	sets the url
			.action("GET",.getUrl()) 		;	performs a get command to the url set with seturl
			._send($responseHeader) 		; 	send action with custom header
			.responseHeader("server") 		;	saves responseheader to ._responseHeader
			ConsoleWrite( "![.getResponseHeader('server')] for ["& .getUrl() &"]" & @CRLF & _
							"-Result:	" & .getResponseHeader() & @CRLF & @CRLF )

		;Internal Error function test
			ConsoleWrite( "![LAST ERROR]" & @CRLF & _
							"-Last Error Text:	" & ._getError() & @CRLF & _
							"-Last Error @error:	" & ._getErrorNum() & @CRLF & _
							"-Last Error @extended:	" & ._getErrorExt() &@CRLF &@CRLF )
			.close()

		#cs
		Host: translate.googleapis.com
		User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0
		Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
		Accept-Language: de,en-US;q=0.7,en;q=0.3
		Accept-Encoding: gzip, deflate, br
		Connection: keep-alive
		Upgrade-Insecure-Requests: 1

		Accept				text/html,application/xhtml+xm…plication/xml;q=0.9,*/*;q=0.8
		Accept-Encoding		gzip, deflate, br
		Accept-Language		de,en-US;q=0.7,en;q=0.3
		Connection			keep-alive´
		#ce

	EndWith
#EndRegion

#ce

#cs - too much problems, continue with multiprocessing.
#Region ###	THREAD EXAMPLE ### - WORKING

	Global $oTHREAD = _CreateTHREADObject() ;Object var to use in the main script - global initialiser
	With $oTHREAD

		.tStart('_test_one')
		.tStart('_test_two')
		MsgBox(0, 'hi', 'from main thread' )
		.tStop('_test_one')
		.tStop('_test_two')

	EndWith

	Exit ; described as needed, otherwise the main process won't exit

	Func _test_one($hThread)
		MsgBox(0, "hi", "from one" )
	EndFunc
	Func _test_two($hThread)
		MsgBox(0, "hi", "from two" )
	EndFunc

#EndRegion
#ce

#Region ###	THREAD EXAMPLE ### - earm no where to be done.

	Global $oTHREAD = _CreateTHREADObject() ;Object var to use in the main script - global initialiser
	With $oTHREAD

		.tStart('_test_one')
		.tStart('_test_two')
		MsgBox(0, 'hi', 'from main thread' )
		.tStop('_test_one')
		.tStop('_test_two')

	EndWith


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