#include-once

; CONSTANTS
Global Const $__GOOGLE_TRANSLATE_TEXT_DELIM 	= "[##%R!E)P]L[A(C!E%##]"
Global Const $__GOOGLE_TRANSLATE_URL 			= "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl="&$__GOOGLE_TRANSLATE_TEXT_DELIM&"&dt=t&q="
Global Const $__GOOGLE_TRANSLATE_REQHEADER		= 'Host:translate.googleapis.com|User-Agent:Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0|Accept:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'

; XMLHTTP METHODS

#Region --- Basic XML Commands
;start object
	Func _XML_Startup($oSelf)
		Local $obj = ObjCreate("MSXML2.ServerXMLHTTP.6.0");ObjCreate("Microsoft.XMLHTTP") <- deprecated/rly old
		$oSelf._XML_OBJECT = $obj
		$oSelf._setError("No Error")
		If IsObj($oSelf._XML_OBJECT) Then Return SetError(0, 0, "Startup: [ok]")
		Return SetError(-1,0,  $oSelf._setError("Startup: [Object creation error]"))
	EndFunc

;POST/GET // ACTION(GET/POST) together
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

;response text
	Func _XML_ResponseText($oSelf)
		$oSelf.setResponse($oSelf._XML_OBJECT.ResponseText)
		If @error Then Return SetError( @error, @extended, $oSelf._setError("ResponseText: error",@error,@extended) )
		Return SetError( 0, 0, "ResponseText: [ok]" )
	EndFunc

;response header
	Func _XML_ResponseHeader($oSelf,$field)
		$oSelf.setResponseHeader($oSelf._XML_OBJECT.getResponseHeader($field))
		If @error Then Return SetError( @error, @extended, $oSelf._setError("ResponseHeader: error",@error,@extended) )
		Return SetError( 0, 0, "ResponseHeader: [ok]" )
	EndFunc

;close object (i think it's not working properly yet -- investigate)
	Func _XML_Close($oSelf)
		If IsObj($oSelf._XML_OBJECT) Then Return $oSelf._XML_OBJECT = ""
		Return SetError(-1, 0, "no Object" )
	EndFunc
#EndRegion

#Region --- Method functions
;send with different agent
	Func _XML_SendWithAgent($oSelf, $Agent="")
		If ($Agent <> "") Then $oSelf.requestHeader($Agent)
		$oSelf._XML_OBJECT.Send();
	EndFunc

;get/set url
	Func _XML_SetURL($oSelf, $url)
		$oSelf.url = $url
	EndFunc
	Func _XML_GetURL($oSelf)
		Return $oSelf.url
	EndFunc

;get/set response text property
	Func _XML_SetResponseText($oSelf, $r )
		$oSelf._response = $r
	EndFunc
	Func _XML_GetResponseText($oSelf)
		Return $oSelf._response
	EndFunc

;get/set response header property
	Func _XML_SetResponseHeader($oSelf, $r)
		$oSelf._responseHeader = $r
	EndFunc
	Func _XML_GetResponseHeader($oSelf)
		Return $oSelf._responseHeader
	EndFunc

;get/set encodeURI property
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

;get/set error propertys
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
;translate text
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

;get/set translate result
	Func _XML_GetCleanTranslateResult($oSelf)
		Return $oSelf._cleanTranslateResult
	EndFunc
	Func _XML_SetCleanTranslateResult($oSelf, $t)
		$oSelf._cleanTranslateResult = $t
	EndFunc

;get/set last translate url
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

;get/set google translate result
	Func _XML_GetGoogleTranslateResult($oSelf)
		Return $oSelf._translateResult
	EndFunc
	Func _XML_SetGoogleTranslateResult($oSelf, $r)
		$oSelf._translateResult = $r
	EndFunc

;encode/decode URI
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

	; #### beyond here = not done/tested
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

	;get/set Random cookie -> first generate this cookie, send request and receive correct cookie
		Func _XML_SetGeneratedRandomCookie($oSelf, $c)
			$oSelf.__rCookie = $c
		EndFunc
		Func _XML_GetGeneratedRandomCookie($oSelf)
			Return $oSelf.__rCookie
		EndFunc

	;get/set Cookie
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
;$oHTTP.setTimeouts(5000, 5000, 15000, 15000)
$oHTTP.Send()
$oHTTP.WaitForResponse
$ContentDisposition = $oHTTP.GetResponseHeader("Content-Disposition")
$array = StringRegExp($ContentDisposition, 'filename="(.*)"',3)
ConsoleWrite($array[0] & @CRLF)

#ce
















