#include-once

; CONSTANTS
Global Const $__GOOGLE_TRANSLATE_TEXT_DELIM 	= "[##%R!E)P]L[A(C!E%##]"
Global Const $__GOOGLE_TRANSLATE_URL 			= "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl="&$__GOOGLE_TRANSLATE_TEXT_DELIM&"&dt=t&q="

; XMLHTTP
Func _XML_Startup($oSelf)
	Local $obj = ObjCreate("MSXML2.ServerXMLHTTP");ObjCreate("Microsoft.XMLHTTP") <- deprecated/rly old
	$oSelf._XML_OBJECT = $obj
	If IsObj($oSelf._XML_OBJECT) Then Return 1
	Return SetError(-1,0, "no Object")
EndFunc

Func _XML_Close($oSelf);, ByRef $obj)
	If IsObj($oSelf._XML_OBJECT) Then Return $oSelf._XML_OBJECT = ""
	Return SetError(-1, 0, "no Object" )
EndFunc

Func _XML_ResponseText($oSelf)
	Local $obj = $oSelf._XML_OBJECT, $r
	If IsObj($obj) Then
		$r = $obj.ResponseText
		$oSelf.setResponse($r)
		$r = $oSelf.getResponse()
		Return SetError( 0, 0, $r )
	Else
		Return SetError( -1, 0, "no Object" )
	EndIf
EndFunc

Func _XML_Action($oSelf, $a, $post, $flag= False )
	Local $obj = $oSelf._XML_OBJECT
	If IsObj($obj) Then
		$obj.Open($a, $post, $flag)
		$obj.Send()
		Return SetError( 0, 0, $obj )
	Else
		Return SetError( -1, 0, "no Object" ) ; no obj
	EndIf
EndFunc

Func _XML_Post($oSelf, $post, $flag= False )
	Local $obj = $oSelf._XML_OBJECT
	If IsObj($obj) Then
		$obj.Open("POST", $post, $flag)
		$obj.Send()
		Return SetError( 0, 0, 0 )
	Else
		Return SetError( -1, 0, "no Object" ) ; no obj
	EndIf
EndFunc

Func _XML_Get($oSelf, $get, $flag = False )
	Local $obj = $oSelf._XML_OBJECT
	If IsObj($obj) Then
		$obj.Open("GET", $get)
		$obj.Send()
		Return SetError( 0, 0, 0 )
	Else
		Return SetError( -1, 0, "no Object" ) ; no obj
	EndIf
EndFunc

Func _XML_Agent($oSelf, $agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0")
	Local $obj = $oSelf._XML_OBJECT
	;HttpSetUserAgent($agent)
	$obj.setRequestHeader('User-Agent', 	$agent)
	$obj.setRequestHeader('Content-Type',	'text/html; charset=utf-8')
EndFunc

Func _XML_SetURL($oSelf, $url)
	;Local $obj = $oSelf._XML_OBJECT
	$oSelf.url = $url
EndFunc

Func _XML_GetURL($oSelf, $url)
	;Local $obj = $oSelf._XML_OBJECT
	Return $oSelf.url
EndFunc

Func _XML_SetResponseText($oSelf, $r )
	;Local $obj = $oSelf._XML_OBJECT
	$oSelf._response = $r
EndFunc

Func _XML_GetResponseText($oSelf)
	;Local $obj = $oSelf._XML_OBJECT
	Return $oSelf._response
EndFunc


; #### test phase

Func _XML_GoogleTranslateText($oSelf, $text, $lang="en")
	Local $obj = $oSelf._XML_OBJECT, $t

	$oSelf.encodeURI($text)
	$t = StringReplace($__GOOGLE_TRANSLATE_URL,$__GOOGLE_TRANSLATE_TEXT_DELIM,$lang) & $oSelf.getEncode()
	$oSelf.tUrl = $t;
	MsgBox(0, "URL", $t);$oSelf._encode)
	$oSelf.post( $oSelf.tUrl )
	$oSelf.response()

	Local $r = $oSelf.getResponse()
	ConsoleWrite( "!$oSelf.getResponse:" & @CRLF & $r & @CRLF )

	$oSelf.setTranslateResult($r)
	ConsoleWrite( "!$oSelf.setTranslateResult:" & @CRLF & $oSelf.getTranslateResult() & @CRLF )

	$oSelf.cleanTranslateResult()

	$r = $oSelf._getCleanTranslationResult()
	ConsoleWrite( "!$oSelf._getCleanTranslationResult:" & @CRLF & $r & @CRLF )

	$oSelf.setTranslateResult($r)
EndFunc

Func _XML_SetEncodeURI($oSelf,$t)
	$oSelf._encode = $t
EndFunc

Func _XML_GetEncodeURI($oSelf)
	Return $oSelf._encode
EndFunc


Func _XML_GetGoogleTranslateResult($oSelf)
	;Local $obj = $oSelf._XML_OBJECT
	Return $oSelf._translateResult
EndFunc

Func _XML_SetGoogleTranslateResult($oSelf, $r)
	;Local $obj = $oSelf._XML_OBJECT
	$oSelf._translateResult = $r
EndFunc

Func __XML_CleanTranslateResult($oSelf)
	Local $obj = $oSelf._XML_OBJECT, $t
	Local $sData, $text = $oSelf.getTranslateResult()
	MsgBox(0, "", $text )
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

Func _XML_GetCleanTranslateResult($oSelf)
	Return $oSelf._cleanTranslateResult
EndFunc

Func _XML_SetCleanTranslateResult($oSelf, $t)
	$oSelf._cleanTranslateResult = $t
EndFunc

Func _XML_GetLastTranslateURL($oSelf)
	Local $obj = $oSelf._XML_OBJECT
	If ($obj.tUrl = "") Then Return SetError(-1, 0, "Use gTranslate first" )
	Return $obj.tUrl
EndFunc

Func _XML_EncodeURI($oSelf, $string) ; Encode by Prog@ndy
	;Local $obj = $oSelf._XML_OBJECT
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



; #### beyond here = not done

Func _XML_GetCookie($oSelf, $url, $flag=False)
	Local $obj = $oSelf._XML_OBJECT, $cookie
	$obj.post($url,$flag)
	Return $obj._response ; cookie has to be this
EndFunc

Func _XML_GetSetCookie($oSelf, $url, $flag=False)
	Local $obj = $oSelf._XML_OBJECT, $cookie=$obj.getCookie($url,$flag)
	$obj.setCookie($cookie)
	Return $cookie
EndFunc


Func _XML_SetCookie($oSelf, $val) ;manually set cookie
	Local $obj = $oSelf._XML_OBJECT
	$obj._cookie = $val
	$obj.SetRequestHeader('Cookie', 'key='&$val)
EndFunc

Func _XML_LoginWithCookie($oSelf, $url, $cookie)
	Local $obj = $oSelf._XML_OBJECT
	$obj.setCookie($cookie)

EndFunc



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
















