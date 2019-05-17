#include "AutoIt-HTML-Parser.au3"


;_HTMLParser($sHTML)
;_HTMLParser_GetElementByID($sID, $pItem, $sHTML)
;_HTMLParser_GetElementsByClassName($sClassName, $pItem, $sHTML)
;_HTMLParser_GetElementsByTagName($sTagName, $pItem, $sHTML)
;_HTMLParser_Element_GetText($pItem, $sHTML, $strtrim=True);TODO: if $pItem passed is a Void/Foreign element Return SetError(3, 0, 0)
;_HTMLParser_Element_GetAttribute($sAttributeName, $pItem, $sHTML)
;_HTMLParser_Element_GetParent # undone
;_HTMLParser_Element_GetChildren($pItem, $sHTML)
;_HTMLParser_GetFirstStartTag($pItem, $sHTML)
;_HTMLParser_VoidOrSelfClosingElement($pItem, $sHTML)
;_HTMLParser_IsVoidElement($pItem, $sHTML)
;_HTMLParser_IsForeignElement #undone

; Remarks .......: @extended is set to indicate where no more matches could be parsed.
;                  To check for errors check @extended with string length or check if $tagTokenListList.First is equals zero.
;                  Note: Currently this function uses the same $tagTokenListList structure every time it is called. Calling this
;                  function multiple times will add the new results to the previous results. This may have unexspected results.

$h = FileRead("test.html")
$sHTML = $h
$tTokenList = _HTMLParser($sHTML)
$pItem = _HTMLParser_GetFirstStartTag($tTokenList.First, $sHTML);finds first start tag. In this example it will be <html>
$aText = _HTMLParser_Element_GetText($pItem, $sHTML)
;this will be changed for a later version
For $i=0 To Ubound($aText, 1)-1
    _MemMoveMemory($aText[$i], $__g_pTokenListToken, $__g_iTokenListToken)
    ConsoleWrite(StringMid($sHTML, $__g_tTokenListToken.Start, $__g_tTokenListToken.Length)&@crlf)
Next