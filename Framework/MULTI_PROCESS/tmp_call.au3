$x = DllCallAddress("int", 0x0000027733290000 )


Global Const $STATUS_PENDING = 0x103
Global Const $STILL_ACTIVE = $STATUS_PENDING
#include <WinAPI.au3>

; ThreadID is @extended
;===============================================================================
;
; Function Name:   _Thread_Create
; Description::    Creates a thread
; Parameter(s):    see MSDN (lpThreadId is removed)
; Requirement(s):  minimum Win2000
; Return Value(s): see MSDN
;                  @extended will be ThreadID
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_Create($lpThreadAttributes, $dwStackSize, $lpStartAddress, $lpParameter, $dwCreationFlags)
	Local $result = DllCall("kernel32.dll", "ptr", "CreateThread", "ptr", $lpThreadAttributes, "dword", $dwStackSize, "ptr", $lpStartAddress, "ptr", $lpParameter, "dword", $dwCreationFlags, "dword*", 0)
	Return SetError($result[0] = 0, $result[6], $result[0])
EndFunc   ;==>_Thread_Create
;===============================================================================
;
; Function Name:   _Thread_Terminate
; Description::    Terminates a thread
; Parameter(s):    see MSDN
; Requirement(s):  minimum Win2000
; Return Value(s): see MSDN
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_Terminate($hThread, $dwExitCode)
	Local $result = DllCall("Kernel32.dll", "int", "TerminateThread", "ptr", $hThread, "dword", $dwExitCode)
	Return SetError($result[0] = 0, 0, $result[0])
EndFunc   ;==>_Thread_Terminate
;===============================================================================
;
; Function Name:   _Thread_Exits
; Description::    Exits the current thread
; Parameter(s):    see MSDN
; Requirement(s):  minimum Win2000
; Return Value(s): none
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_Exit($dwExitCode)
	DllCall("Kernel32.dll", "none", "ExitThread", "dword", $dwExitCode)
EndFunc   ;==>_Thread_Exit
;===============================================================================
;
; Function Name:   _Thread_GetExitCode
; Description::    retrieves ExitCode of a thread
; Parameter(s):    see MSDN
; Requirement(s):  minimum Win2000
; Return Value(s): see MSDN
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_GetExitCode($hThread)
	Local $result = DllCall("Kernel32.dll", "int", "GetExitCodeThread", "ptr", $hThread, "dword*", 0)
	Return SetError($result[0] = 0, 0, $result[2])
EndFunc   ;==>_Thread_GetExitCode
;===============================================================================
;
; Function Name:   _Thread_GetID
; Description::    retrieves ThreadID of a thread
; Parameter(s):    see MSDN
; Requirement(s):  minimum Win2000
; Return Value(s): see MSDN
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_GetID($hThread)
	Local $result = DllCall("Kernel32.dll", "dword", "GetThreadId", "ptr", $hThread)
	Return SetError($result[0] = 0, 0, $result[0])
EndFunc   ;==>_Thread_GetID
;===============================================================================
;
; Function Name:   _Thread_GetPriority
; Description::    retrieves priority of a thread
; Parameter(s):    see MSDN
; Requirement(s):  minimum Win2000
; Return Value(s): see MSDN
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_GetPriority($hThread)
	Local $result = DllCall("Kernel32.dll", "int", "GetThreadPriority", "ptr", $hThread)
	Return SetError($result[0] = 0, 0, $result[0])
EndFunc   ;==>_Thread_GetPriority
;===============================================================================
;
; Function Name:   _Thread_SetPriority
; Description::    sets priority of a thread
; Parameter(s):    see MSDN
; Requirement(s):  minimum Win2000
; Return Value(s): see MSDN
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_SetPriority($hThread, $nPriority)
	Local $result = DllCall("Kernel32.dll", "int", "SetThreadPriority", "ptr", $hThread, "int", $nPriority)
	Return SetError($result[0] = 0, 0, $result[0])
EndFunc   ;==>_Thread_SetPriority
;===============================================================================
;
; Function Name:   _Thread_Suspend
; Description::    suspends a thread
; Parameter(s):    see MSDN
; Requirement(s):  minimum Win2000
; Return Value(s): see MSDN
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_Suspend($hThread)
	Local $result = DllCall("Kernel32.dll", "int", "SuspendThread", "ptr", $hThread)
	Return SetError($result[0] = -1, 0, $result[0])
EndFunc   ;==>_Thread_Suspend
;===============================================================================
;
; Function Name:   _Thread_Resume
; Description::    resumes a thread
; Parameter(s):    see MSDN
; Requirement(s):  minimum Win2000
; Return Value(s): see MSDN
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_Resume($hThread)
	Local $result = DllCall("Kernel32.dll", "int", "ResumeThread", "ptr", $hThread)
	Return SetError($result[0] = -1, 0, $result[0])
EndFunc   ;==>_Thread_Resume
;===============================================================================
;
; Function Name:   _Thread_Wait
; Description::    Waits for a thread to terminate
; Parameter(s):    $hThread  - Handle of thread
;                  $nTimeOut - [optional] Timeout (default: 0xFFFFFFFF => INFINTE)
; Requirement(s):  minimum Win2000
; Return Value(s): Success: true
;                  on TimeOut, @eeor will be set to -1
;                  On error, @error will be set to 1
; Author(s):       Prog@ndy
;
;===============================================================================
;
Func _Thread_Wait($hThread, $nTimeout = 0xFFFFFFFF)
	Local $result = DllCall("Kernel32.dll", "dword", "WaitForSingleObject", "ptr", $hThread, "int", $nTimeout)
	If @error Then Return SetError(2, 0, 0)
	Switch $result[0]
		Case -1, 0xFFFFFFFF
			Return SetError(1, 0, 0)
		Case 0x00000102
			Return SetError(-1, 0, 1)
		Case Else
			Return 1
	EndSwitch
EndFunc   ;==>_Thread_Wait




; creates a struct for an Unicode-String
Func _UnicodeStruct($text)
	; Prog@ndy
	Local $s = DllStructCreate("wchar[" & StringLen($text) + 1 & "]")
	DllStructSetData($s, 1, $text)
	Return $s
EndFunc   ;==>_UnicodeStruct

; retrieves Address of a function
Func _Thread_GetProcAddress($hModule, $sProcname)
	; Prog@ndy
	Local $result = DllCall("kernel32.dll", "ptr", "GetProcAddress", "hwnd", $hModule, "str", $sProcname)
	Return $result[0]
EndFunc   ;==>_Thread_GetProcAddress
