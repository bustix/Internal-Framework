#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Tool.ico
#AutoIt3Wrapper_Outfile=HttpHeaderWatcher.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=Retrieve Http Request Headers and re-create it in a AutoIt script.
#AutoIt3Wrapper_Res_Fileversion=1.0.1.3
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region    ;************ Includes ************
#include <GUIListView.au3>
#EndRegion ;************ Includes ************

Opt ( 'GUIOnEventMode', 1 )
Opt ( 'WinWaitDelay', 0 )
Opt ( 'TrayMenuMode', 1 )
Opt ( 'GUICloseOnESC', 0 )
Opt ( 'MustDeclareVars', 1 )
If Not _Singleton ( @ScriptName, 1 ) Then Exit
OnAutoItExitRegister ( '_OnAutoItExit' )

#Region ------ Global Variables ------------------------------
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_SIZEBOX = 0x00040000
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_HSCROLL = 0x00100000
Global Const $WS_VSCROLL = 0x00200000
Global Const $WS_EX_CLIENTEDGE = 0x00000200
Global Const $WM_NOTIFY = 0x004E
Global Const $WM_GETMINMAXINFO = 0x0024
Global Const $NM_FIRST = 0
Global Const $NM_CLICK = $NM_FIRST - 2
Global Const $ES_READONLY = 2048
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $hNTDLL    = DllOpen ( 'ntdll.dll' )
Global Const $hKernel32 = DllOpen ( 'kernel32.dll' )
Global Const $hIPHLPAPI = DllOpen ( 'iphlpapi.dll' )
Global Const $hWS232    = DllOpen ( 'ws2_32.dll' )
Global Const $hPSAPI    = DllOpen ( 'psapi.dll' )
Global Const $hWTSAPI32 = DllOpen ( 'wtsapi32.dll' )
Global Const $hADVAPI32 = DllOpen ( 'advapi32.dll' )
Global $sSystemModule, $AF_INET = 2, $AF_INET6 = 23
Global $pcap, $aPcapDevices, $packet
Global $hGui, $iWMin, $iHMin, $hListView, $iSelectedItem, $aPosBak, $iCapture, $iListviewClear, $iComboDisable
Global $idButtonStartCapture, $idButtonCreateAu3, $idButtonCopyRequest, $idButtonCopyResponse, $idButtonAbout, $idButtonExit, $idButtonClear, $idLabelIndex
Global $idComboInterface, $idEditRequest, $idEditResponse
Global $aRequest[1], $aAcknowledgment[1], $aResponse[1], $aSequence[1]
Global $sCurrentSel, $sCurrentSelOld, $aTCPTable[1][4]
Global $sRegTitleKey = 'HttpHeaderWatcher'
Global $sRegKeySettings = 'HKCU\Software\' & $sRegTitleKey & '\Settings'
Global $hPcapDll, $hPacketDll, $Pcap_errbuf, $Pcap_ptrhdr, $Pcap_ptrpkt, $Pcap_statV, $Pcap_statN, $Pcap_starttime, $Pcap_timebias
Global $sTempDir = @TempDir & '\HHW'
Global $sSoftTitle = 'HttpHeaderWatcher' & ' v' & _ScriptGetVersion () & ' by wakillon'
; TaskDialog Global Variables :
Global $_TDL_TaskDialogDll = DllOpen ( 'comctl32.dll' ), $_TDL_fUseXTaskDlg = False
_TaskDialog_LoadDLL () ; native dll is used since Vista
Global Const $TDF_ENABLE_HYPERLINKS = 1
Global Const $TDF_USE_COMMAND_LINKS = 16
Global Const $TDCBF_CLOSE_BUTTON = 32
Global Const $TDCBF_CANCEL_BUTTON = 8
Global Const $TD_INFORMATION_ICON = 65533
Global Const $TDN_HYPERLINK_CLICKED = 3
Global $__TDL__ALIGN = 'align 4;'
If $_TDL_fUseXTaskDlg Then $__TDL__ALIGN = ''
Global Const $tagTASKDIALOGCONFIG = $__TDL__ALIGN & 'UINT cbSize;HWND hwndParent;handle hInstance;dword dwFlags;int dwCommonButtons;ptr pszWindowTitle;ptr MainIcon;' & _
	'ptr pszMainInstruction;ptr pszContent;UINT cButtons;ptr pButtons;int nDefaultButton;UINT cRadioButtons;ptr pRadioButtons;int nDefaultRadioButton;ptr pszVerificationText;' & _
	'ptr pszExpandedInformation;ptr pszExpandedControlText;ptr pszCollapsedControlText;ptr FooterIcon;ptr pszFooter;ptr pfCallback;LONG_PTR lpCallbackData;UINT cxWidth;'
#EndRegion --- Global Variables ------------------------------

#Region ------ Init ------------------------------
TCPStartup()
$sSystemModule = _SystemModuleInformation ()
If _PcapSetup () = -1 Then
	ShellExecute ( 'http://www.winpcap.org/install/default.htm' )
	Exit MsgBox ( 262144+16, 'Exiting on error !', 'WinPcap not found !' & @CRLF & 'Download and Install WinPcap first !', 8 )
EndIf
$aPcapDevices = _PcapGetDeviceList ()
If $aPcapDevices = -1 Then Exit MsgBox ( 262144+16, 'Exiting on error ' & _PcapGetLastError (), 'No Devices found !', 5 )
_FileInstall ()
_Gui ()
_GuiCtrlComboSetData ()
_TrayMenu ()
#EndRegion --- Init ------------------------------

#Region ------ Main Loop ------------------------------
While 1
	$sCurrentSel = _GUICtrlListView_GetSelectedIndices ( $hListView )
	If $sCurrentSel <> $sCurrentSelOld Then
		If $sCurrentSel <> '' Then
			_GuiCtrlEditSetData ( $sCurrentSel )
			$sCurrentSelOld = $sCurrentSel
		EndIf
	EndIf
	If $iCapture = 1 Then
		If IsPtr ( $pCap ) Then ; If $pCap is a Ptr, then the capture is running
			If _PcapIsPacketReady ( $pCap ) Then
				$packet = _PcapGetPacket ( $pCap )
;~              [0]: (string) Time the packet was received (format hh:mm:ss.ususus)
;~              [1]: (int) Captured length
;~              [2]: (int) Packet length
;~              [3]: (binary) Packet Data
				If Not IsInt ( $packet ) Then _PacketExtractData ( $packet[3] )
			EndIf
		Else
			Exit MsgBox ( 262144+16, 'Exiting on error ' & _PcapGetLastError (), 'Capture is not running !', 5 )
		EndIf
	EndIf
	Sleep ( 30 )
WEnd
#EndRegion --- Main Loop ------------------------------

Func _ArrayDelete4D ( ByRef $avInput, $iElement ) ; by Psalty
	If ( Not IsArray ( $avInput ) ) Or ( Not IsInt ( $iElement ) ) Then Return SetError ( 1, 0, 0 )
	Local $e, $f, $g, $h
	Local $avUbounds[UBound ( $avInput, 0 ) + 1] = [UBound ( $avInput, 0 )]
	For $e = 1 to $avUbounds[0]
		$avUbounds[$e] = UBound ( $avInput, $e )
	Next
	If $avUbounds[0] > 4 Then Return SetError ( 2, 0, 0 )
	If $avUbounds[1] = 1 Then Return SetError ( 3, 0, 0 )
	If $iElement > $avUbounds[1] - 1 Or $iElement < 0 Then Return SetError ( 4, 0, 0 )
	If $iElement <> $avUbounds[1] - 1 Then
		For $e = $iElement To $avUbounds[1] - 2
			Switch $avUbounds[0]
				Case 1
					$avInput[$e] = $avInput[$e + 1]
				Case 2
					For $f = 0 To $avUbounds[2] - 1
						$avInput[$e][$f] = $avInput[$e + 1][$f]
					Next
				Case 3
					For $f = 0 To $avUbounds[2] - 1
						For $g = 0 To $avUbounds[3] - 1
							$avInput[$e][$f][$g] = $avInput[$e + 1][$f][$g]
						Next
					Next
				Case 4
					For $f = 0 To $avUbounds[2] - 1
						For $g = 0 To $avUbounds[3] - 1
							For $h = 0 To $avUbounds[4] - 1
								$avInput[$e][$f][$g][$h] = $avInput[$e + 1][$f][$g][$h]
							Next
						Next
					Next
			EndSwitch
		Next
	EndIf
	Switch $avUbounds[0]
		Case 1
			ReDim $avInput[$avUbounds[1] - 1]
		Case 2
			ReDim $avInput[$avUbounds[1] - 1][$avUbounds[2]]
		Case 3
			ReDim $avInput[$avUbounds[1] - 1][$avUbounds[2]][$avUbounds[3]]
		Case 4
			ReDim $avInput[$avUbounds[1] - 1][$avUbounds[2]][$avUbounds[3]][$avUbounds[4]]
	EndSwitch
	Return 1
EndFunc ;==> _ArrayDelete4D ()

Func _Base64Decode ( $input_string ) ; by trancexx
	Local $struct = DllStructCreate ( 'int' )
	Local $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', 0, 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 1, 0, '' )
	Local $a = DllStructCreate ( 'byte[' & DllStructGetData ( $struct, 1) & ']' )
	$a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', DllStructGetPtr ( $a ), 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
	If @error Or Not $a_Call[0] Then Return SetError ( 2, 0, '' )
	$struct = 0
	Return DllStructGetData ( $a, 1 )
EndFunc ;==> _Base64Decode ()

Func _Exit ()
	$iCapture = 0
	_GuiCtrlPicButton_SimulateAction ( $idButtonExit, 1 )
	$aRequest = 0
	$aAcknowledgment = 0
	$aResponse = 0
	$aSequence = 0
	If IsPtr ( $pCap ) Then _PcapStopCapture ( $pCap )
	$pCap = 0
	_PcapFree ()
	Exit
EndFunc ;==> _Exit ()

Func _FileGetFullNameByUrl ( $sFileUrl )
	Local $aFileName = StringSplit ( $sFileUrl, '/' )
	If Not @error Then Return $aFileName[$aFileName[0]]
EndFunc ;==> _FileGetFullNameByUrl ()

Func _FileInstall ()
	If Not FileExists ( $sTempDir ) Then DirCreate ( $sTempDir )
	RegWrite ( 'HKCU\Software\Microsoft\WINDOWS\CurrentVersion\Explorer\Advanced', 'EnableBalloonTips', 'REG_DWORD', 0x00000001 ) ; Enable Balloon Tips
	If Not FileExists ( $sTempDir & '\ButtonStopRed.jpg' ) Then  Buttonstopredjpg ( 'ButtonStopRed.jpg', $sTempDir )
	If Not FileExists ( $sTempDir & '\ButtonStartGreen.jpg' ) Then Buttonstartgreenjpg ( 'ButtonStartGreen.jpg', $sTempDir )
	If Not FileExists ( $sTempDir & '\ButtonRequestOrange2.jpg' ) Then Buttonrequestorange2Jpg ( 'ButtonRequestOrange2.jpg', $sTempDir )
	If Not FileExists ( $sTempDir & '\ButtonResponseOrange2.jpg' ) Then Buttonresponseorange2Jpg ( 'ButtonResponseOrange2.jpg', $sTempDir )
	If Not FileExists ( $sTempDir & '\ButtonClearOrange1.jpg' ) Then Buttonclearorange1Jpg ( 'ButtonClearOrange1.jpg', $sTempDir )
	If Not FileExists ( $sTempDir & '\ButtonCreateAu3Orange.jpg' ) Then Buttoncreateau3Orangejpg ( "ButtonCreateAu3Orange.jpg", $sTempDir )
	If Not FileExists ( $sTempDir & '\ButtonHelpOrange1.jpg' ) Then Buttonhelporange1Jpg ( 'ButtonHelpOrange1.jpg', $sTempDir )
	If Not FileExists ( $sTempDir & '\ButtonExitRed.jpg' ) Then Buttonexitredjpg ( 'ButtonExitRed.jpg', $sTempDir )
	If Not FileExists ( 'C:\Tool.ico' ) Then ToolIco ( "Tool.ico", 'C:' )
EndFunc ;==> _FileInstall ()

Func _GetExtendedTcpTable () ; by trancexx modified.
	Local $aCall = DllCall ( $hIPHLPAPI, 'dword', 'GetExtendedTcpTable', 'ptr*', 0, 'dword*', 0, 'int', 1, 'dword', $AF_INET, 'dword', 4, 'dword', 0 ) ; TCP_TABLE_OWNER_PID_CONNECTIONS = 4
	If @error Then Return SetError ( 1, 0, 0 )
	If $aCall[0] <> 122 Then Return SetError ( 2, 0, 0 ) ; ERROR_INSUFFICIENT_BUFFER
	Local $iSize = $aCall[2]
	Local $tByteStructure = DllStructCreate ( 'byte[' & $iSize & ']' )
	$aCall = DllCall ( $hIPHLPAPI, 'dword', 'GetExtendedTcpTable', 'ptr', DllStructGetPtr ( $tByteStructure ), 'dword*', $iSize, 'int', 1, 'dword', $AF_INET, 'dword', 4, 'dword', 0 ) ; TCP_TABLE_OWNER_PID_CONNECTIONS = 4
	If @error Or $aCall[0] Then Return SetError ( 3, 0, 0 )
	Local $tMIB_TCPTABLE_OWNER_PID_DWORDS = DllStructCreate ( 'dword[' & Ceiling ( $iSize / 4 ) & ']', DllStructGetPtr ( $tByteStructure ) )
	Local $iTCPentries = DllStructGetData ( $tMIB_TCPTABLE_OWNER_PID_DWORDS, 1 )
	Local $iUBound = UBound ( $aTCPTable ) -1
	ReDim $aTCPTable[ $iUBound+$iTCPentries + 1][4]
	Local $aProcesses = ProcessList ()
	Local $iOffset
	Local $iIP
	For $i = 1 To $iTCPentries
		$iOffset = ( $i - 1 ) * 6 + 1
		$iIP = DllStructGetData ( $tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 2 )
		If DllStructGetData ( $tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 1 ) < 3 Then
			$aTCPTable[$i+$iUBound][1] = '-'
		Else
			$iIP = DllStructGetData ( $tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 4 )
			$aTCPTable[$i+$iUBound][1] = BitOR ( BinaryMid ( $iIP, 1, 1 ), 0 ) & '.' & BitOR ( BinaryMid ( $iIP, 2, 1 ), 0 ) & '.' & BitOR ( BinaryMid ( $iIP, 3, 1 ), 0 ) & '.' & BitOR ( BinaryMid ( $iIP, 4, 1 ), 0 )
		EndIf
		$aTCPTable[$i+$iUBound][2] = DllStructGetData ( $tMIB_TCPTABLE_OWNER_PID_DWORDS, 1, $iOffset + 6 )
		If $aTCPTable[$i+$iUBound][2] Then
			For $j = 1 To $aProcesses[0][0]
				If $aProcesses[$j][1] = $aTCPTable[$i+$iUBound][2] Then
					$aTCPTable[$i+$iUBound][0] = $aProcesses[$j][0]
					$aTCPTable[$i+$iUBound][3] = _GetPIDFileName ( $aProcesses[$j][1] )
					If Not $aTCPTable[$i+$iUBound][0] Then $aTCPTable[$i+$iUBound][0] = $aProcesses[$j][0]
					ExitLoop
				EndIf
			Next
		EndIf
	Next
	$tByteStructure = 0
	$tMIB_TCPTABLE_OWNER_PID_DWORDS = 0
;~  $aTCPArray[n][0] = process name
;~  $aTCPArray[n][1] = destination ip
;~  $aTCPArray[n][2] = process OwnerPid
;~  $aTCPArray[n][3] = process path
	Return $aTCPTable
EndFunc ;==> _GetExtendedTcpTable ()

Func _GetPIDFileName ( $iPID ) ; by trancexx
	Local $aCall = DllCall ( $hKernel32, 'ptr', 'OpenProcess', 'dword', 1040, 'int', 0, 'dword', $iPID )
	If @error Or Not $aCall[0] Then Return SetError ( 1, 0, '' )
	Local $hProcess = $aCall[0]
	$aCall = DllCall ( $hPSAPI, 'dword', 'GetModuleFileNameExW', 'handle', $hProcess, 'ptr', 0, 'wstr', '', 'dword', 32767 )
	If @error Or Not $aCall[0] Then
		DllCall ( $hKernel32, 'bool', 'CloseHandle', 'handle', $hProcess )
		Return SetError ( 2, 0, '' )
	EndIf
	Local $sFilename = $aCall[3]
	DllCall ( $hKernel32, 'bool', 'CloseHandle', 'handle', $hProcess )
	Return $sFilename
EndFunc ;==> _GetPIDFileName ()

Func _Gui ()
	$hGui = GUICreate ( $sSoftTitle, 1000, 580, -1, -1, BitOR ( $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SYSMENU, $WS_SIZEBOX ) )
	GUISetIcon ( 'C:\Tool.ico' )
	GUISetFont ( 9, 500, 1, 'Comic Sans MS' )
	Local $aPos = WinGetPos( $hGui )
	$iWMin = $aPos[2]
	$iHMin = $aPos[3]
	GUISetOnEvent ( $GUI_EVENT_CLOSE, '_Exit' )
	GUICtrlCreateLabel ( 'Select Device :', 20, 22, 100, 20 )
	$idComboInterface = GUICtrlCreateCombo ( '', 130, 20, 680, 20 )

	#Region ------ ListView ------------------------------
	$hListView = GUICtrlCreateListView( 'N°', 20, 60, 790, 310, BitOR ( $LVS_SHOWSELALWAYS, $LVS_SINGLESEL ) )
	_GUICtrlListView_SetExtendedListViewStyle ( GUICtrlGetHandle ( -1 ), BitOR ( $LVS_EX_FULLROWSELECT, $WS_EX_CLIENTEDGE, $LVS_EX_DOUBLEBUFFER ) )
	_GUICtrlListView_SetColumnWidth ( $hListView, 0, 40 )
	_GUICtrlListView_AddColumn ( $hListView, 'Url', 510 )
	_GUICtrlListView_AddColumn ( $hListView, 'Process Name', 120 )
	_GUICtrlListView_AddColumn ( $hListView, 'Destination IP:Port', 120 )
	_GUICtrlListView_AddColumn ( $hListView, 'Pid', 40 )
	_GUICtrlListView_AddColumn ( $hListView, 'Time', 120 )
	#EndRegion --- ListView ------------------------------

	GUICtrlCreateGroup( '', 830, 15, 150, 355 )
	Local $y = 20

	#Region ------ Buttons ------------------------------
	$idButtonStartCapture = GUICtrlCreatePic ( $sTempDir & '\ButtonStartGreen.jpg', 850, $y+30, 110, 28 )
	GUICtrlSetTip ( -1, 'Start Packets Capture', ' ', 1, 1 )
	GUICtrlSetOnEvent ( -1, '_PacketStartCapture' )
	$idButtonCreateAu3 = GUICtrlCreatePic ( $sTempDir & '\ButtonCreateAu3Orange.jpg', 850, $y+75, 110, 28 )
	GUICtrlSetTip ( -1, 'Create Au3 Http Request' & @CRLF & 'and open it in SciTE Editor', ' ', 1, 1 )
	GUICtrlSetOnEvent ( -1, '_RequestCreateAu3Script' )
	$idButtonCopyRequest = GUICtrlCreatePic ( $sTempDir & '\ButtonRequestOrange2.jpg', 850, $y+120, 110, 28 )
	GUICtrlSetTip ( -1, 'Copy Request to clipboard', ' ', 1, 1 )
	GUICtrlSetOnEvent ( -1, '_RequestCopyToClipboard' )
	$idButtonCopyResponse = GUICtrlCreatePic ( $sTempDir & '\ButtonResponseOrange2.jpg', 850, $y+165, 110, 28 )
	GUICtrlSetTip ( -1, 'Copy Response to clipboard', ' ', 1, 1 )
	GUICtrlSetOnEvent ( -1, '_ResponseCopyToClipboard' )
	$idButtonClear = GUICtrlCreatePic ( $sTempDir & '\ButtonClearOrange1.jpg', 850, $y+210, 110, 28 )
	GUICtrlSetTip ( -1, 'Clear the Listview', ' ', 1, 1 )
	GUICtrlSetOnEvent ( -1, '_ListviewClear' )
	$idButtonAbout = GUICtrlCreatePic ( $sTempDir & '\ButtonHelpOrange1.jpg', 850, $y+255, 110, 28 )
	GUICtrlSetOnEvent ( -1, '_Help' )
	$idButtonExit = GUICtrlCreatePic ( $sTempDir & '\ButtonExitRed.jpg', 850, $y+300, 110, 28 )
	GUICtrlSetOnEvent ( -1, '_Exit' )
	#EndRegion --- Buttons ------------------------------

	GUICtrlCreateLabel ( 'Request Headers', 20, 390, 101, 20 )
	$idLabelIndex = GUICtrlCreateLabel ( '', 121, 390, 50, 20 )
	GUICtrlSetColor ( -1, 0x0000FF )
	$idEditRequest = GUICtrlCreateEdit ( '', 20, 410, 470, 130, BitOR ( $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL ) )
	GUICtrlSetBkColor ( -1, 0xFFFFFF )
	GUICtrlCreateLabel ( 'Response Headers', 510, 390, 110, 20 )
	$idEditResponse = GUICtrlCreateEdit ( '', 510, 410, 470, 130, BitOR ( $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL ) )
	GUICtrlSetBkColor ( -1, 0xFFFFFF )
	GUIRegisterMsg ( $WM_NOTIFY, '_WM_NOTIFY' )
	GUIRegisterMsg ( $WM_GETMINMAXINFO, '_WM_GETMINMAXINFO' )
	GUISetState ()
