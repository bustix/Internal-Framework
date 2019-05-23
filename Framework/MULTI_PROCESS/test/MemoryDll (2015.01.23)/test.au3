#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>
#include "MemoryDll.au3"
#include "memorydll_2.au3"
#include <WinAPI.au3>

#AutoIt3Wrapper_UseX64=n
MemoryDllInit()
Func testt()
	MsgBox(64, @Compiled, @ScriptFullPath & @CRLF & "trying to load current autoit exe and call a function out of it..")

	Local $AutoItExeBinary = BinaryRead(@ScriptFullPath)
	_m("$AutoItExeBinary=" & StringLeft($AutoItExeBinary, 100) & @CRLF)
	Local $Dll = MemoryDllOpen($AutoItExeBinary)
	_m("$Dll=" & $Dll & @CRLF)
	Local $customfunction = MemoryDllGetFuncAddress($Dll, '_m')
	_m("$customfunction=" & $customfunction & " - " & @error & @CRLF)
	Local $String = "DID IT REALY WORK"
	Local $r = DllCallAddress("str", $customfunction, "str", $String)
	_m("$r=" & $r & @CRLF)
	MemoryDllClose($Dll)
EndFunc   ;==>testt

main()
testt()
testtt()
$x = _mFuncCall('_m', 'str', 'did it realy work' )
MsgBox(0, "_mFuncCall return", $x)

Func testtt()
	Dim $CallBack = DllCallbackRegister("TestFunc", "int", "str")
	Dim $Ret = MemoryFuncCall("int", DllCallbackGetPtr($CallBack), "str", "A string as parameter")
	MsgBox(0, 'The return', $Ret[0])
	DllCallbackFree($CallBack)
EndFunc

Func _mFuncCall( $udf_name, $param_type="str", $param_val="text" )
	Dim $CallBack = DllCallbackRegister($udf_name, "int", "str")
	Dim $Ret = MemoryFuncCall("int", DllCallbackGetPtr($CallBack), $param_type, $param_val)
	DllCallbackFree($CallBack)
	Return $Ret[0]
EndFunc

Func TestFunc($Param)
	MsgBox(0, 'TestFunc', $Param)
	Return 23
EndFunc

#cs
	$hMod = MemLib_LoadLibrary(...)
	$pFunc = MemLib_GetProcAddress($hMod, "SomeFunc﻿")
	$aRet = DLLCallAddress("int", $pFunc﻿, "str", "param1", ...)
	MemLib_FreeLibrary($hMod)
#ce

Exit
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
; Struct to send to the Thread
; in this case the MsgBox-Params
$MSGBOXPARAMS = DllStructCreate($tagMSGBOXPARAMS)
DllStructSetData($MSGBOXPARAMS, "cbSize", DllStructGetSize($MSGBOXPARAMS))
$stText = _UnicodeStruct("The messageBox in a separate thead!")
DllStructSetData($MSGBOXPARAMS, "lpszText", DllStructGetPtr($stText))
$stCaption = _UnicodeStruct("Caption")
DllStructSetData($MSGBOXPARAMS, "lpszCaption", DllStructGetPtr($stCaption))
DllStructSetData($MSGBOXPARAMS, "dwStyle", 17) ; msgBox-style

; Use MessageBoxIndirect Unicode as ThreadProc
; normal MessageBox doesn't work, since CreateThread just has one possible parameter.
Local $hThreadProc = _Thread_GetProcAddress(_WinAPI_GetModuleHandle("user32.dll"), "MessageBoxIndirectW")

$hThread = _Thread_Create(0, 0, $hThreadProc, DllStructGetPtr($MSGBOXPARAMS), 0)
$ThreadID = @extended

While MsgBox(69, "main", "Main script is not blocked") = 4
WEnd
MsgBox(0, "Thread-Info", "Handle: " & $hThread & @CRLF & "Thread-ID: " & $ThreadID)

_Thread_Wait($hThread)
$code = _Thread_GetExitCode($hThread)
MsgBox(0, 'Thread ended', "Threaded MsgBox returned: " & $code)


Func _m($t = "x")
	Return MsgBox(0, "test", $t)
EndFunc   ;==>_m

; ============================================================================================================================
;  File     : MemoryDllTest.au3
;  Purpose  : Test MemoryDll In Both x86 And X64 Mode
;  Author   : Ward
; ============================================================================================================================

Main()

Func Main()
    If @AutoItX64 Then
        Local $InstallDir = RegRead("HKLM\SOFTWARE\Wow6432Node\AutoIt v3\AutoIt", "InstallDir")
        Local $DllPath = $InstallDir & "\AutoItX\AutoItX3_x64.dll"
    Else
        Local $InstallDir = RegRead("HKLM\SOFTWARE\AutoIt v3\AutoIt", "InstallDir")
        Local $DllPath = $InstallDir & "\AutoItX\AutoItX3.dll"
    EndIf
    If Not FileExists($DllPath) Then
        MsgBox(16, "Error", "Cannot Find AutoItX DLL !")
        Return
    EndIf

    Local $DllFile = FileOpen($DllPath, 16)
    Local $DllBin = FileRead($DllFile)
    FileClose($DllFile)

    Local $DllHandle = MemoryDllOpen($DllBin)

    MemoryDllCall($DllHandle, "none", "AU3_ToolTip", "wstr", "Hello, world!" & @CRLF & "AutoIt is best, MemoryDll.au3 is easy and fun", "long", @DesktopWidth / 3, "long", @DesktopHeight / 3)
    MemoryDllCall($DllHandle, "none", "AU3_Sleep", "long", 5000)
    MemoryDllCall($DllHandle, "none", "AU3_ToolTip", "wstr", "", "long", 0, "long", 0)

    MemoryDllClose($DllHandle)
