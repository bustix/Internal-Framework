#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; Binary/text resources.
#AutoIt3Wrapper_Res_File_Add=binary_1.dat, RT_RCDATA, BIN_1, 0
#AutoIt3Wrapper_Res_File_Add=text_1.txt, RT_RCDATA, TXT_1, 0

; Cursor resources.
#AutoIt3Wrapper_Res_File_Add=%AUTOITDIR%\Examples\Helpfile\Extras\horse.ani, RT_ANICURSOR, ANI_CUR_1

; Font resources.
#AutoIt3Wrapper_Res_File_Add=%AUTOITDIR%\Examples\Helpfile\Extras\SF Square Head Bold.ttf, RT_FONT, TTF_1, 0

; Image resources.
#AutoIt3Wrapper_Res_File_Add=bmp_1.bmp, RT_BITMAP, BMP_1, 0
#AutoIt3Wrapper_Res_File_Add=gif_1.gif, RT_RCDATA, GIF_1, 0
#AutoIt3Wrapper_Res_File_Add=jpg_1.jpg, RT_RCDATA, JPG_1, 0
#AutoIt3Wrapper_Res_File_Add=png_1.png, RT_RCDATA, PNG_1, 0
#AutoIt3Wrapper_Res_File_Add=png_1.png, RT_RCDATA, PNG_1, 0
#AutoIt3Wrapper_Res_File_Add=%AUTOITDIR%\Examples\GUI\merlin.gif, RT_RCDATA, MERLIN_1, 0

; Icon resources.
#AutoIt3Wrapper_Res_File_Add=%AUTOITDIR%\Aut2Exe\Icons\SETUP01.ico, RT_ICON, ICO_1, 0
#AutoIt3Wrapper_Res_File_Add=%AUTOITDIR%\Examples\Helpfile\Extras\Script.ico, RT_ICON, ICO_2, 0

; Icon resources added with #AutoIt3Wrapper_Res_Icon_Add and that fail to specify a resource name, start from 201 and up.
; See the AutoIt3Wrapper documentation for more details about this directive.
#AutoIt3Wrapper_Res_Icon_Add=%AUTOITDIR%\Examples\Helpfile\Extras\Soccer.ico

; Sound resources.
#AutoIt3Wrapper_Res_File_Add=C:\WINDOWS\Media\tada.wav, SOUND, WAV_1, 0

; String resources.
#AutoIt3Wrapper_Res_File_Add=string_1.ini, RT_STRING

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include '..\ResourcesEx.au3' ; Improved by guinness.

Global $g_hCursor = 0, $g_hGUI = 0

; Display only if compiled.
If @Compiled Then
	If IsXP() Then
		MsgBox($MB_SYSTEMMODAL, '', 'This example has been created for Vista and above. Therefore it''s recommended you change your system or the example. You choose.')
	Else
		Example()
	EndIf
Else
	MsgBox($MB_SYSTEMMODAL, '', 'Please compile the example before running, as the resouces need to be added to the executable.')
EndIf

