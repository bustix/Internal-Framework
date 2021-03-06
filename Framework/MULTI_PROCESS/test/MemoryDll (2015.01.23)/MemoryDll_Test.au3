#Include <GDIPlus.au3>
#Include <GUIConstantsEx.au3>
#Include <File.au3>
#Include "MemoryDll.au3"

Test1()
Test2()
Test3()
Test4()
Test5()

Func Test1()
	MsgBox(64, "Test1", "Call functions in AutoItX3.dll by name or by ordinal value...")

	Local $AutoItX3Dll = GetAutoItFile(@AutoItX64 ? "AutoItX\AutoItX3_x64.dll" : "AutoItX\AutoItX3.dll")
	If Not $AutoItX3Dll Then Return MsgBox(16, "Test1", "Cannot find AutoItX3.dll")

	Local $AutoItX3Binary = BinaryRead($AutoItX3Dll)
	Local $Dll = MemoryDllOpen($AutoItX3Binary)
	Local $Pos = DllStructCreate("struct; long X;long Y; endstruct")

	MemoryDllCall($Dll, "none", "AU3_MouseGetPos", "struct*", $Pos)
	Local $X = DllStructGetData($Pos, "x"), $Y = DllStructGetData($Pos, "y")
	MemoryDllCall($Dll, "none", "AU3_ToolTip", "wstr", "Hello message from AutoItX3.dll", "int", $X + 20, "int", $Y)
	MemoryDllCall($Dll, "none", "AU3_Sleep", "uint", 2000)
	MemoryDllCall($Dll, "none", "AU3_ToolTip", "wstr", "", "int", 0, "int", 0)

	MemoryDllCall($Dll, "none", 0x2D, "struct*", $Pos)
	Local $X = DllStructGetData($Pos, "x"), $Y = DllStructGetData($Pos, "y")
	MemoryDllCall($Dll, "none", 0x43, "wstr", "Another message, located function's address by ordinal value", "int", $X + 20, "int", $Y)
	MemoryDllCall($Dll, "none", 0x40, "uint", 2000)
	MemoryDllClose($Dll)
EndFunc

