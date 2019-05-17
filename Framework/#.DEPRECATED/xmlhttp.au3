#include-once
	#cs
		$oHTTP = ObjCreate("Microsoft.XMLHTTP")
		$oHTTP.Open("POST", $url, False)
		$oHTTP.Send()
		$sData = $oHTTP.ResponseText
	#ce
	#cs useless?
	;$agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0"
	;HttpSetUserAgent($agent)
	;$oHTTP.setRequestHeader('User-Agent', 	$agent)
	;$oHTTP.setRequestHeader('Content-Type',	'text/html; charset=utf-8')
	#ce

Func _XML_Startup()
	$obj = ObjCreate("Microsoft.XMLHTTP")
	If IsObj($obj) Then Return $obj
	Return SetError(-1,0,"no Object")
EndFunc

Func _XML_Close(ByRef $obj)
	If IsObj($obj) Then Return $obj = ""
	Return SetError(-1, 0, "no Object" )
EndFunc

Func _XML_ResponseText($obj)
	If IsObj($obj) Then
		$r = $obj.ResponseText
		Return SetError( 0, 0, $r )
	Else
		Return SetError( -1, 0, "no Object" )
	EndIf
EndFunc

Func _XML_Action($obj, $a, $post, $flag= False )
	If IsObj($obj) Then
		$obj.Open($a, $post, $flag)
		$obj.Send()
		Return SetError( 0, 0, $obj )
	Else
		Return SetError( -1, 0, "no Object" ) ; no obj
	EndIf
EndFunc


Func _XML_Post($obj, $post, $flag= False )
	If IsObj($obj) Then
		$obj.Open("POST", $post, $flag)
		$obj.Send()
		Return SetError( 0, 0, $obj )
	Else
		Return SetError( -1, 0, "no Object" ) ; no obj
	EndIf
EndFunc

Func _XML_Get($obj, $get, $flag = False )
	If IsObj($obj) Then
		$obj.Open("GET", $get, $flag)
		$obj.Send()
		Return SetError( 0, 0, $obj )
	Else
		Return SetError( -1, 0, "no Object" ) ; no obj
	EndIf
EndFunc
