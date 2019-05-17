#include-once
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <IE.au3>

; Opt("MustDeclareVars", 1)

Global $_HtmlParser_Debug = False
Global $_HtmlParser_Script = ""
;Global $_HtmlParser_IE, $_HtmlParser_GUID

Global Const $_HtmlParser_ScriptName = "HtmlParser.au3"
Global Const $tagINTERNET_PROXY_INFO = "dword dwAccessType; ptr lpszProxy; ptr lpszProxyBypass";
Global Const $tagCOPYDATA = _
  "ULONG_PTR;" & _  ; dwData, The data to be passed to the receiving application
  "DWORD;" & _    ; cbData, The size, in bytes, of the data pointed to by the lpData member
  "PTR"          ; lpData, The data to be passed to the receiving application. This member can be NULL.

Func _HtmlParser_Startup ($iPort=843)
    If IsDeclared("_HtmlParser_IE") AND IsObj($_HtmlParser_IE) Then Return 1

    Global $_HtmlParser_Port = $iPort
    __HtmlParser_ParseCmdLine()

    Global $_HtmlParser_HWND = WinWait($_HtmlParser_GUID, "", 5)
    If NOT $_HtmlParser_HWND Then Return SetError(1, 0, 0) ; Daemon failed to start
    WinSetTitle($_HtmlParser_HWND, "", "")

    ; Attach IE
    Global $_HtmlParser_IE = _IEAttach(WinGetHandle($_HtmlParser_GUID), "embedded")
    If NOT IsObj(_HtmlParser_GetDocument()) Then Return SetError(2, 0, 0)

    OnAutoItExitRegister("__HtmlParser_Shutdown")
    Return 1
EndFunc

Func _HtmlParser_GetDocument ()
    If IsObj($_HtmlParser_IE) Then Return _IEDocGetObj($_HtmlParser_IE)
    Return SetError(1, 0, 0)
EndFunc

Func _HtmlParser_LoadHtml ( $sHtml, $fRemoveScriptTags=0 )
    _IENavigate($_HtmlParser_IE, "about:blank")
    Local $doc = _HtmlParser_GetDocument()
    If $fRemoveScriptTags Then $sHtml = StringRegExpReplace($sHtml, "<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>", "")
    $doc.Write($sHtml & @CRLF & '<script language="javascript">' & @CRLF & $_HtmlParser_Script & @CRLF & 'Array.prototype.set=function(i,v){this[i]=v};Array.prototype.get=function(i){return this[i]};document.scripts[document.scripts.length-1].removeNode(false)</script>')
    Return $doc
EndFunc

Func _HtmlParser_LoadUrl ( $sUrl, $fRemoveScriptTags=0 )
    Local $http = ObjCreate("winhttp.winhttprequest.5.1")
    $http.Open("GET", $sUrl)
    $http.Send()
    Return _HtmlParser_LoadHtml($http.Responsetext, $fRemoveScriptTags)
EndFunc

Func _HtmlParser_LoadScript ( $sFilename )
    Local $script = ""
    If FileExists ($sFilename) Then
        $script = FileRead($sFilename)
    Else
        If StringInStr($sFilename, "http://") OR StringInStr($sFilename, "https://") OR StringInStr($sFilename, "ftp://") Then
            Local $http = ObjCreate("winhttp.winhttprequest.5.1")
            $http.Open("GET", $sFilename)
            $http.Send()
            $script = $http.Responsetext
        EndIf
    EndIf
    If $script Then
        $_HtmlParser_Script &= @CRLF & @CRLF & $script
        Return 1
    EndIf
    Return 0
EndFunc

Func _HtmlParser_ClearScript ( $sFilename )
    $_HtmlParser_Script = ""
EndFunc

Func _HtmlParser_Exec ( $sScript )
    Local $doc = _HtmlParser_GetDocument()
    If IsObj($doc) AND IsObj($doc.parentWindow) Then
        Local $window = $doc.parentWindow
        $window.execScript('window._HtmlParser_Result=(function(){' & $sScript & '})();', 'Javascript')
        If $window._HtmlParser_Result OR IsObj($window._HtmlParser_Result) Then
            Return $window._HtmlParser_Result
        Else
            Return SetError(2, 0, 0)
        EndIf
    EndIf
    Return SetError(1, 0, 0)
EndFunc

#region >> Internals

Func __HtmlParser_Shutdown ()
    Global $_HtmlParser_IE = 0
    If IsDeclared("_HtmlParser_HWND") Then WinClose($_HtmlParser_HWND)
    OnAutoItExitUnregister("__HtmlParser_Shutdown")
EndFunc

Func __HtmlParser_ParseCmdLine ()
    If @compiled Then
      Global $_HtmlParser_Exec = '"' & @ScriptFullPath & '"'
    Else
      Global $_HtmlParser_Exec = '"' & @AutoItExe & '" "' & @ScriptFullPath & '"'
    EndIf

    Local $cmd = StringInStr($CmdLineRaw, "/_HtmlParser_", 1), $val
    If $cmd > 0 Then
        #NoTrayIcon
        $cmd = StringRegExp(StringMid($CmdLineRaw, $cmd), '/(_HtmlParser_[a-zA-Z]+)\:"([^"]*)"', 3)
        For $i = 0 To UBound($cmd)-1 Step 2
            $val = $cmd[$i+1]
            If $val = ("" & Number($val)) Then $val = Number($val)
            Assign($cmd[$i], $val, 2)
        Next
        __HtmlParser_DaemonRun()
        Exit
    Else
        Global $_HtmlParser_GUID = __WinAPI_CreateGUID()
        __HtmlParser_Daemonstart()
    EndIf
EndFunc