Func Test2()
	MsgBox(64, "Test2", "Call function in test.dll that need msgbox.dll (msgbox.dll must be loaded with a given name)...")

	;   /* C source of msgbox.dll */
	;
	;	#include <windows.h>
	;	void msgbox(char* msg) {
	;		MessageBox(NULL, msg, "I am msgbox.dll", MB_OK);
	;	}
	;
	;   /* C source of test.dll */
	;
	;	void msgbox(char* msg);
	;	void test() {
	;		msgbox("I am test.dll, I call a function in msgbox.dll");
	;	}

	Local $Code, $MsgboxDll, $TestDll, $Dll
	If @AutoItX64 Then
		$Code = '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' & _
				'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' & _
				'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' & _
				'bHRPPKQ+BtWpdKWmlFy32KifncU/r+bnzDAYsDLIG8x3UKr9qGd/RqBO0zLJznpiV3KuCm4SfdRNoh4joa+OTbhzC4Dm8PoZe5YT8fREL2zrKyyxRpK2d9RL1v1zYYNE9EUCrEjuDhG6KXLBKDKRBXMif8heNyFDwzDbTHT5AOerkKGa9Es+I5o7NUVMH4zTpPA/+Hcn+9UqWUG6A2SmDNnvdM5fgYAVbmZ59PdhySKcVuEMTUY5iULLtpGkUBb/t2wHGcRJsp6KVzWgnTApBAZlBiIVA/ZLmcQsxEQwzZRlhtzlhnaeUEqfxIqJw6BxTl5kmFhm/TUs7inIJJDVv9Aj9eGc5jHL+h0+kxZXVBd/Gh6PASie1kd7qsjrFW7zq0iJVvPh2U+XlBWOAczNZreXOzxj0jd2KoXGlM6zOfTUWnRNJ++7sMJRFhQB415MDS8Mx0SwYA2mYTLwVsRwuEH3lDm9rWcPNo1fstIXvaujIvw/jvIGYOL12fS8DX1v9IuKt1AmFfmGJPrNvkpAQR3sfkoshu8kXivajWNgGb50az+76vOkAwcUA1dCLFuvKs2JTJDepGuN1/Lxzpxm3X98M8C/TeZ+Tlfm++GoQ4K8Ql09gX7DxRbYesMtv++AF0CLWtw+U46wv9Enp5zKDfv1N+yf07xTrH/cEgDg+r4vZJMXDXWDjUAEv8r54l7ex2BzVmOpfXHL1lsYM664sXMCaEX/9oQ6wgrbXwIYikl/MhdOCJ3BTDK2LYcZZZ9xkUU2tEvMGGCSqUgc0YCRZ9oo3jLOzgVsLHNkurwWg9WYaK6GQc9fGjpvWOeqP3lPzcRgnq1MB9FaVpoHfYgcG7BJquS64+G/GfcR1WG5k8oaf9pDjFOYV07F3vlwxEdR6Ld1OKsn903HiRiaiC/dy6CPQIph06Cq3m6uNwKSxrFss+MFlR1LaY1+C/XY96oYuEOP7jDfcpEpKuyIZtzTaNP7NxyMhTXv9TTW4foqpPBvbY5SfnQkc0YsjYsZ22k7ag/ltG2GXN8qi8Ew8TTwnNgHwYeYhG59jvXHd/EmCEZLrwA='
		$MsgboxDll = _BinaryCall_LzmaDecompress(_BinaryCall_Base64Decode($Code))

		$Code = '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' & _
				'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' & _
				'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' & _
				'CY9ZV+0RuWiPY9hA3OoN6fPZy+7YS3+9KW7FDoFtL1pfLku7nGo6zQcrLIRK0rLIc2GTYCiYrVfM0YcV+kvja6fZUX8jMnv5FEtQkkOatTihNVUa1amTJkXlUxEkziQE6mnJwcnBv7fNiPy7DQtCKq2WJI3zZoPKvVBTJKUMKO16nmYHuBjTGkVnuSg8D3OFQen61z1idhJH1DkaRjLcwvWBHWCh73ncOUq/bJb8f/gTCccyQhO9IEAz9/4VcVnjUJwoqV0q2ksNf2BF8813wAsxda+DEMbivlTksr8njIz9AYJPeH51JN+VIgm6ihbSHKC8ftFb89ncUxoRxg6YyndsTk3SXcN3nOwI7tfB4Ot0xvWcG/rKXi5Die3zfu0/Flfm0lLxp4vwUHWsQbbpw7RPnzgvZRz3i09SOInEBCWH5Yje0Sz9rgrlmQHguY0zOoKihR7e9TeSszua7iMDits5IKBIrr01eSc2XuVOOnRi7aMtVKQCKsFJ2Q6XEubF89oe6toHLL/cIwgUOb0VZqgNXfdMuFbLaQNkAlpTcJm2pIbX3oRAsUE1/FmVk944EVMicxSw6ZKmq4/wTM4MHTBCkR0E/a9dVW79xXpngzHh1n8Cpro041gE0qXzya97E9JjH0WbgM/zxLwsFUV4bm1s5bnsF35lgi9OmkIV1ATbTMZ4y/VxCwdrk/+s0MDPFUn/aZ2gnZbv/MCw95prTngBF18ihWMWoqxMvgmNDDa4IKLUjfi1Pte7sggdPoNN3aP2wfBL62oHAPmUnzS73NjWYzKh8NHdk8eT1WTNFmsVqpHImHO+4srI6DQXU+tZDl1cq1na+bdQAvAl5/++XfLVYlJYvcpuMqT4gQHXLebvmgHeSnOZvYDeHQB19RGunuADevNXuBibDDqepouAjklMgSPWyLlfRMSiGXEM54XMps0fcSoDlx4PjZCqA+t5bub579NrzPM+eLSjXSLV5RRoQwWbHW3ejyobAtyiCqLqM8bFXZAb/tU6FbOpovHdrA58Cxj1bN8HQjSCpJisRSdK73nTtiNicAAlIzjKqRflXIey5gA='
		$TestDll = _BinaryCall_LzmaDecompress(_BinaryCall_Base64Decode($Code))

		$Dll = MemoryDllOpen($MsgboxDll, "msgbox_x64.dll")
	Else
		$Code = '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' & _
				'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' & _
				'yz3Uy5UAAA=='
		$MsgboxDll = _BinaryCall_LzmaDecompress(_BinaryCall_Base64Decode($Code))

		$Code = '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' & _
				'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' & _
				'/uQH6l+VcC2bLTSAeVwA'
		$TestDll = _BinaryCall_LzmaDecompress(_BinaryCall_Base64Decode($Code))

		$Dll = MemoryDllOpen($MsgboxDll, "msgbox.dll")
	EndIf

	MemoryDllCall($TestDll, "none:cdecl", "test")
	MemoryDllClose($Dll)
