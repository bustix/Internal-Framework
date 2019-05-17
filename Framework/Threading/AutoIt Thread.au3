#include <Array.au3>

Opt("MustDeclareVars", 1)

#cs
Local $R = DllCall("kernel32.dll", "hwnd", "CreateThread", "ptr", 0, "dword", 0, _
                       "LONG_PTR", DllCallbackGetPtr($H), "LONG_PTR", DllStructGetPtr($S), "long", 0, "int*", 0)

#ce

Func Test_1($x)
    Local $Array = _STCBF_Struct($x)
    Local $At = ''
    For $i = 0 To (UBound($Array)-1) Step 1
        $At &= $Array[$i] &' - '
    ;ConsoleWrite("$Array["& $i &"] = "& $Array[$i] &@CRLF )
    Next
    MsgBox(0x40, "Thread-1", "Added Thread #1" &@CRLF&@CRLF& StringLeft($At,(StringLen($At) -3)) )
EndFunc ;==> _Thread_Start

Func Test_2($x)
    Local $Array = _STCBF_Struct($x)
    Local $At = ''
    For $i = 0 To (UBound($Array)-1) Step 1
        $At &= $Array[$i] &' - '
    ;ConsoleWrite("$Array["& $i &"] = "& $Array[$i] &@CRLF )
    Next
    MsgBox(0x40, "Thread-2", "Added Thread #2" &@CRLF&@CRLF& StringLeft($At,(StringLen($At) -3)) )
EndFunc ;==> _Thread_Start

Func Test_3($x)
    Local $Array = _STCBF_Struct($x)
    Local $At = ''
    For $i = 0 To (UBound($Array)-1) Step 1
        $At &= $Array[$i] &' - '
    ;ConsoleWrite("$Array["& $i &"] = "& $Array[$i] &@CRLF )
    Next
    MsgBox(0x40, "Thread-3", "Added Thread #3" &@CRLF&@CRLF& StringLeft($At,(StringLen($At) -3)) )
EndFunc ;==> _Thread_Start

Local $Ax[4] = [100, 'A', 200, 'B']
Local $N = 10
Local $Bx[4] = [300, 'C', 400, 'D']

    _Sub_Thread_CallBack_Func("Test_1", $Ax)
    _Sub_Thread_CallBack_Func("Test_2", $N)
    _Sub_Thread_CallBack_Func("Test_3", $Bx)

MsgBox(0x40, "Thread-0", "## Default_Thread ##")

;#################################################################################################################################################
Func _Sub_Thread_CallBack_Func($F, ByRef $P)
    Local $Px = "", $L = StringLen($P)
    If IsArray($P) Then
        For $i = 0 To (UBound($P)-1) Step 1
            $Px &= $P[$i] &","
        Next
        $Px = StringLeft($Px, (StringLen($Px) -1) )
        $L = StringLen($Px)
        $P = $Px
    EndIf
    Local $H = DllCallbackRegister($F, "int", "DWORD_PTR")
    Local $S = DllStructCreate("INT; Char["& $L &"]")
    DllStructSetData($S, 2, $P)
    DllStructSetData($S, 1, $L)
    Local $R = DllCall("kernel32.dll", "hwnd", "CreateThread", "ptr", 0, "dword", 0, _
                       "long", DllCallbackGetPtr($H), "ptr", DllStructGetPtr($S), "long", 0, "int*", 0)
    ;DllCallbackFree($H)
    ;Return $R
    Sleep(10)
EndFunc
Func _STCBF_Struct(ByRef $x)
    Local $y = DllStructGetData(DllStructCreate("INT; Char["& DllStructGetData(DllStructCreate("INT; Char[1]", $x), 1) &"]", $x), 2)
    Local $Ar = StringSplit($y, ',', 2)
    Return $Ar
EndFunc
;###############################################################################################