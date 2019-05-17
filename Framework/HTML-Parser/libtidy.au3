#include-once
#include <WinAPI.au3>

; Opt("MustDeclareVars", 1)

Global $_DLL_LibTidy = -1
Global $_DLL_LibTidy_Document = 0
; Tidy Options ID
Global Enum $_LibTidy_optTypeString, $_LibTidy_optTypeInteger, $_LibTidy_optTypeBoolean
Global Enum $_LibTidy_optName, $_LibTidy_optType, $_LibTidy_optValue, $_LibTidy_optMAX
; NOTE: differ among DLL version!
Global Enum $_LibTidy__indentSpaces = 1, $_LibTidy__wrap, $_LibTidy__tabSize, $_LibTidy__charEncoding, $_LibTidy__inputEncoding, $_LibTidy__outputEncoding, $_LibTidy__newline, $_LibTidy__doctypeMode, $_LibTidy__doctype, $_LibTidy__repeatedAttributes, $_LibTidy__altText, $_LibTidy__slideStyle, $_LibTidy__errorFile, $_LibTidy__outputFile, $_LibTidy__writeBack, $_LibTidy__markup, $_LibTidy__showWarnings, $_LibTidy__quiet, $_LibTidy__indent, $_LibTidy__hideEndtags, $_LibTidy__inputXml, $_LibTidy__outputXml, $_LibTidy__outputXhtml, $_LibTidy__outputHtml, $_LibTidy__addXmlDecl, $_LibTidy__uppercaseTags, $_LibTidy__uppercaseAttributes, $_LibTidy__bare, $_LibTidy__clean, $_LibTidy__logicalEmphasis, $_LibTidy__dropProprietaryAttributes, $_LibTidy__dropFontTags, $_LibTidy__dropEmptyParas, $_LibTidy__fixBadComments, $_LibTidy__breakBeforeBr, $_LibTidy__split, $_LibTidy__numericEntities, $_LibTidy__quoteMarks, $_LibTidy__quoteNbsp, $_LibTidy__quoteAmpersand, $_LibTidy__wrapAttributes, $_LibTidy__wrapScriptLiterals, $_LibTidy__wrapSections, $_LibTidy__wrapAsp, $_LibTidy__wrapJste, $_LibTidy__wrapPhp, $_LibTidy__fixBackslash, $_LibTidy__indentAttributes, $_LibTidy__assumeXmlProcins, $_LibTidy__addXmlSpace, $_LibTidy__encloseText, $_LibTidy__encloseBlockText, $_LibTidy__keepTime, $_LibTidy__word2000, $_LibTidy__tidyMark, $_LibTidy__gnuEmacs, $_LibTidy__gnuEmacsFile, $_LibTidy__literalAttributes, $_LibTidy__showBodyOnly, $_LibTidy__fixUri, $_LibTidy__lowerLiterals, $_LibTidy__hideComments, $_LibTidy__indentCdata, $_LibTidy__forceOutput, $_LibTidy__showErrors, $_LibTidy__asciiChars, $_LibTidy__joinClasses, $_LibTidy__joinStyles, $_LibTidy__escapeCdata, $_LibTidy__language, $_LibTidy__ncr, $_LibTidy__outputBom, $_LibTidy__replaceColor, $_LibTidy__cssPrefix, $_LibTidy__newInlineTags, $_LibTidy__newBlocklevelTags, $_LibTidy__newEmptyTags, $_LibTidy__newPreTags, $_LibTidy__accessibilityCheck, $_LibTidy__verticalSpace, $_LibTidy__punctuationWrap, $_LibTidy__mergeDivs, $_LibTidy__decorateInferredUl, $_LibTidy__preserveEntities, $_LibTidy__sortAttributes, $_LibTidy__mergeSpans, $_LibTidy__anchorAsName, $_LibTidy_OptionsMAX
Global $_LibTidy_ConfigInf[$_LibTidy_OptionsMAX][$_LibTidy_optMAX]

