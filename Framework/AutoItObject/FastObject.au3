#include-once
#include "AutoItObject.au3"

; start autoit object
_AutoItObject_StartUp()

Func _ShortObjectCreater($name="",$desc="")
	Local $o = _AutoItObject_Create()
	_AutoItObject_AddMethod		($o, "create", "_create_object")
	_AutoItObject_AddMethod		($o, "delete", "_delete_object")
	_AutoItObject_AddMethod		($o, "method", "_add_method")
	_AutoItObject_AddMethod		($o, "prop", "_add_property")
	_AutoItObject_AddMethod		($o, "save", "_save_obj" )
	_AutoItObject_AddProperty	($o, "Name")
	_AutoItObject_AddProperty	($o, "Description")
	_AutoItObject_AddProperty	($o, "__obj")
	_AutoItObject_AddProperty	($o, "MethodList")
	_AutoItObject_AddProperty	($o, "MethodDescription")
	$o.Name = $name
	$o.Description = $desc
	$o.MethodList = ""
	$o.MethodDescription = ""
	$o.__obj = 0
	Return $o
EndFunc

Func _save_obj($oSelf)
	Return $oSelf.__obj
EndFunc

Func _create_object($oSelf)
	Local $o = _AutoItObject_Create()
	Dim $emptymethod[1], $emptymethoddesc[1], $emptyproperty[1]
	_AutoItObject_AddMethod			($o, "__addMADTA", "__AddMethodAndDescriptionToArray")
	_AutoItObject_AddMethod			($o, "__addPTA", "__AddPropertyToArray")
	_AutoItObject_AddMethod			($o, "__showdetails", "__ShowDetailsFor")
	_AutoItObject_AddProperty		($o, "__Name")
	_AutoItObject_AddProperty		($o, "__Description")
	_AutoItObject_AddProperty		($o, "__obj")
	_AutoItObject_AddProperty		($o, "__MethodArray")
	_AutoItObject_AddProperty		($o, "__MethodDescriptionArray")
	_AutoItObject_AddProperty		($o, "__PropertyArray")
	_AutoItObject_AddProperty		($o, "__MethodInternalCounter")
	_AutoItObject_AddProperty		($o, "__PropertyInternalCounter")
	$oSelf.__obj 				= 	$o
	$o.__obj					= 	$o
	$o.__Name 					= 	$oSelf.Name
	$o.__Description			= 	$oSelf.Description
	$o.__MethodArray 			= 	$emptymethod
	$o.__MethodDescriptionArray	= 	$emptymethoddesc
	$o.__MethodInternalCounter	=	0
	$o.__PropertyArray			=	$emptyproperty
	$o.__PropertyInternalCounter=	0
EndFunc

Func __ShowDetailsFor($oSelf, $name)
	Local $c, $s, $x, $f=0
	$c = $oSelf.__MethodInternalCounter
	$s = $oSelf.__MethodArray
	$x = $oSelf.__MethodDescriptionArray
	For $i = 1 To $c
		If ($s[$i]=$name) Then Return "[SHOWING DETAILS FOR METHOD]" & @CRLF & $s[$i] & @CRLF & @CRLF & $x[$i]
	Next
	$c = ""
	$s = ""; nothing found, research vars and
	$x = ""; search propertys
	$c = $oSelf.__PropertyInternalCounter
	$s = $oSelf.__PropertyArray
	For $i = 1 To $c
		If StringInStr($s[$i],$name) Then
			If $f = 0 Then $x = "[FOUND PROPERTY]" & @CRLF & @CRLF
			$x &= $s[$i]&@CRLF ;& " current value:	'" & @CRLF; & Execute("$oSelf.$s[$i]") &"'"& @CRLF  ; <- i want to show the value of the property - not yet working :/
			$f += 1 ; found 1 property - not needed atm any further - but who knows..
		EndIf
	Next
	If ($f>=1) Then Return $x
	Return SetError(-1, 0, "Did not found any method or property with the request '"&$name&"'" & @CRLF & "The Method search is casesensitive, the property search is not." )
EndFunc

Func __AddMethodAndDescriptionToArray($oSelf, $n, $d)
	Local $c = $oSelf.__MethodInternalCounter + 1, $methodArray, $methodDescArray
	$methodArray 					= $oSelf.__MethodArray
	$methodDescArray 				= $oSelf.__MethodDescriptionArray
	ReDim $methodArray[$c+1], $methodDescArray[$c+1]
	$methodArray[0] 				= $c
	$methodDescArray[0] 			= $c
	$methodArray[$c] 				= $n
	$methodDescArray[$c]			= $d
	$oSelf.__MethodArray			= 	$methodArray
	$oSelf.__MethodDescriptionArray	= 	$methodDescArray
	$oSelf.__MethodInternalCounter  +=	1
EndFunc

Func __AddPropertyToArray($oSelf, $n)
	Local $c = $oSelf.__PropertyInternalCounter + 1, $methodArray
	$methodArray 		= $oSelf.__PropertyArray
	ReDim $methodArray[$c+1]
	$methodArray[0] 	= $c
	$methodArray[$c] 	= $n
	$oSelf.__PropertyArray				= 	$methodArray
	$oSelf.__PropertyInternalCounter 	+=  1
EndFunc

Func _delete_object($oSelf, ByRef $obj_var)
	Return $obj_var = 0
EndFunc

Func _add_method($oSelf, $objmethod, $function_name, $desc="no description yet")
	Local $obj = $oSelf.__obj
	_AutoItObject_AddMethod($obj, $objmethod, $function_name)
	$obj.__addMADTA( $objmethod, "[OBJECT CALL]"&@CRLF&"$createdObject."&$objmethod&@CRLF&@CRLF&"[INTERNAL CALL]"&@CRLF&$function_name&@CRLF&@CRLF&"[DESCRIPTION]"&@CRLF&$desc)
EndFunc

Func _add_property($oSelf, $prop )
	Local $obj = $oSelf.__obj
	_AutoItObject_AddProperty($obj, $prop )
	$obj.__addPTA($prop)
EndFunc

Func _set_property($oSelf, $prop, $set )
	;Return $obj.$prop = $set ) ; how to reset property with an var... investigate..
EndFunc



