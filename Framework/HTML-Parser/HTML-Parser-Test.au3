#include "HTML-Parser.au3"
; ==============================================================================






_HtmlParser_Test()


Func _HtmlParser_Test ()
    $_HtmlParser_Debug = True

    _Critical( _HtmlParser_Startup() )

    ; warming up
    Local $doc = _HtmlParser_GetDocument()
    $doc.write("Hello AutoIt World")
    _Alert("now for real")

    _HtmlParser_LoadScript("https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js")
    ; Or:
    ; _HtmlParser_LoadScript(@ScriptDir & "\jquery.min.js")
    Local $doc = _HtmlParser_LoadUrl("http://www.autoitscript.com", True)
    Local $pages = _Critical( _HtmlParser_Exec('var p=[];$("p").each(function(index) { p.push("[" + (index+1) + "] " + $(this).text());});return p') )
    Local $s = ""
    For $i = 0 To $pages.length-1
        $s &= $pages.get($i) & @CRLF
    Next
    _Alert($s)

    Local $saved = $doc.body.parentElement.outerHTML
    Local $divs = _HtmlParser_Exec('return $(".featitem.clearfix")')
    Local $div, $features = ""
    For $i = 0 To $divs.length-1
        $div = $divs.get($i)
        $features &= $div.outerHTML
    Next
    $doc.body.innerHTML = $features
    _Alert("A lot faster parsing in javascript though")

    _HtmlParser_LoadHtml($saved, True)
    Local $features = _HtmlParser_Exec('var s=""; $(".featitem.clearfix").each(function(){ s += this.outerHTML }); document.body.innerHTML=s; return s')
    _Alert($features)

EndFunc