Func _LibTidy_Startup ($sPath="LibTidy.DLL")
    Dim $_DLL_LibTidy
    Dim $_DLL_LibTidy_Document
    Dim $_LibTidy_ConfigInf
    
    If $_DLL_LibTidy = -1 Then
        If NOT FileExists($sPath) Then
            If NOT FileExists(@ScriptDir & "\" & $sPath) Then Return SetError(1, 0, 0) ; DLL File not found
            $sPath = @ScriptDir & "\" & $sPath
        EndIf
        ; Load DLL
        $_DLL_LibTidy = DllOpen($sPath)
        If $_DLL_LibTidy = -1 Then Return SetError(2, 0, 0) ; Can't load DLL
        ; Try obtain LibTidy Document
        While 1
        
            Local $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyCreate")
            If @error OR NOT $aRet[0] Then ExitLoop SetError(3, @error, 1) ; Can't obtain LibTidy Document
            $_DLL_LibTidy_Document = $aRet[0]
            
            _LibTidy_GetAllOptions($_LibTidy_ConfigInf)
            If @error Then ExitLoop SetError(@error, @extended, 1) ; Rethrow _LibTidy_GetAllOptions Error
        
            ExitLoop
        WEnd
        If @error Then
            Local $err = @error, $ext = @extended
            DllClose($_DLL_LibTidy)
            $_DLL_LibTidy = -1
            Return SetError($err, $ext, 0) ; rethrow error from __LibTidy_Startup_TRY
        Else
            OnAutoItExitRegister("__LibTidy_UnLoad")
        EndIf
    EndIf
    
    Return 1
EndFunc

Func _LibTidy_Shutdown ()
    If __LibTidy_UnLoad() Then OnAutoItExitUnRegister("__LibTidy_UnLoad")
EndFunc

Func __LibTidy_UnLoad ()
    
    Dim $_DLL_LibTidy
    If $_DLL_LibTidy = -1 Then Return 1
    
    Dim $_DLL_LibTidy_Document
    
    ; Unload DLL
    If $_DLL_LibTidy <> -1 Then
        ; Release LibTidy Document
        If $_DLL_LibTidy_Document Then 
            DllCall($_DLL_LibTidy, "none", "tidyRelease", "ptr", $_DLL_LibTidy_Document)
            $_DLL_LibTidy_Document = 0
        EndIf
        DllClose($_DLL_LibTidy)
        $_DLL_LibTidy = -1
    EndIf
    
    Return $_DLL_LibTidy = -1
EndFunc

Func __FileValidate ($sFilename=0, $sPath=@ScriptDir)
    If NOT $sFilename Then Return SetError(1, 0, 0) ; empty input
    
    If NOT FileExists($sFilename) Then
        ; Try default path
        If NOT FileExists($sPath & "\" & $sFilename) Then Return SetError(2, 0, 0) ; File not Found
        $sFilename = $sPath & "\" & $sFilename
    EndIf
    
    If StringInStr(FileGetAttrib($sFilename), "D", 1) Then Return SetError(3, 0, 0) ; path is Directory
    
    Return $sFilename
EndFunc

Func _LibTidy_LoadConfig ($sPath=0)
    
    $sPath = __FileValidate($sPath)
    If @error Then Return SetError (1, @error, 0)
    
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(2, 0, 0) ; Call Startup first!
        
    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidyLoadConfig", _
                                                    "ptr", $_DLL_LibTidy_Document, _
                                                    "str", $sPath )
    If @error Then Return SetError(3, @error, 0)
    If $aRet[0] Then
        $aRet = DllCall($_DLL_LibTidy, "UINT", "tidyConfigErrorCount", _
                                            "ptr", $tidyLoadConfig )
        If @error Then Return SetError(4, @error, 0)
        If $aRet[0] Then Return SetError(5, $aRet[0], 0) ; error in config file
    EndIf
    
    Return 1
EndFunc

Func _LibTidy_ResetConfig ()

    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, 0) ; Call Startup first!

    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidyOptResetAllToDefault", _
                                                    "ptr", $_DLL_LibTidy_Document )
    If @error OR NOT $aRet[0] Then Return SetError(2, @error, 0)
    
    Return 1
EndFunc

