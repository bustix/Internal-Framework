;
; dump variables
;

; sample data

;~ Local $var = ObjCreate("shell.application")
;~ Local $s = DllStructCreate("dword;byte[3];dword[14]")
;~ DllStructSetData($s, 1, 0xdeadbeef)
;~ DllStructSetData($s, 2, 0x67, 1)
;~ DllStructSetData($s, 2, 0x78, 2)
;~ DllStructSetData($s, 2, 0x89, 3)
;~ DllStructSetData($s, 3, 0x89674523, 14)
;~ Local $ar2[2][3] = [[0,1,2], [3,4,5]]
;~ Local $ar[7] = ["1", 2, Binary("0x12345678"), WinGetHandle("[active]"), $s, _
;~ 	Binary("0x12349999999999999999999999999999999999988888888888888888888888888888888888888888888888888888888888888888889999995678"), $ar2]
;~ Local $array[16] = ["abc def", 123456789012345, "129", 129, 119.0 + 3 * 3.3333333333333333333333, 129.0000000001, _
;~ 	1.29e134, Default, 1.0/0.0, Null, $ar, (1 = 1.0), Ptr(-12), Ptr(123456) - Ptr(123444), 0/0, _
;~ 	"aaaaaaaafvsdnlodvgnlsdvnlovsnlodvsnlosdvnldvndvnlodnldfnoqdfnlodfnoldfnlodvfnlodvfnoldvnlodnlovdnlodvnldvnlvdnlozzzzzzzzz"]

;~ ; usage
;~ ConsoleWrite("$var is: " & _VarDump($var) & @LF & @LF)
;~ ConsoleWrite("$array is: " & _VarDump($array) & @LF)



Func _VarDump(ByRef $vVar, $sIndent = '')
	Local $ret, $len
    Select
		Case IsDllStruct($vVar)
			$len = DllStructGetSize($vVar)
			Local $bstruct = DllStructCreate("byte[" & $len & "]", DllStructGetPtr($vVar))
			$ret = 'Struct(' & $len & ') @:' & Hex(DllStructGetPtr($vVar)) & ' = '
			If $len <= 32 Then
				Return($ret & DllStructGetData($bstruct, 1))
			Else
				Return($ret & BinaryMid(DllStructGetData($bstruct, 1), 1, 16) & ' ... ' & StringTrimLeft(BinaryMid(DllStructGetData($bstruct, 1), $len - 15, 16), 2))
			EndIf
        Case IsArray($vVar)
			Local $iSubscripts = UBound($vVar, 0)
			Local $sDims = 'Array'
			$iSubscripts -= 1
			For $i = 0 To $iSubscripts
				$sDims &= '[' & UBound($vVar, $i + 1) & ']'
			Next
            Return $sDims & @CRLF & _VarDumpArray($vVar, $sIndent)
        Case IsBinary($vVar)
			$len = BinaryLen($vVar)
			$ret = 'Binary(' & BinaryLen($vVar) & ') = '
			If $len <= 32 Then
				Return($ret & $vVar)
			Else
				Return($ret & BinaryMid($vVar, 1, 16) & ' ... ' & StringTrimLeft(BinaryMid($vVar, $len - 15, 16), 2))
			EndIf
        Case IsBool($vVar)
            Return 'Boolean ' & $vVar
        Case IsFloat($vVar) Or (IsInt($vVar) And VarGetType($vVar) = "Double")
            Return 'Double ' & $vVar
        Case IsHWnd($vVar)
            Return 'HWnd ' & $vVar
        Case IsInt($vVar)
            Return "Integer(" & StringRight(VarGetType($vVar), 2) & ') ' & $vVar
        Case IsKeyword($vVar)
			$ret = 'Keyword '
			If $vVar = Null Then
            Return $ret & 'Null'
		Else
            Return $ret & $vVar
		EndIf
        Case IsPtr($vVar)
            Return 'Pointer @:' & StringTrimLeft($vVar, 2)
        Case IsObj($vVar)
            Return 'Object ' & ObjName($vVar)
        Case IsString($vVar)
			$len = StringLen($vVar)
			$ret = 'String(' & $len & ") '"
			If $len <= 64 Then
				Return $ret & $vVar & "'"
			Else
				Return($ret & StringMid($vVar, 1, 32) & ' ... ' & StringTrimLeft(StringMid($vVar, $len - 31, 32), 2)) & "'"
			EndIf
        Case Else
            Return 'Unknown ' & $vVar
    EndSelect
EndFunc

Func _VarDumpArray(ByRef $aArray, $sIndent = @TAB)
    Local $sDump
    Local $sArrayFetch, $sArrayRead, $bDone
    Local $iSubscripts = UBound($aArray, 0)
    Local $aUBounds[$iSubscripts]
    Local $aCounts[$iSubscripts]
    $iSubscripts -= 1
    For $i = 0 To $iSubscripts
        $aUBounds[$i] = UBound($aArray, $i + 1) - 1
        $aCounts[$i] = 0
    Next
    $sIndent &= @TAB
    While 1
        $bDone = True
        $sArrayFetch = ''
        For $i = 0 To $iSubscripts
            $sArrayFetch &= '[' & $aCounts[$i] & ']'
            If $aCounts[$i] < $aUBounds[$i] Then $bDone = False
        Next

        $sArrayRead = Execute('$aArray' & $sArrayFetch)
        If @error Then
            ExitLoop
        Else
            $sDump &= $sIndent & $sArrayFetch & ' => ' & _VarDump($sArrayRead, $sIndent)
            If Not $bDone Then
                $sDump &= @CRLF
            Else
                Return $sDump
            EndIf
        EndIf

        For $i = $iSubscripts To 0 Step -1
            $aCounts[$i] += 1
            If $aCounts[$i] > $aUBounds[$i] Then
                $aCounts[$i] = 0
            Else
                ExitLoop
            EndIf
        Next
    WEnd
EndFunc