EndFunc ;==> _Gui ()

Func _GuiCtrlComboSetData ()
	Local $ipv4 = 0, $first
	For $i = 0 To UBound ( $aPcapDevices ) - 1
		If $aPcapDevices[$i][3] = 'EN10MB' And StringLen ( $aPcapDevices[$i][7] ) > 6 Then $ipv4 += 1 ; for ethernet devices with valid ip address only !
	Next
	If $ipv4 = 0 Then
		MsgBox ( 16, 'Error', 'No network interface found with a valid IPv4 address !' )
		_PcapFree ()
		Exit
	EndIf
	If $ipv4 = 1 Then $iComboDisable = 1
	If $ipv4 >= 1 Then
		$first = True
		For $i = 0 To UBound ( $aPcapDevices ) - 1
			If $aPcapDevices[$i][3] = 'EN10MB' And StringLen ( $aPcapDevices[$i][7] ) > 6 Then
				If $first Then
					GUICtrlSetData ( $idComboInterface, $aPcapDevices[$i][7] & ' - ' & _PcapCleanDeviceName ( $aPcapDevices[$i][1] ), $aPcapDevices[$i][7] & ' - ' & _PcapCleanDeviceName ( $aPcapDevices[$i][1] ) )
					$first = False
				Else
					GUICtrlSetData ( $idComboInterface, $aPcapDevices[$i][7] & ' - ' & _PcapCleanDeviceName ( $aPcapDevices[$i][1] ) )
				EndIf
			EndIf
		Next
	EndIf
	If $iComboDisable Then GUICtrlSetState ( $idComboInterface, $GUI_DISABLE )
EndFunc ;==> _GuiCtrlComboSetData ()

Func _GuiCtrlEditSetData ( $iSelection )
	$sCurrentSelOld = $iSelection
	If UBound ( $aRequest ) -1 < 1 Then Return
	ControlSetText ( $hGui, '', $idLabelIndex, 'n°' & $iSelection+1 )
	Local $sUrl = _GUICtrlListView_GetItemText ( $hListView, $iSelection, 1 ) ; url
	ControlSetText ( $hGui, '', $idEditRequest, $aRequest[$iSelection+1] )
	Local $iItem = _ArraySearch ( $aSequence, $aAcknowledgment[$iSelection+1], 1, 0, 0, 0, 1 ) ; Search not partial and by the end.
	If $iItem <> -1 Then
		ControlSetText ( $hGui, '', $idEditResponse, $aResponse[$iItem] )
	Else
		ControlSetText ( $hGui, '', $idEditResponse, '' )
	EndIf
EndFunc ;==> _GuiCtrlEditSetData ()

Func _GuiCtrlPicButton_RestorePos ()
	If IsArray ( $aPosBak ) Then
		GUICtrlSetPos ( $aPosBak[4], $aPosBak[0], $aPosBak[1], $aPosBak[2], $aPosBak[3] )
		$aPosBak = 0
	EndIf
	AdlibUnRegister ( '_GuiCtrlPicButton_RestorePos' )
EndFunc ;==> _GuiCtrlPicButton_RestorePos ()

Func _GuiCtrlPicButton_SimulateAction ( $iCtrlId, $iFlag=1 )
	If Not _WindowIsVisible ( $hGui ) Then Return
	Local $aPos = ControlGetPos ( $hGui, '', $iCtrlId )
	If Not @error Then
		GUICtrlSetPos ( $iCtrlId, $aPos[0]+$iFlag, $aPos[1]+$iFlag, $aPos[2]-2*$iFlag, $aPos[3]-2*$iFlag )
		$aPosBak = $aPos
		_ArrayAdd ( $aPosBak, $iCtrlId )
		AdlibRegister ( '_GuiCtrlPicButton_RestorePos', 150 )
	EndIf
	$aPos = 0
EndFunc ;==> _GuiCtrlPicButton_SimulateAction ()

Func _Help ()
	_GuiCtrlPicButton_SimulateAction ( $idButtonAbout, 1 )
	Local $pnButton, $pnRadioButton, $pfVerificationFlagChecked
	Local $iWidth = 450
	Switch @OSVersion
		Case 'WIN_2003', 'WIN_XP'
			$iWidth = 600
	EndSwitch
	Local $ContentText = @CRLF & 'Informations' & @CRLF & @CRLF _
		& 'HttpHeaderWatcher permit to see Request Headers and its corresponding Response' & @CRLF _
		& 'by extracting datas of TCP packets captured by <a href="http://www.winpcap.org/">WinPcap</a> on ports 80 and 8080.' & @CRLF _
		& 'The latest stable WinPcap version is 4.1.3 and need to be installed.' & @CRLF _
		& 'It support Windows XP/2003/Vista/2008/Win7/2008R2/Win8 (x86 and x64) and can be downloaded <a href="http://www.winpcap.org/install/default.htm">here</a>.' & @CRLF _
		& 'Script use a part of the <a href="http://opensource.grisambre.net/pcapau3/">WinPcap UDF</a> of Nicolas Ricquemaque AKA <a href="http://www.autoitscript.com/forum/user/47902-f1iqf/">f1iqf</a>.' & @CRLF _
		& '' & @CRLF _
		& 'HttpHeaderWatcher do not support HTTPS on port 443 because requests are <a href="http://en.wikipedia.org/wiki/Secure_Sockets_Layer">SSL</a> encrypted.' & @CRLF _
		& "" & @CRLF _
		& "How use it :" & @CRLF _
		& "Select the appropriate device and click on Start Button for launch the packets capture." & @CRLF _
		& 'The listview will display all the "Http" urls extracted from packets.' & @CRLF _
		& 'Clicking on a url will display the request header.' & @CRLF _
		& 'If the response is not displayed, wait a few seconds and re click on url.' & @CRLF & @CRLF _
		& 'The "Create Au3" button permit to re-create current selected Request in a AutoIt script' & @CRLF _
		& 'using the <a href="http://www.autoitscript.com/forum/topic/84133-winhttp-functions/">WinHttp UDF</a> of <a href="http://www.autoitscript.com/forum/user/33569-trancexx/">trancexx</a> ' _
		& 'who can be downloaded <a href="http://code.google.com/p/autoit-winhttp/downloads/list">here</a>.' & @CRLF _
		& 'You will need sometimes the <a href="http://www.autoitscript.com/forum/topic/128962-zlib-deflateinflategzip-udf/">ZLib UDF</a> of <a href="http://www.autoitscript.com/forum/user/10768-ward/">Ward</a> ' _
		& 'when you will get a <a href="http://en.wikipedia.org/wiki/HTTP_compression">gzip</a> Content-Encoding.' & @CRLF _
		& 'Once script created, free to you to adapt it to your needs!' & @CRLF _
		& 'I Hope it help you to easily build Http Requests !' & @CRLF _
		& '' & @CRLF _
		& 'You can Copy Url by pressing left Shift key when clicking on a url.' & @CRLF _
		& "" & @CRLF _
		& 'Thanks to <a href="http://www.autoitscript.com/forum/">AutoIt Community</a>' & @CRLF & @CRLF _
		& '<a href="http://www.autoitscript.com/forum/user/28198-wakillon/">wakillon</a>'
	Local $sDetails = 'Buttons were created with the Online Buttons Generator : <a href="http://www.chimply.com/Generator#button,classicButton">chimply.com</a>' & @CRLF _
		& 'HttpHeaderWatcher was created with <a href="http://www.autoitscript.com/site/">AutoIt v3.3.10.2</a>' & @CRLF _
		& 'Try this powerfull scripting language !' & @CRLF & @CRLF
	Local $CallBackFunc = DllCallbackRegister ( '_TaskDialog_Callback', 'long', 'hwnd;uint;wparam;lparam;long_ptr' )
	Local $ret = _TaskDialog_IndirectParamsMod ( $pnButton, _                         ; ByRef $pnButton
		$pnRadioButton, _                                                             ; ByRef $pnRadioButton
		$pfVerificationFlagChecked, _                                                 ; ByRef $pfVerificationFlagChecked
		$hGui, _                                                                      ; $hwndParent
		0, _                                                                          ; $hInstance
		BitOR ( $TDF_ENABLE_HYPERLINKS, $TDF_USE_COMMAND_LINKS ), _                   ; $dwFlags
		$TDCBF_CLOSE_BUTTON, _                                                        ; $dwCommonButtons
		$sSoftTitle, _                                                                ; $szWindowTitle
		$TDCBF_CANCEL_BUTTON, _                                                       ; $MainIcon
		'Help', _                                                                     ; $szMainInstruction
		$ContentText, _                                                               ; $szContent
		'', _                                                                         ; $szVerificationText
		$sDetails, _                                                                  ; $szExpandedInformation
		'Hide details', _                                                             ; $szExpandedControlText
		'Show details', _                                                             ; $szCollapsedControlText
		$TD_INFORMATION_ICON, _                                                       ; $FooterIcon
		'<a href="http://www.autoitscript.com/site/">Visit autoitscript.com</a>', _   ; $szFooter
		DllCallbackGetPtr ( $CallBackFunc ), _                                        ; $pfCallback
		0, _                                                                          ; $lpCallbackData
		$iWidth _                                                                     ; $cxWidth
		)
	DllCallbackFree ( $CallBackFunc )
	$CallBackFunc = 0
EndFunc ;==> _Help ()

Func _HexIPAddressToString ( $IPAddress )
	Local $sIPAddress
	For $i = 1 To StringLen ( $IPAddress ) Step 2
		$sIPAddress &= Dec ( StringMid ( $IPAddress, $i, 2 ) ) & '.'
	Next
	Return StringTrimRight ( $sIPAddress, 1 )
EndFunc ;==> _HexIPAddressToString

Func _IsPressed ( $sHexKey )
	Local $aRet = DllCall ( 'User32.dll', 'short', 'GetAsyncKeyState', 'int', '0x' & $sHexKey )
	If @error Then Return SetError ( @error, @extended, False )
	Return BitAND ( $aRet[0], 0x8000 ) <> 0
EndFunc ;==> _IsPressed ()

Func _ListviewClear ()
	_GuiCtrlPicButton_SimulateAction ( $idButtonClear, 1 )
	$iListviewClear = 1
	$aRequest = 0
	$aAcknowledgment = 0
	$aResponse = 0
	$aSequence = 0
	_GUICtrlListView_DeleteAllItems ( $hListView )
	Dim $aRequest[1], $aAcknowledgment[1], $aResponse[1], $aSequence[1]
	$iListviewClear = 0
EndFunc ;==> _ListviewClear ()

Func _LzmaDec ( $Source ) ; by Ward
	Local $__LZMADLL = @TempDir & '\LZMA.DLL'
	If Not FileExists ( $__LZMADLL ) Then Lzmadll ( 'LZMA.DLL', @TempDir )
	If @error Then Return SetError ( 1, 0, $Source )
	If BinaryLen ( $Source ) < 9 Then Return SetError ( 2, 0, $Source )
	Local $Src = DllStructCreate ( 'byte[' & BinaryLen ( $Source ) & ']' ), $Ret
	DllStructSetData ( $Src, 1, $Source )
	$Ret = DllCall ( $__LZMADLL, 'uint:cdecl', 'LzmaDecGetSize', 'ptr', DllStructGetPtr ( $Src ) )
	If @Error Then Return SetError ( 3, 0, $Source )
	Local $DestSize = $Ret[0]
	If $DestSize = 0 Then Return SetError ( 4, 0, $Source )
	Local $Dest = DllStructCreate ( 'byte[' & $DestSize & ']' )
	$Ret = DllCall ( $__LZMADLL, 'int:cdecl', 'LzmaDec', 'ptr', DllStructGetPtr ( $Dest ), 'uint*', $DestSize, 'ptr', DllStructGetPtr ( $Src ), 'uint', BinaryLen ( $Source ) )
	If Not @Error Then
		$Src = 0
		Return SetExtended ( $Ret[0], DllStructGetData ( $Dest, 1 ) )
	Else
		$Src = 0
		$Dest = 0
		Return SetError ( 5, 0, $Source )
	EndIf
EndFunc ;==> _LzmaDec ()

Func _OnAutoItExit ()
	GUIDelete ( $hGui )
	If $hPacketDll Then DllClose ( $hPacketDll )
	If $hNTDLL Then DllClose ( $hNTDLL )
	If $hKernel32 Then DllClose ( $hKernel32 )
	If $hIPHLPAPI Then DllClose ( $hIPHLPAPI )
	If $hWS232 Then DllClose ( $hWS232 )
	If $hPSAPI Then DllClose ( $hPSAPI )
	If $hWTSAPI32 Then DllClose ( $hWTSAPI32 )
	If $hADVAPI32 Then DllClose ( $hADVAPI32 )
	TCPShutdown()
	DirRemove ( $sTempDir, 1 )
EndFunc ;==> _OnAutoItExit ()

Func _PacketExtractData ( $data )
	If $iListviewClear Then Return
	Local $IpHeaderLen = BitAND ( _PcapBinaryGetVal ( $data, 15, 1 ), 0xF ) * 4
	Local $TcpOffset = $IpHeaderLen + 14
	Local $TcpLen = _PcapBinaryGetVal ( $data, 17, 2 ) - $IpHeaderLen
	Local $TcpHeaderLen = BitShift ( _PcapBinaryGetVal ( $data, $TcpOffset + 13, 1 ), 4 ) * 4
	Local $HttpLen = $TcpLen - $TcpHeaderLen
	If $HttpLen < 2 Then Return False
	Local $TcpSourcePort = _PcapBinaryGetVal ( $data, $TcpOffset + 1, 2 )
	Local $TcpDestinationPort = _PcapBinaryGetVal ( $data, $TcpOffset + 3, 2 )
	Local $HttpOffset = $TcpOffset + $TcpHeaderLen + 1
	Local $sHttp = BinaryToString ( BinaryMid ( $data, $HttpOffset, $HttpLen ) )
	Local $sUrl, $sFileName, $iStr, $SourceIp, $sDestinationIp, $aTCPArray
	Switch $TcpSourcePort ; Response
		Case 80, 8080
			If StringLeft ( $sHttp, 4 ) = 'http' Then
				$SourceIp = _HexIPAddressToString ( StringMid ( $data, 55, 8 ) )
				$iStr = StringInStr ( $sHttp, @CRLF & @CRLF )
				If Not $iStr Then $iStr = -1
				_ArrayAdd ( $aResponse, StringMid ( $sHttp, 1, $iStr ) )
				_ArrayAdd ( $aSequence, StringMid ( $data, 79, 8 ) )
			EndIf
			Return
	EndSwitch
	Switch $TcpDestinationPort ; Request
		Case 80, 8080
			Local $host = StringRegExp ( $sHttp, 'Host: (.*)' , 1 )
			If Not @Error Then
				$sFileName = StringRegExp ( $sHttp, '(?s)(?i)GET (.*?) HTTP', 3 )
				If @Error Then
					$sFileName = StringRegExp ( $sHttp, '(?s)(?i)POST (.*?) HTTP', 3 )
					If Not @Error Then
						$sFileName = $sFileName[0]
					Else
						Return
					EndIf
				Else
					$sFileName = $sFileName[0]
				EndIf
				$sUrl = 'http://' & $host[0] & $sFileName
			Else
				Return
			EndIf
			If $sUrl = '' Then Return ; url not found !
			If StringInStr ( $sHttp, ' HTTP' ) Then
				$sDestinationIp = _HexIPAddressToString ( StringMid ( $data, 63, 8 ) )
				; remove doublons
				Dim $a[UBound ( $aTCPTable )], $a1
				For $i = UBound ( $aTCPTable ) -1 To 1 Step -1
					$a[$i] = $aTCPTable[$i][1]
					$a1 = _ArrayFindAll ( $a, $a[$i], 1, 0, 0, 0 )
					If Not @error And UBound ( $a1 ) -1 <> 0 Then _ArrayDelete4D ( $aTCPTable, $i )
				Next
				$aTCPArray = _GetExtendedTcpTable ()
;~              $aTCPArray[n][0] = process name
;~              $aTCPArray[n][1] = destination ip
;~              $aTCPArray[n][2] = process pid
;~              $aTCPArray[n][3] = process path
				Local $sProcessName, $iProcessPid
				For $i = UBound ( $aTCPArray ) -1 To 1 Step -1
					If Int ( $aTCPArray[$i][2] ) > 0 Then
						If $aTCPArray[$i][1] = $sDestinationIp Then
							$sProcessName = $aTCPArray[$i][0]
							$iProcessPid = $aTCPArray[$i][2]
							ExitLoop
						EndIf
					Else
						_ArrayDelete4D ( $aTCPTable, $i )
					EndIf
				Next
				$iStr = StringInStr ( $sHttp, @CRLF & @CRLF )
				If Not $iStr Then $iStr = -1
				_ArrayAdd ( $aRequest, StringMid ( $sHttp, 1, $iStr ) )
				_ArrayAdd ( $aAcknowledgment, StringMid ( $data, 87, 8 ) )
				Local $iItemsCount = _GUICtrlListView_GetItemCount ( $hListView )
				_GUICtrlListView_AddItem ( $hListView, $iItemsCount +1 )
				_GuiCtrlListView_AddSubItem ( $hListView, $iItemsCount, $sUrl, 1 )
				_GuiCtrlListView_AddSubItem ( $hListView, $iItemsCount, $sDestinationIp & ':' & $TcpDestinationPort, 3 )
				_GuiCtrlListView_AddSubItem ( $hListView, $iItemsCount, $sProcessName, 2 )
				_GuiCtrlListView_AddSubItem ( $hListView, $iItemsCount, $iProcessPid, 4 )
				_GuiCtrlListView_AddSubItem ( $hListView, $iItemsCount, $packet[0], 5 )
			EndIf
	EndSwitch
EndFunc ;==> _PacketExtractData ()

Func _PacketStartCapture ()
	_GuiCtrlPicButton_SimulateAction ( $idButtonStartCapture, 1 )
	Sleep ( 150 )
	Local $int, $which
	If $iCapture Then ; stop capture
		GUICtrlSetTip ( $idButtonStartCapture, 'Start Packets Capture', ' ', 1, 1 )
		GUICtrlSetImage ( $idButtonStartCapture, $sTempDir & '\ButtonStartGreen.jpg' )
		_PcapStopCapture ( $pCap )
		$pCap = 0
		$iCapture = 0
		If Not $iComboDisable Then GUICtrlSetState ( $idComboInterface, $GUI_ENABLE )
	Else ; start capture
		GUICtrlSetTip ( $idButtonStartCapture, 'Stop Packets Capture', ' ', 1, 1 )
		GUICtrlSetImage ( $idButtonStartCapture, $sTempDir & '\ButtonStopRed.jpg' )
		$iCapture = 1
		$int = -1
		$which = GUICtrlRead ( $idComboInterface )
		GUICtrlSetState ( $idComboInterface, $GUI_DISABLE )
		For $i = 0 To UBound ( $aPcapDevices ) - 1
			If StringLen ( $aPcapDevices[$i][7] ) > 6 And StringInStr ( $which, $aPcapDevices[$i][7] ) Then
				$int = $i
				ExitLoop
			EndIf
		Next
		$pCap = _PcapStartCapture ( $aPcapDevices[$int][0], 'host ' & $aPcapDevices[$int][7] & ' and tcp port (80 or 8080)', 0, 65536, 2^24, 0 ) ; MAX_PACKET_SIZE 0x10000
	EndIf
EndFunc ;==> _PacketStartCapture ()

Func _PcapBinaryGetVal ( $data, $offset, $bytes )
	Local $val32 = Dec ( StringMid ( $data, 3 + ( $offset -1 )*2 , $bytes*2 ) )
	If $val32 < 0 Then Return 2^32 + $val32
	Return $val32
EndFunc ;==> _PcapBinaryGetVal ()

Func _PcapCleanDeviceName ( $sFullName ) ; Returns a cleaner device name without 'Network adapter ' etc If any
	Local $aName = StringRegExp ( $sFullName, "^Network adapter '(.*)' on", 1 )
	If @error = 0 Then Return StringStripWS ( $aName[0], 7 )
	Return StringStripWS ( $sFullName, 7 )
EndFunc ;==> _PcapCleanDeviceName ()

Func _PcapFree () ; free resources opened by _PcapSetup
	DllClose ( $hPcapDll )
EndFunc ;==> _PcapFree ()

