Func _CreateStruct($s_Str)
    Local $v_Struct = DllStructCreate('char[' & StringLen($s_Str)+1 & ']')
    DllStructSetData($v_Struct, 1, $s_Str)
    return $v_Struct
EndFunc

$v_Title = _CreateStruct("I Am A Box.")
$v_Text = _CreateStruct("w0uter rocks my world with his h4x.")
$v_Ret = DllStructCreate('byte')

$v_ASM = DllStructCreate( _
    'byte;int;' _   ;01~02 00401000 >    68 00000000                 PUSH 0                                                  ; /Style = MB_OK|MB_APPLMODAL
&   'byte;int;' _   ;03~04 00401005   .  68 07204000                 PUSH Protect.00402007                                   ; |Title = "lpCaption"
&   'byte;int;' _   ;05~06 0040100A   .  68 00204000                 PUSH Protect.00402000                                   ; |Text = "lpText"
&   'byte;int;' _   ;07~08 0040100F      68 00000000                 PUSH 0                                                  ; |hwnd = 0
&   'byte;int;' _   ;09~10 00444448 >    B8 EA04D577                 MOV EAX,USER32.MessageBoxA
&   'byte;byte;' _  ;11~12 0044444D      FFD0                        CALL NEAR EAX
&   'byte;int;' _   ;13~14 00401019      A2 44332211                 MOV BYTE PTR DS:[11223344],AL
&   'byte' _        ;15~15 0040101E      C3                          RETN
)

DllStructSetData($v_ASM, 01, 0x68)
DllStructSetData($v_ASM, 02, 4)

DllStructSetData($v_ASM, 03, 0x68)
DllStructSetData($v_ASM, 04, DllStructGetPtr($v_Title))

DllStructSetData($v_ASM, 05, 0x68)
DllStructSetData($v_ASM, 06, DllStructGetPtr($v_Text))

DllStructSetData($v_ASM, 07, 0x68)
DllStructSetData($v_ASM, 08, 0)

DllStructSetData($v_ASM, 09, 0xB8)

;~ HMODULE WINAPI LoadLibrary(
;~   LPCTSTR lpFileName
;~ );

$v_Lib = DllCall('kernel32.dll', 'int', 'LoadLibrary', 'str', 'user32.dll')

;~ FARPROC WINAPI GetProcAddress(
;~   HMODULE hModule,
;~   LPCSTR lpProcName
;~ );

$v_Msg = DllCall('kernel32.dll', 'int', 'GetProcAddress', 'int', $v_Lib[0], 'str', "MessageBoxA")

DllStructSetData($v_ASM, 10, $v_Msg[0])

;~ BOOL WINAPI FreeLibrary(
;~   HMODULE hModule
;~ );

DllCall('kernel32.dll', 'int', 'FreeLibrary', 'int', $v_Lib[0])

DllStructSetData($v_ASM, 11, 0xFF)
DllStructSetData($v_ASM, 12, 0xD0)

DllStructSetData($v_ASM, 13, 0xA2)
DllStructSetData($v_ASM, 14, DllStructGetPtr($v_Ret, 1))

DllStructSetData($v_ASM, 15, 0xC3)

;-----------------------------------------------------------------------------------------------------------------------------------------

;~ HANDLE WINAPI CreateThread(
;~   LPSECURITY_ATTRIBUTES lpThreadAttributes,
;~   SIZE_T dwStackSize,
;~   LPTHREAD_START_ROUTINE lpStartAddress,
;~   LPVOID lpParameter,
;~   DWORD dwCreationFlags,
;~   LPDWORD lpThreadId
;~ );

;-----------------------------------------------------------------------------------------------------------------------------------------

DllCall('kernel32.dll', 'int', 'CreateThread', 'int', 0, 'int', 0, 'int', DllStructGetPtr($v_ASM), 'int', 0, 'int', 0, 'int', 0)

$i = 0

While DllStructGetData($v_Ret, 1) = 0
    $i += 1
    ToolTip($i)
WEnd

ToolTip('')

MsgBox(0, 'End', 'The Msgbox return was: ' & DllStructGetData($v_Ret, 1))