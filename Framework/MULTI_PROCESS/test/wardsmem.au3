#AutoIt3Wrapper_UseX64=n

_Example()

Func _Example()

    Local $MD5Dll = @AutoItExe;'nThread.exe'

    Local $String = "test"
    Local $Digest = DllStructCreate("byte[16]")
    Local $hMD5 = MemoryDllOpen(BinaryRead($MD5Dll))
   Local $iMD5 = MemoryDllGetFuncAddress($hMD5, 'md5')
   DllCallAddress("str", $iMD5, "str", $String, "uint", StringLen($String), "struct*", $Digest)
   MemoryDllClose($hMD5)

    ConsoleWrite('MD5 Hash = ' & DllStructGetData($Digest, 1) & @LF)

EndFunc   ;==>_Example
Func BinaryRead($Filename)
	Local $File = FileOpen($Filename, 16)
	Local $Binary = FileRead($File)
	FileClose($File)
	Return $Binary
EndFunc   ;==>BinaryRead

Func md5($test="")
	Return MsgBox(0,"dafuq","")
EndFunc



; ============================================================================================================================
;  Functions : MemoryDllOpen(), MemoryDllGetFuncAddress(), MemoryDllClose()
;  Purpose   : Embedding DLL In Scripts to Call Directly From Memory
;  Author    : Ward
;  Modified  : Brian J Christy (Beege) - Wrapper Functions
; ============================================================================================================================
Func MemoryDllOpen($DllBinary)
    Local $Call = __MemoryDllCore(0, $DllBinary)
    Return SetError(@error, 0, $Call)
EndFunc   ;==>MemoryDllOpen

Func MemoryDllGetFuncAddress($hModule, $sFuncName)
    Local $Call = __MemoryDllCore(1, $hModule, $sFuncName)
    Return SetError(@error, 0, $Call)
EndFunc   ;==>MemoryDllGetFuncAddress

Func MemoryDllClose($hModule)
    __MemoryDllCore(2, $hModule)
EndFunc   ;==>MemoryDllClose

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