Func _PcapGetDeviceList () ; Returns 2D array with pcap devices (name;desc;mac;ipv4_addr;ipv4_netmask;ipv4_broadaddr;ipv6_addr;ipv6_netmask;ipv6_broadaddr;flags) or -1 If error
	Local $alldevs = DLLStructCreate ( 'ptr' )
	Local $r = DllCall ( $hPcapDll, 'int:cdecl', 'pcap_findalldevs_ex', 'str', 'rpcap://', 'ptr', 0, 'ptr', DllStructGetPtr ( $alldevs ), 'ptr', DllStructGetPtr ( $Pcap_errbuf ) )
	If @error > 0 Then Return -1
	If $r[0] = -1 Then Return -1
	Local $next = DllStructGetData ( $alldevs, 1 ), $aList[1][14]
	Local $i = 0, $pcap_If, $len_name, $len_desc, $next_addr, $device, $snames, $handle, $status, $mac, $nettype, $pcap, $types, $pcap_addr, $j, $addr, $packetoiddata
	While $next <> 0
		$pcap_If = DllStructCreate ( 'ptr next;ptr name;ptr desc;ptr addresses;uint flags', $next )
		$len_name = DllCall ( $hKernel32, 'int', 'lstrlen', 'ptr', DllStructGetData ( $pcap_If, 2 ) )
		$len_desc = DllCall ( $hKernel32, 'int', 'lstrlen', 'ptr', DllStructGetData ( $pcap_If, 3 ) )
		$aList[$i][0] = DllStructGetData ( DllStructCreate ( 'char[' & ( $len_name[0] +1 ) & ']', DllStructGetData ( $pcap_If, 2 ) ), 1 )
		$aList[$i][1] = DllStructGetData ( DllStructCreate ( 'char[' & ( $len_desc[0] +1 ) & ']', DllStructGetData ( $pcap_If, 3 ) ), 1 )
		$next_addr = DllStructGetData ( $pcap_If, 'addresses' )
		; retrieve mac address
		$device = StringTrimLeft ( $aList[$i][0], 8 )
		$snames = DllStructCreate ( 'char Name[' & ( StringLen ( $device ) + 1 ) & ']' )
		DllStructSetData ( $snames, 1, $device )
		$handle = DllCall ( $hPacketDll, 'ptr:cdecl', 'PacketOpenAdapter', 'ptr', DllStructGetPtr ( $snames ) )
		If IsPtr ( $handle[0] ) Then
			$packetoiddata = DllStructCreate ( 'ulong oid;ulong length;ubyte data[6]' )
			DllStructSetData ( $packetoiddata, 1, 0x01010102 ) ; OID_802_3_CURRENT_ADDRESS
			DllStructSetData ( $packetoiddata, 2, 6 )
			$status = DllCall ( $hPacketDll, 'byte:cdecl', 'PacketRequest', 'ptr', $handle[0], 'byte', 0, 'ptr', DllStructGetPtr ( $packetoiddata ) )
			If $status[0] Then
				$mac = DllStructGetData ( $packetoiddata, 3 )
				$aList[$i][6] = StringMid ( $mac, 3, 2 ) & ':' & StringMid ( $mac, 5, 2 ) & ':' & StringMid ( $mac, 7, 2 ) & ':' & StringMid ( $mac, 9, 2 ) & ':' & StringMid ( $mac, 11, 2 ) & ':' & StringMid ( $mac, 13, 2 )
			EndIf
			$nettype = DllStructCreate ( 'uint type;uint64 speed' )
			$status = DllCall ( $hPacketDll, 'byte:cdecl', 'PacketGetNetType', 'ptr', $handle[0], 'ptr', DllStructGetPtr ( $nettype ) )
			If $status[0] Then $aList[$i][5] = DllStructGetData ( $nettype, 2 )
			DllCall ( $hPacketDll, 'none:cdecl', 'PacketCloseAdapter', 'ptr', $handle[0] )
		EndIf
		; retrieve lintypes
		$pcap = _PcapStartCapture ( $aList[$i][0], 'host 1.2.3.4', 0, 32 )
		If IsPtr ( $pcap ) Then
			$types = _PcapGetLinkType ( $pcap )
			If IsArray ( $types ) Then
				$aList[$i][2] = $types[0]
				$aList[$i][3] = $types[1]
				$aList[$i][4] = $types[2]
			EndIf
			_PcapStopCapture ( $pcap )
		EndIf
		; retrieve ip addresses
		While $next_addr <> 0
			$pcap_addr = DllStructCreate ( 'ptr next;ptr addr;ptr netmask;ptr broadaddr;ptr dst', $next_addr )
			For $j = 2 to 4
				$addr = _PcapSock2addr ( DllStructGetData ( $pcap_addr, $j ) )
				If StringLen ( $addr ) > 15 Then
					$aList[$i][$j+8] = $addr
				ElseIf StringLen ( $addr ) > 6 Then
					$aList[$i][$j+5] = $addr
				EndIf
			Next
			$next_addr = DllStructGetData ( $pcap_addr, 1 )
		Wend
		$aList[$i][13] = DllStructGetData ( $pcap_If, 5 )
		$next = DllStructGetData ( $pcap_If, 1 )
		$i += 1
		If $next <> 0 Then Redim $aList[$i+1][14]
	Wend
	DllCall ( $hPcapDll, 'none:cdecl', 'pcap_freealldevs', 'ptr', DllStructGetData ( $alldevs, 1 ) )
	$pcap_If = 0
	$alldevs = 0
	$snames = 0
	$packetoiddata = 0
	$nettype = 0
	$pcap_addr = 0
	Return $aList
EndFunc ;==> _PcapGetDeviceList ()

Func _PcapGetLastError ( $pcap=0 ) ; Returns text from last pcap error
	If Not IsPtr ( $pcap ) Then Return DllStructGetData ( $Pcap_errbuf, 1 )
	Local $v = DllCall ( $hPcapDll, 'str:cdecl', 'pcap_geterr', 'ptr', $pcap )
	Return DllStructGetData ( $Pcap_errbuf, 1 ) & $v[0]
EndFunc ;==> _PcapGetLastError ()

Func _PcapGetLinkType ( $pcap ) ; Returns a array with LinkType for opened capture $pcap. [0]: int value of link type, [1] name of linktype, [2] description of linktype
	If Not IsPtr ( $pcap ) Then Return -1
	Local $type[3]
	Local $t = DllCall ( $hPcapDll, 'int:cdecl', 'pcap_datalink', 'ptr', $pcap )
	$type[0] = $t[0]
	Local $name = DllCall ( $hPcapDll, 'str:cdecl', 'pcap_datalink_val_to_name', 'int', $t[0] )
	$type[1] = $name[0]
	Local $desc = DllCall ( $hPcapDll, 'str:cdecl', 'pcap_datalink_val_to_description', 'int', $t[0] )
	$type[2] = $desc[0]
	Return $type
EndFunc ;==> _PcapGetLinkType ()

Func _PcapGetPacket ( $pcap ) ; Return 0: timeout, -1:error, -2:EOF in file or If successfull array[0]=time [1]=captured len [2]=packet len [3]=packet data
	If Not IsPtr ( $pcap ) Then Return -1
	$Pcap_ptrhdr = DllStructCreate ( 'ptr' )
	$Pcap_ptrpkt = DllStructCreate ( 'ptr' )
	Local $pk[4]
	Local $res = DllCall ( $hPcapDll, 'int:cdecl', 'pcap_next_ex', 'ptr', $pcap, 'ptr', DllStructGetPtr ( $Pcap_ptrhdr ), 'ptr', DllStructGetPtr ( $Pcap_ptrpkt ) )
	If $res[0] <> 1 Then Return $res[0]
	Local $pkthdr = DllStructCreate ( 'int s;int us;int caplen;int len', DllStructGetData ( $Pcap_ptrhdr, 1 ) )
	Local $packet = DLLStructCreate ( 'ubyte[' & DllStructGetData ( $pkthdr, 3 ) & ']', DllStructGetData ( $Pcap_ptrpkt, 1 ) )
	Local $time_t = Mod ( DllStructGetData ( $pkthdr, 1 ) + $Pcap_timebias, 86400 )
	$pk[0] = StringFormat ( '%02d:%02d:%02d.%06d', Int ( $time_t / 3600 ), Int ( Mod ( $time_t, 3600 )/60 ), Mod ( $time_t, 60 ), DllStructGetData ( $pkthdr, 2 ) )
	$pk[1] = DllStructGetData ( $pkthdr, 3 )
	$pk[2] = DllStructGetData ( $pkthdr, 4 )
	$pk[3] = DllStructGetData ( $packet, 1 )
	; stats
	$Pcap_statV += $pk[2]
	$Pcap_statN += 1
	$pkthdr = 0
	$packet = 0
	Return $pk
EndFunc ;==> _PcapGetPacket ()

Func _PcapIsPacketReady ( $pcap )
	If Not IsPtr ( $pcap ) Then Return -1
	Local $handle = DllCall ( $hPcapDll, 'ptr:cdecl', 'pcap_getevent', 'ptr', $pcap )
	Local $state = DllCall ( 'kernel32.dll', 'dword', 'WaitForSingleObject', 'ptr', $handle[0], 'dword', 0 )
	Return $state[0] = 0
EndFunc ;==> _PcapIsPacketReady ()

Func _PcapSetup () ; Return WinPCAP version as full text or -1 If winpcap is Not installed, and opens dll
	If Not FileExists ( @SystemDir & '\wpcap.dll' ) Then Return -1
	$hPcapDll = DllOpen ( 'wpcap.dll' )
	$Pcap_errbuf = DLLStructCreate ( 'char[256]' )
	$Pcap_ptrhdr = 0
	$Pcap_ptrpkt = 0