EndFunc

Func Test3()
	MsgBox(64, "Test3", "Load some string resources (String Tables) from AutoIt3.exe...")

	Local $AutoItExeBinary = BinaryRead(@AutoItExe)
	Local $Dll = MemoryDllOpen($AutoItExeBinary)

	Local $Msg, $Str
	For $i = 110 To 130
		$Str = MemoryDllLoadString($Dll, $i)
		If $Str Then $Msg &= StringFormat("%d: %s\n", $i, $Str)
	Next

	MsgBox(0, 'Test3', $Msg)
	MemoryDllClose($Dll)
EndFunc

Func Test4()
	MsgBox(64, "Test4", 'Load binary resource from "Examples\Helpfile\Extras\Resources.dll" (for AutoIt x86 only, x64 version will skip this test)')
	If @AutoItX64 Then Return

	Local $ResourcesDllPath = GetAutoItFile("Examples\Helpfile\Extras\Resources.dll")
	If Not $ResourcesDllPath Then Return MsgBox(16, "Test1", "Cannot find Resources.dll")

	Local $ResourcesDllBinary = BinaryRead($ResourcesDllPath)
	Local $JpegFile = MemoryDllLoadResource($ResourcesDllBinary, "JPEG", 1)

	_GDIPlus_Startup()
	Local $GUI = GUICreate("Test 4", 350, 350)
	GUISetState(@SW_SHOW)

	Local $Graphics = _GDIPlus_GraphicsCreateFromHWND($GUI)
	Local $Bitmap = _GDIPlus_BitmapCreateFromMemory($JpegFile)
	_GDIPlus_GraphicsDrawImage($Graphics, $Bitmap, 0, 0)

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	_GDIPlus_BitmapDispose($Bitmap)
	_GDIPlus_GraphicsDispose($Graphics)
	_GDIPlus_Shutdown()
	GUIDelete($GUI)
EndFunc

Func Test5()
	MsgBox(64, "Test5", 'Load and run Au3Info.exe file (this test will not return)')

	Local $Au3InfoPath = GetAutoItFile(@AutoItX64 ? "Au3Info_x64.exe" : "Au3Info.exe")
	If Not $Au3InfoPath Then Return MsgBox(16, "Test5", "Cannot find Au3Info.exe")
	Local $Au3InfoBinary = BinaryRead($Au3InfoPath)

	MemoryDllRun($Au3InfoBinary)
	If @Error Then MsgBox(16, "Test5", "Unable to execute this exefile")
EndFunc

Func GetAutoItFile($FilePath)
	Local $InstallDir = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir')
	If Not $InstallDir Then
		Local $Drive, $Dir, $Filename, $Ext
		_PathSplit(@AutoItExe, $Drive, $Dir, $Filename, $Ext)
		$InstallDir = StringRegExpReplace($Drive & $Dir, "\\$", "")
	EndIf

	Local $FullPath = $InstallDir & "\" & $FilePath
	Return FileExists($FullPath) ? $FullPath : SetError(1, 0, "")
EndFunc

Func BinaryRead($Filename)
	Local $File = FileOpen($Filename, 16)
	Local $Binary = FileRead($File)
	FileClose($File)
	Return $Binary
EndFunc
