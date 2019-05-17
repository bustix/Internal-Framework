#include-once
#include "AutoItObject.au3"

Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")

; start autoit object
_AutoItObject_StartUp()

Func ErrFunc()
	ConsoleWrite("!>COM Error !"&@CRLF&"!>"&@TAB&"Number: "&Hex($oError.Number,8)&@CRLF&"!>"&@TAB&"Windescription: "&StringRegExpReplace($oError.windescription,"\R$","")&@CRLF&"!>"&@TAB&"Source: "&$oError.source&@CRLF&"!>"&@TAB&"Description: "&$oError.description&@CRLF&"!>"&@TAB&"Helpfile: "&$oError.helpfile&@CRLF&"!>"&@TAB&"Helpcontext: "&$oError.helpcontext&@CRLF&"!>"&@TAB&"Lastdllerror: "&$oError.lastdllerror&@CRLF&"!>"&@TAB&"Scriptline: "&$oError.scriptline&@CRLF)
EndFunc   ;==>ErrFunc

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
	$o.Name = $name
	$o.Description = $desc
	$o.__obj = 0
	Return $o
EndFunc

Func _save_obj($oSelf)
	Return $oSelf.__obj
EndFunc

Func _create_object($oSelf)
	Local $o = _AutoItObject_Create()
	_AutoItObject_AddProperty($o, "__Name")
	_AutoItObject_AddProperty($o, "__Description")
	_AutoItObject_AddProperty($o, "__obj")
	$oSelf.__obj 	= $o
	$o.__obj		= $o
	$o.__Name 		= $oSelf.Name
	$o.__Description= $oSelf.Description
EndFunc

Func _delete_object($oSelf, ByRef $obj_var)
	Return $obj_var = 0
EndFunc

Func _add_method($oSelf, $objmethod, $function_name, $desc  = "")
	Local $obj = $oSelf.__obj
	_AutoItObject_AddMethod($obj, $objmethod, $function_name)
EndFunc

Func _add_property($oSelf, $prop )
	Local $obj = $oSelf.__obj
	_AutoItObject_AddProperty($obj, $prop )
EndFunc

Func _set_property($oSelf, $prop, $set )
	;Return $obj.$prop = $set )
EndFunc



