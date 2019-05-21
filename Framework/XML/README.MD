[XML OBJECT]<br/>
<br/>
[Usage]<br/><br/>
Global $oXML = _CreateXMLObject() ;Object var to use in the main script - global initialiser<br/>
With $oXML<br />
	.start()<br/>
	.gTranslate("please make me japain", "ja")<br/>
	ConsoleWrite( .getTranslateResult() )<br/>
EndWith<br/>
<br/>
<br/>
[Current functionality]<br/><br/>
*Main Methods:<br/>
.start<br/>
.post<br/>
.get<br/>
.action<br/>
._send<br/>
.response<br/>
.responseHeader<br/>
close<br/>
*Main Propertys:<br/>
._XML_OBJECT<br/>
<br/>
*Error Methods:<br/>
._setError<br/>
*Error Propertys:<br/>
._getError<br/>
._getErrorNum<br/>
._getErrorExt:<br/>
<br/>
*Response Methods:<br/>
.setResponse<br/>
.getResponse<br/>
*Response Propertys:<br/>
._response<br/>
<br/>
*url Methods:<br/>
.setUrl<br/>
.getUrl<br/>
*url Propertys:<br/>
.url<br/>
<br/>
*Translate Methods:<br/>
.gTranslate<br/>
.getTranslateResult<br/>
.getLastTranslateURL<br/>
.setTranslateResult {most likely internal usage only}<br/>
.cleanTranslateResult {most likely internal usage only}<br/>
._setCleanTranslationResult {most likely internal usage only}<br/>
._getCleanTranslationResult {most likely internal usage only}<br/>
._cleanTranslateResult {most likely internal usage only}<br/>
<br/>
*Translate Propertys:<br/>
.tUrl {use get/set}<br/>
._translateResult {use get/set}<br/>
._cleanTranslateResult {use get/set}<br/>
<br/>
*Encoding/Decoding Methods:<br/>
.encodeURI<br/>
.setEncode<br/>
.getEncode<br/>
.decodeURI <br/>
.setDecode<br/>
.getDecode<br/>
*Encoding/Decoding Propertys:<br/>
._encode {use get/set}<br/>
._decode {use get/set}<br/>
<br/>
*Request header Methods:<br/>
.requestHeader<br/>
*Request header Propertys:<br/>
._requestHeader {use get/set}<br/>
<br/>
*Cookie Methods:<br/>
.setCookie<br/>
.getCookie<br/>
.getSetCookie<br/>
._generateRandomCookie {most likely internal usage only}<br/>
._getRandCookie {most likely internal usage only}<br/>
._setRandCookie {most likely internal usage only}<br/>
.cLogin<br/>
*request header Propertys:<br/>
._cookie {use get/set}<br/>
.__rCookie {most likely internal usage only}<br/>
<br/>





<br/>
![.getResponse()] for [https://google.de]  [stringleft(100) to shorten result]<br/>
+Result:	<!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="de"><head><meta content<br/>
<br/>
![.gTranslate( 'hallo ich soll ein englischer text werden' )]:<br/>
----------------------------------------<br/>
+Result:	hello I should be an English text<br/>
<br/>
![.gTranslate( 'ich will auch übersetzt werden' )]<br/>
----------------------------------------<br/>
+Result:	I want to be translated too<br/>
<br/>
![.getResponseHeader('server')] for [https://eu.evga.com/]<br/>
+Result:	Microsoft-IIS/10.0<br/>
<br/>
![LAST ERROR]<br/>
<br/>
-Last Error Text:	No Error<br/>
-Last Error @error:	0<br/>
-Last Error @extended:	0<br/>