Func _LibTidy_SaveConfig ($sPath, $fAllOptions=0, $iMode=2)
    Local $aConfig[$_LibTidy_OptionsMAX][$_LibTidy_optMAX]
    Local $sData = "", $fNotDefault, $value
    
    If NOT _LibTidy_GetAllOptions($aConfig) Then Return SetError(2, 0, 0)
    
    For $i = 1 To $_LibTidy_OptionsMAX - 1
        $value = $aConfig[$i][$_LibTidy_optValue]
        $fNotDefault = $fAllOptions OR $value <> $_LibTidy_ConfigInf[$i][$_LibTidy_optValue]
        If $fNotDefault Then
            If $aConfig[$i][$_LibTidy_optType] = $_LibTidy_optTypeBoolean Then
                If $value Then 
                    $value = "yes" 
                Else 
                    $value = "no"
                EndIf
            EndIf
            $sData &= $aConfig[$i][$_LibTidy_optName] & ": " & $value & @CRLF
        EndIf
    Next
    
    Local $hFile = FileOpen($sPath, $iMode)
    If $hFile = -1 Then Return SetError(4, 0, "")
    
    Local $fResult = FileWrite($hFile, $sData)
    FileClose($hFile)
    
    If $fResult Then
        Return $sData
    Else
        Return SetError(4, 0, "")
    EndIf
EndFunc

Func _LibTidy_GetAllOptions (ByRef $aConfig)

    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(100, 0, 0) ; Call Startup first!

    Local $debug = ""
    Local $id = 1, $pOption
    
    Local $tIterator = DllStructCreate("ptr"), _
                $pIterator = DllStructGetPtr($tIterator)
    
    ; Test Configuration's compability
    Local $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyGetOptionList", _
                                                    "ptr", $_DLL_LibTidy_Document )
    If @error OR NOT $aRet[0] Then Return SetError(4, 1, 0) ; Can't get iterator
    DllStructSetData($tIterator, 1, $aRet[0])
    
    While DllStructGetData($tIterator, 1)
        $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyGetNextOption", _
                                            "ptr", $_DLL_LibTidy_Document, _
                                            "ptr", $pIterator )
        If @error OR NOT $aRet[0] Then Return SetError(4, 2, 0) ; Can't walk iterator
        $id += 1
    WEnd
    
    If $id <> $_LibTidy_OptionsMAX Then Return SetError(4, 3, 0) ; Version missmatch!
    $id = 1
    
    ; Retreive Configuration's Info
    Local $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyGetOptionList", _
                                                    "ptr", $_DLL_LibTidy_Document )
    If @error OR NOT $aRet[0] Then Return SetError(4, 1, 0) ; Can't get iterator
    DllStructSetData($tIterator, 1, $aRet[0])
    
    While DllStructGetData($tIterator, 1)
        ; Get Option's address
        $aRet = DllCall($_DLL_LibTidy, "PTR", "tidyGetNextOption", _
                                            "ptr", $_DLL_LibTidy_Document, _
                                            "ptr", $pIterator )
        If @error OR NOT $aRet[0] Then Return SetError(4, 2, 0) ; Can't walk iterator
        $pOption = $aRet[0]
        
        ; Get Option's name
        $aRet = DllCall($_DLL_LibTidy, "STR", "tidyOptGetName", _
                                            "ptr", $pOption )
        If @error OR NOT $aRet[0] Then Return SetError(5, 0, 0) ; Can't get option name
        $aConfig[$id][$_LibTidy_optName] = $aRet[0]

        ; Get Option's Type
        $aRet = DllCall($_DLL_LibTidy, "INT", "tidyOptGetType", _
                                            "ptr", $pOption )
        If @error Then Return SetError(6, 1, 0) ; Can't get option's type
        $aConfig[$id][$_LibTidy_optType] = $aRet[0]

        ; Get Option's Default Value
        $aConfig[$id][$_LibTidy_optValue] = _LibTidy_GetOption($id)
        If @error Then 
            If @error = 3 Then 
                Return SetError(6, 2, 0) ; Unknown option's type
            Else
                Return SetError(7, @extended, 0) ; Rethrow _LibTidy_GetOption Error
            EndIf
        EndIf

        $id += 1
    WEnd
    
    Return 1
EndFunc

