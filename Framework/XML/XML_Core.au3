#include-once

; CONSTANTS
Global Const $__GOOGLE_TRANSLATE_TEXT_DELIM 	= "[##%R!E)P]L[A(C!E%##]"
Global Const $__GOOGLE_TRANSLATE_URL 			= "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl="&$__GOOGLE_TRANSLATE_TEXT_DELIM&"&dt=t&q="

; XMLHTTP
Func _XML_Startup($oSelf)
	Local $obj = ObjCreate("MSXML2.ServerXMLHTTP.6.0");ObjCreate("Microsoft.XMLHTTP") <- deprecated/rly old
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
	$r = $obj.ResponseText
	$oSelf.setResponse($r)
	$r = $oSelf.getResponse()
	Return SetError( 0, 0, $r )
EndFunc

Func _XML_Action($oSelf, $a, $post, $flag= False )
	Local $obj = $oSelf._XML_OBJECT
	$obj.Open($a, $post, $flag)
	$oSelf._send()
	;$obj.Send()
	Return SetError( 0, 0, $obj )
EndFunc

Func _XML_Post($oSelf, $post, $flag= False )
	Local $obj = $oSelf._XML_OBJECT
	$oSelf.Open("POST", $post, $flag)
	$oSelf._send();
	;$obj.Send()
	Return SetError( 0, 0, 0 )
EndFunc

Func _XML_Get($oSelf, $get, $flag = False )
	Local $obj = $oSelf._XML_OBJECT
	$obj.Open("GET", $get)
	$oSelf._send();
	;$obj.Send()
	Return SetError( 0, 0, 0 )
EndFunc

Func _XML_SendWithAgent($oSelf, $Agent="")
	Local $obj = $oSelf._XML_OBJECT
	$oSelf.agent();
	$obj.Send();
EndFunc

Func _XML_Agent($oSelf, $agent="mozilla/5.0");$agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0")
	Local $obj = $oSelf._XML_OBJECT
	;HttpSetUserAgent($agent)
	#cs

	Host: translate.googleapis.com
	User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0
	Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
	Accept-Language: de,en-US;q=0.7,en;q=0.3
	Accept-Encoding: gzip, deflate, br
	Connection: keep-alive
	Upgrade-Insecure-Requests: 1

	#ce
	If ($agent="mozilla/5.0") Then
		$obj.setRequestHeader('Host', 						'translate.googleapis.com' )
		$obj.setRequestHeader('User-Agent', 				'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0')
		$obj.setRequestHeader('Accept',						'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8')
	EndIf

EndFunc

Func _XML_SetURL($oSelf, $url)
	$oSelf.url = $url
EndFunc

Func _XML_GetURL($oSelf, $url)
	Return $oSelf.url
EndFunc

Func _XML_SetResponseText($oSelf, $r )
	$oSelf._response = $r
EndFunc

Func _XML_GetResponseText($oSelf)
	Return $oSelf._response
EndFunc

Func _XML_GoogleTranslateText($oSelf, $text, $m="GET", $lang="en")
	Local $t
	With $oSelf
		.encodeURI($text)
		.tUrl = StringReplace($__GOOGLE_TRANSLATE_URL,$__GOOGLE_TRANSLATE_TEXT_DELIM,$lang) & .getEncode()
		.action( $m, .tUrl )
		.response()
		Local $r
		$r = .getResponse()
		.setTranslateResult($r)
		.cleanTranslateResult()
		$r = ._getCleanTranslationResult()
		.setTranslateResult($r)
	EndWith
EndFunc

Func _XML_SetEncodeURI($oSelf,$t)
	$oSelf._encode = $t
EndFunc

Func _XML_GetEncodeURI($oSelf)
	Return $oSelf._encode
EndFunc

Func _XML_GetGoogleTranslateResult($oSelf)
	Return $oSelf._translateResult
EndFunc

Func _XML_SetGoogleTranslateResult($oSelf, $r)
	$oSelf._translateResult = $r
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

; #### beyond here = not done/tested
Func _XML_GetCookie($oSelf, $url, $flag=False)
	$oSelf.post($url,$flag)
	Return $oSelf.getResponse() ; cookie it has to be this
EndFunc

Func _XML_GetSetCookie($oSelf, $url, $flag=False)
	Local $cookie=$oSelf.getCookie($url,$flag)
	$oSelf.setCookie($cookie)
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
