Func __HtmlParser_Daemonstart ()
    Run ( $_HtmlParser_Exec & _
        ' /_HtmlParser_GUID:"' & $_HtmlParser_GUID & '"' & _
        ' /_HtmlParser_Debug:"' & (0 + $_HtmlParser_Debug) & '"' & _
        ' /_HtmlParser_Port:"' & $_HtmlParser_Port & '"' )
EndFunc

Func __HtmlParser_DaemonRun ()
    ; Initialize GUI
    Local $hGUI = GUICreate("", 500, 400, 10, 10, $WS_SIZEBOX, $WS_EX_TOOLWINDOW)
    Global $_HtmlParser_IE = _IECreateEmbedded()
    Local $hIE = GUICtrlCreateObj($_HtmlParser_IE, 0, 0, _WinAPI_GetClientWidth($hGUI), _WinAPI_GetClientHeight($hGUI))
    GUICtrlSetResizing($hIE, $GUI_DOCKAUTO)
    GUIRegisterMsg($WM_SYSCOMMAND, "__HtmlParser_SysCommand")
    If $_HtmlParser_Debug Then GUISetState()

    ; Initialize IE
    _IE_SetSessionProxy("127.0.0.1:" & $_HtmlParser_Port)
    _IENavigate($_HtmlParser_IE, "about:blank")
    _IEPropertySet($_HtmlParser_IE, "silent", True)
    WinSetTitle($hGUI, "", $_HtmlParser_GUID)

    Local $timeout = TimerInit()
    Do
        If TimerDiff($timeout) > 5000 Then Exit
    Until WinGetTitle($hGUI) <> $_HtmlParser_GUID
    If $_HtmlParser_Debug Then WinSetTitle($hGUI, "", "HtmlParser Debug Window")

    While 1
        Sleep(100)
    WEnd
EndFunc

Func __HtmlParser_SysCommand ($hWnd, $Msg, $wParam, $lParam)
    #forceref $Msg, $wParam, $lParam
    If BitAND($wParam, 0xFFF0) = 0xF060 Then Exit
    Return $GUI_RUNDEFMSG
EndFunc

#endregion << Internals

#region >> WinAPIEx

Func __WinAPI_CreateGUID()

    Local $tGUID, $Ret

    $tGUID = DllStructCreate($tagGUID)
    $Ret = DllCall('ole32.dll', 'uint', 'CoCreateGuid', 'ptr', DllStructGetPtr($tGUID))
    If @error Then
        Return SetError(1, 0, '')
    Else
        If $Ret[0] Then
            Return SetError(1, $Ret[0], 0)
        EndIf
    EndIf
    $Ret = DllCall('ole32.dll', 'int', 'StringFromGUID2', 'ptr', DllStructGetPtr($tGUID), 'wstr', '', 'int', 39)
    If (@error) Or (Not $Ret[0]) Then
        Return SetError(1, 0, '')
    EndIf
    Return $Ret[2]
EndFunc   ;==>__WinAPI_CreateGUID

Func _IE_SetSessionProxy ($sProxyAddress, $sBypassList="")
    Local $tProxyAddress = DllStructCreate("char[" & StringLen($sProxyAddress) + 1 & "]"), _
          $tBypassList = DllStructCreate("char[" & StringLen($sBypassList) + 1 & "]"), _
          $tINTERNET_PROXY_INFO = DllStructCreate($tagINTERNET_PROXY_INFO)

    DllStructSetData($tINTERNET_PROXY_INFO, "dwAccessType", 0x3)
    DllStructSetData($tProxyAddress, 1, $sProxyAddress)
    DllStructSetData($tINTERNET_PROXY_INFO, "lpszProxy", DllStructGetPtr($tProxyAddress))
    DllStructSetData($tBypassList, 1, $sBypassList)
    DllStructSetData($tINTERNET_PROXY_INFO, "lpszProxyBypass", DllStructGetPtr($tBypassList))

    Local $aRet = DllCall("urlmon.dll", "INT", "UrlMkSetSessionOption", _
                            "uint", 0x26, _
                            "ptr", DllStructGetPtr($tINTERNET_PROXY_INFO), _
                            "int", DllStructGetSize($tINTERNET_PROXY_INFO), _
                            "int", 0 )
    If @error OR $aRet[0] Then Return SetError(1, @error, 0)

    Return 1
EndFunc

#endregion << WinAPIEx

#region >> Debugging

Func _Alert ($msg, $fDialog=1)
  If $fDialog Then
    MsgBox(0, @ScriptName, $msg)
  Else
    TrayTip(@ScriptName, $msg, 5000)
  EndIf
EndFunc

Func _Critical ($ret, $rel=0, $msg="Fatal Error", $err=@error, $ext=@extended, $ln = @ScriptLineNumber)
  If $err Then
    $ln += $rel
    Local $LastError = _WinAPI_GetLastError(), _
          $LastErrorMsg = _WinAPI_GetLastErrorMessage(), _
          $LastErrorHex = Hex($LastError)
    $LastErrorHex = "0x" & StringMid($LastErrorHex, StringInStr($LastErrorHex, "0", 1, -1)+1)
    $msg &= @CRLF & "at line " & $ln & @CRLF & @CRLF & "AutoIt Error: " & $err & " (0x" & Hex($err)  & ") Extended: " & $ext
    If $LastError Then $msg &= @CRLF & "WinAPI Error: " & $LastError & " (" & $LastErrorHex & ")" & @CRLF & $LastErrorMsg
    ClipPut($msg)
    MsgBox(270352, "Fatal Error - " & @ScriptName, $msg)
    Exit
  EndIf
  Return $ret
EndFunc

#endregion << Debugging

