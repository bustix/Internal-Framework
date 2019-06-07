#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <NomadMemory.au3>

HotKeySet('{ESC}','Exit1')

Global $var,$var_old
ConsoleWrite('Looking for the pointer for $var ...' &@CRLF)
$var_pointer = GetVariablePointer($var,0.01)
If Not $var_pointer Then Exit
ConsoleWrite('PID: '&@AutoItPID&@CRLF)
ConsoleWrite('Pointer for $var: '&$var_pointer&@CRLF)

ConsoleWrite('Waiting for $var to change from outside... '&@CRLF)
ConsoleWrite('$var_pointer : '&$var_pointer&@CRLF)
ConsoleWrite('$var : '&$var&@CRLF)
While Sleep(100)
    If $var <> $var_old Then
        ConsoleWrite('$var changed to: '&$var&@CRLF)
        $var_old = $var
    EndIf
WEnd





Func GetVariablePointer(ByRef $Variable,$iScanRange = 0.1,$Autoit_hMem = 0)
    If Not IsArray($Autoit_hMem) Then
        Local $hMem = _MemoryOpen(@AutoItPID) ; Open the memory of this Autoit
        If @error Then Return SetError(@ScriptLineNumber) ; Error opening the memory
    Else
        Local $hMem = $Autoit_hMem
    EndIf

    Local Const $UniqueValue = -1234562457
    Local $SavedValue = $Variable,$VariablePtr,$PtrFound
    $Variable = DllStructCreate('int') ; Create variable as struct to get its pointer
    $VariablePtr = Number(DllStructGetPtr($Variable)) ; Get the pointer for the struct variable
    $Variable = $UniqueValue ; Change the variable "back" to normal autoit variable

    For $NewPtr = Int($VariablePtr*(1-$iScanRange)) To Int($VariablePtr*(1+$iScanRange))

        ; Check if the value of the pointer is equal to $variable. If so then there is high chance that we found it
        If _MemoryRead($NewPtr, $hMem,'int') <> $Variable Then ContinueLoop
        ; If this area executed then $variable must be equal to $data_from_memread
        ; next: Check if the founded pointer is correct one
        $Variable = 1 ; Set the $variable to be 1
        If _MemoryRead($NewPtr, $hMem,'int') = $Variable Then ; Check again if the value we got using this pointer is equal to $variable
            ; YES!! we found it! this is the correct pointer
            $PtrFound = 1
            ExitLoop ; Exit now to continue to the magic
        Else
            ; if not then this is the worng one :( so we try again and reset...
            $Variable = $UniqueValue
        EndIf
    Next
    $Variable = 0
    If IsArray($Autoit_hMem) Then _MemoryClose($Autoit_hMem)
    If $PtrFound Then Return Ptr($NewPtr)
    Return SetError(@ScriptLineNumber,0,0) ; Failed to find the pointer
EndFunc

Func Exit1()
    Exit
EndFunc