;~  $Pcap_statV ; Total volume captured
;~  $Pcap_statN ; Total number of packets captured
;~  $Pcap_starttime ; Start time of Capture
	$Pcap_timebias = ( 2^32 - RegRead ( 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation', 'ActiveTimeBias' ) ) * 60
	Local $v = DllCall ( $hPcapDll, 'str:cdecl', 'pcap_lib_version' )
	If @error > 0 Then Return -1
	$hPacketDll = DllOpen ( 'packet.dll' )
	Return $v[0]
EndFunc ;==> _PcapSetup ()

Func _PcapSock2addr ( $sockaddr_ptr ) ; internat function to convert a sockaddr structure into an string containing an IP address
	If $sockaddr_ptr = 0 Then Return ''
	Local $sockaddr = DllStructCreate ( 'ushort family;char data[14]', $sockaddr_ptr )
	Local $family = DllStructGetData ( $sockaddr, 1 )
	If $family = $AF_INET Then ; IPv4
		Local $sockaddr_in = DllStructCreate ( 'short family;ushort port;ubyte addr[4];char zero[8]', $sockaddr_ptr )
		Return DllStructGetData ( $sockaddr_in, 3, 1 ) & '.' & DllStructGetData ( $sockaddr_in, 3, 2 ) & '.' & DllStructGetData ( $sockaddr_in, 3, 3 ) & '.' & DllStructGetData ( $sockaddr_in, 3, 4 )
	EndIf
	If $family = $AF_INET6 Then ; IPv6
		Local $sockaddr_in6 = DllStructCreate ( 'ushort family;ushort port;uint flow;ubyte addr[16];uint scope', $sockaddr_ptr )
		Local $bin = DllStructGetData ( $sockaddr_in6, 4 )
		Local $i, $ipv6
		For $i = 0 to 7
			$ipv6 &= StringMid ( $bin, 3 + $i*4, 4 ) & ':'
		Next
		Return StringTrimRight ( $ipv6, 1 )
	EndIf
	Return ''
EndFunc ;==> _PcapSock2addr ()

Func _PcapStartCapture ( $DeviceName, $filter='', $promiscuous=0, $PacketLen=65536, $buffersize=0, $realtime=1 ) ; start a capture in non-blocking mode on device $DeviceName with optional parameters: $PacketLen, $promiscuous, $filter. Returns -1 on failure or pcap handler
	Local $handle = DllCall ( $hPcapDll, 'ptr:cdecl', 'pcap_open', 'str', $DeviceName, 'int', $PacketLen, 'int', $promiscuous, 'int', 1000, 'ptr', 0, 'ptr', DllStructGetPtr ( $Pcap_errbuf ) )
	If @error > 0 Then Return -1
	If $handle[0] = 0 Then Return -1
	DllCall ( $hPcapDll, 'int:cdecl', 'pcap_setnonblock', 'ptr', $handle[0], 'int', 1, 'ptr', DllStructGetPtr ( $Pcap_errbuf ) )
	If $filter <> '' Then
		Local $fcode = DLLStructCreate ( 'UINT;ptr' )
		Local $comp = DllCall ( $hPcapDll, 'int:cdecl', 'pcap_compile', 'ptr', $handle[0], 'ptr', DllStructGetPtr ( $fcode ), 'str', $filter, 'int', 1, 'int', 0 )
		If $comp[0] = -1 Then
			Local $v = DllCall ( $hPcapDll, 'str:cdecl', 'pcap_geterr', 'ptr', $handle[0] )
			DLLStructSetData ( $Pcap_errbuf, 1, 'Filter: ' & $v[0] )
			_PcapStopCapture ( $handle[0] )
			Return -1
		EndIf
		Local $set = DllCall ( $hPcapDll, 'int:cdecl', 'pcap_setfilter', 'ptr', $handle[0], 'ptr', DllStructGetPtr ( $fcode ) )
		If $set[0] = -1 Then
			Local $v = DllCall ( $hPcapDll, 'str:cdecl', 'pcap_geterr', 'ptr', $handle[0] )
			DLLStructSetData ( $Pcap_errbuf, 1, 'Filter: ' & $v[0] )
			_PcapStopCapture ( $handle[0] )
			Return -1
			DllCall ( $hPcapDll, 'none:cdecl', 'pcap_freecode', 'ptr', $fcode )
		EndIf
	EndIf
	If $buffersize > 0 Then DllCall ( $hPcapDll, 'int:cdecl', 'pcap_setbuff', 'ptr', $handle[0], 'int', $buffersize )
	If $realtime Then DllCall ( $hPcapDll, 'int:cdecl', 'pcap_setmintocopy', 'ptr', $handle[0], 'int', 1 )
	$Pcap_statV = 0
	$Pcap_statN = 0
	$Pcap_starttime = TimerInit()
	Return $handle[0]
EndFunc ;==> _PcapStartCapture ()

Func _PcapStopCapture ( $pcap ) ; stop capture started with _PcapStartCapture
	If Not IsPtr ( $pcap ) Then Return
	DllCall ( $hPcapDll, 'none:cdecl', 'pcap_close', 'ptr', $pcap )
EndFunc ;==> _PcapStopCapture ()

Func _RequestCopyToClipboard ()
	_GuiCtrlPicButton_SimulateAction ( $idButtonCopyRequest, 1 )
	Local $sRequest = GUICtrlRead ( $idEditRequest )
	If $sRequest Then
		ClipPut ( $sRequest )
		_TrayTip ( $sSoftTitle, 'The Current Request (' & GUICtrlRead ( $idLabelIndex ) & ') was copied to the clipboard', 1 )
	Else
		_TrayTip ( $sSoftTitle, 'There is no Request to copy', 2 )
	EndIf
EndFunc ;==> _RequestCopyToClipboard ()

Func _RequestCreateAu3Script ()
	_GuiCtrlPicButton_SimulateAction ( $idButtonCreateAu3, 1 )
	Local $sRequest = StringStripWS ( GUICtrlRead ( $idEditRequest ), 1+2 )
	If Not $sRequest Then
		_TrayTip ( $sSoftTitle, 'There is no Request to create', 2 )
		Return
	EndIf
	Local $a = StringSplit ( $sRequest, @CR, 1+2 ) ; based 0
	If StringLeft ( $a[1], 6 ) <> 'host: ' Then ;  host is not always in second pos.
		Local $iItem = _ArraySearch ( $a, 'host: ', 2, 0, 0, 1, 1 ) ; Search partial and by the end.
		If $iItem <> -1 Then
			_ArrayInsert ( $a, 1, $a[$iItem] )
			_ArrayDelete ( $a, $iItem+1 )
		EndIf
	EndIf
	Local $a1
	Local $a2 = StringSplit ( $a[0], ' ', 1+2 )
	Local $a3 = StringSplit ( $a[1], ' ', 1+2 )
	Local $sScript = '#include <WinHTTP.au3>' & @CRLF & @CRLF & _
		'Local $hOpen = _WinHttpOpen () ; Code Generated by HttpHeaderWatcher (Request ' & GUICtrlRead ( $idLabelIndex ) & ')'& @CRLF & _
		'Local $hConnect = _WinHttpConnect ( $hOpen, "' & $a3[1] & '" )' & @CRLF & _
		'Local $hRequest = _WinHttpOpenRequest ( $hConnect, "' & $a2[0] & '", "' & $a2[1] & '", "' & $a2[2] & '" )' & @CRLF
	For $i = 2 To UBound ( $a ) -1
		$a1 = StringSplit ( $a[$i], ': ', 1+2 )
		$sScript &= "_WinHttpAddRequestHeaders ( $hRequest, '" & StringStripWS ( $a1[0], 1+2 ) & ': ' & StringStripWS ( $a1[1], 1+2 ) & "' )" & @Crlf
	Next
	$sScript = StringReplace ( $sScript, "_WinHttpAddRequestHeaders ( $hRequest, 'If-Modified-Since", ";~ _WinHttpAddRequestHeaders ( $hRequest, 'If-Modified-Since" )
	$sScript = StringReplace ( $sScript, "_WinHttpAddRequestHeaders ( $hRequest, 'If-None-Match", ";~ _WinHttpAddRequestHeaders ( $hRequest, 'If-None-Match" )
	Local $sEditResponse = GUICtrlRead ( $idEditResponse ), $iCharset = 1, $sDecod, $sAction
	Local $sFileName = _FileGetFullNameByUrl ( $a2[1] )
	If Not $sFileName Then $sFileName = 'file.ext'
	; determine action afer response (txt type or not).
	If StringRegExp ( $sEditResponse, '(?i)content-type:\s*text/\w+' ) Then
		$sAction = ";~     ConsoleWrite ( '!$ReceivedData : ' & $ReceivedData & @Crlf )"
	Else
		$sAction = ';~     Local $hFile = FileOpen ( "' & @DesktopDir & '\' & $sFileName & '", 2+8+16 )' & @CRLF & _
			";~     FileWrite ( $hFile, $ReceivedData )" & @CRLF & _
			";~     FileClose ( $hFile )"
	EndIf
	; determine how the binary data will be converted.
	If StringRegExp ( $sEditResponse, '(?im)^Content-Type:\h.*?charset\h*=\h*utf-?8' ) Then $iCharset = 4
	If StringRegExp ( $sEditResponse, '(?im)^Content-Encoding:\h+gzip' ) Then
		$sDecod = '$ReceivedData = BinaryToString ( _ZLIB_GZUncompress ( $ReceivedData ), ' & $iCharset & ' )'
		$sScript = ';~ #include <zlib.au3>' & @CRLF & $sScript
	Else
		$sDecod = '$ReceivedData = BinaryToString ( $ReceivedData, ' & $iCharset & ' )'
	EndIf
	$sScript &= '_WinHttpSendRequest ( $hRequest )' & @CRLF & _
		'_WinHttpReceiveResponse ( $hRequest )' & @CRLF & _
		'If _WinHttpQueryDataAvailable ( $hRequest ) Then' & @CRLF & _
		@TAB & 'Local $sHeaderRaw = _WinHttpQueryHeaders ( $hRequest, $WINHTTP_QUERY_RAW_HEADERS_CRLF ) ; just for test request.' & @CRLF & _
		@TAB & "ConsoleWrite ( '+HeaderRaw : ' & $sHeaderRaw & @Crlf )" & @CRLF & _
		";~     Local $ReceivedData = Binary ( '' ), $chunk" & @CRLF & _
		';~     While 1' & @CRLF & _
		';~         $chunk = _WinHttpReadData ( $hRequest, 2 )' & @CRLF & _
		';~         If Not @extended Then ExitLoop' & @CRLF & _
		';~         $ReceivedData &= $chunk' & @CRLF & _
		';~     WEnd' & @CRLF & _
		';~     ' & $sDecod & @CRLF & _
		$sAction & @CRLF & _
		'EndIf' & @CRLF & _
		'_WinHttpCloseHandle ( $hRequest )' & @CRLF & _
		'_WinHttpCloseHandle ( $hConnect )' & @CRLF & _
		'_WinHttpCloseHandle ( $hOpen )' & @CRLF
	Local $sAu3Path = @TempDir & '\' & @YEAR & @MON & @MDAY & '-' & @HOUR & @MIN & @SEC & '.au3'
	Local $hfile = FileOpen ( $sAu3Path, 2 )
	FileWrite ( $hfile, $sScript )
	FileClose ( $hfile )
	Local $sSciTEPath = _SciTEGetPath ()
	If Not @error Then
		Run ( $sSciTEPath & ' ' & $sAu3Path )
		_TrayTip ( $sSoftTitle, 'The Current Request (' & GUICtrlRead ( $idLabelIndex ) & ') was copied in SciTE Editor', 1 )
	Else
		ClipPut ( $sScript )
		_TrayTip ( $sSoftTitle, 'The Current Request (' & GUICtrlRead ( $idLabelIndex ) & ') was copied to the clipboard', 1 )
	EndIf
EndFunc ;==> _RequestCreateAu3Script ()

Func _ResponseCopyToClipboard ()
	_GuiCtrlPicButton_SimulateAction ( $idButtonCopyResponse, 1 )
	Local $sResponse = GUICtrlRead ( $idEditResponse )
	If $sResponse Then
		ClipPut ( $sResponse )
		_TrayTip ( $sSoftTitle, 'The Current Response was copied to the clipboard', 1 )
	Else
		_TrayTip ( $sSoftTitle, 'There is no Response to copy', 2 )
	EndIf
EndFunc ;==> _ResponseCopyToClipboard ()

Func _SciTEGetPath ()
	Local $sScitePath = @ProgramFilesDir & '\AutoIt3\SciTE\SciTE.exe'
	If Not FileExists ( $sScitePath ) Then $sScitePath = RegRead ( 'HKLM\SOFTWARE\AutoIt v3\AutoIt', 'InstallDir' ) & '\SciTE\scite.exe'
	If Not FileExists ( $sScitePath ) Then
		$sScitePath = RegRead ( $sRegKeySettings, 'SciTEPath' )
		If @error Or Not FileExists ( $sScitePath ) Then
			$sScitePath = FileOpenDialog ( 'SciTE Path', @ProgramFilesDir, '(*.exe)', 1 + 2, 'SciTE.exe' )
			If StringRight ( $sScitePath, 9 ) <> 'SciTE.exe' Then
				$sScitePath = ''
			Else
				RegWrite ( $sRegKeySettings, 'SciTEPath', 'REG_SZ', $sScitePath )
			EndIf
		EndIf
	EndIf
	Return SetError ( Not FileExists ( $sScitePath ), 0, $sScitePath )
EndFunc ;==> _SciTEGetPath ()

Func _ScriptGetVersion ()
	Local $sFileVersion
	If @Compiled Then
		$sFileVersion = FileGetVersion ( @ScriptFullPath, 'FileVersion' )
	Else
		$sFileVersion = _StringBetween ( FileRead ( @ScriptFullPath ), '#AutoIt3Wrapper_Res_Fileversion=', @CR )
		If Not @error Then
			$sFileVersion = $sFileVersion[0]
		Else
			$sFileVersion = '0.0.0.0'
		EndIf
	EndIf
	RegWrite ( $sRegKeySettings, 'Version', 'REG_SZ', $sFileVersion )
	Return $sFileVersion
EndFunc ;==> _ScriptGetVersion ()

Func _Singleton ( $sOccurenceName, $iFlag = 0 )
	Local Const $ERROR_ALREADY_EXISTS = 183
	Local Const $SECURITY_DESCRIPTOR_REVISION = 1
	Local $tSecurityAttributes = 0
	If BitAND ( $iFlag, 2 ) Then
		Local $tSecurityDescriptor = DllStructCreate ( 'byte;byte;word;ptr[4]' )
		Local $aRet = DllCall ( 'advapi32.dll', 'bool', 'InitializeSecurityDescriptor', 'struct*', $tSecurityDescriptor, 'dword', $SECURITY_DESCRIPTOR_REVISION )
		If @error Then Return SetError ( @error, @extended, 0 )
		If $aRet[0] Then
			$aRet = DllCall ( 'advapi32.dll', 'bool', 'SetSecurityDescriptorDacl', 'struct*', $tSecurityDescriptor, 'bool', 1, 'ptr', 0, 'bool', 0 )
			If @error Then Return SetError ( @error, @extended, 0 )
			If $aRet[0] Then
				$tSecurityAttributes = DllStructCreate ( $tagSECURITY_ATTRIBUTES )
				DllStructSetData ( $tSecurityAttributes, 1, DllStructGetSize ( $tSecurityAttributes ) )
				DllStructSetData ( $tSecurityAttributes, 2, DllStructGetPtr ( $tSecurityDescriptor ) )
				DllStructSetData ( $tSecurityAttributes, 3, 0)
			EndIf
		EndIf
	EndIf
	Local $handle = DllCall ( 'kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $tSecurityAttributes, 'bool', 1, 'wstr', $sOccurenceName )
	If @error Then Return SetError ( @error, @extended, 0 )
	Local $lastError = DllCall ( 'kernel32.dll', 'dword', 'GetLastError' )
	If @error Then Return SetError ( @error, @extended, 0 )
	If $lastError[0] = $ERROR_ALREADY_EXISTS Then
		If BitAND ( $iFlag, 1 ) Then
			Return SetError ( $lastError[0], $lastError[0], 0 )
		Else
			Exit -1
		EndIf
	EndIf
	Return $handle[0]
EndFunc ;==> _Singleton ()

Func _StringBetween ( $s_String, $s_Start, $s_End, $v_Case = -1 )
	Local $s_case = ''
	If $v_Case = Default Or $v_Case = -1 Then $s_case = '(?i)'
	Local $s_pattern_escape = '(\.|\||\*|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)'
	$s_Start = StringRegExpReplace ( $s_Start, $s_pattern_escape, '\\$1' )
	$s_End = StringRegExpReplace ( $s_End, $s_pattern_escape, '\\$1' )
	If $s_Start = '' Then $s_Start = '\A'
	If $s_End = '' Then $s_End = '\z'
	Local $a_ret = StringRegExp ( $s_String, '(?s)' & $s_case & $s_Start & '(.*?)' & $s_End, 3 )
	If @error Then Return SetError ( 1, 0, 0 )
	Return $a_ret
EndFunc ;==> _StringBetween ()

Func _SystemModuleInformation() ; by trancexx
	Local $aCall = DllCall ( $hNTDLL, 'long', 'NtQuerySystemInformation', 'dword', 11, 'ptr', 0, 'dword', 0, 'dword*', 0 )
	If @error Then Return SetError ( 1, 0, '' )
	Local $iSize = $aCall[4]
	Local $tBufferRaw = DllStructCreate ( 'byte[' & $iSize & ']' )
	Local $pBuffer = DllStructGetPtr ( $tBufferRaw )
	$aCall = DllCall ( $hNTDLL, 'long', 'NtQuerySystemInformation', 'dword', 11, 'ptr', $pBuffer, 'dword', $iSize, 'dword*', 0 )
	If @error Then Return SetError ( 2, 0, '' )
	Local $pPointer = $pBuffer
	Local $tSYSTEM_MODULE_Modified = DllStructCreate ( 'dword_ptr ModulesCount;dword_ptr Reserved[2];ptr ImageBaseAddress;dword ImageSize;dword Flags;word Index;word Unknown;word LoadCount;word ModuleNameOffset;char ImageName[256]', $pPointer )
	Local $iNameOffset = DllStructGetData ( $tSYSTEM_MODULE_Modified, 'ModuleNameOffset' )
	Local $sImageName = DllStructGetData ( $tSYSTEM_MODULE_Modified, 'ImageName' )
	$tBufferRaw = 0
	$tSYSTEM_MODULE_Modified = 0
	Return StringTrimLeft ( $sImageName, $iNameOffset )
EndFunc ;==> _SystemModuleInformation ()

Func _TaskDialog_Callback ( $hwnd, $uNotification, $wParam, $lParam, $dwRefData ) ; by Prog@ndy
	Switch $uNotification
		Case $TDN_HYPERLINK_CLICKED
			DllCall ( 'shell32.dll', 'long', 'ShellExecuteW', 'hwnd', $hwnd, 'wstr', 'open', 'ptr', $lParam, 'wstr', '', 'wstr', '', 'int', @SW_SHOW )
	EndSwitch
	Return 0
EndFunc ;==> _TaskDialog_Callback ()

Func _TaskDialog_Indirect ( ByRef $structTASKDIALOGCONFIG, ByRef $pnButton, ByRef $pnRadioButton, ByRef $pfVerificationFlagChecked ) ; by Prog@ndy
	If IsDllStruct ( $structTASKDIALOGCONFIG ) Then
		If DllStructGetData ( $structTASKDIALOGCONFIG, 'cButtons' ) = 0 And _
			DllStructGetData ( $structTASKDIALOGCONFIG, 'dwCommonButtons' ) = 0 Then _
			DllStructSetData ( $structTASKDIALOGCONFIG, 'dwCommonButtons', 1 )
		Local $PtrTDL = DllStructGetPtr ( $structTASKDIALOGCONFIG )
	ElseIf IsPtr ( $structTASKDIALOGCONFIG ) Then
		Local $PtrTDL = $structTASKDIALOGCONFIG
	Else
		Return SetError ( 5, 0, 0 )
	EndIf
	Local $Dialog = DllCall ( $_TDL_TaskDialogDll, 'dword', 'TaskDialogIndirect', 'ptr', $PtrTDL, 'int*', 0, 'int*', 0, 'bool*', 0 )
	If @error Then Return SetError ( @error, 0, 0 )
	If $Dialog[0] <> 0 Then Return SetError ( $Dialog[0], 0, 0 )
	$pnButton = $Dialog[2]
	$pnRadioButton = $Dialog[3]
	$pfVerificationFlagChecked = $Dialog[4]
	Return $Dialog[2]
EndFunc ;==> _TaskDialog_Indirect ()

Func _TaskDialog_IndirectParamsMod ( ByRef $pnButton, ByRef $pnRadioButton, ByRef $pfVerificationFlagChecked, _ ; by Prog@ndy mod by wakillon.
		$hwndParent = 0, $hInstance = 0, $dwFlags = 0, $dwCommonButtons = 0, $szWindowTitle = '', $MainIcon = 0, _
		$szMainInstruction = '', $szContent = '', _
		$szVerificationText = '', $szExpandedInformation = '', _
		$szExpandedControlText = '', $szCollapsedControlText = '', _
		$FooterIcon = 0, $szFooter = '', _
		$pfCallback = 0, $lpCallbackData = 0, $cxWidth = 0 )
	Local $structTASKDIALOGCONFIG = DllStructCreate ( $tagTASKDIALOGCONFIG )
	DllStructSetData ( $structTASKDIALOGCONFIG, 1, DllStructGetSize ( $structTASKDIALOGCONFIG ) )
	DllStructSetData ( $structTASKDIALOGCONFIG, 2, $hwndParent )
	DllStructSetData ( $structTASKDIALOGCONFIG, 3, $hInstance )
	DllStructSetData ( $structTASKDIALOGCONFIG, 4, $dwFlags )
	DllStructSetData ( $structTASKDIALOGCONFIG, 5, $dwCommonButtons )
	If $szWindowTitle <> '' And IsString ( $szWindowTitle ) Then
		$szWindowTitle = _TaskDialog_StringStruct ( $szWindowTitle )
		DllStructSetData ( $structTASKDIALOGCONFIG, 6, DllStructGetPtr ( $szWindowTitle ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 6, $szWindowTitle )
	EndIf
	If IsString ( $MainIcon ) And $MainIcon <> '' Then
		$MainIcon = _TaskDialog_StringStruct ( $MainIcon )
		DllStructSetData ( $structTASKDIALOGCONFIG, 7, DllStructGetPtr ( $MainIcon ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 7, $MainIcon )
	EndIf
	If IsString ( $szMainInstruction ) And $szMainInstruction <> '' Then
		$szMainInstruction = _TaskDialog_StringStruct ( $szMainInstruction )
		DllStructSetData ( $structTASKDIALOGCONFIG, 8, DllStructGetPtr ( $szMainInstruction ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 8, $szMainInstruction )
	EndIf
	If IsString ( $szContent ) And $szContent <> '' Then
		$szContent = _TaskDialog_StringStruct ( $szContent )
		DllStructSetData ( $structTASKDIALOGCONFIG, 9, DllStructGetPtr ( $szContent ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 9, $szContent )
	EndIf
	DllStructSetData ( $structTASKDIALOGCONFIG, 11, 1 )
	DllStructSetData ( $structTASKDIALOGCONFIG, 12, 0 )
	DllStructSetData ( $structTASKDIALOGCONFIG, 15, 0 )
	If IsString ( $szVerificationText ) And $szVerificationText <> '' Then
		$szVerificationText = _TaskDialog_StringStruct ( $szVerificationText )
		DllStructSetData ( $structTASKDIALOGCONFIG, 16, DllStructGetPtr ( $szVerificationText ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 16, $szVerificationText )
	EndIf
	If IsString ( $szExpandedInformation ) And $szExpandedInformation <> '' Then
		$szExpandedInformation = _TaskDialog_StringStruct ( $szExpandedInformation )
		DllStructSetData($structTASKDIALOGCONFIG, 17, DllStructGetPtr ( $szExpandedInformation ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 17, $szExpandedInformation )
	EndIf
	If IsString ( $szExpandedControlText ) And $szExpandedControlText <> '' Then
		$szExpandedControlText = _TaskDialog_StringStruct ( $szExpandedControlText )
		DllStructSetData ( $structTASKDIALOGCONFIG, 18, DllStructGetPtr ( $szExpandedControlText ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 18, $szExpandedControlText )
	EndIf
	If IsString ( $szCollapsedControlText ) And $szCollapsedControlText <> '' Then
		$szCollapsedControlText = _TaskDialog_StringStruct ( $szCollapsedControlText )
		DllStructSetData ( $structTASKDIALOGCONFIG, 19, DllStructGetPtr ( $szCollapsedControlText ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 19, $szCollapsedControlText )
	EndIf
	If IsString ( $FooterIcon ) And $FooterIcon <> '' Then
		$FooterIcon = _TaskDialog_StringStruct ( $FooterIcon )
		DllStructSetData ( $structTASKDIALOGCONFIG, 20, DllStructGetPtr ( $FooterIcon ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 20, $FooterIcon )
	EndIf
	If IsString ( $szFooter ) And $szFooter <> '' Then
		$szFooter = _TaskDialog_StringStruct ( $szFooter )
		DllStructSetData ( $structTASKDIALOGCONFIG, 21, DllStructGetPtr ( $szFooter ) )
	Else
		DllStructSetData ( $structTASKDIALOGCONFIG, 21, $szFooter )
	EndIf
	DllStructSetData ( $structTASKDIALOGCONFIG, 22, $pfCallback )
	DllStructSetData ( $structTASKDIALOGCONFIG, 23, $lpCallbackData )
	DllStructSetData ( $structTASKDIALOGCONFIG, 24, $cxWidth )
	Local $Dialog = _TaskDialog_Indirect ( $structTASKDIALOGCONFIG, $pnButton, $pnRadioButton, $pfVerificationFlagChecked )
	Return SetError ( @error, 0, $Dialog )
EndFunc ;==> _TaskDialog_IndirectParamsMod ()

Func _TaskDialog_LoadDLL () ; by Prog@ndy  ; use native for vista+ or load embeded dll.
	Local $res = DllCall ( 'Kernel32.dll', 'handle', 'GetModuleHandle', 'str', 'comctl32' )
	$res = DllCall ( 'Kernel32.dll', 'handle', 'GetProcAddress', 'handle', $res[0], 'str', 'TaskDialog' )
	If Not $res[0] Then
		Local $sPath = TaskDialogDll () ; for Windows 98, Windows ME, Windows 2000, Windows XP and Windows 2003
		DllClose ( $_TDL_TaskDialogDll )
		$_TDL_TaskDialogDll = DllOpen ( $sPath )
		$_TDL_fUseXTaskDlg = True
	EndIf
EndFunc ;==> _TaskDialog_LoadDLL ()

Func _TaskDialog_StringStruct ( $str ) ; by Prog@ndy
	Local $struct = DllStructCreate ( 'wchar[' & StringLen ( $str ) + 1 & ']' )
	DllStructSetData ( $struct, 1, $str )
	Return $struct
EndFunc ;==> _TaskDialog_StringStruct ()

Func _TrayMenu ()
	TraySetIcon ( 'c:\tool.ico' )
	TraySetClick ( 8 )
	TraySetState ( 4 )
	TraySetToolTip ( $sSoftTitle )
EndFunc ;==> _TrayMenu ()

Func _TrayTip ( $sTitle= 'Please Wait', $sTexte= '...', $ico=0 )
	TrayTip ( ' ', '', 1, 0 )
	TrayTip ( $sTitle, $sTexte, 5, $ico )
	AdlibRegister ( '_TrayTipTimer', 5000 )
EndFunc ;==> _TrayTip ()

Func _TrayTipTimer ()
	AdlibUnRegister ( '_TrayTipTimer' )
	TrayTip ( ' ', '', 1, 0 )
EndFunc ;==> _TrayTipTimer ()

Func _WindowIsVisible ( $hWnd )
	If BitAnd ( WinGetState ( $hWnd ), 2 ) Then Return 1
EndFunc ;==> _WindowIsVisible ()

Func _WM_GETMINMAXINFO ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $hGui
			Local $tMinMaxInfo = DllStructCreate ( 'int;int;int;int;int;int;int;int', $lParam )
			DllStructSetData ( $tMinMaxInfo, 7, $iWMin ) ; min w
			DllStructSetData ( $tMinMaxInfo, 8, $iHMin ) ; min h
			$tMinMaxInfo = 0 ; Release the resources used by the structure.
	EndSwitch
EndFunc ;==> _WM_GETMINMAXINFO ()

Func _WM_NOTIFY ( $hWnd, $Msg, $wParam, $lParam )
	Switch $hWnd
		Case $hGui
			Local $tNMHDR = DllStructCreate ( $tagNMHDR, $lParam )
			Local $hWndFrom = DllStructGetData ( $tNMHDR, 'hWndFrom' )
			Switch $hWndFrom
				Case $hListView, GUICtrlGetHandle ( $hListView )
					Local $iCode = DllStructGetData ( $tNMHDR, 'Code' )
					Switch $iCode
						Case $NM_CLICK
							Local $tInfo = DllStructCreate ( $tagNMLISTVIEW, $lParam )
							$iSelectedItem = DllStructGetData ( $tInfo, 'Item' ) ; based 0
							If $iSelectedItem <> -1 Then
								If _IsPressed ( '10' ) Then
									Local $sUrl = _GUICtrlListView_GetItemText ( $hWndFrom, $iSelectedItem, 1 )
									ClipPut ( $sUrl ) ;  10 Left SHIFT key.
									_TrayTip ( $sSoftTitle, 'The Url ' & $sUrl & @CRLF & 'was copied to the clipboard', 1 )
								EndIf
								_GuiCtrlEditSetData ( $iSelectedItem )
							EndIf
							$tInfo = 0 ; Release the resources used by the structure.
					EndSwitch
			EndSwitch
			$tNMHDR = 0 ; Release the resources used by the structure.
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc ;==> _WM_NOTIFY ()

Func Buttonclearorange1Jpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Buttonclearorange1Jpg ()

Func Buttoncreateau3Orangejpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Buttoncreateau3Orangejpg ()

Func Buttonexitredjpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Buttonexitredjpg ()

Func Buttonhelporange1Jpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = "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"
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Buttonhelporange1Jpg ()

Func Buttonrequestorange2Jpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = 'XQAAAAR5CQAASwB/thvt8IRAWOOR3hAnWGGKZ0KCRqdFVqsz28OpebQ+SgSpdExIs/PcoOJmgoCU2IovKQHR+WHzM8P80j//BzXvBN6yUIbNYinE82ajEYb6XX42HalnkrRWbNI2qv51eVwQAcqoKvw7HmJUwFM/1C1Sxhgk4tJAa8/uWbrDollal8znWX/KXabqwBuySlRnqg/e5NmtcyLFXGZzYTh+tQc+SQE5Dyc0XgqfpLGX3FP+RTVwevkoNMMaEigWN2bHW5Hg3F33pNWGoNy+uCEYINx4+OOq8GYcFedc+slSbNt1p6wza14PaUtRvu1h6cp6CPQ3uOcAQun2d5xHl+8df6ouodky1m/Bsyf1F0VTe7FrIXU2UidtKrUYWz07ofXdzbO5SU2WkBeNQemBqCr1JfWr3+Hx3PtjrM50AFx/94ToCHnb/C32Ke5zUCIkUXWkqxRCdd7xqAJDKNf227q0igDEm6F38WT2RcrXLOqQlPYWbuzbEkeFltULJ5p4by9bZhwsjpT3Z5LiTy54Lj35a09trCx8UY8pfnKPsAQtaeQ3+R202eCWtvkxCYi9jdzJNNlcaolaAyYFvPuNpfFJwAUwHqIX1I6RDfAdC1dMAE8vH+lZzu6kw+oQP+AfklZEMM0/HBrVPcxQwYtewSQRN3xKmmBlwNKdGoAxQSoSb+/111yTVSWOZyzchpBUx4ESriTVSodBv+zUUS55FNh8n9iWvb3x1zlZRpS/+TvYEYV84fLsopJI0Urb64Kywipv04lhR03Jj02m9pveX+JZdC6FNthGRfcTMNC3cRXssOsjtfTMJxfkhhdEB60+xRUtMciAQS7svD2IwtLJNvpYAAJMqevPrJxdDim79IYUXSqQEP600f3RvYwnrzr2x2BZiaz7dX/AfK5Zdhp5MKO5zu3ucAsDOJ6U98as8TO4bA72VKy35dmeMtQV5UpCyIED7FHrlon2ngQdJ5Y0HM/pbd9m3g/PFEr/SHd878EO4gqdY4MbPn0wLHioQ1rOqkcDedL1FN9mf2wSnIx1elx1UI1jYR2ohP+2uI2c7vg6Pd/8liPBgUHytHcy4fqm0UWzRQ5W8dckAfsjmQB7CAuuKMncV3DMbnC7JIlgkm/XtOqr5t5eMsDjLGd92uOo9Sito2DDFW0YHFY895ffLA72R+pomPYzByKoMGtHAqpvHLENKGb+3xw1GDxdzwoM9WPEV+MCkLaVWHyg4gXjFUXBNb9z1q97UfoPZqePuOSh9g2Uf92nhlkamlN8ENlUa0PPZukMLmhhuQm1ZIVKSjcZY9CozOMdCzLSTOtl/6cghLdHeLAawe4hjbA9B/YJjKNQdzzFKtsljlWtFZ3vlrMq3281uFveqrzn+mGZ+MNNmCy8SuMYTbfGc1uX2Ra39cDUyAEYQQSHTJWMHaL2S3DrIXhcmJJS4yRLdXiRXyJAfrr1MA2b7gb7u6tkUmA1JJZX9kJz95L4RSr3vb3KoVmFXCM79ALz4FuyedazNW8liYdSQkdIwOXC+wLatZQzAYTdQq9X2hEdck6QZetRdZNmC7oW8bhCtAMifsMu86d3h1agxgfdC6txBzn1o9n5kqsZNr0L4bAlPKuLNE8GGui2rZq7sP0PiaCQn3daI8nmAS0DF6zAZF6hXKM2A4FVqIGjmhjjblAv2hQ5mPJz79eWDMYV2X2POO4S8Yvbx7jaLkvTqu/BAsb97uKprfxa7mnuNdvcqhRiNeOvAYPFqd15fQPkUIavLnSh8zRDkn2p7X1Q2RUMObfhckW1UhNIRz9wfENNvyYLMJcGSorafGN8iJqh1iv5Qy7yv74WV4xQp/TPjWcEe4HAS/YcJJVM4pphkpSG8yZDwVfFI1Q+nVbQRuYXWy/KRAUBLt4uMSPSqN2m9L7Nx/jKKiZwiWFk+/f8/9bfkionGb/vBtrt89hWnLtyUt3oQZxa3JIgNIA/j+8h34bg0FbCBZkFGN3SO6QWStsm1b5J04S+Xbe8Ud9txCri9zmezEftITmdk8JdAxogPLl5fseU+pmh1fHk761R69xXuybFxB7KYjcBsj84QXztd9+IvTRuDWam69LyyaLIuDDEm4Kj/Sg1FURV249oD+O1PU5FSPdtN/7Chg+nH+Erd4fdDvPnA9hOzH33TMPqH9V4l4O/dfU22zhwwAy5C0oT5w0X8QD4w3+qreeZbu2RJPUgKyay4jFTcs4rDkWAYBbh7AsN29EugO+6OCUENc0M2n84rvSVYsDdBrSWmZSwXIy6lGPAjYQyt464VzpIBdJnnzCcJ8l1+BWy268kRhchoeWOXefjRb2YmFmXyBvIKhrtRN+6FJ+qvsb5b6wZtz0X6hB5WNWHUWuC3whcWGqSFaqfANZpl8A8ye6aMlXnu8gVcMI9p2AL9m58KRNm63t2tKP2hTG+KY5QSnRRDSt/w0buWetiEI8eWqAQAeXrRtSwodV2g2AsYXpKua4Kg/zgQh3XwIKWA0T4UM4tinzYCMxIFFux+UpYEXAuHeo2+7tmWygJHxnK4EWKQb1/rrv5Zr0QfwZQYhKpS5aoO1J5NPi9memZePt/MTVjkfi2VUeLuK1K8ZXmjadnrIWIVaiKoibkrValzU7CKVK4+TeI0y6QJgWRjCKL/pkVoo15SKTIbv68ztBG9OAdjiPIc2rBKBciECEJXfNYc8PE+ZOdkfXiob0FuKqeE7JqPcQiB+7ayoOjt8LCQAn67T98AYyPs+4n6jBLpkpKWxDivV4JDHH4KuKT/zKvxUQCnstGxxgKUhG4O+JVIDv9T5WBHE+tqbcejBKFCYo2xX4eblY8pBvGBqa0W817my4YcBN3CxK1pzLFTvQEfBxXEkE1kh653ps9faqgd19PPfMmZnYEe341LYZ3giWDTcEvifYWkUhymyO0OEjpBnn5Eujkg6pjtNuE8Z4CFs7+Z5TjsVqzXDbvlTAN56IOgjFBYJETcemh68QThYr9kwO82TAwn4g4PuQnp8WWnp/UvT32rahLTeu9MUJJ+B3Pa9o/RSgQkGla/Nmg'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Buttonrequestorange2Jpg ()

Func Buttonresponseorange2Jpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Buttonresponseorange2Jpg ()

Func Buttonstartgreenjpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Buttonstartgreenjpg ()

Func Buttonstopredjpg ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Buttonstopredjpg ()

Func Lzmadll ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = '0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000D00000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000A343B8DAE722D689E722D689E722D689643ED889E622D689883DD289E522D689E722D789F422D689693DC289E622D689E722D689EF22D689693DC589E322D68952696368E722D6890000000000000000504500004C010300448DAF4B0000000000000000E0000E210B01050C00600000001000000080000090E100000090000000F000000000001000100000000200000400000000000000040000000000000000000100001000000000000002000000000010000010000000001000001000000000000010000000C8F000007000000000F00000C800000000000000000000000000000000000000000000000000000038F100000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555058300000000000800000001000000000000000040000000000000000000000000000800000E0555058310000000000600000009000000054000000040000000000000000000000000000400000E055505832000000000010000000F000000002000000580000000000000000000000000000400000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000332E303300555058210D090208106E62B27EE4412138C300008351000000A4000026030030FFFF77FFC800010053B28CB9060088C82C01516A0859D0E8730230D0E2F85988FFFFFFFF840DFFFEFFFFE2E68B5D088B4D0C8A451085DB7413E3118A1330C20FB6D23284FFFFFFDB15001DFF43E2EF5BC9C20C005589E5FF750CE80300974283C4045DC3FDEDC8650F48C81062536A058F45F8DDFEFFBF4E0C833B0A73088323006A0758EB5A832B0AC745F01D004BDBDB6DB306F45B8D0D50503C1C6A0009F8EDCBB275080802181410538B4536DB7FFFEEC00A505647FC8945FC83030A9C45148943052D6A6BDB76F70953E82A92884309722C15FC9876FD9C6C65145DECF0836D14DD6EFFBF344D108B550C8B0239410573058B04890269EC509EEDB6BB03F45045055108145069105273FF67E77E6D670CC424837DF4027505B659F2CC7D5D5FC9E553817BAEFE777BDBCA381F8B8DEB0F686B016EFFFDFFC2CD3C31C05B02435243204572726F720D0A00CCAE61738F0055B80192435D4090008CBDBB734EE1C7000515C74024000604C9C9D69D2CD9FF06201CC9C9C9C91814100C0FDFDEC908283E7C908D7426A4567F2F2C6CAF55311ACA0F88EE7B1A8B423DF6EEFF0485C0752583FB050F8F8C118D4C1B0E96D3E089B2BD5FBB1A8DB43514BC27062B08E7F97CB73815010A0CFE0010963FCB9FE7721485F6CB4A1885C9A9ED32F67D5A1C6F8E2B207867746DFBB79B240ED1F9178D41107502D1F86B241B1582B59B2C2B5B5EAD7636E81EBABF96060F95C048250CFE150493E977EB885D54022CCF90096FB8021880B50905754B433FDE601FDAC76D3DEB900FBB426B7763EF3E01FE8DB65FDBAD95C3899F536BFF72F66E906F9F83E0E08D484089C217D76E98ED631404F3F089DE100AE57BDB585710730B4DBBC22097C10B420803376F1BDF7F23A4E583EC3C8975F8B9248B4B8985EEDFF87DFC8D7DC860C8F3A5890424E88AECF125CC2EB7CC18F88B89ECB86FB7FB6EEF55BA664357BFDB563F53BB110D0BFFEDC606024601019089D989F84349A9C1C2DBFF6FBAEB0690881C32404239C872F743B2157EE109F962C7DC5F51E98DBF4F8E18BDF1B799897310895DF48B460F1F39D87BBBD02EF589C30A5F5C241A44240495DBE51D6F0CA0BF60295E08015E1A1F6B7C97B98B2DAA764F575052351ECE7D1CBB4848A73A5CC1F76F6FBF210881C280C33C05102C0489142481C718BD0877AF8B39575125B9312A894C2492452E772BC80B04587425B9BBBF93B000528248191B870897C9EDEFB680CF8FF042C1E3058D343B0190A37DB7B74EB583AC25288D930589CCDBB22C4BB789410508080C0CCBB22CCB101014141818BFB6B92D1C2F8C27411C3E088D8E17027BDDE401CD8605413BDBE9B75AFFAD1D'
	$sFileBin &= 'F00B0F8E67760C03427BF709F08D9F640981C60C2906AF77EBBBDB74DAB8801883EE80891C4DEB80EC7B6BFD4808FF4DF079E0972F97640538C8C8F7B7812C918784010B3088C8C8C8C8348C3890C8C8C8C83C944098C8C8C8C8449C48A0C8C8C8C84CA450A8C8C8C8C854AC58B0C8C8C8C85CB460B8C8C8C8C864BC68C0C8C8C8C86CC470C8C8C8C8C874CC78D0C8C8C8C87CD480D8C3C8C8C884DC88E09C384EC7F8C8050C2B2DB9E42144EF4663605CCF31F02B2C1919D9CA48060BF44CF81C19191950FC54002C323232F258045C0839323232600C643819C8C8C8F3F8963CFC40979F91E7009744048AA0BCB8009D8E3F743AD3E68B91A825ED1C913608B2BA54291CB373226958AF5F102CD353026480C35A05649E4E03A45F5665892A7D84745F0301FB179636687056DC14531486454A81F40B5F50BD91DA3B5F08476E86058C2C43255F5DB7C329765B80E4BEE4F25832B29DDAEF640B8830323232328C34903832323232943C9840323232329C44A04832323232A44CA85032323232AC54B05832323232B45CB86032323232BC64C06832323232C46CC87032323232CC74D07832323232D47CD88033323232DC84E0884C96CCD65587875874A719416A416E5E56C791CE7824D5896B8B9AD191EE34D28B6589710B5091919191F854FC58232323CF002C5C0460089F232323640CF8963819798E8C3CFC3C009740D3E91919044417675C891348A56A5E89F65FC2C4480C9F4C048D4874749F6EB81B83189038895DA8B8A54D8FC142B71BF90822C991C483FAFD347FB6040BBD75C883FEB145BC3D6BF9CCCD062587A30A40989FFE7DC9F483009EB5DC89BB040845D083F857B6F8DD33868F251101BC76060D2FE1B62630BE6B8993984ABA6FB85FBF04398B9427B39C05FECC000FDB75BFB7941D83A4BC43D4850AEC36740F50BAC4ED65D8017E4C04037FC6C289E776044E6FBB7145E056E0BC9CCD456B3F16C70EF80989435F2FB80FD43A16BF7811BF0B8B7AEBB472F421CC0E2F8B5020ADA391ED395B0D060C007D767DC606011314C6406A5018CEC9168C7D062C30E8B2782F384F8F5D856EB150FD93758E70308E521BD9B674795D8C759011FC3C8E75A3F18B53B329C68DF587FE7783FF1239F07407C7433009C2D2017328D1B2ADBE932011532C04183B05BAD896EF6110D970058E5AE1BBFEA6FE76308B48DFB97EFF568BB52942C05F6E4B1483C20183D176B56CED00C1E6610E8989A0C4106F15728F4B2FFAF48845F76DBBDBDCEB09182A0C21004DF7741817876D77FF55F788104039431C7B7441C622FF4CFF36EC1B2CFFA509D075CC6550236B93FD89F0C1E8186788536A1D1078C789D86B0C7CEBB6FF89D7365A0BF3C20C4C8086F051ABFF1723890B74458B034E89F1D1E8960DBFF0AD94F255F0D3E8E401F7D821D00F43FDAEC085080C0C812BEE0077CEC165F083EDAC2BA725035CDC3E755F61241B246F0C2DF091E9C60D89C613213835BCFD37FF0FB71A89F9C1E90B89660FAFCB382B2BB4DD2C5F08CA29D8CF05775D4B18FFB781F96C66891876328916508FFB7EF7AD4EF8D811560C2B89FA29C329CA8DD13103DBD025A1E119890E36D3E163BFE9A96690FFC75689D60194B765386081CBA93F5789DA36DDDA6D5607FAC1EAB11456AC01DBB7B6D0150FE70E00FB5FE376DC9B188C210F573B56BEC1634BB9A13C4A084231C9BA851768EF4B1FDE63C9EB0356B4B7F6DF413D3C77F64A79EC619C83C31060D82DD76D80C85307326A76C853B7B3C5B64FD15198C97FC6536887BD5652489FC89D5B68EF6D3E144608A65DA325438742DBFA31C2C1418B483D0812D2AC75A7D488A66F86D79EC55F5C31FFB6070AD6150AAF049F441FECC89FE90CDBEE21F26501D0FF30596D50EECE5400CE70033C90EF330A07FBC8F7D021C676BD5A2E02381763081F6DD26008F0C6035185C655EC746F9460578B064FEC4FC118F8666B106E06D3EB83E30169326E1722722809D82E75D9560EDC72584F1C0C45313CECBB12B82910753955E85F7D34ED7FB624CF5F1C89FE83E601D1EF60AD8DB91BB23424635BFF38BA8009ECDC09F0423B7CD6CA1D8EC3482F2F31B45684FF80C231F6E0C6E309C3EB2856F80BBBC22BADD1EA230457F7DB81E30B1B5B701AD931C6F8521C19AF6DFF8101DE89D383FB01BF5BC85B7FE4DA77807AC4081DB347032FD88585D2511D2ACADB4BC3F6F183E153EE777801FFF7A4CFAD50480873E4A62E69214BEE4B75D4D96F081D6D81025B6166176A0405ED0DB6BF000444500406425D7F76F31B986B4DDB90B90B00238C1484155C1630CAED5F1F025AB660D881FAD1D2EA5FA34BF34D3FBC2055800415F686AD90CF944DDFEC8D0413B6BD6DEEFF17C1E00689CE8D8438044B14E811C281F26F8E8DEDC008D24604F7C1818B0C6DCE6CB7910E57021EE4151286C2B6DD96242101C819E0139673FA49E2A588894DDC5F3B75EC0F8307228D706BC80867CAB1B1F0F18D443B0407CCCEE4B88BD1DB4BDC0C04B246460776CE040F773D03EC1CCE76A3163F736514B5B5D26C46F83BDFA83A01E6DCC122F1414DE03F80418F3DFC3D0F76CC33318D9F11903AF0BA08E49BB9262D3577DCF0E862973072D63F480C0964C3BDCE848F08095F2081522B021FA8E524C12E18F8D639F32360731B26B75FEF536FDA436A8311DC1F72EC1BD813020DEB0D90004FC9391E18286AC32C4B7734F8D8DE589A106B4548A3DD602A6438967756C756C3B70D4C3A8911F5897CCFC1E2F13BDD0B29541A041D031B100CFBDD5DC06BA77416'
	$sFileBin &= '228B8493CF488907A44B5837157A915501156CA10D7080286ACFB6972DE7026B8D4797446E941A5DC2DE0F82EB8C903C27100803EFB03D472E938131CB21D8366913CE7F96E87928198703AED887EA28AF6EBAE930C111617504C97F0190342FB7A00141548E4018FF51140242C06816FF3F1568AF1D365726AA2A4D77F7F62B53628398068C839C10444443714325227439C67419B45B28B6FE85940D942039BBC64A6C3A7C15741ABB76F81896101E61322D41DB5DB864103D48FF5C13983A8B9367B5E950E9407FC423772A6EB1E1B6092B0639D7B773B224040733DCB6975C0F75A9CF471273A2041262C2EF0774EFEB94BA33EBCF1FAB52A9B94ECA53D051DBA506C74D6D016FE9041284BE4FEDCF538C948B9C0E06818483095B78181835C6CF0F0CCD420B060541892E7CD79CDB26039C0675465594485BAE0E4A6D3E0CAAF5EACEEFF47C574635CB559C860D5C17DB5C9606408B4CA4C8EED00CAC46003048447607DB0A93013374344C4E5C3D45E440949E292561761B9ED3814E74004DBE37ECEB96336A7F8C170B4BF274CBDF9FCB51814AFC9F37C73E931BE3C396E3A54307CB348DF40D469D487803F2F0EE15C16118BD54330C1A304E136D205F4B5210EA8D023BE4045B0EE08430A0CBE17EFCE078144F9E880B178F36B6E1991E01F0D7059015E4216A6078D31453568D0C7F58B2D310C8DD79829C18A00DF3BD1BA60E9082B4512F18BBBB2957267BE7840E741581C17005B3DD04EFC273034431140610BD91BA5B184F7F89E3EC74321FB58D56BC3B8B7A1897EBEC08DEDD8E1B395A142E85656A8B86B83E5782D73AB1020A6B5F05D096C5235856EF6FA8016E9480FCB2E5C6418B82D8ED4EA5730B0939AD980BB8BF5716E0B1A7BC051418B995B0309F018AF49F0FA193752F092EEBBAAF8DB09FDF17B8A80FB7014D98F488E08B574B3DC976BBD84F38FBA1D7ADE84B79F6097CB7AE5998D68F1517E1B0A417B4D714CD9F4DB79C362A1C2C7021D68678F83BEB29161370E8D8A397214CF0B0DA0CBC9457DE14E30BCE1A87D9975BAD579CFDF5A060891287A0604F0DF01604D283BF57003D8901B700B3DE446EC21CD4F06DBA9D46137C1406B83F5E977D8D3D5C717A7E10FA1A9A5DC3184FBA8D032F0D9C04DD811C790FF02B5CE118BF1F2B83720F8F8D802B538D193538BDBEAFD00A56030F68A7CB0B18FAC8F0C283632F849E4C04B95D1B14F1FCDFF9BE8C0D7F236C08815F585381EC5ADE0E8634F48DB585DCFD90EDAA6BDC97941EBEA6D05995D481AD16D8128D780CE2B0CAE0A946C77EF9D3E28B8D120456580B68F3FD5A0C32050AD54CD92973075B5A7B0C70FA949DE81D947B3BBC85B2AA8D862ACD4C1D0368DF16A9A6D8B870B71910E4DD4BB98FFDBD90B589898DE00D83D8B7458BF8C504955F8B10DCE183D88B3507BA8067674BEF24C5951CE6933E42B35FFDB1890F39D077C3BA0EDDF80E1195B664DBEB2440E04CDA83BDFB3DDB3AC66D416F398E3E77DA7F71F86F6D8B134E8F4183F90376F4B91802A76121FF1F0E1FAD366BDF8DDE03792DE49750E8A9BFADA28081C3A381CC26C75FC15929DA0F891F10EC70D261C786F05E81C47392761F1D31189F40C783E58DCFF712EAB39C01FA2000ED346C8EF858F0BC8D43208C8E8C89B3834FEAF1EC8D75C81B018CB4850AFC90EED96B49A22A039C0D0EC7CF35F70EEC8667EB0718BD275B9404CA400F6F2830BCE8CA54049314CB70D3D94F3CEE2FC37408441BA44541CA5514AC1F513055F34FFC5DD989B92D3159D70427040F18BDC61A1A03C7E49E238EC12349F019B0DF7B08C3600FF4108910F483C5E0D016D4FEECE00EB27B0BD701006D6C60750FD2A17940161C3C8B383C89D70A9D75571C0CDECACEC1902D6FF84DBC8223DC60C85C69365BEDDD88321C0F4B04A5942964B073AE3BFFE13F490DFC3E51008008EB55B0511BB07089D78B96F486743B02FC4163C48BF8227E861A6663F1F2464A1628158E580674F13DF9CFDF60EB0A1C15074FC045E876F5457B059669A4ACE845A89DEC06CF1309C1019E00505608C08E6DD02E1508AC3C184C787787527B8D55C41476271A14BC8984402BC49DA0135337C05960836B055732B659C09C3A86341CA1200CA1D51BA1189E12E85C4B876DD8740896D420C0BEBF57720E6D573E9CFF8E31FF3D7B2DD7B0280179A389BD305CB7EA2236845A0B7FCC7C07DA5F8215786DDB499CDF0D9806719C08949C4F6C23BC72986A45C0F44BE12E76A0BAE724A0010F8673B1F614ED84095B0721081463DB61AA0C0F986CBE763BD2F66DC90E94E258FFBD40FF98444BDDCDB08885AB0590E78EFE5803F8E6DA29F1128D7AFF3A42FF5418ABDC91820426DC69E0F67EB4639E613995397BEF08D076A399AC879F766F1CBCDCFE5FA221907C93FC763F8B4493F0403BBF75354BD02059CFEBA83B146FEB6F17F476218D42FEAF02D52BF18DADC530836D4D9C760BAF352845F7658339C874D45002FDE2D4FE3BA7FF7F0F97C285D07411B903D72EDB120F74945A8BD067D2EFCEF50F831A6A0C83C0020E93C2F5ECEDE6DA81A0313EC085D085FB011E66920119037FDCD9FE42063FD40F96C08AA0DE85087F96C209D0A801730ED3098686A5183BFBA48B1C63ACCB1AB66F972521C72CA401750A05C035F12D0A1286F8C25458688B1926E333AF3F8CDA25D9721A2B030F4689D9B0479A312ED6D865BB645645A8C0A603292CC9810C00441E3D723B5AE0DC01F26BF36CEFC2F8980F95AF0C1451058C192FE3F8A0E0F290573AECED8BE429D0'
	$sFileBin &= '890A01688317E2F1C1425EBEBD001A83C4A1ED81BEEB7FC4D7827A42BA8D910F0CBE06A474638B2E015F6A165DC54DB029D82A84066E54821BAE052C1136C77346EBB2F9DDB2C8BC72C0BC4D0899033719D9DC5D0B1396D4050BB8BCFF0DA0BB05002065D2CD39DA770E0F82B6FC86335B07D2C807AE62313296A9858DA87F4011ADB5ED227B1DD67A980DC1EFDCD7AD94D6C04A0E8C0B18204C8B8EA312AE47394117FAB254B91D55849B28031C490B50EA739C501C1F6CC02CC46847D029CF6CFE7D81E0F88246550F9590914B68968696930119398686BEB42108957C8D7583EA11A1B3B02A14B7959AD04A75D50A838DF82F0845289FB8694402AB9C06E61B697BB1B39681171C10A4C532F06A6D07860A35EBB44C4610D50410FB2E165CB1D7445B38C02D0B152016FFED00295898DDB6D71A0D46B5048F101B66AD16AE748D1E3D14A143A5C30EDE455FD562DFE00D86919191CD950B3C4038BCB1709D3CBF1A891474F1483F3A212B3D8686EDFA38D20C261426B8AABA108E6F66435F1D67E347013843B0DBCE35D571FB1390DE4FA039097356686FB6201B42027517FF0D3113DF5003CA55B5E2043A38041AC77AD6DB74E9DB9039BDB1231B0839C7C746CB6D0A284879187D0A28E4C3E11F3A9B8E5874277C03523CA0D2250F9C9214427AE3D6AC1C21BD99FFD2843605FF5C4C0BB38021FA0255E55B92E91A74CD49039670259C107D9E83D8B11FF8A10E46968C2A0D22FDAFBEF5FFC0B92E29C1C1E91FF7D983E1C4C106D3E8F16D45365784B44828E002274E2C54BC694E450EBD5ABB111EBA071BF16052AB9D3E07111E0783D3DCC797048EC48D7C15E70D1C84CAB88B9EF2DC60A97C8C80BDDE00808386821C803BFFC12DD52D31B87837483B74E44212C2E90F5F84BE4BBC466F9517ED05A4BD70B7068DD89E5D08855433FFA235EC15FF385D7225734CBDC8476DEF8D064FEDC68BBD519530DEAEF1F63E5C1539C30FF7AD3B85A1C36F43380642955C4186264FD5BD0BB15CFAD88B83560960E2FDBBA083BD2B01888D5B264B0ABC25762338C14A5A0E6848EC76D011567416E47711B4193C1C285B454B2D360BAEAD92AC763F4821C30F7E3FDA13A0279D74999E944DBDDA041B70BE0588D98C66DB019F7841FFB9B229D922A83D186EADD3E8ED0C520259F81FB8E04FE7D0C1E109E86001DC9AEC82D9B4FF062A15043B528DF795B2E62A85A457BDEF76813BC8E8203C8D3C03BBAB1F5E8783519EE8BDE53FBECCE616720FC5D865BED40A6B609710B368048455E442BCD8684305275E2C85B37D068C01CA878D6711BA9FBB642B388D5A84FD166F959DFC6EFB182D8B5495C821700939CA7306898DC80D5EE17905B887B10C1C38BCA25A900F0C3546048DCF838260D25D21F6DD83E70F28C001633DA9CD9675070B09690D04F386BFC9EE18BB44235CE8198C0B216E74B155CFEC61F84AA8FC7C10735B4A046F194E9CD2E5308A57E30433A3908412F278AC2596274A14E1F9E5BF5DB88D5B0DE52991B60740BF2B60C0F5780C00F288185FE295F21452DB0901DA833B1B83E7C606AAB8FE05089D401DE0EF341A517FFFB8A418B985474C98B41C7FF536E277950C01FF798D095F6B850B5721FA975EAF4F8D6171B2505AD8DB37C50A75636931D8564C2021754679B23AB3C04947048B9D8343B5412E3D10657BFCCF3BF5732A5DE04907B0B93842B61B431A98BDF61415873116BA0BFCD14C5F1374E589A01812395C8D74919A4BE8833989C06526BB214348755C2324F2D9FA06069910E6C6B8ABF13B0DF249258512A5B2756AD81780A3F80AAE49FDC176563B4D872CF6DE187D8C3B39FB0F9237FD7533048D17FB4239D1BC6C0786517BB487E9A6F26747EA6B8CCB970E0D0239D82A0D586D22C6C20C5AAB9D54908E888B37ECFD5A52AF8C0991D34588833CA94997946613D9DB39783C478B99C9285226ED1656A6BF9C19295A63FBE52823B0F28D531EDFB991C38A159114BEACD70791BDF4B6CF1F2DDBE3B744272016C5F80F0D1C9A74D5BA49D944484D87C282FCBE511C4A1D076211082C69D7051A385B57E4AC89C3CCC608B8BC0A96EF307048C19285785B9F1E58FA0DC704404BD63055F19ECB05068B6A2807B370A1BEFAC8DC01F03A9031D8CD3DE326A37D115EED06ABC598A182339A46E12D0974BDC2C801D1F40B85CD966860760397C59D2CBC6A7BBA4703951A4CDF023F7EA1BD5C8E1FEBDF850F02BD7EEC6BF3108B0C391C8272E87FB79A9DEE25148DACED8F04E7DB5E73A8185D6348188DC8C06E7BBABFD8850C301BADF9606B7804694433037787F72CCDD67BFEF5487FAB950C6C36B0F0C1E7072C17504C1D8D44F08162273C8B38B98D88B658E1FB4339B80576B60789487536B381AB41180608E16E36FBC9411CBECAC4740643B08E950EB02C6C502E1C75EC88BDC72877859CFE290580C8021193A36C1864C9D0CB6F5EB4397223D19D632F3C4B881BA94B1616A084E76C9C60DF57173A4B5953181761DE4366FB36C10C4A09970F0B102940613BB1F4837B14031006114F38931522D41D3F101F3C762EFDF56CF6128B059E3CBD8A4839D06C7E939A1BD662BE027B0C80D9D95AA90AB334CE96ECBDCA344D7752B8C55A946270A470690EBCD162FCB68F20F4EDE0D8771B5FFE6F06DF18971C894495D84276F383FAEA225DAB039D11200D761E9A22D685B5F61C31435996AD35073E0520DC24BF5E9665E028E42C8B1B1A9D2C1F8B3378252CBE2F4D848D50ACD7360D691421F9B50735A0858BEF1B29D09F96A4F79A9FD58D34'
	$sFileBin &= 'FF1AD6741DC13286C4ACEE40B6D89E6601D33984782860F0E2417776792E62C48373EB6C2E8C70175F01C1832006D2960132566C2C511B6A3644CEC313321A01852897BDA7C77E16F77F3C308B143987CCE78E19B1BF9F057628890D596AB5C6B3455B43891C09D99BACE18CFB1CD68BE8DC2C6561B60A2C8FE78B91B6D2D35138722491614BD93956241E2052ECC8581C8D1B911A940C8F1462F498FF8EBB677661160AC431409485409DE14E4640E6A38040295293363E2D466F5BAFB320356906B8641AED94D446790F6D0C48025A7290810FFD33DF96E954680EF2E244D893789B63E3E0A91C966C649CF07B934E0A04060C232E2D7428158295816E973376860E30E11B2F77D9C0344B484DB32D090A26D8D3D84A77E9884B86ACC560E07CC41BC4C6528BFE578039C7642C19784D3516801268847787AC4894C038954F950E2CC4864D85D0440B8636F1DFF63024142A7DD84129F8083B8D072956F850762A07697322A2FB676C3600F2384701751442120F94EA07EB221A13043A74EC4A9E2A94966D903DB12FADA4EDAE7738BA094121D9BD100D3219318E8BF80BBCB273C676FB57102A7E1EC7469B102B240254D0468D31F85C100139BA73D39BE0A17623DC7F890852E71CA3C2E9C83704BAC0301DC5B319C52F72E9B08B0F750362945231D231F0748D352E16AC295B0CFD5B1681C809CC90D2E68F8F7DEF2B0C53868911C7421C0079A0B2049D8D9901BDAA5493AC40957404DAA99B2D57AF853035E4E948A7850C47852786757B4213FCFEFC4EAC251B99843880EF7188153B8D3B8F86164C6D3D748D82DACA18007D1706017E07EA6305AB0C682DF02225050BC4E8318363D02F1476521CE707852041399C45B482137143650A73219951E258474F9D5CE78D526F5BD802DE6E7C93F8722BB4E6803CE17D0E3E890C82AB119DDC624E068F41748255F917952458BD1610D3131F91690C16185AE4D66CC9628988F0FA3B28418D42C248CE9549D2E1B516CF2F77E9E0597F036BF1636FE04DB4393BEB1D902B10CDB138EC02E93031E0FE0C6CAC592CE22D278B39600EF9D84F8B5C9F04DC5612182A8C7DA1F0D832BC33B2C2D876B688DD9CB888EB7A8B375F07186B67712AD177E3F871CA1859EAAC406176221E275E9B57293DB1566A34982C2D5A9F7083507A8D913D8F99852CF0CABF98CC3C9374750AA4346887AF85738D63791B3A55B0EA1B72FF040D9E4D17E447DCFE867EC1B63A7B74CB0689188633D0EAC09C9611911BC98FA6C26625D8010C9E071F082CAB54434D9C62D65481A648D4A378F15A8D28761F910BAD6F59ECC250ADDA685850DB8EC562370FC373594BD4F675AB271163443AC2443B7B0706B076420FFF4F3716597826D021BAD4198B2C5B6F05A4149DC6D16C6B7674CB14E8488DF408C3D86B775B18F63B5DB44AF0F9B831A1F6B35C7C9FC18271E1B94EDB17A3FE238C11C6AD4929F907040283C0C317670996068CD5AD487485CC64841B8B352C842105C8AF129D0B91CBB2852AE2DA945667C0C8A5EA1D9C96D9AE8D82859387C4188D14888E615DECC6B6C01521C833E01B8EDFB1E05C39AB2B8D1BD3FB7EF86D8F07886D34A85CE009BA8109AE913290B60C1F9E0517AFEB2F5AC8BD593B76F66BBC21A801C7D0AAA4664160D7D040DAC99444FF8CCF94819434F123F94ECE130287E7ACD7B6CE2B93F469A48B4305086690EF83422C046215C9A10EBC09BC92CF6BCA40040ACC50D0DBBC401688D5CF38F8FD92C06C08C98DCF904A6F9078016B7308F534D240D901108C425D9E6003A73695694790FA3CE4095C38697D14FF96D1389F473B7DBEDFE0F41285B0401F74E5E5B2CD6AF5D6F2F9FD80A77B011BFB130684C1C61366290877DBA408167BCC924CFE7CFE0A6CF508CC0C9EF1206AD6DC8A9F04FF09E2AC17635B133938FC5A1620D620946A54172DD19DD6F726431FB1710C9D2D95CE5A9A4F3358A525EACDA01EA1967BDF36830B077506F805F86A8E142830569CC2F9BB9E4B2F587307CC95F8468375C2D93E082ABD0A1976D8BB341F29FF422A1B244BC3B2B1509D2A551939E9F5668D74556B8490F14A469F9E7DCCE8F8C88725B495803508C604A7AFF37DA5F43985B0F00D48C3849186C22C269CF2D4C8D98B2ABDD9EED03B102906FF1A1E4DA7D8D2C3ECFDB9C307E9D4226D17F0BD11E1C1644A3A5B1FE8C7E8690C1E31883509D581F4260DC9FEC7D3398BB59069B98EC13699A4BFAA4221CABEF470CD5656BC0854BD9034E121BC01DFF5E37081188426CFBE9D948E21238D36F8CC03CE70408692843972DB13F1DA530BF0BC959524BD5284E3C8DCCBD27B4B4E10F78AAFD1844E115A02CAA5D0A78FB4CB5A10897AC833791A10A3876641FCFD6526956403481C7D01AE7E84FC394318730B0D904B7AD8D656F36A3472386F0718798C8B95D06BA0822CF36287D1330B2F439A4C200601614B020842BB07A76C30363F01ACBE271C607E2741F77E8657EE9B504389061188D7B1E032F7FA89FA11645B067182AA9864309B215A07B346501280C749538C9AD9EF8511FE5A241E0311396C7610334F96630731D2B4B8B80DDD19F166A44B83E90428C8C12B598D71E4F68B9514957295C4805FC06ADCD93D562996B5C6A547CCC17830CD31AA407B8AEC8CA3DCDB59818C0C0F83F71582C60C1B056345701A55D6B53D6DDCECDE88438C111009C59775D48C8FDC3B8238EC49386120442DDA235D76D4908CB0E1E886CC30BFA7E0EE64E8F0BED4DD3181A698A44A9F8D55C053948A5946AF75012BCC809161D4A1'
	$sFileBin &= '6291ADB4AE3C34A2AAFF0B189E763C24EBBD894DC06710805640452D901DA080148FCF40ADE254A620F55126E285E46843D10CC15D54F18D86021CB9887607EC2C89D92E34EE584842BFE811CF0F66C7B59FDF93EE0004098C2776E3B8048A009D00F1BAF69BF96C2C45B80C8C5E440794EE4CE5CE5E5C1C0B750B7697DA946BB3C535478A86986EB1E0FF74C1D3E239D37311C36604581D8076DB46431072F5202C0B2C9DC3B866174240A03F09E1BEDB76F44AEA80C3E6DADF80477EB37B6B0C2B7176ED16AB9E1DBAE1117C380A5A39992C2AF00F625590EADD989C252C29541829222750C2792002DF5C04A689D1498928872814598C98CDA4401308D05B5E4F1802BA8227475DF4428F5FC4837F93C9745A8B87DA908DD5C61B81B71E8F7C574858C4630BE9BC6887147412F7DEA760FC132C2413C70A2EB88238DAD3E37AB38AD64335BC23E8B343357809068CEB968751BCACDF31C9612C896037417F9000BD83E50274835C26AC1A77091F5DD0B7D339C277F25510040953F0201C46D1AB2B7805871742D2AE2B5E812C08CF43790A36008DEC0137F85B406B41496F571CB00B2605466385D2DDCE3A585F7405C24E1EBE9883078FF6F8CA2616BA84100DA8C50D2FFE7E6F38932D0C39BEA051849B5D4D08BB61A870A25013CC832D22025E0EE3E07BED411C450821A145113D1B65194D0C599685BD2E80CFC9537464482D010F08D24444C86ABC820BAA89D09E22EE0D7B85901C541FC61488BD151174D9051C951CB663377141BB899D8B56CA8E50880DB011B8F9340F97FFD04498651981483B45F072772A042C10817FEBEAA0FB895F8D5E205E10B9149E0972B3F30D2AD591DB4DAA8A978F7C7249227E6DC763035E185A337EB8DC968CBC65DB3F4C2173E609DB40CC8BE8A39EECCDCBBBB90DD41329C8FC5C75817E55F620269EB281906D78E56D9CFB7FDEFE841A06B4E1824C01432C2FBA204323BF2E2F88ADB5E6203F0E2B11059B905D9714085D9F415CB934B56F837203F011102B5522446C36B3350C0F14C390689388937F451482BB15E90BDAEE1C8B105778FF280CA0C143EC8D833B2341AFAB72837AD0754DA04AA70C1E7EC7F80D24EA81EFAC501C162D6283E603766E8803C7DA205AA7912C06D00238B24F109C8058BC059A09C74611CA109D2DA1562DB905B0ACC9A189D8067659444DB66F24C2B5AD234820EDB834815A368F4E357E4D12D893755929925B729715BF2CFD9DD8301CA88560444A141C446FEB1AAFE90214E447DDA1EA68FD00876607F47C5AA222A787B6756E2A5A311C3D2A46797BF0F8C99F3001564D1C8DF1B59845D27C1B01B534D69BFF8C4F1D69C26D8677AFB9302B29D88901DAAEE00132F4AC270BE4B8F154C71B46A902437A6DA045E573EDEB88BF8DC181F881D1D0437595140F888428E82F7703ADD9E00F7EF3E37765C71E0ECA5E868F451C903B20C3893FCE2581C4A559157B506E671551BCB314AB5CB5F8EE50DA31755F9E0A9E5585FF74D66105012BD1CE2CA2695A200C10F13F8A500CCA7FFF17EC211577808ABB0A19446C8DCD4848D440EF0381E151CE02F0F1EB8DE2085647538B9A3283390F7C542F5168C701FF82E28BE00D8DD4B298C1806604C00282013D7C7A1ABE83BA0B2807101B069EAF88D1AB9032D16E62ECA50A27B11E7EE5FD47DFC0F9E60CD5D0E8884417019BD86042E17EEB8396ACDBA3F038A9EF3070524A703696F475104F61E870B271EB7C118B065BF4F0666DA7EA85C3082825BECA572A9D0610D10C416A5F93893D8D4315D104B05043C2BF06A24CC8D22906F43099463AA4BF38D72CEC20D8CE30F83C1C81C68AE70C4F57742A65AC5503F055BC5E0B260AB4E76401CD3008FCC57DB191545F3AA10892E6F3ECC24146DC75BE1CA49B6C6F20D9D618DD14839C6CE710420C084749AA76B56C403348361FAA2E44971040488F483D0675A3EE8777788B3A4B245F1B61F8873F43388B73145422C8B6D6C1F639D0726310308E17065B7B5503BAD0F83229F834D5BA9BA1343B18EB031329377794A35A47787E48EB20FDB6B51955DA42C82C3B4DEC73054BD4D8A00B69F82C848888DA97E804314169FF75E089719FAC0B41707CEB993F688B702406AA89788730EC94201CB80DDF523078216DFBA05E92855E0A7B29185191B5A5D8B6597DDA8E76E3161CD916DABB915DB4301C9FB836F00AED585788B08B4934F1BB6E893AD0A880044D1BF6DB76AF3C9724494017D83640441AA120D4F5D48B4AAFD0554F36B46CDD194917CC044C8B0ADB5608D81CC86E3D2813C4772B7000A0D07DAC4F49AAEDC25996791C80A8CFC476CBB575348FED21F30AE4B726477D5F818B374639A40FDB856FFFB7107714C165A8083CACC1E7081A014152AC54FB26E00945A8E40B0FAFC2390AED553DB1FEE904C7424C5BD52B144A4946D095BA7DF481C66C0E22035F900B8A6D6BADBDEFA474414292249E5574DEDAB6F675C021DABC59B80FBC518D44330C259A5B070D089183CD54DB098F19C4998C42BF4D82028992837DE0060FD7F68D858BBDFDBB75EBD38388B5C6C7AC7875BD00A5EA5B72044A01C910856AB675585C68A4D3D1B2ED64B04ECE7506E475CEEDD7DD1E72B4290429C734894F29C24C047AD66E358D4C7A4E76B11F7189AE0D6CBDC0721A426D6BBBEE6B0C555BE0FFEC49B85E015A087629A1604439BBE219D55A1508178586D30261E603925DE5C0B0BDB9059A897B1C51B0141C85F6044373181447FCAD5158004953E8120B354C868E34F3395C1A18BC6DDBB2202CD01A3C0E'
	$sFileBin &= '400B44720348558372FED872D443F5E348BC407224C37F7AB606779A7A183BF90B7E4297A5705167D2A52E3D122DB17510A90A4BF0A74822046BE90B0468F51DA1150C111AE61D5A5C1668C030E690E02F56964A701765918031687784606CEEFE0458C90C3BBF029ADE1648813FA705D6D1863D3160DE8E115619503900CA05111786F1B259E3041CCB1304657A006C63022B7966636123BA1F8242B049367ED35101CBB0395DB0734F42B09241AE9271B1B073AF5DE0713D3601294E1E0471331B5BDE98CCB03386D38AC1B747C40CF80376058653CD5AE4E4CB711DB2A1746299600D5A5A6203037330015C1BD3D239C281BEF95B620311B003205D70E082064DC307C114E2A7047301F695C9CFA604195D4A0343895D9B90964CA7AF724A1900B9AC5D9573401420AF00D90561E329E4720583EE40F303EF04D0E263A899F27A56F9ADA2148CCE0283FA0DD468C73AC6DAB89401F8E4D31D03DCADB5813644055E17627F807DD30BEB1DD16594AA5A01DB497493B10F8451D9587713AD4591C03244B3EA06D4E182A43AA75833CCB7BEFB8D5C1B016509D64975AF69D48D5E01960C38D8F4DC73C913D4725B9BD8F6D8F25DDCC9119A8B3B5ED94FB408CD1319C0D7C9540962FD6740DAD5ADBE71B002A4B83975E8F5F204F0128D582BF81239C3766E57CB5599CED729C1070DBE09032B7D45BC01C1018B2DA8356DF2191E3B0D3075B7AD18AAFBCE7EC0019FB82CABAD2D0B1A2133C67FE212F0466F1688022975F5B675CDED3F52AC247258DC6689E2652A07B75F73065C5B54838EB0C9B95746140D42F817D1E59C2A55A0EB244C6D02FF61C9AB03F7D621759CEF85DBB6D0A219690DA0479C5C9CF82D362CA06E21DE2601C88D1C424C254C5865136E6A99B0DB83814E6613EB14DD22B295F7913E0B558332BD521EFCEF16EE2A299862F53E2C5B024DBCBECC0EF04E430517CBC1315511456E954DBA5858E0BB57168ADBAE013D29D654C1EEF1168632D2196054E0B86A74948706DFC05D25C0A1A1A34C0FE800DD88CB47DB6162410B1707890D1AC7B230CBFE0B7F1331094709320025129FE2252263F7C34BA68DE0615C724D11E05102212307C00CAB0008456CAE1C8CC8554286C140D8554D2690D70148071183D5B05264CAE07372CDB0407938DCCC750275D80E0BFD64577E30E8680AED4CCE608F4F37B210D0BBA7F9E83355B7F081C1D5A92B6402D9FD15582CB4499FB0A66402E4C83BC8D839DA46D48AD86F655397617D66C8ABE017A043E95D916E3B912555D0EBBFBAE2C6269703A611410D1646801C2DD5446ABCF8D8B841D03DDBC14BE7FA453A94B96E2475BADBB23B7165AC70541B4E6D6C23E3154F99411B71850C64874E370378272E794EB8BEB01DAD0A7C919A1C221001889421D782EF3635A432217D0CC648FB6690CA55FA87426BBE2990D1EF297DA8ABB7B619F7541FF6697001218DDE82055A0D83CB15C1E60421070B0E12FE44F30E0029F7398993460FA12F96031953E4B90E49383708EA83431530023900724BE300ECC0C0D47682484A2D01D8A9737D4691524B8C909372FF711AA306E635F98FCA6D820362357159CFE30E6109735D8704E64BE4C076079F2256C61E02D3E432A67F05B9CBC877163628015390413403EC921C081A570F90317BEA694148F643F0430A890F1819CF6F3430B14075506D70A2207540894D004B081079436D22684B74531B8259B050DC0057D53C4B2C3982C6AE418821CA088D3C74061C40658B9A4B0C388142B42BAB7BEC6118695939F028EAF05A41B0CFA06500F009C78678361EA14662C139C74410C6804BD002E76C81C22D157061DA04FEC2A7DE0C8A1FBF4B04637DC00560037F0BBF43249E60096E9C4DC49903BD14B441800D1848DA2B17B8E50702D8DC837DE46B4BD0D4E1533EEB109F82C60A168E4405775424DC9A87FD9DF1C553771EBEE5045D5FE61E491CBFB872BB8D6785168554F7348648767B0B4BA8B79F0AE06C5717CA213C770F19556D731244A31A048A22C10E2A607F95C43404D34B425F565160840FF07357FB8C58804663013D3758E12E32D85CC62FD860653A7902E3DCDCC84E080F0B7721A1738ADE70C8C836598FCCDCE1B0DD115B5C020412D0674C051E260CCF4F3B970F63B0C3734243F51D089B039003612548C2C68781DD4172BEEBF0CC88C2109586B9034F5E896A941EE8AD48BDDA443527958410BB6D6BEDCCE0870D7E82253F234A5E209C40D113033B84DF1BBA848CEBB4295D3AA695B9665D5C4E3A58369423C2598AAF996B90FDA201712C5D587589D63E4B374B39C205404B28D2C056D1688DA516AA66569A70D0182208C7BDA5DE363A189008D4C1F7D2210F6A0CCEE8817DD41FB9C0D8049B30517E2B3121DA09933D2AC8D5D9486195E022793902A0C3E5D8C4EBDB6177EB9725E198CD885966523CBC91FDE266957725FF8C160F4C642DC4F965729835D78E2A4DE826EC55DD908CECB950E05C070F3DA0216B462839EE3A3C3CD76A12A1625C3CEF61AFE9CF5BDCB2594B02A88B0C33613AB3D6A21CC8C8A901089C4C1E48CF765A07795B75D919B05FF37676ED8229B21793BDEBE943A293CE41C6991F7779E3D08C9AC40CB9B6DA420E19DFFBB588D3FB47D8901D5D0075A9295CEFC2F782440CED8601EB87372A4C5F588283EA407101A600D70F42E18A8ED1D248588E3A88D9745094DED683C80270A0E8499A010B68414B8D60980D9D0B83FDFAB141C6603D5077197A8BAD381B4DD2C186BBAFCCA8E12C45F734D0FEC39266DBC1AD5A0E96FB5DE5'
	$sFileBin &= 'A164AFE02D135D057B57A0DD5ED1EED2621F4821F0418B37B750FAC9B940639000FB24824FC36D4D5E24EFEDFD48B52F85C9C7404CD4068C88CFC84800587415AA55AAB32524505D2C82605B46070D8F8782070425742605B8082259BB3002BE289154B289E251705EECB6CF562253255FFD609C81E0B9F15FE23C8A1B1A2976759D1C817E5588CE66492001A03A824F7C7690CB484CD99C2BE256C696F00A6702912D24E0725058773C0FF1835017F675E5108844165C1405F702F08946587D5AC0E7D94A103B9F5676D3FBF76E2F59807A5C6B855A14840883C65C3C5E60E97656010346024F18A01009C2B04164EB0B030808344191118E45E6414C4441BB5FB46A1A7A7531F6D739507A1325FA24722C89C19BD60B8B7920667BAC236241601885F60A26BBD3354155DDEBBE758B595A823680508C5BA6106B100F14A0DC49ED9D6854F786970536070E4AA7882DE0D08C4F9F516EEE02252E9072F5378644014E4ECE4640063C383477B02ACEA25052425877CAF048C08A467DF0132B091C408DAF11FD36E806501409DA5AECAA0FB1DA21599E478956FBFD286705D4E3495C3F2E01B209E0823B7D20CF4118677033DC62069D1029CE63817A869F638BC32544CC25412005957B17800950C7069440E2102A4E16F6316C5BA18DFD13BB87C0933BB00434A0DFB72A9C0158C04BE10346872F340537EF43473688D383FB13DC26EA7DB1C0297A75E0C9C1B9CAC5136B7F5D8C84EB00BE59588D715C886116073BDB462F71C534C3756EB98D6A1F5570B9F703C452DBEE36A37FA412013E01D4295A1AADC7F769976158C3512D34AD3AB4D7CEFD04C8A0EC8FA8A37E1E83909CF2E05BB72DD557CCA56ACD0283857B748B90B9B584702B0202F7F1C35C430DFDCA6C317C857A9042D8756CFC5424968CDD7889A1EB8A6C02AE7DB3114504990D14B009373828DC623B4D272A83C05CDE90280CAFFDBCB6B5179E761C01580130458E033D7BA6574A6F966D6046000329E2750F6D816233FF38180D12839B196A0255C90B2E0A9F11B163D85FD089D34772D4DD178539F87206688D1C3EFECE51A5ADCB8DAAD70A8E6010B80C83612267EA0815525F6C946060A3B58D36011E843EEC26E06F0FB7AD582429F301D6FEB8DFE9DC29DF36320CCF015D4B084A9B7676E80149753F32ED53406BEEFF04977525298DB7B17A430624492839D6867CA559A75DAB9F9CB64CC3260B2805B0E80A8B602001AF0A930057EF5D773D736350B4D2FF52F90C4014A65AD8815B0F2F8B432D39B0142B140F118C248AFFC40720217CD6641CF690001793D1EBA396776372816FB804990456925B9FE25753DD8692D942029A4ACBF7EA9E01C10C03AC080418BD89A5289D0FEC6F894E0CD0D8FEEE422E1A80FBE0775B6608D3F62CD48003B4063C01DE622B2AC088089688C8C0B6AD7DD70D1DD100C828C306E2062695E2063079012889C2FA25778374C0EA7663460888D0C05CB4759BA1D02873C10E04FE848623D8ECB986BA1FACD305B1AF18D9A91E4244F18B328C786D347101F1794B2BB0E548C37F2984053973547427897C111CA01D613B3C2478365617891C95023EA41F107402E5C89545D056D0DF28334270F28D5DE8443F1C49089ABE57AC790A3BD743221EA16D656C22E14C7454E3AE068AD934B76CCEA3EE05F40C33E8B1322414BF386F02BB8CA0D8681475B50612C5F4FF2AD064CEDF7976E27F637FC119B4270A5E28741989FA1B64BB66708F4C252B04201D29899191672BA1D8DCE011869D91E4F4614C201CA49334B8EB667E9F72EF7B7C81ECB862B914AF9F8886446772C23EAD0CC58B589989925BAC42F1D91306763501189CED04F0288DAC0F88219F8D01BF1CFD18891485A4A0E665DC104FB38876B23D08894DF621010FD645A0223C893E1D304940D720100C210896F58E059B8D853AF2BEE904B45569BB24833A03749625FBBAC49CCB02A38EBF33F73A5AD8898F8CBBD6EBCDC09DBBB090008B2DB70333C0B58DE24D7F683CFF152310117B6427107CC31F8B4CFD89C8D09A8CD4055AFD8BB57651520301341A1C508901ECC93AD87B682C0DC35F6AFF5021275D617614C30F765F06508C2DBB7C2E8C04C38F13CCD63DD09A13F9068212446DC25F77183B07203C5EC3A99A860E2C6B09CF8FA9D84D446B149629C050519FC9205B371C1A049F02045BBEBB2D5E4C186A015119FC0C4DDB7D832DBF0091693408C32F37394A2E005CEFB6646C6C08518120EC4C2FC20A996C1F2425C5DC48481F0FEF590239CC73E8284F64ECBF770C1F33508B0251507900BFF796AD2FEFD3EF6A1CD9F91C20016A4CAF4BC0C647558BEC0E6816808FF4877704977064A1C15064892587EC085349140BF1565789651BFC7C141EB9B39F2C1096D58D7FB652332C0D5F5E5B8BE5D6C55E2C18A633220F8041B29425AFCF8D9841C74C5406C2D088250706DC3061108D316F5DB27FA338B429A60C5DB4AF8A30112B844DC13650F4FE29C83FA42985152CDB500802040CCFBAADE3B28F38D96089680659B6BF6E0D343F53043F0329D1093053DB680B5043FCD050FF169B8B7845F874395D11348463130AD7F819AF391FE6DAD66D6DF8D71E330C2E4215077E89AD1EC1083B434476B4CF8423D566D5E242EBF10F278813312F14A2EED5DA53406439827AD07BDBC92F374330720A408C16B19DEC6C034766EF4A30F23C29476F0B370A3D3B4244EE04E16BB397FF1F1BDC0D15C119DC0E392173065F5D002D017E306BACCF9E6C119E6DC7468606202C2023B70344B01B48044C1C817827'
	$sFileBin &= '5406CFDAB94049C04015FFFEFF02B076E2644AF7D281E22083B8ED31C24979EB96A58017339E6C43D300CE2F524227D51FEFE2203990202008B42F5C790374B8F6F084C06C915DED6D3C198B2C01E86780E61C908F1DBC8F1CC9D38186D0186337C452817F78F9D1E9128023C3036D0F2F98146F454194EDADF0C58D8C087A08DE5D68AD8838A38C01F21B53448D34C2AF231ABD4CD70D41733CC82DD68AF8488D7701B63FBDE04BC5915CF9026D74328D576C835CBD2B47B80206EEF7E5E40408D1EA81CA3781FA83E9EEFE96010B515328423D7607814904A149F3EC030B00010418A5D61C819E097C7BB12D50A97B8FFD603860B811B4A1B904735006020140ABD8BAD764AB02F5048E9A3A2755F1DCC1019AEA71F291C716F11EC1B73D8D0CB5B583E0BB01DDC8A639DA96008A205B28E696B8595B363B825314019A6B2493246F099BCA05D6C96DCDA6D90F3D8817773C741C5BE81D0C878622AF10016EAF237C89247FC6FE00B1EC97C5D06D6C31C95B82BBC2EF5FFA740723616E51BA37D929E6CF098E4CC212302E8C8AFF0C212816C045AD9904E8AD36E5BF4FF3F75BC239DA04DD78A9A7D38B790E414444B7412C4DF2CD0BE2094DB66123A102201D1C22DA96C00C8E10F91E78C29D61605E8B56E3667A48C5A31F014B60E132963A731AB120DFC730D4854854D14077F348D17698C62309681CF06B89CE38AD18394304DAB9229E30AC5A1ED76F8CC409D1C8EF1F100389762F855339F275731D2F4FB7CDFD049139D8770E9508421F72EF6E2979A870BFD80DEBF096FF18DA58DAD1D483786D7440466DBF5DCE2D465E042B394644742F0C183D723CB407145FF84F9F96D5599A8EFB14568F2650CC166172FE818EB5451BC2EBBCFF58588B5660F0B316167C647A4BE681E300FC5E562FD9F74620706CB46B8C25D483EC5070C02CEBB19F01682C22AF08E170D8000D5E3C8205A276D45F494E29F9828490DE535CEAAC4DE68387280C29DD5E60098FCB0F8D1487181476CC06BBD64118930C8B3A33248F5D468A4C2475B70E023803F70D76C675AD18135F452502221EB5B7FF06423B55F075EE393073898904536EB476A839073B0141FFA339FA8F26F083C204397310EE0B16D07361FF20C14F900986359F55450DE843D9724F808256FCE9B76DD18D58049EA08D98D07B0673247FE30D1AD375DFF3837DFD746E3B5D2073FB5670A66945CBBA0C1C8D3CC2D8EE9A6BB04D201B090757E429D91C758BD8A8E8E076034B77A65E2217B60C329BC73238C16DEBA8DB7465037349C775634F6CE5DCAEDC4DECE2077F04676DC8B9932DB80C6D759224D4B20D12CC07C728D114D6B5F7600F6131B27D02366CAAF6338B07B9FB726C2B0874C20BAD1D3A79883D0A74453785A5CAF62C73512E2C4B432CE0D6B9ED1683C67C06042889127449F175BB86405DA40C02351A44BFBFDD73CEBFB740474475BB5675EB9E6D10764A72B59F5D35751AC2042DF6233584C856DFD6D0A18F47620113FDAF513C2B064F4D101E4C90E35923AC7A506A51C150378A131B06638CBADC614F0629F1C78E8556C57E6A607365598E051CCB55C8546EC25741C3E1965DD809746E3BCE0E4B1B3B7BB619578845DADD9A80DB7A3806746C04733F0DB70005646B4FA64139C25D808D7D7604756A91A83DAC666975960F7BD03262C276377A02D7ED8043C05B75E8E416C7ED3D0E3BE473EE8FC66B787BA51CED751D4187AFDC49D837AC0BAA01AB02441B7691916D74E4A01C5D44743CB6A2A6846FC29640D6E2522BFDD304407AA33D8BD6E04204693E5770AC4B07F2153F387715FE61C027E80177168C74EC4E5775036A674F206427D78136031314C0D52A62D40CA9085B966E1BD9BF2420152C061C18C91F60691814CB4724895C49D107B83526F023BB7BD73D723CFF27C341FF0729C321C1FB02B74280966547470F704BE8E6DEA2C315EBE81F68854C60CF02A917BBB551025302CCD8CDA290DB6087D6CAE51000201376E7DF02141F1A63FF4C4B4610E6E0E34F40E80F86E5E83E0EC18BC834DB07C4578673103F0C71E1FF74CA4702D44D206A90C6EC310CF1776FFD56282104202B1C8A8B8C82B7B1B716B9B9A02DE4899C0F76BCDF05561C828B4E18BBF87176122E754B1CAB66C26638E7848E586A6A1EEF5C5D890C839A0F261A45F58AEFF21CC920CBC98B46467C4670885FB863135DE8E81176CBF3F5467D062229FBF5C846599646461DF44C72115AD4668BC5102D1F040B64BD70DA059468674F3B51D16F4DC3681C0F173BA9750743EBDC73BB421975F1FFCAC5AF4812DE26F7B4891A1008E30E774EBB6C72F2C5B0BE100CB7F740B8E846DF94E4B67158736673BC13B4AC0A5A16EC8B234BB29910CDD2B0045FBF7D4703B1B69A23F5011708E075282C978512C2415C97D813978D23947FC25DD8A551E208D8721B9731B7F2D7DC23A34FD32CDC584244AE89CED00557C2DB87CB57349AC675F0172BB49AC811B1ED21CF04448C06118ADBCB38A9225DE436500582DF8CB22531F63D0FA99ABA6239576BB581741BCF43ECA539C076168B9CFA015DE8A2184596D1BFA29DA0417725E72259784368A2037FCF820B4BFCE52EEE041E5CB0F862854E4EC67A212414100C0F001F742EE07447B55C1B0975251320432CB6601882EDE365786FE7607A84393629CA79AA07314696C835F0C4EC080DAF44480E09ADBE9A388C6F3C7929836E7705BB03CE4D8397C8EACBB1C1AABA1E3DAC57C8C475E4C067062CE7A4AAC775221903560990C71BD12717C66B95CFF8DC0907C50C7C'
	$sFileBin &= '9087E45AA9C46D4863B2046DC3DD12E0C3FAB04CFAF0EBB56FC8858C115F3CCB32944C059333170F915C9D7567FF931C87860E2A57D1E4AEDEC864343836971F39E99531AB857F3CC33D989047C9577B891C13198F1109B22FDA4D8E17932C4C552B35A3E102C9716CA43835C983900B3C7BAC0A89B32B8F7C132F6A16FA9696178B5F20E64800AEB5152C7BAC5485AF12EDC483317034F32EA38473C88B1C0E25B420B807050D9E096104B20807FFD283EDCC1C3BEB0AC64E74750ECBC1363101CC76EBC342010A086CE62261B3A3D8032CC7118975978B0CAA133C4E75900FDF63C860239F0E89AD3CDF6181B6A302E79C2797D050E002645CD957654B70BC67B3839223EC248090AF2CA29D01B9B1EC96949066E97E0252872C0C75B0530FAE0254795BBCAAE75794B26A8121912D27F081C9F5D100B96C4CC9ECCC362C1617CD0D5E04B285A40FDF2C3AB31C72D103E8C21138DA062498C2EE2822671B904F9B55F0CAEEECC39148129D9B21D8B42B532436F28386ED3A6BEF32B68C93F8550C932A1512E40A84581F05E8C09B900B3F380D6D8EB0203FFF0CEB7FB26C9B0A5FDF7728E81040BD9535CD4CC80FE7DF7021C9B6EBDAE220D50421F8101BBBE8B481E29406D59499D3916847E614811F3934906C129FBEDD17B44042B017D123FF724BC4A58A287F1027798DD81D66BD851575EA6116064D58E3D41FA45E99CBBF4C9FD252276D8F438915743BF2D56F60A60E3491CF918F0B98A77B8E8C1F1205B04047326088EED80DB04093BF45B850E5701A311600BE6B59059BADD9080880060C50757E506D2868077AE02F811097823E292F8B52482E741839566805A60421788023C79C19805F1275107D44478E95E00F76C07F30411503827F5FC9C9D9907B1006141881CEC9C91C2024DFA8C8570B5E10FB150DEAD96E4B495E1809EA9C6C6F0422060C08F2CDE24FBF69AC8D461CF80A1459BECD0D8C1D383015CC24C5D99E3D6A7C3397545A2CE622552F8D8D65F89F2D1D62EED70E5AFF781946202669010CC0CE3D6C48501D80907F9616006E27E07EDC5E489D74E5B6AAA5F4041D6DCF7425800F13562CA35D20C161CB0C7E6BD5CCB0A27EBB5D433B9174298D7E24EF9E2D3B1B3C898B332875E52A21C5D957040FD9649BB0FF46EC04E32DB04DBCC19A841DBFB614DBCE353E46108214B854094DB667DD28067D8269DC4D18C9205CF20A1C20388C482B6B718CC48C557136778AC786BC08604F168E0375349510689C0764B9ECD8BC7C7483C24E2821E9C106CF968CEBC2AFE06A5950BF71A22BC0CB9058F94E11C23F96B9A7930F4330BE0CFC217BD65D9C24178284AC2CBAC318E1C743286F437D7CBAD3409601D90E18C41C0EB03968B56F1220DEA2C569CE16EC9EF5A10DD876391C24188563D367B3C01472B823109D119427685C730308D98FE02672859BFF8480D88932466F180474B07C1C7585F875A3F1EB2EB489CF6280569789433BC641C72B9A8037F72B3C905138B475CD1140C70A7F4E930D56BC799775D0A3664F0CCDD1B33C4D5D40CA319EF80F9420BF0133148789DF8E4161BB131786EC43905C142161B0618D0CECBEFB5FDE480EE404485D6CEE1FC45826418B04874D680514D09682202B52EBDA12DD570783C74089091E4367B294141CB6588FCF6CD902B94971D8316400E410B58F5F35240F3C95080552C4224CC481C257AF6EC63A13A2164010DC83C25C0931762B75055810E45F10CCEA80B71436AF5E41C0A00C36C283805BC17A08B4858D3CDB3DA8E50C85D66FB078459AA321D19AB2598C86E8F547E239ECA4C548F4DC0D0A7E4CDDB013353AC37B11A029B0DE7705DD291A299A18516399C3C65A1742140DF0106C089E8C84734C65F402AE8020C8A5622AEE3A1B8E8C093DFFDF44CD229A70994E746B512D8F5EA4058AF814A96FFFF6E707C1E70F7701CFC707F7DFB6686B0C3248DB4F138D5B0181C06B00E0FBFE1FF5BB06135F6D2D2514386C138D728D18790869285C904713C251B46BBB019B1BDC068A1DFF9074011F586DA95CF4EE1EA3CDF70CDA746C65887C4F5E58B1E801B144299A588D076FD6BDA05C40505D92766E16BD60C9653E894316800F39108A424811C085A4EFB0238C595BBF93F06C40BE04285B830187871B9B8370C48B0A2ED085124B0BE00D7983FC425D24000A1A0300177AE5EF8993088D5002173881045246C36C1B04F47F40538029DF1D4060300238CAB786B5F619F1A9C301C0291F11B45534E23FC20539CB5EAB6A773E61AF7D67407432FC3D867C39BEBD6FA108ECAAA9964AC6D88BBE14D1A2D771D6964A93ABF8ADC0BB48FB8B8E1C014F4AC018F1770397895EDEE66E85221A73031F4E203F2C59EBA8F3D4161585B6A02F1AE6F9E4F7FF4E76F3DC6ED90018EB2090150E0102DC6BC39C684AA25D19A219B8DB7C0986280D34454D485E24F3016FFB07201124264ED4AAB3353E7C4C481708DCB3456CE1F947721055F0BD08B61F8B2B0C90B7406C0A42BCE26CD29FA2B2D55699EDC1BD01E0BA919A92862A13C240C361667ACCBC100F824A1AA22148803B3C8B9E30AB4F106DED843EF84946F03D8A98DBEEDC399D28E987ADCB44A02755AA964E8133B709205465FEEBAC05235C9C0A8164B64EBAA54AEB9E808A90BEC2E157C418B901F8F2FB555C88303B2872FBFD028F5A3063618B10575D9D1D888B4C41914A18D9B316DB9575DE772081D08C3F2F407504606F16BEEE377DF402470F3E3083E33FC1E31098A2D70ED201C3648A9C6AB1A29ADDB641BF87775E2B86A243C2492F'
	$sFileBin &= '580F59685991B747EBA89366C266861F5A00753D2161492989D36DC097553322D8029F292037A8083F2F8D63EA5B26487F7B408D5F2C17A66A3B3C474405288FE021874004B6ECEB2A81461385FAFC32881598C5522CEA46E1DD96ACD6AC17892908F7CF01EB8750E973488D8726E0B02D8BEC7E568F0F472B580F1F5116B19533FAAC5783C32C78822212AFAB1920E90ADF09C1BB8C9F833086205601227B80328A0987876F6F3BB4ACE7080CB74390A2DAA159674E1B08921D10F2EB943FAA428F3D8825881CC9172EA20D8C8F0E4143C133456B6F5F430E966478FE368DFC4BC01B087FC1188700EF5BAC7889A45720BA05CFA20D16782440026F3F0086D736846920D3566DD98A32366D20C603825CC48311460B442457E157FFF7050F0E7C6904C9E6706B3859577422ADBA078F30151C5E9D90BEBCC50061F86CFE857437B56C20279397441C8A3FD8007774D6A6E347398FB9F2DD7014A2A7BB40505C8DE0C5BE6450554F36008784046F2F1D8EC1E16190198BB3004E01C4C0172D3B24F192FA06088E6FFCECCE02B680792096402313502A0596E0138DC041D8B951EDD4458D89AC830E08195946961C0C481004D946B6671406101814081C0365641918202C67503029809E03DA63E12FC52C7EB3EF842209C40FE3F1501D5A7E28682039D3C1546BF081A74859C1E3A08A3FC42692F1ED793C43746696260A5A363F0EFBF44D14825C30817B10FEBF243ED110F70C345308316958C15BFC770A59661C839871A45B913CEF8F0E8260296F06125BA968587F405A6F31D8B35A4B917C159057865506BFBBB51B811CB9254932502F8DB65F7D308B5818C75024360E96DC101D9746048A8625388B0C83D0880D6E8E833BD872175DFD12B07BCA6E29DA380416EFF8132A352429EF3F17A92E531A904823232480993928254F6CCFB972148F89988948B354B76D11789140891E20561E550A5C9890234A80213EA9FC149925083D3B294C4388BC063C990EDCCDD5FB39FEBC720DAE50182AD3DB29F9AC0E7449AFF5F625CC5482B52455D1216A80CCFA37102102BA43105A2BF096EAAA6A6AC710022B0451E0005810F3FDCF41D797D01848C79B38440E0274199DDBDC8B3BFC693E086C4172A15850899003B899728D2CFA08EB84EF4A1A86165D518B57EF292A01B0F025F18B31FF4F6FC17B296A6F25320189173B178B010FCDED169A7F040309C3040C095E7829700771E5FF47C6F0FF07A126A400BF0C3F6D0168DB02574401132AB889566E4C44101147D6754F1B0FD58D398D42CD478E0F660DAB60414A84E46A84A17E8B1D1B45A22A1F94E2C6B7FD9873291D2A29C65BC1FE8FF031F2B987B9AE3453043734D0C24B081DC2CFB549FB172BB8064B0907EE0275E795102CEB74EBA29F5DA5B67DC9D733EB1BFF4B5C43498B5AA02EB4FFFB1B01CA114EA44B4B44649F3B5975E0027A81B537272F2A75D5C0215E412F175F58962D259F705D463791A569038856050F47579C0AC056105E08055D17C45B8D13FF4610D4062C8B7E03BAC53C82CB404BBC742F3B460C0AD4842E315658B4C85CF71658B6294C04342E7A76487175D18D34BEEBC427CD944DFF8F554657273D014D0B880AD1055641051C9310A502D98A469BAD21F2B68801B20C99AD0CC8612F25CF02982EAD0A12C95A9FCC95EE3855B3DCFE9080C71555D100B8069220FD5DA266FBD091F0060CE06B74342068D0AE0B98942097DB881DDCCE4954AB87B0C70508210CB0C07283250AA3B86C5D3FD0291495E0D00BB23BC49B2286901B591238F694E04C93D04F3965B625DF4028E0445064EC56F1FFFF88A050054C64646464480C0804766C2C7640CC000B3405380000005B5104031162A62007322403C80A00082403C8400B00ADB24032093FD334CD950B010203042FB0254D0506330203419EB3ED0405060207000A0040A0BB99FF056AF103F7540564290811A00A1905FEFF97675CA00152656C6561736553656D6170686F7265DBF67F5B4C0F7665437269746963616C1763076FEBA6E4B76E15456E746572443D742C00DAB62B47144C5474F66DBB3DF20D57611E460853696E672DDAB737F74F626A2514436C6F7548616E64126D6BDBE60C776146457664413D96EC8B95530A9C730B236E6E976CA727496E7675697AF634DBC880DE694866296BDBB6B95F336C6E630770274AB1FFE76C661E345F6578636570745F6888EEAEDDDC72332A606D6F711A6265672D673CD6BA6876642518637079B28F6FDBFFFF0757076DF09A17F03505F0F902F06901F0D402050B7204196DEDFFFF35F0B90261BBF00705D1F0D302ECF0B101C2181C193DFDFFFFB61F6228FE03F0B31C3522453982204733730528F08B170709FDF6DFDD011B070C05F0340D65F03F06070A0D0D090D070F4BFF63BF0210050D0D06000C06F00C0A040050453D4CCDFF43FE010300448DAF4BE0000E210B01050C0098081B699A27801110B0100B6E166C19020433070CC0CEDC92D01E341007CB66E9D906A0B3D66E8CB15040B21C24C0F01706B26EA7581E2EF9787436B0C176077C979098C40267DBF87220602E726424611B0E7317D27DFB06279C40022763939B636510B32A01FCA2CDED376527421B34B2103EC1B7000000700400240000FF00000000000000000000000000807C2408010F85B901000060BE009000108DBE0080FFFF57EB109090909090908A064688074701DB75078B1E83EEFC11DB72EDB80100000001DB75078B1E83EEFC11DB11C001DB73EF75098B1E83EEFC11DB73E431C983E803720DC1E0088A'
	$sFileBin &= '064683F0FF747489C501DB75078B1E83EEFC11DB11C901DB75078B1E83EEFC11DB11C975204101DB75078B1E83EEFC11DB11C901DB73EF75098B1E83EEFC11DB73E483C10281FD00F3FFFF83D1018D142F83FDFC760F8A02428807474975F7E963FFFFFF908B0283C204890783C70483E90477F101CFE94CFFFFFF5E89F7B9D40100008A07472CE83C0177F7803F0375F28B078A5F0466C1E808C1C01086C429F880EBE801F0890783C70588D8E2D98DBE00C000008B0709C0743C8B5F048D843000E0000001F35083C708FF963CE00000958A074708C074DC89F95748F2AE55FF9640E0000009C07407890383C304EBE16131C0C20C0083C7048D5EFC31C08A074709C074223CEF771101C38B0386C4C1C01086C401F08903EBE2240FC1E010668B0783C702EBE28BAE44E000008DBE00F0FFFFBB0010000050546A045357FFD58D87EF01000080207F8060287F585054505357FFD558618D4424806A0039C475FA83EC80E9272EFFFF00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005CF000003CF0000000000000000000000000000069F0000054F00000000000000000000000000000000000000000000074F0000082F0000092F00000A2F00000B0F0000000000000BEF00000000000004B45524E454C33322E444C4C006D73766372742E646C6C0000004C6F61644C69627261727941000047657450726F634164647265737300005669727475616C50726F7465637400005669727475616C416C6C6F6300005669727475616C46726565000000667265650000000000000000448DAF4B000000000EF10000010000000300000003000000F0F00000FCF0000008F10000E2100000411100006B10000017F100001FF100002EF100000000010002006C7A6D612E646C6C004C7A6D61446563004C7A6D6144656347657453697A65004C7A6D61456E6300000000E000000C0000009D3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 1, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 2, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Lzmadll ()

Func TaskDialogDll ()
	Local $sFileBin = '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '59OL60Q3YxXcuGZTVpCRKd/5FofIkqR+sN+3A9h9zifLrNM0p9hiWn1m91yMFm3NyVJpZMIsC4fYqnOUXQNelnacO5Jf2bmShYLCpGR0nEXsPssH/+6p5niHm2SZFWEgidAEEzVl3RLUBbC023+IEApmGKY28selDD7PO1e+5dHkg4MmpKHLY5ppac1a7bKH7Kc+RPpem0q5OkeGaNCjJZs+OTEZGEJLVGuPMHP8dM9+BT2rUi85hEA+/wt1lGKVoUHsTqYGnzsIaEiRag6QYJ4Qlbdsnx7wJsiIwQseSmbrgnRLFrGNPoFTVx1yGW0sLEb6DSZkZ8ZZtxxd7+qWmCjtb5TyKQIMxgamgquU7aBhblyItTUPdeDYNrAy5Rf/zp3g3Ev2P+X1JwYeooUBKDdo4/Blfs02HgDQ15JpXRNx0i84nd0p9B7dNGI2HyPedGJG2ENmC6WGp1mcPgQtVblsjNrIF5rGcx0/NhA/GYkIIKA6Sv35F5rZ1a8Lz6S5MTJyUHDBOzOnGmjCzaEdUXmnxLHZzBCYDHbsCEDDywKkdb3SJgZsOLn5I7AvUrHz4fY57ZOBXlEeUmN1aSWqPS48nsbW7WlgHHTN++TVtnLJ61Nk5dnHt1D31lrgvokDV3O2ID/WpNUG7gddED8mBFRTihIxYutNzHkOvlT92cnCxCJZMRIoJuhk1wqb5I/ixGJbAxSh/6Xqt1YZweJ4/0243epVZoxjWIxmB98C344anMjkHIKoAMVjiGTRYG3VA6WryfsECpJTeNxSQq9x2/vg1GVYWVsGNk2JqIhyAyTzb5ttCn+Vdu3fdISU2Sjccl3sL+5EExckntLTaiCtieGaq4p1JDW47YW2yGpdBKXdREmOI8ZZo2BhqiwrrbU8bdSw9EoGVg3qWSCvj8mohZwJxWdeMkCLYQU3misZL0bwSlYAwgYJzOsAXJXwKH54b+SlDAufZSPvofAQFJTOySq/Z82XRsXJaQoFG9FLl6qK4TPgwTsqnxlY6/97hGceFo4QQeAKiqPEhPLqQ6/u3yMMtnTiEEZJQ5m+suSGDVERG4O2fUsNxWipZLiFju+eEPMu+3aW2e9d0NECJd+zGM8D8tChExjmSJZ6Nkry64lJj2AdNq/lHWhJqtpP81mppzyVUxExWJUTG6n35gkLovVtdixZoVJINGOFncRo17ycOXCt2H2nujqr2pJ2Hqu8mwVhtwr73MGZ39CjptcPZtnQBbLMOw/6fzLwWPUX0KpnUWjjaZArbysabQHTJdjnI43BT0zSFs8EkfbyrH4epinyX3FrDJfkfPz75e8pijIUs735M0rCO5+ezSVt0rhvI75R2YmWfllQjKc+ZMWwz9V/fLP7I7skmvs4FWbsKbCxyXOKCzGNPWedQ6LoGKPD+c/DAwwGjAxMyaHvpurq6NaAT92eAZJeuyY8L++PYqg+PdPaFD31Ymsme9GyR7Djka0MbbGMOGgQalyB7YavCSWf9bcsYV/QXoYgyeRg8EWRegVqoce99Fim9fhowtMYujoWmcXwJxrP6X7yau6/IrLzJ/U0TG4SiFS/6XcQLJFkHcGlSxnO0WzNe2Xq7THVmn4ExE4z5y3qdWkBX8X8j8l9DNI65hBfFhICU6tdzImo4nAJH5UYH3mWWCqhf4dhxzjMAn4GmLeWpRXga+uIquz9iu2nvH6duQARXkYiLRVL4HAWcMP/HwAUo8m8MugpVPiTIlVl+OtKDqFo/8dAiiMQTyWeCLv/jItJmjFmVsZoDd9RMG2NvauW4X7KK5Fp0zckfmhkIF4OYjuQs+32WcHfbkSanJCvjprIZMcytIw92HwQ0Tys3P8iK2PmmLl2auo5MGrU6unEfMLVTvYOrF7xFQh574NARwWYmSvCpXSRrs7pHb3O58oBRtaIy0DgKYhw/SRgG/kZEeltEH8RhxWg46AQjyYeiR8u8HdR6NK0QXVEsY+Y5MzQd2T0HTe7HC/XqAJg+nqMCYGMEvsVpgHdOe/VKOAosY+leJR5Xgs2XhiCbwIlJbcYtyXGAyOVdbXferlWkdbrhm+HgQczU9KgJ+D0vs5Ozclx+J5TsTi4tLwQsfSZdefZPRa0RAnjJPNj12QLODsR/I6uzJ/9rQlOyAFhXEouXIHp9OUdgbCK04tduGjjWfjpGwA/epz5Hs737nk0pVWKyhKTqjfJ0vY5H9950BkS52tJd0gUzDjBQLDwEUDwJrSwW3koNtM50EZP2bw+O+2uwdip8QC0XaYoOU2MEEjVSft6GWSSNvhW2KqH6R8vAKHGQiYPjNqXvCfxWyxiAJ742fX5+xCSQUzmO5bAhACqb7SFl3mU0Zni1JvrV39E3d0OOvkpUzHollH7Vs+5j11T/2bIjwDT6ZdjlRx3QS8xrrjx1VId/knTubljwh/s6Hqystt69RM9T73w+Q0tvwzIA+SySCxXW5N+PTb2LAr135KtBBqq7xfOUOJs9w/SWhmtepy4JTj3IVeb3yItUofWvAFUA4HJMFL72qzVrEZqdHFGj+ftfQcQ18A2aM0unO5nw3C/8xAx/h3HO/WmbJLLuG1H4PMl8M9OrXT5Ig8tiykXYa5ZgJeRZqFiHCjt4elDwCSdzhXPC6Pdo4ez4p+7iAV0Ni6NMvailMKCfzmO2PHNM5NaoHOJnOokfJyJaKfxrKXqRP04tjgetcjoov5PUoLaFBHA+YGDkj5LnqIal8qGiOGxGb89KNR1Dt5NiXs5MEWs9fGQVyLHyQ2KFPo4w+bGHtNw5JayicuDIJxo5J1hJBM2PWs+T6uIDTfZHF4An3dzvcOdo5VLQxTenlx9Ej0VJ4XnUqokMc4EqE9k2eLDUYQWKMq9Vxfj/+i8rAZSQD/L1zHDT7unZS1pJshWVjbE0kRYOv1t/i6GB2lEptsMrtiBcJPwJTzxn320FQYDzJoKobkkmBmzNZryGEJ9kLO+xHC2eJZ1/KaLxtHOYlRqjAcq45bi2AVblAvwpFN/HH4DaT6nE3UMZ7GAGqXoHY+D5GHCTZJyBDfTnVL2WaBV4kt0XdDUQdI1yRQPguPiF3WJOptXqfexXr+W4ETE6wBdxlYnWt9h1skxrjIM5I4Pj/rzTszk2sPQdZzp+XK7gXMLD+TdyAxX7esRH0dzlchVglaACgDtlBUV9W6c2Q3GcMGXRCikD1bXcVYFCSTu0eNkZIfFrtCZW6tdrslordwOSxzZYan71+PLePKB80QACwNydFIckOVHmX5mTRbsZW/1CKWpOFD/FaRoiQb8QvjyMqafAeFXPwUC7q1E25IuRhfYa7MP9wOMlm7R22kE/DN859QFtsLV0EaBE/XgTPeFTdtdYTvcQqTAM8/TsxGSD+YHRm1cIXkIKHTiXT9dpvav5b1eVD19vSJKY8/Y+8tk3LSVTSUNqOqXFwXPuQB0VjYrU9UUmZ45BkyxIk8Juu2370UbOFgo7h6tweNOdt6kfrM9grr9j6b0ThCZ6vmlhOvykGfBGoJhw8N2z6cRU7l1TVC2ps+aMfOMiwocIqac6HT+I6N4jdG/m907ZKVjDHo9/2OW3WI2mHCTXwK/s3RMum3Z3gFvNtoO36/6kfkBmNVjxMEcbGVQOarPVIg6RYG8Vg0UGNMOZ3MsbKxpu02hDs2Nn6CS9Alx7ohY3XvxIUJ5PQcytxQRmUdQef0mRJuvzZJcmZo4DpN6thn4AvQN7fR+B5bTZFcaiQH57FmhYsLkqI4mfQM+on+q2IpqBMT75aSdwrzx3QUMtJkH4luh+Lymb/6CGyCynbN+y1Xpcda0HNBFpLdcvJv7AmXYH73n8Xpvzah6Ce0oGKr/HQIElWr4mtYfmDXHu/9Tehlk0RKZbU7BsVN4ABnJN3e96aHL1R4cLnSsDU/2V2F1Sx831IJ1JpOT7FPBIqdS3magKHl3qcsN9IGBLhE6wBwFpUIpI1jH5xOSZtluQl6lLM1/rvmyqkWSYYKwwt5daYjCaWo/MPqHq2/APEWT'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin &= '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'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	Local $sDllPath = $sTempDir & '\XTDLAu86.dll'
	Local $hFile = FileOpen ( $sDllPath, 16+2 )
	If @error Then Return $sDllPath
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return $sDllPath
EndFunc ;==> TaskDialogDll ()

Func ToolIco ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
	Local $sFileBin = 'XQAAAAS+EAAAiwAAYASQLCQLm5mqXuKijOFFmQmSoAWbqxfmRANG7R64wimXSGjlSN9HtAESJkr7TbjpaHMaa7x+tMcTkhusHTBcHBsLAR+vebYtaXW+W0/DM1sceXYPPFEvRGG/9we3iW8fCToNn42jaBWhbSIbuKcM7K76OagOZFQfIwMCscafJa52r5yzHazqrnOi4Dv1JaEbgmGWLXLrthvkgiOJLY5UcbCJWBm6nuter19O7u8PoVAHGS4iFWmuLYZlLpZbfnPPeDrak3SWpHZMuhFQ2onqlSNUhqyfCBym5iULw97VckYERK7iiX44xxaZ6EZmGSB0Dk+ppfJoXC1ag9Rl3VtRF7SoFVMyBKtrgM9KJHGEoVN5AD/YOMQPHeqI9jMHFngtZpV47K4/ILlXmxdle2zL2NfiUyBGggyPF1RXAu0vSUQLZj6Vip/xU2wIqagTAIco3QPeeRJUyOn7g8e8Wu8AY983cWf8Kik9Uh/HhhK4Wi+5upqolPEoQeMRwOCTHsfNUjEcenCIXryZk/S7jsCTzTQDhd51+RMwSGkwfG8D767uqTlX06YWkCK1HFgvWggOFpcGDvibY2g0tt2pBvt1o8eLBYbu/LaNyzoyVZ9yi95UB2p145edVBD4y9EaEsrKj6NxGwdP51kOjmx2yOp8wppgpzLr8n7Ys2dghKdebtKOKBwuKNssNF9l4FKGRM4eqXCdYJ+hkcrobapqQqi0pt6JcoBqfnggvhQmZdx9y8kVAqO57n9INJJeaHG59iDzo9f2hFLxUWhuRKT6L4BT4e7kDUFeiTZt/Djrv/achHekU1cjEs8LPBNIQgLoZr/oWe06aCERXzYUNEb5HH8qBxa1Er7Bhe6bTs8yk8i6wySGBq+6sDgK2U/VtmyHnxjUop1hVK7/FeECSmuKGwYcs7iQCHSuEUUjvkNZjpbL+yY9R+YIPM5IoaxWElzYerRk99awsb5mjJPAnJcU3Xdb06uyTxL7A8xN8XtffB0lCnMrcU3cJQEvTfwbEEWnSGr7Vu9rG8cfAsm1zbHqwgjD+LeNFZw4n1QOSGN9gxUvSHJ2qrGK2WZXK+jxK/6LFqRQkkYI1rpesanKTaicdWRDcTK21iAyTOLa5LYOHhkMR3hF9buq+1Gyu5niKaeJGsBI9gkvEqh8UjyO5925qAn23rEoZjv7MTyIE8DN+AgCr/yMZiqL30/1BaqUrs1eDvMQQktxYtPxSB7tT+DHkh0xnVuFJH0u4Jbj+0ggz9SVq+6B2Qlo+SsXqZ2vYjDV6E/NXeNH9/alxka8SVPWy4a2sMbPrF4q+LbRS60pSZHV7DjZbT7b0KUOicCL5cgkQRETVeQneS1R8YtClo9A4yMLzkjqkEgHd0dS3jVUBmCPzlThDpaaUT9uahHN5VQUosDKXzSdVBAWyBj/2jnrys8zh7CrVtye1IDWMS6is/GkScoXebGyCgKKwDgA8n8anjWE+CGyBOQnJxV4AfTG5wKeWmoR2GsfseJLB0MqIb4ZnWzJSJO1X+/oZcz83xiS4bqZYHfbcjFt3ttclN/pxkBf8h/38aCEO9FiN919I1mgsUGS/J8YjwX/jFGLdwQtVflMyP/5+++stM9pzKSiuCEGETWz/88hMNP97jugxV1CfsD/U2yFKxFzwb5S/W36JLxdxl21xEhWUB9XQNGZsykRAjW5qVwwrL4WaZ2rADXd3OPk4+lM6AvRM4iM4DJ8/fp7GkrOVoAHs83a3esVp1v7Y2l/Krq2srwNdjn0rhE6klxxGmbxz87dNDdBt7FJ/Buj5MfOJx1YexpPKd9tjmOzucNkUaSBVTGaWcw433E/qxXSYKBwu2TSfL9m9lYA'
	$sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
	$sFileBin = Binary ( _LZMADec ( $sFileBin ) )
	If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
	If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
	Local $sFilePath = $sOutputDirPath & $sFileName
	If FileExists ( $sFilePath ) Then
		If $iOverWrite = 1 Then
			If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
		Else
			Return SetError ( 0, 0, $sFileBin )
		EndIf
	EndIf
	Local $hFile = FileOpen ( $sFilePath, 16+2 )
	If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
	FileWrite ( $hFile, $sFileBin )
	FileClose ( $hFile )
	Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> ToolIco ()