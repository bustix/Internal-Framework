#include-once
#include "libtidy.au3"

; Opt("MustDeclareVars", 1)

Global Const $_HXmlParser_ScriptName = "HXmlParser.au3"
Global $_HXmlParser_DOM = 0

Func _HXmlParser_Startup ( $sConfFilename="tidy-xml-settings.cfg" )
    _LibTidy_Startup()
    If @error Then Return SetError(@error, @extended, 0)
    _LibTidy_LoadConfig($sConfFilename)
    If @error Then
        _LibTidy_Shutdown()
        Return SetError(@error, @extended, 0)
    EndIf
    $_HXmlParser_DOM = ObjCreate("MSXML2.DOMDocument")
    OnAutoItExitRegister("__HXmlParser_Shutdown")
    $_HXmlParser_DOM.validateOnParse = False;
    $_HXmlParser_DOM.resolveExternals = False;
    Return 1
EndFunc

Func __HXmlParser_Shutdown ()
    $_HXmlParser_DOM = 0
    OnAutoItExitUnRegister("__HXmlParser_Shutdown")
EndFunc

Func _HXmlParser_GetErrorString ()
    If IsObj($_HXmlParser_DOM.parseError) AND $_HXmlParser_DOM.parseError.errorCode Then
        Return "Error loading page " & _
                " (" & Hex($_HXmlParser_DOM.parseError.errorCode) & _
                ") at line: " & $_HXmlParser_DOM.parseError.line & _
                ", position: " & $_HXmlParser_DOM.parseError.linepos & _
                ", reason: " & $_HXmlParser_DOM.parseError.reason
    EndIf
    Return 0
EndFunc

Func _HXmlParser_LoadHtml ( $sHtml )
    If NOT $sHtml Then Return SetError(4, 0, 0)
    _LibTidy_LoadString( $sHtml )
    If @error Then Return SetError(@error, @extended, 0)
    $sHtml = _LibTidy_CleanAndRepair()
    If @error OR NOT $sHtml Then Return SetError(5, @error, 0)

    $sHtml = StringRegExp(StringMid($sHtml, StringInStr($sHtml, "<html")), "(?s)^<html[^>]*>[^<]*(<.*)", 1)
    If @error Then Return SetError(6, @error, 0)

    $sHtml = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd" [' _
        & '<!ENTITY nbsp " "><!ENTITY iexcl "¡"><!ENTITY cent "¢"><!ENTITY pound "£"><!ENTITY curren "¤"><!ENTITY yen "¥"><!ENTITY brvbar "¦"><!ENTITY sect "§"><!ENTITY uml "¨"><!ENTITY copy "©"><!ENTITY ordf "ª"><!ENTITY laquo "«"><!ENTITY not "¬"><!ENTITY shy "­"><!ENTITY reg "®"><!ENTITY macr "¯"><!ENTITY deg "°"><!ENTITY plusmn "±"><!ENTITY sup2 "²"><!ENTITY sup3 "³"><!ENTITY acute "´"><!ENTITY micro "µ"><!ENTITY para "¶"><!ENTITY middot "·"><!ENTITY cedil "¸"><!ENTITY sup1 "¹"><!ENTITY ordm "º"><!ENTITY raquo "»"><!ENTITY frac14 "¼"><!ENTITY frac12 "½"><!ENTITY frac34 "¾"><!ENTITY iquest "¿"><!ENTITY times "×"><!ENTITY divide "÷">' _
        & '<!ENTITY Agrave "À"><!ENTITY Aacute "Á"><!ENTITY Acirc "Â"><!ENTITY Atilde "Ã"><!ENTITY Auml "Ä"><!ENTITY Aring "Å"><!ENTITY AElig "Æ"><!ENTITY Ccedil "Ç"><!ENTITY Egrave "È"><!ENTITY Eacute "É"><!ENTITY Ecirc "Ê"><!ENTITY Euml "Ë"><!ENTITY Igrave "Ì"><!ENTITY Iacute "Í"><!ENTITY Icirc "Î"><!ENTITY Iuml "Ï"><!ENTITY ETH "Ð"><!ENTITY Ntilde "Ñ"><!ENTITY Ograve "Ò"><!ENTITY Oacute "Ó"><!ENTITY Ocirc "Ô"><!ENTITY Otilde "Õ"><!ENTITY Ouml "Ö"><!ENTITY Oslash "Ø"><!ENTITY Ugrave "Ù"><!ENTITY Uacute "Ú"><!ENTITY Ucirc "Û"><!ENTITY Uuml "Ü"><!ENTITY Yacute "Ý"><!ENTITY THORN "Þ"><!ENTITY szlig "ß"><!ENTITY agrave "à"><!ENTITY aacute "á"><!ENTITY acirc "â"><!ENTITY atilde "ã"><!ENTITY auml "ä"><!ENTITY aring "å"><!ENTITY aelig "æ"><!ENTITY ccedil "ç"><!ENTITY egrave "è"><!ENTITY eacute "é"><!ENTITY ecirc "ê"><!ENTITY euml "ë"><!ENTITY igrave "ì"><!ENTITY iacute "í"><!ENTITY icirc "î"><!ENTITY iuml "ï"><!ENTITY eth "ð"><!ENTITY ntilde "ñ"><!ENTITY ograve "ò"><!ENTITY oacute "ó"><!ENTITY ocirc "ô"><!ENTITY otilde "õ"><!ENTITY ouml "ö"><!ENTITY oslash "ø"><!ENTITY ugrave "ù"><!ENTITY uacute "ú"><!ENTITY ucirc "û"><!ENTITY uuml "ü"><!ENTITY yacute "ý"><!ENTITY thorn "þ"><!ENTITY yuml "ÿ">' _
        & ']>' & @CRLF _
        & '<html>' & @CRLF _
        & $sHtml[0]

    $_HXmlParser_DOM.loadXML($sHtml);
    If IsObj($_HXmlParser_DOM.parseError) AND $_HXmlParser_DOM.parseError.errorCode Then
        SetError(7, $_HXmlParser_DOM.parseError.errorCode, 0)
    EndIf

    $_HXmlParser_DOM.setProperty("SelectionLanguage", "XPath");

    Return $_HXmlParser_DOM
