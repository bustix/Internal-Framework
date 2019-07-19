#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_SaveSource=y
#Au3Stripper_Parameters=/mo
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#﻿AutoIt3Wrapper_Res_SaveSourceDirecti﻿ve﻿
Opt("MustDeclareVars", 1)
Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc"); Initialize
;#include "Framework\AutoItObject\FastObject.au3"; REMOVED INCLUDE
;#include "Framework\XML\XML_Object.au3" ; working except cookies & login untestet -> next.; REMOVED INCLUDE
;#include "Framework\MULTI_PROCESS\thread.au3\THREAD_Object.au3"; REMOVED INCLUDE
;#include "Framework\MULTI_PROCESS\rh_self_run_test\CodeExtractor_Object.au3"; REMOVED INCLUDE
#cs
#Region ###	XML EXAMPLE ### - WORKING
	Global $oXML = _CreateXMLObject() ;Object var to use in the main script - global initialiser
	With $oXML
		Local $r
			MsgBox(0, "", .__Name & @CRLF & .__Description )
			MsgBox(0, "", .__showdetails("code"))
			.start() ;starts the oxml object
			.setUrl("https://google.de") ;sets the url
			.action("GET",.getUrl()) ;performs a get command
			._send() ;send the request
			.response() ;saves response to ._response
			ConsoleWrite( "![.getResponse()] for ["&.getUrl()&"]  [stringleft(100) to shorten result]" & @CRLF & _
							"-Result:	" & StringLeft(.getResponse(),100) & @CRLF & @CRLF )
			.gTranslate	( "hallo ich soll ein englischer text werden" )
			ConsoleWrite( "![.gTranslate( 'hallo ich soll ein englischer text werden' )]:" & @CRLF & "----------------------------------------" & @CRLF & _
							"-Result:	" & .getTranslateResult() & @CRLF )
			.close()
			.start()
			.gTranslate	( "ich will auch übersetzt werden" )
			ConsoleWrite( "![.gTranslate( 'ich will auch übersetzt werden' )]" & @CRLF & "----------------------------------------" & @CRLF & _
							"-Result:	" & .getTranslateResult() & @CRLF  & @CRLF )
			.close()
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
#ce
#Region ###	CodeExtractor EXAMPLE ### (From Executable Resources)
	Global $oCE = _CreateCodeExtractorObject() ;Object var to use in the main script - global initialiser
	With $oCE
		.extractSource('TEST')
		.saveSource(@ScriptDir, "Complete_Source_from_RC_DATA.txt")
			ConsoleWrite( .getError("saveSource", "get source from RC_DATA") )
			ConsoleWrite( "error text only:" & @CRLF & ._errorText & @CRLF & @CRLF )
		MsgBox(0,"",.getError("saveSource",  "get source from RC_DATA"))
		.destroyAll()
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
Global Const $__OBJECTTEMPLATE_CONST_WHATEVER 	= "[##%R!E)P]L[A(C!E%##]"
	Func _OBJECTTEMPLATE_Start($oSelf, $function)
	EndFunc
	Func _OBJECTTEMPLATE_Delete($oSelf, $handle )
	EndFunc
	Func _OBJECTTEMPLATE_SetError($oSelf,$t,$er=@error,$ex=@extended)
		$oSelf._errorText = $t
		$oSelf._errorNum = $er
		$oSelf._errorExt = $ex
	EndFunc
	Func _OBJECTTEMPLATE_GetErrorText($oSelf)
		Return $oSelf._errorText
	EndFunc
	Func _OBJECTTEMPLATE_GetErrorNum($oSelf)
		Return $oSelf._errorNum
	EndFunc
	Func _OBJECTTEMPLATE_GetErrorExt($oSelf)
		Return $oSelf._errorExt
	EndFunc
Global Const $__GOOGLE_TRANSLATE_TEXT_DELIM 	= "[##%R!E)P]L[A(C!E%##]"
Global Const $__GOOGLE_TRANSLATE_URL 			= "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl="&$__GOOGLE_TRANSLATE_TEXT_DELIM&"&dt=t&q="
Global Const $__GOOGLE_TRANSLATE_REQHEADER		= 'Host:translate.googleapis.com|User-Agent:Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0|Accept:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
#Region --- Basic XML Commands
	Func _XML_Startup($oSelf)
		Local $obj = ObjCreate("MSXML2.ServerXMLHTTP.6.0");ObjCreate("Microsoft.XMLHTTP") <- deprecated/rly old
		$oSelf._XML_OBJECT = $obj
		$oSelf._setError("No Error")
		If IsObj($oSelf._XML_OBJECT) Then Return SetError(0, 0, "Startup: [ok]")
		Return SetError(-1,0,  $oSelf._setError("Startup: [Object creation error]"))
	EndFunc
	Func _XML_oPost($oSelf, $post, $flag= False )
		$oSelf._XML_OBJECT.Open("POST", $post, $flag)
		If @error Then Return SetError( @error, @extended, $oSelf._setError("Post: error",@error,@extended) )
		Return SetError( 0, 0, "Post: [ok]" )
	EndFunc
	Func _XML_oGet($oSelf, $get, $flag = False )
		$oSelf._XML_OBJECT.Open("GET", $get)
		If @error Then Return SetError( @error, @extended, $oSelf._setError("Get: error",@error,@extended) )
		Return SetError( 0, 0, "Get: [ok]" )
	EndFunc
	Func _XML_oAction($oSelf, $a, $post, $flag= False )
		$oSelf._XML_OBJECT.Open($a, $post, $flag)
		If @error Then Return SetError( @error, @extended, $oSelf._setError("Action: error",@error,@extended) )
		Return SetError( 0, 0, "Action: [ok]" )
	EndFunc
	Func _XML_ResponseText($oSelf)
		$oSelf.setResponse($oSelf._XML_OBJECT.ResponseText)
		If @error Then Return SetError( @error, @extended, $oSelf._setError("ResponseText: error",@error,@extended) )
		Return SetError( 0, 0, "ResponseText: [ok]" )
	EndFunc
	Func _XML_ResponseHeader($oSelf,$field)
		$oSelf.setResponseHeader($oSelf._XML_OBJECT.getResponseHeader($field))
		If @error Then Return SetError( @error, @extended, $oSelf._setError("ResponseHeader: error",@error,@extended) )
		Return SetError( 0, 0, "ResponseHeader: [ok]" )
	EndFunc
	Func _XML_Close($oSelf)
		If IsObj($oSelf._XML_OBJECT) Then Return $oSelf._XML_OBJECT = ""
		Return SetError(-1, 0, "no Object" )
	EndFunc
#EndRegion
#Region --- Method functions
	Func _XML_SendWithAgent($oSelf, $Agent="")
		If ($Agent <> "") Then $oSelf.requestHeader($Agent)
		$oSelf._XML_OBJECT.Send();
	EndFunc
	Func _XML_SetURL($oSelf, $url)
		$oSelf.url = $url
	EndFunc
	Func _XML_GetURL($oSelf)
		Return $oSelf.url
	EndFunc
	Func _XML_SetResponseText($oSelf, $r )
		$oSelf._response = $r
	EndFunc
	Func _XML_GetResponseText($oSelf)
		Return $oSelf._response
	EndFunc
	Func _XML_SetResponseHeader($oSelf, $r)
		$oSelf._responseHeader = $r
	EndFunc
	Func _XML_GetResponseHeader($oSelf)
		Return $oSelf._responseHeader
	EndFunc
	Func _XML_SetEncodeURI($oSelf,$t)
		$oSelf._encode = $t
	EndFunc
	Func _XML_GetEncodeURI($oSelf)
		Return $oSelf._encode
	EndFunc
	Func _XML_SetDecodeURI($oSelf,$t)
		$oSelf._decode = $t
	EndFunc
	Func _XML_GetDecodeURI($oSelf)
		Return $oSelf._decode
	EndFunc
	Func _XML_SetError($oSelf,$t,$er=@error,$ex=@extended)
		$oSelf._errorText = $t
		$oSelf._errorNum = $er
		$oSelf._errorExt = $ex
	EndFunc
	Func _XML_GetErrorText($oSelf)
		Return $oSelf._errorText
	EndFunc
	Func _XML_GetErrorNum($oSelf)
		Return $oSelf._errorNum
	EndFunc
	Func _XML_GetErrorExt($oSelf)
		Return $oSelf._errorExt
	EndFunc
#EndRegion
#Region --- Translate Functions
	Func _XML_GoogleTranslateText($oSelf, $text, $m="GET", $lang="en")
		Local $t, $r
		With $oSelf
			.encodeURI($text)
			.tUrl = StringReplace($__GOOGLE_TRANSLATE_URL,$__GOOGLE_TRANSLATE_TEXT_DELIM,$lang) & .getEncode()
			.action( $m, .tUrl )
			._send($__GOOGLE_TRANSLATE_REQHEADER)
			.response()
			.setTranslateResult(.getResponse())
			.cleanTranslateResult()
			.setTranslateResult(._getCleanTranslationResult())
		EndWith
	EndFunc
	Func _XML_GetCleanTranslateResult($oSelf)
		Return $oSelf._cleanTranslateResult
	EndFunc
	Func _XML_SetCleanTranslateResult($oSelf, $t)
		$oSelf._cleanTranslateResult = $t
	EndFunc
	Func _XML_GetLastTranslateURL($oSelf)
		If ($oSelf.tUrl = "") Then Return SetError(-1, 0, "Use gTranslate first" )
		Return $oSelf.tUrl
	EndFunc
	Func __XML_CleanTranslateResult($oSelf)
		Local $t, $sData, $text = $oSelf.getTranslateResult()
		If ($text = "") Then SetError( -1, 0, "Start a translation first!" )
		$sData = StringRegExpReplace($text, '.*?\["(.*?)(?<!\\)"[^\[]*', "$1" & @CRLF) ; not sure anymore who to kudo for this regex - but it's def. not from me.
		$sData = StringReplace( $sData, "\r", "" )
		$sData = StringReplace( $sData, "\n", "" )
		$sData = StringReplace( $sData, '\"', "" )
		$t = StringSplit( $sData, @CRLF )
		$sData = ""
		For $i = 1 To $t[0]-6
			If $t[$i] <> "" Then
				$sData &= $t[$i] & @CRLF
			EndIf
		Next
		$sData = StringTrimRight($sData, 1)
		$oSelf._setCleanTranslationResult($sData)
	EndFunc
	Func _XML_GetGoogleTranslateResult($oSelf)
		Return $oSelf._translateResult
	EndFunc
	Func _XML_SetGoogleTranslateResult($oSelf, $r)
		$oSelf._translateResult = $r
	EndFunc
	Func _XML_EncodeURI($oSelf, $string) ; Encode by Prog@ndy
		Local $aData = StringSplit(BinaryToString(StringToBinary($string,4),1),"")
		Local $nChar, $sData
		$string=""
		For $i = 1 To $aData[0]
			$nChar = Asc($aData[$i])
			Switch $nChar
				Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
					$sData &= $aData[$i]
				Case 32
					$sData &= "+"
				Case Else
					$sData &= "%" & Hex($nChar,2)
			EndSwitch
		Next
		$oSelf._encode = $sData
	EndFunc
	Func _XML_DecodeURI($oSelf, $string) ; Decode by Prog@ndy
		Local $obj = $oSelf._XML_OBJECT
		Local $aData = StringSplit(StringReplace($string,"+"," ",0,1),"%")
		$string = ""
		For $i = 2 To $aData[0]
			$aData[1] &= Chr(Dec(StringLeft($aData[$i],2))) & StringTrimLeft($aData[$i],2)
		Next
		$oSelf._decode = BinaryToString(StringToBinary($aData[1],1),4)
	EndFunc
#EndRegion
#Region -- AWAITING APPROVAL METHODS
	Func _XML_GetCookie($oSelf, $url, $flag=False)
		$oSelf.post($url,$flag)
		Return $oSelf.getResponse() ; cookie it has to be this
	EndFunc
	Func _XML_GetSetCookie($oSelf, $url, $flag=False)
		Return $oSelf.setCookie($oSelf.getCookie($url,$flag))
	EndFunc
	Func _XML_RequestCookie($oSelf, $url, $flag=False)
		Local $request
		#cs
		__auc=f5dc9c5416a2bcd64dad39b84b9;
		_fbp=fb.1.1555513042478.538265334;
		_ga=GA1.2.1323692892.1555513053;
		.ASPXANONYMOUS=3U4zA4gt1QEkAAAAN2FiZGIwMWItMDRjNy01M2ExLWE0ZjUtNGM2Y2EzOGUzNDYz1x0GJ24T8i77z-S6_eyxfOrQtHA1   <- 92
		#ce
		$request = "__auc=27;__fpb=fb.25;_ga=GA25;.ASPXANONYMOUS=92"
	EndFunc
	Func _XML_SetRequestHeader($oSelf, $header, $delim="|", $cdelim=":") ; sets request header - split multiple items with $delim
		Local $m
		If Not StringInStr($header,$delim) Then ; if not multiline request header
			$m = StringSplit($header,$cdelim)
			If (($m[0] < 2) Or Not IsArray($m)) Then Return SetError(-1, 0, "SetRequestHeader: [header has wrong format (missing =)]")
			$oSelf._XML_OBJECT.setRequestHeader( $m[1], $m[2] )
			$oSelf._requestHeader = $header
			Return SetError(0,0,"SetRequestHeader: [ok]")
		Else ; multiline request header
			Local $x = StringSplit($header, $delim) ;more header
			For $i = 1 To $x[0]
				$m = StringSplit($x[$i],$cdelim)
				If (($m[0] < 2) Or Not IsArray($m)) Then Return SetError(-1, 0, "SetRequestHeader: [header has wrong format (missing =)]")
				$oSelf._XML_OBJECT.setRequestHeader($m[1], $m[2])
			Next
			$oSelf._requestHeader = $header
			Return SetError(0,0,"SetRequestHeader: [ok]")
		EndIf
		Return SetError( -999, 0, "SetRequestHeader: [something went badly wrong- you should never have arrived here]" )
	EndFunc
	Func _XML_GenerateRandomCookie($oSelf, $iLenght)
		Local $r, $rand
		If ($iLenght < 1) Then Return SetError(-1, 0, "GenerateRandomCookie: [Please use a number greater then 0]")
		For $i = 1 To $iLenght
			$rand = Random(0,2,1)
			Switch $rand
				Case 0 ;number
					$r &= Random(0,9,1)
				Case 1 ;lowercase asc
					$r &= Asc(Random( 22, 44, 1 )) ;set correct values
				Case 2 ;upperhase asc
					$r &= Asc(Random( 45, 88, 1 )) ;set correct values
			EndSwitch
		Next
		$oSelf._setRandCookie($r)
		Return SetError(0, 0, "GenerateRandomCookie: [Ok]" )
	EndFunc
		Func _XML_SetGeneratedRandomCookie($oSelf, $c)
			$oSelf.__rCookie = $c
		EndFunc
		Func _XML_GetGeneratedRandomCookie($oSelf)
			Return $oSelf.__rCookie
		EndFunc
		Func _XML_SetCookie($oSelf, $val) ;manually set cookie
			Local $obj = $oSelf._XML_OBJECT
			$oSelf._cookie = $val
			$obj.SetRequestHeader('Cookie', 'key='&$val)
		EndFunc
		Func _XML_LoginWithCookie($oSelf, $url, $cookie)
			Local $obj = $oSelf._XML_OBJECT
			$obj.setCookie($cookie)
		EndFunc
#EndRegion
#cs information gather - possible ways to do
$oHTTP = ObjCreate('winhttp.winhttprequest.5.1')
$oHTTP.Open('POST', 'http://www.shsforums.net/index.php?automodule=downloads&req=download&code=confirm_download&id=141', 1)
$oHTTP.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
$oHTTP.Send()
$oHTTP.WaitForResponse
$ContentDisposition = $oHTTP.GetResponseHeader("Content-Disposition")
$array = StringRegExp($ContentDisposition, 'filename="(.*)"',3)
ConsoleWrite($array[0] & @CRLF)
#ce
Global $__BinaryCall_Kernel32dll = DllOpen('kernel32.dll')
Global $__BinaryCall_Msvcrtdll = DllOpen('msvcrt.dll')
Global $__BinaryCall_LastError = ""
Func _BinaryCall_GetProcAddress($Module, $Proc)
	Local $Ret = DllCall($__BinaryCall_Kernel32dll, 'ptr', 'GetProcAddress', 'ptr', $Module, 'str', $Proc)
	If @Error Or Not $Ret[0] Then Return SetError(1, @Error, 0)
	Return $Ret[0]
EndFunc
Func _BinaryCall_LoadLibrary($Filename)
	Local $Ret = DllCall($__BinaryCall_Kernel32dll, "handle", "LoadLibraryW", "wstr", $Filename)
	If @Error Then Return SetError(1, @Error, 0)
	Return $Ret[0]
EndFunc
Func _BinaryCall_lstrlenA($Ptr)
	Local $Ret = DllCall($__BinaryCall_Kernel32dll, "int", "lstrlenA", "ptr", $Ptr)
	If @Error Then Return SetError(1, @Error, 0)
	Return $Ret[0]
EndFunc
Func _BinaryCall_Alloc($Code, $Padding = 0)
	Local $Length = BinaryLen($Code) + $Padding
	Local $Ret = DllCall($__BinaryCall_Kernel32dll, "ptr", "VirtualAlloc", "ptr", 0, "ulong_ptr", $Length, "dword", 0x1000, "dword", 0x40)
	If @Error Or Not $Ret[0] Then Return SetError(1, @Error, 0)
	If BinaryLen($Code) Then
		Local $Buffer = DllStructCreate("byte[" & $Length & "]", $Ret[0])
		DllStructSetData($Buffer, 1, $Code)
	EndIf
	Return $Ret[0]
EndFunc
Func _BinaryCall_RegionSize($Ptr)
	Local $Buffer = DllStructCreate("ptr;ptr;dword;uint_ptr;dword;dword;dword")
	Local $Ret = DllCall($__BinaryCall_Kernel32dll, "int", "VirtualQuery", "ptr", $Ptr, "ptr", DllStructGetPtr($Buffer), "uint_ptr", DllStructGetSize($Buffer))
	If @Error Or $Ret[0] = 0 Then Return SetError(1, @Error, 0)
	Return DllStructGetData($Buffer, 4)
EndFunc
Func _BinaryCall_Free($Ptr)
	Local $Ret = DllCall($__BinaryCall_Kernel32dll, "bool", "VirtualFree", "ptr", $Ptr, "ulong_ptr", 0, "dword", 0x8000)
	If @Error Or $Ret[0] = 0 Then
		$Ret = DllCall($__BinaryCall_Kernel32dll, "bool", "GlobalFree", "ptr", $Ptr)
		If @Error Or $Ret[0] <> 0 Then Return SetError(1, @Error, False)
	EndIf
	Return True
EndFunc
Func _BinaryCall_Release($CodeBase)
	Local $Ret = _BinaryCall_Free($CodeBase)
	Return SetError(@Error, @Extended, $Ret)
EndFunc
Func _BinaryCall_MemorySearch($Ptr, $Length, $Binary)
	Static $CodeBase
	If Not $CodeBase Then
		If @AutoItX64 Then
			$CodeBase = _BinaryCall_Create('0x4883EC084D85C94889C8742C4C39CA72254C29CA488D141131C9EB0848FFC14C39C97414448A1408453A140874EE48FFC04839D076E231C05AC3', '', 0, True, False)
		Else
			$CodeBase = _BinaryCall_Create('0x5589E58B4D14578B4508568B550C538B7D1085C9742139CA721B29CA8D341031D2EB054239CA740F8A1C17381C1074F34039F076EA31C05B5E5F5DC3', '', 0, True, False)
		EndIf
		If Not $CodeBase Then Return SetError(1, 0, 0)
	EndIf
	$Binary = Binary($Binary)
	Local $Buffer = DllStructCreate("byte[" & BinaryLen($Binary) & "]")
	DllStructSetData($Buffer, 1, $Binary)
	Local $Ret = DllCallAddress("ptr:cdecl", $CodeBase, "ptr", $Ptr, "uint", $Length, "ptr", DllStructGetPtr($Buffer), "uint", DllStructGetSize($Buffer))
	Return $Ret[0]
EndFunc
Func _BinaryCall_Base64Decode($Src)
	Static $CodeBase
	If Not $CodeBase Then
		If @AutoItX64 Then
			$CodeBase = _BinaryCall_Create('0x41544989CAB9FF000000555756E8BE000000534881EC000100004889E7F3A44C89D6E98A0000004439C87E0731C0E98D0000000FB66E01440FB626FFC00FB65E020FB62C2C460FB62424408A3C1C0FB65E034189EB41C1E4024183E3308A1C1C41C1FB044509E34080FF634189CC45881C08744C440FB6DFC1E5044489DF4088E883E73CC1FF0209C7418D44240241887C08014883C10380FB63742488D841C1E3064883C60483E03F4409D841884408FF89F389C84429D339D30F8C67FFFFFF4881C4000100005B5E5F5D415CC35EC3E8F9FFFFFF000000000000000000000000000000000000000000000000000000000000000000000000000000000000003E0000003F3435363738393A3B3C3D00000063000000000102030405060708090A0B0C0D0E0F101112131415161718190000000000001A1B1C1D1E1F202122232425262728292A2B2C2D2E2F30313233', '', 132, True, False)
		Else
			$CodeBase = _BinaryCall_Create('0x55B9FF00000089E531C05756E8F10000005381EC0C0100008B55088DBDF5FEFFFFF3A4E9C00000003B45140F8FC20000000FB65C0A028A9C1DF5FEFFFF889DF3FEFFFF0FB65C0A038A9C1DF5FEFFFF889DF2FEFFFF0FB65C0A018985E8FEFFFF0FB69C1DF5FEFFFF899DECFEFFFF0FB63C0A89DE83E630C1FE040FB6BC3DF5FEFFFFC1E70209FE8B7D1089F3881C074080BDF3FEFFFF63745C0FB6B5F3FEFFFF8BBDECFEFFFF8B9DE8FEFFFF89F083E03CC1E704C1F80209F88B7D1088441F0189D883C00280BDF2FEFFFF6374278A85F2FEFFFFC1E60683C10483E03F09F088441F0289D883C0033B4D0C0F8C37FFFFFFEB0231C081C40C0100005B5E5F5DC35EC3E8F9FFFFFF000000000000000000000000000000000000000000000000000000000000000000000000000000000000003E0000003F3435363738393A3B3C3D00000063000000000102030405060708090A0B0C0D0E0F101112131415161718190000000000001A1B1C1D1E1F202122232425262728292A2B2C2D2E2F30313233', '', 132, True, False)
		EndIf
		If Not $CodeBase Then Return SetError(1, 0, Binary(""))
	EndIf
	$Src = String($Src)
	Local $SrcLen = StringLen($Src)
	Local $SrcBuf = DllStructCreate("char[" & $SrcLen & "]")
	DllStructSetData($SrcBuf, 1, $Src)
	Local $DstLen = Int(($SrcLen + 2) / 4) * 3 + 1
	Local $DstBuf = DllStructCreate("byte[" & $DstLen & "]")
	Local $Ret = DllCallAddress("uint:cdecl", $CodeBase, "ptr", DllStructGetPtr($SrcBuf), "uint", $SrcLen, "ptr", DllStructGetPtr($DstBuf), "uint", $DstLen)
	If $Ret[0] = 0 Then Return SetError(2, 0, Binary(""))
	Return BinaryMid(DllStructGetData($DstBuf, 1), 1, $Ret[0])
EndFunc
Func _BinaryCall_Base64Encode($Src)
	Static $CodeBase
	If Not $CodeBase Then
		If @AutoItX64 Then
			$CodeBase = _BinaryCall_Create('AwAAAARiAQAAAAAAAAArkuFQDAlvIp0qAgbDnjr76UDZs1EPNIP2K18t9s6SNTbd43IB7HfdyPM8VfD/o36z4AmSW2m2AIsC6Af3fKNsHU4BdQKGd0PQXHxPSX0iNqp1YAKovksqQna06NeKMoOYqryTUX4WgpHjokhp6zY2sEFSIjcL7dW3FDoNVz4bGPyZHRvjFwmqvr7YGlNYKwNoh+SYCXmIgVPVZ63Vz1fbT33/QFpWmWOeBRqs4J+c8Qp6zJFsK345Pjw0I8kMSsnho4F4oNzQ2OsAbmIioaQ6Ma2ziw5NH+M+t4SpEeHDnBdUTTL20sxWZ0yKruFAsBIRoHvM7LYcid2eBV2d5roSjnkwMG0g69LNjs1fHjbI/9iU/hJwpSsgl4fltXdZG659/li13UFY89M7UfckiZ9XOeBM0zadgNsy8r8M3rEAAA==')
		Else
			$CodeBase = _BinaryCall_Create('AwAAAARVAQAAAAAAAAAqr7blBndrIGnmhhfXD7R1fkOTKhicg1W6MCtStbz+CsneBEg0bbHH1sqTLmLfY7A6LqZl6LYWT5ULVj6MXgugPbBn9wKsSU2ZCcBBPNkx09HVPdUaKnbqghDGj/C5SHoF+A/5g+UgE1C5zJZORjJ8ljs5lt2Y9lA4BsY7jVKX2vmDvHK1NnSR6nVwh7Pb+Po/UpNcy5sObVWDKkYSCCtCIjKIYqOe3c6k8Xsp4eritCUprXEVvCFi7K5Z6HFXdm3nZsFcE+eSJ1WkRnVQbWcmpjGMGka61C68+CI7tsQ13UnCFWNSpDrCbzUejMZh8HdPgEc5vCg3pKMKin/NavNpB6+87Y9y7HIxmKsPdjDT30u9hUKWnYiRe3nrwKyVDsiYpKU/Nse368jHag5B5or3UKA+nb2+eY8JwzgA')
		EndIf
		If Not $CodeBase Then Return SetError(1, 0, Binary(""))
	EndIf
	$Src = Binary($Src)
	Local $SrcLen = BinaryLen($Src)
	Local $SrcBuf = DllStructCreate("byte[" & $SrcLen & "]")
	DllStructSetData($SrcBuf, 1, $Src)
	Local $DstLen = Int(($SrcLen + 2) / 3) * 4 + 1
	Local $DstBuf = DllStructCreate("char[" & $DstLen & "]")
	Local $Ret = DllCallAddress("uint:cdecl", $CodeBase, "ptr", DllStructGetPtr($SrcBuf), "uint", $SrcLen, "ptr", DllStructGetPtr($DstBuf), "uint", $DstLen)
	If $Ret[0] = 0 Then Return Binary("")
	Return StringMid(DllStructGetData($DstBuf, 1), 1, $Ret[0])
EndFunc
Func _BinaryCall_LzmaDecompress($Src)
	Static $CodeBase
	If Not $CodeBase Then
		If @AutoItX64 Then
			$CodeBase = _BinaryCall_Create(_BinaryCall_Base64Decode('QVcxwEFWQVVBVFVXSInXVkiJzlMx20iB7OgAAABEiiFBgPzgdgnpyQAAAEGD7C1BiMf/wEGA/Cx38THA6wRBg+wJQYjG/8BBgPwId/GLRglEi24FQQ+2zkyJRCQoRQ+2/0HB5xBBiQFBD7bEAcG4AAMAANPgjYQAcA4AAEhjyOjIBAAATInpSInF6L0EAABIicMxwEyJ8kSI4EyLRCQoiNQl//8A/0QJ+EiF24lFAHQoTYXtdCNIjVfzSI1MJDhIg8YNTIkEJE2J6UmJ2EiJ7+g2AAAAicbrBb4BAAAASInp6IQEAACF9nQKSInZMdvodgQAAEiJ2EiBxOgAAABbXl9dQVxBXUFeQV/DVVNBV0FWQVVBVEFQTQHBQVFNicVRVkgB8lJIieX8SYn0iwdMjX8Eik8Cg8r/0+L30olV6Ijhg8r/0+L30olV5ADBiUXsuAEAAACJReCJRdyJRdhIiUXQRSnJKfaDy/8A0bgAAwAA0+BIjYg2BwAAuAAEAARMif/R6fOrvwUAAADoUAMAAP/PdfdEie9EicgrfSDB4ARBifpEI1XoRAHQTY0cR+hAAwAAD4WTAAAAik3sI33k0+eA6Qj22dPuAfe4AQAAAEiNPH++AAEAAMHnCEGD+QdNjbR/bA4AAHI0TInvSCt90A+2P9HnQYnzIf5BAfNPjRxe6O8CAACJwcHuCIPhATnOvgABAAB1DjnGd9jrDE2J8+jQAgAAOfBy9EyJ76pEiclBg/kEcg65AwAAAEGD+QpyA4PBA0EpyelDAgAAT42cT4ABAADomgIAAHUsi0XcQYP5B4lF4BnAi1XY99CLTdCD4AOJVdxBicGJTdhNjbdkBgAA6akAAABPjZxPmAEAAOhfAgAAdUZEicjB4AREAdBNjZxH4AEAAOhHAgAAdWpBg/kHuQkAAAByA4PBAkGJyUyJ70grfdBIO30gD4L9AQAAigdIA33QqumzAQAAT42cT7ABAADoCgIAAIt12HQhT42cT8gBAADo+AEAAIt13HQJi03ci3XgiU3gi03YiU3ci03QiU3YiXXQQYP5B7kIAAAAcgODwQNBiclNjbdoCgAATYnz6LsBAAB1FESJ0CnJweADvggAAABJjXxGBOs2TY1eAuicAQAAdRpEidC5CAAAAMHgA74IAAAASY28RgQBAADrEUmNvgQCAAC5EAAAAL4AAQAAiU3MuAEAAABJifvoYQEAAInCKfJy8gNVzEGD+QSJVcwPg7kAAABBg8EHuQMAAAA50XICidHB4Qa4AQAAAEmNvE9gAwAAvkAAAABJifvoHwEAAEGJwkEp8nLwQYP6BHJ4RInWRIlV0NHug2XQAf/Og03QAkGD+g5zFYnx0mXQi0XQRCnQTY20R14FAADrLIPuBOi6AAAA0evRZdBBOdhyBv9F0EEp2P/OdedNjbdEBgAAwWXQBL4EAAAAvwEAAACJ+E2J8+ioAAAAqAF0Awl90NHn/8516+sERIlV0P9F0EyJ74tNzEiJ+IPBAkgrRSBIOUXQd1RIif5IK3XQSItVGKyqSDnXcwT/yXX1SYn9D7bwTDttGA+C9fz//+gwAAAAKcBIi1UQTCtlCESJIkiLVWBMK20gRIkqSIPEKEFcQV1BXUFfW13DXli4AQAAAOvSgfsAAAABcgHDweMITDtlAHPmQcHgCEWKBCRJg8QBwynATY0cQ4H7AAAAAXMVweMITDtlAHPBQcHgCEWKBCRJg8QBidlBD7cTwekLD6/KQTnIcxOJy7kACAAAKdHB6QVmQQELAcDDKcvB6gVBKchmQSkTAcCDwAHDSLj////////////gbXN2Y3J0LmRsbHxtYWxsb2MASLj////////////gZnJlZQA='))
		Else
			$CodeBase = _BinaryCall_Create(_BinaryCall_Base64Decode('VYnlVzH/VlOD7EyLXQiKC4D54A+HxQAAADHA6wWD6S2I0ID5LI1QAXfziEXmMcDrBYPpCYjQgPkIjVABd/OIReWLRRSITeSLUwkPtsmLcwWJEA+2ReUBwbgAAwAA0+CNhABwDgAAiQQk6EcEAACJNCSJRdToPAQAAItV1InHi0Xkhf+JArgBAAAAdDaF9nQyi0UQg8MNiRQkiXQkFIl8JBCJRCQYjUXgiUQkDItFDIlcJASD6A2JRCQI6CkAAACLVdSJRdSJFCToAQQAAItF1IXAdAqJPCQx/+jwAwAAg8RMifhbXl9dw1dWU1WJ5YtFJAFFKFD8i3UYAXUcVot1FK2SUopO/oPI/9Pg99BQiPGDyP/T4PfQUADRifeD7AwpwEBQUFBQUFcp9laDy/+4AAMAANPgjYg2BwAAuAAEAATR6fOragVZ6MoCAADi+Yt9/ItF8Ct9JCH4iUXosADoywIAAA+FhQAAAIpN9CN97NPngOkI9tnT7lgB916NPH/B5wg8B1qNjH5sDgAAUVa+AAEAAFCwAXI0i338K33cD7Y/i23M0eeJ8SH+AfGNbE0A6JgCAACJwcHuCIPhATnOvgABAAB1DjnwctfrDIttzOh5AgAAOfBy9FqD+gSJ0XIJg/oKsQNyArEGKcpS60mwwOhJAgAAdRRYX1pZWln/NCRRUrpkBgAAsQDrb7DM6CwCAAB1LLDw6BMCAAB1U1g8B7AJcgKwC1CLdfwrddw7dSQPgs8BAACsi338qumOAQAAsNjo9wEAAIt12HQbsOTo6wEAAIt11HQJi3XQi03UiU3Qi03YiU3Ui03ciU3YiXXcWF9ZumgKAACxCAH6Ulc8B4jIcgIEA1CLbczovAEAAHUUi0Xoi33MweADKclqCF6NfEcE6zWLbcyDxQLomwEAAHUYi0Xoi33MweADaghZaghejbxHBAEAAOsQvwQCAAADfcxqEFm+AAEAAIlN5CnAQIn96GYBAACJwSnxcvMBTeSDfcQED4OwAAAAg0XEB4tN5IP5BHIDagNZi33IweEGKcBAakBejbxPYAMAAIn96CoBAACJwSnxcvOJTeiJTdyD+QRyc4nOg2XcAdHug03cAk6D+Q5zGbivAgAAKciJ8dJl3ANF3NHgA0XIiUXM6y2D7gToowAAANHr0WXcOV3gcgb/RdwpXeBOdei4RAYAAANFyIlFzMFl3ARqBF4p/0eJ+IttzOi0AAAAqAF0Awl93NHnTnXs6wD/RdyLTeSDwQKLffyJ+CtFJDlF3HdIif4rddyLVSisqjnXcwNJdfeJffwPtvA7fSgPgnH9///oKAAAACnAjWwkPItVIIt1+Ct1GIkyi1Usi338K30kiTrJW15fw15YKcBA69qB+wAAAAFyAcPB4whWi3X4O3Ucc+SLReDB4AisiUXgiXX4XsOLTcQPtsDB4QQDRegByOsGD7bAA0XEi23IjWxFACnAjWxFAIH7AAAAAXMci0wkOMFkJCAIO0wkXHOcihH/RCQ4weMIiFQkIInZD7dVAMHpCw+vyjlMJCBzF4nLuQAIAAAp0cHpBWYBTQABwI1sJEDDweoFKUwkICnLZilVAAHAg8ABjWwkQMO4///////gbXN2Y3J0LmRsbHxtYWxsb2MAuP//////4GZyZWUA'))
		EndIf
		If Not $CodeBase Then Return SetError(1, 0, Binary(""))
	EndIf
	$Src = Binary($Src)
	Local $SrcLen = BinaryLen($Src)
	Local $SrcBuf = DllStructCreate("byte[" & $SrcLen & "]")
	DllStructSetData($SrcBuf, 1, $Src)
	Local $Ret = DllCallAddress("ptr:cdecl", $CodeBase, "ptr", DllStructGetPtr($SrcBuf), "uint_ptr", $SrcLen, "uint_ptr*", 0, "uint*", 0)
	If $Ret[0] Then
		Local $DstBuf = DllStructCreate("byte[" & $Ret[3] & "]", $Ret[0])
		Local $Output = DllStructGetData($DstBuf, 1)
		DllCall($__BinaryCall_Msvcrtdll, "none:cdecl", "free", "ptr", $Ret[0])
		Return $Output
	EndIf
	Return SetError(2, 0, Binary(""))
EndFunc
Func _BinaryCall_Relocation($Base, $Reloc)
	Local $Size = Int(BinaryMid($Reloc, 1, 2))
	For $i = 3 To BinaryLen($Reloc) Step $Size
		Local $Offset = Int(BinaryMid($Reloc, $i, $Size))
		Local $Ptr = $Base + $Offset
		DllStructSetData(DllStructCreate("ptr", $Ptr), 1, DllStructGetData(DllStructCreate("ptr", $Ptr), 1) + $Base)
	Next
EndFunc
Func _BinaryCall_ImportLibrary($Base, $Length)
	Local $JmpBin, $JmpOff, $JmpLen, $DllName, $ProcName
	If @AutoItX64 Then
		$JmpBin = Binary("0x48B8FFFFFFFFFFFFFFFFFFE0")
		$JmpOff = 2
	Else
		$JmpBin = Binary("0xB8FFFFFFFFFFE0")
		$JmpOff = 1
	EndIf
	$JmpLen = BinaryLen($JmpBin)
	Do
		Local $Ptr = _BinaryCall_MemorySearch($Base, $Length, $JmpBin)
		If $Ptr = 0 Then ExitLoop
		Local $StringPtr = $Ptr + $JmpLen
		Local $StringLen = _BinaryCall_lstrlenA($StringPtr)
		Local $String = DllStructGetData(DllStructCreate("char[" & $StringLen & "]", $StringPtr), 1)
		Local $Split = StringSplit($String, "|")
		If $Split[0] = 1 Then
			$ProcName = $Split[1]
		ElseIf $Split[0] = 2 Then
			If $Split[1] Then $DllName = $Split[1]
			$ProcName = $Split[2]
		EndIf
		If $DllName And $ProcName Then
			Local $Handle = _BinaryCall_LoadLibrary($DllName)
			If Not $Handle Then
				$__BinaryCall_LastError = "LoadLibrary fail on " & $DllName
				Return SetError(1, 0, False)
			EndIf
			Local $Proc = _BinaryCall_GetProcAddress($Handle, $ProcName)
			If Not $Proc Then
				$__BinaryCall_LastError = "GetProcAddress failed on " & $ProcName
				Return SetError(2, 0, False)
			EndIf
			DllStructSetData(DllStructCreate("ptr", $Ptr + $JmpOff), 1, $Proc)
		EndIf
		Local $Diff = Int($Ptr - $Base + $JmpLen + $StringLen + 1)
		$Base += $Diff
		$Length -= $Diff
	Until $Length <= $JmpLen
	Return True
EndFunc
Func _BinaryCall_CodePrepare($Code)
	If Not $Code Then Return ""
	If IsBinary($Code) Then Return $Code
	$Code = String($Code)
	If StringLeft($Code, 2) = "0x" Then Return Binary($Code)
	If StringIsXDigit($Code) Then Return Binary("0x" & $Code)
	Return _BinaryCall_LzmaDecompress(_BinaryCall_Base64Decode($Code))
EndFunc
Func _BinaryCall_SymbolFind($CodeBase, $Identify, $Length = Default)
	$Identify = Binary($Identify)
	If IsKeyword($Length) Then
		$Length = _BinaryCall_RegionSize($CodeBase)
	EndIf
	Local $Ptr = _BinaryCall_MemorySearch($CodeBase, $Length, $Identify)
	If $Ptr = 0 Then Return SetError(1, 0, 0)
	Return $Ptr + BinaryLen($Identify)
EndFunc
Func _BinaryCall_SymbolList($CodeBase, $Symbol)
	If Not IsArray($Symbol) Or $CodeBase = 0 Then Return SetError(1, 0, 0)
	Local $Tag = ""
	For $i = 0 To UBound($Symbol) - 1
		$Tag &=  "ptr " & $Symbol[$i] & ";"
	Next
	Local $SymbolList = DllStructCreate($Tag)
	If @Error Then Return SetError(1, 0, 0)
	For $i = 0 To UBound($Symbol) - 1
		$CodeBase = _BinaryCall_SymbolFind($CodeBase, $Symbol[$i])
		DllStructSetData($SymbolList, $Symbol[$i], $CodeBase)
	Next
	Return $SymbolList
EndFunc
Func _BinaryCall_Create($Code, $Reloc = '', $Padding = 0, $ReleaseOnExit = True, $LibraryImport = True)
	Local $BinaryCode = _BinaryCall_CodePrepare($Code)
	If Not $BinaryCode Then Return SetError(1, 0, 0)
	Local $BinaryCodeLen = BinaryLen($BinaryCode)
	Local $TotalCodeLen = $BinaryCodeLen + $Padding
	Local $CodeBase = _BinaryCall_Alloc($BinaryCode, $Padding)
	If Not $CodeBase Then Return SetError(2, 0, 0)
	If $Reloc Then
		$Reloc = _BinaryCall_CodePrepare($Reloc)
		If Not $Reloc Then Return SetError(3, 0, 0)
		_BinaryCall_Relocation($CodeBase, $Reloc)
	EndIf
	If $LibraryImport Then
		If Not _BinaryCall_ImportLibrary($CodeBase, $BinaryCodeLen) Then
			_BinaryCall_Free($CodeBase)
			Return SetError(4, 0, 0)
		EndIf
	EndIf
	If $ReleaseOnExit Then
		_BinaryCall_ReleaseOnExit($CodeBase)
	EndIf
	Return SetError(0, $TotalCodeLen, $CodeBase)
EndFunc
Func _BinaryCall_CommandLineToArgv($CommandLine, ByRef $Argc, $IsUnicode = False)
	Static $SymbolList
	If Not IsDllStruct($SymbolList) Then
		Local $Code
		If @AutoItX64 Then
			$Code = 'AwAAAASuAgAAAAAAAAAkL48ClEB9jTEOeYv4yYTosNjFNgf81Ag4vS2VP4y4wxFa+4yMI7GDB7CG+xn4JE3cdEVvk8cMp4oIuS3DgTxlcKHGVIg94tvzG/256bizZfGtAETQUCPQjW5+JSx2C/Y4C0VNJMKTlSCHiV5AzXRZ5gw3WFghbtkCCFxWOX+RDSI2oH/vROEOnqc0jfKTo17EBjqX+dW3QxrUe45xsbyYTZ9ccIGySgcOAxetbRiSxQnz8BOMbJyfrbZbuVJyGpKrXFLh/5MlBZ09Cim9qgflbGzmkrGStT9QL1f+O2krzyOzgaWWqhWL6S+y0G32RWVi0uMLR/JOGLEW/+Yg/4bzkeC0lKELT+RmWAatNa38BRfaitROMN12moRDHM6LYD1lzPLnaiefSQRVti561sxni/AFkYoCb5Lkuyw4RIn/r/flRiUg5w48YkqBBd9rXkaXrEoKwPg6rmOvOCZadu//B6HN4+Ipq5aYNuZMxSJXmxwXVRSQZVpSfLS2ATZMd9/Y7kLqrKy1H4V76SgI/d9OKApfKSbQ8ZaKIHBCsoluEip3UDOB82Z21zd933UH5l0laGWLIrTz7xVGkecjo0NQzR7LyhhoV3xszlIuw2v8q0Q/S9LxB5G6tYbOXo7lLjNIZc0derZz7DNeeeJ9dQE9hp8unubaTBpulPxTNtRjog=='
		Else
			$Code = 'AwAAAAR6AgAAAAAAAABcQfD553vjya/3DmalU0BKqABevUb/60GZ55rMwmzpQfPSRUlIl04lEiS8RDrXpS0EoBUe+uzDgZd37nVu9wsJ4fykqYvLoMz3ApxQbTBKleOIRSla6I0V8dNP3P7rHeUfjH0jCho0RvhhVpf0o4ht/iZptauxaoy1zQ19TkPZ/vf5Im8ecY6qEdHNzjo2H60jVwiOJ+1J47TmQRwxJ+yKLakq8QNxtKkRIB9B9ugfo3NAL0QslDxbyU0dSgw2aOPxV+uttLzYNnWbLBZVQbchcKgLRjC/32U3Op576sOYFolB1Nj4/33c7MRgtGLjlZfTB/4yNvd4/E+u3U6/Q4MYApCfWF4R/d9CAdiwgIjCYUkGDExKjFtHbAWXfWh9kQ7Q/GWUjsfF9BtHO6924Cy1Ou+BUKksqsxmIKP4dBjvvmz9OHc1FdtR9I63XKyYtlUnqVRtKwlNrYAZVCSFsyAefMbteq1ihU33sCsLkAnp1LRZ2wofgT1/JtT8+GO2s/n52D18wM70RH2n5uJJv8tlxQc1lwbmo4XQvcbcE91U2j9glvt2wC1pkP0hF23Nr/iiIEZHIPAOAHvhervlHE830LSHyUx8yh5Tjojr0gdLvQ=='
		EndIf
		Local $CodeBase = _BinaryCall_Create($Code)
		If @Error Then Return SetError(1, 0, 0)
		Local $Symbol[] = ["ToArgvW","ToArgvA"]
		$SymbolList = _BinaryCall_SymbolList($CodeBase, $Symbol)
		If @Error Then Return SetError(1, 0, 0)
	EndIf
	Local $Ret
	If $IsUnicode Then
		$Ret = DllCallAddress("ptr:cdecl", DllStructGetData($SymbolList, "ToArgvW"), "wstr", $CommandLine, "int*", 0)
	Else
		$Ret = DllCallAddress("ptr:cdecl", DllStructGetData($SymbolList, "ToArgvA"), "str", $CommandLine, "int*", 0)
	EndIf
	If Not @Error And $Ret[0] <> 0 Then
		_BinaryCall_ReleaseOnExit($Ret[0])
		$Argc = $Ret[2]
		Return $Ret[0]
	Else
		Return SetError(2, 0, 0)
	EndIf
EndFunc
Func _BinaryCall_StdioRedirect($Filename = "CON", $Flag = 1 + 2 + 4)
	Static $SymbolList
	If Not IsDllStruct($SymbolList) Then
		Local $Code, $Reloc
		If @AutoItX64 Then
			$Code = 'AwAAAASjAQAAAAAAAAAkL48ClEB9jTEOeYv4yYTosNjFM1rLNdMULriZUDxTj+ZdkQ01F5zKL+WDCScfQKKLn66EDmcA+gXIkPcZV4lyz8VPw8BPZlNB5KymydM15kCA+uqvmBc1V0NJfzgsF0Amhn0JhM/ZIguYCHxywMQ1SgKxUb05dxDg8WlX/2aPfSolcX47+4/72lPDNTeT7d7XRdm0ND+eCauuQcRH2YOahare9ASxuU4IMHCh2rbZYHwmTNRiQUB/8dLGtph93yhmwdHtyMPLX2x5n6sdA1mxua9htLsLTulE05LLmXbRYXylDz0A'
			$Reloc = 'AwAAAAQIAAAAAAAAAAABAB7T+CzGn9ScQAC='
		Else
			$Code = 'AwAAAASVAQAAAAAAAABcQfD553vjya/3DmalU0BKqABaUcndypZ3mTYUkHxlLV/lKZPrXYWXgNATjyiowkUQGDVYUy5THQwK4zYdU7xuGf7qfVDELc1SNbiW3NgD4D6N6ZM7auI1jPaThsPfA/ouBcx2aVQX36fjmViTZ8ZLzafjJeR7d5OG5s9sAoIzFLTZsqrFlkIJedqDAOfhA/0mMrkavTWnsio6yTbic1dER0DcEsXpLn0vBNErKHoagLzAgofHNLeFRw5yHWz5owR5CYL7rgiv2k51neHBWGx97A=='
			$Reloc = 'AwAAAAQgAAAAAAAAAAABABfyHS/VRkdjBBzbtGPD6vtmVH/IsGHYvPsTv2lGuqJxGlAA'
		EndIf
		Local $CodeBase = _BinaryCall_Create($Code, $Reloc)
		If @Error Then Return SetError(1, 0, 0)
		Local $Symbol[] = ["StdinRedirect","StdoutRedirect","StderrRedirect"]
		$SymbolList = _BinaryCall_SymbolList($CodeBase, $Symbol)
		If @Error Then Return SetError(1, 0, 0)
	EndIf
	If BitAND($Flag, 1) Then DllCallAddress("none:cdecl", DllStructGetData($SymbolList, "StdinRedirect"), "str", $Filename)
	If BitAND($Flag, 2) Then DllCallAddress("none:cdecl", DllStructGetData($SymbolList, "StdoutRedirect"), "str", $Filename)
	If BitAND($Flag, 4) Then DllCallAddress("none:cdecl", DllStructGetData($SymbolList, "StderrRedirect"), "str", $Filename)
EndFunc
Func _BinaryCall_StdinRedirect($Filename = "CON")
	Local $Ret = _BinaryCall_StdioRedirect($Filename, 1)
	Return SetError(@Error, @Extended, $Ret)
EndFunc
Func _BinaryCall_StdoutRedirect($Filename = "CON")
	Local $Ret = _BinaryCall_StdioRedirect($Filename, 2)
	Return SetError(@Error, @Extended, $Ret)
EndFunc
Func _BinaryCall_StderrRedirect($Filename = "CON")
	Local $Ret = _BinaryCall_StdioRedirect($Filename, 4)
	Return SetError(@Error, @Extended, $Ret)
EndFunc
Func _BinaryCall_ReleaseOnExit($Ptr)
	OnAutoItExitRegister('__BinaryCall_DoRelease')
	__BinaryCall_ReleaseOnExit_Handle($Ptr)
EndFunc
Func __BinaryCall_DoRelease()
	__BinaryCall_ReleaseOnExit_Handle()
EndFunc
Func __BinaryCall_ReleaseOnExit_Handle($Ptr = Default)
	Static $PtrList
	If @NumParams = 0 Then
		If IsArray($PtrList) Then
			For $i = 1 To $PtrList[0]
				_BinaryCall_Free($PtrList[$i])
			Next
		EndIf
	Else
		If Not IsArray($PtrList) Then
			Local $InitArray[1] = [0]
			$PtrList = $InitArray
		EndIf
		If IsPtr($Ptr) Then
			Local $Array = $PtrList
			Local $Size = UBound($Array)
			ReDim $Array[$Size + 1]
			$Array[$Size] = $Ptr
			$Array[0] += 1
			$PtrList = $Array
		EndIf
	EndIf
EndFunc
;#include "ArrayDisplayInternals.au3"; REMOVED INCLUDE
;#include "AutoItConstants.au3"; REMOVED INCLUDE
;#include "MsgBoxConstants.au3"; REMOVED INCLUDE
;#include "StringConstants.au3"; REMOVED INCLUDE
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, _
		$ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
Global Enum $ARRAYUNIQUE_NOCOUNT, $ARRAYUNIQUE_COUNT
Global Enum $ARRAYUNIQUE_AUTO, $ARRAYUNIQUE_FORCE32, $ARRAYUNIQUE_FORCE64, $ARRAYUNIQUE_MATCH, $ARRAYUNIQUE_DISTINCT
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
	If $iStart = Default Then $iStart = 0
	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	Local $hDataType = 0
	Switch $iForce
		Case $ARRAYFILL_FORCE_INT
			$hDataType = Int
		Case $ARRAYFILL_FORCE_NUMBER
			$hDataType = Number
		Case $ARRAYFILL_FORCE_PTR
			$hDataType = Ptr
		Case $ARRAYFILL_FORCE_HWND
			$hDataType = Hwnd
		Case $ARRAYFILL_FORCE_STRING
			$hDataType = String
		Case $ARRAYFILL_FORCE_BOOLEAN
			$hDataType = "Boolean"
	EndSwitch
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
				ReDim $aArray[$iDim_1 + 1]
				$aArray[$iDim_1] = $vValue
				Return $iDim_1
			EndIf
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
				$hDataType = 0
			Else
				Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				If UBound($aTmp, $UBOUND_ROWS) = 1 Then
					$aTmp[0] = $vValue
				EndIf
				$vValue = $aTmp
			EndIf
			Local $iAdd = UBound($vValue, $UBOUND_ROWS)
			ReDim $aArray[$iDim_1 + $iAdd]
			For $i = 0 To $iAdd - 1
				If String($hDataType) = "Boolean" Then
					Switch $vValue[$i]
						Case "True", "1"
							$aArray[$iDim_1 + $i] = True
						Case "False", "0", ""
							$aArray[$iDim_1 + $i] = False
					EndSwitch
				ElseIf IsFunc($hDataType) Then
					$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
				Else
					$aArray[$iDim_1 + $i] = $vValue[$i]
				EndIf
			Next
			Return $iDim_1 + $iAdd - 1
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
			Local $iValDim_1, $iValDim_2 = 0, $iColCount
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
				$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
				$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
				$hDataType = 0
			Else
				Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
				Local $aTmp[$iValDim_1][0], $aSplit_2
				For $i = 0 To $iValDim_1 - 1
					$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
					$iColCount = UBound($aSplit_2)
					If $iColCount > $iValDim_2 Then
						$iValDim_2 = $iColCount
						ReDim $aTmp[$iValDim_1][$iValDim_2]
					EndIf
					For $j = 0 To $iColCount - 1
						$aTmp[$i][$j] = $aSplit_2[$j]
					Next
				Next
				$vValue = $aTmp
			EndIf
			If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
			ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
			For $iWriteTo_Index = 0 To $iValDim_1 - 1
				For $j = 0 To $iDim_2 - 1
					If $j < $iStart Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					ElseIf $j - $iStart > $iValDim_2 - 1 Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					Else
						If String($hDataType) = "Boolean" Then
							Switch $vValue[$iWriteTo_Index][$j - $iStart]
								Case "True", "1"
									$aArray[$iWriteTo_Index + $iDim_1][$j] = True
								Case "False", "0", ""
									$aArray[$iWriteTo_Index + $iDim_1][$j] = False
							EndSwitch
						ElseIf IsFunc($hDataType) Then
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
						Else
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
						EndIf
					EndIf
				Next
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return UBound($aArray, $UBOUND_ROWS) - 1
EndFunc   ;==>_ArrayAdd
Func _ArrayBinarySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iColumn = 0)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iColumn = Default Then $iColumn = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	If $iDim_1 = 0 Then Return SetError(6, 0, -1)
	If $iEnd < 1 Or $iEnd > $iDim_1 - 1 Then $iEnd = $iDim_1 - 1
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	Local $iMid = Int(($iEnd + $iStart) / 2)
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $aArray[$iStart] > $vValue Or $aArray[$iEnd] < $vValue Then Return SetError(2, 0, -1)
			While $iStart <= $iMid And $vValue <> $aArray[$iMid]
				If $vValue < $aArray[$iMid] Then
					$iEnd = $iMid - 1
				Else
					$iStart = $iMid + 1
				EndIf
				$iMid = Int(($iEnd + $iStart) / 2)
			WEnd
			If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iColumn < 0 Or $iColumn > $iDim_2 Then Return SetError(7, 0, -1)
			If $aArray[$iStart][$iColumn] > $vValue Or $aArray[$iEnd][$iColumn] < $vValue Then Return SetError(2, 0, -1)
			While $iStart <= $iMid And $vValue <> $aArray[$iMid][$iColumn]
				If $vValue < $aArray[$iMid][$iColumn] Then
					$iEnd = $iMid - 1
				Else
					$iStart = $iMid + 1
				EndIf
				$iMid = Int(($iEnd + $iStart) / 2)
			WEnd
			If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found
		Case Else
			Return SetError(5, 0, -1)
	EndSwitch
	Return $iMid
EndFunc   ;==>_ArrayBinarySearch
Func _ArrayColDelete(ByRef $aArray, $iColumn, $bConvert = False)
	If $bConvert = Default Then $bConvert = False
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(2, 0, -1)
	Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
	Switch $iDim_2
		Case 2
			If $iColumn < 0 Or $iColumn > 1 Then Return SetError(3, 0, -1)
			If $bConvert Then
				Local $aTempArray[$iDim_1]
				For $i = 0 To $iDim_1 - 1
					$aTempArray[$i] = $aArray[$i][(Not $iColumn)]
				Next
				$aArray = $aTempArray
			Else
				ContinueCase
			EndIf
		Case Else
			If $iColumn < 0 Or $iColumn > $iDim_2 - 1 Then Return SetError(3, 0, -1)
			For $i = 0 To $iDim_1 - 1
				For $j = $iColumn To $iDim_2 - 2
					$aArray[$i][$j] = $aArray[$i][$j + 1]
				Next
			Next
			ReDim $aArray[$iDim_1][$iDim_2 - 1]
	EndSwitch
	Return UBound($aArray, $UBOUND_COLUMNS)
EndFunc   ;==>_ArrayColDelete
Func _ArrayColInsert(ByRef $aArray, $iColumn)
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			Local $aTempArray[$iDim_1][2]
			Switch $iColumn
				Case 0, 1
					For $i = 0 To $iDim_1 - 1
						$aTempArray[$i][(Not $iColumn)] = $aArray[$i]
					Next
				Case Else
					Return SetError(3, 0, -1)
			EndSwitch
			$aArray = $aTempArray
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iColumn < 0 Or $iColumn > $iDim_2 Then Return SetError(3, 0, -1)
			ReDim $aArray[$iDim_1][$iDim_2 + 1]
			For $i = 0 To $iDim_1 - 1
				For $j = $iDim_2 To $iColumn + 1 Step -1
					$aArray[$i][$j] = $aArray[$i][$j - 1]
				Next
				$aArray[$i][$iColumn] = ""
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return UBound($aArray, $UBOUND_COLUMNS)
EndFunc   ;==>_ArrayColInsert
Func _ArrayCombinations(Const ByRef $aArray, $iSet, $sDelimiter = "")
	If $sDelimiter = Default Then $sDelimiter = ""
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(2, 0, 0)
	Local $iN = UBound($aArray)
	Local $iR = $iSet
	Local $aIdx[$iR]
	For $i = 0 To $iR - 1
		$aIdx[$i] = $i
	Next
	Local $iTotal = __Array_Combinations($iN, $iR)
	Local $iLeft = $iTotal
	Local $aResult[$iTotal + 1]
	$aResult[0] = $iTotal
	Local $iCount = 1
	While $iLeft > 0
		__Array_GetNext($iN, $iR, $iLeft, $iTotal, $aIdx)
		For $i = 0 To $iSet - 1
			$aResult[$iCount] &= $aArray[$aIdx[$i]] & $sDelimiter
		Next
		If $sDelimiter <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], 1)
		$iCount += 1
	WEnd
	Return $aResult
EndFunc   ;==>_ArrayCombinations
Func _ArrayConcatenate(ByRef $aArrayTarget, Const ByRef $aArraySource, $iStart = 0)
	If $iStart = Default Then $iStart = 0
	If Not IsArray($aArrayTarget) Then Return SetError(1, 0, -1)
	If Not IsArray($aArraySource) Then Return SetError(2, 0, -1)
	Local $iDim_Total_Tgt = UBound($aArrayTarget, $UBOUND_DIMENSIONS)
	Local $iDim_Total_Src = UBound($aArraySource, $UBOUND_DIMENSIONS)
	Local $iDim_1_Tgt = UBound($aArrayTarget, $UBOUND_ROWS)
	Local $iDim_1_Src = UBound($aArraySource, $UBOUND_ROWS)
	If $iStart < 0 Or $iStart > $iDim_1_Src - 1 Then Return SetError(6, 0, -1)
	Switch $iDim_Total_Tgt
		Case 1
			If $iDim_Total_Src <> 1 Then Return SetError(4, 0, -1)
			ReDim $aArrayTarget[$iDim_1_Tgt + $iDim_1_Src - $iStart]
			For $i = $iStart To $iDim_1_Src - 1
				$aArrayTarget[$iDim_1_Tgt + $i - $iStart] = $aArraySource[$i]
			Next
		Case 2
			If $iDim_Total_Src <> 2 Then Return SetError(4, 0, -1)
			Local $iDim_2_Tgt = UBound($aArrayTarget, $UBOUND_COLUMNS)
			If UBound($aArraySource, $UBOUND_COLUMNS) <> $iDim_2_Tgt Then Return SetError(5, 0, -1)
			ReDim $aArrayTarget[$iDim_1_Tgt + $iDim_1_Src - $iStart][$iDim_2_Tgt]
			For $i = $iStart To $iDim_1_Src - 1
				For $j = 0 To $iDim_2_Tgt - 1
					$aArrayTarget[$iDim_1_Tgt + $i - $iStart][$j] = $aArraySource[$i][$j]
				Next
			Next
		Case Else
			Return SetError(3, 0, -1)
	EndSwitch
	Return UBound($aArrayTarget, $UBOUND_ROWS)
EndFunc   ;==>_ArrayConcatenate
Func _ArrayDelete(ByRef $aArray, $vRange)
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If IsArray($vRange) Then
		If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
	Else
		Local $iNumber, $aSplit_1, $aSplit_2
		$vRange = StringStripWS($vRange, 8)
		$aSplit_1 = StringSplit($vRange, ";")
		$vRange = ""
		For $i = 1 To $aSplit_1[0]
			If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
			$aSplit_2 = StringSplit($aSplit_1[$i], "-")
			Switch $aSplit_2[0]
				Case 1
					$vRange &= $aSplit_2[1] & ";"
				Case 2
					If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
						$iNumber = $aSplit_2[1] - 1
						Do
							$iNumber += 1
							$vRange &= $iNumber & ";"
						Until $iNumber = $aSplit_2[2]
					EndIf
			EndSwitch
		Next
		$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
	EndIf
	If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
	Local $iCopyTo_Index = 0
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]] = ChrW(0xFAB1)
			Next
			For $iReadFrom_Index = 0 To $iDim_1
				If $aArray[$iReadFrom_Index] == ChrW(0xFAB1) Then
					ContinueLoop
				Else
					If $iReadFrom_Index <> $iCopyTo_Index Then
						$aArray[$iCopyTo_Index] = $aArray[$iReadFrom_Index]
					EndIf
					$iCopyTo_Index += 1
				EndIf
			Next
			ReDim $aArray[$iDim_1 - $vRange[0] + 1]
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]][0] = ChrW(0xFAB1)
			Next
			For $iReadFrom_Index = 0 To $iDim_1
				If $aArray[$iReadFrom_Index][0] == ChrW(0xFAB1) Then
					ContinueLoop
				Else
					If $iReadFrom_Index <> $iCopyTo_Index Then
						For $j = 0 To $iDim_2
							$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFrom_Index][$j]
						Next
					EndIf
					$iCopyTo_Index += 1
				EndIf
			Next
			ReDim $aArray[$iDim_1 - $vRange[0] + 1][$iDim_2 + 1]
		Case Else
			Return SetError(2, 0, False)
	EndSwitch
	Return UBound($aArray, $UBOUND_ROWS)
EndFunc   ;==>_ArrayDelete
Func _ArrayDisplay(Const ByRef $aArray, $sTitle = Default, $sArrayRange = Default, $iFlags = Default, $vUser_Separator = Default, $sHeader = Default, $iMax_ColWidth = Default)
	#forceref $vUser_Separator
	Local $iRet = __ArrayDisplay_Share($aArray, $sTitle, $sArrayRange, $iFlags, Default, $sHeader, $iMax_ColWidth, 0, False)
	Return SetError(@error, @extended, $iRet)
EndFunc   ;==>_ArrayDisplay
Func _ArrayExtract(Const ByRef $aArray, $iStart_Row = -1, $iEnd_Row = -1, $iStart_Col = -1, $iEnd_Col = -1)
	If $iStart_Row = Default Then $iStart_Row = -1
	If $iEnd_Row = Default Then $iEnd_Row = -1
	If $iStart_Col = Default Then $iStart_Col = -1
	If $iEnd_Col = Default Then $iEnd_Col = -1
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If $iEnd_Row = -1 Then $iEnd_Row = $iDim_1
	If $iStart_Row = -1 Then $iStart_Row = 0
	If $iStart_Row < -1 Or $iEnd_Row < -1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			Local $aRetArray[$iEnd_Row - $iStart_Row + 1]
			For $i = 0 To $iEnd_Row - $iStart_Row
				$aRetArray[$i] = $aArray[$i + $iStart_Row]
			Next
			Return $aRetArray
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iEnd_Col = -1 Then $iEnd_Col = $iDim_2
			If $iStart_Col = -1 Then $iStart_Col = 0
			If $iStart_Col < -1 Or $iEnd_Col < -1 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iDim_2 Or $iEnd_Col > $iDim_2 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iEnd_Col Then Return SetError(6, 0, -1)
			If $iStart_Col = $iEnd_Col Then
				Local $aRetArray[$iEnd_Row - $iStart_Row + 1]
			Else
				Local $aRetArray[$iEnd_Row - $iStart_Row + 1][$iEnd_Col - $iStart_Col + 1]
			EndIf
			For $i = 0 To $iEnd_Row - $iStart_Row
				For $j = 0 To $iEnd_Col - $iStart_Col
					If $iStart_Col = $iEnd_Col Then
						$aRetArray[$i] = $aArray[$i + $iStart_Row][$j + $iStart_Col]
					Else
						$aRetArray[$i][$j] = $aArray[$i + $iStart_Row][$j + $iStart_Col]
					EndIf
				Next
			Next
			Return $aRetArray
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return 1
EndFunc   ;==>_ArrayExtract
Func _ArrayFindAll(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iSubItem = 0, $bRow = False)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iCase = Default Then $iCase = 0
	If $iCompare = Default Then $iCompare = 0
	If $iSubItem = Default Then $iSubItem = 0
	If $bRow = Default Then $bRow = False
	$iStart = _ArraySearch($aArray, $vValue, $iStart, $iEnd, $iCase, $iCompare, 1, $iSubItem, $bRow)
	If @error Then Return SetError(@error, 0, -1)
	Local $iIndex = 0, $avResult[UBound($aArray, ($bRow ? $UBOUND_COLUMNS : $UBOUND_ROWS))] ; Set dimension for Column/Row
	Do
		$avResult[$iIndex] = $iStart
		$iIndex += 1
		$iStart = _ArraySearch($aArray, $vValue, $iStart + 1, $iEnd, $iCase, $iCompare, 1, $iSubItem, $bRow)
	Until @error
	ReDim $avResult[$iIndex]
	Return $avResult
EndFunc   ;==>_ArrayFindAll
Func _ArrayInsert(ByRef $aArray, $vRange, $vValue = "", $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
	If $vValue = Default Then $vValue = ""
	If $iStart = Default Then $iStart = 0
	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	Local $hDataType = 0
	Switch $iForce
		Case $ARRAYFILL_FORCE_INT
			$hDataType = Int
		Case $ARRAYFILL_FORCE_NUMBER
			$hDataType = Number
		Case $ARRAYFILL_FORCE_PTR
			$hDataType = Ptr
		Case $ARRAYFILL_FORCE_HWND
			$hDataType = Hwnd
		Case $ARRAYFILL_FORCE_STRING
			$hDataType = String
	EndSwitch
	Local $aSplit_1, $aSplit_2
	If IsArray($vRange) Then
		If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
	Else
		Local $iNumber
		$vRange = StringStripWS($vRange, 8)
		$aSplit_1 = StringSplit($vRange, ";")
		$vRange = ""
		For $i = 1 To $aSplit_1[0]
			If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
			$aSplit_2 = StringSplit($aSplit_1[$i], "-")
			Switch $aSplit_2[0]
				Case 1
					$vRange &= $aSplit_2[1] & ";"
				Case 2
					If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
						$iNumber = $aSplit_2[1] - 1
						Do
							$iNumber += 1
							$vRange &= $iNumber & ";"
						Until $iNumber = $aSplit_2[2]
					EndIf
			EndSwitch
		Next
		$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
	EndIf
	If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
	For $i = 2 To $vRange[0]
		If $vRange[$i] < $vRange[$i - 1] Then Return SetError(3, 0, -1)
	Next
	Local $iCopyTo_Index = $iDim_1 + $vRange[0]
	Local $iInsertPoint_Index = $vRange[0]
	Local $iInsert_Index = $vRange[$iInsertPoint_Index]
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
				ReDim $aArray[$iDim_1 + $vRange[0] + 1]
				For $iReadFromIndex = $iDim_1 To 0 Step -1
					$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
					$iCopyTo_Index -= 1
					$iInsert_Index = $vRange[$iInsertPoint_Index]
					While $iReadFromIndex = $iInsert_Index
						$aArray[$iCopyTo_Index] = $vValue
						$iCopyTo_Index -= 1
						$iInsertPoint_Index -= 1
						If $iInsertPoint_Index < 1 Then ExitLoop 2
						$iInsert_Index = $vRange[$iInsertPoint_Index]
					WEnd
				Next
				Return $iDim_1 + $vRange[0] + 1
			EndIf
			ReDim $aArray[$iDim_1 + $vRange[0] + 1]
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
				$hDataType = 0
			Else
				Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				If UBound($aTmp, $UBOUND_ROWS) = 1 Then
					$aTmp[0] = $vValue
					$hDataType = 0
				EndIf
				$vValue = $aTmp
			EndIf
			For $iReadFromIndex = $iDim_1 To 0 Step -1
				$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
				$iCopyTo_Index -= 1
				$iInsert_Index = $vRange[$iInsertPoint_Index]
				While $iReadFromIndex = $iInsert_Index
					If $iInsertPoint_Index <= UBound($vValue, $UBOUND_ROWS) Then
						If IsFunc($hDataType) Then
							$aArray[$iCopyTo_Index] = $hDataType($vValue[$iInsertPoint_Index - 1])
						Else
							$aArray[$iCopyTo_Index] = $vValue[$iInsertPoint_Index - 1]
						EndIf
					Else
						$aArray[$iCopyTo_Index] = ""
					EndIf
					$iCopyTo_Index -= 1
					$iInsertPoint_Index -= 1
					If $iInsertPoint_Index = 0 Then ExitLoop 2
					$iInsert_Index = $vRange[$iInsertPoint_Index]
				WEnd
			Next
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(6, 0, -1)
			Local $iValDim_1, $iValDim_2
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(7, 0, -1)
				$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
				$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
				$hDataType = 0
			Else
				$aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
				StringReplace($aSplit_1[0], $sDelim_Item, "")
				$iValDim_2 = @extended + 1
				Local $aTmp[$iValDim_1][$iValDim_2]
				For $i = 0 To $iValDim_1 - 1
					$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
					For $j = 0 To $iValDim_2 - 1
						$aTmp[$i][$j] = $aSplit_2[$j]
					Next
				Next
				$vValue = $aTmp
			EndIf
			If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(8, 0, -1)
			ReDim $aArray[$iDim_1 + $vRange[0] + 1][$iDim_2]
			For $iReadFromIndex = $iDim_1 To 0 Step -1
				For $j = 0 To $iDim_2 - 1
					$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFromIndex][$j]
				Next
				$iCopyTo_Index -= 1
				$iInsert_Index = $vRange[$iInsertPoint_Index]
				While $iReadFromIndex = $iInsert_Index
					For $j = 0 To $iDim_2 - 1
						If $j < $iStart Then
							$aArray[$iCopyTo_Index][$j] = ""
						ElseIf $j - $iStart > $iValDim_2 - 1 Then
							$aArray[$iCopyTo_Index][$j] = ""
						Else
							If $iInsertPoint_Index - 1 < $iValDim_1 Then
								If IsFunc($hDataType) Then
									$aArray[$iCopyTo_Index][$j] = $hDataType($vValue[$iInsertPoint_Index - 1][$j - $iStart])
								Else
									$aArray[$iCopyTo_Index][$j] = $vValue[$iInsertPoint_Index - 1][$j - $iStart]
								EndIf
							Else
								$aArray[$iCopyTo_Index][$j] = ""
							EndIf
						EndIf
					Next
					$iCopyTo_Index -= 1
					$iInsertPoint_Index -= 1
					If $iInsertPoint_Index = 0 Then ExitLoop 2
					$iInsert_Index = $vRange[$iInsertPoint_Index]
				WEnd
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return UBound($aArray, $UBOUND_ROWS)
EndFunc   ;==>_ArrayInsert
Func _ArrayMax(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	Local $iResult = _ArrayMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem)
	If @error Then Return SetError(@error, 0, "")
	If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then
		Return $aArray[$iResult]
	Else
		Return $aArray[$iResult][$iSubItem]
	EndIf
EndFunc   ;==>_ArrayMax
Func _ArrayMaxIndex(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = -1
	If $iEnd = Default Then $iEnd = -1
	If $iSubItem = Default Then $iSubItem = 0
	Local $iRet = __Array_MinMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, __Array_GreaterThan) ; Pass a delegate function to check if value1 > value2.
	Return SetError(@error, 0, $iRet)
EndFunc   ;==>_ArrayMaxIndex
Func _ArrayMin(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	Local $iResult = _ArrayMinIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem)
	If @error Then Return SetError(@error, 0, "")
	If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then
		Return $aArray[$iResult]
	Else
		Return $aArray[$iResult][$iSubItem]
	EndIf
EndFunc   ;==>_ArrayMin
Func _ArrayMinIndex(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = -1
	If $iEnd = Default Then $iEnd = -1
	If $iSubItem = Default Then $iSubItem = 0
	Local $iRet = __Array_MinMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, __Array_LessThan) ; Pass a delegate function to check if value1 < value2.
	Return SetError(@error, 0, $iRet)
EndFunc   ;==>_ArrayMinIndex
Func _ArrayPermute(ByRef $aArray, $sDelimiter = "")
	If $sDelimiter = Default Then $sDelimiter = ""
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(2, 0, 0)
	Local $iSize = UBound($aArray), $iFactorial = 1, $aIdx[$iSize], $aResult[1], $iCount = 1
	If UBound($aArray) Then
		For $i = 0 To $iSize - 1
			$aIdx[$i] = $i
		Next
		For $i = $iSize To 1 Step -1
			$iFactorial *= $i
		Next
		ReDim $aResult[$iFactorial + 1]
		$aResult[0] = $iFactorial
		__Array_ExeterInternal($aArray, 0, $iSize, $sDelimiter, $aIdx, $aResult, $iCount)
	Else
		$aResult[0] = 0
	EndIf
	Return $aResult
EndFunc   ;==>_ArrayPermute
Func _ArrayPop(ByRef $aArray)
	If (Not IsArray($aArray)) Then Return SetError(1, 0, "")
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(2, 0, "")
	Local $iUBound = UBound($aArray) - 1
	If $iUBound = -1 Then Return SetError(3, 0, "")
	Local $sLastVal = $aArray[$iUBound]
	If $iUBound > -1 Then
		ReDim $aArray[$iUBound]
	EndIf
	Return $sLastVal
EndFunc   ;==>_ArrayPop
Func _ArrayPush(ByRef $aArray, $vValue, $iDirection = 0)
	If $iDirection = Default Then $iDirection = 0
	If (Not IsArray($aArray)) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
	Local $iUBound = UBound($aArray) - 1
	If IsArray($vValue) Then ; $vValue is an array
		Local $iUBoundS = UBound($vValue)
		If ($iUBoundS - 1) > $iUBound Then Return SetError(2, 0, 0)
		If $iDirection Then ; slide right, add to front
			For $i = $iUBound To $iUBoundS Step -1
				$aArray[$i] = $aArray[$i - $iUBoundS]
			Next
			For $i = 0 To $iUBoundS - 1
				$aArray[$i] = $vValue[$i]
			Next
		Else ; slide left, add to end
			For $i = 0 To $iUBound - $iUBoundS
				$aArray[$i] = $aArray[$i + $iUBoundS]
			Next
			For $i = 0 To $iUBoundS - 1
				$aArray[$i + $iUBound - $iUBoundS + 1] = $vValue[$i]
			Next
		EndIf
	Else
		If $iUBound > -1 Then
			If $iDirection Then ; slide right, add to front
				For $i = $iUBound To 1 Step -1
					$aArray[$i] = $aArray[$i - 1]
				Next
				$aArray[0] = $vValue
			Else ; slide left, add to end
				For $i = 0 To $iUBound - 1
					$aArray[$i] = $aArray[$i + 1]
				Next
				$aArray[$iUBound] = $vValue
			EndIf
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_ArrayPush
Func _ArrayReverse(ByRef $aArray, $iStart = 0, $iEnd = 0)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
	If Not UBound($aArray) Then Return SetError(4, 0, 0)
	Local $vTmp, $iUBound = UBound($aArray) - 1
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)
	For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
		$vTmp = $aArray[$i]
		$aArray[$i] = $aArray[$iEnd]
		$aArray[$iEnd] = $vTmp
		$iEnd -= 1
	Next
	Return 1
EndFunc   ;==>_ArrayReverse
Func _ArraySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iForward = 1, $iSubItem = -1, $bRow = False)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iCase = Default Then $iCase = 0
	If $iCompare = Default Then $iCompare = 0
	If $iForward = Default Then $iForward = 1
	If $iSubItem = Default Then $iSubItem = -1
	If $bRow = Default Then $bRow = False
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray) - 1
	If $iDim_1 = -1 Then Return SetError(3, 0, -1)
	Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
	Local $bCompType = False
	If $iCompare = 2 Then
		$iCompare = 0
		$bCompType = True
	EndIf
	If $bRow Then
		If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then Return SetError(5, 0, -1)
		If $iEnd < 1 Or $iEnd > $iDim_2 Then $iEnd = $iDim_2
		If $iStart < 0 Then $iStart = 0
		If $iStart > $iEnd Then Return SetError(4, 0, -1)
	Else
		If $iEnd < 1 Or $iEnd > $iDim_1 Then $iEnd = $iDim_1
		If $iStart < 0 Then $iStart = 0
		If $iStart > $iEnd Then Return SetError(4, 0, -1)
	EndIf
	Local $iStep = 1
	If Not $iForward Then
		Local $iTmp = $iStart
		$iStart = $iEnd
		$iEnd = $iTmp
		$iStep = -1
	EndIf
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1 ; 1D array search
			If Not $iCompare Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
						If $aArray[$i] = $vValue Then Return $i
					Next
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
						If $aArray[$i] == $vValue Then Return $i
					Next
				EndIf
			Else
				For $i = $iStart To $iEnd Step $iStep
					If $iCompare = 3 Then
						If StringRegExp($aArray[$i], $vValue) Then Return $i
					Else
						If StringInStr($aArray[$i], $vValue, $iCase) > 0 Then Return $i
					EndIf
				Next
			EndIf
		Case 2 ; 2D array search
			Local $iDim_Sub
			If $bRow Then
				$iDim_Sub = $iDim_1
				If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
				If $iSubItem < 0 Then
					$iSubItem = 0
				Else
					$iDim_Sub = $iSubItem
				EndIf
			Else
				$iDim_Sub = $iDim_2
				If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
				If $iSubItem < 0 Then
					$iSubItem = 0
				Else
					$iDim_Sub = $iSubItem
				EndIf
			EndIf
			For $j = $iSubItem To $iDim_Sub
				If Not $iCompare Then
					If Not $iCase Then
						For $i = $iStart To $iEnd Step $iStep
							If $bRow Then
								If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$j][$i] = $vValue Then Return $i
							Else
								If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$i][$j] = $vValue Then Return $i
							EndIf
						Next
					Else
						For $i = $iStart To $iEnd Step $iStep
							If $bRow Then
								If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$j][$i] == $vValue Then Return $i
							Else
								If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$i][$j] == $vValue Then Return $i
							EndIf
						Next
					EndIf
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $iCompare = 3 Then
							If $bRow Then
								If StringRegExp($aArray[$j][$i], $vValue) Then Return $i
							Else
								If StringRegExp($aArray[$i][$j], $vValue) Then Return $i
							EndIf
						Else
							If $bRow Then
								If StringInStr($aArray[$j][$i], $vValue, $iCase) > 0 Then Return $i
							Else
								If StringInStr($aArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
							EndIf
						EndIf
					Next
				EndIf
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return SetError(6, 0, -1)
EndFunc   ;==>_ArraySearch
Func _ArrayShuffle(ByRef $aArray, $iStart_Row = 0, $iEnd_Row = 0, $iCol = -1)
	If $iStart_Row = Default Then $iStart_Row = 0
	If $iEnd_Row = Default Then $iEnd_Row = 0
	If $iCol = Default Then $iCol = -1
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	If $iEnd_Row = 0 Then $iEnd_Row = $iDim_1 - 1
	If $iStart_Row < 0 Or $iStart_Row > $iDim_1 - 1 Then Return SetError(3, 0, -1)
	If $iEnd_Row < 1 Or $iEnd_Row > $iDim_1 - 1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
	Local $vTmp, $iRand
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			For $i = $iEnd_Row To $iStart_Row + 1 Step -1
				$iRand = Random($iStart_Row, $i, 1)
				$vTmp = $aArray[$i]
				$aArray[$i] = $aArray[$iRand]
				$aArray[$iRand] = $vTmp
			Next
			Return 1
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iCol < -1 Or $iCol > $iDim_2 - 1 Then Return SetError(5, 0, -1)
			Local $iCol_Start, $iCol_End
			If $iCol = -1 Then
				$iCol_Start = 0
				$iCol_End = $iDim_2 - 1
			Else
				$iCol_Start = $iCol
				$iCol_End = $iCol
			EndIf
			For $i = $iEnd_Row To $iStart_Row + 1 Step -1
				$iRand = Random($iStart_Row, $i, 1)
				For $j = $iCol_Start To $iCol_End
					$vTmp = $aArray[$i][$j]
					$aArray[$i][$j] = $aArray[$iRand][$j]
					$aArray[$iRand][$j] = $vTmp
				Next
			Next
			Return 1
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
EndFunc   ;==>_ArrayShuffle
Func _ArraySort(ByRef $aArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0, $iPivot = 0)
	If $iDescending = Default Then $iDescending = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iSubItem = Default Then $iSubItem = 0
	If $iPivot = Default Then $iPivot = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	Local $iUBound = UBound($aArray) - 1
	If $iUBound = -1 Then Return SetError(5, 0, 0)
	If $iEnd = Default Then $iEnd = 0
	If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
	If $iStart < 0 Or $iStart = Default Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iPivot Then ; Switch algorithms as required
				__ArrayDualPivotSort($aArray, $iStart, $iEnd)
			Else
				__ArrayQuickSort1D($aArray, $iStart, $iEnd)
			EndIf
			If $iDescending Then _ArrayReverse($aArray, $iStart, $iEnd)
		Case 2
			If $iPivot Then Return SetError(6, 0, 0) ; Error if 2D array and $iPivot
			Local $iSubMax = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)
			If $iDescending Then
				$iDescending = -1
			Else
				$iDescending = 1
			EndIf
			__ArrayQuickSort2D($aArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch
	Return 1
EndFunc   ;==>_ArraySort
Func __ArrayQuickSort1D(ByRef $aArray, Const ByRef $iStart, Const ByRef $iEnd)
	If $iEnd <= $iStart Then Return
	Local $vTmp
	If ($iEnd - $iStart) < 15 Then
		Local $vCur
		For $i = $iStart + 1 To $iEnd
			$vTmp = $aArray[$i]
			If IsNumber($vTmp) Then
				For $j = $i - 1 To $iStart Step -1
					$vCur = $aArray[$j]
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$aArray[$j + 1] = $vCur
				Next
			Else
				For $j = $i - 1 To $iStart Step -1
					If (StringCompare($vTmp, $aArray[$j]) >= 0) Then ExitLoop
					$aArray[$j + 1] = $aArray[$j]
				Next
			EndIf
			$aArray[$j + 1] = $vTmp
		Next
		Return
	EndIf
	Local $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)], $bNum = IsNumber($vPivot)
	Do
		If $bNum Then
			While ($aArray[$L] < $vPivot And IsNumber($aArray[$L])) Or (Not IsNumber($aArray[$L]) And StringCompare($aArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While ($aArray[$R] > $vPivot And IsNumber($aArray[$R])) Or (Not IsNumber($aArray[$R]) And StringCompare($aArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While (StringCompare($aArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While (StringCompare($aArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf
		If $L <= $R Then
			$vTmp = $aArray[$L]
			$aArray[$L] = $aArray[$R]
			$aArray[$R] = $vTmp
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R
	__ArrayQuickSort1D($aArray, $iStart, $R)
	__ArrayQuickSort1D($aArray, $L, $iEnd)
EndFunc   ;==>__ArrayQuickSort1D
Func __ArrayQuickSort2D(ByRef $aArray, Const ByRef $iStep, Const ByRef $iStart, Const ByRef $iEnd, Const ByRef $iSubItem, Const ByRef $iSubMax)
	If $iEnd <= $iStart Then Return
	Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $bNum = IsNumber($vPivot)
	Do
		If $bNum Then
			While ($iStep * ($aArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($aArray[$L][$iSubItem])) Or (Not IsNumber($aArray[$L][$iSubItem]) And $iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep * ($aArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($aArray[$R][$iSubItem])) Or (Not IsNumber($aArray[$R][$iSubItem]) And $iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While ($iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf
		If $L <= $R Then
			For $i = 0 To $iSubMax
				$vTmp = $aArray[$L][$i]
				$aArray[$L][$i] = $aArray[$R][$i]
				$aArray[$R][$i] = $vTmp
			Next
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R
	__ArrayQuickSort2D($aArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
	__ArrayQuickSort2D($aArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc   ;==>__ArrayQuickSort2D
Func __ArrayDualPivotSort(ByRef $aArray, $iPivot_Left, $iPivot_Right, $bLeftMost = True)
	If $iPivot_Left > $iPivot_Right Then Return
	Local $iLength = $iPivot_Right - $iPivot_Left + 1
	Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
	If $iLength < 45 Then ; Use insertion sort for small arrays - value chosen empirically
		If $bLeftMost Then
			$i = $iPivot_Left
			While $i < $iPivot_Right
				$j = $i
				$iAi = $aArray[$i + 1]
				While $iAi < $aArray[$j]
					$aArray[$j + 1] = $aArray[$j]
					$j -= 1
					If $j + 1 = $iPivot_Left Then ExitLoop
				WEnd
				$aArray[$j + 1] = $iAi
				$i += 1
			WEnd
		Else
			While 1
				If $iPivot_Left >= $iPivot_Right Then Return 1
				$iPivot_Left += 1
				If $aArray[$iPivot_Left] < $aArray[$iPivot_Left - 1] Then ExitLoop
			WEnd
			While 1
				$k = $iPivot_Left
				$iPivot_Left += 1
				If $iPivot_Left > $iPivot_Right Then ExitLoop
				$iA1 = $aArray[$k]
				$iA2 = $aArray[$iPivot_Left]
				If $iA1 < $iA2 Then
					$iA2 = $iA1
					$iA1 = $aArray[$iPivot_Left]
				EndIf
				$k -= 1
				While $iA1 < $aArray[$k]
					$aArray[$k + 2] = $aArray[$k]
					$k -= 1
				WEnd
				$aArray[$k + 2] = $iA1
				While $iA2 < $aArray[$k]
					$aArray[$k + 1] = $aArray[$k]
					$k -= 1
				WEnd
				$aArray[$k + 1] = $iA2
				$iPivot_Left += 1
			WEnd
			$iLast = $aArray[$iPivot_Right]
			$iPivot_Right -= 1
			While $iLast < $aArray[$iPivot_Right]
				$aArray[$iPivot_Right + 1] = $aArray[$iPivot_Right]
				$iPivot_Right -= 1
			WEnd
			$aArray[$iPivot_Right + 1] = $iLast
		EndIf
		Return 1
	EndIf
	Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
	Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
	$iE3 = Ceiling(($iPivot_Left + $iPivot_Right) / 2)
	$iE2 = $iE3 - $iSeventh
	$iE1 = $iE2 - $iSeventh
	$iE4 = $iE3 + $iSeventh
	$iE5 = $iE4 + $iSeventh
	If $aArray[$iE2] < $aArray[$iE1] Then
		$t = $aArray[$iE2]
		$aArray[$iE2] = $aArray[$iE1]
		$aArray[$iE1] = $t
	EndIf
	If $aArray[$iE3] < $aArray[$iE2] Then
		$t = $aArray[$iE3]
		$aArray[$iE3] = $aArray[$iE2]
		$aArray[$iE2] = $t
		If $t < $aArray[$iE1] Then
			$aArray[$iE2] = $aArray[$iE1]
			$aArray[$iE1] = $t
		EndIf
	EndIf
	If $aArray[$iE4] < $aArray[$iE3] Then
		$t = $aArray[$iE4]
		$aArray[$iE4] = $aArray[$iE3]
		$aArray[$iE3] = $t
		If $t < $aArray[$iE2] Then
			$aArray[$iE3] = $aArray[$iE2]
			$aArray[$iE2] = $t
			If $t < $aArray[$iE1] Then
				$aArray[$iE2] = $aArray[$iE1]
				$aArray[$iE1] = $t
			EndIf
		EndIf
	EndIf
	If $aArray[$iE5] < $aArray[$iE4] Then
		$t = $aArray[$iE5]
		$aArray[$iE5] = $aArray[$iE4]
		$aArray[$iE4] = $t
		If $t < $aArray[$iE3] Then
			$aArray[$iE4] = $aArray[$iE3]
			$aArray[$iE3] = $t
			If $t < $aArray[$iE2] Then
				$aArray[$iE3] = $aArray[$iE2]
				$aArray[$iE2] = $t
				If $t < $aArray[$iE1] Then
					$aArray[$iE2] = $aArray[$iE1]
					$aArray[$iE1] = $t
				EndIf
			EndIf
		EndIf
	EndIf
	Local $iLess = $iPivot_Left
	Local $iGreater = $iPivot_Right
	If (($aArray[$iE1] <> $aArray[$iE2]) And ($aArray[$iE2] <> $aArray[$iE3]) And ($aArray[$iE3] <> $aArray[$iE4]) And ($aArray[$iE4] <> $aArray[$iE5])) Then
		Local $iPivot_1 = $aArray[$iE2]
		Local $iPivot_2 = $aArray[$iE4]
		$aArray[$iE2] = $aArray[$iPivot_Left]
		$aArray[$iE4] = $aArray[$iPivot_Right]
		Do
			$iLess += 1
		Until $aArray[$iLess] >= $iPivot_1
		Do
			$iGreater -= 1
		Until $aArray[$iGreater] <= $iPivot_2
		$k = $iLess
		While $k <= $iGreater
			$iAk = $aArray[$k]
			If $iAk < $iPivot_1 Then
				$aArray[$k] = $aArray[$iLess]
				$aArray[$iLess] = $iAk
				$iLess += 1
			ElseIf $iAk > $iPivot_2 Then
				While $aArray[$iGreater] > $iPivot_2
					$iGreater -= 1
					If $iGreater + 1 = $k Then ExitLoop 2
				WEnd
				If $aArray[$iGreater] < $iPivot_1 Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $aArray[$iGreater]
					$iLess += 1
				Else
					$aArray[$k] = $aArray[$iGreater]
				EndIf
				$aArray[$iGreater] = $iAk
				$iGreater -= 1
			EndIf
			$k += 1
		WEnd
		$aArray[$iPivot_Left] = $aArray[$iLess - 1]
		$aArray[$iLess - 1] = $iPivot_1
		$aArray[$iPivot_Right] = $aArray[$iGreater + 1]
		$aArray[$iGreater + 1] = $iPivot_2
		__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 2, True)
		__ArrayDualPivotSort($aArray, $iGreater + 2, $iPivot_Right, False)
		If ($iLess < $iE1) And ($iE5 < $iGreater) Then
			While $aArray[$iLess] = $iPivot_1
				$iLess += 1
			WEnd
			While $aArray[$iGreater] = $iPivot_2
				$iGreater -= 1
			WEnd
			$k = $iLess
			While $k <= $iGreater
				$iAk = $aArray[$k]
				If $iAk = $iPivot_1 Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $iAk
					$iLess += 1
				ElseIf $iAk = $iPivot_2 Then
					While $aArray[$iGreater] = $iPivot_2
						$iGreater -= 1
						If $iGreater + 1 = $k Then ExitLoop 2
					WEnd
					If $aArray[$iGreater] = $iPivot_1 Then
						$aArray[$k] = $aArray[$iLess]
						$aArray[$iLess] = $iPivot_1
						$iLess += 1
					Else
						$aArray[$k] = $aArray[$iGreater]
					EndIf
					$aArray[$iGreater] = $iAk
					$iGreater -= 1
				EndIf
				$k += 1
			WEnd
		EndIf
		__ArrayDualPivotSort($aArray, $iLess, $iGreater, False)
	Else
		Local $iPivot = $aArray[$iE3]
		$k = $iLess
		While $k <= $iGreater
			If $aArray[$k] = $iPivot Then
				$k += 1
				ContinueLoop
			EndIf
			$iAk = $aArray[$k]
			If $iAk < $iPivot Then
				$aArray[$k] = $aArray[$iLess]
				$aArray[$iLess] = $iAk
				$iLess += 1
			Else
				While $aArray[$iGreater] > $iPivot
					$iGreater -= 1
				WEnd
				If $aArray[$iGreater] < $iPivot Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $aArray[$iGreater]
					$iLess += 1
				Else
					$aArray[$k] = $iPivot
				EndIf
				$aArray[$iGreater] = $iAk
				$iGreater -= 1
			EndIf
			$k += 1
		WEnd
		__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 1, True)
		__ArrayDualPivotSort($aArray, $iGreater + 1, $iPivot_Right, False)
	EndIf
EndFunc   ;==>__ArrayDualPivotSort
Func _ArraySwap(ByRef $aArray, $iIndex_1, $iIndex_2, $bCol = False, $iStart = -1, $iEnd = -1)
	If $bCol = Default Then $bCol = False
	If $iStart = Default Then $iStart = -1
	If $iEnd = Default Then $iEnd = -1
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
	If $iDim_2 = -1 Then ; 1D array so force defaults
		$bCol = False
		$iStart = -1
		$iEnd = -1
	EndIf
	If $iStart > $iEnd Then Return SetError(5, 0, -1)
	If $bCol Then
		If $iIndex_1 < 0 Or $iIndex_2 > $iDim_2 Then Return SetError(3, 0, -1)
		If $iStart = -1 Then $iStart = 0
		If $iEnd = -1 Then $iEnd = $iDim_1
	Else
		If $iIndex_1 < 0 Or $iIndex_2 > $iDim_1 Then Return SetError(3, 0, -1)
		If $iStart = -1 Then $iStart = 0
		If $iEnd = -1 Then $iEnd = $iDim_2
	EndIf
	Local $vTmp
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			$vTmp = $aArray[$iIndex_1]
			$aArray[$iIndex_1] = $aArray[$iIndex_2]
			$aArray[$iIndex_2] = $vTmp
		Case 2
			If $iStart < -1 Or $iEnd < -1 Then Return SetError(4, 0, -1)
			If $bCol Then
				If $iStart > $iDim_1 Or $iEnd > $iDim_1 Then Return SetError(4, 0, -1)
				For $j = $iStart To $iEnd
					$vTmp = $aArray[$j][$iIndex_1]
					$aArray[$j][$iIndex_1] = $aArray[$j][$iIndex_2]
					$aArray[$j][$iIndex_2] = $vTmp
				Next
			Else
				If $iStart > $iDim_2 Or $iEnd > $iDim_2 Then Return SetError(4, 0, -1)
				For $j = $iStart To $iEnd
					$vTmp = $aArray[$iIndex_1][$j]
					$aArray[$iIndex_1][$j] = $aArray[$iIndex_2][$j]
					$aArray[$iIndex_2][$j] = $vTmp
				Next
			EndIf
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return 1
EndFunc   ;==>_ArraySwap
Func _ArrayToClip(Const ByRef $aArray, $sDelim_Col = "|", $iStart_Row = -1, $iEnd_Row = -1, $sDelim_Row = @CRLF, $iStart_Col = -1, $iEnd_Col = -1)
	Local $sResult = _ArrayToString($aArray, $sDelim_Col, $iStart_Row, $iEnd_Row, $sDelim_Row, $iStart_Col, $iEnd_Col)
	If @error Then Return SetError(@error, 0, 0)
	If ClipPut($sResult) Then Return 1
	Return SetError(-1, 0, 0)
EndFunc   ;==>_ArrayToClip
Func _ArrayToString(Const ByRef $aArray, $sDelim_Col = "|", $iStart_Row = -1, $iEnd_Row = -1, $sDelim_Row = @CRLF, $iStart_Col = -1, $iEnd_Col = -1)
	If $sDelim_Col = Default Then $sDelim_Col = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iStart_Row = Default Then $iStart_Row = -1
	If $iEnd_Row = Default Then $iEnd_Row = -1
	If $iStart_Col = Default Then $iStart_Col = -1
	If $iEnd_Col = Default Then $iEnd_Col = -1
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If $iStart_Row = -1 Then $iStart_Row = 0
	If $iEnd_Row = -1 Then $iEnd_Row = $iDim_1
	If $iStart_Row < -1 Or $iEnd_Row < -1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, "")
	If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
	Local $sRet = ""
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			For $i = $iStart_Row To $iEnd_Row
				$sRet &= $aArray[$i] & $sDelim_Col
			Next
			Return StringTrimRight($sRet, StringLen($sDelim_Col))
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iStart_Col = -1 Then $iStart_Col = 0
			If $iEnd_Col = -1 Then $iEnd_Col = $iDim_2
			If $iStart_Col < -1 Or $iEnd_Col < -1 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iDim_2 Or $iEnd_Col > $iDim_2 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iEnd_Col Then Return SetError(6, 0, -1)
			For $i = $iStart_Row To $iEnd_Row
				For $j = $iStart_Col To $iEnd_Col
					$sRet &= $aArray[$i][$j] & $sDelim_Col
				Next
				$sRet = StringTrimRight($sRet, StringLen($sDelim_Col)) & $sDelim_Row
			Next
			Return StringTrimRight($sRet, StringLen($sDelim_Row))
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return 1
EndFunc   ;==>_ArrayToString
Func _ArrayTranspose(ByRef $aArray)
	Switch UBound($aArray, 0)
		Case 0
			Return SetError(2, 0, 0)
		Case 1
			Local $aTemp[1][UBound($aArray)]
			For $i = 0 To UBound($aArray) - 1
				$aTemp[0][$i] = $aArray[$i]
			Next
			$aArray = $aTemp
		Case 2
			Local $iDim_1 = UBound($aArray, 1), $iDim_2 = UBound($aArray, 2)
			If $iDim_1 <> $iDim_2 Then
				Local $aTemp[$iDim_2][$iDim_1]
				For $i = 0 To $iDim_1 - 1
					For $j = 0 To $iDim_2 - 1
						$aTemp[$j][$i] = $aArray[$i][$j]
					Next
				Next
				$aArray = $aTemp
			Else ; optimimal method for a square grid
				Local $vElement
				For $i = 0 To $iDim_1 - 1
					For $j = $i + 1 To $iDim_2 - 1
						$vElement = $aArray[$i][$j]
						$aArray[$i][$j] = $aArray[$j][$i]
						$aArray[$j][$i] = $vElement
					Next
				Next
			EndIf
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
	Return 1
EndFunc   ;==>_ArrayTranspose
Func _ArrayTrim(ByRef $aArray, $iTrimNum, $iDirection = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If $iDirection = Default Then $iDirection = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iSubItem = Default Then $iSubItem = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If $iEnd = 0 Then $iEnd = $iDim_1
	If $iStart > $iEnd Then Return SetError(3, 0, -1)
	If $iStart < 0 Or $iEnd < 0 Then Return SetError(3, 0, -1)
	If $iStart > $iDim_1 Or $iEnd > $iDim_1 Then Return SetError(3, 0, -1)
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iDirection Then
				For $i = $iStart To $iEnd
					$aArray[$i] = StringTrimRight($aArray[$i], $iTrimNum)
				Next
			Else
				For $i = $iStart To $iEnd
					$aArray[$i] = StringTrimLeft($aArray[$i], $iTrimNum)
				Next
			EndIf
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iSubItem < 0 Or $iSubItem > $iDim_2 Then Return SetError(5, 0, -1)
			If $iDirection Then
				For $i = $iStart To $iEnd
					$aArray[$i][$iSubItem] = StringTrimRight($aArray[$i][$iSubItem], $iTrimNum)
				Next
			Else
				For $i = $iStart To $iEnd
					$aArray[$i][$iSubItem] = StringTrimLeft($aArray[$i][$iSubItem], $iTrimNum)
				Next
			EndIf
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch
	Return 1
EndFunc   ;==>_ArrayTrim
Func _ArrayUnique(Const ByRef $aArray, $iColumn = 0, $iBase = 0, $iCase = 0, $iCount = $ARRAYUNIQUE_COUNT, $iIntType = $ARRAYUNIQUE_AUTO)
	If $iColumn = Default Then $iColumn = 0
	If $iBase = Default Then $iBase = 0
	If $iCase = Default Then $iCase = 0
	If $iCount = Default Then $iCount = $ARRAYUNIQUE_COUNT
	If UBound($aArray, $UBOUND_ROWS) = 0 Then Return SetError(1, 0, 0)
	Local $iDims = UBound($aArray, $UBOUND_DIMENSIONS), $iNumColumns = UBound($aArray, $UBOUND_COLUMNS)
	If $iDims > 2 Then Return SetError(2, 0, 0)
	If $iBase < 0 Or $iBase > 1 Or (Not IsInt($iBase)) Then Return SetError(3, 0, 0)
	If $iCase < 0 Or $iCase > 1 Or (Not IsInt($iCase)) Then Return SetError(3, 0, 0)
	If $iCount < 0 Or $iCount > 1 Or (Not IsInt($iCount)) Then Return SetError(4, 0, 0)
	If $iIntType < 0 Or $iIntType > 4 Or (Not IsInt($iIntType)) Then Return SetError(5, 0, 0)
	If $iColumn < 0 Or ($iNumColumns = 0 And $iColumn > 0) Or ($iNumColumns > 0 And $iColumn >= $iNumColumns) Then Return SetError(6, 0, 0)
	If $iIntType = $ARRAYUNIQUE_AUTO Then
		Local $bInt, $sVarType
		If $iDims = 1 Then
			$bInt = IsInt($aArray[$iBase])
			$sVarType = VarGetType($aArray[$iBase])
		Else
			$bInt = IsInt($aArray[$iBase][$iColumn])
			$sVarType = VarGetType($aArray[$iBase][$iColumn])
		EndIf
		If $bInt And $sVarType = "Int64" Then
			$iIntType = $ARRAYUNIQUE_FORCE64
		Else
			$iIntType = $ARRAYUNIQUE_FORCE32
		EndIf
	EndIf
	ObjEvent("AutoIt.Error", __ArrayUnique_AutoErrFunc)
	Local $oDictionary = ObjCreate("Scripting.Dictionary")
	$oDictionary.CompareMode = Number(Not $iCase)
	Local $vElem, $sType, $vKey, $bCOMError = False
	For $i = $iBase To UBound($aArray) - 1
		If $iDims = 1 Then
			$vElem = $aArray[$i]
		Else
			$vElem = $aArray[$i][$iColumn]
		EndIf
		Switch $iIntType
			Case $ARRAYUNIQUE_FORCE32
				$oDictionary.Item($vElem) ; Check if key exists - automatically created if not
				If @error Then
					$bCOMError = True ; Failed with an Int64, Ptr or Binary datatype
					ExitLoop
				EndIf
			Case $ARRAYUNIQUE_FORCE64
				$sType = VarGetType($vElem)
				If $sType = "Int32" Then
					$bCOMError = True ; Failed with an Int32 datatype
					ExitLoop
				EndIf ; Create key
				$vKey = "#" & $sType & "#" & String($vElem)
				If Not $oDictionary.Item($vKey) Then ; Check if key exists
					$oDictionary($vKey) = $vElem ; Store actual value in dictionary
				EndIf
			Case $ARRAYUNIQUE_MATCH
				$sType = VarGetType($vElem)
				If StringLeft($sType, 3) = "Int" Then
					$vKey = "#Int#" & String($vElem)
				Else
					$vKey = "#" & $sType & "#" & String($vElem)
				EndIf
				If Not $oDictionary.Item($vKey) Then ; Check if key exists
					$oDictionary($vKey) = $vElem ; Store actual value in dictionary
				EndIf
			Case $ARRAYUNIQUE_DISTINCT
				$vKey = "#" & VarGetType($vElem) & "#" & String($vElem)
				If Not $oDictionary.Item($vKey) Then ; Check if key exists
					$oDictionary($vKey) = $vElem ; Store actual value in dictionary
				EndIf
		EndSwitch
	Next
	Local $aValues, $j = 0
	If $bCOMError Then ; Mismatch Int32/64
		Return SetError(7, 0, 0)
	ElseIf $iIntType <> $ARRAYUNIQUE_FORCE32 Then
		Local $aValues[$oDictionary.Count]
		For $vKey In $oDictionary.Keys()
			$aValues[$j] = $oDictionary($vKey)
			If StringLeft($vKey, 5) = "#Ptr#" Then
				$aValues[$j] = Ptr($aValues[$j])
			EndIf
			$j += 1
		Next
	Else
		$aValues = $oDictionary.Keys()
	EndIf
	If $iCount Then
		_ArrayInsert($aValues, 0, $oDictionary.Count)
	EndIf
	Return $aValues
EndFunc   ;==>_ArrayUnique
Func _Array1DToHistogram($aArray, $iSizing = 100)
	If UBound($aArray, 0) > 1 Then Return SetError(1, 0, "")
	$iSizing = $iSizing * 8
	Local $t, $n, $iMin = 0, $iMax = 0, $iOffset = 0
	For $i = 0 To UBound($aArray) - 1
		$t = $aArray[$i]
		$t = IsNumber($t) ? Round($t) : 0
		If $t < $iMin Then $iMin = $t
		If $t > $iMax Then $iMax = $t
	Next
	Local $iRange = Int(Round(($iMax - $iMin) / 8)) * 8
	Local $iSpaceRatio = 4
	For $i = 0 To UBound($aArray) - 1
		$t = $aArray[$i]
		If $t Then
			$n = Abs(Round(($iSizing * $t) / $iRange) / 8)
			$aArray[$i] = ""
			If $t > 0 Then
				If $iMin Then
					$iOffset = Int(Abs(Round(($iSizing * $iMin) / $iRange) / 8) / 8 * $iSpaceRatio)
					$aArray[$i] = __Array_StringRepeat(ChrW(0x20), $iOffset)
				EndIf
			Else
				If $iMin <> $t Then
					$iOffset = Int(Abs(Round(($iSizing * ($t - $iMin)) / $iRange) / 8) / 8 * $iSpaceRatio)
					$aArray[$i] = __Array_StringRepeat(ChrW(0x20), $iOffset)
				EndIf
			EndIf
			$aArray[$i] &= __Array_StringRepeat(ChrW(0x2588), Int($n / 8))
			$n = Mod($n, 8)
			If $n > 0 Then $aArray[$i] &= ChrW(0x2588 + 8 - $n)
			$aArray[$i] &= ' ' & $t
		Else
			$aArray[$i] = ""
		EndIf
	Next
	Return $aArray
EndFunc   ;==>_Array1DToHistogram
Func __Array_StringRepeat($sString, $iRepeatCount)
	$iRepeatCount = Int($iRepeatCount)
	If StringLen($sString) < 1 Or $iRepeatCount <= 0 Then Return SetError(1, 0, "")
	Local $sResult = ""
	While $iRepeatCount > 1
		If BitAND($iRepeatCount, 1) Then $sResult &= $sString
		$sString &= $sString
		$iRepeatCount = BitShift($iRepeatCount, 1)
	WEnd
	Return $sString & $sResult
EndFunc   ;==>__Array_StringRepeat
Func __Array_ExeterInternal(ByRef $aArray, $iStart, $iSize, $sDelimiter, ByRef $aIdx, ByRef $aResult, ByRef $iCount)
	If $iStart == $iSize - 1 Then
		For $i = 0 To $iSize - 1
			$aResult[$iCount] &= $aArray[$aIdx[$i]] & $sDelimiter
		Next
		If $sDelimiter <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], StringLen($sDelimiter))
		$iCount += 1
	Else
		Local $iTemp
		For $i = $iStart To $iSize - 1
			$iTemp = $aIdx[$i]
			$aIdx[$i] = $aIdx[$iStart]
			$aIdx[$iStart] = $iTemp
			__Array_ExeterInternal($aArray, $iStart + 1, $iSize, $sDelimiter, $aIdx, $aResult, $iCount)
			$aIdx[$iStart] = $aIdx[$i]
			$aIdx[$i] = $iTemp
		Next
	EndIf
EndFunc   ;==>__Array_ExeterInternal
Func __Array_Combinations($iN, $iR)
	Local $i_Total = 1
	For $i = $iR To 1 Step -1
		$i_Total *= ($iN / $i)
		$iN -= 1
	Next
	Return Round($i_Total)
EndFunc   ;==>__Array_Combinations
Func __Array_GetNext($iN, $iR, ByRef $iLeft, $iTotal, ByRef $aIdx)
	If $iLeft == $iTotal Then
		$iLeft -= 1
		Return
	EndIf
	Local $i = $iR - 1
	While $aIdx[$i] == $iN - $iR + $i
		$i -= 1
	WEnd
	$aIdx[$i] += 1
	For $j = $i + 1 To $iR - 1
		$aIdx[$j] = $aIdx[$i] + $j - $i
	Next
	$iLeft -= 1
EndFunc   ;==>__Array_GetNext
Func __Array_MinMaxIndex(Const ByRef $aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, $fuComparison) ; Always swapped the comparison params around e.g. it was for min 100 > 1000 whereas 1000 < 100 makes more sense in a min function.
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iCompNumeric <> 1 Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = 0
	If $iSubItem = Default Then $iSubItem = 0
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If $iDim_1 < 0 Then Return SetError(1, 0, -1)
	If $iEnd = -1 Then $iEnd = $iDim_1
	If $iStart = -1 Then $iStart = 0
	If $iStart < -1 Or $iEnd < -1 Then Return SetError(3, 0, -1)
	If $iStart > $iDim_1 Or $iEnd > $iDim_1 Then Return SetError(3, 0, -1)
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	If $iDim_1 < 0 Then Return SetError(5, 0, -1)
	Local $iMaxMinIndex = $iStart
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If $fuComparison(Number($aArray[$i]), Number($aArray[$iMaxMinIndex])) Then $iMaxMinIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $fuComparison($aArray[$i], $aArray[$iMaxMinIndex]) Then $iMaxMinIndex = $i
				Next
			EndIf
		Case 2
			If $iSubItem < 0 Or $iSubItem > UBound($aArray, $UBOUND_COLUMNS) - 1 Then Return SetError(6, 0, -1)
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If $fuComparison(Number($aArray[$i][$iSubItem]), Number($aArray[$iMaxMinIndex][$iSubItem])) Then $iMaxMinIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $fuComparison($aArray[$i][$iSubItem], $aArray[$iMaxMinIndex][$iSubItem]) Then $iMaxMinIndex = $i
				Next
			EndIf
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return $iMaxMinIndex
EndFunc   ;==>__Array_MinMaxIndex
Func __Array_GreaterThan($vValue1, $vValue2)
	Return $vValue1 > $vValue2
EndFunc   ;==>__Array_GreaterThan
Func __Array_LessThan($vValue1, $vValue2)
	Return $vValue1 < $vValue2
EndFunc   ;==>__Array_LessThan
Func __ArrayUnique_AutoErrFunc()
EndFunc   ;==>__ArrayUnique_AutoErrFunc
;#include "BinaryCall.au3"; REMOVED INCLUDE
Global Const $JSON_UNESCAPED_UNICODE = 1 ; Encode multibyte Unicode characters literally
Global Const $JSON_UNESCAPED_SLASHES = 2 ; Don't escape /
Global Const $JSON_HEX_TAG = 4 ; All < and > are converted to \u003C and \u003E
Global Const $JSON_HEX_AMP = 8 ; All &s are converted to \u0026
Global Const $JSON_HEX_APOS = 16 ; All ' are converted to \u0027
Global Const $JSON_HEX_QUOT = 32 ; All " are converted to \u0022
Global Const $JSON_UNESCAPED_ASCII = 64 ; Don't escape ascii charcters between chr(1) ~ chr(0x1f)
Global Const $JSON_PRETTY_PRINT = 128 ; Use whitespace in returned data to format it
Global Const $JSON_STRICT_PRINT = 256 ; Make sure returned JSON string is RFC4627 compliant
Global Const $JSON_UNQUOTED_STRING = 512 ; Output unquoted string if possible (conflicting with $Json_STRICT_PRINT)
Global Const $JSMN_ERROR_NOMEM = -1 ; Not enough tokens were provided
Global Const $JSMN_ERROR_INVAL = -2 ; Invalid character inside JSON string
Global Const $JSMN_ERROR_PART = -3 ; The string is not a full JSON packet, more bytes expected
Func __Jsmn_RuntimeLoader($ProcName = "")
	Static $SymbolList
	If Not IsDllStruct($SymbolList) Then
		Local $Code
		If @AutoItX64 Then
			$Code = 'AwAAAAQfCAAAAAAAAAA1HbEvgTNrvX54gCiWSTVmt5v7RCdoFJ/zhkKmwcm8yVqZPjJBoVhNHHAIzrHWKbZh1J0QAUaHB5zyQTilTmWa9O0OKeLrk/Jg+o7CmMzjEk74uPongdHv37nwYXvg97fiHvjP2bBzI9gxSkKq9Cqh/GxSHIlZPYyW76pXUt//25Aqs2Icfpyay/NFd50rW7eMliH5ynkrp16HM1afithVrO+LpSaz/IojowApmXnBHUncHliDqbkx6/AODUkyDm1hj+AiEZ9Me1Jy+hBQ1/wC/YnuuYSJvNAKp6XDnyc8Nwr54Uqx5SbUW2CezwQQ7aXX/HFiHSKpQcFW/gi8oSx5nsoxUXVjxeNI/L7z6GF2mfu3Tnpt7hliWEdA2r2VB+TIM7Pgwl9X3Ge0T3KJQUaRtLJZcPvVtOuKXr2Q9wy7hl80hVRrt9zYrbjBHXLrRx/HeIMkZwxhmKo/dD/vvaNgE+BdU8eeJqFBJK2alrK2rh2WkRynftyepm1WrdKrz/5KhQPp/4PqH+9IADDjoGBbfvJQXdT+yiO8DtfrVnd+JOEKsKEsdgeM3UXx5r6tEHO9rYWbzbnyEiX7WozZemry+vBZMMtHn1aA63+RcDQED73xOsnj00/9E5Z6hszM5Hi8vi6Hw3iOgf3cHwcXG44aau0JpuA2DlrUvnJOYkNnY+bECeSdAR1UQkFNyqRoH2xm4Y7gYMCPsFtPBlwwleEKI27SsUq1ZHVQvFCoef7DXgf/GwPCAvwDMIQfb3hJtIVubOkASRQZVNIJ/y4KPrn/gcASV7fvMjE34loltTVlyqprUWxpI51tN6vhTOLAp+CHseKxWaf9g1wdbVs0e/5xAiqgJbmKNi9OYbhV/blpp3SL63XKxGiHdxhK1aR+4rUY4eckNbaHfW7ob+q7aBoHSs6LVX9lWakb/xWxwQdwcX/7/C+TcQSOOg6rLoWZ8wur9qp+QwzoCbXkf04OYpvD5kqgEiwQnB90kLtcA+2XSbDRu+aq02eNNCzgkZujeL/HjVISjf2EuQKSsZkBhS15eiXoRgPaUoQ5586VS7t7rhM8ng5LiVzoUQIZ0pNKxWWqD+gXRBvOMIXY2yd0Ei4sE5KFIEhbs3u8vwP7nFLIpZ/RembPTuc0ZlguGJgJ2F5iApfia+C2tRYRNjVCqECCveWw6P2Btfaq9gw7cWWmJflIQbjxtccDqsn52cftLqXSna9zk05mYdJSV8z2W7vM1YJ5Rd82v0j3kau710A/kQrN41bdaxmKjL+gvSRlOLB1bpvkCtf9+h+eVA4XIkIXKFydr1OjMZ8wq2FIxPJXskAe4YMgwQmeWZXMK1KBbLB3yQR1YOYaaHk1fNea9KsXgs5YLbiP/noAusz76oEDo/DJh1aw7cUwdhboVPg1bNq88mRb5RGa13KDK9uEET7OA02KbSL+Q4HOtyasLUoVrZzVyd8iZPoGrV36vHnj+yvG4fq6F/fkug/sBRp186yVZQVmdAgFd+WiRLnUjxHUKJ6xBbpt4FTP42E/PzPw3JlDb0UQtXTDnIL0CWqbns2E7rZ5PBwrwQYwvBn/gaEeLVGDSh84DfW4zknIneGnYDXdVEHC+ITzejAnNxb1duB+w2aVTk64iXsKHETq53GMH6DuFi0oUeEFb/xp0HsRyNC8vBjOq3Kk7NZHxCQLh7UATFttG7sH+VIqGjjNwmraGJ0C92XhpQwSgfAb3KHucCHGTTti0sn6cgS3vb36BkjGKsRhXVuoQCFH96bvTYtl8paQQW9ufRfvxPqmU0sALdR0fIvZwd7Z8z0UoEec6b1Sul4e60REj/H4scb6N2ryHBR9ua5N1YxJu1uwgoLXUL2wT9ZPBjPjySUzeqXikUIKKYgNlWy+VlNIiWWTPtKpCTr508logA=='
		Else
			$Code = 'AwAAAASFBwAAAAAAAAA1HbEvgTNrvX54gCiqsa1mt5v7RCdoAFjCfVE40DZbE5UfabA9UKuHrjqOMbvjSoB2zBJTEYEQejBREnPrXL3VwpVOW+L9SSfo0rTfA8U2W+Veqo1uy0dOsPhl7vAHbBHrvJNfEUe8TT0q2eaTX2LeWpyrFEm4I3mhDJY/E9cpWf0A78e+y4c7NxewvcVvAakIHE8Xb8fgtqCTVQj3Q1eso7n1fKQj5YsQ20A86Gy9fz8dky78raeZnhYayn0b1riSUKxGVnWja2i02OvAVM3tCCvXwcbSkHTRjuIAbMu2mXF1UpKci3i/GzPmbxo9n/3aX/jpR6UvxMZuaEDEij4yzfZv7EyK9WCNBXxMmtTp3Uv6MZsK+nopXO3C0xFzZA/zQObwP3zhJ4sdatzMhFi9GAM70R4kgMzsxQDNArueXj+UFzbCCFZ89zXs22F7Ixi0FyFTk3jhH56dBaN65S+gtPztNGzEUmtk4M8IanhQSw8xCXr0x0MPDpDFDZs3aN5TtTPYmyk3psk7OrmofCQGG5cRcqEt9902qtxQDOHumfuCPMvU+oMjzLzBVEDnBbj+tY3y1jvgGbmEJguAgfB04tSeAt/2618ksnJJK+dbBkDLxjB4xrFr3uIFFadJQWUckl5vfh4MVXbsFA1hG49lqWDa7uSuPCnOhv8Yql376I4U4gfcF8LcgorkxS+64urv2nMUq6AkBEMQ8bdkI64oKLFfO7fGxh5iMNZuLoutDn2ll3nq4rPi4kOyAtfhW0UPyjvqNtXJ/h0Wik5Mi8z7BVxaURTDk81TP8y9+tzjySB/uGfHFAzjF8DUY1vqJCgn0GQ8ANtiiElX/+Wnc9HWi2bEEXItbm4yv97QrEPvJG9nPRBKWGiAQsIA5J+WryX5NrfEfRPk0QQwyl16lpHlw6l0UMuk7S21xjQgyWo0MywfzoBWW7+t4HH9sqavvP4dYAw81BxXqVHQhefUOS23en4bFUPWE98pAN6bul+kS767vDK34yTC3lA2a8wLrBEilmFhdB74fxbAl+db91PivhwF/CR4Igxr35uLdof7+jAYyACopQzmsbHpvAAwT2lapLix8H03nztAC3fBqFSPBVdIv12lsrrDw4dfhJEzq7AbL/Y7L/nIcBsQ/3UyVnZk4kZP1KzyPCBLLIQNpCVgOLJzQuyaQ6k2QCBy0eJ0ppUyfp54LjwVg0X7bwncYbAomG4ZcFwTQnC2AX3oYG5n6Bz4SLLjxrFsY+v/SVa+GqH8uePBh1TPkHVNmzjXXymEf5jROlnd+EjfQdRyitkjPrg2HiQxxDcVhCh5J2L5+6CY9eIaYgrbd8zJnzAD8KnowHwh2bi4JLgmt7ktJ1XGizox7cWf3/Dod56KAcaIrSVw9XzYybdJCf0YRA6yrwPWXbwnzc/4+UDkmegi+AoCEMoue+cC7vnYVdmlbq/YLE/DWJX383oz2Ryq8anFrZ8jYvdoh8WI+dIugYL2SwRjmBoSwn56XIaot/QpMo3pYJIa4o8aZIZrjvB7BXO5aCDeMuZdUMT6AXGAGF1AeAWxFd2XIo1coR+OplMNDuYia8YAtnSTJ9JwGYWi2dJz3xrxsTQpBONf3yn8LVf8eH+o5eXc7lzCtHlDB+YyI8V9PyMsUPOeyvpB3rr9fDfNy263Zx33zTi5jldgP2OetUqGfbwl+0+zNYnrg64bluyIN/Awt1doDCQkCKpKXxuPaem/SyCHrKjg'
		EndIf
		Local $Symbol[] = ["jsmn_parse", "jsmn_init", "json_string_decode", "json_string_encode"]
		Local $CodeBase = _BinaryCall_Create($Code)
		If @error Then Exit MsgBox(16, "Json", "Startup Failure!")
		$SymbolList = _BinaryCall_SymbolList($CodeBase, $Symbol)
		If @error Then Exit MsgBox(16, "Json", "Startup Failure!")
	EndIf
	If $ProcName Then Return DllStructGetData($SymbolList, $ProcName)
EndFunc   ;==>__Jsmn_RuntimeLoader
Func Json_StringEncode($String, $Option = 0)
	Static $Json_StringEncode = __Jsmn_RuntimeLoader("json_string_encode")
	Local $Length = StringLen($String) * 6 + 1
	Local $Buffer = DllStructCreate("wchar[" & $Length & "]")
	Local $Ret = DllCallAddress("int:cdecl", $Json_StringEncode, "wstr", $String, "ptr", DllStructGetPtr($Buffer), "uint", $Length, "int", $Option)
	Return SetError($Ret[0], 0, DllStructGetData($Buffer, 1))
EndFunc   ;==>Json_StringEncode
Func Json_StringDecode($String)
	Static $Json_StringDecode = __Jsmn_RuntimeLoader("json_string_decode")
	Local $Length = StringLen($String) + 1
	Local $Buffer = DllStructCreate("wchar[" & $Length & "]")
	Local $Ret = DllCallAddress("int:cdecl", $Json_StringDecode, "wstr", $String, "ptr", DllStructGetPtr($Buffer), "uint", $Length)
	Return SetError($Ret[0], 0, DllStructGetData($Buffer, 1))
EndFunc   ;==>Json_StringDecode
Func Json_Decode($Json, $InitTokenCount = 1000)
	Static $Jsmn_Init = __Jsmn_RuntimeLoader("jsmn_init"), $Jsmn_Parse = __Jsmn_RuntimeLoader("jsmn_parse")
	If $Json = "" Then $Json = '""'
	Local $TokenList, $Ret
	Local $Parser = DllStructCreate("uint pos;int toknext;int toksuper")
	Do
		DllCallAddress("none:cdecl", $Jsmn_Init, "ptr", DllStructGetPtr($Parser))
		$TokenList = DllStructCreate("byte[" & ($InitTokenCount * 20) & "]")
		$Ret = DllCallAddress("int:cdecl", $Jsmn_Parse, "ptr", DllStructGetPtr($Parser), "wstr", $Json, "ptr", DllStructGetPtr($TokenList), "uint", $InitTokenCount)
		$InitTokenCount *= 2
	Until $Ret[0] <> $JSMN_ERROR_NOMEM
	Local $Next = 0
	Return SetError($Ret[0], 0, _Json_Token($Json, DllStructGetPtr($TokenList), $Next))
EndFunc   ;==>Json_Decode
Func _Json_Token(ByRef $Json, $Ptr, ByRef $Next)
	If $Next = -1 Then Return Null
	Local $Token = DllStructCreate("int;int;int;int", $Ptr + ($Next * 20))
	Local $Type = DllStructGetData($Token, 1)
	Local $Start = DllStructGetData($Token, 2)
	Local $End = DllStructGetData($Token, 3)
	Local $Size = DllStructGetData($Token, 4)
	$Next += 1
	If $Type = 0 And $Start = 0 And $End = 0 And $Size = 0 Then ; Null Item
		$Next = -1
		Return Null
	EndIf
	Switch $Type
		Case 0 ; Json_PRIMITIVE
			Local $Primitive = StringMid($Json, $Start + 1, $End - $Start)
			Switch $Primitive
				Case "true"
					Return True
				Case "false"
					Return False
				Case "null"
					Return Null
				Case Else
					If StringRegExp($Primitive, "^[+\-0-9]") Then
						Return Number($Primitive)
					Else
						Return Json_StringDecode($Primitive)
					EndIf
			EndSwitch
		Case 1 ; Json_OBJECT
			Local $Object = Json_ObjCreate()
			For $i = 0 To $Size - 1 Step 2
				Local $Key = _Json_Token($Json, $Ptr, $Next)
				Local $Value = _Json_Token($Json, $Ptr, $Next)
				If Not IsString($Key) Then $Key = Json_Encode($Key)
				If $Object.Exists($Key) Then $Object.Remove($Key)
				$Object.Add($Key, $Value)
			Next
			Return $Object
		Case 2 ; Json_ARRAY
			Local $Array[$Size]
			For $i = 0 To $Size - 1
				$Array[$i] = _Json_Token($Json, $Ptr, $Next)
			Next
			Return $Array
		Case 3 ; Json_STRING
			Return Json_StringDecode(StringMid($Json, $Start + 1, $End - $Start))
	EndSwitch
EndFunc   ;==>_Json_Token
Func Json_IsObject(ByRef $Object)
	Return (IsObj($Object) And ObjName($Object) = "Dictionary")
EndFunc   ;==>Json_IsObject
Func Json_IsNull(ByRef $Null)
	Return IsKeyword($Null) Or (Not IsObj($Null) And VarGetType($Null) = "Object")
EndFunc   ;==>Json_IsNull
Func Json_Encode_Compact($Data, $Option = 0)
	Local $Json = ""
	Select
		Case IsString($Data)
			Return '"' & Json_StringEncode($Data, $Option) & '"'
		Case IsNumber($Data)
			Return $Data
		Case IsArray($Data) And UBound($Data, 0) = 1
			$Json = "["
			For $i = 0 To UBound($Data) - 1
				$Json &= Json_Encode_Compact($Data[$i], $Option) & ","
			Next
			If StringRight($Json, 1) = "," Then $Json = StringTrimRight($Json, 1)
			Return $Json & "]"
		Case Json_IsObject($Data)
			$Json = "{"
			Local $Keys = $Data.Keys()
			For $i = 0 To UBound($Keys) - 1
				$Json &= '"' & Json_StringEncode($Keys[$i], $Option) & '":' & Json_Encode_Compact($Data.Item($Keys[$i]), $Option) & ","
			Next
			If StringRight($Json, 1) = "," Then $Json = StringTrimRight($Json, 1)
			Return $Json & "}"
		Case IsBool($Data)
			Return StringLower($Data)
		Case IsPtr($Data)
			Return Number($Data)
		Case IsBinary($Data)
			Return '"' & Json_StringEncode(BinaryToString($Data, 4), $Option) & '"'
		Case Else ; Keyword, DllStruct, Object
			Return "null"
	EndSelect
EndFunc   ;==>Json_Encode_Compact
Func Json_Encode_Pretty($Data, $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep, $ArrayCRLF = Default, $ObjectCRLF = Default, $NextIdent = "")
	Local $ThisIdent = $NextIdent, $Json = "", $String = "", $Match = "", $Keys = ""
	Local $Length = 0
	Select
		Case IsString($Data)
			$String = Json_StringEncode($Data, $Option)
			If BitAND($Option, $JSON_UNQUOTED_STRING) And Not BitAND($Option, $JSON_STRICT_PRINT) And Not StringRegExp($String, "[\s,:]") And Not StringRegExp($String, "^[+\-0-9]") Then
				Return $String
			Else
				Return '"' & $String & '"'
			EndIf
		Case IsArray($Data) And UBound($Data, 0) = 1
			If UBound($Data) = 0 Then Return "[]"
			If IsKeyword($ArrayCRLF) Then
				$ArrayCRLF = ""
				$Match = StringRegExp($ArraySep, "[\r\n]+$", 3)
				If IsArray($Match) Then $ArrayCRLF = $Match[0]
			EndIf
			If $ArrayCRLF Then $NextIdent &= $Indent
			$Length = UBound($Data) - 1
			For $i = 0 To $Length
				If $ArrayCRLF Then $Json &= $NextIdent
				$Json &= Json_Encode_Pretty($Data[$i], $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep, $ArrayCRLF, $ObjectCRLF, $NextIdent)
				If $i < $Length Then $Json &= $ArraySep
			Next
			If $ArrayCRLF Then Return "[" & $ArrayCRLF & $Json & $ArrayCRLF & $ThisIdent & "]"
			Return "[" & $Json & "]"
		Case Json_IsObject($Data)
			If $Data.Count = 0 Then Return "{}"
			If IsKeyword($ObjectCRLF) Then
				$ObjectCRLF = ""
				$Match = StringRegExp($ObjectSep, "[\r\n]+$", 3)
				If IsArray($Match) Then $ObjectCRLF = $Match[0]
			EndIf
			If $ObjectCRLF Then $NextIdent &= $Indent
			$Keys = $Data.Keys()
			$Length = UBound($Keys) - 1
			For $i = 0 To $Length
				If $ObjectCRLF Then $Json &= $NextIdent
				$Json &= Json_Encode_Pretty(String($Keys[$i]), $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep) & $ColonSep _
						 & Json_Encode_Pretty($Data.Item($Keys[$i]), $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep, $ArrayCRLF, $ObjectCRLF, $NextIdent)
				If $i < $Length Then $Json &= $ObjectSep
			Next
			If $ObjectCRLF Then Return "{" & $ObjectCRLF & $Json & $ObjectCRLF & $ThisIdent & "}"
			Return "{" & $Json & "}"
		Case Else
			Return Json_Encode_Compact($Data, $Option)
	EndSelect
EndFunc   ;==>Json_Encode_Pretty
Func Json_Encode($Data, $Option = 0, $Indent = Default, $ArraySep = Default, $ObjectSep = Default, $ColonSep = Default)
	If BitAND($Option, $JSON_PRETTY_PRINT) Then
		Local $Strict = BitAND($Option, $JSON_STRICT_PRINT)
		If IsKeyword($Indent) Then
			$Indent = @TAB
		Else
			$Indent = Json_StringDecode($Indent)
			If StringRegExp($Indent, "[^\t ]") Then $Indent = @TAB
		EndIf
		If IsKeyword($ArraySep) Then
			$ArraySep = "," & @CRLF
		Else
			$ArraySep = Json_StringDecode($ArraySep)
			If $ArraySep = "" Or StringRegExp($ArraySep, "[^\s,]|,.*,") Or ($Strict And Not StringRegExp($ArraySep, ",")) Then $ArraySep = "," & @CRLF
		EndIf
		If IsKeyword($ObjectSep) Then
			$ObjectSep = "," & @CRLF
		Else
			$ObjectSep = Json_StringDecode($ObjectSep)
			If $ObjectSep = "" Or StringRegExp($ObjectSep, "[^\s,]|,.*,") Or ($Strict And Not StringRegExp($ObjectSep, ",")) Then $ObjectSep = "," & @CRLF
		EndIf
		If IsKeyword($ColonSep) Then
			$ColonSep = ": "
		Else
			$ColonSep = Json_StringDecode($ColonSep)
			If $ColonSep = "" Or StringRegExp($ColonSep, "[^\s,:]|[,:].*[,:]") Or ($Strict And (StringRegExp($ColonSep, ",") Or Not StringRegExp($ColonSep, ":"))) Then $ColonSep = ": "
		EndIf
		Return Json_Encode_Pretty($Data, $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep)
	ElseIf BitAND($Option, $JSON_UNQUOTED_STRING) Then
		Return Json_Encode_Pretty($Data, $Option, "", ",", ",", ":")
	Else
		Return Json_Encode_Compact($Data, $Option)
	EndIf
EndFunc   ;==>Json_Encode
Func Json_ObjCreate()
	Local $Object = ObjCreate('Scripting.Dictionary')
	$Object.CompareMode = 0
	Return $Object
EndFunc   ;==>Json_ObjCreate
Func Json_ObjPut(ByRef $Object, $Key, $Value)
	$Key = String($Key)
	If $Object.Exists($Key) Then $Object.Remove($Key)
	$Object.Add($Key, $Value)
EndFunc   ;==>Json_ObjPut
Func Json_ObjGet(ByRef $Object, $Key)
	Local $DynObject = $Object
	Local $Keys = StringSplit($Key, ".")
	For $x = 1 To $Keys[0]
		If $DynObject.Exists($Keys[$x]) Then
			If $x = $Keys[0] Then
				Return $DynObject.Item($Keys[$x])
			Else
				$DynObject = Json_ObjGet($DynObject, $Keys[$x])
			EndIf
		EndIf
	Next
	Return SetError(1, 0, '')
EndFunc   ;==>Json_ObjGet
Func Json_ObjDelete(ByRef $Object, $Key)
	$Key = String($Key)
	If $Object.Exists($Key) Then $Object.Remove($Key)
EndFunc   ;==>Json_ObjDelete
Func Json_ObjExists(ByRef $Object, $Key)
	Local $DynObject = $Object
	Local $Keys = StringSplit($Key, ".")
	For $x = 1 To $Keys[0]
		If $DynObject.Exists($Keys[$x]) Then
			If $x = $Keys[0] Then
				Return True
			Else
				$DynObject = Json_ObjGet($DynObject, $Keys[$x])
			EndIf
		Else
			Return False
		EndIf
	Next
	Return False
EndFunc   ;==>Json_ObjExists
Func Json_ObjGetCount(ByRef $Object)
	Return $Object.Count
EndFunc   ;==>Json_ObjGetCount
Func Json_ObjGetKeys(ByRef $Object)
	Return $Object.Keys()
EndFunc   ;==>Json_ObjGetKeys
Func Json_ObjGetItems(ByRef $Object)
	Return $Object.Items()
EndFunc   ;==>Json_ObjGetItems
Func Json_ObjClear(ByRef $Object)
	Return $Object.RemoveAll()
EndFunc   ;==>Json_ObjClear
Func Json_Put(ByRef $Var, $Notation, $Data, $CheckExists = False)
	Local $Ret = 0, $Item = "", $Error = 0
	Local $Match = ""
	$Match = StringRegExp($Notation, "(^\[([^\]]+)\])|(^\.([^\.\[]+))", 3)
	If IsArray($Match) Then
		Local $Index
		If UBound($Match) = 4 Then
			$Index = String(Json_Decode($Match[3])) ; only string using dot notation
			$Notation = StringTrimLeft($Notation, StringLen($Match[2]))
		Else
			$Index = Json_Decode($Match[1])
			$Notation = StringTrimLeft($Notation, StringLen($Match[0]))
		EndIf
		If IsString($Index) Then
			If $CheckExists And (Not Json_IsObject($Var) Or Not Json_ObjExists($Var, $Index)) Then
				Return SetError(1, 0, False) ; no specific object
			EndIf
			If Not Json_IsObject($Var) Then $Var = Json_ObjCreate()
			If $Notation Then
				$Item = Json_ObjGet($Var, $Index)
				$Ret = Json_Put($Item, $Notation, $Data, $CheckExists)
				$Error = @error
				If Not $Error Then Json_ObjPut($Var, $Index, $Item)
				Return SetError($Error, 0, $Ret)
			Else
				Json_ObjPut($Var, $Index, $Data)
				Return True
			EndIf
		ElseIf IsInt($Index) Then
			If $Index < 0 Or ($CheckExists And (Not IsArray($Var) Or UBound($Var, 0) <> 1 Or $Index >= UBound($Var))) Then
				Return SetError(1, 0, False) ; no specific object
			EndIf
			If Not IsArray($Var) Or UBound($Var, 0) <> 1 Then
				Dim $Var[$Index + 1]
			ElseIf $Index >= UBound($Var) Then
				ReDim $Var[$Index + 1]
			EndIf
			If $Notation Then
				$Ret = Json_Put($Var[$Index], $Notation, $Data, $CheckExists)
				Return SetError(@error, 0, $Ret)
			Else
				$Var[$Index] = $Data
				Return True
			EndIf
		EndIf
	EndIf
	Return SetError(2, 0, False) ; invalid notation
EndFunc   ;==>Json_Put
Func Json_Get(ByRef $Var, $Notation)
	Local $Match = StringRegExp($Notation, "(^\[([^\]]+)\])|(^\.([^\.\[]+))", 3)
	If IsArray($Match) Then
		Local $Index
		If UBound($Match) = 4 Then
			$Index = String(Json_Decode($Match[3])) ; only string using dot notation
			$Notation = StringTrimLeft($Notation, StringLen($Match[2]))
		Else
			$Index = Json_Decode($Match[1])
			$Notation = StringTrimLeft($Notation, StringLen($Match[0]))
		EndIf
		Local $Item
		If IsString($Index) And Json_IsObject($Var) And Json_ObjExists($Var, $Index) Then
			$Item = Json_ObjGet($Var, $Index)
		ElseIf IsInt($Index) And IsArray($Var) And UBound($Var, 0) = 1 And $Index >= 0 And $Index < UBound($Var) Then
			$Item = $Var[$Index]
		Else
			Return SetError(1, 0, "") ; no specific object
		EndIf
		If Not $Notation Then Return $Item
		Local $Ret = Json_Get($Item, $Notation)
		Return SetError(@error, 0, $Ret)
	EndIf
	Return SetError(2, 0, "") ; invalid notation
EndFunc   ;==>Json_Get
Func Json_Dump($Json, $InitTokenCount = 1000)
	Static $Jsmn_Init = __Jsmn_RuntimeLoader("jsmn_init"), $Jsmn_Parse = __Jsmn_RuntimeLoader("jsmn_parse")
	If $Json = "" Then $Json = '""'
	Local $TokenList, $Ret
	Local $Parser = DllStructCreate("uint pos;int toknext;int toksuper")
	Do
		DllCallAddress("none:cdecl", $Jsmn_Init, "ptr", DllStructGetPtr($Parser))
		$TokenList = DllStructCreate("byte[" & ($InitTokenCount * 20) & "]")
		$Ret = DllCallAddress("int:cdecl", $Jsmn_Parse, "ptr", DllStructGetPtr($Parser), "wstr", $Json, "ptr", DllStructGetPtr($TokenList), "uint", $InitTokenCount)
		$InitTokenCount *= 2
	Until $Ret[0] <> $JSMN_ERROR_NOMEM
	Local $Next = 0
	_Json_TokenDump($Json, DllStructGetPtr($TokenList), $Next)
EndFunc   ;==>Json_Dump
Func _Json_TokenDump(ByRef $Json, $Ptr, ByRef $Next, $ObjPath = "")
	If $Next = -1 Then Return Null
	Local $Token = DllStructCreate("int;int;int;int", $Ptr + ($Next * 20))
	Local $Type = DllStructGetData($Token, 1)
	Local $Start = DllStructGetData($Token, 2)
	Local $End = DllStructGetData($Token, 3)
	Local $Size = DllStructGetData($Token, 4)
	Local $Value
	$Next += 1
	If $Type = 0 And $Start = 0 And $End = 0 And $Size = 0 Then ; Null Item
		$Next = -1
		Return Null
	EndIf
	Switch $Type
		Case 0 ; Json_PRIMITIVE
			Local $Primitive = StringMid($Json, $Start + 1, $End - $Start)
			Switch $Primitive
				Case "true"
					Return "True"
				Case "false"
					Return "False"
				Case "null"
					Return "Null"
				Case Else
					If StringRegExp($Primitive, "^[+\-0-9]") Then
						Return Number($Primitive)
					Else
						Return Json_StringDecode($Primitive)
					EndIf
			EndSwitch
		Case 1 ; Json_OBJECT
			For $i = 0 To $Size - 1 Step 2
				Local $Key = _Json_TokenDump($Json, $Ptr, $Next)
				Local $cObjPath = $ObjPath & "." & $Key
				$Value = _Json_TokenDump($Json, $Ptr, $Next, $ObjPath & "." & $Key)
				If Not (IsBool($Value) And $Value = False) Then
					If Not IsString($Key) Then
						$Key = Json_Encode($Key)
					EndIf
					ConsoleWrite("+-> " & $cObjPath & '  =' & $Value & @CRLF)
				EndIf
			Next
			Return False
		Case 2 ; Json_ARRAY
			Local $sObjPath = $ObjPath
			For $i = 0 To $Size - 1
				$sObjPath = $ObjPath & "[" & $i & "]"
				$Value = _Json_TokenDump($Json, $Ptr, $Next, $sObjPath)
				If Not (IsBool($Value) And $Value = False) Then ;XC - Changed line
					ConsoleWrite("+=> " & $sObjPath & "=>" & $Value & @CRLF)
				EndIf
			Next
			$ObjPath = $sObjPath
			Return False
		Case 3 ; Json_STRING
			Local $LastKey = Json_StringDecode(StringMid($Json, $Start + 1, $End - $Start))
			Return $LastKey
	EndSwitch
EndFunc   ;==>_Json_TokenDump
#comments-start
	Copyright 2013 Dragana R. <trancexx at yahoo dot com>
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
#comments-end
;#include "WinHttpConstants.au3"; REMOVED INCLUDE
Global Const $hWINHTTPDLL__WINHTTP = DllOpen("winhttp.dll")
DllOpen("winhttp.dll") ; making sure reference count never reaches 0
Func _WinHttpAddRequestHeaders($hRequest, $sHeader, $iModifier = Default)
	__WinHttpDefault($iModifier, $WINHTTP_ADDREQ_FLAG_ADD_IF_NEW)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpAddRequestHeaders", _
			"handle", $hRequest, _
			"wstr", $sHeader, _
			"dword", -1, _
			"dword", $iModifier)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpCheckPlatform()
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCheckPlatform")
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc
Func _WinHttpCloseHandle($hInternet)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCloseHandle", "handle", $hInternet)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpConnect($hSession, $sServerName, $iServerPort = Default)
	Local $aURL = _WinHttpCrackUrl($sServerName), $iScheme = 0
	If @error Then
		__WinHttpDefault($iServerPort, $INTERNET_DEFAULT_PORT)
	Else
		$sServerName = $aURL[2]
		$iServerPort = $aURL[3]
		$iScheme = $aURL[1]
	EndIf
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpConnect", _
			"handle", $hSession, _
			"wstr", $sServerName, _
			"dword", $iServerPort, _
			"dword", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	_WinHttpSetOption($aCall[0], $WINHTTP_OPTION_CONTEXT_VALUE, $iScheme)
	Return $aCall[0]
EndFunc
Func _WinHttpCrackUrl($sURL, $iFlag = Default)
	__WinHttpDefault($iFlag, $ICU_ESCAPE)
	Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
			"ptr SchemeName;" & _
			"dword SchemeNameLength;" & _
			"int Scheme;" & _
			"ptr HostName;" & _
			"dword HostNameLength;" & _
			"word Port;" & _
			"ptr UserName;" & _
			"dword UserNameLength;" & _
			"ptr Password;" & _
			"dword PasswordLength;" & _
			"ptr UrlPath;" & _
			"dword UrlPathLength;" & _
			"ptr ExtraInfo;" & _
			"dword ExtraInfoLength")
	DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))
	Local $tBuffers[6]
	Local $iURLLen = StringLen($sURL)
	For $i = 0 To 5
		$tBuffers[$i] = DllStructCreate("wchar[" & $iURLLen + 1 & "]")
	Next
	DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0]))
	DllStructSetData($tURL_COMPONENTS, "HostNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1]))
	DllStructSetData($tURL_COMPONENTS, "UserNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2]))
	DllStructSetData($tURL_COMPONENTS, "PasswordLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3]))
	DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4]))
	DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5]))
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCrackUrl", _
			"wstr", $sURL, _
			"dword", $iURLLen, _
			"dword", $iFlag, _
			"struct*", $tURL_COMPONENTS)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Local $aRet[8] = [DllStructGetData($tBuffers[0], 1), _
			DllStructGetData($tURL_COMPONENTS, "Scheme"), _
			DllStructGetData($tBuffers[1], 1), _
			DllStructGetData($tURL_COMPONENTS, "Port"), _
			DllStructGetData($tBuffers[2], 1), _
			DllStructGetData($tBuffers[3], 1), _
			DllStructGetData($tBuffers[4], 1), _
			DllStructGetData($tBuffers[5], 1)]
	Return $aRet
EndFunc
Func _WinHttpCreateUrl($aURLArray)
	If UBound($aURLArray) - 8 Then Return SetError(1, 0, "")
	Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
			"ptr SchemeName;" & _
			"dword SchemeNameLength;" & _
			"int Scheme;" & _
			"ptr HostName;" & _
			"dword HostNameLength;" & _
			"word Port;" & _
			"ptr UserName;" & _
			"dword UserNameLength;" & _
			"ptr Password;" & _
			"dword PasswordLength;" & _
			"ptr UrlPath;" & _
			"dword UrlPathLength;" & _
			"ptr ExtraInfo;" & _
			"dword ExtraInfoLength;")
	DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))
	Local $tBuffers[6][2]
	$tBuffers[0][1] = StringLen($aURLArray[0])
	If $tBuffers[0][1] Then
		$tBuffers[0][0] = DllStructCreate("wchar[" & $tBuffers[0][1] + 1 & "]")
		DllStructSetData($tBuffers[0][0], 1, $aURLArray[0])
	EndIf
	$tBuffers[1][1] = StringLen($aURLArray[2])
	If $tBuffers[1][1] Then
		$tBuffers[1][0] = DllStructCreate("wchar[" & $tBuffers[1][1] + 1 & "]")
		DllStructSetData($tBuffers[1][0], 1, $aURLArray[2])
	EndIf
	$tBuffers[2][1] = StringLen($aURLArray[4])
	If $tBuffers[2][1] Then
		$tBuffers[2][0] = DllStructCreate("wchar[" & $tBuffers[2][1] + 1 & "]")
		DllStructSetData($tBuffers[2][0], 1, $aURLArray[4])
	EndIf
	$tBuffers[3][1] = StringLen($aURLArray[5])
	If $tBuffers[3][1] Then
		$tBuffers[3][0] = DllStructCreate("wchar[" & $tBuffers[3][1] + 1 & "]")
		DllStructSetData($tBuffers[3][0], 1, $aURLArray[5])
	EndIf
	$tBuffers[4][1] = StringLen($aURLArray[6])
	If $tBuffers[4][1] Then
		$tBuffers[4][0] = DllStructCreate("wchar[" & $tBuffers[4][1] + 1 & "]")
		DllStructSetData($tBuffers[4][0], 1, $aURLArray[6])
	EndIf
	$tBuffers[5][1] = StringLen($aURLArray[7])
	If $tBuffers[5][1] Then
		$tBuffers[5][0] = DllStructCreate("wchar[" & $tBuffers[5][1] + 1 & "]")
		DllStructSetData($tBuffers[5][0], 1, $aURLArray[7])
	EndIf
	DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $tBuffers[0][1])
	DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0][0]))
	DllStructSetData($tURL_COMPONENTS, "HostNameLength", $tBuffers[1][1])
	DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1][0]))
	DllStructSetData($tURL_COMPONENTS, "UserNameLength", $tBuffers[2][1])
	DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2][0]))
	DllStructSetData($tURL_COMPONENTS, "PasswordLength", $tBuffers[3][1])
	DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3][0]))
	DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $tBuffers[4][1])
	DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4][0]))
	DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $tBuffers[5][1])
	DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5][0]))
	DllStructSetData($tURL_COMPONENTS, "Scheme", $aURLArray[1])
	DllStructSetData($tURL_COMPONENTS, "Port", $aURLArray[3])
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCreateUrl", _
			"struct*", $tURL_COMPONENTS, _
			"dword", $ICU_ESCAPE, _
			"ptr", 0, _
			"dword*", 0)
	If @error Then Return SetError(2, 0, "")
	Local $iURLLen = $aCall[4]
	Local $URLBuffer = DllStructCreate("wchar[" & ($iURLLen + 1) & "]")
	$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCreateUrl", _
			"struct*", $tURL_COMPONENTS, _
			"dword", $ICU_ESCAPE, _
			"struct*", $URLBuffer, _
			"dword*", $iURLLen)
	If @error Or Not $aCall[0] Then Return SetError(3, 0, "")
	Return DllStructGetData($URLBuffer, 1)
EndFunc
Func _WinHttpDetectAutoProxyConfigUrl($iAutoDetectFlags)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpDetectAutoProxyConfigUrl", "dword", $iAutoDetectFlags, "ptr*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Local $pStr = $aCall[2]
	If $pStr Then
		Local $iLen = __WinHttpPtrStringLenW($pStr)
		If @error Then Return SetError(2, 0, "")
		Local $tString = DllStructCreate("wchar[" & $iLen + 1 & "]", $pStr)
		Local $sString = DllStructGetData($tString, 1)
		__WinHttpMemGlobalFree($pStr)
		Return $sString
	EndIf
	Return ""
EndFunc
Func _WinHttpGetDefaultProxyConfiguration()
	Local $tWINHTTP_PROXY_INFO = DllStructCreate("dword AccessType;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpGetDefaultProxyConfiguration", "struct*", $tWINHTTP_PROXY_INFO)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Local $iAccessType = DllStructGetData($tWINHTTP_PROXY_INFO, "AccessType")
	Local $pProxy = DllStructGetData($tWINHTTP_PROXY_INFO, "Proxy")
	Local $pProxyBypass = DllStructGetData($tWINHTTP_PROXY_INFO, "ProxyBypass")
	Local $sProxy
	If $pProxy Then
		Local $iProxyLen = __WinHttpPtrStringLenW($pProxy)
		If Not @error Then
			Local $tProxy = DllStructCreate("wchar[" & $iProxyLen + 1 & "]", $pProxy)
			$sProxy = DllStructGetData($tProxy, 1)
			__WinHttpMemGlobalFree($pProxy)
		EndIf
	EndIf
	Local $sProxyBypass
	If $pProxyBypass Then
		Local $iProxyBypassLen = __WinHttpPtrStringLenW($pProxyBypass)
		If Not @error Then
			Local $tProxyBypass = DllStructCreate("wchar[" & $iProxyBypassLen + 1 & "]", $pProxyBypass)
			$sProxyBypass = DllStructGetData($tProxyBypass, 1)
			__WinHttpMemGlobalFree($pProxyBypass)
		EndIf
	EndIf
	Local $aRet[3] = [$iAccessType, $sProxy, $sProxyBypass]
	Return $aRet
EndFunc
Func _WinHttpGetIEProxyConfigForCurrentUser()
	Local $tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG = DllStructCreate("int AutoDetect;" & _
			"ptr AutoConfigUrl;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass;")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpGetIEProxyConfigForCurrentUser", "struct*", $tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Local $iAutoDetect = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "AutoDetect")
	Local $pAutoConfigUrl = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "AutoConfigUrl")
	Local $pProxy = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "Proxy")
	Local $pProxyBypass = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "ProxyBypass")
	Local $sAutoConfigUrl
	If $pAutoConfigUrl Then
		Local $iAutoConfigUrlLen = __WinHttpPtrStringLenW($pAutoConfigUrl)
		If Not @error Then
			Local $tAutoConfigUrl = DllStructCreate("wchar[" & $iAutoConfigUrlLen + 1 & "]", $pAutoConfigUrl)
			$sAutoConfigUrl = DllStructGetData($tAutoConfigUrl, 1)
			__WinHttpMemGlobalFree($pAutoConfigUrl)
		EndIf
	EndIf
	Local $sProxy
	If $pProxy Then
		Local $iProxyLen = __WinHttpPtrStringLenW($pProxy)
		If Not @error Then
			Local $tProxy = DllStructCreate("wchar[" & $iProxyLen + 1 & "]", $pProxy)
			$sProxy = DllStructGetData($tProxy, 1)
			__WinHttpMemGlobalFree($pProxy)
		EndIf
	EndIf
	Local $sProxyBypass
	If $pProxyBypass Then
		Local $iProxyBypassLen = __WinHttpPtrStringLenW($pProxyBypass)
		If Not @error Then
			Local $tProxyBypass = DllStructCreate("wchar[" & $iProxyBypassLen + 1 & "]", $pProxyBypass)
			$sProxyBypass = DllStructGetData($tProxyBypass, 1)
			__WinHttpMemGlobalFree($pProxyBypass)
		EndIf
	EndIf
	Local $aOutput[4] = [$iAutoDetect, $sAutoConfigUrl, $sProxy, $sProxyBypass]
	Return $aOutput
EndFunc
Func _WinHttpOpen($sUserAgent = Default, $iAccessType = Default, $sProxyName = Default, $sProxyBypass = Default, $iFlag = Default)
	__WinHttpDefault($sUserAgent, __WinHttpUA())
	__WinHttpDefault($iAccessType, $WINHTTP_ACCESS_TYPE_NO_PROXY)
	__WinHttpDefault($sProxyName, $WINHTTP_NO_PROXY_NAME)
	__WinHttpDefault($sProxyBypass, $WINHTTP_NO_PROXY_BYPASS)
	__WinHttpDefault($iFlag, 0)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpen", _
			"wstr", $sUserAgent, _
			"dword", $iAccessType, _
			"wstr", $sProxyName, _
			"wstr", $sProxyBypass, _
			"dword", $iFlag)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	If $iFlag = $WINHTTP_FLAG_ASYNC Then _WinHttpSetOption($aCall[0], $WINHTTP_OPTION_CONTEXT_VALUE, $WINHTTP_FLAG_ASYNC)
	Return $aCall[0]
EndFunc
Func _WinHttpOpenRequest($hConnect, $sVerb = Default, $sObjectName = Default, $sVersion = Default, $sReferrer = Default, $sAcceptTypes = Default, $iFlags = Default)
	__WinHttpDefault($sVerb, "GET")
	__WinHttpDefault($sObjectName, "")
	__WinHttpDefault($sVersion, "HTTP/1.1")
	__WinHttpDefault($sReferrer, $WINHTTP_NO_REFERER)
	__WinHttpDefault($iFlags, $WINHTTP_FLAG_ESCAPE_DISABLE)
	Local $pAcceptTypes
	If $sAcceptTypes = Default Or Number($sAcceptTypes) = -1 Then
		$pAcceptTypes = $WINHTTP_DEFAULT_ACCEPT_TYPES
	Else
		Local $aTypes = StringSplit($sAcceptTypes, ",", 2)
		Local $tAcceptTypes = DllStructCreate("ptr[" & UBound($aTypes) + 1 & "]")
		Local $tType[UBound($aTypes)]
		For $i = 0 To UBound($aTypes) - 1
			$tType[$i] = DllStructCreate("wchar[" & StringLen($aTypes[$i]) + 1 & "]")
			DllStructSetData($tType[$i], 1, $aTypes[$i])
			DllStructSetData($tAcceptTypes, 1, DllStructGetPtr($tType[$i]), $i + 1)
		Next
		$pAcceptTypes = DllStructGetPtr($tAcceptTypes)
	EndIf
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpenRequest", _
			"handle", $hConnect, _
			"wstr", StringUpper($sVerb), _
			"wstr", $sObjectName, _
			"wstr", StringUpper($sVersion), _
			"wstr", $sReferrer, _
			"ptr", $pAcceptTypes, _
			"dword", $iFlags)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc
Func _WinHttpQueryAuthSchemes($hRequest, ByRef $iSupportedSchemes, ByRef $iFirstScheme, ByRef $iAuthTarget)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryAuthSchemes", _
			"handle", $hRequest, _
			"dword*", 0, _
			"dword*", 0, _
			"dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	$iSupportedSchemes = $aCall[2]
	$iFirstScheme = $aCall[3]
	$iAuthTarget = $aCall[4]
	Return 1
EndFunc
Func _WinHttpQueryDataAvailable($hRequest)
	Local $sReadType = "dword*"
	If BitAND(_WinHttpQueryOption(_WinHttpQueryOption(_WinHttpQueryOption($hRequest, $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_CONTEXT_VALUE), $WINHTTP_FLAG_ASYNC) Then $sReadType = "ptr"
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryDataAvailable", "handle", $hRequest, $sReadType, 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetExtended($aCall[2], $aCall[0])
EndFunc
Func _WinHttpQueryHeaders($hRequest, $iInfoLevel = Default, $sName = Default, $iIndex = Default)
	__WinHttpDefault($iInfoLevel, $WINHTTP_QUERY_RAW_HEADERS_CRLF)
	__WinHttpDefault($sName, $WINHTTP_HEADER_NAME_BY_INDEX)
	__WinHttpDefault($iIndex, $WINHTTP_NO_HEADER_INDEX)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryHeaders", _
			"handle", $hRequest, _
			"dword", $iInfoLevel, _
			"wstr", $sName, _
			"wstr", "", _
			"dword*", 65536, _
			"dword*", $iIndex)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Return SetExtended($aCall[6], $aCall[4])
EndFunc
Func _WinHttpQueryOption($hInternet, $iOption)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
			"ptr", 0, _
			"dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, "")
	Local $iSize = $aCall[4]
	Local $tBuffer
	Switch $iOption
		Case $WINHTTP_OPTION_CONNECTION_INFO, $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_URL, $WINHTTP_OPTION_USERNAME, $WINHTTP_OPTION_USER_AGENT, _
				$WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT, $WINHTTP_OPTION_PASSPORT_COBRANDING_URL
			$tBuffer = DllStructCreate("wchar[" & $iSize + 1 & "]")
		Case $WINHTTP_OPTION_PARENT_HANDLE, $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_SERVER_CERT_CONTEXT
			$tBuffer = DllStructCreate("ptr")
		Case $WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM, _
				$WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, $WINHTTP_OPTION_EXTENDED_ERROR, $WINHTTP_OPTION_HANDLE_TYPE, $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, _
				$WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURITY_FLAGS, $WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT
			$tBuffer = DllStructCreate("int")
		Case $WINHTTP_OPTION_CONTEXT_VALUE
			$tBuffer = DllStructCreate("dword_ptr")
		Case Else
			$tBuffer = DllStructCreate("byte[" & $iSize & "]")
	EndSwitch
	$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
			"struct*", $tBuffer, _
			"dword*", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($tBuffer, 1)
EndFunc
Func _WinHttpReadData($hRequest, $iMode = Default, $iNumberOfBytesToRead = Default, $pBuffer = Default)
	__WinHttpDefault($iMode, 0)
	__WinHttpDefault($iNumberOfBytesToRead, 8192)
	Local $tBuffer, $vOutOnError = ""
	If $iMode = 2 Then $vOutOnError = Binary($vOutOnError)
	Switch $iMode
		Case 1, 2
			If $pBuffer And $pBuffer <> Default Then
				$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]", $pBuffer)
			Else
				$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]")
			EndIf
		Case Else
			$iMode = 0
			If $pBuffer And $pBuffer <> Default Then
				$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]", $pBuffer)
			Else
				$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]")
			EndIf
	EndSwitch
	Local $sReadType = "dword*"
	If BitAND(_WinHttpQueryOption(_WinHttpQueryOption(_WinHttpQueryOption($hRequest, $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_CONTEXT_VALUE), $WINHTTP_FLAG_ASYNC) Then $sReadType = "ptr"
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReadData", _
			"handle", $hRequest, _
			"struct*", $tBuffer, _
			"dword", $iNumberOfBytesToRead, _
			$sReadType, 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	If Not $aCall[4] Then Return SetError(-1, 0, $vOutOnError)
	If $aCall[4] < $iNumberOfBytesToRead Then
		Switch $iMode
			Case 0
				Return SetExtended($aCall[4], StringLeft(DllStructGetData($tBuffer, 1), $aCall[4]))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]), 4))
			Case 2
				Return SetExtended($aCall[4], BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]))
		EndSwitch
	Else
		Switch $iMode
			Case 0, 2
				Return SetExtended($aCall[4], DllStructGetData($tBuffer, 1))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(DllStructGetData($tBuffer, 1), 4))
		EndSwitch
	EndIf
EndFunc
Func _WinHttpReceiveResponse($hRequest)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReceiveResponse", "handle", $hRequest, "ptr", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpSendRequest($hRequest, $sHeaders = Default, $vOptional = Default, $iTotalLength = Default, $iContext = Default)
	__WinHttpDefault($sHeaders, $WINHTTP_NO_ADDITIONAL_HEADERS)
	__WinHttpDefault($vOptional, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($iTotalLength, 0)
	__WinHttpDefault($iContext, 0)
	Local $pOptional = 0, $iOptionalLength = 0
	If @NumParams > 2 Then
		Local $tOptional
		$iOptionalLength = BinaryLen($vOptional)
		$tOptional = DllStructCreate("byte[" & $iOptionalLength & "]")
		If $iOptionalLength Then $pOptional = DllStructGetPtr($tOptional)
		DllStructSetData($tOptional, 1, $vOptional)
	EndIf
	If Not $iTotalLength Or $iTotalLength < $iOptionalLength Then $iTotalLength += $iOptionalLength
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSendRequest", _
			"handle", $hRequest, _
			"wstr", $sHeaders, _
			"dword", 0, _
			"ptr", $pOptional, _
			"dword", $iOptionalLength, _
			"dword", $iTotalLength, _
			"dword_ptr", $iContext)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpSetCredentials($hRequest, $iAuthTargets, $iAuthScheme, $sUserName, $sPassword)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetCredentials", _
			"handle", $hRequest, _
			"dword", $iAuthTargets, _
			"dword", $iAuthScheme, _
			"wstr", $sUserName, _
			"wstr", $sPassword, _
			"ptr", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpSetDefaultProxyConfiguration($iAccessType, $sProxy = "", $sProxyBypass = "")
	Local $tProxy = DllStructCreate("wchar[" & StringLen($sProxy) + 1 & "]")
	DllStructSetData($tProxy, 1, $sProxy)
	Local $tProxyBypass = DllStructCreate("wchar[" & StringLen($sProxyBypass) + 1 & "]")
	DllStructSetData($tProxyBypass, 1, $sProxyBypass)
	Local $tWINHTTP_PROXY_INFO = DllStructCreate("dword AccessType;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass")
	DllStructSetData($tWINHTTP_PROXY_INFO, "AccessType", $iAccessType)
	If $iAccessType <> $WINHTTP_ACCESS_TYPE_NO_PROXY Then
		DllStructSetData($tWINHTTP_PROXY_INFO, "Proxy", DllStructGetPtr($tProxy))
		DllStructSetData($tWINHTTP_PROXY_INFO, "ProxyBypass", DllStructGetPtr($tProxyBypass))
	EndIf
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetDefaultProxyConfiguration", "struct*", $tWINHTTP_PROXY_INFO)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpSetOption($hInternet, $iOption, $vSetting, $iSize = Default)
	If $iSize = Default Then $iSize = -1
	If IsBinary($vSetting) Then
		$iSize = DllStructCreate("byte[" & BinaryLen($vSetting) & "]")
		DllStructSetData($iSize, 1, $vSetting)
		$vSetting = $iSize
		$iSize = DllStructGetSize($vSetting)
	EndIf
	Local $sType
	Switch $iOption
		Case $WINHTTP_OPTION_AUTOLOGON_POLICY, $WINHTTP_OPTION_CODEPAGE, $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, _
				$WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_OPTION_DISABLE_FEATURE, $WINHTTP_OPTION_ENABLE_FEATURE, $WINHTTP_OPTION_ENABLETRACING, _
				$WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, $WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, _
				$WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE, $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE, $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE, _
				$WINHTTP_OPTION_READ_BUFFER_SIZE, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_REDIRECT_POLICY, $WINHTTP_OPTION_REJECT_USERPWD_IN_URL, _
				$WINHTTP_OPTION_REQUEST_PRIORITY, $WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURE_PROTOCOLS, $WINHTTP_OPTION_SECURITY_FLAGS, _
				$WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT, $WINHTTP_OPTION_SPN, $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS, _
				$WINHTTP_OPTION_WORKER_THREAD_COUNT, $WINHTTP_OPTION_WRITE_BUFFER_SIZE, $WINHTTP_OPTION_DECOMPRESSION, $WINHTTP_OPTION_UNSAFE_HEADER_PARSING
			$sType = "dword*"
			$iSize = 4
		Case $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_PASSPORT_SIGN_OUT
			$sType = "ptr*"
			$iSize = 4
			If @AutoItX64 Then $iSize = 8
			If Not IsPtr($vSetting) Then Return SetError(3, 0, 0)
		Case $WINHTTP_OPTION_CONTEXT_VALUE
			$sType = "dword_ptr*"
			$iSize = 4
			If @AutoItX64 Then $iSize = 8
		Case $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_USER_AGENT, $WINHTTP_OPTION_USERNAME
			$sType = "wstr"
			If (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
			If $iSize < 1 Then $iSize = StringLen($vSetting)
		Case $WINHTTP_OPTION_CLIENT_CERT_CONTEXT, $WINHTTP_OPTION_GLOBAL_PROXY_CREDS, $WINHTTP_OPTION_GLOBAL_SERVER_CREDS, $WINHTTP_OPTION_HTTP_VERSION, _
				$WINHTTP_OPTION_PROXY
			$sType = "ptr"
			If Not (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
	If $iSize < 1 Then
		If IsDllStruct($vSetting) Then
			$iSize = DllStructGetSize($vSetting)
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Local $aCall
	If IsDllStruct($vSetting) Then
		$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, DllStructGetPtr($vSetting), "dword", $iSize)
	Else
		$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, $vSetting, "dword", $iSize)
	EndIf
	If @error Or Not $aCall[0] Then Return SetError(4, 0, 0)
	Return 1
EndFunc
Func _WinHttpSetStatusCallback($hInternet, $hInternetCallback, $iNotificationFlags = Default)
	__WinHttpDefault($iNotificationFlags, $WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "ptr", "WinHttpSetStatusCallback", _
			"handle", $hInternet, _
			"ptr", DllCallbackGetPtr($hInternetCallback), _
			"dword", $iNotificationFlags, _
			"ptr", 0)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc
Func _WinHttpSetTimeouts($hInternet, $iResolveTimeout = Default, $iConnectTimeout = Default, $iSendTimeout = Default, $iReceiveTimeout = Default)
	__WinHttpDefault($iResolveTimeout, 0)
	__WinHttpDefault($iConnectTimeout, 60000)
	__WinHttpDefault($iSendTimeout, 30000)
	__WinHttpDefault($iReceiveTimeout, 30000)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetTimeouts", _
			"handle", $hInternet, _
			"int", $iResolveTimeout, _
			"int", $iConnectTimeout, _
			"int", $iSendTimeout, _
			"int", $iReceiveTimeout)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func _WinHttpSimpleBinaryConcat(ByRef $bBinary1, ByRef $bBinary2)
	Switch IsBinary($bBinary1) + 2 * IsBinary($bBinary2)
		Case 0
			Return SetError(1, 0, Binary(''))
		Case 1
			Return $bBinary1
		Case 2
			Return $bBinary2
	EndSwitch
	Local $tAuxiliary = DllStructCreate("byte[" & BinaryLen($bBinary1) & "];byte[" & BinaryLen($bBinary2) & "]")
	DllStructSetData($tAuxiliary, 1, $bBinary1)
	DllStructSetData($tAuxiliary, 2, $bBinary2)
	Local $tOutput = DllStructCreate("byte[" & DllStructGetSize($tAuxiliary) & "]", DllStructGetPtr($tAuxiliary))
	Return DllStructGetData($tOutput, 1)
EndFunc
Func _WinHttpSimpleFormFill(ByRef $hInternet, $sActionPage = Default, $sFormId = Default, $sFldId1 = Default, $sDta1 = Default, $sFldId2 = Default, $sDta2 = Default, $sFldId3 = Default, $sDta3 = Default, $sFldId4 = Default, $sDta4 = Default, $sFldId5 = Default, $sDta5 = Default, $sFldId6 = Default, $sDta6 = Default, $sFldId7 = Default, $sDta7 = Default, $sFldId8 = Default, $sDta8 = Default, $sFldId9 = Default, $sDta9 = Default, $sFldId10 = Default, $sDta10 = Default, _
		$sFldId11 = Default, $sDta11 = Default, $sFldId12 = Default, $sDta12 = Default, $sFldId13 = Default, $sDta13 = Default, $sFldId14 = Default, $sDta14 = Default, $sFldId15 = Default, $sDta15 = Default, $sFldId16 = Default, $sDta16 = Default, $sFldId17 = Default, $sDta17 = Default, $sFldId18 = Default, $sDta18 = Default, $sFldId19 = Default, $sDta19 = Default, $sFldId20 = Default, $sDta20 = Default, _
		$sFldId21 = Default, $sDta21 = Default, $sFldId22 = Default, $sDta22 = Default, $sFldId23 = Default, $sDta23 = Default, $sFldId24 = Default, $sDta24 = Default, $sFldId25 = Default, $sDta25 = Default, $sFldId26 = Default, $sDta26 = Default, $sFldId27 = Default, $sDta27 = Default, $sFldId28 = Default, $sDta28 = Default, $sFldId29 = Default, $sDta29 = Default, $sFldId30 = Default, $sDta30 = Default, _
		$sFldId31 = Default, $sDta31 = Default, $sFldId32 = Default, $sDta32 = Default, $sFldId33 = Default, $sDta33 = Default, $sFldId34 = Default, $sDta34 = Default, $sFldId35 = Default, $sDta35 = Default, $sFldId36 = Default, $sDta36 = Default, $sFldId37 = Default, $sDta37 = Default, $sFldId38 = Default, $sDta38 = Default, $sFldId39 = Default, $sDta39 = Default, $sFldId40 = Default, $sDta40 = Default)
	__WinHttpDefault($sActionPage, "")
	Local $iNumArgs = @NumParams, $sAdditionalHeaders, $sCredName, $sCredPass, $iIgnoreCertErr, $iRetArr
	Local $aDtas[41] = [0, $sDta1, $sDta2, $sDta3, $sDta4, $sDta5, $sDta6, $sDta7, $sDta8, $sDta9, $sDta10, $sDta11, $sDta12, $sDta13, $sDta14, $sDta15, $sDta16, $sDta17, $sDta18, $sDta19, $sDta20, $sDta21, $sDta22, $sDta23, $sDta24, $sDta25, $sDta26, $sDta27, $sDta28, $sDta29, $sDta30, $sDta31, $sDta32, $sDta33, $sDta34, $sDta35, $sDta36, $sDta37, $sDta38, $sDta39, $sDta40]
	Local $aFlds[41] = [0, $sFldId1, $sFldId2, $sFldId3, $sFldId4, $sFldId5, $sFldId6, $sFldId7, $sFldId8, $sFldId9, $sFldId10, $sFldId11, $sFldId12, $sFldId13, $sFldId14, $sFldId15, $sFldId16, $sFldId17, $sFldId18, $sFldId19, $sFldId20, $sFldId21, $sFldId22, $sFldId23, $sFldId24, $sFldId25, $sFldId26, $sFldId27, $sFldId28, $sFldId29, $sFldId30, $sFldId31, $sFldId32, $sFldId33, $sFldId34, $sFldId35, $sFldId36, $sFldId37, $sFldId38, $sFldId39, $sFldId40]
	If Not Mod($iNumArgs, 2) Then
		$sAdditionalHeaders = $aFlds[$iNumArgs / 2 - 1]
		$aFlds[$iNumArgs / 2 - 1] = 0
		$iIgnoreCertErr = StringInStr($sAdditionalHeaders, "[IGNORE_CERT_ERRORS]")
		If $iIgnoreCertErr Then $sAdditionalHeaders = StringReplace($sAdditionalHeaders, "[IGNORE_CERT_ERRORS]", "", 1)
		$iRetArr = StringInStr($sAdditionalHeaders, "[RETURN_ARRAY]")
		If $iRetArr Then $sAdditionalHeaders = StringReplace($sAdditionalHeaders, "[RETURN_ARRAY]", "", 1)
		Local $aCred = StringRegExp($sAdditionalHeaders, "\[CRED:(.*?)\]", 2)
		If Not @error Then
			Local $sCredDelim = ":"
			If Not StringInStr($aCred[1], $sCredDelim) Then $sCredDelim = ","
			Local $aStrSplit = StringSplit($aCred[1], $sCredDelim, 3)
			If Not @error Then
				$sCredName = $aStrSplit[0]
				$sCredPass = $aStrSplit[1]
			EndIf
			$sAdditionalHeaders = StringReplace($sAdditionalHeaders, $aCred[0], "", 1)
		EndIf
	EndIf
	Local $hOpen, $aHTML, $sHTML, $sURL, $fVarForm, $iScheme = $INTERNET_SCHEME_HTTP
	If IsString($hInternet) Then ; $hInternet is page source
		$sHTML = $hInternet
		If _WinHttpQueryOption($sActionPage, $WINHTTP_OPTION_HANDLE_TYPE) <> $WINHTTP_HANDLE_TYPE_SESSION Then Return SetError(6, 0, "")
		$hOpen = $sActionPage
		$fVarForm = True
	Else
		$iScheme = _WinHttpQueryOption($hInternet, $WINHTTP_OPTION_CONTEXT_VALUE); read internet scheme from the connection handle
		Local $sAccpt = "Accept: text/html;q=0.9,text/plain;q=0.8,*/*;q=0.5"
		If $iScheme = $INTERNET_SCHEME_HTTPS Then
			$aHTML = _WinHttpSimpleSSLRequest($hInternet, Default, $sActionPage, Default, Default, $sAccpt, 1, Default, $sCredName, $sCredPass, $iIgnoreCertErr)
		ElseIf $iScheme = $INTERNET_SCHEME_HTTP Then
			$aHTML = _WinHttpSimpleRequest($hInternet, Default, $sActionPage, Default, Default, $sAccpt, 1, Default, $sCredName, $sCredPass)
		Else
			$aHTML = _WinHttpSimpleRequest($hInternet, Default, $sActionPage, Default, Default, $sAccpt, 1, Default, $sCredName, $sCredPass)
			If @error Or @extended >= $HTTP_STATUS_BAD_REQUEST Then
				$aHTML = _WinHttpSimpleSSLRequest($hInternet, Default, $sActionPage, Default, Default, $sAccpt, 1, Default, $sCredName, $sCredPass, $iIgnoreCertErr)
				$iScheme = $INTERNET_SCHEME_HTTPS
			Else
				$iScheme = $INTERNET_SCHEME_HTTP
			EndIf
		EndIf
		If Not @error Then ; Error is checked after If...Then...Else block. Be careful before changing anything!
			$sHTML = $aHTML[1]
			$sURL = $aHTML[2]
		EndIf
	EndIf
	$sHTML = StringRegExpReplace($sHTML, "(?s)<!--.*?-->", "") ; removing comments
	$sHTML = StringRegExpReplace($sHTML, "(?s)<!\[CDATA\[.*?\]\]>", "") ; removing CDATA
	Local $fSend = False ; preset 'Sending flag'
	Local $aForm = StringRegExp($sHTML, "(?si)<\s*form(?:[^\w])\s*(.*?)(?:(?:<\s*/form\s*>)|\Z)", 3)
	If @error Then Return SetError(1, 0, "") ; There are no forms available
	Local $fGetFormByName, $sFormName, $fGetFormByIndex, $fGetFormById, $iFormIndex
	Local $aSplitForm = StringSplit($sFormId, ":", 2)
	If @error Then ; like .getElementById(FormId)
		$fGetFormById = True
	Else
		If $aSplitForm[0] = "name" Then ; like .getElementsByName(FormName)
			$sFormName = $aSplitForm[1]
			$fGetFormByName = True
		ElseIf $aSplitForm[0] = "index" Then
			$iFormIndex = Number($aSplitForm[1])
			$fGetFormByIndex = True
		ElseIf $aSplitForm[0] = "id" Then ; like .getElementById(FormId)
			$sFormId = $aSplitForm[1]
			$fGetFormById = True
		Else ; like .getElementById(FormId)
			$sFormId = $aSplitForm[0]
			$fGetFormById = True
		EndIf
	EndIf
	Local $sForm, $sAttributes, $aInput
	Local $iNumParams = Ceiling(($iNumArgs - 2) / 2) - 1
	Local $sAddData, $sNewURL
	For $iFormOrdinal = 0 To UBound($aForm) - 1
		If $fGetFormByIndex And $iFormOrdinal <> $iFormIndex Then ContinueLoop
		$sForm = $aForm[$iFormOrdinal]
		$sAttributes = StringRegExp($sForm, "(?s)(.*?)>", 3)
		If Not @error Then $sAttributes = StringRegExpReplace($sAttributes[0], "\v", " ")
		Local $sAction = "", $sAccept = "", $sEnctype = "", $sMethod = "", $sName = "", $sId = ""
		$sId = __WinHttpAttribVal($sAttributes, "id")
		If $fGetFormById And $sFormId <> Default And $sId <> $sFormId Then ContinueLoop
		$sName = __WinHttpAttribVal($sAttributes, "name")
		If $fGetFormByName And $sFormName <> $sName Then ContinueLoop
		$sAction = __WinHttpHTMLDecode(__WinHttpAttribVal($sAttributes, "action"))
		$sAccept = __WinHttpAttribVal($sAttributes, "accept")
		$sEnctype = __WinHttpAttribVal($sAttributes, "enctype")
		$sMethod = __WinHttpAttribVal($sAttributes, "method")
		$fSend = True
		Local $sSpr1 = Chr(27), $sSpr2 = Chr(26)
		__WinHttpNormalizeForm($sForm, $sSpr1, $sSpr2)
		$aInput = StringRegExp($sForm, "(?si)<\h*(?:input|textarea|label|fieldset|legend|select|optgroup|option|button)\h*(.*?)/*\h*>", 3)
		If @error Then Return SetError(2, 0, "") ; invalid form
		__WinHttpHTML5FormAttribs($aDtas, $aFlds, $iNumParams, $aInput, $sAction, $sEnctype, $sMethod)
		__WinHttpNormalizeActionURL($sActionPage, $sAction, $iScheme, $sNewURL, $sEnctype, $sMethod, $sURL)
		If $fVarForm And Not $sNewURL Then Return SetError(5, 0, "") ; "action" must have URL specified
		Local $aSplit, $sBoundary, $sPassedId, $sPassedData, $iNumRepl, $fMultiPart = False, $sSubmit, $sRadio, $sCheckBox, $sButton
		Local $sGrSep = Chr(29), $iErr
		Local $aInputIds[4][UBound($aInput)]
		Switch $sEnctype
			Case "", "application/x-www-form-urlencoded", "text/plain"
				For $i = 0 To UBound($aInput) - 1 ; for all input elements
					__WinHttpFormAttrib($aInputIds, $i, $aInput[$i])
					If $aInputIds[1][$i] Then ; if there is 'name' field then add it
						$aInputIds[1][$i] = __WinHttpURLEncode(StringReplace($aInputIds[1][$i], $sSpr1, " "), $sEnctype)
						$aInputIds[2][$i] = __WinHttpURLEncode(StringReplace(StringReplace($aInputIds[2][$i], $sSpr2, ">"), $sSpr1, " "), $sEnctype)
						$sAddData &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & "&"
						If $aInputIds[3][$i] = "submit" Then $sSubmit &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & $sGrSep ; add to overall "submit" string
						If $aInputIds[3][$i] = "radio" Then $sRadio &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & $sGrSep ; add to overall "radio" string
						If $aInputIds[3][$i] = "checkbox" Then $sCheckBox &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & $sGrSep ; add to overall "checkbox" string
						If $aInputIds[3][$i] = "button" Then $sButton &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & $sGrSep ; add to overall "button" string
					EndIf
				Next
				$sSubmit = StringTrimRight($sSubmit, 1)
				$sRadio = StringTrimRight($sRadio, 1)
				$sCheckBox = StringTrimRight($sCheckBox, 1)
				$sButton = StringTrimRight($sButton, 1)
				$sAddData = StringTrimRight($sAddData, 1)
				For $k = 1 To $iNumParams
					$sPassedData = __WinHttpURLEncode($aDtas[$k], $sEnctype)
					$aDtas[$k] = 0
					$sPassedId = $aFlds[$k]
					$aFlds[$k] = 0
					$aSplit = StringSplit($sPassedId, ":", 2)
					$iErr = @error
					$aSplit[0] = __WinHttpURLEncode($aSplit[0], $sEnctype)
					If Not $iErr Then $aSplit[1] = __WinHttpURLEncode($aSplit[1], $sEnctype)
					If $iErr Or $aSplit[0] <> "name" Then ; like .getElementById
						If Not $iErr And $aSplit[0] = "id" Then $sPassedId = $aSplit[1]
						For $j = 0 To UBound($aInputIds, 2) - 1
							If $aInputIds[0][$j] = $sPassedId Then
								If $aInputIds[3][$j] = "submit" Then
									If $sPassedData = True Then ; if this "submit" is set to TRUE then
										If $sSubmit Then ; If not already processed; only the first is valid
											Local $fDelId = False
											For $sChunkSub In StringSplit($sSubmit, $sGrSep, 3) ; go tru all "submit" controls
												If $sChunkSub == $aInputIds[1][$j] & "=" & $aInputIds[2][$j] Then
													If $fDelId Then $sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $sChunkSub & "\E(?:&|\Z)", "&", 1)
													$fDelId = True
												Else
													$sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $sChunkSub & "\E(?:&|\Z)", "&") ; delete all but the TRUE one
												EndIf
												__WinHttpTrimBounds($sAddData, "&")
											Next
											$sSubmit = ""
										EndIf
									EndIf
								ElseIf $aInputIds[3][$j] = "radio" Then
									If $sPassedData = $aInputIds[2][$j] Then
										For $sChunkSub In StringSplit($sRadio, $sGrSep, 3) ; go tru all "radio" controls
											If $sChunkSub == $aInputIds[1][$j] & "=" & $sPassedData Then
												$sAddData = StringRegExpReplace(StringReplace($sAddData, "&", "&&"), "(?:&|\A)\Q" & $aInputIds[1][$j] & "\E(.*?)(?:&|\Z)", "&")
												$sAddData = StringReplace(StringReplace($sAddData, "&&", "&"), "&&", "&")
												If StringLeft($sAddData, 1) = "&" Then $sAddData = StringTrimLeft($sAddData, 1)
												$sAddData &= "&" & $sChunkSub
												$sRadio = StringRegExpReplace(StringReplace($sRadio, $sGrSep, $sGrSep & $sGrSep), "(?:" & $sGrSep & "|\A)\Q" & $aInputIds[1][$j] & "\E(.*?)(?:" & $sGrSep & "|\Z)", $sGrSep)
												$sRadio = StringReplace(StringReplace($sRadio, $sGrSep & $sGrSep, $sGrSep), $sGrSep & $sGrSep, $sGrSep)
											EndIf
										Next
									EndIf
								ElseIf $aInputIds[3][$j] = "checkbox" Then
									$sCheckBox = StringRegExpReplace($sCheckBox, "\Q" & $aInputIds[1][$j] & "=" & $sPassedData & "\E" & $sGrSep & "*", "")
									__WinHttpTrimBounds($sCheckBox, $sGrSep)
								ElseIf $aInputIds[3][$j] = "button" Then
									$sButton = StringRegExpReplace($sButton, "\Q" & $aInputIds[1][$j] & "=" & $sPassedData & "\E" & $sGrSep & "*", "")
									__WinHttpTrimBounds($sButton, $sGrSep)
								Else
									$sAddData = StringRegExpReplace(StringReplace($sAddData, "&", "&&"), "(?:&|\A)\Q" & $aInputIds[1][$j] & "=" & $aInputIds[2][$j] & "\E(?:&|\Z)", "&" & $aInputIds[1][$j] & "=" & $sPassedData & "&")
									$iNumRepl = @extended
									$sAddData = StringReplace($sAddData, "&&", "&")
									If $iNumRepl > 1 Then ; equalize ; TODO: remove duplicates
										$sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $aInputIds[1][$j] & "\E=.*?(?:&|\Z)", "&", $iNumRepl - 1)
									EndIf
									__WinHttpTrimBounds($sAddData, "&")
								EndIf
							EndIf
						Next
					Else ; like .getElementsByName
						For $j = 0 To UBound($aInputIds, 2) - 1
							If $aInputIds[3][$j] = "submit" Then
								If $sPassedData = True Then ; if this "submit" is set to TRUE then
									If $aInputIds[1][$j] == $aSplit[1] Then
										If $sSubmit Then ; If not already processed; only the first is valid
											Local $fDel = False
											For $sChunkSub In StringSplit($sSubmit, $sGrSep, 3) ; go tru all "submit" controls
												If $sChunkSub = $aInputIds[1][$j] & "=" & $aInputIds[2][$j] Then
													If $fDel Then $sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $sChunkSub & "\E(?:&|\Z)", "&", 1)
													$fDel = True
												Else
													$sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $sChunkSub & "\E(?:&|\Z)", "&") ; delete all but the TRUE one
												EndIf
												__WinHttpTrimBounds($sAddData, "&")
											Next
											$sSubmit = ""
										EndIf
										ContinueLoop 2 ; process next parameter
									EndIf
								Else ; False means do nothing
									ContinueLoop 2 ; process next parameter
								EndIf
							ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "radio" Then
								For $sChunkSub In StringSplit($sRadio, $sGrSep, 3) ; go tru all "radio" controls
									If $sChunkSub == $aInputIds[1][$j] & "=" & $sPassedData Then
										$sAddData = StringReplace(StringReplace(StringRegExpReplace(StringReplace($sAddData, "&", "&&"), "(?:&|\A)\Q" & $aInputIds[1][$j] & "\E(.*?)(?:&|\Z)", "&"), "&&", "&"), "&&", "&")
										If StringLeft($sAddData, 1) = "&" Then $sAddData = StringTrimLeft($sAddData, 1)
										$sAddData &= "&" & $sChunkSub
										$sRadio = StringRegExpReplace(StringReplace($sRadio, $sGrSep, $sGrSep & $sGrSep), "(?:" & $sGrSep & "|\A)\Q" & $aInputIds[1][$j] & "\E(.*?)(?:" & $sGrSep & "|\Z)", $sGrSep)
										$sRadio = StringReplace(StringReplace($sRadio, $sGrSep & $sGrSep, $sGrSep), $sGrSep & $sGrSep, $sGrSep)
									EndIf
								Next
								ContinueLoop 2 ; process next parameter
							ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "checkbox" Then
								$sCheckBox = StringRegExpReplace($sCheckBox, "\Q" & $aInputIds[1][$j] & "=" & $sPassedData & "\E" & $sGrSep & "*", "")
								__WinHttpTrimBounds($sCheckBox, $sGrSep)
								ContinueLoop 2 ; process next parameter
							ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "button" Then
								$sButton = StringRegExpReplace($sButton, "\Q" & $aInputIds[1][$j] & "=" & $sPassedData & "\E" & $sGrSep & "*", "")
								__WinHttpTrimBounds($sButton, $sGrSep)
								ContinueLoop 2 ; process next parameter
							EndIf
						Next
						$sAddData = StringRegExpReplace(StringReplace($sAddData, "&", "&&"), "(?:&|\A)\Q" & $aSplit[1] & "\E=.*?(?:&|\Z)", "&" & $aSplit[1] & "=" & $sPassedData & "&")
						$iNumRepl = @extended
						$sAddData = StringReplace($sAddData, "&&", "&")
						If $iNumRepl > 1 Then ; remove duplicates
							$sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $aSplit[1] & "\E=.*?(?:&|\Z)", "&", $iNumRepl - 1)
						EndIf
						__WinHttpTrimBounds($sAddData, "&")
					EndIf
				Next
				__WinHttpFinalizeCtrls($sSubmit, $sRadio, $sCheckBox, $sButton, $sAddData, $sGrSep, "&")
				If $sMethod = "GET" Then
					$sAction &= "?" & $sAddData
					$sAddData = "" ; not to send as addition to the request (this is GET)
				EndIf
			Case "multipart/form-data"
				If $sMethod = "POST" Then ; can't be GET
					$fMultiPart = True
					$sBoundary = StringFormat("%s%.5f", "----WinHttpBoundaryLine_", Random(10000, 99999))
					Local $sCDisp = 'Content-Disposition: form-data; name="'
					For $i = 0 To UBound($aInput) - 1 ; for all input elements
						__WinHttpFormAttrib($aInputIds, $i, $aInput[$i])
						If $aInputIds[1][$i] Then ; if there is 'name' field
							$aInputIds[1][$i] = StringReplace($aInputIds[1][$i], $sSpr1, " ")
							$aInputIds[2][$i] = StringReplace(StringReplace($aInputIds[2][$i], $sSpr2, ">"), $sSpr1, " ")
							If $aInputIds[3][$i] = "file" Then
								$sAddData &= "--" & $sBoundary & @CRLF & _
										$sCDisp & $aInputIds[1][$i] & '"; filename=""' & @CRLF & @CRLF & _
										$aInputIds[2][$i] & @CRLF
							Else
								$sAddData &= "--" & $sBoundary & @CRLF & _
										$sCDisp & $aInputIds[1][$i] & '"' & @CRLF & @CRLF & _
										$aInputIds[2][$i] & @CRLF
							EndIf
							If $aInputIds[3][$i] = "submit" Then $sSubmit &= "--" & $sBoundary & @CRLF & _
									$sCDisp & $aInputIds[1][$i] & '"' & @CRLF & @CRLF & _
									$aInputIds[2][$i] & @CRLF & $sGrSep
							If $aInputIds[3][$i] = "radio" Then $sRadio &= "--" & $sBoundary & @CRLF & _
									$sCDisp & $aInputIds[1][$i] & '"' & @CRLF & @CRLF & _
									$aInputIds[2][$i] & @CRLF & $sGrSep
							If $aInputIds[3][$i] = "checkbox" Then $sCheckBox &= "--" & $sBoundary & @CRLF & _
									$sCDisp & $aInputIds[1][$i] & '"' & @CRLF & @CRLF & _
									$aInputIds[2][$i] & @CRLF & $sGrSep
							If $aInputIds[3][$i] = "button" Then $sButton &= "--" & $sBoundary & @CRLF & _
									$sCDisp & $aInputIds[1][$i] & '"' & @CRLF & @CRLF & _
									$aInputIds[2][$i] & @CRLF & $sGrSep
						EndIf
					Next
					$sSubmit = StringTrimRight($sSubmit, 1)
					$sRadio = StringTrimRight($sRadio, 1)
					$sCheckBox = StringTrimRight($sCheckBox, 1)
					$sButton = StringTrimRight($sButton, 1)
					$sAddData &= "--" & $sBoundary & "--" & @CRLF
					For $k = 1 To $iNumParams
						$sPassedData = $aDtas[$k]
						$aDtas[$k] = 0
						$sPassedId = $aFlds[$k]
						$aFlds[$k] = 0
						$aSplit = StringSplit($sPassedId, ":", 2)
						If @error Or $aSplit[0] <> "name" Then ; like getElementById
							If Not @error And $aSplit[0] = "id" Then $sPassedId = $aSplit[1]
							For $j = 0 To UBound($aInputIds, 2) - 1
								If $aInputIds[0][$j] = $sPassedId Then
									If $aInputIds[3][$j] = "file" Then
										$sAddData = StringReplace($sAddData, _
												$sCDisp & $aInputIds[1][$j] & '"; filename=""' & @CRLF & @CRLF & $aInputIds[2][$j] & @CRLF, _
												__WinHttpFileContent($sAccept, $aInputIds[1][$j], $sPassedData, $sBoundary), 0, 1)
									ElseIf $aInputIds[3][$j] = "submit" Then
										If $sPassedData = True Then ; if this "submit" is set to TRUE then
											If $sSubmit Then ; If not already processed; only the first is valid
												Local $fMDelId = False
												For $sChunkSub In StringSplit($sSubmit, $sGrSep, 3) ; go tru all "submit" controls
													If $sChunkSub = "--" & $sBoundary & @CRLF & _
															$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
															$aInputIds[2][$j] & @CRLF Then
														If $fMDelId Then $sAddData = StringReplace($sAddData, $sChunkSub, "", 1, 1) ; Removing duplicates
														$fMDelId = True
													Else
														$sAddData = StringReplace($sAddData, $sChunkSub, "", 0, 1) ; delete all but the TRUE one
													EndIf
												Next
												$sSubmit = ""
											EndIf
										EndIf
									ElseIf $aInputIds[3][$j] = "radio" Then
										If $sPassedData = $aInputIds[2][$j] Then
											For $sChunkSub In StringSplit($sRadio, $sGrSep, 3) ; go tru all "radio" controls
												If StringInStr($sChunkSub, "--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & $sPassedData & @CRLF, 1) Then
													$sAddData = StringRegExpReplace($sAddData, "\Q--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & "\E" & "(.*?)" & @CRLF, "")
													$sAddData = StringReplace($sAddData, "--" & $sBoundary & "--" & @CRLF, "", 0, 1)
													$sAddData &= $sChunkSub & "--" & $sBoundary & "--" & @CRLF
													$sRadio = StringRegExpReplace($sRadio, "\Q--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & "\E(.*?)" & @CRLF & $sGrSep & "?", "")
												EndIf
											Next
										EndIf
									ElseIf $aInputIds[3][$j] = "checkbox" Then
										$sCheckBox = StringRegExpReplace($sCheckBox, "\Q--" & $sBoundary & @CRLF & _
												$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
												$sPassedData & @CRLF & "\E" & $sGrSep & "*", "")
										If StringRight($sCheckBox, 1) = $sGrSep Then $sCheckBox = StringTrimRight($sCheckBox, 1)
									ElseIf $aInputIds[3][$j] = "button" Then
										$sButton = StringRegExpReplace($sButton, "\Q--" & $sBoundary & @CRLF & _
												$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
												$sPassedData & @CRLF & "\E" & $sGrSep & "*", "")
										If StringRight($sButton, 1) = $sGrSep Then $sButton = StringTrimRight($sButton, 1)
									Else
										$sAddData = StringReplace($sAddData, _
												$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & $aInputIds[2][$j] & @CRLF, _
												$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & $sPassedData & @CRLF, 0, 1)
										$iNumRepl = @extended
										If $iNumRepl > 1 Then ; equalize ; TODO: remove duplicates
											$sAddData = StringRegExpReplace($sAddData, '(?s)\Q--' & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & '\E\r\n\r\n.*?\r\n', "", $iNumRepl - 1)
										EndIf
									EndIf
								EndIf
							Next
						Else ; like getElementsByName
							For $j = 0 To UBound($aInputIds, 2) - 1
								If $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "file" Then
									$sAddData = StringReplace($sAddData, _
											$sCDisp & $aSplit[1] & '"; filename=""' & @CRLF & @CRLF & $aInputIds[2][$j] & @CRLF, _
											__WinHttpFileContent($sAccept, $aInputIds[1][$j], $sPassedData, $sBoundary), 0, 1)
								ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "submit" Then
									If $sPassedData = True Then ; if this "submit" is set to TRUE then
										If $sSubmit Then ; If not already processed; only the first is valid
											Local $fMDel = False
											For $sChunkSub In StringSplit($sSubmit, $sGrSep, 3) ; go tru all "submit" controls
												If $sChunkSub = "--" & $sBoundary & @CRLF & _
														$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
														$aInputIds[2][$j] & @CRLF Then
													If $fMDel Then $sAddData = StringReplace($sAddData, $sChunkSub, "", 1, 1) ; Removing duplicates
													$fMDel = True
												Else
													$sAddData = StringReplace($sAddData, $sChunkSub, "", 0, 1) ; delete all but the TRUE one
												EndIf
											Next
											$sSubmit = ""
										EndIf
										ContinueLoop 2 ; process next parameter
									Else ; False means do nothing
										ContinueLoop 2 ; process next parameter
									EndIf
								ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "radio" Then
									For $sChunkSub In StringSplit($sRadio, $sGrSep, 3) ; go tru all "radio" controls
										If StringInStr($sChunkSub, "--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & $sPassedData & @CRLF, 1) Then
											$sAddData = StringRegExpReplace($sAddData, "\Q--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & "\E" & "(.*?)" & @CRLF, "")
											$sAddData = StringReplace($sAddData, "--" & $sBoundary & "--" & @CRLF, "", 0, 1)
											$sAddData &= $sChunkSub & "--" & $sBoundary & "--" & @CRLF
											$sRadio = StringRegExpReplace($sRadio, "\Q--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & "\E(.*?)" & @CRLF & $sGrSep & "?", "")
										EndIf
									Next
									ContinueLoop 2 ; process next parameter
								ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "checkbox" Then
									$sCheckBox = StringRegExpReplace($sCheckBox, "\Q--" & $sBoundary & @CRLF & _
											$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
											$sPassedData & @CRLF & "\E" & $sGrSep & "*", "")
									If StringRight($sCheckBox, 1) = $sGrSep Then $sCheckBox = StringTrimRight($sCheckBox, 1)
									ContinueLoop 2 ; process next parameter
								ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "button" Then
									$sButton = StringRegExpReplace($sButton, "\Q--" & $sBoundary & @CRLF & _
											$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
											$sPassedData & @CRLF & "\E" & $sGrSep & "*", "")
									If StringRight($sButton, 1) = $sGrSep Then $sButton = StringTrimRight($sButton, 1)
									ContinueLoop 2 ; process next parameter
								EndIf
							Next
							$sAddData = StringRegExpReplace($sAddData, '(?s)\Q' & $sCDisp & $aSplit[1] & '"' & '\E\r\n\r\n.*?\r\n', _
									$sCDisp & $aSplit[1] & '"' & @CRLF & @CRLF & StringReplace($sPassedData, "\", "\\") & @CRLF)
							$iNumRepl = @extended
							If $iNumRepl > 1 Then ; remove duplicates
								$sAddData = StringRegExpReplace($sAddData, '(?s)\Q--' & $sBoundary & @CRLF & $sCDisp & $aSplit[1] & '"' & '\E\r\n\r\n.*?\r\n', "", $iNumRepl - 1)
							EndIf
						EndIf
					Next
				EndIf
				__WinHttpFinalizeCtrls($sSubmit, $sRadio, $sCheckBox, $sButton, $sAddData, $sGrSep)
		EndSwitch
		ExitLoop
	Next
	If $fSend Then
		If $fVarForm Then
			$hInternet = _WinHttpConnect($hOpen, $sNewURL)
		Else
			If $sNewURL Then
				$hOpen = _WinHttpQueryOption($hInternet, $WINHTTP_OPTION_PARENT_HANDLE)
				_WinHttpCloseHandle($hInternet)
				$hInternet = _WinHttpConnect($hOpen, $sNewURL)
			EndIf
		EndIf
		Local $hRequest
		If $iScheme = $INTERNET_SCHEME_HTTPS Then
			$hRequest = __WinHttpFormSend($hInternet, $sMethod, $sAction, $fMultiPart, $sBoundary, $sAddData, True, $sAdditionalHeaders, $sCredName, $sCredPass, $iIgnoreCertErr)
		Else
			$hRequest = __WinHttpFormSend($hInternet, $sMethod, $sAction, $fMultiPart, $sBoundary, $sAddData, False, $sAdditionalHeaders, $sCredName, $sCredPass)
			If _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_STATUS_CODE) >= $HTTP_STATUS_BAD_REQUEST Then
				_WinHttpCloseHandle($hRequest)
				$hRequest = __WinHttpFormSend($hInternet, $sMethod, $sAction, $fMultiPart, $sBoundary, $sAddData, True, $sAdditionalHeaders, $sCredName, $sCredPass, $iIgnoreCertErr) ; try adding $WINHTTP_FLAG_SECURE
			EndIf
		EndIf
		Local $vReturned = _WinHttpSimpleReadData($hRequest)
		If @error Then
			_WinHttpCloseHandle($hRequest)
			Return SetError(4, 0, "") ; either site is expiriencing problems or your connection
		EndIf
		Local $iSCode = _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_STATUS_CODE)
		If $iRetArr Then
			Local $aReturn[3] = [_WinHttpQueryHeaders($hRequest), $vReturned, _WinHttpQueryOption($hRequest, $WINHTTP_OPTION_URL)]
			$vReturned = $aReturn
		EndIf
		_WinHttpCloseHandle($hRequest)
		Return SetExtended($iSCode, $vReturned)
	EndIf
	Return SetError(3, 0, "")
EndFunc
Func _WinHttpSimpleFormFill_SetUploadCallback($vCallback = Default, $iNumChunks = 100)
	If $iNumChunks <= 0 Then $iNumChunks = 100
	Local Static $vFunc = Default, $iParts = $iNumChunks
	If $vCallback <> Default Then
		$vFunc = $vCallback
		$iParts = Ceiling($iNumChunks)
	ElseIf $vCallback = 0 Then
		$vFunc = Default
		$iParts = 1
	EndIf
	Local $aOut[2] = [$vFunc, $iParts]
	Return $aOut
EndFunc
Func _WinHttpSimpleReadData($hRequest, $iMode = Default)
	If $iMode = Default Then
		$iMode = 0
		If __WinHttpCharSet(_WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_CONTENT_TYPE)) = 65001 Then $iMode = 1 ; header suggest utf-8
	Else
		__WinHttpDefault($iMode, 0)
	EndIf
	If $iMode > 2 Or $iMode < 0 Then Return SetError(1, 0, '')
	Local $vData = Binary('')
	If _WinHttpQueryDataAvailable($hRequest) Then
		Do
			$vData &= _WinHttpReadData($hRequest, 2)
		Until @error
		Switch $iMode
			Case 0
				Return BinaryToString($vData)
			Case 1
				Return BinaryToString($vData, 4)
			Case Else
				Return $vData
		EndSwitch
	EndIf
	Return SetError(2, 0, $vData)
EndFunc
Func _WinHttpSimpleReadDataAsync($hInternet, ByRef $pBuffer, $iNumberOfBytesToRead = Default)
	__WinHttpDefault($iNumberOfBytesToRead, 8192)
	Local $vOut = _WinHttpReadData($hInternet, 2, $iNumberOfBytesToRead, $pBuffer)
	Return SetError(@error, @extended, $vOut)
EndFunc
Func _WinHttpSimpleRequest($hConnect, $sType = Default, $sPath = Default, $sReferrer = Default, $sDta = Default, $sHeader = Default, $fGetHeaders = Default, $iMode = Default, $sCredName = Default, $sCredPass = Default)
	__WinHttpDefault($sType, "GET")
	__WinHttpDefault($sPath, "")
	__WinHttpDefault($sReferrer, $WINHTTP_NO_REFERER)
	__WinHttpDefault($sDta, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($sHeader, $WINHTTP_NO_ADDITIONAL_HEADERS)
	__WinHttpDefault($fGetHeaders, False)
	__WinHttpDefault($iMode, Default)
	__WinHttpDefault($sCredName, "")
	__WinHttpDefault($sCredPass, "")
	If $iMode > 2 Or $iMode < 0 Then Return SetError(4, 0, 0)
	Local $hRequest = _WinHttpSimpleSendRequest($hConnect, $sType, $sPath, $sReferrer, $sDta, $sHeader)
	If @error Then Return SetError(@error, 0, 0)
	__WinHttpSetCredentials($hRequest, $sHeader, $sDta, $sCredName, $sCredPass)
	Local $iExtended = _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_STATUS_CODE)
	If $fGetHeaders Then
		Local $aData[3] = [_WinHttpQueryHeaders($hRequest), _WinHttpSimpleReadData($hRequest, $iMode), _WinHttpQueryOption($hRequest, $WINHTTP_OPTION_URL)]
		_WinHttpCloseHandle($hRequest)
		Return SetExtended($iExtended, $aData)
	EndIf
	Local $sOutData = _WinHttpSimpleReadData($hRequest, $iMode)
	_WinHttpCloseHandle($hRequest)
	Return SetExtended($iExtended, $sOutData)
EndFunc
Func _WinHttpSimpleSendRequest($hConnect, $sType = Default, $sPath = Default, $sReferrer = Default, $sDta = Default, $sHeader = Default)
	__WinHttpDefault($sType, "GET")
	__WinHttpDefault($sPath, "")
	__WinHttpDefault($sReferrer, $WINHTTP_NO_REFERER)
	__WinHttpDefault($sDta, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($sHeader, $WINHTTP_NO_ADDITIONAL_HEADERS)
	Local $hRequest = _WinHttpOpenRequest($hConnect, $sType, $sPath, Default, $sReferrer)
	If Not $hRequest Then Return SetError(1, @error, 0)
	If $sType = "POST" And $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS Then $sHeader = "Content-Type: application/x-www-form-urlencoded" & @CRLF
	_WinHttpSetOption($hRequest, $WINHTTP_OPTION_DECOMPRESSION, $WINHTTP_DECOMPRESSION_FLAG_ALL)
	_WinHttpSetOption($hRequest, $WINHTTP_OPTION_UNSAFE_HEADER_PARSING, 1)
	_WinHttpSendRequest($hRequest, $sHeader, $sDta)
	If @error Then Return SetError(2, 0 * _WinHttpCloseHandle($hRequest), 0)
	_WinHttpReceiveResponse($hRequest)
	If @error Then Return SetError(3, 0 * _WinHttpCloseHandle($hRequest), 0)
	Return $hRequest
EndFunc
Func _WinHttpSimpleSendSSLRequest($hConnect, $sType = Default, $sPath = Default, $sReferrer = Default, $sDta = Default, $sHeader = Default, $iIgnoreAllCertErrors = 0)
	__WinHttpDefault($sType, "GET")
	__WinHttpDefault($sPath, "")
	__WinHttpDefault($sReferrer, $WINHTTP_NO_REFERER)
	__WinHttpDefault($sDta, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($sHeader, $WINHTTP_NO_ADDITIONAL_HEADERS)
	Local $hRequest = _WinHttpOpenRequest($hConnect, $sType, $sPath, Default, $sReferrer, Default, BitOR($WINHTTP_FLAG_SECURE, $WINHTTP_FLAG_ESCAPE_DISABLE))
	If Not $hRequest Then Return SetError(1, @error, 0)
	If $iIgnoreAllCertErrors Then _WinHttpSetOption($hRequest, $WINHTTP_OPTION_SECURITY_FLAGS, BitOR($SECURITY_FLAG_IGNORE_UNKNOWN_CA, $SECURITY_FLAG_IGNORE_CERT_DATE_INVALID, $SECURITY_FLAG_IGNORE_CERT_CN_INVALID, $SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE))
	If $sType = "POST" And $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS Then $sHeader = "Content-Type: application/x-www-form-urlencoded" & @CRLF
	_WinHttpSetOption($hRequest, $WINHTTP_OPTION_DECOMPRESSION, $WINHTTP_DECOMPRESSION_FLAG_ALL)
	_WinHttpSetOption($hRequest, $WINHTTP_OPTION_UNSAFE_HEADER_PARSING, 1)
	_WinHttpSendRequest($hRequest, $sHeader, $sDta)
	If @error Then Return SetError(2, 0 * _WinHttpCloseHandle($hRequest), 0)
	_WinHttpReceiveResponse($hRequest)
	If @error Then Return SetError(3, 0 * _WinHttpCloseHandle($hRequest), 0)
	Return $hRequest
EndFunc
Func _WinHttpSimpleSSLRequest($hConnect, $sType = Default, $sPath = Default, $sReferrer = Default, $sDta = Default, $sHeader = Default, $fGetHeaders = Default, $iMode = Default, $sCredName = Default, $sCredPass = Default, $iIgnoreCertErrors = 0)
	__WinHttpDefault($sType, "GET")
	__WinHttpDefault($sPath, "")
	__WinHttpDefault($sReferrer, $WINHTTP_NO_REFERER)
	__WinHttpDefault($sDta, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($sHeader, $WINHTTP_NO_ADDITIONAL_HEADERS)
	__WinHttpDefault($fGetHeaders, False)
	__WinHttpDefault($iMode, Default)
	__WinHttpDefault($sCredName, "")
	__WinHttpDefault($sCredPass, "")
	If $iMode > 2 Or $iMode < 0 Then Return SetError(4, 0, 0)
	Local $hRequest = _WinHttpSimpleSendSSLRequest($hConnect, $sType, $sPath, $sReferrer, $sDta, $sHeader, $iIgnoreCertErrors)
	If @error Then Return SetError(@error, 0, 0)
	__WinHttpSetCredentials($hRequest, $sHeader, $sDta, $sCredName, $sCredPass)
	If $fGetHeaders Then
		Local $aData[3] = [_WinHttpQueryHeaders($hRequest), _WinHttpSimpleReadData($hRequest, $iMode), _WinHttpQueryOption($hRequest, $WINHTTP_OPTION_URL)]
		_WinHttpCloseHandle($hRequest)
		Return $aData
	EndIf
	Local $sOutData = _WinHttpSimpleReadData($hRequest, $iMode)
	_WinHttpCloseHandle($hRequest)
	Return $sOutData
EndFunc
Func _WinHttpTimeFromSystemTime()
	Local $SYSTEMTIME = DllStructCreate("word Year;" & _
			"word Month;" & _
			"word DayOfWeek;" & _
			"word Day;" & _
			"word Hour;" & _
			"word Minute;" & _
			"word Second;" & _
			"word Milliseconds")
	DllCall("kernel32.dll", "none", "GetSystemTime", "struct*", $SYSTEMTIME)
	If @error Then Return SetError(1, 0, "")
	Local $tTime = DllStructCreate("wchar[62]")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpTimeFromSystemTime", "struct*", $SYSTEMTIME, "struct*", $tTime)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($tTime, 1)
EndFunc
Func _WinHttpTimeToSystemTime($sHttpTime)
	Local $SYSTEMTIME = DllStructCreate("word Year;" & _
			"word Month;" & _
			"word DayOfWeek;" & _
			"word Day;" & _
			"word Hour;" & _
			"word Minute;" & _
			"word Second;" & _
			"word Milliseconds")
	Local $tTime = DllStructCreate("wchar[62]")
	DllStructSetData($tTime, 1, $sHttpTime)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpTimeToSystemTime", "struct*", $tTime, "struct*", $SYSTEMTIME)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, 0)
	Local $aRet[8] = [DllStructGetData($SYSTEMTIME, "Year"), _
			DllStructGetData($SYSTEMTIME, "Month"), _
			DllStructGetData($SYSTEMTIME, "DayOfWeek"), _
			DllStructGetData($SYSTEMTIME, "Day"), _
			DllStructGetData($SYSTEMTIME, "Hour"), _
			DllStructGetData($SYSTEMTIME, "Minute"), _
			DllStructGetData($SYSTEMTIME, "Second"), _
			DllStructGetData($SYSTEMTIME, "Milliseconds")]
	Return $aRet
EndFunc
Func _WinHttpWriteData($hRequest, $vData, $iMode = Default)
	__WinHttpDefault($iMode, 0)
	Local $iNumberOfBytesToWrite, $tData
	If $iMode = 1 Then
		$iNumberOfBytesToWrite = BinaryLen($vData)
		$tData = DllStructCreate("byte[" & $iNumberOfBytesToWrite & "]")
		DllStructSetData($tData, 1, $vData)
	ElseIf IsDllStruct($vData) Then
		$iNumberOfBytesToWrite = DllStructGetSize($vData)
		$tData = $vData
	Else
		$iNumberOfBytesToWrite = StringLen($vData)
		$tData = DllStructCreate("char[" & $iNumberOfBytesToWrite + 1 & "]")
		DllStructSetData($tData, 1, $vData)
	EndIf
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpWriteData", _
			"handle", $hRequest, _
			"struct*", $tData, _
			"dword", $iNumberOfBytesToWrite, _
			"dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return SetExtended($aCall[4], 1)
EndFunc
Func __WinHttpFileContent($sAccept, $sName, $sFileString, $sBoundaryMain = "")
	#forceref $sAccept ; FIXME: $sAccept is specified by the server (or left default). In case $sFileString is non-supported MIME type action should be aborted.
	Local $fNonStandard = False
	If StringLeft($sFileString, 10) = "PHP#50338:" Then
		$sFileString = StringTrimLeft($sFileString, 10)
		$fNonStandard = True
	EndIf
	Local $sOut = 'Content-Disposition: form-data; name="' & $sName & '"'
	If Not $sFileString Then Return $sOut & '; filename=""' & @CRLF & @CRLF & @CRLF
	If StringRight($sFileString, 1) = "|" Then $sFileString = StringTrimRight($sFileString, 1)
	Local $aFiles = StringSplit($sFileString, "|", 2), $hFile
	If UBound($aFiles) = 1 Then
		$hFile = FileOpen($aFiles[0], 16)
		$sOut &= '; filename="' & StringRegExpReplace($aFiles[0], ".*\\", "") & '"' & @CRLF & _
				"Content-Type: " & __WinHttpMIMEType($aFiles[0]) & @CRLF & @CRLF & BinaryToString(FileRead($hFile), 1) & @CRLF
		FileClose($hFile)
		Return $sOut ; That's it
	EndIf
	If $fNonStandard Then
		$sOut = "" ; discharge
		Local $iFiles = UBound($aFiles)
		For $i = 0 To $iFiles - 1
			$hFile = FileOpen($aFiles[$i], 16)
			$sOut &= 'Content-Disposition: form-data; name="' & $sName & '"' & _
					'; filename="' & StringRegExpReplace($aFiles[$i], ".*\\", "") & '"' & @CRLF & _
					"Content-Type: " & __WinHttpMIMEType($aFiles[$i]) & @CRLF & @CRLF & BinaryToString(FileRead($hFile), 1) & @CRLF
			FileClose($hFile)
			If $i < $iFiles - 1 Then $sOut &= "--" & $sBoundaryMain & @CRLF
		Next
	Else
		Local $sBoundary = StringFormat("%s%.5f", "----WinHttpSubBoundaryLine_", Random(10000, 99999))
		$sOut &= @CRLF & "Content-Type: multipart/mixed; boundary=" & $sBoundary & @CRLF & @CRLF
		For $i = 0 To UBound($aFiles) - 1
			$hFile = FileOpen($aFiles[$i], 16)
			$sOut &= "--" & $sBoundary & @CRLF & _
					'Content-Disposition: file; filename="' & StringRegExpReplace($aFiles[$i], ".*\\", "") & '"' & @CRLF & _
					"Content-Type: " & __WinHttpMIMEType($aFiles[$i]) & @CRLF & @CRLF & BinaryToString(FileRead($hFile), 1) & @CRLF
			FileClose($hFile)
		Next
		$sOut &= "--" & $sBoundary & "--" & @CRLF
	EndIf
	Return $sOut
EndFunc
Func __WinHttpMIMEType($sFileName)
	Local $aArray = StringRegExp(__WinHttpMIMEAssocString(), "(?i)\Q;" & StringRegExpReplace($sFileName, ".*\.", "") & "\E\|(.*?);", 3)
	If @error Then Return "application/octet-stream"
	Return $aArray[0]
EndFunc
Func __WinHttpMIMEAssocString()
	Return ";ai|application/postscript;aif|audio/x-aiff;aifc|audio/x-aiff;aiff|audio/x-aiff;asc|text/plain;atom|application/atom+xml;au|audio/basic;avi|video/x-msvideo;bcpio|application/x-bcpio;bin|application/octet-stream;bmp|image/bmp;cdf|application/x-netcdf;cgm|image/cgm;class|application/octet-stream;cpio|application/x-cpio;cpt|application/mac-compactpro;csh|application/x-csh;css|text/css;dcr|application/x-director;dif|video/x-dv;dir|application/x-director;djv|image/vnd.djvu;djvu|image/vnd.djvu;dll|application/octet-stream;dmg|application/octet-stream;dms|application/octet-stream;doc|application/msword;dtd|application/xml-dtd;dv|video/x-dv;dvi|application/x-dvi;dxr|application/x-director;eps|application/postscript;etx|text/x-setext;exe|application/octet-stream;ez|application/andrew-inset;gif|image/gif;gram|application/srgs;grxml|application/srgs+xml;gtar|application/x-gtar;hdf|application/x-hdf;hqx|application/mac-binhex40;htm|text/html;html|text/html;ice|x-conference/x-cooltalk;ico|image/x-icon;ics|text/calendar;ief|image/ief;ifb|text/calendar;iges|model/iges;igs|model/iges;jnlp|application/x-java-jnlp-file;jp2|image/jp2;jpe|image/jpeg;jpeg|image/jpeg;jpg|image/jpeg;js|application/x-javascript;kar|audio/midi;latex|application/x-latex;lha|application/octet-stream;lzh|application/octet-stream;m3u|audio/x-mpegurl;m4a|audio/mp4a-latm;m4b|audio/mp4a-latm;m4p|audio/mp4a-latm;m4u|video/vnd.mpegurl;m4v|video/x-m4v;mac|image/x-macpaint;man|application/x-troff-man;mathml|application/mathml+xml;me|application/x-troff-me;mesh|model/mesh;mid|audio/midi;midi|audio/midi;mif|application/vnd.mif;mov|video/quicktime;movie|video/x-sgi-movie;mp2|audio/mpeg;mp3|audio/mpeg;mp4|video/mp4;mpe|video/mpeg;mpeg|video/mpeg;mpg|video/mpeg;mpga|audio/mpeg;ms|application/x-troff-ms;msh|model/mesh;mxu|video/vnd.mpegurl;nc|application/x-netcdf;oda|application/oda;ogg|application/ogg;pbm|image/x-portable-bitmap;pct|image/pict;pdb|chemical/x-pdb;pdf|application/pdf;pgm|image/x-portable-graymap;pgn|application/x-chess-pgn;pic|image/pict;pict|image/pict;png|image/png;pnm|image/x-portable-anymap;pnt|image/x-macpaint;pntg|image/x-macpaint;ppm|image/x-portable-pixmap;ppt|application/vnd.ms-powerpoint;ps|application/postscript;qt|video/quicktime;qti|image/x-quicktime;qtif|image/x-quicktime;ra|audio/x-pn-realaudio;ram|audio/x-pn-realaudio;ras|image/x-cmu-raster;rdf|application/rdf+xml;rgb|image/x-rgb;rm|application/vnd.rn-realmedia;roff|application/x-troff;rtf|text/rtf;rtx|text/richtext;sgm|text/sgml;sgml|text/sgml;sh|application/x-sh;shar|application/x-shar;silo|model/mesh;sit|application/x-stuffit;skd|application/x-koan;skm|application/x-koan;skp|application/x-koan;skt|application/x-koan;smi|application/smil;smil|application/smil;snd|audio/basic;so|application/octet-stream;spl|application/x-futuresplash;src|application/x-wais-source;sv4cpio|application/x-sv4cpio;sv4crc|application/x-sv4crc;svg|image/svg+xml;swf|application/x-shockwave-flash;t|application/x-troff;tar|application/x-tar;tcl|application/x-tcl;tex|application/x-tex;texi|application/x-texinfo;texinfo|application/x-texinfo;tif|image/tiff;tiff|image/tiff;tr|application/x-troff;tsv|text/tab-separated-values;txt|text/plain;ustar|application/x-ustar;vcd|application/x-cdlink;vrml|model/vrml;vxml|application/voicexml+xml;wav|audio/x-wav;wbmp|image/vnd.wap.wbmp;wbmxl|application/vnd.wap.wbxml;wml|text/vnd.wap.wml;wmlc|application/vnd.wap.wmlc;wmls|text/vnd.wap.wmlscript;wmlsc|application/vnd.wap.wmlscriptc;wrl|model/vrml;xbm|image/x-xbitmap;xht|application/xhtml+xml;xhtml|application/xhtml+xml;xls|application/vnd.ms-excel;xml|application/xml;xpm|image/x-xpixmap;xsl|application/xml;xslt|application/xslt+xml;xul|application/vnd.mozilla.xul+xml;xwd|image/x-xwindowdump;xyz|chemical/x-xyz;zip|application/zip;"
EndFunc
Func __WinHttpCharSet($sContentType)
	Local $aContentType = StringRegExp($sContentType, "(?i).*?\Qcharset=\E(?U)([^ ]+)(;| |\Z)", 2)
	If Not @error Then $sContentType = $aContentType[1]
	If StringLeft($sContentType, 2) = "cp" Then Return Int(StringTrimLeft($sContentType, 2))
	If $sContentType = "utf-8" Then Return 65001
EndFunc
Func __WinHttpURLEncode($vData, $sEncType = "")
	If IsBool($vData) Then Return $vData
	$vData = __WinHttpHTMLDecode($vData)
	If $sEnctype = "text/plain" Then Return StringReplace($vData, " ", "+")
	Local $aData = StringToASCIIArray($vData, Default, Default, 2)
	Local $sOut
	For $i = 0 To UBound($aData) - 1
		Switch $aData[$i]
			Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
				$sOut &= Chr($aData[$i])
			Case 32
				$sOut &= "+"
			Case Else
				$sOut &= "%" & Hex($aData[$i], 2)
		EndSwitch
	Next
	Return $sOut
EndFunc
Func __WinHttpHTMLDecode($vData)
	Return StringReplace(StringReplace(StringReplace(StringReplace($vData, "&amp;", "&"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"')
EndFunc
Func __WinHttpNormalizeActionURL($sActionPage, ByRef $sAction, ByRef $iScheme, ByRef $sNewURL, ByRef $sEnctype, ByRef $sMethod, $sURL = "")
	Local $aCrackURL = _WinHttpCrackUrl($sAction)
	If @error Then
		If $sAction Then
			If StringLeft($sAction, 2) = "//" Then
				$aCrackURL = _WinHttpCrackUrl($sURL)
				If Not @error Then
					$aCrackURL = _WinHttpCrackUrl($aCrackURL[0] & ":" & $sAction)
					If Not @error Then
						$sNewURL = $aCrackURL[0] & "://" & $aCrackURL[2] & ":" & $aCrackURL[3]
						$iScheme = $aCrackURL[1]
						$sAction = $aCrackURL[6] & $aCrackURL[7]
						$sActionPage = ""
					EndIf
				EndIf
			ElseIf StringLeft($sAction, 1) = "?" Then
				$aCrackURL = _WinHttpCrackUrl($sURL)
				$sAction = $aCrackURL[6] & $sAction
			ElseIf StringLeft($sAction, 1) = "#" Then
				$sAction = StringReplace($sActionPage, StringRegExpReplace($sActionPage, "(.*?)(#.*?)", "$2"), $sAction)
			ElseIf StringLeft($sAction, 1) <> "/" Then
					Local $sCurrent
					Local $aURL = StringRegExp($sActionPage, '(.*)/', 3)
					If Not @error Then $sCurrent = $aURL[0]
					If $sCurrent Then $sAction = $sCurrent & "/" & $sAction
			EndIf
			If StringLeft($sAction, 1) = "?" Then $sAction = $sActionPage & $sAction
		EndIf
		If Not $sAction Then $sAction = $sActionPage
		$sAction = StringRegExpReplace($sAction, "\A(/*\.\./)*", "") ; /../
	Else
		$iScheme = $aCrackURL[1]
		$sNewURL = $aCrackURL[0] & "://" & $aCrackURL[2] & ":" & $aCrackURL[3]
		$sAction = $aCrackURL[6] & $aCrackURL[7]
	EndIf
	If Not $sMethod Then $sMethod = "GET"
	If $sMethod = "GET" Then $sEnctype = ""
EndFunc
Func __WinHttpHTML5FormAttribs(ByRef $aDtas, ByRef $aFlds, ByRef $iNumParams, ByRef $aInput, ByRef $sAction, ByRef $sEnctype, ByRef $sMethod)
	Local $aSpl, $iSubmitHTML5 = 0, $iInpSubm, $sImgAppx = "."
	For $k = 1 To $iNumParams
		$aSpl = StringSplit($aFlds[$k], ":", 2)
		If $aSpl[0] = "type" And ($aSpl[1] = "submit" Or $aSpl[1] = "image") Then
			Local $iSubmIndex = $aDtas[$k], $iSubmCur = 0, $iImgCur = 0, $sType, $sInpNme
			If $aSpl[1] = "image" Then
				$iSubmIndex = Int($aDtas[$k])
			EndIf
			For $i = 0 To UBound($aInput) - 1 ; for all input elements
				Switch __WinHttpAttribVal($aInput[$i], "type")
					Case "submit"
						If $iSubmCur = $iSubmIndex Then
							$iSubmitHTML5 = 1
							$iInpSubm = $i
							ExitLoop 2
						EndIf
						$iSubmCur += 1
					Case "image"
						If $iImgCur = $iSubmIndex Then
							$iSubmitHTML5 = 1
							$iInpSubm = $i
							$sInpNme = __WinHttpAttribVal($aInput[$iInpSubm], "name")
							If $sInpNme Then $sInpNme &= $sImgAppx
							$aInput[$iInpSubm] = 'type="image" formaction="' & __WinHttpAttribVal($aInput[$iInpSubm], "formaction") & '" formenctype="' & __WinHttpAttribVal($aInput[$iInpSubm], "formenctype") & '" formmethod="' & __WinHttpAttribVal($aInput[$iInpSubm], "formmethod") & '"'
							Local $iX = 0, $iY = 0
							$iX = Int(StringRegExpReplace($aDtas[$k], "(\d+)\h*(\d+),(\d+)", "$2", 1))
							$iY = Int(StringRegExpReplace($aDtas[$k], "(\d+)\h*(\d+),(\d+)", "$3", 1))
							ReDim $aInput[UBound($aInput) + 2]
							$aInput[UBound($aInput) - 2] = 'type="image" name="' & $sInpNme & 'x" value="' & $iX & '"'
							$aInput[UBound($aInput) - 1] = 'type="image" name="' & $sInpNme & 'y" value="' & $iY & '"'
							ExitLoop 2
						EndIf
						$iImgCur += 1
				EndSwitch
			Next
			ElseIf $aSpl[0] = "name" Then
			Local $sInpNme = $aSpl[1], $sType
			For $i = 0 To UBound($aInput) - 1 ; for all input elements
				$sType = __WinHttpAttribVal($aInput[$i], "type")
				If $sType = "submit" Then
					If __WinHttpAttribVal($aInput[$i], "name") = $sInpNme And $aDtas[$k] = True Then
						$iSubmitHTML5 = 1
						$iInpSubm = $i
						ExitLoop 2
					EndIf
				ElseIf $sType = "image" Then
					If __WinHttpAttribVal($aInput[$i], "name") = $sInpNme And $aDtas[$k] Then
						$iSubmitHTML5 = 1
						$iInpSubm = $i
						Local $aStrSplit = StringSplit($aDtas[$k], ",", 3), $iX = 0, $iY = 0
						If Not @error Then
							$iX = Int($aStrSplit[0])
							$iY = Int($aStrSplit[1])
						EndIf
						$aInput[$iInpSubm] = 'type="image" formaction="' & __WinHttpAttribVal($aInput[$iInpSubm], "formaction") & '" formenctype="' & __WinHttpAttribVal($aInput[$iInpSubm], "formenctype") & '" formmethod="' & __WinHttpAttribVal($aInput[$iInpSubm], "formmethod") & '"'
						$sInpNme &= $sImgAppx
						ReDim $aInput[UBound($aInput) + 2]
						$aInput[UBound($aInput) - 2] = 'type="image" name="' & $sInpNme & 'x" value="' & $iX & '"'
						$aInput[UBound($aInput) - 1] = 'type="image" name="' & $sInpNme & 'y" value="' & $iY & '"'
						ExitLoop 2
					EndIf
				EndIf
			Next
		Else ; id
			Local $sInpId, $sType
			If @error Then
				$sInpId = $aSpl[0]
			ElseIf $aSpl[0] = "id" Then
				$sInpId = $aSpl[1]
			EndIf
			For $i = 0 To UBound($aInput) - 1 ; for all input elements
				$sType = __WinHttpAttribVal($aInput[$i], "type")
				If $sType = "submit" Then
					If __WinHttpAttribVal($aInput[$i], "id") = $sInpId And $aDtas[$k] = True Then
						$iSubmitHTML5 = 1
						$iInpSubm = $i
						ExitLoop 2
					EndIf
				ElseIf $sType = "image" Then
					If __WinHttpAttribVal($aInput[$i], "id") = $sInpId And $aDtas[$k] Then
						$iSubmitHTML5 = 1
						$iInpSubm = $i
						Local $sInpNme = __WinHttpAttribVal($aInput[$iInpSubm], "name")
						If $sInpNme Then $sInpNme &= $sImgAppx
						Local $aStrSplit = StringSplit($aDtas[$k], ",", 3), $iX = 0, $iY = 0
						If Not @error Then
							$iX = Int($aStrSplit[0])
							$iY = Int($aStrSplit[1])
						EndIf
						$aInput[$iInpSubm] = 'type="image" formaction="' & __WinHttpAttribVal($aInput[$iInpSubm], "formaction") & '" formenctype="' & __WinHttpAttribVal($aInput[$iInpSubm], "formenctype") & '" formmethod="' & __WinHttpAttribVal($aInput[$iInpSubm], "formmethod") & '"'
						ReDim $aInput[UBound($aInput) + 2]
						$aInput[UBound($aInput) - 2] = 'type="image" name="' & $sInpNme & 'x" value="' & $iX & '"'
						$aInput[UBound($aInput) - 1] = 'type="image" name="' & $sInpNme & 'y" value="' & $iY & '"'
						ExitLoop 2
					EndIf
				EndIf
			Next
		EndIf
	Next
	If $iSubmitHTML5 Then
		Local $iUbound = UBound($aInput) - 1
		If __WinHttpAttribVal($aInput[$iInpSubm], "type") = "image" Then $iUbound -= 2 ; two form fields are added for "image"
		For $j = 0 To $iUbound ; for all other input elements
			If $j = $iInpSubm Then ContinueLoop
			Switch __WinHttpAttribVal($aInput[$j], "type")
				Case "submit", "image"
					$aInput[$j] = "" ; remove any other submit/image controls
			EndSwitch
		Next
		Local $sAttr = __WinHttpAttribVal($aInput[$iInpSubm], "formaction")
		If $sAttr Then $sAction = $sAttr
		$sAttr = __WinHttpAttribVal($aInput[$iInpSubm], "formenctype")
		If $sAttr Then $sEnctype = $sAttr
		$sAttr = __WinHttpAttribVal($aInput[$iInpSubm], "formmethod")
		If $sAttr Then $sMethod = $sAttr
		If __WinHttpAttribVal($aInput[$iInpSubm], "type") = "image" Then $aInput[$iInpSubm] = ""
	EndIf
EndFunc
Func __WinHttpNormalizeForm(ByRef $sForm, $sSpr1, $sSpr2)
	Local $aData = StringToASCIIArray($sForm, Default, Default, 2)
	Local $sOut, $bQuot = False, $bSQuot = False, $bOpTg = True
	For $i = 0 To UBound($aData) - 1
		Switch $aData[$i]
			Case 34
				If $bOpTg Then $bQuot = Not $bQuot
				$sOut &= Chr($aData[$i])
			Case 39
				If $bOpTg Then $bSQuot = Not $bSQuot
				$sOut &= Chr($aData[$i])
			Case 32 ; space
				If $bQuot Or $bSQuot Then
					$sOut &= $sSpr1
				Else
					$sOut &= Chr($aData[$i])
				EndIf
			Case 60 ; <
				If Not $bOpTg Then $bOpTg = True
				$sOut &= Chr($aData[$i])
			Case 62 ; >
				If $bQuot Or $bSQuot Then
					$sOut &= $sSpr2
				Else
					If $bOpTg Then $bOpTg = False
					$sOut &= Chr($aData[$i])
				EndIf
			Case Else
				$sOut &= Chr($aData[$i])
		EndSwitch
	Next
	$sForm = $sOut
EndFunc
Func __WinHttpFinalizeCtrls($sSubmit, $sRadio, $sCheckBox, $sButton, ByRef $sAddData, $sGrSep, $sBound = "")
	If $sSubmit Then ; If no submit is specified
		Local $aSubmit = StringSplit($sSubmit, $sGrSep, 3)
		For $m = 1 To UBound($aSubmit) - 1
			$sAddData = StringRegExpReplace($sAddData, "(?:\Q" & $sBound & "\E|\A)\Q" & $aSubmit[$m] & "\E(?:\Q" & $sBound & "\E|\z)", $sBound)
		Next
		__WinHttpTrimBounds($sAddData, $sBound)
	EndIf
	If $sRadio Then ; If no radio is specified
		If $sRadio <> $sGrSep Then
			For $sElem In StringSplit($sRadio, $sGrSep, 3)
				$sAddData = StringRegExpReplace($sAddData, "(?:\Q" & $sBound & "\E|\A)\Q" & $sElem & "\E(?:\Q" & $sBound & "\E|\z)", $sBound)
			Next
			__WinHttpTrimBounds($sAddData, $sBound)
		EndIf
	EndIf
	If $sCheckBox Then ; If no checkbox is specified
		For $sElem In StringSplit($sCheckBox, $sGrSep, 3)
			$sAddData = StringRegExpReplace($sAddData, "(?:\Q" & $sBound & "\E|\A)\Q" & $sElem & "\E(?:\Q" & $sBound & "\E|\z)", $sBound)
		Next
		__WinHttpTrimBounds($sAddData, $sBound)
	EndIf
	If $sButton Then ; If no button is specified
		For $sElem In StringSplit($sButton, $sGrSep, 3)
			$sAddData = StringRegExpReplace($sAddData, "(?:\Q" & $sBound & "\E|\A)\Q" & $sElem & "\E(?:\Q" & $sBound & "\E|\z)", $sBound)
		Next
		__WinHttpTrimBounds($sAddData, $sBound)
	EndIf
EndFunc
Func __WinHttpTrimBounds(ByRef $sDta, $sBound)
	Local $iBLen = StringLen($sBound)
	If StringRight($sDta, $iBLen) = $sBound Then $sDta = StringTrimRight($sDta, $iBLen)
	If StringLeft($sDta, $iBLen) = $sBound Then $sDta = StringTrimLeft($sDta, $iBLen)
EndFunc
Func __WinHttpFormAttrib(ByRef $aAttrib, $i, $sElement)
	$aAttrib[0][$i] = __WinHttpAttribVal($sElement, "id")
	$aAttrib[1][$i] = __WinHttpAttribVal($sElement, "name")
	$aAttrib[2][$i] = __WinHttpAttribVal($sElement, "value")
	$aAttrib[3][$i] = __WinHttpAttribVal($sElement, "type")
EndFunc
Func __WinHttpAttribVal($sIn, $sAttrib)
	Local $aArray = StringRegExp($sIn, '(?i).*?(\A| )\b' & $sAttrib & '\h*=(\h*"(.*?)"|' & "\h*'(.*?)'|" & '\h*(.*?)(?: |\Z))', 1) ; e.g. id="abc" or id='abc' or id=abc
	If @error Then Return ""
	Return $aArray[UBound($aArray) - 1]
EndFunc
Func __WinHttpFormSend($hInternet, $sMethod, $sAction, $fMultiPart, $sBoundary, $sAddData, $fSecure = False, $sAdditionalHeaders = "", $sCredName = "", $sCredPass = "", $iIgnoreAllCertErrors = 0)
	Local $hRequest
	If $fSecure Then
		$hRequest = _WinHttpOpenRequest($hInternet, $sMethod, $sAction, Default, Default, Default, $WINHTTP_FLAG_SECURE)
		If $iIgnoreAllCertErrors Then _WinHttpSetOption($hRequest, $WINHTTP_OPTION_SECURITY_FLAGS, BitOR($SECURITY_FLAG_IGNORE_UNKNOWN_CA, $SECURITY_FLAG_IGNORE_CERT_DATE_INVALID, $SECURITY_FLAG_IGNORE_CERT_CN_INVALID, $SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE))
	Else
		$hRequest = _WinHttpOpenRequest($hInternet, $sMethod, $sAction)
	EndIf
	If $fMultiPart Then
		_WinHttpAddRequestHeaders($hRequest, "Content-Type: multipart/form-data; boundary=" & $sBoundary)
	Else
		If $sMethod = "POST" Then _WinHttpAddRequestHeaders($hRequest, "Content-Type: application/x-www-form-urlencoded")
	EndIf
	_WinHttpAddRequestHeaders($hRequest, "Accept: application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,*/*;q=0.5")
	_WinHttpAddRequestHeaders($hRequest, "Accept-Charset: utf-8;q=0.7")
	If $sAdditionalHeaders Then _WinHttpAddRequestHeaders($hRequest, $sAdditionalHeaders, BitOR($WINHTTP_ADDREQ_FLAG_REPLACE, $WINHTTP_ADDREQ_FLAG_ADD))
	_WinHttpSetOption($hRequest, $WINHTTP_OPTION_DECOMPRESSION, $WINHTTP_DECOMPRESSION_FLAG_ALL)
	_WinHttpSetOption($hRequest, $WINHTTP_OPTION_UNSAFE_HEADER_PARSING, 1)
	__WinHttpFormUpload($hRequest, "", $sAddData)
	_WinHttpReceiveResponse($hRequest)
	__WinHttpSetCredentials($hRequest, "", $sAddData, $sCredName, $sCredPass, 1)
	Return $hRequest
EndFunc
Func __WinHttpSetCredentials($hRequest, $sHeaders = "", $sOptional = "", $sCredName = "", $sCredPass = "", $iFormFill = 0)
	If $sCredName And $sCredPass Then
		Local $iStatusCode = _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_STATUS_CODE)
		If $iStatusCode = $HTTP_STATUS_DENIED Or $iStatusCode = $HTTP_STATUS_PROXY_AUTH_REQ Then
			Local $iSupportedSchemes, $iFirstScheme, $iAuthTarget
			If _WinHttpQueryAuthSchemes($hRequest, $iSupportedSchemes, $iFirstScheme, $iAuthTarget) Then
				If $iFirstScheme = $WINHTTP_AUTH_SCHEME_PASSPORT And $iStatusCode = $HTTP_STATUS_PROXY_AUTH_REQ Then
					_WinHttpSetOption($hRequest, $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_ENABLE_PASSPORT_AUTH)
					_WinHttpSetOption($hRequest, $WINHTTP_OPTION_PROXY_USERNAME, $sCredName)
					_WinHttpSetOption($hRequest, $WINHTTP_OPTION_PROXY_PASSWORD, $sCredPass)
				Else
					_WinHttpSetCredentials($hRequest, $iAuthTarget, $iFirstScheme, $sCredName, $sCredPass)
				EndIf
				If $iFormFill Then
					__WinHttpFormUpload($hRequest, $sHeaders, $sOptional)
				Else
					_WinHttpSendRequest($hRequest, $sHeaders, $sOptional)
				EndIf
				_WinHttpReceiveResponse($hRequest)
			EndIf
		EndIf
	EndIf
EndFunc
Func __WinHttpFormUpload($hRequest, $sHeaders, $sData)
	Local $aClbk = _WinHttpSimpleFormFill_SetUploadCallback()
	If $aClbk[0] <> Default Then
		Local $iSize = StringLen($sData), $iChunk = Floor($iSize / $aClbk[1]), $iRest = $iSize - ($aClbk[1] - 1) * $iChunk, $iCurCh = $iChunk
		_WinHttpSendRequest($hRequest, Default, Default, $iSize)
		For $i = 1 To $aClbk[1]
			If $i = $aClbk[1] Then $iCurCh = $iRest
			_WinHttpWriteData($hRequest, StringMid($sData, 1 + $iChunk * ($i -1), $iCurCh))
			Call($aClbk[0], Floor($i * 100 / $aClbk[1]))
		Next
	Else
		_WinHttpSendRequest($hRequest, Default, $sData)
	EndIf
EndFunc
Func __WinHttpDefault(ByRef $vInput, $vOutput)
	If $vInput = Default Or Number($vInput) = -1 Then $vInput = $vOutput
EndFunc
Func __WinHttpMemGlobalFree($pMem)
	Local $aCall = DllCall("kernel32.dll", "ptr", "GlobalFree", "ptr", $pMem)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc
Func __WinHttpPtrStringLenW($pStr)
	Local $aCall = DllCall("kernel32.dll", "dword", "lstrlenW", "ptr", $pStr)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc
Func __WinHttpUA()
	Local Static $sUA = "Mozilla/5.0 " & __WinHttpSysInfo() & " WinHttp/" & __WinHttpVer() & " (WinHTTP/5.1) like Gecko"
	Return $sUA
EndFunc
Func __WinHttpSysInfo()
	Local $sDta = FileGetVersion("kernel32.dll")
	$sDta = "(Windows NT " & StringLeft($sDta, StringInStr($sDta, ".", 1, 2) - 1)
	If StringInStr(@OSArch, "64") And Not @AutoItX64 Then $sDta &= "; WOW64"
	$sDta &= ")"
	Return $sDta
EndFunc
Func __WinHttpVer()
	Return "1.6.4.1"
EndFunc
Func _WinHttpBinaryConcat(ByRef $bBinary1, ByRef $bBinary2)
	Local $bOut = _WinHttpSimpleBinaryConcat($bBinary1, $bBinary2)
	Return SetError(@error, 0, $bOut)
EndFunc
;#include <array.au3>; REMOVED INCLUDE
;#include "JSON.au3" ; https://www.autoitscript.com/forum/topic/148114-a-non-strict-json-udf-jsmn; REMOVED INCLUDE
;#include "WinHttp.au3" ; https://www.autoitscript.com/forum/topic/84133-winhttp-functions/; REMOVED INCLUDE
#Region Description
#cs
	V0.1.0.18
	- Changed: Add optional parameters to _WD_NewTab for URL and Features
	- Added: _WD_jQuerify
	- Added: _WD_ElementOptionSelect
	V0.1.0.17
	- Changed: Add 'Screenshot' option to _WD_ElementAction
	- Changed: Extract JSON value when taking screenshot in _WD_Window
	- Changed: Rework coding of _WD_ElementAction
	- Fixed: Error handling in __WD_Get
	- Fixed: _WD_NewTab failed in some situations
    - Fixed: _WD_Window error handling
	- Added: _WD_Screenshot
	V0.1.0.16
	- Changed: Add async support to _WD_ExecuteScript
	- Changed: Add debug info to _WD_GetMouseElement
	- Fixed: Set element value in _WD_ElementAction
	- Fixed: Prevent premature exit in _WD_WaitElement
	- Fixed: ChromeDriver now uses goog:chromeOptions
	V0.1.0.15
	- Fixed: __WD_Post now suppports Unicode text
	- Changed: Add support for Unicode text to _WD_ElementAction's "value" option
	- Changed: Add support for BinaryFormat option to _WD_Option
	- Added: _WD_LoadWait
	V0.1.0.14
	- Fixed: Improve error handling in _WD_NewTab
	- Fixed: Screenshot option in _WD_Window
	- Fixed: Close handles in __WD_Get, __WD_Post, __WD_Delete
	V0.1.0.13
	- Fixed: Remove unsupported locator constants
	- Fixed: Return value of _WD_WaitElement
	- Changed: Add support for 'displayed' option in _WD_ElementAction (BigDaddyO)
	- Changed: Add $lVisible parameter to _WD_WaitElement
	- Changed: $_WD_DEBUG now defaults to $_WD_DEBUG_Info
	V0.1.0.12
	- Changed: Modified _WD_NewTab with timeout parameter
	- Fixed: Correctly set @error in _WD_ExecuteScript
	- Added: _WD_HighlightElement (Danyfirex)
	- Added: _WD_HighlightElements (Danyfirex)
	V0.1.0.11
	- Changed: Modified _WD_FindElement to use new global constant
	- Fixed: _WD_GetMouseElement JSON processing
	- Fixed: _WD_GetElementFromPoint JSON processing
	- Added: _WD_GetFrameCount (Decibel)
	- Added: _WD_IsWindowTop   (Decibel)
	- Added: _WD_FrameEnter    (Decibel)
	- Added: _WD_FrameLeave    (Decibel)
	V0.1.0.10
	- Changed: Add support for non-standard error codes in _WD_Alert
	- Changed: Detect non-present alert in _WD_Alert
	- Changed: __WD_Error coding
	- Fixed: Correctly set function error codes
	- Added: _WD_LastHTTPResult
	V0.1.0.9
	- Changed: Force command parameter to lowercase in _WD_Action
	- Changed: Enhanced error checking in _WD_FindElement
	- Added: _WD_GetMouseElement
	- Added: _WD_GetElementFromPoint
	V0.1.0.8
	- Changed: Improve error handling in _WD_Attach
	- Fixed: Missing "window" in URL for _WD_Window
	- Fixed: Header entry for _WD_Option
	- Added: Reference to Edge driver
	- Fixed: _WD_Window implementation of Maximize, Minimize, Fullscreen, & Screenshot
	- Removed: Normal option from _WD_Window
	- Added: Rect option to _WD_Window
	V0.1.0.7
	- Changed: Add $sOption parameter to _WD_Action
	- Changed: Implemented "Actions" command in _WD_Action
	- Changed: Improved error handling in _WD_FindElement
	- Added: _WD_WaitElement
	V0.1.0.6
	- Fixed: Missing variable declarations
	- Changed: _WD_Attach error handling
	V0.1.0.5
	- Changed: Switched to using _WinHttp functions
	- Added: _WD_LinkClickByText
	V0.1.0.4
	- Changed: Renamed core UDF functions
	- Changed: _WD_FindElement now returns multiple elements as an array instead of raw JSON
	V0.1.0.3
	- Fixed: Error constants
	- Changed: Renamed UDF files
	- Changed: Expanded _WDAlert functionality
	- Changed: Check for timeout in __WD_Post
	- Changed: Support parameters in _WDExecuteScript
	- Added: _WD_Attach function
	V0.1.0.2
	- Fixed: _WDWindow
	- Changed: Error constants (mLipok)
	- Added: Links to W3C documentation
	- Added: _WD_NewTab function
	V0.1.0.1
	- Initial release
#ce
#EndRegion Description
#Region Copyright
#cs
	* WD_Core.au3
	*
	* MIT License
	*
	* Copyright (c) 2018 Dan Pollak
	*
	* Permission is hereby granted, free of charge, to any person obtaining a copy
	* of this software and associated documentation files (the "Software"), to deal
	* in the Software without restriction, including without limitation the rights
	* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	* copies of the Software, and to permit persons to whom the Software is
	* furnished to do so, subject to the following conditions:
	*
	* The above copyright notice and this permission notice shall be included in all
	* copies or substantial portions of the Software.
	*
	* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	* SOFTWARE.
#ce
#EndRegion Copyright
#Region Many thanks to:
#cs
	- Jonathan Bennett and the AutoIt Team
	- Thorsten Willert, author of FF.au3, which I've used as a model
	- Michał Lipok for all his feedback / suggestions
#ce
#EndRegion Many thanks to:
#Region Global Constants
Global Const $__WDVERSION = "0.1.0.18"
Global Const $_WD_ELEMENT_ID = "element-6066-11e4-a52e-4f735466cecf"
Global Const $_WD_LOCATOR_ByCSSSelector = "css selector"
Global Const $_WD_LOCATOR_ByXPath = "xpath"
Global Const $_WD_LOCATOR_ByLinkText = "link text"
Global Const $_WD_LOCATOR_ByPartialLinkText = "partial link text"
Global Const $_WD_LOCATOR_ByTagName = "tag name"
Global Const $_WD_DefaultTimeout = 10000 ; 10 seconds
Global Enum _
		$_WD_DEBUG_None = 0, _ ; No logging to console
		$_WD_DEBUG_Error,    _ ; Error logging to console
		$_WD_DEBUG_Info        ; Full logging to console
Global Enum _
		$_WD_ERROR_Success = 0, _ ; No error
		$_WD_ERROR_GeneralError, _ ; General error
		$_WD_ERROR_SocketError, _ ; No socket
		$_WD_ERROR_InvalidDataType, _ ; Invalid data type (IP, URL, Port ...)
		$_WD_ERROR_InvalidValue, _ ; Invalid value in function-call
		$_WD_ERROR_SendRecv, _ ; Send / Recv Error
		$_WD_ERROR_Timeout, _ ; Connection / Send / Recv timeout
		$_WD_ERROR_NoMatch, _ ; No match for _WDAction-find/search _WDGetElement...
		$_WD_ERROR_RetValue, _ ; Error echo from Repl e.g. _WDAction("fullscreen","true") <> "true"
		$_WD_ERROR_Exception, _ ; Exception from web driver
		$_WD_ERROR_InvalidExpression, _ ; Invalid expression in XPath query or RegEx
		$_WD_ERROR_NoAlert, _ ; No alert present when calling _WD_Alert
		$_WD_ERROR_COUNTER ;
Global Const $aWD_ERROR_DESC[$_WD_ERROR_COUNTER] = [ _
		"Success", _
		"General Error", _
		"Socket Error", _
		"Invalid data type", _
		"Invalid value", _
		"Send / Recv error", _
		"Timeout", _
		"No match", _
		"Error return value", _
		"Webdriver Exception", _
		"Invalid Expression", _
		"No alert present" _
		]
Global Const $WD_Element_NotFound = "no such element"
Global Const $WD_Element_Stale = "stale element reference"
#EndRegion Global Constants
#Region Global Variables
Global $_WD_DRIVER = "" ; Path to web driver executable
Global $_WD_DRIVER_PARAMS = "" ; Parameters to pass to web driver executable
Global $_WD_BASE_URL = "HTTP://127.0.0.1"
Global $_WD_PORT = 0 ; Port used for web driver communication
Global $_WD_OHTTP = ObjCreate("winhttp.winhttprequest.5.1")
Global $_WD_HTTPRESULT ; Result of last WinHTTP request
Global $_WD_BFORMAT = $SB_UTF8 ; Binary format
Global $_WD_ERROR_MSGBOX = True ; Shows in compiled scripts error messages in msgboxes
Global $_WD_DEBUG = $_WD_DEBUG_Info ; Trace to console and show web driver app
#EndRegion Global Variables
Func _WD_CreateSession($sDesiredCapabilities = '{}')
	Local Const $sFuncName = "_WD_CreateSession"
	Local $sSession = ""
	Local $sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session", $sDesiredCapabilities)
	Local $iErr = @error
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr = $_WD_ERROR_Success Then
		Local $sJSON = Json_Decode($sResponse)
		$sSession = Json_Get($sJSON, "[value][sessionId]")
		If @error Then
			Local $sMessage = Json_Get($sJSON, "[value][message]")
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, $sMessage), $_WD_HTTPRESULT, "")
		EndIf
	Else
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, "HTTP status = " & $_WD_HTTPRESULT), $_WD_HTTPRESULT, "")
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sSession)
EndFunc   ;==>_WD_CreateSession
Func _WD_DeleteSession($sSession)
	Local Const $sFuncName = "_WD_DeleteSession"
	Local $sResponse = __WD_Delete($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession)
	Local $iErr = @error
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, "HTTP status = " & $_WD_HTTPRESULT), $_WD_HTTPRESULT, 0)
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, 1)
EndFunc   ;==>_WD_DeleteSession
Func _WD_Status()
	Local Const $sFuncName = "_WD_Status"
	Local $sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/status")
	Local $iErr = @error
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, "HTTP status = " & $_WD_HTTPRESULT), $_WD_HTTPRESULT, 0)
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResponse)
EndFunc   ;==>_WD_Status
Func _WD_Timeouts($sSession, $sTimeouts = '')
	Local Const $sFuncName = "_WD_Timeouts"
	Local $sResponse, $sURL
	$sURL = $_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/timeouts"
	If $sTimeouts = '' Then
		$sResponse = __WD_Get($sURL)
	Else
		$sResponse = __WD_Post($sURL, $sTimeouts)
	EndIf
	Local $iErr = @error
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, "HTTP status = " & $_WD_HTTPRESULT), $_WD_HTTPRESULT, 0)
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResponse)
EndFunc   ;==>_WD_Timeouts
Func _WD_Navigate($sSession, $sURL)
	Local Const $sFuncName = "_WD_Navigate"
	Local $sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/url", '{"url":"' & $sURL & '"}')
	Local $iErr = @error
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, "HTTP status = " & $_WD_HTTPRESULT), $_WD_HTTPRESULT, 0)
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, 1)
EndFunc   ;==>_WD_Navigate
Func _WD_Action($sSession, $sCommand, $sOption = '')
	Local Const $sFuncName = "_WD_Action"
	Local $sResponse, $sResult = "", $iErr, $sJSON, $sURL
	$sCommand = StringLower($sCommand)
	$sURL = $_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/" & $sCommand
	Switch $sCommand
		Case 'back', 'forward', 'refresh'
			$sResponse = __WD_Post($sURL, '{}')
			$iErr = @error
		Case 'url', 'title'
			$sResponse = __WD_Get($sURL)
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				$sJSON = Json_Decode($sResponse)
				$sResult = Json_Get($sJSON, "[value]")
			EndIf
		Case 'actions'
			If $sOption <> '' Then
				$sResponse = __WD_Post($sURL, $sOption)
			Else
				$sResponse = __WD_Delete($sURL)
			EndIf
			$iErr = @error
		Case Else
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(Back|Forward|Refresh|Url|Title|Actions) $sCommand=>" & $sCommand), "")
	EndSwitch
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, "HTTP status = " & $_WD_HTTPRESULT), $_WD_HTTPRESULT, "")
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResult)
EndFunc   ;==>_WD_Action
Func _WD_Window($sSession, $sCommand, $sOption = '')
	Local Const $sFuncName = "_WD_Window"
	Local $sResponse, $sJSON, $sResult = "", $iErr
	$sCommand = StringLower($sCommand)
	Switch $sCommand
		Case 'window'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/" & $sCommand)
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sJSON = Json_Decode($sResponse)
					$sResult = Json_Get($sJSON, "[value]")
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case 'handles'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/window/" & $sCommand)
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sJSON = Json_Decode($sResponse)
					$sResult = Json_Get($sJSON, "[value]")
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case 'maximize', 'minimize', 'fullscreen'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/window/" & $sCommand, $sOption)
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sResult = $sResponse
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case 'rect'
			If $sOption = '' Then
				$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/window/" & $sCommand)
			Else
				$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/window/" & $sCommand, $sOption)
			EndIf
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sResult = $sResponse
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case 'screenshot'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/" & $sCommand)
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sJSON = Json_Decode($sResponse)
					$sResult = Json_Get($sJSON, "[value]")
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case 'close'
			$sResponse = __WD_Delete($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/window")
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sResult = $sResponse
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case 'switch'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/window", $sOption)
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sResult = $sResponse
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case 'frame'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/frame", $sOption)
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sResult = $sResponse
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case 'parent'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/frame/parent", $sOption)
			If $iErr = $_WD_ERROR_Success Then
				If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
					$sResult = $sResponse
				Else
					$iErr = $_WD_ERROR_Exception
				EndIf
			EndIf
		Case Else
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(Window|Handles|Maximize|Minimize|Fullscreen|Rect|Screenshot|Close|Switch|Frame|Parent) $sCommand=>" & $sCommand), 0, "")
	EndSwitch
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & StringLeft($sResponse, 100) & "..." & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, "HTTP status = " & $_WD_HTTPRESULT), $_WD_HTTPRESULT, 0)
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResult)
EndFunc   ;==>_WD_Window
Func _WD_FindElement($sSession, $sStrategy, $sSelector, $sStartElement = "", $lMultiple = False)
	Local Const $sFuncName = "_WD_FindElement"
	Local $sCmd, $sElement, $sResponse, $sResult, $iErr, $sErr
	Local $oJson, $oValues, $sKey, $iRow, $aElements[0]
	$sCmd = ($lMultiple) ? 'elements' : 'element'
	$sElement = ($sStartElement == "") ? "" : "/element/" & $sStartElement
	$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & $sElement & "/" & $sCmd, '{"using":"' & $sStrategy & '","value":"' & $sSelector & '"}')
	$iErr = @error
	If $iErr = $_WD_ERROR_Success Then
		If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
			If $lMultiple Then
				$oJson = Json_Decode($sResponse)
				$oValues = Json_Get($oJson, '[value]')
				If UBound($oValues) > 0 Then
					$sKey = "[" & $_WD_ELEMENT_ID & "]"
					Dim $aElements[UBound($oValues)]
					For $oValue In $oValues
						$aElements[$iRow] = Json_Get($oValue, $sKey)
						$iRow += 1
					Next
				Else
					$iErr = $_WD_ERROR_NoMatch
				EndIf
			Else
				$oJson = Json_Decode($sResponse)
				$sResult = Json_Get($oJson, "[value][" & $_WD_ELEMENT_ID & "]")
			EndIf
		ElseIf $_WD_HTTPRESULT = $HTTP_STATUS_NOT_FOUND Then
			$oJson = Json_Decode($sResponse)
			$sErr = Json_Get($oJson, "[value][error]")
			$iErr = ($sErr == $WD_Element_NotFound) ? $_WD_ERROR_NoMatch : $_WD_ERROR_Exception
		Else
			$iErr = $_WD_ERROR_Exception
		EndIf
	EndIf
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $iErr, "HTTP status = " & $_WD_HTTPRESULT), $_WD_HTTPRESULT, "")
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, ($lMultiple) ? $aElements : $sResult)
EndFunc   ;==>_WD_FindElement
Func _WD_ElementAction($sSession, $sElement, $sCommand, $sOption = '')
	Local Const $sFuncName = "_WD_ElementAction"
	Local $sResponse, $sResult = '', $iErr, $oJson, $sErr
	$sCommand = StringLower($sCommand)
	Switch $sCommand
		Case 'name', 'rect', 'text', 'selected', 'enabled', 'displayed', 'screenshot'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/element/" & $sElement & "/" & $sCommand)
			$iErr = @error
		Case 'active'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/element/" & $sCommand)
			$iErr = @error
		Case 'attribute', 'property', 'css'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/element/" & $sElement & "/" & $sCommand & "/" & $sOption)
			$iErr = @error
		Case 'clear', 'click'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/element/" & $sElement & "/" & $sCommand, '{"id":"' & $sElement & '"}')
			$iErr = @error
		Case 'value'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/element/" & $sElement & "/" & $sCommand, '{"id":"' & $sElement & '", "text":"' & $sOption & '"}')
			$iErr = @error
		Case Else
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(Name|Rect|Text|Selected|Enabled|Displayed|Active|Attribute|Property|CSS|Clear|Click|Value|Screenshot) $sCommand=>" & $sCommand), 0, "")
	EndSwitch
	If $iErr = $_WD_ERROR_Success Then
		If $_WD_HTTPRESULT = $HTTP_STATUS_OK Then
			Switch $sCommand
				Case 'clear', 'click', 'value'
					$sResult = $sResponse
				Case Else
					$oJson = Json_Decode($sResponse)
					$sResult = Json_Get($oJson, "[value]")
			EndSwitch
		ElseIf $_WD_HTTPRESULT = $HTTP_STATUS_NOT_FOUND Then
			$oJson = Json_Decode($sResponse)
			$sErr = Json_Get($oJson, "[value][error]")
			$iErr = ($sErr == $WD_Element_Stale) ? $_WD_ERROR_NoMatch : $_WD_ERROR_Exception
		Else
			$iErr = $_WD_ERROR_Exception
		EndIf
	EndIf
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & StringLeft($sResponse,100) & "..." & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $iErr, $sResponse), $_WD_HTTPRESULT, "")
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResult)
EndFunc   ;==>_WD_ElementAction
Func _WD_ExecuteScript($sSession, $sScript, $sArguments = "[]", $lAsync = False)
	Local Const $sFuncName = "_WD_ExecuteScript"
	Local $sResponse, $sData, $sCmd
	$sData = '{"script":"' & $sScript & '", "args":[' & $sArguments & ']}'
	$sCmd = ($lAsync) ? 'async' : 'sync'
	$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/execute/" & $sCmd, $sData)
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	Return SetError(($_WD_HTTPRESULT <> $HTTP_STATUS_OK) ? $_WD_ERROR_GeneralError : $_WD_ERROR_Success, $_WD_HTTPRESULT, $sResponse)
EndFunc   ;==>_WD_ExecuteScript
Func _WD_Alert($sSession, $sCommand, $sOption = '')
	Local Const $sFuncName = "_WD_Alert"
	Local $sResponse, $iErr, $sJSON, $sResult = ''
	Local $aNoAlertResults[2] = [$HTTP_STATUS_NOT_FOUND, $HTTP_STATUS_BAD_REQUEST]
	$sCommand = StringLower($sCommand)
	Switch $sCommand
		Case 'dismiss', 'accept'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/alert/" & $sCommand, '{}')
			$iErr = @error
			If $iErr = $_WD_ERROR_Success And _ArraySearch($aNoAlertResults, $_WD_HTTPRESULT) >= 0 Then
				$iErr = $_WD_ERROR_NoAlert
			EndIf
		Case 'gettext'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/alert/text")
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				If _ArraySearch($aNoAlertResults, $_WD_HTTPRESULT) >= 0 Then
					$sResult = ""
					$iErr = $_WD_ERROR_NoAlert
				Else
					$sJSON = Json_Decode($sResponse)
					$sResult = Json_Get($sJSON, "[value]")
				EndIf
			EndIf
		Case 'sendtext'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/alert/text", '{"text":"' & $sOption & '"}')
			$iErr = @error
			If $iErr = $_WD_ERROR_Success And _ArraySearch($aNoAlertResults, $_WD_HTTPRESULT) >= 0 Then
				$iErr = $_WD_ERROR_NoAlert
			EndIf
		Case 'status'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/alert/text")
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				$sResult = (_ArraySearch($aNoAlertResults, $_WD_HTTPRESULT) >= 0) ? False : True
			EndIf
		Case Else
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(Dismiss|Accept|GetText|SendText|Status) $sCommand=>" & $sCommand), 0, "")
	EndSwitch
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, $sResponse), $_WD_HTTPRESULT, "")
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResult)
EndFunc   ;==>_WD_Alert
Func _WD_GetSource($sSession)
	Local Const $sFuncName = "_WD_GetSource"
	Local $sResponse, $iErr, $sResult = "", $sJSON
	$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/source")
	$iErr = @error
	If $iErr = $_WD_ERROR_Success Then
		$sJSON = Json_Decode($sResponse)
		$sResult = Json_Get($sJSON, "[value]")
	EndIf
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, $sResponse), $_WD_HTTPRESULT, "")
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResult)
	EndFunc   ;==>_WD_GetSource
Func _WD_Cookies($sSession, $sCommand, $sOption = '')
	Local Const $sFuncName = "_WD_Cookies"
	Local $sResult, $sResponse, $iErr
	$sCommand = StringLower($sCommand)
	Switch $sCommand
		Case 'getall'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/cookie")
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				$sResult = $sResponse
			EndIf
		Case 'get'
			$sResponse = __WD_Get($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/cookie/" & $sOption)
			$iErr = @error
			If $iErr = $_WD_ERROR_Success Then
				$sResult = $sResponse
			EndIf
		Case 'add'
			$sResponse = __WD_Post($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/cookie", $sOption)
			$iErr = @error
		Case 'delete'
			$sResponse = __WD_Delete($_WD_BASE_URL & ":" & $_WD_PORT & "/session/" & $sSession & "/cookie/" & $sOption)
			$iErr = @error
		Case Else
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(GetAll|Get|Add|Delete) $sCommand=>" & $sCommand), "")
	EndSwitch
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sResponse & @CRLF)
	EndIf
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, $sResponse), $_WD_HTTPRESULT, "")
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResult)
EndFunc   ;==>_WD_Cookies
Func _WD_Option($sOption, $vValue = "")
	Local Const $sFuncName = "_WD_Option"
	Switch $sOption
		Case "Driver"
			If $vValue == "" Then Return $_WD_DRIVER
			If Not IsString($vValue) Then
				Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(string) $vValue: " & $vValue), 0, 0)
			EndIf
			$_WD_DRIVER = $vValue
		Case "DriverParams"
			If $vValue == "" Then Return $_WD_DRIVER_PARAMS
			If Not IsString($vValue) Then
				Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(string) $vValue: " & $vValue), 0, 0)
			EndIf
			$_WD_DRIVER_PARAMS = $vValue
		Case "BaseURL"
			If $vValue == "" Then Return $_WD_BASE_URL
			If Not IsString($vValue) Then
				Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(string) $vValue: " & $vValue), 0, 0)
			EndIf
			$_WD_BASE_URL = $vValue
		Case "Port"
			If $vValue == "" Then Return $_WD_PORT
			If Not IsInt($vValue) Then
				Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(int) $vValue: " & $vValue), 0, 0)
			EndIf
			$_WD_PORT = $vValue
		Case "BinaryFormat"
			If $vValue == "" Then Return $_WD_BFORMAT
			If Not IsInt($vValue) Then
				Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(int) $vValue: " & $vValue), 0, 0)
			EndIf
			$_WD_BFORMAT = $vValue
		Case Else
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(Driver|DriverParams|BaseURL|Port|BinaryFormat) $sOption=>" & $sOption), 0, 0)
	EndSwitch
	Return 1
EndFunc   ;==>_WD_Option
Func _WD_Startup()
	Local Const $sFuncName = "_WD_Startup"
	If $_WD_DRIVER = "" Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidValue, "Location for Web Driver not set." & @CRLF), 0, 0)
	EndIf
	__WD_CloseDriver()
	Local $sCommand = StringFormat('"%s" %s ', $_WD_DRIVER, $_WD_DRIVER_PARAMS)
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite("_WDStartup: OS:" & @TAB & @OSVersion & " " & @OSType & " " & @OSBuild & " " & @OSServicePack & @CRLF)
		ConsoleWrite("_WDStartup: AutoIt:" & @TAB & @AutoItVersion & @CRLF)
		ConsoleWrite("_WDStartup: WD.au3:" & @TAB & $__WDVERSION & @CRLF)
		ConsoleWrite("_WDStartup: Driver:" & @TAB & $_WD_DRIVER & @CRLF)
		ConsoleWrite("_WDStartup: Params:" & @TAB & $_WD_DRIVER_PARAMS & @CRLF)
		ConsoleWrite("_WDStartup: Port:" & @TAB & $_WD_PORT & @CRLF)
	Else
		ConsoleWrite('_WDStartup: ' & $sCommand & @CRLF)
	EndIf
	Local $pid = Run($sCommand, "", ($_WD_DEBUG = $_WD_DEBUG_Info) ? @SW_SHOW : @SW_HIDE)
	If @error Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_GeneralError, "Error launching web driver!"), 0, 0)
	EndIf
	Return SetError($_WD_ERROR_Success, 0, $pid)
EndFunc   ;==>_WD_Startup
Func _WD_Shutdown()
	__WD_CloseDriver()
EndFunc   ;==>_WD_Shutdown
Func __WD_Get($sURL)
	Local Const $sFuncName = "__WD_Get"
	Local $iResult = $_WD_ERROR_Success, $sResponseText, $iErr
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': URL=' & $sURL & @CRLF)
	EndIf
	$_WD_HTTPRESULT = 0
	Local $aURL = _WinHttpCrackUrl($sURL)
	Local $hOpen = _WinHttpOpen()
	Local $hConnect = _WinHttpConnect($hOpen, $aURL[2], $aURL[3])
	If @error Then
		$iResult = $_WD_ERROR_SocketError
	Else
		$sResponseText = _WinHttpSimpleRequest($hConnect, "GET", $aURL[6])
		$iErr = @error
		$_WD_HTTPRESULT = @extended
		If $iErr Then
			$iResult = $_WD_ERROR_SendRecv
		EndIf
	EndIf
	_WinHttpCloseHandle($hConnect)
	_WinHttpCloseHandle($hOpen)
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': StatusCode=' & $_WD_HTTPRESULT & "; $iResult = " & $iResult & "; $sResponseText=" & StringLeft($sResponseText,100) & "..." & @CRLF)
	EndIf
	If $iResult Then
		If $_WD_HTTPRESULT = $HTTP_STATUS_REQUEST_TIMEOUT Then
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Timeout, $sResponseText), $_WD_HTTPRESULT, $sResponseText)
		Else
			Return SetError(__WD_Error($sFuncName, $iResult, $sResponseText), $_WD_HTTPRESULT, $sResponseText)
		EndIf
	EndIf
	Return SetError($_WD_ERROR_Success, 0, $sResponseText)
EndFunc   ;==>__WD_Get
Func __WD_Post($sURL, $sData)
	Local Const $sFuncName = "__WD_Post"
	Local $iResult, $sResponseText, $iErr
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': URL=' & $sURL & "; $sData=" & $sData & @CRLF)
	EndIf
	Local $aURL = _WinHttpCrackUrl($sURL)
	$_WD_HTTPRESULT = 0
	Local $hOpen = _WinHttpOpen()
	Local $hConnect = _WinHttpConnect($hOpen, $aURL[2], $_WD_PORT)
	If @error Then
		$iResult = $_WD_ERROR_SocketError
	Else
		$sResponseText = _WinHttpSimpleRequest($hConnect, "POST", $aURL[6], Default, StringToBinary($sData, $_WD_BFORMAT))
		$iErr = @error
		$_WD_HTTPRESULT = @extended
		If $iErr Then
			$iResult = $_WD_ERROR_SendRecv
		EndIf
	EndIf
	_WinHttpCloseHandle($hConnect)
	_WinHttpCloseHandle($hOpen)
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': StatusCode=' & $_WD_HTTPRESULT & "; ResponseText=" & $sResponseText & @CRLF)
	EndIf
	If $iResult Then
		If $_WD_HTTPRESULT = $HTTP_STATUS_REQUEST_TIMEOUT Then
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Timeout, $sResponseText), $_WD_HTTPRESULT, $sResponseText)
		Else
			Return SetError(__WD_Error($sFuncName, $iResult, $sResponseText), $_WD_HTTPRESULT, $sResponseText)
		EndIf
	EndIf
	Return SetError($_WD_ERROR_Success, $_WD_HTTPRESULT, $sResponseText)
EndFunc   ;==>__WD_Post
Func __WD_Delete($sURL)
	Local Const $sFuncName = "__WD_Delete"
	Local $iResult, $sResponseText
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': URL=' & $sURL & @CRLF)
	EndIf
	Local $aURL = _WinHttpCrackUrl($sURL)
	$_WD_HTTPRESULT = 0
	Local $hOpen = _WinHttpOpen()
	Local $hConnect = _WinHttpConnect($hOpen, $aURL[2], $_WD_PORT)
	If @error Then
		$iResult = $_WD_ERROR_SocketError
	Else
		$sResponseText = _WinHttpSimpleRequest($hConnect, "DELETE", $aURL[6])
		$_WD_HTTPRESULT = @extended
		If @error Then
			$iResult = $_WD_ERROR_SendRecv
		EndIf
	EndIf
	_WinHttpCloseHandle($hConnect)
	_WinHttpCloseHandle($hOpen)
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': StatusCode=' & $_WD_HTTPRESULT & "; ResponseText=" & $sResponseText & @CRLF)
	EndIf
	If $iResult Then
		If $_WD_HTTPRESULT = $HTTP_STATUS_REQUEST_TIMEOUT Then
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Timeout, $sResponseText), $_WD_HTTPRESULT, $sResponseText)
		Else
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception, $sResponseText), $_WD_HTTPRESULT, $sResponseText)
		EndIf
	EndIf
	Return SetError($_WD_ERROR_Success, 0, $sResponseText)
EndFunc   ;==>__WD_Delete
Func __WD_Error($sWhere, $i_WD_ERROR, $sMessage = "")
	Local $sMsg
	Switch $_WD_DEBUG
		Case $_WD_DEBUG_None
		Case $_WD_DEBUG_Error
			If $i_WD_ERROR <> $_WD_ERROR_Success Then ContinueCase
		Case $_WD_DEBUG_Info
			$sMsg = $sWhere & " ==> " & $aWD_ERROR_DESC[$i_WD_ERROR]
			If $sMessage <> "" Then
				$sMsg = $sMsg & ": " & $sMessage
			EndIf
			ConsoleWrite($sMsg & @CRLF)
			If @Compiled Then
				If $_WD_ERROR_MSGBOX And $i_WD_ERROR < 6 Then MsgBox(16, "WD_Core.au3 Error:", $sMsg)
				DllCall("kernel32.dll", "none", "OutputDebugString", "str", $sMsg)
			EndIf
	EndSwitch
	Return $i_WD_ERROR
EndFunc ;==>__WD_Error
Func __WD_CloseDriver()
	Local $sFile = StringRegExpReplace($_WD_DRIVER, "^.*\\(.*)$", "$1")
	If ProcessExists($sFile) Then
		ProcessClose($sFile)
	EndIf
EndFunc   ;==>__WD_CloseDriver
;#include "wd_core.au3"; REMOVED INCLUDE
#Region Copyright
#cs
	* WD_Helper.au3
	*
	* MIT License
	*
	* Copyright (c) 2018 Dan Pollak
	*
	* Permission is hereby granted, free of charge, to any person obtaining a copy
	* of this software and associated documentation files (the "Software"), to deal
	* in the Software without restriction, including without limitation the rights
	* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	* copies of the Software, and to permit persons to whom the Software is
	* furnished to do so, subject to the following conditions:
	*
	* The above copyright notice and this permission notice shall be included in all
	* copies or substantial portions of the Software.
	*
	* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	* SOFTWARE.
#ce
#EndRegion Copyright
#Region Many thanks to:
#cs
	- Jonathan Bennett and the AutoIt Team
	- Thorsten Willert, author of FF.au3, which I've used as a model
	- Michał Lipok for all his feedback / suggestions
#ce
#EndRegion Many thanks to:
Func _WD_NewTab($sSession, $lSwitch = True, $iTimeout = -1, $sURL = "", $sFeatures = "")
	Local Const $sFuncName = "_WD_NewTab"
	Local $sTabHandle = '', $sLastTabHandle, $hWaitTimer, $iTabIndex, $aTemp
	If $iTimeout = -1 Then $iTimeout = $_WD_DefaultTimeout
	Local $aHandles = _WD_Window($sSession, 'handles')
	If @error <> $_WD_ERROR_Success Or Not IsArray($aHandles) Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception), 0, $sTabHandle)
	EndIf
	$iTabCount = UBound($aHandles)
	$sLastTabHandle = $aHandles[$iTabCount - 1]
	Local $sCurrentTabHandle = _WD_Window($sSession, 'window')
	If @error = $_WD_ERROR_Success Then
		$iTabIndex = _ArraySearch($aHandles, $sCurrentTabHandle)
		If @error Then
			$sCurrentTabHandle = $sLastTabHandle
			$iTabIndex = $iTabCount - 1
		EndIf
	Else
		_WD_Window($sSession, 'Switch', '{"handle":"' & $sLastTabHandle & '"}')
		$sCurrentTabHandle = $sLastTabHandle
		$iTabIndex = $iTabCount - 1
	EndIf
	_WD_ExecuteScript($sSession, "window.open(arguments[0], '', arguments[1])", '"' & $sURL & '","' & $sFeatures & '"')
	If @error <> $_WD_ERROR_Success Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception), 0, $sTabHandle)
	EndIf
	$hWaitTimer = TimerInit()
	While 1
 		$aTemp = _WD_Window($sSession, 'handles')
		If UBound($aTemp) > $iTabCount Then
			$sTabHandle = $aTemp[$iTabIndex + 1]
			ExitLoop
		EndIf
		If TimerDiff($hWaitTimer) > $iTimeout Then Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Timeout), 0, $sTabHandle)
		Sleep(10)
	WEnd
	If $lSwitch Then
		_WD_Window($sSession, 'Switch', '{"handle":"' & $sTabHandle & '"}')
	Else
		_WD_Window($sSession, 'Switch', '{"handle":"' & $sCurrentTabHandle & '"}')
	EndIf
	Return SetError($_WD_ERROR_Success, 0, $sTabHandle)
EndFunc
Func _WD_Attach($sSession, $sString, $sMode = 'title')
	Local Const $sFuncName = "_WD_Attach"
	Local $sTabHandle = '', $lFound = False, $sCurrentTab, $aHandles
	$sCurrentTab = _WD_Window($sSession, 'window')
	If @error <> $_WD_ERROR_Success Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_GeneralError), 0, $sTabHandle)
	Else
		$aHandles = _WD_Window($sSession, 'handles')
		If @error = $_WD_ERROR_Success Then
			$sMode = StringLower($sMode)
			For $sHandle In $aHandles
				_WD_Window($sSession, 'Switch', '{"handle":"' & $sHandle & '"}')
				Switch $sMode
					Case "title", "url"
						If StringInStr(_WD_Action($sSession, $sMode), $sString) > 0 Then
							$lFound = True
							$sTabHandle = $sHandle
							ExitLoop
						EndIf
					Case 'html'
						If StringInStr(_WD_GetSource($sSession), $sString) > 0 Then
							$lFound = True
							$sTabHandle = $sHandle
							ExitLoop
						EndIf
					Case Else
						Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(Title|URL|HTML) $sOption=>" & $sMode), 0, $sTabHandle)
				EndSwitch
			Next
			If Not $lFound Then
				_WD_Window($sSession, 'Switch', '{"handle":"' & $sCurrentTab & '"}')
				Return SetError(__WD_Error($sFuncName, $_WD_ERROR_NoMatch), 0, $sTabHandle)
			EndIf
		Else
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_GeneralError), 0, $sTabHandle)
		EndIf
	EndIf
	Return SetError($_WD_ERROR_Success, 0, $sTabHandle)
EndFunc
Func _WD_LinkClickByText($sSession, $sText, $lPartial = True)
	Local Const $sFuncName = "_WD_LinkClickByText"
	Local $sElement = _WD_FindElement($sSession, ($lPartial) ? $_WD_LOCATOR_ByPartialLinkText : $_WD_LOCATOR_ByLinkText, $sText)
	Local $iErr = @error
	If $iErr = $_WD_ERROR_Success Then
		_WD_ElementAction($sSession, $sElement, 'click')
		$iErr = @error
		If $iErr <> $_WD_ERROR_Success Then
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception), $_WD_HTTPRESULT)
		EndIf
	Else
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_NoMatch), $_WD_HTTPRESULT)
	EndIf
	Return SetError($_WD_ERROR_Success)
EndFunc
Func _WD_WaitElement($sSession, $sStrategy, $sSelector, $iDelay = 0, $iTimeout = -1, $lVisible = False)
	Local Const $sFuncName = "_WD_WaitElement"
	Local $bAbort = False, $iErr, $iResult = 0, $sElement, $lIsVisible = True
	If $iTimeout = -1 Then $iTimeout = $_WD_DefaultTimeout
	Sleep($iDelay)
	Local $hWaitTimer = TimerInit()
	While 1
		$sElement = _WD_FindElement($sSession, $sStrategy, $sSelector)
		$iErr = @error
		If $iErr = $_WD_ERROR_Success Then
			If $lVisible Then
				$lIsVisible = _WD_ElementAction($sSession, $sElement, 'displayed')
			EndIf
			If $lIsVisible = True Then
				$iResult = 1
				ExitLoop
			EndIf
		EndIf
		If (TimerDiff($hWaitTimer) > $iTimeout) Then
			$iErr = $_WD_ERROR_Timeout
			ExitLoop
		EndIf
		Sleep(1000)
	WEnd
	Return SetError(__WD_Error($sFuncName, $iErr), 0, $iResult)
EndFunc
Func _WD_GetMouseElement($sSession)
	Local Const $sFuncName = "_WD_GetMouseElement"
	Local $sResponse, $sJSON, $sElement
	Local $sScript = "return Array.from(document.querySelectorAll(':hover')).pop()"
	$sResponse = _WD_ExecuteScript($sSession, $sScript, '')
	$sJSON = Json_Decode($sResponse)
	$sElement = Json_Get($sJSON, "[value][" & $_WD_ELEMENT_ID & "]")
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sElement & @CRLF)
		ConsoleWrite($sFuncName & ': ' & IsObj($sElement) & @CRLF)
	EndIf
Return SetError($_WD_ERROR_Success, 0, $sElement)
EndFunc
Func _WD_GetElementFromPoint($sSession, $iX, $iY)
	Local $sResponse, $sElement, $sJSON
    Local $sScript = "return document.elementFromPoint(arguments[0], arguments[1]);"
	Local $sParams = $iX & ", " & $iY
	$sResponse = _WD_ExecuteScript($sSession, $sScript, $sParams)
	$sJSON = Json_Decode($sResponse)
	$sElement = Json_Get($sJSON, "[value][" & $_WD_ELEMENT_ID & "]")
	Return SetError($_WD_ERROR_Success, 0, $sElement)
EndFunc
Func _WD_LastHTTPResult()
	Return $_WD_HTTPRESULT
EndFunc
Func _WD_GetFrameCount($sSession)
    Local $sResponse, $sJSON, $iValue
    $sResponse = _WD_ExecuteScript($sSession, "return window.frames.length")
    $sJSON = Json_Decode($sResponse)
    $iValue = Json_Get($sJSON, "[value]")
    Return Number($iValue)
EndFunc ;==>_WD_GetFrameCount
Func _WD_IsWindowTop($sSession)
    Local $sResponse, $sJSON
    Local $blnResult
    $sResponse = _WD_ExecuteScript($sSession, "return window.top == window.self")
    $sJSON = Json_Decode($sResponse)
    $blnResult = Json_Get($sJSON, "[value]")
    Return $blnResult
EndFunc ;==>_WD_IsWindowTop
Func _WD_FrameEnter($sSession, $sIndexOrID)
    Local $sOption
    Local $sResponse, $sJSON
    Local $sValue
    If IsInt($sIndexOrID) = True Then
        $sOption = '{"id":' & $sIndexOrID & '}'
    Else
		$sOption = '{"id":{"' & $_WD_ELEMENT_ID & '":"' & $sIndexOrID & '"}}'
    EndIf
    $sResponse = _WD_Window($sSession, "frame", $sOption)
    $sJSON = Json_Decode($sResponse)
    $sValue = Json_Get($sJSON, "[value]")
    If $sValue <> Null Then
        $sValue = Json_Get($sJSON, "[value][error]")
    Else
        $sValue = True
    EndIf
    Return $sValue
EndFunc ;==>_WD_FrameEnter
Func _WD_FrameLeave($sSession)
    Local $sOption
    Local $sResponse, $sJSON, $asJSON
    Local $sValue
    $sOption = '{}'
    $sResponse = _WD_Window($sSession, "parent", $sOption)
    $sJSON = Json_Decode($sResponse)
    $sValue = Json_Get($sJSON, "[value]")
    If $sValue <> Null Then
        If Json_IsObject($sValue) = True Then
            $asJSON = Json_ObjGetKeys($sValue)
            If UBound($asJSON) = 0 Then ;Firefox PASS
                $sValue = True
            Else ;Chrome and Firefox FAIL
                $sValue = $asJSON[0] & ":" & Json_Get($sJSON, "[value][" & $asJSON[0] & "]")
            EndIf
        EndIf
    Else ;Chrome PASS
        $sValue = True
    EndIf
    Return $sValue
EndFunc ;==>_WD_FrameLeave
Func _WD_HighlightElement($sSession, $sElement, $iMethod = 1)
    Local Const $aMethod[] = ["border: 2px dotted red", _
            "background: #FFFF66; border-radius: 5px; padding-left: 3px;", _
            "border:2px dotted  red;background: #FFFF66; border-radius: 5px; padding-left: 3px;"]
    If $iMethod < 1 Or $iMethod > 3 Then $iMethod = 1
	Local $sJsonElement = '{"' & $_WD_ELEMENT_ID & '":"' & $sElement & '"}'
    Local $sResponse = _WD_ExecuteScript($sSession, "arguments[0].style='" & $aMethod[$iMethod - 1] & "'; return true;", $sJsonElement)
    Local $sJSON = Json_Decode($sResponse)
    Local $sResult = Json_Get($sJSON, "[value]")
    Return ($sResult = "true" ? SetError(0, 0, $sResult) : SetError(1, 0, False))
EndFunc   ;==>_WD_HighlightElement
Func _WD_HighlightElements($sSession, $aElements, $iMethod = 1)
    Local $iHighlightedElements = 0
    For $i = 0 To UBound($aElements) - 1
        $iHighlightedElements += (_WD_HighlightElement($sSession, $aElements[$i], $iMethod) = True ? 1 : 0)
    Next
    Return ($iHighlightedElements > 0 ? SetError(0, $iHighlightedElements, True) : SetError(1, 0, False))
EndFunc   ;==>_WD_HighlightElements
Func _WD_LoadWait($sSession, $iDelay = 0, $iTimeout = -1, $sElement = '')
	Local Const $sFuncName = "_WD_LoadWait"
	Local $iErr, $sResponse, $sJSON, $sReadyState
	If $iTimeout = -1 Then $iTimeout = $_WD_DefaultTimeout
	If $iDelay Then Sleep($iDelay)
	Local $hLoadWaitTimer = TimerInit()
	While True
		If $sElement <> '' Then
			_WD_ElementAction($sSession, $sElement, 'name')
			If $_WD_HTTPRESULT = $HTTP_STATUS_NOT_FOUND Then $sElement = ''
		Else
			$sResponse = _WD_ExecuteScript($sSession, 'return document.readyState', '')
			$iErr = @error
			If $iErr Then
				ExitLoop
			EndIf
			$sJSON = Json_Decode($sResponse)
			$sReadyState = Json_Get($sJSON, "[value]")
			If $sReadyState = 'complete' Then ExitLoop
		EndIf
		If (TimerDiff($hLoadWaitTimer) > $iTimeout) Then
			$iErr = $_WD_ERROR_Timeout
			ExitLoop
		EndIf
		Sleep(100)
	WEnd
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $iErr, ""), 0, 0)
	EndIf
	Return SetError($_WD_ERROR_Success, 0, 1)
EndFunc
Func _WD_Screenshot($sSession, $sElement = '', $nOutputType = 1)
	Local Const $sFuncName = "_WD_Screenshot"
	Local $sResponse, $sJSON, $sResult, $bDecode
	If $sElement = '' Then
		$sResponse = _WD_Window($sSession, 'Screenshot')
		$iErr = @error
	Else
		$sResponse = _WD_ElementAction($sSession, $sElement, 'Screenshot')
		$iErr = @error
	EndIf
	If $iErr = $_WD_ERROR_Success Then
		Switch $nOutputType
			Case 1 ; String
				$sResult = BinaryToString(_Base64Decode($sResponse))
			Case 2 ; Binary
				$sResult = _Base64Decode($sResponse)
			Case 3 ; Base64
		EndSwitch
	Else
		$sResult = ''
	EndIf
	Return SetError(__WD_Error($sFuncName, $iErr), 0, $sResult)
EndFunc
Func _WD_jQuerify($sSession)
Local $jQueryLoader = _
"(function(jqueryUrl, callback) {" & _
"    if (typeof jqueryUrl != 'string') {" & _
"        jqueryUrl = 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js';" & _
"    }" & _
"    if (typeof jQuery == 'undefined') {" & _
"        var script = document.createElement('script');" & _
"        var head = document.getElementsByTagName('head')[0];" & _
"        var done = false;" & _
"        script.onload = script.onreadystatechange = (function() {" & _
"            if (!done && (!this.readyState || this.readyState == 'loaded' " & _
"                    || this.readyState == 'complete')) {" & _
"                done = true;" & _
"                script.onload = script.onreadystatechange = null;" & _
"                head.removeChild(script);" & _
"                callback();" & _
"            }" & _
"        });" & _
"        script.src = jqueryUrl;" & _
"        head.appendChild(script);" & _
"    }" & _
"    else {" & _
"        jQuery.noConflict();" & _
"        callback();" & _
"    }" & _
"})(arguments[0], arguments[arguments.length - 1]);"
_WD_ExecuteScript($sSession, $jQueryLoader, "[]", True)
Do
	Sleep(250)
	_WD_ExecuteScript($sSession, "jQuery")
Until @error = $_WD_ERROR_Success
EndFunc
Func _WD_ElementOptionSelect($sSession, $sStrategy, $sSelector, $sStartElement = "")
    Local $sElement = _WD_FindElement($sSession, $sStrategy, $sSelector, $sStartElement)
    If @error = $_WD_ERROR_Success Then
        _WD_ElementAction($sSession, $sElement, 'click')
    EndIf
EndFunc
Func _Base64Decode($input_string)
    Local $struct = DllStructCreate("int")
    $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
            "str", $input_string, _
            "int", 0, _
            "int", 1, _
            "ptr", 0, _
            "ptr", DllStructGetPtr($struct, 1), _
            "ptr", 0, _
            "ptr", 0)
    If @error Or Not $a_Call[0] Then
        Return SetError(1, 0, "") ; error calculating the length of the buffer needed
    EndIf
    Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
    $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
            "str", $input_string, _
            "int", 0, _
            "int", 1, _
            "ptr", DllStructGetPtr($a), _
            "ptr", DllStructGetPtr($struct, 1), _
            "ptr", 0, _
            "ptr", 0)
    If @error Or Not $a_Call[0] Then
        Return SetError(2, 0, ""); error decoding
    EndIf
    Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode
Global Const $FC_NOOVERWRITE = 0 ; Do not overwrite existing files (default)
Global Const $FC_OVERWRITE = 1 ; Overwrite existing files
Global Const $FC_CREATEPATH = 8 ; Create destination directory structure if it doesn't exist
Global Const $FT_MODIFIED = 0 ; Date and time file was last modified (default)
Global Const $FT_CREATED = 1 ; Date and time file was created
Global Const $FT_ACCESSED = 2 ; Date and time file was last accessed
Global Const $FT_ARRAY = 0
Global Const $FT_STRING = 1
Global Const $FSF_CREATEBUTTON = 1
Global Const $FSF_NEWDIALOG = 2
Global Const $FSF_EDITCONTROL = 4
Global Const $FT_NONRECURSIVE = 0
Global Const $FT_RECURSIVE = 1
Global Const $FO_READ = 0 ; Read mode
Global Const $FO_APPEND = 1 ; Write mode (append)
Global Const $FO_OVERWRITE = 2 ; Write mode (erase previous contents)
Global Const $FO_CREATEPATH = 8 ; Create directory structure if it doesn't exist
Global Const $FO_BINARY = 16 ; Read/Write mode binary
Global Const $FO_UNICODE = 32 ; Write mode Unicode UTF16-LE
Global Const $FO_UTF16_LE = 32 ; Write mode Unicode UTF16-LE
Global Const $FO_UTF16_BE = 64 ; Write mode Unicode UTF16-BE
Global Const $FO_UTF8 = 128 ; Read/Write mode UTF8 with BOM
Global Const $FO_UTF8_NOBOM = 256 ; Read/Write mode UTF8 with no BOM
Global Const $FO_ANSI = 512 ; Read/Write mode ANSI
Global Const $FO_UTF16_LE_NOBOM = 1024 ; Write mode Unicode UTF16-LE with no BOM
Global Const $FO_UTF16_BE_NOBOM = 2048 ; Write mode Unicode UTF16-BE with no BOM
Global Const $FO_UTF8_FULL = 16384 ; Use full file UTF8 detection if no BOM present
Global Const $FO_FULLFILE_DETECT = 16384 ; Use full file UTF8 detection if no BOM present
Global Const $EOF = -1 ; End-of-file reached
Global Const $FD_FILEMUSTEXIST = 1 ; File must exist
Global Const $FD_PATHMUSTEXIST = 2 ; Path must exist
Global Const $FD_MULTISELECT = 4 ; Allow multi-select
Global Const $FD_PROMPTCREATENEW = 8 ; Prompt to create new file
Global Const $FD_PROMPTOVERWRITE = 16 ; Prompt to overWrite file
Global Const $CREATE_NEW = 1
Global Const $CREATE_ALWAYS = 2
Global Const $OPEN_EXISTING = 3
Global Const $OPEN_ALWAYS = 4
Global Const $TRUNCATE_EXISTING = 5
Global Const $INVALID_SET_FILE_POINTER = -1
Global Const $FILE_BEGIN = 0
Global Const $FILE_CURRENT = 1
Global Const $FILE_END = 2
Global Const $FILE_ATTRIBUTE_READONLY = 0x00000001
Global Const $FILE_ATTRIBUTE_HIDDEN = 0x00000002
Global Const $FILE_ATTRIBUTE_SYSTEM = 0x00000004
Global Const $FILE_ATTRIBUTE_DIRECTORY = 0x00000010
Global Const $FILE_ATTRIBUTE_ARCHIVE = 0x00000020
Global Const $FILE_ATTRIBUTE_DEVICE = 0x00000040
Global Const $FILE_ATTRIBUTE_NORMAL = 0x00000080
Global Const $FILE_ATTRIBUTE_TEMPORARY = 0x00000100
Global Const $FILE_ATTRIBUTE_SPARSE_FILE = 0x00000200
Global Const $FILE_ATTRIBUTE_REPARSE_POINT = 0x00000400
Global Const $FILE_ATTRIBUTE_COMPRESSED = 0x00000800
Global Const $FILE_ATTRIBUTE_OFFLINE = 0x00001000
Global Const $FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = 0x00002000
Global Const $FILE_ATTRIBUTE_ENCRYPTED = 0x00004000
Global Const $FILE_SHARE_READ = 0x00000001
Global Const $FILE_SHARE_WRITE = 0x00000002
Global Const $FILE_SHARE_DELETE = 0x00000004
Global Const $FILE_SHARE_READWRITE = BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE)
Global Const $FILE_SHARE_ANY = BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE, $FILE_SHARE_DELETE)
Global Const $GENERIC_ALL = 0x10000000
Global Const $GENERIC_EXECUTE = 0x20000000
Global Const $GENERIC_WRITE = 0x40000000
Global Const $GENERIC_READ = 0x80000000
Global Const $GENERIC_READWRITE = BitOR($GENERIC_READ, $GENERIC_WRITE)
Global Const $FILE_ENCODING_UTF16LE = 32
Global Const $FE_ENTIRE_UTF8 = 1
Global Const $FE_PARTIALFIRST_UTF8 = 2
Global Const $FN_FULLPATH = 0
Global Const $FN_RELATIVEPATH = 1
Global Const $FV_COMMENTS = "Comments"
Global Const $FV_COMPANYNAME = "CompanyName"
Global Const $FV_FILEDESCRIPTION = "FileDescription"
Global Const $FV_FILEVERSION = "FileVersion"
Global Const $FV_INTERNALNAME = "InternalName"
Global Const $FV_LEGALCOPYRIGHT = "LegalCopyright"
Global Const $FV_LEGALTRADEMARKS = "LegalTrademarks"
Global Const $FV_ORIGINALFILENAME = "OriginalFilename"
Global Const $FV_PRODUCTNAME = "ProductName"
Global Const $FV_PRODUCTVERSION = "ProductVersion"
Global Const $FV_PRIVATEBUILD = "PrivateBuild"
Global Const $FV_SPECIALBUILD = "SpecialBuild"
Global Const $FRTA_NOCOUNT = 0
Global Const $FRTA_COUNT = 1
Global Const $FRTA_INTARRAYS = 2
Global Const $FRTA_ENTIRESPLIT = 4
Global Const $FLTA_FILESFOLDERS = 0
Global Const $FLTA_FILES = 1
Global Const $FLTA_FOLDERS = 2
Global Const $FLTAR_FILESFOLDERS = 0
Global Const $FLTAR_FILES = 1
Global Const $FLTAR_FOLDERS = 2
Global Const $FLTAR_NOHIDDEN = 4
Global Const $FLTAR_NOSYSTEM = 8
Global Const $FLTAR_NOLINK = 16
Global Const $FLTAR_NORECUR = 0
Global Const $FLTAR_RECUR = 1
Global Const $FLTAR_NOSORT = 0
Global Const $FLTAR_SORT = 1
Global Const $FLTAR_FASTSORT = 2
Global Const $FLTAR_NOPATH = 0
Global Const $FLTAR_RELPATH = 1
Global Const $FLTAR_FULLPATH = 2
Global Const $PATH_ORIGINAL = 0
Global Const $PATH_DRIVE = 1
Global Const $PATH_DIRECTORY = 2
Global Const $PATH_FILENAME = 3
Global Const $PATH_EXTENSION = 4
#comments-start
	Copyright 2013 Dragana R. <trancexx at yahoo dot com>
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
#comments-end
Global Const $INTERNET_DEFAULT_PORT = 0
Global Const $INTERNET_DEFAULT_HTTP_PORT = 80
Global Const $INTERNET_DEFAULT_HTTPS_PORT = 443
Global Const $INTERNET_SCHEME_HTTP = 1
Global Const $INTERNET_SCHEME_HTTPS = 2
Global Const $INTERNET_SCHEME_FTP = 3
Global Const $ICU_ESCAPE = 0x80000000
Global Const $WINHTTP_FLAG_ASYNC = 0x10000000
Global Const $WINHTTP_FLAG_ESCAPE_PERCENT = 0x00000004
Global Const $WINHTTP_FLAG_NULL_CODEPAGE = 0x00000008
Global Const $WINHTTP_FLAG_ESCAPE_DISABLE = 0x00000040
Global Const $WINHTTP_FLAG_ESCAPE_DISABLE_QUERY = 0x00000080
Global Const $WINHTTP_FLAG_BYPASS_PROXY_CACHE = 0x00000100
Global Const $WINHTTP_FLAG_REFRESH = $WINHTTP_FLAG_BYPASS_PROXY_CACHE
Global Const $WINHTTP_FLAG_SECURE = 0x00800000
Global Const $WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0
Global Const $WINHTTP_ACCESS_TYPE_NO_PROXY = 1
Global Const $WINHTTP_ACCESS_TYPE_NAMED_PROXY = 3
Global Const $WINHTTP_NO_PROXY_NAME = ""
Global Const $WINHTTP_NO_PROXY_BYPASS = ""
Global Const $WINHTTP_NO_REFERER = ""
Global Const $WINHTTP_DEFAULT_ACCEPT_TYPES = 0
Global Const $WINHTTP_NO_ADDITIONAL_HEADERS = ""
Global Const $WINHTTP_NO_REQUEST_DATA = ""
Global Const $WINHTTP_HEADER_NAME_BY_INDEX = ""
Global Const $WINHTTP_NO_OUTPUT_BUFFER = 0
Global Const $WINHTTP_NO_HEADER_INDEX = 0
Global Const $WINHTTP_ADDREQ_INDEX_MASK = 0x0000FFFF
Global Const $WINHTTP_ADDREQ_FLAGS_MASK = 0xFFFF0000
Global Const $WINHTTP_ADDREQ_FLAG_ADD_IF_NEW = 0x10000000
Global Const $WINHTTP_ADDREQ_FLAG_ADD = 0x20000000
Global Const $WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA = 0x40000000
Global Const $WINHTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON = 0x01000000
Global Const $WINHTTP_ADDREQ_FLAG_COALESCE = $WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA
Global Const $WINHTTP_ADDREQ_FLAG_REPLACE = 0x80000000
Global Const $WINHTTP_IGNORE_REQUEST_TOTAL_LENGTH = 0
Global Const $WINHTTP_OPTION_CALLBACK = 1
Global Const $WINHTTP_FIRST_OPTION = $WINHTTP_OPTION_CALLBACK
Global Const $WINHTTP_OPTION_RESOLVE_TIMEOUT = 2
Global Const $WINHTTP_OPTION_CONNECT_TIMEOUT = 3
Global Const $WINHTTP_OPTION_CONNECT_RETRIES = 4
Global Const $WINHTTP_OPTION_SEND_TIMEOUT = 5
Global Const $WINHTTP_OPTION_RECEIVE_TIMEOUT = 6
Global Const $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT = 7
Global Const $WINHTTP_OPTION_HANDLE_TYPE = 9
Global Const $WINHTTP_OPTION_READ_BUFFER_SIZE = 12
Global Const $WINHTTP_OPTION_WRITE_BUFFER_SIZE = 13
Global Const $WINHTTP_OPTION_PARENT_HANDLE = 21
Global Const $WINHTTP_OPTION_EXTENDED_ERROR = 24
Global Const $WINHTTP_OPTION_SECURITY_FLAGS = 31
Global Const $WINHTTP_OPTION_SECURITY_CERTIFICATE_STRUCT = 32
Global Const $WINHTTP_OPTION_URL = 34
Global Const $WINHTTP_OPTION_SECURITY_KEY_BITNESS = 36
Global Const $WINHTTP_OPTION_PROXY = 38
Global Const $WINHTTP_OPTION_USER_AGENT = 41
Global Const $WINHTTP_OPTION_CONTEXT_VALUE = 45
Global Const $WINHTTP_OPTION_CLIENT_CERT_CONTEXT = 47
Global Const $WINHTTP_OPTION_REQUEST_PRIORITY = 58
Global Const $WINHTTP_OPTION_HTTP_VERSION = 59
Global Const $WINHTTP_OPTION_DISABLE_FEATURE = 63
Global Const $WINHTTP_OPTION_CODEPAGE = 68
Global Const $WINHTTP_OPTION_MAX_CONNS_PER_SERVER = 73
Global Const $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER = 74
Global Const $WINHTTP_OPTION_AUTOLOGON_POLICY = 77
Global Const $WINHTTP_OPTION_SERVER_CERT_CONTEXT = 78
Global Const $WINHTTP_OPTION_ENABLE_FEATURE = 79
Global Const $WINHTTP_OPTION_WORKER_THREAD_COUNT = 80
Global Const $WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT = 81
Global Const $WINHTTP_OPTION_PASSPORT_COBRANDING_URL = 82
Global Const $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH = 83
Global Const $WINHTTP_OPTION_SECURE_PROTOCOLS = 84
Global Const $WINHTTP_OPTION_ENABLETRACING = 85
Global Const $WINHTTP_OPTION_PASSPORT_SIGN_OUT = 86
Global Const $WINHTTP_OPTION_PASSPORT_RETURN_URL = 87
Global Const $WINHTTP_OPTION_REDIRECT_POLICY = 88
Global Const $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS = 89
Global Const $WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE = 90
Global Const $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE = 91
Global Const $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE = 92
Global Const $WINHTTP_OPTION_CONNECTION_INFO = 93
Global Const $WINHTTP_OPTION_CLIENT_CERT_ISSUER_LIST = 94
Global Const $WINHTTP_OPTION_SPN = 96
Global Const $WINHTTP_OPTION_GLOBAL_PROXY_CREDS = 97
Global Const $WINHTTP_OPTION_GLOBAL_SERVER_CREDS = 98
Global Const $WINHTTP_OPTION_UNLOAD_NOTIFY_EVENT = 99
Global Const $WINHTTP_OPTION_REJECT_USERPWD_IN_URL = 100
Global Const $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS = 101
Global Const $WINHTTP_OPTION_RECEIVE_PROXY_CONNECT_RESPONSE = 103
Global Const $WINHTTP_OPTION_IS_PROXY_CONNECT_RESPONSE = 104
Global Const $WINHTTP_OPTION_SERVER_SPN_USED = 106
Global Const $WINHTTP_OPTION_PROXY_SPN_USED = 107
Global Const $WINHTTP_OPTION_SERVER_CBT = 108
Global Const $WINHTTP_OPTION_UNSAFE_HEADER_PARSING = 110
Global Const $WINHTTP_OPTION_DECOMPRESSION = 118
Global Const $WINHTTP_LAST_OPTION = $WINHTTP_OPTION_DECOMPRESSION
Global Const $WINHTTP_OPTION_USERNAME = 0x1000
Global Const $WINHTTP_OPTION_PASSWORD = 0x1001
Global Const $WINHTTP_OPTION_PROXY_USERNAME = 0x1002
Global Const $WINHTTP_OPTION_PROXY_PASSWORD = 0x1003
Global Const $WINHTTP_CONNS_PER_SERVER_UNLIMITED = 0xFFFFFFFF
Global Const $WINHTTP_DECOMPRESSION_FLAG_GZIP = 0x00000001
Global Const $WINHTTP_DECOMPRESSION_FLAG_DEFLATE = 0x00000002
Global Const $WINHTTP_DECOMPRESSION_FLAG_ALL = 0x00000003
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM = 0
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW = 1
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH = 2
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_DEFAULT = $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_NEVER = 0
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP = 1
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS = 2
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_LAST = $WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_DEFAULT = $WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP
Global Const $WINHTTP_DISABLE_PASSPORT_AUTH = 0x00000000
Global Const $WINHTTP_ENABLE_PASSPORT_AUTH = 0x10000000
Global Const $WINHTTP_DISABLE_PASSPORT_KEYRING = 0x20000000
Global Const $WINHTTP_ENABLE_PASSPORT_KEYRING = 0x40000000
Global Const $WINHTTP_DISABLE_COOKIES = 0x00000001
Global Const $WINHTTP_DISABLE_REDIRECTS = 0x00000002
Global Const $WINHTTP_DISABLE_AUTHENTICATION = 0x00000004
Global Const $WINHTTP_DISABLE_KEEP_ALIVE = 0x00000008
Global Const $WINHTTP_ENABLE_SSL_REVOCATION = 0x00000001
Global Const $WINHTTP_ENABLE_SSL_REVERT_IMPERSONATION = 0x00000002
Global Const $WINHTTP_DISABLE_SPN_SERVER_PORT = 0x00000000
Global Const $WINHTTP_ENABLE_SPN_SERVER_PORT = 0x00000001
Global Const $WINHTTP_OPTION_SPN_MASK = $WINHTTP_ENABLE_SPN_SERVER_PORT
Global Const $WINHTTP_ERROR_BASE = 12000
Global Const $ERROR_WINHTTP_OUT_OF_HANDLES = 12001
Global Const $ERROR_WINHTTP_TIMEOUT = 12002
Global Const $ERROR_WINHTTP_INTERNAL_ERROR = 12004
Global Const $ERROR_WINHTTP_INVALID_URL = 12005
Global Const $ERROR_WINHTTP_UNRECOGNIZED_SCHEME = 12006
Global Const $ERROR_WINHTTP_NAME_NOT_RESOLVED = 12007
Global Const $ERROR_WINHTTP_INVALID_OPTION = 12009
Global Const $ERROR_WINHTTP_OPTION_NOT_SETTABLE = 12011
Global Const $ERROR_WINHTTP_SHUTDOWN = 12012
Global Const $ERROR_WINHTTP_LOGIN_FAILURE = 12015
Global Const $ERROR_WINHTTP_OPERATION_CANCELLED = 12017
Global Const $ERROR_WINHTTP_INCORRECT_HANDLE_TYPE = 12018
Global Const $ERROR_WINHTTP_INCORRECT_HANDLE_STATE = 12019
Global Const $ERROR_WINHTTP_CANNOT_CONNECT = 12029
Global Const $ERROR_WINHTTP_CONNECTION_ERROR = 12030
Global Const $ERROR_WINHTTP_RESEND_REQUEST = 12032
Global Const $ERROR_WINHTTP_SECURE_CERT_DATE_INVALID = 12037
Global Const $ERROR_WINHTTP_SECURE_CERT_CN_INVALID = 12038
Global Const $ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED = 12044
Global Const $ERROR_WINHTTP_SECURE_INVALID_CA = 12045
Global Const $ERROR_WINHTTP_SECURE_CERT_REV_FAILED = 12057
Global Const $ERROR_WINHTTP_CANNOT_CALL_BEFORE_OPEN = 12100
Global Const $ERROR_WINHTTP_CANNOT_CALL_BEFORE_SEND = 12101
Global Const $ERROR_WINHTTP_CANNOT_CALL_AFTER_SEND = 12102
Global Const $ERROR_WINHTTP_CANNOT_CALL_AFTER_OPEN = 12103
Global Const $ERROR_WINHTTP_HEADER_NOT_FOUND = 12150
Global Const $ERROR_WINHTTP_INVALID_SERVER_RESPONSE = 12152
Global Const $ERROR_WINHTTP_INVALID_HEADER = 12153
Global Const $ERROR_WINHTTP_INVALID_QUERY_REQUEST = 12154
Global Const $ERROR_WINHTTP_HEADER_ALREADY_EXISTS = 12155
Global Const $ERROR_WINHTTP_REDIRECT_FAILED = 12156
Global Const $ERROR_WINHTTP_SECURE_CHANNEL_ERROR = 12157
Global Const $ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT = 12166
Global Const $ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT = 12167
Global Const $ERROR_WINHTTP_SECURE_INVALID_CERT = 12169
Global Const $ERROR_WINHTTP_SECURE_CERT_REVOKED = 12170
Global Const $ERROR_WINHTTP_NOT_INITIALIZED = 12172
Global Const $ERROR_WINHTTP_SECURE_FAILURE = 12175
Global Const $ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR = 12178
Global Const $ERROR_WINHTTP_SECURE_CERT_WRONG_USAGE = 12179
Global Const $ERROR_WINHTTP_AUTODETECTION_FAILED = 12180
Global Const $ERROR_WINHTTP_HEADER_COUNT_EXCEEDED = 12181
Global Const $ERROR_WINHTTP_HEADER_SIZE_OVERFLOW = 12182
Global Const $ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW = 12183
Global Const $ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW = 12184
Global Const $ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY = 12185
Global Const $ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY = 12186
Global Const $WINHTTP_ERROR_LAST = 12186
Global Const $HTTP_STATUS_CONTINUE = 100
Global Const $HTTP_STATUS_SWITCH_PROTOCOLS = 101
Global Const $HTTP_STATUS_OK = 200
Global Const $HTTP_STATUS_CREATED = 201
Global Const $HTTP_STATUS_ACCEPTED = 202
Global Const $HTTP_STATUS_PARTIAL = 203
Global Const $HTTP_STATUS_NO_CONTENT = 204
Global Const $HTTP_STATUS_RESET_CONTENT = 205
Global Const $HTTP_STATUS_PARTIAL_CONTENT = 206
Global Const $HTTP_STATUS_WEBDAV_MULTI_STATUS = 207
Global Const $HTTP_STATUS_AMBIGUOUS = 300
Global Const $HTTP_STATUS_MOVED = 301
Global Const $HTTP_STATUS_REDIRECT = 302
Global Const $HTTP_STATUS_REDIRECT_METHOD = 303
Global Const $HTTP_STATUS_NOT_MODIFIED = 304
Global Const $HTTP_STATUS_USE_PROXY = 305
Global Const $HTTP_STATUS_REDIRECT_KEEP_VERB = 307
Global Const $HTTP_STATUS_BAD_REQUEST = 400
Global Const $HTTP_STATUS_DENIED = 401
Global Const $HTTP_STATUS_PAYMENT_REQ = 402
Global Const $HTTP_STATUS_FORBIDDEN = 403
Global Const $HTTP_STATUS_NOT_FOUND = 404
Global Const $HTTP_STATUS_BAD_METHOD = 405
Global Const $HTTP_STATUS_NONE_ACCEPTABLE = 406
Global Const $HTTP_STATUS_PROXY_AUTH_REQ = 407
Global Const $HTTP_STATUS_REQUEST_TIMEOUT = 408
Global Const $HTTP_STATUS_CONFLICT = 409
Global Const $HTTP_STATUS_GONE = 410
Global Const $HTTP_STATUS_LENGTH_REQUIRED = 411
Global Const $HTTP_STATUS_PRECOND_FAILED = 412
Global Const $HTTP_STATUS_REQUEST_TOO_LARGE = 413
Global Const $HTTP_STATUS_URI_TOO_LONG = 414
Global Const $HTTP_STATUS_UNSUPPORTED_MEDIA = 415
Global Const $HTTP_STATUS_RETRY_WITH = 449
Global Const $HTTP_STATUS_SERVER_ERROR = 500
Global Const $HTTP_STATUS_NOT_SUPPORTED = 501
Global Const $HTTP_STATUS_BAD_GATEWAY = 502
Global Const $HTTP_STATUS_SERVICE_UNAVAIL = 503
Global Const $HTTP_STATUS_GATEWAY_TIMEOUT = 504
Global Const $HTTP_STATUS_VERSION_NOT_SUP = 505
Global Const $HTTP_STATUS_FIRST = $HTTP_STATUS_CONTINUE
Global Const $HTTP_STATUS_LAST = $HTTP_STATUS_VERSION_NOT_SUP
Global Const $SECURITY_FLAG_IGNORE_UNKNOWN_CA = 0x00000100
Global Const $SECURITY_FLAG_IGNORE_CERT_DATE_INVALID = 0x00002000
Global Const $SECURITY_FLAG_IGNORE_CERT_CN_INVALID = 0x00001000
Global Const $SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE = 0x00000200
Global Const $SECURITY_FLAG_SECURE = 0x00000001
Global Const $SECURITY_FLAG_STRENGTH_WEAK = 0x10000000
Global Const $SECURITY_FLAG_STRENGTH_MEDIUM = 0x40000000
Global Const $SECURITY_FLAG_STRENGTH_STRONG = 0x20000000
Global Const $ICU_NO_ENCODE = 0x20000000
Global Const $ICU_DECODE = 0x10000000
Global Const $ICU_NO_META = 0x08000000
Global Const $ICU_ENCODE_SPACES_ONLY = 0x04000000
Global Const $ICU_BROWSER_MODE = 0x02000000
Global Const $ICU_ENCODE_PERCENT = 0x00001000
Global Const $WINHTTP_QUERY_MIME_VERSION = 0
Global Const $WINHTTP_QUERY_CONTENT_TYPE = 1
Global Const $WINHTTP_QUERY_CONTENT_TRANSFER_ENCODING = 2
Global Const $WINHTTP_QUERY_CONTENT_ID = 3
Global Const $WINHTTP_QUERY_CONTENT_DESCRIPTION = 4
Global Const $WINHTTP_QUERY_CONTENT_LENGTH = 5
Global Const $WINHTTP_QUERY_CONTENT_LANGUAGE = 6
Global Const $WINHTTP_QUERY_ALLOW = 7
Global Const $WINHTTP_QUERY_PUBLIC = 8
Global Const $WINHTTP_QUERY_DATE = 9
Global Const $WINHTTP_QUERY_EXPIRES = 10
Global Const $WINHTTP_QUERY_LAST_MODIFIED = 11
Global Const $WINHTTP_QUERY_MESSAGE_ID = 12
Global Const $WINHTTP_QUERY_URI = 13
Global Const $WINHTTP_QUERY_DERIVED_FROM = 14
Global Const $WINHTTP_QUERY_COST = 15
Global Const $WINHTTP_QUERY_LINK = 16
Global Const $WINHTTP_QUERY_PRAGMA = 17
Global Const $WINHTTP_QUERY_VERSION = 18
Global Const $WINHTTP_QUERY_STATUS_CODE = 19
Global Const $WINHTTP_QUERY_STATUS_TEXT = 20
Global Const $WINHTTP_QUERY_RAW_HEADERS = 21
Global Const $WINHTTP_QUERY_RAW_HEADERS_CRLF = 22
Global Const $WINHTTP_QUERY_CONNECTION = 23
Global Const $WINHTTP_QUERY_ACCEPT = 24
Global Const $WINHTTP_QUERY_ACCEPT_CHARSET = 25
Global Const $WINHTTP_QUERY_ACCEPT_ENCODING = 26
Global Const $WINHTTP_QUERY_ACCEPT_LANGUAGE = 27
Global Const $WINHTTP_QUERY_AUTHORIZATION = 28
Global Const $WINHTTP_QUERY_CONTENT_ENCODING = 29
Global Const $WINHTTP_QUERY_FORWARDED = 30
Global Const $WINHTTP_QUERY_FROM = 31
Global Const $WINHTTP_QUERY_IF_MODIFIED_SINCE = 32
Global Const $WINHTTP_QUERY_LOCATION = 33
Global Const $WINHTTP_QUERY_ORIG_URI = 34
Global Const $WINHTTP_QUERY_REFERER = 35
Global Const $WINHTTP_QUERY_RETRY_AFTER = 36
Global Const $WINHTTP_QUERY_SERVER = 37
Global Const $WINHTTP_QUERY_TITLE = 38
Global Const $WINHTTP_QUERY_USER_AGENT = 39
Global Const $WINHTTP_QUERY_WWW_AUTHENTICATE = 40
Global Const $WINHTTP_QUERY_PROXY_AUTHENTICATE = 41
Global Const $WINHTTP_QUERY_ACCEPT_RANGES = 42
Global Const $WINHTTP_QUERY_SET_COOKIE = 43
Global Const $WINHTTP_QUERY_COOKIE = 44
Global Const $WINHTTP_QUERY_REQUEST_METHOD = 45
Global Const $WINHTTP_QUERY_REFRESH = 46
Global Const $WINHTTP_QUERY_CONTENT_DISPOSITION = 47
Global Const $WINHTTP_QUERY_AGE = 48
Global Const $WINHTTP_QUERY_CACHE_CONTROL = 49
Global Const $WINHTTP_QUERY_CONTENT_BASE = 50
Global Const $WINHTTP_QUERY_CONTENT_LOCATION = 51
Global Const $WINHTTP_QUERY_CONTENT_MD5 = 52
Global Const $WINHTTP_QUERY_CONTENT_RANGE = 53
Global Const $WINHTTP_QUERY_ETAG = 54
Global Const $WINHTTP_QUERY_HOST = 55
Global Const $WINHTTP_QUERY_IF_MATCH = 56
Global Const $WINHTTP_QUERY_IF_NONE_MATCH = 57
Global Const $WINHTTP_QUERY_IF_RANGE = 58
Global Const $WINHTTP_QUERY_IF_UNMODIFIED_SINCE = 59
Global Const $WINHTTP_QUERY_MAX_FORWARDS = 60
Global Const $WINHTTP_QUERY_PROXY_AUTHORIZATION = 61
Global Const $WINHTTP_QUERY_RANGE = 62
Global Const $WINHTTP_QUERY_TRANSFER_ENCODING = 63
Global Const $WINHTTP_QUERY_UPGRADE = 64
Global Const $WINHTTP_QUERY_VARY = 65
Global Const $WINHTTP_QUERY_VIA = 66
Global Const $WINHTTP_QUERY_WARNING = 67
Global Const $WINHTTP_QUERY_EXPECT = 68
Global Const $WINHTTP_QUERY_PROXY_CONNECTION = 69
Global Const $WINHTTP_QUERY_UNLESS_MODIFIED_SINCE = 70
Global Const $WINHTTP_QUERY_PROXY_SUPPORT = 75
Global Const $WINHTTP_QUERY_AUTHENTICATION_INFO = 76
Global Const $WINHTTP_QUERY_PASSPORT_URLS = 77
Global Const $WINHTTP_QUERY_PASSPORT_CONFIG = 78
Global Const $WINHTTP_QUERY_MAX = 78
Global Const $WINHTTP_QUERY_CUSTOM = 65535
Global Const $WINHTTP_QUERY_FLAG_REQUEST_HEADERS = 0x80000000
Global Const $WINHTTP_QUERY_FLAG_SYSTEMTIME = 0x40000000
Global Const $WINHTTP_QUERY_FLAG_NUMBER = 0x20000000
Global Const $WINHTTP_CALLBACK_STATUS_RESOLVING_NAME = 0x00000001
Global Const $WINHTTP_CALLBACK_STATUS_NAME_RESOLVED = 0x00000002
Global Const $WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER = 0x00000004
Global Const $WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER = 0x00000008
Global Const $WINHTTP_CALLBACK_STATUS_SENDING_REQUEST = 0x00000010
Global Const $WINHTTP_CALLBACK_STATUS_REQUEST_SENT = 0x00000020
Global Const $WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE = 0x00000040
Global Const $WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED = 0x00000080
Global Const $WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION = 0x00000100
Global Const $WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED = 0x00000200
Global Const $WINHTTP_CALLBACK_STATUS_HANDLE_CREATED = 0x00000400
Global Const $WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING = 0x00000800
Global Const $WINHTTP_CALLBACK_STATUS_DETECTING_PROXY = 0x00001000
Global Const $WINHTTP_CALLBACK_STATUS_REDIRECT = 0x00004000
Global Const $WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE = 0x00008000
Global Const $WINHTTP_CALLBACK_STATUS_SECURE_FAILURE = 0x00010000
Global Const $WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE = 0x00020000
Global Const $WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE = 0x00040000
Global Const $WINHTTP_CALLBACK_STATUS_READ_COMPLETE = 0x00080000
Global Const $WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE = 0x00100000
Global Const $WINHTTP_CALLBACK_STATUS_REQUEST_ERROR = 0x00200000
Global Const $WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE = 0x00400000
Global Const $WINHTTP_CALLBACK_FLAG_RESOLVE_NAME = 0x00000003
Global Const $WINHTTP_CALLBACK_FLAG_CONNECT_TO_SERVER = 0x0000000C
Global Const $WINHTTP_CALLBACK_FLAG_SEND_REQUEST = 0x00000030
Global Const $WINHTTP_CALLBACK_FLAG_RECEIVE_RESPONSE = 0x000000C0
Global Const $WINHTTP_CALLBACK_FLAG_CLOSE_CONNECTION = 0x00000300
Global Const $WINHTTP_CALLBACK_FLAG_HANDLES = 0x00000C00
Global Const $WINHTTP_CALLBACK_FLAG_DETECTING_PROXY = $WINHTTP_CALLBACK_STATUS_DETECTING_PROXY
Global Const $WINHTTP_CALLBACK_FLAG_REDIRECT = $WINHTTP_CALLBACK_STATUS_REDIRECT
Global Const $WINHTTP_CALLBACK_FLAG_INTERMEDIATE_RESPONSE = $WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE
Global Const $WINHTTP_CALLBACK_FLAG_SECURE_FAILURE = $WINHTTP_CALLBACK_STATUS_SECURE_FAILURE
Global Const $WINHTTP_CALLBACK_FLAG_SENDREQUEST_COMPLETE = $WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE
Global Const $WINHTTP_CALLBACK_FLAG_HEADERS_AVAILABLE = $WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE
Global Const $WINHTTP_CALLBACK_FLAG_DATA_AVAILABLE = $WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE
Global Const $WINHTTP_CALLBACK_FLAG_READ_COMPLETE = $WINHTTP_CALLBACK_STATUS_READ_COMPLETE
Global Const $WINHTTP_CALLBACK_FLAG_WRITE_COMPLETE = $WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE
Global Const $WINHTTP_CALLBACK_FLAG_REQUEST_ERROR = $WINHTTP_CALLBACK_STATUS_REQUEST_ERROR
Global Const $WINHTTP_CALLBACK_FLAG_ALL_COMPLETIONS = 0x007E0000
Global Const $WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS = 0xFFFFFFFF
Global Const $API_RECEIVE_RESPONSE = 1
Global Const $API_QUERY_DATA_AVAILABLE = 2
Global Const $API_READ_DATA = 3
Global Const $API_WRITE_DATA = 4
Global Const $API_SEND_REQUEST = 5
Global Const $WINHTTP_HANDLE_TYPE_SESSION = 1
Global Const $WINHTTP_HANDLE_TYPE_CONNECT = 2
Global Const $WINHTTP_HANDLE_TYPE_REQUEST = 3
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_REV_FAILED = 0x00000001
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CERT = 0x00000002
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_REVOKED = 0x00000004
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CA = 0x00000008
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_CN_INVALID = 0x00000010
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_DATE_INVALID = 0x00000020
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_WRONG_USAGE = 0x00000040
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_SECURITY_CHANNEL_ERROR = 0x80000000
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_SSL2 = 0x00000008
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_SSL3 = 0x00000020
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_TLS1 = 0x00000080
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1 = 0x00000200
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2 = 0x00000800
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_ALL = 0x000000A8
Global Const $WINHTTP_AUTH_SCHEME_BASIC = 0x00000001
Global Const $WINHTTP_AUTH_SCHEME_NTLM = 0x00000002
Global Const $WINHTTP_AUTH_SCHEME_PASSPORT = 0x00000004
Global Const $WINHTTP_AUTH_SCHEME_DIGEST = 0x00000008
Global Const $WINHTTP_AUTH_SCHEME_NEGOTIATE = 0x00000010
Global Const $WINHTTP_AUTH_TARGET_SERVER = 0x00000000
Global Const $WINHTTP_AUTH_TARGET_PROXY = 0x00000001
Global Const $WINHTTP_AUTOPROXY_AUTO_DETECT = 0x00000001
Global Const $WINHTTP_AUTOPROXY_CONFIG_URL = 0x00000002
Global Const $WINHTTP_AUTOPROXY_RUN_INPROCESS = 0x00010000
Global Const $WINHTTP_AUTOPROXY_RUN_OUTPROCESS_ONLY = 0x00020000
Global Const $WINHTTP_AUTO_DETECT_TYPE_DHCP = 0x00000001
Global Const $WINHTTP_AUTO_DETECT_TYPE_DNS_A = 0x00000002
Global Const $__OBJECTTEMPLATE_CONST_WHATEVER 	= "[##%R!E)P]L[A(C!E%##]"
	Func _OBJECTTEMPLATE_Start($oSelf, $function)
	EndFunc
	Func _OBJECTTEMPLATE_Delete($oSelf, $handle )
	EndFunc
	Func _OBJECTTEMPLATE_SetError($oSelf,$t,$er=@error,$ex=@extended)
		$oSelf._errorText = $t
		$oSelf._errorNum = $er
		$oSelf._errorExt = $ex
	EndFunc
	Func _OBJECTTEMPLATE_GetErrorText($oSelf)
		Return $oSelf._errorText
	EndFunc
	Func _OBJECTTEMPLATE_GetErrorNum($oSelf)
		Return $oSelf._errorNum
	EndFunc
	Func _OBJECTTEMPLATE_GetErrorExt($oSelf)
		Return $oSelf._errorExt
	EndFunc
;#include "Array.au3"; REMOVED INCLUDE
;#include "GuiHeader.au3"; REMOVED INCLUDE
;#include "ListViewConstants.au3"; REMOVED INCLUDE
;#include "Memory.au3"; REMOVED INCLUDE
;#include "SendMessage.au3"; REMOVED INCLUDE
;#include "StructureConstants.au3"; REMOVED INCLUDE
;#include "UDFGlobalID.au3"; REMOVED INCLUDE
;#include "WinAPIConv.au3"; REMOVED INCLUDE
;#include "WinAPIGdi.au3"; REMOVED INCLUDE
;#include "WinAPIMisc.au3"; REMOVED INCLUDE
;#include "WinAPIRes.au3"; REMOVED INCLUDE
Global $__g_hLVLastWnd
Global Const $__LISTVIEWCONSTANT_SORTINFOSIZE = 11
Global $__g_aListViewSortInfo[1][$__LISTVIEWCONSTANT_SORTINFOSIZE]
Global Const $__LISTVIEWCONSTANT_ClassName = "SysListView32"
Global Const $__LISTVIEWCONSTANT_WS_MAXIMIZEBOX = 0x00010000
Global Const $__LISTVIEWCONSTANT_WS_MINIMIZEBOX = 0x00020000
Global Const $__LISTVIEWCONSTANT_GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $__LISTVIEWCONSTANT_WM_SETREDRAW = 0x000B
Global Const $__LISTVIEWCONSTANT_WM_SETFONT = 0x0030
Global Const $__LISTVIEWCONSTANT_WM_NOTIFY = 0x004E
Global Const $__LISTVIEWCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__LISTVIEWCONSTANT_ILD_TRANSPARENT = 0x00000001
Global Const $__LISTVIEWCONSTANT_ILD_BLEND25 = 0x00000002
Global Const $__LISTVIEWCONSTANT_ILD_BLEND50 = 0x00000004
Global Const $__LISTVIEWCONSTANT_ILD_MASK = 0x00000010
Global Const $__LISTVIEWCONSTANT_VK_DOWN = 0x28
Global Const $__LISTVIEWCONSTANT_VK_END = 0x23
Global Const $__LISTVIEWCONSTANT_VK_HOME = 0x24
Global Const $__LISTVIEWCONSTANT_VK_LEFT = 0x25
Global Const $__LISTVIEWCONSTANT_VK_NEXT = 0x22
Global Const $__LISTVIEWCONSTANT_VK_PRIOR = 0x21
Global Const $__LISTVIEWCONSTANT_VK_RIGHT = 0x27
Global Const $__LISTVIEWCONSTANT_VK_UP = 0x26
Global Const $tagLVBKIMAGE = "ulong Flags;hwnd hBmp;ptr Image;uint ImageMax;int XOffPercent;int YOffPercent"
Global Const $tagLVCOLUMN = "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order;int cxMin;int cxDefault;int cxIdeal"
Global Const $tagLVGROUP = "uint Size;uint Mask;ptr Header;int HeaderMax;ptr Footer;int FooterMax;int GroupID;uint StateMask;uint State;uint Align;" & _
		"ptr  pszSubtitle;uint cchSubtitle;ptr pszTask;uint cchTask;ptr pszDescriptionTop;uint cchDescriptionTop;ptr pszDescriptionBottom;" & _
		"uint cchDescriptionBottom;int iTitleImage;int iExtendedImage;int iFirstItem;uint cItems;ptr pszSubsetTitle;uint cchSubsetTitle"
Global Const $tagLVINSERTMARK = "uint Size;dword Flags;int Item;dword Reserved"
Global Const $tagLVSETINFOTIP = "uint Size;dword Flags;ptr Text;int Item;int SubItem"
Func _GUICtrlListView_AddArray($hWnd, ByRef $aItems)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	DllStructSetData($tItem, "Mask", $LVIF_TEXT)
	DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
	DllStructSetData($tItem, "TextMax", 4096)
	Local $iLastItem = _GUICtrlListView_GetItemCount($hWnd)
	_GUICtrlListView_BeginUpdate($hWnd)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			For $iI = 0 To UBound($aItems) - 1
				DllStructSetData($tItem, "Item", $iI)
				DllStructSetData($tItem, "SubItem", 0)
				DllStructSetData($tBuffer, "Text", $aItems[$iI][0])
				_SendMessage($hWnd, $LVM_INSERTITEMW, 0, $tItem, 0, "wparam", "struct*")
				For $iJ = 1 To UBound($aItems, $UBOUND_COLUMNS) - 1
					DllStructSetData($tItem, "SubItem", $iJ)
					DllStructSetData($tBuffer, "Text", $aItems[$iI][$iJ])
					_SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*")
				Next
			Next
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			For $iI = 0 To UBound($aItems) - 1
				DllStructSetData($tItem, "Item", $iI + $iLastItem)
				DllStructSetData($tItem, "SubItem", 0)
				DllStructSetData($tBuffer, "Text", $aItems[$iI][0])
				_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
				_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
				If $bUnicode Then
					_SendMessage($hWnd, $LVM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr")
				Else
					_SendMessage($hWnd, $LVM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr")
				EndIf
				For $iJ = 1 To UBound($aItems, $UBOUND_COLUMNS) - 1
					DllStructSetData($tItem, "SubItem", $iJ)
					DllStructSetData($tBuffer, "Text", $aItems[$iI][$iJ])
					_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
					_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
					If $bUnicode Then
						_SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
					Else
						_SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
					EndIf
				Next
			Next
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		For $iI = 0 To UBound($aItems) - 1
			DllStructSetData($tItem, "Item", $iI + $iLastItem)
			DllStructSetData($tItem, "SubItem", 0)
			DllStructSetData($tBuffer, "Text", $aItems[$iI][0])
			If $bUnicode Then
				GUICtrlSendMsg($hWnd, $LVM_INSERTITEMW, 0, $pItem)
			Else
				GUICtrlSendMsg($hWnd, $LVM_INSERTITEMA, 0, $pItem)
			EndIf
			For $iJ = 1 To UBound($aItems, $UBOUND_COLUMNS) - 1
				DllStructSetData($tItem, "SubItem", $iJ)
				DllStructSetData($tBuffer, "Text", $aItems[$iI][$iJ])
				If $bUnicode Then
					GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
				Else
					GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
				EndIf
			Next
		Next
	EndIf
	_GUICtrlListView_EndUpdate($hWnd)
EndFunc   ;==>_GUICtrlListView_AddArray
Func _GUICtrlListView_AddColumn($hWnd, $sText, $iWidth = 50, $iAlign = -1, $iImage = -1, $bOnRight = False)
	Return _GUICtrlListView_InsertColumn($hWnd, _GUICtrlListView_GetColumnCount($hWnd), $sText, $iWidth, $iAlign, $iImage, $bOnRight)
EndFunc   ;==>_GUICtrlListView_AddColumn
Func _GUICtrlListView_AddItem($hWnd, $sText, $iImage = -1, $iParam = 0)
	Return _GUICtrlListView_InsertItem($hWnd, $sText, -1, $iImage, $iParam)
EndFunc   ;==>_GUICtrlListView_AddItem
Func _GUICtrlListView_AddSubItem($hWnd, $iIndex, $sText, $iSubItem, $iImage = -1)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $iMask = $LVIF_TEXT
	If $iImage <> -1 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "Image", $iImage)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		DllStructSetData($tItem, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_AddSubItem
Func _GUICtrlListView_ApproximateViewHeight($hWnd, $iCount = -1, $iCX = -1, $iCY = -1)
	If IsHWnd($hWnd) Then
		Return BitShift((_SendMessage($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))), 16)
	Else
		Return BitShift((GUICtrlSendMsg($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))), 16)
	EndIf
EndFunc   ;==>_GUICtrlListView_ApproximateViewHeight
Func _GUICtrlListView_ApproximateViewRect($hWnd, $iCount = -1, $iCX = -1, $iCY = -1)
	Local $iView
	If IsHWnd($hWnd) Then
		$iView = _SendMessage($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))
	Else
		$iView = GUICtrlSendMsg($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))
	EndIf
	Local $aView[2]
	$aView[0] = BitAND($iView, 0xFFFF)
	$aView[1] = BitShift($iView, 16)
	Return $aView
EndFunc   ;==>_GUICtrlListView_ApproximateViewRect
Func _GUICtrlListView_ApproximateViewWidth($hWnd, $iCount = -1, $iCX = -1, $iCY = -1)
	If IsHWnd($hWnd) Then
		Return BitAND((_SendMessage($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))), 0xFFFF)
	Else
		Return BitAND((GUICtrlSendMsg($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _WinAPI_MakeLong($iCX, $iCY))), 0xFFFF)
	EndIf
EndFunc   ;==>_GUICtrlListView_ApproximateViewWidth
Func _GUICtrlListView_Arrange($hWnd, $iArrange = 0)
	Local $aArrange[4] = [$LVA_DEFAULT, $LVA_ALIGNLEFT, $LVA_ALIGNTOP, $LVA_SNAPTOGRID]
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ARRANGE, $aArrange[$iArrange]) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ARRANGE, $aArrange[$iArrange], 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_Arrange
Func __GUICtrlListView_ArrayDelete(ByRef $avArray, $iElement)
	If Not IsArray($avArray) Then Return SetError(1, 0, "")
	Local $iUpper = UBound($avArray) ; Size of original array
	If $iUpper = 1 Then
		SetError(2)
		Return ""
	EndIf
	Local $avNewArray[$iUpper - 1][$__LISTVIEWCONSTANT_SORTINFOSIZE]
	$avNewArray[0][0] = $avArray[0][0]
	If $iElement < 0 Then
		$iElement = 0
	EndIf
	If $iElement > ($iUpper - 1) Then
		$iElement = ($iUpper - 1)
	EndIf
	If $iElement > 0 Then
		For $iCntr = 0 To $iElement - 1
			For $x = 1 To $__LISTVIEWCONSTANT_SORTINFOSIZE - 1
				$avNewArray[$iCntr][$x] = $avArray[$iCntr][$x]
			Next
		Next
	EndIf
	If $iElement < ($iUpper - 1) Then
		For $iCntr = ($iElement + 1) To ($iUpper - 1)
			For $x = 1 To $__LISTVIEWCONSTANT_SORTINFOSIZE - 1
				$avNewArray[$iCntr - 1][$x] = $avArray[$iCntr][$x]
			Next
		Next
	EndIf
	$avArray = $avNewArray
	SetError(0)
	Return 1
EndFunc   ;==>__GUICtrlListView_ArrayDelete
Func _GUICtrlListView_BeginUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $__LISTVIEWCONSTANT_WM_SETREDRAW, False) = 0
EndFunc   ;==>_GUICtrlListView_BeginUpdate
Func _GUICtrlListView_CancelEditLabel($hWnd)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LVM_CANCELEDITLABEL)
	Else
		GUICtrlSendMsg($hWnd, $LVM_CANCELEDITLABEL, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_CancelEditLabel
Func _GUICtrlListView_ClickItem($hWnd, $iIndex, $sButton = "left", $bMove = False, $iClicks = 1, $iSpeed = 1)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	_GUICtrlListView_EnsureVisible($hWnd, $iIndex, False)
	Local $tRECT = _GUICtrlListView_GetItemRectEx($hWnd, $iIndex, $LVIR_LABEL)
	Local $tPoint = _WinAPI_PointFromRect($tRECT, True)
	$tPoint = _WinAPI_ClientToScreen($hWnd, $tPoint)
	Local $iX, $iY
	_WinAPI_GetXYFromPoint($tPoint, $iX, $iY)
	Local $iMode = Opt("MouseCoordMode", 1)
	If Not $bMove Then
		Local $aPos = MouseGetPos()
		_WinAPI_ShowCursor(False)
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
		MouseMove($aPos[0], $aPos[1], 0)
		_WinAPI_ShowCursor(True)
	Else
		MouseClick($sButton, $iX, $iY, $iClicks, $iSpeed)
	EndIf
	Opt("MouseCoordMode", $iMode)
EndFunc   ;==>_GUICtrlListView_ClickItem
Func _GUICtrlListView_CopyItems($hWnd_Source, $hWnd_Destination, $bDelFlag = False)
	Local $a_Indices, $tItem = DllStructCreate($tagLVITEM), $iIndex
	Local $iCols = _GUICtrlListView_GetColumnCount($hWnd_Source)
	Local $iItems = _GUICtrlListView_GetItemCount($hWnd_Source)
	_GUICtrlListView_BeginUpdate($hWnd_Source)
	_GUICtrlListView_BeginUpdate($hWnd_Destination)
	If BitAND(_GUICtrlListView_GetExtendedListViewStyle($hWnd_Source), $LVS_EX_CHECKBOXES) == $LVS_EX_CHECKBOXES Then
		For $i = 0 To $iItems - 1
			If (_GUICtrlListView_GetItemChecked($hWnd_Source, $i)) Then
				If IsArray($a_Indices) Then
					ReDim $a_Indices[UBound($a_Indices) + 1]
				Else
					Local $a_Indices[2]
				EndIf
				$a_Indices[0] = $a_Indices[0] + 1
				$a_Indices[UBound($a_Indices) - 1] = $i
			EndIf
		Next
		If (IsArray($a_Indices)) Then
			For $i = 1 To $a_Indices[0]
				DllStructSetData($tItem, "Mask", BitOR($LVIF_GROUPID, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_STATE))
				DllStructSetData($tItem, "Item", $a_Indices[$i])
				DllStructSetData($tItem, "SubItem", 0)
				DllStructSetData($tItem, "StateMask", -1)
				_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
				$iIndex = _GUICtrlListView_AddItem($hWnd_Destination, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], 0), DllStructGetData($tItem, "Image"))
				_GUICtrlListView_SetItemChecked($hWnd_Destination, $iIndex)
				For $x = 1 To $iCols - 1
					DllStructSetData($tItem, "Item", $a_Indices[$i])
					DllStructSetData($tItem, "SubItem", $x)
					_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
					_GUICtrlListView_AddSubItem($hWnd_Destination, $iIndex, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], $x), $x, DllStructGetData($tItem, "Image"))
				Next
			Next
			If $bDelFlag Then
				For $i = $a_Indices[0] To 1 Step -1
					_GUICtrlListView_DeleteItem($hWnd_Source, $a_Indices[$i])
				Next
			EndIf
		EndIf
	EndIf
	If (_GUICtrlListView_GetSelectedCount($hWnd_Source)) Then
		$a_Indices = _GUICtrlListView_GetSelectedIndices($hWnd_Source, 1)
		For $i = 1 To $a_Indices[0]
			DllStructSetData($tItem, "Mask", BitOR($LVIF_GROUPID, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_STATE))
			DllStructSetData($tItem, "Item", $a_Indices[$i])
			DllStructSetData($tItem, "SubItem", 0)
			DllStructSetData($tItem, "StateMask", -1)
			_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
			$iIndex = _GUICtrlListView_AddItem($hWnd_Destination, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], 0), DllStructGetData($tItem, "Image"))
			For $x = 1 To $iCols - 1
				DllStructSetData($tItem, "Item", $a_Indices[$i])
				DllStructSetData($tItem, "SubItem", $x)
				_GUICtrlListView_GetItemEx($hWnd_Source, $tItem)
				_GUICtrlListView_AddSubItem($hWnd_Destination, $iIndex, _GUICtrlListView_GetItemText($hWnd_Source, $a_Indices[$i], $x), $x, DllStructGetData($tItem, "Image"))
			Next
		Next
		_GUICtrlListView_SetItemSelected($hWnd_Source, -1, False)
		If $bDelFlag Then
			For $i = $a_Indices[0] To 1 Step -1
				_GUICtrlListView_DeleteItem($hWnd_Source, $a_Indices[$i])
			Next
		EndIf
	EndIf
	_GUICtrlListView_EndUpdate($hWnd_Source)
	_GUICtrlListView_EndUpdate($hWnd_Destination)
EndFunc   ;==>_GUICtrlListView_CopyItems
Func _GUICtrlListView_Create($hWnd, $sHeaderText, $iX, $iY, $iWidth = 150, $iHeight = 150, $iStyle = 0x0000000D, $iExStyle = 0x00000000, $bCoInit = False)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0) ; Invalid Window handle for _GUICtrlListViewCreate 1st parameter
	If Not IsString($sHeaderText) Then Return SetError(2, 0, 0) ; 2nd parameter not a string for _GUICtrlListViewCreate
	If $iWidth = -1 Then $iWidth = 150
	If $iHeight = -1 Then $iHeight = 150
	If $iStyle = -1 Then $iStyle = $LVS_DEFAULT
	If $iExStyle = -1 Then $iExStyle = 0x00000000
	Local Const $S_OK = 0x0
	Local Const $S_FALSE = 0x1
	Local Const $RPC_E_CHANGED_MODE = 0x80010106
	Local Const $E_INVALIDARG = 0x80070057
	Local Const $E_OUTOFMEMORY = 0x8007000E
	Local Const $E_UNEXPECTED = 0x8000FFFF
	Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
	Local Const $COINIT_APARTMENTTHREADED = 0x02
	Local $iStr_len = StringLen($sHeaderText)
	If $iStr_len Then $sHeaderText = StringSplit($sHeaderText, $sSeparatorChar)
	$iStyle = BitOR($__UDFGUICONSTANT_WS_CHILD, $__UDFGUICONSTANT_WS_VISIBLE, $iStyle)
	If $bCoInit Then
		Local $aResult = DllCall('ole32.dll', 'long', 'CoInitializeEx', 'ptr', 0, 'dword', $COINIT_APARTMENTTHREADED)
		If @error Then Return SetError(@error, @extended, 0)
		Switch $aResult[0]
			Case $S_OK
			Case $S_FALSE
			Case $RPC_E_CHANGED_MODE
			Case $E_INVALIDARG
			Case $E_OUTOFMEMORY
			Case $E_UNEXPECTED
		EndSwitch
	EndIf
	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Local $hList = _WinAPI_CreateWindowEx($iExStyle, $__LISTVIEWCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_SendMessage($hList, $__LISTVIEWCONSTANT_WM_SETFONT, _WinAPI_GetStockObject($__LISTVIEWCONSTANT_DEFAULT_GUI_FONT), True)
	If $iStr_len Then
		For $x = 1 To $sHeaderText[0]
			_GUICtrlListView_InsertColumn($hList, $x - 1, $sHeaderText[$x], 75)
		Next
	EndIf
	Return $hList
EndFunc   ;==>_GUICtrlListView_Create
Func _GUICtrlListView_CreateDragImage($hWnd, $iIndex)
	Local $aDrag[3]
	Local $tPoint = DllStructCreate($tagPOINT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$aDrag[0] = _SendMessage($hWnd, $LVM_CREATEDRAGIMAGE, $iIndex, $tPoint, 0, "wparam", "struct*", "handle")
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
			$aDrag[0] = _SendMessage($hWnd, $LVM_CREATEDRAGIMAGE, $iIndex, $pMemory, 0, "wparam", "ptr", "handle")
			_MemRead($tMemMap, $pMemory, $tPoint, $iPoint)
			_MemFree($tMemMap)
		EndIf
	Else
		$aDrag[0] = Ptr(GUICtrlSendMsg($hWnd, $LVM_CREATEDRAGIMAGE, $iIndex, DllStructGetPtr($tPoint)))
	EndIf
	$aDrag[1] = DllStructGetData($tPoint, "X")
	$aDrag[2] = DllStructGetData($tPoint, "Y")
	Return $aDrag
EndFunc   ;==>_GUICtrlListView_CreateDragImage
Func _GUICtrlListView_CreateSolidBitMap($hWnd, $iColor, $iWidth, $iHeight)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _WinAPI_CreateSolidBitmap($hWnd, $iColor, $iWidth, $iHeight)
EndFunc   ;==>_GUICtrlListView_CreateSolidBitMap
Func _GUICtrlListView_DeleteAllItems($hWnd)
	If _GUICtrlListView_GetItemCount($hWnd) = 0 Then Return True
	Local $vCID = 0
	If IsHWnd($hWnd) Then
		$vCID = _WinAPI_GetDlgCtrlID($hWnd)
	Else
		$vCID = $hWnd
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	If $vCID < $_UDF_STARTID Then
		Local $iParam = 0
		For $iIndex = _GUICtrlListView_GetItemCount($hWnd) - 1 To 0 Step -1
			$iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
			If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
				GUICtrlDelete($iParam)
			EndIf
		Next
		If _GUICtrlListView_GetItemCount($hWnd) = 0 Then Return True
	EndIf
	Return _SendMessage($hWnd, $LVM_DELETEALLITEMS) <> 0
EndFunc   ;==>_GUICtrlListView_DeleteAllItems
Func _GUICtrlListView_DeleteColumn($hWnd, $iCol)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_DELETECOLUMN, $iCol) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_DELETECOLUMN, $iCol, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_DeleteColumn
Func _GUICtrlListView_DeleteItem($hWnd, $iIndex)
	Local $vCID = 0
	If IsHWnd($hWnd) Then
		$vCID = _WinAPI_GetDlgCtrlID($hWnd)
	Else
		$vCID = $hWnd
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	If $vCID < $_UDF_STARTID Then
		Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
		If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
			If GUICtrlDelete($iParam) Then
				Return True
			EndIf
		EndIf
	EndIf
	Return _SendMessage($hWnd, $LVM_DELETEITEM, $iIndex) <> 0
EndFunc   ;==>_GUICtrlListView_DeleteItem
Func _GUICtrlListView_DeleteItemsSelected($hWnd)
	Local $iItemCount = _GUICtrlListView_GetItemCount($hWnd)
	If _GUICtrlListView_GetSelectedCount($hWnd) = $iItemCount Then
		Return _GUICtrlListView_DeleteAllItems($hWnd)
	Else
		Local $aSelected = _GUICtrlListView_GetSelectedIndices($hWnd, True)
		If Not IsArray($aSelected) Then Return SetError($LV_ERR, $LV_ERR, 0)
		_GUICtrlListView_SetItemSelected($hWnd, -1, False)
		Local $vCID = 0, $iNative_Delete, $iUDF_Delete
		If IsHWnd($hWnd) Then
			$vCID = _WinAPI_GetDlgCtrlID($hWnd)
		Else
			$vCID = $hWnd
			$hWnd = GUICtrlGetHandle($hWnd)
		EndIf
		For $iIndex = $aSelected[0] To 1 Step -1
			If $vCID < $_UDF_STARTID Then
				Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $aSelected[$iIndex])
				If GUICtrlGetState($iParam) > 0 And GUICtrlGetHandle($iParam) = 0 Then
					$iNative_Delete = GUICtrlDelete($iParam)
					If $iNative_Delete Then ContinueLoop
				EndIf
			EndIf
			$iUDF_Delete = _SendMessage($hWnd, $LVM_DELETEITEM, $aSelected[$iIndex])
			If $iNative_Delete + $iUDF_Delete = 0 Then
				ExitLoop
			EndIf
		Next
		Return Not $iIndex
	EndIf
EndFunc   ;==>_GUICtrlListView_DeleteItemsSelected
Func _GUICtrlListView_Destroy(ByRef $hWnd)
	If Not _WinAPI_IsClassName($hWnd, $__LISTVIEWCONSTANT_ClassName) Then Return SetError(2, 2, False)
	Local $iDestroyed = 0
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			Local $nCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
			Local $hParent = _WinAPI_GetParent($hWnd)
			$iDestroyed = _WinAPI_DestroyWindow($hWnd)
			Local $iRet = __UDF_FreeGlobalID($hParent, $nCtrlID)
			If Not $iRet Then
			EndIf
		Else
			Return SetError(1, 1, False)
		EndIf
	Else
		$iDestroyed = GUICtrlDelete($hWnd)
	EndIf
	If $iDestroyed Then $hWnd = 0
	Return $iDestroyed <> 0
EndFunc   ;==>_GUICtrlListView_Destroy
Func __GUICtrlListView_Draw($hWnd, $iIndex, $hDC, $iX, $iY, $iStyle = 0)
	Local $iFlags = 0
	If BitAND($iStyle, 1) <> 0 Then $iFlags = BitOR($iFlags, $__LISTVIEWCONSTANT_ILD_TRANSPARENT)
	If BitAND($iStyle, 2) <> 0 Then $iFlags = BitOR($iFlags, $__LISTVIEWCONSTANT_ILD_BLEND25)
	If BitAND($iStyle, 4) <> 0 Then $iFlags = BitOR($iFlags, $__LISTVIEWCONSTANT_ILD_BLEND50)
	If BitAND($iStyle, 8) <> 0 Then $iFlags = BitOR($iFlags, $__LISTVIEWCONSTANT_ILD_MASK)
	Local $aResult = DllCall("comctl32.dll", "bool", "ImageList_Draw", "handle", $hWnd, "int", $iIndex, "handle", $hDC, "int", $iX, "int", $iY, "uint", $iFlags)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>__GUICtrlListView_Draw
Func _GUICtrlListView_DrawDragImage(ByRef $hWnd, ByRef $aDrag)
	Local $hDC = _WinAPI_GetWindowDC($hWnd)
	Local $tPoint = _WinAPI_GetMousePos(True, $hWnd)
	_WinAPI_InvalidateRect($hWnd)
	__GUICtrlListView_Draw($aDrag[0], 0, $hDC, DllStructGetData($tPoint, "X"), DllStructGetData($tPoint, "Y"))
	_WinAPI_ReleaseDC($hWnd, $hDC)
EndFunc   ;==>_GUICtrlListView_DrawDragImage
Func _GUICtrlListView_EditLabel($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $aResult
	If IsHWnd($hWnd) Then
		$aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", $hWnd)
		If @error Then Return SetError(@error, @extended, 0)
		If $aResult = 0 Then Return 0
		If $bUnicode Then
			Return _SendMessage($hWnd, $LVM_EDITLABELW, $iIndex, 0, 0, "wparam", "lparam", "hwnd")
		Else
			Return _SendMessage($hWnd, $LVM_EDITLABEL, $iIndex, 0, 0, "wparam", "lparam", "hwnd")
		EndIf
	Else
		$aResult = DllCall("user32.dll", "hwnd", "SetFocus", "hwnd", GUICtrlGetHandle($hWnd))
		If @error Then Return SetError(@error, @extended, 0)
		If $aResult = 0 Then Return 0
		If $bUnicode Then
			Return HWnd(GUICtrlSendMsg($hWnd, $LVM_EDITLABELW, $iIndex, 0))
		Else
			Return HWnd(GUICtrlSendMsg($hWnd, $LVM_EDITLABEL, $iIndex, 0))
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListView_EditLabel
Func _GUICtrlListView_EnableGroupView($hWnd, $bEnable = True)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ENABLEGROUPVIEW, $bEnable)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ENABLEGROUPVIEW, $bEnable, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_EnableGroupView
Func _GUICtrlListView_EndUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $__LISTVIEWCONSTANT_WM_SETREDRAW, True) = 0
EndFunc   ;==>_GUICtrlListView_EndUpdate
Func _GUICtrlListView_EnsureVisible($hWnd, $iIndex, $bPartialOK = False)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ENSUREVISIBLE, $iIndex, $bPartialOK)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ENSUREVISIBLE, $iIndex, $bPartialOK)
	EndIf
EndFunc   ;==>_GUICtrlListView_EnsureVisible
Func _GUICtrlListView_FindInText($hWnd, $sText, $iStart = -1, $bWrapOK = True, $bReverse = False)
	Local $iCount = _GUICtrlListView_GetItemCount($hWnd)
	Local $iColumns = _GUICtrlListView_GetColumnCount($hWnd)
	If $iColumns = 0 Then $iColumns = 1
	If $bReverse And $iStart = -1 Then Return -1
	Local $sList
	If $bReverse Then
		For $iI = $iStart - 1 To 0 Step -1
			For $iJ = 0 To $iColumns - 1
				$sList = _GUICtrlListView_GetItemText($hWnd, $iI, $iJ)
				If StringInStr($sList, $sText) Then Return $iI
			Next
		Next
	Else
		For $iI = $iStart + 1 To $iCount - 1
			For $iJ = 0 To $iColumns - 1
				$sList = _GUICtrlListView_GetItemText($hWnd, $iI, $iJ)
				If StringInStr($sList, $sText) Then Return $iI
			Next
		Next
	EndIf
	If (($iStart = -1) Or Not $bWrapOK) And Not $bReverse Then Return -1
	If $bReverse And $bWrapOK Then
		For $iI = $iCount - 1 To $iStart + 1 Step -1
			For $iJ = 0 To $iColumns - 1
				$sList = _GUICtrlListView_GetItemText($hWnd, $iI, $iJ)
				If StringInStr($sList, $sText) Then Return $iI
			Next
		Next
	Else
		For $iI = 0 To $iStart - 1
			For $iJ = 0 To $iColumns - 1
				$sList = _GUICtrlListView_GetItemText($hWnd, $iI, $iJ)
				If StringInStr($sList, $sText) Then Return $iI
			Next
		Next
	EndIf
	Return -1
EndFunc   ;==>_GUICtrlListView_FindInText
Func _GUICtrlListView_FindItem($hWnd, $iStart, ByRef $tFindInfo, $sText = "")
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	DllStructSetData($tBuffer, "Text", $sText)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tFindInfo, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_FINDITEM, $iStart, $tFindInfo, 0, "wparam", "struct*")
		Else
			Local $iFindInfo = DllStructGetSize($tFindInfo)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iFindInfo + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iFindInfo
			DllStructSetData($tFindInfo, "Text", $pText)
			_MemWrite($tMemMap, $tFindInfo, $pMemory, $iFindInfo)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			$iRet = _SendMessage($hWnd, $LVM_FINDITEM, $iStart, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tFindInfo, "Text", $pBuffer)
		$iRet = GUICtrlSendMsg($hWnd, $LVM_FINDITEM, $iStart, DllStructGetPtr($tFindInfo))
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_FindItem
Func _GUICtrlListView_FindNearest($hWnd, $iX, $iY, $iDir = 0, $iStart = -1, $bWrapOK = True)
	Local $aDir[8] = [$__LISTVIEWCONSTANT_VK_LEFT, $__LISTVIEWCONSTANT_VK_RIGHT, $__LISTVIEWCONSTANT_VK_UP, $__LISTVIEWCONSTANT_VK_DOWN, $__LISTVIEWCONSTANT_VK_HOME, $__LISTVIEWCONSTANT_VK_END, $__LISTVIEWCONSTANT_VK_PRIOR, $__LISTVIEWCONSTANT_VK_NEXT]
	Local $tFindInfo = DllStructCreate($tagLVFINDINFO)
	Local $iFlags = $LVFI_NEARESTXY
	If $bWrapOK Then $iFlags = BitOR($iFlags, $LVFI_WRAP)
	DllStructSetData($tFindInfo, "Flags", $iFlags)
	DllStructSetData($tFindInfo, "X", $iX)
	DllStructSetData($tFindInfo, "Y", $iY)
	DllStructSetData($tFindInfo, "Direction", $aDir[$iDir])
	Return _GUICtrlListView_FindItem($hWnd, $iStart, $tFindInfo)
EndFunc   ;==>_GUICtrlListView_FindNearest
Func _GUICtrlListView_FindParam($hWnd, $iParam, $iStart = -1)
	Local $tFindInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tFindInfo, "Flags", $LVFI_PARAM)
	DllStructSetData($tFindInfo, "Param", $iParam)
	Return _GUICtrlListView_FindItem($hWnd, $iStart, $tFindInfo)
EndFunc   ;==>_GUICtrlListView_FindParam
Func _GUICtrlListView_FindText($hWnd, $sText, $iStart = -1, $bPartialOK = True, $bWrapOK = True)
	Local $tFindInfo = DllStructCreate($tagLVFINDINFO)
	Local $iFlags = $LVFI_STRING
	If $bPartialOK Then $iFlags = BitOR($iFlags, $LVFI_PARTIAL)
	If $bWrapOK Then $iFlags = BitOR($iFlags, $LVFI_WRAP)
	DllStructSetData($tFindInfo, "Flags", $iFlags)
	Return _GUICtrlListView_FindItem($hWnd, $iStart, $tFindInfo, $sText)
EndFunc   ;==>_GUICtrlListView_FindText
Func _GUICtrlListView_GetBkColor($hWnd)
	Local $i_Color
	If IsHWnd($hWnd) Then
		$i_Color = _SendMessage($hWnd, $LVM_GETBKCOLOR)
	Else
		$i_Color = GUICtrlSendMsg($hWnd, $LVM_GETBKCOLOR, 0, 0)
	EndIf
	Return __GUICtrlListView_ReverseColorOrder($i_Color)
EndFunc   ;==>_GUICtrlListView_GetBkColor
Func _GUICtrlListView_GetBkImage($hWnd)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tImage = DllStructCreate($tagLVBKIMAGE)
	DllStructSetData($tImage, "ImageMax", 4096)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tImage, "Image", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_GETBKIMAGEW, 0, $tImage, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $iImage = DllStructGetSize($tImage)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iImage + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iImage
			DllStructSetData($tImage, "Image", $pText)
			_MemWrite($tMemMap, $tImage, $pMemory, $iImage)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_GETBKIMAGEW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_GETBKIMAGEA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tImage, $iImage)
			_MemRead($tMemMap, $pText, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pImage = DllStructGetPtr($tImage)
		DllStructSetData($tImage, "Image", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETBKIMAGEW, 0, $pImage)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETBKIMAGEA, 0, $pImage)
		EndIf
	EndIf
	Local $aImage[4]
	Switch BitAND(DllStructGetData($tImage, "Flags"), $LVBKIF_SOURCE_MASK)
		Case $LVBKIF_SOURCE_HBITMAP
			$aImage[0] = 1
		Case $LVBKIF_SOURCE_URL
			$aImage[0] = 2
	EndSwitch
	$aImage[1] = DllStructGetData($tBuffer, "Text")
	$aImage[2] = DllStructGetData($tImage, "XOffPercent")
	$aImage[3] = DllStructGetData($tImage, "YOffPercent")
	Return SetError($iRet <> 0, 0, $aImage)
EndFunc   ;==>_GUICtrlListView_GetBkImage
Func _GUICtrlListView_GetCallbackMask($hWnd)
	Local $iFlags = 0
	Local $iMask = _SendMessage($hWnd, $LVM_GETCALLBACKMASK)
	If BitAND($iMask, $LVIS_CUT) <> 0 Then $iFlags = BitOR($iFlags, 1)
	If BitAND($iMask, $LVIS_DROPHILITED) <> 0 Then $iFlags = BitOR($iFlags, 2)
	If BitAND($iMask, $LVIS_FOCUSED) <> 0 Then $iFlags = BitOR($iFlags, 4)
	If BitAND($iMask, $LVIS_SELECTED) <> 0 Then $iFlags = BitOR($iFlags, 8)
	If BitAND($iMask, $LVIS_OVERLAYMASK) <> 0 Then $iFlags = BitOR($iFlags, 16)
	If BitAND($iMask, $LVIS_STATEIMAGEMASK) <> 0 Then $iFlags = BitOR($iFlags, 32)
	Return $iFlags
EndFunc   ;==>_GUICtrlListView_GetCallbackMask
Func _GUICtrlListView_GetColumn($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	DllStructSetData($tColumn, "Mask", $LVCF_ALLDATA)
	DllStructSetData($tColumn, "TextMax", 4096)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tColumn, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_GETCOLUMNW, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iColumn
			DllStructSetData($tColumn, "Text", $pText)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_GETCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_GETCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tColumn, $iColumn)
			_MemRead($tMemMap, $pText, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		DllStructSetData($tColumn, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	Local $aColumn[9]
	Switch BitAND(DllStructGetData($tColumn, "Fmt"), $LVCFMT_JUSTIFYMASK)
		Case $LVCFMT_RIGHT
			$aColumn[0] = 1
		Case $LVCFMT_CENTER
			$aColumn[0] = 2
		Case Else
			$aColumn[0] = 0
	EndSwitch
	$aColumn[1] = BitAND(DllStructGetData($tColumn, "Fmt"), $LVCFMT_IMAGE) <> 0
	$aColumn[2] = BitAND(DllStructGetData($tColumn, "Fmt"), $LVCFMT_BITMAP_ON_RIGHT) <> 0
	$aColumn[3] = BitAND(DllStructGetData($tColumn, "Fmt"), $LVCFMT_COL_HAS_IMAGES) <> 0
	$aColumn[4] = DllStructGetData($tColumn, "CX")
	$aColumn[5] = DllStructGetData($tBuffer, "Text")
	$aColumn[6] = DllStructGetData($tColumn, "SubItem")
	$aColumn[7] = DllStructGetData($tColumn, "Image")
	$aColumn[8] = DllStructGetData($tColumn, "Order")
	Return SetError($iRet = 0, 0, $aColumn)
EndFunc   ;==>_GUICtrlListView_GetColumn
Func _GUICtrlListView_GetColumnCount($hWnd)
	Return _SendMessage(_GUICtrlListView_GetHeader($hWnd), 0x1200)
EndFunc   ;==>_GUICtrlListView_GetColumnCount
Func _GUICtrlListView_GetColumnOrder($hWnd)
	Local $a_Cols = _GUICtrlListView_GetColumnOrderArray($hWnd), $s_Cols = ""
	Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
	For $i = 1 To $a_Cols[0]
		$s_Cols &= $a_Cols[$i] & $sSeparatorChar
	Next
	$s_Cols = StringTrimRight($s_Cols, 1)
	Return $s_Cols
EndFunc   ;==>_GUICtrlListView_GetColumnOrder
Func _GUICtrlListView_GetColumnOrderArray($hWnd)
	Local $iColumns = _GUICtrlListView_GetColumnCount($hWnd)
	Local $tBuffer = DllStructCreate("int[" & $iColumns & "]")
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETCOLUMNORDERARRAY, $iColumns, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_SendMessage($hWnd, $LVM_GETCOLUMNORDERARRAY, $iColumns, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETCOLUMNORDERARRAY, $iColumns, DllStructGetPtr($tBuffer))
	EndIf
	Local $aBuffer[$iColumns + 1]
	$aBuffer[0] = $iColumns
	For $iI = 1 To $iColumns
		$aBuffer[$iI] = DllStructGetData($tBuffer, 1, $iI)
	Next
	Return $aBuffer
EndFunc   ;==>_GUICtrlListView_GetColumnOrderArray
Func _GUICtrlListView_GetColumnWidth($hWnd, $iCol)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETCOLUMNWIDTH, $iCol)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETCOLUMNWIDTH, $iCol, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetColumnWidth
Func _GUICtrlListView_GetCounterPage($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETCOUNTPERPAGE)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETCOUNTPERPAGE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetCounterPage
Func _GUICtrlListView_GetEditControl($hWnd)
	If IsHWnd($hWnd) Then
		Return HWnd(_SendMessage($hWnd, $LVM_GETEDITCONTROL))
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $LVM_GETEDITCONTROL, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetEditControl
Func _GUICtrlListView_GetEmptyText($hWnd)
	Local $tText = DllStructCreate("char[4096]")
	Local $iRet
	If IsHWnd($hWnd) Then
		Local $iText = DllStructGetSize($tText)
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iText + 4096, $tMemMap)
		Local $pText = $pMemory + $iText
		DllStructSetData($tText, "Text", $pText)
		_MemWrite($tMemMap, $pText, $pMemory, $iText)
		$iRet = _SendMessage($hWnd, $LVM_GETEMPTYTEXT, 4096, $pMemory)
		_MemRead($tMemMap, $pText, $tText, 4096)
		_MemFree($tMemMap)
		If $iRet = 0 Then Return SetError(-1, 0, "")
		Return DllStructGetData($tText, 1)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETEMPTYTEXT, 4096, DllStructGetPtr($tText))
		If $iRet = 0 Then Return SetError(-1, 0, "")
		Return DllStructGetData($tText, 1)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetEmptyText
Func _GUICtrlListView_GetExtendedListViewStyle($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETEXTENDEDLISTVIEWSTYLE)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetExtendedListViewStyle
Func _GUICtrlListView_GetFocusedGroup($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETFOCUSEDGROUP)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETFOCUSEDGROUP, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetFocusedGroup
Func _GUICtrlListView_GetGroupCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETGROUPCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETGROUPCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetGroupCount
Func _GUICtrlListView_GetGroupInfo($hWnd, $iGroupID)
	Local $tGroup = __GUICtrlListView_GetGroupInfoEx($hWnd, $iGroupID, BitOR($LVGF_HEADER, $LVGF_ALIGN))
	Local $iErr = @error
	Local $aGroup[2]
	$aGroup[0] = _WinAPI_WideCharToMultiByte(DllStructGetData($tGroup, "Header"))
	Select
		Case BitAND(DllStructGetData($tGroup, "Align"), $LVGA_HEADER_CENTER) <> 0
			$aGroup[1] = 1
		Case BitAND(DllStructGetData($tGroup, "Align"), $LVGA_HEADER_RIGHT) <> 0
			$aGroup[1] = 2
		Case Else
			$aGroup[1] = 0
	EndSelect
	Return SetError($iErr, 0, $aGroup)
EndFunc   ;==>_GUICtrlListView_GetGroupInfo
Func __GUICtrlListView_GetGroupInfoEx($hWnd, $iGroupID, $iMask)
	Local $tGroup = DllStructCreate($tagLVGROUP)
	Local $iGroup = DllStructGetSize($tGroup)
	DllStructSetData($tGroup, "Size", $iGroup)
	DllStructSetData($tGroup, "Mask", $iMask)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPINFO, $iGroupID, $tGroup, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup, $tMemMap)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPINFO, $iGroupID, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tGroup, $iGroup)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETGROUPINFO, $iGroupID, DllStructGetPtr($tGroup))
	EndIf
	Return SetError($iRet <> $iGroupID, 0, $tGroup)
EndFunc   ;==>__GUICtrlListView_GetGroupInfoEx
Func _GUICtrlListView_GetGroupInfoByIndex($hWnd, $iIndex)
	Local $tGroup = DllStructCreate($tagLVGROUP)
	Local $iGroup = DllStructGetSize($tGroup)
	DllStructSetData($tGroup, "Size", $iGroup)
	DllStructSetData($tGroup, "Mask", BitOR($LVGF_HEADER, $LVGF_ALIGN, $LVGF_GROUPID))
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPINFOBYINDEX, $iIndex, $tGroup, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup, $tMemMap)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPINFOBYINDEX, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tGroup, $iGroup)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETGROUPINFOBYINDEX, $iIndex, DllStructGetPtr($tGroup))
	EndIf
	Local $aGroup[3]
	$aGroup[0] = _WinAPI_WideCharToMultiByte(DllStructGetData($tGroup, "Header"))
	Select
		Case BitAND(DllStructGetData($tGroup, "Align"), $LVGA_HEADER_CENTER) <> 0
			$aGroup[1] = 1
		Case BitAND(DllStructGetData($tGroup, "Align"), $LVGA_HEADER_RIGHT) <> 0
			$aGroup[1] = 2
		Case Else
			$aGroup[1] = 0
	EndSelect
	$aGroup[2] = DllStructGetData($tGroup, "GroupID")
	Return SetError($iRet = 0, 0, $aGroup)
EndFunc   ;==>_GUICtrlListView_GetGroupInfoByIndex
Func _GUICtrlListView_GetGroupRect($hWnd, $iGroupID, $iGet = $LVGGR_GROUP)
	Local $tGroup = DllStructCreate($tagRECT)
	DllStructSetData($tGroup, "Top", $iGet)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPRECT, $iGroupID, $tGroup, 0, "wparam", "struct*")
		Else
			Local $iGroup = DllStructGetSize($tGroup)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup, $tMemMap)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			$iRet = _SendMessage($hWnd, $LVM_GETGROUPRECT, $iGroupID, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tGroup, $iGroup)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETGROUPRECT, $iGroupID, DllStructGetPtr($tGroup))
	EndIf
	Local $aGroup[4]
	For $x = 0 To 3
		$aGroup[$x] = DllStructGetData($tGroup, $x + 1)
	Next
	Return SetError($iRet = 0, 0, $aGroup)
EndFunc   ;==>_GUICtrlListView_GetGroupRect
Func _GUICtrlListView_GetGroupState($hWnd, $iGroupID, $iMask)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETGROUPSTATE, $iGroupID, $iMask)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETGROUPSTATE, $iGroupID, $iMask)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetGroupState
Func _GUICtrlListView_GetGroupViewEnabled($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ISGROUPVIEWENABLED) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ISGROUPVIEWENABLED, 0, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_GetGroupViewEnabled
Func _GUICtrlListView_GetHeader($hWnd)
	If IsHWnd($hWnd) Then
		Return HWnd(_SendMessage($hWnd, $LVM_GETHEADER))
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $LVM_GETHEADER, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetHeader
Func _GUICtrlListView_GetHotCursor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETHOTCURSOR, 0, 0, 0, "wparam", "lparam", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $LVM_GETHOTCURSOR, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetHotCursor
Func _GUICtrlListView_GetHotItem($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETHOTITEM)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETHOTITEM, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetHotItem
Func _GUICtrlListView_GetHoverTime($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETHOVERTIME)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETHOVERTIME, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetHoverTime
Func _GUICtrlListView_GetImageList($hWnd, $iImageList)
	Local $aImageList[3] = [$LVSIL_NORMAL, $LVSIL_SMALL, $LVSIL_STATE]
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETIMAGELIST, $aImageList[$iImageList], 0, 0, "wparam", "lparam", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $LVM_GETIMAGELIST, $aImageList[$iImageList], 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetImageList
Func _GUICtrlListView_GetInsertMark($hWnd)
	Local $tMark = DllStructCreate($tagLVINSERTMARK)
	Local $iMark = DllStructGetSize($tMark)
	DllStructSetData($tMark, "Size", $iMark)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETINSERTMARK, 0, $tMark, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iMark, $tMemMap)
			_MemWrite($tMemMap, $tMark)
			$iRet = _SendMessage($hWnd, $LVM_GETINSERTMARK, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tMark, $iMark)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETINSERTMARK, 0, DllStructGetPtr($tMark))
	EndIf
	Local $aMark[2]
	$aMark[0] = DllStructGetData($tMark, "Flags") = $LVIM_AFTER
	$aMark[1] = DllStructGetData($tMark, "Item")
	Return SetError($iRet = 0, 0, $aMark)
EndFunc   ;==>_GUICtrlListView_GetInsertMark
Func _GUICtrlListView_GetInsertMarkColor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETINSERTMARKCOLOR, $LVSIL_STATE)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETINSERTMARKCOLOR, $LVSIL_STATE, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetInsertMarkColor
Func _GUICtrlListView_GetInsertMarkRect($hWnd)
	Local $aRect[5]
	Local $tRECT = DllStructCreate($tagRECT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$aRect[0] = _SendMessage($hWnd, $LVM_GETINSERTMARKRECT, 0, $tRECT, 0, "wparam", "struct*") <> 0
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			$aRect[0] = _SendMessage($hWnd, $LVM_GETINSERTMARKRECT, 0, $pMemory, 0, "wparam", "ptr") <> 0
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		$aRect[0] = GUICtrlSendMsg($hWnd, $LVM_GETINSERTMARKRECT, 0, DllStructGetPtr($tRECT)) <> 0
	EndIf
	$aRect[1] = DllStructGetData($tRECT, "Left")
	$aRect[2] = DllStructGetData($tRECT, "Top")
	$aRect[3] = DllStructGetData($tRECT, "Right")
	$aRect[4] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListView_GetInsertMarkRect
Func _GUICtrlListView_GetISearchString($hWnd)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iBuffer
	If IsHWnd($hWnd) Then
		If $bUnicode Then
			$iBuffer = _SendMessage($hWnd, $LVM_GETISEARCHSTRINGW) + 1
		Else
			$iBuffer = _SendMessage($hWnd, $LVM_GETISEARCHSTRINGA) + 1
		EndIf
	Else
		If $bUnicode Then
			$iBuffer = GUICtrlSendMsg($hWnd, $LVM_GETISEARCHSTRINGW, 0, 0) + 1
		Else
			$iBuffer = GUICtrlSendMsg($hWnd, $LVM_GETISEARCHSTRINGA, 0, 0) + 1
		EndIf
	EndIf
	If $iBuffer = 1 Then Return ""
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETISEARCHSTRINGW, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			If $bUnicode Then
				_SendMessage($hWnd, $LVM_GETISEARCHSTRINGW, 0, $pMemory)
			Else
				_SendMessage($hWnd, $LVM_GETISEARCHSTRINGA, 0, $pMemory)
			EndIf
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pBuffer = DllStructGetPtr($tBuffer)
		If $bUnicode Then
			GUICtrlSendMsg($hWnd, $LVM_GETISEARCHSTRINGW, 0, $pBuffer)
		Else
			GUICtrlSendMsg($hWnd, $LVM_GETISEARCHSTRINGA, 0, $pBuffer)
		EndIf
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlListView_GetISearchString
Func _GUICtrlListView_GetItem($hWnd, $iIndex, $iSubItem = 0)
	Local $aItem[8]
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", BitOR($LVIF_GROUPID, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_STATE))
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "StateMask", -1)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Local $iState = DllStructGetData($tItem, "State")
	If BitAND($iState, $LVIS_CUT) <> 0 Then $aItem[0] = BitOR($aItem[0], 1)
	If BitAND($iState, $LVIS_DROPHILITED) <> 0 Then $aItem[0] = BitOR($aItem[0], 2)
	If BitAND($iState, $LVIS_FOCUSED) <> 0 Then $aItem[0] = BitOR($aItem[0], 4)
	If BitAND($iState, $LVIS_SELECTED) <> 0 Then $aItem[0] = BitOR($aItem[0], 8)
	$aItem[1] = __GUICtrlListView_OverlayImageMaskToIndex($iState)
	$aItem[2] = __GUICtrlListView_StateImageMaskToIndex($iState)
	$aItem[3] = _GUICtrlListView_GetItemText($hWnd, $iIndex, $iSubItem)
	$aItem[4] = DllStructGetData($tItem, "Image")
	$aItem[5] = DllStructGetData($tItem, "Param")
	$aItem[6] = DllStructGetData($tItem, "Indent")
	$aItem[7] = DllStructGetData($tItem, "GroupID")
	Return $aItem
EndFunc   ;==>_GUICtrlListView_GetItem
Func _GUICtrlListView_GetItemChecked($hWnd, $iIndex)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $tLVITEM = DllStructCreate($tagLVITEM)
	Local $iSize = DllStructGetSize($tLVITEM)
	If @error Then Return SetError($LV_ERR, $LV_ERR, False)
	DllStructSetData($tLVITEM, "Mask", $LVIF_STATE)
	DllStructSetData($tLVITEM, "Item", $iIndex)
	DllStructSetData($tLVITEM, "StateMask", 0xffff)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $tLVITEM, 0, "wparam", "struct*") <> 0
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iSize, $tMemMap)
			_MemWrite($tMemMap, $tLVITEM)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr") <> 0
			Else
				$iRet = _SendMessage($hWnd, $LVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr") <> 0
			EndIf
			_MemRead($tMemMap, $pMemory, $tLVITEM, $iSize)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tLVITEM)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMW, 0, $pItem) <> 0
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMA, 0, $pItem) <> 0
		EndIf
	EndIf
	If Not $iRet Then Return SetError($LV_ERR, $LV_ERR, False)
	Return BitAND(DllStructGetData($tLVITEM, "State"), 0x2000) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemChecked
Func _GUICtrlListView_GetItemCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETITEMCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETITEMCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemCount
Func _GUICtrlListView_GetItemCut($hWnd, $iIndex)
	Return _GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_CUT) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemCut
Func _GUICtrlListView_GetItemDropHilited($hWnd, $iIndex)
	Return _GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_DROPHILITED) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemDropHilited
Func _GUICtrlListView_GetItemEx($hWnd, ByRef $tItem)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem, $tMemMap)
			_MemWrite($tMemMap, $tItem)
			If $bUnicode Then
				_SendMessage($hWnd, $LVM_GETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				_SendMessage($hWnd, $LVM_GETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tItem, $iItem)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_GetItemEx
Func _GUICtrlListView_GetItemFocused($hWnd, $iIndex)
	Return _GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_FOCUSED) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemFocused
Func _GUICtrlListView_GetItemGroupID($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_GROUPID)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "GroupID")
EndFunc   ;==>_GUICtrlListView_GetItemGroupID
Func _GUICtrlListView_GetItemImage($hWnd, $iIndex, $iSubItem = 0)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_IMAGE)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Image")
EndFunc   ;==>_GUICtrlListView_GetItemImage
Func _GUICtrlListView_GetItemIndent($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_INDENT)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Indent")
EndFunc   ;==>_GUICtrlListView_GetItemIndent
Func __GUICtrlListView_GetItemOverlayImage($hWnd, $iIndex)
	Return BitShift(_GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_OVERLAYMASK), 8)
EndFunc   ;==>__GUICtrlListView_GetItemOverlayImage
Func _GUICtrlListView_GetItemParam($hWnd, $iIndex)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_PARAM)
	DllStructSetData($tItem, "Item", $iIndex)
	_GUICtrlListView_GetItemEx($hWnd, $tItem)
	Return DllStructGetData($tItem, "Param")
EndFunc   ;==>_GUICtrlListView_GetItemParam
Func _GUICtrlListView_GetItemPosition($hWnd, $iIndex)
	Local $aPoint[2], $iRet
	Local $tPoint = DllStructCreate($tagPOINT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			If Not _SendMessage($hWnd, $LVM_GETITEMPOSITION, $iIndex, $tPoint, 0, "wparam", "struct*") Then Return $aPoint
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
			If Not _SendMessage($hWnd, $LVM_GETITEMPOSITION, $iIndex, $pMemory, 0, "wparam", "ptr") Then Return $aPoint
			_MemRead($tMemMap, $pMemory, $tPoint, $iPoint)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMPOSITION, $iIndex, DllStructGetPtr($tPoint))
		If Not $iRet Then Return $aPoint
	EndIf
	$aPoint[0] = DllStructGetData($tPoint, "X")
	$aPoint[1] = DllStructGetData($tPoint, "Y")
	Return $aPoint
EndFunc   ;==>_GUICtrlListView_GetItemPosition
Func _GUICtrlListView_GetItemPositionX($hWnd, $iIndex)
	Local $aPoint = _GUICtrlListView_GetItemPosition($hWnd, $iIndex)
	Return $aPoint[0]
EndFunc   ;==>_GUICtrlListView_GetItemPositionX
Func _GUICtrlListView_GetItemPositionY($hWnd, $iIndex)
	Local $aPoint = _GUICtrlListView_GetItemPosition($hWnd, $iIndex)
	Return $aPoint[1]
EndFunc   ;==>_GUICtrlListView_GetItemPositionY
Func _GUICtrlListView_GetItemRect($hWnd, $iIndex, $iPart = 3)
	Local $tRECT = _GUICtrlListView_GetItemRectEx($hWnd, $iIndex, $iPart)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListView_GetItemRect
Func _GUICtrlListView_GetItemRectEx($hWnd, $iIndex, $iPart = 3)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $iPart)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETITEMRECT, $iIndex, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $tRECT, $pMemory, $iRect)
			_SendMessage($hWnd, $LVM_GETITEMRECT, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETITEMRECT, $iIndex, DllStructGetPtr($tRECT))
	EndIf
	Return $tRECT
EndFunc   ;==>_GUICtrlListView_GetItemRectEx
Func _GUICtrlListView_GetItemSelected($hWnd, $iIndex)
	Return _GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_SELECTED) <> 0
EndFunc   ;==>_GUICtrlListView_GetItemSelected
Func _GUICtrlListView_GetItemSpacing($hWnd, $bSmall = False)
	Local $iSpace
	If IsHWnd($hWnd) Then
		$iSpace = _SendMessage($hWnd, $LVM_GETITEMSPACING, $bSmall)
	Else
		$iSpace = GUICtrlSendMsg($hWnd, $LVM_GETITEMSPACING, $bSmall, 0)
	EndIf
	Local $aSpace[2]
	$aSpace[0] = BitAND($iSpace, 0xFFFF)
	$aSpace[1] = BitShift($iSpace, 16)
	Return $aSpace
EndFunc   ;==>_GUICtrlListView_GetItemSpacing
Func _GUICtrlListView_GetItemSpacingX($hWnd, $bSmall = False)
	If IsHWnd($hWnd) Then
		Return BitAND(_SendMessage($hWnd, $LVM_GETITEMSPACING, $bSmall, 0), 0xFFFF)
	Else
		Return BitAND(GUICtrlSendMsg($hWnd, $LVM_GETITEMSPACING, $bSmall, 0), 0xFFFF)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemSpacingX
Func _GUICtrlListView_GetItemSpacingY($hWnd, $bSmall = False)
	If IsHWnd($hWnd) Then
		Return BitShift(_SendMessage($hWnd, $LVM_GETITEMSPACING, $bSmall, 0), 16)
	Else
		Return BitShift(GUICtrlSendMsg($hWnd, $LVM_GETITEMSPACING, $bSmall, 0), 16)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemSpacingY
Func _GUICtrlListView_GetItemState($hWnd, $iIndex, $iMask)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETITEMSTATE, $iIndex, $iMask)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETITEMSTATE, $iIndex, $iMask)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetItemState
Func _GUICtrlListView_GetItemStateImage($hWnd, $iIndex)
	Return BitShift(_GUICtrlListView_GetItemState($hWnd, $iIndex, $LVIS_STATEIMAGEMASK), 12)
EndFunc   ;==>_GUICtrlListView_GetItemStateImage
Func _GUICtrlListView_GetItemText($hWnd, $iIndex, $iSubItem = 0)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[4096]")
	Else
		$tBuffer = DllStructCreate("char Text[4096]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "TextMax", 4096)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			_SendMessage($hWnd, $LVM_GETITEMTEXTW, $iIndex, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + 4096, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			If $bUnicode Then
				_SendMessage($hWnd, $LVM_GETITEMTEXTW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				_SendMessage($hWnd, $LVM_GETITEMTEXTA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pText, $tBuffer, 4096)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		DllStructSetData($tItem, "Text", $pBuffer)
		If $bUnicode Then
			GUICtrlSendMsg($hWnd, $LVM_GETITEMTEXTW, $iIndex, $pItem)
		Else
			GUICtrlSendMsg($hWnd, $LVM_GETITEMTEXTA, $iIndex, $pItem)
		EndIf
	EndIf
	Return DllStructGetData($tBuffer, "Text")
EndFunc   ;==>_GUICtrlListView_GetItemText
Func _GUICtrlListView_GetItemTextArray($hWnd, $iItem = -1)
	Local $sItems = _GUICtrlListView_GetItemTextString($hWnd, $iItem)
	If $sItems = "" Then
		Local $aItems[1] = [0]
		Return SetError($LV_ERR, $LV_ERR, $aItems)
	EndIf
	Return StringSplit($sItems, Opt('GUIDataSeparatorChar'))
EndFunc   ;==>_GUICtrlListView_GetItemTextArray
Func _GUICtrlListView_GetItemTextString($hWnd, $iItem = -1)
	Local $sRow = "", $sSeparatorChar = Opt('GUIDataSeparatorChar'), $iSelected
	If $iItem = -1 Then
		$iSelected = _GUICtrlListView_GetNextItem($hWnd) ; get current row selected
	Else
		$iSelected = $iItem ; get row
	EndIf
	For $x = 0 To _GUICtrlListView_GetColumnCount($hWnd) - 1
		$sRow &= _GUICtrlListView_GetItemText($hWnd, $iSelected, $x) & $sSeparatorChar
	Next
	Return StringTrimRight($sRow, 1)
EndFunc   ;==>_GUICtrlListView_GetItemTextString
Func _GUICtrlListView_GetNextItem($hWnd, $iStart = -1, $iSearch = 0, $iState = 8)
	Local $aSearch[5] = [$LVNI_ALL, $LVNI_ABOVE, $LVNI_BELOW, $LVNI_TOLEFT, $LVNI_TORIGHT]
	Local $iFlags = $aSearch[$iSearch]
	If BitAND($iState, 1) <> 0 Then $iFlags = BitOR($iFlags, $LVNI_CUT)
	If BitAND($iState, 2) <> 0 Then $iFlags = BitOR($iFlags, $LVNI_DROPHILITED)
	If BitAND($iState, 4) <> 0 Then $iFlags = BitOR($iFlags, $LVNI_FOCUSED)
	If BitAND($iState, 8) <> 0 Then $iFlags = BitOR($iFlags, $LVNI_SELECTED)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETNEXTITEM, $iStart, $iFlags)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETNEXTITEM, $iStart, $iFlags)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetNextItem
Func _GUICtrlListView_GetNumberOfWorkAreas($hWnd)
	Local $tBuffer = DllStructCreate("int Data")
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETNUMBEROFWORKAREAS, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_SendMessage($hWnd, $LVM_GETNUMBEROFWORKAREAS, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETNUMBEROFWORKAREAS, 0, DllStructGetPtr($tBuffer))
	EndIf
	Return DllStructGetData($tBuffer, "Data")
EndFunc   ;==>_GUICtrlListView_GetNumberOfWorkAreas
Func _GUICtrlListView_GetOrigin($hWnd)
	Local $tPoint = DllStructCreate($tagPOINT)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETORIGIN, 0, $tPoint, 0, "wparam", "struct*")
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
			$iRet = _SendMessage($hWnd, $LVM_GETORIGIN, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tPoint, $iPoint)
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_GETORIGIN, 0, DllStructGetPtr($tPoint))
	EndIf
	Local $aOrigin[2]
	$aOrigin[0] = DllStructGetData($tPoint, "X")
	$aOrigin[1] = DllStructGetData($tPoint, "Y")
	Return SetError(@error, $iRet = 1, $aOrigin)
EndFunc   ;==>_GUICtrlListView_GetOrigin
Func _GUICtrlListView_GetOriginX($hWnd)
	Local $aOrigin = _GUICtrlListView_GetOrigin($hWnd)
	Return $aOrigin[0]
EndFunc   ;==>_GUICtrlListView_GetOriginX
Func _GUICtrlListView_GetOriginY($hWnd)
	Local $aOrigin = _GUICtrlListView_GetOrigin($hWnd)
	Return $aOrigin[1]
EndFunc   ;==>_GUICtrlListView_GetOriginY
Func _GUICtrlListView_GetOutlineColor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETOUTLINECOLOR)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETOUTLINECOLOR, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetOutlineColor
Func _GUICtrlListView_GetSelectedColumn($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETSELECTEDCOLUMN)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETSELECTEDCOLUMN, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetSelectedColumn
Func _GUICtrlListView_GetSelectedCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETSELECTEDCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETSELECTEDCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetSelectedCount
Func __GUICtrlListView_GetCheckedIndices($hWnd)
	Local $iCount = _GUICtrlListView_GetItemCount($hWnd)
	Local $aSelected[$iCount + 1] = [0]
	For $i = 0 To $iCount - 1
		If _GUICtrlListView_GetItemChecked($hWnd, $i) Then
			$aSelected[0] += 1
			$aSelected[$aSelected[0]] = $i
		EndIf
	Next
	ReDim $aSelected[$aSelected[0] + 1]
	Return $aSelected
EndFunc   ;==>__GUICtrlListView_GetCheckedIndices
Func _GUICtrlListView_GetSelectedIndices($hWnd, $bArray = False)
	Local $sIndices, $aIndices[1] = [0]
	Local $iRet, $iCount = _GUICtrlListView_GetItemCount($hWnd)
	For $iItem = 0 To $iCount
		If IsHWnd($hWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETITEMSTATE, $iItem, $LVIS_SELECTED)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETITEMSTATE, $iItem, $LVIS_SELECTED)
		EndIf
		If $iRet Then
			If (Not $bArray) Then
				If StringLen($sIndices) Then
					$sIndices &= "|" & $iItem
				Else
					$sIndices = $iItem
				EndIf
			Else
				ReDim $aIndices[UBound($aIndices) + 1]
				$aIndices[0] = UBound($aIndices) - 1
				$aIndices[UBound($aIndices) - 1] = $iItem
			EndIf
		EndIf
	Next
	If (Not $bArray) Then
		Return String($sIndices)
	Else
		Return $aIndices
	EndIf
EndFunc   ;==>_GUICtrlListView_GetSelectedIndices
Func _GUICtrlListView_GetSelectionMark($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETSELECTIONMARK)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETSELECTIONMARK, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetSelectionMark
Func _GUICtrlListView_GetStringWidth($hWnd, $sString)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iBuffer = StringLen($sString) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tBuffer, "Text", $sString)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_GETSTRINGWIDTHW, 0, $tBuffer, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_MemWrite($tMemMap, $tBuffer, $pMemory, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_GETSTRINGWIDTHW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_GETSTRINGWIDTHA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemRead($tMemMap, $pMemory, $tBuffer, $iBuffer)
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pBuffer = DllStructGetPtr($tBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETSTRINGWIDTHW, 0, $pBuffer)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_GETSTRINGWIDTHA, 0, $pBuffer)
		EndIf
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_GetStringWidth
Func _GUICtrlListView_GetSubItemRect($hWnd, $iIndex, $iSubItem, $iPart = 0)
	Local $aPart[2] = [$LVIR_BOUNDS, $LVIR_ICON]
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Top", $iSubItem)
	DllStructSetData($tRECT, "Left", $aPart[$iPart])
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETSUBITEMRECT, $iIndex, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $tRECT, $pMemory, $iRect)
			_SendMessage($hWnd, $LVM_GETSUBITEMRECT, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETSUBITEMRECT, $iIndex, DllStructGetPtr($tRECT))
	EndIf
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListView_GetSubItemRect
Func _GUICtrlListView_GetTextBkColor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETTEXTBKCOLOR)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETTEXTBKCOLOR, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetTextBkColor
Func _GUICtrlListView_GetTextColor($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETTEXTCOLOR)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETTEXTCOLOR, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetTextColor
Func _GUICtrlListView_GetToolTips($hWnd)
	If IsHWnd($hWnd) Then
		Return HWnd(_SendMessage($hWnd, $LVM_GETTOOLTIPS))
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $LVM_GETTOOLTIPS, 0, 0))
	EndIf
EndFunc   ;==>_GUICtrlListView_GetToolTips
Func _GUICtrlListView_GetTopIndex($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETTOPINDEX)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETTOPINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_GetTopIndex
Func _GUICtrlListView_GetUnicodeFormat($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_GETUNICODEFORMAT) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_GETUNICODEFORMAT, 0, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_GetUnicodeFormat
Func _GUICtrlListView_GetView($hWnd)
	Local $iView
	If IsHWnd($hWnd) Then
		$iView = _SendMessage($hWnd, $LVM_GETVIEW)
	Else
		$iView = GUICtrlSendMsg($hWnd, $LVM_GETVIEW, 0, 0)
	EndIf
	Switch $iView
		Case $LV_VIEW_ICON
			Return Int($LV_VIEW_ICON)
		Case $LV_VIEW_DETAILS
			Return Int($LV_VIEW_DETAILS)
		Case $LV_VIEW_LIST
			Return Int($LV_VIEW_LIST)
		Case $LV_VIEW_SMALLICON
			Return Int($LV_VIEW_SMALLICON)
		Case $LV_VIEW_TILE
			Return Int($LV_VIEW_TILE)
		Case Else
			Return -1
	EndSwitch
EndFunc   ;==>_GUICtrlListView_GetView
Func _GUICtrlListView_GetViewDetails($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_DETAILS
EndFunc   ;==>_GUICtrlListView_GetViewDetails
Func _GUICtrlListView_GetViewLarge($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_ICON
EndFunc   ;==>_GUICtrlListView_GetViewLarge
Func _GUICtrlListView_GetViewList($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_LIST
EndFunc   ;==>_GUICtrlListView_GetViewList
Func _GUICtrlListView_GetViewSmall($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_SMALLICON
EndFunc   ;==>_GUICtrlListView_GetViewSmall
Func _GUICtrlListView_GetViewTile($hWnd)
	Return _GUICtrlListView_GetView($hWnd) = $LV_VIEW_TILE
EndFunc   ;==>_GUICtrlListView_GetViewTile
Func _GUICtrlListView_GetViewRect($hWnd)
	Local $aRect[4] = [0, 0, 0, 0]
	Local $iView = _GUICtrlListView_GetView($hWnd)
	If ($iView <> 1) And ($iView <> 3) Then Return $aRect
	Local $tRECT = DllStructCreate($tagRECT)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_GETVIEWRECT, 0, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_SendMessage($hWnd, $LVM_GETVIEWRECT, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tRECT, $iRect)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_GETVIEWRECT, 0, DllStructGetPtr($tRECT))
	EndIf
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlListView_GetViewRect
Func _GUICtrlListView_HideColumn($hWnd, $iCol)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETCOLUMNWIDTH, $iCol) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_HideColumn
Func _GUICtrlListView_HitTest($hWnd, $iX = -1, $iY = -1)
	Local $aTest[10]
	Local $iMode = Opt("MouseCoordMode", 1)
	Local $aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	Local $aResult = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] = 0 Then Return 0
	If $iX = -1 Then $iX = DllStructGetData($tPoint, "X")
	If $iY = -1 Then $iY = DllStructGetData($tPoint, "Y")
	Local $tTest = DllStructCreate($tagLVHITTESTINFO)
	DllStructSetData($tTest, "X", $iX)
	DllStructSetData($tTest, "Y", $iY)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$aTest[0] = _SendMessage($hWnd, $LVM_HITTEST, 0, $tTest, 0, "wparam", "struct*")
		Else
			Local $iTest = DllStructGetSize($tTest)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iTest, $tMemMap)
			_MemWrite($tMemMap, $tTest, $pMemory, $iTest)
			$aTest[0] = _SendMessage($hWnd, $LVM_HITTEST, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tTest, $iTest)
			_MemFree($tMemMap)
		EndIf
	Else
		$aTest[0] = GUICtrlSendMsg($hWnd, $LVM_HITTEST, 0, DllStructGetPtr($tTest))
	EndIf
	Local $iFlags = DllStructGetData($tTest, "Flags")
	$aTest[1] = BitAND($iFlags, $LVHT_NOWHERE) <> 0
	$aTest[2] = BitAND($iFlags, $LVHT_ONITEMICON) <> 0
	$aTest[3] = BitAND($iFlags, $LVHT_ONITEMLABEL) <> 0
	$aTest[4] = BitAND($iFlags, $LVHT_ONITEMSTATEICON) <> 0
	$aTest[5] = BitAND($iFlags, $LVHT_ONITEM) <> 0
	$aTest[6] = BitAND($iFlags, $LVHT_ABOVE) <> 0
	$aTest[7] = BitAND($iFlags, $LVHT_BELOW) <> 0
	$aTest[8] = BitAND($iFlags, $LVHT_TOLEFT) <> 0
	$aTest[9] = BitAND($iFlags, $LVHT_TORIGHT) <> 0
	Return $aTest
EndFunc   ;==>_GUICtrlListView_HitTest
Func __GUICtrlListView_IndexToOverlayImageMask($iIndex)
	Return BitShift($iIndex, -8)
EndFunc   ;==>__GUICtrlListView_IndexToOverlayImageMask
Func __GUICtrlListView_IndexToStateImageMask($iIndex)
	Return BitShift($iIndex, -12)
EndFunc   ;==>__GUICtrlListView_IndexToStateImageMask
Func _GUICtrlListView_InsertColumn($hWnd, $iIndex, $sText, $iWidth = 50, $iAlign = -1, $iImage = -1, $bOnRight = False)
	Local $aAlign[3] = [$LVCFMT_LEFT, $LVCFMT_RIGHT, $LVCFMT_CENTER]
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	Local $iMask = BitOR($LVCF_FMT, $LVCF_WIDTH, $LVCF_TEXT)
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	Local $iFmt = $aAlign[$iAlign]
	If $iImage <> -1 Then
		$iMask = BitOR($iMask, $LVCF_IMAGE)
		$iFmt = BitOR($iFmt, $LVCFMT_COL_HAS_IMAGES, $LVCFMT_IMAGE)
	EndIf
	If $bOnRight Then $iFmt = BitOR($iFmt, $LVCFMT_BITMAP_ON_RIGHT)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tColumn, "Mask", $iMask)
	DllStructSetData($tColumn, "Fmt", $iFmt)
	DllStructSetData($tColumn, "CX", $iWidth)
	DllStructSetData($tColumn, "TextMax", $iBuffer)
	DllStructSetData($tColumn, "Image", $iImage)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tColumn, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_INSERTCOLUMNW, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iColumn
			DllStructSetData($tColumn, "Text", $pText)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_INSERTCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_INSERTCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		DllStructSetData($tColumn, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	If $iAlign > 0 Then _GUICtrlListView_SetColumn($hWnd, $iRet, $sText, $iWidth, $iAlign, $iImage, $bOnRight)
	Return $iRet
EndFunc   ;==>_GUICtrlListView_InsertColumn
Func _GUICtrlListView_InsertGroup($hWnd, $iIndex, $iGroupID, $sHeader, $iAlign = 0)
	Local $aAlign[3] = [$LVGA_HEADER_LEFT, $LVGA_HEADER_CENTER, $LVGA_HEADER_RIGHT]
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	Local $tHeader = _WinAPI_MultiByteToWideChar($sHeader)
	Local $pHeader = DllStructGetPtr($tHeader)
	Local $iHeader = StringLen($sHeader)
	Local $tGroup = DllStructCreate($tagLVGROUP)
	Local $iGroup = DllStructGetSize($tGroup)
	Local $iMask = BitOR($LVGF_HEADER, $LVGF_ALIGN, $LVGF_GROUPID)
	DllStructSetData($tGroup, "Size", $iGroup)
	DllStructSetData($tGroup, "Mask", $iMask)
	DllStructSetData($tGroup, "HeaderMax", $iHeader)
	DllStructSetData($tGroup, "GroupID", $iGroupID)
	DllStructSetData($tGroup, "Align", $aAlign[$iAlign])
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tGroup, "Header", $pHeader)
			$iRet = _SendMessage($hWnd, $LVM_INSERTGROUP, $iIndex, $tGroup, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup + $iHeader, $tMemMap)
			Local $pText = $pMemory + $iGroup
			DllStructSetData($tGroup, "Header", $pText)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			_MemWrite($tMemMap, $tHeader, $pText, $iHeader)
			$iRet = _SendMessage($hWnd, $LVM_INSERTGROUP, $iIndex, $tGroup, 0, "wparam", "struct*")
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tGroup, "Header", $pHeader)
		$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTGROUP, $iIndex, DllStructGetPtr($tGroup))
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_InsertGroup
Func _GUICtrlListView_InsertItem($hWnd, $sText, $iIndex = -1, $iImage = -1, $iParam = 0)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iBuffer, $tBuffer, $iRet
	If $iIndex = -1 Then $iIndex = 999999999
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Param", $iParam)
	$iBuffer = StringLen($sText) + 1
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Text", DllStructGetPtr($tBuffer))
	DllStructSetData($tItem, "TextMax", $iBuffer)
	Local $iMask = BitOR($LVIF_TEXT, $LVIF_PARAM)
	If $iImage >= 0 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Image", $iImage)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Or ($sText = -1) Then
			$iRet = _SendMessage($hWnd, $LVM_INSERTITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_INSERTITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_INSERTITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_INSERTITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_InsertItem
Func _GUICtrlListView_InsertMarkHitTest($hWnd, $iX = -1, $iY = -1)
	Local $iMode = Opt("MouseCoordMode", 1)
	Local $aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	Local $aResult = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $hWnd, "struct*", $tPoint)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] = 0 Then Return 0
	If $iX = -1 Then $iX = DllStructGetData($tPoint, "X")
	If $iY = -1 Then $iY = DllStructGetData($tPoint, "Y")
	Local $tMark = DllStructCreate($tagLVINSERTMARK)
	Local $iMark = DllStructGetSize($tMark)
	DllStructSetData($tPoint, "X", $iX)
	DllStructSetData($tPoint, "Y", $iY)
	DllStructSetData($tMark, "Size", $iMark)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_INSERTMARKHITTEST, $tPoint, $tMark, 0, "struct*", "struct*")
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemM = _MemInit($hWnd, $iPoint + $iMark, $tMemMap)
			Local $pMemP = $pMemM + $iPoint ; BUG ??? was referencing $pMemP
			_MemWrite($tMemMap, $tMark, $pMemM, $iMark)
			_MemWrite($tMemMap, $tPoint, $pMemP, $iPoint)
			_SendMessage($hWnd, $LVM_INSERTMARKHITTEST, $pMemP, $pMemM, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemM, $tMark, $iMark)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_INSERTMARKHITTEST, DllStructGetPtr($tPoint), DllStructGetPtr($tMark))
	EndIf
	Local $aTest[2]
	$aTest[0] = DllStructGetData($tMark, "Flags") = $LVIM_AFTER
	$aTest[1] = DllStructGetData($tMark, "Item")
	Return $aTest
EndFunc   ;==>_GUICtrlListView_InsertMarkHitTest
Func _GUICtrlListView_IsItemVisible($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_ISITEMVISIBLE, $iIndex) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_ISITEMVISIBLE, $iIndex, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_IsItemVisible
Func _GUICtrlListView_JustifyColumn($hWnd, $iIndex, $iAlign = -1)
	Local $aAlign[3] = [$LVCFMT_LEFT, $LVCFMT_RIGHT, $LVCFMT_CENTER]
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	Local $iMask = $LVCF_FMT
	Local $iFmt = $aAlign[$iAlign]
	DllStructSetData($tColumn, "Mask", $iMask)
	DllStructSetData($tColumn, "Fmt", $iFmt)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn, $tMemMap)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_JustifyColumn
Func _GUICtrlListView_MapIDToIndex($hWnd, $iID)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_MAPIDTOINDEX, $iID)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_MAPIDTOINDEX, $iID, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_MapIDToIndex
Func _GUICtrlListView_MapIndexToID($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_MAPINDEXTOID, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_MAPINDEXTOID, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_MapIndexToID
Func _GUICtrlListView_MoveGroup($hWnd, $iGroupID, $iIndex = -1)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_MOVEGROUP, $iGroupID, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_MOVEGROUP, $iGroupID, $iIndex)
	EndIf
EndFunc   ;==>_GUICtrlListView_MoveGroup
Func __GUICtrlListView_OverlayImageMaskToIndex($iMask)
	Return BitShift(BitAND($LVIS_OVERLAYMASK, $iMask), 8)
EndFunc   ;==>__GUICtrlListView_OverlayImageMaskToIndex
Func _GUICtrlListView_RedrawItems($hWnd, $iFirst, $iLast)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_REDRAWITEMS, $iFirst, $iLast) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_REDRAWITEMS, $iFirst, $iLast) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_RedrawItems
Func _GUICtrlListView_RegisterSortCallBack($hWnd, $vCompareType = 1, $bArrows = True, $sPrivateCallback = "__GUICtrlListView_Sort")
	#Au3Stripper_Ignore_Funcs=$sPrivateCallback
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If IsBool($vCompareType) Then $vCompareType = ($vCompareType) ? 1 : 0
	Local $hHeader = _GUICtrlListView_GetHeader($hWnd)
	ReDim $__g_aListViewSortInfo[UBound($__g_aListViewSortInfo) + 1][$__LISTVIEWCONSTANT_SORTINFOSIZE]
	$__g_aListViewSortInfo[0][0] = UBound($__g_aListViewSortInfo) - 1
	Local $iIndex = $__g_aListViewSortInfo[0][0]
	$__g_aListViewSortInfo[$iIndex][1] = $hWnd ; Handle/ID of listview
	$__g_aListViewSortInfo[$iIndex][2] = _
			DllCallbackRegister($sPrivateCallback, "int", "int;int;hwnd") ; Handle of callback
	$__g_aListViewSortInfo[$iIndex][3] = -1 ; $nColumn
	$__g_aListViewSortInfo[$iIndex][4] = -1 ; nCurCol
	$__g_aListViewSortInfo[$iIndex][5] = 1 ; $nSortDir
	$__g_aListViewSortInfo[$iIndex][6] = -1 ; $nCol
	$__g_aListViewSortInfo[$iIndex][7] = 0 ; $bSet
	$__g_aListViewSortInfo[$iIndex][8] = $vCompareType ; Treat as Strings, Numbers or use Windows API to compare
	$__g_aListViewSortInfo[$iIndex][9] = $bArrows ; Use arrows in the header of the columns?
	$__g_aListViewSortInfo[$iIndex][10] = $hHeader ; Handle to the Header
	Return $__g_aListViewSortInfo[$iIndex][2] <> 0
EndFunc   ;==>_GUICtrlListView_RegisterSortCallBack
Func _GUICtrlListView_RemoveAllGroups($hWnd)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LVM_REMOVEALLGROUPS)
	Else
		GUICtrlSendMsg($hWnd, $LVM_REMOVEALLGROUPS, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_RemoveAllGroups
Func _GUICtrlListView_RemoveGroup($hWnd, $iGroupID)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_REMOVEGROUP, $iGroupID)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_REMOVEGROUP, $iGroupID, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_RemoveGroup
Func __GUICtrlListView_ReverseColorOrder($iColor)
	Local $sH = Hex(String($iColor), 6)
	Return '0x' & StringMid($sH, 5, 2) & StringMid($sH, 3, 2) & StringMid($sH, 1, 2)
EndFunc   ;==>__GUICtrlListView_ReverseColorOrder
Func _GUICtrlListView_Scroll($hWnd, $iDX, $iDY)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SCROLL, $iDX, $iDY) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SCROLL, $iDX, $iDY) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_Scroll
Func _GUICtrlListView_SetBkColor($hWnd, $iColor)
	Local $iRet
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETBKCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETBKCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetBkColor
Func _GUICtrlListView_SetBkImage($hWnd, $sURL = "", $iStyle = 0, $iXOffset = 0, $iYOffset = 0)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	If Not IsHWnd($hWnd) Then Return SetError($LV_ERR, $LV_ERR, False)
	Local $aStyle[2] = [$LVBKIF_STYLE_NORMAL, $LVBKIF_STYLE_TILE]
	Local $iBuffer = StringLen($sURL) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tImage = DllStructCreate($tagLVBKIMAGE)
	Local $iRet = 0
	If $sURL <> "" Then $iRet = $LVBKIF_SOURCE_URL
	$iRet = BitOR($iRet, $aStyle[$iStyle])
	DllStructSetData($tBuffer, "Text", $sURL)
	DllStructSetData($tImage, "Flags", $iRet)
	DllStructSetData($tImage, "XOffPercent", $iXOffset)
	DllStructSetData($tImage, "YOffPercent", $iYOffset)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tImage, "Image", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETBKIMAGEW, 0, $tImage, 0, "wparam", "struct*")
		Else
			Local $iImage = DllStructGetSize($tImage)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iImage + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iImage
			DllStructSetData($tImage, "Image", $pText)
			_MemWrite($tMemMap, $tImage, $pMemory, $iImage)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETBKIMAGEW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETBKIMAGEA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pImage = DllStructGetPtr($tImage)
		DllStructSetData($tImage, "Image", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETBKIMAGEW, 0, $pImage)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETBKIMAGEA, 0, $pImage)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetBkImage
Func _GUICtrlListView_SetCallBackMask($hWnd, $iMask)
	Local $iFlags = 0
	If BitAND($iMask, 1) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_CUT)
	If BitAND($iMask, 2) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_DROPHILITED)
	If BitAND($iMask, 4) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_FOCUSED)
	If BitAND($iMask, 8) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_SELECTED)
	If BitAND($iMask, 16) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_OVERLAYMASK)
	If BitAND($iMask, 32) <> 0 Then $iFlags = BitOR($iFlags, $LVIS_STATEIMAGEMASK)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETCALLBACKMASK, $iFlags) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETCALLBACKMASK, $iFlags, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetCallBackMask
Func _GUICtrlListView_SetColumn($hWnd, $iIndex, $sText, $iWidth = -1, $iAlign = -1, $iImage = -1, $bOnRight = False)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $aAlign[3] = [$LVCFMT_LEFT, $LVCFMT_RIGHT, $LVCFMT_CENTER]
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tColumn = DllStructCreate($tagLVCOLUMN)
	Local $iMask = $LVCF_TEXT
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	$iMask = BitOR($iMask, $LVCF_FMT)
	Local $iFmt = $aAlign[$iAlign]
	If $iWidth <> -1 Then $iMask = BitOR($iMask, $LVCF_WIDTH)
	If $iImage <> -1 Then
		$iMask = BitOR($iMask, $LVCF_IMAGE)
		$iFmt = BitOR($iFmt, $LVCFMT_COL_HAS_IMAGES, $LVCFMT_IMAGE)
	Else
		$iImage = 0
	EndIf
	If $bOnRight Then $iFmt = BitOR($iFmt, $LVCFMT_BITMAP_ON_RIGHT)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tColumn, "Mask", $iMask)
	DllStructSetData($tColumn, "Fmt", $iFmt)
	DllStructSetData($tColumn, "CX", $iWidth)
	DllStructSetData($tColumn, "TextMax", $iBuffer)
	DllStructSetData($tColumn, "Image", $iImage)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tColumn, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $tColumn, 0, "wparam", "struct*")
		Else
			Local $iColumn = DllStructGetSize($tColumn)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iColumn + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iColumn
			DllStructSetData($tColumn, "Text", $pText)
			_MemWrite($tMemMap, $tColumn, $pMemory, $iColumn)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNW, $iIndex, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNA, $iIndex, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pColumn = DllStructGetPtr($tColumn)
		DllStructSetData($tColumn, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNW, $iIndex, $pColumn)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNA, $iIndex, $pColumn)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetColumn
Func _GUICtrlListView_SetColumnOrder($hWnd, $sOrder)
	Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
	Return _GUICtrlListView_SetColumnOrderArray($hWnd, StringSplit($sOrder, $sSeparatorChar))
EndFunc   ;==>_GUICtrlListView_SetColumnOrder
Func _GUICtrlListView_SetColumnOrderArray($hWnd, $aOrder)
	Local $tBuffer = DllStructCreate("int[" & $aOrder[0] & "]")
	For $iI = 1 To $aOrder[0]
		DllStructSetData($tBuffer, 1, $aOrder[$iI], $iI)
	Next
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNORDERARRAY, $aOrder[0], $tBuffer, 0, "wparam", "struct*")
		Else
			Local $iBuffer = DllStructGetSize($tBuffer)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iBuffer, $tMemMap)
			_MemWrite($tMemMap, $tBuffer, $pMemory, $iBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETCOLUMNORDERARRAY, $aOrder[0], $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNORDERARRAY, $aOrder[0], DllStructGetPtr($tBuffer))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetColumnOrderArray
Func _GUICtrlListView_SetColumnWidth($hWnd, $iCol, $iWidth)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, $iWidth)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETCOLUMNWIDTH, $iCol, $iWidth)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetColumnWidth
Func _GUICtrlListView_SetExtendedListViewStyle($hWnd, $iExStyle, $iExMask = 0)
	Local $iRet
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETEXTENDEDLISTVIEWSTYLE, $iExMask, $iExStyle)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETEXTENDEDLISTVIEWSTYLE, $iExMask, $iExStyle)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet
EndFunc   ;==>_GUICtrlListView_SetExtendedListViewStyle
Func _GUICtrlListView_SetGroupInfo($hWnd, $iGroupID, $sHeader, $iAlign = 0, $iState = $LVGS_NORMAL)
	Local $tGroup = 0
	If BitAND($iState, $LVGS_SELECTED) Then
		$tGroup = __GUICtrlListView_GetGroupInfoEx($hWnd, $iGroupID, BitOR($LVGF_GROUPID, $LVGF_ITEMS))
		If DllStructGetData($tGroup, "GroupId") <> $iGroupID Or DllStructGetData($tGroup, "cItems") = 0 Then Return False
	EndIf
	Local $aAlign[3] = [$LVGA_HEADER_LEFT, $LVGA_HEADER_CENTER, $LVGA_HEADER_RIGHT]
	If $iAlign < 0 Or $iAlign > 2 Then $iAlign = 0
	Local $tHeader = _WinAPI_MultiByteToWideChar($sHeader)
	Local $pHeader = DllStructGetPtr($tHeader)
	Local $iHeader = StringLen($sHeader)
	$tGroup = DllStructCreate($tagLVGROUP)
	Local $pGroup = DllStructGetPtr($tGroup)
	Local $iGroup = DllStructGetSize($tGroup)
	Local $iMask = BitOR($LVGF_HEADER, $LVGF_ALIGN, $LVGF_STATE)
	DllStructSetData($tGroup, "Size", $iGroup)
	DllStructSetData($tGroup, "Mask", $iMask)
	DllStructSetData($tGroup, "HeaderMax", $iHeader)
	DllStructSetData($tGroup, "Align", $aAlign[$iAlign])
	DllStructSetData($tGroup, "State", $iState)
	DllStructSetData($tGroup, "StateMask", $iState)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tGroup, "Header", $pHeader)
			$iRet = _SendMessage($hWnd, $LVM_SETGROUPINFO, $iGroupID, $pGroup)
			DllStructSetData($tGroup, "Mask", $LVGF_GROUPID)
			DllStructSetData($tGroup, "GroupID", $iGroupID)
			_SendMessage($hWnd, $LVM_SETGROUPINFO, 0, $pGroup)
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iGroup + $iHeader, $tMemMap)
			Local $pText = $pMemory + $iGroup
			DllStructSetData($tGroup, "Header", $pText)
			_MemWrite($tMemMap, $tGroup, $pMemory, $iGroup)
			_MemWrite($tMemMap, $tHeader, $pText, $iHeader)
			$iRet = _SendMessage($hWnd, $LVM_SETGROUPINFO, $iGroupID, $pMemory)
			DllStructSetData($tGroup, "Mask", $LVGF_GROUPID)
			DllStructSetData($tGroup, "GroupID", $iGroupID)
			_SendMessage($hWnd, $LVM_SETGROUPINFO, 0, $pMemory)
			_MemFree($tMemMap)
		EndIf
		_WinAPI_InvalidateRect($hWnd)
	Else
		DllStructSetData($tGroup, "Header", $pHeader)
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETGROUPINFO, $iGroupID, $pGroup)
		DllStructSetData($tGroup, "Mask", $LVGF_GROUPID)
		DllStructSetData($tGroup, "GroupID", $iGroupID)
		GUICtrlSendMsg($hWnd, $LVM_SETGROUPINFO, 0, $pGroup)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetGroupInfo
Func _GUICtrlListView_SetHotCursor($hWnd, $hCursor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETHOTCURSOR, 0, $hCursor, 0, "wparam", "handle", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $LVM_SETHOTCURSOR, 0, $hCursor))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetHotCursor
Func _GUICtrlListView_SetHotItem($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETHOTITEM, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETHOTITEM, $iIndex, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetHotItem
Func _GUICtrlListView_SetHoverTime($hWnd, $iTime)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETHOVERTIME, 0, $iTime)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETHOVERTIME, 0, $iTime)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetHoverTime
Func _GUICtrlListView_SetIconSpacing($hWnd, $iCX, $iCY)
	Local $iRet, $aPadding[2]
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETICONSPACING, 0, _WinAPI_MakeLong($iCX, $iCY))
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETICONSPACING, 0, _WinAPI_MakeLong($iCX, $iCY))
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	$aPadding[0] = BitAND($iRet, 0xFFFF)
	$aPadding[1] = BitShift($iRet, 16)
	Return $aPadding
EndFunc   ;==>_GUICtrlListView_SetIconSpacing
Func _GUICtrlListView_SetImageList($hWnd, $hHandle, $iType = 0)
	Local $aType[3] = [$LVSIL_NORMAL, $LVSIL_SMALL, $LVSIL_STATE]
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETIMAGELIST, $aType[$iType], $hHandle, 0, "wparam", "handle", "handle")
	Else
		Return Ptr(GUICtrlSendMsg($hWnd, $LVM_SETIMAGELIST, $aType[$iType], $hHandle))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetImageList
Func _GUICtrlListView_SetInfoTip($hWnd, $iIndex, $sText, $iSubItem = 0)
	Local $tBuffer = _WinAPI_MultiByteToWideChar($sText)
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $iBuffer = StringLen($sText)
	Local $tInfo = DllStructCreate($tagLVSETINFOTIP)
	Local $iInfo = DllStructGetSize($tInfo)
	DllStructSetData($tInfo, "Size", $iInfo)
	DllStructSetData($tInfo, "Item", $iIndex)
	DllStructSetData($tInfo, "SubItem", $iSubItem)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tInfo, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETINFOTIP, 0, $tInfo, 0, "wparam", "struct*")
		Else
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iInfo + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iInfo
			DllStructSetData($tInfo, "Text", $pText)
			_MemWrite($tMemMap, $tInfo, $pMemory, $iInfo)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETINFOTIP, 0, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		DllStructSetData($tInfo, "Text", $pBuffer)
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETINFOTIP, 0, DllStructGetPtr($tInfo))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetInfoTip
Func _GUICtrlListView_SetInsertMark($hWnd, $iIndex, $bAfter = False)
	Local $tMark = DllStructCreate($tagLVINSERTMARK)
	Local $iMark = DllStructGetSize($tMark)
	DllStructSetData($tMark, "Size", $iMark)
	If $bAfter Then DllStructSetData($tMark, "Flags", $LVIM_AFTER)
	DllStructSetData($tMark, "Item", $iIndex)
	DllStructSetData($tMark, "Reserved", 0)
	Local $iRet
	If IsHWnd($hWnd) Then
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iMark, $tMemMap)
		_MemWrite($tMemMap, $tMark, $pMemory, $iMark)
		$iRet = _SendMessage($hWnd, $LVM_SETINSERTMARK, 0, $pMemory, 0, "wparam", "ptr")
		_MemFree($tMemMap)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETINSERTMARK, 0, DllStructGetPtr($tMark))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetInsertMark
Func _GUICtrlListView_SetInsertMarkColor($hWnd, $iColor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETINSERTMARKCOLOR, 0, $iColor)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETINSERTMARKCOLOR, 0, $iColor)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetInsertMarkColor
Func _GUICtrlListView_SetItem($hWnd, $sText, $iIndex = 0, $iSubItem = 0, $iImage = -1, $iParam = -1, $iIndent = -1)
	Local $pBuffer, $iBuffer
	If $sText <> -1 Then
		$iBuffer = StringLen($sText) + 1
		Local $tBuffer
		If _GUICtrlListView_GetUnicodeFormat($hWnd) Then
			$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		Else
			$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
		EndIf
		$pBuffer = DllStructGetPtr($tBuffer)
		DllStructSetData($tBuffer, "Text", $sText)
	Else
		$iBuffer = 0
		$pBuffer = -1 ; LPSTR_TEXTCALLBACK
	EndIf
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $iMask = $LVIF_TEXT
	If $iImage <> -1 Then $iMask = BitOR($iMask, $LVIF_IMAGE)
	If $iParam <> -1 Then $iMask = BitOR($iMask, $LVIF_PARAM)
	If $iIndent <> -1 Then $iMask = BitOR($iMask, $LVIF_INDENT)
	DllStructSetData($tItem, "Mask", $iMask)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)
	DllStructSetData($tItem, "Image", $iImage)
	DllStructSetData($tItem, "Param", $iParam)
	DllStructSetData($tItem, "Indent", $iIndent)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItem
Func _GUICtrlListView_SetItemChecked($hWnd, $iIndex, $bCheck = True)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $pMemory, $tMemMap, $iRet
	Local $tItem = DllStructCreate($tagLVITEM)
	Local $pItem = DllStructGetPtr($tItem)
	Local $iItem = DllStructGetSize($tItem)
	If @error Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
	If $iIndex <> -1 Then
		DllStructSetData($tItem, "Mask", $LVIF_STATE)
		DllStructSetData($tItem, "Item", $iIndex)
		If ($bCheck) Then
			DllStructSetData($tItem, "State", 0x2000)
		Else
			DllStructSetData($tItem, "State", 0x1000)
		EndIf
		DllStructSetData($tItem, "StateMask", 0xf000)
		If IsHWnd($hWnd) Then
			If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
				Return _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*") <> 0
			Else
				$pMemory = _MemInit($hWnd, $iItem, $tMemMap)
				_MemWrite($tMemMap, $tItem)
				If $bUnicode Then
					$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
				Else
					$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
				EndIf
				_MemFree($tMemMap)
				Return $iRet <> 0
			EndIf
		Else
			If $bUnicode Then
				Return GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem) <> 0
			Else
				Return GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem) <> 0
			EndIf
		EndIf
	Else
		For $x = 0 To _GUICtrlListView_GetItemCount($hWnd) - 1
			DllStructSetData($tItem, "Mask", $LVIF_STATE)
			DllStructSetData($tItem, "Item", $x)
			If ($bCheck) Then
				DllStructSetData($tItem, "State", 0x2000)
			Else
				DllStructSetData($tItem, "State", 0x1000)
			EndIf
			DllStructSetData($tItem, "StateMask", 0xf000)
			If IsHWnd($hWnd) Then
				If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
					If Not _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*") <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				Else
					$pMemory = _MemInit($hWnd, $iItem, $tMemMap)
					_MemWrite($tMemMap, $tItem)
					If $bUnicode Then
						$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
					Else
						$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
					EndIf
					_MemFree($tMemMap)
					If Not $iRet <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				EndIf
			Else
				If $bUnicode Then
					If Not GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem) <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				Else
					If Not GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem) <> 0 Then Return SetError($LV_ERR, $LV_ERR, $LV_ERR)
				EndIf
			EndIf
		Next
		Return True
	EndIf
	Return False
EndFunc   ;==>_GUICtrlListView_SetItemChecked
Func _GUICtrlListView_SetItemCount($hWnd, $iItems)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETITEMCOUNT, $iItems, BitOR($LVSICF_NOINVALIDATEALL, $LVSICF_NOSCROLL)) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETITEMCOUNT, $iItems, BitOR($LVSICF_NOINVALIDATEALL, $LVSICF_NOSCROLL)) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetItemCount
Func _GUICtrlListView_SetItemCut($hWnd, $iIndex, $bEnabled = True)
	Local $iState = 0
	If $bEnabled Then $iState = $LVIS_CUT
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, $iState, $LVIS_CUT)
EndFunc   ;==>_GUICtrlListView_SetItemCut
Func _GUICtrlListView_SetItemDropHilited($hWnd, $iIndex, $bEnabled = True)
	Local $iState = 0
	If $bEnabled Then $iState = $LVIS_DROPHILITED
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, $iState, $LVIS_DROPHILITED)
EndFunc   ;==>_GUICtrlListView_SetItemDropHilited
Func _GUICtrlListView_SetItemEx($hWnd, ByRef $tItem)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iRet
	If IsHWnd($hWnd) Then
		Local $iItem = DllStructGetSize($tItem)
		Local $iBuffer = DllStructGetData($tItem, "TextMax")
		Local $pBuffer = DllStructGetData($tItem, "Text")
		If $bUnicode Then $iBuffer *= 2
		Local $tMemMap
		Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
		Local $pText = $pMemory + $iItem
		DllStructSetData($tItem, "Text", $pText)
		_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
		If $pBuffer <> 0 Then _MemWrite($tMemMap, $pBuffer, $pText, $iBuffer)
		If $bUnicode Then
			$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
		Else
			$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
		EndIf
		_MemFree($tMemMap)
	Else
		Local $pItem = DllStructGetPtr($tItem)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemEx
Func _GUICtrlListView_SetItemFocused($hWnd, $iIndex, $bEnabled = True)
	Local $iState = 0
	If $bEnabled Then $iState = $LVIS_FOCUSED
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, $iState, $LVIS_FOCUSED)
EndFunc   ;==>_GUICtrlListView_SetItemFocused
Func _GUICtrlListView_SetItemGroupID($hWnd, $iIndex, $iGroupID)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_GROUPID)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "GroupID", $iGroupID)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItemGroupID
Func _GUICtrlListView_SetItemImage($hWnd, $iIndex, $iImage, $iSubItem = 0)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_IMAGE)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	DllStructSetData($tItem, "Image", $iImage)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItemImage
Func _GUICtrlListView_SetItemIndent($hWnd, $iIndex, $iIndent)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_INDENT)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Indent", $iIndent)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItemIndent
Func __GUICtrlListView_SetItemOverlayImage($hWnd, $iIndex, $iImage)
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, __GUICtrlListView_IndexToOverlayImageMask($iImage), $LVIS_OVERLAYMASK)
EndFunc   ;==>__GUICtrlListView_SetItemOverlayImage
Func _GUICtrlListView_SetItemParam($hWnd, $iIndex, $iParam)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_PARAM)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "Param", $iParam)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem)
EndFunc   ;==>_GUICtrlListView_SetItemParam
Func _GUICtrlListView_SetItemPosition($hWnd, $iIndex, $iCX, $iCY)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETITEMPOSITION, $iIndex, _WinAPI_MakeLong($iCX, $iCY)) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETITEMPOSITION, $iIndex, _WinAPI_MakeLong($iCX, $iCY)) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetItemPosition
Func _GUICtrlListView_SetItemPosition32($hWnd, $iIndex, $iCX, $iCY)
	Local $tPoint = DllStructCreate($tagPOINT)
	DllStructSetData($tPoint, "X", $iCX)
	DllStructSetData($tPoint, "Y", $iCY)
	Local $iRet
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			$iRet = _SendMessage($hWnd, $LVM_SETITEMPOSITION32, $iIndex, $tPoint, 0, "wparam", "struct*")
		Else
			Local $iPoint = DllStructGetSize($tPoint)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iPoint, $tMemMap)
			_MemWrite($tMemMap, $tPoint)
			$iRet = _SendMessage($hWnd, $LVM_SETITEMPOSITION32, $iIndex, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMPOSITION32, $iIndex, DllStructGetPtr($tPoint))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemPosition32
Func _GUICtrlListView_SetItemSelected($hWnd, $iIndex, $bSelected = True, $bFocused = False)
	Local $tStruct = DllStructCreate($tagLVITEM)
	Local $iRet, $iSelected = 0, $iFocused = 0, $iSize, $tMemMap, $pMemory
	If ($bSelected = True) Then $iSelected = $LVIS_SELECTED
	If ($bFocused = True And $iIndex <> -1) Then $iFocused = $LVIS_FOCUSED
	DllStructSetData($tStruct, "Mask", $LVIF_STATE)
	DllStructSetData($tStruct, "Item", $iIndex)
	DllStructSetData($tStruct, "State", BitOR($iSelected, $iFocused))
	DllStructSetData($tStruct, "StateMask", BitOR($LVIS_SELECTED, $iFocused))
	$iSize = DllStructGetSize($tStruct)
	If IsHWnd($hWnd) Then
		$pMemory = _MemInit($hWnd, $iSize, $tMemMap)
		_MemWrite($tMemMap, $tStruct, $pMemory, $iSize)
		$iRet = _SendMessage($hWnd, $LVM_SETITEMSTATE, $iIndex, $pMemory)
		_MemFree($tMemMap)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMSTATE, $iIndex, DllStructGetPtr($tStruct))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemSelected
Func _GUICtrlListView_SetItemState($hWnd, $iIndex, $iState, $iStateMask)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tItem, "Mask", $LVIF_STATE)
	DllStructSetData($tItem, "Item", $iIndex)
	DllStructSetData($tItem, "State", $iState)
	DllStructSetData($tItem, "StateMask", $iStateMask)
	Return _GUICtrlListView_SetItemEx($hWnd, $tItem) <> 0
EndFunc   ;==>_GUICtrlListView_SetItemState
Func _GUICtrlListView_SetItemStateImage($hWnd, $iIndex, $iImage)
	Return _GUICtrlListView_SetItemState($hWnd, $iIndex, BitShift($iImage, -12), $LVIS_STATEIMAGEMASK)
EndFunc   ;==>_GUICtrlListView_SetItemStateImage
Func _GUICtrlListView_SetItemText($hWnd, $iIndex, $sText, $iSubItem = 0)
	Local $bUnicode = _GUICtrlListView_GetUnicodeFormat($hWnd)
	Local $iRet
	If $iSubItem = -1 Then
		Local $sSeparatorChar = Opt('GUIDataSeparatorChar')
		Local $i_Cols = _GUICtrlListView_GetColumnCount($hWnd)
		Local $a_Text = StringSplit($sText, $sSeparatorChar)
		If $i_Cols > $a_Text[0] Then $i_Cols = $a_Text[0]
		For $i = 1 To $i_Cols
			$iRet = _GUICtrlListView_SetItemText($hWnd, $iIndex, $a_Text[$i], $i - 1)
			If Not $iRet Then ExitLoop
		Next
		Return $iRet
	EndIf
	Local $iBuffer = StringLen($sText) + 1
	Local $tBuffer
	If $bUnicode Then
		$tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]")
		$iBuffer *= 2
	Else
		$tBuffer = DllStructCreate("char Text[" & $iBuffer & "]")
	EndIf
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($tagLVITEM)
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tItem, "Mask", $LVIF_TEXT)
	DllStructSetData($tItem, "item", $iIndex)
	DllStructSetData($tItem, "SubItem", $iSubItem)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			DllStructSetData($tItem, "Text", $pBuffer)
			$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $tItem, 0, "wparam", "struct*")
		Else
			Local $iItem = DllStructGetSize($tItem)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iItem + $iBuffer, $tMemMap)
			Local $pText = $pMemory + $iItem
			DllStructSetData($tItem, "Text", $pText)
			_MemWrite($tMemMap, $tItem, $pMemory, $iItem)
			_MemWrite($tMemMap, $tBuffer, $pText, $iBuffer)
			If $bUnicode Then
				$iRet = _SendMessage($hWnd, $LVM_SETITEMW, 0, $pMemory, 0, "wparam", "ptr")
			Else
				$iRet = _SendMessage($hWnd, $LVM_SETITEMA, 0, $pMemory, 0, "wparam", "ptr")
			EndIf
			_MemFree($tMemMap)
		EndIf
	Else
		Local $pItem = DllStructGetPtr($tItem)
		DllStructSetData($tItem, "Text", $pBuffer)
		If $bUnicode Then
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMW, 0, $pItem)
		Else
			$iRet = GUICtrlSendMsg($hWnd, $LVM_SETITEMA, 0, $pItem)
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetItemText
Func _GUICtrlListView_SetOutlineColor($hWnd, $iColor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETOUTLINECOLOR, 0, $iColor)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETOUTLINECOLOR, 0, $iColor)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetOutlineColor
Func _GUICtrlListView_SetSelectedColumn($hWnd, $iCol)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LVM_SETSELECTEDCOLUMN, $iCol)
		_WinAPI_InvalidateRect($hWnd)
	Else
		GUICtrlSendMsg($hWnd, $LVM_SETSELECTEDCOLUMN, $iCol, 0)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetSelectedColumn
Func _GUICtrlListView_SetSelectionMark($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETSELECTIONMARK, 0, $iIndex)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETSELECTIONMARK, 0, $iIndex)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetSelectionMark
Func _GUICtrlListView_SetTextBkColor($hWnd, $iColor)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETTEXTBKCOLOR, 0, $iColor) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETTEXTBKCOLOR, 0, $iColor) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListView_SetTextBkColor
Func _GUICtrlListView_SetTextColor($hWnd, $iColor)
	Local $iRet
	If IsHWnd($hWnd) Then
		$iRet = _SendMessage($hWnd, $LVM_SETTEXTCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect($hWnd)
	Else
		$iRet = GUICtrlSendMsg($hWnd, $LVM_SETTEXTCOLOR, 0, $iColor)
		_WinAPI_InvalidateRect(GUICtrlGetHandle($hWnd))
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SetTextColor
Func _GUICtrlListView_SetToolTips($hWnd, $hToolTip)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETTOOLTIPS, 0, $hToolTip, 0, "wparam", "hwnd", "hwnd")
	Else
		Return HWnd(GUICtrlSendMsg($hWnd, $LVM_SETTOOLTIPS, 0, $hToolTip))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetToolTips
Func _GUICtrlListView_SetUnicodeFormat($hWnd, $bUnicode)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETUNICODEFORMAT, $bUnicode)
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETUNICODEFORMAT, $bUnicode, 0)
	EndIf
EndFunc   ;==>_GUICtrlListView_SetUnicodeFormat
Func _GUICtrlListView_SetView($hWnd, $iView)
	Local $aView[5] = [$LV_VIEW_ICON, $LV_VIEW_DETAILS, $LV_VIEW_LIST, $LV_VIEW_SMALLICON, $LV_VIEW_TILE]
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LVM_SETVIEW, $aView[$iView]) <> -1
	Else
		Return GUICtrlSendMsg($hWnd, $LVM_SETVIEW, $aView[$iView], 0) <> -1
	EndIf
EndFunc   ;==>_GUICtrlListView_SetView
Func _GUICtrlListView_SetWorkAreas($hWnd, $iLeft, $iTop, $iRight, $iBottom)
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $iLeft)
	DllStructSetData($tRECT, "Top", $iTop)
	DllStructSetData($tRECT, "Right", $iRight)
	DllStructSetData($tRECT, "Bottom", $iBottom)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_SETWORKAREAS, 1, $tRECT, 0, "wparam", "struct*")
		Else
			Local $iRect = DllStructGetSize($tRECT)
			Local $tMemMap
			Local $pMemory = _MemInit($hWnd, $iRect, $tMemMap)
			_MemWrite($tMemMap, $tRECT, $pMemory, $iRect)
			_SendMessage($hWnd, $LVM_SETWORKAREAS, 1, $pMemory, 0, "wparam", "ptr")
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_SETWORKAREAS, 1, DllStructGetPtr($tRECT))
	EndIf
EndFunc   ;==>_GUICtrlListView_SetWorkAreas
Func _GUICtrlListView_SimpleSort($hWnd, ByRef $vSortSense, $iCol, $bToggleSense = True)
	Local $iItemCount = _GUICtrlListView_GetItemCount($hWnd)
	If $iItemCount Then
		Local $iDescending = 0
		If UBound($vSortSense) Then
			$iDescending = $vSortSense[$iCol]
		Else
			$iDescending = $vSortSense
		EndIf
		Local $vSeparatorChar = Opt('GUIDataSeparatorChar')
		Local $iColumnCount = _GUICtrlListView_GetColumnCount($hWnd)
		Local Enum $iIndexValue = $iColumnCount, $iItemParam ; Additional columns for the index value and ItemParam
		Local $aListViewItems[$iItemCount][$iColumnCount + 2]
		Local $aSelectedItems = StringSplit(_GUICtrlListView_GetSelectedIndices($hWnd), $vSeparatorChar)
		Local $aCheckedItems = __GUICtrlListView_GetCheckedIndices($hWnd)
		Local $sItemText, $iFocused = -1
		For $i = 0 To $iItemCount - 1 ; Rows
			If $iFocused = -1 Then
				If _GUICtrlListView_GetItemFocused($hWnd, $i) Then $iFocused = $i
			EndIf
			_GUICtrlListView_SetItemSelected($hWnd, $i, False)
			_GUICtrlListView_SetItemChecked($hWnd, $i, False)
			For $j = 0 To $iColumnCount - 1 ; Columns
				$sItemText = StringStripWS(_GUICtrlListView_GetItemText($hWnd, $i, $j), $STR_STRIPTRAILING)
				If (StringIsFloat($sItemText) Or StringIsInt($sItemText)) Then
					$aListViewItems[$i][$j] = Number($sItemText)
				Else
					$aListViewItems[$i][$j] = $sItemText
				EndIf
			Next
			$aListViewItems[$i][$iIndexValue] = $i ; Index value
			$aListViewItems[$i][$iItemParam] = _GUICtrlListView_GetItemParam($hWnd, $i) ; ItemParam
		Next
		_ArraySort($aListViewItems, $iDescending, 0, 0, $iCol)
		For $i = 0 To $iItemCount - 1 ; Rows
			For $j = 0 To $iColumnCount - 1 ; Columns
				_GUICtrlListView_SetItemText($hWnd, $i, $aListViewItems[$i][$j], $j)
			Next
			_GUICtrlListView_SetItemParam($hWnd, $i, $aListViewItems[$i][$iItemParam]) ; ItemParam
			For $j = 1 To $aSelectedItems[0]
				If $aListViewItems[$i][$iIndexValue] = $aSelectedItems[$j] Then
					If $aListViewItems[$i][$iIndexValue] = $iFocused Then
						_GUICtrlListView_SetItemSelected($hWnd, $i, True, True)
					Else
						_GUICtrlListView_SetItemSelected($hWnd, $i, True)
					EndIf
					ExitLoop
				EndIf
			Next
			For $j = 1 To $aCheckedItems[0]
				If $aListViewItems[$i][$iIndexValue] = $aCheckedItems[$j] Then
					_GUICtrlListView_SetItemChecked($hWnd, $i, True)
					ExitLoop
				EndIf
			Next
		Next
		If $bToggleSense Then ; Automatic sort sense toggle
			If UBound($vSortSense) Then
				$vSortSense[$iCol] = Not $iDescending
			Else
				$vSortSense = Not $iDescending
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListView_SimpleSort
#Au3Stripper_Ignore_Funcs=__GUICtrlListView_Sort
Func __GUICtrlListView_Sort($nItem1, $nItem2, $hWnd)
	Local $iIndex, $sVal1, $sVal2, $nResult
	For $x = 1 To $__g_aListViewSortInfo[0][0]
		If $hWnd = $__g_aListViewSortInfo[$x][1] Then
			$iIndex = $x
			ExitLoop
		EndIf
	Next
	If $__g_aListViewSortInfo[$iIndex][3] = $__g_aListViewSortInfo[$iIndex][4] Then ; $nColumn = nCurCol ?
		If Not $__g_aListViewSortInfo[$iIndex][7] Then ; $bSet
			$__g_aListViewSortInfo[$iIndex][5] *= -1 ; $nSortDir
			$__g_aListViewSortInfo[$iIndex][7] = 1 ; $bSet
		EndIf
	Else
		$__g_aListViewSortInfo[$iIndex][7] = 1 ; $bSet
	EndIf
	$__g_aListViewSortInfo[$iIndex][6] = $__g_aListViewSortInfo[$iIndex][3] ; $nCol = $nColumn
	$sVal1 = _GUICtrlListView_GetItemText($hWnd, $nItem1, $__g_aListViewSortInfo[$iIndex][3])
	$sVal2 = _GUICtrlListView_GetItemText($hWnd, $nItem2, $__g_aListViewSortInfo[$iIndex][3])
	If $__g_aListViewSortInfo[$iIndex][8] = 1 Then
		If (StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
		If (StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
	EndIf
	If $__g_aListViewSortInfo[$iIndex][8] < 2 Then
		$nResult = 0 ; No change of item1 and item2 positions
		If $sVal1 < $sVal2 Then
			$nResult = -1 ; Put item2 before item1
		ElseIf $sVal1 > $sVal2 Then
			$nResult = 1 ; Put item2 behind item1
		EndIf
	Else
		$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
	EndIf
	$nResult = $nResult * $__g_aListViewSortInfo[$iIndex][5] ; $nSortDir
	Return $nResult
EndFunc   ;==>__GUICtrlListView_Sort
Func _GUICtrlListView_SortItems($hWnd, $iCol)
	Local $iRet, $iIndex, $pFunction, $hHeader, $iFormat
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	For $x = 1 To $__g_aListViewSortInfo[0][0]
		If $hWnd = $__g_aListViewSortInfo[$x][1] Then
			$iIndex = $x
			ExitLoop
		EndIf
	Next
	$pFunction = DllCallbackGetPtr($__g_aListViewSortInfo[$iIndex][2]) ; get pointer to call back
	$__g_aListViewSortInfo[$iIndex][3] = $iCol ; $nColumn = column clicked
	$__g_aListViewSortInfo[$iIndex][7] = 0 ; $bSet
	$__g_aListViewSortInfo[$iIndex][4] = $__g_aListViewSortInfo[$iIndex][6] ; nCurCol = $nCol
	$iRet = _SendMessage($hWnd, $LVM_SORTITEMSEX, $hWnd, $pFunction, 0, "hwnd", "ptr")
	If $iRet <> 0 Then
		If $__g_aListViewSortInfo[$iIndex][9] Then ; Use arrow in header
			$hHeader = $__g_aListViewSortInfo[$iIndex][10]
			For $x = 0 To _GUICtrlHeader_GetItemCount($hHeader) - 1
				$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $x)
				If BitAND($iFormat, $HDF_SORTDOWN) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTDOWN))
				ElseIf BitAND($iFormat, $HDF_SORTUP) Then
					_GUICtrlHeader_SetItemFormat($hHeader, $x, BitXOR($iFormat, $HDF_SORTUP))
				EndIf
			Next
			$iFormat = _GUICtrlHeader_GetItemFormat($hHeader, $iCol)
			If $__g_aListViewSortInfo[$iIndex][5] = 1 Then ; ascending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTUP))
			Else ; descending
				_GUICtrlHeader_SetItemFormat($hHeader, $iCol, BitOR($iFormat, $HDF_SORTDOWN))
			EndIf
		EndIf
	EndIf
	Return $iRet <> 0
EndFunc   ;==>_GUICtrlListView_SortItems
Func __GUICtrlListView_StateImageMaskToIndex($iMask)
	Return BitShift(BitAND($iMask, $LVIS_STATEIMAGEMASK), 12)
EndFunc   ;==>__GUICtrlListView_StateImageMaskToIndex
Func _GUICtrlListView_SubItemHitTest($hWnd, $iX = -1, $iY = -1)
	Local $iTest, $tTest, $pMemory, $tMemMap, $iFlags, $aTest[11]
	If $iX = -1 Then $iX = _WinAPI_GetMousePosX(True, $hWnd)
	If $iY = -1 Then $iY = _WinAPI_GetMousePosY(True, $hWnd)
	$tTest = DllStructCreate($tagLVHITTESTINFO)
	DllStructSetData($tTest, "X", $iX)
	DllStructSetData($tTest, "Y", $iY)
	If IsHWnd($hWnd) Then
		If _WinAPI_InProcess($hWnd, $__g_hLVLastWnd) Then
			_SendMessage($hWnd, $LVM_SUBITEMHITTEST, 0, $tTest, 0, "wparam", "struct*")
		Else
			$iTest = DllStructGetSize($tTest)
			$pMemory = _MemInit($hWnd, $iTest, $tMemMap)
			_MemWrite($tMemMap, $tTest)
			_SendMessage($hWnd, $LVM_SUBITEMHITTEST, 0, $pMemory, 0, "wparam", "ptr")
			_MemRead($tMemMap, $pMemory, $tTest, $iTest)
			_MemFree($tMemMap)
		EndIf
	Else
		GUICtrlSendMsg($hWnd, $LVM_SUBITEMHITTEST, 0, DllStructGetPtr($tTest))
	EndIf
	$iFlags = DllStructGetData($tTest, "Flags")
	$aTest[0] = DllStructGetData($tTest, "Item")
	$aTest[1] = DllStructGetData($tTest, "SubItem")
	$aTest[2] = BitAND($iFlags, $LVHT_NOWHERE) <> 0
	$aTest[3] = BitAND($iFlags, $LVHT_ONITEMICON) <> 0
	$aTest[4] = BitAND($iFlags, $LVHT_ONITEMLABEL) <> 0
	$aTest[5] = BitAND($iFlags, $LVHT_ONITEMSTATEICON) <> 0
	$aTest[6] = BitAND($iFlags, $LVHT_ONITEM) <> 0
	$aTest[7] = BitAND($iFlags, $LVHT_ABOVE) <> 0
	$aTest[8] = BitAND($iFlags, $LVHT_BELOW) <> 0
	$aTest[9] = BitAND($iFlags, $LVHT_TOLEFT) <> 0
	$aTest[10] = BitAND($iFlags, $LVHT_TORIGHT) <> 0
	Return $aTest
EndFunc   ;==>_GUICtrlListView_SubItemHitTest
Func _GUICtrlListView_UnRegisterSortCallBack($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	For $x = 1 To $__g_aListViewSortInfo[0][0]
		If $hWnd = $__g_aListViewSortInfo[$x][1] Then
			DllCallbackFree($__g_aListViewSortInfo[$x][2])
			__GUICtrlListView_ArrayDelete($__g_aListViewSortInfo, $x)
			$__g_aListViewSortInfo[0][0] -= 1
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_GUICtrlListView_UnRegisterSortCallBack
#comments-start
	Copyright 2013 Dragana R. <trancexx at yahoo dot com>
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
#comments-end
Global Const $INTERNET_DEFAULT_PORT = 0
Global Const $INTERNET_DEFAULT_HTTP_PORT = 80
Global Const $INTERNET_DEFAULT_HTTPS_PORT = 443
Global Const $INTERNET_SCHEME_HTTP = 1
Global Const $INTERNET_SCHEME_HTTPS = 2
Global Const $INTERNET_SCHEME_FTP = 3
Global Const $ICU_ESCAPE = 0x80000000
Global Const $WINHTTP_FLAG_ASYNC = 0x10000000
Global Const $WINHTTP_FLAG_ESCAPE_PERCENT = 0x00000004
Global Const $WINHTTP_FLAG_NULL_CODEPAGE = 0x00000008
Global Const $WINHTTP_FLAG_ESCAPE_DISABLE = 0x00000040
Global Const $WINHTTP_FLAG_ESCAPE_DISABLE_QUERY = 0x00000080
Global Const $WINHTTP_FLAG_BYPASS_PROXY_CACHE = 0x00000100
Global Const $WINHTTP_FLAG_REFRESH = $WINHTTP_FLAG_BYPASS_PROXY_CACHE
Global Const $WINHTTP_FLAG_SECURE = 0x00800000
Global Const $WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0
Global Const $WINHTTP_ACCESS_TYPE_NO_PROXY = 1
Global Const $WINHTTP_ACCESS_TYPE_NAMED_PROXY = 3
Global Const $WINHTTP_NO_PROXY_NAME = ""
Global Const $WINHTTP_NO_PROXY_BYPASS = ""
Global Const $WINHTTP_NO_REFERER = ""
Global Const $WINHTTP_DEFAULT_ACCEPT_TYPES = 0
Global Const $WINHTTP_NO_ADDITIONAL_HEADERS = ""
Global Const $WINHTTP_NO_REQUEST_DATA = ""
Global Const $WINHTTP_HEADER_NAME_BY_INDEX = ""
Global Const $WINHTTP_NO_OUTPUT_BUFFER = 0
Global Const $WINHTTP_NO_HEADER_INDEX = 0
Global Const $WINHTTP_ADDREQ_INDEX_MASK = 0x0000FFFF
Global Const $WINHTTP_ADDREQ_FLAGS_MASK = 0xFFFF0000
Global Const $WINHTTP_ADDREQ_FLAG_ADD_IF_NEW = 0x10000000
Global Const $WINHTTP_ADDREQ_FLAG_ADD = 0x20000000
Global Const $WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA = 0x40000000
Global Const $WINHTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON = 0x01000000
Global Const $WINHTTP_ADDREQ_FLAG_COALESCE = $WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA
Global Const $WINHTTP_ADDREQ_FLAG_REPLACE = 0x80000000
Global Const $WINHTTP_IGNORE_REQUEST_TOTAL_LENGTH = 0
Global Const $WINHTTP_OPTION_CALLBACK = 1
Global Const $WINHTTP_FIRST_OPTION = $WINHTTP_OPTION_CALLBACK
Global Const $WINHTTP_OPTION_RESOLVE_TIMEOUT = 2
Global Const $WINHTTP_OPTION_CONNECT_TIMEOUT = 3
Global Const $WINHTTP_OPTION_CONNECT_RETRIES = 4
Global Const $WINHTTP_OPTION_SEND_TIMEOUT = 5
Global Const $WINHTTP_OPTION_RECEIVE_TIMEOUT = 6
Global Const $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT = 7
Global Const $WINHTTP_OPTION_HANDLE_TYPE = 9
Global Const $WINHTTP_OPTION_READ_BUFFER_SIZE = 12
Global Const $WINHTTP_OPTION_WRITE_BUFFER_SIZE = 13
Global Const $WINHTTP_OPTION_PARENT_HANDLE = 21
Global Const $WINHTTP_OPTION_EXTENDED_ERROR = 24
Global Const $WINHTTP_OPTION_SECURITY_FLAGS = 31
Global Const $WINHTTP_OPTION_SECURITY_CERTIFICATE_STRUCT = 32
Global Const $WINHTTP_OPTION_URL = 34
Global Const $WINHTTP_OPTION_SECURITY_KEY_BITNESS = 36
Global Const $WINHTTP_OPTION_PROXY = 38
Global Const $WINHTTP_OPTION_USER_AGENT = 41
Global Const $WINHTTP_OPTION_CONTEXT_VALUE = 45
Global Const $WINHTTP_OPTION_CLIENT_CERT_CONTEXT = 47
Global Const $WINHTTP_OPTION_REQUEST_PRIORITY = 58
Global Const $WINHTTP_OPTION_HTTP_VERSION = 59
Global Const $WINHTTP_OPTION_DISABLE_FEATURE = 63
Global Const $WINHTTP_OPTION_CODEPAGE = 68
Global Const $WINHTTP_OPTION_MAX_CONNS_PER_SERVER = 73
Global Const $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER = 74
Global Const $WINHTTP_OPTION_AUTOLOGON_POLICY = 77
Global Const $WINHTTP_OPTION_SERVER_CERT_CONTEXT = 78
Global Const $WINHTTP_OPTION_ENABLE_FEATURE = 79
Global Const $WINHTTP_OPTION_WORKER_THREAD_COUNT = 80
Global Const $WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT = 81
Global Const $WINHTTP_OPTION_PASSPORT_COBRANDING_URL = 82
Global Const $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH = 83
Global Const $WINHTTP_OPTION_SECURE_PROTOCOLS = 84
Global Const $WINHTTP_OPTION_ENABLETRACING = 85
Global Const $WINHTTP_OPTION_PASSPORT_SIGN_OUT = 86
Global Const $WINHTTP_OPTION_PASSPORT_RETURN_URL = 87
Global Const $WINHTTP_OPTION_REDIRECT_POLICY = 88
Global Const $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS = 89
Global Const $WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE = 90
Global Const $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE = 91
Global Const $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE = 92
Global Const $WINHTTP_OPTION_CONNECTION_INFO = 93
Global Const $WINHTTP_OPTION_CLIENT_CERT_ISSUER_LIST = 94
Global Const $WINHTTP_OPTION_SPN = 96
Global Const $WINHTTP_OPTION_GLOBAL_PROXY_CREDS = 97
Global Const $WINHTTP_OPTION_GLOBAL_SERVER_CREDS = 98
Global Const $WINHTTP_OPTION_UNLOAD_NOTIFY_EVENT = 99
Global Const $WINHTTP_OPTION_REJECT_USERPWD_IN_URL = 100
Global Const $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS = 101
Global Const $WINHTTP_OPTION_RECEIVE_PROXY_CONNECT_RESPONSE = 103
Global Const $WINHTTP_OPTION_IS_PROXY_CONNECT_RESPONSE = 104
Global Const $WINHTTP_OPTION_SERVER_SPN_USED = 106
Global Const $WINHTTP_OPTION_PROXY_SPN_USED = 107
Global Const $WINHTTP_OPTION_SERVER_CBT = 108
Global Const $WINHTTP_OPTION_UNSAFE_HEADER_PARSING = 110
Global Const $WINHTTP_OPTION_DECOMPRESSION = 118
Global Const $WINHTTP_LAST_OPTION = $WINHTTP_OPTION_DECOMPRESSION
Global Const $WINHTTP_OPTION_USERNAME = 0x1000
Global Const $WINHTTP_OPTION_PASSWORD = 0x1001
Global Const $WINHTTP_OPTION_PROXY_USERNAME = 0x1002
Global Const $WINHTTP_OPTION_PROXY_PASSWORD = 0x1003
Global Const $WINHTTP_CONNS_PER_SERVER_UNLIMITED = 0xFFFFFFFF
Global Const $WINHTTP_DECOMPRESSION_FLAG_GZIP = 0x00000001
Global Const $WINHTTP_DECOMPRESSION_FLAG_DEFLATE = 0x00000002
Global Const $WINHTTP_DECOMPRESSION_FLAG_ALL = 0x00000003
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM = 0
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW = 1
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH = 2
Global Const $WINHTTP_AUTOLOGON_SECURITY_LEVEL_DEFAULT = $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_NEVER = 0
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP = 1
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS = 2
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_LAST = $WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS
Global Const $WINHTTP_OPTION_REDIRECT_POLICY_DEFAULT = $WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP
Global Const $WINHTTP_DISABLE_PASSPORT_AUTH = 0x00000000
Global Const $WINHTTP_ENABLE_PASSPORT_AUTH = 0x10000000
Global Const $WINHTTP_DISABLE_PASSPORT_KEYRING = 0x20000000
Global Const $WINHTTP_ENABLE_PASSPORT_KEYRING = 0x40000000
Global Const $WINHTTP_DISABLE_COOKIES = 0x00000001
Global Const $WINHTTP_DISABLE_REDIRECTS = 0x00000002
Global Const $WINHTTP_DISABLE_AUTHENTICATION = 0x00000004
Global Const $WINHTTP_DISABLE_KEEP_ALIVE = 0x00000008
Global Const $WINHTTP_ENABLE_SSL_REVOCATION = 0x00000001
Global Const $WINHTTP_ENABLE_SSL_REVERT_IMPERSONATION = 0x00000002
Global Const $WINHTTP_DISABLE_SPN_SERVER_PORT = 0x00000000
Global Const $WINHTTP_ENABLE_SPN_SERVER_PORT = 0x00000001
Global Const $WINHTTP_OPTION_SPN_MASK = $WINHTTP_ENABLE_SPN_SERVER_PORT
Global Const $WINHTTP_ERROR_BASE = 12000
Global Const $ERROR_WINHTTP_OUT_OF_HANDLES = 12001
Global Const $ERROR_WINHTTP_TIMEOUT = 12002
Global Const $ERROR_WINHTTP_INTERNAL_ERROR = 12004
Global Const $ERROR_WINHTTP_INVALID_URL = 12005
Global Const $ERROR_WINHTTP_UNRECOGNIZED_SCHEME = 12006
Global Const $ERROR_WINHTTP_NAME_NOT_RESOLVED = 12007
Global Const $ERROR_WINHTTP_INVALID_OPTION = 12009
Global Const $ERROR_WINHTTP_OPTION_NOT_SETTABLE = 12011
Global Const $ERROR_WINHTTP_SHUTDOWN = 12012
Global Const $ERROR_WINHTTP_LOGIN_FAILURE = 12015
Global Const $ERROR_WINHTTP_OPERATION_CANCELLED = 12017
Global Const $ERROR_WINHTTP_INCORRECT_HANDLE_TYPE = 12018
Global Const $ERROR_WINHTTP_INCORRECT_HANDLE_STATE = 12019
Global Const $ERROR_WINHTTP_CANNOT_CONNECT = 12029
Global Const $ERROR_WINHTTP_CONNECTION_ERROR = 12030
Global Const $ERROR_WINHTTP_RESEND_REQUEST = 12032
Global Const $ERROR_WINHTTP_SECURE_CERT_DATE_INVALID = 12037
Global Const $ERROR_WINHTTP_SECURE_CERT_CN_INVALID = 12038
Global Const $ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED = 12044
Global Const $ERROR_WINHTTP_SECURE_INVALID_CA = 12045
Global Const $ERROR_WINHTTP_SECURE_CERT_REV_FAILED = 12057
Global Const $ERROR_WINHTTP_CANNOT_CALL_BEFORE_OPEN = 12100
Global Const $ERROR_WINHTTP_CANNOT_CALL_BEFORE_SEND = 12101
Global Const $ERROR_WINHTTP_CANNOT_CALL_AFTER_SEND = 12102
Global Const $ERROR_WINHTTP_CANNOT_CALL_AFTER_OPEN = 12103
Global Const $ERROR_WINHTTP_HEADER_NOT_FOUND = 12150
Global Const $ERROR_WINHTTP_INVALID_SERVER_RESPONSE = 12152
Global Const $ERROR_WINHTTP_INVALID_HEADER = 12153
Global Const $ERROR_WINHTTP_INVALID_QUERY_REQUEST = 12154
Global Const $ERROR_WINHTTP_HEADER_ALREADY_EXISTS = 12155
Global Const $ERROR_WINHTTP_REDIRECT_FAILED = 12156
Global Const $ERROR_WINHTTP_SECURE_CHANNEL_ERROR = 12157
Global Const $ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT = 12166
Global Const $ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT = 12167
Global Const $ERROR_WINHTTP_SECURE_INVALID_CERT = 12169
Global Const $ERROR_WINHTTP_SECURE_CERT_REVOKED = 12170
Global Const $ERROR_WINHTTP_NOT_INITIALIZED = 12172
Global Const $ERROR_WINHTTP_SECURE_FAILURE = 12175
Global Const $ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR = 12178
Global Const $ERROR_WINHTTP_SECURE_CERT_WRONG_USAGE = 12179
Global Const $ERROR_WINHTTP_AUTODETECTION_FAILED = 12180
Global Const $ERROR_WINHTTP_HEADER_COUNT_EXCEEDED = 12181
Global Const $ERROR_WINHTTP_HEADER_SIZE_OVERFLOW = 12182
Global Const $ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW = 12183
Global Const $ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW = 12184
Global Const $ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY = 12185
Global Const $ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY = 12186
Global Const $WINHTTP_ERROR_LAST = 12186
Global Const $HTTP_STATUS_CONTINUE = 100
Global Const $HTTP_STATUS_SWITCH_PROTOCOLS = 101
Global Const $HTTP_STATUS_OK = 200
Global Const $HTTP_STATUS_CREATED = 201
Global Const $HTTP_STATUS_ACCEPTED = 202
Global Const $HTTP_STATUS_PARTIAL = 203
Global Const $HTTP_STATUS_NO_CONTENT = 204
Global Const $HTTP_STATUS_RESET_CONTENT = 205
Global Const $HTTP_STATUS_PARTIAL_CONTENT = 206
Global Const $HTTP_STATUS_WEBDAV_MULTI_STATUS = 207
Global Const $HTTP_STATUS_AMBIGUOUS = 300
Global Const $HTTP_STATUS_MOVED = 301
Global Const $HTTP_STATUS_REDIRECT = 302
Global Const $HTTP_STATUS_REDIRECT_METHOD = 303
Global Const $HTTP_STATUS_NOT_MODIFIED = 304
Global Const $HTTP_STATUS_USE_PROXY = 305
Global Const $HTTP_STATUS_REDIRECT_KEEP_VERB = 307
Global Const $HTTP_STATUS_BAD_REQUEST = 400
Global Const $HTTP_STATUS_DENIED = 401
Global Const $HTTP_STATUS_PAYMENT_REQ = 402
Global Const $HTTP_STATUS_FORBIDDEN = 403
Global Const $HTTP_STATUS_NOT_FOUND = 404
Global Const $HTTP_STATUS_BAD_METHOD = 405
Global Const $HTTP_STATUS_NONE_ACCEPTABLE = 406
Global Const $HTTP_STATUS_PROXY_AUTH_REQ = 407
Global Const $HTTP_STATUS_REQUEST_TIMEOUT = 408
Global Const $HTTP_STATUS_CONFLICT = 409
Global Const $HTTP_STATUS_GONE = 410
Global Const $HTTP_STATUS_LENGTH_REQUIRED = 411
Global Const $HTTP_STATUS_PRECOND_FAILED = 412
Global Const $HTTP_STATUS_REQUEST_TOO_LARGE = 413
Global Const $HTTP_STATUS_URI_TOO_LONG = 414
Global Const $HTTP_STATUS_UNSUPPORTED_MEDIA = 415
Global Const $HTTP_STATUS_RETRY_WITH = 449
Global Const $HTTP_STATUS_SERVER_ERROR = 500
Global Const $HTTP_STATUS_NOT_SUPPORTED = 501
Global Const $HTTP_STATUS_BAD_GATEWAY = 502
Global Const $HTTP_STATUS_SERVICE_UNAVAIL = 503
Global Const $HTTP_STATUS_GATEWAY_TIMEOUT = 504
Global Const $HTTP_STATUS_VERSION_NOT_SUP = 505
Global Const $HTTP_STATUS_FIRST = $HTTP_STATUS_CONTINUE
Global Const $HTTP_STATUS_LAST = $HTTP_STATUS_VERSION_NOT_SUP
Global Const $SECURITY_FLAG_IGNORE_UNKNOWN_CA = 0x00000100
Global Const $SECURITY_FLAG_IGNORE_CERT_DATE_INVALID = 0x00002000
Global Const $SECURITY_FLAG_IGNORE_CERT_CN_INVALID = 0x00001000
Global Const $SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE = 0x00000200
Global Const $SECURITY_FLAG_SECURE = 0x00000001
Global Const $SECURITY_FLAG_STRENGTH_WEAK = 0x10000000
Global Const $SECURITY_FLAG_STRENGTH_MEDIUM = 0x40000000
Global Const $SECURITY_FLAG_STRENGTH_STRONG = 0x20000000
Global Const $ICU_NO_ENCODE = 0x20000000
Global Const $ICU_DECODE = 0x10000000
Global Const $ICU_NO_META = 0x08000000
Global Const $ICU_ENCODE_SPACES_ONLY = 0x04000000
Global Const $ICU_BROWSER_MODE = 0x02000000
Global Const $ICU_ENCODE_PERCENT = 0x00001000
Global Const $WINHTTP_QUERY_MIME_VERSION = 0
Global Const $WINHTTP_QUERY_CONTENT_TYPE = 1
Global Const $WINHTTP_QUERY_CONTENT_TRANSFER_ENCODING = 2
Global Const $WINHTTP_QUERY_CONTENT_ID = 3
Global Const $WINHTTP_QUERY_CONTENT_DESCRIPTION = 4
Global Const $WINHTTP_QUERY_CONTENT_LENGTH = 5
Global Const $WINHTTP_QUERY_CONTENT_LANGUAGE = 6
Global Const $WINHTTP_QUERY_ALLOW = 7
Global Const $WINHTTP_QUERY_PUBLIC = 8
Global Const $WINHTTP_QUERY_DATE = 9
Global Const $WINHTTP_QUERY_EXPIRES = 10
Global Const $WINHTTP_QUERY_LAST_MODIFIED = 11
Global Const $WINHTTP_QUERY_MESSAGE_ID = 12
Global Const $WINHTTP_QUERY_URI = 13
Global Const $WINHTTP_QUERY_DERIVED_FROM = 14
Global Const $WINHTTP_QUERY_COST = 15
Global Const $WINHTTP_QUERY_LINK = 16
Global Const $WINHTTP_QUERY_PRAGMA = 17
Global Const $WINHTTP_QUERY_VERSION = 18
Global Const $WINHTTP_QUERY_STATUS_CODE = 19
Global Const $WINHTTP_QUERY_STATUS_TEXT = 20
Global Const $WINHTTP_QUERY_RAW_HEADERS = 21
Global Const $WINHTTP_QUERY_RAW_HEADERS_CRLF = 22
Global Const $WINHTTP_QUERY_CONNECTION = 23
Global Const $WINHTTP_QUERY_ACCEPT = 24
Global Const $WINHTTP_QUERY_ACCEPT_CHARSET = 25
Global Const $WINHTTP_QUERY_ACCEPT_ENCODING = 26
Global Const $WINHTTP_QUERY_ACCEPT_LANGUAGE = 27
Global Const $WINHTTP_QUERY_AUTHORIZATION = 28
Global Const $WINHTTP_QUERY_CONTENT_ENCODING = 29
Global Const $WINHTTP_QUERY_FORWARDED = 30
Global Const $WINHTTP_QUERY_FROM = 31
Global Const $WINHTTP_QUERY_IF_MODIFIED_SINCE = 32
Global Const $WINHTTP_QUERY_LOCATION = 33
Global Const $WINHTTP_QUERY_ORIG_URI = 34
Global Const $WINHTTP_QUERY_REFERER = 35
Global Const $WINHTTP_QUERY_RETRY_AFTER = 36
Global Const $WINHTTP_QUERY_SERVER = 37
Global Const $WINHTTP_QUERY_TITLE = 38
Global Const $WINHTTP_QUERY_USER_AGENT = 39
Global Const $WINHTTP_QUERY_WWW_AUTHENTICATE = 40
Global Const $WINHTTP_QUERY_PROXY_AUTHENTICATE = 41
Global Const $WINHTTP_QUERY_ACCEPT_RANGES = 42
Global Const $WINHTTP_QUERY_SET_COOKIE = 43
Global Const $WINHTTP_QUERY_COOKIE = 44
Global Const $WINHTTP_QUERY_REQUEST_METHOD = 45
Global Const $WINHTTP_QUERY_REFRESH = 46
Global Const $WINHTTP_QUERY_CONTENT_DISPOSITION = 47
Global Const $WINHTTP_QUERY_AGE = 48
Global Const $WINHTTP_QUERY_CACHE_CONTROL = 49
Global Const $WINHTTP_QUERY_CONTENT_BASE = 50
Global Const $WINHTTP_QUERY_CONTENT_LOCATION = 51
Global Const $WINHTTP_QUERY_CONTENT_MD5 = 52
Global Const $WINHTTP_QUERY_CONTENT_RANGE = 53
Global Const $WINHTTP_QUERY_ETAG = 54
Global Const $WINHTTP_QUERY_HOST = 55
Global Const $WINHTTP_QUERY_IF_MATCH = 56
Global Const $WINHTTP_QUERY_IF_NONE_MATCH = 57
Global Const $WINHTTP_QUERY_IF_RANGE = 58
Global Const $WINHTTP_QUERY_IF_UNMODIFIED_SINCE = 59
Global Const $WINHTTP_QUERY_MAX_FORWARDS = 60
Global Const $WINHTTP_QUERY_PROXY_AUTHORIZATION = 61
Global Const $WINHTTP_QUERY_RANGE = 62
Global Const $WINHTTP_QUERY_TRANSFER_ENCODING = 63
Global Const $WINHTTP_QUERY_UPGRADE = 64
Global Const $WINHTTP_QUERY_VARY = 65
Global Const $WINHTTP_QUERY_VIA = 66
Global Const $WINHTTP_QUERY_WARNING = 67
Global Const $WINHTTP_QUERY_EXPECT = 68
Global Const $WINHTTP_QUERY_PROXY_CONNECTION = 69
Global Const $WINHTTP_QUERY_UNLESS_MODIFIED_SINCE = 70
Global Const $WINHTTP_QUERY_PROXY_SUPPORT = 75
Global Const $WINHTTP_QUERY_AUTHENTICATION_INFO = 76
Global Const $WINHTTP_QUERY_PASSPORT_URLS = 77
Global Const $WINHTTP_QUERY_PASSPORT_CONFIG = 78
Global Const $WINHTTP_QUERY_MAX = 78
Global Const $WINHTTP_QUERY_CUSTOM = 65535
Global Const $WINHTTP_QUERY_FLAG_REQUEST_HEADERS = 0x80000000
Global Const $WINHTTP_QUERY_FLAG_SYSTEMTIME = 0x40000000
Global Const $WINHTTP_QUERY_FLAG_NUMBER = 0x20000000
Global Const $WINHTTP_CALLBACK_STATUS_RESOLVING_NAME = 0x00000001
Global Const $WINHTTP_CALLBACK_STATUS_NAME_RESOLVED = 0x00000002
Global Const $WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER = 0x00000004
Global Const $WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER = 0x00000008
Global Const $WINHTTP_CALLBACK_STATUS_SENDING_REQUEST = 0x00000010
Global Const $WINHTTP_CALLBACK_STATUS_REQUEST_SENT = 0x00000020
Global Const $WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE = 0x00000040
Global Const $WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED = 0x00000080
Global Const $WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION = 0x00000100
Global Const $WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED = 0x00000200
Global Const $WINHTTP_CALLBACK_STATUS_HANDLE_CREATED = 0x00000400
Global Const $WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING = 0x00000800
Global Const $WINHTTP_CALLBACK_STATUS_DETECTING_PROXY = 0x00001000
Global Const $WINHTTP_CALLBACK_STATUS_REDIRECT = 0x00004000
Global Const $WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE = 0x00008000
Global Const $WINHTTP_CALLBACK_STATUS_SECURE_FAILURE = 0x00010000
Global Const $WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE = 0x00020000
Global Const $WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE = 0x00040000
Global Const $WINHTTP_CALLBACK_STATUS_READ_COMPLETE = 0x00080000
Global Const $WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE = 0x00100000
Global Const $WINHTTP_CALLBACK_STATUS_REQUEST_ERROR = 0x00200000
Global Const $WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE = 0x00400000
Global Const $WINHTTP_CALLBACK_FLAG_RESOLVE_NAME = 0x00000003
Global Const $WINHTTP_CALLBACK_FLAG_CONNECT_TO_SERVER = 0x0000000C
Global Const $WINHTTP_CALLBACK_FLAG_SEND_REQUEST = 0x00000030
Global Const $WINHTTP_CALLBACK_FLAG_RECEIVE_RESPONSE = 0x000000C0
Global Const $WINHTTP_CALLBACK_FLAG_CLOSE_CONNECTION = 0x00000300
Global Const $WINHTTP_CALLBACK_FLAG_HANDLES = 0x00000C00
Global Const $WINHTTP_CALLBACK_FLAG_DETECTING_PROXY = $WINHTTP_CALLBACK_STATUS_DETECTING_PROXY
Global Const $WINHTTP_CALLBACK_FLAG_REDIRECT = $WINHTTP_CALLBACK_STATUS_REDIRECT
Global Const $WINHTTP_CALLBACK_FLAG_INTERMEDIATE_RESPONSE = $WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE
Global Const $WINHTTP_CALLBACK_FLAG_SECURE_FAILURE = $WINHTTP_CALLBACK_STATUS_SECURE_FAILURE
Global Const $WINHTTP_CALLBACK_FLAG_SENDREQUEST_COMPLETE = $WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE
Global Const $WINHTTP_CALLBACK_FLAG_HEADERS_AVAILABLE = $WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE
Global Const $WINHTTP_CALLBACK_FLAG_DATA_AVAILABLE = $WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE
Global Const $WINHTTP_CALLBACK_FLAG_READ_COMPLETE = $WINHTTP_CALLBACK_STATUS_READ_COMPLETE
Global Const $WINHTTP_CALLBACK_FLAG_WRITE_COMPLETE = $WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE
Global Const $WINHTTP_CALLBACK_FLAG_REQUEST_ERROR = $WINHTTP_CALLBACK_STATUS_REQUEST_ERROR
Global Const $WINHTTP_CALLBACK_FLAG_ALL_COMPLETIONS = 0x007E0000
Global Const $WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS = 0xFFFFFFFF
Global Const $API_RECEIVE_RESPONSE = 1
Global Const $API_QUERY_DATA_AVAILABLE = 2
Global Const $API_READ_DATA = 3
Global Const $API_WRITE_DATA = 4
Global Const $API_SEND_REQUEST = 5
Global Const $WINHTTP_HANDLE_TYPE_SESSION = 1
Global Const $WINHTTP_HANDLE_TYPE_CONNECT = 2
Global Const $WINHTTP_HANDLE_TYPE_REQUEST = 3
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_REV_FAILED = 0x00000001
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CERT = 0x00000002
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_REVOKED = 0x00000004
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CA = 0x00000008
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_CN_INVALID = 0x00000010
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_DATE_INVALID = 0x00000020
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_CERT_WRONG_USAGE = 0x00000040
Global Const $WINHTTP_CALLBACK_STATUS_FLAG_SECURITY_CHANNEL_ERROR = 0x80000000
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_SSL2 = 0x00000008
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_SSL3 = 0x00000020
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_TLS1 = 0x00000080
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1 = 0x00000200
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2 = 0x00000800
Global Const $WINHTTP_FLAG_SECURE_PROTOCOL_ALL = 0x000000A8
Global Const $WINHTTP_AUTH_SCHEME_BASIC = 0x00000001
Global Const $WINHTTP_AUTH_SCHEME_NTLM = 0x00000002
Global Const $WINHTTP_AUTH_SCHEME_PASSPORT = 0x00000004
Global Const $WINHTTP_AUTH_SCHEME_DIGEST = 0x00000008
Global Const $WINHTTP_AUTH_SCHEME_NEGOTIATE = 0x00000010
Global Const $WINHTTP_AUTH_TARGET_SERVER = 0x00000000
Global Const $WINHTTP_AUTH_TARGET_PROXY = 0x00000001
Global Const $WINHTTP_AUTOPROXY_AUTO_DETECT = 0x00000001
Global Const $WINHTTP_AUTOPROXY_CONFIG_URL = 0x00000002
Global Const $WINHTTP_AUTOPROXY_RUN_INPROCESS = 0x00010000
Global Const $WINHTTP_AUTOPROXY_RUN_OUTPROCESS_ONLY = 0x00020000
Global Const $WINHTTP_AUTO_DETECT_TYPE_DHCP = 0x00000001
Global Const $WINHTTP_AUTO_DETECT_TYPE_DNS_A = 0x00000002
;#include <Memory.au3>; REMOVED INCLUDE
;#include "TokenList.au3"; REMOVED INCLUDE
Global Enum $__HTMLPARSERCONSTANT_TYPE_NONE, $__HTMLPARSERCONSTANT_TYPE_CDATA, $__HTMLPARSERCONSTANT_TYPE_COMMENT, $__HTMLPARSERCONSTANT_TYPE_DOCTYPE, $__HTMLPARSERCONSTANT_TYPE_STARTTAG, $__HTMLPARSERCONSTANT_TYPE_ENDTAG, $__HTMLPARSERCONSTANT_TYPE_TEXT
Func _HTMLParser($sHTML)
	Local $iExtended, $i, $aRet, $iOffset = 1
	While 1
		$aRet=StringRegExp($sHTML, "\G<![dD][oO][cC][tT][yY][pP][eE][\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]+[^>]*?>", 1, $iOffset)
		If @error=0 Then
			$iExtended = @extended
			If _TokenList_CreateToken($__HTMLPARSERCONSTANT_TYPE_DOCTYPE, $iOffset, $iExtended-($iOffset)) = 0 Then Return SetError(1, 1, 0)
			$iOffset = $iExtended
			ContinueLoop
		EndIf
		$aRet=StringRegExp($sHTML, "\G[<][0-9a-zA-Z]+(?:[\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]+[^\x{0000}-\x{001F}\x{007F}-\x{009F}\x{0020}\x{0022}\x{0027}\x{003E}\x{002F}\x{003D}\x{FDD0}\x{FDEF}\x{FFFE}\x{FFFF}\x{1FFFE}\x{1FFFF}\x{2FFFE}\x{2FFFF}\x{3FFFE}\x{3FFFF}\x{4FFFE}\x{4FFFF}\x{5FFFE}\x{5FFFF}\x{6FFFE}\x{6FFFF}\x{7FFFE}\x{7FFFF}\x{8FFFE}\x{8FFFF}\x{9FFFE}\x{9FFFF}\x{AFFFE}\x{AFFFF}\x{BFFFE}\x{BFFFF}\x{CFFFE}\x{CFFFF}\x{DFFFE}\x{DFFFF}\x{EFFFE}\x{EFFFF}\x{FFFFE}\x{FFFFF}\x{10FFFE}\x{10FFFF}]+(?:[\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]*[=][\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]*(?:[^\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}\x{0022}\x{0027}\x{003D}\x{003C}\x{003E}\x{0060}]+|['][^']*[']|[""""][^""""]*[""""]))?)*[\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]*[/]?[>]", 1, $iOffset)
		If @error=0 Then
			$iExtended = @extended
			If _TokenList_CreateToken($__HTMLPARSERCONSTANT_TYPE_STARTTAG, $iOffset, $iExtended-($iOffset)) = 0 Then Return SetError(1, 2, 0)
			If StringLower(StringRegExp($sHTML, "\G[<]([0-9a-zA-Z]+)", 1, $iOffset)[0]) == "script" Then
				$aRet = StringRegExp($sHTML, "(?si)\G(.*?)<\/script>", 1, $iExtended)
				If @error = 0 Then
					If _TokenList_CreateToken($__HTMLPARSERCONSTANT_TYPE_TEXT, $iExtended, $iExtended+StringLen($aRet)) = 0 Then Return SetError(1, 2.1, 0)
					$iExtended += StringLen($aRet[0])
				EndIf
			EndIf
			$iOffset = $iExtended
			ContinueLoop
		EndIf
		$aRet=StringRegExp($sHTML, "\G[<][/][0-9a-zA-Z]+[\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]*[>]", 1, $iOffset)
		If @error=0 Then
			$iExtended = @extended
			If _TokenList_CreateToken($__HTMLPARSERCONSTANT_TYPE_ENDTAG, $iOffset, $iExtended-($iOffset)) = 0 Then Return SetError(1, 3, 0)
			$iOffset = $iExtended
			ContinueLoop
		EndIf
		$aRet=StringRegExp($sHTML, "\G<!\[CDATA\[.*?\]\]>", 1, $iOffset)
		If @error=0 Then
			$iExtended = @extended
			If _TokenList_CreateToken($__HTMLPARSERCONSTANT_TYPE_CDATA, $iOffset, $iExtended-($iOffset)) = 0 Then Return SetError(1, 4, 0)
			$iOffset = $iExtended
			ContinueLoop
		EndIf
		$aRet=StringRegExp($sHTML, "\G<!--.*?-->", 1, $iOffset)
		If @error=0 Then
			$iExtended = @extended
			If _TokenList_CreateToken($__HTMLPARSERCONSTANT_TYPE_COMMENT, $iOffset, $iExtended-($iOffset)) = 0 Then Return SetError(1, 5, 0)
			$iOffset = $iExtended
			ContinueLoop
		EndIf
		$aRet=StringRegExp($sHTML, "\G[^<]+", 1, $iOffset)
		If @error=0 Then
			$iExtended = @extended
			If _TokenList_CreateToken($__HTMLPARSERCONSTANT_TYPE_TEXT, $iOffset, $iExtended-($iOffset)) = 0 Then Return SetError(1, 6, 0)
			$iOffset = $iExtended
			ContinueLoop
		EndIf
		ExitLoop
	WEnd
	Return SetError(0, $iExtended, $__g_tTokenListList)
EndFunc
Func _HTMLParser_GetElementByID($sID, $pItem, $sHTML)
	Local $sAttrval, $aRegexRet
	If $pItem = 0 Then Return SetError(3, 0, 0)
	_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	If Not ($__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG) Then Return SetError(2, 0, 0)
	$sActiveTag = StringLower(StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)[0])
	$iActiveTag = 0
	While 1
		If $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG Then
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag+=1
			If $aRegexRet[0]=$sActiveTag And _HTMLParser_VoidOrSelfClosingElement($pItem, $sHTML) Then $iActiveTag-=1
			$sAttrval=_HTMLParser_Element_GetAttribute("id", $pItem, $sHTML)
			If @error=0 And $sAttrval=$sID Then
				Return $pItem
			EndIf
		ElseIf $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_ENDTAG Then
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<][/]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag-=1
		EndIf
		If $__g_tTokenListToken.Next = 0 Or $iActiveTag<1 Then ExitLoop
		$pItem = $__g_tTokenListToken.Next
		_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	WEnd
	Return SetError(1, 0, 0)
EndFunc
Func _HTMLParser_GetElementsByClassName($sClassName, $pItem, $sHTML)
	Local $sAttrval, $aRegexRet, $aRet[0]
	If $pItem = 0 Then Return SetError(3, 0, 0)
	_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	If Not ($__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG) Then Return SetError(2, 0, 0)
	Local $sActiveTag = StringLower(StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)[0])
	Local $iActiveTag = 0
	While 1
		If $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG Then
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag+=1
			If $aRegexRet[0]=$sActiveTag And _HTMLParser_VoidOrSelfClosingElement($pItem, $sHTML) Then $iActiveTag-=1
			$sAttrval=_HTMLParser_Element_GetAttribute("class", $pItem, $sHTML)
			If @error=0 And StringRegExp($sAttrval, "(^|[ ])"&$sClassName&"($|[ ])") Then
				ReDim $aRet[UBound($aRet, 1)+1]
				$aRet[UBound($aRet, 1)-1] = $pItem
			EndIf
		ElseIf $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_ENDTAG Then
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<][/]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag-=1
		EndIf
		If $__g_tTokenListToken.Next = 0 Or $iActiveTag<1 Then ExitLoop
		$pItem = $__g_tTokenListToken.Next
		_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	WEnd
	If UBound($aRet, 1)>0 Then Return $aRet
	Return SetError(1, 0, 0)
EndFunc
Func _HTMLParser_GetElementsByTagName($sTagName, $pItem, $sHTML)
	Local $aRet[100], $iRet = 0, $aRegexRet
	If $pItem = 0 Then Return SetError(3, 0, 0)
	_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	If Not ($__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG) Then Return SetError(2, 0, 0)
	$sActiveTag = StringLower(StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)[0])
	$iActiveTag = 0
	While 1
		If $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG Then
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag+=1
			If $aRegexRet[0]=$sActiveTag And _HTMLParser_VoidOrSelfClosingElement($pItem, $sHTML) Then $iActiveTag-=1
			If $aRegexRet[0]=$sTagName Then
				If UBound($aRet, 1)=$iRet Then ReDim $aRet[$iRet+100]
				$aRet[$iRet]=$pItem
				$iRet+=1
			EndIf
		ElseIf $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_ENDTAG Then
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<][/]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag-=1
		EndIf
		If $__g_tTokenListToken.Next = 0 Or $iActiveTag<1 Then ExitLoop
		$pItem = $__g_tTokenListToken.Next
		_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	WEnd
	If $iRet = 0 Then Return SetError(1, 0, 0)
	ReDim $aRet[$iRet]
	Return $aRet
EndFunc
Func _HTMLParser_Element_GetText($pItem, $sHTML, $strtrim=True);TODO: if $pItem passed is a Void/Foreign element Return SetError(3, 0, 0)
	Local $aRet[100], $iRet = 0, $aRegexRet
	If $pItem = 0 Then Return SetError(3, 0, 0)
	_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	If Not ($__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG) Then Return SetError(2, 0, 0)
	$sActiveTag = StringLower(StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)[0])
	$iActiveTag = 0
	While 1
		If $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG Then
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag+=1
			If $aRegexRet[0]=$sActiveTag And _HTMLParser_VoidOrSelfClosingElement($pItem, $sHTML) Then $iActiveTag-=1
		ElseIf $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_ENDTAG Then
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<][/]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag-=1
		ElseIf $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_TEXT Then
			If UBound($aRet, 1)=$iRet Then ReDim $aRet[$iRet+100]
			$aRet[$iRet]=$pItem
			$iRet+=1
		EndIf
		If $__g_tTokenListToken.Next = 0 Or $iActiveTag<1 Then ExitLoop
		$pItem = $__g_tTokenListToken.Next
		_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	WEnd
	If $iRet = 0 Then Return SetError(1, 0, 0)
	ReDim $aRet[$iRet]
	Return $aRet
EndFunc
Func _HTMLParser_Element_GetAttribute($sAttributeName, $pItem, $sHTML)
	Local $aRet, $iOffset
	If $pItem = 0 Then Return SetError(3, 0, 0)
	_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	If Not ($__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG) Then Return SetError(2, 0, 0)
	$sAttributeName = StringLower($sAttributeName)
	$aRet = StringRegExp($sHTML, "\G([<][0-9a-zA-Z]+)", 1, $__g_tTokenListToken.Start)
	$iOffset = $__g_tTokenListToken.Start + StringLen($aRet[0])
	While 1
		$aRet = StringRegExp($sHTML, "\G[\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]+([^\x{0000}-\x{001F}\x{007F}-\x{009F}\x{0020}\x{0022}\x{0027}\x{003E}\x{002F}\x{003D}\x{FDD0}\x{FDEF}\x{FFFE}\x{FFFF}\x{1FFFE}\x{1FFFF}\x{2FFFE}\x{2FFFF}\x{3FFFE}\x{3FFFF}\x{4FFFE}\x{4FFFF}\x{5FFFE}\x{5FFFF}\x{6FFFE}\x{6FFFF}\x{7FFFE}\x{7FFFF}\x{8FFFE}\x{8FFFF}\x{9FFFE}\x{9FFFF}\x{AFFFE}\x{AFFFF}\x{BFFFE}\x{BFFFF}\x{CFFFE}\x{CFFFF}\x{DFFFE}\x{DFFFF}\x{EFFFE}\x{EFFFF}\x{FFFFE}\x{FFFFF}\x{10FFFE}\x{10FFFF}]+)(?:[\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]*[=][\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}]*(?:([^\x{0009}\x{000A}\x{000C}\x{000D}\x{0020}\x{0022}\x{0027}\x{003D}\x{003C}\x{003E}\x{0060}]+)|[']([^']*)[']|[""""]([^""""]*)[""""]))", 1, $iOffset)
		$iOffset = @extended
		If @error<>0 Then Return SetError(1, 0, "")
		If StringLower($aRet[0]) = $sAttributeName Then
			Return $aRet[(UBound($aRet, 1)<3?1:UBound($aRet, 1)<4?2:3)]
		EndIf
	WEnd
	Return SetError(4, 0, 0)
EndFunc
Func _HTMLParser_Element_GetParent($pItem)
EndFunc
Func _HTMLParser_Element_GetChildren($pItem, $sHTML)
	Local $aRet[0], $iRet = 0, $aRegexRet, $iLevel = 0
	If $pItem = 0 Then Return SetError(3, 0, 0)
	_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	If Not ($__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG) Then Return SetError(2, 0, 0)
	$sActiveTag = StringLower(StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)[0])
	$iActiveTag = 0
	While 1
		If $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG Then
			$iLevel += 1
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag+=1
			If $aRegexRet[0]=$sActiveTag And _HTMLParser_VoidOrSelfClosingElement($pItem, $sHTML) Then $iActiveTag-=1
			If $iLevel = 2 Then
				ReDim $aRet[UBound($aRet, 1) + 1]
				$aRet[UBound($aRet, 1) - 1] = $pItem
			EndIf
			If _HTMLParser_VoidOrSelfClosingElement($pItem, $sHTML) Then $iLevel -= 1
		ElseIf $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_ENDTAG Then
			$iLevel -= 1
			$aRegexRet = StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<][/]([0-9a-zA-Z]+)", 1)
			$aRegexRet[0] = StringLower($aRegexRet[0])
			If $aRegexRet[0]=$sActiveTag Then $iActiveTag-=1
		EndIf
		If $__g_tTokenListToken.Next = 0 Or $iActiveTag<1 Then ExitLoop
		$pItem = $__g_tTokenListToken.Next
		_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	WEnd
	If UBound($aRet, 1) = 0 Then Return SetError(1, 0, 0)
	Return $aRet
EndFunc
Func _HTMLParser_GetFirstStartTag($pItem, $sHTML)
	If $pItem = 0 Then Return SetError(2, 0, 0)
	_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	While 1
		If $__g_tTokenListToken.Type = $__HTMLPARSERCONSTANT_TYPE_STARTTAG Then Return $pItem
		If $__g_tTokenListToken.Next = 0 Then ExitLoop
		$pItem = $__g_tTokenListToken.Next
		_MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
	WEnd
	Return SetError(1, 0, 0)
EndFunc
Func _HTMLParser_VoidOrSelfClosingElement($pItem, $sHTML)
    _MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
    $EOT = StringLeft(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), 2)
    Return _HTMLParser_IsVoidElement($pItem, $sHTML) Or (_HTMLParser_IsForeignElement($pItem, $sHTML) And $EOT == '/>')
EndFunc
Func _HTMLParser_IsVoidElement($pItem, $sHTML)
    Local Static $voidElements = ['area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link', 'meta', 'param', 'source', 'track', 'wbr']
    _MemMoveMemory($pItem, $__g_pTokenListToken, $__g_iTokenListToken)
    $tagName = StringLower(StringRegExp(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length), "^[<]([0-9a-zA-Z]+)", 1)[0])
    For $voidElement In $voidElements
        If StringLower($voidElement) == $tagName Then Return True
    Next
    Return False
EndFunc
Func _HTMLParser_IsForeignElement($pItem, $sHTML)
    Return False;TODO: implement true check of foreign elements
EndFunc
;#include "MemoryConstants.au3"; REMOVED INCLUDE
;#include "ProcessConstants.au3"; REMOVED INCLUDE
;#include "Security.au3"; REMOVED INCLUDE
;#include "StructureConstants.au3"; REMOVED INCLUDE
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"
Func _MemFree(ByRef $tMemMap)
	Local $pMemory = DllStructGetData($tMemMap, "Mem")
	Local $hProcess = DllStructGetData($tMemMap, "hProc")
	Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
	If @error Then Return SetError(@error, @extended, False)
	Return $bResult
EndFunc   ;==>_MemFree
Func _MemGlobalAlloc($iBytes, $iFlags = 0)
	Local $aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $iFlags, "ulong_ptr", $iBytes)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalAlloc
Func _MemGlobalFree($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ptr", "GlobalFree", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalFree
Func _MemGlobalLock($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalLock
Func _MemGlobalSize($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ulong_ptr", "GlobalSize", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalSize
Func _MemGlobalUnlock($hMemory)
	Local $aResult = DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hMemory)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemGlobalUnlock
Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
	Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
	If @error Then Return SetError(@error + 10, @extended, 0)
	Local $iProcessID = $aResult[2]
	If $iProcessID = 0 Then Return SetError(1, 0, 0) ; Invalid window handle
	Local $iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
	Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
	Local $iAlloc = BitOR($MEM_RESERVE, $MEM_COMMIT)
	Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, $PAGE_READWRITE)
	If $pMemory = 0 Then Return SetError(2, 0, 0) ; Unable to allocate memory
	$tMemMap = DllStructCreate($tagMEMMAP)
	DllStructSetData($tMemMap, "hProc", $hProcess)
	DllStructSetData($tMemMap, "Size", $iSize)
	DllStructSetData($tMemMap, "Mem", $pMemory)
	Return $pMemory
EndFunc   ;==>_MemInit
Func _MemMoveMemory($pSource, $pDest, $iLength)
	DllCall("kernel32.dll", "none", "RtlMoveMemory", "struct*", $pDest, "struct*", $pSource, "ulong_ptr", $iLength)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_MemMoveMemory
Func _MemRead(ByRef $tMemMap, $pSrce, $pDest, $iSize)
	Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
			"ptr", $pSrce, "struct*", $pDest, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemRead
Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "struct*")
	If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
	If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
			"ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemWrite
Func _MemVirtualAlloc($pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualAlloc
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualAllocEx
Func _MemVirtualFree($pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFree", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualFree
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_MemVirtualFreeEx
Func __Mem_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
	Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return $aResult[0]
	If Not $bDebugPriv Then Return SetError(100, 0, 0)
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error + 10, @extended, 0)
	_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
	Local $iError = @error
	Local $iExtended = @extended
	Local $iRet = 0
	If Not @error Then
		$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
		$iError = @error
		$iExtended = @extended
		If $aResult[0] Then $iRet = $aResult[0]
		_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
		If @error Then
			$iError = @error + 20
			$iExtended = @extended
		EndIf
	Else
		$iError = @error + 30 ; SeDebugPrivilege=True error
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
	Return SetError($iError, $iExtended, $iRet)
EndFunc   ;==>__Mem_OpenProcess
;#include <Memory.au3>; REMOVED INCLUDE
Global Const $tagTokenListToken = "align 1;PTR Next;BYTE Type;UINT64 Start;UINT64 Length"
Global Const $__g_tTokenListToken = DllStructCreate($tagTokenListToken)
Global Const $__g_pTokenListToken = DllStructGetPtr($__g_tTokenListToken)
Global Const $__g_iTokenListToken = DllStructGetSize($__g_tTokenListToken)
Global Const $tagTokenListList = "PTR First;PTR Last;"
Global Const $__g_tTokenListList = DllStructCreate($tagTokenListList)
Func _TokenList_CreateToken($iType, $iStart, $iLength, $__g_tTokenListList = $__g_tTokenListList, $__g_tTokenListToken = $__g_tTokenListToken)
	Local $pToken
	$__g_tTokenListToken.Next = 0
	$__g_tTokenListToken.Type = $iType
	$__g_tTokenListToken.Start = $iStart
	$__g_tTokenListToken.Length = $iLength
	$pToken = _MemGlobalAlloc($__g_iTokenListToken, $GPTR)
	If $pToken = 0 Then Return SetError(1, 0, 0)
	_MemMoveMemory($__g_pTokenListToken, $pToken, $__g_iTokenListToken)
	If $__g_tTokenListList.Last<>0 Then
		_MemMoveMemory($__g_tTokenListList.Last, $__g_pTokenListToken, $__g_iTokenListToken)
		$__g_tTokenListToken.Next = $pToken
		_MemMoveMemory($__g_pTokenListToken, $__g_tTokenListList.Last, $__g_iTokenListToken)
		$__g_tTokenListList.Last = $pToken
	EndIf
	If $__g_tTokenListList.First = 0 Then
		$__g_tTokenListList.First = $pToken
		$__g_tTokenListList.Last = $pToken
	EndIf
	Return $pToken
EndFunc
;#include <WinAPI.au3>; REMOVED INCLUDE
Global $_DLL_LibTidy = -1
Global $_DLL_LibTidy_Document = 0
Global Enum $_LibTidy_optTypeString, $_LibTidy_optTypeInteger, $_LibTidy_optTypeBoolean
Global Enum $_LibTidy_optName, $_LibTidy_optType, $_LibTidy_optValue, $_LibTidy_optMAX
Global Enum $_LibTidy__indentSpaces = 1, $_LibTidy__wrap, $_LibTidy__tabSize, $_LibTidy__charEncoding, $_LibTidy__inputEncoding, $_LibTidy__outputEncoding, $_LibTidy__newline, $_LibTidy__doctypeMode, $_LibTidy__doctype, $_LibTidy__repeatedAttributes, $_LibTidy__altText, $_LibTidy__slideStyle, $_LibTidy__errorFile, $_LibTidy__outputFile, $_LibTidy__writeBack, $_LibTidy__markup, $_LibTidy__showWarnings, $_LibTidy__quiet, $_LibTidy__indent, $_LibTidy__hideEndtags, $_LibTidy__inputXml, $_LibTidy__outputXml, $_LibTidy__outputXhtml, $_LibTidy__outputHtml, $_LibTidy__addXmlDecl, $_LibTidy__uppercaseTags, $_LibTidy__uppercaseAttributes, $_LibTidy__bare, $_LibTidy__clean, $_LibTidy__logicalEmphasis, $_LibTidy__dropProprietaryAttributes, $_LibTidy__dropFontTags, $_LibTidy__dropEmptyParas, $_LibTidy__fixBadComments, $_LibTidy__breakBeforeBr, $_LibTidy__split, $_LibTidy__numericEntities, $_LibTidy__quoteMarks, $_LibTidy__quoteNbsp, $_LibTidy__quoteAmpersand, $_LibTidy__wrapAttributes, $_LibTidy__wrapScriptLiterals, $_LibTidy__wrapSections, $_LibTidy__wrapAsp, $_LibTidy__wrapJste, $_LibTidy__wrapPhp, $_LibTidy__fixBackslash, $_LibTidy__indentAttributes, $_LibTidy__assumeXmlProcins, $_LibTidy__addXmlSpace, $_LibTidy__encloseText, $_LibTidy__encloseBlockText, $_LibTidy__keepTime, $_LibTidy__word2000, $_LibTidy__tidyMark, $_LibTidy__gnuEmacs, $_LibTidy__gnuEmacsFile, $_LibTidy__literalAttributes, $_LibTidy__showBodyOnly, $_LibTidy__fixUri, $_LibTidy__lowerLiterals, $_LibTidy__hideComments, $_LibTidy__indentCdata, $_LibTidy__forceOutput, $_LibTidy__showErrors, $_LibTidy__asciiChars, $_LibTidy__joinClasses, $_LibTidy__joinStyles, $_LibTidy__escapeCdata, $_LibTidy__language, $_LibTidy__ncr, $_LibTidy__outputBom, $_LibTidy__replaceColor, $_LibTidy__cssPrefix, $_LibTidy__newInlineTags, $_LibTidy__newBlocklevelTags, $_LibTidy__newEmptyTags, $_LibTidy__newPreTags, $_LibTidy__accessibilityCheck, $_LibTidy__verticalSpace, $_LibTidy__punctuationWrap, $_LibTidy__mergeDivs, $_LibTidy__decorateInferredUl, $_LibTidy__preserveEntities, $_LibTidy__sortAttributes, $_LibTidy__mergeSpans, $_LibTidy__anchorAsName, $_LibTidy_OptionsMAX
Global $_LibTidy_ConfigInf[$_LibTidy_OptionsMAX][$_LibTidy_optMAX]
Func _LibTidy_Startup ($sPath="LibTidy.DLL")
    Dim $_DLL_LibTidy
    Dim $_DLL_LibTidy_Document
    Dim $_LibTidy_ConfigInf
    
    If $_DLL_LibTidy = -1 Then
        If NOT FileExists($sPath) Then
            If NOT FileExists(@ScriptDir & "\" & $sPath) Then Return SetError(1, 0, 0) ; DLL File not found
            $sPath = @ScriptDir & "\" & $sPath
        EndIf
        $_DLL_LibTidy = DllOpen($sPath)
        If $_DLL_LibTidy = -1 Then Return SetError(2, 0, 0) ; Can't load DLL
        While 1
        
            Local $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyCreate")
            If @error OR NOT $aRet[0] Then ExitLoop SetError(3, @error, 1) ; Can't obtain LibTidy Document
            $_DLL_LibTidy_Document = $aRet[0]
            
            _LibTidy_GetAllOptions($_LibTidy_ConfigInf)
            If @error Then ExitLoop SetError(@error, @extended, 1) ; Rethrow _LibTidy_GetAllOptions Error
        
            ExitLoop
        WEnd
        If @error Then
            Local $err = @error, $ext = @extended
            DllClose($_DLL_LibTidy)
            $_DLL_LibTidy = -1
            Return SetError($err, $ext, 0) ; rethrow error from __LibTidy_Startup_TRY
        Else
            OnAutoItExitRegister("__LibTidy_UnLoad")
        EndIf
    EndIf
    
    Return 1
EndFunc
Func _LibTidy_Shutdown ()
    If __LibTidy_UnLoad() Then OnAutoItExitUnRegister("__LibTidy_UnLoad")
EndFunc
Func __LibTidy_UnLoad ()
    
    Dim $_DLL_LibTidy
    If $_DLL_LibTidy = -1 Then Return 1
    
    Dim $_DLL_LibTidy_Document
    
    If $_DLL_LibTidy <> -1 Then
        If $_DLL_LibTidy_Document Then 
            DllCall($_DLL_LibTidy, "none", "tidyRelease", "ptr", $_DLL_LibTidy_Document)
            $_DLL_LibTidy_Document = 0
        EndIf
        DllClose($_DLL_LibTidy)
        $_DLL_LibTidy = -1
    EndIf
    
    Return $_DLL_LibTidy = -1
EndFunc
Func __FileValidate ($sFilename=0, $sPath=@ScriptDir)
    If NOT $sFilename Then Return SetError(1, 0, 0) ; empty input
    
    If NOT FileExists($sFilename) Then
        If NOT FileExists($sPath & "\" & $sFilename) Then Return SetError(2, 0, 0) ; File not Found
        $sFilename = $sPath & "\" & $sFilename
    EndIf
    
    If StringInStr(FileGetAttrib($sFilename), "D", 1) Then Return SetError(3, 0, 0) ; path is Directory
    
    Return $sFilename
EndFunc
Func _LibTidy_LoadConfig ($sPath=0)
    
    $sPath = __FileValidate($sPath)
    If @error Then Return SetError (1, @error, 0)
    
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(2, 0, 0) ; Call Startup first!
        
    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidyLoadConfig", _
                                                    "ptr", $_DLL_LibTidy_Document, _
                                                    "str", $sPath )
    If @error Then Return SetError(3, @error, 0)
    If $aRet[0] Then
        $aRet = DllCall($_DLL_LibTidy, "UINT", "tidyConfigErrorCount", _
                                            "ptr", $tidyLoadConfig )
        If @error Then Return SetError(4, @error, 0)
        If $aRet[0] Then Return SetError(5, $aRet[0], 0) ; error in config file
    EndIf
    
    Return 1
EndFunc
Func _LibTidy_ResetConfig ()
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, 0) ; Call Startup first!
    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidyOptResetAllToDefault", _
                                                    "ptr", $_DLL_LibTidy_Document )
    If @error OR NOT $aRet[0] Then Return SetError(2, @error, 0)
    
    Return 1
EndFunc
Func _LibTidy_SaveConfig ($sPath, $fAllOptions=0, $iMode=2)
    Local $aConfig[$_LibTidy_OptionsMAX][$_LibTidy_optMAX]
    Local $sData = "", $fNotDefault, $value
    
    If NOT _LibTidy_GetAllOptions($aConfig) Then Return SetError(2, 0, 0)
    
    For $i = 1 To $_LibTidy_OptionsMAX - 1
        $value = $aConfig[$i][$_LibTidy_optValue]
        $fNotDefault = $fAllOptions OR $value <> $_LibTidy_ConfigInf[$i][$_LibTidy_optValue]
        If $fNotDefault Then
            If $aConfig[$i][$_LibTidy_optType] = $_LibTidy_optTypeBoolean Then
                If $value Then 
                    $value = "yes" 
                Else 
                    $value = "no"
                EndIf
            EndIf
            $sData &= $aConfig[$i][$_LibTidy_optName] & ": " & $value & @CRLF
        EndIf
    Next
    
    Local $hFile = FileOpen($sPath, $iMode)
    If $hFile = -1 Then Return SetError(4, 0, "")
    
    Local $fResult = FileWrite($hFile, $sData)
    FileClose($hFile)
    
    If $fResult Then
        Return $sData
    Else
        Return SetError(4, 0, "")
    EndIf
EndFunc
Func _LibTidy_GetAllOptions (ByRef $aConfig)
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(100, 0, 0) ; Call Startup first!
    Local $debug = ""
    Local $id = 1, $pOption
    
    Local $tIterator = DllStructCreate("ptr"), _
                $pIterator = DllStructGetPtr($tIterator)
    
    Local $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyGetOptionList", _
                                                    "ptr", $_DLL_LibTidy_Document )
    If @error OR NOT $aRet[0] Then Return SetError(4, 1, 0) ; Can't get iterator
    DllStructSetData($tIterator, 1, $aRet[0])
    
    While DllStructGetData($tIterator, 1)
        $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyGetNextOption", _
                                            "ptr", $_DLL_LibTidy_Document, _
                                            "ptr", $pIterator )
        If @error OR NOT $aRet[0] Then Return SetError(4, 2, 0) ; Can't walk iterator
        $id += 1
    WEnd
    
    If $id <> $_LibTidy_OptionsMAX Then Return SetError(4, 3, 0) ; Version missmatch!
    $id = 1
    
    Local $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyGetOptionList", _
                                                    "ptr", $_DLL_LibTidy_Document )
    If @error OR NOT $aRet[0] Then Return SetError(4, 1, 0) ; Can't get iterator
    DllStructSetData($tIterator, 1, $aRet[0])
    
    While DllStructGetData($tIterator, 1)
        $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyGetNextOption", _
                                            "ptr", $_DLL_LibTidy_Document, _
                                            "ptr", $pIterator )
        If @error OR NOT $aRet[0] Then Return SetError(4, 2, 0) ; Can't walk iterator
        $pOption = $aRet[0]
        
        $aRet = DllCall($_DLL_LibTidy, "STR", "tidyOptGetName", _
                                            "ptr", $pOption )
        If @error OR NOT $aRet[0] Then Return SetError(5, 0, 0) ; Can't get option name
        $aConfig[$id][$_LibTidy_optName] = $aRet[0]
        $aRet = DllCall($_DLL_LibTidy, "INT", "tidyOptGetType", _
                                            "ptr", $pOption )
        If @error Then Return SetError(6, 1, 0) ; Can't get option's type
        $aConfig[$id][$_LibTidy_optType] = $aRet[0]
        $aConfig[$id][$_LibTidy_optValue] = _LibTidy_GetOption($id)
        If @error Then 
            If @error = 3 Then 
                Return SetError(6, 2, 0) ; Unknown option's type
            Else
                Return SetError(7, @extended, 0) ; Rethrow _LibTidy_GetOption Error
            EndIf
        EndIf
        $id += 1
    WEnd
    
    Return 1
EndFunc
Func _LibTidy_GetOption ($ID)
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, 0) ; Call Startup first!
    
    Switch $_LibTidy_ConfigInf[$ID][$_LibTidy_optType]
    
        Case $_LibTidy_optTypeString
            Local $aRet = DllCall($_DLL_LibTidy, "STR", "tidyOptGetValue", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID )
            If @error Then Return SetError(2, 1, 0) ; Error fetching string data
            Return $aRet[0]
            
        Case $_LibTidy_optTypeInteger
            Local $aRet = DllCall($_DLL_LibTidy, "ULONG", "tidyOptGetInt", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID )
            If @error Then Return SetError(2, 2, 0) ; Error fetching integer data
            Return $aRet[0]
            
        Case $_LibTidy_optTypeBoolean
            Local $aRet = DllCall($_DLL_LibTidy, "BOOL", "tidyOptGetBool", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID )
            If @error Then Return SetError(2, 2, 0) ; Error fetching boolean data
            Return 0 <> $aRet[0]
            
        Case Else
            Return SetError(3, 0, 0) ; Unknown type
    EndSwitch
EndFunc
Func _LibTidy_SetOption ($ID, $Value)
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, 0) ; Call Startup first!
    
    Switch $_LibTidy_ConfigInf[$ID][$_LibTidy_optType]
    
        Case $_LibTidy_optTypeString
            If NOT IsString($Value) Then Return SetError(2, 1, 0) ; Invalid value type
            Local $aRet = DllCall($_DLL_LibTidy, "BOOL", "tidyOptSetValue", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID, _
                                                            "str", $Value )
            If @error Then Return SetError(3, 1, 0) ; Error setting string data
            
        Case $_LibTidy_optTypeInteger
            If NOT IsInt($Value) Then Return SetError(2, 2, 0) ; Invalid value type
            If @error Then Return SetError(2, 2, 0) ; Invalid value type
            Local $aRet = DllCall($_DLL_LibTidy, "BOOL", "tidyOptSetInt", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID, _
                                                            "ulong", Int($Value, 1) )
            If @error Then Return SetError(3, 2, 0) ; Error setting integer data
            
        Case $_LibTidy_optTypeBoolean
            If NOT IsBool($Value) Then Return SetError(2, 3, 0) ; Invalid value type
            If @error Then Return SetError(2, 3, 0) ; Invalid value type
            Local $aRet = DllCall($_DLL_LibTidy, "BOOL", "tidyOptSetBool", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID, _
                                                            "bool", $Value )
            If @error Then Return SetError(3, 3, 0) ; Error setting boolean data
            
        Case Else
            Return SetError(4, 0, 0) ; Unknown type
    EndSwitch
    
    Return 1
EndFunc
Func _LibTidy_LoadString ($sData="")
    If NOT StringStripWS($sData, 3) Then Return SetError(2, 2, 0) ; empty string
    
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(2, 1, 0) ; Call Startup first!
    Local $tBuffer = DllStructCreate("char[" & (StringLen($sData) + 1) & "]"), _
                $pBuffer = DllStructGetPtr($tBuffer)
    DllStructSetData($tBuffer, 1, $sData)
    
    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidyParseString", _
                                                    "ptr", $_DLL_LibTidy_Document, _
                                                    "ptr", $pBuffer )
    If @error OR NOT $aRet[0] Then Return SetError(3, @error, 0)
    
    Return 1
EndFunc
Func _LibTidy_LoadFile ($sPath=0)
    $sPath = __FileValidate($sPath)
    If @error Then Return SetError (1, @error, 0)
    _LibTidy_LoadString(FileRead($sPath))
    If @error Then Return SetError(@error, @extended, 0)
    
    Return 1
EndFunc
Func _LibTidy_SaveString ()
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, "") ; Call Startup first!
    Local $tBuffer = DllStructCreate("char[1]"), _
                $tBufLen = DllStructCreate("uint"), _
                $pBufLen = DllStructGetPtr($tBufLen)
    DllStructSetData($tBufLen, 1, 1)
    
    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidySaveString", _
                                                    "ptr", $_DLL_LibTidy_Document, _
                                                    "ptr", DllStructGetPtr($tBuffer), _
                                                    "ptr", $pBufLen )
    If @error Then Return SetError(2, @error, "")
    
    If $aRet[0] = -12 Then
        $tBuffer = DllStructCreate("char[" & DllStructGetData($tBufLen, 1) & "]")
        $aRet = DllCall($_DLL_LibTidy, "INT", "tidySaveString", _
                                            "ptr", $_DLL_LibTidy_Document, _
                                            "ptr", DllStructGetPtr($tBuffer), _
                                            "ptr", $pBufLen )
        If @error OR NOT $aRet[0] Then Return SetError(3, @error, "")
        Return DllStructGetData($tBuffer, 1)
    Else
        Return ""
    EndIf
EndFunc
Func _LibTidy_SaveFile ($sPath, $iMode=2)
    Local $sData = _LibTidy_SaveString()
    If @error Then Return SetError(@error, @extended, "")
    
    Local $hFile = FileOpen($sPath, $iMode)
    If $hFile = -1 Then Return SetError(4, 0, "")
    
    Local $fResult = FileWrite($hFile, $sData)
    FileClose($hFile)
    
    If $fResult Then
        Return $sData
    Else
        Return SetError(4, 0, "")
    EndIf
EndFunc
Func _LibTidy_CleanAndRepair ()
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, -1) ; Call Startup first!
    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidyCleanAndRepair", _
                                                    "ptr", $_DLL_LibTidy_Document )
    If @error OR NOT $aRet[0] Then Return SetError(4, @error, -1)
    
    Local $sResult = _LibTidy_SaveString()
    If @error Then Return SetError(@error, @extended, $sResult)
    
    Return $sResult
EndFunc
#cs 
================================================================================
Testbed, uncomment and run
================================================================================
;#include <Array.au3>; REMOVED INCLUDE
Func _Alert ($msg, $fDialog=1)
    If $fDialog Then
        MsgBox(0, @ScriptName, $msg)
    Else
        TrayTip(@ScriptName, $msg, 5000)
    EndIf
EndFunc
Func _Critical ($ret, $rel=0, $msg="Fatal Error", $err=@error, $ext=@extended, $ln = @ScriptLineNumber)
    If $err Then
        $ln += $rel
        Local $LastError = _WinAPI_GetLastError(), _
                    $LastErrorMsg = _WinAPI_GetLastErrorMessage(), _
                    $LastErrorHex = Hex($LastError)
        $LastErrorHex = "0x" & StringMid($LastErrorHex, StringInStr($LastErrorHex, "0", 1, -1)+1)
        $msg &= @CRLF & "at line " & $ln & @CRLF & @CRLF & "AutoIt Error: " & $err & " (0x" & Hex($err)    & ") Extended: " & $ext 
        If $LastError Then $msg &= @CRLF & "WinAPI Error: " & $LastError & " (" & $LastErrorHex & ")" & @CRLF & $LastErrorMsg
        ClipPut($msg)
        MsgBox(270352, "Fatal Error - " & @ScriptName, $msg)
        Exit
    EndIf
    Return $ret
EndFunc
Func _Throw ($msg="Fatal Error", $rel=0, $ln = @ScriptLineNumber)
    _Critical(0, $rel, $msg, 0xDEADF00D, 0, $ln)
EndFunc
_Critical( _LibTidy_Startup() )
_ArrayDisplay($_LibTidy_ConfigInf)
_Critical( _LibTidy_SetOption($_LibTidy__indentSpaces, 4) )
_Critical( _LibTidy_SetOption($_LibTidy__uppercaseTags, True) )
_Critical( _LibTidy_SetOption($_LibTidy__language, "id") )
If NOT _Critical( _LibTidy_ResetConfig() ) Then _Throw("Configuration reset failed")
Local $sFile = FileOpenDialog("Select LibTidy Configuration File", @ScriptDir, "Configuration file (*.cfg)|All files (*.*)")
If @error Then _Throw("Load Configuration File Aborted", -1)
_Critical( _LibTidy_LoadConfig($sFile) )
Local $sFile = FileOpenDialog("Select Web Page", @ScriptDir, "Web page (*.htm;*.html)|All files (*.*)")
If @error Then _Throw("Load Web Page Aborted", -1)
_Critical( _LibTidy_LoadFile($sFile) )
_Critical( _LibTidy_CleanAndRepair() )
Local $sFile = FileSaveDialog("Save As Web Page", @ScriptDir, "Web page (*.htm;*.html)|All files (*.*)")
If @error Then _Throw("Save Web Page Aborted", -1)
ClipPut(_Critical( _LibTidy_SaveFile($sFile) ))
_Alert("Processed page also available on clipboard.")
Local $sFile = FileSaveDialog("Save As LibTidy Configuration File", @ScriptDir, "Configuration file (*.cfg)|All files (*.*)")
If @error Then _Throw("Save Configuration File Aborted", -1)
_Critical( _LibTidy_SaveConfig($sFile) )
_Critical( _LibTidy_Shutdown() )
#ce
;#include <WinAPI.au3>; REMOVED INCLUDE
;#include <WindowsConstants.au3>; REMOVED INCLUDE
;#include <GuiConstantsEx.au3>; REMOVED INCLUDE
;#include <IE.au3>; REMOVED INCLUDE
Global $_HtmlParser_Debug = False
Global $_HtmlParser_Script = ""
Global Const $_HtmlParser_ScriptName = "HtmlParser.au3"
Global Const $tagINTERNET_PROXY_INFO = "dword dwAccessType; ptr lpszProxy; ptr lpszProxyBypass";
Global Const $tagCOPYDATA = _
  "ULONG_PTR;" & _  ; dwData, The data to be passed to the receiving application
  "DWORD;" & _    ; cbData, The size, in bytes, of the data pointed to by the lpData member
  "PTR"          ; lpData, The data to be passed to the receiving application. This member can be NULL.
Func _HtmlParser_Startup ($iPort=843)
    If IsDeclared("_HtmlParser_IE") AND IsObj($_HtmlParser_IE) Then Return 1
    Global $_HtmlParser_Port = $iPort
    __HtmlParser_ParseCmdLine()
    Global $_HtmlParser_HWND = WinWait($_HtmlParser_GUID, "", 5)
    If NOT $_HtmlParser_HWND Then Return SetError(1, 0, 0) ; Daemon failed to start
    WinSetTitle($_HtmlParser_HWND, "", "")
    Global $_HtmlParser_IE = _IEAttach(WinGetHandle($_HtmlParser_GUID), "embedded")
    If NOT IsObj(_HtmlParser_GetDocument()) Then Return SetError(2, 0, 0)
    OnAutoItExitRegister("__HtmlParser_Shutdown")
    Return 1
EndFunc
Func _HtmlParser_GetDocument ()
    If IsObj($_HtmlParser_IE) Then Return _IEDocGetObj($_HtmlParser_IE)
    Return SetError(1, 0, 0)
EndFunc
Func _HtmlParser_LoadHtml ( $sHtml, $fRemoveScriptTags=0 )
    _IENavigate($_HtmlParser_IE, "about:blank")
    Local $doc = _HtmlParser_GetDocument()
    If $fRemoveScriptTags Then $sHtml = StringRegExpReplace($sHtml, "<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>", "")
    $doc.Write($sHtml & @CRLF & '<script language="javascript">' & @CRLF & $_HtmlParser_Script & @CRLF & 'Array.prototype.set=function(i,v){this[i]=v};Array.prototype.get=function(i){return this[i]};document.scripts[document.scripts.length-1].removeNode(false)</script>')
    Return $doc
EndFunc
Func _HtmlParser_LoadUrl ( $sUrl, $fRemoveScriptTags=0 )
    Local $http = ObjCreate("winhttp.winhttprequest.5.1")
    $http.Open("GET", $sUrl)
    $http.Send()
    Return _HtmlParser_LoadHtml($http.Responsetext, $fRemoveScriptTags)
EndFunc
Func _HtmlParser_LoadScript ( $sFilename )
    Local $script = ""
    If FileExists ($sFilename) Then
        $script = FileRead($sFilename)
    Else
        If StringInStr($sFilename, "http://") OR StringInStr($sFilename, "https://") OR StringInStr($sFilename, "ftp://") Then
            Local $http = ObjCreate("winhttp.winhttprequest.5.1")
            $http.Open("GET", $sFilename)
            $http.Send()
            $script = $http.Responsetext
        EndIf
    EndIf
    If $script Then
        $_HtmlParser_Script &= @CRLF & @CRLF & $script
        Return 1
    EndIf
    Return 0
EndFunc
Func _HtmlParser_ClearScript ( $sFilename )
    $_HtmlParser_Script = ""
EndFunc
Func _HtmlParser_Exec ( $sScript )
    Local $doc = _HtmlParser_GetDocument()
    If IsObj($doc) AND IsObj($doc.parentWindow) Then
        Local $window = $doc.parentWindow
        $window.execScript('window._HtmlParser_Result=(function(){' & $sScript & '})();', 'Javascript')
        If $window._HtmlParser_Result OR IsObj($window._HtmlParser_Result) Then
            Return $window._HtmlParser_Result
        Else
            Return SetError(2, 0, 0)
        EndIf
    EndIf
    Return SetError(1, 0, 0)
EndFunc
#region >> Internals
Func __HtmlParser_Shutdown ()
    Global $_HtmlParser_IE = 0
    If IsDeclared("_HtmlParser_HWND") Then WinClose($_HtmlParser_HWND)
    OnAutoItExitUnregister("__HtmlParser_Shutdown")
EndFunc
Func __HtmlParser_ParseCmdLine ()
    If @compiled Then
      Global $_HtmlParser_Exec = '"' & @ScriptFullPath & '"'
    Else
      Global $_HtmlParser_Exec = '"' & @AutoItExe & '" "' & @ScriptFullPath & '"'
    EndIf
    Local $cmd = StringInStr($CmdLineRaw, "/_HtmlParser_", 1), $val
    If $cmd > 0 Then
        #NoTrayIcon
        $cmd = StringRegExp(StringMid($CmdLineRaw, $cmd), '/(_HtmlParser_[a-zA-Z]+)\:"([^"]*)"', 3)
        For $i = 0 To UBound($cmd)-1 Step 2
            $val = $cmd[$i+1]
            If $val = ("" & Number($val)) Then $val = Number($val)
            Assign($cmd[$i], $val, 2)
        Next
        __HtmlParser_DaemonRun()
        Exit
    Else
        Global $_HtmlParser_GUID = __WinAPI_CreateGUID()
        __HtmlParser_Daemonstart()
    EndIf
EndFunc
Func __HtmlParser_Daemonstart ()
    Run ( $_HtmlParser_Exec & _
        ' /_HtmlParser_GUID:"' & $_HtmlParser_GUID & '"' & _
        ' /_HtmlParser_Debug:"' & (0 + $_HtmlParser_Debug) & '"' & _
        ' /_HtmlParser_Port:"' & $_HtmlParser_Port & '"' )
EndFunc
Func __HtmlParser_DaemonRun ()
    Local $hGUI = GUICreate("", 500, 400, 10, 10, $WS_SIZEBOX, $WS_EX_TOOLWINDOW)
    Global $_HtmlParser_IE = _IECreateEmbedded()
    Local $hIE = GUICtrlCreateObj($_HtmlParser_IE, 0, 0, _WinAPI_GetClientWidth($hGUI), _WinAPI_GetClientHeight($hGUI))
    GUICtrlSetResizing($hIE, $GUI_DOCKAUTO)
    GUIRegisterMsg($WM_SYSCOMMAND, "__HtmlParser_SysCommand")
    If $_HtmlParser_Debug Then GUISetState()
    _IE_SetSessionProxy("127.0.0.1:" & $_HtmlParser_Port)
    _IENavigate($_HtmlParser_IE, "about:blank")
    _IEPropertySet($_HtmlParser_IE, "silent", True)
    WinSetTitle($hGUI, "", $_HtmlParser_GUID)
    Local $timeout = TimerInit()
    Do
        If TimerDiff($timeout) > 5000 Then Exit
    Until WinGetTitle($hGUI) <> $_HtmlParser_GUID
    If $_HtmlParser_Debug Then WinSetTitle($hGUI, "", "HtmlParser Debug Window")
    While 1
        Sleep(100)
    WEnd
EndFunc
Func __HtmlParser_SysCommand ($hWnd, $Msg, $wParam, $lParam)
    #forceref $Msg, $wParam, $lParam
    If BitAND($wParam, 0xFFF0) = 0xF060 Then Exit
    Return $GUI_RUNDEFMSG
EndFunc
#endregion << Internals
#region >> WinAPIEx
Func __WinAPI_CreateGUID()
    Local $tGUID, $Ret
    $tGUID = DllStructCreate($tagGUID)
    $Ret = DllCall('ole32.dll', 'uint', 'CoCreateGuid', 'ptr', DllStructGetPtr($tGUID))
    If @error Then
        Return SetError(1, 0, '')
    Else
        If $Ret[0] Then
            Return SetError(1, $Ret[0], 0)
        EndIf
    EndIf
    $Ret = DllCall('ole32.dll', 'int', 'StringFromGUID2', 'ptr', DllStructGetPtr($tGUID), 'wstr', '', 'int', 39)
    If (@error) Or (Not $Ret[0]) Then
        Return SetError(1, 0, '')
    EndIf
    Return $Ret[2]
EndFunc   ;==>__WinAPI_CreateGUID
Func _IE_SetSessionProxy ($sProxyAddress, $sBypassList="")
    Local $tProxyAddress = DllStructCreate("char[" & StringLen($sProxyAddress) + 1 & "]"), _
          $tBypassList = DllStructCreate("char[" & StringLen($sBypassList) + 1 & "]"), _
          $tINTERNET_PROXY_INFO = DllStructCreate($tagINTERNET_PROXY_INFO)
    DllStructSetData($tINTERNET_PROXY_INFO, "dwAccessType", 0x3)
    DllStructSetData($tProxyAddress, 1, $sProxyAddress)
    DllStructSetData($tINTERNET_PROXY_INFO, "lpszProxy", DllStructGetPtr($tProxyAddress))
    DllStructSetData($tBypassList, 1, $sBypassList)
    DllStructSetData($tINTERNET_PROXY_INFO, "lpszProxyBypass", DllStructGetPtr($tBypassList))
    Local $aRet = DllCall("urlmon.dll", "INT", "UrlMkSetSessionOption", _
                            "uint", 0x26, _
                            "ptr", DllStructGetPtr($tINTERNET_PROXY_INFO), _
                            "int", DllStructGetSize($tINTERNET_PROXY_INFO), _
                            "int", 0 )
    If @error OR $aRet[0] Then Return SetError(1, @error, 0)
    Return 1
EndFunc
#endregion << WinAPIEx
#region >> Debugging
Func _Alert ($msg, $fDialog=1)
  If $fDialog Then
    MsgBox(0, @ScriptName, $msg)
  Else
    TrayTip(@ScriptName, $msg, 5000)
  EndIf
EndFunc
Func _Critical ($ret, $rel=0, $msg="Fatal Error", $err=@error, $ext=@extended, $ln = @ScriptLineNumber)
  If $err Then
    $ln += $rel
    Local $LastError = _WinAPI_GetLastError(), _
          $LastErrorMsg = _WinAPI_GetLastErrorMessage(), _
          $LastErrorHex = Hex($LastError)
    $LastErrorHex = "0x" & StringMid($LastErrorHex, StringInStr($LastErrorHex, "0", 1, -1)+1)
    $msg &= @CRLF & "at line " & $ln & @CRLF & @CRLF & "AutoIt Error: " & $err & " (0x" & Hex($err)  & ") Extended: " & $ext
    If $LastError Then $msg &= @CRLF & "WinAPI Error: " & $LastError & " (" & $LastErrorHex & ")" & @CRLF & $LastErrorMsg
    ClipPut($msg)
    MsgBox(270352, "Fatal Error - " & @ScriptName, $msg)
    Exit
  EndIf
  Return $ret
EndFunc
#endregion << Debugging
;#include "AutoItConstants.au3"; REMOVED INCLUDE
;#include "FileConstants.au3"; REMOVED INCLUDE
;#include "MsgBoxConstants.au3"; REMOVED INCLUDE
;#include "Security.au3"; REMOVED INCLUDE
;#include "SendMessage.au3"; REMOVED INCLUDE
;#include "StringConstants.au3"; REMOVED INCLUDE
;#include "StructureConstants.au3"; REMOVED INCLUDE
;#include "WinAPIConstants.au3"; REMOVED INCLUDE
;#include "WinAPIConv.au3"; REMOVED INCLUDE
;#include "WinAPIDlg.au3"; REMOVED INCLUDE
;#include "WinAPIError.au3"; REMOVED INCLUDE
;#include "WinAPIFiles.au3"; REMOVED INCLUDE
;#include "WinAPIGdi.au3"; REMOVED INCLUDE
;#include "WinAPIHObj.au3"; REMOVED INCLUDE
;#include "WinAPIIcons.au3"; REMOVED INCLUDE
;#include "WinAPIMem.au3"; REMOVED INCLUDE
;#include "WinAPIMisc.au3"; REMOVED INCLUDE
;#include "WinAPIProc.au3"; REMOVED INCLUDE
;#include "WinAPIRes.au3"; REMOVED INCLUDE
;#include "WinAPIShellEx.au3"; REMOVED INCLUDE
;#include "WinAPISys.au3"; REMOVED INCLUDE
Global Const $WC_ANIMATE = 'SysAnimate32'
Global Const $WC_BUTTON = 'Button'
Global Const $WC_COMBOBOX = 'ComboBox'
Global Const $WC_COMBOBOXEX = 'ComboBoxEx32'
Global Const $WC_DATETIMEPICK = 'SysDateTimePick32'
Global Const $WC_EDIT = 'Edit'
Global Const $WC_HEADER = 'SysHeader32'
Global Const $WC_HOTKEY = 'msctls_hotkey32'
Global Const $WC_IPADDRESS = 'SysIPAddress32'
Global Const $WC_LINK = 'SysLink'
Global Const $WC_LISTBOX = 'ListBox'
Global Const $WC_LISTVIEW = 'SysListView32'
Global Const $WC_MONTHCAL = 'SysMonthCal32'
Global Const $WC_NATIVEFONTCTL = 'NativeFontCtl'
Global Const $WC_PAGESCROLLER = 'SysPager'
Global Const $WC_PROGRESS = 'msctls_progress32'
Global Const $WC_REBAR = 'ReBarWindow32'
Global Const $WC_SCROLLBAR = 'ScrollBar'
Global Const $WC_STATIC = 'Static'
Global Const $WC_STATUSBAR = 'msctls_statusbar32'
Global Const $WC_TABCONTROL = 'SysTabControl32'
Global Const $WC_TOOLBAR = 'ToolbarWindow32'
Global Const $WC_TOOLTIPS = 'tooltips_class32'
Global Const $WC_TRACKBAR = 'msctls_trackbar32'
Global Const $WC_TREEVIEW = 'SysTreeView32'
Global Const $WC_UPDOWN = 'msctls_updown32'
Global Const $WS_OVERLAPPED = 0
Global Const $WS_TILED = $WS_OVERLAPPED
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_TABSTOP = 0x00010000
Global Const $WS_GROUP = 0x00020000
Global Const $WS_SIZEBOX = 0x00040000
Global Const $WS_THICKFRAME = $WS_SIZEBOX
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_HSCROLL = 0x00100000
Global Const $WS_VSCROLL = 0x00200000
Global Const $WS_DLGFRAME = 0x00400000
Global Const $WS_BORDER = 0x00800000
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_OVERLAPPEDWINDOW = BitOR($WS_CAPTION, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_OVERLAPPED, $WS_SYSMENU, $WS_THICKFRAME)
Global Const $WS_TILEDWINDOW = $WS_OVERLAPPEDWINDOW
Global Const $WS_MAXIMIZE = 0x01000000
Global Const $WS_CLIPCHILDREN = 0x02000000
Global Const $WS_CLIPSIBLINGS = 0x04000000
Global Const $WS_DISABLED = 0x08000000
Global Const $WS_VISIBLE = 0x10000000
Global Const $WS_MINIMIZE = 0x20000000
Global Const $WS_ICONIC = $WS_MINIMIZE
Global Const $WS_CHILD = 0x40000000
Global Const $WS_CHILDWINDOW = $WS_CHILD
Global Const $WS_POPUP = 0x80000000
Global Const $WS_POPUPWINDOW = 0x80880000
Global Const $DS_3DLOOK = 0x0004
Global Const $DS_ABSALIGN = 0x0001
Global Const $DS_CENTER = 0x0800
Global Const $DS_CENTERMOUSE = 0x1000
Global Const $DS_CONTEXTHELP = 0x2000
Global Const $DS_CONTROL = 0x0400
Global Const $DS_FIXEDSYS = 0x0008
Global Const $DS_LOCALEDIT = 0x0020
Global Const $DS_MODALFRAME = 0x0080
Global Const $DS_NOFAILCREATE = 0x0010
Global Const $DS_NOIDLEMSG = 0x0100
Global Const $DS_SETFONT = 0x0040
Global Const $DS_SETFOREGROUND = 0x0200
Global Const $DS_SHELLFONT = BitOR($DS_FIXEDSYS, $DS_SETFONT)
Global Const $DS_SYSMODAL = 0x0002
Global Const $WS_EX_ACCEPTFILES = 0x00000010
Global Const $WS_EX_APPWINDOW = 0x00040000
Global Const $WS_EX_COMPOSITED = 0x02000000
Global Const $WS_EX_CONTROLPARENT = 0x10000
Global Const $WS_EX_CLIENTEDGE = 0x00000200
Global Const $WS_EX_CONTEXTHELP = 0x00000400
Global Const $WS_EX_DLGMODALFRAME = 0x00000001
Global Const $WS_EX_LAYERED = 0x00080000
Global Const $WS_EX_LAYOUTRTL = 0x400000
Global Const $WS_EX_LEFT = 0x00000000
Global Const $WS_EX_LEFTSCROLLBAR = 0x00004000
Global Const $WS_EX_LTRREADING = 0x00000000
Global Const $WS_EX_MDICHILD = 0x00000040
Global Const $WS_EX_NOACTIVATE = 0x08000000
Global Const $WS_EX_NOINHERITLAYOUT = 0x00100000
Global Const $WS_EX_NOPARENTNOTIFY = 0x00000004
Global Const $WS_EX_RIGHT = 0x00001000
Global Const $WS_EX_RIGHTSCROLLBAR = 0x00000000
Global Const $WS_EX_RTLREADING = 0x2000
Global Const $WS_EX_STATICEDGE = 0x00020000
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $WS_EX_TOPMOST = 0x00000008
Global Const $WS_EX_TRANSPARENT = 0x00000020
Global Const $WS_EX_WINDOWEDGE = 0x00000100
Global Const $WS_EX_OVERLAPPEDWINDOW = BitOR($WS_EX_CLIENTEDGE, $WS_EX_WINDOWEDGE)
Global Const $WS_EX_PALETTEWINDOW = BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $WS_EX_WINDOWEDGE)
Global Const $WM_NULL = 0x0000
Global Const $WM_CREATE = 0x0001
Global Const $WM_DESTROY = 0x0002
Global Const $WM_MOVE = 0x0003
Global Const $WM_SIZEWAIT = 0x0004
Global Const $WM_SIZE = 0x0005
Global Const $WM_ACTIVATE = 0x0006
Global Const $WM_SETFOCUS = 0x0007
Global Const $WM_KILLFOCUS = 0x0008
Global Const $WM_SETVISIBLE = 0x0009
Global Const $WM_ENABLE = 0x000A
Global Const $WM_SETREDRAW = 0x000B
Global Const $WM_SETTEXT = 0x000C
Global Const $WM_GETTEXT = 0x000D
Global Const $WM_GETTEXTLENGTH = 0x000E
Global Const $WM_PAINT = 0x000F
Global Const $WM_CLOSE = 0x0010
Global Const $WM_QUERYENDSESSION = 0x0011
Global Const $WM_QUIT = 0x0012
Global Const $WM_ERASEBKGND = 0x0014
Global Const $WM_QUERYOPEN = 0x0013
Global Const $WM_SYSCOLORCHANGE = 0x0015
Global Const $WM_ENDSESSION = 0x0016
Global Const $WM_SYSTEMERROR = 0x0017
Global Const $WM_SHOWWINDOW = 0x0018
Global Const $WM_CTLCOLOR = 0x0019
Global Const $WM_SETTINGCHANGE = 0x001A
Global Const $WM_WININICHANGE = 0x001A
Global Const $WM_DEVMODECHANGE = 0x001B
Global Const $WM_ACTIVATEAPP = 0x001C
Global Const $WM_FONTCHANGE = 0x001D
Global Const $WM_TIMECHANGE = 0x001E
Global Const $WM_CANCELMODE = 0x001F
Global Const $WM_SETCURSOR = 0x0020
Global Const $WM_MOUSEACTIVATE = 0x0021
Global Const $WM_CHILDACTIVATE = 0x0022
Global Const $WM_QUEUESYNC = 0x0023
Global Const $WM_GETMINMAXINFO = 0x0024
Global Const $WM_LOGOFF = 0x0025
Global Const $WM_PAINTICON = 0x0026
Global Const $WM_ICONERASEBKGND = 0x0027
Global Const $WM_NEXTDLGCTL = 0x0028
Global Const $WM_ALTTABACTIVE = 0x0029
Global Const $WM_SPOOLERSTATUS = 0x002A
Global Const $WM_DRAWITEM = 0x002B
Global Const $WM_MEASUREITEM = 0x002C
Global Const $WM_DELETEITEM = 0x002D
Global Const $WM_VKEYTOITEM = 0x002E
Global Const $WM_CHARTOITEM = 0x002F
Global Const $WM_SETFONT = 0x0030
Global Const $WM_GETFONT = 0x0031
Global Const $WM_SETHOTKEY = 0x0032
Global Const $WM_GETHOTKEY = 0x0033
Global Const $WM_FILESYSCHANGE = 0x0034
Global Const $WM_ISACTIVEICON = 0x0035
Global Const $WM_QUERYPARKICON = 0x0036
Global Const $WM_QUERYDRAGICON = 0x0037
Global Const $WM_WINHELP = 0x0038
Global Const $WM_COMPAREITEM = 0x0039
Global Const $WM_FULLSCREEN = 0x003A
Global Const $WM_CLIENTSHUTDOWN = 0x003B
Global Const $WM_DDEMLEVENT = 0x003C
Global Const $WM_GETOBJECT = 0x003D
Global Const $WM_CALCSCROLL = 0x003F
Global Const $WM_TESTING = 0x0040
Global Const $WM_COMPACTING = 0x0041
Global Const $WM_OTHERWINDOWCREATED = 0x0042
Global Const $WM_OTHERWINDOWDESTROYED = 0x0043
Global Const $WM_COMMNOTIFY = 0x0044
Global Const $WM_MEDIASTATUSCHANGE = 0x0045
Global Const $WM_WINDOWPOSCHANGING = 0x0046
Global Const $WM_WINDOWPOSCHANGED = 0x0047
Global Const $WM_POWER = 0x0048
Global Const $WM_COPYGLOBALDATA = 0x0049
Global Const $WM_COPYDATA = 0x004A
Global Const $WM_CANCELJOURNAL = 0x004B
Global Const $WM_LOGONNOTIFY = 0x004C
Global Const $WM_KEYF1 = 0x004D
Global Const $WM_NOTIFY = 0x004E
Global Const $WM_ACCESS_WINDOW = 0x004F
Global Const $WM_INPUTLANGCHANGEREQUEST = 0x0050
Global Const $WM_INPUTLANGCHANGE = 0x0051
Global Const $WM_TCARD = 0x0052
Global Const $WM_HELP = 0x0053
Global Const $WM_USERCHANGED = 0x0054
Global Const $WM_NOTIFYFORMAT = 0x0055
Global Const $WM_QM_ACTIVATE = 0x0060
Global Const $WM_HOOK_DO_CALLBACK = 0x0061
Global Const $WM_SYSCOPYDATA = 0x0062
Global Const $WM_FINALDESTROY = 0x0070
Global Const $WM_MEASUREITEM_CLIENTDATA = 0x0071
Global Const $WM_CONTEXTMENU = 0x007B
Global Const $WM_STYLECHANGING = 0x007C
Global Const $WM_STYLECHANGED = 0x007D
Global Const $WM_DISPLAYCHANGE = 0x007E
Global Const $WM_GETICON = 0x007F
Global Const $WM_SETICON = 0x0080
Global Const $WM_NCCREATE = 0x0081
Global Const $WM_NCDESTROY = 0x0082
Global Const $WM_NCCALCSIZE = 0x0083
Global Const $WM_NCHITTEST = 0x0084
Global Const $WM_NCPAINT = 0x0085
Global Const $WM_NCACTIVATE = 0x0086
Global Const $WM_GETDLGCODE = 0x0087
Global Const $WM_SYNCPAINT = 0x0088
Global Const $WM_SYNCTASK = 0x0089
Global Const $WM_KLUDGEMINRECT = 0x008B
Global Const $WM_LPKDRAWSWITCHWND = 0x008C
Global Const $WM_UAHDESTROYWINDOW = 0x0090
Global Const $WM_UAHDRAWMENU = 0x0091
Global Const $WM_UAHDRAWMENUITEM = 0x0092
Global Const $WM_UAHINITMENU = 0x0093
Global Const $WM_UAHMEASUREMENUITEM = 0x0094
Global Const $WM_UAHNCPAINTMENUPOPUP = 0x0095
Global Const $WM_NCMOUSEMOVE = 0x00A0
Global Const $WM_NCLBUTTONDOWN = 0x00A1
Global Const $WM_NCLBUTTONUP = 0x00A2
Global Const $WM_NCLBUTTONDBLCLK = 0x00A3
Global Const $WM_NCRBUTTONDOWN = 0x00A4
Global Const $WM_NCRBUTTONUP = 0x00A5
Global Const $WM_NCRBUTTONDBLCLK = 0x00A6
Global Const $WM_NCMBUTTONDOWN = 0x00A7
Global Const $WM_NCMBUTTONUP = 0x00A8
Global Const $WM_NCMBUTTONDBLCLK = 0x00A9
Global Const $WM_NCXBUTTONDOWN = 0x00AB
Global Const $WM_NCXBUTTONUP = 0x00AC
Global Const $WM_NCXBUTTONDBLCLK = 0x00AD
Global Const $WM_NCUAHDRAWCAPTION = 0x00AE
Global Const $WM_NCUAHDRAWFRAME = 0x00AF
Global Const $WM_INPUT_DEVICE_CHANGE = 0x00FE
Global Const $WM_INPUT = 0x00FF
Global Const $WM_KEYDOWN = 0x0100
Global Const $WM_KEYFIRST = 0x0100
Global Const $WM_KEYUP = 0x0101
Global Const $WM_CHAR = 0x0102
Global Const $WM_DEADCHAR = 0x0103
Global Const $WM_SYSKEYDOWN = 0x0104
Global Const $WM_SYSKEYUP = 0x0105
Global Const $WM_SYSCHAR = 0x0106
Global Const $WM_SYSDEADCHAR = 0x0107
Global Const $WM_YOMICHAR = 0x0108
Global Const $WM_KEYLAST = 0x0109
Global Const $WM_UNICHAR = 0x0109
Global Const $WM_CONVERTREQUEST = 0x010A
Global Const $WM_CONVERTRESULT = 0x010B
Global Const $WM_IM_INFO = 0x010C
Global Const $WM_IME_STARTCOMPOSITION = 0x010D
Global Const $WM_IME_ENDCOMPOSITION = 0x010E
Global Const $WM_IME_COMPOSITION = 0x010F
Global Const $WM_IME_KEYLAST = 0x010F
Global Const $WM_INITDIALOG = 0x0110
Global Const $WM_COMMAND = 0x0111
Global Const $WM_SYSCOMMAND = 0x0112
Global Const $WM_TIMER = 0x0113
Global Const $WM_HSCROLL = 0x0114
Global Const $WM_VSCROLL = 0x0115
Global Const $WM_INITMENU = 0x0116
Global Const $WM_INITMENUPOPUP = 0x0117
Global Const $WM_SYSTIMER = 0x0118
Global Const $WM_GESTURE = 0x0119
Global Const $WM_GESTURENOTIFY = 0x011A
Global Const $WM_GESTUREINPUT = 0x011B
Global Const $WM_GESTURENOTIFIED = 0x011C
Global Const $WM_MENUSELECT = 0x011F
Global Const $WM_MENUCHAR = 0x0120
Global Const $WM_ENTERIDLE = 0x0121
Global Const $WM_MENURBUTTONUP = 0x0122
Global Const $WM_MENUDRAG = 0x0123
Global Const $WM_MENUGETOBJECT = 0x0124
Global Const $WM_UNINITMENUPOPUP = 0x0125
Global Const $WM_MENUCOMMAND = 0x0126
Global Const $WM_CHANGEUISTATE = 0x0127
Global Const $WM_UPDATEUISTATE = 0x0128
Global Const $WM_QUERYUISTATE = 0x0129
Global Const $WM_LBTRACKPOINT = 0x0131
Global Const $WM_CTLCOLORMSGBOX = 0x0132
Global Const $WM_CTLCOLOREDIT = 0x0133
Global Const $WM_CTLCOLORLISTBOX = 0x0134
Global Const $WM_CTLCOLORBTN = 0x0135
Global Const $WM_CTLCOLORDLG = 0x0136
Global Const $WM_CTLCOLORSCROLLBAR = 0x0137
Global Const $WM_CTLCOLORSTATIC = 0x0138
Global Const $MN_GETHMENU = 0x01E1
Global Const $WM_PARENTNOTIFY = 0x0210
Global Const $WM_ENTERMENULOOP = 0x0211
Global Const $WM_EXITMENULOOP = 0x0212
Global Const $WM_NEXTMENU = 0x0213
Global Const $WM_SIZING = 0x0214
Global Const $WM_CAPTURECHANGED = 0x0215
Global Const $WM_MOVING = 0x0216
Global Const $WM_POWERBROADCAST = 0x0218
Global Const $WM_DEVICECHANGE = 0x0219
Global Const $WM_MDICREATE = 0x0220
Global Const $WM_MDIDESTROY = 0x0221
Global Const $WM_MDIACTIVATE = 0x0222
Global Const $WM_MDIRESTORE = 0x0223
Global Const $WM_MDINEXT = 0x0224
Global Const $WM_MDIMAXIMIZE = 0x0225
Global Const $WM_MDITILE = 0x0226
Global Const $WM_MDICASCADE = 0x0227
Global Const $WM_MDIICONARRANGE = 0x0228
Global Const $WM_MDIGETACTIVE = 0x0229
Global Const $WM_DROPOBJECT = 0x022A
Global Const $WM_QUERYDROPOBJECT = 0x022B
Global Const $WM_BEGINDRAG = 0x022C
Global Const $WM_DRAGLOOP = 0x022D
Global Const $WM_DRAGSELECT = 0x022E
Global Const $WM_DRAGMOVE = 0x022F
Global Const $WM_MDISETMENU = 0x0230
Global Const $WM_ENTERSIZEMOVE = 0x0231
Global Const $WM_EXITSIZEMOVE = 0x0232
Global Const $WM_DROPFILES = 0x0233
Global Const $WM_MDIREFRESHMENU = 0x0234
Global Const $WM_TOUCH = 0x0240
Global Const $WM_IME_SETCONTEXT = 0x0281
Global Const $WM_IME_NOTIFY = 0x0282
Global Const $WM_IME_CONTROL = 0x0283
Global Const $WM_IME_COMPOSITIONFULL = 0x0284
Global Const $WM_IME_SELECT = 0x0285
Global Const $WM_IME_CHAR = 0x0286
Global Const $WM_IME_SYSTEM = 0x0287
Global Const $WM_IME_REQUEST = 0x0288
Global Const $WM_IME_KEYDOWN = 0x0290
Global Const $WM_IME_KEYUP = 0x0291
Global Const $WM_NCMOUSEHOVER = 0x02A0
Global Const $WM_MOUSEHOVER = 0x02A1
Global Const $WM_NCMOUSELEAVE = 0x02A2
Global Const $WM_MOUSELEAVE = 0x02A3
Global Const $WM_WTSSESSION_CHANGE = 0x02B1
Global Const $WM_TABLET_FIRST = 0x02C0
Global Const $WM_TABLET_LAST = 0x02DF
Global Const $WM_CUT = 0x0300
Global Const $WM_COPY = 0x0301
Global Const $WM_PASTE = 0x0302
Global Const $WM_CLEAR = 0x0303
Global Const $WM_UNDO = 0x0304
Global Const $WM_PALETTEISCHANGING = 0x0310
Global Const $WM_HOTKEY = 0x0312
Global Const $WM_PALETTECHANGED = 0x0311
Global Const $WM_SYSMENU = 0x0313
Global Const $WM_HOOKMSG = 0x0314
Global Const $WM_EXITPROCESS = 0x0315
Global Const $WM_WAKETHREAD = 0x0316
Global Const $WM_PRINT = 0x0317
Global Const $WM_PRINTCLIENT = 0x0318
Global Const $WM_APPCOMMAND = 0x0319
Global Const $WM_QUERYNEWPALETTE = 0x030F
Global Const $WM_THEMECHANGED = 0x031A
Global Const $WM_UAHINIT = 0x031B
Global Const $WM_DESKTOPNOTIFY = 0x031C
Global Const $WM_CLIPBOARDUPDATE = 0x031D
Global Const $WM_DWMCOMPOSITIONCHANGED = 0x031E
Global Const $WM_DWMNCRENDERINGCHANGED = 0x031F
Global Const $WM_DWMCOLORIZATIONCOLORCHANGED = 0x0320
Global Const $WM_DWMWINDOWMAXIMIZEDCHANGE = 0x0321
Global Const $WM_DWMEXILEFRAME = 0x0322
Global Const $WM_DWMSENDICONICTHUMBNAIL = 0x0323
Global Const $WM_MAGNIFICATION_STARTED = 0x0324
Global Const $WM_MAGNIFICATION_ENDED = 0x0325
Global Const $WM_DWMSENDICONICLIVEPREVIEWBITMAP = 0x0326
Global Const $WM_DWMTHUMBNAILSIZECHANGED = 0x0327
Global Const $WM_MAGNIFICATION_OUTPUT = 0x0328
Global Const $WM_MEASURECONTROL = 0x0330
Global Const $WM_GETACTIONTEXT = 0x0331
Global Const $WM_FORWARDKEYDOWN = 0x0333
Global Const $WM_FORWARDKEYUP = 0x0334
Global Const $WM_GETTITLEBARINFOEX = 0x033F
Global Const $WM_NOTIFYWOW = 0x0340
Global Const $WM_HANDHELDFIRST = 0x0358
Global Const $WM_HANDHELDLAST = 0x035F
Global Const $WM_AFXFIRST = 0x0360
Global Const $WM_AFXLAST = 0x037F
Global Const $WM_PENWINFIRST = 0x0380
Global Const $WM_PENWINLAST = 0x038F
Global Const $WM_DDE_INITIATE = 0x03E0
Global Const $WM_DDE_TERMINATE = 0x03E1
Global Const $WM_DDE_ADVISE = 0x03E2
Global Const $WM_DDE_UNADVISE = 0x03E3
Global Const $WM_DDE_ACK = 0x03E4
Global Const $WM_DDE_DATA = 0x03E5
Global Const $WM_DDE_REQUEST = 0x03E6
Global Const $WM_DDE_POKE = 0x03E7
Global Const $WM_DDE_EXECUTE = 0x03E8
Global Const $WM_DBNOTIFICATION = 0x03FD
Global Const $WM_NETCONNECT = 0x03FE
Global Const $WM_HIBERNATE = 0x03FF
Global Const $WM_USER = 0x0400
Global Const $WM_APP = 0x8000
Global Const $NM_FIRST = 0
Global Const $NM_OUTOFMEMORY = $NM_FIRST - 1
Global Const $NM_CLICK = $NM_FIRST - 2
Global Const $NM_DBLCLK = $NM_FIRST - 3
Global Const $NM_RETURN = $NM_FIRST - 4
Global Const $NM_RCLICK = $NM_FIRST - 5
Global Const $NM_RDBLCLK = $NM_FIRST - 6
Global Const $NM_SETFOCUS = $NM_FIRST - 7
Global Const $NM_KILLFOCUS = $NM_FIRST - 8
Global Const $NM_CUSTOMDRAW = $NM_FIRST - 12
Global Const $NM_HOVER = $NM_FIRST - 13
Global Const $NM_NCHITTEST = $NM_FIRST - 14
Global Const $NM_KEYDOWN = $NM_FIRST - 15
Global Const $NM_RELEASEDCAPTURE = $NM_FIRST - 16
Global Const $NM_SETCURSOR = $NM_FIRST - 17
Global Const $NM_CHAR = $NM_FIRST - 18
Global Const $NM_TOOLTIPSCREATED = $NM_FIRST - 19
Global Const $NM_LDOWN = $NM_FIRST - 20
Global Const $NM_RDOWN = $NM_FIRST - 21
Global Const $NM_THEMECHANGED = $NM_FIRST - 22
Global Const $WM_MOUSEFIRST = 0x0200
Global Const $WM_MOUSEMOVE = 0x0200
Global Const $WM_LBUTTONDOWN = 0x0201
Global Const $WM_LBUTTONUP = 0x0202
Global Const $WM_LBUTTONDBLCLK = 0x0203
Global Const $WM_RBUTTONDOWN = 0x0204
Global Const $WM_RBUTTONUP = 0x0205
Global Const $WM_RBUTTONDBLCLK = 0x0206
Global Const $WM_MBUTTONDOWN = 0x0207
Global Const $WM_MBUTTONUP = 0x0208
Global Const $WM_MBUTTONDBLCLK = 0x0209
Global Const $WM_MOUSEWHEEL = 0x020A
Global Const $WM_XBUTTONDOWN = 0x020B
Global Const $WM_XBUTTONUP = 0x020C
Global Const $WM_XBUTTONDBLCLK = 0x020D
Global Const $WM_MOUSEHWHEEL = 0x020E
Global Const $PS_SOLID = 0
Global Const $PS_DASH = 1
Global Const $PS_DOT = 2
Global Const $PS_DASHDOT = 3
Global Const $PS_DASHDOTDOT = 4
Global Const $PS_NULL = 5
Global Const $PS_INSIDEFRAME = 6
Global Const $PS_USERSTYLE = 7
Global Const $PS_ALTERNATE = 8
Global Const $PS_ENDCAP_ROUND = 0x00000000
Global Const $PS_ENDCAP_SQUARE = 0x00000100
Global Const $PS_ENDCAP_FLAT = 0x00000200
Global Const $PS_JOIN_BEVEL = 0x00001000
Global Const $PS_JOIN_MITER = 0x00002000
Global Const $PS_JOIN_ROUND = 0x00000000
Global Const $PS_GEOMETRIC = 0x00010000
Global Const $PS_COSMETIC = 0x00000000
Global Const $LWA_ALPHA = 0x2
Global Const $LWA_COLORKEY = 0x1
Global Const $RGN_AND = 1
Global Const $RGN_OR = 2
Global Const $RGN_XOR = 3
Global Const $RGN_DIFF = 4
Global Const $RGN_COPY = 5
Global Const $ERRORREGION = 0
Global Const $NULLREGION = 1
Global Const $SIMPLEREGION = 2
Global Const $COMPLEXREGION = 3
Global Const $TRANSPARENT = 1
Global Const $OPAQUE = 2
Global Const $CCM_FIRST = 0x2000
Global Const $CCM_GETUNICODEFORMAT = ($CCM_FIRST + 6)
Global Const $CCM_SETUNICODEFORMAT = ($CCM_FIRST + 5)
Global Const $CCM_SETBKCOLOR = $CCM_FIRST + 1
Global Const $CCM_SETCOLORSCHEME = $CCM_FIRST + 2
Global Const $CCM_GETCOLORSCHEME = $CCM_FIRST + 3
Global Const $CCM_GETDROPTARGET = $CCM_FIRST + 4
Global Const $CCM_SETWINDOWTHEME = $CCM_FIRST + 11
Global Const $GA_PARENT = 1
Global Const $GA_ROOT = 2
Global Const $GA_ROOTOWNER = 3
Global Const $SM_CXSCREEN = 0
Global Const $SM_CYSCREEN = 1
Global Const $SM_CXVSCROLL = 2
Global Const $SM_CYHSCROLL = 3
Global Const $SM_CYCAPTION = 4
Global Const $SM_CXBORDER = 5
Global Const $SM_CYBORDER = 6
Global Const $SM_CXFIXEDFRAME = 7
Global Const $SM_CXDLGFRAME = $SM_CXFIXEDFRAME
Global Const $SM_CYFIXEDFRAME = 8
Global Const $SM_CYDLGFRAME = $SM_CYFIXEDFRAME
Global Const $SM_CYVTHUMB = 9
Global Const $SM_CXHTHUMB = 10
Global Const $SM_CXICON = 11
Global Const $SM_CYICON = 12
Global Const $SM_CXCURSOR = 13
Global Const $SM_CYCURSOR = 14
Global Const $SM_CYMENU = 15
Global Const $SM_CXFULLSCREEN = 16
Global Const $SM_CYFULLSCREEN = 17
Global Const $SM_CYKANJIWINDOW = 18
Global Const $SM_MOUSEPRESENT = 19
Global Const $SM_CYVSCROLL = 20
Global Const $SM_CXHSCROLL = 21
Global Const $SM_DEBUG = 22
Global Const $SM_SWAPBUTTON = 23
Global Const $SM_RESERVED1 = 24
Global Const $SM_RESERVED2 = 25
Global Const $SM_RESERVED3 = 26
Global Const $SM_RESERVED4 = 27
Global Const $SM_CXMIN = 28
Global Const $SM_CYMIN = 29
Global Const $SM_CXSIZE = 30
Global Const $SM_CYSIZE = 31
Global Const $SM_CXSIZEFRAME = 32
Global Const $SM_CXFRAME = $SM_CXSIZEFRAME
Global Const $SM_CYSIZEFRAME = 33
Global Const $SM_CYFRAME = $SM_CYSIZEFRAME
Global Const $SM_CXMINTRACK = 34
Global Const $SM_CYMINTRACK = 35
Global Const $SM_CXDOUBLECLK = 36
Global Const $SM_CYDOUBLECLK = 37
Global Const $SM_CXICONSPACING = 38
Global Const $SM_CYICONSPACING = 39
Global Const $SM_MENUDROPALIGNMENT = 40
Global Const $SM_PENWINDOWS = 41
Global Const $SM_DBCSENABLED = 42
Global Const $SM_CMOUSEBUTTONS = 43
Global Const $SM_SECURE = 44
Global Const $SM_CXEDGE = 45
Global Const $SM_CYEDGE = 46
Global Const $SM_CXMINSPACING = 47
Global Const $SM_CYMINSPACING = 48
Global Const $SM_CXSMICON = 49
Global Const $SM_CYSMICON = 50
Global Const $SM_CYSMCAPTION = 51
Global Const $SM_CXSMSIZE = 52
Global Const $SM_CYSMSIZE = 53
Global Const $SM_CXMENUSIZE = 54
Global Const $SM_CYMENUSIZE = 55
Global Const $SM_ARRANGE = 56
Global Const $SM_CXMINIMIZED = 57
Global Const $SM_CYMINIMIZED = 58
Global Const $SM_CXMAXTRACK = 59
Global Const $SM_CYMAXTRACK = 60
Global Const $SM_CXMAXIMIZED = 61
Global Const $SM_CYMAXIMIZED = 62
Global Const $SM_NETWORK = 63
Global Const $SM_CLEANBOOT = 67
Global Const $SM_CXDRAG = 68
Global Const $SM_CYDRAG = 69
Global Const $SM_SHOWSOUNDS = 70
Global Const $SM_CXMENUCHECK = 71
Global Const $SM_CYMENUCHECK = 72
Global Const $SM_SLOWMACHINE = 73
Global Const $SM_MIDEASTENABLED = 74
Global Const $SM_MOUSEWHEELPRESENT = 75
Global Const $SM_XVIRTUALSCREEN = 76
Global Const $SM_YVIRTUALSCREEN = 77
Global Const $SM_CXVIRTUALSCREEN = 78
Global Const $SM_CYVIRTUALSCREEN = 79
Global Const $SM_CMONITORS = 80
Global Const $SM_SAMEDISPLAYFORMAT = 81
Global Const $SM_IMMENABLED = 82
Global Const $SM_CXFOCUSBORDER = 83
Global Const $SM_CYFOCUSBORDER = 84
Global Const $SM_TABLETPC = 86
Global Const $SM_MEDIACENTER = 87
Global Const $SM_STARTER = 88
Global Const $SM_SERVERR2 = 89
Global Const $SM_CMETRICS = 90
Global Const $SM_REMOTESESSION = 0x1000
Global Const $SM_SHUTTINGDOWN = 0x2000
Global Const $SM_REMOTECONTROL = 0x2001
Global Const $SM_CARETBLINKINGENABLED = 0x2002
Global Const $BLACKNESS = 0x00000042 ; Fills the destination rectangle using the color associated with index 0 in the physical palette
Global Const $CAPTUREBLT = 0X40000000 ; Includes any window that are layered on top of your window in the resulting image
Global Const $DSTINVERT = 0x00550009 ; Inverts the destination rectangle
Global Const $MERGECOPY = 0x00C000CA ; Copies the inverted source rectangle to the destination
Global Const $MERGEPAINT = 0x00BB0226 ; Merges the color of the inverted source rectangle with the colors of the destination rectangle by using the OR operator
Global Const $NOMIRRORBITMAP = 0X80000000 ; Prevents the bitmap from being mirrored
Global Const $NOTSRCCOPY = 0x00330008 ; Copies the inverted source rectangle to the destination
Global Const $NOTSRCERASE = 0x001100A6 ; Combines the colors of the source and destination rectangles by using the Boolean OR operator and then inverts the resultant color
Global Const $PATCOPY = 0x00F00021 ; Copies the brush selected in hdcDest, into the destination bitmap
Global Const $PATINVERT = 0x005A0049 ; Combines the colors of the brush currently selected  in  hDest,  with  the  colors  of  the destination rectangle by using the XOR operator
Global Const $PATPAINT = 0x00FB0A09 ; Combines the colors of the brush currently selected  in  hDest,  with  the  colors  of  the inverted source rectangle by using the OR operator
Global Const $SRCAND = 0x008800C6 ; Combines the colors of the source and destination rectangles by using the Boolean AND operator
Global Const $SRCCOPY = 0x00CC0020 ; Copies the source rectangle directly to the destination rectangle
Global Const $SRCERASE = 0x00440328 ; Combines the inverted colors of the destination rectangle with the colors of the source rectangle by using the Boolean AND operator
Global Const $SRCINVERT = 0x00660046 ; Combines the colors of the source and destination rectangles by using the Boolean XOR operator
Global Const $SRCPAINT = 0x00EE0086 ; Combines the colors of the source and destination rectangles by using the Boolean OR operator
Global Const $WHITENESS = 0x00FF0062 ; Fills the destination rectangle using the color associated with index 1 in the physical palette
Global Const $DT_BOTTOM = 0x8
Global Const $DT_CALCRECT = 0x400
Global Const $DT_CENTER = 0x1
Global Const $DT_EDITCONTROL = 0x2000
Global Const $DT_END_ELLIPSIS = 0x8000
Global Const $DT_EXPANDTABS = 0x40
Global Const $DT_EXTERNALLEADING = 0x200
Global Const $DT_HIDEPREFIX = 0x100000
Global Const $DT_INTERNAL = 0x1000
Global Const $DT_LEFT = 0x0
Global Const $DT_MODIFYSTRING = 0x10000
Global Const $DT_NOCLIP = 0x100
Global Const $DT_NOFULLWIDTHCHARBREAK = 0x80000
Global Const $DT_NOPREFIX = 0x800
Global Const $DT_PATH_ELLIPSIS = 0x4000
Global Const $DT_PREFIXONLY = 0x200000
Global Const $DT_RIGHT = 0x2
Global Const $DT_RTLREADING = 0x20000
Global Const $DT_SINGLELINE = 0x20
Global Const $DT_TABSTOP = 0x80
Global Const $DT_TOP = 0x0
Global Const $DT_VCENTER = 0x4
Global Const $DT_WORDBREAK = 0x10
Global Const $DT_WORD_ELLIPSIS = 0x40000
Global Const $RDW_ERASE = 0x0004 ; Causes the window to receive a WM_ERASEBKGND message when the window is repainted
Global Const $RDW_FRAME = 0x0400 ; Causes any part of the nonclient area of the window that intersects the update region to receive a WM_NCPAINT message
Global Const $RDW_INTERNALPAINT = 0x0002 ; Causes a WM_PAINT message to be posted to the window regardless of whether any portion of the window is invalid
Global Const $RDW_INVALIDATE = 0x0001 ; Invalidates DllStructGetData($tRECT or $hRegion, "") If both are 0, the entire window is invalidated
Global Const $RDW_NOERASE = 0x0020 ; Suppresses any pending WM_ERASEBKGND messages
Global Const $RDW_NOFRAME = 0x0800 ; Suppresses any pending WM_NCPAINT messages
Global Const $RDW_NOINTERNALPAINT = 0x0010 ; Suppresses any pending internal WM_PAINT messages
Global Const $RDW_VALIDATE = 0x0008 ; Validates Rect or hRegion
Global Const $RDW_ERASENOW = 0x0200 ; Causes the affected windows to receive WM_NCPAINT and WM_ERASEBKGND messages
Global Const $RDW_UPDATENOW = 0x0100 ; Causes the affected windows to receive WM_NCPAINT, WM_ERASEBKGND, and WM_PAINT messages
Global Const $RDW_ALLCHILDREN = 0x0080 ; Includes child windows in the repainting operation
Global Const $RDW_NOCHILDREN = 0x0040 ; Excludes child windows from the repainting operation
Global Const $WM_RENDERFORMAT = 0x0305 ; Sent if the owner has delayed rendering a specific clipboard format
Global Const $WM_RENDERALLFORMATS = 0x0306 ; Sent if the owner has delayed rendering clipboard formats
Global Const $WM_DESTROYCLIPBOARD = 0x0307 ; Sent when a call to EmptyClipboard empties the clipboard
Global Const $WM_DRAWCLIPBOARD = 0x0308 ; Sent when the content of the clipboard changes
Global Const $WM_PAINTCLIPBOARD = 0x0309 ; Sent when the clipboard viewer's client area needs repainting
Global Const $WM_VSCROLLCLIPBOARD = 0x030A ; Sent when an event occurs in the viewer's vertical scroll bar
Global Const $WM_SIZECLIPBOARD = 0x030B ; Sent when the clipboard viewer's client area has changed size
Global Const $WM_ASKCBFORMATNAME = 0x030C ; Sent to request the name of a $CF_OWNERDISPLAY clipboard format
Global Const $WM_CHANGECBCHAIN = 0x030D ; Sent when a window is being removed from the chain
Global Const $WM_HSCROLLCLIPBOARD = 0x030E ; Sent when an event occurs in the viewer's horizontal scroll bar
Global Const $HTERROR = -2
Global Const $HTTRANSPARENT = -1
Global Const $HTNOWHERE = 0
Global Const $HTCLIENT = 1
Global Const $HTCAPTION = 2
Global Const $HTSYSMENU = 3
Global Const $HTGROWBOX = 4
Global Const $HTSIZE = $HTGROWBOX
Global Const $HTMENU = 5
Global Const $HTHSCROLL = 6
Global Const $HTVSCROLL = 7
Global Const $HTMINBUTTON = 8
Global Const $HTMAXBUTTON = 9
Global Const $HTLEFT = 10
Global Const $HTRIGHT = 11
Global Const $HTTOP = 12
Global Const $HTTOPLEFT = 13
Global Const $HTTOPRIGHT = 14
Global Const $HTBOTTOM = 15
Global Const $HTBOTTOMLEFT = 16
Global Const $HTBOTTOMRIGHT = 17
Global Const $HTBORDER = 18
Global Const $HTREDUCE = $HTMINBUTTON
Global Const $HTZOOM = $HTMAXBUTTON
Global Const $HTSIZEFIRST = $HTLEFT
Global Const $HTSIZELAST = $HTBOTTOMRIGHT
Global Const $HTOBJECT = 19
Global Const $HTCLOSE = 20
Global Const $HTHELP = 21
Global Const $COLOR_SCROLLBAR = 0
Global Const $COLOR_BACKGROUND = 1
Global Const $COLOR_ACTIVECAPTION = 2
Global Const $COLOR_INACTIVECAPTION = 3
Global Const $COLOR_MENU = 4
Global Const $COLOR_WINDOW = 5
Global Const $COLOR_WINDOWFRAME = 6
Global Const $COLOR_MENUTEXT = 7
Global Const $COLOR_WINDOWTEXT = 8
Global Const $COLOR_CAPTIONTEXT = 9
Global Const $COLOR_ACTIVEBORDER = 10
Global Const $COLOR_INACTIVEBORDER = 11
Global Const $COLOR_APPWORKSPACE = 12
Global Const $COLOR_HIGHLIGHT = 13
Global Const $COLOR_HIGHLIGHTTEXT = 14
Global Const $COLOR_BTNFACE = 15
Global Const $COLOR_BTNSHADOW = 16
Global Const $COLOR_GRAYTEXT = 17
Global Const $COLOR_BTNTEXT = 18
Global Const $COLOR_INACTIVECAPTIONTEXT = 19
Global Const $COLOR_BTNHIGHLIGHT = 20
Global Const $COLOR_3DDKSHADOW = 21
Global Const $COLOR_3DLIGHT = 22
Global Const $COLOR_INFOTEXT = 23
Global Const $COLOR_INFOBK = 24
Global Const $COLOR_HOTLIGHT = 26
Global Const $COLOR_GRADIENTACTIVECAPTION = 27
Global Const $COLOR_GRADIENTINACTIVECAPTION = 28
Global Const $COLOR_MENUHILIGHT = 29
Global Const $COLOR_MENUBAR = 30
Global Const $COLOR_DESKTOP = 1
Global Const $COLOR_3DFACE = 15
Global Const $COLOR_3DSHADOW = 16
Global Const $COLOR_3DHIGHLIGHT = 20
Global Const $COLOR_3DHILIGHT = 20
Global Const $COLOR_BTNHILIGHT = 20
Global Const $HINST_COMMCTRL = -1
Global Const $IDB_STD_SMALL_COLOR = 0
Global Const $IDB_STD_LARGE_COLOR = 1
Global Const $IDB_VIEW_SMALL_COLOR = 4
Global Const $IDB_VIEW_LARGE_COLOR = 5
Global Const $IDB_HIST_SMALL_COLOR = 8
Global Const $IDB_HIST_LARGE_COLOR = 9
Global Const $STARTF_FORCEOFFFEEDBACK = 0x80
Global Const $STARTF_FORCEONFEEDBACK = 0x40
Global Const $STARTF_PREVENTPINNING = 0x00002000
Global Const $STARTF_RUNFULLSCREEN = 0x20
Global Const $STARTF_TITLEISAPPID = 0x00001000
Global Const $STARTF_TITLEISLINKNAME = 0x00000800
Global Const $STARTF_USECOUNTCHARS = 0x8
Global Const $STARTF_USEFILLATTRIBUTE = 0x10
Global Const $STARTF_USEHOTKEY = 0x200
Global Const $STARTF_USEPOSITION = 0x4
Global Const $STARTF_USESHOWWINDOW = 0x1
Global Const $STARTF_USESIZE = 0x2
Global Const $STARTF_USESTDHANDLES = 0x100
Global Const $CDDS_PREPAINT = 0x00000001
Global Const $CDDS_POSTPAINT = 0x00000002
Global Const $CDDS_PREERASE = 0x00000003
Global Const $CDDS_POSTERASE = 0x00000004
Global Const $CDDS_ITEM = 0x00010000
Global Const $CDDS_ITEMPREPAINT = 0x00010001
Global Const $CDDS_ITEMPOSTPAINT = 0x00010002
Global Const $CDDS_ITEMPREERASE = 0x00010003
Global Const $CDDS_ITEMPOSTERASE = 0x00010004
Global Const $CDDS_SUBITEM = 0x00020000
Global Const $CDIS_SELECTED = 0x0001
Global Const $CDIS_GRAYED = 0x0002
Global Const $CDIS_DISABLED = 0x0004
Global Const $CDIS_CHECKED = 0x0008
Global Const $CDIS_FOCUS = 0x0010
Global Const $CDIS_DEFAULT = 0x0020
Global Const $CDIS_HOT = 0x0040
Global Const $CDIS_MARKED = 0x0080
Global Const $CDIS_INDETERMINATE = 0x0100
Global Const $CDIS_SHOWKEYBOARDCUES = 0x0200
Global Const $CDIS_NEARHOT = 0x0400
Global Const $CDIS_OTHERSIDEHOT = 0x0800
Global Const $CDIS_DROPHILITED = 0x1000
Global Const $CDRF_DODEFAULT = 0x00000000
Global Const $CDRF_NEWFONT = 0x00000002
Global Const $CDRF_SKIPDEFAULT = 0x00000004
Global Const $CDRF_NOTIFYPOSTPAINT = 0x00000010
Global Const $CDRF_NOTIFYITEMDRAW = 0x00000020
Global Const $CDRF_NOTIFYSUBITEMDRAW = 0x00000020
Global Const $CDRF_NOTIFYPOSTERASE = 0x00000040
Global Const $CDRF_DOERASE = 0x00000008
Global Const $CDRF_SKIPPOSTPAINT = 0x00000100
Global Const $GUI_SS_DEFAULT_GUI = BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
Global Const $GUI_EVENT_SINGLE = 0 ; (default) Returns a single event.
Global Const $GUI_EVENT_ARRAY = 1 ; returns an array containing the event and extended information.
Global Const $GUI_EVENT_NONE = 0
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_EVENT_MINIMIZE = -4
Global Const $GUI_EVENT_RESTORE = -5
Global Const $GUI_EVENT_MAXIMIZE = -6
Global Const $GUI_EVENT_PRIMARYDOWN = -7
Global Const $GUI_EVENT_PRIMARYUP = -8
Global Const $GUI_EVENT_SECONDARYDOWN = -9
Global Const $GUI_EVENT_SECONDARYUP = -10
Global Const $GUI_EVENT_MOUSEMOVE = -11
Global Const $GUI_EVENT_RESIZED = -12
Global Const $GUI_EVENT_DROPPED = -13
Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $GUI_AVISTOP = 0
Global Const $GUI_AVISTART = 1
Global Const $GUI_AVICLOSE = 2
Global Const $GUI_CHECKED = 1
Global Const $GUI_INDETERMINATE = 2
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_DROPACCEPTED = 8
Global Const $GUI_NODROPACCEPTED = 4096
Global Const $GUI_ACCEPTFILES = $GUI_DROPACCEPTED ; to be suppressed
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_FOCUS = 256
Global Const $GUI_NOFOCUS = 8192
Global Const $GUI_DEFBUTTON = 512
Global Const $GUI_EXPAND = 1024
Global Const $GUI_ONTOP = 2048
Global Const $GUI_FONTNORMAL = 0
Global Const $GUI_FONTITALIC = 2
Global Const $GUI_FONTUNDER = 4
Global Const $GUI_FONTSTRIKE = 8
Global Const $GUI_DOCKAUTO = 0x0001
Global Const $GUI_DOCKLEFT = 0x0002
Global Const $GUI_DOCKRIGHT = 0x0004
Global Const $GUI_DOCKHCENTER = 0x0008
Global Const $GUI_DOCKTOP = 0x0020
Global Const $GUI_DOCKBOTTOM = 0x0040
Global Const $GUI_DOCKVCENTER = 0x0080
Global Const $GUI_DOCKWIDTH = 0x0100
Global Const $GUI_DOCKHEIGHT = 0x0200
Global Const $GUI_DOCKSIZE = 0x0300 ; width+height
Global Const $GUI_DOCKMENUBAR = 0x0220 ; top+height
Global Const $GUI_DOCKSTATEBAR = 0x0240 ; bottom+height
Global Const $GUI_DOCKALL = 0x0322 ; left+top+width+height
Global Const $GUI_DOCKBORDERS = 0x0066 ; left+top+right+bottom
Global Const $GUI_GR_CLOSE = 1
Global Const $GUI_GR_LINE = 2
Global Const $GUI_GR_BEZIER = 4
Global Const $GUI_GR_MOVE = 6
Global Const $GUI_GR_COLOR = 8
Global Const $GUI_GR_RECT = 10
Global Const $GUI_GR_ELLIPSE = 12
Global Const $GUI_GR_PIE = 14
Global Const $GUI_GR_DOT = 16
Global Const $GUI_GR_PIXEL = 18
Global Const $GUI_GR_HINT = 20
Global Const $GUI_GR_REFRESH = 22
Global Const $GUI_GR_PENSIZE = 24
Global Const $GUI_GR_NOBKCOLOR = -2
Global Const $GUI_BKCOLOR_DEFAULT = -1
Global Const $GUI_BKCOLOR_TRANSPARENT = -2
Global Const $GUI_BKCOLOR_LV_ALTERNATE = 0xFE000000
Global Const $GUI_READ_DEFAULT = 0 ; (Default) Returns a value with state or data of a control.
Global Const $GUI_READ_EXTENDED = 1 ; Returns extended information of a control (see Remarks).
Global Const $GUI_CURSOR_NOOVERRIDE = 0 ; (default) Don't override a control's default mouse cursor.
Global Const $GUI_CURSOR_OVERRIDE = 1 ; override control's default mouse cursor.
Global Const $GUI_WS_EX_PARENTDRAG = 0x00100000
;#include "AutoItConstants.au3"; REMOVED INCLUDE
;#include "FileConstants.au3"; REMOVED INCLUDE
;#include "WinAPIError.au3"; REMOVED INCLUDE
#Region Header
#cs
	Title:   Internet Explorer Automation UDF Library for AutoIt3
	Filename:  IE.au3
	Description: A collection of functions for creating, attaching to, reading from and manipulating Internet Explorer
	Author:   DaleHohm
	Modified: jpm, Jon
	Version:  T3.0-2
	Last Update: 14/08/19
	Requirements: AutoIt3 3.3.9 or higher
	Update History:
	===================================================
	T3.0-2 14/8/19
	Enhancements
	- Updated  __IEErrorHandlerRegister to work with or without COM errors being fatal
	T3.0-1 13/6/2
	Enhancements
	- Fixed _IE_Introduction, _IE_Examples generate HTML5
	- Added check in __IEComErrorUnrecoverable for COM error -2147023174, "RPC server not accessible."
	- Fixed check in __IEComErrorUnrecoverable for COM error -2147024891, "Access is denied."
	- Fixed check in __IEComErrorUnrecoverable for COM error  -2147352567, "an exception has occurred."
	- Fixed __IEIsObjType() not restoring _IEErrorNotify()
	- Fixed $b_mustUnlock on Error in _IECreate()
	- Fixed no timeout cheking if error in _IELoadWait()
	- Fixed HTML5 support in _IEImgClick(), _IEFormImageClick()
	- Fixed _IEHeadInsertEventScript() COM error return
	- Updated _IEErrorNotify() default keyword support
	- Updated rename __IENotify() to __IEConsoleWriteError() and restore calling  @error
	- Removed __IEInternalErrorHandler() (not used any more)
	- Updated Function Headers
	- Updated doc and splitting and checking examples
	T3.0-0 12/9/3
	Fixes
	- Removed _IEErrorHandlerRegister() and all internal calls to it.  Unneeded as COM errors are no longer fatal
	- Removed code deprecated in V2
	- Fixed _IELoadWait check for unrecoverable COM errors
	- Removed Vcard support from _IEPropertyGet (IE removed support in IE7)
	- Code cleanup with #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6
	New Features
	- Added "scrollIntoView" to _IEAction
	Enhancements
	- Added check in __IEComErrorUnrecoverable for COM error -2147023179, "The interface is unknown."
	- Added "Trap COM error, report and return" to functions that perform blind method calls (those without return values)
	===================================================
#ce
#EndRegion Header
#Region Global Variables
Global $__g_iIELoadWaitTimeout = 300000 ; 5 Minutes
Global $__g_bIEAU3Debug = False
Global $__g_bIEErrorNotify = True
Global $__g_oIEErrorHandler, $__g_sIEUserErrorHandler
#EndRegion Global Variables
#Region Global Constants
Global Const $__gaIEAU3VersionInfo[6] = ["T", 3, 0, 2, "20140819", "T3.0-2"]
Global Const $LSFW_LOCK = 1, $LSFW_UNLOCK = 2
Global Enum _; Error Status Types
		$_IESTATUS_Success = 0, _
		$_IESTATUS_GeneralError, _
		$_IESTATUS_ComError, _
		$_IESTATUS_InvalidDataType, _
		$_IESTATUS_InvalidObjectType, _
		$_IESTATUS_InvalidValue, _
		$_IESTATUS_LoadWaitTimeout, _
		$_IESTATUS_NoMatch, _
		$_IESTATUS_AccessIsDenied, _
		$_IESTATUS_ClientDisconnected
#EndRegion Global Constants
#Region Core functions
Func _IECreate($sUrl = "about:blank", $iTryAttach = 0, $iVisible = 1, $iWait = 1, $iTakeFocus = 1)
	If Not $iVisible Then $iTakeFocus = 0 ; Force takeFocus to 0 for hidden window
	If $iTryAttach Then
		Local $oResult = _IEAttach($sUrl, "url")
		If IsObj($oResult) Then
			If $iTakeFocus Then WinActivate(HWnd($oResult.hWnd))
			Return SetError($_IESTATUS_Success, 1, $oResult)
		EndIf
	EndIf
	Local $iMustUnlock = 0
	If Not $iVisible And __IELockSetForegroundWindow($LSFW_LOCK) Then $iMustUnlock = 1
	Local $oObject = ObjCreate("InternetExplorer.Application")
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IECreate", "", "Browser Object Creation Failed")
		If $iMustUnlock Then __IELockSetForegroundWindow($LSFW_UNLOCK)
		Return SetError($_IESTATUS_GeneralError, 0, 0)
	EndIf
	$oObject.visible = $iVisible
	If $iMustUnlock And Not __IELockSetForegroundWindow($LSFW_UNLOCK) Then __IEConsoleWriteError("Warning", "_IECreate", "", "Foreground Window Unlock Failed!")
	_IENavigate($oObject, $sUrl, $iWait)
	Local $iError = @error
	If Not $iError And StringLeft($sUrl, 6) = "about:" Then
		Local $oDocument = $oObject.document
		_IEAction($oDocument, "focus")
	EndIf
	Return SetError($iError, 0, $oObject)
EndFunc   ;==>_IECreate
Func _IECreateEmbedded()
	Local $oObject = ObjCreate("Shell.Explorer.2")
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IECreateEmbedded", "", "WebBrowser Object Creation Failed")
		Return SetError($_IESTATUS_GeneralError, 0, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, $oObject)
EndFunc   ;==>_IECreateEmbedded
Func _IENavigate(ByRef $oObject, $sUrl, $iWait = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IENavigate", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "documentContainer") Then
		__IEConsoleWriteError("Error", "_IENavigate", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$oObject.navigate($sUrl)
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IENavigate", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	If $iWait Then
		_IELoadWait($oObject)
		Return SetError(@error, 0, -1)
	EndIf
	Return SetError($_IESTATUS_Success, 0, -1)
EndFunc   ;==>_IENavigate
Func _IEAttach($sString, $sMode = "title", $iInstance = 1)
	$sMode = StringLower($sMode)
	$iInstance = Int($iInstance)
	If $iInstance < 1 Then
		__IEConsoleWriteError("Error", "_IEAttach", "$_IESTATUS_InvalidValue", "$iInstance < 1")
		Return SetError($_IESTATUS_InvalidValue, 3, 0)
	EndIf
	If $sMode = "embedded" Or $sMode = "dialogbox" Then
		Local $iWinTitleMatchMode = Opt("WinTitleMatchMode", $OPT_MATCHANY)
		If $sMode = "dialogbox" And $iInstance > 1 Then
			If IsHWnd($sString) Then
				$iInstance = 1
				__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_GeneralError", "$iInstance > 1 invalid with HWnd and DialogBox.  Setting to 1.")
			Else
				Local $aWinlist = WinList($sString, "")
				If $iInstance <= $aWinlist[0][0] Then
					$sString = $aWinlist[$iInstance][1]
					$iInstance = 1
				Else
					__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_NoMatch")
					Opt("WinTitleMatchMode", $iWinTitleMatchMode)
					Return SetError($_IESTATUS_NoMatch, 1, 0)
				EndIf
			EndIf
		EndIf
		Local $hControl = ControlGetHandle($sString, "", "[CLASS:Internet Explorer_Server; INSTANCE:" & $iInstance & "]")
		Local $oResult = __IEControlGetObjFromHWND($hControl)
		Opt("WinTitleMatchMode", $iWinTitleMatchMode)
		If IsObj($oResult) Then
			Return SetError($_IESTATUS_Success, 0, $oResult)
		Else
			__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 1, 0)
		EndIf
	EndIf
	Local $oShell = ObjCreate("Shell.Application")
	Local $oShellWindows = $oShell.Windows(); collection of all ShellWindows (IE and File Explorer)
	Local $iTmp = 1
	Local $iNotifyStatus, $bIsBrowser, $sTmp
	Local $bStatus
	For $oWindow In $oShellWindows
		$bIsBrowser = True
		$bStatus = __IEInternalErrorHandlerRegister()
		If Not $bStatus Then __IEConsoleWriteError("Warning", "_IEAttach", _
				"Cannot register internal error handler, cannot trap COM errors", _
				"Use _IEErrorHandlerRegister() to register a user error handler")
		$iNotifyStatus = _IEErrorNotify() ; save current error notify status
		_IEErrorNotify(False)
		If $bIsBrowser Then
			$sTmp = $oWindow.type ; Is .type a valid property?
			If @error Then $bIsBrowser = False
		EndIf
		If $bIsBrowser Then
			$sTmp = $oWindow.document.title ; Does object have a .document and .title property?
			If @error Then $bIsBrowser = False
		EndIf
		_IEErrorNotify($iNotifyStatus) ; restore notification status
		__IEInternalErrorHandlerDeRegister()
		If $bIsBrowser Then
			Switch $sMode
				Case "title"
					If StringInStr($oWindow.document.title, $sString) > 0 Then
						If $iInstance = $iTmp Then
							Return SetError($_IESTATUS_Success, 0, $oWindow)
						Else
							$iTmp += 1
						EndIf
					EndIf
				Case "instance"
					If $iInstance = $iTmp Then
						Return SetError($_IESTATUS_Success, 0, $oWindow)
					Else
						$iTmp += 1
					EndIf
				Case "windowtitle"
					Local $bFound = False
					$sTmp = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\", "Window Title")
					If Not @error Then
						If StringInStr($oWindow.document.title & " - " & $sTmp, $sString) Then $bFound = True
					Else
						If StringInStr($oWindow.document.title & " - Microsoft Internet Explorer", $sString) Then $bFound = True
						If StringInStr($oWindow.document.title & " - Windows Internet Explorer", $sString) Then $bFound = True
					EndIf
					If $bFound Then
						If $iInstance = $iTmp Then
							Return SetError($_IESTATUS_Success, 0, $oWindow)
						Else
							$iTmp += 1
						EndIf
					EndIf
				Case "url"
					If StringInStr($oWindow.LocationURL, $sString) > 0 Then
						If $iInstance = $iTmp Then
							Return SetError($_IESTATUS_Success, 0, $oWindow)
						Else
							$iTmp += 1
						EndIf
					EndIf
				Case "text"
					If StringInStr($oWindow.document.body.innerText, $sString) > 0 Then
						If $iInstance = $iTmp Then
							Return SetError($_IESTATUS_Success, 0, $oWindow)
						Else
							$iTmp += 1
						EndIf
					EndIf
				Case "html"
					If StringInStr($oWindow.document.body.innerHTML, $sString) > 0 Then
						If $iInstance = $iTmp Then
							Return SetError($_IESTATUS_Success, 0, $oWindow)
						Else
							$iTmp += 1
						EndIf
					EndIf
				Case "hwnd"
					If $iInstance > 1 Then
						$iInstance = 1
						__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_GeneralError", "$iInstance > 1 invalid with HWnd.  Setting to 1.")
					EndIf
					If _IEPropertyGet($oWindow, "hwnd") = $sString Then
						Return SetError($_IESTATUS_Success, 0, $oWindow)
					EndIf
				Case Else
					__IEConsoleWriteError("Error", "_IEAttach", "$_IESTATUS_InvalidValue", "Invalid Mode Specified")
					Return SetError($_IESTATUS_InvalidValue, 2, 0)
			EndSwitch
		EndIf
	Next
	__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_NoMatch")
	Return SetError($_IESTATUS_NoMatch, 1, 0)
EndFunc   ;==>_IEAttach
Func _IELoadWait(ByRef $oObject, $iDelay = 0, $iTimeout = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IELoadWait", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IELoadWait", "$_IESTATUS_InvalidObjectType", ObjName($oObject))
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Local $oTemp, $bAbort = False, $iErrorStatusCode = $_IESTATUS_Success
	Local $bStatus = __IEInternalErrorHandlerRegister()
	If Not $bStatus Then __IEConsoleWriteError("Warning", "_IELoadWait", _
			"Cannot register internal error handler, cannot trap COM errors", _
			"Use _IEErrorHandlerRegister() to register a user error handler")
	Local $iNotifyStatus = _IEErrorNotify() ; save current error notify status
	_IEErrorNotify(False)
	Sleep($iDelay)
	Local $iError
	Local $hIELoadWaitTimer = TimerInit()
	If $iTimeout = -1 Then $iTimeout = $__g_iIELoadWaitTimeout
	Select
		Case __IEIsObjType($oObject, "browser", False); Internet Explorer
			While Not (String($oObject.readyState) = "complete" Or $oObject.readyState = 4 Or $bAbort)
				If @error Then
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
					EndIf
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				EndIf
				Sleep(100)
			WEnd
			While Not (String($oObject.document.readyState) = "complete" Or $oObject.document.readyState = 4 Or $bAbort)
				If @error Then
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
					EndIf
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				EndIf
				Sleep(100)
			WEnd
		Case __IEIsObjType($oObject, "window", False) ; Window, Frame, iFrame
			While Not (String($oObject.document.readyState) = "complete" Or $oObject.document.readyState = 4 Or $bAbort)
				If @error Then
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
					EndIf
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				EndIf
				Sleep(100)
			WEnd
			While Not (String($oObject.top.document.readyState) = "complete" Or $oObject.top.document.readyState = 4 Or $bAbort)
				If @error Then
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
					EndIf
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				EndIf
				Sleep(100)
			WEnd
		Case __IEIsObjType($oObject, "document", False) ; Document
			$oTemp = $oObject.parentWindow
			While Not (String($oTemp.document.readyState) = "complete" Or $oTemp.document.readyState = 4 Or $bAbort)
				If @error Then
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
					EndIf
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				EndIf
				Sleep(100)
			WEnd
			While Not (String($oTemp.top.document.readyState) = "complete" Or $oTemp.top.document.readyState = 4 Or $bAbort)
				If @error Then
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
					EndIf
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				EndIf
				Sleep(100)
			WEnd
		Case Else ; this should work with any other DOM object
			$oTemp = $oObject.document.parentWindow
			While Not (String($oTemp.document.readyState) = "complete" Or $oTemp.document.readyState = 4 Or $bAbort)
				If @error Then
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
					EndIf
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				EndIf
				Sleep(100)
			WEnd
			While Not (String($oTemp.top.document.readyState) = "complete" Or $oObject.top.document.readyState = 4 Or $bAbort)
				If @error Then
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
					EndIf
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				EndIf
				Sleep(100)
			WEnd
	EndSelect
	_IEErrorNotify($iNotifyStatus) ; restore notification status
	__IEInternalErrorHandlerDeRegister()
	Switch $iErrorStatusCode
		Case $_IESTATUS_Success
			Return SetError($_IESTATUS_Success, 0, 1)
		Case $_IESTATUS_LoadWaitTimeout
			__IEConsoleWriteError("Warning", "_IELoadWait", "$_IESTATUS_LoadWaitTimeout")
			Return SetError($_IESTATUS_LoadWaitTimeout, 3, 0)
		Case $_IESTATUS_AccessIsDenied
			__IEConsoleWriteError("Warning", "_IELoadWait", "$_IESTATUS_AccessIsDenied", _
					"Cannot verify readyState.  Likely casue: cross-domain scripting security restriction. (" & $iError & ")")
			Return SetError($_IESTATUS_AccessIsDenied, 0, 0)
		Case $_IESTATUS_ClientDisconnected
			__IEConsoleWriteError("Error", "_IELoadWait", "$_IESTATUS_ClientDisconnected", _
					$iError & ", Browser has been deleted prior to operation.")
			Return SetError($_IESTATUS_ClientDisconnected, 0, 0)
		Case Else
			__IEConsoleWriteError("Error", "_IELoadWait", "$_IESTATUS_GeneralError", "Invalid Error Status - Notify IE.au3 developer")
			Return SetError($_IESTATUS_GeneralError, 0, 0)
	EndSwitch
EndFunc   ;==>_IELoadWait
Func _IELoadWaitTimeout($iTimeout = -1)
	If $iTimeout = -1 Then
		Return SetError($_IESTATUS_Success, 0, $__g_iIELoadWaitTimeout)
	Else
		$__g_iIELoadWaitTimeout = $iTimeout
		Return SetError($_IESTATUS_Success, 0, 1)
	EndIf
EndFunc   ;==>_IELoadWaitTimeout
#EndRegion Core functions
#Region Frame Functions
Func _IEIsFrameSet(ByRef $oObject)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEIsFrameSet", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If String($oObject.document.body.tagName) = "frameset" Then
		Return SetError($_IESTATUS_Success, 0, 1)
	Else
		If @error Then ; Trap COM error, report and return
			__IEConsoleWriteError("Error", "_IEIsFrameSet", "$_IESTATUS_COMError", @error)
			Return SetError($_IESTATUS_ComError, @error, 0)
		EndIf
		Return SetError($_IESTATUS_Success, 0, 0)
	EndIf
EndFunc   ;==>_IEIsFrameSet
Func _IEFrameGetCollection(ByRef $oObject, $iIndex = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFrameGetCollection", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	$iIndex = Number($iIndex)
	Select
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oObject.document.parentwindow.frames.length, _
					$oObject.document.parentwindow.frames)
		Case $iIndex > -1 And $iIndex < $oObject.document.parentwindow.frames.length
			Return SetError($_IESTATUS_Success, $oObject.document.parentwindow.frames.length, _
					$oObject.document.parentwindow.frames.item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IEFrameGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
		Case Else
			__IEConsoleWriteError("Warning", "_IEFrameGetCollection", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 2, 0)
	EndSelect
EndFunc   ;==>_IEFrameGetCollection
Func _IEFrameGetObjByName(ByRef $oObject, $sName)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFrameGetObjByName", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $oTemp, $oFrames
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IEFrameGetObjByName", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	If __IEIsObjType($oObject, "document") Then
		$oTemp = $oObject.parentWindow
	Else
		$oTemp = $oObject.document.parentWindow
	EndIf
	If _IEIsFrameSet($oTemp) Then
		$oFrames = _IETagNameGetCollection($oTemp, "frame")
	Else
		$oFrames = _IETagNameGetCollection($oTemp, "iframe")
	EndIf
	If $oFrames.length Then
		For $oFrame In $oFrames
			If String($oFrame.name) = $sName Then Return SetError($_IESTATUS_Success, 0, $oTemp.frames($sName))
		Next
		__IEConsoleWriteError("Warning", "_IEFrameGetObjByName", "$_IESTATUS_NoMatch", "No frames matching name")
		Return SetError($_IESTATUS_NoMatch, 2, 0)
	Else
		__IEConsoleWriteError("Warning", "_IEFrameGetObjByName", "$_IESTATUS_NoMatch", "No Frames found")
		Return SetError($_IESTATUS_NoMatch, 2, 0)
	EndIf
EndFunc   ;==>_IEFrameGetObjByName
#EndRegion Frame Functions
#Region Link functions
Func _IELinkClickByText(ByRef $oObject, $sLinkText, $iIndex = 0, $iWait = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IELinkClickByText", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $iFound = 0, $sModeLinktext, $oLinks = $oObject.document.links
	$iIndex = Number($iIndex)
	For $oLink In $oLinks
		$sModeLinktext = String($oLink.outerText)
		If $sModeLinktext = $sLinkText Then
			If ($iFound = $iIndex) Then
				$oLink.click()
				If @error Then ; Trap COM error, report and return
					__IEConsoleWriteError("Error", "_IELinkClickByText", "$_IESTATUS_COMError", @error)
					Return SetError($_IESTATUS_ComError, @error, 0)
				EndIf
				If $iWait Then
					_IELoadWait($oObject)
					Return SetError(@error, 0, -1)
				EndIf
				Return SetError($_IESTATUS_Success, 0, -1)
			EndIf
			$iFound = $iFound + 1
		EndIf
	Next
	__IEConsoleWriteError("Warning", "_IELinkClickByText", "$_IESTATUS_NoMatch")
	Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 3 or both
EndFunc   ;==>_IELinkClickByText
Func _IELinkClickByIndex(ByRef $oObject, $iIndex, $iWait = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IELinkClickByIndex", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $oLinks = $oObject.document.links, $oLink
	$iIndex = Number($iIndex)
	If ($iIndex >= 0) And ($iIndex <= $oLinks.length - 1) Then
		$oLink = $oLinks($iIndex)
		$oLink.click()
		If @error Then ; Trap COM error, report and return
			__IEConsoleWriteError("Error", "_IELinkClickByIndex", "$_IESTATUS_COMError", @error)
			Return SetError($_IESTATUS_ComError, @error, 0)
		EndIf
		If $iWait Then
			_IELoadWait($oObject)
			Return SetError(@error, 0, -1)
		EndIf
		Return SetError($_IESTATUS_Success, 0, -1)
	Else
		__IEConsoleWriteError("Warning", "_IELinkClickByIndex", "$_IESTATUS_NoMatch")
		Return SetError($_IESTATUS_NoMatch, 2, 0)
	EndIf
EndFunc   ;==>_IELinkClickByIndex
Func _IELinkGetCollection(ByRef $oObject, $iIndex = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IELinkGetCollection", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	$iIndex = Number($iIndex)
	Select
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oObject.document.links.length, _
					$oObject.document.links)
		Case $iIndex > -1 And $iIndex < $oObject.document.links.length
			Return SetError($_IESTATUS_Success, $oObject.document.links.length, _
					$oObject.document.links.item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IELinkGetCollection", "$_IESTATUS_InvalidValue")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
		Case Else
			__IEConsoleWriteError("Warning", "_IELinkGetCollection", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 2, 0)
	EndSelect
EndFunc   ;==>_IELinkGetCollection
#EndRegion Link functions
#Region Image functions
Func _IEImgClick(ByRef $oObject, $sLinkText, $sMode = "src", $iIndex = 0, $iWait = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEImgClick", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $sModeLinktext, $iFound = 0, $oImgs = $oObject.document.images
	$sMode = StringLower($sMode)
	$iIndex = Number($iIndex)
	For $oImg In $oImgs
		Select
			Case $sMode = "alt"
				$sModeLinktext = $oImg.alt
			Case $sMode = "name"
				$sModeLinktext = $oImg.name
				If Not IsString($sModeLinktext) Then $sModeLinktext = $oImg.id ; html5 support
			Case $sMode = "id"
				$sModeLinktext = $oImg.id
			Case $sMode = "src"
				$sModeLinktext = $oImg.src
			Case Else
				__IEConsoleWriteError("Error", "_IEImgClick", "$_IESTATUS_InvalidValue", "Invalid mode: " & $sMode)
				Return SetError($_IESTATUS_InvalidValue, 3, 0)
		EndSelect
		If StringInStr($sModeLinktext, $sLinkText) Then
			If ($iFound = $iIndex) Then
				$oImg.click()
				If @error Then ; Trap COM error, report and return
					__IEConsoleWriteError("Error", "_IEImgClick", "$_IESTATUS_COMError", @error)
					Return SetError($_IESTATUS_ComError, @error, 0)
				EndIf
				If $iWait Then
					_IELoadWait($oObject)
					Return SetError(@error, 0, -1)
				EndIf
				Return SetError($_IESTATUS_Success, 0, -1)
			EndIf
			$iFound = $iFound + 1
		EndIf
	Next
	__IEConsoleWriteError("Warning", "_IEImgClick", "$_IESTATUS_NoMatch")
	Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 4 or both
EndFunc   ;==>_IEImgClick
Func _IEImgGetCollection(ByRef $oObject, $iIndex = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEImgGetCollection", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $oTemp = _IEDocGetObj($oObject)
	$iIndex = Number($iIndex)
	Select
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oTemp.images.length, $oTemp.images)
		Case $iIndex > -1 And $iIndex < $oTemp.images.length
			Return SetError($_IESTATUS_Success, $oTemp.images.length, $oTemp.images.item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IEImgGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
		Case Else
			__IEConsoleWriteError("Warning", "_IEImgGetCollection", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 1, 0)
	EndSelect
EndFunc   ;==>_IEImgGetCollection
#EndRegion Image functions
#Region Form functions
Func _IEFormGetCollection(ByRef $oObject, $iIndex = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormGetCollection", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $oTemp = _IEDocGetObj($oObject)
	$iIndex = Number($iIndex)
	Select
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oTemp.forms.length, $oTemp.forms)
		Case $iIndex > -1 And $iIndex < $oTemp.forms.length
			Return SetError($_IESTATUS_Success, $oTemp.forms.length, $oTemp.forms.item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IEFormGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
		Case Else
			__IEConsoleWriteError("Warning", "_IEFormGetCollection", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 1, 0)
	EndSelect
EndFunc   ;==>_IEFormGetCollection
Func _IEFormGetObjByName(ByRef $oObject, $sName, $iIndex = 0)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormGetObjByName", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $iLength = 0
	Local $oCol = $oObject.document.forms.item($sName)
	If IsObj($oCol) Then
		If __IEIsObjType($oCol, "elementcollection") Then
			$iLength = $oCol.length
		Else
			$iLength = 1
		EndIf
	EndIf
	$iIndex = Number($iIndex)
	If $iIndex = -1 Then
		Return SetError($_IESTATUS_Success, $iLength, $oObject.document.forms.item($sName))
	Else
		If IsObj($oObject.document.forms.item($sName, $iIndex)) Then
			Return SetError($_IESTATUS_Success, $iLength, $oObject.document.forms.item($sName, $iIndex))
		Else
			__IEConsoleWriteError("Warning", "_IEFormGetObjByName", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 3 or both
		EndIf
	EndIf
EndFunc   ;==>_IEFormGetObjByName
Func _IEFormElementGetCollection(ByRef $oObject, $iIndex = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormElementGetCollection", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "form") Then
		__IEConsoleWriteError("Error", "_IEFormElementGetCollection", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$iIndex = Number($iIndex)
	Select
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oObject.elements.length, $oObject.elements)
		Case $iIndex > -1 And $iIndex < $oObject.elements.length
			Return SetError($_IESTATUS_Success, $oObject.elements.length, $oObject.elements.item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IEFormElementGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
		Case Else
			Return SetError($_IESTATUS_NoMatch, 1, 0)
	EndSelect
EndFunc   ;==>_IEFormElementGetCollection
Func _IEFormElementGetObjByName(ByRef $oObject, $sName, $iIndex = 0)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormElementGetObjByName", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "form") Then
		__IEConsoleWriteError("Error", "_IEFormElementGetObjByName", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Local $iLength = 0
	Local $oCol = $oObject.elements.item($sName)
	If IsObj($oCol) Then
		If __IEIsObjType($oCol, "elementcollection") Then
			$iLength = $oCol.length
		Else
			$iLength = 1
		EndIf
	EndIf
	$iIndex = Number($iIndex)
	If $iIndex = -1 Then
		Return SetError($_IESTATUS_Success, $iLength, $oObject.elements.item($sName))
	Else
		If IsObj($oObject.elements.item($sName, $iIndex)) Then
			Return SetError($_IESTATUS_Success, $iLength, $oObject.elements.item($sName, $iIndex))
		Else
			__IEConsoleWriteError("Warning", "_IEFormElementGetObjByName", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 3 or both
		EndIf
	EndIf
EndFunc   ;==>_IEFormElementGetObjByName
Func _IEFormElementGetValue(ByRef $oObject)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormElementGetValue", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "forminputelement") Then
		__IEConsoleWriteError("Error", "_IEFormElementGetValue", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Local $sReturn = String($oObject.value)
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEFormElementGetValue", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	SetError($_IESTATUS_Success)
	Return $sReturn
EndFunc   ;==>_IEFormElementGetValue
Func _IEFormElementSetValue(ByRef $oObject, $sNewValue, $iFireEvent = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormElementSetValue", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "forminputelement") Then
		__IEConsoleWriteError("Error", "_IEFormElementSetValue", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	If String($oObject.type) = "file" Then
		__IEConsoleWriteError("Error", "_IEFormElementSetValue", "$_IESTATUS_InvalidObjectType", "Browser security prevents SetValue of TYPE=FILE")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$oObject.value = $sNewValue
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEFormElementSetValue", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	If $iFireEvent Then
		$oObject.fireEvent("OnChange")
		$oObject.fireEvent("OnClick")
	EndIf
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEFormElementSetValue
Func _IEFormElementOptionSelect(ByRef $oObject, $sString, $iSelect = 1, $sMode = "byValue", $iFireEvent = 1)
    If Not IsObj($oObject) Then
        __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidDataType")
        Return SetError($_IESTATUS_InvalidDataType, 1, 0)
    EndIf
    If Not __IEIsObjType($oObject, "formselectelement") Then
        __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidObjectType")
        Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
    EndIf
    Local $oItem, $oItems = $oObject.options, $iNumItems = $oObject.options.length, $bIsMultiple = $oObject.multiple
    Switch $sMode
        Case "byValue"
            For $oItem In $oItems
                If $oItem.value = $sString Then
                    Switch $iSelect
                        Case -1
                            Return SetError($_IESTATUS_Success, 0, $oItem.selected)
                        Case 0
                            If Not $bIsMultiple Then
                                __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", _
                                        "$iSelect=0 only valid for type=select multiple")
                                Return SetError($_IESTATUS_InvalidValue, 3)
                            EndIf
                            If $oItem.selected Then
                                $oItem.selected = False
                                If $iFireEvent Then
                                    $oObject.fireEvent("onChange")
                                    $oObject.fireEvent("OnClick")
                                EndIf
                            EndIf
                            Return SetError($_IESTATUS_Success, 0, 1)
                        Case 1
                            If Not $oItem.selected Then
                                $oItem.selected = True
                                If $iFireEvent Then
                                    $oObject.fireEvent("onChange")
                                    $oObject.fireEvent("OnClick")
                                EndIf
                            EndIf
                            Return SetError($_IESTATUS_Success, 0, 1)
                        Case Else
                            __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid $iSelect value")
                            Return SetError($_IESTATUS_InvalidValue, 3, 0)
                    EndSwitch
                EndIf
            Next
            __IEConsoleWriteError("Warning", "_IEFormElementOptionSelect", "$_IESTATUS_NoMatch", "Value not matched")
            Return SetError($_IESTATUS_NoMatch, 2, 0)
        Case "byText"
            For $oItem In $oItems
                If String($oItem.text) = $sString Then
                    Switch $iSelect
                        Case -1
                            Return SetError($_IESTATUS_Success, 0, $oItem.selected)
                        Case 0
                            If Not $bIsMultiple Then
                                __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", _
                                        "$iSelect=0 only valid for type=select multiple")
                                Return SetError($_IESTATUS_InvalidValue, 3)
                            EndIf
                            If $oItem.selected Then
                                $oItem.selected = False
                                If $iFireEvent Then
                                    $oObject.fireEvent("onChange")
                                    $oObject.fireEvent("OnClick")
                                EndIf
                            EndIf
                            Return SetError($_IESTATUS_Success, 0, 1)
                        Case 1
                            If Not $oItem.selected Then
                                $oItem.selected = True
                                If $iFireEvent Then
                                    $oObject.fireEvent("onChange")
                                    $oObject.fireEvent("OnClick")
                                EndIf
                            EndIf
                            Return SetError($_IESTATUS_Success, 0, 1)
                        Case Else
                            __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid $iSelect value")
                            Return SetError($_IESTATUS_InvalidValue, 3, 0)
                    EndSwitch
                EndIf
            Next
            __IEConsoleWriteError("Warning", "_IEFormElementOptionSelect", "$_IESTATUS_NoMatch", "Text not matched")
            Return SetError($_IESTATUS_NoMatch, 2, 0)
        Case "byIndex"
            Local $iIndex = Number($sString)
            If $iIndex < 0 Or $iIndex >= $iNumItems Then
                __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid index value, " & $iIndex)
                Return SetError($_IESTATUS_InvalidValue, 2, 0)
            EndIf
            $oItem = $oItems.item($iIndex)
            Switch $iSelect
                Case -1
                    Return SetError($_IESTATUS_Success, 0, $oItems.item($iIndex).selected)
                Case 0
                    If Not $bIsMultiple Then
                        __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", _
                                "$iSelect=0 only valid for type=select multiple")
                        Return SetError($_IESTATUS_InvalidValue, 3)
                    EndIf
                    If $oItem.selected Then
                        $oItems.item($iIndex).selected = False
                        If $iFireEvent Then
                            $oObject.fireEvent("onChange")
                            $oObject.fireEvent("OnClick")
                        EndIf
                    EndIf
                    Return SetError($_IESTATUS_Success, 0, 1)
                Case 1
                    If Not $oItem.selected Then
                        $oItems.item($iIndex).selected = True
                        If $iFireEvent Then
                            $oObject.fireEvent("onChange")
                            $oObject.fireEvent("OnClick")
                        EndIf
                    EndIf
                    Return SetError($_IESTATUS_Success, 0, 1)
                Case Else
                    __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid $iSelect value")
                    Return SetError($_IESTATUS_InvalidValue, 3, 0)
            EndSwitch
        Case Else
            __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid Mode")
            Return SetError($_IESTATUS_InvalidValue, 4, 0)
    EndSwitch
EndFunc   ;==>_IEFormElementOptionSelect
Func _IEFormElementCheckBoxSelect(ByRef $oObject, $sString, $sName = "", $iSelect = 1, $sMode = "byValue", $iFireEvent = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormElementCheckBoxSelect", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "form") Then
		__IEConsoleWriteError("Error", "_IEFormElementCheckBoxSelect", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$sString = String($sString)
	$sName = String($sName)
	Local $oItems
	If $sName = "" Then
		$oItems = _IETagNameGetCollection($oObject, "input")
	Else
		$oItems = Execute("$oObject.elements('" & $sName & "')")
	EndIf
	If Not IsObj($oItems) Then
		__IEConsoleWriteError("Warning", "_IEFormElementCheckBoxSelect", "$_IESTATUS_NoMatch")
		Return SetError($_IESTATUS_NoMatch, 3, 0)
	EndIf
	Local $oItem, $bFound = False
	Switch $sMode
		Case "byValue"
			If __IEIsObjType($oItems, "forminputelement") Then
				$oItem = $oItems
				If String($oItem.type) = "checkbox" And String($oItem.value) = $sString Then $bFound = True
			Else
				For $oItem In $oItems
					If String($oItem.type) = "checkbox" And String($oItem.value) = $sString Then
						$bFound = True
						ExitLoop
					EndIf
				Next
			EndIf
		Case "byIndex"
			If __IEIsObjType($oItems, "forminputelement") Then
				$oItem = $oItems
				If String($oItem.type) = "checkbox" And Number($sString) = 0 Then $bFound = True
			Else
				Local $iCount = 0
				For $oItem In $oItems
					If String($oItem.type) = "checkbox" And Number($sString) = $iCount Then
						$bFound = True
						ExitLoop
					Else
						If String($oItem.type) = "checkbox" Then $iCount += 1
					EndIf
				Next
			EndIf
		Case Else
			__IEConsoleWriteError("Error", "_IEFormElementCheckBoxSelect", "$_IESTATUS_InvalidValue", "Invalid Mode")
			Return SetError($_IESTATUS_InvalidValue, 5, 0)
	EndSwitch
	If Not $bFound Then
		__IEConsoleWriteError("Warning", "_IEFormElementCheckBoxSelect", "$_IESTATUS_NoMatch")
		Return SetError($_IESTATUS_NoMatch, 2, 0)
	EndIf
	Switch $iSelect
		Case -1
			Return SetError($_IESTATUS_Success, 0, $oItem.checked)
		Case 0
			If $oItem.checked Then
				$oItem.checked = False
				If $iFireEvent Then
					$oItem.fireEvent("onChange")
					$oItem.fireEvent("OnClick")
				EndIf
			EndIf
			Return SetError($_IESTATUS_Success, 0, 1)
		Case 1
			If Not $oItem.checked Then
				$oItem.checked = True
				If $iFireEvent Then
					$oItem.fireEvent("onChange")
					$oItem.fireEvent("OnClick")
				EndIf
			EndIf
			Return SetError($_IESTATUS_Success, 0, 1)
		Case Else
			__IEConsoleWriteError("Error", "_IEFormElementCheckBoxSelect", "$_IESTATUS_InvalidValue", "Invalid $iSelect value")
			Return SetError($_IESTATUS_InvalidValue, 3, 0)
	EndSwitch
EndFunc   ;==>_IEFormElementCheckBoxSelect
Func _IEFormElementRadioSelect(ByRef $oObject, $sString, $sName, $iSelect = 1, $sMode = "byValue", $iFireEvent = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormElementRadioSelect", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "form") Then
		__IEConsoleWriteError("Error", "_IEFormElementRadioSelect", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$sString = String($sString)
	$sName = String($sName)
	Local $oItems = Execute("$oObject.elements('" & $sName & "')")
	If Not IsObj($oItems) Then
		__IEConsoleWriteError("Warning", "_IEFormElementRadioSelect", "$_IESTATUS_NoMatch")
		Return SetError($_IESTATUS_NoMatch, 3, 0)
	EndIf
	Local $oItem, $bFound = False
	Switch $sMode
		Case "byValue"
			If __IEIsObjType($oItems, "forminputelement") Then
				$oItem = $oItems
				If String($oItem.type) = "radio" And String($oItem.value) = $sString Then $bFound = True
			Else
				For $oItem In $oItems
					If String($oItem.type) = "radio" And String($oItem.value) = $sString Then
						$bFound = True
						ExitLoop
					EndIf
				Next
			EndIf
		Case "byIndex"
			If __IEIsObjType($oItems, "forminputelement") Then
				$oItem = $oItems
				If String($oItem.type) = "radio" And Number($sString) = 0 Then $bFound = True
			Else
				Local $iCount = 0
				For $oItem In $oItems
					If String($oItem.type) = "radio" And Number($sString) = $iCount Then
						$bFound = True
						ExitLoop
					Else
						$iCount += 1
					EndIf
				Next
			EndIf
		Case Else
			__IEConsoleWriteError("Error", "_IEFormElementRadioSelect", "$_IESTATUS_InvalidValue", "Invalid Mode")
			Return SetError($_IESTATUS_InvalidValue, 5, 0)
	EndSwitch
	If Not $bFound Then
		__IEConsoleWriteError("Warning", "_IEFormElementRadioSelect", "$_IESTATUS_NoMatch")
		Return SetError($_IESTATUS_NoMatch, 2, 0)
	EndIf
	Switch $iSelect
		Case -1
			Return SetError($_IESTATUS_Success, 0, $oItem.checked)
		Case 0
			If $oItem.checked Then
				$oItem.checked = False
				If $iFireEvent Then
					$oItem.fireEvent("onChange")
					$oItem.fireEvent("OnClick")
				EndIf
			EndIf
			Return SetError($_IESTATUS_Success, 0, 1)
		Case 1
			If Not $oItem.checked Then
				$oItem.checked = True
				If $iFireEvent Then
					$oItem.fireEvent("onChange")
					$oItem.fireEvent("OnClick")
				EndIf
			EndIf
			Return SetError($_IESTATUS_Success, 0, 1)
		Case Else
			__IEConsoleWriteError("Error", "_IEFormElementRadioSelect", "$_IESTATUS_InvalidValue", "$iSelect value invalid")
			Return SetError($_IESTATUS_InvalidValue, 4, 0)
	EndSwitch
EndFunc   ;==>_IEFormElementRadioSelect
Func _IEFormImageClick(ByRef $oObject, $sLinkText, $sMode = "src", $iIndex = 0, $iWait = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormImageClick", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $sModeLinktext, $iFound = 0
	Local $oTemp = _IEDocGetObj($oObject)
	Local $oImgs = _IETagNameGetCollection($oTemp, "input")
	$sMode = StringLower($sMode)
	$iIndex = Number($iIndex)
	For $oImg In $oImgs
		If String($oImg.type) = "image" Then
			Select
				Case $sMode = "alt"
					$sModeLinktext = $oImg.alt
				Case $sMode = "name"
					$sModeLinktext = $oImg.name
					If Not IsString($sModeLinktext) Then $sModeLinktext = $oImg.id ; html5 support
				Case $sMode = "id"
					$sModeLinktext = $oImg.id
				Case $sMode = "src"
					$sModeLinktext = $oImg.src
				Case Else
					__IEConsoleWriteError("Error", "_IEFormImageClick", "$_IESTATUS_InvalidValue", "Invalid mode: " & $sMode)
					Return SetError($_IESTATUS_InvalidValue, 3, 0)
			EndSelect
			If StringInStr($sModeLinktext, $sLinkText) Then
				If ($iFound = $iIndex) Then
					$oImg.click()
					If @error Then ; Trap COM error, report and return
						__IEConsoleWriteError("Error", "_IEFormImageClick", "$_IESTATUS_COMError", @error)
						Return SetError($_IESTATUS_ComError, @error, 0)
					EndIf
					If $iWait Then
						_IELoadWait($oObject)
						Return SetError(@error, 0, -1)
					EndIf
					Return SetError($_IESTATUS_Success, 0, -1)
				EndIf
				$iFound = $iFound + 1
			EndIf
		EndIf
	Next
	__IEConsoleWriteError("Warning", "_IEFormImageClick", "$_IESTATUS_NoMatch")
	Return SetError($_IESTATUS_NoMatch, 2, 0)
EndFunc   ;==>_IEFormImageClick
Func _IEFormSubmit(ByRef $oObject, $iWait = 1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormSubmit", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "form") Then
		__IEConsoleWriteError("Error", "_IEFormSubmit", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Local $oWindow = $oObject.document.parentWindow
	$oObject.submit()
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEFormSubmit", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	If $iWait Then
		_IELoadWait($oWindow)
		Return SetError(@error, 0, -1)
	EndIf
	Return SetError($_IESTATUS_Success, 0, -1)
EndFunc   ;==>_IEFormSubmit
Func _IEFormReset(ByRef $oObject)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEFormReset", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "form") Then
		__IEConsoleWriteError("Error", "_IEFormReset", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$oObject.reset()
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEFormReset", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEFormReset
#EndRegion Form functions
#Region Table functions
Func _IETableGetCollection(ByRef $oObject, $iIndex = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IETableGetCollection", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	$iIndex = Number($iIndex)
	Select
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oObject.document.GetElementsByTagName("table").length, _
					$oObject.document.GetElementsByTagName("table"))
		Case $iIndex > -1 And $iIndex < $oObject.document.GetElementsByTagName("table").length
			Return SetError($_IESTATUS_Success, $oObject.document.GetElementsByTagName("table").length, _
					$oObject.document.GetElementsByTagName("table").item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IETableGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
		Case Else
			__IEConsoleWriteError("Warning", "_IETableGetCollection", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 1, 0)
	EndSelect
EndFunc   ;==>_IETableGetCollection
Func _IETableWriteToArray(ByRef $oObject, $bTranspose = False)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IETableWriteToArray", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "table") Then
		__IEConsoleWriteError("Error", "_IETableWriteToArray", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Local $iCols = 0, $oTds, $iCol
	Local $oTrs = $oObject.rows
	For $oTr In $oTrs
		$oTds = $oTr.cells
		$iCol = 0
		For $oTd In $oTds
			$iCol = $iCol + $oTd.colSpan
		Next
		If $iCol > $iCols Then $iCols = $iCol
	Next
	Local $iRows = $oTrs.length
	Local $aTableCells[$iCols][$iRows]
	Local $iRow = 0
	For $oTr In $oTrs
		$oTds = $oTr.cells
		$iCol = 0
		For $oTd In $oTds
			$aTableCells[$iCol][$iRow] = String($oTd.innerText)
			If @error Then ; Trap COM error, report and return
				__IEConsoleWriteError("Error", "_IETableWriteToArray", "$_IESTATUS_COMError", @error)
				Return SetError($_IESTATUS_ComError, @error, 0)
			EndIf
			$iCol = $iCol + $oTd.colSpan
		Next
		$iRow = $iRow + 1
	Next
	If $bTranspose Then
		Local $iD1 = UBound($aTableCells, $UBOUND_ROWS), $iD2 = UBound($aTableCells, $UBOUND_COLUMNS), $aTmp[$iD2][$iD1]
		For $i = 0 To $iD2 - 1
			For $j = 0 To $iD1 - 1
				$aTmp[$i][$j] = $aTableCells[$j][$i]
			Next
		Next
		$aTableCells = $aTmp
	EndIf
	Return SetError($_IESTATUS_Success, 0, $aTableCells)
EndFunc   ;==>_IETableWriteToArray
#EndRegion Table functions
#Region Read/Write functions
Func _IEBodyReadHTML(ByRef $oObject)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEBodyReadHTML", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, $oObject.document.body.innerHTML)
EndFunc   ;==>_IEBodyReadHTML
Func _IEBodyReadText(ByRef $oObject)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEBodyReadText", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IEBodyReadText", "$_IESTATUS_InvalidObjectType", "Expected document element")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, $oObject.document.body.innerText)
EndFunc   ;==>_IEBodyReadText
Func _IEBodyWriteHTML(ByRef $oObject, $sHTML)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEBodyWriteHTML", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IEBodyWriteHTML", "$_IESTATUS_InvalidObjectType", "Expected document element")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$oObject.document.body.innerHTML = $sHTML
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEBodyWriteHTML", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	Local $oTemp = $oObject.document
	_IELoadWait($oTemp)
	Return SetError(@error, 0, -1)
EndFunc   ;==>_IEBodyWriteHTML
Func _IEDocReadHTML(ByRef $oObject)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEDocReadHTML", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IEDocReadHTML", "$_IESTATUS_InvalidObjectType", "Expected document element")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, $oObject.document.documentElement.outerHTML)
EndFunc   ;==>_IEDocReadHTML
Func _IEDocWriteHTML(ByRef $oObject, $sHTML)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEDocWriteHTML", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IEDocWriteHTML", "$_IESTATUS_InvalidObjectType", "Expected document element")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$oObject.document.Write($sHTML)
	$oObject.document.close()
	Local $oTemp = $oObject.document
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEDocWriteHTML", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	_IELoadWait($oTemp)
	Return SetError(@error, 0, -1)
EndFunc   ;==>_IEDocWriteHTML
Func _IEDocInsertText(ByRef $oObject, $sString, $sWhere = "beforeend")
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEDocInsertText", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Or __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
		__IEConsoleWriteError("Error", "_IEDocInsertText", "$_IESTATUS_InvalidObjectType", "Expected document element")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$sWhere = StringLower($sWhere)
	Select
		Case $sWhere = "beforebegin"
			$oObject.insertAdjacentText($sWhere, $sString)
		Case $sWhere = "afterbegin"
			$oObject.insertAdjacentText($sWhere, $sString)
		Case $sWhere = "beforeend"
			$oObject.insertAdjacentText($sWhere, $sString)
		Case $sWhere = "afterend"
			$oObject.insertAdjacentText($sWhere, $sString)
		Case Else
			__IEConsoleWriteError("Error", "_IEDocInsertText", "$_IESTATUS_InvalidValue", "Invalid where value")
			Return SetError($_IESTATUS_InvalidValue, 3, 0)
	EndSelect
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEDocInsertText", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEDocInsertText
Func _IEDocInsertHTML(ByRef $oObject, $sString, $sWhere = "beforeend")
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEDocInsertHTML", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Or __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
		__IEConsoleWriteError("Error", "_IEDocInsertHTML", "$_IESTATUS_InvalidObjectType", "Expected document element")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$sWhere = StringLower($sWhere)
	Select
		Case $sWhere = "beforebegin"
			$oObject.insertAdjacentHTML($sWhere, $sString)
		Case $sWhere = "afterbegin"
			$oObject.insertAdjacentHTML($sWhere, $sString)
		Case $sWhere = "beforeend"
			$oObject.insertAdjacentHTML($sWhere, $sString)
		Case $sWhere = "afterend"
			$oObject.insertAdjacentHTML($sWhere, $sString)
		Case Else
			__IEConsoleWriteError("Error", "_IEDocInsertHTML", "$_IESTATUS_InvalidValue", "Invalid where value")
			Return SetError($_IESTATUS_InvalidValue, 3, 0)
	EndSelect
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEDocInsertHTML", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEDocInsertHTML
Func _IEHeadInsertEventScript(ByRef $oObject, $sHTMLFor, $sEvent, $sScript)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEHeadInsertEventScript", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $oHead = $oObject.document.all.tags("HEAD").Item(0)
	Local $oScript = $oObject.document.createElement("script")
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEHeadInsertEventScript(script)", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	With $oScript
		.defer = True
		.language = "jscript"
		.type = "text/javascript"
		.htmlFor = $sHTMLFor
		.event = $sEvent
		.text = $sScript
	EndWith
	$oHead.appendChild($oScript)
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEHeadInsertEventScript", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEHeadInsertEventScript
#EndRegion Read/Write functions
#Region Utility functions
Func _IEDocGetObj(ByRef $oObject)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEDocGetObj", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If __IEIsObjType($oObject, "document") Then
		Return SetError($_IESTATUS_Success, 0, $oObject)
	EndIf
	Return SetError($_IESTATUS_Success, 0, $oObject.document)
EndFunc   ;==>_IEDocGetObj
Func _IETagNameGetCollection(ByRef $oObject, $sTagName, $iIndex = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IETagNameGetCollection", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IETagNameGetCollection", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Local $oTemp
	If __IEIsObjType($oObject, "documentcontainer") Then
		$oTemp = _IEDocGetObj($oObject)
	Else
		$oTemp = $oObject
	EndIf
	$iIndex = Number($iIndex)
	Select
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oTemp.GetElementsByTagName($sTagName).length, _
					$oTemp.GetElementsByTagName($sTagName))
		Case $iIndex > -1 And $iIndex < $oTemp.GetElementsByTagName($sTagName).length
			Return SetError($_IESTATUS_Success, $oTemp.GetElementsByTagName($sTagName).length, _
					$oTemp.GetElementsByTagName($sTagName).item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IETagNameGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			Return SetError($_IESTATUS_InvalidValue, 3, 0)
		Case Else
			__IEConsoleWriteError("Error", "_IETagNameGetCollection", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 3 or both
	EndSelect
EndFunc   ;==>_IETagNameGetCollection
Func _IETagNameAllGetCollection(ByRef $oObject, $iIndex = -1)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IETagNameAllGetCollection", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IETagNameAllGetCollection", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Local $oTemp
	If __IEIsObjType($oObject, "documentcontainer") Then
		$oTemp = _IEDocGetObj($oObject)
	Else
		$oTemp = $oObject
	EndIf
	$iIndex = Number($iIndex)
	Select
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oTemp.all.length, $oTemp.all)
		Case $iIndex > -1 And $iIndex < $oTemp.all.length
			Return SetError($_IESTATUS_Success, $oTemp.all.length, $oTemp.all.item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IETagNameAllGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
		Case Else
			__IEConsoleWriteError("Error", "_IETagNameAllGetCollection", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 1, 0)
	EndSelect
EndFunc   ;==>_IETagNameAllGetCollection
Func _IEGetObjByName(ByRef $oObject, $sName, $iIndex = 0)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEGetObjByName", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	$iIndex = Number($iIndex)
	If $iIndex = -1 Then
		Return SetError($_IESTATUS_Success, $oObject.document.GetElementsByName($sName).length, _
				$oObject.document.GetElementsByName($sName))
	Else
		If IsObj($oObject.document.GetElementsByName($sName).item($iIndex)) Then
			Return SetError($_IESTATUS_Success, $oObject.document.GetElementsByName($sName).length, _
					$oObject.document.GetElementsByName($sName).item($iIndex))
		Else
			__IEConsoleWriteError("Warning", "_IEGetObjByName", "$_IESTATUS_NoMatch", "Name: " & $sName & ", Index: " & $iIndex)
			Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 3 or both
		EndIf
	EndIf
EndFunc   ;==>_IEGetObjByName
Func _IEGetObjById(ByRef $oObject, $sID)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEGetObjById", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IEGetObById", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	If IsObj($oObject.document.getElementById($sID)) Then
		Return SetError($_IESTATUS_Success, 0, $oObject.document.getElementById($sID))
	Else
		__IEConsoleWriteError("Warning", "_IEGetObjById", "$_IESTATUS_NoMatch", $sID)
		Return SetError($_IESTATUS_NoMatch, 2, 0)
	EndIf
EndFunc   ;==>_IEGetObjById
Func _IEAction(ByRef $oObject, $sAction)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEAction(" & $sAction & ")", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	$sAction = StringLower($sAction)
	Select
		Case $sAction = "click"
			If __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(click)", " $_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Click()
		Case $sAction = "disable"
			If __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(disable)", " $_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.disabled = True
		Case $sAction = "enable"
			If __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(enable)", " $_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.disabled = False
		Case $sAction = "focus"
			If __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(focus)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Focus()
		Case $sAction = "scrollintoview"
			If __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(scrollintoview)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.scrollIntoView()
		Case $sAction = "copy"
			$oObject.document.execCommand("Copy")
		Case $sAction = "cut"
			$oObject.document.execCommand("Cut")
		Case $sAction = "paste"
			$oObject.document.execCommand("Paste")
		Case $sAction = "delete"
			$oObject.document.execCommand("Delete")
		Case $sAction = "saveas"
			$oObject.document.execCommand("SaveAs")
		Case $sAction = "refresh"
			$oObject.document.execCommand("Refresh")
			If @error Then ; Trap COM error, report and return
				__IEConsoleWriteError("Error", "_IEAction(refresh)", "$_IESTATUS_COMError", @error)
				Return SetError($_IESTATUS_ComError, @error, 0)
			EndIf
			_IELoadWait($oObject)
		Case $sAction = "selectall"
			$oObject.document.execCommand("SelectAll")
		Case $sAction = "unselect"
			$oObject.document.execCommand("Unselect")
		Case $sAction = "print"
			$oObject.document.parentwindow.Print()
		Case $sAction = "printdefault"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEAction(printdefault)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.execWB(6, 2)
		Case $sAction = "back"
			If Not __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(back)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.GoBack()
		Case $sAction = "blur"
			$oObject.Blur()
		Case $sAction = "forward"
			If Not __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(forward)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.GoForward()
		Case $sAction = "home"
			If Not __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(home)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.GoHome()
		Case $sAction = "invisible"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEAction(invisible)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.visible = 0
		Case $sAction = "visible"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEAction(visible)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.visible = 1
		Case $sAction = "search"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEAction(search)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.GoSearch()
		Case $sAction = "stop"
			If Not __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(stop)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Stop()
		Case $sAction = "quit"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEAction(quit)", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Quit()
			If @error Then ; Trap COM error, report and return
				__IEConsoleWriteError("Error", "_IEAction(" & $sAction & ")", "$_IESTATUS_COMError", @error)
				Return SetError($_IESTATUS_ComError, @error, 0)
			EndIf
			$oObject = 0
			Return SetError($_IESTATUS_Success, 0, 1)
		Case Else
			__IEConsoleWriteError("Error", "_IEAction(" & $sAction & ")", "$_IESTATUS_InvalidValue", "Invalid Action")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
	EndSelect
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEAction(" & $sAction & ")", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEAction
Func _IEPropertyGet(ByRef $oObject, $sProperty)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	Local $oTemp, $iTemp
	$sProperty = StringLower($sProperty)
	Select
		Case $sProperty = "browserx"
			If __IEIsObjType($oObject, "browsercontainer") Or __IEIsObjType($oObject, "document") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oTemp = $oObject
			$iTemp = 0
			While IsObj($oTemp)
				$iTemp += $oTemp.offsetLeft
				$oTemp = $oTemp.offsetParent
			WEnd
			Return SetError($_IESTATUS_Success, 0, $iTemp)
		Case $sProperty = "browsery"
			If __IEIsObjType($oObject, "browsercontainer") Or __IEIsObjType($oObject, "document") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oTemp = $oObject
			$iTemp = 0
			While IsObj($oTemp)
				$iTemp += $oTemp.offsetTop
				$oTemp = $oTemp.offsetParent
			WEnd
			Return SetError($_IESTATUS_Success, 0, $iTemp)
		Case $sProperty = "screenx"
			If __IEIsObjType($oObject, "window") Or __IEIsObjType($oObject, "document") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			If __IEIsObjType($oObject, "browser") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.left())
			Else
				$oTemp = $oObject
				$iTemp = 0
				While IsObj($oTemp)
					$iTemp += $oTemp.offsetLeft
					$oTemp = $oTemp.offsetParent
				WEnd
			EndIf
			Return SetError($_IESTATUS_Success, 0, _
					$iTemp + $oObject.document.parentWindow.screenLeft)
		Case $sProperty = "screeny"
			If __IEIsObjType($oObject, "window") Or __IEIsObjType($oObject, "document") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			If __IEIsObjType($oObject, "browser") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.top())
			Else
				$oTemp = $oObject
				$iTemp = 0
				While IsObj($oTemp)
					$iTemp += $oTemp.offsetTop
					$oTemp = $oTemp.offsetParent
				WEnd
			EndIf
			Return SetError($_IESTATUS_Success, 0, _
					$iTemp + $oObject.document.parentWindow.screenTop)
		Case $sProperty = "height"
			If __IEIsObjType($oObject, "window") Or __IEIsObjType($oObject, "document") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			If __IEIsObjType($oObject, "browser") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.Height())
			Else
				Return SetError($_IESTATUS_Success, 0, $oObject.offsetHeight)
			EndIf
		Case $sProperty = "width"
			If __IEIsObjType($oObject, "window") Or __IEIsObjType($oObject, "document") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			If __IEIsObjType($oObject, "browser") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.Width())
			Else
				Return SetError($_IESTATUS_Success, 0, $oObject.offsetWidth)
			EndIf
		Case $sProperty = "isdisabled"
			Return SetError($_IESTATUS_Success, 0, $oObject.isDisabled())
		Case $sProperty = "addressbar"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.AddressBar())
		Case $sProperty = "busy"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.Busy())
		Case $sProperty = "fullscreen"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.fullScreen())
		Case $sProperty = "hwnd"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, HWnd($oObject.HWnd()))
		Case $sProperty = "left"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.Left())
		Case $sProperty = "locationname"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.LocationName())
		Case $sProperty = "locationurl"
			If __IEIsObjType($oObject, "browser") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.locationURL())
			EndIf
			If __IEIsObjType($oObject, "window") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.location.href())
			EndIf
			If __IEIsObjType($oObject, "document") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.parentwindow.location.href())
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentwindow.location.href())
		Case $sProperty = "menubar"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.MenuBar())
		Case $sProperty = "offline"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.OffLine())
		Case $sProperty = "readystate"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.ReadyState())
		Case $sProperty = "resizable"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.Resizable())
		Case $sProperty = "silent"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.Silent())
		Case $sProperty = "statusbar"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.StatusBar())
		Case $sProperty = "statustext"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.StatusText())
		Case $sProperty = "top"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.Top())
		Case $sProperty = "visible"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.Visible())
		Case $sProperty = "appcodename"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.appCodeName())
		Case $sProperty = "appminorversion"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.appMinorVersion())
		Case $sProperty = "appname"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.appName())
		Case $sProperty = "appversion"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.appVersion())
		Case $sProperty = "browserlanguage"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.browserLanguage())
		Case $sProperty = "cookieenabled"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.cookieEnabled())
		Case $sProperty = "cpuclass"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.cpuClass())
		Case $sProperty = "javaenabled"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.javaEnabled())
		Case $sProperty = "online"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.onLine())
		Case $sProperty = "platform"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.platform())
		Case $sProperty = "systemlanguage"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.systemLanguage())
		Case $sProperty = "useragent"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.userAgent())
		Case $sProperty = "userlanguage"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.userLanguage())
		Case $sProperty = "referrer"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.referrer)
		Case $sProperty = "theatermode"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.TheaterMode)
		Case $sProperty = "toolbar"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oObject.ToolBar)
		Case $sProperty = "contenteditable"
			If __IEIsObjType($oObject, "browser") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oTemp.isContentEditable)
		Case $sProperty = "innertext"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oTemp.innerText)
		Case $sProperty = "outertext"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oTemp.outerText)
		Case $sProperty = "innerhtml"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oTemp.innerHTML)
		Case $sProperty = "outerhtml"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			Return SetError($_IESTATUS_Success, 0, $oTemp.outerHTML)
		Case $sProperty = "title"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.title)
		Case $sProperty = "uniqueid"
			If __IEIsObjType($oObject, "window") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			Else
				Return SetError($_IESTATUS_Success, 0, $oObject.uniqueID)
			EndIf
		Case Else
			__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidValue", "Invalid Property")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
	EndSelect
EndFunc   ;==>_IEPropertyGet
Func _IEPropertySet(ByRef $oObject, $sProperty, $vValue)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $oTemp
	#forceref $oTemp
	$sProperty = StringLower($sProperty)
	Select
		Case $sProperty = "addressbar"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.AddressBar = $vValue
		Case $sProperty = "height"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Height = $vValue
		Case $sProperty = "left"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Left = $vValue
		Case $sProperty = "menubar"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.MenuBar = $vValue
		Case $sProperty = "offline"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.OffLine = $vValue
		Case $sProperty = "resizable"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Resizable = $vValue
		Case $sProperty = "statusbar"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.StatusBar = $vValue
		Case $sProperty = "statustext"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.StatusText = $vValue
		Case $sProperty = "top"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Top = $vValue
		Case $sProperty = "width"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			$oObject.Width = $vValue
		Case $sProperty = "theatermode"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			If $vValue Then
				$oObject.TheaterMode = True
			Else
				$oObject.TheaterMode = False
			EndIf
		Case $sProperty = "toolbar"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			If $vValue Then
				$oObject.ToolBar = True
			Else
				$oObject.ToolBar = False
			EndIf
		Case $sProperty = "contenteditable"
			If __IEIsObjType($oObject, "browser") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			If $vValue Then
				$oTemp.contentEditable = "true"
			Else
				$oTemp.contentEditable = "false"
			EndIf
		Case $sProperty = "innertext"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			$oTemp.innerText = $vValue
		Case $sProperty = "outertext"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			$oTemp.outerText = $vValue
		Case $sProperty = "innerhtml"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			$oTemp.innerHTML = $vValue
		Case $sProperty = "outerhtml"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Else
				$oTemp = $oObject
			EndIf
			$oTemp.outerHTML = $vValue
		Case $sProperty = "title"
			$oObject.document.title = $vValue
		Case $sProperty = "silent"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			EndIf
			If $vValue Then
				$oObject.silent = True
			Else
				$oObject.silent = False
			EndIf
		Case Else
			__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidValue", "Invalid Property")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
	EndSelect
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEPropertySet
Func _IEErrorNotify($vNotify = Default)
	If $vNotify = Default Then Return $__g_bIEErrorNotify
	If $vNotify Then
		$__g_bIEErrorNotify = True
	Else
		$__g_bIEErrorNotify = False
	EndIf
	Return 1
EndFunc   ;==>_IEErrorNotify
Func _IEErrorHandlerRegister($sFunctionName = "__IEInternalErrorHandler")
	$__g_oIEErrorHandler = ObjEvent("AutoIt.Error", $sFunctionName)
	If IsObj($__g_oIEErrorHandler) Then
		$__g_sIEUserErrorHandler = $sFunctionName
		Return SetError($_IESTATUS_Success, 0, 1)
	Else
		$__g_oIEErrorHandler = ""
		__IEConsoleWriteError("Error", "_IEErrorHandlerRegister", "$_IEStatus_GeneralError", _
				"Error Handler Not Registered - Check existance of error function")
		Return SetError($_IEStatus_GeneralError, 1, 0)
	EndIf
EndFunc   ;==>_IEErrorHandlerRegister
Func _IEErrorHandlerDeRegister()
	$__g_sIEUserErrorHandler = ""
	$__g_oIEErrorHandler = ""
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEErrorHandlerDeRegister
Func __IEInternalErrorHandlerRegister()
	Local $sCurrentErrorHandler = ObjEvent("AutoIt.Error")
	If $sCurrentErrorHandler <> "" And Not IsObj($__g_oIEErrorHandler) Then
		Return SetError($_IEStatus_GeneralError, 0, False)
	EndIf
	$__g_oIEErrorHandler = ObjEvent("AutoIt.Error", "__IEInternalErrorHandler")
	If IsObj($__g_oIEErrorHandler) Then
		Return SetError($_IESTATUS_Success, 0, True)
	Else
		$__g_oIEErrorHandler = ""
		Return SetError($_IEStatus_GeneralError, 0, False)
	EndIf
EndFunc   ;==>__IEInternalErrorHandlerRegister
Func __IEInternalErrorHandlerDeRegister()
	$__g_oIEErrorHandler = ""
	If $__g_sIEUserErrorHandler <> "" Then
		$__g_oIEErrorHandler = ObjEvent("AutoIt.Error", $__g_sIEUserErrorHandler)
	EndIf
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>__IEInternalErrorHandlerDeRegister
Func __IEInternalErrorHandler($oCOMError)
	If $__g_bIEErrorNotify Or $__g_bIEAU3Debug Then ConsoleWrite("--> " & __COMErrorFormating($oCOMError, "----> $IEComError") & @CRLF)
	SetError($_IEStatus_ComError)
	Return
EndFunc   ;==>__IEInternalErrorHandler
Func _IEQuit(ByRef $oObject)
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IEQuit", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "browser") Then
		__IEConsoleWriteError("Error", "_IEQuit", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$oObject.quit()
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IEQuit", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	EndIf
	$oObject = 0
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEQuit
#EndRegion Utility functions
#Region General
Func _IE_Introduction($sModule = "basic")
	Local $sHTML = ""
	Switch $sModule
		Case "basic"
			$sHTML &= '<!DOCTYPE html>' & @CR
			$sHTML &= '<html>' & @CR
			$sHTML &= '<head>' & @CR
			$sHTML &= '<meta content="text/html; charset=UTF-8" http-equiv="content-type">' & @CR
			$sHTML &= '<title>_IE_Introduction ("basic")</title>' & @CR
			$sHTML &= '<style>body {font-family: Arial}' & @CR
			$sHTML &= 'td {padding:6px}</style>' & @CR
			$sHTML &= '</head>' & @CR
			$sHTML &= '<body>' & @CR
			$sHTML &= '<table border=1 id="table1" style="width:600px;border-spacing:6px;">' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<h1>Welcome to IE.au3</h1>' & @CR
			$sHTML &= 'IE.au3 is a UDF (User Defined Function) library for the ' & @CR
			$sHTML &= '<a href="http://www.autoitscript.com">AutoIt</a> scripting language.' & @CR
			$sHTML &= '<br>  ' & @CR
			$sHTML &= 'IE.au3 allows you to either create or attach to an Internet Explorer browser and do ' & @CR
			$sHTML &= 'just about anything you could do with it interactively with the mouse and ' & @CR
			$sHTML &= 'keyboard, but do it through script.' & @CR
			$sHTML &= '<br>' & @CR
			$sHTML &= 'You can navigate to pages, click links, fill and submit forms etc. You can ' & @CR
			$sHTML &= 'also do things you cannot do interactively like change or rewrite page ' & @CR
			$sHTML &= 'content and JavaScripts, read, parse and save page content and monitor and act ' & @CR
			$sHTML &= 'upon browser "events".<br>' & @CR
			$sHTML &= 'IE.au3 uses the COM interface in AutoIt to interact with the Internet Explorer ' & @CR
			$sHTML &= 'object model and the DOM (Document Object Model) supported by the browser.' & @CR
			$sHTML &= '<br>' & @CR
			$sHTML &= 'Here are some links for more information and helpful tools:<br>' & @CR
			$sHTML &= 'Reference Material: ' & @CR
			$sHTML &= '<ul>' & @CR
			$sHTML &= '<li><a href="http://msdn1.microsoft.com/">MSDN (Microsoft Developer Network)</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/library/aa752084.aspx" target="_blank">InternetExplorer Object</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/library/ms531073.aspx" target="_blank">Document Object</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/ie/aa740473.aspx" target="_blank">Overviews and Tutorials</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/library/ms533029.aspx" target="_blank">DHTML Objects</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/library/ms533051.aspx" target="_blank">DHTML Events</a></li>' & @CR
			$sHTML &= '</ul><br>' & @CR
			$sHTML &= 'Helpful Tools: ' & @CR
			$sHTML &= '<ul>' & @CR
			$sHTML &= '<li><a href="http://www.autoitscript.com/forum/index.php?showtopic=19368" target="_blank">AutoIt IE Builder</a> (build IE scripts interactively)</li>' & @CR
			$sHTML &= '<li><a href="http://www.debugbar.com/" target="_blank">DebugBar</a> (DOM inspector, HTTP inspector, HTML validator and more - free for personal use) Recommended</li>' & @CR
			$sHTML &= '<li><a href="http://www.microsoft.com/downloads/details.aspx?FamilyID=e59c3964-672d-4511-bb3e-2d5e1db91038&amp;displaylang=en" target="_blank">IE Developer Toolbar</a> (comprehensive DOM analysis tool)</li>' & @CR
			$sHTML &= '<li><a href="http://slayeroffice.com/tools/modi/v2.0/modi_help.html" target="_blank">MODIV2</a> (view the DOM of a web page by mousing around)</li>' & @CR
			$sHTML &= '<li><a href="http://validator.w3.org/" target="_blank">HTML Validator</a> (verify HTML follows format rules)</li>' & @CR
			$sHTML &= '<li><a href="http://www.fiddlertool.com/fiddler/" target="_blank">Fiddler</a> (examine HTTP traffic)</li>' & @CR
			$sHTML &= '</ul>' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '</table>' & @CR
			$sHTML &= '</body>' & @CR
			$sHTML &= '</html>'
		Case Else
			__IEConsoleWriteError("Error", "_IE_Introduction", "$_IESTATUS_InvalidValue")
			Return SetError($_IESTATUS_InvalidValue, 1, 0)
	EndSwitch
	Local $oObject = _IECreate()
	_IEDocWriteHTML($oObject, $sHTML)
	Return SetError($_IESTATUS_Success, 0, $oObject)
EndFunc   ;==>_IE_Introduction
Func _IE_Example($sModule = "basic")
	Local $sHTML = "", $oObject
	Switch $sModule
		Case "basic"
			$sHTML &= '<!DOCTYPE html>' & @CR
			$sHTML &= '<html>' & @CR
			$sHTML &= '<head>' & @CR
			$sHTML &= '<meta content="text/html; charset=UTF-8" http-equiv="content-type">' & @CR
			$sHTML &= '<title>_IE_Example("basic")</title>' & @CR
			$sHTML &= '<style>body {font-family: Arial}</style>' & @CR
			$sHTML &= '</head>' & @CR
			$sHTML &= '<body>' & @CR
			$sHTML &= '<a href="http://www.autoitscript.com"><img src="http://www.autoitscript.com/images/logo_autoit_210x72.png" id="AutoItImage" alt="AutoIt Homepage Image" style="background: #204080;"></a>' & @CR
			$sHTML &= '<p></p>' & @CR
			$sHTML &= '<div id="line1">This is a simple HTML page with text, links and images.</div>' & @CR
			$sHTML &= '<br>' & @CR
			$sHTML &= '<div id="line2"><a href="http://www.autoitscript.com">AutoIt</a> is a wonderful automation scripting language.</div>' & @CR
			$sHTML &= '<br>' & @CR
			$sHTML &= '<div id="line3">It is supported by a very active and supporting <a href="http://www.autoitscript.com/forum/">user forum</a>.</div>' & @CR
			$sHTML &= '<br>' & @CR
			$sHTML &= '<div id="IEAu3Data"></div>' & @CR
			$sHTML &= '</body>' & @CR
			$sHTML &= '</html>'
			$oObject = _IECreate()
			_IEDocWriteHTML($oObject, $sHTML)
		Case "table"
			$sHTML &= '<!DOCTYPE html>' & @CR
			$sHTML &= '<html>' & @CR
			$sHTML &= '<head>' & @CR
			$sHTML &= '<meta content="text/html; charset=utf-8" http-equiv="content-type">' & @CR
			$sHTML &= '<title>_IE_Example("table")</title>' & @CR
			$sHTML &= '<style>body {font-family: Arial}</style>' & @CR
			$sHTML &= '</head>' & @CR
			$sHTML &= '<body>' & @CR
			$sHTML &= '$oTableOne = _IETableGetObjByName($oIE, "tableOne")<br>' & @CR
			$sHTML &= '&lt;table border=1 id="tableOne"&gt;<br>' & @CR
			$sHTML &= '<table border=1 id="tableOne">' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>AutoIt</td>' & @CR
			$sHTML &= '		<td>is</td>' & @CR
			$sHTML &= '		<td>really</td>' & @CR
			$sHTML &= '		<td>great</td>' & @CR
			$sHTML &= '		<td>with</td>' & @CR
			$sHTML &= '		<td>IE.au3</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>1</td>' & @CR
			$sHTML &= '		<td>2</td>' & @CR
			$sHTML &= '		<td>3</td>' & @CR
			$sHTML &= '		<td>4</td>' & @CR
			$sHTML &= '		<td>5</td>' & @CR
			$sHTML &= '		<td>6</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>the</td>' & @CR
			$sHTML &= '		<td>quick</td>' & @CR
			$sHTML &= '		<td>red</td>' & @CR
			$sHTML &= '		<td>fox</td>' & @CR
			$sHTML &= '		<td>jumped</td>' & @CR
			$sHTML &= '		<td>over</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>the</td>' & @CR
			$sHTML &= '		<td>lazy</td>' & @CR
			$sHTML &= '		<td>brown</td>' & @CR
			$sHTML &= '		<td>dog</td>' & @CR
			$sHTML &= '		<td>the</td>' & @CR
			$sHTML &= '		<td>time</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>has</td>' & @CR
			$sHTML &= '		<td>come</td>' & @CR
			$sHTML &= '		<td>for</td>' & @CR
			$sHTML &= '		<td>all</td>' & @CR
			$sHTML &= '		<td>good</td>' & @CR
			$sHTML &= '		<td>men</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>to</td>' & @CR
			$sHTML &= '		<td>come</td>' & @CR
			$sHTML &= '		<td>to</td>' & @CR
			$sHTML &= '		<td>the</td>' & @CR
			$sHTML &= '		<td>aid</td>' & @CR
			$sHTML &= '		<td>of</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '</table>' & @CR
			$sHTML &= '<br>' & @CR
			$sHTML &= '$oTableTwo = _IETableGetObjByName($oIE, "tableTwo")<br>' & @CR
			$sHTML &= '&lt;table border="1" id="tableTwo"&gt;<br>' & @CR
			$sHTML &= '<table border=1 id="tableTwo">' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td colspan="4">Table Top</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>One</td>' & @CR
			$sHTML &= '		<td colspan="3">Two</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>Three</td>' & @CR
			$sHTML &= '		<td>Four</td>' & @CR
			$sHTML &= '		<td colspan="2">Five</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>Six</td>' & @CR
			$sHTML &= '		<td colspan="3">Seven</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>Eight</td>' & @CR
			$sHTML &= '		<td>Nine</td>' & @CR
			$sHTML &= '		<td>Ten</td>' & @CR
			$sHTML &= '		<td>Eleven</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '</table>' & @CR
			$sHTML &= '</body>' & @CR
			$sHTML &= '</html>'
			$oObject = _IECreate()
			_IEDocWriteHTML($oObject, $sHTML)
		Case "form"
			$sHTML &= '<!DOCTYPE html>' & @CR
			$sHTML &= '<html>' & @CR
			$sHTML &= '<head>' & @CR
			$sHTML &= '<meta content="text/html; charset=UTF-8" http-equiv="content-type">' & @CR
			$sHTML &= '<title>_IE_Example("form")</title>' & @CR
			$sHTML &= '<style>body {font-family: Arial}' & @CR
			$sHTML &= 'td {padding:6px}</style>' & @CR
			$sHTML &= '</head>' & @CR
			$sHTML &= '<body>' & @CR
			$sHTML &= '<form name="ExampleForm" onSubmit="javascript:alert(''ExampleFormSubmitted'');" method="post">' & @CR
			$sHTML &= '<table style="border-spacing:6px 6px;" border=1>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>ExampleForm</td>' & @CR
			$sHTML &= '<td>&lt;form name="ExampleForm" onSubmit="javascript:alert(''ExampleFormSubmitted'');" method="post"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>Hidden Input Element<input type="hidden" name="hiddenExample" value="secret value"></td>' & @CR
			$sHTML &= '<td>&lt;input type="hidden" name="hiddenExample" value="secret value"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<input type="text" name="textExample" value="http://" size="20" maxlength="30">' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;input type="text" name="textExample" value="http://" size="20" maxlength="30"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<input type="password" name="passwordExample" size="10">' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;input type="password" name="passwordExample" size="10"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<input type="file" name="fileExample">' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;input type="file" name="fileExample"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<input type="image" name="imageExample" alt="AutoIt Homepage" src="http://www.autoitscript.com/images/logo_autoit_210x72.png" style="background: #204080;>' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;input type="image" name="imageExample" alt="AutoIt Homepage" src="http://www.autoitscript.com/images/logo_autoit_210x72.png"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<textarea name="textareaExample" rows="5" cols="15">Hello!</textarea>' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;textarea name="textareaExample" rows="5" cols="15"&gt;Hello!&lt;/textarea&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<input type="checkbox" name="checkboxG1Example" value="gameBasketball">Basketball<br>' & @CR
			$sHTML &= '<input type="checkbox" name="checkboxG1Example" value="gameFootball">Football<br>' & @CR
			$sHTML &= '<input type="checkbox" name="checkboxG2Example" value="gameTennis" checked>Tennis<br>' & @CR
			$sHTML &= '<input type="checkbox" name="checkboxG2Example" value="gameBaseball">Baseball' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;input type="checkbox" name="checkboxG1Example" value="gameBasketball"&gt;Basketball&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="checkbox" name="checkboxG1Example" value="gameFootball"&gt;Football&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="checkbox" name="checkboxG2Example" value="gameTennis" checked&gt;Tennis&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="checkbox" name="checkboxG2Example" value="gameBaseball"&gt;Baseball</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<input type="radio" name="radioExample" value="vehicleAirplane">Airplane<br>' & @CR
			$sHTML &= '<input type="radio" name="radioExample" value="vehicleTrain" checked>Train<br>' & @CR
			$sHTML &= '<input type="radio" name="radioExample" value="vehicleBoat">Boat<br>' & @CR
			$sHTML &= '<input type="radio" name="radioExample" value="vehicleCar">Car</td>' & @CR
			$sHTML &= '<td>&lt;input type="radio" name="radioExample" value="vehicleAirplane"&gt;Airplane&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="radio" name="radioExample" value="vehicleTrain" checked&gt;Train&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="radio" name="radioExample" value="vehicleBoat"&gt;Boat&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="radio" name="radioExample" value="vehicleCar"&gt;Car&lt;br&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<select name="selectExample">' & @CR
			$sHTML &= '<option value="homepage.html">Homepage' & @CR
			$sHTML &= '<option value="midipage.html">Midipage' & @CR
			$sHTML &= '<option value="freepage.html">Freepage' & @CR
			$sHTML &= '</select>' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;select name="selectExample"&gt;<br>' & @CR
			$sHTML &= '&lt;option value="homepage.html"&gt;Homepage<br>' & @CR
			$sHTML &= '&lt;option value="midipage.html"&gt;Midipage<br>' & @CR
			$sHTML &= '&lt;option value="freepage.html"&gt;Freepage<br>' & @CR
			$sHTML &= '&lt;/select&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<select name="multipleSelectExample" size="6" multiple>' & @CR
			$sHTML &= '<option value="Name1">Aaron' & @CR
			$sHTML &= '<option value="Name2">Bruce' & @CR
			$sHTML &= '<option value="Name3">Carlos' & @CR
			$sHTML &= '<option value="Name4">Denis' & @CR
			$sHTML &= '<option value="Name5">Ed' & @CR
			$sHTML &= '<option value="Name6">Freddy' & @CR
			$sHTML &= '</select>' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;select name="multipleSelectExample" size="6" multiple&gt;<br>' & @CR
			$sHTML &= '&lt;option value="Name1"&gt;Aaron<br>' & @CR
			$sHTML &= '&lt;option value="Name2"&gt;Bruce<br>' & @CR
			$sHTML &= '&lt;option value="Name3"&gt;Carlos<br>' & @CR
			$sHTML &= '&lt;option value="Name4"&gt;Denis<br>' & @CR
			$sHTML &= '&lt;option value="Name5"&gt;Ed<br>' & @CR
			$sHTML &= '&lt;option value="Name6"&gt;Freddy<br>' & @CR
			$sHTML &= '&lt;/select&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<input name="submitExample" type="submit" value="Submit">' & @CR
			$sHTML &= '<input name="resetExample" type="reset" value="Reset">' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '<td>&lt;input name="submitExample" type="submit" value="Submit"&gt;<br>' & @CR
			$sHTML &= '&lt;input name="resetExample" type="reset" value="Reset"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '</table>' & @CR
			$sHTML &= '<input type="hidden" name="hiddenExample" value="secret value">' & @CR
			$sHTML &= '</form>' & @CR
			$sHTML &= '</body>' & @CR
			$sHTML &= '</html>'
			$oObject = _IECreate()
			_IEDocWriteHTML($oObject, $sHTML)
		Case "frameset"
			$sHTML &= '<!DOCTYPE html>' & @CR
			$sHTML &= '<html>' & @CR
			$sHTML &= '<head>' & @CR
			$sHTML &= '<meta content="text/html; charset=UTF-8" http-equiv="content-type">' & @CR
			$sHTML &= '<title>_IE_Example("frameset")</title>' & @CR
			$sHTML &= '</head>' & @CR
			$sHTML &= '<frameset rows="25,200">' & @CR
			$sHTML &= '	<frame name=Top SRC=about:blank>' & @CR
			$sHTML &= '	<frameset cols="100,500">' & @CR
			$sHTML &= '		<frame name=Menu SRC=about:blank>' & @CR
			$sHTML &= '		<frame name=Main SRC=about:blank>' & @CR
			$sHTML &= '	</frameset>' & @CR
			$sHTML &= '</frameset>' & @CR
			$sHTML &= '</html>'
			$oObject = _IECreate()
			_IEDocWriteHTML($oObject, $sHTML)
			_IEAction($oObject, "refresh")
			Local $oFrameTop = _IEFrameGetObjByName($oObject, "Top")
			Local $oFrameMenu = _IEFrameGetObjByName($oObject, "Menu")
			Local $oFrameMain = _IEFrameGetObjByName($oObject, "Main")
			_IEBodyWriteHTML($oFrameTop, '$oFrameTop = _IEFrameGetObjByName($oIE, "Top")')
			_IEBodyWriteHTML($oFrameMenu, '$oFrameMenu = _IEFrameGetObjByName($oIE, "Menu")')
			_IEBodyWriteHTML($oFrameMain, '$oFrameMain = _IEFrameGetObjByName($oIE, "Main")')
		Case "iframe"
			$sHTML &= '<!DOCTYPE html>' & @CR
			$sHTML &= '<html>' & @CR
			$sHTML &= '<head>' & @CR
			$sHTML &= '<meta content="text/html; charset=UTF-8" http-equiv="content-type">' & @CR
			$sHTML &= '<title>_IE_Example("iframe")</title>' & @CR
			$sHTML &= '<style>td {padding:6px}</style>' & @CR
			$sHTML &= '</head>' & @CR
			$sHTML &= '<body>' & @CR
			$sHTML &= '<table style="border-spacing:6px" border=1>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td><iframe name="iFrameOne" src="about:blank" title="iFrameOne"></iframe></td>' & @CR
			$sHTML &= '<td>&lt;iframe name="iFrameOne" src="about:blank" title="iFrameOne"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td><iframe name="iFrameTwo" src="about:blank" title="iFrameTwo"></iframe></td>' & @CR
			$sHTML &= '<td>&lt;iframe name="iFrameTwo" src="about:blank" title="iFrameTwo"&gt;</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '</table>' & @CR
			$sHTML &= '</body>' & @CR
			$sHTML &= '</html>'
			$oObject = _IECreate()
			_IEDocWriteHTML($oObject, $sHTML)
			_IEAction($oObject, "refresh")
			Local $oIFrameOne = _IEFrameGetObjByName($oObject, "iFrameOne")
			Local $oIFrameTwo = _IEFrameGetObjByName($oObject, "iFrameTwo")
			_IEBodyWriteHTML($oIFrameOne, '$oIFrameOne = _IEFrameGetObjByName($oIE, "iFrameOne")')
			_IEBodyWriteHTML($oIFrameTwo, '$oIFrameTwo = _IEFrameGetObjByName($oIE, "iFrameTwo")')
		Case Else
			__IEConsoleWriteError("Error", "_IE_Example", "$_IESTATUS_InvalidValue")
			Return SetError($_IESTATUS_InvalidValue, 1, 0)
	EndSwitch
	Sleep(500)
	Return SetError($_IESTATUS_Success, 0, $oObject)
EndFunc   ;==>_IE_Example
Func _IE_VersionInfo()
	__IEConsoleWriteError("Information", "_IE_VersionInfo", "version " & _
			$__gaIEAU3VersionInfo[0] & _
			$__gaIEAU3VersionInfo[1] & "." & _
			$__gaIEAU3VersionInfo[2] & "-" & _
			$__gaIEAU3VersionInfo[3], "Release date: " & $__gaIEAU3VersionInfo[4])
	Return SetError($_IESTATUS_Success, 0, $__gaIEAU3VersionInfo)
EndFunc   ;==>_IE_VersionInfo
#EndRegion General
#Region Internal functions
Func __IELockSetForegroundWindow($iLockCode)
	Local $aRet = DllCall("user32.dll", "bool", "LockSetForegroundWindow", "uint", $iLockCode)
	If @error Or Not $aRet[0] Then Return SetError(1, _WinAPI_GetLastError(), 0)
	Return $aRet[0]
EndFunc   ;==>__IELockSetForegroundWindow
Func __IEControlGetObjFromHWND(ByRef $hWin)
	DllCall("ole32.dll", "long", "CoInitialize", "ptr", 0)
	If @error Then Return SetError(2, @error, 0)
	Local Const $WM_HTML_GETOBJECT = __IERegisterWindowMessage("WM_HTML_GETOBJECT")
	Local Const $SMTO_ABORTIFHUNG = 0x0002
	Local $iResult
	__IESendMessageTimeout($hWin, $WM_HTML_GETOBJECT, 0, 0, $SMTO_ABORTIFHUNG, 1000, $iResult)
	Local $tUUID = DllStructCreate("int;short;short;byte[8]")
	DllStructSetData($tUUID, 1, 0x626FC520)
	DllStructSetData($tUUID, 2, 0xA41E)
	DllStructSetData($tUUID, 3, 0x11CF)
	DllStructSetData($tUUID, 4, 0xA7, 1)
	DllStructSetData($tUUID, 4, 0x31, 2)
	DllStructSetData($tUUID, 4, 0x0, 3)
	DllStructSetData($tUUID, 4, 0xA0, 4)
	DllStructSetData($tUUID, 4, 0xC9, 5)
	DllStructSetData($tUUID, 4, 0x8, 6)
	DllStructSetData($tUUID, 4, 0x26, 7)
	DllStructSetData($tUUID, 4, 0x37, 8)
	Local $aRet = DllCall("oleacc.dll", "long", "ObjectFromLresult", "lresult", $iResult, "struct*", $tUUID, _
			"wparam", 0, "idispatch*", 0)
	If @error Then Return SetError(3, @error, 0)
	If IsObj($aRet[4]) Then
		Local $oIE = $aRet[4].Script()
		Return $oIE.Document.parentwindow
	Else
		Return SetError(1, $aRet[0], 0)
	EndIf
EndFunc   ;==>__IEControlGetObjFromHWND
Func __IERegisterWindowMessage($sMsg)
	Local $aRet = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $sMsg)
	If @error Then Return SetError(@error, @extended, 0)
	If $aRet[0] = 0 Then Return SetError(10, _WinAPI_GetLastError(), 0)
	Return $aRet[0]
EndFunc   ;==>__IERegisterWindowMessage
Func __IESendMessageTimeout($hWnd, $iMsg, $wParam, $lParam, $iFlags, $iTimeout, ByRef $vOut, $r = 0, $sT1 = "int", $sT2 = "int")
	Local $aRet = DllCall("user32.dll", "lresult", "SendMessageTimeout", "hwnd", $hWnd, "uint", $iMsg, $sT1, $wParam, _
			$sT2, $lParam, "uint", $iFlags, "uint", $iTimeout, "dword_ptr*", "")
	If @error Or $aRet[0] = 0 Then
		$vOut = 0
		Return SetError(1, _WinAPI_GetLastError(), 0)
	EndIf
	$vOut = $aRet[7]
	If $r >= 0 And $r <= 4 Then Return $aRet[$r]
	Return $aRet
EndFunc   ;==>__IESendMessageTimeout
Func __IEIsObjType(ByRef $oObject, $sType, $bRegister = True)
	If Not IsObj($oObject) Then
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	Local $bStatus = $bRegister
	If $bRegister Then
		$bStatus = __IEInternalErrorHandlerRegister()
		If Not $bStatus Then __IEConsoleWriteError("Warning", "internal function __IEIsObjType", _
				"Cannot register internal error handler, cannot trap COM errors", _
				"Use _IEErrorHandlerRegister() to register a user error handler")
	EndIf
	Local $iNotifyStatus = _IEErrorNotify() ; save current error notify status
	_IEErrorNotify(False)
	Local $sName = String(ObjName($oObject)), $iErrorStatus = $_IESTATUS_InvalidObjectType
	Switch $sType
		Case "browserdom"
			If __IEIsObjType($oObject, "documentcontainer", False) Then
				$iErrorStatus = $_IESTATUS_Success
			ElseIf __IEIsObjType($oObject, "document", False) Then
				$iErrorStatus = $_IESTATUS_Success
			Else
				Local $oTemp = $oObject.document
				If __IEIsObjType($oTemp, "document", False) Then
					$iErrorStatus = $_IESTATUS_Success
				EndIf
			EndIf
		Case "browser"
			If ($sName = "IWebBrowser2") Or ($sName = "IWebBrowser") Or ($sName = "WebBrowser") Then $iErrorStatus = $_IESTATUS_Success
		Case "window"
			If $sName = "HTMLWindow2" Then $iErrorStatus = $_IESTATUS_Success
		Case "documentContainer"
			If __IEIsObjType($oObject, "window", False) Or __IEIsObjType($oObject, "browser", False) Then $iErrorStatus = $_IESTATUS_Success
		Case "document"
			If $sName = "HTMLDocument" Then $iErrorStatus = $_IESTATUS_Success
		Case "table"
			If $sName = "HTMLTable" Then $iErrorStatus = $_IESTATUS_Success
		Case "form"
			If $sName = "HTMLFormElement" Then $iErrorStatus = $_IESTATUS_Success
		Case "forminputelement"
			If ($sName = "HTMLInputElement") Or ($sName = "HTMLSelectElement") Or ($sName = "HTMLTextAreaElement") Then $iErrorStatus = $_IESTATUS_Success
		Case "elementcollection"
			If ($sName = "HTMLElementCollection") Then $iErrorStatus = $_IESTATUS_Success
		Case "formselectelement"
			If $sName = "HTMLSelectElement" Then $iErrorStatus = $_IESTATUS_Success
		Case Else
			$iErrorStatus = $_IESTATUS_InvalidValue
	EndSwitch
	_IEErrorNotify($iNotifyStatus) ; restore notification status
	If $bRegister Then
		__IEInternalErrorHandlerDeRegister()
	EndIf
	If $iErrorStatus = $_IESTATUS_Success Then
		Return SetError($_IESTATUS_Success, 0, 1)
	Else
		Return SetError($iErrorStatus, 1, 0)
	EndIf
EndFunc   ;==>__IEIsObjType
Func __IEConsoleWriteError($sSeverity, $sFunc, $sMessage = Default, $sStatus = Default)
	If $__g_bIEErrorNotify Or $__g_bIEAU3Debug Then
		Local $sStr = "--> IE.au3 " & $__gaIEAU3VersionInfo[5] & " " & $sSeverity & " from function " & $sFunc
		If Not ($sMessage = Default) Then $sStr &= ", " & $sMessage
		If Not ($sStatus = Default) Then $sStr &= " (" & $sStatus & ")"
		ConsoleWrite($sStr & @CRLF)
	EndIf
	Return SetError($sStatus, 0, 1) ; restore calling @error
EndFunc   ;==>__IEConsoleWriteError
Func __IEComErrorUnrecoverable($iError)
	Switch $iError
		Case -2147352567 ; "an exception has occurred."
			Return $_IESTATUS_AccessIsDenied
		Case -2147024891 ; "Access is denied."
			Return $_IESTATUS_AccessIsDenied
		Case -2147417848 ; "The object invoked has disconnected from its clients."
			Return $_IESTATUS_ClientDisconnected
		Case -2147023174 ; "RPC server not accessible."
			Return $_IESTATUS_ClientDisconnected
		Case -2147023179 ; "The interface is unknown."
			Return $_IESTATUS_ClientDisconnected
		Case Else
			Return $_IESTATUS_Success
	EndSwitch
EndFunc   ;==>__IEComErrorUnrecoverable
#EndRegion Internal functions
#Region ProtoType Functions
Func __IENavigate(ByRef $oObject, $sUrl, $iWait = 1, $iFags = 0, $sTarget = "", $sPostdata = "", $sHeaders = "")
	__IEConsoleWriteError("Warning", "__IENavigate", "Unsupported function called. Not fully tested.")
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "__IENavigate", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	EndIf
	If Not __IEIsObjType($oObject, "documentContainer") Then
		__IEConsoleWriteError("Error", "__IENavigate", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	EndIf
	$oObject.navigate($sUrl, $iFags, $sTarget, $sPostdata, $sHeaders)
	If $iWait Then
		_IELoadWait($oObject)
		Return SetError(@error, 0, $oObject)
	EndIf
	Return SetError($_IESTATUS_Success, 0, $oObject)
EndFunc   ;==>__IENavigate
#cs
;	#include <IE.au3>; REMOVED INCLUDE
	$sFormAction = "http://www.autoitscript.com/forum/index.php?act=Search&CODE=01"
	$sHeader = "Content-Type: application/x-www-form-urlencoded"
	$sDataToPost = "keywords=safearray&namesearch=&forums%5B%5D=all&searchsubs=1&prune=0&prune_type=newer&sort_key=last_post&sort_order=desc&search_in=posts&result_type=posts"
	$oDataToPostBstr = __IEStringToBstr($sDataToPost) ; convert string to BSTR
	ConsoleWrite(__IEBstrToString($oDataToPostBstr) & @CRLF) ; prove we can convert it back to a string
	$oIE = _IECreate()
	$oIE.Navigate( $sFormAction, Default, Default, $oDataToPostBstr, $sHeader)
#ce
Func __IEStringToBstr($sString, $sCharSet = "us-ascii")
	Local Const $iTypeBinary = 1, $iTypeText = 2
	Local $oStream = ObjCreate("ADODB.Stream")
	$oStream.type = $iTypeText
	$oStream.CharSet = $sCharSet
	$oStream.Open
	$oStream.WriteText($sString)
	$oStream.Position = 0
	$oStream.type = $iTypeBinary
	$oStream.Position = 0
	Return $oStream.Read()
EndFunc   ;==>__IEStringToBstr
Func __IEBstrToString($oBstr, $sCharSet = "us-ascii")
	Local Const $iTypeBinary = 1, $iTypeText = 2
	Local $oStream = ObjCreate("ADODB.Stream")
	$oStream.type = $iTypeBinary
	$oStream.Open
	$oStream.Write($oBstr)
	$oStream.Position = 0
	$oStream.type = $iTypeText
	$oStream.CharSet = $sCharSet
	$oStream.Position = 0
	Return $oStream.ReadText()
EndFunc   ;==>__IEBstrToString
Func __IECreateNewIE($sTitle, $sHead = "", $sBody = "")
	Local $sTemp = __IETempFile("", "~IE~", ".htm")
	If @error Then
		__IEConsoleWriteError("Error", "_IECreateHTA", "", "Error creating temporary file in @TempDir or @ScriptDir")
		Return SetError($_IESTATUS_GeneralError, 1, 0)
	EndIf
	Local $sHTML = ''
	$sHTML &= '<!DOCTYPE html>' & @CR
	$sHTML &= '<html>' & @CR
	$sHTML &= '<head>' & @CR
	$sHTML &= '<meta content="text/html; charset=UTF-8" http-equiv="content-type">' & @CR
	$sHTML &= '<title>' & $sTemp & '</title>' & @CR & $sHead & @CR
	$sHTML &= '</head>' & @CR
	$sHTML &= '<body>' & @CR & $sBody & @CR
	$sHTML &= '</body>' & @CR
	$sHTML &= '</html>'
	Local $hFile = FileOpen($sTemp, $FO_OVERWRITE)
	FileWrite($hFile, $sHTML)
	FileClose($hFile)
	If @error Then
		__IEConsoleWriteError("Error", "_IECreateNewIE", "", "Error creating temporary file in @TempDir or @ScriptDir")
		Return SetError($_IESTATUS_GeneralError, 2, 0)
	EndIf
	Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe " & $sTemp)
	Local $iPID
	If WinWait($sTemp, "", 60) Then
		$iPID = WinGetProcess($sTemp)
	Else
		__IEConsoleWriteError("Error", "_IECreateNewIE", "", "Timeout waiting for new IE window creation")
		Return SetError($_IESTATUS_GeneralError, 3, 0)
	EndIf
	If Not FileDelete($sTemp) Then
		__IEConsoleWriteError("Warning", "_IECreateNewIE", "", "Could not delete temporary file " & FileGetLongName($sTemp))
	EndIf
	Local $oObject = _IEAttach($sTemp)
	_IELoadWait($oObject)
	_IEPropertySet($oObject, "title", $sTitle)
	Return SetError($_IESTATUS_Success, $iPID, $oObject)
EndFunc   ;==>__IECreateNewIE
Func __IETempFile($sDirectoryName = @TempDir, $sFilePrefix = "~", $sFileExtension = ".tmp", $iRandomLength = 7)
	Local $sTempName, $iTmp = 0
	If Not FileExists($sDirectoryName) Then $sDirectoryName = @TempDir ; First reset to default temp dir
	If Not FileExists($sDirectoryName) Then $sDirectoryName = @ScriptDir ; Still wrong then set to Scriptdir
	If StringRight($sDirectoryName, 1) <> "\" Then $sDirectoryName = $sDirectoryName & "\"
	Do
		$sTempName = ""
		While StringLen($sTempName) < $iRandomLength
			$sTempName = $sTempName & Chr(Random(97, 122, 1))
		WEnd
		$sTempName = $sDirectoryName & $sFilePrefix & $sTempName & $sFileExtension
		$iTmp += 1
		If $iTmp > 200 Then ; If we fail over 200 times, there is something wrong
			Return SetError($_IESTATUS_GeneralError, 1, 0)
		EndIf
	Until Not FileExists($sTempName)
	Return $sTempName
EndFunc   ;==>__IETempFile
#EndRegion ProtoType Functions
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#Region Variable definitions
Global Const $gh_AU3Obj_kernel32dll = DllOpen("kernel32.dll")
Global Const $gh_AU3Obj_oleautdll = DllOpen("oleaut32.dll")
Global Const $gh_AU3Obj_ole32dll = DllOpen("ole32.dll")
Global Const $__Au3Obj_X64 = @AutoItX64
Global Const $__Au3Obj_VT_EMPTY = 0
Global Const $__Au3Obj_VT_NULL = 1
Global Const $__Au3Obj_VT_I2 = 2
Global Const $__Au3Obj_VT_I4 = 3
Global Const $__Au3Obj_VT_R4 = 4
Global Const $__Au3Obj_VT_R8 = 5
Global Const $__Au3Obj_VT_CY = 6
Global Const $__Au3Obj_VT_DATE = 7
Global Const $__Au3Obj_VT_BSTR = 8
Global Const $__Au3Obj_VT_DISPATCH = 9
Global Const $__Au3Obj_VT_ERROR = 10
Global Const $__Au3Obj_VT_BOOL = 11
Global Const $__Au3Obj_VT_VARIANT = 12
Global Const $__Au3Obj_VT_UNKNOWN = 13
Global Const $__Au3Obj_VT_DECIMAL = 14
Global Const $__Au3Obj_VT_I1 = 16
Global Const $__Au3Obj_VT_UI1 = 17
Global Const $__Au3Obj_VT_UI2 = 18
Global Const $__Au3Obj_VT_UI4 = 19
Global Const $__Au3Obj_VT_I8 = 20
Global Const $__Au3Obj_VT_UI8 = 21
Global Const $__Au3Obj_VT_INT = 22
Global Const $__Au3Obj_VT_UINT = 23
Global Const $__Au3Obj_VT_VOID = 24
Global Const $__Au3Obj_VT_HRESULT = 25
Global Const $__Au3Obj_VT_PTR = 26
Global Const $__Au3Obj_VT_SAFEARRAY = 27
Global Const $__Au3Obj_VT_CARRAY = 28
Global Const $__Au3Obj_VT_USERDEFINED = 29
Global Const $__Au3Obj_VT_LPSTR = 30
Global Const $__Au3Obj_VT_LPWSTR = 31
Global Const $__Au3Obj_VT_RECORD = 36
Global Const $__Au3Obj_VT_INT_PTR = 37
Global Const $__Au3Obj_VT_UINT_PTR = 38
Global Const $__Au3Obj_VT_FILETIME = 64
Global Const $__Au3Obj_VT_BLOB = 65
Global Const $__Au3Obj_VT_STREAM = 66
Global Const $__Au3Obj_VT_STORAGE = 67
Global Const $__Au3Obj_VT_STREAMED_OBJECT = 68
Global Const $__Au3Obj_VT_STORED_OBJECT = 69
Global Const $__Au3Obj_VT_BLOB_OBJECT = 70
Global Const $__Au3Obj_VT_CF = 71
Global Const $__Au3Obj_VT_CLSID = 72
Global Const $__Au3Obj_VT_VERSIONED_STREAM = 73
Global Const $__Au3Obj_VT_BSTR_BLOB = 0xfff
Global Const $__Au3Obj_VT_VECTOR = 0x1000
Global Const $__Au3Obj_VT_ARRAY = 0x2000
Global Const $__Au3Obj_VT_BYREF = 0x4000
Global Const $__Au3Obj_VT_RESERVED = 0x8000
Global Const $__Au3Obj_VT_ILLEGAL = 0xffff
Global Const $__Au3Obj_VT_ILLEGALMASKED = 0xfff
Global Const $__Au3Obj_VT_TYPEMASK = 0xfff
Global Const $__Au3Obj_tagVARIANT = "word vt;word r1;word r2;word r3;ptr data; ptr"
Global Const $__Au3Obj_VARIANT_SIZE = DllStructGetSize(DllStructCreate($__Au3Obj_tagVARIANT, 1))
Global Const $__Au3Obj_PTR_SIZE = DllStructGetSize(DllStructCreate('ptr', 1))
Global Const $__Au3Obj_tagSAFEARRAYBOUND = "ulong cElements; long lLbound;"
Global $ghAutoItObjectDLL = -1, $giAutoItObjectDLLRef = 0
#interface "IUnknown"
Global Const $sIID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
Global $dtagIUnknown = "QueryInterface hresult(ptr;ptr*);" & _
		"AddRef dword();" & _
		"Release dword();"
Global $ltagIUnknown = "QueryInterface;" & _
		"AddRef;" & _
		"Release;"
#interface "IDispatch"
Global Const $sIID_IDispatch = "{00020400-0000-0000-C000-000000000046}"
Global $dtagIDispatch = $dtagIUnknown & _
		"GetTypeInfoCount hresult(dword*);" & _
		"GetTypeInfo hresult(dword;dword;ptr*);" & _
		"GetIDsOfNames hresult(ptr;ptr;dword;dword;ptr);" & _
		"Invoke hresult(dword;ptr;dword;word;ptr;ptr;ptr;ptr);"
Global $ltagIDispatch = $ltagIUnknown & _
		"GetTypeInfoCount;" & _
		"GetTypeInfo;" & _
		"GetIDsOfNames;" & _
		"Invoke;"
#EndRegion Variable definitions
#Region Misc
DllCall($gh_AU3Obj_ole32dll, 'long', 'OleInitialize', 'ptr', 0)
OnAutoItExitRegister("__Au3Obj_OleUninitialize")
Func __Au3Obj_OleUninitialize()
	DllCall($gh_AU3Obj_ole32dll, 'long', 'OleUninitialize')
	_AutoItObject_Shutdown(True)
EndFunc   ;==>__Au3Obj_OleUninitialize
Func __Au3Obj_IUnknown_AddRef($vObj)
	Local $sType = "ptr"
	If IsObj($vObj) Then $sType = "idispatch"
	Local $tVARIANT = DllStructCreate($__Au3Obj_tagVARIANT)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "DispCallFunc", _
			$sType, $vObj, _
			"dword", $__Au3Obj_PTR_SIZE, _ ; offset (4 for x86, 8 for x64)
			"dword", 4, _ ; CC_STDCALL
			"dword", $__Au3Obj_VT_UINT, _
			"dword", 0, _ ; number of function parameters
			"ptr", 0, _ ; parameters related
			"ptr", 0, _ ; parameters related
			"ptr", DllStructGetPtr($tVARIANT))
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return DllStructGetData(DllStructCreate("dword", DllStructGetPtr($tVARIANT, "data")), 1)
EndFunc   ;==>__Au3Obj_IUnknown_AddRef
Func __Au3Obj_IUnknown_Release($vObj)
	Local $sType = "ptr"
	If IsObj($vObj) Then $sType = "idispatch"
	Local $tVARIANT = DllStructCreate($__Au3Obj_tagVARIANT)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "DispCallFunc", _
			$sType, $vObj, _
			"dword", 2 * $__Au3Obj_PTR_SIZE, _ ; offset (8 for x86, 16 for x64)
			"dword", 4, _ ; CC_STDCALL
			"dword", $__Au3Obj_VT_UINT, _
			"dword", 0, _ ; number of function parameters
			"ptr", 0, _ ; parameters related
			"ptr", 0, _ ; parameters related
			"ptr", DllStructGetPtr($tVARIANT))
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return DllStructGetData(DllStructCreate("dword", DllStructGetPtr($tVARIANT, "data")), 1)
EndFunc   ;==>__Au3Obj_IUnknown_Release
Func __Au3Obj_GetMethods($tagInterface)
	Local $sMethods = StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(\w+\*?)\h*(\((.*?)\))\h*(;|;*\z)", "$1\|$2;$4" & @LF), ";" & @LF, @LF)
	If $sMethods = $tagInterface Then $sMethods = StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(;|;*\z)", "$1\|" & @LF), ";" & @LF, @LF)
	Return StringTrimRight($sMethods, 1)
EndFunc   ;==>__Au3Obj_GetMethods
Func __Au3Obj_ObjStructGetElements($sTag, ByRef $sAlign)
	Local $sAlignment = StringRegExpReplace($sTag, "\h*(align\h+\d+)\h*;.*", "$1")
	If $sAlignment <> $sTag Then
		$sAlign = $sAlignment
		$sTag = StringRegExpReplace($sTag, "\h*(align\h+\d+)\h*;", "")
	EndIf
	Return StringTrimRight(StringRegExpReplace($sTag, "\h*\w+\h*(\w+)\h*(\[\d+\])*\h*(;|;*\z)\h*", "$1;"), 1)
EndFunc   ;==>__Au3Obj_ObjStructGetElements
#EndRegion Misc
#Region SafeArray
Func __Au3Obj_SafeArrayCreate($vType, $cDims, $rgsabound)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SafeArrayCreate", "dword", $vType, "uint", $cDims, 'ptr', $rgsabound)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayCreate
Func __Au3Obj_SafeArrayDestroy($pSafeArray)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayDestroy", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayDestroy
Func __Au3Obj_SafeArrayAccessData($pSafeArray, ByRef $pArrayData)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayAccessData", "ptr", $pSafeArray, 'ptr*', 0)
	If @error Then Return SetError(1, 0, 1)
	$pArrayData = $aCall[2]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayAccessData
Func __Au3Obj_SafeArrayUnaccessData($pSafeArray)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayUnaccessData", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayUnaccessData
Func __Au3Obj_SafeArrayGetUBound($pSafeArray, $iDim, ByRef $iBound)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayGetUBound", "ptr", $pSafeArray, 'uint', $iDim, 'long*', 0)
	If @error Then Return SetError(1, 0, 1)
	$iBound = $aCall[3]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetUBound
Func __Au3Obj_SafeArrayGetLBound($pSafeArray, $iDim, ByRef $iBound)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayGetLBound", "ptr", $pSafeArray, 'uint', $iDim, 'long*', 0)
	If @error Then Return SetError(1, 0, 1)
	$iBound = $aCall[3]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetLBound
Func __Au3Obj_SafeArrayGetDim($pSafeArray)
	Local $aResult = DllCall($gh_AU3Obj_oleautdll, "uint", "SafeArrayGetDim", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 0)
	Return $aResult[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetDim
Func __Au3Obj_CreateSafeArrayVariant(ByRef Const $aArray)
	Local $iDim = UBound($aArray, 0), $pData, $pSafeArray, $bound, $subBound, $tBound
	Switch $iDim
		Case 1
			$bound = UBound($aArray) - 1
			$tBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tBound, 1, $bound + 1)
			$pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_VARIANT, 1, DllStructGetPtr($tBound))
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					_AutoItObject_VariantInit($pData + $i * $__Au3Obj_VARIANT_SIZE)
					_AutoItObject_VariantSet($pData + $i * $__Au3Obj_VARIANT_SIZE, $aArray[$i])
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $pSafeArray
		Case 2
			$bound = UBound($aArray, 1) - 1
			$subBound = UBound($aArray, 2) - 1
			$tBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND & $__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tBound, 3, $bound + 1)
			DllStructSetData($tBound, 1, $subBound + 1)
			$pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_VARIANT, 2, DllStructGetPtr($tBound))
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					For $j = 0 To $subBound
						_AutoItObject_VariantInit($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE)
						_AutoItObject_VariantSet($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE, $aArray[$i][$j])
					Next
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $pSafeArray
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>__Au3Obj_CreateSafeArrayVariant
Func __Au3Obj_ReadSafeArrayVariant($pSafeArray)
	Local $iDim = __Au3Obj_SafeArrayGetDim($pSafeArray), $pData, $lbound, $bound, $subBound
	Switch $iDim
		Case 1
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $bound)
			$bound -= $lbound
			Local $array[$bound + 1]
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					$array[$i] = _AutoItObject_VariantRead($pData + $i * $__Au3Obj_VARIANT_SIZE)
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $array
		Case 2
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 2, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 2, $bound)
			$bound -= $lbound
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $subBound)
			$subBound -= $lbound
			Local $array[$bound + 1][$subBound + 1]
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					For $j = 0 To $subBound
						$array[$i][$j] = _AutoItObject_VariantRead($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_VARIANT_SIZE)
					Next
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $array
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>__Au3Obj_ReadSafeArrayVariant
#EndRegion SafeArray
#Region Memory
Func __Au3Obj_CoTaskMemAlloc($iSize)
	Local $aCall = DllCall($gh_AU3Obj_ole32dll, "ptr", "CoTaskMemAlloc", "uint_ptr", $iSize)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_CoTaskMemAlloc
Func __Au3Obj_CoTaskMemFree($pCoMem)
	DllCall($gh_AU3Obj_ole32dll, "none", "CoTaskMemFree", "ptr", $pCoMem)
	If @error Then Return SetError(1, 0, 0)
EndFunc   ;==>__Au3Obj_CoTaskMemFree
Func __Au3Obj_CoTaskMemRealloc($pCoMem, $iSize)
	Local $aCall = DllCall($gh_AU3Obj_ole32dll, "ptr", "CoTaskMemRealloc", 'ptr', $pCoMem, "uint_ptr", $iSize)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_CoTaskMemRealloc
Func __Au3Obj_GlobalAlloc($iSize, $iFlag)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GlobalAlloc", "dword", $iFlag, "dword_ptr", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_GlobalAlloc
Func __Au3Obj_GlobalFree($pPointer)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GlobalFree", "ptr", $pPointer)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_GlobalFree
#EndRegion Memory
#Region SysString
Func __Au3Obj_SysAllocString($str)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SysAllocString", "wstr", $str)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysAllocString
Func __Au3Obj_SysCopyString($pBSTR)
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SysAllocStringLen", "ptr", $pBSTR, "uint", __Au3Obj_SysStringLen($pBSTR))
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysCopyString
Func __Au3Obj_SysReAllocString(ByRef $pBSTR, $str)
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SysReAllocString", 'ptr*', $pBSTR, "wstr", $str)
	If @error Then Return SetError(1, 0, 0)
	$pBSTR = $aCall[1]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysReAllocString
Func __Au3Obj_SysFreeString($pBSTR)
	If Not $pBSTR Then Return SetError(2, 0, 0)
	DllCall($gh_AU3Obj_oleautdll, "none", "SysFreeString", "ptr", $pBSTR)
	If @error Then Return SetError(1, 0, 0)
EndFunc   ;==>__Au3Obj_SysFreeString
Func __Au3Obj_SysStringLen($pBSTR)
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "uint", "SysStringLen", "ptr", $pBSTR)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysStringLen
Func __Au3Obj_SysReadString($pBSTR, $iLen = -1)
	If Not $pBSTR Then Return SetError(2, 0, '')
	If $iLen < 1 Then $iLen = __Au3Obj_SysStringLen($pBSTR)
	If $iLen < 1 Then Return SetError(1, 0, '')
	Return DllStructGetData(DllStructCreate("wchar[" & $iLen & "]", $pBSTR), 1)
EndFunc   ;==>__Au3Obj_SysReadString
Func __Au3Obj_PtrStringLen($pStr)
	Local $aResult = DllCall($gh_AU3Obj_kernel32dll, 'int', 'lstrlenW', 'ptr', $pStr)
	If @error Then Return SetError(1, 0, 0)
	Return $aResult[0]
EndFunc   ;==>__Au3Obj_PtrStringLen
Func __Au3Obj_PtrStringRead($pStr, $iLen = -1)
	If $iLen < 1 Then $iLen = __Au3Obj_PtrStringLen($pStr)
	If $iLen < 1 Then Return SetError(1, 0, '')
	Return DllStructGetData(DllStructCreate("wchar[" & $iLen & "]", $pStr), 1)
EndFunc   ;==>__Au3Obj_PtrStringRead
#EndRegion SysString
#Region Proxy Functions
Func __Au3Obj_FunctionProxy($FuncName, $oSelf) ; allows binary code to call autoit functions
	Local $arg = $oSelf.__params__ ; fetch params
	If IsArray($arg) Then
		Local $ret = Call($FuncName, $arg) ; Call
		If @error = 0xDEAD And @extended = 0xBEEF Then Return 0
		$oSelf.__error__ = @error ; set error
		$oSelf.__result__ = $ret ; set result
		Return 1
	EndIf
EndFunc   ;==>__Au3Obj_FunctionProxy
Func __Au3Obj_EnumFunctionProxy($iAction, $FuncName, $oSelf, $pVarCurrent, $pVarResult)
	Local $Current, $ret
	Switch $iAction
		Case 0 ; Next
			$Current = $oSelf.__bridge__(Number($pVarCurrent))
			$ret = Execute($FuncName & "($oSelf, $Current)")
			If @error Then Return False
			$oSelf.__bridge__(Number($pVarCurrent)) = $Current
			$oSelf.__bridge__(Number($pVarResult)) = $ret
			Return 1
		Case 1 ;Skip
			Return False
		Case 2 ; Reset
			$Current = $oSelf.__bridge__(Number($pVarCurrent))
			$ret = Execute($FuncName & "($oSelf, $Current)")
			If @error Or Not $ret Then Return False
			$oSelf.__bridge__(Number($pVarCurrent)) = $Current
			Return True
	EndSwitch
EndFunc   ;==>__Au3Obj_EnumFunctionProxy
#EndRegion Proxy Functions
#Region Call Pointer
Func __Au3Obj_PointerCall($sRetType, $pAddress, $sType1 = "", $vParam1 = 0, $sType2 = "", $vParam2 = 0, $sType3 = "", $vParam3 = 0, $sType4 = "", $vParam4 = 0, $sType5 = "", $vParam5 = 0, $sType6 = "", $vParam6 = 0, $sType7 = "", $vParam7 = 0, $sType8 = "", $vParam8 = 0, $sType9 = "", $vParam9 = 0, $sType10 = "", $vParam10 = 0, $sType11 = "", $vParam11 = 0, $sType12 = "", $vParam12 = 0, $sType13 = "", $vParam13 = 0, $sType14 = "", $vParam14 = 0, $sType15 = "", $vParam15 = 0, $sType16 = "", $vParam16 = 0, $sType17 = "", $vParam17 = 0, $sType18 = "", $vParam18 = 0, $sType19 = "", $vParam19 = 0, $sType20 = "", $vParam20 = 0)
	Local Static $pHook, $hPseudo, $tPtr, $sFuncName = "MemoryCallEntry"
	If $pAddress Then
		If Not $pHook Then
			Local $sDll = "AutoItObject.dll"
			If $__Au3Obj_X64 Then $sDll = "AutoItObject_X64.dll"
			$hPseudo = DllOpen($sDll)
			If $hPseudo = -1 Then
				$sDll = "kernel32.dll"
				$sFuncName = "GlobalFix"
				$hPseudo = DllOpen($sDll)
			EndIf
			Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetModuleHandleW", "wstr", $sDll)
			If @error Or Not $aCall[0] Then Return SetError(7, @error, 0) ; Couldn't get dll handle
			Local $hModuleHandle = $aCall[0]
			$aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetProcAddress", "ptr", $hModuleHandle, "str", $sFuncName)
			If @error Then Return SetError(8, @error, 0) ; Wanted function not found
			$pHook = $aCall[0]
			$aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "VirtualProtect", "ptr", $pHook, "dword", 7 + 5 * $__Au3Obj_X64, "dword", 64, "dword*", 0)
			If @error Or Not $aCall[0] Then Return SetError(9, @error, 0) ; Unable to set MEM_EXECUTE_READWRITE
			If $__Au3Obj_X64 Then
				DllStructSetData(DllStructCreate("word", $pHook), 1, 0xB848)
				DllStructSetData(DllStructCreate("word", $pHook + 10), 1, 0xE0FF)
			Else
				DllStructSetData(DllStructCreate("byte", $pHook), 1, 0xB8)
				DllStructSetData(DllStructCreate("word", $pHook + 5), 1, 0xE0FF)
			EndIf
			$tPtr = DllStructCreate("ptr", $pHook + 1 + $__Au3Obj_X64)
		EndIf
		DllStructSetData($tPtr, 1, $pAddress)
		Local $aRet
		Switch @NumParams
			Case 2
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName)
			Case 4
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1)
			Case 6
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2)
			Case 8
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3)
			Case 10
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4)
			Case 12
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5)
			Case 14
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6)
			Case 16
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7)
			Case 18
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8)
			Case 20
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9)
			Case 22
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
			Case 24
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
			Case 26
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12)
			Case 28
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13)
			Case 30
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14)
			Case 32
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15)
			Case 34
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16)
			Case 36
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17)
			Case 38
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18)
			Case 40
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19)
			Case 42
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19, $sType20, $vParam20)
			Case Else
				If Mod(@NumParams, 2) Then Return SetError(4, 0, 0) ; Bad number of parameters
				Return SetError(5, 0, 0) ; Max number of parameters exceeded
		EndSwitch
		Return SetError(@error, @extended, $aRet) ; All went well. Error description and return values like with DllCall()
	EndIf
	Return SetError(6, 0, 0) ; Null address specified
EndFunc   ;==>__Au3Obj_PointerCall
#EndRegion Call Pointer
#Region Embedded DLL
Func __Au3Obj_Mem_DllOpen($bBinaryImage = 0, $sSubrogor = "cmd.exe")
	If Not $bBinaryImage Then
		If $__Au3Obj_X64 Then
			$bBinaryImage = __Au3Obj_Mem_BinDll_X64()
		Else
			$bBinaryImage = __Au3Obj_Mem_BinDll()
		EndIf
	EndIf
	Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinaryImage) & "]")
	DllStructSetData($tBinary, 1, $bBinaryImage) ; fill the structure
	Local $pPointer = DllStructGetPtr($tBinary)
	Local $tIMAGE_DOS_HEADER = DllStructCreate("char Magic[2];" & _
			"word BytesOnLastPage;" & _
			"word Pages;" & _
			"word Relocations;" & _
			"word SizeofHeader;" & _
			"word MinimumExtra;" & _
			"word MaximumExtra;" & _
			"word SS;" & _
			"word SP;" & _
			"word Checksum;" & _
			"word IP;" & _
			"word CS;" & _
			"word Relocation;" & _
			"word Overlay;" & _
			"char Reserved[8];" & _
			"word OEMIdentifier;" & _
			"word OEMInformation;" & _
			"char Reserved2[20];" & _
			"dword AddressOfNewExeHeader", _
			$pPointer)
	$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader") ; move to PE file header
	$pPointer += 4 ; size of skipped $tIMAGE_NT_SIGNATURE structure
	Local $tIMAGE_FILE_HEADER = DllStructCreate("word Machine;" & _
			"word NumberOfSections;" & _
			"dword TimeDateStamp;" & _
			"dword PointerToSymbolTable;" & _
			"dword NumberOfSymbols;" & _
			"word SizeOfOptionalHeader;" & _
			"word Characteristics", _
			$pPointer)
	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
	$pPointer += 20 ; size of $tIMAGE_FILE_HEADER structure
	Local $tMagic = DllStructCreate("word Magic;", $pPointer)
	Local $iMagic = DllStructGetData($tMagic, 1)
	Local $tIMAGE_OPTIONAL_HEADER
	If $iMagic = 267 Then ; x86 version
		If $__Au3Obj_X64 Then Return SetError(1, 0, -1) ; incompatible versions
		$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;" & _
				"byte MajorLinkerVersion;" & _
				"byte MinorLinkerVersion;" & _
				"dword SizeOfCode;" & _
				"dword SizeOfInitializedData;" & _
				"dword SizeOfUninitializedData;" & _
				"dword AddressOfEntryPoint;" & _
				"dword BaseOfCode;" & _
				"dword BaseOfData;" & _
				"dword ImageBase;" & _
				"dword SectionAlignment;" & _
				"dword FileAlignment;" & _
				"word MajorOperatingSystemVersion;" & _
				"word MinorOperatingSystemVersion;" & _
				"word MajorImageVersion;" & _
				"word MinorImageVersion;" & _
				"word MajorSubsystemVersion;" & _
				"word MinorSubsystemVersion;" & _
				"dword Win32VersionValue;" & _
				"dword SizeOfImage;" & _
				"dword SizeOfHeaders;" & _
				"dword CheckSum;" & _
				"word Subsystem;" & _
				"word DllCharacteristics;" & _
				"dword SizeOfStackReserve;" & _
				"dword SizeOfStackCommit;" & _
				"dword SizeOfHeapReserve;" & _
				"dword SizeOfHeapCommit;" & _
				"dword LoaderFlags;" & _
				"dword NumberOfRvaAndSizes", _
				$pPointer)
		$pPointer += 96 ; size of $tIMAGE_OPTIONAL_HEADER
	ElseIf $iMagic = 523 Then ; x64 version
		If Not $__Au3Obj_X64 Then Return SetError(1, 0, -1) ; incompatible versions
		$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;" & _
				"byte MajorLinkerVersion;" & _
				"byte MinorLinkerVersion;" & _
				"dword SizeOfCode;" & _
				"dword SizeOfInitializedData;" & _
				"dword SizeOfUninitializedData;" & _
				"dword AddressOfEntryPoint;" & _
				"dword BaseOfCode;" & _
				"uint64 ImageBase;" & _
				"dword SectionAlignment;" & _
				"dword FileAlignment;" & _
				"word MajorOperatingSystemVersion;" & _
				"word MinorOperatingSystemVersion;" & _
				"word MajorImageVersion;" & _
				"word MinorImageVersion;" & _
				"word MajorSubsystemVersion;" & _
				"word MinorSubsystemVersion;" & _
				"dword Win32VersionValue;" & _
				"dword SizeOfImage;" & _
				"dword SizeOfHeaders;" & _
				"dword CheckSum;" & _
				"word Subsystem;" & _
				"word DllCharacteristics;" & _
				"uint64 SizeOfStackReserve;" & _
				"uint64 SizeOfStackCommit;" & _
				"uint64 SizeOfHeapReserve;" & _
				"uint64 SizeOfHeapCommit;" & _
				"dword LoaderFlags;" & _
				"dword NumberOfRvaAndSizes", _
				$pPointer)
		$pPointer += 112 ; size of $tIMAGE_OPTIONAL_HEADER
	Else
		Return SetError(1, 0, -1) ; incompatible versions
	EndIf
	Local $iEntryPoint = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint") ; if loaded binary image would start executing at this address
	Local $pOptionalHeaderImageBase = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "ImageBase") ; address of the first byte of the image when it's loaded in memory
	$pPointer += 8 ; skipping IMAGE_DIRECTORY_ENTRY_EXPORT
	Local $tIMAGE_DIRECTORY_ENTRY_IMPORT = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
	Local $pAddressImport = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "VirtualAddress")
	$pPointer += 8 ; size of $tIMAGE_DIRECTORY_ENTRY_IMPORT
	$pPointer += 24 ; skipping IMAGE_DIRECTORY_ENTRY_RESOURCE, IMAGE_DIRECTORY_ENTRY_EXCEPTION, IMAGE_DIRECTORY_ENTRY_SECURITY
	Local $tIMAGE_DIRECTORY_ENTRY_BASERELOC = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
	Local $pAddressNewBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "VirtualAddress")
	Local $iSizeBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "Size")
	$pPointer += 8 ; size of IMAGE_DIRECTORY_ENTRY_BASERELOC
	$pPointer += 40 ; skipping IMAGE_DIRECTORY_ENTRY_DEBUG, IMAGE_DIRECTORY_ENTRY_COPYRIGHT, IMAGE_DIRECTORY_ENTRY_GLOBALPTR, IMAGE_DIRECTORY_ENTRY_TLS, IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG
	$pPointer += 40 ; five more generally unused data directories
	Local $pBaseAddress = __Au3Obj_Mem_LoadLibraryEx($sSubrogor, 1) ; "lighter" loading, DONT_RESOLVE_DLL_REFERENCES
	If @error Then Return SetError(2, 0, -1) ; Couldn't load subrogor
	Local $pHeadersNew = DllStructGetPtr($tIMAGE_DOS_HEADER) ; starting address of binary image headers
	Local $iOptionalHeaderSizeOfHeaders = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfHeaders") ; the size of the MS-DOS stub, the PE header, and the section headers
	If Not __Au3Obj_Mem_VirtualProtect($pBaseAddress, $iOptionalHeaderSizeOfHeaders, 4) Then Return SetError(3, 0, -1) ; Couldn't set proper protection for headers
	DllStructSetData(DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeaders & "]", $pBaseAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeaders & "]", $pHeadersNew), 1))
	Local $tIMAGE_SECTION_HEADER
	Local $iSizeOfRawData, $pPointerToRawData
	Local $iVirtualSize, $iVirtualAddress
	Local $pRelocRaw
	For $i = 1 To $iNumberOfSections
		$tIMAGE_SECTION_HEADER = DllStructCreate("char Name[8];" & _
				"dword UnionOfVirtualSizeAndPhysicalAddress;" & _
				"dword VirtualAddress;" & _
				"dword SizeOfRawData;" & _
				"dword PointerToRawData;" & _
				"dword PointerToRelocations;" & _
				"dword PointerToLinenumbers;" & _
				"word NumberOfRelocations;" & _
				"word NumberOfLinenumbers;" & _
				"dword Characteristics", _
				$pPointer)
		$iSizeOfRawData = DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData")
		$pPointerToRawData = $pHeadersNew + DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")
		$iVirtualAddress = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualAddress")
		$iVirtualSize = DllStructGetData($tIMAGE_SECTION_HEADER, "UnionOfVirtualSizeAndPhysicalAddress")
		If $iVirtualSize And $iVirtualSize < $iSizeOfRawData Then $iSizeOfRawData = $iVirtualSize
		If Not __Au3Obj_Mem_VirtualProtect($pBaseAddress + $iVirtualAddress, $iVirtualSize, 64) Then
			$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure
			ContinueLoop
		EndIf
		DllStructSetData(DllStructCreate("byte[" & $iVirtualSize & "]", $pBaseAddress + $iVirtualAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iVirtualSize & "]"), 1))
		If $iSizeOfRawData Then DllStructSetData(DllStructCreate("byte[" & $iSizeOfRawData & "]", $pBaseAddress + $iVirtualAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iSizeOfRawData & "]", $pPointerToRawData), 1))
		If $iVirtualAddress <= $pAddressNewBaseReloc And $iVirtualAddress + $iSizeOfRawData > $pAddressNewBaseReloc Then $pRelocRaw = $pPointerToRawData + ($pAddressNewBaseReloc - $iVirtualAddress)
		If $iVirtualAddress <= $pAddressImport And $iVirtualAddress + $iSizeOfRawData > $pAddressImport Then __Au3Obj_Mem_FixImports($pPointerToRawData + ($pAddressImport - $iVirtualAddress), $pBaseAddress) ; fix imports in place
		$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure
	Next
	If $pAddressNewBaseReloc And $iSizeBaseReloc Then __Au3Obj_Mem_FixReloc($pRelocRaw, $iSizeBaseReloc, $pBaseAddress, $pOptionalHeaderImageBase, $iMagic = 523)
	Local $pEntryFunc = $pBaseAddress + $iEntryPoint
	__Au3Obj_PointerCall("bool", $pEntryFunc, "ptr", $pBaseAddress, "dword", 1, "ptr", 0) ; DLL_PROCESS_ATTACH
	Local $hPseudo = DllOpen($sSubrogor)
	__Au3Obj_Mem_FreeLibrary($pBaseAddress) ; decrement reference count
	Return $hPseudo
EndFunc   ;==>__Au3Obj_Mem_DllOpen
Func __Au3Obj_Mem_FixReloc($pData, $iSize, $pAddressNew, $pAddressOld, $fImageX64)
	Local $iDelta = $pAddressNew - $pAddressOld ; dislocation value
	Local $tIMAGE_BASE_RELOCATION, $iRelativeMove
	Local $iVirtualAddress, $iSizeofBlock, $iNumberOfEntries
	Local $tEnries, $iData, $tAddress
	Local $iFlag = 3 + 7 * $fImageX64 ; IMAGE_REL_BASED_HIGHLOW = 3 or IMAGE_REL_BASED_DIR64 = 10
	While $iRelativeMove < $iSize ; for all data available
		$tIMAGE_BASE_RELOCATION = DllStructCreate("dword VirtualAddress; dword SizeOfBlock", $pData + $iRelativeMove)
		$iVirtualAddress = DllStructGetData($tIMAGE_BASE_RELOCATION, "VirtualAddress")
		$iSizeofBlock = DllStructGetData($tIMAGE_BASE_RELOCATION, "SizeOfBlock")
		$iNumberOfEntries = ($iSizeofBlock - 8) / 2
		$tEnries = DllStructCreate("word[" & $iNumberOfEntries & "]", DllStructGetPtr($tIMAGE_BASE_RELOCATION) + 8)
		For $i = 1 To $iNumberOfEntries
			$iData = DllStructGetData($tEnries, 1, $i)
			If BitShift($iData, 12) = $iFlag Then ; check type
				$tAddress = DllStructCreate("ptr", $pAddressNew + $iVirtualAddress + BitAND($iData, 0xFFF)) ; the rest of $iData is offset
				DllStructSetData($tAddress, 1, DllStructGetData($tAddress, 1) + $iDelta) ; this is what's this all about
			EndIf
		Next
		$iRelativeMove += $iSizeofBlock
	WEnd
	Return 1 ; all OK!
EndFunc   ;==>__Au3Obj_Mem_FixReloc
Func __Au3Obj_Mem_FixImports($pImportDirectory, $hInstance)
	Local $hModule, $tFuncName, $sFuncName, $pFuncAddress
	Local $tIMAGE_IMPORT_MODULE_DIRECTORY, $tModuleName
	Local $tBufferOffset2, $iBufferOffset2
	Local $iInitialOffset, $iInitialOffset2, $iOffset
	While 1
		$tIMAGE_IMPORT_MODULE_DIRECTORY = DllStructCreate("dword RVAOriginalFirstThunk;" & _
				"dword TimeDateStamp;" & _
				"dword ForwarderChain;" & _
				"dword RVAModuleName;" & _
				"dword RVAFirstThunk", _
				$pImportDirectory)
		If Not DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk") Then ExitLoop ; the end
		$tModuleName = DllStructCreate("char Name[64]", $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName"))
		$hModule = __Au3Obj_Mem_LoadLibraryEx(DllStructGetData($tModuleName, "Name")) ; load the module, full load
		$iInitialOffset = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk")
		$iInitialOffset2 = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAOriginalFirstThunk")
		If $iInitialOffset2 = $hInstance Then $iInitialOffset2 = $iInitialOffset
		$iOffset = 0 ; back to 0
		While 1
			$tBufferOffset2 = DllStructCreate("ptr", $iInitialOffset2 + $iOffset)
			$iBufferOffset2 = DllStructGetData($tBufferOffset2, 1) ; value at that address
			If Not $iBufferOffset2 Then ExitLoop ; zero value is the end
			If BitShift(BinaryMid($iBufferOffset2, $__Au3Obj_PTR_SIZE, 1), 7) Then ; MSB is set for imports by ordinal, otherwise not
				$pFuncAddress = __Au3Obj_Mem_GetAddress($hModule, BitAND($iBufferOffset2, 0xFFFFFF)) ; the rest is ordinal value
			Else
				$tFuncName = DllStructCreate("word Ordinal; char Name[64]", $hInstance + $iBufferOffset2)
				$sFuncName = DllStructGetData($tFuncName, "Name")
				$pFuncAddress = __Au3Obj_Mem_GetAddress($hModule, $sFuncName)
			EndIf
			DllStructSetData(DllStructCreate("ptr", $iInitialOffset + $iOffset), 1, $pFuncAddress) ; and this is what's this all about
			$iOffset += $__Au3Obj_PTR_SIZE ; size of $tBufferOffset2
		WEnd
		$pImportDirectory += 20 ; size of $tIMAGE_IMPORT_MODULE_DIRECTORY
	WEnd
	Return 1 ; all OK!
EndFunc   ;==>__Au3Obj_Mem_FixImports
Func __Au3Obj_Mem_Base64Decode($sData) ; Ward
	Local $bOpcode
	If $__Au3Obj_X64 Then
		$bOpcode = Binary("0x4156415541544D89CC555756534C89C34883EC20410FB64104418800418B3183FE010F84AB00000073434863D24D89C54889CE488D3C114839FE0F84A50100000FB62E4883C601E8B501000083ED2B4080FD5077E2480FBEED0FB6042884C00FBED078D3C1E20241885500EB7383FE020F841C01000031C083FE03740F4883C4205B5E5F5D415C415D415EC34863D24D89C54889CE488D3C114839FE0F84CA0000000FB62E4883C601E85301000083ED2B4080FD5077E2480FBEED0FB6042884C078D683E03F410845004983C501E964FFFFFF4863D24D89C54889CE488D3C114839FE0F84E00000000FB62E4883C601E80C01000083ED2B4080FD5077E2480FBEED0FB6042884C00FBED078D389D04D8D7501C1E20483E03041885501C1F804410845004839FE747B0FB62E4883C601E8CC00000083ED2B4080FD5077E6480FBEED0FB6042884C00FBED078D789D0C1E2064D8D6E0183E03C41885601C1F8024108064839FE0F8536FFFFFF41C7042403000000410FB6450041884424044489E84883C42029D85B5E5F5D415C415D415EC34863D24889CE4D89C6488D3C114839FE758541C7042402000000410FB60641884424044489F04883C42029D85B5E5F5D415C415D415EC341C7042401000000410FB6450041884424044489E829D8E998FEFFFF41C7042400000000410FB6450041884424044489E829D8E97CFEFFFFE8500000003EFFFFFF3F3435363738393A3B3C3DFFFFFFFEFFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A1B1C1D1E1F202122232425262728292A2B2C2D2E2F3031323358C3")
	Else
		$bOpcode = Binary("0x5557565383EC1C8B6C243C8B5424388B5C24308B7424340FB6450488028B550083FA010F84A1000000733F8B5424388D34338954240C39F30F848B0100000FB63B83C301E8890100008D57D580FA5077E50FBED20FB6041084C00FBED078D78B44240CC1E2028810EB6B83FA020F841201000031C083FA03740A83C41C5B5E5F5DC210008B4C24388D3433894C240C39F30F84CD0000000FB63B83C301E8300100008D57D580FA5077E50FBED20FB6041084C078DA8B54240C83E03F080283C2018954240CE96CFFFFFF8B4424388D34338944240C39F30F84D00000000FB63B83C301E8EA0000008D57D580FA5077E50FBED20FB6141084D20FBEC278D78B4C240C89C283E230C1FA04C1E004081189CF83C70188410139F374750FB60383C3018844240CE8A80000000FB654240C83EA2B80FA5077E00FBED20FB6141084D20FBEC278D289C283E23CC1FA02C1E006081739F38D57018954240C8847010F8533FFFFFFC74500030000008B4C240C0FB60188450489C82B44243883C41C5B5E5F5DC210008D34338B7C243839F3758BC74500020000000FB60788450489F82B44243883C41C5B5E5F5DC210008B54240CC74500010000000FB60288450489D02B442438E9B1FEFFFFC7450000000000EB99E8500000003EFFFFFF3F3435363738393A3B3C3DFFFFFFFEFFFFFF000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF1A1B1C1D1E1F202122232425262728292A2B2C2D2E2F3031323358C3")
	EndIf
	Local $tCodeBuffer = DllStructCreate("byte[" & BinaryLen($bOpcode) & "]")
	DllStructSetData($tCodeBuffer, 1, $bOpcode)
	__Au3Obj_Mem_VirtualProtect(DllStructGetPtr($tCodeBuffer), DllStructGetSize($tCodeBuffer), 64)
	If @error Then Return SetError(1, 0, "")
	Local $iLen = StringLen($sData)
	Local $tOut = DllStructCreate("byte[" & $iLen & "]")
	Local $tState = DllStructCreate("byte[16]")
	Local $Call = __Au3Obj_PointerCall("int", DllStructGetPtr($tCodeBuffer), "str", $sData, "dword", $iLen, "ptr", DllStructGetPtr($tOut), "ptr", DllStructGetPtr($tState))
	If @error Then Return SetError(2, 0, "")
	Return BinaryMid(DllStructGetData($tOut, 1), 1, $Call[0])
EndFunc   ;==>__Au3Obj_Mem_Base64Decode
Func __Au3Obj_Mem_LoadLibraryEx($sModule, $iFlag = 0)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "handle", "LoadLibraryExW", "wstr", $sModule, "handle", 0, "dword", $iFlag)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_Mem_LoadLibraryEx
Func __Au3Obj_Mem_FreeLibrary($hModule)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "FreeLibrary", "handle", $hModule)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_Mem_FreeLibrary
Func __Au3Obj_Mem_GetAddress($hModule, $vFuncName)
	Local $sType = "str"
	If IsNumber($vFuncName) Then $sType = "int" ; if ordinal value passed
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetProcAddress", "handle", $hModule, $sType, $vFuncName)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_Mem_GetAddress
Func __Au3Obj_Mem_VirtualProtect($pAddress, $iSize, $iProtection)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "VirtualProtect", "ptr", $pAddress, "dword_ptr", $iSize, "dword", $iProtection, "dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_Mem_VirtualProtect
Func __Au3Obj_Mem_BinDll()
    Local $sData = "TVpAAAEAAAACAAAA//8AALgAAAAAAAAACgAAAAAAAAAOH7oOALQJzSG4AUzNIVdpbjMyIC5ETEwuDQokQAAAAFBFAABMAQMAmYvVTQAAAAAAAAAA4AACIwsBCgAAOgAAABgAAAAAAABbkwAAABAAAABQAAAAAAAQABAAAAACAAAFAAEAAAAAAAUAAQAAAAAAALAAAAACAAAAAAAAAgAABQAAEAAAEAAAAAAQAAAQAAAAAAAAEAAAAACQAABUAgAAVJIAAAgBAAAAoAAAcAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALiSAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALk1QUkVTUzEAgAAAABAAAAAqAAAAAgAAAAAAAAAAAAAAAAAA4AAA4C5NUFJFU1MyFgYAAACQAAAACAAAACwAAAAAAAAAAAAAAAAAAOAAAOAucnNyYwAAAHADAAAAoAAAAAQAAAA0AAAAAAAAAAAAAAAAAABAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdjIuMTcIAJopAABVAIvs/3UIagj/ABVYUAAQUP8VSlQM0DXMQgAsBgXIUoPsIIPk8NkAwNlUJBjffCQCEN9sJBCLFrAIQEQCUQhMx+MNkF4oneeRzUECsMhAEhgPAAAAABgY/P///zcIAg3ABBSD0gDraCw65DLYLqMNsI5EARH3wipRh5sNwUWCYRDJw1aLAPGDJgCDZhgAFI1GCBUAgBUAi8ZIXi6xaEAOB1DoQBPOkDVojGD1D1JBqANew4sBwwGNQQjDi0EYZxAAi0UIiUEYXcIFBACLQRwgxgESgBhgdbWY33iHIGA26ANAdyBIaiAIWP8AZokG/xVBiByQeATx5cVF" & _
            "gC4wGIwQ9V/BGw8DhFUBbAT/FQQ+ADCTrCYApHUvDvAAGXyfvYAcRYDO6P//zxOJBriTAABXEIRUAjBKDQacHIEJjUYYUMcGCDxRABAdMItGCECL9QBRCINmCABAXg1CVot1DFczAckzwGaJTfQGAECuRpDV2Ac/AyCdWAR/XGQPAAAADJBYpG92DFDkD2A0f3pcBABOQCAAcFxkDgoz6jDgDmBEtwGsCHACPiM9f0oHwLDYBJEYgCtwAAQAuA5xAsAh9gJAMAP85ZUszAB8EGMTjUgYUf9wDAj/cAxRE3kQi00AFIkBM8mFwA8BlMGLwV3CELNAImoAVkahFmA19wHYG8BAXcIIRA8AAaEmQKQEALgB4B8AVLMOgPDvRLAIYkRwAOCM/hgAYAJglR4zA3wZmDZhhkIAkBiT2BdEsFg0wJBoxLBYJAKBAA4UiUYU0xGlY2Fwo2TYFSLew3AVFPALQmXVKQBcFIAxFvMLAQpSB11RdQiLBlYi/1DMAJEI0xXRBd4Vww45AwODIAAzUcDjQFNlE0YYV2mzJIs9aRP/123jVfwN//+LHV8TTJGYBqEwvWjEoacMbh/QUewGNJFoxCEmIGKqKf0C6/tiMhQAIgZfMl5bhxBZAP82ajITAJyVaJBoRFAaAPhA8p9EsBhEsAhQhbADPYewmCCwSBCYSBDZIDEF2FoQP/N/bMAiBQAAkeMHYeexCDgfwIFbuE3nsEixjH5rCVMPMEc7AX4QcuKNXgwsICBCAACw2FNO0QhghAL1f91ohMSrIDgK0BWwB7gPu2iXAVJov2egMf8zDoO8B7BtUoUxIDDIjgEwtag8GB5gdQXxUCjMA/bCAg8ghbkQwvBAOCKAAADQw9cVUNe2SFDHMeiHgAMoB4AbAEYEM9uDOP0AD5TDM8CF2w8AlcCL+IsGwecABAPHD7cIg/kAFXQZg/kUdBQAg/kadBuD+RMAdBaD+QN0EekA6wUAAGoTagBUUL0DrL0TNnxCCQwQDE4wYAz1T1fgg5Ce" & _
            "YGAOeuYBGASAMIiHAPBACERrAoPAOItNHAH/MVDrbT15PKDxUFjYTEBkkUSChLO+/QUzRPAFEfBQuIQHA4sGLUAeLRA3ABgadCAtEDcAA3QWALgFAAKA6UoMpDfABu8VdSCnODPAl0DSs4cbXakEuKAOSBu40FjUOGAH8x9SgeoEhcB1OU0Ak1UJaBDHAmaJsQZZGZAmkBgUd8ChloAFYZYYFF3AkQiHAT1TgyekSDBojGJFs86YDxNigFAOAJVeZfARgUcSEtlgpI8BAYPAWOvhPXcwIeCy2Icw+AcTi4wwsFgHEqa3pXFHgnwA00OQ/tAUgc9fR8VUCIJBBlhk0QcCdEVGDVhqKGaJDAfo+PjlBJkDE/8AdiCLyP92HP8EdhhW6M4hA+sCDDPAiUd5R6Ays02wM/zA+GAvCIsAfhBHO8cPjQCAHOHHsMhzmNgXgGC2s/xQeIQHtL8jPhDyO8A9S/GMDrb+PUANCTleCA8ohMgmo20CSA+EQl/HAkgPhbMoUbfEUa4wiA8IgThgBELWDJDLAAIwp8AxYJaD8FCYoQVrEisVoJsR+PsCByKwRYGUvEWgNjCgMAO8JVKYHEaQ2ARyRmZGsINBtzDVQptTFATyQtZIdIMANSYgSiucQJD+pJA1MKC01Q5QWHoBDnIB0mgMAheAAnV/D1ALAIsR+YvHkRqD4ALEIWQwAG4wCAyRFS9QCPTfHjAAvEhkjABtpAA8BAQ0998b/wKD5/6DxwJVAokARfQD/o1F8FeG4QEg6RQI2QY5KymW7QT/NsEBK2UD9SX/jCIH8Iw+nSEhCSCJRmAkngDZLbCIhTBYBsAO0DgkkFiEDtBYhA6lFqDGAPFfgWkUEE0MUVAQiUX49WpThdt+EUaLw1UCx0X0OQMAAIld/Itd9IlMRboAMTDshVBRAACLA00YjUQI8IEBYAPYyTHYhgExOAwR8N/EX/f8X5cFANi1segFtliEfxxiBJYcAJBevhB46ZUXeCOZJVCC1EqRgtOHDhXVR+kC"
    $sData &= "hqV1i/i4ga0VZjkHD4US0RdWd9GXANEXBn0GWfUCCASDOP91I5F8Zol1HpIUYeAADRCUqglh0EXDVid7AEwByQSxFiUJ1J4AFaGiGaFfIBh+TbeoYbDYkw9RFHRQFHONHXkGZDapAlkHi3YYAIl19IP+/3Un4J1xShNRGjHYBy9g9Rx9UaSUXtOi0BrQekBUYUlEEEBAp4DrUBwVkNMF8kB4ry/MACZNCMkh6YdeBNHezFCdQpGDH8Ofg6+An4Mvgp+DMZwFkIPGP2gGhgzaDwAEk3KiNmCWaITigmVFAViBIgklxhIxKNAHApDoBZZXQBfX0CDidFBZkv9OCBEBgZUm/f/9fwUD4QMY6wW4GCHMAMnCJOxSHGTvAN4OAeLtAGoSwYBrWDoChX4uo9YAvgTxQGjuIOCDyP9yHLN4HLNurzYhuBGPHtVSELCIPbj/7zeSACBwtciDWfjv/gDPoO4PcmXoMFONTgzofznGAyAaIToeVl4RC0ILGSBI8IUHdDNYZTaIA+BHV7J4xDC1iMMBKxTxAGBQO8EAuwWyvpAS0PjEgI5DppEI4SUhM9s2E3C1CNYTU2EnMYleBIleAwiJXgyJXiyghAEAKFCJXhiJXhwDiV4giV4k/hHlIlFBWBSgBoIuKG+NAAA7w3QLi8jon8qdLbYI8D9VHOBNA2pTAiDwDgJoWAIawAJVP70IV8IasJwj8OWaAZxmEhIVlRNPI8UA7gGQ8yUBYddXFoAeXxbDAFgWlFiEsD6Q2AWE0DXCv8iAmNi0hu8UIJUDULUhi0DgCiD/QGFLEECRuwEkGRJAEboSDxQtEo0WNTL/RfyNCQA7RxByg4tHGIDdAA7/dyCLzv8CdxxQ6HEDtULJkXE2UVH+HvdQaKkwEEQ94RkAdH0xDYNlQPyNA34QQE/HRVH4QgMAIJoBdE5T4hgBXI9UblGH0+iFMsVY+tNYhJ/UGLhllgg1wDxWebtPdbRb9XYZ1WJTtdGz8JUiUFWRAG4Scr1BtQEQ/zZocOIN" & _
            "Bt1q7iPBcQxgIwH/pcohgiGZAGiEhLpAKJZ2FrHODQeccB9gVxHrWb9wQAv3AVoUsS4KB2XIcB9ghBHrhXAADqdiDnBiTxHpeg/iC4Hmx8/3ARIVwUc1HHEsvhYQkDKIb5kBLUkCuAYeBAHGRwgtLWogi/noNJfvghSTqgafqmCvdhdQPVB/YYMSzpUnUTd5N1cMJMDPBFbxCtEqNiSVGgUkFAVPIBAFNNgXdcCnkAZTlBEEEwmbBjuYR8AAcBzAX8BQlwDuJBLCLOL/IU0Ii0EIf0BSGuCSIrImgQtOKSN8IpVGaEjo0DvNmTSQTiGx2kOCxfcBm3yIxqexNUqafLAuBwd8cB+QqQoXVXBACfcBmHCBowoHsHAfcAkXG3AA/AqnDXBiWZaiZAApFoEpgBEjDIP5nHUQ9gJFGAJ1ELh+DhIYRCGnAUUYAevuOioAWUVgxKC3EXQPg/lVm0IMAIEYf4hwBR5LLmkAOVjODpCc9yHRcbKOH3FQ46DJAcdGUgwBIJNexwwJAHVBZQg5UlnIYIkFO8NVBUaCVUVqaOhD7ZIBk9CZb9DSoNpBfOQvAAwVQACadWGLfRyLdwAIg/4CdAmD/ggDD4VIAREHi84AA8kz0maDfMgA8AiNTv4PlcKAPLBtNsiDjPAQUDm8MP1Q+MIJgBIa4D9Ql2CWgwSAQDegJpC1aB0QNSD9TweNzgBA+HozgUSw3jeYL5FZ5+TVEEgI7h5AGIRej5E/8HD4XZVBALEYPACcCSAMDxoiwI0mAXYEi1wIwugz/5RQJ7AIoL/oRHA19U9HIIyPzgqRL4ZZt/eSBOAwApIV4CkQi+4BkQBAlMkSTgRTUgGAxq0aX3HFfJexkgXlEV+HofIQdUq54B0AnTKJACN1Oh0CUYvWndIuBRKwjjSYb1l3VBbUbC4D1hOxzhMXgwMIOBHQsoiHcIVGXoaadGCOIusSrRLojM0M3YEozg/U5fxAagaSgYBQ3UJzEKFm01I2gqDyAwwACGpoxwapHeg76+AZ" & _
            "Px33A5o/sRg8iAQB8D+TnIiQiESQkohEAQzqP2JE4P6ThO4+IPFvx0Aj/3ZTCFSTRQ9BBBY3A8yThj6PoKpu6ENGBIo+aQAAyCEQWjOU45MLL7DYhQAwk2yWs/BAGAtaaTEcRbBT92A2CIAnAEA3cLReEJhhkAgR1EiwBAYAAHXhhcl0AUeSViNAOEgLjUHiPKCmJFASk+jTEuPREjE1B+WsAyUxhECgpVMCtXEk/OmEsOgkeAMIiUAIHDADPPNvliMRQGcDGk4MmQcBETt1Fr0HiRwBPADQSBQgsOiEkEhAoDAoTMADR40gBD+MgABQJ70+NmBZBBoVtBgEoUlkjkPFakEgBBYEQCA9ZGY8XEcyGHCQYwRDV6FqAwFG6SBgEBS1B1TCBLLeZM/DPHUe0FT3AF0SPbduTCgCIzAAdBAqBwGE0a1xEJAQEY/gYRCKPUih2IOIGj+VGEQTGxTIDjDo5xAzwFBQaCThWARAjQoOEaX2/28HxCo9EgxaD1HIFIozQPOfUoFQbpHcbNWHICwAhL0XjXRH/qpIoFJHoDMDfKWmiBToBkkz8SZNFAo0oKbiIRMTuP//xiURQGc9AE4EYDKUqPABEMfdEFUH60EbkRcPdBKLxx0HFzp0E0UHT0UnkisQUAIAAdBI89RoJICBBjYl3wQRLTPbWVRDHR0FWRMYgiMw6Ffir9IPUJdi8QH+CfEAKEb+DWGq1kOBsW4omxqukxoWlpATYAYAiwnC6cwX5g4zYx8tAMCQU4fg9/BPA3QbqGKUtVOHwFcXr94xOQUcRMFBGBxkxMEhg8QUcRXuCBIlFuVZIeYN8V+BLjEi+BGLVfxOF9VYxB9VkG0KBYRE60My1gVQxG9vAijrEVQC26+yg7xRAHyPfY/NXt0aShBQ9A8VFdXNoX4DQLjkU6BY9L+OYIkG6CpZAMnGRYM6/KaoBYY6BmbuGcD6DsC1rJ9BnBCE+hHIqJSNCkAJaJDdxZBdxIDL+gTMWfAJZQ0BFhF0KgOLwVeDfQze"
    $sData &= "E5CDIMBSB6Hmsq41BTgALnUGaixfZokEOEKNBFGhKNpfwBpK5DUwjUgBO04IIHZGNlGgRtBIBKBsEUCGAKNZbsIC+N5HkANgRGDnsOiwyAAQmMhwCLRjRAAjJy+FRAkAWY1MAAoCiT6JLhzhoIMEiQQUgf9GBEJOFTXDAIxTBOG8FOpIc2yAx1amoCUAHk4g4QSJRjSsAjpwpd8BjdZJ4blCCIsEXQyDZQgSH4DxIGBbRDFYRoECOIAogDGVaMST2AXuNAACBuI7BfyJVRiNIgRT5kPCV+fQx5CIgNBINCXdAgjrZACD+Qp0BWaFyTB1WnkC4QoI6Mfk0M4IIzgS3uYMkFgEsY5AMFgGIYkhTRDoNSAVlhiDAmkoQoESOFYW1SrGKaGDEotFGAX/RRSNRGovwaCYBEBCDQE7VfwPhnPP+hTgLEIUABZM1SthwyI2InKrwWTy9QAaTLqVB2HBFCUznYoUMeinLwB2A6bHADQeCmLxXwEBJzhwICwE/z4VFLpY4ZRA6kugrSAuLHGHAbGuoW4CDi4Ci85RHSTg4JJOZizw5+CCxg4uQu7QQrAiyQEXHCI38V+31KDDgusnPQbwTijh0GLNNYIOLea11YoQcWPV51Jp9gL9GSpJ8R/tCp3eOKztAYoe4YkBACBSUvBdW/xLHdhJ/x/Y9L/CXdZYC/8f4PDfQP8MjAIAOEF/gY5CkFjF/92GnwF/EIWfAcqXAdRdhJ8BvzAyA2wbAzhdDBkOuQ34DU6yMZvgoM0QxS0QV4kwXjilDZIeAKJGgb4jFS7scdEcohYBFcPV7WdevmJ6Uq5fy7nh+vUBbg0B0fB/g4YRE6CbcREiI4LGLeMAGl6DoesUg348AAB0E4sHiUZA4xEdeToNC9z/N3UAjRqTKitVl+w+IuvE9ljkPgIA7EyD4gFWdQaE/iNBhxKY3wZRBzIrIIUTNgxhHRBAGIYCIFEFMA8wzlbSPJCDxVMHkLCzzAexgwRR0LdgtjOtUUIKAhwCku4AGlAMixSK" & _
            "gP0Ai0kIAwqJVQTYi9GB4gIiAJgI0ASdV6A0qOwPJ4QLjkKCG/9ACI0AQf+ZK8KL8Fck0f7iF7JorH4xddyH3gUj/v3/b8YEyhfDNqpgkwwmDGAPAAsm+KpgAAG2l2DCD/YAfoBgsFgHnVhE3ghi5O8zAsQUiX3UEYlF4DYw4TiQ0C8BAl5SIZFXgDSITOAP9EAYbucEi00A2Dk5dWKLdeCNtiJxMGBvkAF2JBHPBhj/dPCuDiR3FAeLRGDwlkegYgH8i/PB5gwEjTwGGhWQeTFQx0YeTiB6MNhKClA+UQQuQQeD1DQQjS8aFQEI6yvoZYEGi8iLDsYrReBcoicGBk/ADix+MIEA66aLCQPABo1EwfBQNQCiQ7EI0QS/CAh17I1ESEieFoCjQgkPhRe0xhfRpFcBwhYRYEEhi1UA8FlZaipZD7dIwGYScHWVBWCWqBDszkTFAU30DQBAKjkhRYAIBh4pgI8gQwVmAIN97ACJTfAPIIQEISPsZoP5EQB1N2oB6DPe/0n/vkoAkBUCQNfgBAKg/gRB2pSw/qAWoUYDYNUXkAahqJwETewEiAHpZiU2O5G/cFRn6gHo9t3wKHEA8FLE2+CQfi/iEgQL/Ifz8GvGBVDBDgJ1IgxqAui67BkO9dEhGA6AoyawbsIJEip1OZwgyfkC4YEREC1qEoFwZq5y0SWQmBhWNJEJQIA+hf8CXZkQFDdqE5kgAx0DBOhRK5wvoMkZD2oDmXDQlTCRcAyRABDo7tz0jgBQaJN20f/A3mWULsZlwikURmEQlEACFQ8rhLYkQxAOIssO4eBU1+EwBOFw2eEARewo2RjhUAXwgIBeVwn/Ah4e8FIAf93wctQNbx51YF0H5jRRqcGxrqKmQQesZSEAE4uBISBqAVaJdezqBTKwfnBcxI6iKgD+BXAQAIDuv21vEl0JViJhCgRWNiJQx24jUs1SHyh1U5XwISyVMAIA6GeYlRBdAIvw0KCREmFQFAh1SmEQBQEA6yWxVcAQVWBJMAW+MEEA" & _
            "wXygZyZFzI1FzGZlIagWAjyY6YQpPSAaGA+Eu6UMkRsldRWwWQQe5QBZVHUcahQi6y9sYVInxAYCx2yEBll0FclE3gnRdRKQGEWw3qRWEXwoay0V7I4r4gED6zEhEAkYD4V9vQDxBrXa/1//ViaQEAqinwJxOAkCVnEQZ+CTUg480RyQyJNpswQEiQSZ6YvZAWg0teIIOlYBkEr/wRNk1tIRIBxkjyC5Bmoe62dEgEYFVA06Vw0vwhRodpvtHWgcCvGhIAD2AeHnI5kFd6PhApjiJZBIgxkuUhGxBVURWlQRUnNfwYUOhQCY3m5CkNUIEAiQvkuCrHwQPgZSRC9REDxYdAcEagjrD24GYGgQsgVw8HBLEAzloTLQYE8AIFm5oiqyE/xAeM3q/ARm8oFAKP8UMREPhUDLujyCkNjEPogfsVCXIttAD7cH0gUQ3xdVLuE7QOIrgJDuVydgMIgfUYdC+wpqBYHICGsFdR6ID9Dv0e1li1gEiC/gBxDZiKYJB67lSgGA+QBZGulijKXIuLDBEndIoIkAVoP4Azx1fhk37fECNBAmgaBYUMSenneSAyHhCQTFEmnhrgHs6UtIMuGIFELsIXMEdQjbcPCrCicFMMMJIxVGRYCPQPFQmB9JUcSeyZgYVPBQ6FoVsgLQ3QWEnhGfUNFdhB4V5dwnYKgC6PiJEk1BZDtSHXyQFiRAtk9kN0G2TXtkUYWSH0OmpmSh2iIzQLbSzFdRNUExUkeCB+jI1vISUETQYMWwThEjL9C2QRO2ATFIgmmJAdBDM/8A/03gg33g/w8Qj/32fhNQhJ3YFwat3xhNAzk4dGb+GmDpFSEYU2UKasooYakBdUj0xltQRy5uFnX4UzHoUTUDKkSAewIobAFfDcIW4EsSeinCGqRsiQEF/0gIi8akQ2CeEUDUnmgyYL/IBY8/8HBLBA8/Fb3TCkDevCB4Bt42kpXlSAMcdUREXn/RWATOANBQX1MuG9AlcQPVDRZeoZUIvYAY/3XcxSA5IeuHORJ9"
    $sData &= "0HQqAMBRYSoRgwR9HB50BxjxUTfh8HBr/QdF1GwhJxQgRbR6HpTjx0MHI7DoPLONHtIIsKNxXBcjZiWN8AMv8RIBwaIyIHwBi14Y6FICLQAQDC6w2Mfd2IRCG1UWc+WLA/914FJQPl+Ap7MSZcixAMSBTl9wpMaQ2Ees2lZdGOZ2Aa/aVkZN4JkoFDQAMLOd2AWe08Ut8eCo6rcEM/ZaLtAIQ2SgvBlyGEO/2AQe6QwASKk2FvFAyGwGAEo1KHKLjApRrDFFAwXlBwDqFmamygeEgficoBEDmQoifqHfBPgQDwyUwgvKbkOgUAZMDhAIigliIIDIZIGhkZ7hEj9hFwAdmhpBxGbggASiT1ApUAmab2CWWEDkgJH+gTgCqoQhiChmiwDr4UQg4UPnTgHxClykBifIORBCV04BDA+F440twOkAkFCEkdiE/cBzm1AflR7FBPEKHnVkYxEAYgVC5EAVi0AACFNTav9QU1MWiUXYypCjZeAAHh9oxzQtgCDMif0HxgmBPdU05UUGddBCiKVdBNBVEcfyJdMWMoj/oasHnaCeZQIIHOkNLAAAqQD+JmagWwINMx1BZIISuQpVJhiJ+QOLQE0LyRIcsclSFDVzkEewno0GdBU1I0UPgJRtYRPZXFUGuWMFaNaNFt1oyOVhmgRFuQHNw7CSPiadFcAIH4xf8E/HCMuzjIMgtxixtetoXCAvAWBF5jdAAiV1F2oDxB1JFWDpEi34YlJHR+C7Ae0W9hFworIVVRgnagkuC8BkEUqQhqJhCebZMrUQkjpQxC8cGSKhU/REzmLp4GECcJAJ0PSQgoSvkxFcNRAIWbkWpEUwANX2CYDR1fYa6zi3JhnBEQgTB/LvAgmkVDEydqFCALUM/zSIEX3uHQH2L+8ATihgDLFTxO3xwLilwhnGA6GsA4kd9yVFHD0ddCYxGBUxCAsBi0W8LJApIRmlCgRQDOm6L+Jxks417AIAfgFA7VGHVY7TKUMNHJkizJliHJmCmdC3mSIcdhNQKcFc" & _
            "KeGhQRUAYFaZABJDU4eQte6CmAfxUacRphXwXzfEGykXhLDeoDIg7RHmWn3iNSAxFf91dgFg7CdFE/CNfnZkUAfi6Ac2cuR10DHkJBEVtOM88AW2MrDFqlsDJCAA5EADSiOw/SzoKjQHi8jpqdo0MPMCPGxPBsVUaM0VVKAqA6BgwApGCIvIXelmt2TivXroDYoD0A6A/iTYjZCV5YBEekPSU1AV8W8jJv5UZJswsl9C+gI6YUFqXDjsQBZcpIaEztETpLACrz0QyBURZV4kYX8DVUCUsGLvTDkXlEFBGSkQvazxaRoUrGLqNiI5kAxL++JwIZIT4nDjBzfmRkNBArZGNE4CCkeRF2CFDqVsAY6oRWRVWAAxY68qGP8VQhjdFfg7/nWOrLAO9dMTYJYIkVPHUEcgsWNMRyKYBwFW19YO0R1BQQQSPCDRCD0SdFaFIRY2EApAYbQAi8aNSlo2yM4g7BNurcGgZgTzxQF5ECpUEidRAQElAQ7AsQVmR7IOPlhGDxCwiGDVWEUvFXXyLcwBYMCgWQTCVMAo6gABIiH33iJUAD1SRJ97cCwMNbHQMsDrNgKAC5ESs8gAkQFBT4X2Bj/g9VMIgX0Ircp1UAcTiNDH8O4LAidWagz1/xUkIiCRJtBYFIAApSaChkClbyJvIFSAARxeZGP/WuJeo+969pUwPEdC/RwMEBEmgJYEoHsTFSjWDoEu4OoqgPEMCAh0BWoKWIIWtTBjn1MDLe0HdkYetRM0tUgs4K10ESRGO3QiJy4yIV5dAsNmiwR1AESwDjRvDkSLBo1NCFEnaFCiYWD1LyESdnQQFhGwCP8fBbL+gUddQHg2gSd6kgAYFNIngobQBVBiAuNpGDldDA11EFe+5mKhWwulALDxtV6hTRE5JvRqESRzFun1ACoV0TlAEFPyQKhbGK5IhO/sQcdIQBjqlEIQ8uBosBhqBGiIYiSgo0bQhxA4KWEZlwkgCM6qE5FoU7eRbKHNOzFYCPAiTtBOYkgEAlLAANBYtYXf" & _
            "gsDvIhlcgRFx2FmGsDNfB12I0lgFbyDVWAUuJVgGeQC8AIt18DldEHVeyeESLm6w3pq2sLSscTQ1n1P6T9C0VJkUwG+kOVF1xr0A0BLQWERvlCEcagFT2RKNDCEzhWTIjgtgLgDoUDIaQp+1HtXZ76EcBfJAaAQHcVOCBRDekMaUfkUjJCZCg5YsYHU1sw0HFXsILQBhAT5201NE3VPhlgba9hfRTciqCRiRhL+RNJTxkfQGJoIhAAABAVbonokB3NYYYE4a/ToXULYg5ALoSoKtAVaL+OhCHKCGRGR3Ceg4JLAIrzYFYdcSLCwwSCw4A7aYEEcedqC6Bd4f8V/B5AgQITVIOiwzhPb/p0wmpDECREiABtoTcPVPZs0LFIBGTTPrKByNRdQNABLBEIdEuOGo9ifppDiCWuKRIL4ugVaETTyLdeixDuwFBO8AYCgAeACEB3JC4KgwkmYVkJWV04VA5+cIAohaflCAi6spCmoKMwjSWffxmpCQ2IURKMAAO8N2TL8D9QOCyRj/Nv8VPPYe0ceBUGeTN6NqEIFjdSFYaupDgOPqIKprgLFTJMEhdwwbCVPoQUMIFjaLPTAccf1/Ykfg1gld8KEBMSFKTwSRlS5aJYDThVGX1uBGEFoFAI8L6wkoIsRiWDD7D4T+AsaAZkefK6LoJvEADCjgwhXpIC82uQFN9FFoMIJJF03EUf/QsQThKjP2VRBCfgMikANCpptR8xKKEEHg2gloQFNQoCbgtZ5BZWzVEEDwpgRgP2juP2iM6mQB9I0b+I0L1FJTwWYFYRIAdTvzdGNNLBSNVRjlC1Feu1CXBODkRFfgRMexrkSjCRZwFH4VoCFGDFHGHKAiAv8VcKYPQvYCdP7GGKSUC20dOlVQ2xYPABLpL0E35iQwL1IFaC59AGEs8XkG9ipQLWGWBfjrQokMKpPH3T0sdRz45V0crWSQR0YS4Sz2DIJvpTA02FdSX2ClIMNmoIIBABRl1AtLRVJORUwAMzIuZGxsAGwBc3RyY3B5"
    $sData &= "VyACwFbmdgVwVEYHACX3NhZERiYHUDY3B3CVRlYGMIQWJkf11lQHwEaXJpRHVwYAYCRXVsaUJiaXECaXB0BlVG+oRQDA9BZGxkdFeABXAEZsdXNoRgBpbGVCdWZmZUNyTQByaXRlQBELETBFR4YU5kYGAwBDb21wYXJlUwJ0cmluZ1cVkFcCAENsb3NlnEQFUCbXluYWRlcW3BnRGDHFVlYG1wIRUISXRjf0RgZmGENyZZiXJtL0RhZSx9YO4hTWVpYtQzEWRscmQlEAcnkQVHlwXIBUFgYXnCkBIkFsbG9jYVPEJQBMAQBAWa3wxoZUFkI09NYbCJCUREBkJPfWliIDMBTDNMUz/HCWRMQKAEluaXRpYWxpR3rVElVuaTjIWuwV9JYRUeVWN1dWB0SQVjZXhFcTIVUH5EYOZ09iamVjDnRUYWIJFMEieRJNAm9uaWtlcvxAJRA2t9ZU1lYjMgT0RjhJbnN0YW4EY2UAAERGAfDEhFAUVEUVIhRQEAAQcAsQMAoQoAsQEKALELAbEAAgCRBABRCAAAAQkAAQIAAQoAQAEJABEDABEADwABCgARAQAQAQgAEQcAEQwAAAEHAAENAHEABoNQsKAAEzAAESAAEBRwABPQABQIj4EBBgAxBQARZgEQgifTKFxHQVRAOV1AzSKkDVNEBnA0XTewGgiBCLeAQLAP9QdDWLUAiLADAD8Cvyi96LAkgQK8t0I6pdMAAgP+C/ArwivQAAzRosfgCNLgdgvwC9IE2HMACgnbKwcy9Hji5wuQMAgFWgWg0AgPARAGQQAMSAFTAAoABc99ZiKwoAAIA4TXVli3gAPAP4K8Bmi0cAFAP4g8c/6NbA1FC3BYAeyAMAILAATOeDPo8FVgJpcnR1YWwBBnTRsQQGbnBINyBQVHZRIIB3tYj9D40DEACwYIgHiEcoWBBQVFBU8D+NtQji32rTBXQ9A/hWgUUgi9isCsCw6kEA8V9nTwJ04TwgAnYETlbrCSEBrRhOxgbCJtAGsioDDMwI" & _
            "hFBnv36NfkZIBF+Bx+7yAwCbDqGK6+FlAKth6RSiujjg4jEaJTdG1QMlYDsUAPD/mgO1EQAQZwYmABCuEhpHwABgqAwwyACmDPAF8AUAQAZQBmAGECYAUAfABkDHA1+IkgHwBeBEBXcARSwAblzQph0gZCEGcCEHkEYMZ3RAOlwTBccPcgzQBjDHpUZlVCAH8MYAXVBfvCxQRgm1kA1QpAEHYDfWAWA8AWzq1gbSDDfUykhBzHBGIfUQeWwC4jHRK8PqAQAhBsgCBScAEFwfABoQ4RRqu1AgoNYBMHbdDgAQQzUhYTTg2AAAQBTUJkAG0EQDdABWaDUBZEwGVRdUJEFXXQrCNUQ1InRUUFcFot4qwVb1c1KU0MYGdt0cUAfR1hFQAgEQflIHJNhSbyATAgARwgCJVCTNNTosIMQAJiK+/TVw9SBlUwBXFQMwd7U0ClAPwLNj5SBj1QAZAAB47QP9E9ou/XNB/izw9QIAMUYOGGkAOszEciAAL6rNAnX9IkkUMNMugHdcBMIUZQBTJFB+0RrRAwLgVQcAQBHcMcUEvPUXdCTQNNE4URZBxBbEZk8BQ2xhc3PuFAPIBExvbC4gWW8AdSBmb3VuZCAAdGhlIGVhc3QAZXItZWdnLiB7DZrTUBDQaNubkdYr0JjRRkcFTodxV5wIEGREoFteQdZD5mcDNQNvBQZnu0yaRgRlFUQFQAktsH1shao8UQHdFFEBi9YPsOZWi8ISYSzC1pTEWOrNlT2WJIXWDUzWDVDHTQ0dUGYlIQ0THXI2AOvaL9ATRjN2NSJpFSGs8c82HXIAwV8A0TnXQdkY4U1SjDHXw1JpARA0KaZLAm/lKCzX1OHGI3m2bW1ulSAsA+D4DwAB3E8zQhXGU4K9ARA8pQBEgDwFOFL9d+C0AQDh2oIAsOJyTGzGEgD/74gQAbBAAAIAVBIEMEEgAwTAAEBBAVDhKQQFPOABgPdhmQVsRxA0MwGQME0AAEFgLAX4VYZjwABV3AwAzQDADEDLAFWoDMDJ" & _
            "AJAMQMgAVXwMwMYAYAwAxQBVRAxAwwAkDMDBAFUQDEDAAPzGZsDOAFXgDADNALwMwMoAVZwMgMgAdAwAxgBXUAzAwwAsDGAwMgD/n+EBEEThAOIwYMEDQOghA0QE4sEAMACFZQSpREICIKKqM6BmNgAKMIDDAeUhoQQK4IE0YEknJAYGoOKsxSElo2INwINCggKnoQcPSCNeMgUuDMROAAwD6HAcQBRmIEQ6AAA0oG4HBAREEvgFgpCqxAADAkYDFAM0agADIiAm4gOoRAAsSFZYWFZYAwCgOlIDVG46HggDfHp8COAIJwqAh18gykMhpwKgaAso7KxkIQmgh8WDhMTjIgQg42Cuq8SD5AGgxOOCRSQjzwEAxGFk5ISkwwEgzzHgx1HA5QvAwsHBIzZgJwsgNkCFxMiI4QtABcSDb6VCIQFgQ3FgIqwCCwng4eAgqYNBQgKA4kPmwmLiAQIAgkIyIGChggnCocICxAwmChwAJDYKNJJEMhAAXhYeDhYcQCICLLQ0JVYIADKQBctBcByDQzOIHPMP8AlScP/f2AD//4tF2Il90MdF4AQAAAA5OHRmi8joZRUAAIsYU2oI62r/dQyLdQj/dfSLzv915P91/P91+FPoURgAAP9OCLgngAKA6Q0wAAC+J4ACgP91DItNCP919P915P91/P91+FMAAAAAlYvVTQAAAAB4kAAAAQAAABQAAAAUAAAAKJAAAImQAAApkgAAqkAAAIBAAADCQAAAokMAACZFAABKQAAANEAAAB5AAAB1QQAA2kAAAABBAADBQgAA0UIAAGdAAACBQgAA2EEAAJhAAADhQgAAR0IAACxBAABBdXRvSXRPYmplY3QuZGxsANmQAADhkAAA65AAAPeQAAAQkQAAK5EAAD2RAABQkQAAaJEAAHyRAACQkQAAppEAALWRAADFkQAA0JEAAOCRAADvkQAA/JEAAAeSAAAYkgAAQWRkRW51bQBBZGRNZXRob2QAQWRkUHJvcGVydHkAQXV0b0l0T2Jq"
    $sData &= "ZWN0Q3JlYXRlT2JqZWN0AEF1dG9JdE9iamVjdENyZWF0ZU9iamVjdEV4AENsb25lQXV0b0l0T2JqZWN0AENyZWF0ZUF1dG9JdE9iamVjdABDcmVhdGVBdXRvSXRPYmplY3RDbGFzcwBDcmVhdGVEbGxDYWxsT2JqZWN0AENyZWF0ZVdyYXBwZXJPYmplY3QAQ3JlYXRlV3JhcHBlck9iamVjdEV4AElVbmtub3duQWRkUmVmAElVbmtub3duUmVsZWFzZQBJbml0aWFsaXplAE1lbW9yeUNhbGxFbnRyeQBSZWdpc3Rlck9iamVjdABSZW1vdmVNZW1iZXIAUmV0dXJuVGhpcwBVblJlZ2lzdGVyT2JqZWN0AFdyYXBwZXJBZGRNZXRob2QAAAABAAIAAwAEAAUABgAHAAgACQAKAAsADAANAA4ADwAQABEAEgATAAAAALiSAAAAAAAAAAAAAAyTAAC4kgAAxJIAAAAAAAAAAAAAGZMAAMSSAADMkgAAAAAAAAAAAAAykwAAzJIAANSSAAAAAAAAAAAAAD+TAADUkgAAAAAAAAAAAAAAAAAAAAAAAAAAAADokgAA+5IAAAAAAAAjkwAAAAAAAAUBAIAAAAAAS5MAAAAAAAAAAAAAAAAAAAAAAAAAAEdldE1vZHVsZUhhbmRsZUEAAABHZXRQcm9jQWRkcmVzcwBLRVJORUwzMi5ETEwAb2xlMzIuZGxsAAAAQ29Jbml0aWFsaXplAE9MRUFVVDMyLmRsbABTSExXQVBJLmRsbAAAAFN0clRvSW50NjRFeFcAYOgAAAAAWAWfAgAAizAD8CvAi/5mrcHgDIvIUK0ryAPxi8hXUUmKRDkGiAQxdfaL1ovP6FwAAABeWivAiQQytBAr0CvJO8pzJovZrEEk/jzodfJDg8EErQvAeAY7wnPl6wYDw3jfA8Irw4lG/OvW6AAAAABfgceM////sOmquJsCAACr6AAAAABYBRwCAADpDAIAAFWL7IPsFIoCVjP2Rjl1CIlN" & _
            "8IgBiXX4xkX/AA+G4wEAAFNXgH3/AIoMMnQMikQyAcDpBMDgBArIRoNl9ACITf4PtkX/i30IK/g79w+DoAEAAITJD4kXAQAAgH3/AIscMnQDwesEgeP//w8ARoF9+IEIAACL+3Mg0e/2wwF0FIHn/wcAAAPwgceBAAAAgHX/AetLg+d/60WD4wPB7wKD6wB0N0t0J0t0FUt1MoHn//8DAI10MAGBx0FEAADrz4Hn/z8AAIHHQQQAAEbrEYHn/wMAAAPwg8dB67OD5z9HgH3/AHQJD7ccMsHrBOsMM9tmixwygeP/DwAAD7ZF/4B1/wED8IvDg+APg/gPdAWNWAPrOEaB+/8PAAB0CMHrBIPDEusngH3/AHQNiwQywegEJf//AADrBA+3BDJGjZgRAQAARoH7EAEBAHRfi0X4K8eF23RCi33wA8eJXeyLXfiKCP9F+ED/TeyIDB9174pN/uskgH3/AA+2HDJ0DQ+2RDIBwesEweAEC9iLffiLRfD/RfiIHDhG/0X00OGDffQIiE3+D4ya/v//60kzwDhF/3QTikQy/MZF/wAl/AAAAMHgBUbrDGaLRDL7JcAPAADR4IPhfwPIjUQJCIXAdBaLDDKLXfiLffCDRfgEg8YESIkMH3XqD7ZF/4tNCCvIO/EPgiH+//9fW4tF+F7JwgQA6Vm1//8Aev//YgEAAAAQAAAAgAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" & _
            "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAQAAAAGAAAgAAAAAAAAAAAAAAAAAAAAQABAAAAMAAAgAAAAAAAAAAAAAAAAAAAAQAJBAAASAAAAFigAAAYAwAAAAAAAAAAAAAYAzQAAABWAFMAXwBWAEUAUgBTAEkATwBOAF8ASQBOAEYATwAAAAAAvQTv/gAAAQACAAEAAgAIAAIAAQACAAgAAAAAAAAAAAAEAAAAAgAAAAAAAAAAAAAAAAAAAHYCAAABAFMAdAByAGkAbgBnAEYAaQBsAGUASQBuAGYAbwAAAFICAAABADAANAAwADkAMAA0AEIAMAAAADAACAABAEYAaQBsAGUAVgBlAHIAcwBpAG8AbgAAAAAAMQAuADIALgA4AC4AMgAAADQACAABAFAAcgBvAGQAdQBjAHQAVgBlAHIAcwBpAG8AbgAAADEALgAyAC4AOAAuADIAAAB6ACkAAQBGAGkAbABlAEQAZQBzAGMAcgBpAHAAdABpAG8AbgAAAAAAUAByAG8AdgBpAGQAZQBzACAAbwBiAGoAZQBjAHQAIABmAHUAbgBjAHQAaQBvAG4AYQBsAGkAdAB5ACAAZgBvAHIAIABBAHUAdABvAEkAdAAAAAAAOgANAAEAUAByAG8AZAB1AGMAdABOAGEAbQBlAAAAAABBAHUAdABvAEkAdABPAGIA"
    $sData &= "agBlAGMAdAAAAAAAWAAaAAEATABlAGcAYQBsAEMAbwBwAHkAcgBpAGcAaAB0AAAAKABDACkAIABUAGgAZQAgAEEAdQB0AG8ASQB0AE8AYgBqAGUAYwB0AC0AVABlAGEAbQAAAEoAEQABAE8AcgBpAGcAaQBuAGEAbABGAGkAbABlAG4AYQBtAGUAAABBAHUAdABvAEkAdABPAGIAagBlAGMAdAAuAGQAbABsAAAAAAB6ACMAAQBUAGgAZQAgAEEAdQB0AG8ASQB0AE8AYgBqAGUAYwB0AC0AVABlAGEAbQAAAAAAbQBvAG4AbwBjAGUAcgBlAHMALAAgAHQAcgBhAG4AYwBlAHgAeAAsACAASwBpAHAALAAgAFAAcgBvAGcAQQBuAGQAeQAAAAAARAAAAAEAVgBhAHIARgBpAGwAZQBJAG4AZgBvAAAAAAAkAAQAAABUAHIAYQBuAHMAbABhAHQAaQBvAG4AAAAAAAkEsAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    Return __Au3Obj_Mem_Base64Decode($sData)
EndFunc   ;==>__Au3Obj_Mem_BinDll
Func __Au3Obj_Mem_BinDll_X64()
    Local $sData = "TVpAAAEAAAACAAAA//8AALgAAAAAAAAACgAAAAAAAAAOH7oOALQJzSG4AUzNIVdpbjY0IC5ETEwuDQokQAAAAFBFAABkhgMApIvVTQAAAAAAAAAA8AAiIgsCCgAASgAAACAAAAAAAACLwwAAABAAAAAAAIABAAAAABAAAAACAAAFAAIAAAAAAAUAAgAAAAAAAOAAAAACAAAAAAAAAgAAAQAAEAAAAAAAACAAAAAAAAAAABAAAAAAAAAQAAAAAAAAAAAAABAAAAAAwAAAWAIAAFjCAAA4AQAAANAAAHADAAAAkAAAuAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC8wgAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC5NUFJFU1MxALAAAAAQAAAAKgAAAAIAAAAAAAAAAAAAAAAAAOAAAOAuTVBSRVNTMpUOAAAAwAAAABAAAAAsAAAAAAAAAAAAAAAAAADgAADgLnJzcmMAAABwAwAAANAAAAAEAAAAPAAAAAAAAAAAAAAAAAAAQAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdjIuMTcLAOApAAAAAQAgFf9LwNUagdOS+vXucGtQtg9DS6IQmf+s8pSAof/lzpNbvs5vGDaqkwL0lyayt6KDCqSJQ4o1tatkkGwANofdA4t1w8Ib1+wlEQkEKJCbSipLHHBKr6/Y6mEy+GC/8kjnyRwAZHJdcZTrXuvURTMyEd7xL18vaaxPaKpIVxEN6R1ewTtehzTryXuW5aYS9U2CkNUeS5HPgAZi3C2Dw+FhvjaiZrlQ1oVO3mVxsRfsYRkDLQJHWOoCQDSFK0iJc+hkrvg9EKsx/Rh204M2EBtV4vIh2EB8j1HCY/e0lUmRXtqzblX1lAX+FLwRWycOh1iPPU/ST+jE" & _
            "4av+V/Bfw4egyu5QXFd/C0BzI0KuqclmBNs+gKC15g5R8Q4KN0a6VBjXCWzdY68PGquCwoDBdX1hKMk0t5rJOEcUsj4a3PfiXUrStDAev4XnYPX0cEIUm1x12xEZjyAt4S72+v5Hlgfu1CcYLPoXaKf2blru95fnkt5Q0aQPUohkA/Cih9g3rGU19LFzxem68pJtoJxTY72YWjGcOtbYSFHU/P02tTE8lK+BG+bMPfEppQr+CB122EJ496aVhNw/nVlQSuvpwlIamoIgF/KAmcVCstzT41+LCbwMqbLJJzi4IPuOkLmpiKRYHZfKn87JmUnuO5CSH2CKODE4t0RH6xY2KUnQlM9Iy2x+K0T0HVkqlFJAacrC2ebUelKXoL/OzMMsGkA3S1TWnDwCp3UqTpuvgOCmzJqbCHZ4IbqgrF7QBrCw94U9pOQBZIzbsHom0NpAhB+3SojF8YxewirrYDgQFLYXUwiRm+9qyilPcEFn1ptxME9WXBcxCkxqbvqSvt7Hpr+FCgrqNItPuTfZb0kWsVf3zxgkNxoJUt38BfR+v2GM9P7UuP1NRlg0MwGBhinv/atRz5sdVUK/iCj7SuwVDDPKRiTAqyURAE7ZLLtTPFvK7oj+Fp+vyBFjeDQVU7EuES37VB7C5vML5xxBDPQDxdyCX42LeUiqqk4qnmsI1/8ek6y166AtZlr+Ja94gjustQV/RpJh1nf/ZiJ+SwKrpktO+NgLvs/vAnqtnwBB/1rh/qrOdGTpAYTOq8t0gLw3gUZhtX4NAjk5d6TNK9baalO9o2dWBA8pxyeEarp7J78xk66o0j4FF0Z/93MEMrTBxX6D1UjInCpAAgAIOykfyZo+B9+RPFkbv9U9h81z7vYBISis/TtlcdPo7qU8O/F74iOaMOKzg0qBqj2k6V4RqJi9COy/3+rX+pgTnX/NUfnm0oBrOp/gdEgl2cr7YzC9aL6YEp0SchIEL8FF4Ld1lXBSPOSzihcwkrAQ3n/hqKAVfipWmYPrcBWqELh1" & _
            "8W4+zhf9FnLVQoPDpgLsC88CXh8ppr86W0gTlCtfiOldcvgItCG7YIygWmhALdYWVrytuVwk7KUn/H2550+q2P5GOJUPFJQa/M1Hr2NJ1VK2ybNmETnUE6mK762HprF9RkI9SuBoG4qwxTK/NanKYARLkKncCPORFBusAgkhuvkf5AvED/LIIGovVsrymjDmPDOUOUrL5UmQ2xP3fXh5rNGY5eCaCzTw3mNwbHyrrRZR4pLWWXE1BHUXzdVclaX8eVkYo3kdILj9Clhh4uBaK5XDXTeMroHOlJ0yeUNeQb7MOH68G0F5L6jtng+uYKO5gQIWpbbVjKTs9e/i8xL+QPgG9KwLvUGfHUmBcU9NKDddN4eJKQ7NGX3Ltv1oBZRSSWfwcPplgzNjDNtkmWsxx5niAddn8BY+iTku2pwZsmcY7V82whgLdj0gKZu/lrDYDKOOkb62/QJ5XiQYZxPdyO4tDeWWRsoEMht4QkJ8rAdzrxoRf8xyhit7/buTTP4sERpW1P0VNHstcmQ+1wFD7b1FC7WoFPXclfeSioefT2hWAO/Vouc+Q0hkY2gRkJSCRwLgOxdwQmBD8JaJ4mb3o/vsHyg/zvDyMyhLDHECO1MnBk8ltm3/AE+aNk/J0L7OCJOWTnTC8qOGEpDX0Vk1s6kqrdVai0pvF4GYiCUm5SBGTug8tryOqb9HmktJMvLWD2rOxDLeEU7WniBH2G/B2yE/gxmjbYUPI3cPAtV8GmG3KaRmErU8ScFbTqXlYOQfCLIQPKWvGbKOUSfm61WwyKzyHLWrCptIFOhud+YQKyBrZFDs0gA7H4YZuDwpT328DGNE5pBC8JgRG7+PNoUTOThbF/qeefqcb4uqpoMW2Egul8qfpCrywkTSqudrcvon4VuB7Lno1YP2Us08iAPGUxTi2+/dnWtK06V72GfTyLim3ANLUc0MquuRaSQsAYmZB9sMX7Yq5exJuy1IZIlgNjF99jpYHGqGDIEOZMllZnIMZQ0fDWSCSNwki/TyCgls"
    $sData &= "VZu9oQarvrJ4CdrIUjoQNTMPhyAQd5RXyBOdbsnWGQYPQ9HQ/8WsNo7tmMV4Xk59whuiEKAzYoMjV/BpJ3rz0FWRxAZeU9fSGDCqoLqgMtbYH5WijE5OxcHBk20QpYkw3nniDJ0LB1ZDWUCkW/x50pkJCHflX3AaNCOL1x/dO8cDfvbrZOAs10Kggh+h8/hNvKCRcRMgPpZRQi8i+g//h2igsJ4QkR1PK5EciUrmWLhd7m240wiQdUkdpKydUW0IJvs5j3uuPul/ITq4pgNcg67Y2ILm2QrsgQC4STmZ9YjsV7D2RkFPds9kcsAa2bqyeRy5dQO00Nq7Z7fwWpG65Hg2acd4XKmXvQVhhayEbVaa+F82RoV7eLDMaLdpWctvgCgh5pp3fCrkGx9KFh8m3xat011VzIihSthdH1YMcGhbrkypaX15qMRbUUKG4a1ZvM9R374fJsl/zNGu/DTDiBLUFh0J1sqLTzJ7BPlNaYwwNzL9Z9MC05E0nIFkASIw3OTPphGPj89erNxCAg5xKHc+C2s9VRrG5TbjiZRh0mXhrIITdorKKl+3HmUky62oq5RUO7IqNWMEYfIfhZMIPrfK0oaB5MbSzQsUMMyy6D4uGZIinG8QQqkHxNXYsl2Xqs3jok5ikYomJIul0g41PYCm5n4znrkoHArlk4DDuwJHMsiWbAcwLT2dAnMUiFc4erQYxyGys785ox5ICE6XcVD37eDst2ZbrtxkWaN/lHZUwmQ50nx1SEor/l0sw/mEg7dnnbbNsop+xRjyriNDinKBtiqI5Z+UNp2T1T+1pATYWpYZdlG9Bh2eYt/KGtQazSAmcLcJ1upYHEE/fvflQFVKeqIwONpLGyorFVRMunw60QRBjRcH7+N/+1FKoG67l4ExFhpXT7zQSiymSL3TVr5j/JuCuRN5uB2BaJckm9rvlH2cHYxwd0QoEYa8rgsfOKIkLIaImaMv3lgP0ECjfl7qk676lOe9Gp2gYzDHdiweazDU97egGCU5hiVBnUuk" & _
            "3pPhFUW48xKuUD+KUW+4DYjqJEX31IUijM6kuN8jiMPGk1kQzHWgI3iWVU9Wc9OAON8+ZuC3pP7J1iJAm9hSAmpgPjbujpZw21Sm2nujNeYDe0ILNK3ily1Y7cU4IZe05L/w8NRpXoX7FulX4p1ODFBcNclzGBONPUGT2ybNM2iBG6BuOvG2QIHAZ8a8k2aUoxxw+3xFP658+HEVuBLZgaLKXAJ9YRWT/SKdwUmagrh5VGTxZuzQLSWajcq9UXuiYVpxUz9M1fU5mC++gZVf08iKzpR2P9LbCYpxTY2N0hpVe1apJS/9wNOSTA5uCzuMMyAMzhbHyyjkY3ThKcsW+Q7R2J0q37QN+WfV4/GTLhOgpLAzkDjHwr06DrkASqz5JyySia4HnrEYb+a63YCTJ2vnHr9l29sD/i3L2XH4ycVXumVsHF1T1fsg5zltrWR4NnHweNqt5t+M7XgYTquIc4qQdt63EPskkdzIW5n0/6Dsk0CCnJNVTCFfiNk3sd4o0TE5F1ImmaPVTtoCWRRKYDnJUVksQLKTgISTIOoZI7HS6Mt8eIEqY9EL6iZs63Gmb39sEulvc+HjECxMFysnIbqLvSuBFs2NciPAskvT6kVm7ZU+WdI8vBTWlZhWVHbmGddV9RaWvlIHrwmY13WJ5PlnFzqZU+0t0JpAtkr5oPqS1RDoUmRvQG1QlxD7PLmBWMPYsMyRlzWfRyWmf9bwRQjb7cyvi3n1P6groTeEQOb5MCdmQ/euG3QKt2ZW22RKLbhIg3+jh8XVK/96R94uhNDVba1EFPbnAuvRkSb57/8kWIegmytP+2eDH7/zRcNjvxt71L6L70hQt5qxw9x0i7B1rRTgNETksNi5jTnLjXvAn0YIy9+Oh3uXIdtmY8w+Ifmku1b5nGWidmhP7hRfTODWNUhSPC5UyfD9KesHgtuWcbYVyCNyp7J69xwhjmIakkK2QaoEApG/J9+7uMclP+bCC4K+98ma3czbuLfTqgK4SmQMe+GmnZ5QNcipe6Vd" & _
            "+qitKlCTzKt9Womv2fZ0+EhSOma9XV/O1HyS4xRDcjT8yXEUyY0RR4tEwYXfAmevJdMfHzD1lgLp4wSTI5MkeZr5blgMIlDVnUSchB4Pfp98w2DQT8XN4tmFrGBPFFKGROPudxFsJvXLQtEAc66EJcpO4GuI7txO+q9BORWZnn7uikYozG1bVe0ergtb/lN2BVbEmqOX51gmKSa8zjSTf/zK95U+OTdjw4G6GHlR5aScL9mqptjTEUHOjudRjAVOGAYhdmctDQMhPYeBYvwvcyEgG8wJDmcc/XielYoqhYaLOgYS8VSEUnr6F6dePTjlFRzuRe/NLFNMnSHGvqVog46LGu8BLS2n6lD70oVSZF4iaDKHDNFwKE9/eKAcGWzKfavGqMHBrArkVoSngm/ruFRzvixFbZL3LqNV4zwk1RM2DcPj/FO2vWItkRCdCt2JUG2DdA2djCMjlrSb+WDA7YoO6c31TqRMyOsAUomtNqCJLgCD26fXfB/1ZOkbs/UC6ahiQVws29AZhyhAFM7xNje3QgUIWOAiAgMTpXxsympXjPbQO0cv1x+XNdtHVXbsXJr56+alyF7quU4unpQWA8E1sw9CHTR7GUFezUsZz9LJM20NZEBqOzcUW0CgYrPUP12+2auqMzg9TjFY1xgjk4LaSj1QmoTSEy3+UcBeXa5aDY5095iuYSpIrFWB3QE1Kb6BtJm5RvKV+CDMBhX156cgOLmK4X7MnTfKw0eLWGOVBxBNJYUngL1GtqEc7sUQSL9Ifmj/HtTru0XdTZYNp3BEx7cnC9xlFs61ICgWxUa4ATqJnES8SyFYz6VfLXEWthIdm0It6rMjz8iXZuB2j9odsIMKMBGczm5fgU23mhCsTtLcA4NhUJGtZHp2ST5gAURfMAWRzLlaTTMWSv7D44rN/WimKS67MZQL9Sn/OF1BmhUZLcPmAr7rBF/rsqRI6qFhqxW5mAdWcRlQnQT4ug1XrKuzxbj/bZtS5KBhyOVQ2v0JJ2vB0c35wEweft6x"
    $sData &= "IoiCVbFKKfuL/fhJCdavUNjEjrZTw1csjGqpmZpooI7CRRHG5FtjvyoZPGOSOTaVUBG6AJtumdArrjEHG75pQhydFOKkIgdMQFpEeCyrqP9eFMcXLmuLDsUzcReszulMWofMx7oGUmvJ1raFBIs3tV6sSyUnB6G9A2Kn7QbTQYySAWzyg8T64Nt9FWcucwZMogdEiNMMHv6Ymfj9TlDrgiDb99WNJU/a/XStZNI52CU5FpRqIc18r0fs9rcnB/OWy0e/KCLit6notvu6j1GEitlSBiHrMatqUWbyscgLLInks1I5EoWEl6UUsWtKzFRP6daWM+yTwjWbZEc+MK8tD3vwvsP3zIqxUm6m1xr9EdAnIUyNe6MMe/1/tTUgc6+qOQrNMU3Rn2eKCs2DrzJAWWhoshdcaS04FJyLb2gcfsx0hyfDVB2gCovqqIW5dd7nw3CeCA+0BUOQCdCsHOpKSyZ3KM7Z0EDy2MpdAZ24NYs5a4N3hBK2+iu6pzYgYQsaqeTgcqsBsZDbSAYYli3Zcn6lZtLifFf3Mr8OZVFwqMLCvMM1EU2CAWXRtjQRjl0woeE32jsfZEQWvWFYh+TsQWBulwDVeqr10N1f+2AP0vcgcE+bJCjE1NtIdSXx5eUbPyFItuiKj+RcvWLKo9t4AQFh0Yx661dyZ13aaznFS1xkB2oeaQwF4Y/FJDzu65ghvv0VgNPcxiZmkpnglJ0sNNuwsGWd/ULKhbe6OKUnQNR0CxqOXx1DFCcTRsin9ndXxt5DdetT5HwtNEVnyvbjcoOE2W5EU5t//AB9yXFtjGkHhEteam2mZF6JjFDqlnvcvCx3d1L0BiCv6hJHPBueA9fjRFvvWn2euU+5BEwu6j4wFDWvppIPcNvJPdjjkLeuXYn0HY78F3H2NQHMO5OmcHGroh2Qkf9SWmaZ1Qruqznysd+4Kg1t0Nue3OFSpsQlzOSzDCAdYf3JSmzFtwsZEs+L2fCjBRCjYfep+4yOLdqX8SBzmWMHLyt4QWfkcaOY" & _
            "7i8MgpIEcv7rqlPA4l5DG8v14aPE6G+MbctL1xbgVQoGOBvZWKG0KSFMFu6ScvNjeL9Hb1fJnSdJUNUbqY3vHPsVX2azEuWigsJTEzL2SnjlrkcmgR3RWv0QQiGCD5fjo9yJLcqU/NMtnn/kabSlPrmjmgVH8Rhgmkaa6gCM1trP6+zsehU1LArb2H6rb04XhOO0du3xFSb32KM2pestLIiT5i8Wekxv+6PmQT6OIFdi88RFBSYh4DPgM7SDJciEuABhkJ1tjB2hv36jZkbSVm7KeThPIcv3OeoULow7q+1qSR0v2GS1VbWIokl3x6x2xJIVKjXV2Fj6CO3VXP5tNuxbvrQ7PP9WST35LnXUlXx0ahQB2+zjci73gJkyOFhsFE3wPJomxRcwW2VA/blBMqAAsuf17ZXBrKBMBNG3gIVRlSTCPA3N3r8uJE+aFlvdYxFjhGqk0bkJ4zSqJrCd+sRxZWopdN5sjoeBAvIop021pasvOmwp07M0pYklrfLRg8ts10qX4FxGKgDMdppk2FdlibUHdQwToY7IPfViQ/CD48hIxhivolISsYNWI53Y0Vtd9TTnxWa2fdtUJikJ8H6Oaa5i+vkO614ICcpMU2ercCwFUTZzc5wCcfcv8bKptM/jflB6zS1g7iiFoX27Tnz01dSyhr4aqp6sdJ1wEb3AinNEzKYoBvxy80yXCD77e9J72/n2coEXUbLZVoJKVlMNB+rxOANzUCuK2M0efrFroILCITebdEGUZm7oViNvSqWyn96+Hs9TnzUbAy/kutLUqtkIUG3IEK75PMCxmYgnPMuTUQqdnLNS4zYOdGb+krWtPIGV4KoGIttbPk0ZZ7X8hET8lvdjSkKPrf+CLFw+hl0QGboIqBu8ReQYFTf2tLbYPtLqvAITe9nRZhijjVNL3cyPAccN93DNfPE4W3Whn5qYbddPSJhRdsHrdNzjqPnE76MtTXxaHGcPNnN1c8XlL6DxKGhPEOZjq5d0Bni0ZVAih8zFie0awRoaJ+0G" & _
            "7C0mLbG2iBKsd9Fsvn6z60TeZBDbgKEzfJR1938OXZvS5m+l2rOaLbQYVci8offDjVIS0EEWeUX9CFbNBoqKYkALSM0jGepwayKQDBmQ0iV3VijVNcvZa/2G1MpAbhyr/KbK6JLJZmUULRk8GwfYh53Xj1m+7Q5RvPQXEY7QshErUYPW69non3krtjohk4CnhajPSjVlcKYATVlLP1ft9AzxH+4nsep2zKwuXzmzRmq1Vdu3q2RZKAxT/k7vS66WLjmGBnq0+vvAKNC0hPvPus7SHUv9sfD+mWY5IUC3eYKIWFg0/iQNo0EUg6ISfyafZayYH56ZL2WvkOoUFFdmGYnSjuakCvEquvZWp927eh2F5Mir+qofEOpNmze07pAH5Ix/sIzYjLgbTl9VipdfCSJpK3B4b1wwux6mnIXpYHI7qmvmD7ZsuvFQeecD95L1INynJkbFJN6afu9WlfDxP23KGxEJf52eg9T3g0vUz3iRbLNN/MN3fNtwDhoP7IZ58UPBmrkYkcihaBpkNcwulnXVvPa9yYy8NgXQXcf8TD8bJUwSg6dFfdNZmfDssiiVXA5rnApB6awaTLYyyI5YrCH/i/ru6mE0T1VA69/VSclYLf7U1FKoZkpb0T3GNVEqNt0m6iG+mctKDeL0hjXtF9OgrLHH8asc8fb81dz46hfiSncQU3aT58Ih36n2KG4426gZ+w1WMluRNU2AoO4UwwDw7Avn71qmEDh+gvr5Wj+g6ix1ijtsd8uTwrt+fQ+8AZ+285HNfvZQwZcioG6LH5x9HkKqPcmYSHgm8ypaEY9w2POlh5yP2wevEpgJVhDpuNLIVVjkziS2ATbjZzer/aJCkGDdvGcx+Ft86SWeJeITxo06lHX2oAPFMSKp88y8/mVsUCWPODFIZst9N1Vxpw4k+E+RC+RJVHDveWvIT5HEPK5D4qmVM408On/tooDdjGJbbVACKYFHnONz4omnc5+S6uToRQTY6p3TnlI6hvDqhl+3g9Iqgo+6XmD3yXx8"
    $sData &= "5JtBLMxxY0/qIh3v0/qcbUu2qAJaZ4vfc4tAp9nFq6VBvrZzm5OXw9pKywpgZeo2CpER6fF1D/tyVUJr5nl19OkURSnIuBiAfGJfJ7amMjq2sSLOkHEU5xjAzHyXr+aDWUTvnGt9RxMsVQsTzKhwEZkNuVovfq55FSBTkKCK2jCXDSnmMxJ4zKfHq4Q3z8zqNyldjbPgfBYzlaq/zpxsTLCd2huEZZSH+bLhD5TfKlL4k5hlLUmRnp/IUYaOVfTF12/ajWgE2nKICsyR5O+SPx451518U/kzSsevlh8Aj9xwa+PJjwZ8Ca3rECk30Xm8cIij8RDegArwuRcn4ZXhP6/3JtpaC9kjrE7H8C8a+8HFDdwf+0WbQu0RTMiKL7xroJf17giqsMCgiLjk2I12x93jGKg5HG6HO0HhCIn4IWI24zIfSk3VSDkHhv61NJU5Anxv+8YApS65UY22HQrUNvbSvglOxIPlFSCyubbGzkvGB9ArKKBYxhFep3qAo/Q5nAvtol158F53rBh8rwsAimiMWKMSU8EVLvEvCSW60C+2kgkU4qWIRo4uITTeLjffgixPxdPNEkcAbfoUyKAAzOIIOK3LbIIVVLp8hed0zez7GDJDf7lN7T4pY3jwoo/DIDl28bsAFnK2oLJR8myO2WRtAPvKDsz7uia1oVBOeUqLmIo3GdrLy39pzO5Vzwz+911nSFe0jP6oVkPcpEggIg7VATzW5lekq1+h/lv8bCYHn9rkV9aHnLqDRu1A6tzY3/PL/vnW/w8R1eImyQvIKGdoSY9X0vOt+9bYmy4nrT8iiYlhRV9sz4Aqa1N1SGJv10kXF5hhVgd2pH4g5da9qzEQ3irpy8uIGPshjTbPJDFSqnx81MQsEW8gokCaZmJ9oJtujleTqUyRO5rRiTdJs6W6Vbqe73pd6t6b3WIMVEDTGRWFo94ndzZL2U/o1Ihonc/KMIdXSbq5zoHpp1BENEo0T/G6+SQ4WhWsAVlCcX0iA2DomMgIoVTOKmiB/24i" & _
            "MPKAx0gNGe0b9haXcHHqRyq1lvRZGw91fF0PhAMUjLPqCcrkgPmY2G/qUwAkDOZHyqPUbcr6yvVXz1TxN8WDMhSZ09lnEaQ00ez0NfLhxNBWsv0rw//f2tiKWvDFML2y9nU0VGhYis5S4jBEfjXnj+MiPGfs5TzXp/W90MvAu7P3YfJ1qO3zXwoCRxp25YR10e7knUL775Q0E5MxN4k1Vu8rvD5A9eggX5YfefwA5Q44SYkgBASSQXLXt8gYoeCA8OK51c20j4Asy6+1ZSnntDZd272Wn+QTeVBDHRskA9ae6l+JlRwhrJM4I5KE2iu5jrQ6vRZaO6nYB2M0EXew8bRWfUvVihYrjIiWVR/RS8GgVQvffy+oM7XmNiq3dGM33G5UB93Mkd2x92+LUNbDalOlWafqI4ImtmIaNoqaM92yKmumzoyYQPz8wTnHuSUA0Oa1nHYTx9dHQogoRt/d/074zTIdoW4X6ZDAtY3DFeeew13xTw3keq0PRl0hS8ZIt83VRDZolZOYH/usijiEnqG+6M3XEsPpkaj+2K0coPs79BFVQOL1dlf16Nj3XrYFP3MstiAP6iFNGMRlySexee+GxM1Qa+cPcTFj2LmqO817qjKAyJR91pCxuc8SaoQG3dqYrRioVgKAHmTjGhLpTDu91b8b7fcCGiTxz5Dyk5mmVSoOsPCrPCE/QSTLxkMm1yNvfyJAXHlRL7dUaBxU23IRPvxKf2ZbR0Lho2GYTKdBmpsmMVmpUK7bmX8AtSDgGXGm4lHMvgdc3CKyBVozu1m9dQa01kFTR9Gl/fAx7ymH454WnmFPNYyuv2MaYDRLRUFbdIZw2cPvceUlbxuiBQ8mHlFe7s6icf8Ob9HSh6wxCFBZbzps5fCxTmrV4szNstr0eou24kWrpqcKFAZicMg0/bvfjqCgSrvUugc2xGYmfpuCDqlNWY9hBS6cvw8+0S3/TZGK/V1UmNxRoKgYj+ig2+8gufjcXazK7Jnh0gpD2pxLzchKDB3qaB/7Fblo" & _
            "5WsiAk/jhVZooezywP74czXJ8zc+md5wCJM/HahRW/Uem59n326GAyKDz3P8+swxrlfy8U7DM/hgYcq5pkPOe7vEVPDYUnPDbnUKGZdpKG32Q+s1uj0YSb5jYzM0O4FyZKSkAnwg0HVgUBwoZEqKa+TFYJOA9V7pKVWGN5jMcxcooz4DSi+1tgkY07WgyoJQEnqzbnh6+lPxllfagEzdyRUIghdSI2jHia/UCFrEF8KtsbcAzwI7Qo4MuegkYGZ+DGhjFCSqQpj3zwZ6lweA7BEUQMnw/SQl73oznO7foLoJfMrU76YnzFkJq2sl61qLE+GxYsNs8LheXLlkGc3dwSOY3gt8mFf9UEAvtHJ0FRFnETrXrpXaGj3JeMR3+lwzCM5SAMWTForoQeaAje55/fs1qqE5NVpur2CHxkg/qc+JYhRRprKyigOaJ/jA6Qv5ywoNVuy9fWVB2gdvkX5f5VI66D/M6S21x9vgCNtD7/GqGMcTXzfCUpKKuP2J5XXgV5bOrNg0Mod+q523puaVwX25vfDsKf/kV7fMNB1ShlzhxUGb8+SgD5XeBwhjohTwl5bGjC1+3CseGNSZQuw/WSTlbYDon4N8hZhJiBb5ISr61ueXPFek8b8AFPv6LsalRZgC6GnkVz2OYfp5qaO+p0e96BLw3OxNTezpQCmd2wFGEq/ABnDQoX5f1TyUuBfkaPv0hmQZm+EyINwTRNW5dLJnZAAnYnpYD7uqQRTDYpI4nQcQR6l1Hk6cYaMAX2pM+kLdt9fYyqqW297nd3Wd/AhWQ1u8DCeo1iQn/Ub1BnrVAXPjGpD+istceAWuCLyLlc9dbmM63XEZJuhIeXj/qcTPlMkOdGnURWl+XaPbYihZoXHfSbURuqpIcobGgQ6ID1sbpZU0mqidKDLJQhB0nT4El4W9wKDgy8AQUGeqUjA61dy3d2X91P5YCUk8a6f29emDTnOLJjzRuWuAbM0SrdbwgTUl+MDpVe4Q4iTMlDIFShgk0/D8PmdwTzWiPL3w"
    $sData &= "ZHY3REBrXaQur7kdOD9scHWtN2Ew/Wh5DQ6qViGYNOlIy/Oa/odrB02BDzra8GsQom9epNMDH2/eYq3EIL8AXuFOf5yTlFyqNnuIv5ulAV1BefhycjAuV6WOUMnv28WFgXe+T6bNkgXiWZXoEjfyt7+2k6wrzcYnpqm7G0wjA7IKhYvX0c7D+nnc2KLsKdMezfT/kOfHJbEUaTdOFNlMFxll8fMrWKNHwBHm2rU3Swbt1iqM1KEvPfT4u0veGXCcEJwdulQhmcWWHPvq+biKzaw77Na4rCWkw7iobqA281fIZSsiKdk4c1B0scv33XGRwBx+/7f8eOpLYpnIGQJuKaZJknZnp7H65IpwfxUNNTh2GuW0mSEayO+wB39qfoZ71tuscGXnN+E+gQknKRER20t9v6MLMwhOI2J8wmcISim7xIXczhDn/CbmA1g5FT66ufLAswQ372Pkw+ubGuZCzxcteQ00aC/NcONgQpE05KblBlIbqWYBcjzeL/Ll4KjCrdsy+n3HIYUbpMSIbib0mS1EG39mqsM4FGfVM4QDwkEm//LTl/nz2MRCzzuKcM8Jv6icDDPrW1N6Ee0EMUFefPXCMo956GcVZeS4OQzPBRtddFzbpVHw1yN5Rwx08W64DOf//wSAiBUwiPI3igQV9jOlPnqQYVqjX/41Kv+VTEHwnZILopuoKaYTKqYHli+k24D9YCVLPTp1k/754GVK+6KmDlMgr0KQvTlgOnAdOy5f95i0pGh73HM0FYNBqXmgO/eGQBOKD7jkVlE9wFsEI2PlNByfDwEiaR45JNtJ9rsGmmLEmq8a/iSRL6v5MWzuFD5hbF1kSUXfD3bU8wgJ6vIfi5IuMoHv7s/JT5+hfeCpEGagNKm/4KUDxjiyGdcuLXAWiPWnpqu7Wy4O/u2m8QG6wXKBcBeJS4ev5ECtSC8ad6zl0q1S/mlj8gZfjcFqG0x/8/Dcy+iKDmmyT7VZ2JAnEHEnArl7DdgfL+ykHbcLhANckhNRY2LhYZx8YVDf" & _
            "Q1Tj3R9bLgbccGDQG555FmPK9oYAvzcrIqi1E10zx5mA+hS/jhbbzwKuYHc807w7Q29US3GpDfZiUffWY5+RR1o9THCBAdKvZnBhCDel3PLKtUitxSIP+p+wq+98ZTFq3e0lgqP4B/AQSncoGageTF3VSgp9dckG6b3NVOz2jLP/a8P5FBVoOZ0U7+/knxn8QyhLiKMi+GprPluQfUNelI6Dam2Uvzp4u4bVBoR7o79wmStEdy70zBhe4+iX7QtzK7DyrCKBd0UC7q+cePivkXrB9f5C+HTruO97z6aVga6QuYLzw4CRKT2iZHDzYta6owd8Kv4xA+v43qyfTZs+bfRtgC6uFNQnBE4Xn5bDnPUglBlPoIotQxqn17hE9IOmYGj2A+p49eYiUSJvbpKUH2oD8MKhGLnQOp8NCirFLAGBRzvLmdL0WFloFvrgtO9GeLJUHtqBGFq4jtOvj7JHBNXC1eD5ZTnZ5mpHzNhGRBLLAo0U4dOU5Q1EV3JgLj4rEQsPT9RsZ5faaK9YGafdM/A/iJPOGNuupSdhWrRUpEHGWCXwcCHBsSptxvUmibz8Lw6iQ1W7r7+0oOnzqOjbPR3WwIC8Vc0YZQq+u9MGDPUc51AuJvE/D1XX3mbGvJNAG9VSRs5sPGX8UBMvo89MP1+vgfMiEx/wruSZ9xbB+oZEAHM7L3uECTuKeKQsWb0N4ODqCCCpuik81WK0a7vKywlBTdhiNJDPAmuzfr1grMzj1fomSRCnYkNXYmgxiI+HagIKcWxcbqTWShwOlCYUv5BWjimv/lCHtPRyFh5THt+FvbG+FG8mQPxeU4vCfxPdjaZZ/l3E18dG+zuo1GUENxN3yXDfUOXlKYzZyK0OmT2XIHyy3nX4/yybAueET1obQxbsYt44RUV5PU0h2RehNU3ZDej1yR5RK+z8wKrh2Ur7OWSoqKilQ695z2F3qlK6oF1OdoU1FBHoi//JoYaK+F0fKJ0FECLVQ+EH8Q8DrySOVaUhpo9LLDaag9tewlYa" & _
            "9cAONZ9mGIgDnAqt6kFC5mMvB2gFsrJ+Qgoe7EINUj6L6ZQvHXunVFbnyVbdwV29ll2r8cyp8JpHdPNll3pDtc3mu+BhMTtJLB7pxacHhvzDq72LD5SN2rSQgZaH0g1GBM/e31jNlaQtEMVChZIqo5rXvsUoMCnB0Z8F0ovVqQfD0i6zOlCKfkmRbVblDH+83YDj6MtRbu19XPrGd+IXPvm+IV9iiBfRHAHyeRj+nKx2Ax0Mjg4Ve5G8s+Kv9USiOeqgyxIQPR5j58rNuoDOYdVDpJLIR5f2I042y9lW87TpYR10zxOFLdTppy/3baFMke+hn+8wl6Iy3rodhrTEyfqjnRc0GlGDSWExJOV/+BIJNf/q9emApvKJ8YLzFPkc1de6LEDIX4TZyol85d6ZDF8BAX4Of5e38EM1fQoP4sss571vyqTFUWLnhcd3a3di/oT74/YCWa6k9PCAxYdqsGDM+up87kxmNawjNOqM0r3j7cMdUPYauLthz2B8ZdyPlak2B0jCEJqFrp0Y9jsN8G42+KlP4C2fNtbZVeKzDn0s6q+6myWLXSW7oxKcJD7/oOrf+rS3yideGoS3EU5LTw+SGEoYthiBPkMho0HHRwnzvAa5OK1H7YSA8/ACZ78w2WroAUeAAAAAZjkE+Q+FTQwAAEiLTPkI/xVcUQAAiUUAAAAApIvVTQAAAAB4wAAAAQAAABQAAAAUAAAAKMAAAI3AAAAtwgAAXE8AAExPAABkTwAAeFMAAHBVAAAETwAA4E4AALxOAACQUAAAbE8AAKhPAABUUgAAXFIAADBPAAAAUgAAHFEAAFRPAABkUgAAvFEAAAhQAABBdXRvSXRPYmplY3RfWDY0LmRsbADdwAAA5cAAAO/AAAD7wAAAFMEAAC/BAABBwQAAVMEAAGzBAACAwQAAlMEAAKrBAAC5wQAAycEAANTBAADkwQAA88EAAADCAAALwgAAHMIAAEFkZEVudW0AQWRkTWV0aG9kAEFkZFByb3BlcnR5AEF1dG9J"
    $sData &= "dE9iamVjdENyZWF0ZU9iamVjdABBdXRvSXRPYmplY3RDcmVhdGVPYmplY3RFeABDbG9uZUF1dG9JdE9iamVjdABDcmVhdGVBdXRvSXRPYmplY3QAQ3JlYXRlQXV0b0l0T2JqZWN0Q2xhc3MAQ3JlYXRlRGxsQ2FsbE9iamVjdABDcmVhdGVXcmFwcGVyT2JqZWN0AENyZWF0ZVdyYXBwZXJPYmplY3RFeABJVW5rbm93bkFkZFJlZgBJVW5rbm93blJlbGVhc2UASW5pdGlhbGl6ZQBNZW1vcnlDYWxsRW50cnkAUmVnaXN0ZXJPYmplY3QAUmVtb3ZlTWVtYmVyAFJldHVyblRoaXMAVW5SZWdpc3Rlck9iamVjdABXcmFwcGVyQWRkTWV0aG9kAAAAAQACAAMABAAFAAYABwAIAAkACgALAAwADQAOAA8AEAARABIAEwAAAAC8wgAAAAAAAAAAAABAwwAAvMIAANTCAAAAAAAAAAAAAEnDAADUwgAA5MIAAAAAAAAAAAAAYsMAAOTCAAD0wgAAAAAAAAAAAABvwwAA9MIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHMMAAAAAAAAvwwAAAAAAAAAAAAAAAAAAU8MAAAAAAAAAAAAAAAAAAAUBAAAAAACAAAAAAAAAAAB7wwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABHZXRNb2R1bGVIYW5kbGVBAAAAR2V0UHJvY0FkZHJlc3MAS0VSTkVMMzIAb2xlMzIuZGxsAAAAQ29Jbml0aWFsaXplAE9MRUFVVDMyLmRsbABTSExXQVBJLmRsbAAAAFN0clRvSW50NjRFeFcAV1ZTUVJBUEiNBd4KAABIizBIA/BIK8BIi/5mrcHgDEiLyFCtK8hIA/GLyFdEi8H/yYpEOQaIBDF19UFRVSvArIvIwekEUSQPUKyLyAIMJFBIx8UA/f//SNPlWVhIweAgSAPIWEiL3EiNpGyQ8f//UFFIK8lR" & _
            "UUiLzFFmixfB4gxSV0yNSQhJjUkIVlpIg+wg6MgAAABIi+NdQVleWoHqABAAACvJO8pzSovZrP/BPP91DYoGJP08FXXrrP/B6xc8jXUNigYkxzwFddqs/8HrBiT+POh1z1Fbg8EErQvAeAY7wnPB6wYDw3i7A8Irw4lG/OuySI09Bv///7DpqrjiCgAAq0iNBeIJAACLUAyLeAgL/3Q9SIswSAPwSCvySIveSItIFEgry3Qoi1AQSAPySAP+K8Ar0gvQrMHiB9DocvYL0AvSdAtIA9pIKQtIO/dy4UiNBZQJAADpigkAAEyJTCQgSIlUJBBTVVZXQVRBVUFWQVdIg+woM/ZMi/JIi8GNXgFMjWkMi0kIRIvTi9NMi/5B0+KLSAREit7T4kiLjCSgAAAARCvTK9OL7kSL44lUJAyLEEmJMYlUJAhIiTGLSAQDyroAAwAARIlUJBDT4omcJIAAAACJXCRwgcI2BwAAiVwkBHQNi8pJi/24AAQAAPNmq02Lzk0D8Iv+QYPI/4vOTTvOD4TKCAAAQQ+2AcHnCAPLC/hMA8uD+QV85Eg5tCSYAAAAD4aKCAAAi8VBi/e6CAAAAMHgBEEj8kG6AAAAAUhj2EhjxkgD2EU7wnMaTTvOD4Q/CAAAQQ+2AcHnCEHB4AgL+EmDwQFBD7dMXQBBi8DB6AsPr8E7+A+DtQEAAESLwLgACAAAQboBAAAAK8HB+AVmA8GLykEPttNmQYlEXQCLXCQIi0QkDEkjxyrLSNPqi8tI0+BIA9BIjQRSSMHgCYP9B0mNtAVsDgAAD4y7AAAAQYvESYvPSCvISIuEJJAAAAAPthwIA9tJY8JEi9tBgeMAAQAASWPTSAPQQYH4AAAAAXMaTTvOD4SIBwAAQQ+2AcHnCEHB4AgL+EmDwQEPt4xWAAIAAEGLwMHoCw+vwTv4cyhEi8C4AAgAAEUD0ivBwfgFZgPBZomEVgACAAAzwEQ72A+FmwAAAOsjRCvAK/gPt8FmwegFR41UEgFmK8gzwEQ7" & _
            "2GaJjFYAAgAAdHZBgfoAAQAAfXbpWv///0GB+AAAAAFJY9JzGk07zg+E9AYAAEEPtgHB5whBweAIC/hJg8EBD7cMVkGLwMHoCw+vwTv4cxlEi8C4AAgAACvBwfgFZgPBRQPSZokEVusYRCvAK/gPt8FmwegFR41UEgFmK8hmiQxWQYH6AAEAAHyPSIuEJJAAAABFitpGiBQ4SYPHAYP9BH0JM8CL6OljBgAAg/0KfQiD7QPpVgYAAIPtBulOBgAARCvAK/gPt8FmwegFSGPVZivIRTvCZkGJTF0AcyFNO84PhDwGAABBD7YBwecIQbsBAAAAC/hBweAITQPL6wZBuwEAAABBD7eMVYABAABBi8DB6AsPr8E7+HNRRIvAuAAIAAArwcH4BWYDwYP9B2ZBiYRVgAEAAItEJHBJjZVkBgAAiUQkBIuEJIAAAABEiaQkgAAAAIlEJHC4AwAAAI1Y/Q9Mw41rCOlOAgAARCvAK/gPt8FmwegFZivIRTvCZkGJjFWAAQAAcxlNO84PhJgFAABBD7YBwecIQcHgCAv4TQPLRQ+3lFWYAQAAQYvIwekLQQ+vyjv5D4PIAAAAuAAIAABEi8FBK8LB+AVmQQPCQboAAAABQTvKZkGJhFWYAQAAcxlNO84PhD4FAABBD7YBwecIQcHgCAv4TQPLQQ+3jF3gAQAAQYvAwegLD6/BO/hzVkSLwLgACAAAK8HB+AVmA8FmQYmEXeABAAAzwEw7+A+E9AQAAEiLlCSQAAAAuAsAAACD/QeNSP4PTMFJi8+L6EGLxEgryESKHApGiBw6SYPHAemnBAAARCvAK/gPt8FmwegFZivIZkGJjF3gAQAA6R4BAABBD7fCRCvBK/lmwegFZkQr0GZFiZRVmAEAAEG6AAAAAUU7wnMZTTvOD4R3BAAAQQ+2AcHnCEHB4AgL+E0Dy0EPt4xVsAEAAEGLwMHoCw+vwTv4cyVEi8C4AAgAACvBwfgFZgPBZkGJhFWwAQAAi4QkgAAAAOmaAAAARCvA"
    $sData &= "K/gPt8FmwegFZivIRTvCZkGJjFWwAQAAcxlNO84PhAYEAABBD7YBwecIQcHgCAv4TQPLQQ+3jFXIAQAAQYvAwegLD6/BO/hzH0SLwLgACAAAK8HB+AVmA8FmQYmEVcgBAACLRCRw6yREK8Ar+A+3wWbB6AVmK8iLRCQEZkGJjFXIAQAAi0wkcIlMJASLjCSAAAAAiUwkcESJpCSAAAAARIvgg/0HuAsAAABJjZVoCgAAjWj9D0zFM9tFO8KJBCRzGU07zg+EXwMAAEEPtgHB5whBweAIC/hNA8sPtwpBi8DB6AsPr8E7+HMlRIvAuAAIAABEi9MrwcH4BWYDwWaJAovGweADSGPITI1cSgTraEQrwCv4D7fBZsHoBWYryEU7wmaJCnMZTTvOD4T6AgAAQQ+2AcHnCEHB4AgL+E0Dyw+3SgJBi8DB6AsPr8E7+HMuRIvAuAAIAABEi9UrwcH4BWYDwWaJQgKLxsHgA0hjyEyNnEoEAQAAuwMAAADrIkQrwCv4D7fBZsHoBUyNmgQCAABBuhAAAABmK8iL3WaJSgKL870BAAAAQYH4AAAAAUhj1XMaTTvOD4RmAgAAQQ+2AcHnCEHB4AgL+EmDwQFBD7cMU0GLwMHoCw+vwTv4cxlEi8C4AAgAACvBwfgFZgPBA+1mQYkEU+sYRCvAK/gPt8FmwegFjWwtAWYryGZBiQxTg+4BdZKNRgGLy9PgRCvQiwQkQQPqg/gED42gAQAAg8AHg/0EjV4GiQQkjUYDjVYBD0zFweAGSJhNjZxFYAMAAEGB+AAAAAFMY9JzGk07zg+EvQEAAEEPtgHB5whBweAIC/hJg8EBQw+3DFNBi8DB6AsPr8E7+HMZRIvAuAAIAAArwcH4BWYDwQPSZkOJBFPrGEQrwCv4D7fBZsHoBY1UEgFmK8hmQ4kMU4PrAXWSg+pAg/oERIviD4z7AAAAQYPkAUSL0kHR+kGDzAJBg+oBg/oOfRlBi8pIY8JB0+RBi8xIK8hJjZxNXgUAAOtQQYPq" & _
            "BEGB+AAAAAFzGk07zg+EDwEAAEEPtgHB5whBweAIC/hJg8EBQdHoRQPkQTv4cgdBK/hBg8wBQYPqAXXFSY2dRAYAAEHB5ARBugQAAAC+AQAAAIvWQYH4AAAAAUxj2nMaTTvOD4S5AAAAQQ+2AcHnCEHB4AgL+EmDwQFCD7cMW0GLwMHoCw+vwTv4cxlEi8C4AAgAACvBwfgFZgPBA9JmQokEW+sbRCvAK/gPt8FmwegFjVQSAWYryEQL5mZCiQxbA/ZBg+oBdYxBg8QBdGBBi8SDxQJJY8xJO8d3RkiLlCSQAAAASYvHSCvBSAPCRIoYSIPAAUaIHDpJg8cBg+0BdApMO7wkmAAAAHLiiywkTDu8JJgAAABzFkSLVCQQ6ZT3//+4AQAAAOs4QYvD6zNBgfgAAAABcwlNO8505kmDwQFIi4QkiAAAAEwrTCR4TIkISIuEJKAAAABMiTgzwOsCi8NIg8QoQV9BXkFdQVxfXl1bw+lCjv//iUH///////9DAAAAABAAAACwAAAAAACAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" & _
            "AAAAAAAAAAAAAAAAAAABABAAAAAYAACAAAAAAAAAAAAAAAAAAAABAAEAAAAwAACAAAAAAAAAAAAAAAAAAAABAAkEAABIAAAAWNAAABgDAAAAAAAAAAAAABgDNAAAAFYAUwBfAFYARQBSAFMASQBPAE4AXwBJAE4ARgBPAAAAAAC9BO/+AAABAAIAAQACAAgAAgABAAIACAAAAAAAAAAAAAQAAAACAAAAAAAAAAAAAAAAAAAAdgIAAAEAUwB0AHIAaQBuAGcARgBpAGwAZQBJAG4AZgBvAAAAUgIAAAEAMAA0ADAAOQAwADQAQgAwAAAAMAAIAAEARgBpAGwAZQBWAGUAcgBzAGkAbwBuAAAAAAAxAC4AMgAuADgALgAyAAAANAAIAAEAUAByAG8AZAB1AGMAdABWAGUAcgBzAGkAbwBuAAAAMQAuADIALgA4AC4AMgAAAHoAKQABAEYAaQBsAGUARABlAHMAYwByAGkAcAB0AGkAbwBuAAAAAABQAHIAbwB2AGkAZABlAHMAIABvAGIAagBlAGMAdAAgAGYAdQBuAGMAdABpAG8AbgBhAGwAaQB0AHkAIABmAG8AcgAgAEEAdQB0AG8ASQB0AAAAAAA6AA0AAQBQAHIAbwBkAHUAYwB0AE4AYQBtAGUAAAAAAEEAdQB0AG8ASQB0AE8AYgBqAGUAYwB0AAAAAABYABoAAQBMAGUAZwBhAGwAQwBvAHAAeQByAGkAZwBoAHQAAAAoAEMAKQAgAFQAaABlACAAQQB1AHQAbwBJAHQATwBiAGoAZQBjAHQALQBUAGUAYQBtAAAASgARAAEATwByAGkAZwBpAG4AYQBsAEYAaQBsAGUAbgBhAG0AZQAAAEEAdQB0AG8ASQB0AE8AYgBqAGUAYwB0AC4AZABsAGwAAAAAAHoAIwABAFQAaABlACAAQQB1AHQAbwBJAHQATwBiAGoAZQBjAHQALQBUAGUAYQBtAAAAAABtAG8AbgBvAGMAZQByAGUAcwAsACAAdAByAGEA"
    $sData &= "bgBjAGUAeAB4ACwAIABLAGkAcAAsACAAUAByAG8AZwBBAG4AZAB5AAAAAABEAAAAAQBWAGEAcgBGAGkAbABlAEkAbgBmAG8AAAAAACQABAAAAFQAcgBhAG4AcwBsAGEAdABpAG8AbgAAAAAACQSwBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
    Return __Au3Obj_Mem_Base64Decode($sData)
EndFunc   ;==>__Au3Obj_Mem_BinDll_X64
#EndRegion Embedded DLL
#Region DllStructCreate Wrapper
Func __Au3Obj_ObjStructMethod(ByRef $oSelf, $vParam1 = 0, $vParam2 = 0)
	Local $sMethod = $oSelf.__name__
	Local $tStructure = DllStructCreate($oSelf.__tag__, $oSelf.__pointer__)
	Local $vOut
	Switch @NumParams
		Case 1
			$vOut = DllStructGetData($tStructure, $sMethod)
		Case 2
			If $oSelf.__propcall__ Then
				$vOut = DllStructSetData($tStructure, $sMethod, $vParam1)
			Else
				$vOut = DllStructGetData($tStructure, $sMethod, $vParam1)
			EndIf
		Case 3
			$vOut = DllStructSetData($tStructure, $sMethod, $vParam2, $vParam1)
	EndSwitch
	If IsPtr($vOut) Then Return Number($vOut)
	Return $vOut
EndFunc   ;==>__Au3Obj_ObjStructMethod
Func __Au3Obj_ObjStructDestructor(ByRef $oSelf)
	If $oSelf.__new__ Then __Au3Obj_GlobalFree($oSelf.__pointer__)
EndFunc   ;==>__Au3Obj_ObjStructDestructor
Func __Au3Obj_ObjStructPointer(ByRef $oSelf, $vParam = Default)
	If $oSelf.__propcall__ Then Return SetError(1, 0, 0)
	If @NumParams = 1 Or IsKeyword($vParam) Then Return $oSelf.__pointer__
	Return Number(DllStructGetPtr(DllStructCreate($oSelf.__tag__, $oSelf.__pointer__), $vParam))
EndFunc   ;==>__Au3Obj_ObjStructPointer
#EndRegion DllStructCreate Wrapper
#Region Public UDFs
Global Enum $ELTYPE_NOTHING, $ELTYPE_METHOD, $ELTYPE_PROPERTY
Global Enum $ELSCOPE_PUBLIC, $ELSCOPE_READONLY, $ELSCOPE_PRIVATE
Func _AutoItObject_AddDestructor(ByRef $oObject, $sAutoItFunc)
	Return _AutoItObject_AddMethod($oObject, "~", $sAutoItFunc, True)
EndFunc   ;==>_AutoItObject_AddDestructor
Func _AutoItObject_AddEnum(ByRef $oObject, $sNextFunc, $sResetFunc, $sSkipFunc = '')
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "AddEnum", "idispatch", $oObject, "wstr", $sNextFunc, "wstr", $sResetFunc, "wstr", $sSkipFunc)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddEnum
Func _AutoItObject_AddMethod(ByRef $oObject, $sName, $sAutoItFunc, $fPrivate = False)
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	Local $iFlags = 0
	If $fPrivate Then $iFlags = $ELSCOPE_PRIVATE
	DllCall($ghAutoItObjectDLL, "none", "AddMethod", "idispatch", $oObject, "wstr", $sName, "wstr", $sAutoItFunc, 'dword', $iFlags)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddMethod
Func _AutoItObject_AddProperty(ByRef $oObject, $sName, $iFlags = $ELSCOPE_PUBLIC, $vData = "")
	Local Static $tStruct = DllStructCreate($__Au3Obj_tagVARIANT)
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	Local $pData = 0
	If @NumParams = 4 Then
		$pData = DllStructGetPtr($tStruct)
		_AutoItObject_VariantInit($pData)
		$oObject.__bridge__(Number($pData)) = $vData
	EndIf
	DllCall($ghAutoItObjectDLL, "none", "AddProperty", "idispatch", $oObject, "wstr", $sName, 'dword', $iFlags, 'ptr', $pData)
	Local $error = @error
	If $pData Then _AutoItObject_VariantClear($pData)
	If $error Then Return SetError(1, $error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddProperty
Func _AutoItObject_Class()
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "CreateAutoItObjectClass")
	If @error Then Return SetError(1, @error, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_Class
Func _AutoItObject_CLSIDFromString($sString)
	Local $tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Local $aResult = DllCall($gh_AU3Obj_ole32dll, 'long', 'CLSIDFromString', 'wstr', $sString, 'ptr', DllStructGetPtr($tCLSID))
	If @error Then Return SetError(1, @error, 0)
	If $aResult[0] <> 0 Then Return SetError(2, $aResult[0], 0)
	Return $tCLSID
EndFunc   ;==>_AutoItObject_CLSIDFromString
Func _AutoItObject_CoCreateInstance($rclsid, $pUnkOuter, $dwClsContext, $riid, ByRef $ppv)
	$ppv = 0
	Local $aResult = DllCall($gh_AU3Obj_ole32dll, 'long', 'CoCreateInstance', 'ptr', $rclsid, 'ptr', $pUnkOuter, 'dword', $dwClsContext, 'ptr', $riid, 'ptr*', 0)
	If @error Then Return SetError(1, @error, 0)
	$ppv = $aResult[5]
	Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_AutoItObject_CoCreateInstance
Func _AutoItObject_Create($oParent = 0)
	Local $aResult
	Switch IsObj($oParent)
		Case True
			$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CloneAutoItObject", 'idispatch', $oParent)
		Case Else
			$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateAutoItObject")
	EndSwitch
	If @error Then Return SetError(1, @error, 0)
	Return $aResult[0]
EndFunc   ;==>_AutoItObject_Create
Func _AutoItObject_DllOpen($sDll, $sTag = "", $iFlag = 0)
	Local $sTypeTag = "wstr"
	If $sTag = Default Or Not $sTag Then $sTypeTag = "ptr"
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "CreateDllCallObject", "wstr", $sDll, $sTypeTag, __Au3Obj_GetMethods($sTag), "dword", $iFlag)
	If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_DllOpen
Func _AutoItObject_DllStructCreate($sTag, $vParam = 0)
	Local $fNew = False
	Local $tSubStructure = DllStructCreate($sTag)
	If @error Then Return SetError(@error, 0, 0)
	Local $iSize = DllStructGetSize($tSubStructure)
	Local $pPointer = $vParam
	Select
		Case @NumParams = 1
			$pPointer = __Au3Obj_GlobalAlloc($iSize + 128, 64) ; GPTR
			If @error Then Return SetError(3, 0, 0)
			$fNew = True
		Case IsDllStruct($vParam)
			$pPointer = __Au3Obj_GlobalAlloc($iSize, 64) ; GPTR
			If @error Then Return SetError(3, 0, 0)
			$fNew = True
			DllStructSetData(DllStructCreate("byte[" & $iSize & "]", $pPointer), 1, DllStructGetData(DllStructCreate("byte[" & $iSize & "]", DllStructGetPtr($vParam)), 1))
		Case @NumParams = 2 And $vParam = 0
			Return SetError(3, 0, 0)
	EndSelect
	Local $sAlignment
	Local $sNamesString = __Au3Obj_ObjStructGetElements($sTag, $sAlignment)
	Local $aElements = StringSplit($sNamesString, ";", 2)
	Local $oObj = _AutoItObject_Class()
	For $i = 0 To UBound($aElements) - 1
		$oObj.AddMethod($aElements[$i], "__Au3Obj_ObjStructMethod")
	Next
	$oObj.AddProperty("__tag__", $ELSCOPE_READONLY, $sTag)
	$oObj.AddProperty("__size__", $ELSCOPE_READONLY, $iSize)
	$oObj.AddProperty("__alignment__", $ELSCOPE_READONLY, $sAlignment)
	$oObj.AddProperty("__count__", $ELSCOPE_READONLY, UBound($aElements))
	$oObj.AddProperty("__elements__", $ELSCOPE_READONLY, $sNamesString)
	$oObj.AddProperty("__new__", $ELSCOPE_PRIVATE, $fNew)
	$oObj.AddProperty("__pointer__", $ELSCOPE_READONLY, Number($pPointer))
	$oObj.AddMethod("__default__", "__Au3Obj_ObjStructPointer")
	$oObj.AddDestructor("__Au3Obj_ObjStructDestructor")
	Return $oObj.Object
EndFunc   ;==>_AutoItObject_DllStructCreate
Func _AutoItObject_IDispatchToPtr($oIDispatch)
	Local $aCall = DllCall($ghAutoItObjectDLL, "ptr", "ReturnThis", "idispatch", $oIDispatch)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_IDispatchToPtr
Func _AutoItObject_IUnknownAddRef(Const $vUnknown)
	Local $sType = "ptr"
	If IsObj($vUnknown) Then $sType = "idispatch"
	Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "IUnknownAddRef", $sType, $vUnknown)
	If @error Then Return SetError(1, @error, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_IUnknownAddRef
Func _AutoItObject_IUnknownRelease(Const $vUnknown)
	Local $sType = "ptr"
	If IsObj($vUnknown) Then $sType = "idispatch"
	Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "IUnknownRelease", $sType, $vUnknown)
	If @error Then Return SetError(1, @error, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_IUnknownRelease
Func _AutoItObject_ObjCreate($sID, $sRefId = Default, $tagInterface = Default)
	Local $sTypeRef = "wstr"
	If $sRefId = Default Or Not $sRefId Then $sTypeRef = "ptr"
	Local $sTypeTag = "wstr"
	If $tagInterface = Default Or Not $tagInterface Then $sTypeTag = "ptr"
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "AutoItObjectCreateObject", "wstr", $sID, $sTypeRef, $sRefId, $sTypeTag, __Au3Obj_GetMethods($tagInterface))
	If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
	If $sTypeRef = "ptr" And $sTypeTag = "ptr" Then _AutoItObject_IUnknownRelease($aCall[0])
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_ObjCreate
Func _AutoItObject_ObjCreateEx($sModule, $sID, $sRefId = Default, $tagInterface = Default, $fWrapp = False, $iTimeOut = Default)
	Local $sTypeRef = "wstr"
	If $sRefId = Default Or Not $sRefId Then $sTypeRef = "ptr"
	Local $sTypeTag = "wstr"
	If $tagInterface = Default Or Not $tagInterface Then
		$sTypeTag = "ptr"
	Else
		$fWrapp = True
	EndIf
	If $iTimeOut = Default Then $iTimeOut = 0
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "AutoItObjectCreateObjectEx", "wstr", $sModule, "wstr", $sID, $sTypeRef, $sRefId, $sTypeTag, __Au3Obj_GetMethods($tagInterface), "bool", $fWrapp, "dword", $iTimeOut)
	If @error Or Not IsObj($aCall[0]) Then Return SetError(1, 0, 0)
	If Not $fWrapp Then _AutoItObject_IUnknownRelease($aCall[0])
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_ObjCreateEx
Func _AutoItObject_ObjectFromDtag($sFunctionPrefix, $dtagInterface, $fNoUnknown = False)
	Local $sMethods = __Au3Obj_GetMethods($dtagInterface)
	$sMethods = StringReplace(StringReplace(StringReplace(StringReplace($sMethods, "object", "idispatch"), "variant*", "ptr"), "hresult", "long"), "bstr", "ptr")
	Local $aMethods = StringSplit($sMethods, @LF, 3)
	Local $iUbound = UBound($aMethods)
	Local $sMethod, $aSplit, $sNamePart, $aTagPart, $sTagPart, $sRet, $sParams
	Local $tInterface = DllStructCreate("ptr[" & $iUbound + 1 & "]", __Au3Obj_CoTaskMemAlloc($__Au3Obj_PTR_SIZE * ($iUbound + 1)))
	If @error Then Return SetError(1, 0, 0)
	For $i = 0 To $iUbound - 1
		$aSplit = StringSplit($aMethods[$i], "|", 2)
		If UBound($aSplit) <> 2 Then ReDim $aSplit[2]
		$sNamePart = $aSplit[0]
		$sTagPart = $aSplit[1]
		$sMethod = $sFunctionPrefix & $sNamePart
		$aTagPart = StringSplit($sTagPart, ";", 2)
		$sRet = $aTagPart[0]
		$sParams = StringReplace($sTagPart, $sRet, "", 1)
		$sParams = "ptr" & $sParams
		DllStructSetData($tInterface, 1, DllCallbackGetPtr(DllCallbackRegister($sMethod, $sRet, $sParams)), $i + 2) ; Freeing is left to AutoIt.
	Next
	DllStructSetData($tInterface, 1, DllStructGetPtr($tInterface) + $__Au3Obj_PTR_SIZE) ; Interface method pointers are actually pointer size away
	Return _AutoItObject_WrapperCreate(DllStructGetPtr($tInterface), $dtagInterface, $fNoUnknown, True) ; and first pointer is object pointer that's wrapped
EndFunc   ;==>_AutoItObject_ObjectFromDtag
Func _AutoItObject_PtrToIDispatch($pIDispatch)
	Local $aCall = DllCall($ghAutoItObjectDLL, "idispatch", "ReturnThis", "ptr", $pIDispatch)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_PtrToIDispatch
Func _AutoItObject_RegisterObject($vObject, $sID)
	Local $sTypeObj = "ptr"
	If IsObj($vObject) Then $sTypeObj = "idispatch"
	Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "RegisterObject", $sTypeObj, $vObject, "wstr", $sID)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_RegisterObject
Func _AutoItObject_RemoveMember(ByRef $oObject, $sMember)
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	If $sMember = '__default__' Then Return SetError(3, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "RemoveMember", "idispatch", $oObject, "wstr", $sMember)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_RemoveMember
Func _AutoItObject_Shutdown($fFinal = False)
	If $giAutoItObjectDLLRef <= 0 Then Return 0
	$giAutoItObjectDLLRef -= 1
	If $fFinal Then $giAutoItObjectDLLRef = 0
	If $giAutoItObjectDLLRef = 0 Then DllCall($ghAutoItObjectDLL, "ptr", "Initialize", "ptr", 0, "ptr", 0)
	Return $giAutoItObjectDLLRef
EndFunc   ;==>_AutoItObject_Shutdown
Func _AutoItObject_Startup($fLoadDLL = False, $sDll = "AutoitObject.dll")
	Local Static $__Au3Obj_FunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_FunctionProxy", "int", "wstr;idispatch"))
	Local Static $__Au3Obj_EnumFunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_EnumFunctionProxy", "int", "dword;wstr;idispatch;ptr;ptr"))
	If $ghAutoItObjectDLL = -1 Then
		If $fLoadDLL Then
			If $__Au3Obj_X64 And @NumParams = 1 Then $sDll = "AutoItObject_X64.dll"
			$ghAutoItObjectDLL = DllOpen($sDll)
		Else
			$ghAutoItObjectDLL = __Au3Obj_Mem_DllOpen()
		EndIf
		If $ghAutoItObjectDLL = -1 Then Return SetError(1, 0, False)
	EndIf
	If $giAutoItObjectDLLRef <= 0 Then
		$giAutoItObjectDLLRef = 0
		DllCall($ghAutoItObjectDLL, "ptr", "Initialize", "ptr", $__Au3Obj_FunctionProxy, "ptr", $__Au3Obj_EnumFunctionProxy)
		If @error Then
			DllClose($ghAutoItObjectDLL)
			$ghAutoItObjectDLL = -1
			Return SetError(2, 0, False)
		EndIf
	EndIf
	$giAutoItObjectDLLRef += 1
	Return True
EndFunc   ;==>_AutoItObject_Startup
Func _AutoItObject_UnregisterObject($iHandle)
	Local $aCall = DllCall($ghAutoItObjectDLL, "dword", "UnRegisterObject", "dword", $iHandle)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_AutoItObject_UnregisterObject
Func _AutoItObject_VariantClear($pvarg)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantClear", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantClear
Func _AutoItObject_VariantCopy($pvargDest, $pvargSrc)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantCopy", "ptr", $pvargDest, 'ptr', $pvargSrc)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantCopy
Func _AutoItObject_VariantFree($pvarg)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantClear", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	If $aCall[0] = 0 Then __Au3Obj_CoTaskMemFree($pvarg)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantFree
Func _AutoItObject_VariantInit($pvarg)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantInit", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantInit
Func _AutoItObject_VariantRead($pVariant)
	Local $var = DllStructCreate($__Au3Obj_tagVARIANT, $pVariant), $data
	Local $VT = DllStructGetData($var, "vt"), $type
	Switch $VT
		Case $__Au3Obj_VT_I1, $__Au3Obj_VT_UI1
			$type = "byte"
		Case $__Au3Obj_VT_I2
			$type = "short"
		Case $__Au3Obj_VT_I4
			$type = "int"
		Case $__Au3Obj_VT_I8
			$type = "int64"
		Case $__Au3Obj_VT_R4
			$type = "float"
		Case $__Au3Obj_VT_R8
			$type = "double"
		Case $__Au3Obj_VT_UI2
			$type = 'word'
		Case $__Au3Obj_VT_UI4
			$type = 'uint'
		Case $__Au3Obj_VT_UI8
			$type = 'uint64'
		Case $__Au3Obj_VT_BSTR
			Return __Au3Obj_SysReadString(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_BOOL
			$type = 'short'
		Case BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_UI1)
			Local $pSafeArray = DllStructGetData($var, "data")
			Local $bound, $pData, $lbound
			If 0 = __Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $bound) Then
				__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
				$bound += 1 - $lbound
				If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
					Local $tData = DllStructCreate("byte[" & $bound & "]", $pData)
					$data = DllStructGetData($tData, 1)
					__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				EndIf
			EndIf
			Return $data
		Case BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_VARIANT)
			Return __Au3Obj_ReadSafeArrayVariant(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_DISPATCH
			Return _AutoItObject_PtrToIDispatch(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_PTR
			Return DllStructGetData($var, "data")
		Case $__Au3Obj_VT_ERROR
			Return Default
		Case Else
			Return SetError(1, 0, '')
	EndSwitch
	$data = DllStructCreate($type, DllStructGetPtr($var, "data"))
	Switch $VT
		Case $__Au3Obj_VT_BOOL
			Return DllStructGetData($data, 1) <> 0
	EndSwitch
	Return DllStructGetData($data, 1)
EndFunc   ;==>_AutoItObject_VariantRead
Func _AutoItObject_VariantSet($pVar, $vVal, $iSpecialType = 0)
	If Not $pVar Then
		$pVar = __Au3Obj_CoTaskMemAlloc($__Au3Obj_VARIANT_SIZE)
		_AutoItObject_VariantInit($pVar)
	Else
		_AutoItObject_VariantClear($pVar)
	EndIf
	Local $tVar = DllStructCreate($__Au3Obj_tagVARIANT, $pVar)
	Local $iType = $__Au3Obj_VT_EMPTY, $vDataType = ''
	Switch VarGetType($vVal)
		Case "Int32"
			$iType = $__Au3Obj_VT_I4
			$vDataType = 'int'
		Case "Int64"
			$iType = $__Au3Obj_VT_I8
			$vDataType = 'int64'
		Case "String", 'Text'
			$iType = $__Au3Obj_VT_BSTR
			$vDataType = 'ptr'
			$vVal = __Au3Obj_SysAllocString($vVal)
		Case "Double"
			$vDataType = 'double'
			$iType = $__Au3Obj_VT_R8
		Case "Float"
			$vDataType = 'float'
			$iType = $__Au3Obj_VT_R4
		Case "Bool"
			$vDataType = 'short'
			$iType = $__Au3Obj_VT_BOOL
			If $vVal Then
				$vVal = 0xffff
			Else
				$vVal = 0
			EndIf
		Case 'Ptr'
			If $__Au3Obj_X64 Then
				$iType = $__Au3Obj_VT_UI8
			Else
				$iType = $__Au3Obj_VT_UI4
			EndIf
			$vDataType = 'ptr'
		Case 'Object'
			_AutoItObject_IUnknownAddRef($vVal)
			$vDataType = 'ptr'
			$iType = $__Au3Obj_VT_DISPATCH
		Case "Binary"
			Local $tSafeArrayBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tSafeArrayBound, 1, BinaryLen($vVal))
			Local $pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_UI1, 1, DllStructGetPtr($tSafeArrayBound))
			Local $pData
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				Local $tData = DllStructCreate("byte[" & BinaryLen($vVal) & "]", $pData)
				DllStructSetData($tData, 1, $vVal)
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				$vVal = $pSafeArray
				$vDataType = 'ptr'
				$iType = BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_UI1)
			EndIf
		Case "Array"
			$vDataType = 'ptr'
			$vVal = __Au3Obj_CreateSafeArrayVariant($vVal)
			$iType = BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_VARIANT)
		Case Else ;"Keyword" ; all keywords and unknown Vartypes will be handled as "default"
			$iType = $__Au3Obj_VT_ERROR
			$vDataType = 'int'
	EndSwitch
	If $vDataType Then
		DllStructSetData(DllStructCreate($vDataType, DllStructGetPtr($tVar, 'data')), 1, $vVal)
		If @NumParams = 3 Then $iType = $iSpecialType
		DllStructSetData($tVar, 'vt', $iType)
	EndIf
	Return $pVar
EndFunc   ;==>_AutoItObject_VariantSet
Func _AutoItObject_WrapperAddMethod(ByRef $oWrapper, $sReturnType, $sName, $sParamTypes, $ivtableIndex)
	If Not IsObj($oWrapper) Then Return SetError(2, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "WrapperAddMethod", 'idispatch', $oWrapper, 'wstr', $sName, "wstr", StringRegExpReplace($sReturnType & ';' & $sParamTypes, "\s|(;+\Z)", ''), 'dword', $ivtableIndex)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_WrapperAddMethod
Func _AutoItObject_WrapperCreate($pUnknown, $tagInterface, $fNoUnknown = False, $fCallFree = False)
	If Not $pUnknown Then Return SetError(1, 0, 0)
	Local $sMethods = __Au3Obj_GetMethods($tagInterface)
	Local $aResult
	If $sMethods Then
		$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateWrapperObjectEx", 'ptr', $pUnknown, 'wstr', $sMethods, "bool", $fNoUnknown, "bool", $fCallFree)
	Else
		$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateWrapperObject", 'ptr', $pUnknown, "bool", $fNoUnknown)
	EndIf
	If @error Then Return SetError(2, @error, 0)
	Return $aResult[0]
EndFunc   ;==>_AutoItObject_WrapperCreate
#EndRegion Public UDFs