Func _LibTidy_GetOption ($ID)
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, 0) ; Call Startup first!
    
    Switch $_LibTidy_ConfigInf[$ID][$_LibTidy_optType]
    
        Case $_LibTidy_optTypeString
            Local $aRet = DllCall($_DLL_LibTidy, "STR", "tidyOptGetValue", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID )
            If @error Then Return SetError(2, 1, 0) ; Error fetching string data
            Return $aRet[0]
            
        Case $_LibTidy_optTypeInteger
            Local $aRet = DllCall($_DLL_LibTidy, "ULONG", "tidyOptGetInt", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID )
            If @error Then Return SetError(2, 2, 0) ; Error fetching integer data
            Return $aRet[0]
            
        Case $_LibTidy_optTypeBoolean
            Local $aRet = DllCall($_DLL_LibTidy, "BOOL", "tidyOptGetBool", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID )
            If @error Then Return SetError(2, 2, 0) ; Error fetching boolean data
            Return 0 <> $aRet[0]
            
        Case Else
            Return SetError(3, 0, 0) ; Unknown type
    EndSwitch
EndFunc

Func _LibTidy_SetOption ($ID, $Value)
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, 0) ; Call Startup first!
    
    Switch $_LibTidy_ConfigInf[$ID][$_LibTidy_optType]
    
        Case $_LibTidy_optTypeString
            If NOT IsString($Value) Then Return SetError(2, 1, 0) ; Invalid value type
            Local $aRet = DllCall($_DLL_LibTidy, "BOOL", "tidyOptSetValue", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID, _
                                                            "str", $Value )
            If @error Then Return SetError(3, 1, 0) ; Error setting string data
            
        Case $_LibTidy_optTypeInteger
            If NOT IsInt($Value) Then Return SetError(2, 2, 0) ; Invalid value type
            If @error Then Return SetError(2, 2, 0) ; Invalid value type
            Local $aRet = DllCall($_DLL_LibTidy, "BOOL", "tidyOptSetInt", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID, _
                                                            "ulong", Int($Value, 1) )
            If @error Then Return SetError(3, 2, 0) ; Error setting integer data
            
        Case $_LibTidy_optTypeBoolean
            If NOT IsBool($Value) Then Return SetError(2, 3, 0) ; Invalid value type
            If @error Then Return SetError(2, 3, 0) ; Invalid value type
            Local $aRet = DllCall($_DLL_LibTidy, "BOOL", "tidyOptSetBool", _
                                                            "ptr", $_DLL_LibTidy_Document, _
                                                            "int", $ID, _
                                                            "bool", $Value )
            If @error Then Return SetError(3, 3, 0) ; Error setting boolean data
            
        Case Else
            Return SetError(4, 0, 0) ; Unknown type
    EndSwitch
    
    Return 1
EndFunc

Func _LibTidy_LoadString ($sData="")
    If NOT StringStripWS($sData, 3) Then Return SetError(2, 2, 0) ; empty string
    
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(2, 1, 0) ; Call Startup first!

    Local $tBuffer = DllStructCreate("char[" & (StringLen($sData) + 1) & "]"), _
                $pBuffer = DllStructGetPtr($tBuffer)
    DllStructSetData($tBuffer, 1, $sData)
    
    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidyParseString", _
                                                    "ptr", $_DLL_LibTidy_Document, _
                                                    "ptr", $pBuffer )
    If @error OR NOT $aRet[0] Then Return SetError(3, @error, 0)
    
    Return 1
EndFunc

Func _LibTidy_LoadFile ($sPath=0)

    $sPath = __FileValidate($sPath)
    If @error Then Return SetError (1, @error, 0)

    _LibTidy_LoadString(FileRead($sPath))
    If @error Then Return SetError(@error, @extended, 0)
    
    Return 1
EndFunc

Func _LibTidy_SaveString ()
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, "") ; Call Startup first!

    Local $tBuffer = DllStructCreate("char[1]"), _
                $tBufLen = DllStructCreate("uint"), _
                $pBufLen = DllStructGetPtr($tBufLen)
    DllStructSetData($tBufLen, 1, 1)
    
    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidySaveString", _
                                                    "ptr", $_DLL_LibTidy_Document, _
                                                    "ptr", DllStructGetPtr($tBuffer), _
                                                    "ptr", $pBufLen )
    If @error Then Return SetError(2, @error, "")
    
    If $aRet[0] = -12 Then
        $tBuffer = DllStructCreate("char[" & DllStructGetData($tBufLen, 1) & "]")
        $aRet = DllCall($_DLL_LibTidy, "INT", "tidySaveString", _
                                            "ptr", $_DLL_LibTidy_Document, _
                                            "ptr", DllStructGetPtr($tBuffer), _
                                            "ptr", $pBufLen )
        If @error OR NOT $aRet[0] Then Return SetError(3, @error, "")
        Return DllStructGetData($tBuffer, 1)
    Else
        Return ""
    EndIf
