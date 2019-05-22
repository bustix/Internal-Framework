#include-once
; #INDEX# =======================================================================================================================
; Title ............: thread.au3
; AutoIt Version ...: 3.3.14.1
; Description ......: True threading for AutoIt3 (currently in development state).
; Author(s) ........: Jefrey Sobreira Santos (jesobreira)
; Link .............: https://github.com/jesobreira/thread.au3
; ===============================================================================================================================

; CONSTANTS
Global Const $__THREAD_CONST_WHATEVER 	= "[##%R!E)P]L[A(C!E%##]"

; THREAD METHODS

;start object
	; #FUNCTION# ====================================================================================================================
	; Name ..........: _Thread_Create
	; Description ...: Create a Thread.
	; Syntax ........: _Thread_Create($sCallback)
	; Parameters ....: $sCallback           - $sCallback funtion as a string.
	; Return values .: Success: Handle to the thread.
	;                  Failure: False and @error set to 1.
	; Author ........: Jefrey Sobreira Santos (jesobreira)
	; Modified ......: Damon Harris (TheDcoder) and J2TeaM
	; Remarks .......:
	; Related .......:
	; Link ..........:
	; Example .......: Yes
	; ===============================================================================================================================
	Func _THREAD_Start($oSelf, $sCallback)
		Local $hHandle, $tStruct, $aResult
		$hHandle = DllCallbackRegister($sCallback, "int", "ptr")
		$tStruct = DllStructCreate("Char[200];int")
		DllStructSetData($tStruct, 1, 10)
		$aResult = DllCall("kernel32.dll", "hwnd", "CreateThread", "ptr", 0, "dword", 0, "long", DllCallbackGetPtr($hHandle), "ptr", DllStructGetPtr($tStruct), "long", 0, "int*", 0)
		Return (Not @error And IsArray($aResult)) ? $aResult[0] : SetError(1, 0, False)
		Return SetError(-1,0,  $oSelf._setError("Startup: [Object creation error]"))
	EndFunc

	; #FUNCTION# ====================================================================================================================
	; Name ..........: _Thread_Terminate
	; Description ...: Terminate a Thread
	; Syntax ........: _Thread_Terminate($hThread)
	; Parameters ....: $hThread             - Handle returned by _Thread_Create.
	; Return values .: Success: True.
	;                  Failure: False.
	; Author ........: Jefrey Sobreira Santos (jesobreira)
	; Modified ......: Damon Harris (TheDcoder) and J2TeaM
	; Remarks .......:
	; Related .......:
	; Link ..........:
	; Example .......: Yes
	; ===============================================================================================================================
	Func _THREAD_Delete($oSelf, $hThread )
		Return DllCall("kernel32.dll", "bool", "TerminateThread", "handle", $hThread, "dword", 0)
	EndFunc

;get/set error propertys
	Func _THREAD_SetError($oSelf,$t,$er=@error,$ex=@extended)
		$oSelf._errorText = $t
		$oSelf._errorNum = $er
		$oSelf._errorExt = $ex
	EndFunc
	Func _THREAD_GetErrorText($oSelf)
		Return $oSelf._errorText
	EndFunc
	Func _THREAD_GetErrorNum($oSelf)
		Return $oSelf._errorNum
	EndFunc
	Func _THREAD_GetErrorExt($oSelf)
		Return $oSelf._errorExt
	EndFunc


Func _Thread_Create($sCallback)
EndFunc

Func _Thread_Terminate($hThread)
EndFunc