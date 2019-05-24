#include-once
#include 'Array.au3'
#cs
	AutoIt Threads
	http://github.com/jesobreira/thread.au3
#ce
Global $hHandle, $tStruct, $aResult, $dReturn, $aTerminate, $hThread


$hThread = CreateThread(0x0000027254EF0000) ;DllStructGetPtr($struct), 0)

MsgBox(0, "", $hThread )



Func CreateThread($sCallback)
;~ 	Local $hHandle, $tStruct, $aResult, $dReturn
	$hHandle = DllCallbackRegister($sCallback, "int", "ptr")
	If Not $hHandle Then Return False
	$tStruct = DllStructCreate("Char[200];int")
	DllStructSetData($tStruct, 1, 10)
	$aResult = DllCall("kernel32.dll", "hwnd", "CreateThread", "ptr", 0, "dword", 0, "long", DllCallbackGetPtr($hHandle), "ptr", DllStructGetPtr($tStruct), "long", 0, "int*", 0)
	$dReturn = (Not @error And IsArray($aResult)) ? $aResult[0] : SetError(1, 0, False)
	DllCallbackFree($aResult)
	Sleep(50)
	Return $dReturn
EndFunc   ;==>CreateThread

Func TerminateThread($hThread, $dwExitCode = 0)
	If Not IsHWnd($hThread) Then Return False
	$aTerminate = DllCall("kernel32.dll", "bool", "TerminateThread", "handle", $hThread, "dword", $dwExitCode)
	$dReturn = (Not @error And IsArray($aTerminate)) ? $aTerminate[1] : SetError(1, 0, False)
	Sleep(50)
	Return $dReturn
EndFunc   ;==>TerminateThread
