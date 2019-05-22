#Include <GDIPlus.au3>
#Include <GUIConstantsEx.au3>
#Include <File.au3>
#Include "MemoryDll.au3"
#include <WinAPI.au3>

#AutoIt3Wrapper_UseX64=n

Func testt()
	MsgBox(64, @Compiled, @ScriptFullPath & @CRLF & "trying to load current autoit exe and call a function out of it..")

	Local $AutoItExeBinary = BinaryRead(@ScriptFullPath)
_m( "$AutoItExeBinary=" & StringLeft($AutoItExeBinary,100) & @CRLF)
	Local $Dll = MemoryDllOpen($AutoItExeBinary)
_m( "$Dll=" & $Dll & @CRLF)
	Local $customfunction = MemoryDllGetFuncAddress($Dll, '_m')
_m( "$customfunction=" & $customfunction & " - " & @error & @CRLF)
	Local $String = "DID IT REALY WORK"
	Local $r = DllCallAddress("str", $customfunction, "str", $String )
_m( "$r=" & $r & @CRLF)
	MemoryDllClose($Dll)
EndFunc

testt()

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


Func _m($t="x")
	Return MsgBox(0, "test", $t )
EndFunc

Func BinaryRead($Filename)
	Local $File = FileOpen($Filename, 16)
	Local $Binary = FileRead($File)
	FileClose($File)
	Return $Binary
EndFunc


Func MemoryFuncCall($RetType, $FunctionPointer, $Type1 = "int", $Param1 = 0, $Type2 = "int", $Param2 = 0, $Type3 = "int", $Param3 = 0, $Type4 = "int", $Param4 = 0, $Type5 = "int", $Param5 = 0, _

$Type6 = "int", $Param6 = 0, $Type7 = "int", $Param7 = 0, $Type8 = "int", $Param8 = 0, $Type9 = "int", $Param9 = 0, $Type10 = "int", $Param10 = 0, _

$Type11 = "int", $Param11 = 0, $Type12 = "int", $Param12 = 0, $Type13 = "int", $Param13 = 0, $Type14 = "int", $Param14 = 0, $Type15 = "int", $Param15 = 0, _

$Type16 = "int", $Param16 = 0, $Type17 = "int", $Param17 = 0, $Type18 = "int", $Param18 = 0, $Type19 = "int", $Param19 = 0, $Type20 = "int", $Param20 = 0 )

Local $Ret

Local Const $MaxParams = 20

If (@NumParams < 2) Or (@NumParams > $MaxParams * 2 + 2) Or (Mod(@NumParams, 2) = 1) Then

SetError(2)

Return 0

EndIf

If Not IsDllStruct($_MDCodeBuffer) Then MemoryDllInit()



If $FunctionPointer = 0 Then

SetError(1)

Return 0

EndIf



Local $Ret[1] = [$FunctionPointer]



Switch @NumParams

Case 13 To $MaxParams * 2 + 2

Local $DllParams = (@NumParams - 3) / 2, $i, $PartRet

$Ret = DllCall("user32.dll", $RetType, "CallWindowProc", "ptr", DllStructGetPtr($_MDCodeBuffer) + $_MDWarpN, _

"uint", $Ret[0], _

"uint", $DllParams, _

$Type1, $Param1, _

$Type2, $Param2)



$Ret[1] = $Ret[4]

$Ret[2] = $Ret[5]

ReDim $Ret[3]



For $i = 3 To $DllParams Step 3

$PartRet = DllCall("user32.dll", $RetType, "CallWindowProc", "ptr", DllStructGetPtr($_MDCodeBuffer) + $_MDWarpN, _

"uint", 0, _

Eval('Type' & $i), Eval('Param' & $i), _

Eval('Type' & ($i+1)), Eval('Param' & ($i+1)), _

Eval('Type' & ($i+2)), Eval('Param' & ($i+2)))

ReDim $Ret[$i + 3]

$Ret[$i + 2] = $PartRet[5]

$Ret[$i + 1] = $PartRet[4]

$Ret[$i] = $PartRet[3]

Next

$Ret[0] = $PartRet[0]

ReDim $Ret[$DllParams + 1]



Case 10

$Ret = DllCall("user32.dll", $RetType, "CallWindowProc", "ptr", $Ret[0], _

$Type1, $Param1, _

$Type2, $Param2, _

$Type3, $Param3, _

$Type4, $Param4)

$Ret[1] = $Ret[2]

$Ret[2] = $Ret[3]

$Ret[3] = $Ret[4]

$Ret[4] = $Ret[5]

ReDim $Ret[5]



Case 8

$Ret = DllCall("user32.dll", $RetType, "CallWindowProc", "ptr", DllStructGetPtr($_MDCodeBuffer) + $_MDWarp3, _

"uint", $Ret[0], _

$Type1, $Param1, _

$Type2, $Param2, _

$Type3, $Param3)

$Ret[1] = $Ret[3]

$Ret[2] = $Ret[4]

$Ret[3] = $Ret[5]

ReDim $Ret[4]



Case 6

$Ret = DllCall("user32.dll", $RetType, "CallWindowProc", "ptr", DllStructGetPtr($_MDCodeBuffer) + $_MDWarp2, _

"int", 0, _

"uint", $Ret[0], _

$Type1, $Param1, _

$Type2, $Param2)

$Ret[1] = $Ret[4]

$Ret[2] = $Ret[5]

ReDim $Ret[3]



Case 4

$Ret = DllCall("user32.dll", $RetType, "CallWindowProc", "ptr", DllStructGetPtr($_MDCodeBuffer) + $_MDWarp1, _

"int", 0, _

"int", 0, _

"uint", $Ret[0], _

$Type1, $Param1)

$Ret[1] = $Ret[5]

ReDim $Ret[2]



Case 2

$Ret = DllCall("user32.dll", $RetType, "CallWindowProc", "ptr", DllStructGetPtr($_MDCodeBuffer) + $_MDWarp0, _

"int", 0, _

"int", 0, _

"int", 0, _

"int", $Ret[0])



ReDim $Ret[1]

EndSwitch



SetError(0)

Return $Ret

EndFunc

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

        If @AutoItX64 Then Exit(MsgBox(16, 'Error - x64', 'x64 Not Supported! ' & @LF & @LF & 'Download newest version for x64 support'))

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
        Case 0; DllOpen
            Local $DllBuffer = DllStructCreate("byte[" & BinaryLen($Mod_Bin) & "]")
            DllCall("kernel32.dll", "bool", "VirtualProtect", "struct*", $DllBuffer, "dword_ptr", DllStructGetSize($DllBuffer), "dword", 0x00000040, "dword*", 0) ; PAGE_EXECUTE_READWRITE
            DllStructSetData($DllBuffer, 1, $Mod_Bin)
            Local $Module = DllCallAddress('uint', $_MDLoadLibrary, "uint", $LoadLibraryA[0], "uint", $GetProcAddress[0], "struct*", $DllBuffer)
            If $Module[0] = 0 Then Return SetError(1, 0, 0)
            Return $Module[0]
        Case 1; MemoryDllGetFuncAddress
            Local $Address = DllCallAddress("uint", $_MDGetFuncAddress, "uint", $Mod_Bin, "str", $sFuncName)
            If $Address[0] = 0 Then Return SetError(1, 0, 0)
            Return $Address[0]
        Case 2; DllClose
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
