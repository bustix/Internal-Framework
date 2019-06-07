#Region ;**** Directives created by AutoIt3Wrapper_GUI ****

#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_SaveSource=y
#Au3Stripper_Parameters=/mo
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#﻿AutoIt3Wrapper_Res_SaveSourceDirecti﻿ve﻿
Opt("MustDeclareVars", 1)
Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc"); Initialize
#include "Framework\AutoItObject\FastObject.au3"
#include "Framework\XML\XML_Object.au3" ; working except cookies & login untestet -> next.
#include "Framework\MULTI_PROCESS\thread.au3\THREAD_Object.au3"
#include "Framework\MULTI_PROCESS\rh_self_run_test\CodeExtractor_Object.au3"
	EndWith
#EndRegion
#ce
#Region ###	CodeExtractor EXAMPLE ### (From Executable Resources)
	Global $oCE = _CreateCodeExtractorObject() ;Object var to use in the main script - global initialiser
	With $oCE
		.extractSource('TEST')
		.saveSource(@ScriptDir, "Complete_Source_from_RC_DATA.txt")
			ConsoleWrite( .getError("saveSource", "get source from RC_DATA") )
			ConsoleWrite( "error text only:" & @CRLF & ._errorText & @CRLF & @CRLF )
		MsgBox(0,"",.getError("saveSource",  "get source from RC_DATA"))
		.destroyAll()
Exit
Func MyErrFunc()
  ConsoleWrite("! [AutoIt-COM]	We intercepted a COM Error !"    		& @CRLF & @CRLF & _
             "	err.description is: " & @TAB & $oMyError.description  		& @CRLF & _
             "	err.windescription:"   & @TAB & $oMyError.windescription 	& @CRLF & _
             "	err.number is: "       & @TAB & hex($oMyError.number,8)  	& @CRLF & _
             "	err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   	& @CRLF & _
             "	err.scriptline is: "   & @TAB & $oMyError.scriptline   		& @CRLF & _
             "	err.source is: "       & @TAB & $oMyError.source       		& @CRLF & _
             "	err.helpfile is: "       & @TAB & $oMyError.helpfile    	& @CRLF & _
             "	err.helpcontext is: " & @TAB & $oMyError.helpcontext 		& @CRLF & _
             "	@ScriptLineNumber is: "  & @TAB & @ScriptLineNumber     	& @CRLF & @CRLF _
			 )
Endfunc
#comments-start
	Copyright 2013 Dragana R. <trancexx at yahoo dot com>
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
#comments-end
#include "WinHttpConstants.au3"
Global Const $hWINHTTPDLL__WINHTTP = DllOpen("winhttp.dll")
DllOpen("winhttp.dll") ; making sure reference count never reaches 0
Func _WinHttpAddRequestHeaders($hRequest, $sHeader, $iModifier = Default)
	__WinHttpDefault($iModifier, $WINHTTP_ADDREQ_FLAG_ADD_IF_NEW)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpAddRequestHeaders", _
			"handle", $hRequest, _
			"wstr", $sHeader, _
			"dword", -1, _
			"dword", $iModifier)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
Func _WinHttpCheckPlatform()
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCheckPlatform")
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
Func _WinHttpCloseHandle($hInternet)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCloseHandle", "handle", $hInternet)
Func _WinHttpConnect($hSession, $sServerName, $iServerPort = Default)
	Local $aURL = _WinHttpCrackUrl($sServerName), $iScheme = 0
	If @error Then
		__WinHttpDefault($iServerPort, $INTERNET_DEFAULT_PORT)
	Else
		$sServerName = $aURL[2]
		$iServerPort = $aURL[3]
		$iScheme = $aURL[1]
	EndIf
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpConnect", _
			"handle", $hSession, _
			"wstr", $sServerName, _
			"dword", $iServerPort, _
			"dword", 0)
	_WinHttpSetOption($aCall[0], $WINHTTP_OPTION_CONTEXT_VALUE, $iScheme)
Func _WinHttpCrackUrl($sURL, $iFlag = Default)
	__WinHttpDefault($iFlag, $ICU_ESCAPE)
	Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
			"ptr SchemeName;" & _
			"dword SchemeNameLength;" & _
			"int Scheme;" & _
			"ptr HostName;" & _
			"dword HostNameLength;" & _
			"word Port;" & _
			"ptr UserName;" & _
			"dword UserNameLength;" & _
			"ptr Password;" & _
			"dword PasswordLength;" & _
			"ptr UrlPath;" & _
			"dword UrlPathLength;" & _
			"ptr ExtraInfo;" & _
			"dword ExtraInfoLength")
	DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))
	Local $tBuffers[6]
	Local $iURLLen = StringLen($sURL)
	For $i = 0 To 5
		$tBuffers[$i] = DllStructCreate("wchar[" & $iURLLen + 1 & "]")
	Next
	DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0]))
	DllStructSetData($tURL_COMPONENTS, "HostNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1]))
	DllStructSetData($tURL_COMPONENTS, "UserNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2]))
	DllStructSetData($tURL_COMPONENTS, "PasswordLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3]))
	DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4]))
	DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5]))
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCrackUrl", _
			"wstr", $sURL, _
			"dword", $iURLLen, _
			"dword", $iFlag, _
			"struct*", $tURL_COMPONENTS)
	Local $aRet[8] = [DllStructGetData($tBuffers[0], 1), _
			DllStructGetData($tURL_COMPONENTS, "Scheme"), _
			DllStructGetData($tBuffers[1], 1), _
			DllStructGetData($tURL_COMPONENTS, "Port"), _
			DllStructGetData($tBuffers[2], 1), _
			DllStructGetData($tBuffers[3], 1), _
			DllStructGetData($tBuffers[4], 1), _
			DllStructGetData($tBuffers[5], 1)]
	Return $aRet
Func _WinHttpCreateUrl($aURLArray)
	If UBound($aURLArray) - 8 Then Return SetError(1, 0, "")
			"dword ExtraInfoLength;")
	Local $tBuffers[6][2]
	$tBuffers[0][1] = StringLen($aURLArray[0])
	If $tBuffers[0][1] Then
		$tBuffers[0][0] = DllStructCreate("wchar[" & $tBuffers[0][1] + 1 & "]")
		DllStructSetData($tBuffers[0][0], 1, $aURLArray[0])
	$tBuffers[1][1] = StringLen($aURLArray[2])
	If $tBuffers[1][1] Then
		$tBuffers[1][0] = DllStructCreate("wchar[" & $tBuffers[1][1] + 1 & "]")
		DllStructSetData($tBuffers[1][0], 1, $aURLArray[2])
	$tBuffers[2][1] = StringLen($aURLArray[4])
	If $tBuffers[2][1] Then
		$tBuffers[2][0] = DllStructCreate("wchar[" & $tBuffers[2][1] + 1 & "]")
		DllStructSetData($tBuffers[2][0], 1, $aURLArray[4])
	$tBuffers[3][1] = StringLen($aURLArray[5])
	If $tBuffers[3][1] Then
		$tBuffers[3][0] = DllStructCreate("wchar[" & $tBuffers[3][1] + 1 & "]")
		DllStructSetData($tBuffers[3][0], 1, $aURLArray[5])
	$tBuffers[4][1] = StringLen($aURLArray[6])
	If $tBuffers[4][1] Then
		$tBuffers[4][0] = DllStructCreate("wchar[" & $tBuffers[4][1] + 1 & "]")
		DllStructSetData($tBuffers[4][0], 1, $aURLArray[6])
	$tBuffers[5][1] = StringLen($aURLArray[7])
	If $tBuffers[5][1] Then
		$tBuffers[5][0] = DllStructCreate("wchar[" & $tBuffers[5][1] + 1 & "]")
		DllStructSetData($tBuffers[5][0], 1, $aURLArray[7])
	DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $tBuffers[0][1])
	DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0][0]))
	DllStructSetData($tURL_COMPONENTS, "HostNameLength", $tBuffers[1][1])
	DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1][0]))
	DllStructSetData($tURL_COMPONENTS, "UserNameLength", $tBuffers[2][1])
	DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2][0]))
	DllStructSetData($tURL_COMPONENTS, "PasswordLength", $tBuffers[3][1])
	DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3][0]))
	DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $tBuffers[4][1])
	DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4][0]))
	DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $tBuffers[5][1])
	DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5][0]))
	DllStructSetData($tURL_COMPONENTS, "Scheme", $aURLArray[1])
	DllStructSetData($tURL_COMPONENTS, "Port", $aURLArray[3])
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCreateUrl", _
			"struct*", $tURL_COMPONENTS, _
			"dword", $ICU_ESCAPE, _
			"ptr", 0, _
			"dword*", 0)
	If @error Then Return SetError(2, 0, "")
	Local $iURLLen = $aCall[4]
	Local $URLBuffer = DllStructCreate("wchar[" & ($iURLLen + 1) & "]")
	$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpCreateUrl", _
			"struct*", $URLBuffer, _
			"dword*", $iURLLen)
	If @error Or Not $aCall[0] Then Return SetError(3, 0, "")
	Return DllStructGetData($URLBuffer, 1)
Func _WinHttpDetectAutoProxyConfigUrl($iAutoDetectFlags)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpDetectAutoProxyConfigUrl", "dword", $iAutoDetectFlags, "ptr*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Local $pStr = $aCall[2]
	If $pStr Then
		Local $iLen = __WinHttpPtrStringLenW($pStr)
		If @error Then Return SetError(2, 0, "")
		Local $tString = DllStructCreate("wchar[" & $iLen + 1 & "]", $pStr)
		Local $sString = DllStructGetData($tString, 1)
		__WinHttpMemGlobalFree($pStr)
		Return $sString
	Return ""
Func _WinHttpGetDefaultProxyConfiguration()
	Local $tWINHTTP_PROXY_INFO = DllStructCreate("dword AccessType;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpGetDefaultProxyConfiguration", "struct*", $tWINHTTP_PROXY_INFO)
	Local $iAccessType = DllStructGetData($tWINHTTP_PROXY_INFO, "AccessType")
	Local $pProxy = DllStructGetData($tWINHTTP_PROXY_INFO, "Proxy")
	Local $pProxyBypass = DllStructGetData($tWINHTTP_PROXY_INFO, "ProxyBypass")
	Local $sProxy
	If $pProxy Then
		Local $iProxyLen = __WinHttpPtrStringLenW($pProxy)
		If Not @error Then
			Local $tProxy = DllStructCreate("wchar[" & $iProxyLen + 1 & "]", $pProxy)
			$sProxy = DllStructGetData($tProxy, 1)
			__WinHttpMemGlobalFree($pProxy)
		EndIf
	Local $sProxyBypass
	If $pProxyBypass Then
		Local $iProxyBypassLen = __WinHttpPtrStringLenW($pProxyBypass)
			Local $tProxyBypass = DllStructCreate("wchar[" & $iProxyBypassLen + 1 & "]", $pProxyBypass)
			$sProxyBypass = DllStructGetData($tProxyBypass, 1)
			__WinHttpMemGlobalFree($pProxyBypass)
	Local $aRet[3] = [$iAccessType, $sProxy, $sProxyBypass]
Func _WinHttpGetIEProxyConfigForCurrentUser()
	Local $tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG = DllStructCreate("int AutoDetect;" & _
			"ptr AutoConfigUrl;" & _
			"ptr ProxyBypass;")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpGetIEProxyConfigForCurrentUser", "struct*", $tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG)
	Local $iAutoDetect = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "AutoDetect")
	Local $pAutoConfigUrl = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "AutoConfigUrl")
	Local $pProxy = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "Proxy")
	Local $pProxyBypass = DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "ProxyBypass")
	Local $sAutoConfigUrl
	If $pAutoConfigUrl Then
		Local $iAutoConfigUrlLen = __WinHttpPtrStringLenW($pAutoConfigUrl)
			Local $tAutoConfigUrl = DllStructCreate("wchar[" & $iAutoConfigUrlLen + 1 & "]", $pAutoConfigUrl)
			$sAutoConfigUrl = DllStructGetData($tAutoConfigUrl, 1)
			__WinHttpMemGlobalFree($pAutoConfigUrl)
	Local $aOutput[4] = [$iAutoDetect, $sAutoConfigUrl, $sProxy, $sProxyBypass]
	Return $aOutput
Func _WinHttpOpen($sUserAgent = Default, $iAccessType = Default, $sProxyName = Default, $sProxyBypass = Default, $iFlag = Default)
	__WinHttpDefault($sUserAgent, __WinHttpUA())
	__WinHttpDefault($iAccessType, $WINHTTP_ACCESS_TYPE_NO_PROXY)
	__WinHttpDefault($sProxyName, $WINHTTP_NO_PROXY_NAME)
	__WinHttpDefault($sProxyBypass, $WINHTTP_NO_PROXY_BYPASS)
	__WinHttpDefault($iFlag, 0)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpen", _
			"wstr", $sUserAgent, _
			"dword", $iAccessType, _
			"wstr", $sProxyName, _
			"wstr", $sProxyBypass, _
			"dword", $iFlag)
	If $iFlag = $WINHTTP_FLAG_ASYNC Then _WinHttpSetOption($aCall[0], $WINHTTP_OPTION_CONTEXT_VALUE, $WINHTTP_FLAG_ASYNC)
Func _WinHttpOpenRequest($hConnect, $sVerb = Default, $sObjectName = Default, $sVersion = Default, $sReferrer = Default, $sAcceptTypes = Default, $iFlags = Default)
	__WinHttpDefault($sVerb, "GET")
	__WinHttpDefault($sObjectName, "")
	__WinHttpDefault($sVersion, "HTTP/1.1")
	__WinHttpDefault($sReferrer, $WINHTTP_NO_REFERER)
	__WinHttpDefault($iFlags, $WINHTTP_FLAG_ESCAPE_DISABLE)
	Local $pAcceptTypes
	If $sAcceptTypes = Default Or Number($sAcceptTypes) = -1 Then
		$pAcceptTypes = $WINHTTP_DEFAULT_ACCEPT_TYPES
		Local $aTypes = StringSplit($sAcceptTypes, ",", 2)
		Local $tAcceptTypes = DllStructCreate("ptr[" & UBound($aTypes) + 1 & "]")
		Local $tType[UBound($aTypes)]
		For $i = 0 To UBound($aTypes) - 1
			$tType[$i] = DllStructCreate("wchar[" & StringLen($aTypes[$i]) + 1 & "]")
			DllStructSetData($tType[$i], 1, $aTypes[$i])
			DllStructSetData($tAcceptTypes, 1, DllStructGetPtr($tType[$i]), $i + 1)
		Next
		$pAcceptTypes = DllStructGetPtr($tAcceptTypes)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "handle", "WinHttpOpenRequest", _
			"handle", $hConnect, _
			"wstr", StringUpper($sVerb), _
			"wstr", $sObjectName, _
			"wstr", StringUpper($sVersion), _
			"wstr", $sReferrer, _
			"ptr", $pAcceptTypes, _
			"dword", $iFlags)
Func _WinHttpQueryAuthSchemes($hRequest, ByRef $iSupportedSchemes, ByRef $iFirstScheme, ByRef $iAuthTarget)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryAuthSchemes", _
			"dword*", 0, _
	$iSupportedSchemes = $aCall[2]
	$iFirstScheme = $aCall[3]
	$iAuthTarget = $aCall[4]
Func _WinHttpQueryDataAvailable($hRequest)
	Local $sReadType = "dword*"
	If BitAND(_WinHttpQueryOption(_WinHttpQueryOption(_WinHttpQueryOption($hRequest, $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_PARENT_HANDLE), $WINHTTP_OPTION_CONTEXT_VALUE), $WINHTTP_FLAG_ASYNC) Then $sReadType = "ptr"
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryDataAvailable", "handle", $hRequest, $sReadType, 0)
	Return SetExtended($aCall[2], $aCall[0])
Func _WinHttpQueryHeaders($hRequest, $iInfoLevel = Default, $sName = Default, $iIndex = Default)
	__WinHttpDefault($iInfoLevel, $WINHTTP_QUERY_RAW_HEADERS_CRLF)
	__WinHttpDefault($sName, $WINHTTP_HEADER_NAME_BY_INDEX)
	__WinHttpDefault($iIndex, $WINHTTP_NO_HEADER_INDEX)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryHeaders", _
			"dword", $iInfoLevel, _
			"wstr", $sName, _
			"wstr", "", _
			"dword*", 65536, _
			"dword*", $iIndex)
	Return SetExtended($aCall[6], $aCall[4])
Func _WinHttpQueryOption($hInternet, $iOption)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"handle", $hInternet, _
			"dword", $iOption, _
	If @error Or $aCall[0] Then Return SetError(1, 0, "")
	Local $iSize = $aCall[4]
	Local $tBuffer
	Switch $iOption
		Case $WINHTTP_OPTION_CONNECTION_INFO, $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_URL, $WINHTTP_OPTION_USERNAME, $WINHTTP_OPTION_USER_AGENT, _
				$WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT, $WINHTTP_OPTION_PASSPORT_COBRANDING_URL
			$tBuffer = DllStructCreate("wchar[" & $iSize + 1 & "]")
		Case $WINHTTP_OPTION_PARENT_HANDLE, $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_SERVER_CERT_CONTEXT
			$tBuffer = DllStructCreate("ptr")
		Case $WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM, _
				$WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, $WINHTTP_OPTION_EXTENDED_ERROR, $WINHTTP_OPTION_HANDLE_TYPE, $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, _
				$WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURITY_FLAGS, $WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT
			$tBuffer = DllStructCreate("int")
		Case $WINHTTP_OPTION_CONTEXT_VALUE
			$tBuffer = DllStructCreate("dword_ptr")
		Case Else
			$tBuffer = DllStructCreate("byte[" & $iSize & "]")
	EndSwitch
	$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpQueryOption", _
			"struct*", $tBuffer, _
			"dword*", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($tBuffer, 1)
Func _WinHttpReadData($hRequest, $iMode = Default, $iNumberOfBytesToRead = Default, $pBuffer = Default)
	__WinHttpDefault($iMode, 0)
	__WinHttpDefault($iNumberOfBytesToRead, 8192)
	Local $tBuffer, $vOutOnError = ""
	If $iMode = 2 Then $vOutOnError = Binary($vOutOnError)
	Switch $iMode
		Case 1, 2
			If $pBuffer And $pBuffer <> Default Then
				$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]", $pBuffer)
			Else
				$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]")
			EndIf
			$iMode = 0
				$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]", $pBuffer)
				$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReadData", _
			"dword", $iNumberOfBytesToRead, _
			$sReadType, 0)
	If Not $aCall[4] Then Return SetError(-1, 0, $vOutOnError)
	If $aCall[4] < $iNumberOfBytesToRead Then
		Switch $iMode
			Case 0
				Return SetExtended($aCall[4], StringLeft(DllStructGetData($tBuffer, 1), $aCall[4]))
			Case 1
				Return SetExtended($aCall[4], BinaryToString(BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]), 4))
			Case 2
				Return SetExtended($aCall[4], BinaryMid(DllStructGetData($tBuffer, 1), 1, $aCall[4]))
		EndSwitch
			Case 0, 2
				Return SetExtended($aCall[4], DllStructGetData($tBuffer, 1))
				Return SetExtended($aCall[4], BinaryToString(DllStructGetData($tBuffer, 1), 4))
Func _WinHttpReceiveResponse($hRequest)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpReceiveResponse", "handle", $hRequest, "ptr", 0)
Func _WinHttpSendRequest($hRequest, $sHeaders = Default, $vOptional = Default, $iTotalLength = Default, $iContext = Default)
	__WinHttpDefault($sHeaders, $WINHTTP_NO_ADDITIONAL_HEADERS)
	__WinHttpDefault($vOptional, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($iTotalLength, 0)
	__WinHttpDefault($iContext, 0)
	Local $pOptional = 0, $iOptionalLength = 0
	If @NumParams > 2 Then
		Local $tOptional
		$iOptionalLength = BinaryLen($vOptional)
		$tOptional = DllStructCreate("byte[" & $iOptionalLength & "]")
		If $iOptionalLength Then $pOptional = DllStructGetPtr($tOptional)
		DllStructSetData($tOptional, 1, $vOptional)
	If Not $iTotalLength Or $iTotalLength < $iOptionalLength Then $iTotalLength += $iOptionalLength
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSendRequest", _
			"wstr", $sHeaders, _
			"dword", 0, _
			"ptr", $pOptional, _
			"dword", $iOptionalLength, _
			"dword", $iTotalLength, _
			"dword_ptr", $iContext)
Func _WinHttpSetCredentials($hRequest, $iAuthTargets, $iAuthScheme, $sUserName, $sPassword)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetCredentials", _
			"dword", $iAuthTargets, _
			"dword", $iAuthScheme, _
			"wstr", $sUserName, _
			"wstr", $sPassword, _
			"ptr", 0)
Func _WinHttpSetDefaultProxyConfiguration($iAccessType, $sProxy = "", $sProxyBypass = "")
	Local $tProxy = DllStructCreate("wchar[" & StringLen($sProxy) + 1 & "]")
	DllStructSetData($tProxy, 1, $sProxy)
	Local $tProxyBypass = DllStructCreate("wchar[" & StringLen($sProxyBypass) + 1 & "]")
	DllStructSetData($tProxyBypass, 1, $sProxyBypass)
	DllStructSetData($tWINHTTP_PROXY_INFO, "AccessType", $iAccessType)
	If $iAccessType <> $WINHTTP_ACCESS_TYPE_NO_PROXY Then
		DllStructSetData($tWINHTTP_PROXY_INFO, "Proxy", DllStructGetPtr($tProxy))
		DllStructSetData($tWINHTTP_PROXY_INFO, "ProxyBypass", DllStructGetPtr($tProxyBypass))
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetDefaultProxyConfiguration", "struct*", $tWINHTTP_PROXY_INFO)
Func _WinHttpSetOption($hInternet, $iOption, $vSetting, $iSize = Default)
	If $iSize = Default Then $iSize = -1
	If IsBinary($vSetting) Then
		$iSize = DllStructCreate("byte[" & BinaryLen($vSetting) & "]")
		DllStructSetData($iSize, 1, $vSetting)
		$vSetting = $iSize
		$iSize = DllStructGetSize($vSetting)
	Local $sType
		Case $WINHTTP_OPTION_AUTOLOGON_POLICY, $WINHTTP_OPTION_CODEPAGE, $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, _
				$WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_OPTION_DISABLE_FEATURE, $WINHTTP_OPTION_ENABLE_FEATURE, $WINHTTP_OPTION_ENABLETRACING, _
				$WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, $WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, _
				$WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE, $WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE, $WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE, _
				$WINHTTP_OPTION_READ_BUFFER_SIZE, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_REDIRECT_POLICY, $WINHTTP_OPTION_REJECT_USERPWD_IN_URL, _
				$WINHTTP_OPTION_REQUEST_PRIORITY, $WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURE_PROTOCOLS, $WINHTTP_OPTION_SECURITY_FLAGS, _
				$WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT, $WINHTTP_OPTION_SPN, $WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS, _
				$WINHTTP_OPTION_WORKER_THREAD_COUNT, $WINHTTP_OPTION_WRITE_BUFFER_SIZE, $WINHTTP_OPTION_DECOMPRESSION, $WINHTTP_OPTION_UNSAFE_HEADER_PARSING
			$sType = "dword*"
			$iSize = 4
		Case $WINHTTP_OPTION_CALLBACK, $WINHTTP_OPTION_PASSPORT_SIGN_OUT
			$sType = "ptr*"
			If @AutoItX64 Then $iSize = 8
			If Not IsPtr($vSetting) Then Return SetError(3, 0, 0)
			$sType = "dword_ptr*"
		Case $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_USER_AGENT, $WINHTTP_OPTION_USERNAME
			$sType = "wstr"
			If (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
			If $iSize < 1 Then $iSize = StringLen($vSetting)
		Case $WINHTTP_OPTION_CLIENT_CERT_CONTEXT, $WINHTTP_OPTION_GLOBAL_PROXY_CREDS, $WINHTTP_OPTION_GLOBAL_SERVER_CREDS, $WINHTTP_OPTION_HTTP_VERSION, _
				$WINHTTP_OPTION_PROXY
			$sType = "ptr"
			If Not (IsDllStruct($vSetting) Or IsPtr($vSetting)) Then Return SetError(3, 0, 0)
			Return SetError(1, 0, 0)
	If $iSize < 1 Then
		If IsDllStruct($vSetting) Then
			$iSize = DllStructGetSize($vSetting)
		Else
			Return SetError(2, 0, 0)
	Local $aCall
	If IsDllStruct($vSetting) Then
		$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, DllStructGetPtr($vSetting), "dword", $iSize)
		$aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetOption", "handle", $hInternet, "dword", $iOption, $sType, $vSetting, "dword", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(4, 0, 0)
Func _WinHttpSetStatusCallback($hInternet, $hInternetCallback, $iNotificationFlags = Default)
	__WinHttpDefault($iNotificationFlags, $WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "ptr", "WinHttpSetStatusCallback", _
			"ptr", DllCallbackGetPtr($hInternetCallback), _
			"dword", $iNotificationFlags, _
Func _WinHttpSetTimeouts($hInternet, $iResolveTimeout = Default, $iConnectTimeout = Default, $iSendTimeout = Default, $iReceiveTimeout = Default)
	__WinHttpDefault($iResolveTimeout, 0)
	__WinHttpDefault($iConnectTimeout, 60000)
	__WinHttpDefault($iSendTimeout, 30000)
	__WinHttpDefault($iReceiveTimeout, 30000)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpSetTimeouts", _
			"int", $iResolveTimeout, _
			"int", $iConnectTimeout, _
			"int", $iSendTimeout, _
			"int", $iReceiveTimeout)
Func _WinHttpSimpleBinaryConcat(ByRef $bBinary1, ByRef $bBinary2)
	Switch IsBinary($bBinary1) + 2 * IsBinary($bBinary2)
		Case 0
			Return SetError(1, 0, Binary(''))
		Case 1
			Return $bBinary1
		Case 2
			Return $bBinary2
	Local $tAuxiliary = DllStructCreate("byte[" & BinaryLen($bBinary1) & "];byte[" & BinaryLen($bBinary2) & "]")
	DllStructSetData($tAuxiliary, 1, $bBinary1)
	DllStructSetData($tAuxiliary, 2, $bBinary2)
	Local $tOutput = DllStructCreate("byte[" & DllStructGetSize($tAuxiliary) & "]", DllStructGetPtr($tAuxiliary))
	Return DllStructGetData($tOutput, 1)
Func _WinHttpSimpleFormFill(ByRef $hInternet, $sActionPage = Default, $sFormId = Default, $sFldId1 = Default, $sDta1 = Default, $sFldId2 = Default, $sDta2 = Default, $sFldId3 = Default, $sDta3 = Default, $sFldId4 = Default, $sDta4 = Default, $sFldId5 = Default, $sDta5 = Default, $sFldId6 = Default, $sDta6 = Default, $sFldId7 = Default, $sDta7 = Default, $sFldId8 = Default, $sDta8 = Default, $sFldId9 = Default, $sDta9 = Default, $sFldId10 = Default, $sDta10 = Default, _
		$sFldId11 = Default, $sDta11 = Default, $sFldId12 = Default, $sDta12 = Default, $sFldId13 = Default, $sDta13 = Default, $sFldId14 = Default, $sDta14 = Default, $sFldId15 = Default, $sDta15 = Default, $sFldId16 = Default, $sDta16 = Default, $sFldId17 = Default, $sDta17 = Default, $sFldId18 = Default, $sDta18 = Default, $sFldId19 = Default, $sDta19 = Default, $sFldId20 = Default, $sDta20 = Default, _
		$sFldId21 = Default, $sDta21 = Default, $sFldId22 = Default, $sDta22 = Default, $sFldId23 = Default, $sDta23 = Default, $sFldId24 = Default, $sDta24 = Default, $sFldId25 = Default, $sDta25 = Default, $sFldId26 = Default, $sDta26 = Default, $sFldId27 = Default, $sDta27 = Default, $sFldId28 = Default, $sDta28 = Default, $sFldId29 = Default, $sDta29 = Default, $sFldId30 = Default, $sDta30 = Default, _
		$sFldId31 = Default, $sDta31 = Default, $sFldId32 = Default, $sDta32 = Default, $sFldId33 = Default, $sDta33 = Default, $sFldId34 = Default, $sDta34 = Default, $sFldId35 = Default, $sDta35 = Default, $sFldId36 = Default, $sDta36 = Default, $sFldId37 = Default, $sDta37 = Default, $sFldId38 = Default, $sDta38 = Default, $sFldId39 = Default, $sDta39 = Default, $sFldId40 = Default, $sDta40 = Default)
	__WinHttpDefault($sActionPage, "")
	Local $iNumArgs = @NumParams, $sAdditionalHeaders, $sCredName, $sCredPass, $iIgnoreCertErr, $iRetArr
	Local $aDtas[41] = [0, $sDta1, $sDta2, $sDta3, $sDta4, $sDta5, $sDta6, $sDta7, $sDta8, $sDta9, $sDta10, $sDta11, $sDta12, $sDta13, $sDta14, $sDta15, $sDta16, $sDta17, $sDta18, $sDta19, $sDta20, $sDta21, $sDta22, $sDta23, $sDta24, $sDta25, $sDta26, $sDta27, $sDta28, $sDta29, $sDta30, $sDta31, $sDta32, $sDta33, $sDta34, $sDta35, $sDta36, $sDta37, $sDta38, $sDta39, $sDta40]
	Local $aFlds[41] = [0, $sFldId1, $sFldId2, $sFldId3, $sFldId4, $sFldId5, $sFldId6, $sFldId7, $sFldId8, $sFldId9, $sFldId10, $sFldId11, $sFldId12, $sFldId13, $sFldId14, $sFldId15, $sFldId16, $sFldId17, $sFldId18, $sFldId19, $sFldId20, $sFldId21, $sFldId22, $sFldId23, $sFldId24, $sFldId25, $sFldId26, $sFldId27, $sFldId28, $sFldId29, $sFldId30, $sFldId31, $sFldId32, $sFldId33, $sFldId34, $sFldId35, $sFldId36, $sFldId37, $sFldId38, $sFldId39, $sFldId40]
	If Not Mod($iNumArgs, 2) Then
		$sAdditionalHeaders = $aFlds[$iNumArgs / 2 - 1]
		$aFlds[$iNumArgs / 2 - 1] = 0
		$iIgnoreCertErr = StringInStr($sAdditionalHeaders, "[IGNORE_CERT_ERRORS]")
		If $iIgnoreCertErr Then $sAdditionalHeaders = StringReplace($sAdditionalHeaders, "[IGNORE_CERT_ERRORS]", "", 1)
		$iRetArr = StringInStr($sAdditionalHeaders, "[RETURN_ARRAY]")
		If $iRetArr Then $sAdditionalHeaders = StringReplace($sAdditionalHeaders, "[RETURN_ARRAY]", "", 1)
		Local $aCred = StringRegExp($sAdditionalHeaders, "\[CRED:(.*?)\]", 2)
			Local $sCredDelim = ":"
			If Not StringInStr($aCred[1], $sCredDelim) Then $sCredDelim = ","
			Local $aStrSplit = StringSplit($aCred[1], $sCredDelim, 3)
			If Not @error Then
				$sCredName = $aStrSplit[0]
				$sCredPass = $aStrSplit[1]
			$sAdditionalHeaders = StringReplace($sAdditionalHeaders, $aCred[0], "", 1)
	Local $hOpen, $aHTML, $sHTML, $sURL, $fVarForm, $iScheme = $INTERNET_SCHEME_HTTP
	If IsString($hInternet) Then ; $hInternet is page source
		$sHTML = $hInternet
		If _WinHttpQueryOption($sActionPage, $WINHTTP_OPTION_HANDLE_TYPE) <> $WINHTTP_HANDLE_TYPE_SESSION Then Return SetError(6, 0, "")
		$hOpen = $sActionPage
		$fVarForm = True
		$iScheme = _WinHttpQueryOption($hInternet, $WINHTTP_OPTION_CONTEXT_VALUE); read internet scheme from the connection handle
		Local $sAccpt = "Accept: text/html;q=0.9,text/plain;q=0.8,*/*;q=0.5"
		If $iScheme = $INTERNET_SCHEME_HTTPS Then
			$aHTML = _WinHttpSimpleSSLRequest($hInternet, Default, $sActionPage, Default, Default, $sAccpt, 1, Default, $sCredName, $sCredPass, $iIgnoreCertErr)
		ElseIf $iScheme = $INTERNET_SCHEME_HTTP Then
			$aHTML = _WinHttpSimpleRequest($hInternet, Default, $sActionPage, Default, Default, $sAccpt, 1, Default, $sCredName, $sCredPass)
			If @error Or @extended >= $HTTP_STATUS_BAD_REQUEST Then
				$aHTML = _WinHttpSimpleSSLRequest($hInternet, Default, $sActionPage, Default, Default, $sAccpt, 1, Default, $sCredName, $sCredPass, $iIgnoreCertErr)
				$iScheme = $INTERNET_SCHEME_HTTPS
				$iScheme = $INTERNET_SCHEME_HTTP
		If Not @error Then ; Error is checked after If...Then...Else block. Be careful before changing anything!
			$sHTML = $aHTML[1]
			$sURL = $aHTML[2]
	$sHTML = StringRegExpReplace($sHTML, "(?s)<!--.*?-->", "") ; removing comments
	$sHTML = StringRegExpReplace($sHTML, "(?s)<!\[CDATA\[.*?\]\]>", "") ; removing CDATA
	Local $fSend = False ; preset 'Sending flag'
	Local $aForm = StringRegExp($sHTML, "(?si)<\s*form(?:[^\w])\s*(.*?)(?:(?:<\s*/form\s*>)|\Z)", 3)
	If @error Then Return SetError(1, 0, "") ; There are no forms available
	Local $fGetFormByName, $sFormName, $fGetFormByIndex, $fGetFormById, $iFormIndex
	Local $aSplitForm = StringSplit($sFormId, ":", 2)
	If @error Then ; like .getElementById(FormId)
		$fGetFormById = True
		If $aSplitForm[0] = "name" Then ; like .getElementsByName(FormName)
			$sFormName = $aSplitForm[1]
			$fGetFormByName = True
		ElseIf $aSplitForm[0] = "index" Then
			$iFormIndex = Number($aSplitForm[1])
			$fGetFormByIndex = True
		ElseIf $aSplitForm[0] = "id" Then ; like .getElementById(FormId)
			$sFormId = $aSplitForm[1]
			$fGetFormById = True
		Else ; like .getElementById(FormId)
			$sFormId = $aSplitForm[0]
	Local $sForm, $sAttributes, $aInput
	Local $iNumParams = Ceiling(($iNumArgs - 2) / 2) - 1
	Local $sAddData, $sNewURL
	For $iFormOrdinal = 0 To UBound($aForm) - 1
		If $fGetFormByIndex And $iFormOrdinal <> $iFormIndex Then ContinueLoop
		$sForm = $aForm[$iFormOrdinal]
		$sAttributes = StringRegExp($sForm, "(?s)(.*?)>", 3)
		If Not @error Then $sAttributes = StringRegExpReplace($sAttributes[0], "\v", " ")
		Local $sAction = "", $sAccept = "", $sEnctype = "", $sMethod = "", $sName = "", $sId = ""
		$sId = __WinHttpAttribVal($sAttributes, "id")
		If $fGetFormById And $sFormId <> Default And $sId <> $sFormId Then ContinueLoop
		$sName = __WinHttpAttribVal($sAttributes, "name")
		If $fGetFormByName And $sFormName <> $sName Then ContinueLoop
		$sAction = __WinHttpHTMLDecode(__WinHttpAttribVal($sAttributes, "action"))
		$sAccept = __WinHttpAttribVal($sAttributes, "accept")
		$sEnctype = __WinHttpAttribVal($sAttributes, "enctype")
		$sMethod = __WinHttpAttribVal($sAttributes, "method")
		$fSend = True
		Local $sSpr1 = Chr(27), $sSpr2 = Chr(26)
		__WinHttpNormalizeForm($sForm, $sSpr1, $sSpr2)
		$aInput = StringRegExp($sForm, "(?si)<\h*(?:input|textarea|label|fieldset|legend|select|optgroup|option|button)\h*(.*?)/*\h*>", 3)
		If @error Then Return SetError(2, 0, "") ; invalid form
		__WinHttpHTML5FormAttribs($aDtas, $aFlds, $iNumParams, $aInput, $sAction, $sEnctype, $sMethod)
		__WinHttpNormalizeActionURL($sActionPage, $sAction, $iScheme, $sNewURL, $sEnctype, $sMethod, $sURL)
		If $fVarForm And Not $sNewURL Then Return SetError(5, 0, "") ; "action" must have URL specified
		Local $aSplit, $sBoundary, $sPassedId, $sPassedData, $iNumRepl, $fMultiPart = False, $sSubmit, $sRadio, $sCheckBox, $sButton
		Local $sGrSep = Chr(29), $iErr
		Local $aInputIds[4][UBound($aInput)]
		Switch $sEnctype
			Case "", "application/x-www-form-urlencoded", "text/plain"
				For $i = 0 To UBound($aInput) - 1 ; for all input elements
					__WinHttpFormAttrib($aInputIds, $i, $aInput[$i])
					If $aInputIds[1][$i] Then ; if there is 'name' field then add it
						$aInputIds[1][$i] = __WinHttpURLEncode(StringReplace($aInputIds[1][$i], $sSpr1, " "), $sEnctype)
						$aInputIds[2][$i] = __WinHttpURLEncode(StringReplace(StringReplace($aInputIds[2][$i], $sSpr2, ">"), $sSpr1, " "), $sEnctype)
						$sAddData &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & "&"
						If $aInputIds[3][$i] = "submit" Then $sSubmit &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & $sGrSep ; add to overall "submit" string
						If $aInputIds[3][$i] = "radio" Then $sRadio &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & $sGrSep ; add to overall "radio" string
						If $aInputIds[3][$i] = "checkbox" Then $sCheckBox &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & $sGrSep ; add to overall "checkbox" string
						If $aInputIds[3][$i] = "button" Then $sButton &= $aInputIds[1][$i] & "=" & $aInputIds[2][$i] & $sGrSep ; add to overall "button" string
					EndIf
				Next
				$sSubmit = StringTrimRight($sSubmit, 1)
				$sRadio = StringTrimRight($sRadio, 1)
				$sCheckBox = StringTrimRight($sCheckBox, 1)
				$sButton = StringTrimRight($sButton, 1)
				$sAddData = StringTrimRight($sAddData, 1)
				For $k = 1 To $iNumParams
					$sPassedData = __WinHttpURLEncode($aDtas[$k], $sEnctype)
					$aDtas[$k] = 0
					$sPassedId = $aFlds[$k]
					$aFlds[$k] = 0
					$aSplit = StringSplit($sPassedId, ":", 2)
					$iErr = @error
					$aSplit[0] = __WinHttpURLEncode($aSplit[0], $sEnctype)
					If Not $iErr Then $aSplit[1] = __WinHttpURLEncode($aSplit[1], $sEnctype)
					If $iErr Or $aSplit[0] <> "name" Then ; like .getElementById
						If Not $iErr And $aSplit[0] = "id" Then $sPassedId = $aSplit[1]
						For $j = 0 To UBound($aInputIds, 2) - 1
							If $aInputIds[0][$j] = $sPassedId Then
								If $aInputIds[3][$j] = "submit" Then
									If $sPassedData = True Then ; if this "submit" is set to TRUE then
										If $sSubmit Then ; If not already processed; only the first is valid
											Local $fDelId = False
											For $sChunkSub In StringSplit($sSubmit, $sGrSep, 3) ; go tru all "submit" controls
												If $sChunkSub == $aInputIds[1][$j] & "=" & $aInputIds[2][$j] Then
													If $fDelId Then $sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $sChunkSub & "\E(?:&|\Z)", "&", 1)
													$fDelId = True
												Else
													$sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $sChunkSub & "\E(?:&|\Z)", "&") ; delete all but the TRUE one
												EndIf
												__WinHttpTrimBounds($sAddData, "&")
											Next
											$sSubmit = ""
										EndIf
									EndIf
								ElseIf $aInputIds[3][$j] = "radio" Then
									If $sPassedData = $aInputIds[2][$j] Then
										For $sChunkSub In StringSplit($sRadio, $sGrSep, 3) ; go tru all "radio" controls
											If $sChunkSub == $aInputIds[1][$j] & "=" & $sPassedData Then
												$sAddData = StringRegExpReplace(StringReplace($sAddData, "&", "&&"), "(?:&|\A)\Q" & $aInputIds[1][$j] & "\E(.*?)(?:&|\Z)", "&")
												$sAddData = StringReplace(StringReplace($sAddData, "&&", "&"), "&&", "&")
												If StringLeft($sAddData, 1) = "&" Then $sAddData = StringTrimLeft($sAddData, 1)
												$sAddData &= "&" & $sChunkSub
												$sRadio = StringRegExpReplace(StringReplace($sRadio, $sGrSep, $sGrSep & $sGrSep), "(?:" & $sGrSep & "|\A)\Q" & $aInputIds[1][$j] & "\E(.*?)(?:" & $sGrSep & "|\Z)", $sGrSep)
												$sRadio = StringReplace(StringReplace($sRadio, $sGrSep & $sGrSep, $sGrSep), $sGrSep & $sGrSep, $sGrSep)
											EndIf
										Next
								ElseIf $aInputIds[3][$j] = "checkbox" Then
									$sCheckBox = StringRegExpReplace($sCheckBox, "\Q" & $aInputIds[1][$j] & "=" & $sPassedData & "\E" & $sGrSep & "*", "")
									__WinHttpTrimBounds($sCheckBox, $sGrSep)
								ElseIf $aInputIds[3][$j] = "button" Then
									$sButton = StringRegExpReplace($sButton, "\Q" & $aInputIds[1][$j] & "=" & $sPassedData & "\E" & $sGrSep & "*", "")
									__WinHttpTrimBounds($sButton, $sGrSep)
								Else
									$sAddData = StringRegExpReplace(StringReplace($sAddData, "&", "&&"), "(?:&|\A)\Q" & $aInputIds[1][$j] & "=" & $aInputIds[2][$j] & "\E(?:&|\Z)", "&" & $aInputIds[1][$j] & "=" & $sPassedData & "&")
									$iNumRepl = @extended
									$sAddData = StringReplace($sAddData, "&&", "&")
									If $iNumRepl > 1 Then ; equalize ; TODO: remove duplicates
										$sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $aInputIds[1][$j] & "\E=.*?(?:&|\Z)", "&", $iNumRepl - 1)
									__WinHttpTrimBounds($sAddData, "&")
								EndIf
							EndIf
						Next
					Else ; like .getElementsByName
							If $aInputIds[3][$j] = "submit" Then
								If $sPassedData = True Then ; if this "submit" is set to TRUE then
									If $aInputIds[1][$j] == $aSplit[1] Then
											Local $fDel = False
												If $sChunkSub = $aInputIds[1][$j] & "=" & $aInputIds[2][$j] Then
													If $fDel Then $sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $sChunkSub & "\E(?:&|\Z)", "&", 1)
													$fDel = True
										ContinueLoop 2 ; process next parameter
								Else ; False means do nothing
									ContinueLoop 2 ; process next parameter
							ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "radio" Then
								For $sChunkSub In StringSplit($sRadio, $sGrSep, 3) ; go tru all "radio" controls
									If $sChunkSub == $aInputIds[1][$j] & "=" & $sPassedData Then
										$sAddData = StringReplace(StringReplace(StringRegExpReplace(StringReplace($sAddData, "&", "&&"), "(?:&|\A)\Q" & $aInputIds[1][$j] & "\E(.*?)(?:&|\Z)", "&"), "&&", "&"), "&&", "&")
										If StringLeft($sAddData, 1) = "&" Then $sAddData = StringTrimLeft($sAddData, 1)
										$sAddData &= "&" & $sChunkSub
										$sRadio = StringRegExpReplace(StringReplace($sRadio, $sGrSep, $sGrSep & $sGrSep), "(?:" & $sGrSep & "|\A)\Q" & $aInputIds[1][$j] & "\E(.*?)(?:" & $sGrSep & "|\Z)", $sGrSep)
										$sRadio = StringReplace(StringReplace($sRadio, $sGrSep & $sGrSep, $sGrSep), $sGrSep & $sGrSep, $sGrSep)
								Next
								ContinueLoop 2 ; process next parameter
							ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "checkbox" Then
								$sCheckBox = StringRegExpReplace($sCheckBox, "\Q" & $aInputIds[1][$j] & "=" & $sPassedData & "\E" & $sGrSep & "*", "")
								__WinHttpTrimBounds($sCheckBox, $sGrSep)
							ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "button" Then
								$sButton = StringRegExpReplace($sButton, "\Q" & $aInputIds[1][$j] & "=" & $sPassedData & "\E" & $sGrSep & "*", "")
								__WinHttpTrimBounds($sButton, $sGrSep)
						$sAddData = StringRegExpReplace(StringReplace($sAddData, "&", "&&"), "(?:&|\A)\Q" & $aSplit[1] & "\E=.*?(?:&|\Z)", "&" & $aSplit[1] & "=" & $sPassedData & "&")
						$iNumRepl = @extended
						$sAddData = StringReplace($sAddData, "&&", "&")
						If $iNumRepl > 1 Then ; remove duplicates
							$sAddData = StringRegExpReplace($sAddData, "(?:&|\A)\Q" & $aSplit[1] & "\E=.*?(?:&|\Z)", "&", $iNumRepl - 1)
						EndIf
						__WinHttpTrimBounds($sAddData, "&")
				__WinHttpFinalizeCtrls($sSubmit, $sRadio, $sCheckBox, $sButton, $sAddData, $sGrSep, "&")
				If $sMethod = "GET" Then
					$sAction &= "?" & $sAddData
					$sAddData = "" ; not to send as addition to the request (this is GET)
				EndIf
			Case "multipart/form-data"
				If $sMethod = "POST" Then ; can't be GET
					$fMultiPart = True
					$sBoundary = StringFormat("%s%.5f", "----WinHttpBoundaryLine_", Random(10000, 99999))
					Local $sCDisp = 'Content-Disposition: form-data; name="'
					For $i = 0 To UBound($aInput) - 1 ; for all input elements
						__WinHttpFormAttrib($aInputIds, $i, $aInput[$i])
						If $aInputIds[1][$i] Then ; if there is 'name' field
							$aInputIds[1][$i] = StringReplace($aInputIds[1][$i], $sSpr1, " ")
							$aInputIds[2][$i] = StringReplace(StringReplace($aInputIds[2][$i], $sSpr2, ">"), $sSpr1, " ")
							If $aInputIds[3][$i] = "file" Then
								$sAddData &= "--" & $sBoundary & @CRLF & _
										$sCDisp & $aInputIds[1][$i] & '"; filename=""' & @CRLF & @CRLF & _
										$aInputIds[2][$i] & @CRLF
							Else
										$sCDisp & $aInputIds[1][$i] & '"' & @CRLF & @CRLF & _
							If $aInputIds[3][$i] = "submit" Then $sSubmit &= "--" & $sBoundary & @CRLF & _
									$sCDisp & $aInputIds[1][$i] & '"' & @CRLF & @CRLF & _
									$aInputIds[2][$i] & @CRLF & $sGrSep
							If $aInputIds[3][$i] = "radio" Then $sRadio &= "--" & $sBoundary & @CRLF & _
							If $aInputIds[3][$i] = "checkbox" Then $sCheckBox &= "--" & $sBoundary & @CRLF & _
							If $aInputIds[3][$i] = "button" Then $sButton &= "--" & $sBoundary & @CRLF & _
					Next
					$sSubmit = StringTrimRight($sSubmit, 1)
					$sRadio = StringTrimRight($sRadio, 1)
					$sCheckBox = StringTrimRight($sCheckBox, 1)
					$sButton = StringTrimRight($sButton, 1)
					$sAddData &= "--" & $sBoundary & "--" & @CRLF
					For $k = 1 To $iNumParams
						$sPassedData = $aDtas[$k]
						$aDtas[$k] = 0
						$sPassedId = $aFlds[$k]
						$aFlds[$k] = 0
						$aSplit = StringSplit($sPassedId, ":", 2)
						If @error Or $aSplit[0] <> "name" Then ; like getElementById
							If Not @error And $aSplit[0] = "id" Then $sPassedId = $aSplit[1]
							For $j = 0 To UBound($aInputIds, 2) - 1
								If $aInputIds[0][$j] = $sPassedId Then
									If $aInputIds[3][$j] = "file" Then
										$sAddData = StringReplace($sAddData, _
												$sCDisp & $aInputIds[1][$j] & '"; filename=""' & @CRLF & @CRLF & $aInputIds[2][$j] & @CRLF, _
												__WinHttpFileContent($sAccept, $aInputIds[1][$j], $sPassedData, $sBoundary), 0, 1)
									ElseIf $aInputIds[3][$j] = "submit" Then
										If $sPassedData = True Then ; if this "submit" is set to TRUE then
											If $sSubmit Then ; If not already processed; only the first is valid
												Local $fMDelId = False
												For $sChunkSub In StringSplit($sSubmit, $sGrSep, 3) ; go tru all "submit" controls
													If $sChunkSub = "--" & $sBoundary & @CRLF & _
															$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
															$aInputIds[2][$j] & @CRLF Then
														If $fMDelId Then $sAddData = StringReplace($sAddData, $sChunkSub, "", 1, 1) ; Removing duplicates
														$fMDelId = True
													Else
														$sAddData = StringReplace($sAddData, $sChunkSub, "", 0, 1) ; delete all but the TRUE one
													EndIf
												Next
												$sSubmit = ""
									ElseIf $aInputIds[3][$j] = "radio" Then
										If $sPassedData = $aInputIds[2][$j] Then
											For $sChunkSub In StringSplit($sRadio, $sGrSep, 3) ; go tru all "radio" controls
												If StringInStr($sChunkSub, "--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & $sPassedData & @CRLF, 1) Then
													$sAddData = StringRegExpReplace($sAddData, "\Q--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & "\E" & "(.*?)" & @CRLF, "")
													$sAddData = StringReplace($sAddData, "--" & $sBoundary & "--" & @CRLF, "", 0, 1)
													$sAddData &= $sChunkSub & "--" & $sBoundary & "--" & @CRLF
													$sRadio = StringRegExpReplace($sRadio, "\Q--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & "\E(.*?)" & @CRLF & $sGrSep & "?", "")
									ElseIf $aInputIds[3][$j] = "checkbox" Then
										$sCheckBox = StringRegExpReplace($sCheckBox, "\Q--" & $sBoundary & @CRLF & _
												$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
												$sPassedData & @CRLF & "\E" & $sGrSep & "*", "")
										If StringRight($sCheckBox, 1) = $sGrSep Then $sCheckBox = StringTrimRight($sCheckBox, 1)
									ElseIf $aInputIds[3][$j] = "button" Then
										$sButton = StringRegExpReplace($sButton, "\Q--" & $sBoundary & @CRLF & _
										If StringRight($sButton, 1) = $sGrSep Then $sButton = StringTrimRight($sButton, 1)
									Else
												$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & $aInputIds[2][$j] & @CRLF, _
												$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & $sPassedData & @CRLF, 0, 1)
										$iNumRepl = @extended
										If $iNumRepl > 1 Then ; equalize ; TODO: remove duplicates
											$sAddData = StringRegExpReplace($sAddData, '(?s)\Q--' & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & '\E\r\n\r\n.*?\r\n', "", $iNumRepl - 1)
							Next
						Else ; like getElementsByName
								If $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "file" Then
									$sAddData = StringReplace($sAddData, _
											$sCDisp & $aSplit[1] & '"; filename=""' & @CRLF & @CRLF & $aInputIds[2][$j] & @CRLF, _
											__WinHttpFileContent($sAccept, $aInputIds[1][$j], $sPassedData, $sBoundary), 0, 1)
								ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "submit" Then
											Local $fMDel = False
												If $sChunkSub = "--" & $sBoundary & @CRLF & _
														$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
														$aInputIds[2][$j] & @CRLF Then
													If $fMDel Then $sAddData = StringReplace($sAddData, $sChunkSub, "", 1, 1) ; Removing duplicates
													$fMDel = True
													$sAddData = StringReplace($sAddData, $sChunkSub, "", 0, 1) ; delete all but the TRUE one
									Else ; False means do nothing
								ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "radio" Then
									For $sChunkSub In StringSplit($sRadio, $sGrSep, 3) ; go tru all "radio" controls
										If StringInStr($sChunkSub, "--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & $sPassedData & @CRLF, 1) Then
											$sAddData = StringRegExpReplace($sAddData, "\Q--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & "\E" & "(.*?)" & @CRLF, "")
											$sAddData = StringReplace($sAddData, "--" & $sBoundary & "--" & @CRLF, "", 0, 1)
											$sAddData &= $sChunkSub & "--" & $sBoundary & "--" & @CRLF
											$sRadio = StringRegExpReplace($sRadio, "\Q--" & $sBoundary & @CRLF & $sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & "\E(.*?)" & @CRLF & $sGrSep & "?", "")
									Next
								ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "checkbox" Then
									$sCheckBox = StringRegExpReplace($sCheckBox, "\Q--" & $sBoundary & @CRLF & _
											$sCDisp & $aInputIds[1][$j] & '"' & @CRLF & @CRLF & _
											$sPassedData & @CRLF & "\E" & $sGrSep & "*", "")
									If StringRight($sCheckBox, 1) = $sGrSep Then $sCheckBox = StringTrimRight($sCheckBox, 1)
								ElseIf $aInputIds[1][$j] == $aSplit[1] And $aInputIds[3][$j] = "button" Then
									$sButton = StringRegExpReplace($sButton, "\Q--" & $sBoundary & @CRLF & _
									If StringRight($sButton, 1) = $sGrSep Then $sButton = StringTrimRight($sButton, 1)
							$sAddData = StringRegExpReplace($sAddData, '(?s)\Q' & $sCDisp & $aSplit[1] & '"' & '\E\r\n\r\n.*?\r\n', _
									$sCDisp & $aSplit[1] & '"' & @CRLF & @CRLF & StringReplace($sPassedData, "\", "\\") & @CRLF)
							$iNumRepl = @extended
							If $iNumRepl > 1 Then ; remove duplicates
								$sAddData = StringRegExpReplace($sAddData, '(?s)\Q--' & $sBoundary & @CRLF & $sCDisp & $aSplit[1] & '"' & '\E\r\n\r\n.*?\r\n', "", $iNumRepl - 1)
				__WinHttpFinalizeCtrls($sSubmit, $sRadio, $sCheckBox, $sButton, $sAddData, $sGrSep)
		ExitLoop
	If $fSend Then
		If $fVarForm Then
			$hInternet = _WinHttpConnect($hOpen, $sNewURL)
			If $sNewURL Then
				$hOpen = _WinHttpQueryOption($hInternet, $WINHTTP_OPTION_PARENT_HANDLE)
				_WinHttpCloseHandle($hInternet)
				$hInternet = _WinHttpConnect($hOpen, $sNewURL)
		Local $hRequest
			$hRequest = __WinHttpFormSend($hInternet, $sMethod, $sAction, $fMultiPart, $sBoundary, $sAddData, True, $sAdditionalHeaders, $sCredName, $sCredPass, $iIgnoreCertErr)
			$hRequest = __WinHttpFormSend($hInternet, $sMethod, $sAction, $fMultiPart, $sBoundary, $sAddData, False, $sAdditionalHeaders, $sCredName, $sCredPass)
			If _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_STATUS_CODE) >= $HTTP_STATUS_BAD_REQUEST Then
				_WinHttpCloseHandle($hRequest)
				$hRequest = __WinHttpFormSend($hInternet, $sMethod, $sAction, $fMultiPart, $sBoundary, $sAddData, True, $sAdditionalHeaders, $sCredName, $sCredPass, $iIgnoreCertErr) ; try adding $WINHTTP_FLAG_SECURE
		Local $vReturned = _WinHttpSimpleReadData($hRequest)
		If @error Then
			_WinHttpCloseHandle($hRequest)
			Return SetError(4, 0, "") ; either site is expiriencing problems or your connection
		Local $iSCode = _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_STATUS_CODE)
		If $iRetArr Then
			Local $aReturn[3] = [_WinHttpQueryHeaders($hRequest), $vReturned, _WinHttpQueryOption($hRequest, $WINHTTP_OPTION_URL)]
			$vReturned = $aReturn
		_WinHttpCloseHandle($hRequest)
		Return SetExtended($iSCode, $vReturned)
	Return SetError(3, 0, "")
Func _WinHttpSimpleFormFill_SetUploadCallback($vCallback = Default, $iNumChunks = 100)
	If $iNumChunks <= 0 Then $iNumChunks = 100
	Local Static $vFunc = Default, $iParts = $iNumChunks
	If $vCallback <> Default Then
		$vFunc = $vCallback
		$iParts = Ceiling($iNumChunks)
	ElseIf $vCallback = 0 Then
		$vFunc = Default
		$iParts = 1
	Local $aOut[2] = [$vFunc, $iParts]
	Return $aOut
Func _WinHttpSimpleReadData($hRequest, $iMode = Default)
	If $iMode = Default Then
		$iMode = 0
		If __WinHttpCharSet(_WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_CONTENT_TYPE)) = 65001 Then $iMode = 1 ; header suggest utf-8
		__WinHttpDefault($iMode, 0)
	If $iMode > 2 Or $iMode < 0 Then Return SetError(1, 0, '')
	Local $vData = Binary('')
	If _WinHttpQueryDataAvailable($hRequest) Then
		Do
			$vData &= _WinHttpReadData($hRequest, 2)
		Until @error
				Return BinaryToString($vData)
				Return BinaryToString($vData, 4)
			Case Else
				Return $vData
	Return SetError(2, 0, $vData)
Func _WinHttpSimpleReadDataAsync($hInternet, ByRef $pBuffer, $iNumberOfBytesToRead = Default)
	Local $vOut = _WinHttpReadData($hInternet, 2, $iNumberOfBytesToRead, $pBuffer)
	Return SetError(@error, @extended, $vOut)
Func _WinHttpSimpleRequest($hConnect, $sType = Default, $sPath = Default, $sReferrer = Default, $sDta = Default, $sHeader = Default, $fGetHeaders = Default, $iMode = Default, $sCredName = Default, $sCredPass = Default)
	__WinHttpDefault($sType, "GET")
	__WinHttpDefault($sPath, "")
	__WinHttpDefault($sDta, $WINHTTP_NO_REQUEST_DATA)
	__WinHttpDefault($sHeader, $WINHTTP_NO_ADDITIONAL_HEADERS)
	__WinHttpDefault($fGetHeaders, False)
	__WinHttpDefault($iMode, Default)
	__WinHttpDefault($sCredName, "")
	__WinHttpDefault($sCredPass, "")
	If $iMode > 2 Or $iMode < 0 Then Return SetError(4, 0, 0)
	Local $hRequest = _WinHttpSimpleSendRequest($hConnect, $sType, $sPath, $sReferrer, $sDta, $sHeader)
	If @error Then Return SetError(@error, 0, 0)
	__WinHttpSetCredentials($hRequest, $sHeader, $sDta, $sCredName, $sCredPass)
	Local $iExtended = _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_STATUS_CODE)
	If $fGetHeaders Then
		Local $aData[3] = [_WinHttpQueryHeaders($hRequest), _WinHttpSimpleReadData($hRequest, $iMode), _WinHttpQueryOption($hRequest, $WINHTTP_OPTION_URL)]
		Return SetExtended($iExtended, $aData)
	Local $sOutData = _WinHttpSimpleReadData($hRequest, $iMode)
	_WinHttpCloseHandle($hRequest)
	Return SetExtended($iExtended, $sOutData)
Func _WinHttpSimpleSendRequest($hConnect, $sType = Default, $sPath = Default, $sReferrer = Default, $sDta = Default, $sHeader = Default)
	Local $hRequest = _WinHttpOpenRequest($hConnect, $sType, $sPath, Default, $sReferrer)
	If Not $hRequest Then Return SetError(1, @error, 0)
	If $sType = "POST" And $sHeader = $WINHTTP_NO_ADDITIONAL_HEADERS Then $sHeader = "Content-Type: application/x-www-form-urlencoded" & @CRLF
	_WinHttpSetOption($hRequest, $WINHTTP_OPTION_DECOMPRESSION, $WINHTTP_DECOMPRESSION_FLAG_ALL)
	_WinHttpSetOption($hRequest, $WINHTTP_OPTION_UNSAFE_HEADER_PARSING, 1)
	_WinHttpSendRequest($hRequest, $sHeader, $sDta)
	If @error Then Return SetError(2, 0 * _WinHttpCloseHandle($hRequest), 0)
	_WinHttpReceiveResponse($hRequest)
	If @error Then Return SetError(3, 0 * _WinHttpCloseHandle($hRequest), 0)
	Return $hRequest
Func _WinHttpSimpleSendSSLRequest($hConnect, $sType = Default, $sPath = Default, $sReferrer = Default, $sDta = Default, $sHeader = Default, $iIgnoreAllCertErrors = 0)
	Local $hRequest = _WinHttpOpenRequest($hConnect, $sType, $sPath, Default, $sReferrer, Default, BitOR($WINHTTP_FLAG_SECURE, $WINHTTP_FLAG_ESCAPE_DISABLE))
	If $iIgnoreAllCertErrors Then _WinHttpSetOption($hRequest, $WINHTTP_OPTION_SECURITY_FLAGS, BitOR($SECURITY_FLAG_IGNORE_UNKNOWN_CA, $SECURITY_FLAG_IGNORE_CERT_DATE_INVALID, $SECURITY_FLAG_IGNORE_CERT_CN_INVALID, $SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE))
Func _WinHttpSimpleSSLRequest($hConnect, $sType = Default, $sPath = Default, $sReferrer = Default, $sDta = Default, $sHeader = Default, $fGetHeaders = Default, $iMode = Default, $sCredName = Default, $sCredPass = Default, $iIgnoreCertErrors = 0)
	Local $hRequest = _WinHttpSimpleSendSSLRequest($hConnect, $sType, $sPath, $sReferrer, $sDta, $sHeader, $iIgnoreCertErrors)
		Return $aData
	Return $sOutData
Func _WinHttpTimeFromSystemTime()
	Local $SYSTEMTIME = DllStructCreate("word Year;" & _
			"word Month;" & _
			"word DayOfWeek;" & _
			"word Day;" & _
			"word Hour;" & _
			"word Minute;" & _
			"word Second;" & _
			"word Milliseconds")
	DllCall("kernel32.dll", "none", "GetSystemTime", "struct*", $SYSTEMTIME)
	If @error Then Return SetError(1, 0, "")
	Local $tTime = DllStructCreate("wchar[62]")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpTimeFromSystemTime", "struct*", $SYSTEMTIME, "struct*", $tTime)
	Return DllStructGetData($tTime, 1)
Func _WinHttpTimeToSystemTime($sHttpTime)
	DllStructSetData($tTime, 1, $sHttpTime)
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpTimeToSystemTime", "struct*", $tTime, "struct*", $SYSTEMTIME)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, 0)
	Local $aRet[8] = [DllStructGetData($SYSTEMTIME, "Year"), _
			DllStructGetData($SYSTEMTIME, "Month"), _
			DllStructGetData($SYSTEMTIME, "DayOfWeek"), _
			DllStructGetData($SYSTEMTIME, "Day"), _
			DllStructGetData($SYSTEMTIME, "Hour"), _
			DllStructGetData($SYSTEMTIME, "Minute"), _
			DllStructGetData($SYSTEMTIME, "Second"), _
			DllStructGetData($SYSTEMTIME, "Milliseconds")]
Func _WinHttpWriteData($hRequest, $vData, $iMode = Default)
	Local $iNumberOfBytesToWrite, $tData
	If $iMode = 1 Then
		$iNumberOfBytesToWrite = BinaryLen($vData)
		$tData = DllStructCreate("byte[" & $iNumberOfBytesToWrite & "]")
		DllStructSetData($tData, 1, $vData)
	ElseIf IsDllStruct($vData) Then
		$iNumberOfBytesToWrite = DllStructGetSize($vData)
		$tData = $vData
		$iNumberOfBytesToWrite = StringLen($vData)
		$tData = DllStructCreate("char[" & $iNumberOfBytesToWrite + 1 & "]")
	Local $aCall = DllCall($hWINHTTPDLL__WINHTTP, "bool", "WinHttpWriteData", _
			"struct*", $tData, _
			"dword", $iNumberOfBytesToWrite, _
	Return SetExtended($aCall[4], 1)
Func __WinHttpFileContent($sAccept, $sName, $sFileString, $sBoundaryMain = "")
	#forceref $sAccept ; FIXME: $sAccept is specified by the server (or left default). In case $sFileString is non-supported MIME type action should be aborted.
	Local $fNonStandard = False
	If StringLeft($sFileString, 10) = "PHP#50338:" Then
		$sFileString = StringTrimLeft($sFileString, 10)
		$fNonStandard = True
	Local $sOut = 'Content-Disposition: form-data; name="' & $sName & '"'
	If Not $sFileString Then Return $sOut & '; filename=""' & @CRLF & @CRLF & @CRLF
	If StringRight($sFileString, 1) = "|" Then $sFileString = StringTrimRight($sFileString, 1)
	Local $aFiles = StringSplit($sFileString, "|", 2), $hFile
	If UBound($aFiles) = 1 Then
		$hFile = FileOpen($aFiles[0], 16)
		$sOut &= '; filename="' & StringRegExpReplace($aFiles[0], ".*\\", "") & '"' & @CRLF & _
				"Content-Type: " & __WinHttpMIMEType($aFiles[0]) & @CRLF & @CRLF & BinaryToString(FileRead($hFile), 1) & @CRLF
		FileClose($hFile)
		Return $sOut ; That's it
	If $fNonStandard Then
		$sOut = "" ; discharge
		Local $iFiles = UBound($aFiles)
		For $i = 0 To $iFiles - 1
			$hFile = FileOpen($aFiles[$i], 16)
			$sOut &= 'Content-Disposition: form-data; name="' & $sName & '"' & _
					'; filename="' & StringRegExpReplace($aFiles[$i], ".*\\", "") & '"' & @CRLF & _
					"Content-Type: " & __WinHttpMIMEType($aFiles[$i]) & @CRLF & @CRLF & BinaryToString(FileRead($hFile), 1) & @CRLF
			FileClose($hFile)
			If $i < $iFiles - 1 Then $sOut &= "--" & $sBoundaryMain & @CRLF
		Local $sBoundary = StringFormat("%s%.5f", "----WinHttpSubBoundaryLine_", Random(10000, 99999))
		$sOut &= @CRLF & "Content-Type: multipart/mixed; boundary=" & $sBoundary & @CRLF & @CRLF
		For $i = 0 To UBound($aFiles) - 1
			$sOut &= "--" & $sBoundary & @CRLF & _
					'Content-Disposition: file; filename="' & StringRegExpReplace($aFiles[$i], ".*\\", "") & '"' & @CRLF & _
		$sOut &= "--" & $sBoundary & "--" & @CRLF
	Return $sOut
Func __WinHttpMIMEType($sFileName)
	Local $aArray = StringRegExp(__WinHttpMIMEAssocString(), "(?i)\Q;" & StringRegExpReplace($sFileName, ".*\.", "") & "\E\|(.*?);", 3)
	If @error Then Return "application/octet-stream"
	Return $aArray[0]
Func __WinHttpMIMEAssocString()
	Return ";ai|application/postscript;aif|audio/x-aiff;aifc|audio/x-aiff;aiff|audio/x-aiff;asc|text/plain;atom|application/atom+xml;au|audio/basic;avi|video/x-msvideo;bcpio|application/x-bcpio;bin|application/octet-stream;bmp|image/bmp;cdf|application/x-netcdf;cgm|image/cgm;class|application/octet-stream;cpio|application/x-cpio;cpt|application/mac-compactpro;csh|application/x-csh;css|text/css;dcr|application/x-director;dif|video/x-dv;dir|application/x-director;djv|image/vnd.djvu;djvu|image/vnd.djvu;dll|application/octet-stream;dmg|application/octet-stream;dms|application/octet-stream;doc|application/msword;dtd|application/xml-dtd;dv|video/x-dv;dvi|application/x-dvi;dxr|application/x-director;eps|application/postscript;etx|text/x-setext;exe|application/octet-stream;ez|application/andrew-inset;gif|image/gif;gram|application/srgs;grxml|application/srgs+xml;gtar|application/x-gtar;hdf|application/x-hdf;hqx|application/mac-binhex40;htm|text/html;html|text/html;ice|x-conference/x-cooltalk;ico|image/x-icon;ics|text/calendar;ief|image/ief;ifb|text/calendar;iges|model/iges;igs|model/iges;jnlp|application/x-java-jnlp-file;jp2|image/jp2;jpe|image/jpeg;jpeg|image/jpeg;jpg|image/jpeg;js|application/x-javascript;kar|audio/midi;latex|application/x-latex;lha|application/octet-stream;lzh|application/octet-stream;m3u|audio/x-mpegurl;m4a|audio/mp4a-latm;m4b|audio/mp4a-latm;m4p|audio/mp4a-latm;m4u|video/vnd.mpegurl;m4v|video/x-m4v;mac|image/x-macpaint;man|application/x-troff-man;mathml|application/mathml+xml;me|application/x-troff-me;mesh|model/mesh;mid|audio/midi;midi|audio/midi;mif|application/vnd.mif;mov|video/quicktime;movie|video/x-sgi-movie;mp2|audio/mpeg;mp3|audio/mpeg;mp4|video/mp4;mpe|video/mpeg;mpeg|video/mpeg;mpg|video/mpeg;mpga|audio/mpeg;ms|application/x-troff-ms;msh|model/mesh;mxu|video/vnd.mpegurl;nc|application/x-netcdf;oda|application/oda;ogg|application/ogg;pbm|image/x-portable-bitmap;pct|image/pict;pdb|chemical/x-pdb;pdf|application/pdf;pgm|image/x-portable-graymap;pgn|application/x-chess-pgn;pic|image/pict;pict|image/pict;png|image/png;pnm|image/x-portable-anymap;pnt|image/x-macpaint;pntg|image/x-macpaint;ppm|image/x-portable-pixmap;ppt|application/vnd.ms-powerpoint;ps|application/postscript;qt|video/quicktime;qti|image/x-quicktime;qtif|image/x-quicktime;ra|audio/x-pn-realaudio;ram|audio/x-pn-realaudio;ras|image/x-cmu-raster;rdf|application/rdf+xml;rgb|image/x-rgb;rm|application/vnd.rn-realmedia;roff|application/x-troff;rtf|text/rtf;rtx|text/richtext;sgm|text/sgml;sgml|text/sgml;sh|application/x-sh;shar|application/x-shar;silo|model/mesh;sit|application/x-stuffit;skd|application/x-koan;skm|application/x-koan;skp|application/x-koan;skt|application/x-koan;smi|application/smil;smil|application/smil;snd|audio/basic;so|application/octet-stream;spl|application/x-futuresplash;src|application/x-wais-source;sv4cpio|application/x-sv4cpio;sv4crc|application/x-sv4crc;svg|image/svg+xml;swf|application/x-shockwave-flash;t|application/x-troff;tar|application/x-tar;tcl|application/x-tcl;tex|application/x-tex;texi|application/x-texinfo;texinfo|application/x-texinfo;tif|image/tiff;tiff|image/tiff;tr|application/x-troff;tsv|text/tab-separated-values;txt|text/plain;ustar|application/x-ustar;vcd|application/x-cdlink;vrml|model/vrml;vxml|application/voicexml+xml;wav|audio/x-wav;wbmp|image/vnd.wap.wbmp;wbmxl|application/vnd.wap.wbxml;wml|text/vnd.wap.wml;wmlc|application/vnd.wap.wmlc;wmls|text/vnd.wap.wmlscript;wmlsc|application/vnd.wap.wmlscriptc;wrl|model/vrml;xbm|image/x-xbitmap;xht|application/xhtml+xml;xhtml|application/xhtml+xml;xls|application/vnd.ms-excel;xml|application/xml;xpm|image/x-xpixmap;xsl|application/xml;xslt|application/xslt+xml;xul|application/vnd.mozilla.xul+xml;xwd|image/x-xwindowdump;xyz|chemical/x-xyz;zip|application/zip;"
Func __WinHttpCharSet($sContentType)
	Local $aContentType = StringRegExp($sContentType, "(?i).*?\Qcharset=\E(?U)([^ ]+)(;| |\Z)", 2)
	If Not @error Then $sContentType = $aContentType[1]
	If StringLeft($sContentType, 2) = "cp" Then Return Int(StringTrimLeft($sContentType, 2))
	If $sContentType = "utf-8" Then Return 65001
Func __WinHttpURLEncode($vData, $sEncType = "")
	If IsBool($vData) Then Return $vData
	$vData = __WinHttpHTMLDecode($vData)
	If $sEnctype = "text/plain" Then Return StringReplace($vData, " ", "+")
	Local $aData = StringToASCIIArray($vData, Default, Default, 2)
	Local $sOut
	For $i = 0 To UBound($aData) - 1
		Switch $aData[$i]
			Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
				$sOut &= Chr($aData[$i])
			Case 32
				$sOut &= "+"
				$sOut &= "%" & Hex($aData[$i], 2)
Func __WinHttpHTMLDecode($vData)
	Return StringReplace(StringReplace(StringReplace(StringReplace($vData, "&amp;", "&"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"')
Func __WinHttpNormalizeActionURL($sActionPage, ByRef $sAction, ByRef $iScheme, ByRef $sNewURL, ByRef $sEnctype, ByRef $sMethod, $sURL = "")
	Local $aCrackURL = _WinHttpCrackUrl($sAction)
		If $sAction Then
			If StringLeft($sAction, 2) = "//" Then
				$aCrackURL = _WinHttpCrackUrl($sURL)
				If Not @error Then
					$aCrackURL = _WinHttpCrackUrl($aCrackURL[0] & ":" & $sAction)
					If Not @error Then
						$sNewURL = $aCrackURL[0] & "://" & $aCrackURL[2] & ":" & $aCrackURL[3]
						$iScheme = $aCrackURL[1]
						$sAction = $aCrackURL[6] & $aCrackURL[7]
						$sActionPage = ""
			ElseIf StringLeft($sAction, 1) = "?" Then
				$sAction = $aCrackURL[6] & $sAction
			ElseIf StringLeft($sAction, 1) = "#" Then
				$sAction = StringReplace($sActionPage, StringRegExpReplace($sActionPage, "(.*?)(#.*?)", "$2"), $sAction)
			ElseIf StringLeft($sAction, 1) <> "/" Then
					Local $sCurrent
					Local $aURL = StringRegExp($sActionPage, '(.*)/', 3)
					If Not @error Then $sCurrent = $aURL[0]
					If $sCurrent Then $sAction = $sCurrent & "/" & $sAction
			If StringLeft($sAction, 1) = "?" Then $sAction = $sActionPage & $sAction
		If Not $sAction Then $sAction = $sActionPage
		$sAction = StringRegExpReplace($sAction, "\A(/*\.\./)*", "") ; /../
		$iScheme = $aCrackURL[1]
		$sNewURL = $aCrackURL[0] & "://" & $aCrackURL[2] & ":" & $aCrackURL[3]
		$sAction = $aCrackURL[6] & $aCrackURL[7]
	If Not $sMethod Then $sMethod = "GET"
	If $sMethod = "GET" Then $sEnctype = ""
Func __WinHttpHTML5FormAttribs(ByRef $aDtas, ByRef $aFlds, ByRef $iNumParams, ByRef $aInput, ByRef $sAction, ByRef $sEnctype, ByRef $sMethod)
	Local $aSpl, $iSubmitHTML5 = 0, $iInpSubm, $sImgAppx = "."
	For $k = 1 To $iNumParams
		$aSpl = StringSplit($aFlds[$k], ":", 2)
		If $aSpl[0] = "type" And ($aSpl[1] = "submit" Or $aSpl[1] = "image") Then
			Local $iSubmIndex = $aDtas[$k], $iSubmCur = 0, $iImgCur = 0, $sType, $sInpNme
			If $aSpl[1] = "image" Then
				$iSubmIndex = Int($aDtas[$k])
			For $i = 0 To UBound($aInput) - 1 ; for all input elements
				Switch __WinHttpAttribVal($aInput[$i], "type")
					Case "submit"
						If $iSubmCur = $iSubmIndex Then
							$iSubmitHTML5 = 1
							$iInpSubm = $i
							ExitLoop 2
						$iSubmCur += 1
					Case "image"
						If $iImgCur = $iSubmIndex Then
							$sInpNme = __WinHttpAttribVal($aInput[$iInpSubm], "name")
							If $sInpNme Then $sInpNme &= $sImgAppx
							$aInput[$iInpSubm] = 'type="image" formaction="' & __WinHttpAttribVal($aInput[$iInpSubm], "formaction") & '" formenctype="' & __WinHttpAttribVal($aInput[$iInpSubm], "formenctype") & '" formmethod="' & __WinHttpAttribVal($aInput[$iInpSubm], "formmethod") & '"'
							Local $iX = 0, $iY = 0
							$iX = Int(StringRegExpReplace($aDtas[$k], "(\d+)\h*(\d+),(\d+)", "$2", 1))
							$iY = Int(StringRegExpReplace($aDtas[$k], "(\d+)\h*(\d+),(\d+)", "$3", 1))
							ReDim $aInput[UBound($aInput) + 2]
							$aInput[UBound($aInput) - 2] = 'type="image" name="' & $sInpNme & 'x" value="' & $iX & '"'
							$aInput[UBound($aInput) - 1] = 'type="image" name="' & $sInpNme & 'y" value="' & $iY & '"'
						$iImgCur += 1
				EndSwitch
			Next
			ElseIf $aSpl[0] = "name" Then
			Local $sInpNme = $aSpl[1], $sType
				$sType = __WinHttpAttribVal($aInput[$i], "type")
				If $sType = "submit" Then
					If __WinHttpAttribVal($aInput[$i], "name") = $sInpNme And $aDtas[$k] = True Then
						$iSubmitHTML5 = 1
						$iInpSubm = $i
						ExitLoop 2
				ElseIf $sType = "image" Then
					If __WinHttpAttribVal($aInput[$i], "name") = $sInpNme And $aDtas[$k] Then
						Local $aStrSplit = StringSplit($aDtas[$k], ",", 3), $iX = 0, $iY = 0
						If Not @error Then
							$iX = Int($aStrSplit[0])
							$iY = Int($aStrSplit[1])
						$aInput[$iInpSubm] = 'type="image" formaction="' & __WinHttpAttribVal($aInput[$iInpSubm], "formaction") & '" formenctype="' & __WinHttpAttribVal($aInput[$iInpSubm], "formenctype") & '" formmethod="' & __WinHttpAttribVal($aInput[$iInpSubm], "formmethod") & '"'
						$sInpNme &= $sImgAppx
						ReDim $aInput[UBound($aInput) + 2]
						$aInput[UBound($aInput) - 2] = 'type="image" name="' & $sInpNme & 'x" value="' & $iX & '"'
						$aInput[UBound($aInput) - 1] = 'type="image" name="' & $sInpNme & 'y" value="' & $iY & '"'
		Else ; id
			Local $sInpId, $sType
			If @error Then
				$sInpId = $aSpl[0]
			ElseIf $aSpl[0] = "id" Then
				$sInpId = $aSpl[1]
					If __WinHttpAttribVal($aInput[$i], "id") = $sInpId And $aDtas[$k] = True Then
					If __WinHttpAttribVal($aInput[$i], "id") = $sInpId And $aDtas[$k] Then
						Local $sInpNme = __WinHttpAttribVal($aInput[$iInpSubm], "name")
						If $sInpNme Then $sInpNme &= $sImgAppx
	If $iSubmitHTML5 Then
		Local $iUbound = UBound($aInput) - 1
		If __WinHttpAttribVal($aInput[$iInpSubm], "type") = "image" Then $iUbound -= 2 ; two form fields are added for "image"
		For $j = 0 To $iUbound ; for all other input elements
			If $j = $iInpSubm Then ContinueLoop
			Switch __WinHttpAttribVal($aInput[$j], "type")
				Case "submit", "image"
					$aInput[$j] = "" ; remove any other submit/image controls
			EndSwitch
		Local $sAttr = __WinHttpAttribVal($aInput[$iInpSubm], "formaction")
		If $sAttr Then $sAction = $sAttr
		$sAttr = __WinHttpAttribVal($aInput[$iInpSubm], "formenctype")
		If $sAttr Then $sEnctype = $sAttr
		$sAttr = __WinHttpAttribVal($aInput[$iInpSubm], "formmethod")
		If $sAttr Then $sMethod = $sAttr
		If __WinHttpAttribVal($aInput[$iInpSubm], "type") = "image" Then $aInput[$iInpSubm] = ""
Func __WinHttpNormalizeForm(ByRef $sForm, $sSpr1, $sSpr2)
	Local $aData = StringToASCIIArray($sForm, Default, Default, 2)
	Local $sOut, $bQuot = False, $bSQuot = False, $bOpTg = True
			Case 34
				If $bOpTg Then $bQuot = Not $bQuot
			Case 39
				If $bOpTg Then $bSQuot = Not $bSQuot
			Case 32 ; space
				If $bQuot Or $bSQuot Then
					$sOut &= $sSpr1
				Else
					$sOut &= Chr($aData[$i])
			Case 60 ; <
				If Not $bOpTg Then $bOpTg = True
			Case 62 ; >
					$sOut &= $sSpr2
					If $bOpTg Then $bOpTg = False
	$sForm = $sOut
Func __WinHttpFinalizeCtrls($sSubmit, $sRadio, $sCheckBox, $sButton, ByRef $sAddData, $sGrSep, $sBound = "")
	If $sSubmit Then ; If no submit is specified
		Local $aSubmit = StringSplit($sSubmit, $sGrSep, 3)
		For $m = 1 To UBound($aSubmit) - 1
			$sAddData = StringRegExpReplace($sAddData, "(?:\Q" & $sBound & "\E|\A)\Q" & $aSubmit[$m] & "\E(?:\Q" & $sBound & "\E|\z)", $sBound)
		__WinHttpTrimBounds($sAddData, $sBound)
	If $sRadio Then ; If no radio is specified
		If $sRadio <> $sGrSep Then
			For $sElem In StringSplit($sRadio, $sGrSep, 3)
				$sAddData = StringRegExpReplace($sAddData, "(?:\Q" & $sBound & "\E|\A)\Q" & $sElem & "\E(?:\Q" & $sBound & "\E|\z)", $sBound)
			__WinHttpTrimBounds($sAddData, $sBound)
	If $sCheckBox Then ; If no checkbox is specified
		For $sElem In StringSplit($sCheckBox, $sGrSep, 3)
			$sAddData = StringRegExpReplace($sAddData, "(?:\Q" & $sBound & "\E|\A)\Q" & $sElem & "\E(?:\Q" & $sBound & "\E|\z)", $sBound)
	If $sButton Then ; If no button is specified
		For $sElem In StringSplit($sButton, $sGrSep, 3)
Func __WinHttpTrimBounds(ByRef $sDta, $sBound)
	Local $iBLen = StringLen($sBound)
	If StringRight($sDta, $iBLen) = $sBound Then $sDta = StringTrimRight($sDta, $iBLen)
	If StringLeft($sDta, $iBLen) = $sBound Then $sDta = StringTrimLeft($sDta, $iBLen)
Func __WinHttpFormAttrib(ByRef $aAttrib, $i, $sElement)
	$aAttrib[0][$i] = __WinHttpAttribVal($sElement, "id")
	$aAttrib[1][$i] = __WinHttpAttribVal($sElement, "name")
	$aAttrib[2][$i] = __WinHttpAttribVal($sElement, "value")
	$aAttrib[3][$i] = __WinHttpAttribVal($sElement, "type")
Func __WinHttpAttribVal($sIn, $sAttrib)
	Local $aArray = StringRegExp($sIn, '(?i).*?(\A| )\b' & $sAttrib & '\h*=(\h*"(.*?)"|' & "\h*'(.*?)'|" & '\h*(.*?)(?: |\Z))', 1) ; e.g. id="abc" or id='abc' or id=abc
	If @error Then Return ""
	Return $aArray[UBound($aArray) - 1]
Func __WinHttpFormSend($hInternet, $sMethod, $sAction, $fMultiPart, $sBoundary, $sAddData, $fSecure = False, $sAdditionalHeaders = "", $sCredName = "", $sCredPass = "", $iIgnoreAllCertErrors = 0)
	Local $hRequest
	If $fSecure Then
		$hRequest = _WinHttpOpenRequest($hInternet, $sMethod, $sAction, Default, Default, Default, $WINHTTP_FLAG_SECURE)
		If $iIgnoreAllCertErrors Then _WinHttpSetOption($hRequest, $WINHTTP_OPTION_SECURITY_FLAGS, BitOR($SECURITY_FLAG_IGNORE_UNKNOWN_CA, $SECURITY_FLAG_IGNORE_CERT_DATE_INVALID, $SECURITY_FLAG_IGNORE_CERT_CN_INVALID, $SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE))
		$hRequest = _WinHttpOpenRequest($hInternet, $sMethod, $sAction)
	If $fMultiPart Then
		_WinHttpAddRequestHeaders($hRequest, "Content-Type: multipart/form-data; boundary=" & $sBoundary)
		If $sMethod = "POST" Then _WinHttpAddRequestHeaders($hRequest, "Content-Type: application/x-www-form-urlencoded")
	_WinHttpAddRequestHeaders($hRequest, "Accept: application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,*/*;q=0.5")
	_WinHttpAddRequestHeaders($hRequest, "Accept-Charset: utf-8;q=0.7")
	If $sAdditionalHeaders Then _WinHttpAddRequestHeaders($hRequest, $sAdditionalHeaders, BitOR($WINHTTP_ADDREQ_FLAG_REPLACE, $WINHTTP_ADDREQ_FLAG_ADD))
	__WinHttpFormUpload($hRequest, "", $sAddData)
	__WinHttpSetCredentials($hRequest, "", $sAddData, $sCredName, $sCredPass, 1)
Func __WinHttpSetCredentials($hRequest, $sHeaders = "", $sOptional = "", $sCredName = "", $sCredPass = "", $iFormFill = 0)
	If $sCredName And $sCredPass Then
		Local $iStatusCode = _WinHttpQueryHeaders($hRequest, $WINHTTP_QUERY_STATUS_CODE)
		If $iStatusCode = $HTTP_STATUS_DENIED Or $iStatusCode = $HTTP_STATUS_PROXY_AUTH_REQ Then
			Local $iSupportedSchemes, $iFirstScheme, $iAuthTarget
			If _WinHttpQueryAuthSchemes($hRequest, $iSupportedSchemes, $iFirstScheme, $iAuthTarget) Then
				If $iFirstScheme = $WINHTTP_AUTH_SCHEME_PASSPORT And $iStatusCode = $HTTP_STATUS_PROXY_AUTH_REQ Then
					_WinHttpSetOption($hRequest, $WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_ENABLE_PASSPORT_AUTH)
					_WinHttpSetOption($hRequest, $WINHTTP_OPTION_PROXY_USERNAME, $sCredName)
					_WinHttpSetOption($hRequest, $WINHTTP_OPTION_PROXY_PASSWORD, $sCredPass)
					_WinHttpSetCredentials($hRequest, $iAuthTarget, $iFirstScheme, $sCredName, $sCredPass)
				If $iFormFill Then
					__WinHttpFormUpload($hRequest, $sHeaders, $sOptional)
					_WinHttpSendRequest($hRequest, $sHeaders, $sOptional)
				_WinHttpReceiveResponse($hRequest)
Func __WinHttpFormUpload($hRequest, $sHeaders, $sData)
	Local $aClbk = _WinHttpSimpleFormFill_SetUploadCallback()
	If $aClbk[0] <> Default Then
		Local $iSize = StringLen($sData), $iChunk = Floor($iSize / $aClbk[1]), $iRest = $iSize - ($aClbk[1] - 1) * $iChunk, $iCurCh = $iChunk
		_WinHttpSendRequest($hRequest, Default, Default, $iSize)
		For $i = 1 To $aClbk[1]
			If $i = $aClbk[1] Then $iCurCh = $iRest
			_WinHttpWriteData($hRequest, StringMid($sData, 1 + $iChunk * ($i -1), $iCurCh))
			Call($aClbk[0], Floor($i * 100 / $aClbk[1]))
		_WinHttpSendRequest($hRequest, Default, $sData)
Func __WinHttpDefault(ByRef $vInput, $vOutput)
	If $vInput = Default Or Number($vInput) = -1 Then $vInput = $vOutput
Func __WinHttpMemGlobalFree($pMem)
	Local $aCall = DllCall("kernel32.dll", "ptr", "GlobalFree", "ptr", $pMem)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
Func __WinHttpPtrStringLenW($pStr)
	Local $aCall = DllCall("kernel32.dll", "dword", "lstrlenW", "ptr", $pStr)
Func __WinHttpUA()
	Local Static $sUA = "Mozilla/5.0 " & __WinHttpSysInfo() & " WinHttp/" & __WinHttpVer() & " (WinHTTP/5.1) like Gecko"
	Return $sUA
Func __WinHttpSysInfo()
	Local $sDta = FileGetVersion("kernel32.dll")
	$sDta = "(Windows NT " & StringLeft($sDta, StringInStr($sDta, ".", 1, 2) - 1)
	If StringInStr(@OSArch, "64") And Not @AutoItX64 Then $sDta &= "; WOW64"
	$sDta &= ")"
	Return $sDta
Func __WinHttpVer()
	Return "1.6.4.1"
Func _WinHttpBinaryConcat(ByRef $bBinary1, ByRef $bBinary2)
	Local $bOut = _WinHttpSimpleBinaryConcat($bBinary1, $bBinary2)
	Return SetError(@error, 0, $bOut)
#include "wd_core.au3"
#Region Copyright
#EndRegion Copyright
#Region Many thanks to:
#EndRegion Many thanks to:
Func _WD_NewTab($sSession, $lSwitch = True, $iTimeout = -1, $sURL = "", $sFeatures = "")
	Local Const $sFuncName = "_WD_NewTab"
	Local $sTabHandle = '', $sLastTabHandle, $hWaitTimer, $iTabIndex, $aTemp
	If $iTimeout = -1 Then $iTimeout = $_WD_DefaultTimeout
	Local $aHandles = _WD_Window($sSession, 'handles')
	If @error <> $_WD_ERROR_Success Or Not IsArray($aHandles) Then
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception), 0, $sTabHandle)
	$iTabCount = UBound($aHandles)
	$sLastTabHandle = $aHandles[$iTabCount - 1]
	Local $sCurrentTabHandle = _WD_Window($sSession, 'window')
	If @error = $_WD_ERROR_Success Then
		$iTabIndex = _ArraySearch($aHandles, $sCurrentTabHandle)
			$sCurrentTabHandle = $sLastTabHandle
			$iTabIndex = $iTabCount - 1
		_WD_Window($sSession, 'Switch', '{"handle":"' & $sLastTabHandle & '"}')
		$sCurrentTabHandle = $sLastTabHandle
		$iTabIndex = $iTabCount - 1
	_WD_ExecuteScript($sSession, "window.open(arguments[0], '', arguments[1])", '"' & $sURL & '","' & $sFeatures & '"')
	If @error <> $_WD_ERROR_Success Then
	$hWaitTimer = TimerInit()
	While 1
 		$aTemp = _WD_Window($sSession, 'handles')
		If UBound($aTemp) > $iTabCount Then
			$sTabHandle = $aTemp[$iTabIndex + 1]
			ExitLoop
		If TimerDiff($hWaitTimer) > $iTimeout Then Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Timeout), 0, $sTabHandle)
		Sleep(10)
	WEnd
	If $lSwitch Then
		_WD_Window($sSession, 'Switch', '{"handle":"' & $sTabHandle & '"}')
		_WD_Window($sSession, 'Switch', '{"handle":"' & $sCurrentTabHandle & '"}')
	Return SetError($_WD_ERROR_Success, 0, $sTabHandle)
Func _WD_Attach($sSession, $sString, $sMode = 'title')
	Local Const $sFuncName = "_WD_Attach"
	Local $sTabHandle = '', $lFound = False, $sCurrentTab, $aHandles
	$sCurrentTab = _WD_Window($sSession, 'window')
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_GeneralError), 0, $sTabHandle)
		$aHandles = _WD_Window($sSession, 'handles')
		If @error = $_WD_ERROR_Success Then
			$sMode = StringLower($sMode)
			For $sHandle In $aHandles
				_WD_Window($sSession, 'Switch', '{"handle":"' & $sHandle & '"}')
				Switch $sMode
					Case "title", "url"
						If StringInStr(_WD_Action($sSession, $sMode), $sString) > 0 Then
							$lFound = True
							$sTabHandle = $sHandle
							ExitLoop
					Case 'html'
						If StringInStr(_WD_GetSource($sSession), $sString) > 0 Then
					Case Else
						Return SetError(__WD_Error($sFuncName, $_WD_ERROR_InvalidDataType, "(Title|URL|HTML) $sOption=>" & $sMode), 0, $sTabHandle)
			If Not $lFound Then
				_WD_Window($sSession, 'Switch', '{"handle":"' & $sCurrentTab & '"}')
				Return SetError(__WD_Error($sFuncName, $_WD_ERROR_NoMatch), 0, $sTabHandle)
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_GeneralError), 0, $sTabHandle)
Func _WD_LinkClickByText($sSession, $sText, $lPartial = True)
	Local Const $sFuncName = "_WD_LinkClickByText"
	Local $sElement = _WD_FindElement($sSession, ($lPartial) ? $_WD_LOCATOR_ByPartialLinkText : $_WD_LOCATOR_ByLinkText, $sText)
	Local $iErr = @error
	If $iErr = $_WD_ERROR_Success Then
		_WD_ElementAction($sSession, $sElement, 'click')
		$iErr = @error
		If $iErr <> $_WD_ERROR_Success Then
			Return SetError(__WD_Error($sFuncName, $_WD_ERROR_Exception), $_WD_HTTPRESULT)
		Return SetError(__WD_Error($sFuncName, $_WD_ERROR_NoMatch), $_WD_HTTPRESULT)
	Return SetError($_WD_ERROR_Success)
Func _WD_WaitElement($sSession, $sStrategy, $sSelector, $iDelay = 0, $iTimeout = -1, $lVisible = False)
	Local Const $sFuncName = "_WD_WaitElement"
	Local $bAbort = False, $iErr, $iResult = 0, $sElement, $lIsVisible = True
	Sleep($iDelay)
	Local $hWaitTimer = TimerInit()
		$sElement = _WD_FindElement($sSession, $sStrategy, $sSelector)
		If $iErr = $_WD_ERROR_Success Then
			If $lVisible Then
				$lIsVisible = _WD_ElementAction($sSession, $sElement, 'displayed')
			If $lIsVisible = True Then
				$iResult = 1
				ExitLoop
		If (TimerDiff($hWaitTimer) > $iTimeout) Then
			$iErr = $_WD_ERROR_Timeout
		Sleep(1000)
	Return SetError(__WD_Error($sFuncName, $iErr), 0, $iResult)
Func _WD_GetMouseElement($sSession)
	Local Const $sFuncName = "_WD_GetMouseElement"
	Local $sResponse, $sJSON, $sElement
	Local $sScript = "return Array.from(document.querySelectorAll(':hover')).pop()"
	$sResponse = _WD_ExecuteScript($sSession, $sScript, '')
	$sJSON = Json_Decode($sResponse)
	$sElement = Json_Get($sJSON, "[value][" & $_WD_ELEMENT_ID & "]")
	If $_WD_DEBUG = $_WD_DEBUG_Info Then
		ConsoleWrite($sFuncName & ': ' & $sElement & @CRLF)
		ConsoleWrite($sFuncName & ': ' & IsObj($sElement) & @CRLF)
Return SetError($_WD_ERROR_Success, 0, $sElement)
Func _WD_GetElementFromPoint($sSession, $iX, $iY)
	Local $sResponse, $sElement, $sJSON
    Local $sScript = "return document.elementFromPoint(arguments[0], arguments[1]);"
	Local $sParams = $iX & ", " & $iY
	$sResponse = _WD_ExecuteScript($sSession, $sScript, $sParams)
	Return SetError($_WD_ERROR_Success, 0, $sElement)
Func _WD_LastHTTPResult()
	Return $_WD_HTTPRESULT
Func _WD_GetFrameCount($sSession)
    Local $sResponse, $sJSON, $iValue
    $sResponse = _WD_ExecuteScript($sSession, "return window.frames.length")
    $sJSON = Json_Decode($sResponse)
    $iValue = Json_Get($sJSON, "[value]")
    Return Number($iValue)
EndFunc ;==>_WD_GetFrameCount
Func _WD_IsWindowTop($sSession)
    Local $sResponse, $sJSON
    Local $blnResult
    $sResponse = _WD_ExecuteScript($sSession, "return window.top == window.self")
    $blnResult = Json_Get($sJSON, "[value]")
    Return $blnResult
EndFunc ;==>_WD_IsWindowTop
Func _WD_FrameEnter($sSession, $sIndexOrID)
    Local $sOption
    Local $sValue
    If IsInt($sIndexOrID) = True Then
        $sOption = '{"id":' & $sIndexOrID & '}'
    Else
		$sOption = '{"id":{"' & $_WD_ELEMENT_ID & '":"' & $sIndexOrID & '"}}'
    EndIf
    $sResponse = _WD_Window($sSession, "frame", $sOption)
    $sValue = Json_Get($sJSON, "[value]")
    If $sValue <> Null Then
        $sValue = Json_Get($sJSON, "[value][error]")
        $sValue = True
    Return $sValue
EndFunc ;==>_WD_FrameEnter
Func _WD_FrameLeave($sSession)
    Local $sResponse, $sJSON, $asJSON
    $sOption = '{}'
    $sResponse = _WD_Window($sSession, "parent", $sOption)
        If Json_IsObject($sValue) = True Then
            $asJSON = Json_ObjGetKeys($sValue)
            If UBound($asJSON) = 0 Then ;Firefox PASS
                $sValue = True
            Else ;Chrome and Firefox FAIL
                $sValue = $asJSON[0] & ":" & Json_Get($sJSON, "[value][" & $asJSON[0] & "]")
            EndIf
        EndIf
    Else ;Chrome PASS
EndFunc ;==>_WD_FrameLeave
Func _WD_HighlightElement($sSession, $sElement, $iMethod = 1)
    Local Const $aMethod[] = ["border: 2px dotted red", _
            "background: #FFFF66; border-radius: 5px; padding-left: 3px;", _
            "border:2px dotted  red;background: #FFFF66; border-radius: 5px; padding-left: 3px;"]
    If $iMethod < 1 Or $iMethod > 3 Then $iMethod = 1
	Local $sJsonElement = '{"' & $_WD_ELEMENT_ID & '":"' & $sElement & '"}'
    Local $sResponse = _WD_ExecuteScript($sSession, "arguments[0].style='" & $aMethod[$iMethod - 1] & "'; return true;", $sJsonElement)
    Local $sJSON = Json_Decode($sResponse)
    Local $sResult = Json_Get($sJSON, "[value]")
    Return ($sResult = "true" ? SetError(0, 0, $sResult) : SetError(1, 0, False))
EndFunc   ;==>_WD_HighlightElement
Func _WD_HighlightElements($sSession, $aElements, $iMethod = 1)
    Local $iHighlightedElements = 0
    For $i = 0 To UBound($aElements) - 1
        $iHighlightedElements += (_WD_HighlightElement($sSession, $aElements[$i], $iMethod) = True ? 1 : 0)
    Next
    Return ($iHighlightedElements > 0 ? SetError(0, $iHighlightedElements, True) : SetError(1, 0, False))
EndFunc   ;==>_WD_HighlightElements
Func _WD_LoadWait($sSession, $iDelay = 0, $iTimeout = -1, $sElement = '')
	Local Const $sFuncName = "_WD_LoadWait"
	Local $iErr, $sResponse, $sJSON, $sReadyState
	If $iDelay Then Sleep($iDelay)
	Local $hLoadWaitTimer = TimerInit()
	While True
		If $sElement <> '' Then
			_WD_ElementAction($sSession, $sElement, 'name')
			If $_WD_HTTPRESULT = $HTTP_STATUS_NOT_FOUND Then $sElement = ''
			$sResponse = _WD_ExecuteScript($sSession, 'return document.readyState', '')
			$iErr = @error
			If $iErr Then
			$sJSON = Json_Decode($sResponse)
			$sReadyState = Json_Get($sJSON, "[value]")
			If $sReadyState = 'complete' Then ExitLoop
		If (TimerDiff($hLoadWaitTimer) > $iTimeout) Then
		Sleep(100)
	If $iErr Then
		Return SetError(__WD_Error($sFuncName, $iErr, ""), 0, 0)
	Return SetError($_WD_ERROR_Success, 0, 1)
Func _WD_Screenshot($sSession, $sElement = '', $nOutputType = 1)
	Local Const $sFuncName = "_WD_Screenshot"
	Local $sResponse, $sJSON, $sResult, $bDecode
	If $sElement = '' Then
		$sResponse = _WD_Window($sSession, 'Screenshot')
		$sResponse = _WD_ElementAction($sSession, $sElement, 'Screenshot')
		Switch $nOutputType
			Case 1 ; String
				$sResult = BinaryToString(_Base64Decode($sResponse))
			Case 2 ; Binary
				$sResult = _Base64Decode($sResponse)
			Case 3 ; Base64
		$sResult = ''
	Return SetError(__WD_Error($sFuncName, $iErr), 0, $sResult)
Func _WD_jQuerify($sSession)
Local $jQueryLoader = _
"(function(jqueryUrl, callback) {" & _
"    if (typeof jqueryUrl != 'string') {" & _
"        jqueryUrl = 'https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js';" & _
"    }" & _
"    if (typeof jQuery == 'undefined') {" & _
"        var script = document.createElement('script');" & _
"        var head = document.getElementsByTagName('head')[0];" & _
"        var done = false;" & _
"        script.onload = script.onreadystatechange = (function() {" & _
"            if (!done && (!this.readyState || this.readyState == 'loaded' " & _
"                    || this.readyState == 'complete')) {" & _
"                done = true;" & _
"                script.onload = script.onreadystatechange = null;" & _
"                head.removeChild(script);" & _
"                callback();" & _
"            }" & _
"        });" & _
"        script.src = jqueryUrl;" & _
"        head.appendChild(script);" & _
"    else {" & _
"        jQuery.noConflict();" & _
"        callback();" & _
"})(arguments[0], arguments[arguments.length - 1]);"
_WD_ExecuteScript($sSession, $jQueryLoader, "[]", True)
Do
	Sleep(250)
	_WD_ExecuteScript($sSession, "jQuery")
Until @error = $_WD_ERROR_Success
Func _WD_ElementOptionSelect($sSession, $sStrategy, $sSelector, $sStartElement = "")
    Local $sElement = _WD_FindElement($sSession, $sStrategy, $sSelector, $sStartElement)
    If @error = $_WD_ERROR_Success Then
        _WD_ElementAction($sSession, $sElement, 'click')
Func _Base64Decode($input_string)
    Local $struct = DllStructCreate("int")
    $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
            "str", $input_string, _
            "int", 0, _
            "int", 1, _
            "ptr", 0, _
            "ptr", DllStructGetPtr($struct, 1), _
            "ptr", 0)
    If @error Or Not $a_Call[0] Then
        Return SetError(1, 0, "") ; error calculating the length of the buffer needed
    Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
            "ptr", DllStructGetPtr($a), _
        Return SetError(2, 0, ""); error decoding
    Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode
Global $g_vMacro_J3611D687A2E2445F907F05FFD04B3A5DD611C3C6DAB446A4B196B389830541DFA8D8248BB4584FB0AE1CE6BDD0DCE952 = @AutoItExe
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <APIResConstants.au3>
OnAutoItExitRegister(_GDIPlus_Shutdown)
OnAutoItExitRegister(_Resource_DestroyAll)
_GDIPlus_Startup()
Func _Resource_Destroy($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDllOrExePath = Default)
If $iResLang = Default Then $iResLang = 0
If $iResType = Default Then $iResType = $RT_RCDATA
Return __Resource_Storage(9, $sDllOrExePath, Null, $sResNameOrID, $iResType, $iResLang, $iResType, Null)
Func _Resource_DestroyAll()
Return __Resource_Storage(10, Null, Null, Null, Null, Null, Null, Null)
Func _Resource_GetAsBitmap($sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default)
Local $hHBITMAP = 0, $hBitmap = _Resource_GetAsImage($sResNameOrID, $iResType, $sDllOrExePath)
Local $iError = @error
Local $iLength = @extended
If $iError = 0 And $iLength > 0 Then
$hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
If @error Then
$iError = 7
Else
_GDIPlus_BitmapDispose($hBitmap)
$hBitmap = 0
EndIf
If $iError <> 0 Then $hHBITMAP = 0
Return SetError($iError, $iLength, $hHBITMAP)
Func _Resource_GetAsCursor($sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default)
Local $hCursor = __Resource_Get($sResNameOrID, $iResType, 0, $sDllOrExePath, $RT_CURSOR)
If $iError <> 0 Then $hCursor = 0
Return SetError($iError, $iLength, $hCursor)
Func _Resource_GetAsBytes($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDllOrExePath = Default)
Local $pResource = __Resource_Get($sResNameOrID, $iResType, $iResLang, $sDllOrExePath, $RT_RCDATA)
Local $dBytes = Binary(Null)
Local $tBuffer = DllStructCreate('byte array[' & $iLength & ']', $pResource)
$dBytes = DllStructGetData($tBuffer, 'array')
Return SetError($iError, $iLength, $dBytes)
Func _Resource_GetAsIcon($sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default)
Local $hIcon = __Resource_Get($sResNameOrID, $iResType, 0, $sDllOrExePath, $RT_ICON)
If $iError <> 0 Then $hIcon = 0
Return SetError($iError, $iLength, $hIcon)
Func _Resource_GetAsImage($sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default)
Local $iError = 10, $iLength = 0, $hBitmap = 0
Switch $iResType
Case $RT_BITMAP
Local $hHBITMAP = __Resource_Get($sResNameOrID, $RT_BITMAP, 0, $sDllOrExePath, $RT_BITMAP)
$iError = @error
$iLength = @extended
$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBITMAP)
$iError = 10
Case Else
Local $pResource = __Resource_Get($sResNameOrID, $iResType, 0, $sDllOrExePath, $RT_RCDATA)
$hBitmap = __Resource_ConvertToBitmap($pResource, $iLength)
EndSwitch
Return SetError($iError, $iLength, $hBitmap)
Func _Resource_GetAsRaw($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDllOrExePath = Default)
Local $hResource = __Resource_Get($sResNameOrID, $iResType, $iResLang, $sDllOrExePath, $RT_RCDATA)
Return SetError(@error, @extended, $hResource)
Func _Resource_GetAsString($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDllOrExePath = Default)
Local $iError = 12, $iLength = 0, $sString = ''
Case $RT_RCDATA
Local $dBytes = _Resource_GetAsBytes($sResNameOrID, $iResType, $iResLang, $sDllOrExePath)
Local $iStart = 0, $iUTFEncoding = 1
Local $iUTF8 = 3, $iUTF16BE = 2, $iUTF16LE = 2, $iUTF32BE = 4, $iUTF32LE = 4
Select
Case BinaryMid($dBytes, 1, $iUTF32BE) = '0x0000FEFF'
$iStart = $iUTF32BE
$iUTFEncoding = 1
Case BinaryMid($dBytes, 1, $iUTF32LE) = '0xFFFE0000'
$iStart = $iUTF32LE
Case BinaryMid($dBytes, 1, $iUTF16BE) = '0xFEFF'
$iStart = $iUTF16BE
$iUTFEncoding = 3
Case BinaryMid($dBytes, 1, $iUTF16LE) = '0xFFFE'
$iStart = $iUTF16LE
$iUTFEncoding = 2
Case BinaryMid($dBytes, 1, $iUTF8) = '0xEFBBBF'
$iStart = $iUTF8
$iUTFEncoding = 4
EndSelect
$iStart += 1
$iLength = $iLength + 1 - $iStart
$sString = BinaryToString(BinaryMid($dBytes, $iStart), $iUTFEncoding)
$dBytes = 0
Case $RT_STRING
$sString = __Resource_Get($sResNameOrID, $iResType, $iResLang, $sDllOrExePath, $iResType)
Return SetError($iError, $iLength, $sString)
Func _Resource_LoadFont($sResNameOrID, $iResLang = Default, $sDllOrExePath = Default)
Local $pResource = __Resource_Get($sResNameOrID, $RT_FONT, $iResLang, $sDllOrExePath, $RT_FONT)
If $iError = 0 Then
Local $hFont = _WinAPI_AddFontMemResourceEx($pResource, $iLength)
__Resource_Storage(8, $sDllOrExePath, $hFont, $sResNameOrID, 1002, $iResLang, 1002, $iLength)
$hFont = 0
Return SetError($iError, $iLength, $pResource)
Func _Resource_LoadSound($sResNameOrID, $iFlags = $SND_SYNC, $sDllOrExePath = Default)
Local $bIsInternal = False, $bReturn = False
Local $hInstance = __Resource_LoadModule($sDllOrExePath, $bIsInternal)
If Not $hInstance Then Return SetError(11, 0, $bReturn)
Local $dSound = _Resource_GetAsBytes($sResNameOrID)
If Not $iLength Then
$bReturn = _WinAPI_PlaySound($sResNameOrID, BitOR($SND_RESOURCE, $iFlags), $hInstance)
Local $sAlign_Buffer = '00', $sHeader_1 = '0x52494646', $sHeader_2 = '57415645666D74201E0000005500020044AC0000581B0000010000000C00010002000000B600010071056661637404000000640E060064617461'
Local $sMp3 = StringTrimLeft(Binary($dSound), 2)
Local $iMp3Size = StringRegExpReplace(Hex($iLength, 8), '(..)(..)(..)(..)', '$4$3$2$1')
Local $iWavSize = StringRegExpReplace(Hex($iLength + 63, 8), '(..)(..)(..)(..)', '$4$3$2$1')
Local $sHybridWav = $sHeader_1 & $iWavSize & $sHeader_2 & $iMp3Size & $sMp3
If Mod($iMp3Size, 2) Then
$sHybridWav &= $sAlign_Buffer
Local $tWAV = DllStructCreate('byte array[' & BinaryLen($sHybridWav) & ']')
DllStructSetData($tWAV, 'array', $sHybridWav)
$iFlags = BitOR($SND_MEMORY, $SND_NODEFAULT, $iFlags)
$bReturn = _WinAPI_PlaySound(DllStructGetPtr($tWAV), $iFlags, $hInstance)
__Resource_UnloadModule($hInstance, $bIsInternal)
Return $bReturn
Func _Resource_SaveToFile($sFilePath, $sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $bCreatePath = Default, $sDllOrExePath = Default)
Local $bReturn = False, $iCreatePath = (IsBool($bCreatePath) And $bCreatePath ? $FO_CREATEPATH : 0), $iError = 0, $iLength = 0
If $iResType = $RT_BITMAP Then
Local $hImage = _Resource_GetAsImage($sResNameOrID, $iResType)
FileClose(FileOpen($sFilePath, BitOR($FO_OVERWRITE, $FO_BINARY, $iCreatePath)))
$bReturn = _GDIPlus_ImageSaveToFile($hImage, $sFilePath)
_GDIPlus_ImageDispose($hImage)
Local $hFileOpen = FileOpen($sFilePath, BitOR($FO_OVERWRITE, $FO_BINARY, $iCreatePath))
If $hFileOpen > -1 Then
$bReturn = True
FileWrite($hFileOpen, $dBytes)
FileClose($hFileOpen)
Return SetError($iError, $iLength, $bReturn)
Func _Resource_SetBitmapToCtrlID($iCtrlID, $hHBITMAP, $bResize = Default)
Local $bReturn = __Resource_SetToCtrlID($iCtrlID, $hHBITMAP, $RT_BITMAP, False, $bResize)
Return SetError(@error, @extended, $bReturn)
Func _Resource_SetCursorToCtrlID($iCtrlID, $hCursor, $bResize = Default)
Local $bReturn = __Resource_SetToCtrlID($iCtrlID, $hCursor, $RT_CURSOR, False, $bResize)
Func _Resource_SetIconToCtrlID($iCtrlID, $hIcon, $bResize = Default)
Local $bReturn = __Resource_SetToCtrlID($iCtrlID, $hIcon, $RT_ICON, False, $bResize)
Func _Resource_SetImageToCtrlID($iCtrlID, $hBitmap, $bResize = Default)
Local $hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
$hHBITMAP = 0
Func _Resource_SetToCtrlID($iCtrlID, $sResNameOrID, $iResType = $RT_RCDATA, $sDllOrExePath = Default, $bResize = Default)
Local $aWinGetPos = 0, $bDestroy = True, $bReturn = False, $iError = 5, $iLength = 0, $vReturn = False
Local $hWnd = 0
__Resource_GetCtrlId($hWnd, $iCtrlID)
Case $RT_BITMAP, $RT_RCDATA
If StringStripWS($sResNameOrID, $STR_STRIPALL) = '' Or String($sResNameOrID) = '0' Then
$bReturn = __Resource_SetToCtrlID($iCtrlID, 0, $RT_BITMAP, True, False)
Local $hHBITMAP = _Resource_GetAsBitmap($sResNameOrID, $iResType, $sDllOrExePath)
$bReturn = __Resource_SetToCtrlID($iCtrlID, $hHBITMAP, $RT_BITMAP, $bDestroy, $bResize)
If $bReturn Then
If $__WINVER >= 0x0600 Then
$bReturn = _WinAPI_DeleteObject($hHBITMAP) > 0
$vReturn = $bReturn
__Resource_Storage(8, $sDllOrExePath, $hHBITMAP, $sResNameOrID, $iResType, Null, $iResType, $iLength)
$vReturn = $hHBITMAP
Case $RT_CURSOR
$bReturn = __Resource_SetToCtrlID($iCtrlID, 0, $RT_CURSOR, True, False)
$bDestroy = False
Local $hCursor = 0
If $bResize Then
$aWinGetPos = WinGetPos($hWnd)
If Not @error Then
Local $aPos[2]
$aPos[0] = $aWinGetPos[3]
$aPos[1] = $aWinGetPos[2]
If $aPos[0] = 0 And $aPos[1] = 0 Then
GUICtrlSetImage($iCtrlID, $g_vMacro_J3611D687A2E2445F907F05FFD04B3A5DD611C3C6DAB446A4B196B389830541DFA8D8248BB4584FB0AE1CE6BDD0DCE952, 0)
$hCursor = __Resource_Get($sResNameOrID, $RT_CURSOR, 0, $sDllOrExePath, $RT_CURSOR, $aPos)
$hCursor = _Resource_GetAsCursor($sResNameOrID, $iResType, $sDllOrExePath)
$bReturn = __Resource_SetToCtrlID($iCtrlID, $hCursor, $RT_CURSOR, $bDestroy, $bResize)
$hCursor = 0
Case $RT_ICON
$bReturn = __Resource_SetToCtrlID($iCtrlID, 0, $RT_ICON, True, False)
Local $hIcon = 0
$hIcon = __Resource_Get($sResNameOrID, $RT_ICON, 0, $sDllOrExePath, $RT_ICON, $aPos)
$hIcon = _Resource_GetAsIcon($sResNameOrID, $iResType, $sDllOrExePath)
$bReturn = __Resource_SetToCtrlID($iCtrlID, $hIcon, $RT_ICON, $bDestroy, $bResize)
$hIcon = 0
Return SetError($iError, $iLength, $vReturn)
Func __Resource_ConvertToBitmap($pResource, $iLength)
Local $hData = _MemGlobalAlloc($iLength, $GMEM_MOVEABLE)
Local $pData = _MemGlobalLock($hData)
_MemMoveMemory($pResource, $pData, $iLength)
_MemGlobalUnlock($hData)
Local $pStream = _WinAPI_CreateStreamOnHGlobal($hData)
Local $hBitmap = _GDIPlus_BitmapCreateFromStream($pStream)
_WinAPI_ReleaseStream($pStream)
Return $hBitmap
Func __Resource_Destroy($pResource, $iResType)
Local $bReturn = False
Case $RT_ANICURSOR, $RT_CURSOR
$bReturn = _WinAPI_DeleteObject($pResource) > 0
If Not $bReturn Then
$bReturn = _WinAPI_DestroyCursor($pResource) > 0
Case $RT_FONT
$bReturn = _WinAPI_DestroyIcon($pResource) > 0
Case $RT_MENU
$bReturn = _GUICtrlMenu_DestroyMenu($pResource) > 0
Case 1000
$bReturn = _GDIPlus_BitmapDispose($pResource) > 0
Case 1001
$bReturn = _WinAPI_DeleteEnhMetaFile($pResource) > 0
Case 1002
$bReturn = _WinAPI_RemoveFontMemResourceEx($pResource) > 0
If Not IsBool($bReturn) Then $bReturn = $bReturn > 0
Func __Resource_Get($sResNameOrID, $iResType = $RT_RCDATA, $iResLang = Default, $sDllOrExePath = Default, $iCastResType = Default, $aPos = Null)
If $iResType = $RT_RCDATA And StringStripWS($sResNameOrID, $STR_STRIPALL) = '' Then Return SetError(4, 0, Null)
If $iCastResType = Default Then $iCastResType = $iResType
Local $iError = 0, $iLength = 0, $vResource = __Resource_Storage(11, $sDllOrExePath, Null, $sResNameOrID, $iResType, $iResLang, $iCastResType, Null)
If $vResource Then
Return SetError($iError, $iLength, $vResource)
Local $bIsInternal = False
If Not $hInstance Then Return SetError(11, 0, 0)
Local $hResource = (($iResLang <> 0) ? _WinAPI_FindResourceEx($hInstance, $iResType, $sResNameOrID, $iResLang) : _WinAPI_FindResource($hInstance, $iResType, $sResNameOrID))
If @error <> 0 Then $iError = 1
If $aPos = Null Then
Local $aTemp[2] = [0, 0]
$aPos = $aTemp
$aTemp = 0
$aPos[0] = 0
$aPos[1] = 0
$iLength = _WinAPI_SizeOfResource($hInstance, $hResource)
Switch $iCastResType
$vResource = _WinAPI_LoadImage($hInstance, $sResNameOrID, $IMAGE_CURSOR, $aPos[1], $aPos[0], $LR_DEFAULTCOLOR)
If @error <> 0 Or Not $vResource Then $iError = 8
$vResource = _WinAPI_LoadImage($hInstance, $sResNameOrID, $IMAGE_BITMAP, $aPos[1], $aPos[0], $LR_DEFAULTCOLOR)
If @error <> 0 Or Not $vResource Then $iError = 7
$vResource = _WinAPI_LoadImage($hInstance, $sResNameOrID, $IMAGE_ICON, $aPos[1], $aPos[0], $LR_DEFAULTCOLOR)
If @error <> 0 Or Not $vResource Then $iError = 9
$vResource = _WinAPI_LoadString($hInstance, $sResNameOrID)
If @error <> 0 Then $iError = 12
Local $hData = _WinAPI_LoadResource($hInstance, $hResource)
$vResource = _WinAPI_LockResource($hData)
$hData = 0
If Not $vResource Then $iError = 6
__Resource_Storage(8, $sDllOrExePath, $vResource, $sResNameOrID, $iResType, $iResLang, $iCastResType, $iLength)
$vResource = Null
Func __Resource_GetCtrlId(ByRef $hWnd, ByRef $iCtrlID)
If $iCtrlID = Default Or $iCtrlID <= 0 Or Not IsInt($iCtrlID) Then $iCtrlID = -1
$hWnd = GUICtrlGetHandle($iCtrlID)
If $hWnd And $iCtrlID = -1 Then
$iCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
Return True
Func __Resource_GetLastImage($iCtrlID, $hResource, $sClassName, ByRef $hPrevious, ByRef $iPreviousResType)
$hPrevious = 0
$iPreviousResType = 0
Local $aGetImage = 0, $bReturn = True, $iMsg_Get = 0
Switch $sClassName
Case 'Button'
Local $aButton = [[$IMAGE_BITMAP, $RT_BITMAP], [$IMAGE_ICON, $RT_ICON]]
$aGetImage = $aButton
$aButton = 0
$iMsg_Get = $BM_GETIMAGE
Case 'Static'
Local $aStatic = [[$IMAGE_BITMAP, $RT_BITMAP], [$IMAGE_CURSOR, $RT_CURSOR], [$IMAGE_ENHMETAFILE, 1001], [$IMAGE_ICON, $RT_ICON]]
$aGetImage = $aStatic
$aStatic = 0
$iMsg_Get = 0x0173
$bReturn = False
For $i = 0 To UBound($aGetImage) - 1
$hPrevious = GUICtrlSendMsg($iCtrlID, $iMsg_Get, $aGetImage[$i][0], 0)
If $hPrevious <> 0 And $hPrevious <> $hResource Then
$iPreviousResType = $aGetImage[$i][1]
ExitLoop
Next
Func __Resource_LoadModule(ByRef $sDllOrExePath, ByRef $bIsInternal)
$bIsInternal = ($sDllOrExePath = Default Or $sDllOrExePath = -1)
If Not $bIsInternal And Not StringRegExp($sDllOrExePath, '\.(?:cpl|dll|exe)$') Then
$bIsInternal = True
Return ($bIsInternal ? _WinAPI_GetModuleHandle(Null) : _WinAPI_LoadLibraryEx($sDllOrExePath, $LOAD_LIBRARY_AS_DATAFILE))
Func __Resource_UnloadModule(ByRef $hInstance, ByRef $bIsInternal)
Local $bReturn = True
If $bIsInternal And $hInstance Then
$bReturn = _WinAPI_FreeLibrary($hInstance)
Func __Resource_SetToCtrlID($iCtrlID, $hResource, $iResType, $bDestroy, $bResize)
Local $bReturn = False, $iError = 13
$iError = 2
If $hWnd And $iCtrlID > 0 Then
Local $aStyles[0]
$iError = 0
Local $iMsg_Set = 0, $iStyle = 0, $wParam = 0
Local $sClassName = _WinAPI_GetClassName($iCtrlID)
Local $aButtonStyles = [$BS_BITMAP, $BS_ICON]
$aStyles = $aButtonStyles
$aButtonStyles = 0
$iMsg_Set = $BM_SETIMAGE
$iStyle = $BS_BITMAP
$wParam = $IMAGE_BITMAP
$bResize = False
$iStyle = $BS_ICON
$wParam = $IMAGE_ICON
$iError = 5
Local $aStaticStyles = [$SS_BITMAP, $SS_ICON, 0xF]
$aStyles = $aStaticStyles
$aStaticStyles = 0
$iMsg_Set = 0x0172
$iStyle = $SS_BITMAP
$iStyle = $SS_ICON
$wParam = $IMAGE_CURSOR
$iStyle = 0xF
$wParam = $IMAGE_ENHMETAFILE
$iError = 3
Local $iCurrentStyle = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
For $i = 0 To UBound($aStyles) - 1
If BitAND($aStyles[$i], $iCurrentStyle) Then
$iCurrentStyle = BitXOR($iCurrentStyle, $aStyles[$i])
_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($iCurrentStyle, 0x40, $iStyle))
_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($iCurrentStyle, $iStyle))
Local $hPrevious = 0, $iPreviousResType = 0
__Resource_GetLastImage($iCtrlID, $hResource, $sClassName, $hPrevious, $iPreviousResType)
GUICtrlSendMsg($iCtrlID, $iMsg_Set, $wParam, $hResource)
If $iPreviousResType Then
__Resource_Destroy($hPrevious, $iPreviousResType)
__Resource_Storage(9, Null, $hPrevious, Null, Null, Null, Null, Null)
If $bDestroy = Default Or $bDestroy Then
__Resource_Destroy($hResource, $iResType)
__Resource_Storage(9, Null, $hResource, Null, Null, Null, Null, Null)
_WinAPI_InvalidateRect($hWnd, 0, True)
_WinAPI_UpdateWindow($hWnd)
$iError = 13
Return SetError($iError, 0, $bReturn)
Func __Resource_Storage($iAction, $sDllOrExePath, $pResource, $sResNameOrID, $iResType, $iResLang, $iCastResType, $iLength)
Local Static $aStorage[1][7]
Switch $iAction
Case 8
If Not ($aStorage[0][0] = 'CA37F1E6-04D1-11E4-B340-4B0AE3E253B6') Then
$aStorage[0][0] = 'CA37F1E6-04D1-11E4-B340-4B0AE3E253B6'
$aStorage[0][1] = 0
$aStorage[0][2] = 0
$aStorage[0][3] = 1
If Not ($pResource = Null) And Not __Resource_Storage(11, $sDllOrExePath, Null, $sResNameOrID, $iResType, $iResLang, $iCastResType, Null) Then
$aStorage[0][1] += 1
If $aStorage[0][1] >= $aStorage[0][3] Then
$aStorage[0][3] = Ceiling($aStorage[0][1] * 1.3)
ReDim $aStorage[$aStorage[0][3]][7]
$aStorage[$aStorage[0][1]][0] = $sDllOrExePath
$aStorage[$aStorage[0][1]][3] = $pResource
$aStorage[$aStorage[0][1]][4] = $iResLang
$aStorage[$aStorage[0][1]][5] = $sResNameOrID
$aStorage[$aStorage[0][1]][6] = $iResType
$aStorage[$aStorage[0][1]][1] = $iCastResType
$aStorage[$aStorage[0][1]][2] = $iLength
Case 9
Local $iDestoryCount = 0, $iDestoryed = 0
For $i = 1 To $aStorage[0][1]
If Not ($aStorage[$i][3] = Null) Then
If $aStorage[$i][3] = $pResource Or ($aStorage[$i][0] = $sDllOrExePath And $aStorage[$i][5] = $sResNameOrID And $aStorage[$i][6] = $iResType And $aStorage[$i][1] = $iCastResType) Then
$bReturn = __Resource_Storage_Destroy($aStorage, $i)
$iDestoryed += 1
$aStorage[0][2] += 1
$iDestoryCount += 1
$bReturn = $iDestoryCount = $iDestoryed
If $aStorage[0][2] >= 20 Then
Local $iIndex = 0
$iIndex += 1
For $j = 0 To 7 - 1
$aStorage[$iIndex][$j] = $aStorage[$i][$j]
$aStorage[0][1] = $iIndex
$aStorage[0][3] = $iIndex + 1
Case 10
__Resource_Storage_Destroy($aStorage, $i)
Case 11
Local $iExtended = 0, $pReturn = Null
Return SetExtended($iExtended, $pReturn)
Func __Resource_Storage_Destroy(ByRef $aStorage, $iIndex)
If Not ($aStorage[$iIndex][3] = Null) Then
$bReturn = __Resource_Destroy($aStorage[$iIndex][3], $aStorage[$iIndex][6])
$aStorage[$iIndex][3] = Null
$aStorage[$iIndex][4] = Null
$aStorage[$iIndex][5] = Null
$aStorage[$iIndex][6] = Null
__CodeExtractor_ADD_WRAPPER_INFORMATIONS()
Global Const $__CODEEXTRACTOR_CONST_REPLACE_TEXT 	= "[##%R!E)P]L[A(C!E%##]"
Global Const $__OBJECT_ERROR_MANAGER_NO_ERROR_IN_OBJECT__ = "No Error in Object"
Global Const $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT = "[##!R§E$P%L[A%C§E!##]"
Func __CodeExtractor_ADD_WRAPPER_INFORMATIONS()
	#AutoIt3Wrapper_Res_File_Add = $test
	Func _CodeExtractor_SaveSourceToFile($oSelf, $p, $f, $d=1)
		If Not (StringRight($p,1)="\") Then $p &= "\"
		If ($d = 1) Then FileDelete($p&$f)
		FileWrite($p & $f, $oSelf.getSource())
		If @error Then Return $oSelf._setError("Error while creating the file: " & @CRLF & $p & $f, @error, @extended)
		Return 1
	EndFunc
	Func _CodeExtractor_ExtractSource($oSelf, $w = '999');, $RC_DATA = 10)
		If Not @Compiled Then Return $oSelf._setError("To extract the code you have to compile the script first / Otherwise there is nothing to extract.", -1, -1)
		Local $g =  _GetSavedSource(Default)
		Return $oSelf.setSource($g)
	Func _CodeExtractor_SetCurrentFileSavePath($oSelf, $p ) ;entire path
		$oSelf._CodeExtractFilePath = $p
	Func _CodeExtractor_GetCurrentFileSavePath($oSelf)
		Return $oSelf._CodeExtractFilePath
	Func __CodeExtractor_SetFileName($oSelf, $n )
		$oSelf._FileName = $n
	Func __CodeExtractor_GetFileName($oSelf)
		Return $oSelf._FileName
	Func _CodeExtractor_SetCurrentSource($oSelf, $s )
		$oSelf._SourceCode = $s
	Func _CodeExtractor_GetCurrentSource($oSelf)
		Return $oSelf._SourceCode
	Func _CodeExtractor_destroyAll($oSelf)
		Return _Resource_DestroyAll()
	Func _CodeExtractor_SetError($oSelf,$t,$er=@error,$ex=@extended)
		If ($oSelf._errorCount = "") Then $oSelf._errorCount = 0
		If (($er <> 0) Or ($ex <> 0)) Then $oSelf._incError()
		$oSelf._errorText = $t
		$oSelf._errorNum = $er
		$oSelf._errorExt = $ex
		Return $t
	Func _CodeExtractor_GetError($oSelf, $a="", $e= "")
		Local $Error
		$Error = "!+[NO ERROR]" & @CRLF & $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT & @CRLF & "-	text:		" & $__OBJECT_ERROR_MANAGER_NO_ERROR_IN_OBJECT__ & @CRLF & "!+[----------]" & @CRLF & @CRLF
		If (($e <> "") And ($a <> "")) Then
			$Error = StringReplace( $Error, $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT, "-	" & StringLeft($a,10) & ":	[" & $e & "]", 0, 1)
			$Error = StringReplace( $Error, $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT, "", 0, 1)
		If (($oSelf._getErrorNum = "") And ($oSelf._getErrorText() = "") And ($oSelf._getErrorExt() = "")) Then Return $Error
		$Error = "!+[LAST ERROR]" & @CRLF & _
							$__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT & @CRLF & _
							"-	text:		[" 	& $oSelf._getErrorText() & "]"	& 	@CRLF & _
							"-	@error:		[" 	& $oSelf._getErrorNum() & "]"	& 	@CRLF & _
							"-	@extended:	[" 	& $oSelf._getErrorExt() & "]"	&	@CRLF & _
							"-	error count:	[" 	& $oSelf._errorCount & "]"	&	@CRLF & _
							"!+[----------]" & @CRLF & @CRLF
		Local $x
			$Error = StringReplace( $Error, $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT, "-	" & $a & ":	[" & $e & "]", 0, 1)
		Return $Error
	Func _CodeExtractor_GetErrorText($oSelf)
		Return $oSelf._errorText
	Func _CodeExtractor_GetErrorNum($oSelf)
		Return $oSelf._errorNum
	Func _CodeExtractor_GetErrorExt($oSelf)
		Return $oSelf._errorExt
	Func _CodeExtractor_IncError($oSelf)
		$oSelf._errorCount = $oSelf._errorCount + 1
		Return
#include "APIDiagConstants.au3"
#include "StringConstants.au3"
#include "WinAPIFiles.au3"
#include "WinAPIHObj.au3"
#include "WinAPIMem.au3"
#include "WinAPIShellEx.au3"
#include "WinAPITheme.au3"
#Region Global Variables and Constants
Global $__g_hFRDlg = 0, $__g_hFRDll = 0
#EndRegion Global Variables and Constants
#Region Functions list
#EndRegion Functions list
#Region Public Functions
Func _WinAPI_DisplayStruct($tStruct, $sStruct = '', $sTitle = '', $iItem = 0, $iSubItem = 0, $iFlags = 0, $bTop = True, $hParent = 0)
	If Not StringStripWS($sTitle, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTitle = 'Structure: ListView Display'
	$sStruct = StringRegExpReplace(StringStripWS($sStruct, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES), ';+\Z', '')
	Local $pData
	If IsDllStruct($tStruct) Then
		$pData = DllStructGetPtr($tStruct)
		If Not $sStruct Then
			$sStruct = 'byte[' & DllStructGetSize($tStruct) & ']'
			$iFlags = BitOR($iFlags, 64)
		$pData = $tStruct
		If Not $sStruct Then Return SetError(10, 0, 0)
	Local $tData = DllStructCreate($sStruct, $pData)
	Local $iData = DllStructGetSize($tData)
	If (Not BitAND($iFlags, 512)) And (_WinAPI_IsBadReadPtr($pData, $iData)) Then
		If Not BitAND($iFlags, 256) Then
			MsgBox($MB_SYSTEMMODAL, $sTitle, 'The memory range allocated to a given structure could not be read.' & _
					@CRLF & @CRLF & Ptr($pData) & ' - ' & Ptr($pData + $iData - 1) & _
					@CRLF & @CRLF & 'Press OK to exit.')
			Exit -1073741819
		Return SetError(15, 0, 0)
	Local $sOpt1 = Opt('GUIDataSeparatorChar', '|')
	Local $iOpt2 = Opt('GUIOnEventMode', 0)
	Local $iOpt3 = Opt('GUICloseOnESC', 1)
	If $hParent Then
		GUISetState(@SW_DISABLE, $hParent)
	Local $iStyle = 0x00000001
	If $bTop Then
		$iStyle = BitOR($iStyle, 0x00000008)
	$__g_hFRDlg = GUICreate($sTitle, 570, 620, -1, -1, 0x80C70000, $iStyle, $hParent)
	Local $idLV = GUICtrlCreateListView('#|Member|Offset|Type|Size|Value', 0, 0, 570, 620, 0x0000800D, (($__WINVER < 0x0600) ? 0x00010031 : 0x00010030))
	Local $hLV = GUICtrlGetHandle($idLV)
	If $__WINVER >= 0x0600 Then
		_WinAPI_SetWindowTheme($hLV, 'Explorer')
	GUICtrlSetResizing(-1, 0x0066)
	GUICtrlSetFont(-1, 8.5, 400, 0, 'Tahoma')
	GUICtrlSetState(-1, 0x0100)
	Local $aVal[101] = [0]
	If Not BitAND($iFlags, 1) Then
		__Inc($aVal)
		$aVal[$aVal[0]] = ''
		GUICtrlCreateListViewItem('-|-|' & $pData & '|<struct>|0|-', $idLV)
		GUICtrlSetColor(-1, 0x9C9C9C)
	Local $aData = StringSplit($sStruct, ';')
	Local $aItem, $vItem, $sItem, $iMode, $iIndex, $iCount = 0, $iPrev = 0
	Local $aSel[2] = [0, 0]
	Local $aType[28][2] = _
			[['BYTE', 1], _
			['BOOLEAN', 1], _
			['CHAR', 1], _
			['WCHAR', 2], _
			['short', 2], _
			['USHORT', 2], _
			['WORD', 2], _
			['int', 4], _
			['long', 4], _
			['BOOL', 4], _
			['UINT', 4], _
			['ULONG', 4], _
			['DWORD', 4], _
			['INT64', 8], _
			['UINT64', 8], _
			['ptr', (@AutoItX64 ? 8 : 4)], _
			['HWND', (@AutoItX64 ? 8 : 4)], _
			['HANDLE', (@AutoItX64 ? 8 : 4)], _
			['float', 4], _
			['double', 8], _
			['INT_PTR', (@AutoItX64 ? 8 : 4)], _
			['LONG_PTR', (@AutoItX64 ? 8 : 4)], _
			['LRESULT', (@AutoItX64 ? 8 : 4)], _
			['LPARAM', (@AutoItX64 ? 8 : 4)], _
			['UINT_PTR', (@AutoItX64 ? 8 : 4)], _
			['ULONG_PTR', (@AutoItX64 ? 8 : 4)], _
			['DWORD_PTR', (@AutoItX64 ? 8 : 4)], _
			['WPARAM', (@AutoItX64 ? 8 : 4)]]
	For $i = 1 To $aData[0]
		$aItem = StringSplit(StringStripWS($aData[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING), ' ')
		Switch $aItem[1]
			Case 'ALIGN', 'STRUCT', 'ENDSTRUCT'
				ContinueLoop
		$iCount += 1
		$iMode = 1
		$sItem = $iCount & '|'
		If $aItem[0] > 1 Then
			$vItem = StringRegExpReplace($aItem[2], '\[.*\Z', '')
			$sItem &= $vItem & '|'
			If (Not BitAND($iFlags, 16)) And (Not StringCompare(StringRegExpReplace($vItem, '[0-9]+\Z', ''), 'RESERVED')) Then
				$iMode = 0
			If Not IsString($iItem) Then
				$vItem = $iCount
			$iIndex = 2
			If Not BitAND($iFlags, 4) Then
				$sItem &= '<unnamed>|'
				$sItem &= '|'
				$vItem = 0
			$iIndex = 1
		If (Not $aSel[0]) And ($vItem) And ($iItem) And ($vItem = $iItem) Then
			$aSel[0] = $iCount
		Local $iOffset = Number(DllStructGetPtr($tData, $iCount) - $pData)
		$iIndex = StringRegExp($aItem[$iIndex], '\[(\d+)\]', $STR_REGEXPARRAYGLOBALMATCH)
		Local $iSize
			ReDim $aItem[3]
			$vItem = StringRegExpReplace($aItem[1], '\[.*\Z', '')
			For $j = 0 To UBound($aType) - 1
				If Not StringCompare($aType[$j][0], $vItem) Then
					$aItem[1] = $aType[$j][0]
					$aItem[2] = $aType[$j][1]
					$iSize = $aItem[2]
					ExitLoop 2
			$aItem[1] = '?'
			$aItem[2] = '?'
			$iSize = 0
		Until 1
		$sItem &= $iOffset & '|'
		If (IsArray($iIndex)) And ($iIndex[0] > '1') Then
			If $iSize Then
				$aItem[2] = $aItem[2] * $iIndex[0]
			Do
				Switch $aItem[1]
					Case 'BYTE', 'BOOLEAN'
						If Not BitAND($iFlags, 64) Then
							ContinueCase
					Case 'CHAR', 'WCHAR'
						$sItem &= $aItem[1] & '[' & $iIndex[0] & ']|' & $aItem[2] & '|'
						$iIndex = 0
						ExitLoop
				If ($iSize) And ($iMode) Then
					$sItem &= $aItem[1] & '[' & $iIndex[0] & ']|' & $aItem[2] & ' (' & $iSize & ')' & '|'
					$sItem &= $aItem[1] & '[' & $iIndex[0] & ']|' & $aItem[2] & '|'
				If $iMode Then
					$iIndex = $iIndex[0]
					$iIndex = 0
			Until 1
			$sItem &= $aItem[1] & '|' & $aItem[2] & '|'
			$iIndex = 0
		If (Not BitAND($iFlags, 2)) And ($iPrev) And ($iOffset > $iPrev) Then
			__Inc($aVal)
			$aVal[$aVal[0]] = ''
			GUICtrlCreateListViewItem('-|-|-|<alignment>|' & ($iOffset - $iPrev) & '|-', $idLV)
			GUICtrlSetColor(-1, 0xFF0000)
		If $iSize Then
			$iPrev = $iOffset + $aItem[2]
			$iPrev = 0
		Local $idLVItem, $idInit
		If $iIndex Then
			Local $sPattern = '[%0' & StringLen($iIndex) & 'd] '
			For $j = 1 To $iIndex
				__Inc($aVal)
				$aVal[$aVal[0]] = DllStructGetData($tData, $iCount, $j)
				If BitAND($iFlags, 128) Then
					$aVal[$aVal[0]] = __WinAPIDiag_Hex($aVal[$aVal[0]], $aItem[1])
				$idLVItem = GUICtrlCreateListViewItem($sItem & StringFormat($sPattern, $j) & $aVal[$aVal[0]], $idLV)
				If ($aSel[0] = $iCount) And (Not $aSel[1]) Then
					If ($iSubItem < 1) Or ($iSubItem > $iIndex) Or ($iSubItem = $j) Then
						$aSel[1] = $idLVItem
				If (Not $idInit) And ($iCount = 1) Then
					$idInit = $idLVItem
				If Not BitAND($iFlags, 8) Then
					GUICtrlSetBkColor(-1, 0xF5F5F5)
				If $iSize Then
					$sItem = '-|-|' & ($iOffset + $j * $iSize) & '|-|-|'
					GUICtrlSetColor(-1, 0xFF8800)
					$sItem = '-|-|-|-|-|'
			If $iMode Then
				$aVal[$aVal[0]] = DllStructGetData($tData, $iCount)
				$idLVItem = GUICtrlCreateListViewItem($sItem & $aVal[$aVal[0]], $idLV)
				$aVal[$aVal[0]] = ''
				$idLVItem = GUICtrlCreateListViewItem($sItem & '-', $idLV)
			If ($aSel[0] = $iCount) And (Not $aSel[1]) Then
				$aSel[1] = $idLVItem
			If (Not $idInit) And ($iCount = 1) Then
				$idInit = $idLVItem
			If Not $iSize Then
				GUICtrlSetColor(-1, 0xFF8800)
		If (Not BitAND($iFlags, 2)) And (Not $iSize) Then
			GUICtrlCreateListViewItem('-|-|-|<alignment>|?|-', $idLV)
			GUICtrlSetColor(-1, 0xFF8800)
	If (Not BitAND($iFlags, 2)) And ($iPrev) And ($iData > $iPrev) Then
		GUICtrlCreateListViewItem('-|-|-|<alignment>|' & ($iData - $iPrev) & '|-', $idLV)
		GUICtrlSetColor(-1, 0xFF0000)
		GUICtrlCreateListViewItem('-|-|' & ($pData + $iData - 0) & '|<endstruct>|' & $iData & '|-', $idLV)
	If $aSel[1] Then
		GUICtrlSetState($aSel[1], 0x0100)
		GUICtrlSetState($idInit, 0x0100)
	Local $idDummy = GUICtrlCreateDummy()
	Local $aWidth[6] = [30, 130, 76, 100, 50, 167]
	For $i = 0 To UBound($aWidth) - 1
		GUICtrlSendMsg($idLV, 0x101E, $i, $aWidth[$i])
	Local $tParam = DllStructCreate('ptr;uint')
	DllStructSetData($tParam, 1, $hLV)
	If Not BitAND($iFlags, 32) Then
		DllStructSetData($tParam, 2, $idDummy)
		DllStructSetData($tParam, 2, 0)
	$__g_hFRDll = DllCallbackRegister('__DlgSubclassProc', 'lresult', 'hwnd;uint;wparam;lparam;uint;ptr')
	Local $pDll = DllCallbackGetPtr($__g_hFRDll)
	If _WinAPI_SetWindowSubclass($__g_hFRDlg, $pDll, 1000, DllStructGetPtr($tParam)) Then
		OnAutoItExitRegister('__WinAPIDiag_Quit')
		DllCallbackFree($__g_hFRDll)
		$__g_hFRDll = 0
	GUISetState()
		Switch GUIGetMsg()
			Case -3
			Case $idDummy
				$iIndex = GUICtrlRead($idDummy)
				If ($iIndex >= 0) And ($iIndex < $aVal[0]) Then
					ClipPut($aVal[$iIndex + 1])
	If $__g_hFRDll Then
		OnAutoItExitUnRegister('__WinAPIDiag_Quit')
	__WinAPIDiag_Quit()
		GUISetState(@SW_ENABLE, $hParent)
	GUIDelete($__g_hFRDlg)
	Opt('GUIDataSeparatorChar', $sOpt1)
	Opt('GUIOnEventMode', $iOpt2)
	Opt('GUICloseOnESC', $iOpt3)
EndFunc   ;==>_WinAPI_DisplayStruct
Func _WinAPI_EnumDllProc($sFilePath, $sMask = '', $iFlags = 0)
	If Not __DLL('dbghelp.dll') Then Return SetError(103, 0, 0)
	Local $vVer = __WinAPIDiag_Ver('dbghelp.dll')
	If $vVer < 0x0501 Then Return SetError(2, 0, 0)
	$__g_vEnum = 0
	Local $iPE, $aRet, $iError = 0, $hLibrary = 0, $vWOW64 = Default
	If _WinAPI_IsWow64Process() Then
		$aRet = DllCall('kernel32.dll', 'bool', 'Wow64DisableWow64FsRedirection', 'ptr*', 0)
		If Not @error And $aRet[0] Then $vWOW64 = $aRet[1]
	Do
		$aRet = DllCall('kernel32.dll', 'dword', 'SearchPathW', 'ptr', 0, 'wstr', $sFilePath, 'ptr', 0, 'dword', 4096, 'wstr', '', 'ptr', 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 10
		$__g_vExt = $aRet[5]
		$iPE = _WinAPI_GetPEType($__g_vExt)
		Switch $iPE
			Case 0x014C
			Case 0x0200, 0x8664
				$iError = @error + 20
		$hLibrary = _WinAPI_LoadLibraryEx($__g_vExt, 0x00000003)
		If Not $hLibrary Then
			$iError = @error + 30
		If $vVer >= 0x0600 Then
			__EnumDllProcW($hLibrary, $sMask, $iFlags)
			__EnumDllProcA($hLibrary, $sMask, $iFlags)
			$iError = @error + 40
	Until 1
	If $hLibrary Then
		_WinAPI_FreeLibrary($hLibrary)
	If Not ($vWOW64 = Default) Then
		DllCall('kernel32.dll', 'bool', 'Wow64RevertWow64FsRedirection', 'ptr*', $vWOW64)
	Return SetError($iError, $iPE, $__g_vEnum)
EndFunc   ;==>_WinAPI_EnumDllProc
Func _WinAPI_GetApplicationRestartSettings($iPID = 0)
	If Not $iPID Then $iPID = @AutoItPID
	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000410 : 0x00001010), _
			'bool', 0, 'dword', $iPID)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, 0)
	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetApplicationRestartSettings', 'handle', $hProcess[0], 'wstr', '', _
			'dword*', 4096, 'dword*', 0)
	Local $iError, $iExtended = @extended
		$iError = @error
	ElseIf $aRet[0] Then
		$iError = 10
		$iExtended = $aRet[0]
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess[0])
	If $iError Then Return SetError($iError, $iExtended, 0)
	Local $aResult[2]
	$aResult[0] = $aRet[2]
	$aResult[1] = $aRet[4]
	Return $aResult
EndFunc   ;==>_WinAPI_GetApplicationRestartSettings
Func _WinAPI_GetErrorMode()
	Local $aRet = DllCall('kernel32.dll', 'uint', 'GetErrorMode')
	If @error Then Return SetError(@error, @extended, 0)
	Return $aRet[0]
EndFunc   ;==>_WinAPI_GetErrorMode
Func _WinAPI_FatalExit($iCode)
	DllCall('kernel32.dll', 'none', 'FatalExit', 'int', $iCode)
	If @error Then Return SetError(@error, @extended)
EndFunc   ;==>_WinAPI_FatalExit
Func _WinAPI_IsInternetConnected()
	If Not __DLL('connect.dll') Then Return SetError(103, 0, 0)
	Local $aRet = DllCall('connect.dll', 'long', 'IsInternetConnected')
	If Not ($aRet[0] = 0 Or $aRet[0] = 1) Then ; not S_OK nor S_FALSE
		Return SetError(10, $aRet[0], False)
	Return Not $aRet[0]
EndFunc   ;==>_WinAPI_IsInternetConnected
Func _WinAPI_IsNetworkAlive()
	If Not __DLL('sensapi.dll') Then Return SetError(103, 0, 0)
	Local $aRet = DllCall('sensapi.dll', 'bool', 'IsNetworkAlive', 'int*', 0)
	Local $iLastError = _WinAPI_GetLastError()
	If $iLastError Then Return SetError(1, $iLastError, 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, $iLastError, 0)
	Return $aRet[1]
EndFunc   ;==>_WinAPI_IsNetworkAlive
Func _WinAPI_NtStatusToDosError($iStatus)
	Local $aRet = DllCall('ntdll.dll', 'ulong', 'RtlNtStatusToDosError', 'long', $iStatus)
EndFunc   ;==>_WinAPI_NtStatusToDosError
Func _WinAPI_RegisterApplicationRestart($iFlags = 0, $sCmd = '')
	Local $aRet = DllCall('kernel32.dll', 'long', 'RegisterApplicationRestart', 'wstr', $sCmd, 'dword', $iFlags)
	If $aRet[0] Then Return SetError(10, $aRet[0], 0)
EndFunc   ;==>_WinAPI_RegisterApplicationRestart
Func _WinAPI_SetErrorMode($iMode)
	Local $aRet = DllCall('kernel32.dll', 'uint', 'SetErrorMode', 'uint', $iMode)
EndFunc   ;==>_WinAPI_SetErrorMode
Func _WinAPI_UniqueHardwareID($iFlags = 0)
	Local $oService = ObjGet('winmgmts:\\.\root\cimv2')
	If Not IsObj($oService) Then Return SetError(1, 0, '')
	Local $oItems = $oService.ExecQuery('SELECT * FROM Win32_ComputerSystemProduct')
	If Not IsObj($oItems) Then Return SetError(2, 0, '')
	Local $sHw = '', $iExtended = 0
	For $oProperty In $oItems
		$sHw &= $oProperty.IdentifyingNumber
		$sHw &= $oProperty.Name
		$sHw &= $oProperty.SKUNumber
		$sHw &= $oProperty.UUID
		$sHw &= $oProperty.Vendor
		$sHw &= $oProperty.Version
	$sHw = StringStripWS($sHw, $STR_STRIPALL)
	If Not $sHw Then Return SetError(3, 0, '')
	Local $sText
	If BitAND($iFlags, 0x0001) Then
		$oItems = $oService.ExecQuery('SELECT * FROM Win32_BIOS')
		If Not IsObj($oItems) Then Return SetError(3, 0, '')
		$sText = ''
		For $oProperty In $oItems
			$sText &= $oProperty.IdentificationCode
			$sText &= $oProperty.Manufacturer
			$sText &= $oProperty.Name
			$sText &= $oProperty.SerialNumber
			$sText &= $oProperty.SMBIOSMajorVersion
			$sText &= $oProperty.SMBIOSMinorVersion
		$sText = StringStripWS($sText, $STR_STRIPALL)
		If $sText Then
			$iExtended += 0x0001
			$sHw &= $sText
	If BitAND($iFlags, 0x0002) Then
		$oItems = $oService.ExecQuery('SELECT * FROM Win32_Processor')
		If Not IsObj($oItems) Then Return SetError(4, 0, '')
			$sText &= $oProperty.Architecture
			$sText &= $oProperty.Family
			$sText &= $oProperty.Level
			$sText &= $oProperty.ProcessorId
			$sText &= $oProperty.Revision
			$sText &= $oProperty.Version
			$iExtended += 0x0002
	If BitAND($iFlags, 0x0004) Then
		$oItems = $oService.ExecQuery('SELECT * FROM Win32_PhysicalMedia')
		If Not IsObj($oItems) Then Return SetError(5, 0, '')
			Switch _WinAPI_GetDriveBusType($oProperty.Tag)
				Case 0x03, 0x0B
					$sText &= $oProperty.SerialNumber
				Case Else
			$iExtended += 0x0004
	Local $sHash = __WinAPIDiag_MD5($sHw)
	If Not $sHash Then Return SetError(6, 0, '')
	Return SetExtended($iExtended, '{' & StringMid($sHash, 1, 8) & '-' & StringMid($sHash, 9, 4) & '-' & StringMid($sHash, 13, 4) & '-' & StringMid($sHash, 17, 4) & '-' & StringMid($sHash, 21, 12) & '}')
EndFunc   ;==>_WinAPI_UniqueHardwareID
Func _WinAPI_UnregisterApplicationRestart()
	Local $aRet = DllCall('kernel32.dll', 'long', 'UnregisterApplicationRestart')
EndFunc   ;==>_WinAPI_UnregisterApplicationRestart
#EndRegion Public Functions
#Region Internal Functions
Func __DlgSubclassProc($sHwnd, $iMsg, $wParam, $lParam, $idLV, $pData)
	#forceref $idLV
	Switch $iMsg
		Case 0x004E ; WM_NOTIFY
			Local $tNMIA = DllStructCreate('hwnd;uint_ptr;' & (@AutoItX64 ? 'int;int' : 'int') & ';int Item;int;uint;uint;uint;long;long;lparam;uint', $lParam)
			Local $hListView = DllStructGetData($tNMIA, 1)
			Local $nMsg = DllStructGetData($tNMIA, 3)
			Local $tParam = DllStructCreate('ptr;uint', $pData)
			Local $iDummy = DllStructGetData($tParam, 2)
			Local $hLV = DllStructGetData($tParam, 1)
			Switch $hListView
				Case $hLV
					Switch $nMsg
						Case -109 ; LVN_BEGINDRAG
							Return 0
						Case -114 ; LVN_ITEMACTIVATE
							If $iDummy Then
								GUICtrlSendToDummy($iDummy, DllStructGetData($tNMIA, 'Item'))
					EndSwitch
	Return _WinAPI_DefSubclassProc($sHwnd, $iMsg, $wParam, $lParam)
EndFunc   ;==>__DlgSubclassProc
Func __EnumDllProcA($hLibrary, $sMask, $iFlags)
	Local $hProcess, $pAddress = 0, $iInit = 0, $vOpts = Default, $iError = 0
	Local $sTypeOfMask = 'str'
		Local $aRet = DllCall('dbghelp.dll', 'dword', 'SymGetOptions')
		$vOpts = $aRet[0]
		$aRet = DllCall('dbghelp.dll', 'dword', 'SymSetOptions', 'dword', BitOR(BitAND($iFlags, 0x00000003), 0x00000204))
			$iError = @error + 20
		$hProcess = _WinAPI_GetCurrentProcess()
		$aRet = DllCall('dbghelp.dll', 'int', 'SymInitialize', 'handle', $hProcess, 'ptr', 0, 'int', 1)
		$iInit = 1
		$aRet = DllCall('dbghelp.dll', 'uint64', 'SymLoadModule64', 'handle', $hProcess, 'ptr', 0, 'str', $__g_vExt, 'ptr', 0, 'uint64', $hLibrary, 'dword', 0)
		$pAddress = $aRet[0]
		Dim $__g_vEnum[501][2] = [[0]]
		Local $hEnumProc = DllCallbackRegister('__EnumSymbolsProcA', 'int', 'ptr;ulong;lparam')
		Local $pEnumProc = DllCallbackGetPtr($hEnumProc)
		If Not StringStripWS($sMask, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$sTypeOfMask = 'ptr'
			$sMask = 0
		$aRet = DllCall('dbghelp.dll', 'int', 'SymEnumSymbols', 'handle', $hProcess, 'uint64', $pAddress, $sTypeOfMask, $sMask, 'ptr', $pEnumProc, 'lparam', 0)
		If @error Or Not $aRet[0] Or (Not $__g_vEnum[0][0]) Then
			$iError = @error + 50
			$__g_vEnum = 0
		DllCallbackFree($hEnumProc)
		If IsArray($__g_vEnum) Then
			__Inc($__g_vEnum, -1)
	If $pAddress Then
		DllCall('dbghelp.dll', 'int', 'SymUnloadModule64', 'handle', $hProcess, 'uint64', $pAddress)
	If $iInit Then
		DllCall('dbghelp.dll', 'int', 'SymCleanup', 'handle', $hProcess)
	If Not ($vOpts = Default) Then
		DllCall('dbghelp.dll', 'dword', 'SymSetOptions', 'dword', $vOpts)
	If $iError Then Return SetError($iError, 0, 0)
EndFunc   ;==>__EnumDllProcA
Func __EnumDllProcW($hLibrary, $sMask, $iFlags)
	Local $sTypeOfMask = 'wstr'
		$aRet = DllCall('dbghelp.dll', 'int', 'SymInitializeW', 'handle', $hProcess, 'ptr', 0, 'int', 1)
		$aRet = DllCall('dbghelp.dll', 'uint64', 'SymLoadModuleExW', 'handle', $hProcess, 'ptr', 0, 'wstr', $__g_vExt, 'ptr', 0, 'uint64', $hLibrary, 'dword', 0, 'ptr', 0, 'dword', 0)
		Local $hEnumProc = DllCallbackRegister('__EnumSymbolsProcW', 'int', 'ptr;ulong;lparam')
		$aRet = DllCall('dbghelp.dll', 'int', 'SymEnumSymbolsW', 'handle', $hProcess, 'uint64', $pAddress, $sTypeOfMask, $sMask, 'ptr', $pEnumProc, 'lparam', 0)
		If @error Or Not $aRet[0] Or Not $__g_vEnum[0][0] Then
EndFunc   ;==>__EnumDllProcW
Func __EnumSymbolsProcA($pSymInfo, $iSymSize, $lParam)
	#forceref $iSymSize, $lParam
	Local $tagSYMBOL_INFO = 'uint SizeOfStruct;uint TypeIndex;uint64 Reserved[2];uint Index;uint Size;uint64 ModBase;uint Flags;uint64 Value;uint64 Address;uint Register;uint Scope;uint Tag;uint NameLen;uint MaxNameLen;wchar Name[1]'
	Local $tSYMINFO = DllStructCreate($tagSYMBOL_INFO, $pSymInfo)
	Local $iLength = DllStructGetData($tSYMINFO, 'NameLen')
	If $iLength And BitAND(DllStructGetData($tSYMINFO, 'Flags'), 0x00000600) Then
		__Inc($__g_vEnum, 500)
		$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData($tSYMINFO, 'Address') - DllStructGetData($tSYMINFO, 'ModBase')
		$__g_vEnum[$__g_vEnum[0][0]][1] = DllStructGetData(DllStructCreate('char[' & ($iLength + 1) & ']', DllStructGetPtr($tSYMINFO, 'Name')), 1)
EndFunc   ;==>__EnumSymbolsProcA
Func __EnumSymbolsProcW($pSymInfo, $iSymSize, $lParam)
		$__g_vEnum[$__g_vEnum[0][0]][1] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', DllStructGetPtr($tSYMINFO, 'Name')), 1)
EndFunc   ;==>__EnumSymbolsProcW
Func __WinAPIDiag_Hex($iValue, $sType)
	Local $iLength
	Switch $sType
		Case 'BYTE', 'BOOLEAN'
			$iLength = 2
		Case 'WORD', 'USHORT', 'short'
			$iLength = 4
		Case 'BOOL', 'UINT', 'ULONG', 'DWORD', 'int', 'long'
			$iLength = 8
		Case 'INT64', 'UINT64'
			$iLength = 16
		Case 'INT_PTR', 'UINT_PTR', 'LONG_PTR', 'ULONG_PTR', 'DWORD_PTR', 'WPARAM', 'LPARAM', 'LRESULT'
			$iLength = (@AutoItX64 ? 16 : 8)
			$iLength = 0
	If $iLength Then
		Return '0x' & Hex($iValue, $iLength)
		Return $iValue
EndFunc   ;==>__WinAPIDiag_Hex
Func __WinAPIDiag_MD5($sData)
	Local $hHash, $iError = 0
	Local $hProv = DllCall('advapi32.dll', 'int', 'CryptAcquireContextW', 'ptr*', 0, 'ptr', 0, 'ptr', 0, 'dword', 3, 'dword', 0xF0000000)
	If @error Or Not $hProv[0] Then Return SetError(@error + 10, @extended, '')
		$hHash = DllCall('advapi32.dll', 'int', 'CryptCreateHash', 'handle', $hProv[1], 'uint', 0x00008003, 'ptr', 0, 'dword', 0, _
				'ptr*', 0)
		If @error Or Not $hHash[0] Then
			$hHash = 0
		$hHash = $hHash[5]
		Local $tData = DllStructCreate('byte[' & BinaryLen($sData) & ']')
		DllStructSetData($tData, 1, $sData)
		Local $aRet = DllCall('advapi32.dll', 'int', 'CryptHashData', 'handle', $hHash, 'struct*', $tData, _
				'dword', DllStructGetSize($tData), 'dword', 1)
		$tData = DllStructCreate('byte[16]')
		$aRet = DllCall('advapi32.dll', 'int', 'CryptGetHashParam', 'handle', $hHash, 'dword', 2, 'struct*', $tData, 'dword*', 16, _
				'dword', 0)
	If $hHash Then
		DllCall('advapi32.dll', 'int', 'CryptDestroyHash', 'handle', $hHash)
	If $iError Then Return SetError($iError, 0, '')
	Return StringTrimLeft(DllStructGetData($tData, 1), 2)
EndFunc   ;==>__WinAPIDiag_MD5
Func __WinAPIDiag_Quit()
	If $pDll Then
		_WinAPI_RemoveWindowSubclass($__g_hFRDlg, $pDll, 1000)
	$__g_hFRDll = 0
EndFunc   ;==>__WinAPIDiag_Quit
Func __WinAPIDiag_Ver($sPath)
	Local $hLibrary = _WinAPI_GetModuleHandle($sPath)
	If Not $hLibrary Then Return SetError(@error + 10, @extended, 0)
	$sPath = _WinAPI_GetModuleFileNameEx(_WinAPI_GetCurrentProcess(), $hLibrary)
	If Not $sPath Then Return SetError(@error + 20, @extended, 0)
	Local $vVer = FileGetVersion($sPath)
	$vVer = StringSplit($vVer, '.', $STR_NOCOUNT)
	If UBound($vVer) < 2 Then Return SetError(2, 0, 0)
	Return BitOR(BitShift(Number($vVer[0]), -8), Number($vVer[1]))
EndFunc   ;==>__WinAPIDiag_Ver
#EndRegion Internal Functions
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $CLR_INVALID = -1
Global Const $MB_PRECOMPOSED = 0x01
Global Const $MB_COMPOSITE = 0x02
Global Const $MB_USEGLYPHCHARS = 0x04
Global Const $ULW_ALPHA = 0x02
Global Const $ULW_COLORKEY = 0x01
Global Const $ULW_OPAQUE = 0x04
Global Const $ULW_EX_NORESIZE = 0x08
Global Const $WH_CALLWNDPROC = 4
Global Const $WH_CALLWNDPROCRET = 12
Global Const $WH_CBT = 5
Global Const $WH_DEBUG = 9
Global Const $WH_FOREGROUNDIDLE = 11
Global Const $WH_GETMESSAGE = 3
Global Const $WH_JOURNALPLAYBACK = 1
Global Const $WH_JOURNALRECORD = 0
Global Const $WH_KEYBOARD = 2
Global Const $WH_KEYBOARD_LL = 13
Global Const $WH_MOUSE = 7
Global Const $WH_MOUSE_LL = 14
Global Const $WH_MSGFILTER = -1
Global Const $WH_SHELL = 10
Global Const $WH_SYSMSGFILTER = 6
Global Const $WPF_ASYNCWINDOWPLACEMENT = 0x04
Global Const $WPF_RESTORETOMAXIMIZED = 0x02
Global Const $WPF_SETMINPOSITION = 0x01
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_INJECTED = 0x10
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Global Const $OFN_ALLOWMULTISELECT = 0x00000200
Global Const $OFN_CREATEPROMPT = 0x00002000
Global Const $OFN_DONTADDTORECENT = 0x02000000
Global Const $OFN_ENABLEHOOK = 0x00000020
Global Const $OFN_ENABLEINCLUDENOTIFY = 0x00400000
Global Const $OFN_ENABLESIZING = 0x00800000
Global Const $OFN_ENABLETEMPLATE = 0x00000040
Global Const $OFN_ENABLETEMPLATEHANDLE = 0x00000080
Global Const $OFN_EXPLORER = 0x00080000
Global Const $OFN_EXTENSIONDIFFERENT = 0x00000400
Global Const $OFN_FILEMUSTEXIST = 0x00001000
Global Const $OFN_FORCESHOWHIDDEN = 0x10000000
Global Const $OFN_HIDEREADONLY = 0x00000004
Global Const $OFN_LONGNAMES = 0x00200000
Global Const $OFN_NOCHANGEDIR = 0x00000008
Global Const $OFN_NODEREFERENCELINKS = 0x00100000
Global Const $OFN_NOLONGNAMES = 0x00040000
Global Const $OFN_NONETWORKBUTTON = 0x00020000
Global Const $OFN_NOREADONLYRETURN = 0x00008000
Global Const $OFN_NOTESTFILECREATE = 0x00010000
Global Const $OFN_NOVALIDATE = 0x00000100
Global Const $OFN_OVERWRITEPROMPT = 0x00000002
Global Const $OFN_PATHMUSTEXIST = 0x00000800
Global Const $OFN_READONLY = 0x00000001
Global Const $OFN_SHAREAWARE = 0x00004000
Global Const $OFN_SHOWHELP = 0x00000010
Global Const $OFN_EX_NOPLACESBAR = 0x00000001
Global Const $STD_CUT = 0
Global Const $STD_COPY = 1
Global Const $STD_PASTE = 2
Global Const $STD_UNDO = 3
Global Const $STD_REDOW = 4
Global Const $STD_DELETE = 5
Global Const $STD_FILENEW = 6
Global Const $STD_FILEOPEN = 7
Global Const $STD_FILESAVE = 8
Global Const $STD_PRINTPRE = 9
Global Const $STD_PROPERTIES = 10
Global Const $STD_HELP = 11
Global Const $STD_FIND = 12
Global Const $STD_REPLACE = 13
Global Const $STD_PRINT = 14
Global Const $KB_SENDSPECIAL = 0 ; Special characters indicate key presses (default)
Global Const $KB_SENDRAW = 1 ; Keys are sent raw
Global Const $KB_CAPSOFF = 0 ; Caps Lock is off
Global Const $KB_CAPSON = 1 ; Caps Lock is on
Global Const $S_OK = 0x00000000
Global Const $E_ABORT = 0x80004004
Global Const $E_ACCESSDENIED = 0x80070005
Global Const $E_FAIL = 0x80004005
Global Const $E_HANDLE = 0x80070006
Global Const $E_INVALIDARG = 0x80070057
Global Const $E_NOINTERFACE = 0x80004002
Global Const $E_NOTIMPL = 0x80004001
Global Const $E_OUTOFMEMORY = 0x8007000E
Global Const $E_POINTER = 0x80004003
Global Const $E_UNEXPECTED = 0x8000FFFF
#include "APIProcConstants.au3"
#include "Security.au3"
#include "SecurityConstants.au3"
#include "WinAPICom.au3"
#include "WinAPIError.au3"
#include "WinAPIShPath.au3"
Global Const $tagIO_COUNTERS = 'struct;uint64 ReadOperationCount;uint64 WriteOperationCount;uint64 OtherOperationCount;uint64 ReadTransferCount;uint64 WriteTransferCount;uint64 OtherTransferCount;endstruct'
Global Const $tagJOBOBJECT_ASSOCIATE_COMPLETION_PORT = 'ulong_ptr CompletionKey;ptr CompletionPort'
Global Const $tagJOBOBJECT_BASIC_ACCOUNTING_INFORMATION = 'struct;int64 TotalUserTime;int64 TotalKernelTime;int64 ThisPeriodTotalUserTime;int64 ThisPeriodTotalKernelTime;dword TotalPageFaultCount;dword TotalProcesses;dword ActiveProcesses;dword TotalTerminatedProcesses;endstruct'
Global Const $tagJOBOBJECT_BASIC_AND_IO_ACCOUNTING_INFORMATION = $tagJOBOBJECT_BASIC_ACCOUNTING_INFORMATION & ';' & $tagIO_COUNTERS
Global Const $tagJOBOBJECT_BASIC_LIMIT_INFORMATION = 'struct;int64 PerProcessUserTimeLimit;int64 PerJobUserTimeLimit;dword LimitFlags;ulong_ptr MinimumWorkingSetSize;ulong_ptr MaximumWorkingSetSize;dword ActiveProcessLimit;ulong_ptr Affinity;dword PriorityClass;dword SchedulingClass;endstruct'
Global Const $tagJOBOBJECT_BASIC_PROCESS_ID_LIST = 'dword NumberOfAssignedProcesses;dword NumberOfProcessIdsInList' ; & ';ulong_ptr ProcessIdList[n]'
Global Const $tagJOBOBJECT_BASIC_UI_RESTRICTIONS = 'dword UIRestrictionsClass'
Global Const $tagJOBOBJECT_END_OF_JOB_TIME_INFORMATION = 'dword EndOfJobTimeAction'
Global Const $tagJOBOBJECT_EXTENDED_LIMIT_INFORMATION = $tagJOBOBJECT_BASIC_LIMIT_INFORMATION & ';' & $tagIO_COUNTERS & ';ulong_ptr ProcessMemoryLimit;ulong_ptr JobMemoryLimit;ulong_ptr PeakProcessMemoryUsed;ulong_ptr PeakJobMemoryUsed'
Global Const $tagJOBOBJECT_GROUP_INFORMATION = '' ; & 'ushort ProcessorGroup[n]'
Global Const $tagJOBOBJECT_SECURITY_LIMIT_INFORMATION = 'dword SecurityLimitFlags;ptr JobToken;ptr SidsToDisable;ptr PrivilegesToDelete;ptr RestrictedSids'
Global Const $tagMODULEINFO = 'ptr BaseOfDll;dword SizeOfImage;ptr EntryPoint'
Global Const $tagPROCESSENTRY32 = 'dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]'
Func _WinAPI_AdjustTokenPrivileges($hToken, $aPrivileges, $iAttributes, ByRef $aAdjust)
	$aAdjust = 0
	If Not $aPrivileges And IsNumber($aPrivileges) Then Return 0
	Local $tTP1 = 0, $tTP2, $iCount, $aRet, $bDisable = False
	If $aPrivileges = -1 Then
		$tTP2 = DllStructCreate('dword')
		$aRet = DllCall('advapi32.dll', 'bool', 'AdjustTokenPrivileges', 'handle', $hToken, 'bool', 1, 'ptr', 0, _
				'dword', 0, 'struct*', $tTP2, 'dword*', 0)
		If @error Then Return SetError(@error, @extended, 0)
		Local $iLastError = _WinAPI_GetLastError()
		Switch $iLastError
			Case 122 ; ERROR_INSUFFICIENT_BUFFER
				$tTP2 = DllStructCreate('dword;dword[' & ($aRet[6] / 4 - 1) & ']')
				If @error Then
					ContinueCase
				Return SetError(10, $iLastError, 0)
		$bDisable = True
		Local $aPrev = 0
		If Not IsArray($aPrivileges) Then
			Dim $aPrev[1][2]
			$aPrev[0][0] = $aPrivileges
			$aPrev[0][1] = $iAttributes
			If Not UBound($aPrivileges, $UBOUND_COLUMNS) Then
				$iCount = UBound($aPrivileges)
				Dim $aPrev[$iCount][2]
				For $i = 0 To $iCount - 1
					$aPrev[$i][0] = $aPrivileges[$i]
					$aPrev[$i][1] = $iAttributes
		If IsArray($aPrev) Then
			$aPrivileges = $aPrev
		Local $tagStruct = 'dword;dword[' & (3 * UBound($aPrivileges)) & ']'
		$tTP1 = DllStructCreate($tagStruct)
		$tTP2 = DllStructCreate($tagStruct)
		If @error Then Return SetError(@error + 20, 0, 0)
		DllStructSetData($tTP1, 1, UBound($aPrivileges))
		For $i = 0 To UBound($aPrivileges) - 1
			DllStructSetData($tTP1, 2, $aPrivileges[$i][1], 3 * $i + 3)
			$aRet = DllCall('advapi32.dll', 'bool', 'LookupPrivilegeValueW', 'ptr', 0, 'wstr', $aPrivileges[$i][0], _
					'ptr', DllStructGetPtr($tTP1, 2) + 12 * $i)
			If @error Or Not $aRet[0] Then Return SetError(@error + 100, @extended, 0)
	$aRet = DllCall('advapi32.dll', 'bool', 'AdjustTokenPrivileges', 'handle', $hToken, 'bool', $bDisable, _
			'struct*', $tTP1, 'dword', DllStructGetSize($tTP2), 'struct*', $tTP2, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 200, @extended, 0)
	Local $iResult
	Switch _WinAPI_GetLastError()
		Case 1300 ; ERROR_NOT_ALL_ASSIGNED
			$iResult = 1
			$iResult = 0
	$iCount = DllStructGetData($tTP2, 1)
	If $iCount Then
		Local $tData = DllStructCreate('wchar[128]')
		Dim $aPrivileges[$iCount][2]
		For $i = 0 To $iCount - 1
			$aRet = DllCall('advapi32.dll', 'bool', 'LookupPrivilegeNameW', 'ptr', 0, _
					'ptr', DllStructGetPtr($tTP2, 2) + 12 * $i, 'struct*', $tData, 'dword*', 128)
			If @error Or Not $aRet[0] Then Return SetError(@error + 300, @extended, 0)
			$aPrivileges[$i][1] = DllStructGetData($tTP2, 2, 3 * $i + 3)
			$aPrivileges[$i][0] = DllStructGetData($tData, 1)
		$aAdjust = $aPrivileges
	Return SetExtended($iResult, 1)
EndFunc   ;==>_WinAPI_AdjustTokenPrivileges
Func _WinAPI_AssignProcessToJobObject($hJob, $hProcess)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'AssignProcessToJobObject', 'handle', $hJob, 'handle', $hProcess)
	If @error Then Return SetError(@error, @extended, False)
EndFunc   ;==>_WinAPI_AssignProcessToJobObject
Func _WinAPI_AttachConsole($iPID = -1)
	Local $aResult = DllCall("kernel32.dll", "bool", "AttachConsole", "dword", $iPID)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_AttachConsole
Func _WinAPI_AttachThreadInput($iAttach, $iAttachTo, $bAttach)
	Local $aResult = DllCall("user32.dll", "bool", "AttachThreadInput", "dword", $iAttach, "dword", $iAttachTo, "bool", $bAttach)
EndFunc   ;==>_WinAPI_AttachThreadInput
Func _WinAPI_CreateEvent($tAttributes = 0, $bManualReset = True, $bInitialState = True, $sName = "")
	Local $sNameType = "wstr"
	If $sName = "" Then
		$sName = 0
		$sNameType = "ptr"
	Local $aResult = DllCall("kernel32.dll", "handle", "CreateEventW", "struct*", $tAttributes, "bool", $bManualReset, _
			"bool", $bInitialState, $sNameType, $sName)
EndFunc   ;==>_WinAPI_CreateEvent
Func _WinAPI_CreateJobObject($sName = '', $tSecurity = 0)
	Local $sTypeOfName = 'wstr'
	If Not StringStripWS($sName, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfName = 'ptr'
	Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateJobObjectW', 'struct*', $tSecurity, $sTypeOfName, $sName)
EndFunc   ;==>_WinAPI_CreateJobObject
Func _WinAPI_CreateMutex($sMutex, $bInitial = True, $tSecurity = 0)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $tSecurity, 'bool', $bInitial, 'wstr', $sMutex)
EndFunc   ;==>_WinAPI_CreateMutex
Func _WinAPI_CreateProcess($sAppName, $sCommand, $tSecurity, $tThread, $bInherit, $iFlags, $pEnviron, $sDir, $tStartupInfo, $tProcess)
	Local $tCommand = 0
	Local $sAppNameType = "wstr", $sDirType = "wstr"
	If $sAppName = "" Then
		$sAppNameType = "ptr"
		$sAppName = 0
	If $sCommand <> "" Then
		$tCommand = DllStructCreate("wchar Text[" & 260 + 1 & "]")
		DllStructSetData($tCommand, "Text", $sCommand)
	If $sDir = "" Then
		$sDirType = "ptr"
		$sDir = 0
	Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", $sAppNameType, $sAppName, "struct*", $tCommand, _
			"struct*", $tSecurity, "struct*", $tThread, "bool", $bInherit, "dword", $iFlags, "struct*", $pEnviron, $sDirType, $sDir, _
			"struct*", $tStartupInfo, "struct*", $tProcess)
EndFunc   ;==>_WinAPI_CreateProcess
Func _WinAPI_CreateProcessWithToken($sApp, $sCmd, $iFlags, $tStartupInfo, $tProcessInfo, $hToken, $iLogon = 0, $pEnvironment = 0, $sDir = '')
	Local $sTypeOfApp = 'wstr', $sTypeOfCmd = 'wstr', $sTypeOfDir = 'wstr'
	If Not StringStripWS($sApp, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfApp = 'ptr'
		$sApp = 0
	If Not StringStripWS($sCmd, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfCmd = 'ptr'
		$sCmd = 0
	If Not StringStripWS($sDir, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
		$sTypeOfDir = 'ptr'
	Local $aRet = DllCall('advapi32.dll', 'bool', 'CreateProcessWithTokenW', 'handle', $hToken, 'dword', $iLogon, _
			$sTypeOfApp, $sApp, $sTypeOfCmd, $sCmd, 'dword', $iFlags, 'struct*', $pEnvironment, _
			$sTypeOfDir, $sDir, 'struct*', $tStartupInfo, 'struct*', $tProcessInfo)
EndFunc   ;==>_WinAPI_CreateProcessWithToken
Func _WinAPI_CreateSemaphore($sSemaphore, $iInitial, $iMaximum, $tSecurity = 0)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'CreateSemaphoreW', 'struct*', $tSecurity, 'long', $iInitial, _
			'long', $iMaximum, 'wstr', $sSemaphore)
EndFunc   ;==>_WinAPI_CreateSemaphore
Func _WinAPI_DuplicateTokenEx($hToken, $iAccess, $iLevel, $iType = 1, $tSecurity = 0)
	Local $aRet = DllCall('advapi32.dll', 'bool', 'DuplicateTokenEx', 'handle', $hToken, 'dword', $iAccess, _
			'struct*', $tSecurity, 'int', $iLevel, 'int', $iType, 'handle*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, 0)
	Return $aRet[6]
EndFunc   ;==>_WinAPI_DuplicateTokenEx
Func _WinAPI_EmptyWorkingSet($iPID = 0)
	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000500 : 0x00001100), _
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EmptyWorkingSet', 'handle', $hProcess[0])
	If __CheckErrorCloseHandle($aRet, $hProcess[0]) Then Return SetError(@error, @extended, 0)
EndFunc   ;==>_WinAPI_EmptyWorkingSet
Func _WinAPI_EnumChildProcess($iPID = 0)
	Local $hSnapshot = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
	If @error Or ($hSnapshot[0] = Ptr(-1)) Then Return SetError(@error + 10, @extended, 0) ; $INVALID_HANDLE_VALUE
	Local $tPROCESSENTRY32 = DllStructCreate($tagPROCESSENTRY32)
	Local $aResult[101][2] = [[0]]
	$hSnapshot = $hSnapshot[0]
	DllStructSetData($tPROCESSENTRY32, 'Size', DllStructGetSize($tPROCESSENTRY32))
	Local $aRet = DllCall('kernel32.dll', 'bool', 'Process32FirstW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
	Local $iError = @error
	While (Not @error) And ($aRet[0])
		If DllStructGetData($tPROCESSENTRY32, 'ParentProcessID') = $iPID Then
			__Inc($aResult)
			$aResult[$aResult[0][0]][0] = DllStructGetData($tPROCESSENTRY32, 'ProcessID')
			$aResult[$aResult[0][0]][1] = DllStructGetData($tPROCESSENTRY32, 'ExeFile')
		$aRet = DllCall('kernel32.dll', 'bool', 'Process32NextW', 'handle', $hSnapshot, 'struct*', $tPROCESSENTRY32)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hSnapshot)
	If Not $aResult[0][0] Then Return SetError($iError + 20, 0, 0)
	__Inc($aResult, -1)
EndFunc   ;==>_WinAPI_EnumChildProcess
Func _WinAPI_EnumDeviceDrivers()
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumDeviceDrivers', 'ptr', 0, 'dword', 0, 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, 0)
	Local $iSize
	If @AutoItX64 Then
		$iSize = $aRet[3] / 8
		$iSize = $aRet[3] / 4
	Local $tData = DllStructCreate('ptr[' & $iSize & ']')
	$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumDeviceDrivers', 'struct*', $tData, _
			'dword', DllStructGetSize($tData), 'dword*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error + 20, @extended, 0)
	Local $aResult[$iSize + 1] = [$iSize]
	For $i = 1 To $iSize
		$aResult[$i] = DllStructGetData($tData, 1, $i)
EndFunc   ;==>_WinAPI_EnumDeviceDrivers
Func _WinAPI_EnumProcessHandles($iPID = 0, $iType = 0)
	Local $aResult[101][4] = [[0]]
	Local $tSHI = DllStructCreate('ulong;byte[4194304]')
	Local $aRet = DllCall('ntdll.dll', 'long', 'ZwQuerySystemInformation', 'uint', 16, 'struct*', $tSHI, _
			'ulong', DllStructGetSize($tSHI), 'ulong*', 0)
	Local $pData = DllStructGetPtr($tSHI, 2)
	Local $tHandle
	For $i = 1 To DllStructGetData($tSHI, 1)
		$tHandle = DllStructCreate('align 4;ulong;byte;byte;ushort;ptr;ulong', $pData + (@AutoItX64 ? (4 + ($i - 1) * 24) : (($i - 1) * 16)))
		If (DllStructGetData($tHandle, 1) = $iPID) And ((Not $iType) Or ($iType = DllStructGetData($tHandle, 2))) Then
			$aResult[$aResult[0][0]][0] = Ptr(DllStructGetData($tHandle, 4))
			$aResult[$aResult[0][0]][1] = DllStructGetData($tHandle, 2)
			$aResult[$aResult[0][0]][2] = DllStructGetData($tHandle, 3)
			$aResult[$aResult[0][0]][3] = DllStructGetData($tHandle, 6)
	If Not $aResult[0][0] Then Return SetError(11, 0, 0)
EndFunc   ;==>_WinAPI_EnumProcessHandles
Func _WinAPI_EnumProcessModules($iPID = 0, $iFlag = 0)
	Local $iCount, $aRet, $iError = 0
		If $__WINVER >= 0x0600 Then
			$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumProcessModulesEx', 'handle', $hProcess[0], 'ptr', 0, _
					'dword', 0, 'dword*', 0, 'dword', $iFlag)
			$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumProcessModules', 'handle', $hProcess[0], 'ptr', 0, _
					'dword', 0, 'dword*', 0)
		If @AutoItX64 Then
			$iCount = $aRet[4] / 8
			$iCount = $aRet[4] / 4
		Local $tPtr = DllStructCreate('ptr[' & $iCount & ']')
			$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumProcessModulesEx', 'handle', $hProcess[0], 'struct*', $tPtr, _
					'dword', DllStructGetSize($tPtr), 'dword*', 0, 'dword', $iFlag)
			$aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'EnumProcessModules', 'handle', $hProcess[0], 'struct*', $tPtr, _
					'dword', DllStructGetSize($tPtr), 'dword*', 0)
		Local $aResult[$iCount + 1][2] = [[$iCount]]
		For $i = 1 To $iCount
			$aResult[$i][0] = DllStructGetData($tPtr, 1, $i)
			$aResult[$i][1] = _WinAPI_GetModuleFileNameEx($hProcess[0], $aResult[$i][0])
EndFunc   ;==>_WinAPI_EnumProcessModules
Func _WinAPI_EnumProcessThreads($iPID = 0)
	Local $hSnapshot = DllCall('kernel32.dll', 'handle', 'CreateToolhelp32Snapshot', 'dword', 0x00000004, 'dword', 0)
	If @error Or Not $hSnapshot[0] Then Return SetError(@error + 10, @extended, 0)
	Local Const $tagTHREADENTRY32 = 'dword Size;dword Usage;dword ThreadID;dword OwnerProcessID;long BasePri;long DeltaPri;dword Flags'
	Local $tTHREADENTRY32 = DllStructCreate($tagTHREADENTRY32)
	Local $aResult[101] = [0]
	DllStructSetData($tTHREADENTRY32, 'Size', DllStructGetSize($tTHREADENTRY32))
	Local $aRet = DllCall('kernel32.dll', 'bool', 'Thread32First', 'handle', $hSnapshot, 'struct*', $tTHREADENTRY32)
	While Not @error And $aRet[0]
		If DllStructGetData($tTHREADENTRY32, 'OwnerProcessID') = $iPID Then
			$aResult[$aResult[0]] = DllStructGetData($tTHREADENTRY32, 'ThreadID')
		$aRet = DllCall('kernel32.dll', 'bool', 'Thread32Next', 'handle', $hSnapshot, 'struct*', $tTHREADENTRY32)
	If Not $aResult[0] Then Return SetError(1, 0, 0)
EndFunc   ;==>_WinAPI_EnumProcessThreads
Func _WinAPI_EnumProcessWindows($iPID = 0, $bVisible = True)
	Local $aThreads = _WinAPI_EnumProcessThreads($iPID)
	Local $hEnumProc = DllCallbackRegister('__EnumWindowsProc', 'bool', 'hwnd;lparam')
	Dim $__g_vEnum[101][2] = [[0]]
	For $i = 1 To $aThreads[0]
		DllCall('user32.dll', 'bool', 'EnumThreadWindows', 'dword', $aThreads[$i], 'ptr', DllCallbackGetPtr($hEnumProc), _
				'lparam', $bVisible)
	DllCallbackFree($hEnumProc)
	If Not $__g_vEnum[0][0] Then Return SetError(11, 0, 0)
	__Inc($__g_vEnum, -1)
	Return $__g_vEnum
EndFunc   ;==>_WinAPI_EnumProcessWindows
Func _WinAPI_FatalAppExit($sMessage)
	DllCall("kernel32.dll", "none", "FatalAppExitW", "uint", 0, "wstr", $sMessage)
EndFunc   ;==>_WinAPI_FatalAppExit
Func _WinAPI_GetCurrentProcessExplicitAppUserModelID()
	Local $aRet = DllCall('shell32.dll', 'long', 'GetCurrentProcessExplicitAppUserModelID', 'ptr*', 0)
	If @error Then Return SetError(@error, @extended, '')
	If $aRet[0] Then Return SetError(10, $aRet[0], '')
	Local $sID = _WinAPI_GetString($aRet[1])
	_WinAPI_CoTaskMemFree($aRet[1])
	Return $sID
EndFunc   ;==>_WinAPI_GetCurrentProcessExplicitAppUserModelID
Func _WinAPI_GetCurrentProcessID()
	Local $aResult = DllCall("kernel32.dll", "dword", "GetCurrentProcessId")
EndFunc   ;==>_WinAPI_GetCurrentProcessID
Func _WinAPI_GetCurrentThread()
	Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentThread")
EndFunc   ;==>_WinAPI_GetCurrentThread
Func _WinAPI_GetCurrentThreadId()
	Local $aResult = DllCall("kernel32.dll", "dword", "GetCurrentThreadId")
EndFunc   ;==>_WinAPI_GetCurrentThreadId
Func _WinAPI_GetDeviceDriverBaseName($pDriver)
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'dword', 'GetDeviceDriverBaseNameW', 'ptr', $pDriver, 'wstr', '', _
			'dword', 4096)
	Return $aRet[2]
EndFunc   ;==>_WinAPI_GetDeviceDriverBaseName
Func _WinAPI_GetDeviceDriverFileName($pDriver)
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'dword', 'GetDeviceDriverFileNameW', 'ptr', $pDriver, 'wstr', '', _
EndFunc   ;==>_WinAPI_GetDeviceDriverFileName
Func _WinAPI_GetExitCodeProcess($hProcess)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetExitCodeProcess', 'handle', $hProcess, 'dword*', 0)
EndFunc   ;==>_WinAPI_GetExitCodeProcess
Func _WinAPI_GetGuiResources($iFlag = 0, $hProcess = -1)
	If $hProcess = -1 Then $hProcess = _WinAPI_GetCurrentProcess()
	Local $aResult = DllCall("user32.dll", "dword", "GetGuiResources", "handle", $hProcess, "dword", $iFlag)
EndFunc   ;==>_WinAPI_GetGuiResources
Func _WinAPI_GetModuleFileNameEx($hProcess, $hModule = 0)
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'dword', 'GetModuleFileNameExW', 'handle', $hProcess, 'handle', $hModule, _
			'wstr', '', 'int', 4096)
	If @error Or Not $aRet[0] Then Return SetError(@error + 10, @extended, '')
	Return $aRet[3]
EndFunc   ;==>_WinAPI_GetModuleFileNameEx
Func _WinAPI_GetModuleInformation($hProcess, $hModule = 0)
	Local $tMODULEINFO = DllStructCreate($tagMODULEINFO)
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'GetModuleInformation', 'handle', $hProcess, 'handle', $hModule, _
			'struct*', $tMODULEINFO, 'dword', DllStructGetSize($tMODULEINFO))
	Return $tMODULEINFO
EndFunc   ;==>_WinAPI_GetModuleInformation
Func _WinAPI_GetParentProcess($iPID = 0)
	Local $iResult = 0
		If DllStructGetData($tPROCESSENTRY32, 'ProcessID') = $iPID Then
			$iResult = DllStructGetData($tPROCESSENTRY32, 'ParentProcessID')
	If Not $iResult Then Return SetError($iError, 0, 0)
	Return $iResult
EndFunc   ;==>_WinAPI_GetParentProcess
Func _WinAPI_GetPriorityClass($iPID = 0)
	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000400 : 0x00001000), 'bool', 0, 'dword', $iPID)
	Local $iError = 0
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetPriorityClass', 'handle', $hProcess[0])
	If @error Then $iError = @error
EndFunc   ;==>_WinAPI_GetPriorityClass
Func _WinAPI_GetProcessAffinityMask($hProcess)
	Local $aResult = DllCall("kernel32.dll", "bool", "GetProcessAffinityMask", "handle", $hProcess, "dword_ptr*", 0, "dword_ptr*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, 0)
	Local $aMask[3]
	$aMask[0] = True
	$aMask[1] = $aResult[2]
	$aMask[2] = $aResult[3]
	Return $aMask
EndFunc   ;==>_WinAPI_GetProcessAffinityMask
Func _WinAPI_GetProcessCommandLine($iPID = 0)
	If @error Or Not $hProcess[0] Then Return SetError(@error + 20, @extended, '')
	$hProcess = $hProcess[0]
	Local $tPBI = DllStructCreate('ulong_ptr ExitStatus;ptr PebBaseAddress;ulong_ptr AffinityMask;ulong_ptr BasePriority;ulong_ptr UniqueProcessId;ulong_ptr InheritedFromUniqueProcessId')
	Local $tPEB = DllStructCreate('byte InheritedAddressSpace;byte ReadImageFileExecOptions;byte BeingDebugged;byte Spare;ptr Mutant;ptr ImageBaseAddress;ptr LoaderData;ptr ProcessParameters;ptr SubSystemData;ptr ProcessHeap;ptr FastPebLock;ptr FastPebLockRoutine;ptr FastPebUnlockRoutine;ulong EnvironmentUpdateCount;ptr KernelCallbackTable;ptr EventLogSection;ptr EventLog;ptr FreeList;ulong TlsExpansionCounter;ptr TlsBitmap;ulong TlsBitmapBits[2];ptr ReadOnlySharedMemoryBase;ptr ReadOnlySharedMemoryHeap;ptr ReadOnlyStaticServerData;ptr AnsiCodePageData;ptr OemCodePageData;ptr UnicodeCaseTableData;ulong NumberOfProcessors;ulong NtGlobalFlag;byte Spare2[4];int64 CriticalSectionTimeout;ulong HeapSegmentReserve;ulong HeapSegmentCommit;ulong HeapDeCommitTotalFreeThreshold;ulong HeapDeCommitFreeBlockThreshold;ulong NumberOfHeaps;ulong MaximumNumberOfHeaps;ptr ProcessHeaps;ptr GdiSharedHandleTable;ptr ProcessStarterHelper;ptr GdiDCAttributeList;ptr LoaderLock;ulong OSMajorVersion;ulong OSMinorVersion;ulong OSBuildNumber;ulong OSPlatformId;ulong ImageSubSystem;ulong ImageSubSystemMajorVersion;ulong ImageSubSystemMinorVersion;ulong GdiHandleBuffer[34];ulong PostProcessInitRoutine;ulong TlsExpansionBitmap;byte TlsExpansionBitmapBits[128];ulong SessionId')
	Local $tUPP = DllStructCreate('ulong AllocationSize;ulong ActualSize;ulong Flags;ulong Unknown1;ushort LengthUnknown2;ushort MaxLengthUnknown2;ptr Unknown2;ptr InputHandle;ptr OutputHandle;ptr ErrorHandle;ushort LengthCurrentDirectory;ushort MaxLengthCurrentDirectory;ptr CurrentDirectory;ptr CurrentDirectoryHandle;ushort LengthSearchPaths;ushort MaxLengthSearchPaths;ptr SearchPaths;ushort LengthApplicationName;ushort MaxLengthApplicationName;ptr ApplicationName;ushort LengthCommandLine;ushort MaxLengthCommandLine;ptr CommandLine;ptr EnvironmentBlock;ulong Unknown[9];ushort LengthUnknown3;ushort MaxLengthUnknown3;ptr Unknown3;ushort LengthUnknown4;ushort MaxLengthUnknown4;ptr Unknown4;ushort LengthUnknown5;ushort MaxLengthUnknown5;ptr Unknown5')
	Local $tCMD
	Local $aRet, $iError = 0
		$aRet = DllCall('ntdll.dll', 'long', 'NtQueryInformationProcess', 'handle', $hProcess, 'ulong', 0, 'struct*', $tPBI, _
				'ulong', DllStructGetSize($tPBI), 'ulong*', 0)
		If @error Or $aRet[0] Then
		$aRet = DllCall('kernel32.dll', 'bool', 'ReadProcessMemory', 'handle', $hProcess, _
				'ptr', DllStructGetData($tPBI, 'PebBaseAddress'), 'struct*', $tPEB, _
				'ulong_ptr', DllStructGetSize($tPEB), 'ulong_ptr*', 0)
		If @error Or Not $aRet[0] Or (Not $aRet[5]) Then
				'ptr', DllStructGetData($tPEB, 'ProcessParameters'), 'struct*', $tUPP, _
				'ulong_ptr', DllStructGetSize($tUPP), 'ulong_ptr*', 0)
		$tCMD = DllStructCreate('byte[' & DllStructGetData($tUPP, 'MaxLengthCommandLine') & ']')
			$iError = @error + 60
				'ptr', DllStructGetData($tUPP, 'CommandLine'), 'struct*', $tCMD, _
				'ulong_ptr', DllStructGetSize($tCMD), 'ulong_ptr*', 0)
			$iError = @error + 70
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
	Return StringStripWS(_WinAPI_PathGetArgs(_WinAPI_GetString(DllStructGetPtr($tCMD, 1))), $STR_STRIPLEADING + $STR_STRIPTRAILING)
EndFunc   ;==>_WinAPI_GetProcessCommandLine
Func _WinAPI_GetProcessFileName($iPID = 0)
	Local $sPath = _WinAPI_GetModuleFileNameEx($hProcess[0])
	If $iError Then Return SetError(@error, 0, '')
	Return $sPath
EndFunc   ;==>_WinAPI_GetProcessFileName
Func _WinAPI_GetProcessHandleCount($iPID = 0)
	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000400 : 0x00001000), _
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetProcessHandleCount', 'handle', $hProcess[0], 'dword*', 0)
EndFunc   ;==>_WinAPI_GetProcessHandleCount
Func _WinAPI_GetProcessID($hProcess)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetProcessId', 'handle', $hProcess)
EndFunc   ;==>_WinAPI_GetProcessID
Func _WinAPI_GetProcessIoCounters($iPID = 0)
	Local $tIO_COUNTERS = DllStructCreate('uint64[6]')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetProcessIoCounters', 'handle', $hProcess[0], 'struct*', $tIO_COUNTERS)
	Local $aResult[6]
		$aResult[$i] = DllStructGetData($tIO_COUNTERS, 1, $i + 1)
EndFunc   ;==>_WinAPI_GetProcessIoCounters
Func _WinAPI_GetProcessMemoryInfo($iPID = 0)
	Local $tPMC_EX = DllStructCreate('dword;dword;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr;ulong_ptr')
	Local $aRet = DllCall(@SystemDir & '\psapi.dll', 'bool', 'GetProcessMemoryInfo', 'handle', $hProcess[0], 'struct*', $tPMC_EX, _
			'int', DllStructGetSize($tPMC_EX))
	Local $aResult[10]
	For $i = 0 To 9
		$aResult[$i] = DllStructGetData($tPMC_EX, $i + 2)
EndFunc   ;==>_WinAPI_GetProcessMemoryInfo
Func _WinAPI_GetProcessName($iPID = 0)
	If @error Or Not $hSnapshot[0] Then Return SetError(@error + 20, @extended, '')
	If Not $aRet[0] Then SetError(10, 0, '')
	Return DllStructGetData($tPROCESSENTRY32, 'ExeFile')
EndFunc   ;==>_WinAPI_GetProcessName
Func _WinAPI_GetProcessTimes($iPID = 0)
	Local $tFILETIME = DllStructCreate($tagFILETIME)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'GetProcessTimes', 'handle', $hProcess[0], 'struct*', $tFILETIME, 'uint64*', 0, _
			'uint64*', 0, 'uint64*', 0)
	Local $aResult[3]
	$aResult[0] = $tFILETIME
	$aResult[2] = $aRet[5]
EndFunc   ;==>_WinAPI_GetProcessTimes
Func _WinAPI_GetProcessUser($iPID = 0)
	Local $tSID, $hToken, $aRet
		$hToken = _WinAPI_OpenProcessToken(0x00000008, $hProcess[0])
		If Not $hToken Then
		$tSID = DllStructCreate('ptr;byte[1024]')
		$aRet = DllCall('advapi32.dll', 'bool', 'GetTokenInformation', 'handle', $hToken, 'uint', 1, 'struct*', $tSID, _
				'dword', DllStructGetSize($tSID), 'dword*', 0)
		$aRet = DllCall('advapi32.dll', 'bool', 'LookupAccountSidW', 'ptr', 0, 'ptr', DllStructGetData($tSID, 1), 'wstr', '', _
				'dword*', 2048, 'wstr', '', 'dword*', 2048, 'uint*', 0)
	If $hToken Then
		DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
	$aResult[0] = $aRet[3]
	$aResult[1] = $aRet[5]
EndFunc   ;==>_WinAPI_GetProcessUser
Func _WinAPI_GetProcessWorkingDirectory($iPID = 0)
	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000410 : 0x00001010), 'bool', 0, 'dword', $iPID)
	Local $tDIR
		If @error Or ($aRet[0]) Then
		If @error Or (Not $aRet[0]) Or (Not $aRet[5]) Then
		$tDIR = DllStructCreate('byte[' & DllStructGetData($tUPP, 'MaxLengthCurrentDirectory') & ']')
				'ptr', DllStructGetData($tUPP, 'CurrentDirectory'), 'struct*', $tDIR, _
				'ulong_ptr', DllStructGetSize($tDIR), 'ulong_ptr*', 0)
		$iError = 0
	Return _WinAPI_PathRemoveBackslash(_WinAPI_GetString(DllStructGetPtr($tDIR)))
EndFunc   ;==>_WinAPI_GetProcessWorkingDirectory
Func _WinAPI_GetThreadDesktop($iThreadId)
	Local $aRet = DllCall('user32.dll', 'handle', 'GetThreadDesktop', 'dword', $iThreadId)
EndFunc   ;==>_WinAPI_GetThreadDesktop
Func _WinAPI_GetThreadErrorMode()
	Local $aRet = DllCall('kernel32.dll', 'dword', 'GetThreadErrorMode')
EndFunc   ;==>_WinAPI_GetThreadErrorMode
Func _WinAPI_GetWindowFileName($hWnd)
	Local $iPID = 0
	Local $aResult = DllCall("user32.dll", "bool", "IsWindow", "hwnd", $hWnd)
	If $aResult[0] Then
		$aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
		$iPID = $aResult[2]
	If Not $iPID Then Return SetError(1, 0, '')
	Local $sResult = _WinAPI_GetProcessFileName($iPID)
	Return $sResult
EndFunc   ;==>_WinAPI_GetWindowFileName
Func _WinAPI_IsElevated()
	Local $iElev, $aRet, $iError = 0
	Local $hToken = _WinAPI_OpenProcessToken(0x0008)
	If Not $hToken Then Return SetError(@error + 10, @extended, False)
		$aRet = DllCall('advapi32.dll', 'bool', 'GetTokenInformation', 'handle', $hToken, 'uint', 20, 'uint*', 0, 'dword', 4, _
				'dword*', 0) ; TOKEN_ELEVATION
		$iElev = $aRet[3]
		$aRet = DllCall('advapi32.dll', 'bool', 'GetTokenInformation', 'handle', $hToken, 'uint', 18, 'uint*', 0, 'dword', 4, _
				'dword*', 0) ; TOKEN_ELEVATION_TYPE
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hToken)
	If $iError Then Return SetError($iError, 0, False)
	Return SetExtended($aRet[0] - 1, $iElev)
EndFunc   ;==>_WinAPI_IsElevated
Func _WinAPI_IsProcessInJob($hProcess, $hJob = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'IsProcessInJob', 'handle', $hProcess, 'handle', $hJob, 'bool*', 0)
	If @error Or Not $aRet[0] Then Return SetError(@error, @extended, False)
EndFunc   ;==>_WinAPI_IsProcessInJob
Func _WinAPI_OpenJobObject($sName, $iAccess = $JOB_OBJECT_ALL_ACCESS, $bInherit = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'OpenJobObjectW', 'dword', $iAccess, 'bool', $bInherit, 'wstr', $sName)
EndFunc   ;==>_WinAPI_OpenJobObject
Func _WinAPI_OpenMutex($sMutex, $iAccess = $MUTEX_ALL_ACCESS, $bInherit = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'OpenMutexW', 'dword', $iAccess, 'bool', $bInherit, 'wstr', $sMutex)
EndFunc   ;==>_WinAPI_OpenMutex
Func _WinAPI_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
	Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
	If $aResult[0] Then Return $aResult[0]
	If Not $bDebugPriv Then Return SetError(100, 0, 0)
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error + 10, @extended, 0)
	_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
	Local $iExtended = @extended
	Local $iRet = 0
	If Not @error Then
		$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $bInherit, "dword", $iPID)
		$iExtended = @extended
		If $aResult[0] Then $iRet = $aResult[0]
		_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
			$iExtended = @extended
		$iError = @error + 30 ; SeDebugPrivilege=True error
	Return SetError($iError, $iExtended, $iRet)
EndFunc   ;==>_WinAPI_OpenProcess
Func _WinAPI_OpenProcessToken($iAccess, $hProcess = 0)
	If Not $hProcess Then
		$hProcess = DllCall("kernel32.dll", "handle", "GetCurrentProcess")
		$hProcess = $hProcess[0]
	Local $aRet = DllCall('advapi32.dll', 'bool', 'OpenProcessToken', 'handle', $hProcess, 'dword', $iAccess, 'handle*', 0)
EndFunc   ;==>_WinAPI_OpenProcessToken
Func _WinAPI_OpenSemaphore($sSemaphore, $iAccess = 0x001F0003, $bInherit = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'OpenSemaphoreW', 'dword', $iAccess, 'bool', $bInherit, 'wstr', $sSemaphore)
EndFunc   ;==>_WinAPI_OpenSemaphore
Func _WinAPI_QueryInformationJobObject($hJob, $iJobObjectInfoClass, ByRef $tJobObjectInfo)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'QueryInformationJobObject', 'handle', $hJob, 'int', $iJobObjectInfoClass, _
			'struct*', $tJobObjectInfo, 'dword', DllStructGetSize($tJobObjectInfo), 'dword*', 0)
	Return $aRet[5]
EndFunc   ;==>_WinAPI_QueryInformationJobObject
Func _WinAPI_ReleaseMutex($hMutex)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'ReleaseMutex', 'handle', $hMutex)
EndFunc   ;==>_WinAPI_ReleaseMutex
Func _WinAPI_ReleaseSemaphore($hSemaphore, $iIncrease = 1)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'ReleaseSemaphore', 'handle', $hSemaphore, 'long', $iIncrease, 'long*', 0)
EndFunc   ;==>_WinAPI_ReleaseSemaphore
Func _WinAPI_ResetEvent($hEvent)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'ResetEvent', 'handle', $hEvent)
EndFunc   ;==>_WinAPI_ResetEvent
Func _WinAPI_SetEvent($hEvent)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetEvent", "handle", $hEvent)
EndFunc   ;==>_WinAPI_SetEvent
Func _WinAPI_SetInformationJobObject($hJob, $iJobObjectInfoClass, $tJobObjectInfo)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetInformationJobObject', 'handle', $hJob, 'int', $iJobObjectInfoClass, _
			'struct*', $tJobObjectInfo, 'dword', DllStructGetSize($tJobObjectInfo))
EndFunc   ;==>_WinAPI_SetInformationJobObject
Func _WinAPI_SetPriorityClass($iPriority, $iPID = 0)
	Local $hProcess = DllCall('kernel32.dll', 'handle', 'OpenProcess', 'dword', (($__WINVER < 0x0600) ? 0x00000600 : 0x00001200), _
	If @error Or Not $hProcess[0] Then Return SetError(@error + 10, @extended, 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetPriorityClass', 'handle', $hProcess[0], 'dword', $iPriority)
EndFunc   ;==>_WinAPI_SetPriorityClass
Func _WinAPI_SetProcessAffinityMask($hProcess, $iMask)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetProcessAffinityMask", "handle", $hProcess, "ulong_ptr", $iMask)
EndFunc   ;==>_WinAPI_SetProcessAffinityMask
Func _WinAPI_SetThreadDesktop($hDesktop)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetThreadDesktop', 'handle', $hDesktop)
EndFunc   ;==>_WinAPI_SetThreadDesktop
Func _WinAPI_SetThreadErrorMode($iMode)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'SetThreadErrorMode', 'dword', $iMode, 'dword*', 0)
EndFunc   ;==>_WinAPI_SetThreadErrorMode
Func _WinAPI_SetThreadExecutionState($iFlags)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'SetThreadExecutionState', 'dword', $iFlags)
EndFunc   ;==>_WinAPI_SetThreadExecutionState
Func _WinAPI_TerminateJobObject($hJob, $iExitCode = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'TerminateJobObject', 'handle', $hJob, 'uint', $iExitCode)
EndFunc   ;==>_WinAPI_TerminateJobObject
Func _WinAPI_TerminateProcess($hProcess, $iExitCode = 0)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'TerminateProcess', 'handle', $hProcess, 'uint', $iExitCode)
EndFunc   ;==>_WinAPI_TerminateProcess
Func _WinAPI_UserHandleGrantAccess($hObject, $hJob, $bGrant)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'UserHandleGrantAccess', 'handle', $hObject, 'handle', $hJob, 'bool', $bGrant)
EndFunc   ;==>_WinAPI_UserHandleGrantAccess
Func _WinAPI_WaitForInputIdle($hProcess, $iTimeout = -1)
	Local $aResult = DllCall("user32.dll", "dword", "WaitForInputIdle", "handle", $hProcess, "dword", $iTimeout)
EndFunc   ;==>_WinAPI_WaitForInputIdle
Func _WinAPI_WaitForMultipleObjects($iCount, $paHandles, $bWaitAll = False, $iTimeout = -1)
	Local $aResult = DllCall("kernel32.dll", "INT", "WaitForMultipleObjects", "dword", $iCount, "struct*", $paHandles, "bool", $bWaitAll, "dword", $iTimeout)
	If @error Then Return SetError(@error, @extended, -1)
EndFunc   ;==>_WinAPI_WaitForMultipleObjects
Func _WinAPI_WaitForSingleObject($hHandle, $iTimeout = -1)
	Local $aResult = DllCall("kernel32.dll", "INT", "WaitForSingleObject", "handle", $hHandle, "dword", $iTimeout)
EndFunc   ;==>_WinAPI_WaitForSingleObject
Func _WinAPI_WriteConsole($hConsole, $sText)
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteConsoleW", "handle", $hConsole, "wstr", $sText, _
			"dword", StringLen($sText), "dword*", 0, "ptr", 0)
EndFunc   ;==>_WinAPI_WriteConsole
#include "APILocaleConstants.au3"
#include "APIResConstants.au3"
#include "WinAPIConv.au3"
#include "WinAPIIcons.au3"
#include "WinAPIInternals.au3"
Global $__g_vVal
Global Const $tagVS_FIXEDFILEINFO = 'dword Signature;dword StrucVersion;dword FileVersionMS;dword FileVersionLS;dword ProductVersionMS;dword ProductVersionLS;dword FileFlagsMask;dword FileFlags;dword FileOS;dword FileType;dword FileSubtype;dword FileDateMS;dword FileDateLS'
Func _WinAPI_BeginUpdateResource($sFilePath, $bDelete = False)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'BeginUpdateResourceW', 'wstr', $sFilePath, 'bool', $bDelete)
EndFunc   ;==>_WinAPI_BeginUpdateResource
Func _WinAPI_ClipCursor($tRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'ClipCursor', 'struct*', $tRECT)
EndFunc   ;==>_WinAPI_ClipCursor
Func _WinAPI_CopyCursor($hCursor)
	Return _WinAPI_CopyIcon($hCursor)
EndFunc   ;==>_WinAPI_CopyCursor
Func _WinAPI_CreateCaret($hWnd, $hBitmap, $iWidth = 0, $iHeight = 0)
	Local $aRet = DllCall('user32.dll', 'bool', 'CreateCaret', 'hwnd', $hWnd, 'handle', $hBitmap, 'int', $iWidth, 'int', $iHeight)
EndFunc   ;==>_WinAPI_CreateCaret
Func _WinAPI_DestroyCaret()
	Local $aRet = DllCall('user32.dll', 'bool', 'DestroyCaret')
EndFunc   ;==>_WinAPI_DestroyCaret
Func _WinAPI_DestroyCursor($hCursor)
	Local $aRet = DllCall('user32.dll', 'bool', 'DestroyCursor', 'handle', $hCursor)
EndFunc   ;==>_WinAPI_DestroyCursor
Func _WinAPI_EndUpdateResource($hUpdate, $bDiscard = False)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EndUpdateResourceW', 'handle', $hUpdate, 'bool', $bDiscard)
EndFunc   ;==>_WinAPI_EndUpdateResource
Func _WinAPI_EnumResourceLanguages($hModule, $sType, $sName)
	Local $iLibrary = 0, $sTypeOfType = 'int', $sTypeOfName = 'int'
	If IsString($hModule) Then
		If StringStripWS($hModule, $STR_STRIPLEADING + $STR_STRIPTRAILING) Then
			$hModule = _WinAPI_LoadLibraryEx($hModule, 0x00000003)
			If Not $hModule Then Return SetError(1, 0, 0)
			$iLibrary = 1
			$hModule = 0
	If IsString($sType) Then
		$sTypeOfType = 'wstr'
	If IsString($sName) Then
		$sTypeOfName = 'wstr'
	Dim $__g_vEnum[101] = [0]
	Local $hEnumProc = DllCallbackRegister('__EnumResLanguagesProc', 'bool', 'handle;ptr;ptr;word;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceLanguagesW', 'handle', $hModule, $sTypeOfType, $sType, _
			$sTypeOfName, $sName, 'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', 0)
	If @error Or Not $aRet[0] Or Not $__g_vEnum[0] Then
		$__g_vEnum = @error + 10
	If $iLibrary Then
		_WinAPI_FreeLibrary($hModule)
	If $__g_vEnum Then Return SetError($__g_vEnum, 0, 0)
EndFunc   ;==>_WinAPI_EnumResourceLanguages
Func _WinAPI_EnumResourceNames($hModule, $sType)
	Local $aRet, $hEnumProc, $iLibrary = 0, $sTypeOfType = 'int'
	$hEnumProc = DllCallbackRegister('__EnumResNamesProc', 'bool', 'handle;ptr;ptr;long_ptr')
	$aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceNamesW', 'handle', $hModule, $sTypeOfType, $sType, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', 0)
	If @error Or Not $aRet[0] Or (Not $__g_vEnum[0]) Then
EndFunc   ;==>_WinAPI_EnumResourceNames
Func _WinAPI_EnumResourceTypes($hModule)
	Local $iLibrary = 0
	Local $hEnumProc = DllCallbackRegister('__EnumResTypesProc', 'bool', 'handle;ptr;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceTypesW', 'handle', $hModule, _
EndFunc   ;==>_WinAPI_EnumResourceTypes
Func _WinAPI_FindResource($hInstance, $sType, $sName)
	Local $sTypeOfType = 'int', $sTypeOfName = 'int'
	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindResourceW', 'handle', $hInstance, $sTypeOfName, $sName, $sTypeOfType, $sType)
EndFunc   ;==>_WinAPI_FindResource
Func _WinAPI_FindResourceEx($hInstance, $sType, $sName, $iLanguage)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'FindResourceExW', 'handle', $hInstance, $sTypeOfType, $sType, _
			$sTypeOfName, $sName, 'ushort', $iLanguage)
EndFunc   ;==>_WinAPI_FindResourceEx
Func _WinAPI_FreeResource($hData)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'FreeResource', 'handle', $hData)
EndFunc   ;==>_WinAPI_FreeResource
Func _WinAPI_GetCaretBlinkTime()
	Local $aRet = DllCall('user32.dll', 'uint', 'GetCaretBlinkTime')
EndFunc   ;==>_WinAPI_GetCaretBlinkTime
Func _WinAPI_GetCaretPos()
	Local $tPOINT = DllStructCreate($tagPOINT)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetCaretPos', 'struct*', $tagPOINT)
	For $i = 0 To 1
		$aResult[$i] = DllStructGetData($tPOINT, $i + 1)
EndFunc   ;==>_WinAPI_GetCaretPos
Func _WinAPI_GetClipCursor()
	Local $tRECT = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetClipCursor', 'struct*', $tRECT)
	Return $tRECT
EndFunc   ;==>_WinAPI_GetClipCursor
Func _WinAPI_GetCursor()
	Local $aRet = DllCall('user32.dll', 'handle', 'GetCursor')
EndFunc   ;==>_WinAPI_GetCursor
Func _WinAPI_GetFileVersionInfo($sFilePath, ByRef $pBuffer, $iFlags = 0)
	Local $aRet
		$aRet = DllCall('version.dll', 'dword', 'GetFileVersionInfoSizeExW', 'dword', BitAND($iFlags, 0x03), 'wstr', $sFilePath, _
				'ptr', 0)
		$aRet = DllCall('version.dll', 'dword', 'GetFileVersionInfoSizeW', 'wstr', $sFilePath, 'ptr', 0)
	$pBuffer = __HeapReAlloc($pBuffer, $aRet[0], 1)
	If @error Then Return SetError(@error + 100, @extended, 0)
	Local $iNbByte = $aRet[0]
		$aRet = DllCall('version.dll', 'bool', 'GetFileVersionInfoExW', 'dword', BitAND($iFlags, 0x07), 'wstr', $sFilePath, _
				'dword', 0, 'dword', $iNbByte, 'ptr', $pBuffer)
		$aRet = DllCall('version.dll', 'bool', 'GetFileVersionInfoW', 'wstr', $sFilePath, _
	Return $iNbByte
EndFunc   ;==>_WinAPI_GetFileVersionInfo
Func _WinAPI_HideCaret($hWnd)
	Local $aRet = DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_HideCaret
Func _WinAPI_LoadBitmap($hInstance, $sBitmap)
	Local $sBitmapType = "int"
	If IsString($sBitmap) Then $sBitmapType = "wstr"
	Local $aResult = DllCall("user32.dll", "handle", "LoadBitmapW", "handle", $hInstance, $sBitmapType, $sBitmap)
EndFunc   ;==>_WinAPI_LoadBitmap
Func _WinAPI_LoadCursor($hInstance, $sName)
	Local $sTypeOfName = 'int'
	Local $aRet = DllCall('user32.dll', 'handle', 'LoadCursorW', 'handle', $hInstance, $sTypeOfName, $sName)
EndFunc   ;==>_WinAPI_LoadCursor
Func _WinAPI_LoadCursorFromFile($sFilePath)
	Local $aRet = DllCall('user32.dll', 'handle', 'LoadCursorFromFileW', 'wstr', $sFilePath)
EndFunc   ;==>_WinAPI_LoadCursorFromFile
Func _WinAPI_LoadIndirectString($sStrIn)
	Local $aRet = DllCall('shlwapi.dll', 'uint', 'SHLoadIndirectString', 'wstr', $sStrIn, 'wstr', '', 'uint', 4096, 'ptr*', 0)
EndFunc   ;==>_WinAPI_LoadIndirectString
Func _WinAPI_LoadString($hInstance, $iStringID)
	Local $aResult = DllCall("user32.dll", "int", "LoadStringW", "handle", $hInstance, "uint", $iStringID, "wstr", "", "int", 4096)
	If @error Or Not $aResult[0] Then Return SetError(@error + 10, @extended, "")
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_WinAPI_LoadString
Func _WinAPI_LoadLibraryEx($sFileName, $iFlags = 0)
	Local $aResult = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $sFileName, "ptr", 0, "dword", $iFlags)
EndFunc   ;==>_WinAPI_LoadLibraryEx
Func _WinAPI_LoadResource($hInstance, $hResource)
	Local $aRet = DllCall('kernel32.dll', 'handle', 'LoadResource', 'handle', $hInstance, 'handle', $hResource)
EndFunc   ;==>_WinAPI_LoadResource
Func _WinAPI_LoadStringEx($hModule, $iID, $iLanguage = $LOCALE_USER_DEFAULT)
			If Not $hModule Then Return SetError(@error + 20, @extended, '')
	Local $sResult = ''
	Local $pData = __ResLoad($hModule, 6, Floor($iID / 16) + 1, $iLanguage)
		Local $iOffset = 0
		For $i = 0 To Mod($iID, 16) - 1
			$iOffset += 2 * (DllStructGetData(DllStructCreate('ushort', $pData + $iOffset), 1) + 1)
		$sResult = DllStructGetData(DllStructCreate('ushort;wchar[' & DllStructGetData(DllStructCreate('ushort', $pData + $iOffset), 1) & ']', $pData + $iOffset), 2)
		If @error Then $sResult = ''
		Return SetError(10, 0, '')
	Return SetError(Number(Not $sResult), 0, $sResult)
EndFunc   ;==>_WinAPI_LoadStringEx
Func _WinAPI_LockResource($hData)
	Local $aRet = DllCall('kernel32.dll', 'ptr', 'LockResource', 'handle', $hData)
EndFunc   ;==>_WinAPI_LockResource
Func _WinAPI_SetCaretBlinkTime($iDuration)
	Local $iPrev = _WinAPI_GetCaretBlinkTime()
	If Not $iPrev Then Return SetError(@error + 20, @extended, 0)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetCaretBlinkTime', 'uint', $iDuration)
	Return $iPrev
EndFunc   ;==>_WinAPI_SetCaretBlinkTime
Func _WinAPI_SetCaretPos($iX, $iY)
	Local $aRet = DllCall('user32.dll', 'int', 'SetCaretPos', 'int', $iX, 'int', $iY)
EndFunc   ;==>_WinAPI_SetCaretPos
Func _WinAPI_SetCursor($hCursor)
	Local $aResult = DllCall("user32.dll", "handle", "SetCursor", "handle", $hCursor)
EndFunc   ;==>_WinAPI_SetCursor
Func _WinAPI_SetSystemCursor($hCursor, $iID, $bCopy = False)
	If $bCopy Then
		$hCursor = _WinAPI_CopyCursor($hCursor)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetSystemCursor', 'handle', $hCursor, 'dword', $iID)
EndFunc   ;==>_WinAPI_SetSystemCursor
Func _WinAPI_ShowCaret($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShowCaret', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_ShowCaret
Func _WinAPI_ShowCursor($bShow)
	Local $aResult = DllCall("user32.dll", "int", "ShowCursor", "bool", $bShow)
EndFunc   ;==>_WinAPI_ShowCursor
Func _WinAPI_SizeOfResource($hInstance, $hResource)
	Local $aRet = DllCall('kernel32.dll', 'dword', 'SizeofResource', 'handle', $hInstance, 'handle', $hResource)
EndFunc   ;==>_WinAPI_SizeOfResource
Func _WinAPI_UpdateResource($hUpdate, $sType, $sName, $iLanguage, $pData, $iSize)
	Local $aRet = DllCall('kernel32.dll', 'bool', 'UpdateResourceW', 'handle', $hUpdate, $sTypeOfType, $sType, $sTypeOfName, $sName, _
			'word', $iLanguage, 'ptr', $pData, 'dword', $iSize)
EndFunc   ;==>_WinAPI_UpdateResource
Func _WinAPI_VerQueryRoot($pData)
	Local $aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\', 'ptr*', 0, 'uint*', 0)
	If @error Or Not $aRet[0] Or Not $aRet[4] Then Return SetError(@error + 10, @extended, 0)
	Local $tVFFI = DllStructCreate($tagVS_FIXEDFILEINFO)
	If Not _WinAPI_MoveMemory($tVFFI, $aRet[3], $aRet[4]) Then Return SetError(@error + 20, @extended, 0)
	Return $tVFFI
EndFunc   ;==>_WinAPI_VerQueryRoot
Func _WinAPI_VerQueryValue($pData, $sValues = '')
	$sValues = StringRegExpReplace($sValues, '\A[\s\|]*|[\s\|]*\Z', '')
	If Not $sValues Then
		$sValues = 'Comments|CompanyName|FileDescription|FileVersion|InternalName|LegalCopyright|LegalTrademarks|OriginalFilename|ProductName|ProductVersion|PrivateBuild|SpecialBuild'
	$sValues = StringSplit($sValues, '|', $STR_NOCOUNT)
	Local $aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\VarFileInfo\Translation', 'ptr*', 0, _
			'uint*', 0)
	If @error Or Not $aRet[0] Or Not $aRet[4] Then Return SetError(@error + 10, 0, 0)
	Local $iLength = Floor($aRet[4] / 4)
	Local $tLang = DllStructCreate('dword[' & $iLength & ']', $aRet[3])
	If @error Then Return SetError(@error + 20, 0, 0)
	Local $sCP, $aInfo[101][UBound($sValues) + 1] = [[0]]
	For $i = 1 To $iLength
		__Inc($aInfo)
		$aInfo[$aInfo[0][0]][0] = _WinAPI_LoWord(DllStructGetData($tLang, 1, $i))
		$sCP = Hex(_WinAPI_MakeLong(_WinAPI_HiWord(DllStructGetData($tLang, 1, $i)), _WinAPI_LoWord(DllStructGetData($tLang, 1, $i))), 8)
		For $j = 0 To UBound($sValues) - 1
			$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\StringFileInfo\' & $sCP & '\' & $sValues[$j], _
					'ptr*', 0, 'uint*', 0)
			If Not @error And $aRet[0] And $aRet[4] Then
				$aInfo[$aInfo[0][0]][$j + 1] = DllStructGetData(DllStructCreate('wchar[' & $aRet[4] & ']', $aRet[3]), 1)
				$aInfo[$aInfo[0][0]][$j + 1] = ''
	__Inc($aInfo, -1)
	Return $aInfo
EndFunc   ;==>_WinAPI_VerQueryValue
Func _WinAPI_VerQueryValueEx($hModule, $sValues = '', $iLanguage = 0x0400)
	$__g_vVal = StringRegExpReplace($sValues, '\A[\s\|]*|[\s\|]*\Z', '')
	If Not $__g_vVal Then
		$__g_vVal = 'Comments|CompanyName|FileDescription|FileVersion|InternalName|LegalCopyright|LegalTrademarks|OriginalFilename|ProductName|ProductVersion|PrivateBuild|SpecialBuild'
	$__g_vVal = StringSplit($__g_vVal, '|')
	If Not IsArray($__g_vVal) Then Return SetError(1, 0, 0)
			If Not $hModule Then
				Return SetError(@error + 10, @extended, 0)
	Dim $__g_vEnum[101][$__g_vVal[0] + 1] = [[0]]
	Local $hEnumProc = DllCallbackRegister('__EnumVerValuesProc', 'bool', 'ptr;ptr;ptr;word;long_ptr')
	Local $aRet = DllCall('kernel32.dll', 'bool', 'EnumResourceLanguagesW', 'handle', $hModule, 'int', 16, 'int', 1, _
			'ptr', DllCallbackGetPtr($hEnumProc), 'long_ptr', $iLanguage)
			$__g_vEnum = @error + 20
			If Not $aRet[0] Then
				Switch _WinAPI_GetLastError()
					Case 0, 15106 ; ERROR_SUCCESS, ERROR_RESOURCE_ENUM_USER_STOP
						$__g_vEnum = 20
	If Not $__g_vEnum[0][0] Then $__g_vEnum = 230
EndFunc   ;==>_WinAPI_VerQueryValueEx
Func __EnumResLanguagesProc($hModule, $iType, $iName, $iLanguage, $lParam)
	#forceref $hModule, $iType, $iName, $lParam
	__Inc($__g_vEnum)
	$__g_vEnum[$__g_vEnum[0]] = $iLanguage
EndFunc   ;==>__EnumResLanguagesProc
Func __EnumResNamesProc($hModule, $iType, $iName, $lParam)
	#forceref $hModule, $iType, $lParam
	Local $iLength = _WinAPI_StrLen($iName)
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $iName), 1)
		$__g_vEnum[$__g_vEnum[0]] = Number($iName)
EndFunc   ;==>__EnumResNamesProc
Func __EnumResTypesProc($hModule, $iType, $lParam)
	#forceref $hModule, $lParam
	Local $iLength = _WinAPI_StrLen($iType)
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $iType), 1)
		$__g_vEnum[$__g_vEnum[0]] = Number($iType)
EndFunc   ;==>__EnumResTypesProc
Func __EnumVerValuesProc($hModule, $iType, $iName, $iLanguage, $iDefault)
	Local $aRet, $iEnum = 1, $iError = 0
	Switch $iDefault
		Case -1
		Case 0x0400
			$iLanguage = 0x0400
			$iEnum = 0
			If $iLanguage <> $iDefault Then
				Return 1
		Local $pData = __ResLoad($hModule, $iType, $iName, $iLanguage)
		$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\VarFileInfo\Translation', 'ptr*', 0, 'uint*', 0)
		If @error Or Not $aRet[0] Or Not $aRet[4] Then
		Local $tData = DllStructCreate('ushort;ushort', $aRet[3])
	If Not $iError Then
		__Inc($__g_vEnum)
		$__g_vEnum[$__g_vEnum[0][0]][0] = DllStructGetData($tData, 1)
		Local $sCP = Hex(_WinAPI_MakeLong(DllStructGetData($tData, 2), DllStructGetData($tData, 1)), 8)
		For $i = 1 To $__g_vVal[0]
			$aRet = DllCall('version.dll', 'bool', 'VerQueryValueW', 'ptr', $pData, 'wstr', '\StringFileInfo\' & $sCP & '\' & $__g_vVal[$i], _
				$__g_vEnum[$__g_vEnum[0][0]][$i] = DllStructGetData(DllStructCreate('wchar[' & $aRet[4] & ']', $aRet[3]), 1)
				$__g_vEnum[$__g_vEnum[0][0]][$i] = ''
		$__g_vEnum = @error + 40
	If $__g_vEnum Then Return SetError($iError, 0, 0)
	Return $iEnum
EndFunc   ;==>__EnumVerValuesProc
Func __ResLoad($hInstance, $sType, $sName, $iLanguage)
	Local $hInfo = _WinAPI_FindResourceEx($hInstance, $sType, $sName, $iLanguage)
	If Not $hInfo Then Return SetError(@error + 10, @extended, 0)
	Local $iSize = _WinAPI_SizeOfResource($hInstance, $hInfo)
	If Not $iSize Then Return SetError(@error + 20, @extended, 0)
	Local $hData = _WinAPI_LoadResource($hInstance, $hInfo)
	If Not $hData Then Return SetError(@error + 30, @extended, 0)
	Local $pData = _WinAPI_LockResource($hData)
	If Not $pData Then Return SetError(@error + 40, @extended, 0)
	Return SetExtended($iSize, $pData)
EndFunc   ;==>__ResLoad
#region _Memory
Func _MemoryModuleGetBaseAddress($iPID, $sModule)
    If Not ProcessExists($iPID) Then Return SetError(1, 0, 0)
    If Not IsString($sModule) Then Return SetError(2, 0, 0)
    Local   $PSAPI = DllOpen("psapi.dll")
    Local   $hProcess
    Local   $PERMISSION = BitOR(0x0002, 0x0400, 0x0008, 0x0010, 0x0020) ; CREATE_THREAD, QUERY_INFORMATION, VM_OPERATION, VM_READ, VM_WRITE
    If $iPID > 0 Then
        Local $hProcess = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", $PERMISSION, "int", 0, "dword", $iPID)
        If $hProcess[0] Then
            $hProcess = $hProcess[0]
    Local   $Modules = DllStructCreate("ptr[1024]")
    Local   $aCall = DllCall($PSAPI, "int", "EnumProcessModules", "ptr", $hProcess, "ptr", DllStructGetPtr($Modules), "dword", DllStructGetSize($Modules), "dword*", 0)
    If $aCall[4] > 0 Then
        Local   $iModnum = $aCall[4] / 4
        Local   $aTemp
        For $i = 1 To $iModnum
            $aTemp =  DllCall($PSAPI, "dword", "GetModuleBaseNameW", "ptr", $hProcess, "ptr", Ptr(DllStructGetData($Modules, 1, $i)), "wstr", "", "dword", 260)
            If $aTemp[3] = $sModule Then
                DllClose($PSAPI)
                Return Ptr(DllStructGetData($Modules, 1, $i))
        Next
    DllClose($PSAPI)
    Return SetError(-1, 0, 0)
Func _MemoryOpen($iv_Pid, $iv_DesiredAccess = 0x1F0FFF, $iv_InheritHandle = 1)
	If Not ProcessExists($iv_Pid) Then
		SetError(1)
        Return 0
	Local $ah_Handle[2] = [DllOpen('kernel32.dll')]
        SetError(2)
	Local $av_OpenProcess = DllCall($ah_Handle[0], 'int', 'OpenProcess', 'int', $iv_DesiredAccess, 'int', $iv_InheritHandle, 'int', $iv_Pid)
        DllClose($ah_Handle[0])
        SetError(3)
	$ah_Handle[1] = $av_OpenProcess[0]
	Return $ah_Handle
Func _MemoryRead($iv_Address, $ah_Handle, $sv_Type = 'dword')
	If Not IsArray($ah_Handle) Then
	Local $v_Buffer = DllStructCreate($sv_Type)
		SetError(@Error + 1)
		Return 0
	DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
		Local $v_Value = DllStructGetData($v_Buffer, 1)
		Return $v_Value
		SetError(6)
Func _MemoryWrite($iv_Address, $ah_Handle, $v_Data, $sv_Type = 'dword')
		DllStructSetData($v_Buffer, 1, $v_Data)
			SetError(6)
			Return 0
	DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
		SetError(7)
Func _MemoryClose($ah_Handle)
	DllCall($ah_Handle[0], 'int', 'CloseHandle', 'int', $ah_Handle[1])
		DllClose($ah_Handle[0])
		SetError(2)
Func SetPrivilege( $privilege, $bEnable )
    Local $hToken, $SP_auxret, $SP_ret, $hCurrProcess, $nTokens, $nTokenIndex, $priv
    $nTokens = 1
    $LUID = DLLStructCreate("dword;int")
    If IsArray($privilege) Then    $nTokens = UBound($privilege)
    $TOKEN_PRIVILEGES = DLLStructCreate("dword;dword[" & (3 * $nTokens) & "]")
    $NEWTOKEN_PRIVILEGES = DLLStructCreate("dword;dword[" & (3 * $nTokens) & "]")
    $hCurrProcess = DLLCall("kernel32.dll","hwnd","GetCurrentProcess")
    $SP_auxret = DLLCall("advapi32.dll","int","OpenProcessToken","hwnd",$hCurrProcess[0],   _
            "int",BitOR($TOKEN_ADJUST_PRIVILEGES,$TOKEN_QUERY),"int_ptr",0)
    If $SP_auxret[0] Then
        $hToken = $SP_auxret[3]
        DLLStructSetData($TOKEN_PRIVILEGES,1,1)
        $nTokenIndex = 1
        While $nTokenIndex <= $nTokens
            If IsArray($privilege) Then
                $priv = $privilege[$nTokenIndex-1]
            Else
                $priv = $privilege
            $ret = DLLCall("advapi32.dll","int","LookupPrivilegeValue","str","","str",$priv,   _
                    "ptr",DLLStructGetPtr($LUID))
            If $ret[0] Then
                If $bEnable Then
                    DLLStructSetData($TOKEN_PRIVILEGES,2,$SE_PRIVILEGE_ENABLED,(3 * $nTokenIndex))
                Else
                    DLLStructSetData($TOKEN_PRIVILEGES,2,0,(3 * $nTokenIndex))
                EndIf
                DLLStructSetData($TOKEN_PRIVILEGES,2,DllStructGetData($LUID,1),(3 * ($nTokenIndex-1)) + 1)
                DLLStructSetData($TOKEN_PRIVILEGES,2,DllStructGetData($LUID,2),(3 * ($nTokenIndex-1)) + 2)
                DLLStructSetData($LUID,1,0)
                DLLStructSetData($LUID,2,0)
            $nTokenIndex += 1
        WEnd
        $ret = DLLCall("advapi32.dll","int","AdjustTokenPrivileges","hwnd",$hToken,"int",0,   _
                "ptr",DllStructGetPtr($TOKEN_PRIVILEGES),"int",DllStructGetSize($NEWTOKEN_PRIVILEGES),   _
                "ptr",DllStructGetPtr($NEWTOKEN_PRIVILEGES),"int_ptr",0)
        $f = DLLCall("kernel32.dll","int","GetLastError")
    $NEWTOKEN_PRIVILEGES=0
    $TOKEN_PRIVILEGES=0
    $LUID=0
    If $SP_auxret[0] = 0 Then Return 0
    $SP_auxret = DLLCall("kernel32.dll","int","CloseHandle","hwnd",$hToken)
    If Not $ret[0] And Not $SP_auxret[0] Then Return 0
    return $ret[0]
EndFunc   ;==>SetPrivilege
Global Const $BS_GROUPBOX = 0x0007
Global Const $BS_BOTTOM = 0x0800
Global Const $BS_CENTER = 0x0300
Global Const $BS_DEFPUSHBUTTON = 0x0001
Global Const $BS_LEFT = 0x0100
Global Const $BS_MULTILINE = 0x2000
Global Const $BS_PUSHBOX = 0x000A
Global Const $BS_PUSHLIKE = 0x1000
Global Const $BS_RIGHT = 0x0200
Global Const $BS_RIGHTBUTTON = 0x0020
Global Const $BS_TOP = 0x0400
Global Const $BS_VCENTER = 0x0C00
Global Const $BS_FLAT = 0x8000
Global Const $BS_ICON = 0x0040
Global Const $BS_BITMAP = 0x0080
Global Const $BS_NOTIFY = 0x4000
Global Const $BS_SPLITBUTTON = 0x0000000C
Global Const $BS_DEFSPLITBUTTON = 0x0000000D
Global Const $BS_COMMANDLINK = 0x0000000E
Global Const $BS_DEFCOMMANDLINK = 0x0000000F
Global Const $BCSIF_GLYPH = 0x0001
Global Const $BCSIF_IMAGE = 0x0002
Global Const $BCSIF_STYLE = 0x0004
Global Const $BCSIF_SIZE = 0x0008
Global Const $BCSS_NOSPLIT = 0x0001
Global Const $BCSS_STRETCH = 0x0002
Global Const $BCSS_ALIGNLEFT = 0x0004
Global Const $BCSS_IMAGE = 0x0008
Global Const $BUTTON_IMAGELIST_ALIGN_LEFT = 0
Global Const $BUTTON_IMAGELIST_ALIGN_RIGHT = 1
Global Const $BUTTON_IMAGELIST_ALIGN_TOP = 2
Global Const $BUTTON_IMAGELIST_ALIGN_BOTTOM = 3
Global Const $BUTTON_IMAGELIST_ALIGN_CENTER = 4 ; Doesn't draw text
Global Const $BS_3STATE = 0x0005
Global Const $BS_AUTO3STATE = 0x0006
Global Const $BS_AUTOCHECKBOX = 0x0003
Global Const $BS_CHECKBOX = 0x0002
Global Const $BS_RADIOBUTTON = 0x4
Global Const $BS_AUTORADIOBUTTON = 0x0009
Global Const $BS_OWNERDRAW = 0xB
Global Const $GUI_SS_DEFAULT_BUTTON = 0
Global Const $GUI_SS_DEFAULT_CHECKBOX = 0
Global Const $GUI_SS_DEFAULT_GROUP = 0
Global Const $GUI_SS_DEFAULT_RADIO = 0
Global Const $BCM_FIRST = 0x1600
Global Const $BCM_GETIDEALSIZE = ($BCM_FIRST + 0x0001)
Global Const $BCM_GETIMAGELIST = ($BCM_FIRST + 0x0003)
Global Const $BCM_GETNOTE = ($BCM_FIRST + 0x000A)
Global Const $BCM_GETNOTELENGTH = ($BCM_FIRST + 0x000B)
Global Const $BCM_GETSPLITINFO = ($BCM_FIRST + 0x0008)
Global Const $BCM_GETTEXTMARGIN = ($BCM_FIRST + 0x0005)
Global Const $BCM_SETDROPDOWNSTATE = ($BCM_FIRST + 0x0006)
Global Const $BCM_SETIMAGELIST = ($BCM_FIRST + 0x0002)
Global Const $BCM_SETNOTE = ($BCM_FIRST + 0x0009)
Global Const $BCM_SETSHIELD = ($BCM_FIRST + 0x000C)
Global Const $BCM_SETSPLITINFO = ($BCM_FIRST + 0x0007)
Global Const $BCM_SETTEXTMARGIN = ($BCM_FIRST + 0x0004)
Global Const $BM_CLICK = 0xF5
Global Const $BM_GETCHECK = 0xF0
Global Const $BM_GETIMAGE = 0xF6
Global Const $BM_GETSTATE = 0xF2
Global Const $BM_SETCHECK = 0xF1
Global Const $BM_SETDONTCLICK = 0xF8
Global Const $BM_SETIMAGE = 0xF7
Global Const $BM_SETSTATE = 0xF3
Global Const $BM_SETSTYLE = 0xF4
Global Const $BCN_FIRST = -1250
Global Const $BCN_DROPDOWN = ($BCN_FIRST + 0x0002)
Global Const $BCN_HOTITEMCHANGE = ($BCN_FIRST + 0x0001)
Global Const $BN_CLICKED = 0
Global Const $BN_PAINT = 1
Global Const $BN_HILITE = 2
Global Const $BN_UNHILITE = 3
Global Const $BN_DISABLE = 4
Global Const $BN_DOUBLECLICKED = 5
Global Const $BN_SETFOCUS = 6
Global Const $BN_KILLFOCUS = 7
Global Const $BN_PUSHED = $BN_HILITE
Global Const $BN_UNPUSHED = $BN_UNHILITE
Global Const $BN_DBLCLK = $BN_DOUBLECLICKED
Global Const $BST_CHECKED = 0x1
Global Const $BST_INDETERMINATE = 0x2
Global Const $BST_UNCHECKED = 0x0
Global Const $BST_FOCUS = 0x8
Global Const $BST_PUSHED = 0x4
Global Const $BST_DONTCLICK = 0x000080
#include "GDIPlusConstants.au3"
#include "StructureConstants.au3"
#include "WinAPIGdi.au3"
Global $__g_hGDIPBrush = 0
Global $__g_hGDIPDll = 0
Global $__g_hGDIPPen = 0
Global $__g_iGDIPRef = 0
Global $__g_iGDIPToken = 0
Global $__g_bGDIP_V1_0 = True
Func _GDIPlus_ArrowCapCreate($fHeight, $fWidth, $bFilled = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateAdjustableArrowCap", "float", $fHeight, "float", $fWidth, "bool", $bFilled, "handle*", 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)
	Return $aResult[4]
EndFunc   ;==>_GDIPlus_ArrowCapCreate
Func _GDIPlus_ArrowCapDispose($hCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteCustomLineCap", "handle", $hCap)
	If $aResult[0] Then Return SetError(10, $aResult[0], False)
	Return True
EndFunc   ;==>_GDIPlus_ArrowCapDispose
Func _GDIPlus_ArrowCapGetFillState($hArrowCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetAdjustableArrowCapFillState", "handle", $hArrowCap, "bool*", 0)
EndFunc   ;==>_GDIPlus_ArrowCapGetFillState
Func _GDIPlus_ArrowCapGetHeight($hArrowCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetAdjustableArrowCapHeight", "handle", $hArrowCap, "float*", 0)
	Return $aResult[2]
EndFunc   ;==>_GDIPlus_ArrowCapGetHeight
Func _GDIPlus_ArrowCapGetMiddleInset($hArrowCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetAdjustableArrowCapMiddleInset", "handle", $hArrowCap, "float*", 0)
EndFunc   ;==>_GDIPlus_ArrowCapGetMiddleInset
Func _GDIPlus_ArrowCapGetWidth($hArrowCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetAdjustableArrowCapWidth", "handle", $hArrowCap, "float*", 0)
EndFunc   ;==>_GDIPlus_ArrowCapGetWidth
Func _GDIPlus_ArrowCapSetFillState($hArrowCap, $bFilled = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetAdjustableArrowCapFillState", "handle", $hArrowCap, "bool", $bFilled)
EndFunc   ;==>_GDIPlus_ArrowCapSetFillState
Func _GDIPlus_ArrowCapSetHeight($hArrowCap, $fHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetAdjustableArrowCapHeight", "handle", $hArrowCap, "float", $fHeight)
EndFunc   ;==>_GDIPlus_ArrowCapSetHeight
Func _GDIPlus_ArrowCapSetMiddleInset($hArrowCap, $fInset)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetAdjustableArrowCapMiddleInset", "handle", $hArrowCap, "float", $fInset)
EndFunc   ;==>_GDIPlus_ArrowCapSetMiddleInset
Func _GDIPlus_ArrowCapSetWidth($hArrowCap, $fWidth)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetAdjustableArrowCapWidth", "handle", $hArrowCap, "float", $fWidth)
EndFunc   ;==>_GDIPlus_ArrowCapSetWidth
Func _GDIPlus_BitmapCloneArea($hBitmap, $nLeft, $nTop, $nWidth, $nHeight, $iFormat = 0x00021808)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneBitmapArea", "float", $nLeft, "float", $nTop, "float", $nWidth, "float", $nHeight, _
			"int", $iFormat, "handle", $hBitmap, "handle*", 0)
	Return $aResult[7]
EndFunc   ;==>_GDIPlus_BitmapCloneArea
Func _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
	Local $aRet = DllCall($__g_hGDIPDll, "uint", "GdipGetImageDimension", "handle", $hBitmap, "float*", 0, "float*", 0)
	If @error Or $aRet[0] Then Return SetError(@error + 10, $aRet[0], 0)
	Local $tData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $aRet[2], $aRet[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	Local $pBits = DllStructGetData($tData, "Scan0")
	If Not $pBits Then Return 0
	Local $tBIHDR = DllStructCreate($tagBITMAPV5HEADER)
	DllStructSetData($tBIHDR, "bV5Size", DllStructGetSize($tBIHDR))
	DllStructSetData($tBIHDR, "bV5Width", $aRet[2])
	DllStructSetData($tBIHDR, "bV5Height", $aRet[3])
	DllStructSetData($tBIHDR, "bV5Planes", 1)
	DllStructSetData($tBIHDR, "bV5BitCount", 32)
	DllStructSetData($tBIHDR, "bV5Compression", 0) ; $BI_BITFIELDS = 3, $BI_RGB = 0, $BI_RLE8 = 1, $BI_RLE4 = 2, $RGBA = 0x41424752
	DllStructSetData($tBIHDR, "bV5SizeImage", $aRet[3] * DllStructGetData($tData, "Stride"))
	DllStructSetData($tBIHDR, "bV5AlphaMask", 0xFF000000)
	DllStructSetData($tBIHDR, "bV5RedMask", 0x00FF0000)
	DllStructSetData($tBIHDR, "bV5GreenMask", 0x0000FF00)
	DllStructSetData($tBIHDR, "bV5BlueMask", 0x000000FF)
	DllStructSetData($tBIHDR, "bV5CSType", 2) ; $LCS_WINDOWS_COLOR_SPACE = 2
	DllStructSetData($tBIHDR, "bV5Intent", 4) ; $LCS_GM_IMA = 4
	Local $hHBitmapv5 = DllCall("gdi32.dll", "ptr", "CreateDIBSection", "hwnd", 0, "struct*", $tBIHDR, "uint", 0, "ptr*", 0, "ptr", 0, "dword", 0)
	If Not @error And $hHBitmapv5[0] Then
		DllCall("gdi32.dll", "dword", "SetBitmapBits", "ptr", $hHBitmapv5[0], "dword", $aRet[2] * $aRet[3] * 4, "ptr", DllStructGetData($tData, "Scan0"))
		$hHBitmapv5 = $hHBitmapv5[0]
		$hHBitmapv5 = 0
	_GDIPlus_BitmapUnlockBits($hBitmap, $tData)
	$tData = 0
	$tBIHDR = 0
	Return $hHBitmapv5
EndFunc   ;==>_GDIPlus_BitmapCreateDIBFromBitmap
Func _GDIPlus_BitmapCreateFromFile($sFileName)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromFile", "wstr", $sFileName, "handle*", 0)
EndFunc   ;==>_GDIPlus_BitmapCreateFromFile
Func _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromGraphics", "int", $iWidth, "int", $iHeight, "handle", $hGraphics, _
			"handle*", 0)
EndFunc   ;==>_GDIPlus_BitmapCreateFromGraphics
Func _GDIPlus_BitmapCreateFromHBITMAP($hBitmap, $hPal = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "handle", $hBitmap, "handle", $hPal, "handle*", 0)
	Return $aResult[3]
EndFunc   ;==>_GDIPlus_BitmapCreateFromHBITMAP
Func _GDIPlus_BitmapCreateFromMemory($dImage, $bHBITMAP = False)
	If Not IsBinary($dImage) Then Return SetError(1, 0, 0)
	Local $aResult = 0
	Local Const $dMemBitmap = Binary($dImage) ;load image saved in variable (memory) and convert it to binary
	Local Const $iLen = BinaryLen($dMemBitmap) ;get binary length of the image
	Local Const $GMEM_MOVEABLE = 0x0002
	$aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $GMEM_MOVEABLE, "ulong_ptr", $iLen) ;allocates movable memory ($GMEM_MOVEABLE = 0x0002)
	If @error Then Return SetError(4, 0, 0)
	Local Const $hData = $aResult[0]
	$aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hData)
	If @error Then Return SetError(5, 0, 0)
	Local $tMem = DllStructCreate("byte[" & $iLen & "]", $aResult[0]) ;create struct
	DllStructSetData($tMem, 1, $dMemBitmap) ;fill struct with image data
	DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hData) ;decrements the lock count associated with a memory object that was allocated with GMEM_MOVEABLE
	If @error Then Return SetError(6, 0, 0)
	Local Const $hStream = _WinAPI_CreateStreamOnHGlobal($hData) ;creates a stream object that uses an HGLOBAL memory handle to store the stream contents
	If @error Then Return SetError(2, 0, 0)
	Local Const $hBitmap = _GDIPlus_BitmapCreateFromStream($hStream) ;creates a Bitmap object based on an IStream COM interface
	If @error Then Return SetError(3, 0, 0)
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "ulong_ptr", 8 * (1 + @AutoItX64), "uint", 4, "ushort", 23, "uint", 0, "ptr", 0, "ptr", 0, "str", "") ;release memory from $hStream to avoid memory leak
	If $bHBITMAP Then
		Local Const $hHBmp = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap) ;supports GDI transparent color format
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBmp
	Return $hBitmap
EndFunc   ;==>_GDIPlus_BitmapCreateFromMemory
Func _GDIPlus_BitmapCreateFromResource($hInst, $vResourceName)
	Local $sType = "int"
	If IsString($vResourceName) Then $sType = "wstr"
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromResource", "handle", $hInst, $sType, $vResourceName, "handle*", 0)
EndFunc   ;==>_GDIPlus_BitmapCreateFromResource
Func _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iPixelFormat = $GDIP_PXF32ARGB, $iStride = 0, $pScan0 = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "int", $iPixelFormat, "struct*", $pScan0, "handle*", 0)
	Return $aResult[6]
EndFunc   ;==>_GDIPlus_BitmapCreateFromScan0
Func _GDIPlus_BitmapCreateFromStream($pStream)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromStream", "ptr", $pStream, "handle*", 0)
EndFunc   ;==>_GDIPlus_BitmapCreateFromStream
Func _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap, $iARGB = 0xFF000000)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateHBITMAPFromBitmap", "handle", $hBitmap, "handle*", 0, "dword", $iARGB)
EndFunc   ;==>_GDIPlus_BitmapCreateHBITMAPFromBitmap
Func _GDIPlus_BitmapDispose($hBitmap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
EndFunc   ;==>_GDIPlus_BitmapDispose
Func _GDIPlus_BitmapCreateFromHICON($hIcon)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateBitmapFromHICON", "handle", $hIcon, "handle*", 0)
EndFunc   ;==>_GDIPlus_BitmapCreateFromHICON
Func _GDIPlus_BitmapCreateFromHICON32($hIcon)
	Local $tSIZE = _WinAPI_GetIconDimension($hIcon)
	Local $iWidth = DllStructGetData($tSIZE, 'X')
	Local $iHeight = DllStructGetData($tSIZE, 'Y')
	If $iWidth <= 0 Or $iHeight <= 0 Then Return SetError(10, -1, 0)
	Local $tBITMAPINFO = DllStructCreate("dword Size;long Width;long Height;word Planes;word BitCount;dword Compression;dword SizeImage;long XPelsPerMeter;long YPelsPerMeter;dword ClrUsed;dword ClrImportant;dword RGBQuad")
	DllStructSetData($tBITMAPINFO, 'Size', DllStructGetSize($tBITMAPINFO) - 4)
	DllStructSetData($tBITMAPINFO, 'Width', $iWidth)
	DllStructSetData($tBITMAPINFO, 'Height', -$iHeight)
	DllStructSetData($tBITMAPINFO, 'Planes', 1)
	DllStructSetData($tBITMAPINFO, 'BitCount', 32)
	DllStructSetData($tBITMAPINFO, 'Compression', 0)
	DllStructSetData($tBITMAPINFO, 'SizeImage', 0)
	Local $hDC = _WinAPI_CreateCompatibleDC(0)
	Local $pBits
	Local $hBmp = _WinAPI_CreateDIBSection(0, $tBITMAPINFO, 0, $pBits)
	Local $hOrig = _WinAPI_SelectObject($hDC, $hBmp)
	_WinAPI_DrawIconEx($hDC, 0, 0, $hIcon, $iWidth, $iHeight)
	Local $hBitmapIcon = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $GDIP_PXF32ARGB, $iWidth * 4, $pBits)
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
	Local $hContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsDrawImage($hContext, $hBitmapIcon, 0, 0)
	_GDIPlus_GraphicsDispose($hContext)
	_GDIPlus_BitmapDispose($hBitmapIcon)
	_WinAPI_SelectObject($hDC, $hOrig)
	_WinAPI_DeleteDC($hDC)
	_WinAPI_DeleteObject($hBmp)
EndFunc   ;==>_GDIPlus_BitmapCreateFromHICON32
Func _GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapGetPixel", "handle", $hBitmap, "int", $iX, "int", $iY, "uint*", 0)
EndFunc   ;==>_GDIPlus_BitmapGetPixel
Func _GDIPlus_BitmapLockBits($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $iFlags = $GDIP_ILMREAD, $iFormat = $GDIP_PXF32RGB)
	Local $tData = DllStructCreate($tagGDIPBITMAPDATA)
	DllStructSetData($tRECT, "Left", $iLeft)
	DllStructSetData($tRECT, "Top", $iTop)
	DllStructSetData($tRECT, "Right", $iWidth)
	DllStructSetData($tRECT, "Bottom", $iHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapLockBits", "handle", $hBitmap, "struct*", $tRECT, "uint", $iFlags, "int", $iFormat, "struct*", $tData)
	Return $tData
EndFunc   ;==>_GDIPlus_BitmapLockBits
Func _GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, $iARGB)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapSetPixel", "handle", $hBitmap, "int", $iX, "int", $iY, "uint", $iARGB)
EndFunc   ;==>_GDIPlus_BitmapSetPixel
Func _GDIPlus_BitmapSetResolution($hBitmap, $fDpiX, $fDpiY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapSetResolution", "handle", $hBitmap, "float", $fDpiX, "float", $fDpiY)
EndFunc   ;==>_GDIPlus_BitmapSetResolution
Func _GDIPlus_BitmapUnlockBits($hBitmap, $tBitmapData)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapUnlockBits", "handle", $hBitmap, "struct*", $tBitmapData)
EndFunc   ;==>_GDIPlus_BitmapUnlockBits
Func _GDIPlus_BrushClone($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneBrush", "handle", $hBrush, "handle*", 0)
EndFunc   ;==>_GDIPlus_BrushClone
Func _GDIPlus_BrushCreateSolid($iARGB = 0xFF000000)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateSolidFill", "int", $iARGB, "handle*", 0)
EndFunc   ;==>_GDIPlus_BrushCreateSolid
Func _GDIPlus_BrushDispose($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteBrush", "handle", $hBrush)
EndFunc   ;==>_GDIPlus_BrushDispose
Func _GDIPlus_BrushGetSolidColor($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetSolidFillColor", "handle", $hBrush, "dword*", 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], -1)
EndFunc   ;==>_GDIPlus_BrushGetSolidColor
Func _GDIPlus_BrushGetType($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetBrushType", "handle", $hBrush, "int*", 0)
EndFunc   ;==>_GDIPlus_BrushGetType
Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetSolidFillColor", "handle", $hBrush, "dword", $iARGB)
EndFunc   ;==>_GDIPlus_BrushSetSolidColor
Func _GDIPlus_ColorMatrixCreate()
	Return _GDIPlus_ColorMatrixCreateScale(1, 1, 1, 1)
EndFunc   ;==>_GDIPlus_ColorMatrixCreate
Func _GDIPlus_ColorMatrixCreateGrayScale()
	Local $iI, $iJ, $tCM, $aLums[4] = [$GDIP_RLUM, $GDIP_GLUM, $GDIP_BLUM, 0]
	$tCM = DllStructCreate($tagGDIPCOLORMATRIX)
	For $iI = 0 To 3
		For $iJ = 1 To 3
			DllStructSetData($tCM, "m", $aLums[$iI], $iI * 5 + $iJ)
	DllStructSetData($tCM, "m", 1, 19)
	DllStructSetData($tCM, "m", 1, 25)
	Return $tCM
EndFunc   ;==>_GDIPlus_ColorMatrixCreateGrayScale
Func _GDIPlus_ColorMatrixCreateNegative()
	Local $iI, $tCM
	$tCM = _GDIPlus_ColorMatrixCreateScale(-1, -1, -1, 1)
	For $iI = 1 To 4
		DllStructSetData($tCM, "m", 1, 20 + $iI)
EndFunc   ;==>_GDIPlus_ColorMatrixCreateNegative
Func _GDIPlus_ColorMatrixCreateSaturation($fSat)
	Local $fSatComp, $tCM
	$fSatComp = (1 - $fSat)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_RLUM + $fSat, 1)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_RLUM, 2)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_RLUM, 3)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_GLUM, 6)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_GLUM + $fSat, 7)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_GLUM, 8)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_BLUM, 11)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_BLUM, 12)
	DllStructSetData($tCM, "m", $fSatComp * $GDIP_BLUM + $fSat, 13)
EndFunc   ;==>_GDIPlus_ColorMatrixCreateSaturation
Func _GDIPlus_ColorMatrixCreateScale($fRed, $fGreen, $fBlue, $fAlpha = 1)
	Local $tCM
	DllStructSetData($tCM, "m", $fRed, 1)
	DllStructSetData($tCM, "m", $fGreen, 7)
	DllStructSetData($tCM, "m", $fBlue, 13)
	DllStructSetData($tCM, "m", $fAlpha, 19)
EndFunc   ;==>_GDIPlus_ColorMatrixCreateScale
Func _GDIPlus_ColorMatrixCreateTranslate($fRed, $fGreen, $fBlue, $fAlpha = 0)
	Local $iI, $tCM, $aFactors[4] = [$fRed, $fGreen, $fBlue, $fAlpha]
	$tCM = _GDIPlus_ColorMatrixCreate()
		DllStructSetData($tCM, "m", $aFactors[$iI], 21 + $iI)
EndFunc   ;==>_GDIPlus_ColorMatrixCreateTranslate
Func _GDIPlus_CustomLineCapClone($hCustomLineCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneCustomLineCap", "handle", $hCustomLineCap, "handle*", 0)
	If $aResult[0] Then SetError(10, $aResult[0], 0)
EndFunc   ;==>_GDIPlus_CustomLineCapClone
Func _GDIPlus_CustomLineCapCreate($hPathFill, $hPathStroke, $iLineCap = 0, $nBaseInset = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateCustomLineCap", "handle", $hPathFill, "handle", $hPathStroke, "int", $iLineCap, "float", $nBaseInset, "handle*", 0)
	Return $aResult[5]
EndFunc   ;==>_GDIPlus_CustomLineCapCreate
Func _GDIPlus_CustomLineCapDispose($hCap)
EndFunc   ;==>_GDIPlus_CustomLineCapDispose
Func _GDIPlus_CustomLineCapGetStrokeCaps($hCustomLineCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCustomLineCapStrokeCaps", "hwnd", $hCustomLineCap, "ptr*", 0, "ptr*", 0)
	Local $aCaps[2]
	$aCaps[0] = $aResult[2]
	$aCaps[1] = $aResult[3]
	Return $aCaps
EndFunc   ;==>_GDIPlus_CustomLineCapGetStrokeCaps
Func _GDIPlus_CustomLineCapSetStrokeCaps($hCustomLineCap, $iStartCap, $iEndCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetCustomLineCapStrokeCaps", "handle", $hCustomLineCap, "int", $iStartCap, "int", $iEndCap)
	If $aResult[0] Then SetError(10, $aResult[0], False)
EndFunc   ;==>_GDIPlus_CustomLineCapSetStrokeCaps
Func _GDIPlus_Decoders()
	Local $iCount = _GDIPlus_DecodersGetCount()
	Local $iSize = _GDIPlus_DecodersGetSize()
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageDecoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $tCodec, $aInfo[$iCount + 1][14]
	$aInfo[0][0] = $iCount
	For $iI = 1 To $iCount
		$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
		$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
		$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
		$aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
		$aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
		$aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
		$aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
		$aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
		$aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
		$aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
		$aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
		$aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
		$aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
		$aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
		$pBuffer += DllStructGetSize($tCodec)
EndFunc   ;==>_GDIPlus_Decoders
Func _GDIPlus_DecodersGetCount()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageDecodersSize", "uint*", 0, "uint*", 0)
	Return $aResult[1]
EndFunc   ;==>_GDIPlus_DecodersGetCount
Func _GDIPlus_DecodersGetSize()
EndFunc   ;==>_GDIPlus_DecodersGetSize
Func _GDIPlus_DrawImagePoints($hGraphic, $hImage, $nULX, $nULY, $nURX, $nURY, $nLLX, $nLLY, $iCount = 3)
	Local $tPoint = DllStructCreate("float X;float Y;float X2;float Y2;float X3;float Y3")
	DllStructSetData($tPoint, "X", $nULX)
	DllStructSetData($tPoint, "Y", $nULY)
	DllStructSetData($tPoint, "X2", $nURX)
	DllStructSetData($tPoint, "Y2", $nURY)
	DllStructSetData($tPoint, "X3", $nLLX)
	DllStructSetData($tPoint, "Y3", $nLLY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImagePoints", "handle", $hGraphic, "handle", $hImage, "struct*", $tPoint, "int", $iCount)
EndFunc   ;==>_GDIPlus_DrawImagePoints
Func _GDIPlus_Encoders()
	Local $iCount = _GDIPlus_EncodersGetCount()
	Local $iSize = _GDIPlus_EncodersGetSize()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncoders", "uint", $iCount, "uint", $iSize, "struct*", $tBuffer)
EndFunc   ;==>_GDIPlus_Encoders
Func _GDIPlus_EncodersGetCLSID($sFileExtension)
	Local $aEncoders = _GDIPlus_Encoders()
	If @error Then Return SetError(@error, 0, "")
	For $iI = 1 To $aEncoders[0][0]
		If StringInStr($aEncoders[$iI][6], "*." & $sFileExtension) > 0 Then Return $aEncoders[$iI][1]
	Return SetError(-1, -1, "")
EndFunc   ;==>_GDIPlus_EncodersGetCLSID
Func _GDIPlus_EncodersGetCount()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
EndFunc   ;==>_GDIPlus_EncodersGetCount
Func _GDIPlus_EncodersGetParamList($hImage, $sEncoder)
	Local $iSize = _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $iRemainingSize = $iSize - 4 - _GDIPlus_ParamSize()
	If $iRemainingSize Then
		$tBuffer = DllStructCreate("dword Count;" & $tagGDIPENCODERPARAM & ";byte [" & $iRemainingSize & "]")
		$tBuffer = DllStructCreate("dword Count;" & $tagGDIPENCODERPARAM)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEncoderParameterList", "handle", $hImage, "struct*", $tGUID, "uint", $iSize, "struct*", $tBuffer)
	Return $tBuffer
EndFunc   ;==>_GDIPlus_EncodersGetParamList
Func _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEncoderParameterListSize", "handle", $hImage, "struct*", $tGUID, "uint*", 0)
EndFunc   ;==>_GDIPlus_EncodersGetParamListSize
Func _GDIPlus_EncodersGetSize()
EndFunc   ;==>_GDIPlus_EncodersGetSize
Func _GDIPlus_FontCreate($hFamily, $fSize, $iStyle = 0, $iUnit = 3)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFont", "handle", $hFamily, "float", $fSize, "int", $iStyle, "int", $iUnit, "handle*", 0)
EndFunc   ;==>_GDIPlus_FontCreate
Func _GDIPlus_FontDispose($hFont)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteFont", "handle", $hFont)
EndFunc   ;==>_GDIPlus_FontDispose
Func _GDIPlus_FontFamilyCreate($sFamily, $pCollection = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFontFamilyFromName", "wstr", $sFamily, "ptr", $pCollection, "handle*", 0)
EndFunc   ;==>_GDIPlus_FontFamilyCreate
Func _GDIPlus_FontFamilyCreateFromCollection($sFontName, $hFontCollection)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFontFamilyFromName", "wstr", $sFontName, "ptr", $hFontCollection, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, "")
	If $aResult[0] Then Return SetError(10, $aResult[0], "")
EndFunc   ;==>_GDIPlus_FontFamilyCreateFromCollection
Func _GDIPlus_FontFamilyDispose($hFamily)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteFontFamily", "handle", $hFamily)
EndFunc   ;==>_GDIPlus_FontFamilyDispose
Func _GDIPlus_FontFamilyGetCellAscent($hFontFamily, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCellAscent", "handle", $hFontFamily, "int", $iStyle, "ushort*", 0)
EndFunc   ;==>_GDIPlus_FontFamilyGetCellAscent
Func _GDIPlus_FontFamilyGetCellDescent($hFontFamily, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCellDescent", "handle", $hFontFamily, "int", $iStyle, "ushort*", 0)
EndFunc   ;==>_GDIPlus_FontFamilyGetCellDescent
Func _GDIPlus_FontFamilyGetEmHeight($hFontFamily, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEmHeight", "handle", $hFontFamily, "int", $iStyle, "ushort*", 0)
EndFunc   ;==>_GDIPlus_FontFamilyGetEmHeight
Func _GDIPlus_FontFamilyGetLineSpacing($hFontFamily, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetLineSpacing", "handle", $hFontFamily, "int", $iStyle, "ushort*", 0)
EndFunc   ;==>_GDIPlus_FontFamilyGetLineSpacing
Func _GDIPlus_FontGetHeight($hFont, $hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetFontHeight", "handle", $hFont, "handle", $hGraphics, "float*", 0)
EndFunc   ;==>_GDIPlus_FontGetHeight
Func _GDIPlus_FontPrivateAddFont($hFontCollection, $sFontFile)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPrivateAddFontFile", "ptr", $hFontCollection, "wstr", $sFontFile)
EndFunc   ;==>_GDIPlus_FontPrivateAddFont
Func _GDIPlus_FontPrivateAddMemoryFont($hFontCollection, $tFont)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPrivateAddMemoryFont", "handle", $hFontCollection, "struct*", $tFont, "int", DllStructGetSize($tFont))
EndFunc   ;==>_GDIPlus_FontPrivateAddMemoryFont
Func _GDIPlus_FontPrivateCollectionDispose($hFontCollection)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeletePrivateFontCollection", "handle*", $hFontCollection)
EndFunc   ;==>_GDIPlus_FontPrivateCollectionDispose
Func _GDIPlus_FontPrivateCreateCollection()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipNewPrivateFontCollection", "ptr*", 0)
EndFunc   ;==>_GDIPlus_FontPrivateCreateCollection
Func _GDIPlus_GraphicsClear($hGraphics, $iARGB = 0xFF000000)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGraphicsClear", "handle", $hGraphics, "dword", $iARGB)
EndFunc   ;==>_GDIPlus_GraphicsClear
Func _GDIPlus_GraphicsCreateFromHDC($hDC)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFromHDC", "handle", $hDC, "handle*", 0)
EndFunc   ;==>_GDIPlus_GraphicsCreateFromHDC
Func _GDIPlus_GraphicsCreateFromHWND($hWnd)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateFromHWND", "hwnd", $hWnd, "handle*", 0)
EndFunc   ;==>_GDIPlus_GraphicsCreateFromHWND
Func _GDIPlus_GraphicsDispose($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
EndFunc   ;==>_GDIPlus_GraphicsDispose
Func _GDIPlus_GraphicsDrawArc($hGraphics, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawArc", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight, "float", $fStartAngle, "float", $fSweepAngle)
	__GDIPlus_PenDefDispose() ; does destroyed @error, @extended
EndFunc   ;==>_GDIPlus_GraphicsDrawArc
Func _GDIPlus_GraphicsDrawBezier($hGraphics, $nX1, $nY1, $nX2, $nY2, $nX3, $nY3, $nX4, $nY4, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawBezier", "handle", $hGraphics, "handle", $hPen, "float", $nX1, "float", $nY1, _
			"float", $nX2, "float", $nY2, "float", $nX3, "float", $nY3, "float", $nX4, "float", $nY4)
EndFunc   ;==>_GDIPlus_GraphicsDrawBezier
Func _GDIPlus_GraphicsDrawClosedCurve($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawClosedCurve", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
EndFunc   ;==>_GDIPlus_GraphicsDrawClosedCurve
Func _GDIPlus_GraphicsDrawClosedCurve2($hGraphics, $aPoints, $nTension, $hPen = 0)
	Local $iI, $iCount, $tPoints, $aResult
	$iCount = $aPoints[0][0]
	$tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawClosedCurve2", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount, "float", $nTension)
EndFunc   ;==>_GDIPlus_GraphicsDrawClosedCurve2
Func _GDIPlus_GraphicsDrawCurve($hGraphics, $aPoints, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawCurve", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
EndFunc   ;==>_GDIPlus_GraphicsDrawCurve
Func _GDIPlus_GraphicsDrawCurve2($hGraphics, $aPoints, $nTension, $hPen = 0)
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawCurve2", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount, "float", $nTension)
EndFunc   ;==>_GDIPlus_GraphicsDrawCurve2
Func _GDIPlus_GraphicsDrawEllipse($hGraphics, $nX, $nY, $nWidth, $nHeight, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawEllipse", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, _
			"float", $nWidth, "float", $nHeight)
EndFunc   ;==>_GDIPlus_GraphicsDrawEllipse
Func _GDIPlus_GraphicsDrawImage($hGraphics, $hImage, $nX, $nY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImage", "handle", $hGraphics, "handle", $hImage, "float", $nX, "float", $nY)
EndFunc   ;==>_GDIPlus_GraphicsDrawImage
Func _GDIPlus_GraphicsDrawImagePointsRect($hGraphics, $hImage, $nULX, $nULY, $nURX, $nURY, $nLLX, $nLLY, $nSrcX, $nSrcY, $nSrcWidth, $nSrcHeight, $hImageAttributes = 0, $iUnit = 2)
	Local $tPoints = DllStructCreate("float X; float Y; float X2; float Y2; float X3; float Y3;")
	DllStructSetData($tPoints, "X", $nULX)
	DllStructSetData($tPoints, "Y", $nULY)
	DllStructSetData($tPoints, "X2", $nURX)
	DllStructSetData($tPoints, "Y2", $nURY)
	DllStructSetData($tPoints, "X3", $nLLX)
	DllStructSetData($tPoints, "Y3", $nLLY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImagePointsRect", "handle", $hGraphics, "handle", $hImage, "struct*", $tPoints, "int", 3, "float", $nSrcX, "float", $nSrcY, "float", $nSrcWidth, "float", $nSrcHeight, "int", $iUnit, "handle", $hImageAttributes, "ptr", 0, "ptr", 0)
EndFunc   ;==>_GDIPlus_GraphicsDrawImagePointsRect
Func _GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $nX, $nY, $nW, $nH)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImageRect", "handle", $hGraphics, "handle", $hImage, "float", $nX, "float", $nY, _
			"float", $nW, "float", $nH)
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRect
Func _GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hImage, $nSrcX, $nSrcY, $nSrcWidth, $nSrcHeight, $nDstX, $nDstY, $nDstWidth, $nDstHeight, $pAttributes = 0, $iUnit = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImageRectRect", "handle", $hGraphics, "handle", $hImage, _
			"float", $nDstX, "float", $nDstY, "float", $nDstWidth, "float", $nDstHeight, _
			"float", $nSrcX, "float", $nSrcY, "float", $nSrcWidth, "float", $nSrcHeight, _
			"int", $iUnit, "handle", $pAttributes, "ptr", 0, "ptr", 0)
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRectRect
Func _GDIPlus_GraphicsDrawLine($hGraphics, $nX1, $nY1, $nX2, $nY2, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawLine", "handle", $hGraphics, "handle", $hPen, "float", $nX1, "float", $nY1, _
			"float", $nX2, "float", $nY2)
EndFunc   ;==>_GDIPlus_GraphicsDrawLine
Func _GDIPlus_GraphicsDrawPath($hGraphics, $hPath, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawPath", "handle", $hGraphics, "handle", $hPen, "handle", $hPath)
EndFunc   ;==>_GDIPlus_GraphicsDrawPath
Func _GDIPlus_GraphicsDrawPie($hGraphics, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawPie", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, _
EndFunc   ;==>_GDIPlus_GraphicsDrawPie
Func _GDIPlus_GraphicsDrawPolygon($hGraphics, $aPoints, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawPolygon", "handle", $hGraphics, "handle", $hPen, "struct*", $tPoints, "int", $iCount)
EndFunc   ;==>_GDIPlus_GraphicsDrawPolygon
Func _GDIPlus_GraphicsDrawRect($hGraphics, $nX, $nY, $nWidth, $nHeight, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawRectangle", "handle", $hGraphics, "handle", $hPen, "float", $nX, "float", $nY, _
EndFunc   ;==>_GDIPlus_GraphicsDrawRect
Func _GDIPlus_GraphicsDrawString($hGraphics, $sString, $nX, $nY, $sFont = "Arial", $fSize = 10, $iFormat = 0)
	Local $hBrush = _GDIPlus_BrushCreateSolid()
	Local $hFormat = _GDIPlus_StringFormatCreate($iFormat)
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $fSize)
	Local $tLayout = _GDIPlus_RectFCreate($nX, $nY, 0.0, 0.0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	Local $aResult = _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	Local $iError = @error, $iExtended = @extended
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	Return SetError($iError, $iExtended, $aResult)
EndFunc   ;==>_GDIPlus_GraphicsDrawString
Func _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $tLayout, $hFormat, $hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, _
			"struct*", $tLayout, "handle", $hFormat, "handle", $hBrush)
EndFunc   ;==>_GDIPlus_GraphicsDrawStringEx
Func _GDIPlus_GraphicsFillClosedCurve($hGraphics, $aPoints, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillClosedCurve", "handle", $hGraphics, "handle", $hBrush, "struct*", $tPoints, "int", $iCount)
	__GDIPlus_BrushDefDispose()
EndFunc   ;==>_GDIPlus_GraphicsFillClosedCurve
Func _GDIPlus_GraphicsFillClosedCurve2($hGraphics, $aPoints, $nTension, $hBrush = 0, $iFillMode = 0)
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipFillClosedCurve2", "handle", $hGraphics, "handle", $hBrush, "struct*", $tPoints, "int", $iCount, "float", $nTension, "int", $iFillMode)
EndFunc   ;==>_GDIPlus_GraphicsFillClosedCurve2
Func _GDIPlus_GraphicsFillEllipse($hGraphics, $nX, $nY, $nWidth, $nHeight, $hBrush = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillEllipse", "handle", $hGraphics, "handle", $hBrush, "float", $nX, "float", $nY, _
EndFunc   ;==>_GDIPlus_GraphicsFillEllipse
Func _GDIPlus_GraphicsFillPath($hGraphics, $hPath, $hBrush = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillPath", "handle", $hGraphics, "handle", $hBrush, "handle", $hPath)
EndFunc   ;==>_GDIPlus_GraphicsFillPath
Func _GDIPlus_GraphicsFillPie($hGraphics, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle, $hBrush = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillPie", "handle", $hGraphics, "handle", $hBrush, "float", $nX, "float", $nY, _
EndFunc   ;==>_GDIPlus_GraphicsFillPie
Func _GDIPlus_GraphicsFillPolygon($hGraphics, $aPoints, $hBrush = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillPolygon", "handle", $hGraphics, "handle", $hBrush, _
			"struct*", $tPoints, "int", $iCount, "int", "FillModeAlternate")
EndFunc   ;==>_GDIPlus_GraphicsFillPolygon
Func _GDIPlus_GraphicsFillRect($hGraphics, $nX, $nY, $nWidth, $nHeight, $hBrush = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillRectangle", "handle", $hGraphics, "handle", $hBrush, "float", $nX, "float", $nY, _
EndFunc   ;==>_GDIPlus_GraphicsFillRect
Func _GDIPlus_GraphicsFillRegion($hGraphics, $hRegion, $hBrush = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFillRegion", "handle", $hGraphics, "handle", $hBrush, "handle", $hRegion)
EndFunc   ;==>_GDIPlus_GraphicsFillRegion
Func _GDIPlus_GraphicsGetCompositingMode($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCompositingMode", "handle", $hGraphics, "int*", 0)
EndFunc   ;==>_GDIPlus_GraphicsGetCompositingMode
Func _GDIPlus_GraphicsGetCompositingQuality($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetCompositingQuality", "handle", $hGraphics, "int*", 0)
EndFunc   ;==>_GDIPlus_GraphicsGetCompositingQuality
Func _GDIPlus_GraphicsGetDC($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDC", "handle", $hGraphics, "handle*", 0)
EndFunc   ;==>_GDIPlus_GraphicsGetDC
Func _GDIPlus_GraphicsGetInterpolationMode($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetInterpolationMode", "handle", $hGraphics, "int*", 0)
EndFunc   ;==>_GDIPlus_GraphicsGetInterpolationMode
Func _GDIPlus_GraphicsGetSmoothingMode($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetSmoothingMode", "handle", $hGraphics, "int*", 0)
	Switch $aResult[2]
		Case $GDIP_SMOOTHINGMODE_NONE
		Case $GDIP_SMOOTHINGMODE_HIGHQUALITY, $GDIP_SMOOTHINGMODE_ANTIALIAS8X4
			Return 1
		Case $GDIP_SMOOTHINGMODE_ANTIALIAS8X8
			Return 2
EndFunc   ;==>_GDIPlus_GraphicsGetSmoothingMode
Func _GDIPlus_GraphicsGetTransform($hGraphics, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetWorldTransform", "handle", $hGraphics, "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_GraphicsGetTransform
Func _GDIPlus_GraphicsMeasureCharacterRanges($hGraphics, $sString, $hFont, $tLayout, $hStringFormat)
	Local $iCount = _GDIPlus_StringFormatGetMeasurableCharacterRangeCount($hStringFormat)
	Local $tRegions = DllStructCreate("handle[" & $iCount & "]")
	Local $aRegions[$iCount + 1] = [$iCount]
		$aRegions[$iI] = _GDIPlus_RegionCreate()
		DllStructSetData($tRegions, 1, $aRegions[$iI], $iI)
	DllCall($__g_hGDIPDll, "int", "GdipMeasureCharacterRanges", "handle", $hGraphics, "wstr", $sString, "int", -1, "hwnd", $hFont, "struct*", $tLayout, "handle", $hStringFormat, "int", $iCount, "struct*", $tRegions)
	If $iError Then
		For $iI = 1 To $iCount
			_GDIPlus_RegionDispose($aRegions[$iI])
		Return SetError($iError + 10, $iExtended, 0)
	Return $aRegions
EndFunc   ;==>_GDIPlus_GraphicsMeasureCharacterRanges
Func _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	Local $tRECTF = DllStructCreate($tagGDIPRECTF)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipMeasureString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, _
			"struct*", $tLayout, "handle", $hFormat, "struct*", $tRECTF, "int*", 0, "int*", 0)
	Local $aInfo[3]
	$aInfo[0] = $tRECTF
	$aInfo[1] = $aResult[8]
	$aInfo[2] = $aResult[9]
EndFunc   ;==>_GDIPlus_GraphicsMeasureString
Func _GDIPlus_GraphicsReleaseDC($hGraphics, $hDC)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipReleaseDC", "handle", $hGraphics, "handle", $hDC)
EndFunc   ;==>_GDIPlus_GraphicsReleaseDC
Func _GDIPlus_GraphicsResetClip($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetClip", "handle", $hGraphics)
EndFunc   ;==>_GDIPlus_GraphicsResetClip
Func _GDIPlus_GraphicsResetTransform($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetWorldTransform", "handle", $hGraphics)
EndFunc   ;==>_GDIPlus_GraphicsResetTransform
Func _GDIPlus_GraphicsRestore($hGraphics, $iState)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipRestoreGraphics", "handle", $hGraphics, "uint", $iState)
EndFunc   ;==>_GDIPlus_GraphicsRestore
Func _GDIPlus_GraphicsRotateTransform($hGraphics, $fAngle, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipRotateWorldTransform", "handle", $hGraphics, "float", $fAngle, "int", $iOrder)
EndFunc   ;==>_GDIPlus_GraphicsRotateTransform
Func _GDIPlus_GraphicsSave($hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveGraphics", "handle", $hGraphics, "uint*", 0)
EndFunc   ;==>_GDIPlus_GraphicsSave
Func _GDIPlus_GraphicsScaleTransform($hGraphics, $fScaleX, $fScaleY, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipScaleWorldTransform", "handle", $hGraphics, "float", $fScaleX, "float", $fScaleY, "int", $iOrder)
EndFunc   ;==>_GDIPlus_GraphicsScaleTransform
Func _GDIPlus_GraphicsSetClipPath($hGraphics, $hPath, $iCombineMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetClipPath", "handle", $hGraphics, "handle", $hPath, "int", $iCombineMode)
EndFunc   ;==>_GDIPlus_GraphicsSetClipPath
Func _GDIPlus_GraphicsSetClipRect($hGraphics, $nX, $nY, $nWidth, $nHeight, $iCombineMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetClipRect", "handle", $hGraphics, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "int", $iCombineMode)
EndFunc   ;==>_GDIPlus_GraphicsSetClipRect
Func _GDIPlus_GraphicsSetClipRegion($hGraphics, $hRegion, $iCombineMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetClipRegion", "handle", $hGraphics, "handle", $hRegion, "int", $iCombineMode)
EndFunc   ;==>_GDIPlus_GraphicsSetClipRegion
Func _GDIPlus_GraphicsSetCompositingMode($hGraphics, $iCompositionMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetCompositingMode", "handle", $hGraphics, "int", $iCompositionMode)
EndFunc   ;==>_GDIPlus_GraphicsSetCompositingMode
Func _GDIPlus_GraphicsSetCompositingQuality($hGraphics, $iCompositionQuality)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetCompositingQuality", "handle", $hGraphics, "int", $iCompositionQuality)
EndFunc   ;==>_GDIPlus_GraphicsSetCompositingQuality
Func _GDIPlus_GraphicsSetInterpolationMode($hGraphics, $iInterpolationMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetInterpolationMode", "handle", $hGraphics, "int", $iInterpolationMode)
EndFunc   ;==>_GDIPlus_GraphicsSetInterpolationMode
Func _GDIPlus_GraphicsSetPixelOffsetMode($hGraphics, $iPixelOffsetMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPixelOffsetMode", "handle", $hGraphics, "int", $iPixelOffsetMode)
EndFunc   ;==>_GDIPlus_GraphicsSetPixelOffsetMode
Func _GDIPlus_GraphicsSetSmoothingMode($hGraphics, $iSmooth)
	If $iSmooth < $GDIP_SMOOTHINGMODE_DEFAULT Or $iSmooth > $GDIP_SMOOTHINGMODE_ANTIALIAS8X8 Then $iSmooth = $GDIP_SMOOTHINGMODE_DEFAULT
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetSmoothingMode", "handle", $hGraphics, "int", $iSmooth)
EndFunc   ;==>_GDIPlus_GraphicsSetSmoothingMode
Func _GDIPlus_GraphicsSetTextRenderingHint($hGraphics, $iTextRenderingHint)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetTextRenderingHint", "handle", $hGraphics, "int", $iTextRenderingHint)
EndFunc   ;==>_GDIPlus_GraphicsSetTextRenderingHint
Func _GDIPlus_GraphicsSetTransform($hGraphics, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetWorldTransform", "handle", $hGraphics, "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_GraphicsSetTransform
Func _GDIPlus_GraphicsTransformPoints($hGraphics, ByRef $aPoints, $iCoordSpaceTo = 0, $iCoordSpaceFrom = 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], ($iI - 1) * 2 + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], ($iI - 1) * 2 + 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTransformPoints", "handle", $hGraphics, "int", $iCoordSpaceTo, "int", $iCoordSpaceFrom, "struct*", $tPoints, "int", $iCount)
		$aPoints[$iI][0] = DllStructGetData($tPoints, 1, ($iI - 1) * 2 + 1)
		$aPoints[$iI][1] = DllStructGetData($tPoints, 1, ($iI - 1) * 2 + 2)
EndFunc   ;==>_GDIPlus_GraphicsTransformPoints
Func _GDIPlus_GraphicsTranslateTransform($hGraphics, $nDX, $nDY, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTranslateWorldTransform", "handle", $hGraphics, "float", $nDX, "float", $nDY, "int", $iOrder)
EndFunc   ;==>_GDIPlus_GraphicsTranslateTransform
Func _GDIPlus_HatchBrushCreate($iHatchStyle = 0, $iARGBForeground = 0xFFFFFFFF, $iARGBBackground = 0xFFFFFFFF)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateHatchBrush", "int", $iHatchStyle, "uint", $iARGBForeground, "uint", $iARGBBackground, "handle*", 0)
EndFunc   ;==>_GDIPlus_HatchBrushCreate
Func _GDIPlus_HICONCreateFromBitmap($hBitmap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateHICONFromBitmap", "handle", $hBitmap, "handle*", 0)
EndFunc   ;==>_GDIPlus_HICONCreateFromBitmap
Func _GDIPlus_ImageAttributesCreate()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateImageAttributes", "handle*", 0)
EndFunc   ;==>_GDIPlus_ImageAttributesCreate
Func _GDIPlus_ImageAttributesDispose($hImageAttributes)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImageAttributes", "handle", $hImageAttributes)
EndFunc   ;==>_GDIPlus_ImageAttributesDispose
Func _GDIPlus_ImageAttributesSetColorKeys($hImageAttributes, $iColorAdjustType = 0, $bEnable = False, $iARGBLow = 0, $iARGBHigh = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesColorKeys", "handle", $hImageAttributes, "int", $iColorAdjustType, "int", $bEnable, "uint", $iARGBLow, "uint", $iARGBHigh)
EndFunc   ;==>_GDIPlus_ImageAttributesSetColorKeys
Func _GDIPlus_ImageAttributesSetColorMatrix($hImageAttributes, $iColorAdjustType = 0, $bEnable = False, $tClrMatrix = 0, $tGrayMatrix = 0, $iColorMatrixFlags = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesColorMatrix", "handle", $hImageAttributes, "int", $iColorAdjustType, "int", $bEnable, "struct*", $tClrMatrix, "struct*", $tGrayMatrix, "int", $iColorMatrixFlags)
EndFunc   ;==>_GDIPlus_ImageAttributesSetColorMatrix
Func _GDIPlus_ImageAttributesSetRemapTable($hImageAttributes, $aColorMap = 0, $iColorAdjustType = 0, $bEnable = True)
	Local $aResult
	If IsArray($aColorMap) Then
		Local $iCount = $aColorMap[0][0]
		Local $tColorMap = DllStructCreate("uint[" & $iCount * 2 & "]")
			DllStructSetData($tColorMap, 1, $aColorMap[$i][0], ($i - 1) * 2 + 1)
			DllStructSetData($tColorMap, 1, $aColorMap[$i][1], ($i - 1) * 2 + 2)
		$aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesRemapTable", "handle", $hImageAttributes, "int", $iColorAdjustType, "int", $bEnable, "int", $iCount, "struct*", $tColorMap)
		$aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesRemapTable", "handle", $hImageAttributes, "int", $iColorAdjustType, "int", $bEnable, "int", 0, "struct*", 0)
EndFunc   ;==>_GDIPlus_ImageAttributesSetRemapTable
Func _GDIPlus_ImageAttributesSetThreshold($hImageAttributes, $fThreshold, $iColorAdjustType = $GDIP_COLORADJUSTTYPE_DEFAULT, $bEnable = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetImageAttributesThreshold", "handle", $hImageAttributes, "int", $iColorAdjustType, "bool", $bEnable, "float", $fThreshold)
EndFunc   ;==>_GDIPlus_ImageAttributesSetThreshold
Func _GDIPlus_ImageClone($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneImage", "handle", $hImage, "handle*", 0)
EndFunc   ;==>_GDIPlus_ImageClone
Func _GDIPlus_ImageDispose($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDisposeImage", "handle", $hImage)
EndFunc   ;==>_GDIPlus_ImageDispose
Func _GDIPlus_ImageGetDimension($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageDimension", "handle", $hImage, "float*", 0, "float*", 0)
	Local $aImgDim[2] = [$aResult[2], $aResult[3]]
	Return $aImgDim
EndFunc   ;==>_GDIPlus_ImageGetDimension
Func _GDIPlus_ImageGetFlags($hImage)
	Local $aFlag[2] = [0, ""]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, $aFlag)
	Local $aImageFlags[13][2] = _
			[["Pixel data Cacheable", $GDIP_IMAGEFLAGS_CACHING], _
			["Pixel data read-only", $GDIP_IMAGEFLAGS_READONLY], _
			["Pixel size in image", $GDIP_IMAGEFLAGS_HASREALPIXELSIZE], _
			["DPI info in image", $GDIP_IMAGEFLAGS_HASREALDPI], _
			["YCCK color space", $GDIP_IMAGEFLAGS_COLORSPACE_YCCK], _
			["YCBCR color space", $GDIP_IMAGEFLAGS_COLORSPACE_YCBCR], _
			["Grayscale image", $GDIP_IMAGEFLAGS_COLORSPACE_GRAY], _
			["CMYK color space", $GDIP_IMAGEFLAGS_COLORSPACE_CMYK], _
			["RGB color space", $GDIP_IMAGEFLAGS_COLORSPACE_RGB], _
			["Partially scalable", $GDIP_IMAGEFLAGS_PARTIALLYSCALABLE], _
			["Alpha values other than 0 (transparent) and 255 (opaque)", $GDIP_IMAGEFLAGS_HASTRANSLUCENT], _
			["Alpha values", $GDIP_IMAGEFLAGS_HASALPHA], _
			["Scalable", $GDIP_IMAGEFLAGS_SCALABLE]]
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageFlags", "handle", $hImage, "long*", 0)
	If @error Then Return SetError(@error, @extended, $aFlag)
	If $aResult[0] Then Return SetError(10, $aResult[0], $aFlag)
	If $aResult[2] = $GDIP_IMAGEFLAGS_NONE Then
		$aFlag[1] = "No pixel data"
		Return SetError(12, $aResult[2], $aFlag)
	$aFlag[0] = $aResult[2]
	For $i = 0 To 12
		If BitAND($aResult[2], $aImageFlags[$i][1]) = $aImageFlags[$i][1] Then
			If StringLen($aFlag[1]) Then $aFlag[1] &= "|"
			$aResult[2] -= $aImageFlags[$i][1]
			$aFlag[1] &= $aImageFlags[$i][0]
	Return $aFlag
EndFunc   ;==>_GDIPlus_ImageGetFlags
Func _GDIPlus_ImageGetFrameCount($hImage, $sDimensionID)
	Local $tGUID = _WinAPI_GUIDFromString($sDimensionID)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipImageGetFrameCount", "handle", $hImage, "struct*", $tGUID, "uint*", 0)
EndFunc   ;==>_GDIPlus_ImageGetFrameCount
Func _GDIPlus_ImageGetGraphicsContext($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageGraphicsContext", "handle", $hImage, "handle*", 0)
EndFunc   ;==>_GDIPlus_ImageGetGraphicsContext
Func _GDIPlus_ImageGetHeight($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageHeight", "handle", $hImage, "uint*", 0)
EndFunc   ;==>_GDIPlus_ImageGetHeight
Func _GDIPlus_ImageGetHorizontalResolution($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageHorizontalResolution", "handle", $hImage, "float*", 0)
	Return Round($aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetHorizontalResolution
Func _GDIPlus_ImageGetPixelFormat($hImage)
	Local $aFormat[2] = [0, ""]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, $aFormat)
	Local $aPixelFormat[14][2] = _
			[["1 Bpp Indexed", $GDIP_PXF01INDEXED], _
			["4 Bpp Indexed", $GDIP_PXF04INDEXED], _
			["8 Bpp Indexed", $GDIP_PXF08INDEXED], _
			["16 Bpp Grayscale", $GDIP_PXF16GRAYSCALE], _
			["16 Bpp RGB 555", $GDIP_PXF16RGB555], _
			["16 Bpp RGB 565", $GDIP_PXF16RGB565], _
			["16 Bpp ARGB 1555", $GDIP_PXF16ARGB1555], _
			["24 Bpp RGB", $GDIP_PXF24RGB], _
			["32 Bpp RGB", $GDIP_PXF32RGB], _
			["32 Bpp ARGB", $GDIP_PXF32ARGB], _
			["32 Bpp PARGB", $GDIP_PXF32PARGB], _
			["48 Bpp RGB", $GDIP_PXF48RGB], _
			["64 Bpp ARGB", $GDIP_PXF64ARGB], _
			["64 Bpp PARGB", $GDIP_PXF64PARGB]]
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImagePixelFormat", "handle", $hImage, "int*", 0)
	If @error Then Return SetError(@error, @extended, $aFormat)
	If $aResult[0] Then Return SetError(10, $aResult[0], $aFormat)
	For $i = 0 To 13
		If $aPixelFormat[$i][1] = $aResult[2] Then
			$aFormat[0] = $aPixelFormat[$i][1]
			$aFormat[1] = $aPixelFormat[$i][0]
			Return $aFormat
	Return SetError(12, 0, $aFormat)
EndFunc   ;==>_GDIPlus_ImageGetPixelFormat
Func __GDIPlus_ImageGetPropertyCount($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyCount", "handle", $hImage, "uint*", 0)
EndFunc   ;==>__GDIPlus_ImageGetPropertyCount
Func _GDIPlus_ImageGetPropertyIdList($hImage)
	Local $iCount = __GDIPlus_ImageGetPropertyCount($hImage)
	Local $tProperties = DllStructCreate("uint[" & $iCount & "]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyIdList", "handle", $hImage, "int", $iCount, "struct*", $tProperties)
	Local $sPropertyTagInfo = "0x0000=GpsVer;0x0001=GpsLatitudeRef;0x0002=GpsLatitude;0x0003=GpsLongitudeRef;0x0004=GpsLongitude;0x0005=GpsAltitudeRef;0x0006=GpsAltitude;0x0007=GpsGpsTime;0x0008=GpsGpsSatellites;0x0009=GpsGpsStatus;0x000A=GpsGpsMeasureMode;0x000B=GpsGpsDop;0x000C=GpsSpeedRef;0x000D=GpsSpeed;0x000E=GpsTrackRef;0x000F=GpsTrack;0x0010=GpsImgDirRef;0x0011=GpsImgDir;0x0012=GpsMapDatum;0x0013=GpsDestLatRef;0x0014=GpsDestLat;0x0015=GpsDestLongRef;0x0016=GpsDestLong;0x0017=GpsDestBearRef;0x0018=GpsDestBear;0x0019=GpsDestDistRef;0x001A=GpsDestDist;0x00FE=NewSubfileType;0x00FF=SubfileType;0x0100=ImageWidth;0x0101=ImageHeight;0x0102=BitsPerSample;0x0103=Compression;0x0106=PhotometricInterp;0x0107=ThreshHolding;0x0108=CellWidth;0x0109=CellHeight;0x010A=FillOrder;0x010D=DocumentName;0x010E=ImageDescription;0x010F=EquipMake;0x0110=EquipModel;0x0111=StripOffsets;0x0112=Orientation;0x0115=SamplesPerPixel;0x0116=RowsPerStrip;0x0117=StripBytesCount;0x0118=MinSampleValue;0x0119=MaxSampleValue;0x011A=XResolution;0x011B=YResolution;0x011C=PlanarConfig;0x011D=PageName;0x011E=XPosition;0x011F=YPosition;0x0120=FreeOffset;0x0121=FreeByteCounts;0x0122=GrayResponseUnit;0x0123=GrayResponseCurve;0x0124=T4Option;0x0125=T6Option;0x0128=ResolutionUnit;0x0129=PageNumber;0x012D=TransferFunction;0x0131=SoftwareUsed;0x0132=DateTime;0x013B=Artist;0x013C=HostComputer;0x013D=Predictor;0x013E=WhitePoint;0x013F=PrimaryChromaticities;0x0140=ColorMap;0x0141=HalftoneHints;0x0142=TileWidth;0x0143=TileLength;0x0144=TileOffset;0x0145=TileByteCounts;0x014C=InkSet;0x014D=InkNames;0x014E=NumberOfInks;0x0150=DotRange;0x0151=TargetPrinter;0x0152=ExtraSamples;0x0153=SampleFormat;0x0154=SMinSampleValue;0x0155=SMaxSampleValue;0x0156=TransferRange;0x0200=JPEGProc;0x0201=JPEGInterFormat;0x0202=JPEGInterLength;0x0203=JPEGRestartInterval;0x0205=JPEGLosslessPredictors;0x0206=JPEGPointTransforms;0x0207=JPEGQTables;0x0208=JPEGDCTables;0x0209=JPEGACTables;0x0211=YCbCrCoefficients;0x0212=YCbCrSubsampling;0x0213=YCbCrPositioning;0x0214=REFBlackWhite;0x0301=Gamma;0x0302=ICCProfileDescriptor;0x0303=SRGBRenderingIntent;0x0320=ImageTitle;0x5001=ResolutionXUnit;0x5002=ResolutionYUnit;0x5003=ResolutionXLengthUnit;0x5004=ResolutionYLengthUnit;0x5005=PrintFlags;0x5006=PrintFlagsVersion;0x5007=PrintFlagsCrop;0x5008=PrintFlagsBleedWidth;0x5009=PrintFlagsBleedWidthScale;0x500A=HalftoneLPI;0x500B=HalftoneLPIUnit;0x500C=HalftoneDegree;" & _
			"0x500D=HalftoneShape;0x500E=HalftoneMisc;0x500F=HalftoneScreen;0x5010=JPEGQuality;0x5011=GridSize;0x5012=ThumbnailFormat;0x5013=ThumbnailWidth;0x5014=ThumbnailHeight;0x5015=ThumbnailColorDepth;0x5016=ThumbnailPlanes;0x5017=ThumbnailRawBytes;0x5018=ThumbnailSize;0x5019=ThumbnailCompressedSize;0x501A=ColorTransferFunction;0x501B=ThumbnailData;0x5020=ThumbnailImageWidth;0x5021=ThumbnailImageHeight;0x5022=ThumbnailBitsPerSample;0x5023=ThumbnailCompression;0x5024=ThumbnailPhotometricInterp;0x5025=ThumbnailImageDescription;0x5026=ThumbnailEquipMake;0x5027=ThumbnailEquipModel;0x5028=ThumbnailStripOffsets;0x5029=ThumbnailOrientation;0x502A=ThumbnailSamplesPerPixel;0x502B=ThumbnailRowsPerStrip;0x502C=ThumbnailStripBytesCount;0x502D=ThumbnailResolutionX;0x502E=ThumbnailResolutionY;0x502F=ThumbnailPlanarConfig;0x5030=ThumbnailResolutionUnit;0x5031=ThumbnailTransferFunction;0x5032=ThumbnailSoftwareUsed;0x5033=ThumbnailDateTime;0x5034=ThumbnailArtist;0x5035=ThumbnailWhitePoint;0x5036=ThumbnailPrimaryChromaticities;0x5037=ThumbnailYCbCrCoefficients;0x5038=ThumbnailYCbCrSubsampling;0x5039=ThumbnailYCbCrPositioning;0x503A=ThumbnailRefBlackWhite;0x503B=ThumbnailCopyRight;0x5090=LuminanceTable;0x5091=ChrominanceTable;0x5100=FrameDelay;0x5101=LoopCount;0x5102=GlobalPalette;0x5103=IndexBackground;0x5104=IndexTransparent;0x5110=PixelUnit;0x5111=PixelPerUnitX;0x5112=PixelPerUnitY;0x5113=PaletteHistogram;0x8298=Copyright;0x829A=ExifExposureTime;0x829D=ExifFNumber;0x8769=ExifIFD;0x8773=ICCProfile;0x8822=ExifExposureProg;0x8824=ExifSpectralSense;0x8825=GpsIFD;0x8827=ExifISOSpeed;0x8828=ExifOECF;0x9000=ExifVer;0x9003=ExifDTOrig;0x9004=ExifDTDigitized;0x9101=ExifCompConfig;0x9102=ExifCompBPP;0x9201=ExifShutterSpeed;0x9202=ExifAperture;0x9203=ExifBrightness;0x9204=ExifExposureBias;0x9205=ExifMaxAperture;0x9206=ExifSubjectDist;0x9207=ExifMeteringMode;0x9208=ExifLightSource;0x9209=ExifFlash;0x920A=ExifFocalLength;0x927C=ExifMakerNote;0x9286=ExifUserComment;0x9290=ExifDTSubsec;0x9291=ExifDTOrigSS;0x9292=ExifDTDigSS;0xA000=ExifFPXVer;0xA001=ExifColorSpace;0xA002=ExifPixXDim;0xA003=ExifPixYDim;0xA004=ExifRelatedWav;0xA005=ExifInterop;0xA20B=ExifFlashEnergy;0xA20C=ExifSpatialFR;0xA20E=ExifFocalXRes;0xA20F=ExifFocalYRes;0xA210=ExifFocalResUnit;0xA214=ExifSubjectLoc;0xA215=ExifExposureIndex;0xA217=ExifSensingMethod;0xA300=ExifFileSource;0xA301=ExifSceneType;0xA302=ExifCfaPattern"
	Local $aProperties[$iCount + 1][2] = [[$iCount]]
	Local $aRegExp
	For $i = 1 To $iCount
		$aProperties[$i][0] = DllStructGetData($tProperties, 1, $i)
		$aRegExp = StringRegExp($sPropertyTagInfo, "(?i)" & Hex(DllStructGetData($tProperties, 1, $i), 4) & "=(\w+)", 3)
		Switch IsArray($aRegExp)
			Case True
				$aProperties[$i][1] = $aRegExp[0]
				$aProperties[$i][1] = "PropertyTagUnKnown"
	Return $aProperties
EndFunc   ;==>_GDIPlus_ImageGetPropertyIdList
Func __GDIPlus_ImageGetPropertyItemSize($hImage, $iPropID)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyItemSize", "handle", $hImage, "uint", $iPropID, "uint*", 0)
EndFunc   ;==>__GDIPlus_ImageGetPropertyItemSize
Func _GDIPlus_ImageGetPropertyItem($hImage, $iPropID)
	Local $iSize = __GDIPlus_ImageGetPropertyItemSize($hImage, $iPropID)
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "];")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPropertyItem", "handle", $hImage, "uint", $iPropID, "uint", $iSize, "struct*", $tBuffer)
	Local $tPropertyItem = DllStructCreate("int id; int length; short type; ptr value;", $pBuffer)
	Local $iBytes = DllStructGetData($tPropertyItem, "length")
	Local $pValue = DllStructGetData($tPropertyItem, "value")
	Local $tValues, $iValues
	Switch DllStructGetData($tPropertyItem, "type")
		Case 2 ;ASCII String
			$iValues = 1
			$tValues = DllStructCreate("char[" & $iBytes & "];", $pValue)
		Case 3 ;Array of UShort
			$iValues = Int($iBytes / 2)
			$tValues = DllStructCreate("ushort[" & $iValues & "];", $pValue)
		Case 4, 5 ;Array of UInt / Fraction
			$iValues = Int($iBytes / 4)
			$tValues = DllStructCreate("uint[" & $iValues & "];", $pValue)
		Case 9, 10 ;Array of Int / Fraction
			$tValues = DllStructCreate("int[" & $iValues & "];", $pValue)
		Case Else ;Array of Bytes
			$tValues = DllStructCreate("byte[" & $iBytes & "];", $pValue)
	Local $aValues[$iValues + 1] = [$iValues]
		Case 5, 10 ;Pair of UInt Fraction [numerator][denominator]
			$iValues = Int($iValues / 2)
			ReDim $aValues[$iValues + 1]
			$aValues[0] = $iValues
			For $j = 1 To $iValues
				$aValues[$j] = DllStructGetData($tValues, 1, ($j - 1) * 2 + 1) / DllStructGetData($tValues, 1, ($j - 1) * 2 + 2)
		Case 3, 4, 9
				$aValues[$j] = DllStructGetData($tValues, 1, $j)
			$aValues[1] = DllStructGetData($tValues, 1)
	Return $aValues
EndFunc   ;==>_GDIPlus_ImageGetPropertyItem
Func _GDIPlus_ImageGetRawFormat($hImage)
	Local $aGuid[2]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, $aGuid)
	Local $aImageType[11][2] = _
			[["UNDEFINED", $GDIP_IMAGEFORMAT_UNDEFINED], _
			["MEMORYBMP", $GDIP_IMAGEFORMAT_MEMORYBMP], _
			["BMP", $GDIP_IMAGEFORMAT_BMP], _
			["EMF", $GDIP_IMAGEFORMAT_EMF], _
			["WMF", $GDIP_IMAGEFORMAT_WMF], _
			["JPEG", $GDIP_IMAGEFORMAT_JPEG], _
			["PNG", $GDIP_IMAGEFORMAT_PNG], _
			["GIF", $GDIP_IMAGEFORMAT_GIF], _
			["TIFF", $GDIP_IMAGEFORMAT_TIFF], _
			["EXIF", $GDIP_IMAGEFORMAT_EXIF], _
			["ICON", $GDIP_IMAGEFORMAT_ICON]]
	Local $tStruct = DllStructCreate("byte[16]")
	Local $aResult1 = DllCall($__g_hGDIPDll, "int", "GdipGetImageRawFormat", "handle", $hImage, "struct*", $tStruct)
	If @error Then Return SetError(@error, @extended, $aGuid)
	If $aResult1[0] Then Return SetError(10, $aResult1[0], $aGuid)
	Local $sResult2 = _WinAPI_StringFromGUID($aResult1[2])
	If @error Then Return SetError(@error + 20, @extended, $aGuid)
	If $sResult2 = "" Then Return SetError(12, 0, $aGuid)
	For $i = 0 To 10
		If $aImageType[$i][1] == $sResult2 Then
			$aGuid[0] = $aImageType[$i][1]
			$aGuid[1] = $aImageType[$i][0]
			Return $aGuid
	Return SetError(13, 0, $aGuid)
EndFunc   ;==>_GDIPlus_ImageGetRawFormat
Func _GDIPlus_ImageGetThumbnail($hImage, $iWidth = 0, $iHeight = 0, $bKeepRatio = True, $hCallback = Null, $hCallbackData = Null)
	If $bKeepRatio Then
		Local $aImgDim = _GDIPlus_ImageGetDimension($hImage)
		If @error Then Return SetError(@error + 20, @extended, False)
		Local $f
		If $iWidth < 1 Or $iHeight < 1 Then
			$iWidth = 0
			$iHeight = 0
			If ($aImgDim[0] / $aImgDim[1]) > 1 Then
				$f = $aImgDim[0] / $iWidth
				$f = $aImgDim[1] / $iHeight
			$iWidth = Int($aImgDim[0] / $f)
			$iHeight = Int($aImgDim[1] / $f)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageThumbnail", "handle", $hImage, "uint", $iWidth, "uint", $iHeight, "ptr*", 0, "ptr", $hCallback, "ptr", $hCallbackData)
EndFunc   ;==>_GDIPlus_ImageGetThumbnail
Func _GDIPlus_ImageGetType($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(11, 0, -1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageType", "handle", $hImage, "int*", 0)
EndFunc   ;==>_GDIPlus_ImageGetType
Func _GDIPlus_ImageGetVerticalResolution($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageVerticalResolution", "handle", $hImage, "float*", 0)
EndFunc   ;==>_GDIPlus_ImageGetVerticalResolution
Func _GDIPlus_ImageGetWidth($hImage)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetImageWidth", "handle", $hImage, "uint*", -1)
EndFunc   ;==>_GDIPlus_ImageGetWidth
Func _GDIPlus_ImageLoadFromFile($sFileName)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipLoadImageFromFile", "wstr", $sFileName, "handle*", 0)
EndFunc   ;==>_GDIPlus_ImageLoadFromFile
Func _GDIPlus_ImageLoadFromStream($pStream)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipLoadImageFromStream", "ptr", $pStream, "handle*", 0)
EndFunc   ;==>_GDIPlus_ImageLoadFromStream
Func _GDIPlus_ImageRotateFlip($hImage, $iRotateFlipType)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipImageRotateFlip", "handle", $hImage, "int", $iRotateFlipType)
EndFunc   ;==>_GDIPlus_ImageRotateFlip
Func _GDIPlus_ImageSaveAdd($hImage, $tParams)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveAdd", "handle", $hImage, "struct*", $tParams)
EndFunc   ;==>_GDIPlus_ImageSaveAdd
Func _GDIPlus_ImageSaveAddImage($hImage, $hImageNew, $tParams)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveAddImage", "handle", $hImage, "handle", $hImageNew, "struct*", $tParams)
EndFunc   ;==>_GDIPlus_ImageSaveAddImage
Func _GDIPlus_ImageSaveToFile($hImage, $sFileName)
	Local $sExt = __GDIPlus_ExtractFileExt($sFileName)
	Local $sCLSID = _GDIPlus_EncodersGetCLSID($sExt)
	If $sCLSID = "" Then Return SetError(-1, 0, False)
	Local $bRet = _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sCLSID, 0)
	Return SetError(@error, @extended, $bRet)
EndFunc   ;==>_GDIPlus_ImageSaveToFile
Func _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sEncoder, $tParams = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveImageToFile", "handle", $hImage, "wstr", $sFileName, "struct*", $tGUID, "struct*", $tParams)
EndFunc   ;==>_GDIPlus_ImageSaveToFileEx
Func _GDIPlus_ImageSaveToStream($hImage, $pStream, $tEncoder, $tParams = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSaveImageToStream", "handle", $hImage, "ptr", $pStream, "struct*", $tEncoder, "struct*", $tParams)
EndFunc   ;==>_GDIPlus_ImageSaveToStream
Func _GDIPlus_ImageScale($hImage, $iScaleW, $iScaleH, $iInterpolationMode = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC)
	Local $iWidth = _GDIPlus_ImageGetWidth($hImage) * $iScaleW
	Local $iHeight = _GDIPlus_ImageGetHeight($hImage) * $iScaleH
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
		Return SetError(4, 0, 0)
	_GDIPlus_GraphicsSetInterpolationMode($hBmpCtxt, $iInterpolationMode)
		_GDIPlus_GraphicsDispose($hBmpCtxt)
		Return SetError(5, 0, 0)
	_GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iWidth, $iHeight)
		Return SetError(6, 0, 0)
	_GDIPlus_GraphicsDispose($hBmpCtxt)
EndFunc   ;==>_GDIPlus_ImageScale
Func _GDIPlus_ImageSelectActiveFrame($hImage, $sDimensionID, $iFrameIndex)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipImageSelectActiveFrame", "handle", $hImage, "struct*", $tGUID, "uint", $iFrameIndex)
EndFunc   ;==>_GDIPlus_ImageSelectActiveFrame
Func _GDIPlus_ImageResize($hImage, $iNewWidth, $iNewHeight, $iInterpolationMode = $GDIP_INTERPOLATIONMODE_HIGHQUALITYBICUBIC)
	Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iNewWidth, $iNewHeight)
		Return SetError(2, @extended, 0)
		Return SetError(3, @extended, 0)
	_GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iNewWidth, $iNewHeight)
		Return SetError(4, @extended, 0)
EndFunc   ;==>_GDIPlus_ImageResize
Func _GDIPlus_LineBrushCreate($nX1, $nY1, $nX2, $nY2, $iARGBClr1, $iARGBClr2, $iWrapMode = 0)
	Local $tPointF1, $tPointF2, $aResult
	$tPointF1 = DllStructCreate("float;float")
	$tPointF2 = DllStructCreate("float;float")
	DllStructSetData($tPointF1, 1, $nX1)
	DllStructSetData($tPointF1, 2, $nY1)
	DllStructSetData($tPointF2, 1, $nX2)
	DllStructSetData($tPointF2, 2, $nY2)
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateLineBrush", "struct*", $tPointF1, "struct*", $tPointF2, "uint", $iARGBClr1, "uint", $iARGBClr2, "int", $iWrapMode, "handle*", 0)
EndFunc   ;==>_GDIPlus_LineBrushCreate
Func _GDIPlus_LineBrushCreateFromRect($tRECTF, $iARGBClr1, $iARGBClr2, $iGradientMode = 0, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateLineBrushFromRect", "struct*", $tRECTF, "uint", $iARGBClr1, "uint", $iARGBClr2, "int", $iGradientMode, "int", $iWrapMode, "handle*", 0)
EndFunc   ;==>_GDIPlus_LineBrushCreateFromRect
Func _GDIPlus_LineBrushCreateFromRectWithAngle($tRECTF, $iARGBClr1, $iARGBClr2, $fAngle, $bIsAngleScalable = True, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateLineBrushFromRectWithAngle", "struct*", $tRECTF, "uint", $iARGBClr1, "uint", $iARGBClr2, "float", $fAngle, "int", $bIsAngleScalable, "int", $iWrapMode, "handle*", 0)
EndFunc   ;==>_GDIPlus_LineBrushCreateFromRectWithAngle
Func _GDIPlus_LineBrushGetColors($hLineGradientBrush)
	Local $tARGBs, $aARGBs[2], $aResult
	$tARGBs = DllStructCreate("uint;uint")
	$aResult = DllCall($__g_hGDIPDll, "uint", "GdipGetLineColors", "handle", $hLineGradientBrush, "struct*", $tARGBs)
	$aARGBs[0] = DllStructGetData($tARGBs, 1)
	$aARGBs[1] = DllStructGetData($tARGBs, 2)
	Return $aARGBs
EndFunc   ;==>_GDIPlus_LineBrushGetColors
Func _GDIPlus_LineBrushGetRect($hLineGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetLineRect", "handle", $hLineGradientBrush, "struct*", $tRECTF)
	Local $aRectF[4]
		$aRectF[$iI - 1] = DllStructGetData($tRECTF, $iI)
	Return $aRectF
EndFunc   ;==>_GDIPlus_LineBrushGetRect
Func _GDIPlus_LineBrushMultiplyTransform($hLineGradientBrush, $hMatrix, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipMultiplyLineTransform", "handle", $hLineGradientBrush, "handle", $hMatrix, "int", $iOrder)
EndFunc   ;==>_GDIPlus_LineBrushMultiplyTransform
Func _GDIPlus_LineBrushResetTransform($hLineGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetLineTransform", "handle", $hLineGradientBrush)
EndFunc   ;==>_GDIPlus_LineBrushResetTransform
Func _GDIPlus_LineBrushSetBlend($hLineGradientBrush, $aBlends)
	Local $iI, $iCount, $tFactors, $tPositions, $aResult
	$iCount = $aBlends[0][0]
	$tFactors = DllStructCreate("float[" & $iCount & "]")
	$tPositions = DllStructCreate("float[" & $iCount & "]")
		DllStructSetData($tFactors, 1, $aBlends[$iI][0], $iI)
		DllStructSetData($tPositions, 1, $aBlends[$iI][1], $iI)
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineBlend", "handle", $hLineGradientBrush, "struct*", $tFactors, "struct*", $tPositions, "int", $iCount)
EndFunc   ;==>_GDIPlus_LineBrushSetBlend
Func _GDIPlus_LineBrushSetColors($hLineGradientBrush, $iARGBStart, $iARGBEnd)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineColors", "handle", $hLineGradientBrush, "uint", $iARGBStart, "uint", $iARGBEnd)
EndFunc   ;==>_GDIPlus_LineBrushSetColors
Func _GDIPlus_LineBrushSetGammaCorrection($hLineGradientBrush, $bUseGammaCorrection = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineGammaCorrection", "handle", $hLineGradientBrush, "int", $bUseGammaCorrection)
EndFunc   ;==>_GDIPlus_LineBrushSetGammaCorrection
Func _GDIPlus_LineBrushSetLinearBlend($hLineGradientBrush, $fFocus, $fScale = 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineLinearBlend", "handle", $hLineGradientBrush, "float", $fFocus, "float", $fScale)
EndFunc   ;==>_GDIPlus_LineBrushSetLinearBlend
Func _GDIPlus_LineBrushSetPresetBlend($hLineGradientBrush, $aInterpolations)
	Local $iI, $iCount, $tColors, $tPositions, $aResult
	$iCount = $aInterpolations[0][0]
	$tColors = DllStructCreate("uint[" & $iCount & "]")
		DllStructSetData($tColors, 1, $aInterpolations[$iI][0], $iI)
		DllStructSetData($tPositions, 1, $aInterpolations[$iI][1], $iI)
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLinePresetBlend", "handle", $hLineGradientBrush, "struct*", $tColors, "struct*", $tPositions, "int", $iCount)
EndFunc   ;==>_GDIPlus_LineBrushSetPresetBlend
Func _GDIPlus_LineBrushSetSigmaBlend($hLineGradientBrush, $fFocus, $fScale = 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineSigmaBlend", "handle", $hLineGradientBrush, "float", $fFocus, "float", $fScale)
EndFunc   ;==>_GDIPlus_LineBrushSetSigmaBlend
Func _GDIPlus_LineBrushSetTransform($hLineGradientBrush, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetLineTransform", "handle", $hLineGradientBrush, "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_LineBrushSetTransform
Func _GDIPlus_MatrixCreate()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateMatrix", "handle*", 0)
EndFunc   ;==>_GDIPlus_MatrixCreate
Func _GDIPlus_MatrixCreate2($nM11 = 1, $nM12 = 1, $nM21 = 1, $nM22 = 1, $nDX = 0, $nDY = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateMatrix2", "float", $nM11, "float", $nM12, "float", $nM21, "float", $nM22, "float", $nDX, "float", $nDY, "handle*", 0)
EndFunc   ;==>_GDIPlus_MatrixCreate2
Func _GDIPlus_MatrixClone($hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneMatrix", "handle", $hMatrix, "handle*", 0)
EndFunc   ;==>_GDIPlus_MatrixClone
Func _GDIPlus_MatrixDispose($hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteMatrix", "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_MatrixDispose
Func _GDIPlus_MatrixGetElements($hMatrix)
	Local $tElements = DllStructCreate("float[6]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetMatrixElements", "handle", $hMatrix, "struct*", $tElements)
	Local $aElements[6]
	For $iI = 1 To 6
		$aElements[$iI - 1] = DllStructGetData($tElements, 1, $iI)
	Return $aElements
EndFunc   ;==>_GDIPlus_MatrixGetElements
Func _GDIPlus_MatrixInvert($hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipInvertMatrix", "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_MatrixInvert
Func _GDIPlus_MatrixMultiply($hMatrix1, $hMatrix2, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipMultiplyMatrix", "handle", $hMatrix1, "handle", $hMatrix2, "int", $iOrder)
EndFunc   ;==>_GDIPlus_MatrixMultiply
Func _GDIPlus_MatrixRotate($hMatrix, $fAngle, $bAppend = False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipRotateMatrix", "handle", $hMatrix, "float", $fAngle, "int", $bAppend)
EndFunc   ;==>_GDIPlus_MatrixRotate
Func _GDIPlus_MatrixScale($hMatrix, $fScaleX, $fScaleY, $bOrder = False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipScaleMatrix", "handle", $hMatrix, "float", $fScaleX, "float", $fScaleY, "int", $bOrder)
EndFunc   ;==>_GDIPlus_MatrixScale
Func _GDIPlus_MatrixSetElements($hMatrix, $nM11 = 1, $nM12 = 0, $nM21 = 0, $nM22 = 1, $nDX = 0, $nDY = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetMatrixElements", "handle", $hMatrix, "float", $nM11, "float", $nM12, _
			"float", $nM21, "float", $nM22, "float", $nDX, "float", $nDY)
EndFunc   ;==>_GDIPlus_MatrixSetElements
Func _GDIPlus_MatrixShear($hMatrix, $fShearX, $fShearY, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipShearMatrix", "handle", $hMatrix, "float", $fShearX, "float", $fShearY, "int", $iOrder)
EndFunc   ;==>_GDIPlus_MatrixShear
Func _GDIPlus_MatrixTransformPoints($hMatrix, ByRef $aPoints)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTransformMatrixPoints", "handle", $hMatrix, "struct*", $tPoints, "int", $iCount)
EndFunc   ;==>_GDIPlus_MatrixTransformPoints
Func _GDIPlus_MatrixTranslate($hMatrix, $fOffsetX, $fOffsetY, $bAppend = False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTranslateMatrix", "handle", $hMatrix, "float", $fOffsetX, "float", $fOffsetY, "int", $bAppend)
EndFunc   ;==>_GDIPlus_MatrixTranslate
Func _GDIPlus_ParamAdd(ByRef $tParams, $sGUID, $iNbOfValues, $iType, $pValues)
	Local $iCount = DllStructGetData($tParams, "Count")
	Local $pGUID = DllStructGetPtr($tParams, "GUID") + ($iCount * _GDIPlus_ParamSize())
	Local $tParam = DllStructCreate($tagGDIPENCODERPARAM, $pGUID)
	_WinAPI_GUIDFromStringEx($sGUID, $pGUID)
	DllStructSetData($tParam, "Type", $iType)
	DllStructSetData($tParam, "NumberOfValues", $iNbOfValues)
	DllStructSetData($tParam, "Values", $pValues)
	DllStructSetData($tParams, "Count", $iCount + 1)
EndFunc   ;==>_GDIPlus_ParamAdd
Func _GDIPlus_ParamInit($iCount)
	Local $sStruct = $tagGDIPENCODERPARAMS
	For $i = 2 To $iCount
		$sStruct &= ";struct;byte[16];ulong;ulong;ptr;endstruct"
	Return DllStructCreate($sStruct)
EndFunc   ;==>_GDIPlus_ParamInit
Func _GDIPlus_ParamSize()
	Local $tParam = DllStructCreate($tagGDIPENCODERPARAM)
	Return DllStructGetSize($tParam)
EndFunc   ;==>_GDIPlus_ParamSize
Func _GDIPlus_PathAddArc($hPath, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathArc", "handle", $hPath, "float", $nX, "float", $nY, _
EndFunc   ;==>_GDIPlus_PathAddArc
Func _GDIPlus_PathAddBezier($hPath, $nX1, $nY1, $nX2, $nY2, $nX3, $nY3, $nX4, $nY4)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathBezier", "handle", $hPath, "float", $nX1, "float", $nY1, "float", $nX2, "float", $nY2, "float", $nX3, "float", $nY3, "float", $nX4, "float", $nY4)
EndFunc   ;==>_GDIPlus_PathAddBezier
Func _GDIPlus_PathAddClosedCurve($hPath, $aPoints)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathClosedCurve", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
EndFunc   ;==>_GDIPlus_PathAddClosedCurve
Func _GDIPlus_PathAddClosedCurve2($hPath, $aPoints, $nTension = 0.5)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathClosedCurve2", "handle", $hPath, "struct*", $tPoints, "int", $iCount, "float", $nTension)
EndFunc   ;==>_GDIPlus_PathAddClosedCurve2
Func _GDIPlus_PathAddCurve($hPath, $aPoints)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathCurve", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
EndFunc   ;==>_GDIPlus_PathAddCurve
Func _GDIPlus_PathAddCurve2($hPath, $aPoints, $nTension = 0.5)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathCurve2", "handle", $hPath, "struct*", $tPoints, "int", $iCount, "float", $nTension)
EndFunc   ;==>_GDIPlus_PathAddCurve2
Func _GDIPlus_PathAddCurve3($hPath, $aPoints, $iOffset, $iNumOfSegments, $nTension = 0.5)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathCurve3", "handle", $hPath, "struct*", $tPoints, "int", $iCount, "int", $iOffset, "int", $iNumOfSegments, "float", $nTension)
EndFunc   ;==>_GDIPlus_PathAddCurve3
Func _GDIPlus_PathAddEllipse($hPath, $nX, $nY, $nWidth, $nHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathEllipse", "handle", $hPath, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight)
EndFunc   ;==>_GDIPlus_PathAddEllipse
Func _GDIPlus_PathAddLine($hPath, $nX1, $nY1, $nX2, $nY2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathLine", "handle", $hPath, "float", $nX1, "float", $nY1, "float", $nX2, "float", $nY2)
EndFunc   ;==>_GDIPlus_PathAddLine
Func _GDIPlus_PathAddLine2($hPath, $aPoints)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathLine2", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
EndFunc   ;==>_GDIPlus_PathAddLine2
Func _GDIPlus_PathAddPath($hPath1, $hPath2, $bConnect = True)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathPath", "handle", $hPath1, "handle", $hPath2, "int", $bConnect)
EndFunc   ;==>_GDIPlus_PathAddPath
Func _GDIPlus_PathAddPie($hPath, $nX, $nY, $nWidth, $nHeight, $fStartAngle, $fSweepAngle)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathPie", "handle", $hPath, "float", $nX, "float", $nY, _
EndFunc   ;==>_GDIPlus_PathAddPie
Func _GDIPlus_PathAddPolygon($hPath, $aPoints)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathPolygon", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
EndFunc   ;==>_GDIPlus_PathAddPolygon
Func _GDIPlus_PathAddRectangle($hPath, $nX, $nY, $nWidth, $nHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathRectangle", "handle", $hPath, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight)
EndFunc   ;==>_GDIPlus_PathAddRectangle
Func _GDIPlus_PathAddString($hPath, $sString, $tLayout, $hFamily, $iStyle = 0, $fSize = 8.5, $hFormat = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipAddPathString", "handle", $hPath, "wstr", $sString, "int", -1, _
			"handle", $hFamily, "int", $iStyle, "float", $fSize, "struct*", $tLayout, "handle", $hFormat)
EndFunc   ;==>_GDIPlus_PathAddString
Func _GDIPlus_PathBrushCreate($aPoints, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePathGradient", "struct*", $tPoints, "int", $iCount, "int", $iWrapMode, "handle*", 0)
EndFunc   ;==>_GDIPlus_PathBrushCreate
Func _GDIPlus_PathBrushCreateFromPath($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePathGradientFromPath", "handle", $hPath, "handle*", 0)
EndFunc   ;==>_GDIPlus_PathBrushCreateFromPath
Func _GDIPlus_PathBrushGetCenterPoint($hPathGradientBrush)
	Local $tPointF = DllStructCreate("float;float")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientCenterPoint", "handle", $hPathGradientBrush, "struct*", $tPointF)
	Local $aPointF[2]
	$aPointF[0] = DllStructGetData($tPointF, 1)
	$aPointF[1] = DllStructGetData($tPointF, 2)
	Return $aPointF
EndFunc   ;==>_GDIPlus_PathBrushGetCenterPoint
Func _GDIPlus_PathBrushGetFocusScales($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientFocusScales", "handle", $hPathGradientBrush, "float*", 0, "float*", 0)
	Local $aScales[2]
	$aScales[0] = $aResult[2]
	$aScales[1] = $aResult[3]
	Return $aScales
EndFunc   ;==>_GDIPlus_PathBrushGetFocusScales
Func _GDIPlus_PathBrushGetPointCount($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientPointCount", "handle", $hPathGradientBrush, "int*", 0)
EndFunc   ;==>_GDIPlus_PathBrushGetPointCount
Func _GDIPlus_PathBrushGetRect($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientRect", "handle", $hPathGradientBrush, "struct*", $tRECTF)
EndFunc   ;==>_GDIPlus_PathBrushGetRect
Func _GDIPlus_PathBrushGetWrapMode($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathGradientWrapMode", "handle", $hPathGradientBrush, "int*", 0)
EndFunc   ;==>_GDIPlus_PathBrushGetWrapMode
Func _GDIPlus_PathBrushMultiplyTransform($hPathGradientBrush, $hMatrix, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipMultiplyPathGradientTransform", "handle", $hPathGradientBrush, "handle", $hMatrix, "int", $iOrder)
EndFunc   ;==>_GDIPlus_PathBrushMultiplyTransform
Func _GDIPlus_PathBrushResetTransform($hPathGradientBrush)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetPathGradientTransform", "handle", $hPathGradientBrush)
EndFunc   ;==>_GDIPlus_PathBrushResetTransform
Func _GDIPlus_PathBrushSetBlend($hPathGradientBrush, $aBlends)
	Local $iCount = $aBlends[0][0]
	Local $tFactors = DllStructCreate("float[" & $iCount & "]")
	Local $tPositions = DllStructCreate("float[" & $iCount & "]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientBlend", "handle", $hPathGradientBrush, "struct*", $tFactors, "struct*", $tPositions, "int", $iCount)
EndFunc   ;==>_GDIPlus_PathBrushSetBlend
Func _GDIPlus_PathBrushSetCenterColor($hPathGradientBrush, $iARGB)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientCenterColor", "handle", $hPathGradientBrush, "uint", $iARGB)
EndFunc   ;==>_GDIPlus_PathBrushSetCenterColor
Func _GDIPlus_PathBrushSetCenterPoint($hPathGradientBrush, $nX, $nY)
	DllStructSetData($tPointF, 1, $nX)
	DllStructSetData($tPointF, 2, $nY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientCenterPoint", "handle", $hPathGradientBrush, "struct*", $tPointF)
EndFunc   ;==>_GDIPlus_PathBrushSetCenterPoint
Func _GDIPlus_PathBrushSetFocusScales($hPathGradientBrush, $fScaleX, $fScaleY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientFocusScales", "handle", $hPathGradientBrush, "float", $fScaleX, "float", $fScaleY)
EndFunc   ;==>_GDIPlus_PathBrushSetFocusScales
Func _GDIPlus_PathBrushSetGammaCorrection($hPathGradientBrush, $bUseGammaCorrection)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientGammaCorrection", "handle", $hPathGradientBrush, "int", $bUseGammaCorrection)
EndFunc   ;==>_GDIPlus_PathBrushSetGammaCorrection
Func _GDIPlus_PathBrushSetLinearBlend($hPathGradientBrush, $fFocus, $fScale = 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientLinearBlend", "handle", $hPathGradientBrush, "float", $fFocus, "float", $fScale)
EndFunc   ;==>_GDIPlus_PathBrushSetLinearBlend
Func _GDIPlus_PathBrushSetPresetBlend($hPathGradientBrush, $aInterpolations)
	Local $iCount = $aInterpolations[0][0]
	Local $tColors = DllStructCreate("uint[" & $iCount & "]")
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientPresetBlend", "handle", $hPathGradientBrush, "struct*", $tColors, "struct*", $tPositions, "int", $iCount)
EndFunc   ;==>_GDIPlus_PathBrushSetPresetBlend
Func _GDIPlus_PathBrushSetSigmaBlend($hPathGradientBrush, $fFocus, $fScale = 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientSigmaBlend", "handle", $hPathGradientBrush, "float", $fFocus, "float", $fScale)
EndFunc   ;==>_GDIPlus_PathBrushSetSigmaBlend
Func _GDIPlus_PathBrushSetSurroundColor($hPathGradientBrush, $iARGB)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientSurroundColorsWithCount", "handle", $hPathGradientBrush, "uint*", $iARGB, "int*", 1)
EndFunc   ;==>_GDIPlus_PathBrushSetSurroundColor
Func _GDIPlus_PathBrushSetSurroundColorsWithCount($hPathGradientBrush, $aColors)
	Local $iCount = $aColors[0]
	Local $iColors = _GDIPlus_PathBrushGetPointCount($hPathGradientBrush)
	If $iColors < $iCount Then $iCount = $iColors
		DllStructSetData($tColors, 1, $aColors[$iI], $iI)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientSurroundColorsWithCount", "handle", $hPathGradientBrush, "struct*", $tColors, "int*", $iCount)
EndFunc   ;==>_GDIPlus_PathBrushSetSurroundColorsWithCount
Func _GDIPlus_PathBrushSetTransform($hPathGradientBrush, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientTransform", "handle", $hPathGradientBrush, "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_PathBrushSetTransform
Func _GDIPlus_PathBrushSetWrapMode($hPathGradientBrush, $iWrapMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathGradientWrapMode", "handle", $hPathGradientBrush, "int", $iWrapMode)
EndFunc   ;==>_GDIPlus_PathBrushSetWrapMode
Func _GDIPlus_PathClone($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipClonePath", "handle", $hPath, "handle*", 0)
EndFunc   ;==>_GDIPlus_PathClone
Func _GDIPlus_PathCloseFigure($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipClosePathFigure", "handle", $hPath)
EndFunc   ;==>_GDIPlus_PathCloseFigure
Func _GDIPlus_PathCreate($iFillMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePath", "int", $iFillMode, "handle*", 0)
EndFunc   ;==>_GDIPlus_PathCreate
Func _GDIPlus_PathCreate2($aPathData, $iFillMode = 0)
	Local $iCount = $aPathData[0][0]
	Local $tTypes = DllStructCreate("byte[" & $iCount & "]")
		DllStructSetData($tPoints, 1, $aPathData[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPathData[$iI][1], (($iI - 1) * 2) + 2)
		DllStructSetData($tTypes, 1, $aPathData[$iI][2], $iI)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePath2", "struct*", $tPoints, "struct*", $tTypes, "int", $iCount, "int", $iFillMode, "handle*", 0)
EndFunc   ;==>_GDIPlus_PathCreate2
Func _GDIPlus_PathDispose($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeletePath", "handle", $hPath)
EndFunc   ;==>_GDIPlus_PathDispose
Func _GDIPlus_PathFlatten($hPath, $fFlatness = 0.25, $hMatrix = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipFlattenPath", "handle", $hPath, "handle", $hMatrix, "float", $fFlatness)
EndFunc   ;==>_GDIPlus_PathFlatten
Func _GDIPlus_PathGetData($hPath)
	Local $iCount = _GDIPlus_PathGetPointCount($hPath)
	Local $tPathData = DllStructCreate("int Count; ptr Points; ptr Types;")
	DllStructSetData($tPathData, "Count", $iCount)
	DllStructSetData($tPathData, "Points", DllStructGetPtr($tPoints))
	DllStructSetData($tPathData, "Types", DllStructGetPtr($tTypes))
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathData", "handle", $hPath, "struct*", $tPathData)
	If $aResult[0] Then Return SetError($aResult[0], $aResult[0], -1)
	Local $aData[$iCount + 1][3]
	$aData[0][0] = $iCount
		$aData[$iI][0] = DllStructGetData($tPoints, 1, (($iI - 1) * 2) + 1)
		$aData[$iI][1] = DllStructGetData($tPoints, 1, (($iI - 1) * 2) + 2)
		$aData[$iI][2] = DllStructGetData($tTypes, 1, $iI)
	Return $aData
EndFunc   ;==>_GDIPlus_PathGetData
Func _GDIPlus_PathGetFillMode($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathFillMode", "handle", $hPath, "int*", 0)
EndFunc   ;==>_GDIPlus_PathGetFillMode
Func _GDIPlus_PathGetLastPoint($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathLastPoint", "handle", $hPath, "struct*", $tPointF)
EndFunc   ;==>_GDIPlus_PathGetLastPoint
Func _GDIPlus_PathGetPointCount($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPointCount", "handle", $hPath, "int*", 0)
EndFunc   ;==>_GDIPlus_PathGetPointCount
Func _GDIPlus_PathGetPoints($hPath)
	Local $iI, $iCount, $tPoints, $aPoints[1][1], $aResult
	$iCount = _GDIPlus_PathGetPointCount($hPath)
	If @error Then Return SetError(@error + 10, @extended, -1)
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathPoints", "handle", $hPath, "struct*", $tPoints, "int", $iCount)
	Local $aPoints[$iCount + 1][2]
	$aPoints[0][0] = $iCount
		$aPoints[$iI][0] = DllStructGetData($tPoints, 1, (($iI - 1) * 2) + 1)
		$aPoints[$iI][1] = DllStructGetData($tPoints, 1, (($iI - 1) * 2) + 2)
	Return $aPoints
EndFunc   ;==>_GDIPlus_PathGetPoints
Func _GDIPlus_PathGetWorldBounds($hPath, $hMatrix = 0, $hPen = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPathWorldBounds", "handle", $hPath, "struct*", $tRECTF, "handle", $hMatrix, "handle", $hPen)
EndFunc   ;==>_GDIPlus_PathGetWorldBounds
Func _GDIPlus_PathIsOutlineVisiblePoint($hPath, $nX, $nY, $hPen = 0, $hGraphics = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipIsOutlineVisiblePathPoint", "handle", $hPath, "float", $nX, "float", $nY, "handle", $hPen, "handle", $hGraphics, "int*", 0)
	Return $aResult[6] <> 0
EndFunc   ;==>_GDIPlus_PathIsOutlineVisiblePoint
Func _GDIPlus_PathIsVisiblePoint($hPath, $nX, $nY, $hGraphics = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipIsVisiblePathPoint", "handle", $hPath, "float", $nX, "float", $nY, "handle", $hGraphics, "int*", 0)
	Return $aResult[5] <> 0
EndFunc   ;==>_GDIPlus_PathIsVisiblePoint
Func _GDIPlus_PathIterCreate($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePathIter", "handle*", 0, "handle", $hPath)
EndFunc   ;==>_GDIPlus_PathIterCreate
Func _GDIPlus_PathIterDispose($hPathIter)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeletePathIter", "handle", $hPathIter)
EndFunc   ;==>_GDIPlus_PathIterDispose
Func _GDIPlus_PathIterGetSubpathCount($hPathIter)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPathIterGetSubpathCount", "handle", $hPathIter, "int*", 0)
EndFunc   ;==>_GDIPlus_PathIterGetSubpathCount
Func _GDIPlus_PathIterNextMarkerPath($hPathIter, $hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPathIterNextMarkerPath", "handle", $hPathIter, "int*", 0, "handle", $hPath)
EndFunc   ;==>_GDIPlus_PathIterNextMarkerPath
Func _GDIPlus_PathIterNextSubpathPath($hPathIter, $hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPathIterNextSubpathPath", "handle", $hPathIter, "int*", 0, "handle", $hPath, "bool*", 0)
	Local $aReturn[2]
	$aReturn[0] = $aResult[2]
	$aReturn[1] = $aResult[4]
	Return $aReturn
EndFunc   ;==>_GDIPlus_PathIterNextSubpathPath
Func _GDIPlus_PathIterRewind($hPathIter)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipPathIterRewind", "handle", $hPathIter)
EndFunc   ;==>_GDIPlus_PathIterRewind
Func _GDIPlus_PathReset($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetPath", "handle", $hPath)
EndFunc   ;==>_GDIPlus_PathReset
Func _GDIPlus_PathReverse($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipReversePath", "handle", $hPath)
EndFunc   ;==>_GDIPlus_PathReverse
Func _GDIPlus_PathSetFillMode($hPath, $iFillMode)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathFillMode", "handle", $hPath, "int", $iFillMode)
EndFunc   ;==>_GDIPlus_PathSetFillMode
Func _GDIPlus_PathSetMarker($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPathMarker", "handle", $hPath)
EndFunc   ;==>_GDIPlus_PathSetMarker
Func _GDIPlus_PathStartFigure($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipStartPathFigure", "handle", $hPath)
EndFunc   ;==>_GDIPlus_PathStartFigure
Func _GDIPlus_PathTransform($hPath, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTransformPath", "handle", $hPath, "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_PathTransform
Func _GDIPlus_PathWarp($hPath, $hMatrix, $aPoints, $nX, $nY, $nWidth, $nHeight, $iWarpMode = 0, $fFlatness = 0.25)
	If $iCount <> 3 And $iCount <> 4 Then Return SetError(11, 0, False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipWarpPath", "handle", $hPath, "handle", $hMatrix, "struct*", $tPoints, "int", $iCount, _
			"float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "int", $iWarpMode, "float", $fFlatness)
EndFunc   ;==>_GDIPlus_PathWarp
Func _GDIPlus_PathWiden($hPath, $hPen, $hMatrix = 0, $fFlatness = 0.25)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipWidenPath", "handle", $hPath, "handle", $hPen, "handle", $hMatrix, "float", $fFlatness)
EndFunc   ;==>_GDIPlus_PathWiden
Func _GDIPlus_PathWindingModeOutline($hPath, $hMatrix = 0, $fFlatness = 0.25)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipWindingModeOutline", "handle", $hPath, "handle", $hMatrix, "float", $fFlatness)
EndFunc   ;==>_GDIPlus_PathWindingModeOutline
Func _GDIPlus_PenCreate($iARGB = 0xFF000000, $nWidth = 1, $iUnit = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePen1", "dword", $iARGB, "float", $nWidth, "int", $iUnit, "handle*", 0)
EndFunc   ;==>_GDIPlus_PenCreate
Func _GDIPlus_PenCreate2($hBrush, $nWidth = 1, $iUnit = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreatePen2", "handle", $hBrush, "float", $nWidth, "int", $iUnit, "handle*", 0)
EndFunc   ;==>_GDIPlus_PenCreate2
Func _GDIPlus_PenDispose($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeletePen", "handle", $hPen)
EndFunc   ;==>_GDIPlus_PenDispose
Func _GDIPlus_PenGetAlignment($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenMode", "handle", $hPen, "int*", 0)
EndFunc   ;==>_GDIPlus_PenGetAlignment
Func _GDIPlus_PenGetColor($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenColor", "handle", $hPen, "dword*", 0)
EndFunc   ;==>_GDIPlus_PenGetColor
Func _GDIPlus_PenGetCustomEndCap($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenCustomEndCap", "handle", $hPen, "handle*", 0)
EndFunc   ;==>_GDIPlus_PenGetCustomEndCap
Func _GDIPlus_PenGetDashCap($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenDashCap197819", "handle", $hPen, "int*", 0)
EndFunc   ;==>_GDIPlus_PenGetDashCap
Func _GDIPlus_PenGetDashStyle($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenDashStyle", "handle", $hPen, "int*", 0)
EndFunc   ;==>_GDIPlus_PenGetDashStyle
Func _GDIPlus_PenGetEndCap($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenEndCap", "handle", $hPen, "int*", 0)
EndFunc   ;==>_GDIPlus_PenGetEndCap
Func _GDIPlus_PenGetMiterLimit($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenMiterLimit", "handle", $hPen, "float*", 0)
EndFunc   ;==>_GDIPlus_PenGetMiterLimit
Func _GDIPlus_PenGetWidth($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetPenWidth", "handle", $hPen, "float*", 0)
EndFunc   ;==>_GDIPlus_PenGetWidth
Func _GDIPlus_PenResetTransform($hPen)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipResetPenTransform", "handle", $hPen)
EndFunc   ;==>_GDIPlus_PenResetTransform
Func _GDIPlus_PenRotateTransform($hPen, $fAngle, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipRotatePenTransform", "handle", $hPen, "float", $fAngle, "int", $iOrder)
EndFunc   ;==>_GDIPlus_PenRotateTransform
Func _GDIPlus_PenScaleTransform($hPen, $fScaleX, $fScaleY, $iOrder = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipScalePenTransform", "handle", $hPen, "float", $fScaleX, "float", $fScaleY, "int", $iOrder)
EndFunc   ;==>_GDIPlus_PenScaleTransform
Func _GDIPlus_PenSetAlignment($hPen, $iAlignment = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenMode", "handle", $hPen, "int", $iAlignment)
EndFunc   ;==>_GDIPlus_PenSetAlignment
Func _GDIPlus_PenSetColor($hPen, $iARGB)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenColor", "handle", $hPen, "dword", $iARGB)
EndFunc   ;==>_GDIPlus_PenSetColor
Func _GDIPlus_PenSetCompound($hPen, $aCompounds)
	Local $iCount = $aCompounds[0]
	Local $tCompounds = DllStructCreate("float[" & $iCount & "];")
		DllStructSetData($tCompounds, 1, $aCompounds[$i], $i)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenCompoundArray", "handle", $hPen, "struct*", $tCompounds, "int", $iCount)
EndFunc   ;==>_GDIPlus_PenSetCompound
Func _GDIPlus_PenSetCustomEndCap($hPen, $hEndCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenCustomEndCap", "handle", $hPen, "handle", $hEndCap)
EndFunc   ;==>_GDIPlus_PenSetCustomEndCap
Func _GDIPlus_PenSetDashCap($hPen, $iDash = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenDashCap197819", "handle", $hPen, "int", $iDash)
EndFunc   ;==>_GDIPlus_PenSetDashCap
Func _GDIPlus_PenSetDashStyle($hPen, $iStyle = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenDashStyle", "handle", $hPen, "int", $iStyle)
EndFunc   ;==>_GDIPlus_PenSetDashStyle
Func _GDIPlus_PenSetEndCap($hPen, $iEndCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenEndCap", "handle", $hPen, "int", $iEndCap)
EndFunc   ;==>_GDIPlus_PenSetEndCap
Func _GDIPlus_PenSetLineCap($hPen, $iStartCap, $iEndCap, $iDashCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenLineCap197819", "handle", $hPen, "int", $iStartCap, "int", $iEndCap, "int", $iDashCap)
EndFunc   ;==>_GDIPlus_PenSetLineCap
Func _GDIPlus_PenSetLineJoin($hPen, $iLineJoin)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenLineJoin", "handle", $hPen, "int", $iLineJoin)
EndFunc   ;==>_GDIPlus_PenSetLineJoin
Func _GDIPlus_PenSetMiterLimit($hPen, $fMiterLimit)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenMiterLimit", "handle", $hPen, "float", $fMiterLimit)
EndFunc   ;==>_GDIPlus_PenSetMiterLimit
Func _GDIPlus_PenSetStartCap($hPen, $iLineCap)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenStartCap", "handle", $hPen, "int", $iLineCap)
EndFunc   ;==>_GDIPlus_PenSetStartCap
Func _GDIPlus_PenSetTransform($hPen, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenTransform", "handle", $hPen, "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_PenSetTransform
Func _GDIPlus_PenSetWidth($hPen, $fWidth)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetPenWidth", "handle", $hPen, "float", $fWidth)
EndFunc   ;==>_GDIPlus_PenSetWidth
Func _GDIPlus_RectFCreate($nX = 0, $nY = 0, $nWidth = 0, $nHeight = 0)
	DllStructSetData($tRECTF, "X", $nX)
	DllStructSetData($tRECTF, "Y", $nY)
	DllStructSetData($tRECTF, "Width", $nWidth)
	DllStructSetData($tRECTF, "Height", $nHeight)
	Return $tRECTF
EndFunc   ;==>_GDIPlus_RectFCreate
Func _GDIPlus_RegionClone($hRegion)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCloneRegion", "handle", $hRegion, "handle*", 0)
EndFunc   ;==>_GDIPlus_RegionClone
Func _GDIPlus_RegionCombinePath($hRegion, $hPath, $iCombineMode = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCombineRegionPath", "handle", $hRegion, "handle", $hPath, "int", $iCombineMode)
EndFunc   ;==>_GDIPlus_RegionCombinePath
Func _GDIPlus_RegionCombineRect($hRegion, $nX, $nY, $nWidth, $nHeight, $iCombineMode = 2)
	Local $tRECTF = _GDIPlus_RectFCreate($nX, $nY, $nWidth, $nHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCombineRegionRect", "handle", $hRegion, "struct*", $tRECTF, "int", $iCombineMode)
EndFunc   ;==>_GDIPlus_RegionCombineRect
Func _GDIPlus_RegionCombineRegion($hRegionDst, $hRegionSrc, $iCombineMode = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCombineRegionRegion", "handle", $hRegionDst, "handle", $hRegionSrc, "int", $iCombineMode)
EndFunc   ;==>_GDIPlus_RegionCombineRegion
Func _GDIPlus_RegionCreate()
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateRegion", "handle*", 0)
EndFunc   ;==>_GDIPlus_RegionCreate
Func _GDIPlus_RegionCreateFromPath($hPath)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateRegionPath", "handle", $hPath, "handle*", 0)
EndFunc   ;==>_GDIPlus_RegionCreateFromPath
Func _GDIPlus_RegionCreateFromRect($nX, $nY, $nWidth, $nHeight)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateRegionRect", "struct*", $tRECTF, "handle*", 0)
EndFunc   ;==>_GDIPlus_RegionCreateFromRect
Func _GDIPlus_RegionDispose($hRegion)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteRegion", "handle", $hRegion)
EndFunc   ;==>_GDIPlus_RegionDispose
Func _GDIPlus_RegionGetBounds($hRegion, $hGraphics)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetRegionBounds", "handle", $hRegion, "handle", $hGraphics, "struct*", $tRECTF)
	Local $aBounds[4]
		$aBounds[$iI - 1] = DllStructGetData($tRECTF, $iI)
	Return $aBounds
EndFunc   ;==>_GDIPlus_RegionGetBounds
Func _GDIPlus_RegionGetHRgn($hRegion, $hGraphics = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetRegionHRgn", "handle", $hRegion, "handle", $hGraphics, "handle*", 0)
EndFunc   ;==>_GDIPlus_RegionGetHRgn
Func _GDIPlus_RegionSetEmpty($hRegion)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetEmpty", "handle", $hRegion)
EndFunc   ;==>_GDIPlus_RegionSetEmpty
Func _GDIPlus_RegionSetInfinite($hRegion)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetInfinite", "handle", $hRegion)
EndFunc   ;==>_GDIPlus_RegionSetInfinite
Func _GDIPlus_RegionTransform($hRegion, $hMatrix)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTransformRegion", "handle", $hRegion, "handle", $hMatrix)
EndFunc   ;==>_GDIPlus_RegionTransform
Func _GDIPlus_RegionTranslate($hRegion, $nDX, $nDY)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipTranslateRegion", "handle", $hRegion, "float", $nDX, "float", $nDY)
EndFunc   ;==>_GDIPlus_RegionTranslate
Func _GDIPlus_Shutdown()
	If $__g_hGDIPDll = 0 Then Return SetError(-1, -1, False)
	$__g_iGDIPRef -= 1
	If $__g_iGDIPRef = 0 Then
		DllCall($__g_hGDIPDll, "none", "GdiplusShutdown", "ulong_ptr", $__g_iGDIPToken)
		DllClose($__g_hGDIPDll)
		$__g_hGDIPDll = 0
EndFunc   ;==>_GDIPlus_Shutdown
Func _GDIPlus_Startup($sGDIPDLL = Default, $bRetDllHandle = False)
	$__g_iGDIPRef += 1
	If $__g_iGDIPRef > 1 Then Return True
	If $sGDIPDLL = Default Then $sGDIPDLL = "gdiplus.dll"
	$__g_hGDIPDll = DllOpen($sGDIPDLL)
	If $__g_hGDIPDll = -1 Then
		$__g_iGDIPRef = 0
		Return SetError(1, 2, False)
	Local $sVer = FileGetVersion($sGDIPDLL)
	$sVer = StringSplit($sVer, ".")
	If $sVer[1] > 5 Then $__g_bGDIP_V1_0 = False
	Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
	Local $tToken = DllStructCreate("ulong_ptr Data")
	DllStructSetData($tInput, "Version", 1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdiplusStartup", "struct*", $tToken, "struct*", $tInput, "ptr", 0)
	$__g_iGDIPToken = DllStructGetData($tToken, "Data")
	If $bRetDllHandle Then Return $__g_hGDIPDll
	Return SetExtended($sVer[1], True)
EndFunc   ;==>_GDIPlus_Startup
Func _GDIPlus_StringFormatCreate($iFormat = 0, $iLangID = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateStringFormat", "int", $iFormat, "word", $iLangID, "handle*", 0)
EndFunc   ;==>_GDIPlus_StringFormatCreate
Func _GDIPlus_StringFormatDispose($hFormat)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteStringFormat", "handle", $hFormat)
EndFunc   ;==>_GDIPlus_StringFormatDispose
Func _GDIPlus_StringFormatGetMeasurableCharacterRangeCount($hStringFormat)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetStringFormatMeasurableCharacterRangeCount", "handle", $hStringFormat, "int*", 0)
EndFunc   ;==>_GDIPlus_StringFormatGetMeasurableCharacterRangeCount
Func _GDIPlus_StringFormatSetAlign($hStringFormat, $iFlag)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetStringFormatAlign", "handle", $hStringFormat, "int", $iFlag)
EndFunc   ;==>_GDIPlus_StringFormatSetAlign
Func _GDIPlus_StringFormatSetLineAlign($hStringFormat, $iStringAlign)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetStringFormatLineAlign", "handle", $hStringFormat, "int", $iStringAlign)
EndFunc   ;==>_GDIPlus_StringFormatSetLineAlign
Func _GDIPlus_StringFormatSetMeasurableCharacterRanges($hStringFormat, $aRanges)
	Local $iCount = $aRanges[0][0]
	Local $tCharacterRanges = DllStructCreate("int[" & $iCount * 2 & "]")
		DllStructSetData($tCharacterRanges, 1, $aRanges[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tCharacterRanges, 1, $aRanges[$iI][1], (($iI - 1) * 2) + 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetStringFormatMeasurableCharacterRanges", "handle", $hStringFormat, "int", $iCount, "struct*", $tCharacterRanges)
EndFunc   ;==>_GDIPlus_StringFormatSetMeasurableCharacterRanges
Func _GDIPlus_TextureCreate($hImage, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateTexture", "handle", $hImage, "int", $iWrapMode, "handle*", 0)
EndFunc   ;==>_GDIPlus_TextureCreate
Func _GDIPlus_TextureCreate2($hImage, $nX, $nY, $nWidth, $nHeight, $iWrapMode = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateTexture2", "handle", $hImage, "int", $iWrapMode, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "handle*", 0)
EndFunc   ;==>_GDIPlus_TextureCreate2
Func _GDIPlus_TextureCreateIA($hImage, $nX, $nY, $nWidth, $nHeight, $pImageAttributes = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateTextureIA", "handle", $hImage, "handle", $pImageAttributes, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "ptr*", 0)
EndFunc   ;==>_GDIPlus_TextureCreateIA
Func __GDIPlus_BrushDefCreate(ByRef $hBrush)
	If $hBrush = 0 Then
		$__g_hGDIPBrush = _GDIPlus_BrushCreateSolid()
		$hBrush = $__g_hGDIPBrush
EndFunc   ;==>__GDIPlus_BrushDefCreate
Func __GDIPlus_BrushDefDispose($iCurError = @error, $iCurExtended = @extended)
	If $__g_hGDIPBrush <> 0 Then
		_GDIPlus_BrushDispose($__g_hGDIPBrush)
		$__g_hGDIPBrush = 0
	Return SetError($iCurError, $iCurExtended) ; restore caller @error and @extended
EndFunc   ;==>__GDIPlus_BrushDefDispose
Func __GDIPlus_ExtractFileExt($sFileName, $bNoDot = True)
	Local $iIndex = __GDIPlus_LastDelimiter(".\:", $sFileName)
	If ($iIndex > 0) And (StringMid($sFileName, $iIndex, 1) = '.') Then
		If $bNoDot Then
			Return StringMid($sFileName, $iIndex + 1)
			Return StringMid($sFileName, $iIndex)
		Return ""
EndFunc   ;==>__GDIPlus_ExtractFileExt
Func __GDIPlus_LastDelimiter($sDelimiters, $sString)
	Local $sDelimiter, $iN
	For $iI = 1 To StringLen($sDelimiters)
		$sDelimiter = StringMid($sDelimiters, $iI, 1)
		$iN = StringInStr($sString, $sDelimiter, $STR_NOCASESENSEBASIC, -1)
		If $iN > 0 Then Return $iN
EndFunc   ;==>__GDIPlus_LastDelimiter
Func __GDIPlus_PenDefCreate(ByRef $hPen)
	If $hPen = 0 Then
		$__g_hGDIPPen = _GDIPlus_PenCreate()
		$hPen = $__g_hGDIPPen
EndFunc   ;==>__GDIPlus_PenDefCreate
Func __GDIPlus_PenDefDispose($iCurError = @error, $iCurExtended = @extended)
	If $__g_hGDIPPen <> 0 Then
		_GDIPlus_PenDispose($__g_hGDIPPen)
		$__g_hGDIPPen = 0
EndFunc   ;==>__GDIPlus_PenDefDispose
Func _GDIPlus_BitmapApplyEffect($hBitmap, $hEffect, $tRECT = Null)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, False)
	If Not IsPtr($hEffect) Then Return SetError(10, 0, False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapApplyEffect", "handle", $hBitmap, "handle", $hEffect, "struct*", $tRECT, "int", 0, "ptr*", 0, "int*", 0)
EndFunc   ;==>_GDIPlus_BitmapApplyEffect
Func _GDIPlus_BitmapApplyEffectEx($hBitmap, $hEffect, $iX = 0, $iY = 0, $iW = 0, $iH = 0)
	Local $tRECT = 0
	If BitOR($iX, $iY, $iW, $iH) Then
		$tRECT = DllStructCreate("int Left; int Top; int Right; int Bottom;")
		DllStructSetData($tRECT, "Right", $iW + DllStructSetData($tRECT, "Left", $iX))
		DllStructSetData($tRECT, "Bottom", $iH + DllStructSetData($tRECT, "Top", $iY))
	Local $iStatus = _GDIPlus_BitmapApplyEffect($hBitmap, $hEffect, $tRECT)
	If Not $iStatus Then Return SetError(@error, @extended, False)
EndFunc   ;==>_GDIPlus_BitmapApplyEffectEx
Func _GDIPlus_BitmapConvertFormat($hBitmap, $iPixelFormat, $iDitherType, $iPaletteType, $tPalette, $fAlphaThresholdPercent = 0.0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapConvertFormat", "handle", $hBitmap, "uint", $iPixelFormat, "uint", $iDitherType, "uint", $iPaletteType, "struct*", $tPalette, "float", $fAlphaThresholdPercent)
EndFunc   ;==>_GDIPlus_BitmapConvertFormat
Func _GDIPlus_BitmapCreateApplyEffect($hBitmap, $hEffect, $tRECT = Null, $tOutRECT = Null)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapCreateApplyEffect", "handle*", $hBitmap, "int", 1, "handle", $hEffect, "struct*", $tRECT, "struct*", $tOutRECT, "handle*", 0, "int", 0, "ptr*", 0, "int*", 0)
EndFunc   ;==>_GDIPlus_BitmapCreateApplyEffect
Func _GDIPlus_BitmapCreateApplyEffectEx($hBitmap, $hEffect, $iX = 0, $iY = 0, $iW = 0, $iH = 0)
	Local $hBitmap_FX = _GDIPlus_BitmapCreateApplyEffect($hBitmap, $hEffect, $tRECT, Null)
	Return SetError(@error, @extended, $hBitmap_FX)
EndFunc   ;==>_GDIPlus_BitmapCreateApplyEffectEx
Func _GDIPlus_BitmapGetHistogram($hBitmap, $iHistogramFormat, $iHistogramSize, $tChannel_0, $tChannel_1 = 0, $tChannel_2 = 0, $tChannel_3 = 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapGetHistogram", "handle", $hBitmap, "uint", $iHistogramFormat, "uint", $iHistogramSize, "struct*", $tChannel_0, "struct*", $tChannel_1, "struct*", $tChannel_2, "struct*", $tChannel_3)
EndFunc   ;==>_GDIPlus_BitmapGetHistogram
Func _GDIPlus_BitmapGetHistogramEx($hBitmap)
	Local $iSize = _GDIPlus_BitmapGetHistogramSize($GDIP_HistogramFormatARGB)
	Local $tHistogram = DllStructCreate("int Size; uint Red[" & $iSize & "]; uint MaxRed; uint Green[" & $iSize & "]; uint MaxGreen; uint Blue[" & $iSize & "]; uint MaxBlue; uint Alpha[" & $iSize & "]; uint MaxAlpha; uint Grey[" & $iSize & "]; uint MaxGrey;")
	DllStructSetData($tHistogram, "Size", $iSize)
	Local $iStatus = _GDIPlus_BitmapGetHistogram($hBitmap, $GDIP_HistogramFormatARGB, $iSize, DllStructGetPtr($tHistogram, "Alpha"), DllStructGetPtr($tHistogram, "Red"), DllStructGetPtr($tHistogram, "Green"), DllStructGetPtr($tHistogram, "Blue"))
	If Not $iStatus Then Return SetError(@error, @extended, 0)
	$iStatus = _GDIPlus_BitmapGetHistogram($hBitmap, $GDIP_HistogramFormatGray, $iSize, DllStructGetPtr($tHistogram, "Grey"))
	If Not $iStatus Then Return SetError(@error + 10, @extended, 0)
	Local $iMaxRed = 0, $iMaxGreen = 0, $iMaxBlue = 0, $iMaxAlpha = 0, $iMaxGrey = 0
		If DllStructGetData($tHistogram, "Red", $i) > $iMaxRed Then $iMaxRed = DllStructGetData($tHistogram, "Red", $i)
		If DllStructGetData($tHistogram, "Green", $i) > $iMaxGreen Then $iMaxGreen = DllStructGetData($tHistogram, "Green", $i)
		If DllStructGetData($tHistogram, "Blue", $i) > $iMaxBlue Then $iMaxBlue = DllStructGetData($tHistogram, "Blue", $i)
		If DllStructGetData($tHistogram, "Alpha", $i) > $iMaxAlpha Then $iMaxAlpha = DllStructGetData($tHistogram, "Alpha", $i)
		If DllStructGetData($tHistogram, "Grey", $i) > $iMaxGrey Then $iMaxGrey = DllStructGetData($tHistogram, "Grey", $i)
	DllStructSetData($tHistogram, "MaxRed", $iMaxRed)
	DllStructSetData($tHistogram, "MaxGreen", $iMaxGreen)
	DllStructSetData($tHistogram, "MaxBlue", $iMaxBlue)
	DllStructSetData($tHistogram, "MaxAlpha", $iMaxAlpha)
	DllStructSetData($tHistogram, "MaxGrey", $iMaxGrey)
	Return $tHistogram
EndFunc   ;==>_GDIPlus_BitmapGetHistogramEx
Func _GDIPlus_BitmapGetHistogramSize($iFormat)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipBitmapGetHistogramSize", "uint", $iFormat, "uint*", 0)
EndFunc   ;==>_GDIPlus_BitmapGetHistogramSize
Func _GDIPlus_DrawImageFX($hGraphics, $hImage, $hEffect, $tRECTF = 0, $hMatrix = 0, $hImgAttributes = 0, $iUnit = 2)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDrawImageFX", "handle", $hGraphics, "handle", $hImage, "struct*", $tRECTF, "handle", $hMatrix, "handle", $hEffect, "handle", $hImgAttributes, "uint", $iUnit)
EndFunc   ;==>_GDIPlus_DrawImageFX
Func _GDIPlus_DrawImageFXEx($hGraphics, $hImage, $hEffect, $nX = 0, $nY = 0, $nW = 0, $nH = 0, $hMatrix = 0, $hImgAttributes = 0, $iUnit = 2)
	Local $tRECTF = 0
	If BitOR($nX, $nY, $nW, $nH) Then $tRECTF = _GDIPlus_RectFCreate($nX, $nY, $nW, $nH)
	Local $iStatus = _GDIPlus_DrawImageFX($hGraphics, $hImage, $hEffect, $tRECTF, $hMatrix, $hImgAttributes, $iUnit)
	Return SetError(@error, @extended, $iStatus)
EndFunc   ;==>_GDIPlus_DrawImageFXEx
Func _GDIPlus_EffectCreate($sEffectGUID)
	Local $tGUID = _WinAPI_GUIDFromString($sEffectGUID)
		$aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateEffect", "struct*", $tGUID, "handle*", 0)
		If $aResult[0] Then Return SetError(10, $aResult[0], 0)
		Return $aResult[2]
	Local $tElem = DllStructCreate("uint64[2];", DllStructGetPtr($tGUID))
	$aResult = DllCall($__g_hGDIPDll, "int", "GdipCreateEffect", "uint64", DllStructGetData($tElem, 1, 1), "uint64", DllStructGetData($tElem, 1, 2), "handle*", 0)
EndFunc   ;==>_GDIPlus_EffectCreate
Func _GDIPlus_EffectCreateBlur($fRadius = 10.0, $bExpandEdge = False)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_Blur)
	DllStructSetData($tEffectParameters, "Radius", $fRadius)
	DllStructSetData($tEffectParameters, "ExpandEdge", $bExpandEdge)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_BlurEffectGuid)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters)
	Return $hEffect
EndFunc   ;==>_GDIPlus_EffectCreateBlur
Func _GDIPlus_EffectCreateBrightnessContrast($iBrightnessLevel = 0, $iContrastLevel = 0)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_BrightnessContrast)
	DllStructSetData($tEffectParameters, "BrightnessLevel", $iBrightnessLevel)
	DllStructSetData($tEffectParameters, "ContrastLevel", $iContrastLevel)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_BrightnessContrastEffectGuid)
EndFunc   ;==>_GDIPlus_EffectCreateBrightnessContrast
Func _GDIPlus_EffectCreateColorBalance($iCyanRed = 0, $iMagentaGreen = 0, $iYellowBlue = 0)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_ColorBalance)
	DllStructSetData($tEffectParameters, "CyanRed", $iCyanRed)
	DllStructSetData($tEffectParameters, "MagentaGreen", $iMagentaGreen)
	DllStructSetData($tEffectParameters, "YellowBlue", $iYellowBlue)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_ColorBalanceEffectGuid)
EndFunc   ;==>_GDIPlus_EffectCreateColorBalance
Func _GDIPlus_EffectCreateColorCurve($iAdjustment, $iChannel, $iAdjustValue)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_ColorCurve)
	DllStructSetData($tEffectParameters, "Adjustment", $iAdjustment)
	DllStructSetData($tEffectParameters, "Channel", $iChannel)
	DllStructSetData($tEffectParameters, "AdjustValue", $iAdjustValue)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_ColorCurveEffectGuid)
EndFunc   ;==>_GDIPlus_EffectCreateColorCurve
Func _GDIPlus_EffectCreateColorLUT($aColorLUT)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_ColorLUT)
	For $iI = 0 To 255
		DllStructSetData($tEffectParameters, "LutA", $aColorLUT[$iI][0], $iI + 1)
		DllStructSetData($tEffectParameters, "LutR", $aColorLUT[$iI][1], $iI + 1)
		DllStructSetData($tEffectParameters, "LutG", $aColorLUT[$iI][2], $iI + 1)
		DllStructSetData($tEffectParameters, "LutB", $aColorLUT[$iI][3], $iI + 1)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_ColorLUTEffectGuid)
EndFunc   ;==>_GDIPlus_EffectCreateColorLUT
Func _GDIPlus_EffectCreateColorMatrix($tColorMatrix)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_ColorMatrixEffectGuid)
	_GDIPlus_EffectSetParameters($hEffect, $tColorMatrix)
EndFunc   ;==>_GDIPlus_EffectCreateColorMatrix
Func _GDIPlus_EffectCreateHueSaturationLightness($iHueLevel = 0, $iSaturationLevel = 0, $iLightnessLevel = 0)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_HueSaturationLightness)
	DllStructSetData($tEffectParameters, "HueLevel", $iHueLevel)
	DllStructSetData($tEffectParameters, "SaturationLevel", $iSaturationLevel)
	DllStructSetData($tEffectParameters, "LightnessLevel", $iLightnessLevel)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_HueSaturationLightnessEffectGuid)
EndFunc   ;==>_GDIPlus_EffectCreateHueSaturationLightness
Func _GDIPlus_EffectCreateLevels($iHighlight = 100, $iMidtone = 0, $iShadow = 0)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_Levels)
	DllStructSetData($tEffectParameters, "Highlight", $iHighlight)
	DllStructSetData($tEffectParameters, "Midtone", $iMidtone)
	DllStructSetData($tEffectParameters, "Shadow", $iShadow)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_LevelsEffectGuid)
EndFunc   ;==>_GDIPlus_EffectCreateLevels
Func _GDIPlus_EffectCreateRedEyeCorrection($aAreas)
	Local $iCount = $aAreas[0][0]
	Local $tAreas = DllStructCreate("long[" & $iCount * 4 & "]")
		DllStructSetData($tAreas, 1, DllStructSetData($tAreas, 1, $aAreas[$iI][0], (($iI - 1) * 4) + 1) + $aAreas[$iI][2], (($iI - 1) * 4) + 3)
		DllStructSetData($tAreas, 1, DllStructSetData($tAreas, 1, $aAreas[$iI][1], (($iI - 1) * 4) + 2) + $aAreas[$iI][3], (($iI - 1) * 4) + 4)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_RedEyeCorrection)
	DllStructSetData($tEffectParameters, "NumberOfAreas", $iCount)
	DllStructSetData($tEffectParameters, "Areas", DllStructGetPtr($tAreas))
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_RedEyeCorrectionEffectGuid)
	_GDIPlus_EffectSetParameters($hEffect, $tEffectParameters, (DllStructGetSize($tAreas) + DllStructGetSize($tEffectParameters)) / DllStructGetSize($tEffectParameters))
EndFunc   ;==>_GDIPlus_EffectCreateRedEyeCorrection
Func _GDIPlus_EffectCreateSharpen($fRadius = 10.0, $fAmount = 50.0)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_Sharpen)
	DllStructSetData($tEffectParameters, "Amount", $fAmount)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_SharpenEffectGuid)
EndFunc   ;==>_GDIPlus_EffectCreateSharpen
Func _GDIPlus_EffectCreateTint($iHue = 0, $iAmount = 0)
	Local $tEffectParameters = DllStructCreate($tagGDIP_EFFECTPARAMS_Tint)
	DllStructSetData($tEffectParameters, "Hue", $iHue)
	DllStructSetData($tEffectParameters, "Amount", $iAmount)
	Local $hEffect = _GDIPlus_EffectCreate($GDIP_TintEffectGuid)
EndFunc   ;==>_GDIPlus_EffectCreateTint
Func _GDIPlus_EffectDispose($hEffect)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipDeleteEffect", "handle", $hEffect)
EndFunc   ;==>_GDIPlus_EffectDispose
Func _GDIPlus_EffectGetParameters($hEffect, $tEffectParameters)
	If DllStructGetSize($tEffectParameters) < __GDIPlus_EffectGetParameterSize($hEffect) Then Return SetError(2, 5, False)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEffectParameters", "handle", $hEffect, "uint*", DllStructGetSize($tEffectParameters), "struct*", $tEffectParameters)
EndFunc   ;==>_GDIPlus_EffectGetParameters
Func __GDIPlus_EffectGetParameterSize($hEffect)
	If $__g_bGDIP_V1_0 Then Return SetError(-1, 0, -1)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetEffectParameterSize", "handle", $hEffect, "uint*", 0)
EndFunc   ;==>__GDIPlus_EffectGetParameterSize
Func _GDIPlus_EffectSetParameters($hEffect, $tEffectParameters, $iSizeAdjust = 1)
	Local $iSize = __GDIPlus_EffectGetParameterSize($hEffect)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipSetEffectParameters", "handle", $hEffect, "struct*", $tEffectParameters, "uint", $iSize * $iSizeAdjust)
EndFunc   ;==>_GDIPlus_EffectSetParameters
Func _GDIPlus_PaletteInitialize($iEntries, $iPaletteType = $GDIP_PaletteTypeOptimal, $iOptimalColors = 0, $bUseTransparentColor = True, $hBitmap = Null)
	If $iOptimalColors > 0 Then $iPaletteType = $GDIP_PaletteTypeOptimal
	Local $tPalette = DllStructCreate("uint Flags; uint Count; uint ARGB[" & $iEntries & "];")
	DllStructSetData($tPalette, "Flags", $iPaletteType)
	DllStructSetData($tPalette, "Count", $iEntries)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipInitializePalette", "struct*", $tPalette, "uint", $iPaletteType, "uint", $iOptimalColors, "bool", $bUseTransparentColor, "handle", $hBitmap)
	Return $tPalette
EndFunc   ;==>_GDIPlus_PaletteInitialize
#include "MenuConstants.au3"
#include "WinAPISysInternals.au3"
Global Const $__MENUCONSTANT_OBJID_CLIENT = 0xFFFFFFFC
Global Const $tagMENUBARINFO = "dword Size;" & $tagRECT & ";handle hMenu;handle hWndMenu;bool Focused"
Global Const $tagMDINEXTMENU = "handle hMenuIn;handle hMenuNext;hwnd hWndNext"
Global Const $tagMENUGETOBJECTINFO = "dword Flags;uint Pos;handle hMenu;ptr RIID;ptr Obj"
Global Const $tagTPMPARAMS = "uint Size;" & $tagRECT
Func _GUICtrlMenu_AddMenuItem($hMenu, $sText, $iCmdID = 0, $hSubMenu = 0)
	Local $iIndex = _GUICtrlMenu_GetItemCount($hMenu)
	Local $tMenu = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tMenu, "Size", DllStructGetSize($tMenu))
	DllStructSetData($tMenu, "ID", $iCmdID)
	DllStructSetData($tMenu, "SubMenu", $hSubMenu)
	If $sText = "" Then
		DllStructSetData($tMenu, "Mask", $MIIM_FTYPE)
		DllStructSetData($tMenu, "Type", $MFT_SEPARATOR)
		DllStructSetData($tMenu, "Mask", BitOR($MIIM_ID, $MIIM_STRING, $MIIM_SUBMENU))
		DllStructSetData($tMenu, "Type", $MFT_STRING)
		Local $tText = DllStructCreate("wchar Text[" & StringLen($sText) + 1 & "]")
		DllStructSetData($tText, "Text", $sText)
		DllStructSetData($tMenu, "TypeData", DllStructGetPtr($tText))
	Local $aResult = DllCall("user32.dll", "bool", "InsertMenuItemW", "handle", $hMenu, "uint", $iIndex, "bool", True, "struct*", $tMenu)
	Return SetExtended($aResult[0], $iIndex)
EndFunc   ;==>_GUICtrlMenu_AddMenuItem
Func _GUICtrlMenu_AppendMenu($hMenu, $iFlags, $iNewItem, $vNewItem)
	Local $sType = "wstr"
	If BitAND($iFlags, $MF_BITMAP) Then $sType = "handle"
	If BitAND($iFlags, $MF_OWNERDRAW) Then $sType = "ulong_ptr"
	Local $aResult = DllCall("user32.dll", "bool", "AppendMenuW", "handle", $hMenu, "uint", $iFlags, "uint_ptr", $iNewItem, $sType, $vNewItem)
	If $aResult[0] = 0 Then Return SetError(10, 0, False)
	_GUICtrlMenu_DrawMenuBar(_GUICtrlMenu_FindParent($hMenu))
EndFunc   ;==>_GUICtrlMenu_AppendMenu
Func _GUICtrlMenu_CalculatePopupWindowPosition($iX, $iY, $iWidth, $iHeight, $iFlags = 0, $tExclude = 0)
	Local $tAnchor = DllStructCreate($tagPOINT)
	DllStructSetData($tAnchor, 1, $iX)
	DllStructSetData($tAnchor, 2, $iY)
	Local $tSIZE = DllStructCreate($tagSIZE)
	DllStructSetData($tSIZE, 1, $iWidth)
	DllStructSetData($tSIZE, 2, $iHeight)
	Local $tPos = DllStructCreate($tagRECT)
	Local $aRet = DllCall('user32.dll', 'bool', 'CalculatePopupWindowPosition', 'struct*', $tAnchor, 'struct*', $tSIZE, _
			'uint', $iFlags, 'struct*', $tExclude, 'struct*', $tPos)
	Return $tPos
EndFunc   ;==>_GUICtrlMenu_CalculatePopupWindowPosition
Func _GUICtrlMenu_CheckMenuItem($hMenu, $iItem, $bCheck = True, $bByPos = True)
	Local $iByPos = 0
	If $bCheck Then $iByPos = BitOR($iByPos, $MF_CHECKED)
	If $bByPos Then $iByPos = BitOR($iByPos, $MF_BYPOSITION)
	Local $aResult = DllCall("user32.dll", "dword", "CheckMenuItem", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
EndFunc   ;==>_GUICtrlMenu_CheckMenuItem
Func _GUICtrlMenu_CheckRadioItem($hMenu, $iFirst, $iLast, $iCheck, $bByPos = True)
	If $bByPos Then $iByPos = $MF_BYPOSITION
	Local $aResult = DllCall("user32.dll", "bool", "CheckMenuRadioItem", "handle", $hMenu, "uint", $iFirst, "uint", $iLast, "uint", $iCheck, "uint", $iByPos)
EndFunc   ;==>_GUICtrlMenu_CheckRadioItem
Func _GUICtrlMenu_CreateMenu($iStyle = $MNS_CHECKORBMP)
	Local $aResult = DllCall("user32.dll", "handle", "CreateMenu")
	If $aResult[0] = 0 Then Return SetError(10, 0, 0)
	_GUICtrlMenu_SetMenuStyle($aResult[0], $iStyle)
EndFunc   ;==>_GUICtrlMenu_CreateMenu
Func _GUICtrlMenu_CreatePopup($iStyle = $MNS_CHECKORBMP)
	Local $aResult = DllCall("user32.dll", "handle", "CreatePopupMenu")
EndFunc   ;==>_GUICtrlMenu_CreatePopup
Func _GUICtrlMenu_DeleteMenu($hMenu, $iItem, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "bool", "DeleteMenu", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
EndFunc   ;==>_GUICtrlMenu_DeleteMenu
Func _GUICtrlMenu_DestroyMenu($hMenu)
	Local $aResult = DllCall("user32.dll", "bool", "DestroyMenu", "handle", $hMenu)
EndFunc   ;==>_GUICtrlMenu_DestroyMenu
Func _GUICtrlMenu_DrawMenuBar($hWnd)
	Local $aResult = DllCall("user32.dll", "bool", "DrawMenuBar", "hwnd", $hWnd)
EndFunc   ;==>_GUICtrlMenu_DrawMenuBar
Func _GUICtrlMenu_EnableMenuItem($hMenu, $iItem, $iState = 0, $bByPos = True)
	Local $iByPos = $iState
	Local $aResult = DllCall("user32.dll", "bool", "EnableMenuItem", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
EndFunc   ;==>_GUICtrlMenu_EnableMenuItem
Func _GUICtrlMenu_EndMenu()
	Local $aResult = DllCall("user32.dll", "bool", "EndMenu")
EndFunc   ;==>_GUICtrlMenu_EndMenu
Func _GUICtrlMenu_FindItem($hMenu, $sText, $bInStr = False, $iStart = 0)
	Local $sMenu
	For $iI = $iStart To _GUICtrlMenu_GetItemCount($hMenu)
		$sMenu = StringReplace(_GUICtrlMenu_GetItemText($hMenu, $iI), "&", "")
		Switch $bInStr
			Case False
				If $sMenu = $sText Then Return $iI
				If StringInStr($sMenu, $sText) Then Return $iI
	Return -1
EndFunc   ;==>_GUICtrlMenu_FindItem
Func _GUICtrlMenu_FindParent($hMenu)
	Local $hList = _WinAPI_EnumWindowsTop()
	For $iI = 1 To $hList[0][0]
		If _GUICtrlMenu_GetMenu($hList[$iI][0]) = $hMenu Then Return $hList[$iI][0]
EndFunc   ;==>_GUICtrlMenu_FindParent
Func _GUICtrlMenu_GetItemBmp($hMenu, $iItem, $bByPos = True)
	Local $tInfo = _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos)
	Return DllStructGetData($tInfo, "BmpItem")
EndFunc   ;==>_GUICtrlMenu_GetItemBmp
Func _GUICtrlMenu_GetItemBmpChecked($hMenu, $iItem, $bByPos = True)
	Return DllStructGetData($tInfo, "BmpChecked")
EndFunc   ;==>_GUICtrlMenu_GetItemBmpChecked
Func _GUICtrlMenu_GetItemBmpUnchecked($hMenu, $iItem, $bByPos = True)
	Return DllStructGetData($tInfo, "BmpUnchecked")
EndFunc   ;==>_GUICtrlMenu_GetItemBmpUnchecked
Func _GUICtrlMenu_GetItemChecked($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_CHECKED) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemChecked
Func _GUICtrlMenu_GetItemCount($hMenu)
	Local $aResult = DllCall("user32.dll", "int", "GetMenuItemCount", "handle", $hMenu)
EndFunc   ;==>_GUICtrlMenu_GetItemCount
Func _GUICtrlMenu_GetItemData($hMenu, $iItem, $bByPos = True)
	Return DllStructGetData($tInfo, "ItemData")
EndFunc   ;==>_GUICtrlMenu_GetItemData
Func _GUICtrlMenu_GetItemDefault($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_DEFAULT) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemDefault
Func _GUICtrlMenu_GetItemDisabled($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_DISABLED) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemDisabled
Func _GUICtrlMenu_GetItemEnabled($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_DISABLED) = 0
EndFunc   ;==>_GUICtrlMenu_GetItemEnabled
Func _GUICtrlMenu_GetItemGrayed($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_GRAYED) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemGrayed
Func _GUICtrlMenu_GetItemHighlighted($hMenu, $iItem, $bByPos = True)
	Return BitAND(_GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos), $MF_HILITE) <> 0
EndFunc   ;==>_GUICtrlMenu_GetItemHighlighted
Func _GUICtrlMenu_GetItemID($hMenu, $iItem, $bByPos = True)
	Return DllStructGetData($tInfo, "ID")
EndFunc   ;==>_GUICtrlMenu_GetItemID
Func _GUICtrlMenu_GetItemInfo($hMenu, $iItem, $bByPos = True)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_DATAMASK)
	Local $aResult = DllCall("user32.dll", "bool", "GetMenuItemInfo", "handle", $hMenu, "uint", $iItem, "bool", $bByPos, "struct*", $tInfo)
	Return SetExtended($aResult[0], $tInfo)
EndFunc   ;==>_GUICtrlMenu_GetItemInfo
Func _GUICtrlMenu_GetItemRect($hWnd, $hMenu, $iItem)
	Local $tRECT = _GUICtrlMenu_GetItemRectEx($hWnd, $hMenu, $iItem)
	Local $aRect[4]
	$aRect[0] = DllStructGetData($tRECT, "Left")
	$aRect[1] = DllStructGetData($tRECT, "Top")
	$aRect[2] = DllStructGetData($tRECT, "Right")
	$aRect[3] = DllStructGetData($tRECT, "Bottom")
	Return $aRect
EndFunc   ;==>_GUICtrlMenu_GetItemRect
Func _GUICtrlMenu_GetItemRectEx($hWnd, $hMenu, $iItem)
	Local $aResult = DllCall("user32.dll", "bool", "GetMenuItemRect", "hwnd", $hWnd, "handle", $hMenu, "uint", $iItem, "struct*", $tRECT)
	Return SetExtended($aResult[0], $tRECT)
EndFunc   ;==>_GUICtrlMenu_GetItemRectEx
Func _GUICtrlMenu_GetItemState($hMenu, $iItem, $bByPos = True)
	Local $iState = _GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos)
	If BitAND($iState, $MFS_CHECKED) <> 0 Then $iRet = BitOR($iRet, 1)
	If BitAND($iState, $MFS_DEFAULT) <> 0 Then $iRet = BitOR($iRet, 2)
	If BitAND($iState, $MFS_DISABLED) <> 0 Then $iRet = BitOR($iRet, 4)
	If BitAND($iState, $MFS_GRAYED) <> 0 Then $iRet = BitOR($iRet, 8)
	If BitAND($iState, $MFS_HILITE) <> 0 Then $iRet = BitOR($iRet, 16)
	Return $iRet
EndFunc   ;==>_GUICtrlMenu_GetItemState
Func _GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos = True)
	Return DllStructGetData($tInfo, "State")
EndFunc   ;==>_GUICtrlMenu_GetItemStateEx
Func _GUICtrlMenu_GetItemSubMenu($hMenu, $iItem)
	Local $aResult = DllCall("user32.dll", "handle", "GetSubMenu", "handle", $hMenu, "int", $iItem)
EndFunc   ;==>_GUICtrlMenu_GetItemSubMenu
Func _GUICtrlMenu_GetItemText($hMenu, $iItem, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "int", "GetMenuStringW", "handle", $hMenu, "uint", $iItem, "wstr", "", "int", 4096, "uint", $iByPos)
EndFunc   ;==>_GUICtrlMenu_GetItemText
Func _GUICtrlMenu_GetItemType($hMenu, $iItem, $bByPos = True)
	Return DllStructGetData($tInfo, "Type")
EndFunc   ;==>_GUICtrlMenu_GetItemType
Func _GUICtrlMenu_GetMenu($hWnd)
	Local $aResult = DllCall("user32.dll", "handle", "GetMenu", "hwnd", $hWnd)
EndFunc   ;==>_GUICtrlMenu_GetMenu
Func _GUICtrlMenu_GetMenuBackground($hMenu)
	Local $tInfo = _GUICtrlMenu_GetMenuInfo($hMenu)
	Return DllStructGetData($tInfo, "hBack")
EndFunc   ;==>_GUICtrlMenu_GetMenuBackground
Func _GUICtrlMenu_GetMenuBarInfo($hWnd, $iItem = 0, $iObject = 1)
	Local $aObject[3] = [$__MENUCONSTANT_OBJID_CLIENT, $OBJID_MENU, $OBJID_SYSMENU]
	Local $tInfo = DllStructCreate($tagMENUBARINFO)
	Local $aResult = DllCall("user32.dll", "bool", "GetMenuBarInfo", "hwnd", $hWnd, "long", $aObject[$iObject], "long", $iItem, "struct*", $tInfo)
	Local $aInfo[8]
	$aInfo[0] = DllStructGetData($tInfo, "Left")
	$aInfo[1] = DllStructGetData($tInfo, "Top")
	$aInfo[2] = DllStructGetData($tInfo, "Right")
	$aInfo[3] = DllStructGetData($tInfo, "Bottom")
	$aInfo[4] = DllStructGetData($tInfo, "hMenu")
	$aInfo[5] = DllStructGetData($tInfo, "hWndMenu")
	$aInfo[6] = BitAND(DllStructGetData($tInfo, "Focused"), 1) <> 0
	$aInfo[7] = BitAND(DllStructGetData($tInfo, "Focused"), 2) <> 0
	Return SetExtended($aResult[0], $aInfo)
EndFunc   ;==>_GUICtrlMenu_GetMenuBarInfo
Func _GUICtrlMenu_GetMenuContextHelpID($hMenu)
	Return DllStructGetData($tInfo, "ContextHelpID")
EndFunc   ;==>_GUICtrlMenu_GetMenuContextHelpID
Func _GUICtrlMenu_GetMenuData($hMenu)
	Return DllStructGetData($tInfo, "MenuData")
EndFunc   ;==>_GUICtrlMenu_GetMenuData
Func _GUICtrlMenu_GetMenuDefaultItem($hMenu, $bByPos = True, $iFlags = 0)
	Local $aResult = DllCall("user32.dll", "INT", "GetMenuDefaultItem", "handle", $hMenu, "uint", $bByPos, "uint", $iFlags)
EndFunc   ;==>_GUICtrlMenu_GetMenuDefaultItem
Func _GUICtrlMenu_GetMenuHeight($hMenu)
	Return DllStructGetData($tInfo, "YMax")
EndFunc   ;==>_GUICtrlMenu_GetMenuHeight
Func _GUICtrlMenu_GetMenuInfo($hMenu)
	Local $tInfo = DllStructCreate($tagMENUINFO)
	DllStructSetData($tInfo, "Mask", BitOR($MIM_BACKGROUND, $MIM_HELPID, $MIM_MAXHEIGHT, $MIM_MENUDATA, $MIM_STYLE))
	Local $aResult = DllCall("user32.dll", "bool", "GetMenuInfo", "handle", $hMenu, "struct*", $tInfo)
EndFunc   ;==>_GUICtrlMenu_GetMenuInfo
Func _GUICtrlMenu_GetMenuStyle($hMenu)
	Return DllStructGetData($tInfo, "Style")
EndFunc   ;==>_GUICtrlMenu_GetMenuStyle
Func _GUICtrlMenu_GetSystemMenu($hWnd, $bRevert = False)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetSystemMenu", "hwnd", $hWnd, "int", $bRevert)
EndFunc   ;==>_GUICtrlMenu_GetSystemMenu
Func _GUICtrlMenu_InsertMenuItem($hMenu, $iIndex, $sText, $iCmdID = 0, $hSubMenu = 0)
EndFunc   ;==>_GUICtrlMenu_InsertMenuItem
Func _GUICtrlMenu_InsertMenuItemEx($hMenu, $iIndex, ByRef $tMenu, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "bool", "InsertMenuItemW", "handle", $hMenu, "uint", $iIndex, "bool", $bByPos, "struct*", $tMenu)
EndFunc   ;==>_GUICtrlMenu_InsertMenuItemEx
Func _GUICtrlMenu_IsMenu($hMenu)
	Local $aResult = DllCall("user32.dll", "bool", "IsMenu", "handle", $hMenu)
EndFunc   ;==>_GUICtrlMenu_IsMenu
Func _GUICtrlMenu_LoadMenu($hInst, $sMenuName)
	Local $aResult = DllCall("user32.dll", "handle", "LoadMenuW", "handle", $hInst, "wstr", $sMenuName)
EndFunc   ;==>_GUICtrlMenu_LoadMenu
Func _GUICtrlMenu_MapAccelerator($hMenu, $sAccelKey)
	Local $iCount = _GUICtrlMenu_GetItemCount($hMenu)
	For $iI = 0 To $iCount - 1
		$sText = _GUICtrlMenu_GetItemText($hMenu, $iI)
		If StringInStr($sText, "&" & $sAccelKey) > 0 Then Return $iI
EndFunc   ;==>_GUICtrlMenu_MapAccelerator
Func _GUICtrlMenu_MenuItemFromPoint($hWnd, $hMenu, $iX = -1, $iY = -1)
	If $iX = -1 Then $iX = _WinAPI_GetMousePosX()
	If $iY = -1 Then $iY = _WinAPI_GetMousePosY()
	Local $aResult = DllCall("user32.dll", "int", "MenuItemFromPoint", "hwnd", $hWnd, "handle", $hMenu, "int", $iX, "int", $iY)
EndFunc   ;==>_GUICtrlMenu_MenuItemFromPoint
Func _GUICtrlMenu_RemoveMenu($hMenu, $iItem, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "bool", "RemoveMenu", "handle", $hMenu, "uint", $iItem, "uint", $iByPos)
EndFunc   ;==>_GUICtrlMenu_RemoveMenu
Func _GUICtrlMenu_SetItemBitmaps($hMenu, $iItem, $hChecked, $hUnChecked, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "bool", "SetMenuItemBitmaps", "handle", $hMenu, "uint", $iItem, "uint", $iByPos, "handle", $hUnChecked, "handle", $hChecked)
EndFunc   ;==>_GUICtrlMenu_SetItemBitmaps
Func _GUICtrlMenu_SetItemBmp($hMenu, $iItem, $hBitmap, $bByPos = True)
	DllStructSetData($tInfo, "Mask", $MIIM_BITMAP)
	DllStructSetData($tInfo, "BmpItem", $hBitmap)
	Return _GUICtrlMenu_SetItemInfo($hMenu, $iItem, $tInfo, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemBmp
Func _GUICtrlMenu_SetItemBmpChecked($hMenu, $iItem, $hBitmap, $bByPos = True)
	DllStructSetData($tInfo, "Mask", $MIIM_CHECKMARKS)
	DllStructSetData($tInfo, "BmpChecked", $hBitmap)
EndFunc   ;==>_GUICtrlMenu_SetItemBmpChecked
Func _GUICtrlMenu_SetItemBmpUnchecked($hMenu, $iItem, $hBitmap, $bByPos = True)
	DllStructSetData($tInfo, "BmpUnchecked", $hBitmap)
EndFunc   ;==>_GUICtrlMenu_SetItemBmpUnchecked
Func _GUICtrlMenu_SetItemChecked($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, $MFS_CHECKED, $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemChecked
Func _GUICtrlMenu_SetItemData($hMenu, $iItem, $iData, $bByPos = True)
	DllStructSetData($tInfo, "Mask", $MIIM_DATA)
	DllStructSetData($tInfo, "ItemData", $iData)
EndFunc   ;==>_GUICtrlMenu_SetItemData
Func _GUICtrlMenu_SetItemDefault($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, $MFS_DEFAULT, $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemDefault
Func _GUICtrlMenu_SetItemDisabled($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, BitOR($MFS_DISABLED, $MFS_GRAYED), $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemDisabled
Func _GUICtrlMenu_SetItemEnabled($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, BitOR($MFS_DISABLED, $MFS_GRAYED), Not $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemEnabled
Func _GUICtrlMenu_SetItemGrayed($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, $MFS_GRAYED, $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemGrayed
Func _GUICtrlMenu_SetItemHighlighted($hMenu, $iItem, $bState = True, $bByPos = True)
	Return _GUICtrlMenu_SetItemState($hMenu, $iItem, $MFS_HILITE, $bState, $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetItemHighlighted
Func _GUICtrlMenu_SetItemID($hMenu, $iItem, $iID, $bByPos = True)
	DllStructSetData($tInfo, "Mask", $MIIM_ID)
	DllStructSetData($tInfo, "ID", $iID)
EndFunc   ;==>_GUICtrlMenu_SetItemID
Func _GUICtrlMenu_SetItemInfo($hMenu, $iItem, ByRef $tInfo, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "bool", "SetMenuItemInfoW", "handle", $hMenu, "uint", $iItem, "bool", $bByPos, "struct*", $tInfo)
EndFunc   ;==>_GUICtrlMenu_SetItemInfo
Func _GUICtrlMenu_SetItemState($hMenu, $iItem, $iState, $bState = True, $bByPos = True)
	Local $iFlag = _GUICtrlMenu_GetItemStateEx($hMenu, $iItem, $bByPos)
	If $bState Then
		$iState = BitOR($iFlag, $iState)
		$iState = BitAND($iFlag, BitNOT($iState))
	DllStructSetData($tInfo, "Mask", $MIIM_STATE)
	DllStructSetData($tInfo, "State", $iState)
EndFunc   ;==>_GUICtrlMenu_SetItemState
Func _GUICtrlMenu_SetItemSubMenu($hMenu, $iItem, $hSubMenu, $bByPos = True)
	DllStructSetData($tInfo, "Mask", $MIIM_SUBMENU)
	DllStructSetData($tInfo, "SubMenu", $hSubMenu)
EndFunc   ;==>_GUICtrlMenu_SetItemSubMenu
Func _GUICtrlMenu_SetItemText($hMenu, $iItem, $sText, $bByPos = True)
	Local $tBuffer = DllStructCreate("wchar Text[" & StringLen($sText) + 1 & "]")
	DllStructSetData($tBuffer, "Text", $sText)
	DllStructSetData($tInfo, "Mask", $MIIM_STRING)
	DllStructSetData($tInfo, "TypeData", DllStructGetPtr($tBuffer))
EndFunc   ;==>_GUICtrlMenu_SetItemText
Func _GUICtrlMenu_SetItemType($hMenu, $iItem, $iType, $bByPos = True)
	DllStructSetData($tInfo, "Mask", $MIIM_FTYPE)
	DllStructSetData($tInfo, "Type", $iType)
EndFunc   ;==>_GUICtrlMenu_SetItemType
Func _GUICtrlMenu_SetMenu($hWnd, $hMenu)
	Local $aResult = DllCall("user32.dll", "bool", "SetMenu", "hwnd", $hWnd, "handle", $hMenu)
EndFunc   ;==>_GUICtrlMenu_SetMenu
Func _GUICtrlMenu_SetMenuBackground($hMenu, $hBrush)
	DllStructSetData($tInfo, "Mask", $MIM_BACKGROUND)
	DllStructSetData($tInfo, "hBack", $hBrush)
	Return _GUICtrlMenu_SetMenuInfo($hMenu, $tInfo)
EndFunc   ;==>_GUICtrlMenu_SetMenuBackground
Func _GUICtrlMenu_SetMenuContextHelpID($hMenu, $iHelpID)
	DllStructSetData($tInfo, "Mask", $MIM_HELPID)
	DllStructSetData($tInfo, "ContextHelpID", $iHelpID)
EndFunc   ;==>_GUICtrlMenu_SetMenuContextHelpID
Func _GUICtrlMenu_SetMenuData($hMenu, $iData)
	DllStructSetData($tInfo, "Mask", $MIM_MENUDATA)
	DllStructSetData($tInfo, "MenuData", $iData)
EndFunc   ;==>_GUICtrlMenu_SetMenuData
Func _GUICtrlMenu_SetMenuDefaultItem($hMenu, $iItem, $bByPos = True)
	Local $aResult = DllCall("user32.dll", "bool", "SetMenuDefaultItem", "handle", $hMenu, "uint", $iItem, "uint", $bByPos)
EndFunc   ;==>_GUICtrlMenu_SetMenuDefaultItem
Func _GUICtrlMenu_SetMenuHeight($hMenu, $iHeight)
	DllStructSetData($tInfo, "Mask", $MIM_MAXHEIGHT)
	DllStructSetData($tInfo, "YMax", $iHeight)
EndFunc   ;==>_GUICtrlMenu_SetMenuHeight
Func _GUICtrlMenu_SetMenuInfo($hMenu, ByRef $tInfo)
	Local $aResult = DllCall("user32.dll", "bool", "SetMenuInfo", "handle", $hMenu, "struct*", $tInfo)
EndFunc   ;==>_GUICtrlMenu_SetMenuInfo
Func _GUICtrlMenu_SetMenuStyle($hMenu, $iStyle)
	DllStructSetData($tInfo, "Mask", $MIM_STYLE)
	DllStructSetData($tInfo, "Style", $iStyle)
EndFunc   ;==>_GUICtrlMenu_SetMenuStyle
Func _GUICtrlMenu_TrackPopupMenu($hMenu, $hWnd, $iX = -1, $iY = -1, $iAlignX = 1, $iAlignY = 1, $iNotify = 0, $iButtons = 0)
	Local $iFlags = 0
	Switch $iAlignX
			$iFlags = BitOR($iFlags, $TPM_LEFTALIGN)
			$iFlags = BitOR($iFlags, $TPM_RIGHTALIGN)
			$iFlags = BitOR($iFlags, $TPM_CENTERALIGN)
	Switch $iAlignY
			$iFlags = BitOR($iFlags, $TPM_TOPALIGN)
			$iFlags = BitOR($iFlags, $TPM_VCENTERALIGN)
			$iFlags = BitOR($iFlags, $TPM_BOTTOMALIGN)
	If BitAND($iNotify, 1) <> 0 Then $iFlags = BitOR($iFlags, $TPM_NONOTIFY)
	If BitAND($iNotify, 2) <> 0 Then $iFlags = BitOR($iFlags, $TPM_RETURNCMD)
	Switch $iButtons
			$iFlags = BitOR($iFlags, $TPM_RIGHTBUTTON)
			$iFlags = BitOR($iFlags, $TPM_LEFTBUTTON)
	Local $aResult = DllCall("user32.dll", "bool", "TrackPopupMenu", "handle", $hMenu, "uint", $iFlags, "int", $iX, "int", $iY, "int", 0, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>_GUICtrlMenu_TrackPopupMenu
#include "MemoryConstants.au3"
#include "ProcessConstants.au3"
Global Const $tagMEMMAP = "handle hProc;ulong_ptr Size;ptr Mem"
Func _MemFree(ByRef $tMemMap)
	Local $pMemory = DllStructGetData($tMemMap, "Mem")
	Local $hProcess = DllStructGetData($tMemMap, "hProc")
	Local $bResult = _MemVirtualFreeEx($hProcess, $pMemory, 0, $MEM_RELEASE)
	Return $bResult
EndFunc   ;==>_MemFree
Func _MemGlobalAlloc($iBytes, $iFlags = 0)
	Local $aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $iFlags, "ulong_ptr", $iBytes)
EndFunc   ;==>_MemGlobalAlloc
Func _MemGlobalFree($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ptr", "GlobalFree", "handle", $hMemory)
EndFunc   ;==>_MemGlobalFree
Func _MemGlobalLock($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hMemory)
EndFunc   ;==>_MemGlobalLock
Func _MemGlobalSize($hMemory)
	Local $aResult = DllCall("kernel32.dll", "ulong_ptr", "GlobalSize", "handle", $hMemory)
EndFunc   ;==>_MemGlobalSize
Func _MemGlobalUnlock($hMemory)
	Local $aResult = DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hMemory)
EndFunc   ;==>_MemGlobalUnlock
Func _MemInit($hWnd, $iSize, ByRef $tMemMap)
	Local $aResult = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $hWnd, "dword*", 0)
	Local $iProcessID = $aResult[2]
	If $iProcessID = 0 Then Return SetError(1, 0, 0) ; Invalid window handle
	Local $iAccess = BitOR($PROCESS_VM_OPERATION, $PROCESS_VM_READ, $PROCESS_VM_WRITE)
	Local $hProcess = __Mem_OpenProcess($iAccess, False, $iProcessID, True)
	Local $iAlloc = BitOR($MEM_RESERVE, $MEM_COMMIT)
	Local $pMemory = _MemVirtualAllocEx($hProcess, 0, $iSize, $iAlloc, $PAGE_READWRITE)
	If $pMemory = 0 Then Return SetError(2, 0, 0) ; Unable to allocate memory
	$tMemMap = DllStructCreate($tagMEMMAP)
	DllStructSetData($tMemMap, "hProc", $hProcess)
	DllStructSetData($tMemMap, "Size", $iSize)
	DllStructSetData($tMemMap, "Mem", $pMemory)
	Return $pMemory
EndFunc   ;==>_MemInit
Func _MemMoveMemory($pSource, $pDest, $iLength)
	DllCall("kernel32.dll", "none", "RtlMoveMemory", "struct*", $pDest, "struct*", $pSource, "ulong_ptr", $iLength)
EndFunc   ;==>_MemMoveMemory
Func _MemRead(ByRef $tMemMap, $pSrce, $pDest, $iSize)
	Local $aResult = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
			"ptr", $pSrce, "struct*", $pDest, "ulong_ptr", $iSize, "ulong_ptr*", 0)
EndFunc   ;==>_MemRead
Func _MemWrite(ByRef $tMemMap, $pSrce, $pDest = 0, $iSize = 0, $sSrce = "struct*")
	If $pDest = 0 Then $pDest = DllStructGetData($tMemMap, "Mem")
	If $iSize = 0 Then $iSize = DllStructGetData($tMemMap, "Size")
	Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($tMemMap, "hProc"), _
			"ptr", $pDest, $sSrce, $pSrce, "ulong_ptr", $iSize, "ulong_ptr*", 0)
EndFunc   ;==>_MemWrite
Func _MemVirtualAlloc($pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
EndFunc   ;==>_MemVirtualAlloc
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
	Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
EndFunc   ;==>_MemVirtualAllocEx
Func _MemVirtualFree($pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFree", "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
EndFunc   ;==>_MemVirtualFree
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
	Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
EndFunc   ;==>_MemVirtualFreeEx
Func __Mem_OpenProcess($iAccess, $bInherit, $iPID, $bDebugPriv = False)
EndFunc   ;==>__Mem_OpenProcess
Global Const $SS_LEFT = 0x0
Global Const $SS_CENTER = 0x1
Global Const $SS_RIGHT = 0x2
Global Const $SS_ICON = 0x3
Global Const $SS_BLACKRECT = 0x4
Global Const $SS_GRAYRECT = 0x5
Global Const $SS_WHITERECT = 0x6
Global Const $SS_BLACKFRAME = 0x7
Global Const $SS_GRAYFRAME = 0x8
Global Const $SS_WHITEFRAME = 0x9
Global Const $SS_SIMPLE = 0xB
Global Const $SS_LEFTNOWORDWRAP = 0xC
Global Const $SS_BITMAP = 0xE
Global Const $SS_ENHMETAFILE = 0xF
Global Const $SS_ETCHEDHORZ = 0x10
Global Const $SS_ETCHEDVERT = 0x11
Global Const $SS_ETCHEDFRAME = 0x12
Global Const $SS_REALSIZECONTROL = 0x40
Global Const $SS_NOPREFIX = 0x0080
Global Const $SS_NOTIFY = 0x0100
Global Const $SS_CENTERIMAGE = 0x0200
Global Const $SS_RIGHTJUST = 0x0400
Global Const $SS_SUNKEN = 0x1000
Global Const $GUI_SS_DEFAULT_LABEL = 0
Global Const $GUI_SS_DEFAULT_GRAPHIC = 0
Global Const $GUI_SS_DEFAULT_ICON = $SS_NOTIFY
Global Const $GUI_SS_DEFAULT_PIC = $SS_NOTIFY
Global Const $STM_SETICON = 0x0170
Global Const $STM_GETICON = 0x0171
Global Const $STM_SETIMAGE = 0x0172
Global Const $STM_GETIMAGE = 0x0173
#include "APIMiscConstants.au3"
Func _WinAPI_ArrayToStruct(Const ByRef $aData, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aData, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)
	Local $tagStruct = ''
	For $i = $iStart To $iEnd
		$tagStruct &= 'wchar[' & (StringLen($aData[$i]) + 1) & '];'
	Local $tData = DllStructCreate($tagStruct & 'wchar[1]')
	Local $iCount = 1
		DllStructSetData($tData, $iCount, $aData[$i])
	DllStructSetData($tData, $iCount, ChrW(0))
EndFunc   ;==>_WinAPI_ArrayToStruct
Func _WinAPI_CreateMargins($iLeftWidth, $iRightWidth, $iTopHeight, $iBottomHeight)
	Local $tMARGINS = DllStructCreate($tagMARGINS)
	DllStructSetData($tMARGINS, 1, $iLeftWidth)
	DllStructSetData($tMARGINS, 2, $iRightWidth)
	DllStructSetData($tMARGINS, 3, $iTopHeight)
	DllStructSetData($tMARGINS, 4, $iBottomHeight)
	Return $tMARGINS
EndFunc   ;==>_WinAPI_CreateMargins
Func _WinAPI_CreatePoint($iX, $iY)
	DllStructSetData($tPOINT, 1, $iX)
	DllStructSetData($tPOINT, 2, $iY)
	Return $tPOINT
EndFunc   ;==>_WinAPI_CreatePoint
Func _WinAPI_CreateRect($iLeft, $iTop, $iRight, $iBottom)
	DllStructSetData($tRECT, 1, $iLeft)
	DllStructSetData($tRECT, 2, $iTop)
	DllStructSetData($tRECT, 3, $iRight)
	DllStructSetData($tRECT, 4, $iBottom)
EndFunc   ;==>_WinAPI_CreateRect
Func _WinAPI_CreateRectEx($iX, $iY, $iWidth, $iHeight)
	DllStructSetData($tRECT, 1, $iX)
	DllStructSetData($tRECT, 2, $iY)
	DllStructSetData($tRECT, 3, $iX + $iWidth)
	DllStructSetData($tRECT, 4, $iY + $iHeight)
EndFunc   ;==>_WinAPI_CreateRectEx
Func _WinAPI_CreateSize($iWidth, $iHeight)
	Return $tSIZE
EndFunc   ;==>_WinAPI_CreateSize
Func _WinAPI_CopyStruct($tStruct, $sStruct = '')
	Local $iSize = DllStructGetSize($tStruct)
	If Not $iSize Then Return SetError(1, 0, 0)
	Local $tResult
	If Not StringStripWS($sStruct, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES) Then
		$tResult = DllStructCreate('byte[' & $iSize & ']')
		$tResult = DllStructCreate($sStruct)
	If DllStructGetSize($tResult) < $iSize Then Return SetError(2, 0, 0)
	_WinAPI_MoveMemory($tResult, $tStruct, $iSize)
	Return $tResult
EndFunc   ;==>_WinAPI_CopyStruct
Func _WinAPI_GetExtended()
	Return $__g_vExt
EndFunc   ;==>_WinAPI_GetExtended
Func _WinAPI_GetMousePos($bToClient = False, $hWnd = 0)
	Local $iMode = Opt("MouseCoordMode", 1)
	Local $aPos = MouseGetPos()
	Opt("MouseCoordMode", $iMode)
	DllStructSetData($tPoint, "X", $aPos[0])
	DllStructSetData($tPoint, "Y", $aPos[1])
	If $bToClient And Not _WinAPI_ScreenToClient($hWnd, $tPoint) Then Return SetError(@error + 20, @extended, 0)
EndFunc   ;==>_WinAPI_GetMousePos
Func _WinAPI_GetMousePosX($bToClient = False, $hWnd = 0)
	Local $tPoint = _WinAPI_GetMousePos($bToClient, $hWnd)
	Return DllStructGetData($tPoint, "X")
EndFunc   ;==>_WinAPI_GetMousePosX
Func _WinAPI_GetMousePosY($bToClient = False, $hWnd = 0)
	Return DllStructGetData($tPoint, "Y")
EndFunc   ;==>_WinAPI_GetMousePosY
Func _WinAPI_MulDiv($iNumber, $iNumerator, $iDenominator)
	Local $aResult = DllCall("kernel32.dll", "int", "MulDiv", "int", $iNumber, "int", $iNumerator, "int", $iDenominator)
EndFunc   ;==>_WinAPI_MulDiv
Func _WinAPI_PlaySound($sSound, $iFlags = $SND_SYSTEM_NOSTOP, $hInstance = 0)
	Local $sTypeOfSound = 'ptr'
	If $sSound Then
		If IsString($sSound) Then
			$sTypeOfSound = 'wstr'
		$sSound = 0
		$iFlags = 0
	Local $aRet = DllCall('winmm.dll', 'bool', 'PlaySoundW', $sTypeOfSound, $sSound, 'handle', $hInstance, 'dword', $iFlags)
EndFunc   ;==>_WinAPI_PlaySound
Func _WinAPI_StringLenA(Const ByRef $tString)
	Local $aResult = DllCall("kernel32.dll", "int", "lstrlenA", "struct*", $tString)
EndFunc   ;==>_WinAPI_StringLenA
Func _WinAPI_StringLenW(Const ByRef $tString)
	Local $aResult = DllCall("kernel32.dll", "int", "lstrlenW", "struct*", $tString)
EndFunc   ;==>_WinAPI_StringLenW
Func _WinAPI_StructToArray(ByRef $tStruct, $iItems = 0)
	Local $iSize = 2 * Floor(DllStructGetSize($tStruct) / 2)
	Local $pStruct = DllStructGetPtr($tStruct)
	If Not $iSize Or Not $pStruct Then Return SetError(1, 0, 0)
	Local $tData, $iLength, $iOffset = 0
		$iLength = _WinAPI_StrLen($pStruct + $iOffset)
		If Not $iLength Then
		If 2 * (1 + $iLength) + $iOffset > $iSize Then Return SetError(3, 0, 0)
		$tData = DllStructCreate('wchar[' & (1 + $iLength) & ']', $pStruct + $iOffset)
		If @error Then Return SetError(@error + 10, 0, 0)
		__Inc($aResult)
		$aResult[$aResult[0]] = DllStructGetData($tData, 1)
		If $aResult[0] = $iItems Then
		$iOffset += 2 * (1 + $iLength)
		If $iOffset >= $iSize Then Return SetError(3, 0, 0)
	If Not $aResult[0] Then Return SetError(2, 0, 0)
EndFunc   ;==>_WinAPI_StructToArray
Func _WinAPI_UnionStruct($tStruct1, $tStruct2, $sStruct = '')
	Local $aSize[2] = [DllStructGetSize($tStruct1), DllStructGetSize($tStruct2)]
	If Not $aSize[0] Or Not $aSize[1] Then Return SetError(1, 0, 0)
		$tResult = DllStructCreate('byte[' & ($aSize[0] + $aSize[1]) & ']')
	If DllStructGetSize($tResult) < ($aSize[0] + $aSize[1]) Then Return SetError(2, 0, 0)
	_WinAPI_MoveMemory($tResult, $tStruct1, $aSize[0])
	_WinAPI_MoveMemory(DllStructGetPtr($tResult) + $aSize[0], $tStruct2, $aSize[1])
EndFunc   ;==>_WinAPI_UnionStruct
Global Const $WC_ANIMATE = 'SysAnimate32'
Global Const $WC_BUTTON = 'Button'
Global Const $WC_COMBOBOX = 'ComboBox'
Global Const $WC_COMBOBOXEX = 'ComboBoxEx32'
Global Const $WC_DATETIMEPICK = 'SysDateTimePick32'
Global Const $WC_EDIT = 'Edit'
Global Const $WC_HEADER = 'SysHeader32'
Global Const $WC_HOTKEY = 'msctls_hotkey32'
Global Const $WC_IPADDRESS = 'SysIPAddress32'
Global Const $WC_LINK = 'SysLink'
Global Const $WC_LISTBOX = 'ListBox'
Global Const $WC_LISTVIEW = 'SysListView32'
Global Const $WC_MONTHCAL = 'SysMonthCal32'
Global Const $WC_NATIVEFONTCTL = 'NativeFontCtl'
Global Const $WC_PAGESCROLLER = 'SysPager'
Global Const $WC_PROGRESS = 'msctls_progress32'
Global Const $WC_REBAR = 'ReBarWindow32'
Global Const $WC_SCROLLBAR = 'ScrollBar'
Global Const $WC_STATIC = 'Static'
Global Const $WC_STATUSBAR = 'msctls_statusbar32'
Global Const $WC_TABCONTROL = 'SysTabControl32'
Global Const $WC_TOOLBAR = 'ToolbarWindow32'
Global Const $WC_TOOLTIPS = 'tooltips_class32'
Global Const $WC_TRACKBAR = 'msctls_trackbar32'
Global Const $WC_TREEVIEW = 'SysTreeView32'
Global Const $WC_UPDOWN = 'msctls_updown32'
Global Const $WS_OVERLAPPED = 0
Global Const $WS_TILED = $WS_OVERLAPPED
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_TABSTOP = 0x00010000
Global Const $WS_GROUP = 0x00020000
Global Const $WS_SIZEBOX = 0x00040000
Global Const $WS_THICKFRAME = $WS_SIZEBOX
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_HSCROLL = 0x00100000
Global Const $WS_VSCROLL = 0x00200000
Global Const $WS_DLGFRAME = 0x00400000
Global Const $WS_BORDER = 0x00800000
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_OVERLAPPEDWINDOW = BitOR($WS_CAPTION, $WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_OVERLAPPED, $WS_SYSMENU, $WS_THICKFRAME)
Global Const $WS_TILEDWINDOW = $WS_OVERLAPPEDWINDOW
Global Const $WS_MAXIMIZE = 0x01000000
Global Const $WS_CLIPCHILDREN = 0x02000000
Global Const $WS_CLIPSIBLINGS = 0x04000000
Global Const $WS_DISABLED = 0x08000000
Global Const $WS_VISIBLE = 0x10000000
Global Const $WS_MINIMIZE = 0x20000000
Global Const $WS_ICONIC = $WS_MINIMIZE
Global Const $WS_CHILD = 0x40000000
Global Const $WS_CHILDWINDOW = $WS_CHILD
Global Const $WS_POPUP = 0x80000000
Global Const $WS_POPUPWINDOW = 0x80880000
Global Const $DS_3DLOOK = 0x0004
Global Const $DS_ABSALIGN = 0x0001
Global Const $DS_CENTER = 0x0800
Global Const $DS_CENTERMOUSE = 0x1000
Global Const $DS_CONTEXTHELP = 0x2000
Global Const $DS_CONTROL = 0x0400
Global Const $DS_FIXEDSYS = 0x0008
Global Const $DS_LOCALEDIT = 0x0020
Global Const $DS_MODALFRAME = 0x0080
Global Const $DS_NOFAILCREATE = 0x0010
Global Const $DS_NOIDLEMSG = 0x0100
Global Const $DS_SETFONT = 0x0040
Global Const $DS_SETFOREGROUND = 0x0200
Global Const $DS_SHELLFONT = BitOR($DS_FIXEDSYS, $DS_SETFONT)
Global Const $DS_SYSMODAL = 0x0002
Global Const $WS_EX_ACCEPTFILES = 0x00000010
Global Const $WS_EX_APPWINDOW = 0x00040000
Global Const $WS_EX_COMPOSITED = 0x02000000
Global Const $WS_EX_CONTROLPARENT = 0x10000
Global Const $WS_EX_CLIENTEDGE = 0x00000200
Global Const $WS_EX_CONTEXTHELP = 0x00000400
Global Const $WS_EX_DLGMODALFRAME = 0x00000001
Global Const $WS_EX_LAYERED = 0x00080000
Global Const $WS_EX_LAYOUTRTL = 0x400000
Global Const $WS_EX_LEFT = 0x00000000
Global Const $WS_EX_LEFTSCROLLBAR = 0x00004000
Global Const $WS_EX_LTRREADING = 0x00000000
Global Const $WS_EX_MDICHILD = 0x00000040
Global Const $WS_EX_NOACTIVATE = 0x08000000
Global Const $WS_EX_NOINHERITLAYOUT = 0x00100000
Global Const $WS_EX_NOPARENTNOTIFY = 0x00000004
Global Const $WS_EX_RIGHT = 0x00001000
Global Const $WS_EX_RIGHTSCROLLBAR = 0x00000000
Global Const $WS_EX_RTLREADING = 0x2000
Global Const $WS_EX_STATICEDGE = 0x00020000
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $WS_EX_TOPMOST = 0x00000008
Global Const $WS_EX_TRANSPARENT = 0x00000020
Global Const $WS_EX_WINDOWEDGE = 0x00000100
Global Const $WS_EX_OVERLAPPEDWINDOW = BitOR($WS_EX_CLIENTEDGE, $WS_EX_WINDOWEDGE)
Global Const $WS_EX_PALETTEWINDOW = BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $WS_EX_WINDOWEDGE)
Global Const $WM_NULL = 0x0000
Global Const $WM_CREATE = 0x0001
Global Const $WM_DESTROY = 0x0002
Global Const $WM_MOVE = 0x0003
Global Const $WM_SIZEWAIT = 0x0004
Global Const $WM_SIZE = 0x0005
Global Const $WM_ACTIVATE = 0x0006
Global Const $WM_SETFOCUS = 0x0007
Global Const $WM_KILLFOCUS = 0x0008
Global Const $WM_SETVISIBLE = 0x0009
Global Const $WM_ENABLE = 0x000A
Global Const $WM_SETREDRAW = 0x000B
Global Const $WM_SETTEXT = 0x000C
Global Const $WM_GETTEXT = 0x000D
Global Const $WM_GETTEXTLENGTH = 0x000E
Global Const $WM_PAINT = 0x000F
Global Const $WM_CLOSE = 0x0010
Global Const $WM_QUERYENDSESSION = 0x0011
Global Const $WM_QUIT = 0x0012
Global Const $WM_ERASEBKGND = 0x0014
Global Const $WM_QUERYOPEN = 0x0013
Global Const $WM_SYSCOLORCHANGE = 0x0015
Global Const $WM_ENDSESSION = 0x0016
Global Const $WM_SYSTEMERROR = 0x0017
Global Const $WM_SHOWWINDOW = 0x0018
Global Const $WM_CTLCOLOR = 0x0019
Global Const $WM_SETTINGCHANGE = 0x001A
Global Const $WM_WININICHANGE = 0x001A
Global Const $WM_DEVMODECHANGE = 0x001B
Global Const $WM_ACTIVATEAPP = 0x001C
Global Const $WM_FONTCHANGE = 0x001D
Global Const $WM_TIMECHANGE = 0x001E
Global Const $WM_CANCELMODE = 0x001F
Global Const $WM_SETCURSOR = 0x0020
Global Const $WM_MOUSEACTIVATE = 0x0021
Global Const $WM_CHILDACTIVATE = 0x0022
Global Const $WM_QUEUESYNC = 0x0023
Global Const $WM_GETMINMAXINFO = 0x0024
Global Const $WM_LOGOFF = 0x0025
Global Const $WM_PAINTICON = 0x0026
Global Const $WM_ICONERASEBKGND = 0x0027
Global Const $WM_NEXTDLGCTL = 0x0028
Global Const $WM_ALTTABACTIVE = 0x0029
Global Const $WM_SPOOLERSTATUS = 0x002A
Global Const $WM_DRAWITEM = 0x002B
Global Const $WM_MEASUREITEM = 0x002C
Global Const $WM_DELETEITEM = 0x002D
Global Const $WM_VKEYTOITEM = 0x002E
Global Const $WM_CHARTOITEM = 0x002F
Global Const $WM_SETFONT = 0x0030
Global Const $WM_GETFONT = 0x0031
Global Const $WM_SETHOTKEY = 0x0032
Global Const $WM_GETHOTKEY = 0x0033
Global Const $WM_FILESYSCHANGE = 0x0034
Global Const $WM_ISACTIVEICON = 0x0035
Global Const $WM_QUERYPARKICON = 0x0036
Global Const $WM_QUERYDRAGICON = 0x0037
Global Const $WM_WINHELP = 0x0038
Global Const $WM_COMPAREITEM = 0x0039
Global Const $WM_FULLSCREEN = 0x003A
Global Const $WM_CLIENTSHUTDOWN = 0x003B
Global Const $WM_DDEMLEVENT = 0x003C
Global Const $WM_GETOBJECT = 0x003D
Global Const $WM_CALCSCROLL = 0x003F
Global Const $WM_TESTING = 0x0040
Global Const $WM_COMPACTING = 0x0041
Global Const $WM_OTHERWINDOWCREATED = 0x0042
Global Const $WM_OTHERWINDOWDESTROYED = 0x0043
Global Const $WM_COMMNOTIFY = 0x0044
Global Const $WM_MEDIASTATUSCHANGE = 0x0045
Global Const $WM_WINDOWPOSCHANGING = 0x0046
Global Const $WM_WINDOWPOSCHANGED = 0x0047
Global Const $WM_POWER = 0x0048
Global Const $WM_COPYGLOBALDATA = 0x0049
Global Const $WM_COPYDATA = 0x004A
Global Const $WM_CANCELJOURNAL = 0x004B
Global Const $WM_LOGONNOTIFY = 0x004C
Global Const $WM_KEYF1 = 0x004D
Global Const $WM_NOTIFY = 0x004E
Global Const $WM_ACCESS_WINDOW = 0x004F
Global Const $WM_INPUTLANGCHANGEREQUEST = 0x0050
Global Const $WM_INPUTLANGCHANGE = 0x0051
Global Const $WM_TCARD = 0x0052
Global Const $WM_HELP = 0x0053
Global Const $WM_USERCHANGED = 0x0054
Global Const $WM_NOTIFYFORMAT = 0x0055
Global Const $WM_QM_ACTIVATE = 0x0060
Global Const $WM_HOOK_DO_CALLBACK = 0x0061
Global Const $WM_SYSCOPYDATA = 0x0062
Global Const $WM_FINALDESTROY = 0x0070
Global Const $WM_MEASUREITEM_CLIENTDATA = 0x0071
Global Const $WM_CONTEXTMENU = 0x007B
Global Const $WM_STYLECHANGING = 0x007C
Global Const $WM_STYLECHANGED = 0x007D
Global Const $WM_DISPLAYCHANGE = 0x007E
Global Const $WM_GETICON = 0x007F
Global Const $WM_SETICON = 0x0080
Global Const $WM_NCCREATE = 0x0081
Global Const $WM_NCDESTROY = 0x0082
Global Const $WM_NCCALCSIZE = 0x0083
Global Const $WM_NCHITTEST = 0x0084
Global Const $WM_NCPAINT = 0x0085
Global Const $WM_NCACTIVATE = 0x0086
Global Const $WM_GETDLGCODE = 0x0087
Global Const $WM_SYNCPAINT = 0x0088
Global Const $WM_SYNCTASK = 0x0089
Global Const $WM_KLUDGEMINRECT = 0x008B
Global Const $WM_LPKDRAWSWITCHWND = 0x008C
Global Const $WM_UAHDESTROYWINDOW = 0x0090
Global Const $WM_UAHDRAWMENU = 0x0091
Global Const $WM_UAHDRAWMENUITEM = 0x0092
Global Const $WM_UAHINITMENU = 0x0093
Global Const $WM_UAHMEASUREMENUITEM = 0x0094
Global Const $WM_UAHNCPAINTMENUPOPUP = 0x0095
Global Const $WM_NCMOUSEMOVE = 0x00A0
Global Const $WM_NCLBUTTONDOWN = 0x00A1
Global Const $WM_NCLBUTTONUP = 0x00A2
Global Const $WM_NCLBUTTONDBLCLK = 0x00A3
Global Const $WM_NCRBUTTONDOWN = 0x00A4
Global Const $WM_NCRBUTTONUP = 0x00A5
Global Const $WM_NCRBUTTONDBLCLK = 0x00A6
Global Const $WM_NCMBUTTONDOWN = 0x00A7
Global Const $WM_NCMBUTTONUP = 0x00A8
Global Const $WM_NCMBUTTONDBLCLK = 0x00A9
Global Const $WM_NCXBUTTONDOWN = 0x00AB
Global Const $WM_NCXBUTTONUP = 0x00AC
Global Const $WM_NCXBUTTONDBLCLK = 0x00AD
Global Const $WM_NCUAHDRAWCAPTION = 0x00AE
Global Const $WM_NCUAHDRAWFRAME = 0x00AF
Global Const $WM_INPUT_DEVICE_CHANGE = 0x00FE
Global Const $WM_INPUT = 0x00FF
Global Const $WM_KEYDOWN = 0x0100
Global Const $WM_KEYFIRST = 0x0100
Global Const $WM_KEYUP = 0x0101
Global Const $WM_CHAR = 0x0102
Global Const $WM_DEADCHAR = 0x0103
Global Const $WM_SYSKEYDOWN = 0x0104
Global Const $WM_SYSKEYUP = 0x0105
Global Const $WM_SYSCHAR = 0x0106
Global Const $WM_SYSDEADCHAR = 0x0107
Global Const $WM_YOMICHAR = 0x0108
Global Const $WM_KEYLAST = 0x0109
Global Const $WM_UNICHAR = 0x0109
Global Const $WM_CONVERTREQUEST = 0x010A
Global Const $WM_CONVERTRESULT = 0x010B
Global Const $WM_IM_INFO = 0x010C
Global Const $WM_IME_STARTCOMPOSITION = 0x010D
Global Const $WM_IME_ENDCOMPOSITION = 0x010E
Global Const $WM_IME_COMPOSITION = 0x010F
Global Const $WM_IME_KEYLAST = 0x010F
Global Const $WM_INITDIALOG = 0x0110
Global Const $WM_COMMAND = 0x0111
Global Const $WM_SYSCOMMAND = 0x0112
Global Const $WM_TIMER = 0x0113
Global Const $WM_HSCROLL = 0x0114
Global Const $WM_VSCROLL = 0x0115
Global Const $WM_INITMENU = 0x0116
Global Const $WM_INITMENUPOPUP = 0x0117
Global Const $WM_SYSTIMER = 0x0118
Global Const $WM_GESTURE = 0x0119
Global Const $WM_GESTURENOTIFY = 0x011A
Global Const $WM_GESTUREINPUT = 0x011B
Global Const $WM_GESTURENOTIFIED = 0x011C
Global Const $WM_MENUSELECT = 0x011F
Global Const $WM_MENUCHAR = 0x0120
Global Const $WM_ENTERIDLE = 0x0121
Global Const $WM_MENURBUTTONUP = 0x0122
Global Const $WM_MENUDRAG = 0x0123
Global Const $WM_MENUGETOBJECT = 0x0124
Global Const $WM_UNINITMENUPOPUP = 0x0125
Global Const $WM_MENUCOMMAND = 0x0126
Global Const $WM_CHANGEUISTATE = 0x0127
Global Const $WM_UPDATEUISTATE = 0x0128
Global Const $WM_QUERYUISTATE = 0x0129
Global Const $WM_LBTRACKPOINT = 0x0131
Global Const $WM_CTLCOLORMSGBOX = 0x0132
Global Const $WM_CTLCOLOREDIT = 0x0133
Global Const $WM_CTLCOLORLISTBOX = 0x0134
Global Const $WM_CTLCOLORBTN = 0x0135
Global Const $WM_CTLCOLORDLG = 0x0136
Global Const $WM_CTLCOLORSCROLLBAR = 0x0137
Global Const $WM_CTLCOLORSTATIC = 0x0138
Global Const $MN_GETHMENU = 0x01E1
Global Const $WM_PARENTNOTIFY = 0x0210
Global Const $WM_ENTERMENULOOP = 0x0211
Global Const $WM_EXITMENULOOP = 0x0212
Global Const $WM_NEXTMENU = 0x0213
Global Const $WM_SIZING = 0x0214
Global Const $WM_CAPTURECHANGED = 0x0215
Global Const $WM_MOVING = 0x0216
Global Const $WM_POWERBROADCAST = 0x0218
Global Const $WM_DEVICECHANGE = 0x0219
Global Const $WM_MDICREATE = 0x0220
Global Const $WM_MDIDESTROY = 0x0221
Global Const $WM_MDIACTIVATE = 0x0222
Global Const $WM_MDIRESTORE = 0x0223
Global Const $WM_MDINEXT = 0x0224
Global Const $WM_MDIMAXIMIZE = 0x0225
Global Const $WM_MDITILE = 0x0226
Global Const $WM_MDICASCADE = 0x0227
Global Const $WM_MDIICONARRANGE = 0x0228
Global Const $WM_MDIGETACTIVE = 0x0229
Global Const $WM_DROPOBJECT = 0x022A
Global Const $WM_QUERYDROPOBJECT = 0x022B
Global Const $WM_BEGINDRAG = 0x022C
Global Const $WM_DRAGLOOP = 0x022D
Global Const $WM_DRAGSELECT = 0x022E
Global Const $WM_DRAGMOVE = 0x022F
Global Const $WM_MDISETMENU = 0x0230
Global Const $WM_ENTERSIZEMOVE = 0x0231
Global Const $WM_EXITSIZEMOVE = 0x0232
Global Const $WM_DROPFILES = 0x0233
Global Const $WM_MDIREFRESHMENU = 0x0234
Global Const $WM_TOUCH = 0x0240
Global Const $WM_IME_SETCONTEXT = 0x0281
Global Const $WM_IME_NOTIFY = 0x0282
Global Const $WM_IME_CONTROL = 0x0283
Global Const $WM_IME_COMPOSITIONFULL = 0x0284
Global Const $WM_IME_SELECT = 0x0285
Global Const $WM_IME_CHAR = 0x0286
Global Const $WM_IME_SYSTEM = 0x0287
Global Const $WM_IME_REQUEST = 0x0288
Global Const $WM_IME_KEYDOWN = 0x0290
Global Const $WM_IME_KEYUP = 0x0291
Global Const $WM_NCMOUSEHOVER = 0x02A0
Global Const $WM_MOUSEHOVER = 0x02A1
Global Const $WM_NCMOUSELEAVE = 0x02A2
Global Const $WM_MOUSELEAVE = 0x02A3
Global Const $WM_WTSSESSION_CHANGE = 0x02B1
Global Const $WM_TABLET_FIRST = 0x02C0
Global Const $WM_TABLET_LAST = 0x02DF
Global Const $WM_CUT = 0x0300
Global Const $WM_COPY = 0x0301
Global Const $WM_PASTE = 0x0302
Global Const $WM_CLEAR = 0x0303
Global Const $WM_UNDO = 0x0304
Global Const $WM_PALETTEISCHANGING = 0x0310
Global Const $WM_HOTKEY = 0x0312
Global Const $WM_PALETTECHANGED = 0x0311
Global Const $WM_SYSMENU = 0x0313
Global Const $WM_HOOKMSG = 0x0314
Global Const $WM_EXITPROCESS = 0x0315
Global Const $WM_WAKETHREAD = 0x0316
Global Const $WM_PRINT = 0x0317
Global Const $WM_PRINTCLIENT = 0x0318
Global Const $WM_APPCOMMAND = 0x0319
Global Const $WM_QUERYNEWPALETTE = 0x030F
Global Const $WM_THEMECHANGED = 0x031A
Global Const $WM_UAHINIT = 0x031B
Global Const $WM_DESKTOPNOTIFY = 0x031C
Global Const $WM_CLIPBOARDUPDATE = 0x031D
Global Const $WM_DWMCOMPOSITIONCHANGED = 0x031E
Global Const $WM_DWMNCRENDERINGCHANGED = 0x031F
Global Const $WM_DWMCOLORIZATIONCOLORCHANGED = 0x0320
Global Const $WM_DWMWINDOWMAXIMIZEDCHANGE = 0x0321
Global Const $WM_DWMEXILEFRAME = 0x0322
Global Const $WM_DWMSENDICONICTHUMBNAIL = 0x0323
Global Const $WM_MAGNIFICATION_STARTED = 0x0324
Global Const $WM_MAGNIFICATION_ENDED = 0x0325
Global Const $WM_DWMSENDICONICLIVEPREVIEWBITMAP = 0x0326
Global Const $WM_DWMTHUMBNAILSIZECHANGED = 0x0327
Global Const $WM_MAGNIFICATION_OUTPUT = 0x0328
Global Const $WM_MEASURECONTROL = 0x0330
Global Const $WM_GETACTIONTEXT = 0x0331
Global Const $WM_FORWARDKEYDOWN = 0x0333
Global Const $WM_FORWARDKEYUP = 0x0334
Global Const $WM_GETTITLEBARINFOEX = 0x033F
Global Const $WM_NOTIFYWOW = 0x0340
Global Const $WM_HANDHELDFIRST = 0x0358
Global Const $WM_HANDHELDLAST = 0x035F
Global Const $WM_AFXFIRST = 0x0360
Global Const $WM_AFXLAST = 0x037F
Global Const $WM_PENWINFIRST = 0x0380
Global Const $WM_PENWINLAST = 0x038F
Global Const $WM_DDE_INITIATE = 0x03E0
Global Const $WM_DDE_TERMINATE = 0x03E1
Global Const $WM_DDE_ADVISE = 0x03E2
Global Const $WM_DDE_UNADVISE = 0x03E3
Global Const $WM_DDE_ACK = 0x03E4
Global Const $WM_DDE_DATA = 0x03E5
Global Const $WM_DDE_REQUEST = 0x03E6
Global Const $WM_DDE_POKE = 0x03E7
Global Const $WM_DDE_EXECUTE = 0x03E8
Global Const $WM_DBNOTIFICATION = 0x03FD
Global Const $WM_NETCONNECT = 0x03FE
Global Const $WM_HIBERNATE = 0x03FF
Global Const $WM_USER = 0x0400
Global Const $WM_APP = 0x8000
Global Const $NM_FIRST = 0
Global Const $NM_OUTOFMEMORY = $NM_FIRST - 1
Global Const $NM_CLICK = $NM_FIRST - 2
Global Const $NM_DBLCLK = $NM_FIRST - 3
Global Const $NM_RETURN = $NM_FIRST - 4
Global Const $NM_RCLICK = $NM_FIRST - 5
Global Const $NM_RDBLCLK = $NM_FIRST - 6
Global Const $NM_SETFOCUS = $NM_FIRST - 7
Global Const $NM_KILLFOCUS = $NM_FIRST - 8
Global Const $NM_CUSTOMDRAW = $NM_FIRST - 12
Global Const $NM_HOVER = $NM_FIRST - 13
Global Const $NM_NCHITTEST = $NM_FIRST - 14
Global Const $NM_KEYDOWN = $NM_FIRST - 15
Global Const $NM_RELEASEDCAPTURE = $NM_FIRST - 16
Global Const $NM_SETCURSOR = $NM_FIRST - 17
Global Const $NM_CHAR = $NM_FIRST - 18
Global Const $NM_TOOLTIPSCREATED = $NM_FIRST - 19
Global Const $NM_LDOWN = $NM_FIRST - 20
Global Const $NM_RDOWN = $NM_FIRST - 21
Global Const $NM_THEMECHANGED = $NM_FIRST - 22
Global Const $WM_MOUSEFIRST = 0x0200
Global Const $WM_MOUSEMOVE = 0x0200
Global Const $WM_LBUTTONDOWN = 0x0201
Global Const $WM_LBUTTONUP = 0x0202
Global Const $WM_LBUTTONDBLCLK = 0x0203
Global Const $WM_RBUTTONDOWN = 0x0204
Global Const $WM_RBUTTONUP = 0x0205
Global Const $WM_RBUTTONDBLCLK = 0x0206
Global Const $WM_MBUTTONDOWN = 0x0207
Global Const $WM_MBUTTONUP = 0x0208
Global Const $WM_MBUTTONDBLCLK = 0x0209
Global Const $WM_MOUSEWHEEL = 0x020A
Global Const $WM_XBUTTONDOWN = 0x020B
Global Const $WM_XBUTTONUP = 0x020C
Global Const $WM_XBUTTONDBLCLK = 0x020D
Global Const $WM_MOUSEHWHEEL = 0x020E
Global Const $PS_SOLID = 0
Global Const $PS_DASH = 1
Global Const $PS_DOT = 2
Global Const $PS_DASHDOT = 3
Global Const $PS_DASHDOTDOT = 4
Global Const $PS_NULL = 5
Global Const $PS_INSIDEFRAME = 6
Global Const $PS_USERSTYLE = 7
Global Const $PS_ALTERNATE = 8
Global Const $PS_ENDCAP_ROUND = 0x00000000
Global Const $PS_ENDCAP_SQUARE = 0x00000100
Global Const $PS_ENDCAP_FLAT = 0x00000200
Global Const $PS_JOIN_BEVEL = 0x00001000
Global Const $PS_JOIN_MITER = 0x00002000
Global Const $PS_JOIN_ROUND = 0x00000000
Global Const $PS_GEOMETRIC = 0x00010000
Global Const $PS_COSMETIC = 0x00000000
Global Const $LWA_ALPHA = 0x2
Global Const $LWA_COLORKEY = 0x1
Global Const $RGN_AND = 1
Global Const $RGN_OR = 2
Global Const $RGN_XOR = 3
Global Const $RGN_DIFF = 4
Global Const $RGN_COPY = 5
Global Const $ERRORREGION = 0
Global Const $NULLREGION = 1
Global Const $SIMPLEREGION = 2
Global Const $COMPLEXREGION = 3
Global Const $TRANSPARENT = 1
Global Const $OPAQUE = 2
Global Const $CCM_FIRST = 0x2000
Global Const $CCM_GETUNICODEFORMAT = ($CCM_FIRST + 6)
Global Const $CCM_SETUNICODEFORMAT = ($CCM_FIRST + 5)
Global Const $CCM_SETBKCOLOR = $CCM_FIRST + 1
Global Const $CCM_SETCOLORSCHEME = $CCM_FIRST + 2
Global Const $CCM_GETCOLORSCHEME = $CCM_FIRST + 3
Global Const $CCM_GETDROPTARGET = $CCM_FIRST + 4
Global Const $CCM_SETWINDOWTHEME = $CCM_FIRST + 11
Global Const $GA_PARENT = 1
Global Const $GA_ROOT = 2
Global Const $GA_ROOTOWNER = 3
Global Const $SM_CXSCREEN = 0
Global Const $SM_CYSCREEN = 1
Global Const $SM_CXVSCROLL = 2
Global Const $SM_CYHSCROLL = 3
Global Const $SM_CYCAPTION = 4
Global Const $SM_CXBORDER = 5
Global Const $SM_CYBORDER = 6
Global Const $SM_CXFIXEDFRAME = 7
Global Const $SM_CXDLGFRAME = $SM_CXFIXEDFRAME
Global Const $SM_CYFIXEDFRAME = 8
Global Const $SM_CYDLGFRAME = $SM_CYFIXEDFRAME
Global Const $SM_CYVTHUMB = 9
Global Const $SM_CXHTHUMB = 10
Global Const $SM_CXICON = 11
Global Const $SM_CYICON = 12
Global Const $SM_CXCURSOR = 13
Global Const $SM_CYCURSOR = 14
Global Const $SM_CYMENU = 15
Global Const $SM_CXFULLSCREEN = 16
Global Const $SM_CYFULLSCREEN = 17
Global Const $SM_CYKANJIWINDOW = 18
Global Const $SM_MOUSEPRESENT = 19
Global Const $SM_CYVSCROLL = 20
Global Const $SM_CXHSCROLL = 21
Global Const $SM_DEBUG = 22
Global Const $SM_SWAPBUTTON = 23
Global Const $SM_RESERVED1 = 24
Global Const $SM_RESERVED2 = 25
Global Const $SM_RESERVED3 = 26
Global Const $SM_RESERVED4 = 27
Global Const $SM_CXMIN = 28
Global Const $SM_CYMIN = 29
Global Const $SM_CXSIZE = 30
Global Const $SM_CYSIZE = 31
Global Const $SM_CXSIZEFRAME = 32
Global Const $SM_CXFRAME = $SM_CXSIZEFRAME
Global Const $SM_CYSIZEFRAME = 33
Global Const $SM_CYFRAME = $SM_CYSIZEFRAME
Global Const $SM_CXMINTRACK = 34
Global Const $SM_CYMINTRACK = 35
Global Const $SM_CXDOUBLECLK = 36
Global Const $SM_CYDOUBLECLK = 37
Global Const $SM_CXICONSPACING = 38
Global Const $SM_CYICONSPACING = 39
Global Const $SM_MENUDROPALIGNMENT = 40
Global Const $SM_PENWINDOWS = 41
Global Const $SM_DBCSENABLED = 42
Global Const $SM_CMOUSEBUTTONS = 43
Global Const $SM_SECURE = 44
Global Const $SM_CXEDGE = 45
Global Const $SM_CYEDGE = 46
Global Const $SM_CXMINSPACING = 47
Global Const $SM_CYMINSPACING = 48
Global Const $SM_CXSMICON = 49
Global Const $SM_CYSMICON = 50
Global Const $SM_CYSMCAPTION = 51
Global Const $SM_CXSMSIZE = 52
Global Const $SM_CYSMSIZE = 53
Global Const $SM_CXMENUSIZE = 54
Global Const $SM_CYMENUSIZE = 55
Global Const $SM_ARRANGE = 56
Global Const $SM_CXMINIMIZED = 57
Global Const $SM_CYMINIMIZED = 58
Global Const $SM_CXMAXTRACK = 59
Global Const $SM_CYMAXTRACK = 60
Global Const $SM_CXMAXIMIZED = 61
Global Const $SM_CYMAXIMIZED = 62
Global Const $SM_NETWORK = 63
Global Const $SM_CLEANBOOT = 67
Global Const $SM_CXDRAG = 68
Global Const $SM_CYDRAG = 69
Global Const $SM_SHOWSOUNDS = 70
Global Const $SM_CXMENUCHECK = 71
Global Const $SM_CYMENUCHECK = 72
Global Const $SM_SLOWMACHINE = 73
Global Const $SM_MIDEASTENABLED = 74
Global Const $SM_MOUSEWHEELPRESENT = 75
Global Const $SM_XVIRTUALSCREEN = 76
Global Const $SM_YVIRTUALSCREEN = 77
Global Const $SM_CXVIRTUALSCREEN = 78
Global Const $SM_CYVIRTUALSCREEN = 79
Global Const $SM_CMONITORS = 80
Global Const $SM_SAMEDISPLAYFORMAT = 81
Global Const $SM_IMMENABLED = 82
Global Const $SM_CXFOCUSBORDER = 83
Global Const $SM_CYFOCUSBORDER = 84
Global Const $SM_TABLETPC = 86
Global Const $SM_MEDIACENTER = 87
Global Const $SM_STARTER = 88
Global Const $SM_SERVERR2 = 89
Global Const $SM_CMETRICS = 90
Global Const $SM_REMOTESESSION = 0x1000
Global Const $SM_SHUTTINGDOWN = 0x2000
Global Const $SM_REMOTECONTROL = 0x2001
Global Const $SM_CARETBLINKINGENABLED = 0x2002
Global Const $BLACKNESS = 0x00000042 ; Fills the destination rectangle using the color associated with index 0 in the physical palette
Global Const $CAPTUREBLT = 0X40000000 ; Includes any window that are layered on top of your window in the resulting image
Global Const $DSTINVERT = 0x00550009 ; Inverts the destination rectangle
Global Const $MERGECOPY = 0x00C000CA ; Copies the inverted source rectangle to the destination
Global Const $MERGEPAINT = 0x00BB0226 ; Merges the color of the inverted source rectangle with the colors of the destination rectangle by using the OR operator
Global Const $NOMIRRORBITMAP = 0X80000000 ; Prevents the bitmap from being mirrored
Global Const $NOTSRCCOPY = 0x00330008 ; Copies the inverted source rectangle to the destination
Global Const $NOTSRCERASE = 0x001100A6 ; Combines the colors of the source and destination rectangles by using the Boolean OR operator and then inverts the resultant color
Global Const $PATCOPY = 0x00F00021 ; Copies the brush selected in hdcDest, into the destination bitmap
Global Const $PATINVERT = 0x005A0049 ; Combines the colors of the brush currently selected  in  hDest,  with  the  colors  of  the destination rectangle by using the XOR operator
Global Const $PATPAINT = 0x00FB0A09 ; Combines the colors of the brush currently selected  in  hDest,  with  the  colors  of  the inverted source rectangle by using the OR operator
Global Const $SRCAND = 0x008800C6 ; Combines the colors of the source and destination rectangles by using the Boolean AND operator
Global Const $SRCCOPY = 0x00CC0020 ; Copies the source rectangle directly to the destination rectangle
Global Const $SRCERASE = 0x00440328 ; Combines the inverted colors of the destination rectangle with the colors of the source rectangle by using the Boolean AND operator
Global Const $SRCINVERT = 0x00660046 ; Combines the colors of the source and destination rectangles by using the Boolean XOR operator
Global Const $SRCPAINT = 0x00EE0086 ; Combines the colors of the source and destination rectangles by using the Boolean OR operator
Global Const $WHITENESS = 0x00FF0062 ; Fills the destination rectangle using the color associated with index 1 in the physical palette
Global Const $DT_BOTTOM = 0x8
Global Const $DT_CALCRECT = 0x400
Global Const $DT_CENTER = 0x1
Global Const $DT_EDITCONTROL = 0x2000
Global Const $DT_END_ELLIPSIS = 0x8000
Global Const $DT_EXPANDTABS = 0x40
Global Const $DT_EXTERNALLEADING = 0x200
Global Const $DT_HIDEPREFIX = 0x100000
Global Const $DT_INTERNAL = 0x1000
Global Const $DT_LEFT = 0x0
Global Const $DT_MODIFYSTRING = 0x10000
Global Const $DT_NOCLIP = 0x100
Global Const $DT_NOFULLWIDTHCHARBREAK = 0x80000
Global Const $DT_NOPREFIX = 0x800
Global Const $DT_PATH_ELLIPSIS = 0x4000
Global Const $DT_PREFIXONLY = 0x200000
Global Const $DT_RIGHT = 0x2
Global Const $DT_RTLREADING = 0x20000
Global Const $DT_SINGLELINE = 0x20
Global Const $DT_TABSTOP = 0x80
Global Const $DT_TOP = 0x0
Global Const $DT_VCENTER = 0x4
Global Const $DT_WORDBREAK = 0x10
Global Const $DT_WORD_ELLIPSIS = 0x40000
Global Const $RDW_ERASE = 0x0004 ; Causes the window to receive a WM_ERASEBKGND message when the window is repainted
Global Const $RDW_FRAME = 0x0400 ; Causes any part of the nonclient area of the window that intersects the update region to receive a WM_NCPAINT message
Global Const $RDW_INTERNALPAINT = 0x0002 ; Causes a WM_PAINT message to be posted to the window regardless of whether any portion of the window is invalid
Global Const $RDW_INVALIDATE = 0x0001 ; Invalidates DllStructGetData($tRECT or $hRegion, "") If both are 0, the entire window is invalidated
Global Const $RDW_NOERASE = 0x0020 ; Suppresses any pending WM_ERASEBKGND messages
Global Const $RDW_NOFRAME = 0x0800 ; Suppresses any pending WM_NCPAINT messages
Global Const $RDW_NOINTERNALPAINT = 0x0010 ; Suppresses any pending internal WM_PAINT messages
Global Const $RDW_VALIDATE = 0x0008 ; Validates Rect or hRegion
Global Const $RDW_ERASENOW = 0x0200 ; Causes the affected windows to receive WM_NCPAINT and WM_ERASEBKGND messages
Global Const $RDW_UPDATENOW = 0x0100 ; Causes the affected windows to receive WM_NCPAINT, WM_ERASEBKGND, and WM_PAINT messages
Global Const $RDW_ALLCHILDREN = 0x0080 ; Includes child windows in the repainting operation
Global Const $RDW_NOCHILDREN = 0x0040 ; Excludes child windows from the repainting operation
Global Const $WM_RENDERFORMAT = 0x0305 ; Sent if the owner has delayed rendering a specific clipboard format
Global Const $WM_RENDERALLFORMATS = 0x0306 ; Sent if the owner has delayed rendering clipboard formats
Global Const $WM_DESTROYCLIPBOARD = 0x0307 ; Sent when a call to EmptyClipboard empties the clipboard
Global Const $WM_DRAWCLIPBOARD = 0x0308 ; Sent when the content of the clipboard changes
Global Const $WM_PAINTCLIPBOARD = 0x0309 ; Sent when the clipboard viewer's client area needs repainting
Global Const $WM_VSCROLLCLIPBOARD = 0x030A ; Sent when an event occurs in the viewer's vertical scroll bar
Global Const $WM_SIZECLIPBOARD = 0x030B ; Sent when the clipboard viewer's client area has changed size
Global Const $WM_ASKCBFORMATNAME = 0x030C ; Sent to request the name of a $CF_OWNERDISPLAY clipboard format
Global Const $WM_CHANGECBCHAIN = 0x030D ; Sent when a window is being removed from the chain
Global Const $WM_HSCROLLCLIPBOARD = 0x030E ; Sent when an event occurs in the viewer's horizontal scroll bar
Global Const $HTERROR = -2
Global Const $HTTRANSPARENT = -1
Global Const $HTNOWHERE = 0
Global Const $HTCLIENT = 1
Global Const $HTCAPTION = 2
Global Const $HTSYSMENU = 3
Global Const $HTGROWBOX = 4
Global Const $HTSIZE = $HTGROWBOX
Global Const $HTMENU = 5
Global Const $HTHSCROLL = 6
Global Const $HTVSCROLL = 7
Global Const $HTMINBUTTON = 8
Global Const $HTMAXBUTTON = 9
Global Const $HTLEFT = 10
Global Const $HTRIGHT = 11
Global Const $HTTOP = 12
Global Const $HTTOPLEFT = 13
Global Const $HTTOPRIGHT = 14
Global Const $HTBOTTOM = 15
Global Const $HTBOTTOMLEFT = 16
Global Const $HTBOTTOMRIGHT = 17
Global Const $HTBORDER = 18
Global Const $HTREDUCE = $HTMINBUTTON
Global Const $HTZOOM = $HTMAXBUTTON
Global Const $HTSIZEFIRST = $HTLEFT
Global Const $HTSIZELAST = $HTBOTTOMRIGHT
Global Const $HTOBJECT = 19
Global Const $HTCLOSE = 20
Global Const $HTHELP = 21
Global Const $COLOR_SCROLLBAR = 0
Global Const $COLOR_BACKGROUND = 1
Global Const $COLOR_ACTIVECAPTION = 2
Global Const $COLOR_INACTIVECAPTION = 3
Global Const $COLOR_MENU = 4
Global Const $COLOR_WINDOW = 5
Global Const $COLOR_WINDOWFRAME = 6
Global Const $COLOR_MENUTEXT = 7
Global Const $COLOR_WINDOWTEXT = 8
Global Const $COLOR_CAPTIONTEXT = 9
Global Const $COLOR_ACTIVEBORDER = 10
Global Const $COLOR_INACTIVEBORDER = 11
Global Const $COLOR_APPWORKSPACE = 12
Global Const $COLOR_HIGHLIGHT = 13
Global Const $COLOR_HIGHLIGHTTEXT = 14
Global Const $COLOR_BTNFACE = 15
Global Const $COLOR_BTNSHADOW = 16
Global Const $COLOR_GRAYTEXT = 17
Global Const $COLOR_BTNTEXT = 18
Global Const $COLOR_INACTIVECAPTIONTEXT = 19
Global Const $COLOR_BTNHIGHLIGHT = 20
Global Const $COLOR_3DDKSHADOW = 21
Global Const $COLOR_3DLIGHT = 22
Global Const $COLOR_INFOTEXT = 23
Global Const $COLOR_INFOBK = 24
Global Const $COLOR_HOTLIGHT = 26
Global Const $COLOR_GRADIENTACTIVECAPTION = 27
Global Const $COLOR_GRADIENTINACTIVECAPTION = 28
Global Const $COLOR_MENUHILIGHT = 29
Global Const $COLOR_MENUBAR = 30
Global Const $COLOR_DESKTOP = 1
Global Const $COLOR_3DFACE = 15
Global Const $COLOR_3DSHADOW = 16
Global Const $COLOR_3DHIGHLIGHT = 20
Global Const $COLOR_3DHILIGHT = 20
Global Const $COLOR_BTNHILIGHT = 20
Global Const $HINST_COMMCTRL = -1
Global Const $IDB_STD_SMALL_COLOR = 0
Global Const $IDB_STD_LARGE_COLOR = 1
Global Const $IDB_VIEW_SMALL_COLOR = 4
Global Const $IDB_VIEW_LARGE_COLOR = 5
Global Const $IDB_HIST_SMALL_COLOR = 8
Global Const $IDB_HIST_LARGE_COLOR = 9
Global Const $STARTF_FORCEOFFFEEDBACK = 0x80
Global Const $STARTF_FORCEONFEEDBACK = 0x40
Global Const $STARTF_PREVENTPINNING = 0x00002000
Global Const $STARTF_RUNFULLSCREEN = 0x20
Global Const $STARTF_TITLEISAPPID = 0x00001000
Global Const $STARTF_TITLEISLINKNAME = 0x00000800
Global Const $STARTF_USECOUNTCHARS = 0x8
Global Const $STARTF_USEFILLATTRIBUTE = 0x10
Global Const $STARTF_USEHOTKEY = 0x200
Global Const $STARTF_USEPOSITION = 0x4
Global Const $STARTF_USESHOWWINDOW = 0x1
Global Const $STARTF_USESIZE = 0x2
Global Const $STARTF_USESTDHANDLES = 0x100
Global Const $CDDS_PREPAINT = 0x00000001
Global Const $CDDS_POSTPAINT = 0x00000002
Global Const $CDDS_PREERASE = 0x00000003
Global Const $CDDS_POSTERASE = 0x00000004
Global Const $CDDS_ITEM = 0x00010000
Global Const $CDDS_ITEMPREPAINT = 0x00010001
Global Const $CDDS_ITEMPOSTPAINT = 0x00010002
Global Const $CDDS_ITEMPREERASE = 0x00010003
Global Const $CDDS_ITEMPOSTERASE = 0x00010004
Global Const $CDDS_SUBITEM = 0x00020000
Global Const $CDIS_SELECTED = 0x0001
Global Const $CDIS_GRAYED = 0x0002
Global Const $CDIS_DISABLED = 0x0004
Global Const $CDIS_CHECKED = 0x0008
Global Const $CDIS_FOCUS = 0x0010
Global Const $CDIS_DEFAULT = 0x0020
Global Const $CDIS_HOT = 0x0040
Global Const $CDIS_MARKED = 0x0080
Global Const $CDIS_INDETERMINATE = 0x0100
Global Const $CDIS_SHOWKEYBOARDCUES = 0x0200
Global Const $CDIS_NEARHOT = 0x0400
Global Const $CDIS_OTHERSIDEHOT = 0x0800
Global Const $CDIS_DROPHILITED = 0x1000
Global Const $CDRF_DODEFAULT = 0x00000000
Global Const $CDRF_NEWFONT = 0x00000002
Global Const $CDRF_SKIPDEFAULT = 0x00000004
Global Const $CDRF_NOTIFYPOSTPAINT = 0x00000010
Global Const $CDRF_NOTIFYITEMDRAW = 0x00000020
Global Const $CDRF_NOTIFYSUBITEMDRAW = 0x00000020
Global Const $CDRF_NOTIFYPOSTERASE = 0x00000040
Global Const $CDRF_DOERASE = 0x00000008
Global Const $CDRF_SKIPPOSTPAINT = 0x00000100
Global Const $GUI_SS_DEFAULT_GUI = BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
Global Const $FLASHW_CAPTION = 0x00000001
Global Const $FLASHW_TRAY = 0x00000002
Global Const $FLASHW_TIMER = 0x00000004
Global Const $FLASHW_TIMERNOFG = 0x0000000C
Global Const $tagUPDATELAYEREDWINDOWINFO = 'dword Size;hwnd hDstDC;long DstX;long DstY;long cX;long cY;hwnd hSrcDC;long SrcX;long SrcY;dword crKey;byte BlendOp;byte BlendFlags;byte Alpha;byte AlphaFormat;dword Flags;long DirtyLeft;long DirtyTop;long DirtyRight;long DirtyBottom'
Global Const $tagWINDOWINFO = 'dword Size;struct;long rWindow[4];endstruct;struct;long rClient[4];endstruct;dword Style;dword ExStyle;dword WindowStatus;uint cxWindowBorders;uint cyWindowBorders;word atomWindowType;word CreatorVersion'
Global Const $tagWNDCLASS = 'uint Style;ptr hWndProc;int ClsExtra;int WndExtra;ptr hInstance;ptr hIcon;ptr hCursor;ptr hBackground;ptr MenuName;ptr ClassName'
Global Const $tagWNDCLASSEX = 'uint Size;uint Style;ptr hWndProc;int ClsExtra;int WndExtra;ptr hInstance;ptr hIcon;ptr hCursor;ptr hBackground;ptr MenuName;ptr ClassName;ptr hIconSm'
Global Const $tagFLASHWINFO = "uint Size;hwnd hWnd;dword Flags;uint Count;dword TimeOut"
Func _WinAPI_AdjustWindowRectEx(ByRef $tRECT, $iStyle, $iExStyle = 0, $bMenu = False)
	Local $aRet = DllCall('user32.dll', 'bool', 'AdjustWindowRectEx', 'struct*', $tRECT, 'dword', $iStyle, 'bool', $bMenu, _
			'dword', $iExStyle)
EndFunc   ;==>_WinAPI_AdjustWindowRectEx
Func _WinAPI_AnimateWindow($hWnd, $iFlags, $iDuration = 1000)
	Local $aRet = DllCall('user32.dll', 'bool', 'AnimateWindow', 'hwnd', $hWnd, 'dword', $iDuration, 'dword', $iFlags)
EndFunc   ;==>_WinAPI_AnimateWindow
Func _WinAPI_BeginDeferWindowPos($iAmount = 1)
	Local $aRet = DllCall('user32.dll', 'handle', 'BeginDeferWindowPos', 'int', $iAmount)
EndFunc   ;==>_WinAPI_BeginDeferWindowPos
Func _WinAPI_BringWindowToTop($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'BringWindowToTop', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_BringWindowToTop
Func _WinAPI_BroadcastSystemMessage($iMsg, $wParam = 0, $lParam = 0, $iFlags = 0, $iRecipients = 0)
	Local $aRet = DllCall('user32.dll', 'long', 'BroadcastSystemMessageW', 'dword', $iFlags, 'dword*', $iRecipients, _
			'uint', $iMsg, 'wparam', $wParam, 'lparam', $lParam)
	If @error Or ($aRet[0] = -1) Then Return SetError(@error, @extended, -1)
	Return SetExtended($aRet[2], $aRet[0])
EndFunc   ;==>_WinAPI_BroadcastSystemMessage
Func _WinAPI_CallWindowProc($pPrevWndFunc, $hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "lresult", "CallWindowProc", "ptr", $pPrevWndFunc, "hwnd", $hWnd, "uint", $iMsg, _
			"wparam", $wParam, "lparam", $lParam)
EndFunc   ;==>_WinAPI_CallWindowProc
Func _WinAPI_CallWindowProcW($pPrevWndProc, $hWnd, $iMsg, $wParam, $lParam)
	Local $aRet = DllCall('user32.dll', 'lresult', 'CallWindowProcW', 'ptr', $pPrevWndProc, 'hwnd', $hWnd, 'uint', $iMsg, _
			'wparam', $wParam, 'lparam', $lParam)
EndFunc   ;==>_WinAPI_CallWindowProcW
Func _WinAPI_CascadeWindows($aWnds, $tRECT = 0, $hParent = 0, $iFlags = 0, $iStart = 0, $iEnd = -1)
	If __CheckErrorArrayBounds($aWnds, $iStart, $iEnd) Then Return SetError(@error + 10, @extended, 0)
	Local $iCount = $iEnd - $iStart + 1
	Local $tWnds = DllStructCreate('hwnd[' & $iCount & ']')
	$iCount = 1
		DllStructSetData($tWnds, 1, $aWnds[$i], $iCount)
	Local $aRet = DllCall('user32.dll', 'word', 'CascadeWindows', 'hwnd', $hParent, 'uint', $iFlags, 'struct*', $tRECT, _
			'uint', $iCount - 1, 'struct*', $tWnds)
EndFunc   ;==>_WinAPI_CascadeWindows
Func _WinAPI_ChangeWindowMessageFilterEx($hWnd, $iMsg, $iAction)
	Local $tCFS, $aRet
	If $hWnd And ($__WINVER > 0x0600) Then
		Local Const $tagCHANGEFILTERSTRUCT = 'dword cbSize; dword ExtStatus'
		$tCFS = DllStructCreate($tagCHANGEFILTERSTRUCT)
		DllStructSetData($tCFS, 1, DllStructGetSize($tCFS))
		$aRet = DllCall('user32.dll', 'bool', 'ChangeWindowMessageFilterEx', 'hwnd', $hWnd, 'uint', $iMsg, 'dword', $iAction, _
				'struct*', $tCFS)
		$tCFS = 0
		$aRet = DllCall('user32.dll', 'bool', 'ChangeWindowMessageFilter', 'uint', $iMsg, 'dword', $iAction)
	Return SetExtended(DllStructGetData($tCFS, 2), 1)
EndFunc   ;==>_WinAPI_ChangeWindowMessageFilterEx
Func _WinAPI_ChildWindowFromPointEx($hWnd, $tPOINT, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'ChildWindowFromPointEx', 'hwnd', $hWnd, 'struct', $tPOINT, 'uint', $iFlags)
EndFunc   ;==>_WinAPI_ChildWindowFromPointEx
Func _WinAPI_CloseWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'CloseWindow', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_CloseWindow
Func _WinAPI_DeferWindowPos($hInfo, $hWnd, $hAfter, $iX, $iY, $iWidth, $iHeight, $iFlags)
	Local $aRet = DllCall('user32.dll', 'handle', 'DeferWindowPos', 'handle', $hInfo, 'hwnd', $hWnd, 'hwnd', $hAfter, _
			'int', $iX, 'int', $iY, 'int', $iWidth, 'int', $iHeight, 'uint', $iFlags)
EndFunc   ;==>_WinAPI_DeferWindowPos
Func _WinAPI_DefWindowProc($hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "lresult", "DefWindowProc", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, _
			"lparam", $lParam)
EndFunc   ;==>_WinAPI_DefWindowProc
Func _WinAPI_DefWindowProcW($hWnd, $iMsg, $wParam, $lParam)
	Local $aRet = DllCall('user32.dll', 'lresult', 'DefWindowProcW', 'hwnd', $hWnd, 'uint', $iMsg, 'wparam', $wParam, _
			'lparam', $lParam)
EndFunc   ;==>_WinAPI_DefWindowProcW
Func _WinAPI_DeregisterShellHookWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'DeregisterShellHookWindow', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_DeregisterShellHookWindow
Func _WinAPI_DragAcceptFiles($hWnd, $bAccept = True)
	DllCall('shell32.dll', 'none', 'DragAcceptFiles', 'hwnd', $hWnd, 'bool', $bAccept)
EndFunc   ;==>_WinAPI_DragAcceptFiles
Func _WinAPI_DragFinish($hDrop)
	DllCall('shell32.dll', 'none', 'DragFinish', 'handle', $hDrop)
EndFunc   ;==>_WinAPI_DragFinish
Func _WinAPI_DragQueryFileEx($hDrop, $iFlag = 0)
	Local $aRet = DllCall('shell32.dll', 'uint', 'DragQueryFileW', 'handle', $hDrop, 'uint', -1, 'ptr', 0, 'uint', 0)
	If Not $aRet[0] Then Return SetError(10, 0, 0)
	Local $iCount = $aRet[0]
	Local $aResult[$iCount + 1]
	For $i = 0 To $iCount - 1
		$aRet = DllCall('shell32.dll', 'uint', 'DragQueryFileW', 'handle', $hDrop, 'uint', $i, 'wstr', '', 'uint', 4096)
		If Not $aRet[0] Then Return SetError(11, 0, 0)
		If $iFlag Then
			Local $bDir = _WinAPI_PathIsDirectory($aRet[3])
			If (($iFlag = 1) And $bDir) Or (($iFlag = 2) And Not $bDir) Then
		$aResult[$i + 1] = $aRet[3]
		$aResult[0] += 1
	If Not $aResult[0] Then Return SetError(12, 0, 0)
EndFunc   ;==>_WinAPI_DragQueryFileEx
Func _WinAPI_DragQueryPoint($hDrop)
	Local $aRet = DllCall('shell32.dll', 'bool', 'DragQueryPoint', 'handle', $hDrop, 'struct*', $tPOINT)
EndFunc   ;==>_WinAPI_DragQueryPoint
Func _WinAPI_EndDeferWindowPos($hInfo)
	Local $aRet = DllCall('user32.dll', 'bool', 'EndDeferWindowPos', 'handle', $hInfo)
EndFunc   ;==>_WinAPI_EndDeferWindowPos
Func _WinAPI_EnumChildWindows($hWnd, $bVisible = True)
	If Not _WinAPI_GetWindow($hWnd, 5) Then Return SetError(2, 0, 0) ; $GW_CHILD
	DllCall('user32.dll', 'bool', 'EnumChildWindows', 'hwnd', $hWnd, 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', $bVisible)
	If @error Or Not $__g_vEnum[0][0] Then
EndFunc   ;==>_WinAPI_EnumChildWindows
Func _WinAPI_FindWindow($sClassName, $sWindowName)
	Local $aResult = DllCall("user32.dll", "hwnd", "FindWindowW", "wstr", $sClassName, "wstr", $sWindowName)
EndFunc   ;==>_WinAPI_FindWindow
Func _WinAPI_FlashWindow($hWnd, $bInvert = True)
	Local $aResult = DllCall("user32.dll", "bool", "FlashWindow", "hwnd", $hWnd, "bool", $bInvert)
EndFunc   ;==>_WinAPI_FlashWindow
Func _WinAPI_FlashWindowEx($hWnd, $iFlags = 3, $iCount = 3, $iTimeout = 0)
	Local $tFlash = DllStructCreate($tagFLASHWINFO)
	Local $iFlash = DllStructGetSize($tFlash)
	Local $iMode = 0
	If BitAND($iFlags, 1) <> 0 Then $iMode = BitOR($iMode, $FLASHW_CAPTION)
	If BitAND($iFlags, 2) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TRAY)
	If BitAND($iFlags, 4) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TIMER)
	If BitAND($iFlags, 8) <> 0 Then $iMode = BitOR($iMode, $FLASHW_TIMERNOFG)
	DllStructSetData($tFlash, "Size", $iFlash)
	DllStructSetData($tFlash, "hWnd", $hWnd)
	DllStructSetData($tFlash, "Flags", $iMode)
	DllStructSetData($tFlash, "Count", $iCount)
	DllStructSetData($tFlash, "Timeout", $iTimeout)
	Local $aResult = DllCall("user32.dll", "bool", "FlashWindowEx", "struct*", $tFlash)
EndFunc   ;==>_WinAPI_FlashWindowEx
Func _WinAPI_GetAncestor($hWnd, $iFlags = 1)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetAncestor", "hwnd", $hWnd, "uint", $iFlags)
EndFunc   ;==>_WinAPI_GetAncestor
Func _WinAPI_GetClassInfoEx($sClass, $hInstance = 0)
	Local $sTypeOfClass = 'ptr'
	If IsString($sClass) Then
		$sTypeOfClass = 'wstr'
	Local $tWNDCLASSEX = DllStructCreate($tagWNDCLASSEX)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetClassInfoExW', 'handle', $hInstance, $sTypeOfClass, $sClass, _
			'struct*', $tWNDCLASSEX)
	Return $tWNDCLASSEX
EndFunc   ;==>_WinAPI_GetClassInfoEx
Func _WinAPI_GetClassLongEx($hWnd, $iIndex)
		$aRet = DllCall('user32.dll', 'ulong_ptr', 'GetClassLongPtrW', 'hwnd', $hWnd, 'int', $iIndex)
		$aRet = DllCall('user32.dll', 'dword', 'GetClassLongW', 'hwnd', $hWnd, 'int', $iIndex)
EndFunc   ;==>_WinAPI_GetClassLongEx
Func _WinAPI_GetClientHeight($hWnd)
	Local $tRECT = _WinAPI_GetClientRect($hWnd)
	Return DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top")
EndFunc   ;==>_WinAPI_GetClientHeight
Func _WinAPI_GetClientWidth($hWnd)
	Return DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left")
EndFunc   ;==>_WinAPI_GetClientWidth
Func _WinAPI_GetDlgItem($hWnd, $iItemID)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetDlgItem", "hwnd", $hWnd, "int", $iItemID)
EndFunc   ;==>_WinAPI_GetDlgItem
Func _WinAPI_GetForegroundWindow()
	Local $aResult = DllCall("user32.dll", "hwnd", "GetForegroundWindow")
EndFunc   ;==>_WinAPI_GetForegroundWindow
Func _WinAPI_GetGUIThreadInfo($iThreadId)
    Local Const $tagGUITHREADINFO = 'dword Size;dword Flags;hwnd hWndActive;hwnd hWndFocus;hwnd hWndCapture;hwnd hWndMenuOwner;hwnd hWndMoveSize;hwnd hWndCaret;struct rcCaret;long left;long top;long right;long bottom;endstruct'
	Local $tGTI = DllStructCreate($tagGUITHREADINFO)
	DllStructSetData($tGTI, 1, DllStructGetSize($tGTI))
	Local $aRet = DllCall('user32.dll', 'bool', 'GetGUIThreadInfo', 'dword', $iThreadId, 'struct*', $tGTI)
	Local $aResult[11]
		$aResult[$i] = DllStructGetData($tGTI, $i + 2)
	For $i = 9 To 10
		$aResult[$i] -= $aResult[$i - 2]
EndFunc   ;==>_WinAPI_GetGUIThreadInfo
Func _WinAPI_GetLastActivePopup($hWnd)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetLastActivePopup', 'hwnd', $hWnd)
	If $aRet[0] = $hWnd Then Return SetError(1, 0, 0)
EndFunc   ;==>_WinAPI_GetLastActivePopup
Func _WinAPI_GetLayeredWindowAttributes($hWnd, ByRef $iTransColor, ByRef $iTransGUI, $bColorRef = False)
	$iTransColor = -1
	$iTransGUI = -1
	Local $aResult = DllCall("user32.dll", "bool", "GetLayeredWindowAttributes", "hwnd", $hWnd, "INT*", $iTransColor, _
			"byte*", $iTransGUI, "dword*", 0)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, 0)
	If Not $bColorRef Then
		$aResult[2] = Int(BinaryMid($aResult[2], 3, 1) & BinaryMid($aResult[2], 2, 1) & BinaryMid($aResult[2], 1, 1))
	$iTransColor = $aResult[2]
	$iTransGUI = $aResult[3]
EndFunc   ;==>_WinAPI_GetLayeredWindowAttributes
Func _WinAPI_GetMessageExtraInfo()
	Local $aRet = DllCall('user32.dll', 'lparam', 'GetMessageExtraInfo')
EndFunc   ;==>_WinAPI_GetMessageExtraInfo
Func _WinAPI_GetShellWindow()
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetShellWindow')
EndFunc   ;==>_WinAPI_GetShellWindow
Func _WinAPI_GetTopWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'hwnd', 'GetTopWindow', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_GetTopWindow
Func _WinAPI_GetWindowDisplayAffinity($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'GetWindowDisplayAffinity', 'hwnd', $hWnd, 'dword*', 0)
EndFunc   ;==>_WinAPI_GetWindowDisplayAffinity
Func _WinAPI_GetWindowInfo($hWnd)
	Local $tWINDOWINFO = DllStructCreate($tagWINDOWINFO)
	DllStructSetData($tWINDOWINFO, 'Size', DllStructGetSize($tWINDOWINFO))
	Local $aRet = DllCall('user32.dll', 'bool', 'GetWindowInfo', 'hwnd', $hWnd, 'struct*', $tWINDOWINFO)
	Return $tWINDOWINFO
EndFunc   ;==>_WinAPI_GetWindowInfo
Func _WinAPI_GetWindowPlacement($hWnd)
	Local $tWindowPlacement = DllStructCreate($tagWINDOWPLACEMENT)
	DllStructSetData($tWindowPlacement, "length", DllStructGetSize($tWindowPlacement))
	Local $aRet = DllCall("user32.dll", "bool", "GetWindowPlacement", "hwnd", $hWnd, "struct*", $tWindowPlacement)
	Return $tWindowPlacement
EndFunc   ;==>_WinAPI_GetWindowPlacement
Func _WinAPI_IsChild($hWnd, $hWndParent)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsChild', 'hwnd', $hWndParent, 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_IsChild
Func _WinAPI_IsHungAppWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsHungAppWindow', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_IsHungAppWindow
Func _WinAPI_IsIconic($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsIconic', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_IsIconic
Func _WinAPI_IsWindowUnicode($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsWindowUnicode', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_IsWindowUnicode
Func _WinAPI_IsZoomed($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'IsZoomed', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_IsZoomed
Func _WinAPI_KillTimer($hWnd, $iTimerID)
	Local $aRet = DllCall('user32.dll', 'bool', 'KillTimer', 'hwnd', $hWnd, 'uint_ptr', $iTimerID)
EndFunc   ;==>_WinAPI_KillTimer
Func _WinAPI_OpenIcon($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'OpenIcon', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_OpenIcon
Func _WinAPI_PostMessage($hWnd, $iMsg, $wParam, $lParam)
	Local $aResult = DllCall("user32.dll", "bool", "PostMessage", "hwnd", $hWnd, "uint", $iMsg, "wparam", $wParam, _
EndFunc   ;==>_WinAPI_PostMessage
Func _WinAPI_RegisterClass($tWNDCLASS)
	Local $aRet = DllCall('user32.dll', 'word', 'RegisterClassW', 'struct*', $tWNDCLASS)
EndFunc   ;==>_WinAPI_RegisterClass
Func _WinAPI_RegisterClassEx($tWNDCLASSEX)
	Local $aRet = DllCall('user32.dll', 'word', 'RegisterClassExW', 'struct*', $tWNDCLASSEX)
EndFunc   ;==>_WinAPI_RegisterClassEx
Func _WinAPI_RegisterShellHookWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'RegisterShellHookWindow', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_RegisterShellHookWindow
Func _WinAPI_RegisterWindowMessage($sMessage)
	Local $aResult = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $sMessage)
EndFunc   ;==>_WinAPI_RegisterWindowMessage
Func _WinAPI_SendMessageTimeout($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iTimeout = 1000, $iFlags = 0)
	Local $aRet = DllCall('user32.dll', 'lresult', 'SendMessageTimeoutW', 'hwnd', $hWnd, 'uint', $iMsg, 'wparam', $wParam, _
			'lparam', $lParam, 'uint', $iFlags, 'uint', $iTimeout, 'dword_ptr*', 0)
	If Not $aRet[0] Then Return SetError(10, _WinAPI_GetLastError(), -1)
	Return $aRet[7]
EndFunc   ;==>_WinAPI_SendMessageTimeout
Func _WinAPI_SetClassLongEx($hWnd, $iIndex, $iNewLong)
		$aRet = DllCall('user32.dll', 'ulong_ptr', 'SetClassLongPtrW', 'hwnd', $hWnd, 'int', $iIndex, 'long_ptr', $iNewLong)
		$aRet = DllCall('user32.dll', 'dword', 'SetClassLongW', 'hwnd', $hWnd, 'int', $iIndex, 'long', $iNewLong)
EndFunc   ;==>_WinAPI_SetClassLongEx
Func _WinAPI_SetForegroundWindow($hWnd)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetForegroundWindow', 'hwnd', $hWnd)
EndFunc   ;==>_WinAPI_SetForegroundWindow
Func _WinAPI_SetLayeredWindowAttributes($hWnd, $iTransColor, $iTransGUI = 255, $iFlags = 0x03, $bColorRef = False)
	If $iFlags = Default Or $iFlags = "" Or $iFlags < 0 Then $iFlags = 0x03
		$iTransColor = Int(BinaryMid($iTransColor, 3, 1) & BinaryMid($iTransColor, 2, 1) & BinaryMid($iTransColor, 1, 1))
	Local $aResult = DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hWnd, "INT", $iTransColor, _
			"byte", $iTransGUI, "dword", $iFlags)
EndFunc   ;==>_WinAPI_SetLayeredWindowAttributes
Func _WinAPI_SetMessageExtraInfo($lParam)
	Local $aRet = DllCall('user32.dll', 'lparam', 'SetMessageExtraInfo', 'lparam', $lParam)
EndFunc   ;==>_WinAPI_SetMessageExtraInfo
Func _WinAPI_SetSysColors($vElements, $vColors)
	Local $bIsEArray = IsArray($vElements), $bIsCArray = IsArray($vColors)
	Local $iElementNum
	If Not $bIsCArray And Not $bIsEArray Then
		$iElementNum = 1
	ElseIf $bIsCArray Or $bIsEArray Then
		If Not $bIsCArray Or Not $bIsEArray Then Return SetError(-1, -1, False)
		If UBound($vElements) <> UBound($vColors) Then Return SetError(-1, -1, False)
		$iElementNum = UBound($vElements)
	Local $tElements = DllStructCreate("int Element[" & $iElementNum & "]")
	Local $tColors = DllStructCreate("INT NewColor[" & $iElementNum & "]")
	If Not $bIsEArray Then
		DllStructSetData($tElements, "Element", $vElements, 1)
		For $x = 0 To $iElementNum - 1
			DllStructSetData($tElements, "Element", $vElements[$x], $x + 1)
	If Not $bIsCArray Then
		DllStructSetData($tColors, "NewColor", $vColors, 1)
			DllStructSetData($tColors, "NewColor", $vColors[$x], $x + 1)
	Local $aResult = DllCall("user32.dll", "bool", "SetSysColors", "int", $iElementNum, "struct*", $tElements, "struct*", $tColors)
EndFunc   ;==>_WinAPI_SetSysColors
Func _WinAPI_SetTimer($hWnd, $iTimerID, $iElapse, $pTimerFunc)
	Local $aRet = DllCall('user32.dll', 'uint_ptr', 'SetTimer', 'hwnd', $hWnd, 'uint_ptr', $iTimerID, 'uint', $iElapse, _
			'ptr', $pTimerFunc)
EndFunc   ;==>_WinAPI_SetTimer
Func _WinAPI_SetWindowDisplayAffinity($hWnd, $iAffinity)
	Local $aRet = DllCall('user32.dll', 'bool', 'SetWindowDisplayAffinity', 'hwnd', $hWnd, 'dword', $iAffinity)
EndFunc   ;==>_WinAPI_SetWindowDisplayAffinity
Func _WinAPI_SetWindowLong($hWnd, $iIndex, $iValue)
	_WinAPI_SetLastError(0) ; as suggested in MSDN
	Local $sFuncName = "SetWindowLongW"
	If @AutoItX64 Then $sFuncName = "SetWindowLongPtrW"
	Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex, "long_ptr", $iValue)
EndFunc   ;==>_WinAPI_SetWindowLong
Func _WinAPI_SetWindowPlacement($hWnd, $tWindowPlacement)
	Local $aResult = DllCall("user32.dll", "bool", "SetWindowPlacement", "hwnd", $hWnd, "struct*", $tWindowPlacement)
EndFunc   ;==>_WinAPI_SetWindowPlacement
Func _WinAPI_ShowOwnedPopups($hWnd, $bShow)
	Local $aRet = DllCall('user32.dll', 'bool', 'ShowOwnedPopups', 'hwnd', $hWnd, 'bool', $bShow)
EndFunc   ;==>_WinAPI_ShowOwnedPopups
Func _WinAPI_SwitchToThisWindow($hWnd, $bAltTab = False)
	DllCall('user32.dll', 'none', 'SwitchToThisWindow', 'hwnd', $hWnd, 'bool', $bAltTab)
EndFunc   ;==>_WinAPI_SwitchToThisWindow
Func _WinAPI_TileWindows($aWnds, $tRECT = 0, $hParent = 0, $iFlags = 0, $iStart = 0, $iEnd = -1)
	Local $aRet = DllCall('user32.dll', 'word', 'TileWindows', 'hwnd', $hParent, 'uint', $iFlags, 'struct*', $tRECT, _
EndFunc   ;==>_WinAPI_TileWindows
Func _WinAPI_UnregisterClass($sClass, $hInstance = 0)
	Local $aRet = DllCall('user32.dll', 'bool', 'UnregisterClassW', $sTypeOfClass, $sClass, 'handle', $hInstance)
EndFunc   ;==>_WinAPI_UnregisterClass
Func _WinAPI_UpdateLayeredWindow($hWnd, $hDestDC, $tPTDest, $tSize, $hSrcDC, $tPTSrce, $iRGB, $tBlend, $iFlags)
	Local $aResult = DllCall("user32.dll", "bool", "UpdateLayeredWindow", "hwnd", $hWnd, "handle", $hDestDC, "struct*", $tPTDest, _
			"struct*", $tSize, "handle", $hSrcDC, "struct*", $tPTSrce, "dword", $iRGB, "struct*", $tBlend, "dword", $iFlags)
EndFunc   ;==>_WinAPI_UpdateLayeredWindow
Func _WinAPI_UpdateLayeredWindowEx($hWnd, $iX, $iY, $hBitmap, $iOpacity = 255, $bDelete = False)
	Local $aRet = DllCall('user32.dll', 'handle', 'GetDC', 'hwnd', $hWnd)
	Local $hDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'CreateCompatibleDC', 'handle', $hDC)
	Local $hDestDC = $aRet[0]
	$aRet = DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hBitmap)
	Local $hDestSv = $aRet[0]
	Local $tPOINT
	If ($iX = -1) And ($iY = -1) Then
		$tPOINT = DllStructCreate('int;int')
		$tPOINT = DllStructCreate('int;int;int;int')
		DllStructSetData($tPOINT, 3, $iX)
		DllStructSetData($tPOINT, 4, $iY)
	DllStructSetData($tPOINT, 1, 0)
	DllStructSetData($tPOINT, 2, 0)
	Local $tBLENDFUNCTION = DllStructCreate($tagBLENDFUNCTION)
	DllStructSetData($tBLENDFUNCTION, 1, 0)
	DllStructSetData($tBLENDFUNCTION, 2, 0)
	DllStructSetData($tBLENDFUNCTION, 3, $iOpacity)
	DllStructSetData($tBLENDFUNCTION, 4, 1)
	Local Const $tagBITMAP = 'struct;long bmType;long bmWidth;long bmHeight;long bmWidthBytes;ushort bmPlanes;ushort bmBitsPixel;ptr bmBits;endstruct'
	Local $tObj = DllStructCreate($tagBITMAP)
	DllCall('gdi32.dll', 'int', 'GetObject', 'handle', $hBitmap, 'int', DllStructGetSize($tObj), 'struct*', $tObj)
	Local $tSize = DllStructCreate($tagSIZE, DllStructGetPtr($tObj, "bmWidth"))
	$aRet = DllCall('user32.dll', 'bool', 'UpdateLayeredWindow', 'hwnd', $hWnd, 'handle', $hDC, 'ptr', DllStructGetPtr($tPOINT, 3), _
			'struct*', $tSIZE, 'handle', $hDestDC, 'struct*', $tPOINT, 'dword', 0, 'struct*', $tBLENDFUNCTION, 'dword', 0x02)
	DllCall('user32.dll', 'bool', 'ReleaseDC', 'hwnd', $hWnd, 'handle', $hDC)
	DllCall('gdi32.dll', 'handle', 'SelectObject', 'handle', $hDestDC, 'handle', $hDestSv)
	DllCall('gdi32.dll', 'bool', 'DeleteDC', 'handle', $hDestDC)
	If $bDelete Then
		DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $hBitmap)
EndFunc   ;==>_WinAPI_UpdateLayeredWindowEx
Func _WinAPI_UpdateLayeredWindowIndirect($hWnd, $tULWINFO)
	Local $aRet = DllCall('user32.dll', 'bool', 'UpdateLayeredWindowIndirect', 'hwnd', $hWnd, 'struct*', $tULWINFO)
EndFunc   ;==>_WinAPI_UpdateLayeredWindowIndirect
Func _WinAPI_WindowFromPoint(ByRef $tPoint)
	Local $aResult = DllCall("user32.dll", "hwnd", "WindowFromPoint", "struct", $tPoint)
EndFunc   ;==>_WinAPI_WindowFromPoint
Func __EnumDefaultProc($pData, $lParam)
	#forceref $lParam
	Local $iLength = _WinAPI_StrLen($pData)
		$__g_vEnum[$__g_vEnum[0]] = DllStructGetData(DllStructCreate('wchar[' & ($iLength + 1) & ']', $pData), 1)
		$__g_vEnum[$__g_vEnum[0]] = ''
EndFunc   ;==>__EnumDefaultProc
Global Const $GUI_EVENT_SINGLE = 0 ; (default) Returns a single event.
Global Const $GUI_EVENT_ARRAY = 1 ; returns an array containing the event and extended information.
Global Const $GUI_EVENT_NONE = 0
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_EVENT_MINIMIZE = -4
Global Const $GUI_EVENT_RESTORE = -5
Global Const $GUI_EVENT_MAXIMIZE = -6
Global Const $GUI_EVENT_PRIMARYDOWN = -7
Global Const $GUI_EVENT_PRIMARYUP = -8
Global Const $GUI_EVENT_SECONDARYDOWN = -9
Global Const $GUI_EVENT_SECONDARYUP = -10
Global Const $GUI_EVENT_MOUSEMOVE = -11
Global Const $GUI_EVENT_RESIZED = -12
Global Const $GUI_EVENT_DROPPED = -13
Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $GUI_AVISTOP = 0
Global Const $GUI_AVISTART = 1
Global Const $GUI_AVICLOSE = 2
Global Const $GUI_CHECKED = 1
Global Const $GUI_INDETERMINATE = 2
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_DROPACCEPTED = 8
Global Const $GUI_NODROPACCEPTED = 4096
Global Const $GUI_ACCEPTFILES = $GUI_DROPACCEPTED ; to be suppressed
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_FOCUS = 256
Global Const $GUI_NOFOCUS = 8192
Global Const $GUI_DEFBUTTON = 512
Global Const $GUI_EXPAND = 1024
Global Const $GUI_ONTOP = 2048
Global Const $GUI_FONTNORMAL = 0
Global Const $GUI_FONTITALIC = 2
Global Const $GUI_FONTUNDER = 4
Global Const $GUI_FONTSTRIKE = 8
Global Const $GUI_DOCKAUTO = 0x0001
Global Const $GUI_DOCKLEFT = 0x0002
Global Const $GUI_DOCKRIGHT = 0x0004
Global Const $GUI_DOCKHCENTER = 0x0008
Global Const $GUI_DOCKTOP = 0x0020
Global Const $GUI_DOCKBOTTOM = 0x0040
Global Const $GUI_DOCKVCENTER = 0x0080
Global Const $GUI_DOCKWIDTH = 0x0100
Global Const $GUI_DOCKHEIGHT = 0x0200
Global Const $GUI_DOCKSIZE = 0x0300 ; width+height
Global Const $GUI_DOCKMENUBAR = 0x0220 ; top+height
Global Const $GUI_DOCKSTATEBAR = 0x0240 ; bottom+height
Global Const $GUI_DOCKALL = 0x0322 ; left+top+width+height
Global Const $GUI_DOCKBORDERS = 0x0066 ; left+top+right+bottom
Global Const $GUI_GR_CLOSE = 1
Global Const $GUI_GR_LINE = 2
Global Const $GUI_GR_BEZIER = 4
Global Const $GUI_GR_MOVE = 6
Global Const $GUI_GR_COLOR = 8
Global Const $GUI_GR_RECT = 10
Global Const $GUI_GR_ELLIPSE = 12
Global Const $GUI_GR_PIE = 14
Global Const $GUI_GR_DOT = 16
Global Const $GUI_GR_PIXEL = 18
Global Const $GUI_GR_HINT = 20
Global Const $GUI_GR_REFRESH = 22
Global Const $GUI_GR_PENSIZE = 24
Global Const $GUI_GR_NOBKCOLOR = -2
Global Const $GUI_BKCOLOR_DEFAULT = -1
Global Const $GUI_BKCOLOR_TRANSPARENT = -2
Global Const $GUI_BKCOLOR_LV_ALTERNATE = 0xFE000000
Global Const $GUI_READ_DEFAULT = 0 ; (Default) Returns a value with state or data of a control.
Global Const $GUI_READ_EXTENDED = 1 ; Returns extended information of a control (see Remarks).
Global Const $GUI_CURSOR_NOOVERRIDE = 0 ; (default) Don't override a control's default mouse cursor.
Global Const $GUI_CURSOR_OVERRIDE = 1 ; override control's default mouse cursor.
Global Const $GUI_WS_EX_PARENTDRAG = 0x00100000
#include "AutoItConstants.au3"
#include "FileConstants.au3"
#Region Header
#EndRegion Header
#Region Global Variables
Global $__g_iIELoadWaitTimeout = 300000 ; 5 Minutes
Global $__g_bIEAU3Debug = False
Global $__g_bIEErrorNotify = True
Global $__g_oIEErrorHandler, $__g_sIEUserErrorHandler
#EndRegion Global Variables
#Region Global Constants
Global Const $__gaIEAU3VersionInfo[6] = ["T", 3, 0, 2, "20140819", "T3.0-2"]
Global Const $LSFW_LOCK = 1, $LSFW_UNLOCK = 2
Global Enum _; Error Status Types
		$_IESTATUS_Success = 0, _
		$_IESTATUS_GeneralError, _
		$_IESTATUS_ComError, _
		$_IESTATUS_InvalidDataType, _
		$_IESTATUS_InvalidObjectType, _
		$_IESTATUS_InvalidValue, _
		$_IESTATUS_LoadWaitTimeout, _
		$_IESTATUS_NoMatch, _
		$_IESTATUS_AccessIsDenied, _
		$_IESTATUS_ClientDisconnected
#EndRegion Global Constants
#Region Core functions
Func _IECreate($sUrl = "about:blank", $iTryAttach = 0, $iVisible = 1, $iWait = 1, $iTakeFocus = 1)
	If Not $iVisible Then $iTakeFocus = 0 ; Force takeFocus to 0 for hidden window
	If $iTryAttach Then
		Local $oResult = _IEAttach($sUrl, "url")
		If IsObj($oResult) Then
			If $iTakeFocus Then WinActivate(HWnd($oResult.hWnd))
			Return SetError($_IESTATUS_Success, 1, $oResult)
	Local $iMustUnlock = 0
	If Not $iVisible And __IELockSetForegroundWindow($LSFW_LOCK) Then $iMustUnlock = 1
	Local $oObject = ObjCreate("InternetExplorer.Application")
	If Not IsObj($oObject) Then
		__IEConsoleWriteError("Error", "_IECreate", "", "Browser Object Creation Failed")
		If $iMustUnlock Then __IELockSetForegroundWindow($LSFW_UNLOCK)
		Return SetError($_IESTATUS_GeneralError, 0, 0)
	$oObject.visible = $iVisible
	If $iMustUnlock And Not __IELockSetForegroundWindow($LSFW_UNLOCK) Then __IEConsoleWriteError("Warning", "_IECreate", "", "Foreground Window Unlock Failed!")
	_IENavigate($oObject, $sUrl, $iWait)
	If Not $iError And StringLeft($sUrl, 6) = "about:" Then
		Local $oDocument = $oObject.document
		_IEAction($oDocument, "focus")
	Return SetError($iError, 0, $oObject)
EndFunc   ;==>_IECreate
Func _IECreateEmbedded()
	Local $oObject = ObjCreate("Shell.Explorer.2")
		__IEConsoleWriteError("Error", "_IECreateEmbedded", "", "WebBrowser Object Creation Failed")
	Return SetError($_IESTATUS_Success, 0, $oObject)
EndFunc   ;==>_IECreateEmbedded
Func _IENavigate(ByRef $oObject, $sUrl, $iWait = 1)
		__IEConsoleWriteError("Error", "_IENavigate", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_InvalidDataType, 1, 0)
	If Not __IEIsObjType($oObject, "documentContainer") Then
		__IEConsoleWriteError("Error", "_IENavigate", "$_IESTATUS_InvalidObjectType")
		Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
	$oObject.navigate($sUrl)
	If @error Then ; Trap COM error, report and return
		__IEConsoleWriteError("Error", "_IENavigate", "$_IESTATUS_COMError", @error)
		Return SetError($_IESTATUS_ComError, @error, 0)
	If $iWait Then
		_IELoadWait($oObject)
		Return SetError(@error, 0, -1)
	Return SetError($_IESTATUS_Success, 0, -1)
EndFunc   ;==>_IENavigate
Func _IEAttach($sString, $sMode = "title", $iInstance = 1)
	$sMode = StringLower($sMode)
	$iInstance = Int($iInstance)
	If $iInstance < 1 Then
		__IEConsoleWriteError("Error", "_IEAttach", "$_IESTATUS_InvalidValue", "$iInstance < 1")
		Return SetError($_IESTATUS_InvalidValue, 3, 0)
	If $sMode = "embedded" Or $sMode = "dialogbox" Then
		Local $iWinTitleMatchMode = Opt("WinTitleMatchMode", $OPT_MATCHANY)
		If $sMode = "dialogbox" And $iInstance > 1 Then
			If IsHWnd($sString) Then
				$iInstance = 1
				__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_GeneralError", "$iInstance > 1 invalid with HWnd and DialogBox.  Setting to 1.")
				Local $aWinlist = WinList($sString, "")
				If $iInstance <= $aWinlist[0][0] Then
					$sString = $aWinlist[$iInstance][1]
					$iInstance = 1
					__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_NoMatch")
					Opt("WinTitleMatchMode", $iWinTitleMatchMode)
					Return SetError($_IESTATUS_NoMatch, 1, 0)
		Local $hControl = ControlGetHandle($sString, "", "[CLASS:Internet Explorer_Server; INSTANCE:" & $iInstance & "]")
		Local $oResult = __IEControlGetObjFromHWND($hControl)
		Opt("WinTitleMatchMode", $iWinTitleMatchMode)
			Return SetError($_IESTATUS_Success, 0, $oResult)
			__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 1, 0)
	Local $oShell = ObjCreate("Shell.Application")
	Local $oShellWindows = $oShell.Windows(); collection of all ShellWindows (IE and File Explorer)
	Local $iTmp = 1
	Local $iNotifyStatus, $bIsBrowser, $sTmp
	Local $bStatus
	For $oWindow In $oShellWindows
		$bIsBrowser = True
		$bStatus = __IEInternalErrorHandlerRegister()
		If Not $bStatus Then __IEConsoleWriteError("Warning", "_IEAttach", _
				"Cannot register internal error handler, cannot trap COM errors", _
				"Use _IEErrorHandlerRegister() to register a user error handler")
		$iNotifyStatus = _IEErrorNotify() ; save current error notify status
		_IEErrorNotify(False)
		If $bIsBrowser Then
			$sTmp = $oWindow.type ; Is .type a valid property?
			If @error Then $bIsBrowser = False
			$sTmp = $oWindow.document.title ; Does object have a .document and .title property?
		_IEErrorNotify($iNotifyStatus) ; restore notification status
		__IEInternalErrorHandlerDeRegister()
			Switch $sMode
				Case "title"
					If StringInStr($oWindow.document.title, $sString) > 0 Then
						If $iInstance = $iTmp Then
							Return SetError($_IESTATUS_Success, 0, $oWindow)
						Else
							$iTmp += 1
				Case "instance"
					If $iInstance = $iTmp Then
						Return SetError($_IESTATUS_Success, 0, $oWindow)
					Else
						$iTmp += 1
				Case "windowtitle"
					Local $bFound = False
					$sTmp = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\", "Window Title")
						If StringInStr($oWindow.document.title & " - " & $sTmp, $sString) Then $bFound = True
						If StringInStr($oWindow.document.title & " - Microsoft Internet Explorer", $sString) Then $bFound = True
						If StringInStr($oWindow.document.title & " - Windows Internet Explorer", $sString) Then $bFound = True
					If $bFound Then
				Case "url"
					If StringInStr($oWindow.LocationURL, $sString) > 0 Then
				Case "text"
					If StringInStr($oWindow.document.body.innerText, $sString) > 0 Then
				Case "html"
					If StringInStr($oWindow.document.body.innerHTML, $sString) > 0 Then
				Case "hwnd"
					If $iInstance > 1 Then
						$iInstance = 1
						__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_GeneralError", "$iInstance > 1 invalid with HWnd.  Setting to 1.")
					If _IEPropertyGet($oWindow, "hwnd") = $sString Then
					__IEConsoleWriteError("Error", "_IEAttach", "$_IESTATUS_InvalidValue", "Invalid Mode Specified")
					Return SetError($_IESTATUS_InvalidValue, 2, 0)
	__IEConsoleWriteError("Warning", "_IEAttach", "$_IESTATUS_NoMatch")
	Return SetError($_IESTATUS_NoMatch, 1, 0)
EndFunc   ;==>_IEAttach
Func _IELoadWait(ByRef $oObject, $iDelay = 0, $iTimeout = -1)
		__IEConsoleWriteError("Error", "_IELoadWait", "$_IESTATUS_InvalidDataType")
	If Not __IEIsObjType($oObject, "browserdom") Then
		__IEConsoleWriteError("Error", "_IELoadWait", "$_IESTATUS_InvalidObjectType", ObjName($oObject))
	Local $oTemp, $bAbort = False, $iErrorStatusCode = $_IESTATUS_Success
	Local $bStatus = __IEInternalErrorHandlerRegister()
	If Not $bStatus Then __IEConsoleWriteError("Warning", "_IELoadWait", _
			"Cannot register internal error handler, cannot trap COM errors", _
			"Use _IEErrorHandlerRegister() to register a user error handler")
	Local $iNotifyStatus = _IEErrorNotify() ; save current error notify status
	_IEErrorNotify(False)
	Local $iError
	Local $hIELoadWaitTimer = TimerInit()
	If $iTimeout = -1 Then $iTimeout = $__g_iIELoadWaitTimeout
	Select
		Case __IEIsObjType($oObject, "browser", False); Internet Explorer
			While Not (String($oObject.readyState) = "complete" Or $oObject.readyState = 4 Or $bAbort)
					$iError = @error
					If __IEComErrorUnrecoverable($iError) Then
						$iErrorStatusCode = __IEComErrorUnrecoverable($iError)
						$bAbort = True
				ElseIf (TimerDiff($hIELoadWaitTimer) > $iTimeout) Then
					$iErrorStatusCode = $_IESTATUS_LoadWaitTimeout
					$bAbort = True
				Sleep(100)
			WEnd
			While Not (String($oObject.document.readyState) = "complete" Or $oObject.document.readyState = 4 Or $bAbort)
		Case __IEIsObjType($oObject, "window", False) ; Window, Frame, iFrame
			While Not (String($oObject.top.document.readyState) = "complete" Or $oObject.top.document.readyState = 4 Or $bAbort)
		Case __IEIsObjType($oObject, "document", False) ; Document
			$oTemp = $oObject.parentWindow
			While Not (String($oTemp.document.readyState) = "complete" Or $oTemp.document.readyState = 4 Or $bAbort)
			While Not (String($oTemp.top.document.readyState) = "complete" Or $oTemp.top.document.readyState = 4 Or $bAbort)
		Case Else ; this should work with any other DOM object
			$oTemp = $oObject.document.parentWindow
			While Not (String($oTemp.top.document.readyState) = "complete" Or $oObject.top.document.readyState = 4 Or $bAbort)
	EndSelect
	_IEErrorNotify($iNotifyStatus) ; restore notification status
	__IEInternalErrorHandlerDeRegister()
	Switch $iErrorStatusCode
		Case $_IESTATUS_Success
			Return SetError($_IESTATUS_Success, 0, 1)
		Case $_IESTATUS_LoadWaitTimeout
			__IEConsoleWriteError("Warning", "_IELoadWait", "$_IESTATUS_LoadWaitTimeout")
			Return SetError($_IESTATUS_LoadWaitTimeout, 3, 0)
		Case $_IESTATUS_AccessIsDenied
			__IEConsoleWriteError("Warning", "_IELoadWait", "$_IESTATUS_AccessIsDenied", _
					"Cannot verify readyState.  Likely casue: cross-domain scripting security restriction. (" & $iError & ")")
			Return SetError($_IESTATUS_AccessIsDenied, 0, 0)
		Case $_IESTATUS_ClientDisconnected
			__IEConsoleWriteError("Error", "_IELoadWait", "$_IESTATUS_ClientDisconnected", _
					$iError & ", Browser has been deleted prior to operation.")
			Return SetError($_IESTATUS_ClientDisconnected, 0, 0)
			__IEConsoleWriteError("Error", "_IELoadWait", "$_IESTATUS_GeneralError", "Invalid Error Status - Notify IE.au3 developer")
			Return SetError($_IESTATUS_GeneralError, 0, 0)
EndFunc   ;==>_IELoadWait
Func _IELoadWaitTimeout($iTimeout = -1)
	If $iTimeout = -1 Then
		Return SetError($_IESTATUS_Success, 0, $__g_iIELoadWaitTimeout)
		$__g_iIELoadWaitTimeout = $iTimeout
		Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IELoadWaitTimeout
#EndRegion Core functions
#Region Frame Functions
Func _IEIsFrameSet(ByRef $oObject)
		__IEConsoleWriteError("Error", "_IEIsFrameSet", "$_IESTATUS_InvalidDataType")
	If String($oObject.document.body.tagName) = "frameset" Then
		If @error Then ; Trap COM error, report and return
			__IEConsoleWriteError("Error", "_IEIsFrameSet", "$_IESTATUS_COMError", @error)
			Return SetError($_IESTATUS_ComError, @error, 0)
		Return SetError($_IESTATUS_Success, 0, 0)
EndFunc   ;==>_IEIsFrameSet
Func _IEFrameGetCollection(ByRef $oObject, $iIndex = -1)
		__IEConsoleWriteError("Error", "_IEFrameGetCollection", "$_IESTATUS_InvalidDataType")
	$iIndex = Number($iIndex)
		Case $iIndex = -1
			Return SetError($_IESTATUS_Success, $oObject.document.parentwindow.frames.length, _
					$oObject.document.parentwindow.frames)
		Case $iIndex > -1 And $iIndex < $oObject.document.parentwindow.frames.length
					$oObject.document.parentwindow.frames.item($iIndex))
		Case $iIndex < -1
			__IEConsoleWriteError("Error", "_IEFrameGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			Return SetError($_IESTATUS_InvalidValue, 2, 0)
			__IEConsoleWriteError("Warning", "_IEFrameGetCollection", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 2, 0)
EndFunc   ;==>_IEFrameGetCollection
Func _IEFrameGetObjByName(ByRef $oObject, $sName)
		__IEConsoleWriteError("Error", "_IEFrameGetObjByName", "$_IESTATUS_InvalidDataType")
	Local $oTemp, $oFrames
		__IEConsoleWriteError("Error", "_IEFrameGetObjByName", "$_IESTATUS_InvalidObjectType")
	If __IEIsObjType($oObject, "document") Then
		$oTemp = $oObject.parentWindow
		$oTemp = $oObject.document.parentWindow
	If _IEIsFrameSet($oTemp) Then
		$oFrames = _IETagNameGetCollection($oTemp, "frame")
		$oFrames = _IETagNameGetCollection($oTemp, "iframe")
	If $oFrames.length Then
		For $oFrame In $oFrames
			If String($oFrame.name) = $sName Then Return SetError($_IESTATUS_Success, 0, $oTemp.frames($sName))
		__IEConsoleWriteError("Warning", "_IEFrameGetObjByName", "$_IESTATUS_NoMatch", "No frames matching name")
		Return SetError($_IESTATUS_NoMatch, 2, 0)
		__IEConsoleWriteError("Warning", "_IEFrameGetObjByName", "$_IESTATUS_NoMatch", "No Frames found")
EndFunc   ;==>_IEFrameGetObjByName
#EndRegion Frame Functions
#Region Link functions
Func _IELinkClickByText(ByRef $oObject, $sLinkText, $iIndex = 0, $iWait = 1)
		__IEConsoleWriteError("Error", "_IELinkClickByText", "$_IESTATUS_InvalidDataType")
	Local $iFound = 0, $sModeLinktext, $oLinks = $oObject.document.links
	For $oLink In $oLinks
		$sModeLinktext = String($oLink.outerText)
		If $sModeLinktext = $sLinkText Then
			If ($iFound = $iIndex) Then
				$oLink.click()
				If @error Then ; Trap COM error, report and return
					__IEConsoleWriteError("Error", "_IELinkClickByText", "$_IESTATUS_COMError", @error)
					Return SetError($_IESTATUS_ComError, @error, 0)
				If $iWait Then
					_IELoadWait($oObject)
					Return SetError(@error, 0, -1)
				Return SetError($_IESTATUS_Success, 0, -1)
			$iFound = $iFound + 1
	__IEConsoleWriteError("Warning", "_IELinkClickByText", "$_IESTATUS_NoMatch")
	Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 3 or both
EndFunc   ;==>_IELinkClickByText
Func _IELinkClickByIndex(ByRef $oObject, $iIndex, $iWait = 1)
		__IEConsoleWriteError("Error", "_IELinkClickByIndex", "$_IESTATUS_InvalidDataType")
	Local $oLinks = $oObject.document.links, $oLink
	If ($iIndex >= 0) And ($iIndex <= $oLinks.length - 1) Then
		$oLink = $oLinks($iIndex)
		$oLink.click()
			__IEConsoleWriteError("Error", "_IELinkClickByIndex", "$_IESTATUS_COMError", @error)
		If $iWait Then
			_IELoadWait($oObject)
			Return SetError(@error, 0, -1)
		Return SetError($_IESTATUS_Success, 0, -1)
		__IEConsoleWriteError("Warning", "_IELinkClickByIndex", "$_IESTATUS_NoMatch")
EndFunc   ;==>_IELinkClickByIndex
Func _IELinkGetCollection(ByRef $oObject, $iIndex = -1)
		__IEConsoleWriteError("Error", "_IELinkGetCollection", "$_IESTATUS_InvalidDataType")
			Return SetError($_IESTATUS_Success, $oObject.document.links.length, _
					$oObject.document.links)
		Case $iIndex > -1 And $iIndex < $oObject.document.links.length
					$oObject.document.links.item($iIndex))
			__IEConsoleWriteError("Error", "_IELinkGetCollection", "$_IESTATUS_InvalidValue")
			__IEConsoleWriteError("Warning", "_IELinkGetCollection", "$_IESTATUS_NoMatch")
EndFunc   ;==>_IELinkGetCollection
#EndRegion Link functions
#Region Image functions
Func _IEImgClick(ByRef $oObject, $sLinkText, $sMode = "src", $iIndex = 0, $iWait = 1)
		__IEConsoleWriteError("Error", "_IEImgClick", "$_IESTATUS_InvalidDataType")
	Local $sModeLinktext, $iFound = 0, $oImgs = $oObject.document.images
	For $oImg In $oImgs
		Select
			Case $sMode = "alt"
				$sModeLinktext = $oImg.alt
			Case $sMode = "name"
				$sModeLinktext = $oImg.name
				If Not IsString($sModeLinktext) Then $sModeLinktext = $oImg.id ; html5 support
			Case $sMode = "id"
				$sModeLinktext = $oImg.id
			Case $sMode = "src"
				$sModeLinktext = $oImg.src
				__IEConsoleWriteError("Error", "_IEImgClick", "$_IESTATUS_InvalidValue", "Invalid mode: " & $sMode)
				Return SetError($_IESTATUS_InvalidValue, 3, 0)
		EndSelect
		If StringInStr($sModeLinktext, $sLinkText) Then
				$oImg.click()
					__IEConsoleWriteError("Error", "_IEImgClick", "$_IESTATUS_COMError", @error)
	__IEConsoleWriteError("Warning", "_IEImgClick", "$_IESTATUS_NoMatch")
	Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 4 or both
EndFunc   ;==>_IEImgClick
Func _IEImgGetCollection(ByRef $oObject, $iIndex = -1)
		__IEConsoleWriteError("Error", "_IEImgGetCollection", "$_IESTATUS_InvalidDataType")
	Local $oTemp = _IEDocGetObj($oObject)
			Return SetError($_IESTATUS_Success, $oTemp.images.length, $oTemp.images)
		Case $iIndex > -1 And $iIndex < $oTemp.images.length
			Return SetError($_IESTATUS_Success, $oTemp.images.length, $oTemp.images.item($iIndex))
			__IEConsoleWriteError("Error", "_IEImgGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			__IEConsoleWriteError("Warning", "_IEImgGetCollection", "$_IESTATUS_NoMatch")
EndFunc   ;==>_IEImgGetCollection
#EndRegion Image functions
#Region Form functions
Func _IEFormGetCollection(ByRef $oObject, $iIndex = -1)
		__IEConsoleWriteError("Error", "_IEFormGetCollection", "$_IESTATUS_InvalidDataType")
			Return SetError($_IESTATUS_Success, $oTemp.forms.length, $oTemp.forms)
		Case $iIndex > -1 And $iIndex < $oTemp.forms.length
			Return SetError($_IESTATUS_Success, $oTemp.forms.length, $oTemp.forms.item($iIndex))
			__IEConsoleWriteError("Error", "_IEFormGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			__IEConsoleWriteError("Warning", "_IEFormGetCollection", "$_IESTATUS_NoMatch")
EndFunc   ;==>_IEFormGetCollection
Func _IEFormGetObjByName(ByRef $oObject, $sName, $iIndex = 0)
		__IEConsoleWriteError("Error", "_IEFormGetObjByName", "$_IESTATUS_InvalidDataType")
	Local $iLength = 0
	Local $oCol = $oObject.document.forms.item($sName)
	If IsObj($oCol) Then
		If __IEIsObjType($oCol, "elementcollection") Then
			$iLength = $oCol.length
			$iLength = 1
	If $iIndex = -1 Then
		Return SetError($_IESTATUS_Success, $iLength, $oObject.document.forms.item($sName))
		If IsObj($oObject.document.forms.item($sName, $iIndex)) Then
			Return SetError($_IESTATUS_Success, $iLength, $oObject.document.forms.item($sName, $iIndex))
			__IEConsoleWriteError("Warning", "_IEFormGetObjByName", "$_IESTATUS_NoMatch")
			Return SetError($_IESTATUS_NoMatch, 0, 0) ; Could be caused by parameter 2, 3 or both
EndFunc   ;==>_IEFormGetObjByName
Func _IEFormElementGetCollection(ByRef $oObject, $iIndex = -1)
		__IEConsoleWriteError("Error", "_IEFormElementGetCollection", "$_IESTATUS_InvalidDataType")
	If Not __IEIsObjType($oObject, "form") Then
		__IEConsoleWriteError("Error", "_IEFormElementGetCollection", "$_IESTATUS_InvalidObjectType")
			Return SetError($_IESTATUS_Success, $oObject.elements.length, $oObject.elements)
		Case $iIndex > -1 And $iIndex < $oObject.elements.length
			Return SetError($_IESTATUS_Success, $oObject.elements.length, $oObject.elements.item($iIndex))
			__IEConsoleWriteError("Error", "_IEFormElementGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
EndFunc   ;==>_IEFormElementGetCollection
Func _IEFormElementGetObjByName(ByRef $oObject, $sName, $iIndex = 0)
		__IEConsoleWriteError("Error", "_IEFormElementGetObjByName", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEFormElementGetObjByName", "$_IESTATUS_InvalidObjectType")
	Local $oCol = $oObject.elements.item($sName)
		Return SetError($_IESTATUS_Success, $iLength, $oObject.elements.item($sName))
		If IsObj($oObject.elements.item($sName, $iIndex)) Then
			Return SetError($_IESTATUS_Success, $iLength, $oObject.elements.item($sName, $iIndex))
			__IEConsoleWriteError("Warning", "_IEFormElementGetObjByName", "$_IESTATUS_NoMatch")
EndFunc   ;==>_IEFormElementGetObjByName
Func _IEFormElementGetValue(ByRef $oObject)
		__IEConsoleWriteError("Error", "_IEFormElementGetValue", "$_IESTATUS_InvalidDataType")
	If Not __IEIsObjType($oObject, "forminputelement") Then
		__IEConsoleWriteError("Error", "_IEFormElementGetValue", "$_IESTATUS_InvalidObjectType")
	Local $sReturn = String($oObject.value)
		__IEConsoleWriteError("Error", "_IEFormElementGetValue", "$_IESTATUS_COMError", @error)
	SetError($_IESTATUS_Success)
	Return $sReturn
EndFunc   ;==>_IEFormElementGetValue
Func _IEFormElementSetValue(ByRef $oObject, $sNewValue, $iFireEvent = 1)
		__IEConsoleWriteError("Error", "_IEFormElementSetValue", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEFormElementSetValue", "$_IESTATUS_InvalidObjectType")
	If String($oObject.type) = "file" Then
		__IEConsoleWriteError("Error", "_IEFormElementSetValue", "$_IESTATUS_InvalidObjectType", "Browser security prevents SetValue of TYPE=FILE")
	$oObject.value = $sNewValue
		__IEConsoleWriteError("Error", "_IEFormElementSetValue", "$_IESTATUS_COMError", @error)
	If $iFireEvent Then
		$oObject.fireEvent("OnChange")
		$oObject.fireEvent("OnClick")
	Return SetError($_IESTATUS_Success, 0, 1)
EndFunc   ;==>_IEFormElementSetValue
Func _IEFormElementOptionSelect(ByRef $oObject, $sString, $iSelect = 1, $sMode = "byValue", $iFireEvent = 1)
    If Not IsObj($oObject) Then
        __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidDataType")
        Return SetError($_IESTATUS_InvalidDataType, 1, 0)
    If Not __IEIsObjType($oObject, "formselectelement") Then
        __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidObjectType")
        Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
    Local $oItem, $oItems = $oObject.options, $iNumItems = $oObject.options.length, $bIsMultiple = $oObject.multiple
    Switch $sMode
        Case "byValue"
            For $oItem In $oItems
                If $oItem.value = $sString Then
                    Switch $iSelect
                        Case -1
                            Return SetError($_IESTATUS_Success, 0, $oItem.selected)
                        Case 0
                            If Not $bIsMultiple Then
                                __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", _
                                        "$iSelect=0 only valid for type=select multiple")
                                Return SetError($_IESTATUS_InvalidValue, 3)
                            EndIf
                            If $oItem.selected Then
                                $oItem.selected = False
                                If $iFireEvent Then
                                    $oObject.fireEvent("onChange")
                                    $oObject.fireEvent("OnClick")
                                EndIf
                            Return SetError($_IESTATUS_Success, 0, 1)
                        Case 1
                            If Not $oItem.selected Then
                                $oItem.selected = True
                        Case Else
                            __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid $iSelect value")
                            Return SetError($_IESTATUS_InvalidValue, 3, 0)
                    EndSwitch
            Next
            __IEConsoleWriteError("Warning", "_IEFormElementOptionSelect", "$_IESTATUS_NoMatch", "Value not matched")
            Return SetError($_IESTATUS_NoMatch, 2, 0)
        Case "byText"
                If String($oItem.text) = $sString Then
            __IEConsoleWriteError("Warning", "_IEFormElementOptionSelect", "$_IESTATUS_NoMatch", "Text not matched")
        Case "byIndex"
            Local $iIndex = Number($sString)
            If $iIndex < 0 Or $iIndex >= $iNumItems Then
                __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid index value, " & $iIndex)
                Return SetError($_IESTATUS_InvalidValue, 2, 0)
            $oItem = $oItems.item($iIndex)
            Switch $iSelect
                Case -1
                    Return SetError($_IESTATUS_Success, 0, $oItems.item($iIndex).selected)
                Case 0
                    If Not $bIsMultiple Then
                        __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", _
                                "$iSelect=0 only valid for type=select multiple")
                        Return SetError($_IESTATUS_InvalidValue, 3)
                    EndIf
                    If $oItem.selected Then
                        $oItems.item($iIndex).selected = False
                        If $iFireEvent Then
                            $oObject.fireEvent("onChange")
                            $oObject.fireEvent("OnClick")
                        EndIf
                    Return SetError($_IESTATUS_Success, 0, 1)
                Case 1
                    If Not $oItem.selected Then
                        $oItems.item($iIndex).selected = True
                Case Else
                    __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid $iSelect value")
                    Return SetError($_IESTATUS_InvalidValue, 3, 0)
            EndSwitch
        Case Else
            __IEConsoleWriteError("Error", "_IEFormElementOptionSelect", "$_IESTATUS_InvalidValue", "Invalid Mode")
            Return SetError($_IESTATUS_InvalidValue, 4, 0)
    EndSwitch
EndFunc   ;==>_IEFormElementOptionSelect
Func _IEFormElementCheckBoxSelect(ByRef $oObject, $sString, $sName = "", $iSelect = 1, $sMode = "byValue", $iFireEvent = 1)
		__IEConsoleWriteError("Error", "_IEFormElementCheckBoxSelect", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEFormElementCheckBoxSelect", "$_IESTATUS_InvalidObjectType")
	$sString = String($sString)
	$sName = String($sName)
	Local $oItems
		$oItems = _IETagNameGetCollection($oObject, "input")
		$oItems = Execute("$oObject.elements('" & $sName & "')")
	If Not IsObj($oItems) Then
		__IEConsoleWriteError("Warning", "_IEFormElementCheckBoxSelect", "$_IESTATUS_NoMatch")
		Return SetError($_IESTATUS_NoMatch, 3, 0)
	Local $oItem, $bFound = False
	Switch $sMode
		Case "byValue"
			If __IEIsObjType($oItems, "forminputelement") Then
				$oItem = $oItems
				If String($oItem.type) = "checkbox" And String($oItem.value) = $sString Then $bFound = True
				For $oItem In $oItems
					If String($oItem.type) = "checkbox" And String($oItem.value) = $sString Then
						$bFound = True
		Case "byIndex"
				If String($oItem.type) = "checkbox" And Number($sString) = 0 Then $bFound = True
				Local $iCount = 0
					If String($oItem.type) = "checkbox" And Number($sString) = $iCount Then
						If String($oItem.type) = "checkbox" Then $iCount += 1
			__IEConsoleWriteError("Error", "_IEFormElementCheckBoxSelect", "$_IESTATUS_InvalidValue", "Invalid Mode")
			Return SetError($_IESTATUS_InvalidValue, 5, 0)
	If Not $bFound Then
	Switch $iSelect
			Return SetError($_IESTATUS_Success, 0, $oItem.checked)
			If $oItem.checked Then
				$oItem.checked = False
				If $iFireEvent Then
					$oItem.fireEvent("onChange")
					$oItem.fireEvent("OnClick")
			If Not $oItem.checked Then
				$oItem.checked = True
			__IEConsoleWriteError("Error", "_IEFormElementCheckBoxSelect", "$_IESTATUS_InvalidValue", "Invalid $iSelect value")
			Return SetError($_IESTATUS_InvalidValue, 3, 0)
EndFunc   ;==>_IEFormElementCheckBoxSelect
Func _IEFormElementRadioSelect(ByRef $oObject, $sString, $sName, $iSelect = 1, $sMode = "byValue", $iFireEvent = 1)
		__IEConsoleWriteError("Error", "_IEFormElementRadioSelect", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEFormElementRadioSelect", "$_IESTATUS_InvalidObjectType")
	Local $oItems = Execute("$oObject.elements('" & $sName & "')")
		__IEConsoleWriteError("Warning", "_IEFormElementRadioSelect", "$_IESTATUS_NoMatch")
				If String($oItem.type) = "radio" And String($oItem.value) = $sString Then $bFound = True
					If String($oItem.type) = "radio" And String($oItem.value) = $sString Then
				If String($oItem.type) = "radio" And Number($sString) = 0 Then $bFound = True
					If String($oItem.type) = "radio" And Number($sString) = $iCount Then
						$iCount += 1
			__IEConsoleWriteError("Error", "_IEFormElementRadioSelect", "$_IESTATUS_InvalidValue", "Invalid Mode")
			__IEConsoleWriteError("Error", "_IEFormElementRadioSelect", "$_IESTATUS_InvalidValue", "$iSelect value invalid")
			Return SetError($_IESTATUS_InvalidValue, 4, 0)
EndFunc   ;==>_IEFormElementRadioSelect
Func _IEFormImageClick(ByRef $oObject, $sLinkText, $sMode = "src", $iIndex = 0, $iWait = 1)
		__IEConsoleWriteError("Error", "_IEFormImageClick", "$_IESTATUS_InvalidDataType")
	Local $sModeLinktext, $iFound = 0
	Local $oImgs = _IETagNameGetCollection($oTemp, "input")
		If String($oImg.type) = "image" Then
			Select
				Case $sMode = "alt"
					$sModeLinktext = $oImg.alt
				Case $sMode = "name"
					$sModeLinktext = $oImg.name
					If Not IsString($sModeLinktext) Then $sModeLinktext = $oImg.id ; html5 support
				Case $sMode = "id"
					$sModeLinktext = $oImg.id
				Case $sMode = "src"
					$sModeLinktext = $oImg.src
					__IEConsoleWriteError("Error", "_IEFormImageClick", "$_IESTATUS_InvalidValue", "Invalid mode: " & $sMode)
					Return SetError($_IESTATUS_InvalidValue, 3, 0)
			EndSelect
			If StringInStr($sModeLinktext, $sLinkText) Then
				If ($iFound = $iIndex) Then
					$oImg.click()
					If @error Then ; Trap COM error, report and return
						__IEConsoleWriteError("Error", "_IEFormImageClick", "$_IESTATUS_COMError", @error)
						Return SetError($_IESTATUS_ComError, @error, 0)
					If $iWait Then
						_IELoadWait($oObject)
						Return SetError(@error, 0, -1)
					Return SetError($_IESTATUS_Success, 0, -1)
				$iFound = $iFound + 1
	__IEConsoleWriteError("Warning", "_IEFormImageClick", "$_IESTATUS_NoMatch")
	Return SetError($_IESTATUS_NoMatch, 2, 0)
EndFunc   ;==>_IEFormImageClick
Func _IEFormSubmit(ByRef $oObject, $iWait = 1)
		__IEConsoleWriteError("Error", "_IEFormSubmit", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEFormSubmit", "$_IESTATUS_InvalidObjectType")
	Local $oWindow = $oObject.document.parentWindow
	$oObject.submit()
		__IEConsoleWriteError("Error", "_IEFormSubmit", "$_IESTATUS_COMError", @error)
		_IELoadWait($oWindow)
EndFunc   ;==>_IEFormSubmit
Func _IEFormReset(ByRef $oObject)
		__IEConsoleWriteError("Error", "_IEFormReset", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEFormReset", "$_IESTATUS_InvalidObjectType")
	$oObject.reset()
		__IEConsoleWriteError("Error", "_IEFormReset", "$_IESTATUS_COMError", @error)
EndFunc   ;==>_IEFormReset
#EndRegion Form functions
#Region Table functions
Func _IETableGetCollection(ByRef $oObject, $iIndex = -1)
		__IEConsoleWriteError("Error", "_IETableGetCollection", "$_IESTATUS_InvalidDataType")
			Return SetError($_IESTATUS_Success, $oObject.document.GetElementsByTagName("table").length, _
					$oObject.document.GetElementsByTagName("table"))
		Case $iIndex > -1 And $iIndex < $oObject.document.GetElementsByTagName("table").length
					$oObject.document.GetElementsByTagName("table").item($iIndex))
			__IEConsoleWriteError("Error", "_IETableGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			__IEConsoleWriteError("Warning", "_IETableGetCollection", "$_IESTATUS_NoMatch")
EndFunc   ;==>_IETableGetCollection
Func _IETableWriteToArray(ByRef $oObject, $bTranspose = False)
		__IEConsoleWriteError("Error", "_IETableWriteToArray", "$_IESTATUS_InvalidDataType")
	If Not __IEIsObjType($oObject, "table") Then
		__IEConsoleWriteError("Error", "_IETableWriteToArray", "$_IESTATUS_InvalidObjectType")
	Local $iCols = 0, $oTds, $iCol
	Local $oTrs = $oObject.rows
	For $oTr In $oTrs
		$oTds = $oTr.cells
		$iCol = 0
		For $oTd In $oTds
			$iCol = $iCol + $oTd.colSpan
		If $iCol > $iCols Then $iCols = $iCol
	Local $iRows = $oTrs.length
	Local $aTableCells[$iCols][$iRows]
	Local $iRow = 0
			$aTableCells[$iCol][$iRow] = String($oTd.innerText)
			If @error Then ; Trap COM error, report and return
				__IEConsoleWriteError("Error", "_IETableWriteToArray", "$_IESTATUS_COMError", @error)
				Return SetError($_IESTATUS_ComError, @error, 0)
		$iRow = $iRow + 1
	If $bTranspose Then
		Local $iD1 = UBound($aTableCells, $UBOUND_ROWS), $iD2 = UBound($aTableCells, $UBOUND_COLUMNS), $aTmp[$iD2][$iD1]
		For $i = 0 To $iD2 - 1
			For $j = 0 To $iD1 - 1
				$aTmp[$i][$j] = $aTableCells[$j][$i]
		$aTableCells = $aTmp
	Return SetError($_IESTATUS_Success, 0, $aTableCells)
EndFunc   ;==>_IETableWriteToArray
#EndRegion Table functions
#Region Read/Write functions
Func _IEBodyReadHTML(ByRef $oObject)
		__IEConsoleWriteError("Error", "_IEBodyReadHTML", "$_IESTATUS_InvalidDataType")
	Return SetError($_IESTATUS_Success, 0, $oObject.document.body.innerHTML)
EndFunc   ;==>_IEBodyReadHTML
Func _IEBodyReadText(ByRef $oObject)
		__IEConsoleWriteError("Error", "_IEBodyReadText", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEBodyReadText", "$_IESTATUS_InvalidObjectType", "Expected document element")
	Return SetError($_IESTATUS_Success, 0, $oObject.document.body.innerText)
EndFunc   ;==>_IEBodyReadText
Func _IEBodyWriteHTML(ByRef $oObject, $sHTML)
		__IEConsoleWriteError("Error", "_IEBodyWriteHTML", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEBodyWriteHTML", "$_IESTATUS_InvalidObjectType", "Expected document element")
	$oObject.document.body.innerHTML = $sHTML
		__IEConsoleWriteError("Error", "_IEBodyWriteHTML", "$_IESTATUS_COMError", @error)
	Local $oTemp = $oObject.document
	_IELoadWait($oTemp)
	Return SetError(@error, 0, -1)
EndFunc   ;==>_IEBodyWriteHTML
Func _IEDocReadHTML(ByRef $oObject)
		__IEConsoleWriteError("Error", "_IEDocReadHTML", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEDocReadHTML", "$_IESTATUS_InvalidObjectType", "Expected document element")
	Return SetError($_IESTATUS_Success, 0, $oObject.document.documentElement.outerHTML)
EndFunc   ;==>_IEDocReadHTML
Func _IEDocWriteHTML(ByRef $oObject, $sHTML)
		__IEConsoleWriteError("Error", "_IEDocWriteHTML", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEDocWriteHTML", "$_IESTATUS_InvalidObjectType", "Expected document element")
	$oObject.document.Write($sHTML)
	$oObject.document.close()
		__IEConsoleWriteError("Error", "_IEDocWriteHTML", "$_IESTATUS_COMError", @error)
EndFunc   ;==>_IEDocWriteHTML
Func _IEDocInsertText(ByRef $oObject, $sString, $sWhere = "beforeend")
		__IEConsoleWriteError("Error", "_IEDocInsertText", "$_IESTATUS_InvalidDataType")
	If Not __IEIsObjType($oObject, "browserdom") Or __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
		__IEConsoleWriteError("Error", "_IEDocInsertText", "$_IESTATUS_InvalidObjectType", "Expected document element")
	$sWhere = StringLower($sWhere)
		Case $sWhere = "beforebegin"
			$oObject.insertAdjacentText($sWhere, $sString)
		Case $sWhere = "afterbegin"
		Case $sWhere = "beforeend"
		Case $sWhere = "afterend"
			__IEConsoleWriteError("Error", "_IEDocInsertText", "$_IESTATUS_InvalidValue", "Invalid where value")
		__IEConsoleWriteError("Error", "_IEDocInsertText", "$_IESTATUS_COMError", @error)
EndFunc   ;==>_IEDocInsertText
Func _IEDocInsertHTML(ByRef $oObject, $sString, $sWhere = "beforeend")
		__IEConsoleWriteError("Error", "_IEDocInsertHTML", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEDocInsertHTML", "$_IESTATUS_InvalidObjectType", "Expected document element")
			$oObject.insertAdjacentHTML($sWhere, $sString)
			__IEConsoleWriteError("Error", "_IEDocInsertHTML", "$_IESTATUS_InvalidValue", "Invalid where value")
		__IEConsoleWriteError("Error", "_IEDocInsertHTML", "$_IESTATUS_COMError", @error)
EndFunc   ;==>_IEDocInsertHTML
Func _IEHeadInsertEventScript(ByRef $oObject, $sHTMLFor, $sEvent, $sScript)
		__IEConsoleWriteError("Error", "_IEHeadInsertEventScript", "$_IESTATUS_InvalidDataType")
	Local $oHead = $oObject.document.all.tags("HEAD").Item(0)
	Local $oScript = $oObject.document.createElement("script")
		__IEConsoleWriteError("Error", "_IEHeadInsertEventScript(script)", "$_IESTATUS_COMError", @error)
	With $oScript
		.defer = True
		.language = "jscript"
		.type = "text/javascript"
		.htmlFor = $sHTMLFor
		.event = $sEvent
		.text = $sScript
	$oHead.appendChild($oScript)
		__IEConsoleWriteError("Error", "_IEHeadInsertEventScript", "$_IESTATUS_COMError", @error)
EndFunc   ;==>_IEHeadInsertEventScript
#EndRegion Read/Write functions
#Region Utility functions
Func _IEDocGetObj(ByRef $oObject)
		__IEConsoleWriteError("Error", "_IEDocGetObj", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_Success, 0, $oObject)
	Return SetError($_IESTATUS_Success, 0, $oObject.document)
EndFunc   ;==>_IEDocGetObj
Func _IETagNameGetCollection(ByRef $oObject, $sTagName, $iIndex = -1)
		__IEConsoleWriteError("Error", "_IETagNameGetCollection", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IETagNameGetCollection", "$_IESTATUS_InvalidObjectType")
	Local $oTemp
	If __IEIsObjType($oObject, "documentcontainer") Then
		$oTemp = _IEDocGetObj($oObject)
		$oTemp = $oObject
			Return SetError($_IESTATUS_Success, $oTemp.GetElementsByTagName($sTagName).length, _
					$oTemp.GetElementsByTagName($sTagName))
		Case $iIndex > -1 And $iIndex < $oTemp.GetElementsByTagName($sTagName).length
					$oTemp.GetElementsByTagName($sTagName).item($iIndex))
			__IEConsoleWriteError("Error", "_IETagNameGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			__IEConsoleWriteError("Error", "_IETagNameGetCollection", "$_IESTATUS_NoMatch")
EndFunc   ;==>_IETagNameGetCollection
Func _IETagNameAllGetCollection(ByRef $oObject, $iIndex = -1)
		__IEConsoleWriteError("Error", "_IETagNameAllGetCollection", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IETagNameAllGetCollection", "$_IESTATUS_InvalidObjectType")
			Return SetError($_IESTATUS_Success, $oTemp.all.length, $oTemp.all)
		Case $iIndex > -1 And $iIndex < $oTemp.all.length
			Return SetError($_IESTATUS_Success, $oTemp.all.length, $oTemp.all.item($iIndex))
			__IEConsoleWriteError("Error", "_IETagNameAllGetCollection", "$_IESTATUS_InvalidValue", "$iIndex < -1")
			__IEConsoleWriteError("Error", "_IETagNameAllGetCollection", "$_IESTATUS_NoMatch")
EndFunc   ;==>_IETagNameAllGetCollection
Func _IEGetObjByName(ByRef $oObject, $sName, $iIndex = 0)
		__IEConsoleWriteError("Error", "_IEGetObjByName", "$_IESTATUS_InvalidDataType")
		Return SetError($_IESTATUS_Success, $oObject.document.GetElementsByName($sName).length, _
				$oObject.document.GetElementsByName($sName))
		If IsObj($oObject.document.GetElementsByName($sName).item($iIndex)) Then
			Return SetError($_IESTATUS_Success, $oObject.document.GetElementsByName($sName).length, _
					$oObject.document.GetElementsByName($sName).item($iIndex))
			__IEConsoleWriteError("Warning", "_IEGetObjByName", "$_IESTATUS_NoMatch", "Name: " & $sName & ", Index: " & $iIndex)
EndFunc   ;==>_IEGetObjByName
Func _IEGetObjById(ByRef $oObject, $sID)
		__IEConsoleWriteError("Error", "_IEGetObjById", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEGetObById", "$_IESTATUS_InvalidObjectType")
	If IsObj($oObject.document.getElementById($sID)) Then
		Return SetError($_IESTATUS_Success, 0, $oObject.document.getElementById($sID))
		__IEConsoleWriteError("Warning", "_IEGetObjById", "$_IESTATUS_NoMatch", $sID)
EndFunc   ;==>_IEGetObjById
Func _IEAction(ByRef $oObject, $sAction)
		__IEConsoleWriteError("Error", "_IEAction(" & $sAction & ")", "$_IESTATUS_InvalidDataType")
	$sAction = StringLower($sAction)
		Case $sAction = "click"
			If __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(click)", " $_IESTATUS_InvalidObjectType")
				Return SetError($_IESTATUS_InvalidObjectType, 1, 0)
			$oObject.Click()
		Case $sAction = "disable"
				__IEConsoleWriteError("Error", "_IEAction(disable)", " $_IESTATUS_InvalidObjectType")
			$oObject.disabled = True
		Case $sAction = "enable"
				__IEConsoleWriteError("Error", "_IEAction(enable)", " $_IESTATUS_InvalidObjectType")
			$oObject.disabled = False
		Case $sAction = "focus"
				__IEConsoleWriteError("Error", "_IEAction(focus)", "$_IESTATUS_InvalidObjectType")
			$oObject.Focus()
		Case $sAction = "scrollintoview"
				__IEConsoleWriteError("Error", "_IEAction(scrollintoview)", "$_IESTATUS_InvalidObjectType")
			$oObject.scrollIntoView()
		Case $sAction = "copy"
			$oObject.document.execCommand("Copy")
		Case $sAction = "cut"
			$oObject.document.execCommand("Cut")
		Case $sAction = "paste"
			$oObject.document.execCommand("Paste")
		Case $sAction = "delete"
			$oObject.document.execCommand("Delete")
		Case $sAction = "saveas"
			$oObject.document.execCommand("SaveAs")
		Case $sAction = "refresh"
			$oObject.document.execCommand("Refresh")
				__IEConsoleWriteError("Error", "_IEAction(refresh)", "$_IESTATUS_COMError", @error)
		Case $sAction = "selectall"
			$oObject.document.execCommand("SelectAll")
		Case $sAction = "unselect"
			$oObject.document.execCommand("Unselect")
		Case $sAction = "print"
			$oObject.document.parentwindow.Print()
		Case $sAction = "printdefault"
			If Not __IEIsObjType($oObject, "browser") Then
				__IEConsoleWriteError("Error", "_IEAction(printdefault)", "$_IESTATUS_InvalidObjectType")
			$oObject.execWB(6, 2)
		Case $sAction = "back"
			If Not __IEIsObjType($oObject, "documentContainer") Then
				__IEConsoleWriteError("Error", "_IEAction(back)", "$_IESTATUS_InvalidObjectType")
			$oObject.GoBack()
		Case $sAction = "blur"
			$oObject.Blur()
		Case $sAction = "forward"
				__IEConsoleWriteError("Error", "_IEAction(forward)", "$_IESTATUS_InvalidObjectType")
			$oObject.GoForward()
		Case $sAction = "home"
				__IEConsoleWriteError("Error", "_IEAction(home)", "$_IESTATUS_InvalidObjectType")
			$oObject.GoHome()
		Case $sAction = "invisible"
				__IEConsoleWriteError("Error", "_IEAction(invisible)", "$_IESTATUS_InvalidObjectType")
			$oObject.visible = 0
		Case $sAction = "visible"
				__IEConsoleWriteError("Error", "_IEAction(visible)", "$_IESTATUS_InvalidObjectType")
			$oObject.visible = 1
		Case $sAction = "search"
				__IEConsoleWriteError("Error", "_IEAction(search)", "$_IESTATUS_InvalidObjectType")
			$oObject.GoSearch()
		Case $sAction = "stop"
				__IEConsoleWriteError("Error", "_IEAction(stop)", "$_IESTATUS_InvalidObjectType")
			$oObject.Stop()
		Case $sAction = "quit"
				__IEConsoleWriteError("Error", "_IEAction(quit)", "$_IESTATUS_InvalidObjectType")
			$oObject.Quit()
				__IEConsoleWriteError("Error", "_IEAction(" & $sAction & ")", "$_IESTATUS_COMError", @error)
			$oObject = 0
			__IEConsoleWriteError("Error", "_IEAction(" & $sAction & ")", "$_IESTATUS_InvalidValue", "Invalid Action")
		__IEConsoleWriteError("Error", "_IEAction(" & $sAction & ")", "$_IESTATUS_COMError", @error)
EndFunc   ;==>_IEAction
Func _IEPropertyGet(ByRef $oObject, $sProperty)
		__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
	Local $oTemp, $iTemp
	$sProperty = StringLower($sProperty)
		Case $sProperty = "browserx"
			If __IEIsObjType($oObject, "browsercontainer") Or __IEIsObjType($oObject, "document") Then
				__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidObjectType")
			$oTemp = $oObject
			$iTemp = 0
			While IsObj($oTemp)
				$iTemp += $oTemp.offsetLeft
				$oTemp = $oTemp.offsetParent
			Return SetError($_IESTATUS_Success, 0, $iTemp)
		Case $sProperty = "browsery"
				$iTemp += $oTemp.offsetTop
		Case $sProperty = "screenx"
			If __IEIsObjType($oObject, "window") Or __IEIsObjType($oObject, "document") Then
			If __IEIsObjType($oObject, "browser") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.left())
				$oTemp = $oObject
				$iTemp = 0
				While IsObj($oTemp)
					$iTemp += $oTemp.offsetLeft
					$oTemp = $oTemp.offsetParent
				WEnd
			Return SetError($_IESTATUS_Success, 0, _
					$iTemp + $oObject.document.parentWindow.screenLeft)
		Case $sProperty = "screeny"
				Return SetError($_IESTATUS_Success, 0, $oObject.top())
					$iTemp += $oTemp.offsetTop
					$iTemp + $oObject.document.parentWindow.screenTop)
		Case $sProperty = "height"
				Return SetError($_IESTATUS_Success, 0, $oObject.Height())
				Return SetError($_IESTATUS_Success, 0, $oObject.offsetHeight)
		Case $sProperty = "width"
				Return SetError($_IESTATUS_Success, 0, $oObject.Width())
				Return SetError($_IESTATUS_Success, 0, $oObject.offsetWidth)
		Case $sProperty = "isdisabled"
			Return SetError($_IESTATUS_Success, 0, $oObject.isDisabled())
		Case $sProperty = "addressbar"
			Return SetError($_IESTATUS_Success, 0, $oObject.AddressBar())
		Case $sProperty = "busy"
			Return SetError($_IESTATUS_Success, 0, $oObject.Busy())
		Case $sProperty = "fullscreen"
			Return SetError($_IESTATUS_Success, 0, $oObject.fullScreen())
		Case $sProperty = "hwnd"
			Return SetError($_IESTATUS_Success, 0, HWnd($oObject.HWnd()))
		Case $sProperty = "left"
			Return SetError($_IESTATUS_Success, 0, $oObject.Left())
		Case $sProperty = "locationname"
			Return SetError($_IESTATUS_Success, 0, $oObject.LocationName())
		Case $sProperty = "locationurl"
				Return SetError($_IESTATUS_Success, 0, $oObject.locationURL())
			If __IEIsObjType($oObject, "window") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.location.href())
			If __IEIsObjType($oObject, "document") Then
				Return SetError($_IESTATUS_Success, 0, $oObject.parentwindow.location.href())
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentwindow.location.href())
		Case $sProperty = "menubar"
			Return SetError($_IESTATUS_Success, 0, $oObject.MenuBar())
		Case $sProperty = "offline"
			Return SetError($_IESTATUS_Success, 0, $oObject.OffLine())
		Case $sProperty = "readystate"
			Return SetError($_IESTATUS_Success, 0, $oObject.ReadyState())
		Case $sProperty = "resizable"
			Return SetError($_IESTATUS_Success, 0, $oObject.Resizable())
		Case $sProperty = "silent"
			Return SetError($_IESTATUS_Success, 0, $oObject.Silent())
		Case $sProperty = "statusbar"
			Return SetError($_IESTATUS_Success, 0, $oObject.StatusBar())
		Case $sProperty = "statustext"
			Return SetError($_IESTATUS_Success, 0, $oObject.StatusText())
		Case $sProperty = "top"
			Return SetError($_IESTATUS_Success, 0, $oObject.Top())
		Case $sProperty = "visible"
			Return SetError($_IESTATUS_Success, 0, $oObject.Visible())
		Case $sProperty = "appcodename"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.appCodeName())
		Case $sProperty = "appminorversion"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.appMinorVersion())
		Case $sProperty = "appname"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.appName())
		Case $sProperty = "appversion"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.appVersion())
		Case $sProperty = "browserlanguage"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.browserLanguage())
		Case $sProperty = "cookieenabled"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.cookieEnabled())
		Case $sProperty = "cpuclass"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.cpuClass())
		Case $sProperty = "javaenabled"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.javaEnabled())
		Case $sProperty = "online"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.onLine())
		Case $sProperty = "platform"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.platform())
		Case $sProperty = "systemlanguage"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.systemLanguage())
		Case $sProperty = "useragent"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.userAgent())
		Case $sProperty = "userlanguage"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.parentWindow.top.navigator.userLanguage())
		Case $sProperty = "referrer"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.referrer)
		Case $sProperty = "theatermode"
			Return SetError($_IESTATUS_Success, 0, $oObject.TheaterMode)
		Case $sProperty = "toolbar"
			Return SetError($_IESTATUS_Success, 0, $oObject.ToolBar)
		Case $sProperty = "contenteditable"
			If __IEIsObjType($oObject, "browser") Or __IEIsObjType($oObject, "document") Then
				$oTemp = $oObject.document.body
			Return SetError($_IESTATUS_Success, 0, $oTemp.isContentEditable)
		Case $sProperty = "innertext"
			If __IEIsObjType($oObject, "documentcontainer") Or __IEIsObjType($oObject, "document") Then
			Return SetError($_IESTATUS_Success, 0, $oTemp.innerText)
		Case $sProperty = "outertext"
			Return SetError($_IESTATUS_Success, 0, $oTemp.outerText)
		Case $sProperty = "innerhtml"
			Return SetError($_IESTATUS_Success, 0, $oTemp.innerHTML)
		Case $sProperty = "outerhtml"
			Return SetError($_IESTATUS_Success, 0, $oTemp.outerHTML)
		Case $sProperty = "title"
			Return SetError($_IESTATUS_Success, 0, $oObject.document.title)
		Case $sProperty = "uniqueid"
				Return SetError($_IESTATUS_Success, 0, $oObject.uniqueID)
			__IEConsoleWriteError("Error", "_IEPropertyGet", "$_IESTATUS_InvalidValue", "Invalid Property")
EndFunc   ;==>_IEPropertyGet
Func _IEPropertySet(ByRef $oObject, $sProperty, $vValue)
		__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidDataType")
	#forceref $oTemp
				__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidObjectType")
			$oObject.AddressBar = $vValue
			$oObject.Height = $vValue
			$oObject.Left = $vValue
			$oObject.MenuBar = $vValue
			$oObject.OffLine = $vValue
			$oObject.Resizable = $vValue
			$oObject.StatusBar = $vValue
			$oObject.StatusText = $vValue
			$oObject.Top = $vValue
			$oObject.Width = $vValue
			If $vValue Then
				$oObject.TheaterMode = True
				$oObject.TheaterMode = False
				$oObject.ToolBar = True
				$oObject.ToolBar = False
				$oTemp.contentEditable = "true"
				$oTemp.contentEditable = "false"
			$oTemp.innerText = $vValue
			$oTemp.outerText = $vValue
			$oTemp.innerHTML = $vValue
			$oTemp.outerHTML = $vValue
			$oObject.document.title = $vValue
				$oObject.silent = True
				$oObject.silent = False
			__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_InvalidValue", "Invalid Property")
		__IEConsoleWriteError("Error", "_IEPropertySet", "$_IESTATUS_COMError", @error)
EndFunc   ;==>_IEPropertySet
Func _IEErrorNotify($vNotify = Default)
	If $vNotify = Default Then Return $__g_bIEErrorNotify
	If $vNotify Then
		$__g_bIEErrorNotify = True
		$__g_bIEErrorNotify = False
EndFunc   ;==>_IEErrorNotify
Func _IEErrorHandlerRegister($sFunctionName = "__IEInternalErrorHandler")
	$__g_oIEErrorHandler = ObjEvent("AutoIt.Error", $sFunctionName)
	If IsObj($__g_oIEErrorHandler) Then
		$__g_sIEUserErrorHandler = $sFunctionName
		$__g_oIEErrorHandler = ""
		__IEConsoleWriteError("Error", "_IEErrorHandlerRegister", "$_IEStatus_GeneralError", _
				"Error Handler Not Registered - Check existance of error function")
		Return SetError($_IEStatus_GeneralError, 1, 0)
EndFunc   ;==>_IEErrorHandlerRegister
Func _IEErrorHandlerDeRegister()
	$__g_sIEUserErrorHandler = ""
	$__g_oIEErrorHandler = ""
EndFunc   ;==>_IEErrorHandlerDeRegister
Func __IEInternalErrorHandlerRegister()
	Local $sCurrentErrorHandler = ObjEvent("AutoIt.Error")
	If $sCurrentErrorHandler <> "" And Not IsObj($__g_oIEErrorHandler) Then
		Return SetError($_IEStatus_GeneralError, 0, False)
	$__g_oIEErrorHandler = ObjEvent("AutoIt.Error", "__IEInternalErrorHandler")
		Return SetError($_IESTATUS_Success, 0, True)
EndFunc   ;==>__IEInternalErrorHandlerRegister
Func __IEInternalErrorHandlerDeRegister()
	If $__g_sIEUserErrorHandler <> "" Then
		$__g_oIEErrorHandler = ObjEvent("AutoIt.Error", $__g_sIEUserErrorHandler)
EndFunc   ;==>__IEInternalErrorHandlerDeRegister
Func __IEInternalErrorHandler($oCOMError)
	If $__g_bIEErrorNotify Or $__g_bIEAU3Debug Then ConsoleWrite("--> " & __COMErrorFormating($oCOMError, "----> $IEComError") & @CRLF)
	SetError($_IEStatus_ComError)
	Return
EndFunc   ;==>__IEInternalErrorHandler
Func _IEQuit(ByRef $oObject)
		__IEConsoleWriteError("Error", "_IEQuit", "$_IESTATUS_InvalidDataType")
	If Not __IEIsObjType($oObject, "browser") Then
		__IEConsoleWriteError("Error", "_IEQuit", "$_IESTATUS_InvalidObjectType")
	$oObject.quit()
		__IEConsoleWriteError("Error", "_IEQuit", "$_IESTATUS_COMError", @error)
	$oObject = 0
EndFunc   ;==>_IEQuit
#EndRegion Utility functions
#Region General
Func _IE_Introduction($sModule = "basic")
	Local $sHTML = ""
	Switch $sModule
		Case "basic"
			$sHTML &= '<!DOCTYPE html>' & @CR
			$sHTML &= '<html>' & @CR
			$sHTML &= '<head>' & @CR
			$sHTML &= '<meta content="text/html; charset=UTF-8" http-equiv="content-type">' & @CR
			$sHTML &= '<title>_IE_Introduction ("basic")</title>' & @CR
			$sHTML &= '<style>body {font-family: Arial}' & @CR
			$sHTML &= 'td {padding:6px}</style>' & @CR
			$sHTML &= '</head>' & @CR
			$sHTML &= '<body>' & @CR
			$sHTML &= '<table border=1 id="table1" style="width:600px;border-spacing:6px;">' & @CR
			$sHTML &= '<tr>' & @CR
			$sHTML &= '<td>' & @CR
			$sHTML &= '<h1>Welcome to IE.au3</h1>' & @CR
			$sHTML &= 'IE.au3 is a UDF (User Defined Function) library for the ' & @CR
			$sHTML &= '<a href="http://www.autoitscript.com">AutoIt</a> scripting language.' & @CR
			$sHTML &= '<br>  ' & @CR
			$sHTML &= 'IE.au3 allows you to either create or attach to an Internet Explorer browser and do ' & @CR
			$sHTML &= 'just about anything you could do with it interactively with the mouse and ' & @CR
			$sHTML &= 'keyboard, but do it through script.' & @CR
			$sHTML &= '<br>' & @CR
			$sHTML &= 'You can navigate to pages, click links, fill and submit forms etc. You can ' & @CR
			$sHTML &= 'also do things you cannot do interactively like change or rewrite page ' & @CR
			$sHTML &= 'content and JavaScripts, read, parse and save page content and monitor and act ' & @CR
			$sHTML &= 'upon browser "events".<br>' & @CR
			$sHTML &= 'IE.au3 uses the COM interface in AutoIt to interact with the Internet Explorer ' & @CR
			$sHTML &= 'object model and the DOM (Document Object Model) supported by the browser.' & @CR
			$sHTML &= 'Here are some links for more information and helpful tools:<br>' & @CR
			$sHTML &= 'Reference Material: ' & @CR
			$sHTML &= '<ul>' & @CR
			$sHTML &= '<li><a href="http://msdn1.microsoft.com/">MSDN (Microsoft Developer Network)</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/library/aa752084.aspx" target="_blank">InternetExplorer Object</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/library/ms531073.aspx" target="_blank">Document Object</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/ie/aa740473.aspx" target="_blank">Overviews and Tutorials</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/library/ms533029.aspx" target="_blank">DHTML Objects</a></li>' & @CR
			$sHTML &= '<li><a href="http://msdn2.microsoft.com/en-us/library/ms533051.aspx" target="_blank">DHTML Events</a></li>' & @CR
			$sHTML &= '</ul><br>' & @CR
			$sHTML &= 'Helpful Tools: ' & @CR
			$sHTML &= '<li><a href="http://www.autoitscript.com/forum/index.php?showtopic=19368" target="_blank">AutoIt IE Builder</a> (build IE scripts interactively)</li>' & @CR
			$sHTML &= '<li><a href="http://www.debugbar.com/" target="_blank">DebugBar</a> (DOM inspector, HTTP inspector, HTML validator and more - free for personal use) Recommended</li>' & @CR
			$sHTML &= '<li><a href="http://www.microsoft.com/downloads/details.aspx?FamilyID=e59c3964-672d-4511-bb3e-2d5e1db91038&amp;displaylang=en" target="_blank">IE Developer Toolbar</a> (comprehensive DOM analysis tool)</li>' & @CR
			$sHTML &= '<li><a href="http://slayeroffice.com/tools/modi/v2.0/modi_help.html" target="_blank">MODIV2</a> (view the DOM of a web page by mousing around)</li>' & @CR
			$sHTML &= '<li><a href="http://validator.w3.org/" target="_blank">HTML Validator</a> (verify HTML follows format rules)</li>' & @CR
			$sHTML &= '<li><a href="http://www.fiddlertool.com/fiddler/" target="_blank">Fiddler</a> (examine HTTP traffic)</li>' & @CR
			$sHTML &= '</ul>' & @CR
			$sHTML &= '</td>' & @CR
			$sHTML &= '</tr>' & @CR
			$sHTML &= '</table>' & @CR
			$sHTML &= '</body>' & @CR
			$sHTML &= '</html>'
			__IEConsoleWriteError("Error", "_IE_Introduction", "$_IESTATUS_InvalidValue")
			Return SetError($_IESTATUS_InvalidValue, 1, 0)
	Local $oObject = _IECreate()
	_IEDocWriteHTML($oObject, $sHTML)
EndFunc   ;==>_IE_Introduction
Func _IE_Example($sModule = "basic")
	Local $sHTML = "", $oObject
			$sHTML &= '<title>_IE_Example("basic")</title>' & @CR
			$sHTML &= '<style>body {font-family: Arial}</style>' & @CR
			$sHTML &= '<a href="http://www.autoitscript.com"><img src="http://www.autoitscript.com/images/logo_autoit_210x72.png" id="AutoItImage" alt="AutoIt Homepage Image" style="background: #204080;"></a>' & @CR
			$sHTML &= '<p></p>' & @CR
			$sHTML &= '<div id="line1">This is a simple HTML page with text, links and images.</div>' & @CR
			$sHTML &= '<div id="line2"><a href="http://www.autoitscript.com">AutoIt</a> is a wonderful automation scripting language.</div>' & @CR
			$sHTML &= '<div id="line3">It is supported by a very active and supporting <a href="http://www.autoitscript.com/forum/">user forum</a>.</div>' & @CR
			$sHTML &= '<div id="IEAu3Data"></div>' & @CR
			$oObject = _IECreate()
			_IEDocWriteHTML($oObject, $sHTML)
		Case "table"
			$sHTML &= '<title>_IE_Example("table")</title>' & @CR
			$sHTML &= '$oTableOne = _IETableGetObjByName($oIE, "tableOne")<br>' & @CR
			$sHTML &= '&lt;table border=1 id="tableOne"&gt;<br>' & @CR
			$sHTML &= '<table border=1 id="tableOne">' & @CR
			$sHTML &= '	<tr>' & @CR
			$sHTML &= '		<td>AutoIt</td>' & @CR
			$sHTML &= '		<td>is</td>' & @CR
			$sHTML &= '		<td>really</td>' & @CR
			$sHTML &= '		<td>great</td>' & @CR
			$sHTML &= '		<td>with</td>' & @CR
			$sHTML &= '		<td>IE.au3</td>' & @CR
			$sHTML &= '	</tr>' & @CR
			$sHTML &= '		<td>1</td>' & @CR
			$sHTML &= '		<td>2</td>' & @CR
			$sHTML &= '		<td>3</td>' & @CR
			$sHTML &= '		<td>4</td>' & @CR
			$sHTML &= '		<td>5</td>' & @CR
			$sHTML &= '		<td>6</td>' & @CR
			$sHTML &= '		<td>the</td>' & @CR
			$sHTML &= '		<td>quick</td>' & @CR
			$sHTML &= '		<td>red</td>' & @CR
			$sHTML &= '		<td>fox</td>' & @CR
			$sHTML &= '		<td>jumped</td>' & @CR
			$sHTML &= '		<td>over</td>' & @CR
			$sHTML &= '		<td>lazy</td>' & @CR
			$sHTML &= '		<td>brown</td>' & @CR
			$sHTML &= '		<td>dog</td>' & @CR
			$sHTML &= '		<td>time</td>' & @CR
			$sHTML &= '		<td>has</td>' & @CR
			$sHTML &= '		<td>come</td>' & @CR
			$sHTML &= '		<td>for</td>' & @CR
			$sHTML &= '		<td>all</td>' & @CR
			$sHTML &= '		<td>good</td>' & @CR
			$sHTML &= '		<td>men</td>' & @CR
			$sHTML &= '		<td>to</td>' & @CR
			$sHTML &= '		<td>aid</td>' & @CR
			$sHTML &= '		<td>of</td>' & @CR
			$sHTML &= '$oTableTwo = _IETableGetObjByName($oIE, "tableTwo")<br>' & @CR
			$sHTML &= '&lt;table border="1" id="tableTwo"&gt;<br>' & @CR
			$sHTML &= '<table border=1 id="tableTwo">' & @CR
			$sHTML &= '		<td colspan="4">Table Top</td>' & @CR
			$sHTML &= '		<td>One</td>' & @CR
			$sHTML &= '		<td colspan="3">Two</td>' & @CR
			$sHTML &= '		<td>Three</td>' & @CR
			$sHTML &= '		<td>Four</td>' & @CR
			$sHTML &= '		<td colspan="2">Five</td>' & @CR
			$sHTML &= '		<td>Six</td>' & @CR
			$sHTML &= '		<td colspan="3">Seven</td>' & @CR
			$sHTML &= '		<td>Eight</td>' & @CR
			$sHTML &= '		<td>Nine</td>' & @CR
			$sHTML &= '		<td>Ten</td>' & @CR
			$sHTML &= '		<td>Eleven</td>' & @CR
		Case "form"
			$sHTML &= '<title>_IE_Example("form")</title>' & @CR
			$sHTML &= '<form name="ExampleForm" onSubmit="javascript:alert(''ExampleFormSubmitted'');" method="post">' & @CR
			$sHTML &= '<table style="border-spacing:6px 6px;" border=1>' & @CR
			$sHTML &= '<td>ExampleForm</td>' & @CR
			$sHTML &= '<td>&lt;form name="ExampleForm" onSubmit="javascript:alert(''ExampleFormSubmitted'');" method="post"&gt;</td>' & @CR
			$sHTML &= '<td>Hidden Input Element<input type="hidden" name="hiddenExample" value="secret value"></td>' & @CR
			$sHTML &= '<td>&lt;input type="hidden" name="hiddenExample" value="secret value"&gt;</td>' & @CR
			$sHTML &= '<input type="text" name="textExample" value="http://" size="20" maxlength="30">' & @CR
			$sHTML &= '<td>&lt;input type="text" name="textExample" value="http://" size="20" maxlength="30"&gt;</td>' & @CR
			$sHTML &= '<input type="password" name="passwordExample" size="10">' & @CR
			$sHTML &= '<td>&lt;input type="password" name="passwordExample" size="10"&gt;</td>' & @CR
			$sHTML &= '<input type="file" name="fileExample">' & @CR
			$sHTML &= '<td>&lt;input type="file" name="fileExample"&gt;</td>' & @CR
			$sHTML &= '<input type="image" name="imageExample" alt="AutoIt Homepage" src="http://www.autoitscript.com/images/logo_autoit_210x72.png" style="background: #204080;>' & @CR
			$sHTML &= '<td>&lt;input type="image" name="imageExample" alt="AutoIt Homepage" src="http://www.autoitscript.com/images/logo_autoit_210x72.png"&gt;</td>' & @CR
			$sHTML &= '<textarea name="textareaExample" rows="5" cols="15">Hello!</textarea>' & @CR
			$sHTML &= '<td>&lt;textarea name="textareaExample" rows="5" cols="15"&gt;Hello!&lt;/textarea&gt;</td>' & @CR
			$sHTML &= '<input type="checkbox" name="checkboxG1Example" value="gameBasketball">Basketball<br>' & @CR
			$sHTML &= '<input type="checkbox" name="checkboxG1Example" value="gameFootball">Football<br>' & @CR
			$sHTML &= '<input type="checkbox" name="checkboxG2Example" value="gameTennis" checked>Tennis<br>' & @CR
			$sHTML &= '<input type="checkbox" name="checkboxG2Example" value="gameBaseball">Baseball' & @CR
			$sHTML &= '<td>&lt;input type="checkbox" name="checkboxG1Example" value="gameBasketball"&gt;Basketball&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="checkbox" name="checkboxG1Example" value="gameFootball"&gt;Football&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="checkbox" name="checkboxG2Example" value="gameTennis" checked&gt;Tennis&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="checkbox" name="checkboxG2Example" value="gameBaseball"&gt;Baseball</td>' & @CR
			$sHTML &= '<input type="radio" name="radioExample" value="vehicleAirplane">Airplane<br>' & @CR
			$sHTML &= '<input type="radio" name="radioExample" value="vehicleTrain" checked>Train<br>' & @CR
			$sHTML &= '<input type="radio" name="radioExample" value="vehicleBoat">Boat<br>' & @CR
			$sHTML &= '<input type="radio" name="radioExample" value="vehicleCar">Car</td>' & @CR
			$sHTML &= '<td>&lt;input type="radio" name="radioExample" value="vehicleAirplane"&gt;Airplane&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="radio" name="radioExample" value="vehicleTrain" checked&gt;Train&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="radio" name="radioExample" value="vehicleBoat"&gt;Boat&lt;br&gt;<br>' & @CR
			$sHTML &= '&lt;input type="radio" name="radioExample" value="vehicleCar"&gt;Car&lt;br&gt;</td>' & @CR
			$sHTML &= '<select name="selectExample">' & @CR
			$sHTML &= '<option value="homepage.html">Homepage' & @CR
			$sHTML &= '<option value="midipage.html">Midipage' & @CR
			$sHTML &= '<option value="freepage.html">Freepage' & @CR
			$sHTML &= '</select>' & @CR
			$sHTML &= '<td>&lt;select name="selectExample"&gt;<br>' & @CR
			$sHTML &= '&lt;option value="homepage.html"&gt;Homepage<br>' & @CR
			$sHTML &= '&lt;option value="midipage.html"&gt;Midipage<br>' & @CR
			$sHTML &= '&lt;option value="freepage.html"&gt;Freepage<br>' & @CR
			$sHTML &= '&lt;/select&gt;</td>' & @CR
			$sHTML &= '<select name="multipleSelectExample" size="6" multiple>' & @CR
			$sHTML &= '<option value="Name1">Aaron' & @CR
			$sHTML &= '<option value="Name2">Bruce' & @CR
			$sHTML &= '<option value="Name3">Carlos' & @CR
			$sHTML &= '<option value="Name4">Denis' & @CR
			$sHTML &= '<option value="Name5">Ed' & @CR
			$sHTML &= '<option value="Name6">Freddy' & @CR
			$sHTML &= '<td>&lt;select name="multipleSelectExample" size="6" multiple&gt;<br>' & @CR
			$sHTML &= '&lt;option value="Name1"&gt;Aaron<br>' & @CR
			$sHTML &= '&lt;option value="Name2"&gt;Bruce<br>' & @CR
			$sHTML &= '&lt;option value="Name3"&gt;Carlos<br>' & @CR
			$sHTML &= '&lt;option value="Name4"&gt;Denis<br>' & @CR
			$sHTML &= '&lt;option value="Name5"&gt;Ed<br>' & @CR
			$sHTML &= '&lt;option value="Name6"&gt;Freddy<br>' & @CR
			$sHTML &= '<input name="submitExample" type="submit" value="Submit">' & @CR
			$sHTML &= '<input name="resetExample" type="reset" value="Reset">' & @CR
			$sHTML &= '<td>&lt;input name="submitExample" type="submit" value="Submit"&gt;<br>' & @CR
			$sHTML &= '&lt;input name="resetExample" type="reset" value="Reset"&gt;</td>' & @CR
			$sHTML &= '<input type="hidden" name="hiddenExample" value="secret value">' & @CR
			$sHTML &= '</form>' & @CR
		Case "frameset"
			$sHTML &= '<title>_IE_Example("frameset")</title>' & @CR
			$sHTML &= '<frameset rows="25,200">' & @CR
			$sHTML &= '	<frame name=Top SRC=about:blank>' & @CR
			$sHTML &= '	<frameset cols="100,500">' & @CR
			$sHTML &= '		<frame name=Menu SRC=about:blank>' & @CR
			$sHTML &= '		<frame name=Main SRC=about:blank>' & @CR
			$sHTML &= '	</frameset>' & @CR
			$sHTML &= '</frameset>' & @CR
			_IEAction($oObject, "refresh")
			Local $oFrameTop = _IEFrameGetObjByName($oObject, "Top")
			Local $oFrameMenu = _IEFrameGetObjByName($oObject, "Menu")
			Local $oFrameMain = _IEFrameGetObjByName($oObject, "Main")
			_IEBodyWriteHTML($oFrameTop, '$oFrameTop = _IEFrameGetObjByName($oIE, "Top")')
			_IEBodyWriteHTML($oFrameMenu, '$oFrameMenu = _IEFrameGetObjByName($oIE, "Menu")')
			_IEBodyWriteHTML($oFrameMain, '$oFrameMain = _IEFrameGetObjByName($oIE, "Main")')
		Case "iframe"
			$sHTML &= '<title>_IE_Example("iframe")</title>' & @CR
			$sHTML &= '<style>td {padding:6px}</style>' & @CR
			$sHTML &= '<table style="border-spacing:6px" border=1>' & @CR
			$sHTML &= '<td><iframe name="iFrameOne" src="about:blank" title="iFrameOne"></iframe></td>' & @CR
			$sHTML &= '<td>&lt;iframe name="iFrameOne" src="about:blank" title="iFrameOne"&gt;</td>' & @CR
			$sHTML &= '<td><iframe name="iFrameTwo" src="about:blank" title="iFrameTwo"></iframe></td>' & @CR
			$sHTML &= '<td>&lt;iframe name="iFrameTwo" src="about:blank" title="iFrameTwo"&gt;</td>' & @CR
			Local $oIFrameOne = _IEFrameGetObjByName($oObject, "iFrameOne")
			Local $oIFrameTwo = _IEFrameGetObjByName($oObject, "iFrameTwo")
			_IEBodyWriteHTML($oIFrameOne, '$oIFrameOne = _IEFrameGetObjByName($oIE, "iFrameOne")')
			_IEBodyWriteHTML($oIFrameTwo, '$oIFrameTwo = _IEFrameGetObjByName($oIE, "iFrameTwo")')
			__IEConsoleWriteError("Error", "_IE_Example", "$_IESTATUS_InvalidValue")
	Sleep(500)
EndFunc   ;==>_IE_Example
Func _IE_VersionInfo()
	__IEConsoleWriteError("Information", "_IE_VersionInfo", "version " & _
			$__gaIEAU3VersionInfo[0] & _
			$__gaIEAU3VersionInfo[1] & "." & _
			$__gaIEAU3VersionInfo[2] & "-" & _
			$__gaIEAU3VersionInfo[3], "Release date: " & $__gaIEAU3VersionInfo[4])
	Return SetError($_IESTATUS_Success, 0, $__gaIEAU3VersionInfo)
EndFunc   ;==>_IE_VersionInfo
#EndRegion General
Func __IELockSetForegroundWindow($iLockCode)
	Local $aRet = DllCall("user32.dll", "bool", "LockSetForegroundWindow", "uint", $iLockCode)
	If @error Or Not $aRet[0] Then Return SetError(1, _WinAPI_GetLastError(), 0)
EndFunc   ;==>__IELockSetForegroundWindow
Func __IEControlGetObjFromHWND(ByRef $hWin)
	DllCall("ole32.dll", "long", "CoInitialize", "ptr", 0)
	If @error Then Return SetError(2, @error, 0)
	Local Const $WM_HTML_GETOBJECT = __IERegisterWindowMessage("WM_HTML_GETOBJECT")
	Local Const $SMTO_ABORTIFHUNG = 0x0002
	__IESendMessageTimeout($hWin, $WM_HTML_GETOBJECT, 0, 0, $SMTO_ABORTIFHUNG, 1000, $iResult)
	Local $tUUID = DllStructCreate("int;short;short;byte[8]")
	DllStructSetData($tUUID, 1, 0x626FC520)
	DllStructSetData($tUUID, 2, 0xA41E)
	DllStructSetData($tUUID, 3, 0x11CF)
	DllStructSetData($tUUID, 4, 0xA7, 1)
	DllStructSetData($tUUID, 4, 0x31, 2)
	DllStructSetData($tUUID, 4, 0x0, 3)
	DllStructSetData($tUUID, 4, 0xA0, 4)
	DllStructSetData($tUUID, 4, 0xC9, 5)
	DllStructSetData($tUUID, 4, 0x8, 6)
	DllStructSetData($tUUID, 4, 0x26, 7)
	DllStructSetData($tUUID, 4, 0x37, 8)
	Local $aRet = DllCall("oleacc.dll", "long", "ObjectFromLresult", "lresult", $iResult, "struct*", $tUUID, _
			"wparam", 0, "idispatch*", 0)
	If @error Then Return SetError(3, @error, 0)
	If IsObj($aRet[4]) Then
		Local $oIE = $aRet[4].Script()
		Return $oIE.Document.parentwindow
		Return SetError(1, $aRet[0], 0)
EndFunc   ;==>__IEControlGetObjFromHWND
Func __IERegisterWindowMessage($sMsg)
	Local $aRet = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $sMsg)
	If $aRet[0] = 0 Then Return SetError(10, _WinAPI_GetLastError(), 0)
EndFunc   ;==>__IERegisterWindowMessage
Func __IESendMessageTimeout($hWnd, $iMsg, $wParam, $lParam, $iFlags, $iTimeout, ByRef $vOut, $r = 0, $sT1 = "int", $sT2 = "int")
	Local $aRet = DllCall("user32.dll", "lresult", "SendMessageTimeout", "hwnd", $hWnd, "uint", $iMsg, $sT1, $wParam, _
			$sT2, $lParam, "uint", $iFlags, "uint", $iTimeout, "dword_ptr*", "")
	If @error Or $aRet[0] = 0 Then
		$vOut = 0
		Return SetError(1, _WinAPI_GetLastError(), 0)
	$vOut = $aRet[7]
	If $r >= 0 And $r <= 4 Then Return $aRet[$r]
EndFunc   ;==>__IESendMessageTimeout
Func __IEIsObjType(ByRef $oObject, $sType, $bRegister = True)
	Local $bStatus = $bRegister
	If $bRegister Then
		If Not $bStatus Then __IEConsoleWriteError("Warning", "internal function __IEIsObjType", _
	Local $sName = String(ObjName($oObject)), $iErrorStatus = $_IESTATUS_InvalidObjectType
		Case "browserdom"
			If __IEIsObjType($oObject, "documentcontainer", False) Then
				$iErrorStatus = $_IESTATUS_Success
			ElseIf __IEIsObjType($oObject, "document", False) Then
				Local $oTemp = $oObject.document
				If __IEIsObjType($oTemp, "document", False) Then
					$iErrorStatus = $_IESTATUS_Success
		Case "browser"
			If ($sName = "IWebBrowser2") Or ($sName = "IWebBrowser") Or ($sName = "WebBrowser") Then $iErrorStatus = $_IESTATUS_Success
		Case "window"
			If $sName = "HTMLWindow2" Then $iErrorStatus = $_IESTATUS_Success
		Case "documentContainer"
			If __IEIsObjType($oObject, "window", False) Or __IEIsObjType($oObject, "browser", False) Then $iErrorStatus = $_IESTATUS_Success
		Case "document"
			If $sName = "HTMLDocument" Then $iErrorStatus = $_IESTATUS_Success
			If $sName = "HTMLTable" Then $iErrorStatus = $_IESTATUS_Success
			If $sName = "HTMLFormElement" Then $iErrorStatus = $_IESTATUS_Success
		Case "forminputelement"
			If ($sName = "HTMLInputElement") Or ($sName = "HTMLSelectElement") Or ($sName = "HTMLTextAreaElement") Then $iErrorStatus = $_IESTATUS_Success
		Case "elementcollection"
			If ($sName = "HTMLElementCollection") Then $iErrorStatus = $_IESTATUS_Success
		Case "formselectelement"
			If $sName = "HTMLSelectElement" Then $iErrorStatus = $_IESTATUS_Success
			$iErrorStatus = $_IESTATUS_InvalidValue
	If $iErrorStatus = $_IESTATUS_Success Then
		Return SetError($iErrorStatus, 1, 0)
EndFunc   ;==>__IEIsObjType
Func __IEConsoleWriteError($sSeverity, $sFunc, $sMessage = Default, $sStatus = Default)
	If $__g_bIEErrorNotify Or $__g_bIEAU3Debug Then
		Local $sStr = "--> IE.au3 " & $__gaIEAU3VersionInfo[5] & " " & $sSeverity & " from function " & $sFunc
		If Not ($sMessage = Default) Then $sStr &= ", " & $sMessage
		If Not ($sStatus = Default) Then $sStr &= " (" & $sStatus & ")"
		ConsoleWrite($sStr & @CRLF)
	Return SetError($sStatus, 0, 1) ; restore calling @error
EndFunc   ;==>__IEConsoleWriteError
Func __IEComErrorUnrecoverable($iError)
	Switch $iError
		Case -2147352567 ; "an exception has occurred."
			Return $_IESTATUS_AccessIsDenied
		Case -2147024891 ; "Access is denied."
		Case -2147417848 ; "The object invoked has disconnected from its clients."
			Return $_IESTATUS_ClientDisconnected
		Case -2147023174 ; "RPC server not accessible."
		Case -2147023179 ; "The interface is unknown."
			Return $_IESTATUS_Success
EndFunc   ;==>__IEComErrorUnrecoverable
#Region ProtoType Functions
Func __IENavigate(ByRef $oObject, $sUrl, $iWait = 1, $iFags = 0, $sTarget = "", $sPostdata = "", $sHeaders = "")
	__IEConsoleWriteError("Warning", "__IENavigate", "Unsupported function called. Not fully tested.")
		__IEConsoleWriteError("Error", "__IENavigate", "$_IESTATUS_InvalidDataType")
		__IEConsoleWriteError("Error", "__IENavigate", "$_IESTATUS_InvalidObjectType")
	$oObject.navigate($sUrl, $iFags, $sTarget, $sPostdata, $sHeaders)
		Return SetError(@error, 0, $oObject)
EndFunc   ;==>__IENavigate
Func __IEStringToBstr($sString, $sCharSet = "us-ascii")
	Local Const $iTypeBinary = 1, $iTypeText = 2
	Local $oStream = ObjCreate("ADODB.Stream")
	$oStream.type = $iTypeText
	$oStream.CharSet = $sCharSet
	$oStream.Open
	$oStream.WriteText($sString)
	$oStream.Position = 0
	$oStream.type = $iTypeBinary
	Return $oStream.Read()
EndFunc   ;==>__IEStringToBstr
Func __IEBstrToString($oBstr, $sCharSet = "us-ascii")
	$oStream.Write($oBstr)
	Return $oStream.ReadText()
EndFunc   ;==>__IEBstrToString
Func __IECreateNewIE($sTitle, $sHead = "", $sBody = "")
	Local $sTemp = __IETempFile("", "~IE~", ".htm")
		__IEConsoleWriteError("Error", "_IECreateHTA", "", "Error creating temporary file in @TempDir or @ScriptDir")
	Local $sHTML = ''
	$sHTML &= '<!DOCTYPE html>' & @CR
	$sHTML &= '<html>' & @CR
	$sHTML &= '<head>' & @CR
	$sHTML &= '<meta content="text/html; charset=UTF-8" http-equiv="content-type">' & @CR
	$sHTML &= '<title>' & $sTemp & '</title>' & @CR & $sHead & @CR
	$sHTML &= '</head>' & @CR
	$sHTML &= '<body>' & @CR & $sBody & @CR
	$sHTML &= '</body>' & @CR
	$sHTML &= '</html>'
	Local $hFile = FileOpen($sTemp, $FO_OVERWRITE)
	FileWrite($hFile, $sHTML)
	FileClose($hFile)
		__IEConsoleWriteError("Error", "_IECreateNewIE", "", "Error creating temporary file in @TempDir or @ScriptDir")
		Return SetError($_IESTATUS_GeneralError, 2, 0)
	Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe " & $sTemp)
	Local $iPID
	If WinWait($sTemp, "", 60) Then
		$iPID = WinGetProcess($sTemp)
		__IEConsoleWriteError("Error", "_IECreateNewIE", "", "Timeout waiting for new IE window creation")
		Return SetError($_IESTATUS_GeneralError, 3, 0)
	If Not FileDelete($sTemp) Then
		__IEConsoleWriteError("Warning", "_IECreateNewIE", "", "Could not delete temporary file " & FileGetLongName($sTemp))
	Local $oObject = _IEAttach($sTemp)
	_IELoadWait($oObject)
	_IEPropertySet($oObject, "title", $sTitle)
	Return SetError($_IESTATUS_Success, $iPID, $oObject)
EndFunc   ;==>__IECreateNewIE
Func __IETempFile($sDirectoryName = @TempDir, $sFilePrefix = "~", $sFileExtension = ".tmp", $iRandomLength = 7)
	Local $sTempName, $iTmp = 0
	If Not FileExists($sDirectoryName) Then $sDirectoryName = @TempDir ; First reset to default temp dir
	If Not FileExists($sDirectoryName) Then $sDirectoryName = @ScriptDir ; Still wrong then set to Scriptdir
	If StringRight($sDirectoryName, 1) <> "\" Then $sDirectoryName = $sDirectoryName & "\"
		$sTempName = ""
		While StringLen($sTempName) < $iRandomLength
			$sTempName = $sTempName & Chr(Random(97, 122, 1))
		WEnd
		$sTempName = $sDirectoryName & $sFilePrefix & $sTempName & $sFileExtension
		$iTmp += 1
		If $iTmp > 200 Then ; If we fail over 200 times, there is something wrong
			Return SetError($_IESTATUS_GeneralError, 1, 0)
	Until Not FileExists($sTempName)
	Return $sTempName
EndFunc   ;==>__IETempFile
#EndRegion ProtoType Functions
#include "ArrayDisplayInternals.au3"
#include "MsgBoxConstants.au3"
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, _
		$ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
Global Enum $ARRAYUNIQUE_NOCOUNT, $ARRAYUNIQUE_COUNT
Global Enum $ARRAYUNIQUE_AUTO, $ARRAYUNIQUE_FORCE32, $ARRAYUNIQUE_FORCE64, $ARRAYUNIQUE_MATCH, $ARRAYUNIQUE_DISTINCT
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
	If $iStart = Default Then $iStart = 0
	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	Local $hDataType = 0
	Switch $iForce
		Case $ARRAYFILL_FORCE_INT
			$hDataType = Int
		Case $ARRAYFILL_FORCE_NUMBER
			$hDataType = Number
		Case $ARRAYFILL_FORCE_PTR
			$hDataType = Ptr
		Case $ARRAYFILL_FORCE_HWND
			$hDataType = Hwnd
		Case $ARRAYFILL_FORCE_STRING
			$hDataType = String
		Case $ARRAYFILL_FORCE_BOOLEAN
			$hDataType = "Boolean"
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
			If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
				ReDim $aArray[$iDim_1 + 1]
				$aArray[$iDim_1] = $vValue
				Return $iDim_1
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
				$hDataType = 0
				Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				If UBound($aTmp, $UBOUND_ROWS) = 1 Then
					$aTmp[0] = $vValue
				$vValue = $aTmp
			Local $iAdd = UBound($vValue, $UBOUND_ROWS)
			ReDim $aArray[$iDim_1 + $iAdd]
			For $i = 0 To $iAdd - 1
				If String($hDataType) = "Boolean" Then
					Switch $vValue[$i]
						Case "True", "1"
							$aArray[$iDim_1 + $i] = True
						Case "False", "0", ""
							$aArray[$iDim_1 + $i] = False
				ElseIf IsFunc($hDataType) Then
					$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
					$aArray[$iDim_1 + $i] = $vValue[$i]
			Return $iDim_1 + $iAdd - 1
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
			Local $iValDim_1, $iValDim_2 = 0, $iColCount
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
				$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
				$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
				Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
				Local $aTmp[$iValDim_1][0], $aSplit_2
				For $i = 0 To $iValDim_1 - 1
					$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
					$iColCount = UBound($aSplit_2)
					If $iColCount > $iValDim_2 Then
						$iValDim_2 = $iColCount
						ReDim $aTmp[$iValDim_1][$iValDim_2]
					For $j = 0 To $iColCount - 1
						$aTmp[$i][$j] = $aSplit_2[$j]
			If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
			ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
			For $iWriteTo_Index = 0 To $iValDim_1 - 1
				For $j = 0 To $iDim_2 - 1
					If $j < $iStart Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					ElseIf $j - $iStart > $iValDim_2 - 1 Then
						If String($hDataType) = "Boolean" Then
							Switch $vValue[$iWriteTo_Index][$j - $iStart]
								Case "True", "1"
									$aArray[$iWriteTo_Index + $iDim_1][$j] = True
								Case "False", "0", ""
									$aArray[$iWriteTo_Index + $iDim_1][$j] = False
							EndSwitch
						ElseIf IsFunc($hDataType) Then
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
			Return SetError(2, 0, -1)
	Return UBound($aArray, $UBOUND_ROWS) - 1
EndFunc   ;==>_ArrayAdd
Func _ArrayBinarySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iColumn = 0)
	If $iEnd = Default Then $iEnd = 0
	If $iColumn = Default Then $iColumn = 0
	If $iDim_1 = 0 Then Return SetError(6, 0, -1)
	If $iEnd < 1 Or $iEnd > $iDim_1 - 1 Then $iEnd = $iDim_1 - 1
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	Local $iMid = Int(($iEnd + $iStart) / 2)
			If $aArray[$iStart] > $vValue Or $aArray[$iEnd] < $vValue Then Return SetError(2, 0, -1)
			While $iStart <= $iMid And $vValue <> $aArray[$iMid]
				If $vValue < $aArray[$iMid] Then
					$iEnd = $iMid - 1
					$iStart = $iMid + 1
				$iMid = Int(($iEnd + $iStart) / 2)
			If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iColumn < 0 Or $iColumn > $iDim_2 Then Return SetError(7, 0, -1)
			If $aArray[$iStart][$iColumn] > $vValue Or $aArray[$iEnd][$iColumn] < $vValue Then Return SetError(2, 0, -1)
			While $iStart <= $iMid And $vValue <> $aArray[$iMid][$iColumn]
				If $vValue < $aArray[$iMid][$iColumn] Then
			Return SetError(5, 0, -1)
	Return $iMid
EndFunc   ;==>_ArrayBinarySearch
Func _ArrayColDelete(ByRef $aArray, $iColumn, $bConvert = False)
	If $bConvert = Default Then $bConvert = False
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(2, 0, -1)
	Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
	Switch $iDim_2
			If $iColumn < 0 Or $iColumn > 1 Then Return SetError(3, 0, -1)
			If $bConvert Then
				Local $aTempArray[$iDim_1]
				For $i = 0 To $iDim_1 - 1
					$aTempArray[$i] = $aArray[$i][(Not $iColumn)]
				$aArray = $aTempArray
				ContinueCase
			If $iColumn < 0 Or $iColumn > $iDim_2 - 1 Then Return SetError(3, 0, -1)
			For $i = 0 To $iDim_1 - 1
				For $j = $iColumn To $iDim_2 - 2
					$aArray[$i][$j] = $aArray[$i][$j + 1]
			ReDim $aArray[$iDim_1][$iDim_2 - 1]
	Return UBound($aArray, $UBOUND_COLUMNS)
EndFunc   ;==>_ArrayColDelete
Func _ArrayColInsert(ByRef $aArray, $iColumn)
			Local $aTempArray[$iDim_1][2]
			Switch $iColumn
				Case 0, 1
					For $i = 0 To $iDim_1 - 1
						$aTempArray[$i][(Not $iColumn)] = $aArray[$i]
					Return SetError(3, 0, -1)
			$aArray = $aTempArray
			If $iColumn < 0 Or $iColumn > $iDim_2 Then Return SetError(3, 0, -1)
			ReDim $aArray[$iDim_1][$iDim_2 + 1]
				For $j = $iDim_2 To $iColumn + 1 Step -1
					$aArray[$i][$j] = $aArray[$i][$j - 1]
				$aArray[$i][$iColumn] = ""
EndFunc   ;==>_ArrayColInsert
Func _ArrayCombinations(Const ByRef $aArray, $iSet, $sDelimiter = "")
	If $sDelimiter = Default Then $sDelimiter = ""
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(2, 0, 0)
	Local $iN = UBound($aArray)
	Local $iR = $iSet
	Local $aIdx[$iR]
	For $i = 0 To $iR - 1
		$aIdx[$i] = $i
	Local $iTotal = __Array_Combinations($iN, $iR)
	Local $iLeft = $iTotal
	Local $aResult[$iTotal + 1]
	$aResult[0] = $iTotal
	While $iLeft > 0
		__Array_GetNext($iN, $iR, $iLeft, $iTotal, $aIdx)
		For $i = 0 To $iSet - 1
			$aResult[$iCount] &= $aArray[$aIdx[$i]] & $sDelimiter
		If $sDelimiter <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], 1)
EndFunc   ;==>_ArrayCombinations
Func _ArrayConcatenate(ByRef $aArrayTarget, Const ByRef $aArraySource, $iStart = 0)
	If Not IsArray($aArrayTarget) Then Return SetError(1, 0, -1)
	If Not IsArray($aArraySource) Then Return SetError(2, 0, -1)
	Local $iDim_Total_Tgt = UBound($aArrayTarget, $UBOUND_DIMENSIONS)
	Local $iDim_Total_Src = UBound($aArraySource, $UBOUND_DIMENSIONS)
	Local $iDim_1_Tgt = UBound($aArrayTarget, $UBOUND_ROWS)
	Local $iDim_1_Src = UBound($aArraySource, $UBOUND_ROWS)
	If $iStart < 0 Or $iStart > $iDim_1_Src - 1 Then Return SetError(6, 0, -1)
	Switch $iDim_Total_Tgt
			If $iDim_Total_Src <> 1 Then Return SetError(4, 0, -1)
			ReDim $aArrayTarget[$iDim_1_Tgt + $iDim_1_Src - $iStart]
			For $i = $iStart To $iDim_1_Src - 1
				$aArrayTarget[$iDim_1_Tgt + $i - $iStart] = $aArraySource[$i]
			If $iDim_Total_Src <> 2 Then Return SetError(4, 0, -1)
			Local $iDim_2_Tgt = UBound($aArrayTarget, $UBOUND_COLUMNS)
			If UBound($aArraySource, $UBOUND_COLUMNS) <> $iDim_2_Tgt Then Return SetError(5, 0, -1)
			ReDim $aArrayTarget[$iDim_1_Tgt + $iDim_1_Src - $iStart][$iDim_2_Tgt]
				For $j = 0 To $iDim_2_Tgt - 1
					$aArrayTarget[$iDim_1_Tgt + $i - $iStart][$j] = $aArraySource[$i][$j]
			Return SetError(3, 0, -1)
	Return UBound($aArrayTarget, $UBOUND_ROWS)
EndFunc   ;==>_ArrayConcatenate
Func _ArrayDelete(ByRef $aArray, $vRange)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If IsArray($vRange) Then
		If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
		Local $iNumber, $aSplit_1, $aSplit_2
		$vRange = StringStripWS($vRange, 8)
		$aSplit_1 = StringSplit($vRange, ";")
		$vRange = ""
		For $i = 1 To $aSplit_1[0]
			If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
			$aSplit_2 = StringSplit($aSplit_1[$i], "-")
			Switch $aSplit_2[0]
				Case 1
					$vRange &= $aSplit_2[1] & ";"
				Case 2
					If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
						$iNumber = $aSplit_2[1] - 1
						Do
							$iNumber += 1
							$vRange &= $iNumber & ";"
						Until $iNumber = $aSplit_2[2]
		$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
	If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
	Local $iCopyTo_Index = 0
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]] = ChrW(0xFAB1)
			For $iReadFrom_Index = 0 To $iDim_1
				If $aArray[$iReadFrom_Index] == ChrW(0xFAB1) Then
					ContinueLoop
					If $iReadFrom_Index <> $iCopyTo_Index Then
						$aArray[$iCopyTo_Index] = $aArray[$iReadFrom_Index]
					$iCopyTo_Index += 1
			ReDim $aArray[$iDim_1 - $vRange[0] + 1]
				$aArray[$vRange[$i]][0] = ChrW(0xFAB1)
				If $aArray[$iReadFrom_Index][0] == ChrW(0xFAB1) Then
						For $j = 0 To $iDim_2
							$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFrom_Index][$j]
			ReDim $aArray[$iDim_1 - $vRange[0] + 1][$iDim_2 + 1]
			Return SetError(2, 0, False)
	Return UBound($aArray, $UBOUND_ROWS)
EndFunc   ;==>_ArrayDelete
Func _ArrayDisplay(Const ByRef $aArray, $sTitle = Default, $sArrayRange = Default, $iFlags = Default, $vUser_Separator = Default, $sHeader = Default, $iMax_ColWidth = Default)
	#forceref $vUser_Separator
	Local $iRet = __ArrayDisplay_Share($aArray, $sTitle, $sArrayRange, $iFlags, Default, $sHeader, $iMax_ColWidth, 0, False)
	Return SetError(@error, @extended, $iRet)
EndFunc   ;==>_ArrayDisplay
Func _ArrayExtract(Const ByRef $aArray, $iStart_Row = -1, $iEnd_Row = -1, $iStart_Col = -1, $iEnd_Col = -1)
	If $iStart_Row = Default Then $iStart_Row = -1
	If $iEnd_Row = Default Then $iEnd_Row = -1
	If $iStart_Col = Default Then $iStart_Col = -1
	If $iEnd_Col = Default Then $iEnd_Col = -1
	If $iEnd_Row = -1 Then $iEnd_Row = $iDim_1
	If $iStart_Row = -1 Then $iStart_Row = 0
	If $iStart_Row < -1 Or $iEnd_Row < -1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, -1)
	If $iStart_Row > $iEnd_Row Then Return SetError(4, 0, -1)
			Local $aRetArray[$iEnd_Row - $iStart_Row + 1]
			For $i = 0 To $iEnd_Row - $iStart_Row
				$aRetArray[$i] = $aArray[$i + $iStart_Row]
			Return $aRetArray
			If $iEnd_Col = -1 Then $iEnd_Col = $iDim_2
			If $iStart_Col = -1 Then $iStart_Col = 0
			If $iStart_Col < -1 Or $iEnd_Col < -1 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iDim_2 Or $iEnd_Col > $iDim_2 Then Return SetError(5, 0, -1)
			If $iStart_Col > $iEnd_Col Then Return SetError(6, 0, -1)
			If $iStart_Col = $iEnd_Col Then
				Local $aRetArray[$iEnd_Row - $iStart_Row + 1]
				Local $aRetArray[$iEnd_Row - $iStart_Row + 1][$iEnd_Col - $iStart_Col + 1]
				For $j = 0 To $iEnd_Col - $iStart_Col
					If $iStart_Col = $iEnd_Col Then
						$aRetArray[$i] = $aArray[$i + $iStart_Row][$j + $iStart_Col]
						$aRetArray[$i][$j] = $aArray[$i + $iStart_Row][$j + $iStart_Col]
EndFunc   ;==>_ArrayExtract
Func _ArrayFindAll(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iSubItem = 0, $bRow = False)
	If $iCase = Default Then $iCase = 0
	If $iCompare = Default Then $iCompare = 0
	If $iSubItem = Default Then $iSubItem = 0
	If $bRow = Default Then $bRow = False
	$iStart = _ArraySearch($aArray, $vValue, $iStart, $iEnd, $iCase, $iCompare, 1, $iSubItem, $bRow)
	If @error Then Return SetError(@error, 0, -1)
	Local $iIndex = 0, $avResult[UBound($aArray, ($bRow ? $UBOUND_COLUMNS : $UBOUND_ROWS))] ; Set dimension for Column/Row
		$avResult[$iIndex] = $iStart
		$iIndex += 1
		$iStart = _ArraySearch($aArray, $vValue, $iStart + 1, $iEnd, $iCase, $iCompare, 1, $iSubItem, $bRow)
	Until @error
	ReDim $avResult[$iIndex]
	Return $avResult
EndFunc   ;==>_ArrayFindAll
Func _ArrayInsert(ByRef $aArray, $vRange, $vValue = "", $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
	If $vValue = Default Then $vValue = ""
	Local $aSplit_1, $aSplit_2
		Local $iNumber
	For $i = 2 To $vRange[0]
		If $vRange[$i] < $vRange[$i - 1] Then Return SetError(3, 0, -1)
	Local $iCopyTo_Index = $iDim_1 + $vRange[0]
	Local $iInsertPoint_Index = $vRange[0]
	Local $iInsert_Index = $vRange[$iInsertPoint_Index]
				ReDim $aArray[$iDim_1 + $vRange[0] + 1]
				For $iReadFromIndex = $iDim_1 To 0 Step -1
					$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
					$iCopyTo_Index -= 1
					$iInsert_Index = $vRange[$iInsertPoint_Index]
					While $iReadFromIndex = $iInsert_Index
						$aArray[$iCopyTo_Index] = $vValue
						$iCopyTo_Index -= 1
						$iInsertPoint_Index -= 1
						If $iInsertPoint_Index < 1 Then ExitLoop 2
						$iInsert_Index = $vRange[$iInsertPoint_Index]
					WEnd
				Return $iDim_1 + $vRange[0] + 1
			ReDim $aArray[$iDim_1 + $vRange[0] + 1]
					$hDataType = 0
			For $iReadFromIndex = $iDim_1 To 0 Step -1
				$aArray[$iCopyTo_Index] = $aArray[$iReadFromIndex]
				$iCopyTo_Index -= 1
				$iInsert_Index = $vRange[$iInsertPoint_Index]
				While $iReadFromIndex = $iInsert_Index
					If $iInsertPoint_Index <= UBound($vValue, $UBOUND_ROWS) Then
						If IsFunc($hDataType) Then
							$aArray[$iCopyTo_Index] = $hDataType($vValue[$iInsertPoint_Index - 1])
							$aArray[$iCopyTo_Index] = $vValue[$iInsertPoint_Index - 1]
						$aArray[$iCopyTo_Index] = ""
					$iInsertPoint_Index -= 1
					If $iInsertPoint_Index = 0 Then ExitLoop 2
			If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(6, 0, -1)
			Local $iValDim_1, $iValDim_2
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(7, 0, -1)
				$aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				StringReplace($aSplit_1[0], $sDelim_Item, "")
				$iValDim_2 = @extended + 1
				Local $aTmp[$iValDim_1][$iValDim_2]
					For $j = 0 To $iValDim_2 - 1
			If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(8, 0, -1)
			ReDim $aArray[$iDim_1 + $vRange[0] + 1][$iDim_2]
					$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFromIndex][$j]
					For $j = 0 To $iDim_2 - 1
						If $j < $iStart Then
							$aArray[$iCopyTo_Index][$j] = ""
						ElseIf $j - $iStart > $iValDim_2 - 1 Then
							If $iInsertPoint_Index - 1 < $iValDim_1 Then
								If IsFunc($hDataType) Then
									$aArray[$iCopyTo_Index][$j] = $hDataType($vValue[$iInsertPoint_Index - 1][$j - $iStart])
									$aArray[$iCopyTo_Index][$j] = $vValue[$iInsertPoint_Index - 1][$j - $iStart]
								$aArray[$iCopyTo_Index][$j] = ""
EndFunc   ;==>_ArrayInsert
Func _ArrayMax(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	Local $iResult = _ArrayMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem)
	If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then
		Return $aArray[$iResult]
		Return $aArray[$iResult][$iSubItem]
EndFunc   ;==>_ArrayMax
Func _ArrayMaxIndex(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = -1
	If $iEnd = Default Then $iEnd = -1
	Local $iRet = __Array_MinMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, __Array_GreaterThan) ; Pass a delegate function to check if value1 > value2.
	Return SetError(@error, 0, $iRet)
EndFunc   ;==>_ArrayMaxIndex
Func _ArrayMin(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	Local $iResult = _ArrayMinIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem)
EndFunc   ;==>_ArrayMin
Func _ArrayMinIndex(Const ByRef $aArray, $iCompNumeric = 0, $iStart = -1, $iEnd = -1, $iSubItem = 0)
	Local $iRet = __Array_MinMaxIndex($aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, __Array_LessThan) ; Pass a delegate function to check if value1 < value2.
EndFunc   ;==>_ArrayMinIndex
Func _ArrayPermute(ByRef $aArray, $sDelimiter = "")
	Local $iSize = UBound($aArray), $iFactorial = 1, $aIdx[$iSize], $aResult[1], $iCount = 1
	If UBound($aArray) Then
		For $i = 0 To $iSize - 1
			$aIdx[$i] = $i
		For $i = $iSize To 1 Step -1
			$iFactorial *= $i
		ReDim $aResult[$iFactorial + 1]
		$aResult[0] = $iFactorial
		__Array_ExeterInternal($aArray, 0, $iSize, $sDelimiter, $aIdx, $aResult, $iCount)
		$aResult[0] = 0
EndFunc   ;==>_ArrayPermute
Func _ArrayPop(ByRef $aArray)
	If (Not IsArray($aArray)) Then Return SetError(1, 0, "")
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(2, 0, "")
	Local $iUBound = UBound($aArray) - 1
	If $iUBound = -1 Then Return SetError(3, 0, "")
	Local $sLastVal = $aArray[$iUBound]
	If $iUBound > -1 Then
		ReDim $aArray[$iUBound]
	Return $sLastVal
EndFunc   ;==>_ArrayPop
Func _ArrayPush(ByRef $aArray, $vValue, $iDirection = 0)
	If $iDirection = Default Then $iDirection = 0
	If (Not IsArray($aArray)) Then Return SetError(1, 0, 0)
	If UBound($aArray, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(3, 0, 0)
	If IsArray($vValue) Then ; $vValue is an array
		Local $iUBoundS = UBound($vValue)
		If ($iUBoundS - 1) > $iUBound Then Return SetError(2, 0, 0)
		If $iDirection Then ; slide right, add to front
			For $i = $iUBound To $iUBoundS Step -1
				$aArray[$i] = $aArray[$i - $iUBoundS]
			For $i = 0 To $iUBoundS - 1
				$aArray[$i] = $vValue[$i]
		Else ; slide left, add to end
			For $i = 0 To $iUBound - $iUBoundS
				$aArray[$i] = $aArray[$i + $iUBoundS]
				$aArray[$i + $iUBound - $iUBoundS + 1] = $vValue[$i]
		If $iUBound > -1 Then
			If $iDirection Then ; slide right, add to front
				For $i = $iUBound To 1 Step -1
					$aArray[$i] = $aArray[$i - 1]
				$aArray[0] = $vValue
			Else ; slide left, add to end
				For $i = 0 To $iUBound - 1
					$aArray[$i] = $aArray[$i + 1]
				$aArray[$iUBound] = $vValue
EndFunc   ;==>_ArrayPush
Func _ArrayReverse(ByRef $aArray, $iStart = 0, $iEnd = 0)
	If Not UBound($aArray) Then Return SetError(4, 0, 0)
	Local $vTmp, $iUBound = UBound($aArray) - 1
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart > $iEnd Then Return SetError(2, 0, 0)
	For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
		$vTmp = $aArray[$i]
		$aArray[$i] = $aArray[$iEnd]
		$aArray[$iEnd] = $vTmp
		$iEnd -= 1
EndFunc   ;==>_ArrayReverse
Func _ArraySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iForward = 1, $iSubItem = -1, $bRow = False)
	If $iForward = Default Then $iForward = 1
	If $iSubItem = Default Then $iSubItem = -1
	Local $iDim_1 = UBound($aArray) - 1
	If $iDim_1 = -1 Then Return SetError(3, 0, -1)
	Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
	Local $bCompType = False
	If $iCompare = 2 Then
		$iCompare = 0
		$bCompType = True
	If $bRow Then
		If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then Return SetError(5, 0, -1)
		If $iEnd < 1 Or $iEnd > $iDim_2 Then $iEnd = $iDim_2
		If $iStart < 0 Then $iStart = 0
		If $iStart > $iEnd Then Return SetError(4, 0, -1)
		If $iEnd < 1 Or $iEnd > $iDim_1 Then $iEnd = $iDim_1
	Local $iStep = 1
	If Not $iForward Then
		Local $iTmp = $iStart
		$iStart = $iEnd
		$iEnd = $iTmp
		$iStep = -1
		Case 1 ; 1D array search
			If Not $iCompare Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
						If $aArray[$i] = $vValue Then Return $i
						If $aArray[$i] == $vValue Then Return $i
				For $i = $iStart To $iEnd Step $iStep
					If $iCompare = 3 Then
						If StringRegExp($aArray[$i], $vValue) Then Return $i
						If StringInStr($aArray[$i], $vValue, $iCase) > 0 Then Return $i
		Case 2 ; 2D array search
			Local $iDim_Sub
			If $bRow Then
				$iDim_Sub = $iDim_1
				If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
				If $iSubItem < 0 Then
					$iSubItem = 0
					$iDim_Sub = $iSubItem
				$iDim_Sub = $iDim_2
			For $j = $iSubItem To $iDim_Sub
				If Not $iCompare Then
					If Not $iCase Then
						For $i = $iStart To $iEnd Step $iStep
							If $bRow Then
								If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$j][$i] = $vValue Then Return $i
								If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
								If $aArray[$i][$j] = $vValue Then Return $i
								If $aArray[$j][$i] == $vValue Then Return $i
								If $aArray[$i][$j] == $vValue Then Return $i
						If $iCompare = 3 Then
								If StringRegExp($aArray[$j][$i], $vValue) Then Return $i
								If StringRegExp($aArray[$i][$j], $vValue) Then Return $i
								If StringInStr($aArray[$j][$i], $vValue, $iCase) > 0 Then Return $i
								If StringInStr($aArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
	Return SetError(6, 0, -1)
EndFunc   ;==>_ArraySearch
Func _ArrayShuffle(ByRef $aArray, $iStart_Row = 0, $iEnd_Row = 0, $iCol = -1)
	If $iStart_Row = Default Then $iStart_Row = 0
	If $iEnd_Row = Default Then $iEnd_Row = 0
	If $iCol = Default Then $iCol = -1
	If $iEnd_Row = 0 Then $iEnd_Row = $iDim_1 - 1
	If $iStart_Row < 0 Or $iStart_Row > $iDim_1 - 1 Then Return SetError(3, 0, -1)
	If $iEnd_Row < 1 Or $iEnd_Row > $iDim_1 - 1 Then Return SetError(3, 0, -1)
	Local $vTmp, $iRand
			For $i = $iEnd_Row To $iStart_Row + 1 Step -1
				$iRand = Random($iStart_Row, $i, 1)
				$vTmp = $aArray[$i]
				$aArray[$i] = $aArray[$iRand]
				$aArray[$iRand] = $vTmp
			If $iCol < -1 Or $iCol > $iDim_2 - 1 Then Return SetError(5, 0, -1)
			Local $iCol_Start, $iCol_End
			If $iCol = -1 Then
				$iCol_Start = 0
				$iCol_End = $iDim_2 - 1
				$iCol_Start = $iCol
				$iCol_End = $iCol
				For $j = $iCol_Start To $iCol_End
					$vTmp = $aArray[$i][$j]
					$aArray[$i][$j] = $aArray[$iRand][$j]
					$aArray[$iRand][$j] = $vTmp
EndFunc   ;==>_ArrayShuffle
Func _ArraySort(ByRef $aArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0, $iPivot = 0)
	If $iDescending = Default Then $iDescending = 0
	If $iPivot = Default Then $iPivot = 0
	If $iUBound = -1 Then Return SetError(5, 0, 0)
	If $iEnd < 1 Or $iEnd > $iUBound Or $iEnd = Default Then $iEnd = $iUBound
	If $iStart < 0 Or $iStart = Default Then $iStart = 0
			If $iPivot Then ; Switch algorithms as required
				__ArrayDualPivotSort($aArray, $iStart, $iEnd)
				__ArrayQuickSort1D($aArray, $iStart, $iEnd)
			If $iDescending Then _ArrayReverse($aArray, $iStart, $iEnd)
			If $iPivot Then Return SetError(6, 0, 0) ; Error if 2D array and $iPivot
			Local $iSubMax = UBound($aArray, $UBOUND_COLUMNS) - 1
			If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)
			If $iDescending Then
				$iDescending = -1
				$iDescending = 1
			__ArrayQuickSort2D($aArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
			Return SetError(4, 0, 0)
EndFunc   ;==>_ArraySort
Func __ArrayQuickSort1D(ByRef $aArray, Const ByRef $iStart, Const ByRef $iEnd)
	If $iEnd <= $iStart Then Return
	Local $vTmp
	If ($iEnd - $iStart) < 15 Then
		Local $vCur
		For $i = $iStart + 1 To $iEnd
			$vTmp = $aArray[$i]
			If IsNumber($vTmp) Then
				For $j = $i - 1 To $iStart Step -1
					$vCur = $aArray[$j]
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$aArray[$j + 1] = $vCur
					If (StringCompare($vTmp, $aArray[$j]) >= 0) Then ExitLoop
					$aArray[$j + 1] = $aArray[$j]
			$aArray[$j + 1] = $vTmp
	Local $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)], $bNum = IsNumber($vPivot)
		If $bNum Then
			While ($aArray[$L] < $vPivot And IsNumber($aArray[$L])) Or (Not IsNumber($aArray[$L]) And StringCompare($aArray[$L], $vPivot) < 0)
				$L += 1
			While ($aArray[$R] > $vPivot And IsNumber($aArray[$R])) Or (Not IsNumber($aArray[$R]) And StringCompare($aArray[$R], $vPivot) > 0)
				$R -= 1
			While (StringCompare($aArray[$L], $vPivot) < 0)
			While (StringCompare($aArray[$R], $vPivot) > 0)
		If $L <= $R Then
			$vTmp = $aArray[$L]
			$aArray[$L] = $aArray[$R]
			$aArray[$R] = $vTmp
			$L += 1
			$R -= 1
	Until $L > $R
	__ArrayQuickSort1D($aArray, $iStart, $R)
	__ArrayQuickSort1D($aArray, $L, $iEnd)
EndFunc   ;==>__ArrayQuickSort1D
Func __ArrayQuickSort2D(ByRef $aArray, Const ByRef $iStep, Const ByRef $iStart, Const ByRef $iEnd, Const ByRef $iSubItem, Const ByRef $iSubMax)
	Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $aArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $bNum = IsNumber($vPivot)
			While ($iStep * ($aArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($aArray[$L][$iSubItem])) Or (Not IsNumber($aArray[$L][$iSubItem]) And $iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
			While ($iStep * ($aArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($aArray[$R][$iSubItem])) Or (Not IsNumber($aArray[$R][$iSubItem]) And $iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
			While ($iStep * StringCompare($aArray[$L][$iSubItem], $vPivot) < 0)
			While ($iStep * StringCompare($aArray[$R][$iSubItem], $vPivot) > 0)
			For $i = 0 To $iSubMax
				$vTmp = $aArray[$L][$i]
				$aArray[$L][$i] = $aArray[$R][$i]
				$aArray[$R][$i] = $vTmp
	__ArrayQuickSort2D($aArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
	__ArrayQuickSort2D($aArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc   ;==>__ArrayQuickSort2D
Func __ArrayDualPivotSort(ByRef $aArray, $iPivot_Left, $iPivot_Right, $bLeftMost = True)
	If $iPivot_Left > $iPivot_Right Then Return
	Local $iLength = $iPivot_Right - $iPivot_Left + 1
	Local $i, $j, $k, $iAi, $iAk, $iA1, $iA2, $iLast
	If $iLength < 45 Then ; Use insertion sort for small arrays - value chosen empirically
		If $bLeftMost Then
			$i = $iPivot_Left
			While $i < $iPivot_Right
				$j = $i
				$iAi = $aArray[$i + 1]
				While $iAi < $aArray[$j]
					$j -= 1
					If $j + 1 = $iPivot_Left Then ExitLoop
				$aArray[$j + 1] = $iAi
				$i += 1
			While 1
				If $iPivot_Left >= $iPivot_Right Then Return 1
				$iPivot_Left += 1
				If $aArray[$iPivot_Left] < $aArray[$iPivot_Left - 1] Then ExitLoop
				$k = $iPivot_Left
				If $iPivot_Left > $iPivot_Right Then ExitLoop
				$iA1 = $aArray[$k]
				$iA2 = $aArray[$iPivot_Left]
				If $iA1 < $iA2 Then
					$iA2 = $iA1
					$iA1 = $aArray[$iPivot_Left]
				$k -= 1
				While $iA1 < $aArray[$k]
					$aArray[$k + 2] = $aArray[$k]
					$k -= 1
				$aArray[$k + 2] = $iA1
				While $iA2 < $aArray[$k]
					$aArray[$k + 1] = $aArray[$k]
				$aArray[$k + 1] = $iA2
			$iLast = $aArray[$iPivot_Right]
			$iPivot_Right -= 1
			While $iLast < $aArray[$iPivot_Right]
				$aArray[$iPivot_Right + 1] = $aArray[$iPivot_Right]
				$iPivot_Right -= 1
			$aArray[$iPivot_Right + 1] = $iLast
	Local $iSeventh = BitShift($iLength, 3) + BitShift($iLength, 6) + 1
	Local $iE1, $iE2, $iE3, $iE4, $iE5, $t
	$iE3 = Ceiling(($iPivot_Left + $iPivot_Right) / 2)
	$iE2 = $iE3 - $iSeventh
	$iE1 = $iE2 - $iSeventh
	$iE4 = $iE3 + $iSeventh
	$iE5 = $iE4 + $iSeventh
	If $aArray[$iE2] < $aArray[$iE1] Then
		$t = $aArray[$iE2]
		$aArray[$iE2] = $aArray[$iE1]
		$aArray[$iE1] = $t
	If $aArray[$iE3] < $aArray[$iE2] Then
		$t = $aArray[$iE3]
		$aArray[$iE3] = $aArray[$iE2]
		$aArray[$iE2] = $t
		If $t < $aArray[$iE1] Then
			$aArray[$iE2] = $aArray[$iE1]
			$aArray[$iE1] = $t
	If $aArray[$iE4] < $aArray[$iE3] Then
		$t = $aArray[$iE4]
		$aArray[$iE4] = $aArray[$iE3]
		$aArray[$iE3] = $t
		If $t < $aArray[$iE2] Then
			$aArray[$iE3] = $aArray[$iE2]
			$aArray[$iE2] = $t
			If $t < $aArray[$iE1] Then
				$aArray[$iE2] = $aArray[$iE1]
				$aArray[$iE1] = $t
	If $aArray[$iE5] < $aArray[$iE4] Then
		$t = $aArray[$iE5]
		$aArray[$iE5] = $aArray[$iE4]
		$aArray[$iE4] = $t
		If $t < $aArray[$iE3] Then
			$aArray[$iE4] = $aArray[$iE3]
			$aArray[$iE3] = $t
			If $t < $aArray[$iE2] Then
				$aArray[$iE3] = $aArray[$iE2]
				$aArray[$iE2] = $t
				If $t < $aArray[$iE1] Then
					$aArray[$iE2] = $aArray[$iE1]
					$aArray[$iE1] = $t
	Local $iLess = $iPivot_Left
	Local $iGreater = $iPivot_Right
	If (($aArray[$iE1] <> $aArray[$iE2]) And ($aArray[$iE2] <> $aArray[$iE3]) And ($aArray[$iE3] <> $aArray[$iE4]) And ($aArray[$iE4] <> $aArray[$iE5])) Then
		Local $iPivot_1 = $aArray[$iE2]
		Local $iPivot_2 = $aArray[$iE4]
		$aArray[$iE2] = $aArray[$iPivot_Left]
		$aArray[$iE4] = $aArray[$iPivot_Right]
			$iLess += 1
		Until $aArray[$iLess] >= $iPivot_1
			$iGreater -= 1
		Until $aArray[$iGreater] <= $iPivot_2
		$k = $iLess
		While $k <= $iGreater
			$iAk = $aArray[$k]
			If $iAk < $iPivot_1 Then
				$aArray[$k] = $aArray[$iLess]
				$aArray[$iLess] = $iAk
				$iLess += 1
			ElseIf $iAk > $iPivot_2 Then
				While $aArray[$iGreater] > $iPivot_2
					$iGreater -= 1
					If $iGreater + 1 = $k Then ExitLoop 2
				If $aArray[$iGreater] < $iPivot_1 Then
					$aArray[$k] = $aArray[$iLess]
					$aArray[$iLess] = $aArray[$iGreater]
					$iLess += 1
					$aArray[$k] = $aArray[$iGreater]
				$aArray[$iGreater] = $iAk
				$iGreater -= 1
			$k += 1
		$aArray[$iPivot_Left] = $aArray[$iLess - 1]
		$aArray[$iLess - 1] = $iPivot_1
		$aArray[$iPivot_Right] = $aArray[$iGreater + 1]
		$aArray[$iGreater + 1] = $iPivot_2
		__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 2, True)
		__ArrayDualPivotSort($aArray, $iGreater + 2, $iPivot_Right, False)
		If ($iLess < $iE1) And ($iE5 < $iGreater) Then
			While $aArray[$iLess] = $iPivot_1
			While $aArray[$iGreater] = $iPivot_2
			$k = $iLess
			While $k <= $iGreater
				$iAk = $aArray[$k]
				If $iAk = $iPivot_1 Then
					$aArray[$iLess] = $iAk
				ElseIf $iAk = $iPivot_2 Then
					While $aArray[$iGreater] = $iPivot_2
						$iGreater -= 1
						If $iGreater + 1 = $k Then ExitLoop 2
					If $aArray[$iGreater] = $iPivot_1 Then
						$aArray[$k] = $aArray[$iLess]
						$aArray[$iLess] = $iPivot_1
						$iLess += 1
						$aArray[$k] = $aArray[$iGreater]
					$aArray[$iGreater] = $iAk
				$k += 1
		__ArrayDualPivotSort($aArray, $iLess, $iGreater, False)
		Local $iPivot = $aArray[$iE3]
			If $aArray[$k] = $iPivot Then
			If $iAk < $iPivot Then
				While $aArray[$iGreater] > $iPivot
				If $aArray[$iGreater] < $iPivot Then
					$aArray[$k] = $iPivot
		__ArrayDualPivotSort($aArray, $iPivot_Left, $iLess - 1, True)
		__ArrayDualPivotSort($aArray, $iGreater + 1, $iPivot_Right, False)
EndFunc   ;==>__ArrayDualPivotSort
Func _ArraySwap(ByRef $aArray, $iIndex_1, $iIndex_2, $bCol = False, $iStart = -1, $iEnd = -1)
	If $bCol = Default Then $bCol = False
	If $iDim_2 = -1 Then ; 1D array so force defaults
		$bCol = False
		$iStart = -1
		$iEnd = -1
	If $iStart > $iEnd Then Return SetError(5, 0, -1)
	If $bCol Then
		If $iIndex_1 < 0 Or $iIndex_2 > $iDim_2 Then Return SetError(3, 0, -1)
		If $iStart = -1 Then $iStart = 0
		If $iEnd = -1 Then $iEnd = $iDim_1
		If $iIndex_1 < 0 Or $iIndex_2 > $iDim_1 Then Return SetError(3, 0, -1)
		If $iEnd = -1 Then $iEnd = $iDim_2
			$vTmp = $aArray[$iIndex_1]
			$aArray[$iIndex_1] = $aArray[$iIndex_2]
			$aArray[$iIndex_2] = $vTmp
			If $iStart < -1 Or $iEnd < -1 Then Return SetError(4, 0, -1)
			If $bCol Then
				If $iStart > $iDim_1 Or $iEnd > $iDim_1 Then Return SetError(4, 0, -1)
				For $j = $iStart To $iEnd
					$vTmp = $aArray[$j][$iIndex_1]
					$aArray[$j][$iIndex_1] = $aArray[$j][$iIndex_2]
					$aArray[$j][$iIndex_2] = $vTmp
				If $iStart > $iDim_2 Or $iEnd > $iDim_2 Then Return SetError(4, 0, -1)
					$vTmp = $aArray[$iIndex_1][$j]
					$aArray[$iIndex_1][$j] = $aArray[$iIndex_2][$j]
					$aArray[$iIndex_2][$j] = $vTmp
EndFunc   ;==>_ArraySwap
Func _ArrayToClip(Const ByRef $aArray, $sDelim_Col = "|", $iStart_Row = -1, $iEnd_Row = -1, $sDelim_Row = @CRLF, $iStart_Col = -1, $iEnd_Col = -1)
	Local $sResult = _ArrayToString($aArray, $sDelim_Col, $iStart_Row, $iEnd_Row, $sDelim_Row, $iStart_Col, $iEnd_Col)
	If ClipPut($sResult) Then Return 1
	Return SetError(-1, 0, 0)
EndFunc   ;==>_ArrayToClip
Func _ArrayToString(Const ByRef $aArray, $sDelim_Col = "|", $iStart_Row = -1, $iEnd_Row = -1, $sDelim_Row = @CRLF, $iStart_Col = -1, $iEnd_Col = -1)
	If $sDelim_Col = Default Then $sDelim_Col = "|"
	If $iStart_Row > $iDim_1 Or $iEnd_Row > $iDim_1 Then Return SetError(3, 0, "")
	Local $sRet = ""
			For $i = $iStart_Row To $iEnd_Row
				$sRet &= $aArray[$i] & $sDelim_Col
			Return StringTrimRight($sRet, StringLen($sDelim_Col))
				For $j = $iStart_Col To $iEnd_Col
					$sRet &= $aArray[$i][$j] & $sDelim_Col
				$sRet = StringTrimRight($sRet, StringLen($sDelim_Col)) & $sDelim_Row
			Return StringTrimRight($sRet, StringLen($sDelim_Row))
EndFunc   ;==>_ArrayToString
Func _ArrayTranspose(ByRef $aArray)
	Switch UBound($aArray, 0)
			Local $aTemp[1][UBound($aArray)]
			For $i = 0 To UBound($aArray) - 1
				$aTemp[0][$i] = $aArray[$i]
			$aArray = $aTemp
			Local $iDim_1 = UBound($aArray, 1), $iDim_2 = UBound($aArray, 2)
			If $iDim_1 <> $iDim_2 Then
				Local $aTemp[$iDim_2][$iDim_1]
						$aTemp[$j][$i] = $aArray[$i][$j]
				$aArray = $aTemp
			Else ; optimimal method for a square grid
				Local $vElement
					For $j = $i + 1 To $iDim_2 - 1
						$vElement = $aArray[$i][$j]
						$aArray[$i][$j] = $aArray[$j][$i]
						$aArray[$j][$i] = $vElement
EndFunc   ;==>_ArrayTranspose
Func _ArrayTrim(ByRef $aArray, $iTrimNum, $iDirection = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If $iEnd = 0 Then $iEnd = $iDim_1
	If $iStart > $iEnd Then Return SetError(3, 0, -1)
	If $iStart < 0 Or $iEnd < 0 Then Return SetError(3, 0, -1)
	If $iStart > $iDim_1 Or $iEnd > $iDim_1 Then Return SetError(3, 0, -1)
			If $iDirection Then
				For $i = $iStart To $iEnd
					$aArray[$i] = StringTrimRight($aArray[$i], $iTrimNum)
					$aArray[$i] = StringTrimLeft($aArray[$i], $iTrimNum)
			If $iSubItem < 0 Or $iSubItem > $iDim_2 Then Return SetError(5, 0, -1)
					$aArray[$i][$iSubItem] = StringTrimRight($aArray[$i][$iSubItem], $iTrimNum)
					$aArray[$i][$iSubItem] = StringTrimLeft($aArray[$i][$iSubItem], $iTrimNum)
EndFunc   ;==>_ArrayTrim
Func _ArrayUnique(Const ByRef $aArray, $iColumn = 0, $iBase = 0, $iCase = 0, $iCount = $ARRAYUNIQUE_COUNT, $iIntType = $ARRAYUNIQUE_AUTO)
	If $iBase = Default Then $iBase = 0
	If $iCount = Default Then $iCount = $ARRAYUNIQUE_COUNT
	If UBound($aArray, $UBOUND_ROWS) = 0 Then Return SetError(1, 0, 0)
	Local $iDims = UBound($aArray, $UBOUND_DIMENSIONS), $iNumColumns = UBound($aArray, $UBOUND_COLUMNS)
	If $iDims > 2 Then Return SetError(2, 0, 0)
	If $iBase < 0 Or $iBase > 1 Or (Not IsInt($iBase)) Then Return SetError(3, 0, 0)
	If $iCase < 0 Or $iCase > 1 Or (Not IsInt($iCase)) Then Return SetError(3, 0, 0)
	If $iCount < 0 Or $iCount > 1 Or (Not IsInt($iCount)) Then Return SetError(4, 0, 0)
	If $iIntType < 0 Or $iIntType > 4 Or (Not IsInt($iIntType)) Then Return SetError(5, 0, 0)
	If $iColumn < 0 Or ($iNumColumns = 0 And $iColumn > 0) Or ($iNumColumns > 0 And $iColumn >= $iNumColumns) Then Return SetError(6, 0, 0)
	If $iIntType = $ARRAYUNIQUE_AUTO Then
		Local $bInt, $sVarType
		If $iDims = 1 Then
			$bInt = IsInt($aArray[$iBase])
			$sVarType = VarGetType($aArray[$iBase])
			$bInt = IsInt($aArray[$iBase][$iColumn])
			$sVarType = VarGetType($aArray[$iBase][$iColumn])
		If $bInt And $sVarType = "Int64" Then
			$iIntType = $ARRAYUNIQUE_FORCE64
			$iIntType = $ARRAYUNIQUE_FORCE32
	ObjEvent("AutoIt.Error", __ArrayUnique_AutoErrFunc)
	Local $oDictionary = ObjCreate("Scripting.Dictionary")
	$oDictionary.CompareMode = Number(Not $iCase)
	Local $vElem, $sType, $vKey, $bCOMError = False
	For $i = $iBase To UBound($aArray) - 1
			$vElem = $aArray[$i]
			$vElem = $aArray[$i][$iColumn]
		Switch $iIntType
			Case $ARRAYUNIQUE_FORCE32
				$oDictionary.Item($vElem) ; Check if key exists - automatically created if not
					$bCOMError = True ; Failed with an Int64, Ptr or Binary datatype
					ExitLoop
			Case $ARRAYUNIQUE_FORCE64
				$sType = VarGetType($vElem)
				If $sType = "Int32" Then
					$bCOMError = True ; Failed with an Int32 datatype
				EndIf ; Create key
				$vKey = "#" & $sType & "#" & String($vElem)
				If Not $oDictionary.Item($vKey) Then ; Check if key exists
					$oDictionary($vKey) = $vElem ; Store actual value in dictionary
			Case $ARRAYUNIQUE_MATCH
				If StringLeft($sType, 3) = "Int" Then
					$vKey = "#Int#" & String($vElem)
					$vKey = "#" & $sType & "#" & String($vElem)
			Case $ARRAYUNIQUE_DISTINCT
				$vKey = "#" & VarGetType($vElem) & "#" & String($vElem)
	Local $aValues, $j = 0
	If $bCOMError Then ; Mismatch Int32/64
		Return SetError(7, 0, 0)
	ElseIf $iIntType <> $ARRAYUNIQUE_FORCE32 Then
		Local $aValues[$oDictionary.Count]
		For $vKey In $oDictionary.Keys()
			$aValues[$j] = $oDictionary($vKey)
			If StringLeft($vKey, 5) = "#Ptr#" Then
				$aValues[$j] = Ptr($aValues[$j])
			$j += 1
		$aValues = $oDictionary.Keys()
		_ArrayInsert($aValues, 0, $oDictionary.Count)
EndFunc   ;==>_ArrayUnique
Func _Array1DToHistogram($aArray, $iSizing = 100)
	If UBound($aArray, 0) > 1 Then Return SetError(1, 0, "")
	$iSizing = $iSizing * 8
	Local $t, $n, $iMin = 0, $iMax = 0, $iOffset = 0
	For $i = 0 To UBound($aArray) - 1
		$t = $aArray[$i]
		$t = IsNumber($t) ? Round($t) : 0
		If $t < $iMin Then $iMin = $t
		If $t > $iMax Then $iMax = $t
	Local $iRange = Int(Round(($iMax - $iMin) / 8)) * 8
	Local $iSpaceRatio = 4
		If $t Then
			$n = Abs(Round(($iSizing * $t) / $iRange) / 8)
			$aArray[$i] = ""
			If $t > 0 Then
				If $iMin Then
					$iOffset = Int(Abs(Round(($iSizing * $iMin) / $iRange) / 8) / 8 * $iSpaceRatio)
					$aArray[$i] = __Array_StringRepeat(ChrW(0x20), $iOffset)
				If $iMin <> $t Then
					$iOffset = Int(Abs(Round(($iSizing * ($t - $iMin)) / $iRange) / 8) / 8 * $iSpaceRatio)
			$aArray[$i] &= __Array_StringRepeat(ChrW(0x2588), Int($n / 8))
			$n = Mod($n, 8)
			If $n > 0 Then $aArray[$i] &= ChrW(0x2588 + 8 - $n)
			$aArray[$i] &= ' ' & $t
	Return $aArray
EndFunc   ;==>_Array1DToHistogram
Func __Array_StringRepeat($sString, $iRepeatCount)
	$iRepeatCount = Int($iRepeatCount)
	If StringLen($sString) < 1 Or $iRepeatCount <= 0 Then Return SetError(1, 0, "")
	Local $sResult = ""
	While $iRepeatCount > 1
		If BitAND($iRepeatCount, 1) Then $sResult &= $sString
		$sString &= $sString
		$iRepeatCount = BitShift($iRepeatCount, 1)
	Return $sString & $sResult
EndFunc   ;==>__Array_StringRepeat
Func __Array_ExeterInternal(ByRef $aArray, $iStart, $iSize, $sDelimiter, ByRef $aIdx, ByRef $aResult, ByRef $iCount)
	If $iStart == $iSize - 1 Then
		If $sDelimiter <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], StringLen($sDelimiter))
		Local $iTemp
		For $i = $iStart To $iSize - 1
			$iTemp = $aIdx[$i]
			$aIdx[$i] = $aIdx[$iStart]
			$aIdx[$iStart] = $iTemp
			__Array_ExeterInternal($aArray, $iStart + 1, $iSize, $sDelimiter, $aIdx, $aResult, $iCount)
			$aIdx[$iStart] = $aIdx[$i]
			$aIdx[$i] = $iTemp
EndFunc   ;==>__Array_ExeterInternal
Func __Array_Combinations($iN, $iR)
	Local $i_Total = 1
	For $i = $iR To 1 Step -1
		$i_Total *= ($iN / $i)
		$iN -= 1
	Return Round($i_Total)
EndFunc   ;==>__Array_Combinations
Func __Array_GetNext($iN, $iR, ByRef $iLeft, $iTotal, ByRef $aIdx)
	If $iLeft == $iTotal Then
		$iLeft -= 1
	Local $i = $iR - 1
	While $aIdx[$i] == $iN - $iR + $i
		$i -= 1
	$aIdx[$i] += 1
	For $j = $i + 1 To $iR - 1
		$aIdx[$j] = $aIdx[$i] + $j - $i
	$iLeft -= 1
EndFunc   ;==>__Array_GetNext
Func __Array_MinMaxIndex(Const ByRef $aArray, $iCompNumeric, $iStart, $iEnd, $iSubItem, $fuComparison) ; Always swapped the comparison params around e.g. it was for min 100 > 1000 whereas 1000 < 100 makes more sense in a min function.
	If $iCompNumeric <> 1 Then $iCompNumeric = 0
	If $iDim_1 < 0 Then Return SetError(1, 0, -1)
	If $iEnd = -1 Then $iEnd = $iDim_1
	If $iStart = -1 Then $iStart = 0
	If $iStart < -1 Or $iEnd < -1 Then Return SetError(3, 0, -1)
	If $iDim_1 < 0 Then Return SetError(5, 0, -1)
	Local $iMaxMinIndex = $iStart
			If $iCompNumeric Then
					If $fuComparison(Number($aArray[$i]), Number($aArray[$iMaxMinIndex])) Then $iMaxMinIndex = $i
					If $fuComparison($aArray[$i], $aArray[$iMaxMinIndex]) Then $iMaxMinIndex = $i
			If $iSubItem < 0 Or $iSubItem > UBound($aArray, $UBOUND_COLUMNS) - 1 Then Return SetError(6, 0, -1)
					If $fuComparison(Number($aArray[$i][$iSubItem]), Number($aArray[$iMaxMinIndex][$iSubItem])) Then $iMaxMinIndex = $i
					If $fuComparison($aArray[$i][$iSubItem], $aArray[$iMaxMinIndex][$iSubItem]) Then $iMaxMinIndex = $i
	Return $iMaxMinIndex
EndFunc   ;==>__Array_MinMaxIndex
Func __Array_GreaterThan($vValue1, $vValue2)
	Return $vValue1 > $vValue2
EndFunc   ;==>__Array_GreaterThan
Func __Array_LessThan($vValue1, $vValue2)
	Return $vValue1 < $vValue2
EndFunc   ;==>__Array_LessThan
Func __ArrayUnique_AutoErrFunc()
EndFunc   ;==>__ArrayUnique_AutoErrFunc