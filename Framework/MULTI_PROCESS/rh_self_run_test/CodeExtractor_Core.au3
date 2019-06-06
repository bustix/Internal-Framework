#include-once
; REQUIRED!
__CodeExtractor_ADD_WRAPPER_INFORMATIONS()
;#AutoIt3Wrapper_Res_File_Add ; <- maybe add all includes here in an automatic parse-function...

; CONSTANTS
Global Const $__CODEEXTRACTOR_CONST_REPLACE_TEXT 	= "[##%R!E)P]L[A(C!E%##]"


; CONSTANTS FOR THE NEW ERROR OBJECT LATER
Global Const $__OBJECT_ERROR_MANAGER_NO_ERROR_IN_OBJECT__ = "No Error in Object"
Global Const $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT = "[##!R§E$P%L[A%C§E!##]"

; WRAPPER INCLUDES ADD
Func __CodeExtractor_ADD_WRAPPER_INFORMATIONS()
	#AutoIt3Wrapper_Res_File_Add = $test
EndFunc

; CODEEXTRACTOR METHODS
	Func _CodeExtractor_SaveSourceToFile($oSelf, $p, $f, $d=1)
		If Not (StringRight($p,1)="\") Then $p &= "\"
		If ($d = 1) Then FileDelete($p&$f)
		FileWrite($p & $f, $oSelf.getSource())
		If @error Then Return $oSelf._setError("Error while creating the file: " & @CRLF & $p & $f, @error, @extended)
		Return 1
		;_Resource_SaveToFile($p & $f, $oSelf.getSource())
	EndFunc

	Func _CodeExtractor_ExtractSource($oSelf, $w = '999');, $RC_DATA = 10)
		If Not @Compiled Then Return $oSelf._setError("To extract the code you have to compile the script first / Otherwise there is nothing to extract.", -1, -1)
		Local $g =  _GetSavedSource(Default)
		Return $oSelf.setSource($g)
	EndFunc

	Func _CodeExtractor_SetCurrentFileSavePath($oSelf, $p ) ;entire path
		$oSelf._CodeExtractFilePath = $p
	EndFunc

	Func _CodeExtractor_GetCurrentFileSavePath($oSelf)
		Return $oSelf._CodeExtractFilePath
	EndFunc

	Func __CodeExtractor_SetFileName($oSelf, $n )
		$oSelf._FileName = $n
	EndFunc

	Func __CodeExtractor_GetFileName($oSelf)
		Return $oSelf._FileName
	EndFunc

	Func _CodeExtractor_SetCurrentSource($oSelf, $s )
		$oSelf._SourceCode = $s
	EndFunc

	Func _CodeExtractor_GetCurrentSource($oSelf)
		Return $oSelf._SourceCode
	EndFunc

	Func _CodeExtractor_destroyAll($oSelf)
		Return _Resource_DestroyAll()
	EndFunc


;get/set error propertys
	Func _CodeExtractor_SetError($oSelf,$t,$er=@error,$ex=@extended)
		If ($oSelf._errorCount = "") Then $oSelf._errorCount = 0
		If (($er <> 0) Or ($ex <> 0)) Then $oSelf._incError()
		$oSelf._errorText = $t
		$oSelf._errorNum = $er
		$oSelf._errorExt = $ex
		Return $t
	EndFunc
	Func _CodeExtractor_GetError($oSelf, $a="", $e= "")
		Local $Error

	;no error
		$Error = "!+[NO ERROR]" & @CRLF & $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT & @CRLF & "-	text:		" & $__OBJECT_ERROR_MANAGER_NO_ERROR_IN_OBJECT__ & @CRLF & "!+[----------]" & @CRLF & @CRLF
		If (($e <> "") And ($a <> "")) Then
			$Error = StringReplace( $Error, $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT, "-	" & StringLeft($a,10) & ":	[" & $e & "]", 0, 1)
		Else
			$Error = StringReplace( $Error, $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT, "", 0, 1)
		EndIf
		If (($oSelf._getErrorNum = "") And ($oSelf._getErrorText() = "") And ($oSelf._getErrorExt() = "")) Then Return $Error

	;error
		$Error = "!+[LAST ERROR]" & @CRLF & _
							$__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT & @CRLF & _
							"-	text:		[" 	& $oSelf._getErrorText() & "]"	& 	@CRLF & _
							"-	@error:		[" 	& $oSelf._getErrorNum() & "]"	& 	@CRLF & _
							"-	@extended:	[" 	& $oSelf._getErrorExt() & "]"	&	@CRLF & _
							"-	error count:	[" 	& $oSelf._errorCount & "]"	&	@CRLF & _
							"!+[----------]" & @CRLF & @CRLF

		Local $x
		If (($e <> "") And ($a <> "")) Then
			$Error = StringReplace( $Error, $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT, "-	" & $a & ":	[" & $e & "]", 0, 1)
		Else
			$Error = StringReplace( $Error, $__OBJECT_ERROR_MANAGER_CONST_REPLACE_TEXT, "", 0, 1)
		EndIf

		Return $Error
	EndFunc
	Func _CodeExtractor_GetErrorText($oSelf)
		Return $oSelf._errorText
	EndFunc
	Func _CodeExtractor_GetErrorNum($oSelf)
		Return $oSelf._errorNum
	EndFunc
	Func _CodeExtractor_GetErrorExt($oSelf)
		Return $oSelf._errorExt
	EndFunc
	Func _CodeExtractor_IncError($oSelf)
		$oSelf._errorCount = $oSelf._errorCount + 1
		Return
	EndFunc