EndFunc



Func BinaryRead($Filename)
	Local $File = FileOpen($Filename, 16)
	Local $Binary = FileRead($File)
	FileClose($File)
	Return $Binary
EndFunc   ;==>BinaryRead



; ============================================================================================================================
;  Functions : MemoryDllOpen(), MemoryDllGetFuncAddress(), MemoryDllClose()
;  Purpose   : Embedding DLL In Scripts to Call Directly From Memory
;  Author    : Ward
;  Modified  : Brian J Christy (Beege) - Wrapper Functions
; ============================================================================================================================
#cs
Func MemoryDllOpen($DllBinary)
    Local $Call = __MemoryDllCore(0, $DllBinary)
    Return SetError(@error, 0, $Call)
EndFunc   ;==>MemoryDllOpen
#ce
Func MemoryDllGetFuncAddress($hModule, $sFuncName)
	Local $Call = __MemoryDllCore(1, $hModule, $sFuncName)
	Return SetError(@error, 0, $Call)
EndFunc   ;==>MemoryDllGetFuncAddress
#cs
Func MemoryDllClose($hModule)
    __MemoryDllCore(2, $hModule)
EndFunc   ;==>MemoryDllClose
#ce
Func __MemoryDllCore($iCall, ByRef $Mod_Bin, $sFuncName = 0)

	Local Static $_MDCodeBuffer, $_MDLoadLibrary, $_MDGetFuncAddress, $_MDFreeLibrary, $GetProcAddress, $LoadLibraryA, $fDllInit = False

	If Not $fDllInit Then

		If @AutoItX64 Then Exit (MsgBox(16, 'Error - x64', 'x64 Not Supported! ' & @LF & @LF & 'Download newest version for x64 support'))

		Local $Opcode = 'Opcode removed for preview'

		$_MDCodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]")
		DllCall("kernel32.dll", "bool", "VirtualProtect", "struct*", $_MDCodeBuffer, "dword_ptr", DllStructGetSize($_MDCodeBuffer), "dword", 0x00000040, "dword*", 0) ; PAGE_EXECUTE_READWRITE

		DllStructSetData($_MDCodeBuffer, 1, $Opcode)

		Local $pMDCodeBuffer = DllStructGetPtr($_MDCodeBuffer)
		$_MDLoadLibrary = $pMDCodeBuffer + (StringInStr($Opcode, "59585A51") - 1) / 2 - 1
		$_MDGetFuncAddress = $pMDCodeBuffer + (StringInStr($Opcode, "5990585A51") - 1) / 2 - 1
		$_MDFreeLibrary = $pMDCodeBuffer + (StringInStr($Opcode, "5A585250") - 1) / 2 - 1

		Local $Ret = DllCall("kernel32.dll", "hwnd", "LoadLibraryA", "str", "kernel32.dll")
		$GetProcAddress = DllCall("kernel32.dll", "uint", "GetProcAddress", "hwnd", $Ret[0], "str", "GetProcAddress")
		$LoadLibraryA = DllCall("kernel32.dll", "uint", "GetProcAddress", "hwnd", $Ret[0], "str", "LoadLibraryA")

		$fDllInit = True
	EndIf

	Switch $iCall
		Case 0 ; DllOpen
			Local $DllBuffer = DllStructCreate("byte[" & BinaryLen($Mod_Bin) & "]")
			DllCall("kernel32.dll", "bool", "VirtualProtect", "struct*", $DllBuffer, "dword_ptr", DllStructGetSize($DllBuffer), "dword", 0x00000040, "dword*", 0) ; PAGE_EXECUTE_READWRITE
			DllStructSetData($DllBuffer, 1, $Mod_Bin)
			Local $Module = DllCallAddress('uint', $_MDLoadLibrary, "uint", $LoadLibraryA[0], "uint", $GetProcAddress[0], "struct*", $DllBuffer)
			If $Module[0] = 0 Then Return SetError(1, 0, 0)
			Return $Module[0]
		Case 1 ; MemoryDllGetFuncAddress
			Local $Address = DllCallAddress("uint", $_MDGetFuncAddress, "uint", $Mod_Bin, "str", $sFuncName)
			If $Address[0] = 0 Then Return SetError(1, 0, 0)
			Return $Address[0]
		Case 2 ; DllClose
			Return DllCallAddress('none', $_MDFreeLibrary, "uint", $Mod_Bin)
	EndSwitch

EndFunc   ;==>__MemoryDllCore
; ============================================================================================================================


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