EndFunc

Func _LibTidy_SaveFile ($sPath, $iMode=2)
    Local $sData = _LibTidy_SaveString()
    If @error Then Return SetError(@error, @extended, "")
    
    Local $hFile = FileOpen($sPath, $iMode)
    If $hFile = -1 Then Return SetError(4, 0, "")
    
    Local $fResult = FileWrite($hFile, $sData)
    FileClose($hFile)
    
    If $fResult Then
        Return $sData
    Else
        Return SetError(4, 0, "")
    EndIf
EndFunc

Func _LibTidy_CleanAndRepair ()
    Dim $_DLL_LibTidy, $_DLL_LibTidy_Document
    If $_DLL_LibTidy = -1 OR NOT $_DLL_LibTidy_Document Then Return SetError(1, 0, -1) ; Call Startup first!

    Local $aRet = DllCall($_DLL_LibTidy, "INT", "tidyCleanAndRepair", _
                                                    "ptr", $_DLL_LibTidy_Document )
    If @error OR NOT $aRet[0] Then Return SetError(4, @error, -1)
    
    Local $sResult = _LibTidy_SaveString()
    If @error Then Return SetError(@error, @extended, $sResult)
    
    Return $sResult
EndFunc

#cs 
================================================================================
Testbed, uncomment and run
================================================================================
#include <Array.au3>

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
        $msg &= @CRLF & "at line " & $ln & @CRLF & @CRLF & "AutoIt Error: " & $err & " (0x" & Hex($err)    & ") Extended: " & $ext 
        If $LastError Then $msg &= @CRLF & "WinAPI Error: " & $LastError & " (" & $LastErrorHex & ")" & @CRLF & $LastErrorMsg
        ClipPut($msg)
        MsgBox(270352, "Fatal Error - " & @ScriptName, $msg)
        Exit
    EndIf
    Return $ret
EndFunc

Func _Throw ($msg="Fatal Error", $rel=0, $ln = @ScriptLineNumber)
    _Critical(0, $rel, $msg, 0xDEADF00D, 0, $ln)
EndFunc

_Critical( _LibTidy_Startup() )
; Default Configuration Options:
_ArrayDisplay($_LibTidy_ConfigInf)

_Critical( _LibTidy_SetOption($_LibTidy__indentSpaces, 4) )
_Critical( _LibTidy_SetOption($_LibTidy__uppercaseTags, True) )
_Critical( _LibTidy_SetOption($_LibTidy__language, "id") )

If NOT _Critical( _LibTidy_ResetConfig() ) Then _Throw("Configuration reset failed")

Local $sFile = FileOpenDialog("Select LibTidy Configuration File", @ScriptDir, "Configuration file (*.cfg)|All files (*.*)")
If @error Then _Throw("Load Configuration File Aborted", -1)
_Critical( _LibTidy_LoadConfig($sFile) )

Local $sFile = FileOpenDialog("Select Web Page", @ScriptDir, "Web page (*.htm;*.html)|All files (*.*)")
If @error Then _Throw("Load Web Page Aborted", -1)
_Critical( _LibTidy_LoadFile($sFile) )

_Critical( _LibTidy_CleanAndRepair() )

Local $sFile = FileSaveDialog("Save As Web Page", @ScriptDir, "Web page (*.htm;*.html)|All files (*.*)")
If @error Then _Throw("Save Web Page Aborted", -1)
ClipPut(_Critical( _LibTidy_SaveFile($sFile) ))
_Alert("Processed page also available on clipboard.")

Local $sFile = FileSaveDialog("Save As LibTidy Configuration File", @ScriptDir, "Configuration file (*.cfg)|All files (*.*)")
If @error Then _Throw("Save Configuration File Aborted", -1)
_Critical( _LibTidy_SaveConfig($sFile) )

_Critical( _LibTidy_Shutdown() )
#ce
