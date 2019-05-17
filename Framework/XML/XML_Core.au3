#include-once

; XMLHTTP

Func _XML_Startup($oSelf)
	Local $obj = ObjCreate("MSXML2.ServerXMLHTTP");ObjCreate("Microsoft.XMLHTTP")
	$oSelf._XML_OBJECT = $obj
	If IsObj($oSelf._XML_OBJECT) Then Return 1
	Return SetError(-1,0,"no Object")
EndFunc

Func _XML_Close($oSelf);, ByRef $obj)
	If IsObj($oSelf._XML_OBJECT) Then Return $oSelf._XML_OBJECT = ""
	Return SetError(-1, 0, "no Object" )
EndFunc

Func _XML_ResponseText($oSelf)
	Local $obj = $oSelf._XML_OBJECT, $r
	If IsObj($obj) Then
		$r = $obj.ResponseText
		$oSelf._response=$r
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
	HttpSetUserAgent($agent)
	$obj.setRequestHeader('User-Agent', 	$agent)
	$obj.setRequestHeader('Content-Type',	'text/html; charset=utf-8')
EndFunc

#cs
; New MSXML2.ServerXMLHTTP Test

Local $objHTTP
$objHTTP = objCreate( "MSXML2.ServerXMLHTTP" )

$objHTTP.open ( "GET", "http://google.de", false )

$objHTTP.setRequestHeader( "Content-type", "application/x-www-form-urlencoded" );
$objHTTP.SetRequestHeader( "Cookie", "test=Hey!" );

$objHTTP.send ( "test=Hey!" )

MsgBox(0, "Result", $objHTTP.responseText )
#ce