Func Example()
	Local Const $iHeight = 450, $iWidth = 470
	$g_hGUI = GUICreate('Resources Example', $iWidth, $iHeight, Default, Default, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX))

	Local $iText_1 = GUICtrlCreateLabel('', 5, 300, 195, 60)
	Local $iDimensions = GUICtrlCreateLabel('', 200, 300, 200, 60)
	Local $iFont = GUICtrlCreateLabel("Different font Loaded from resources", 5, 380, $iWidth - 10, 20)

	Local $iPic_1 = GUICtrlCreatePic('', 0, 0, 200, 100)
	Local $iPic_2 = GUICtrlCreatePic('', 200, 0, 200, 100)
	Local $iPic_3 = GUICtrlCreatePic('', 0, 100, 200, 100)
	Local $iPic_4 = GUICtrlCreatePic('', 200, 100, 200, 100)

	Local $iPic_5 = GUICtrlCreatePic('', 0, 200, 200, 100)

	; Set an image to a picture controlid using an external dll.
	_Resource_SetToCtrlID($iPic_5, '#701', $RT_BITMAP, @SystemDir & '\shell32.dll', True)

	Local $iIcon_1 = GUICtrlCreateIcon(@AutoItExe, 0, 200, 205, 32, 32)

	Local $iLoadCursor = GUICtrlCreateButton('Load Cursor', 5, $iHeight - 30, 85, 25)
	Local $iLoadIcon = GUICtrlCreateButton('Load Icon', 90, $iHeight - 30, 85, 25)
	Local $iLoadSound = GUICtrlCreateButton('Load Sound', 175, $iHeight - 30, 85, 25)
	Local $iSaveFile = GUICtrlCreateButton('Save File', 260, $iHeight - 30, 85, 25)

	Local $iMerlin = GUICtrlCreateButton('', $iWidth - 68, 0, 68, 71)
	_Resource_SetToCtrlID(-1, 'MERLIN_1') ; Use the last controlid.

	Local $iBall = GUICtrlCreateButton('Click', $iWidth - 68, 72, 68, 71, $BS_ICON)
	GUICtrlSetImage($iBall, @AutoItExe, '201') ; Icon resources added with #AutoIt3Wrapper_Res_Icon_Add, can be directly used without the UDF.

	GUISetState(@SW_SHOW, $g_hGUI)

	; Get as a string from the executable's resources.
	Local $sString = _Resource_GetAsString('TXT_1')
	GUICtrlSetData($iText_1, $sString & @CRLF & 'Length: ' & @extended)

	; Get a bitmap image resource.
	Local $hHBITMAP = _Resource_GetAsBitmap('BMP_1', $RT_BITMAP)
	; Set the bitmap image handle to the $iPic_2 controlid.
	_Resource_SetBitmapToCtrlID($iPic_1, $hHBITMAP)

	; Set a gif image resource to a picture controlid.
	_Resource_SetToCtrlID($iPic_2, 'GIF_1')

	; Set a jpg image resource to a picture controlid.
	_Resource_SetToCtrlID($iPic_3, 'JPG_1')

	; Set a png image resource to a picture controlid.
	_Resource_SetToCtrlID($iPic_4, 'PNG_1')

	; Set a font resource to a label.
	_Resource_LoadFont('TTF_1')
	GUICtrlSetFont($iFont, 8, 800, 0, 'SF Square Head', 5)

	; Custom function to display the size of a specific resource.
	GUICtrlSetData($iDimensions, GetImageSize('BMP_1', $RT_BITMAP) & @CRLF & _
			GetImageSize('GIF_1') & @CRLF & _
			GetImageSize('JPG_1') & @CRLF & _
			GetImageSize('PNG_1') & @CRLF)

	Local $bIsCursor = False, $bIsIcon = False
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $iLoadCursor
				If $bIsCursor Then
					; Remove the cursor.
					_WinAPI_SetCursor(0)

					; Unregister the WM_CURSOR message.
					GUIRegisterMsg($WM_SETCURSOR, '')

					; Destroy the cursor handle.
					_WinAPI_DestroyCursor($g_hCursor)
					$g_hCursor = 0
				Else
					; Retrieve the animated cursor and set to the current instance.
					$g_hCursor = _Resource_GetAsCursor('ANI_CUR_1', $RT_ANICURSOR)
					_WinAPI_SetCursor($g_hCursor)

					; Register the WM_CURSOR message to reinstate the cursor after is passes over a static control.
					GUIRegisterMsg($WM_SETCURSOR, WM_SETCURSOR)
				EndIf
				$bIsCursor = Not $bIsCursor

			Case $iLoadIcon
				If $bIsIcon Then
					_Resource_SetIconToCtrlID($iIcon_1, 0) ; Clear the icon.
				Else
					_Resource_SetToCtrlID($iIcon_1, 'ICO_2', $RT_ICON, Default, True)
					#cs
						; Workaround for re-sizing the icon control.
						Local $hParent = _WinAPI_GetParent(GUICtrlGetHandle($iIcon_1))
						Local $aWinGetPos = WinGetPos($hParent)
						_WinAPI_MoveWindow($hParent, $aWinGetPos[0], $aWinGetPos[1], $aWinGetPos[2], $aWinGetPos[3] + 1)
						_WinAPI_MoveWindow($hParent, $aWinGetPos[0], $aWinGetPos[1], $aWinGetPos[2], $aWinGetPos[3] - 1)
					#ce
				EndIf
				$bIsIcon = Not $bIsIcon

			Case $iLoadSound
				; Play a wav file from the executable's resources (sync/async).
				_Resource_LoadSound('WAV_1')
				_Resource_LoadSound('WAV_1', $SND_ASYNC)

			Case $iBall, $iMerlin
				MsgBox($MB_SYSTEMMODAL, '', 'An example of an icon or image on a button.', 3, $g_hGUI)

			Case $iSaveFile
				; Save binary data stored in the executable's resources.
				_Resource_SaveToFile(@ScriptDir & '\binary_data_1.dat', 'BIN_1')
				ShellExecute(@ScriptDir)

		EndSwitch
	WEnd

	; Destroy all the resource handles.
	_Resource_DestroyAll()

	; Delete the GUI.
	GUIDelete($g_hGUI)
	Return True
EndFunc   ;==>Example

Func GetImageSize($sResName, $iResType = $RT_RCDATA)
	Local $sString = ''
	Local $hImage = _Resource_GetAsImage($sResName, $iResType)
	If Not @error Then
		Local $iSize = @extended
		Local $iWidth = _GDIPlus_ImageGetWidth($hImage)
		Local $iHeight = _GDIPlus_ImageGetHeight($hImage)
		$sString = $sResName & ' is: ' & $iWidth & ' x ' & $iHeight & ' and ' & $iSize & ' byte' & (($iSize = 1) ? '' : 's') & '.'
	EndIf
	Return $sString
EndFunc   ;==>GetImageSize

Func IsXP()
	Return $__WINVER < 0x0600
EndFunc   ;==>IsXP

Func WM_SETCURSOR($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $wParam, $lParam
	If $hWnd = $g_hGUI And $g_hCursor Then
		Return _WinAPI_SetCursor($g_hCursor)
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SETCURSOR
