#AutoIt3Wrapper_Res_SaveSource=y
#﻿AutoIt3Wrapper_Res_SaveSourcedirecti﻿ve﻿
Global Const $STATUS_PENDING = 0x103
Global Const $STILL_ACTIVE = $STATUS_PENDING

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
    Local $result = DllCall("kernel32.dll","ptr","CreateThread", "ptr", $lpThreadAttributes, "dword", $dwStackSize, "ptr", $lpStartAddress, "ptr", $lpParameter, "dword", $dwCreationFlags, "dword*", 0)
    Return SetError($result[0]=0,$result[6],$result[0])
EndFunc
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
Func _Thread_Terminate($hThread,$dwExitCode)
    Local $result = DllCall("Kernel32.dll","int","TerminateThread","ptr",$hThread,"dword",$dwExitCode)
    Return SetError($result[0]=0,0,$result[0])
EndFunc
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
    DllCall("Kernel32.dll","none","ExitThread","dword",$dwExitCode)
EndFunc
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
    Local $result = DllCall("Kernel32.dll","int","GetExitCodeThread","ptr",$hThread,"dword*",0)
    Return SetError($result[0]=0,0,$result[2])
EndFunc
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
    Local $result = DllCall("Kernel32.dll","dword","GetThreadId","ptr",$hThread)
    Return SetError($result[0]=0,0,$result[0])
EndFunc
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
    Local $result = DllCall("Kernel32.dll","int","GetThreadPriority","ptr",$hThread)
    Return SetError($result[0]=0,0,$result[0])
EndFunc
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
Func _Thread_SetPriority($hThread,$nPriority)
    Local $result = DllCall("Kernel32.dll","int","SetThreadPriority","ptr",$hThread,"int",$nPriority)
    Return SetError($result[0]=0,0,$result[0])
EndFunc
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
    Local $result = DllCall("Kernel32.dll","int","SuspendThread","ptr",$hThread)
    Return SetError($result[0]=-1,0,$result[0])
EndFunc
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
    Local $result = DllCall("Kernel32.dll","int","ResumeThread","ptr",$hThread)
    Return SetError($result[0]=-1,0,$result[0])
EndFunc
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
Func _Thread_Wait($hThread,$nTimeout=0xFFFFFFFF)
    Local $result = DllCall("Kernel32.dll", "dword", "WaitForSingleObject", "ptr", $hThread, "int", $nTimeout)
    If @error Then Return SetError(2,0,0)
    Switch $result[0]
        Case -1, 0xFFFFFFFF
            Return SetError(1,0,0)
        Case 0x00000102
            Return SetError(-1,0,1)
        Case Else
            Return 1
    EndSwitch
EndFunc


#include <WinAPI.au3>


; creates a struct for an Unicode-String
Func _UnicodeStruct($text)
    ; Prog@ndy
    Local $s = DllStructCreate("wchar[" & StringLen($text)+1 & "]")
    DllStructSetData($s,1,$text)
    Return $s
EndFunc

; retrieves Address of a function
Func _Thread_GetProcAddress($hModule,$sProcname)
    ; Prog@ndy
    Local $result = DllCall("kernel32.dll","ptr","GetProcAddress","hwnd",$hModule,"str",$sProcname)
    Return $result[0]
EndFunc

#cs
$tagMSGBOXPARAMS = _
        "UINT cbSize;" & _
        "HWND hwndOwner;" & _
        "ptr hInstance;" & _
        "ptr lpszText;" & _
        "ptr lpszCaption;" & _
        "DWORD dwStyle;" & _
        "ptr lpszIcon;" & _
        "UINT_PTR dwContextHelpId;" & _
        "ptr lpfnMsgBoxCallback;" & _
        "DWORD dwLanguageId;"
#ce
#include "VarDump.au3"
#include <WinAPIDiag.au3>
#include "NomadMemory.au3"
#include <WinAPIConstants.au3>
#include <WinAPIProc.au3>
#include <WinAPIRes.au3>

Local $x = 1

If $x = 0 Then

Local $me = @AutoItPID, $t, $r, $s, $test, $a, $test2, $test3, $i
$s = "_m"
$t = ProcessExists($me)
$r = _MemoryModuleGetBaseAddress($t, $s)
$test = _WinAPI_GetModuleHandle(@AutoItExe)
$test2 = _WinAPI_LoadLibraryEx(@AutoItExe,$LOAD_LIBRARY_AS_DATAFILE)
$test3= _WinAPI_GetProcAddress ($test, "" )

$i = _WinAPI_GetModuleInformation($test)
MsgBox(0, "result", $i )


MsgBox(0,"PID: "&$me & "/" & $t, "filename:		" & $me & @CRLF & "searching for:	" & $s & @CRLF & "found:		" & $r & @CRLF & "test:		" & $test & @CRLF & "test2:		" & $test2& @CRLF & "test3:		" & $test3)



Exit

ElseIf $x = 1 Then
; Struct to send to the Thread
; in this case the MsgBox-Params
$MSGBOXPARAMS = DllStructCreate($tagMSGBOXPARAMS)
DllStructSetData($MSGBOXPARAMS,"cbSize",DllStructGetSize($MSGBOXPARAMS))
$stText = _UnicodeStruct("The messageBox in a separate thead!")
DllStructSetData($MSGBOXPARAMS,"lpszText",DllStructGetPtr($stText))
$stCaption = _UnicodeStruct("Caption")
DllStructSetData($MSGBOXPARAMS,"lpszCaption",DllStructGetPtr($stCaption))
DllStructSetData($MSGBOXPARAMS,"dwStyle",17) ; msgBox-style

; Use MessageBoxIndirect Unicode as ThreadProc
; normal MessageBox doesn't work, since CreateThread just has one possible parameter.
Local $hThreadProc = _Thread_GetProcAddress(_WinAPI_GetModuleHandle("user32.dll"),"MessageBoxIndirectW")

$hThread = _Thread_Create(0 ,0, $hThreadProc, DllStructGetPtr($MSGBOXPARAMS), 0)
$ThreadID = @extended

While MsgBox(69, "main", "Main script is not blocked" )=4
WEnd
MsgBox(0, "Thread-Info", "Handle: " & $hThread & @CRLF & "Thread-ID: " & $ThreadID)

_Thread_Wait($hThread)
$code = _Thread_GetExitCode($hThread)
MsgBox(0, 'Thread ended', "Threaded MsgBox returned: " & $code)

EndIf

Func _m($t="x")
	Return MsgBox(0, "test", $t )
EndFunc