EndFunc

Func _HXmlParser_LoadUrl ( $sUrl )
    Local $http = ObjCreate("winhttp.winhttprequest.5.1")
    $http.Open("GET", $sUrl)
    $http.Send()
    Local $ret = _HXmlParser_LoadHtml($http.Responsetext)
    If @error Then Return SetError(@error, @extended, $ret)
    Return $ret
EndFunc


#region >> Debugging

Func _Alert ($msg, $fDialog=1, $err=@error, $ext=@extended, $ln = @ScriptLineNumber)
  If $fDialog Then
    MsgBox(0, @ScriptName, $msg)
  Else
    TrayTip(@ScriptName, $msg, 5000)
  EndIf
  If $err Then Return SetError($err, $ext, $ln)
  Return 0
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
    $msg &= @CRLF & @CRLF & _HXmlParser_GetErrorString()
    ClipPut($msg)
    MsgBox(270352, "Fatal Error - " & @ScriptName, $msg)
    Exit
  EndIf
  Return $ret
EndFunc

#endregion << Debugging

Func _HXmlParser_Test ()

    _Critical( _HXmlParser_Startup() )
    Local $dom = _Critical( _HXmlParser_LoadUrl("http://www.AutoItScript.com") )

    _Alert("Removing all SCRIPT tags")
    Local $begin = TimerInit()
    Local $nodes = $dom.selectNodes("//script")
    If $nodes.length Then
        For $i = 0 To $nodes.length - 1
            Local $node = $nodes.item($i)
            $node.parentNode.removeChild($node)
        Next
    EndIf
    _Alert("Done in " & TimerDiff($begin) & " ms")

    _Alert("Collecting all P tags")
    Local $count = 1, $s = ""
    $begin = TimerInit()
    $nodes = $dom.selectNodes("//p")
    If $nodes.length Then
        For $i = 0 To $nodes.length - 1
            Local $node = $nodes.item($i)
            $s &= "[" & $count & "] " & $node.text & @CRLF
            $count += 1
        Next
    EndIf
    _Alert("Done in " & TimerDiff($begin) & " ms")
    _Alert($s)

    $s = ""
    _Alert("Collecting all feature DIVs")
    $begin = TimerInit()
    $nodes = $dom.selectNodes("//div[contains(@class, 'featitem')]")
    If $nodes.length Then
        For $i = 0 To $nodes.length - 1
            Local $node = $nodes.item($i)
            $s &= $node.xml & @CRLF
        Next
    EndIf
    _Alert("Done in " & TimerDiff($begin) & " ms")
    _Alert($s)

    ClipPut($dom.xml)
    _Alert("HTML content is in clipboard")

EndFunc
If @ScriptName = $_HXmlParser_ScriptName Then _HXmlParser_Test()