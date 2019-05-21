#include-once

; CONSTANTS
Global Const $__OBJECTTEMPLATE_CONST_WHATEVER 	= "[##%R!E)P]L[A(C!E%##]"

; THREAD METHODS

;start object

	Func _OBJECTTEMPLATE_Start($oSelf, $function)

	EndFunc

	Func _OBJECTTEMPLATE_Delete($oSelf, $handle )

	EndFunc

;get/set error propertys
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

