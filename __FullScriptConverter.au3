
#include <File.au3>
#include <Array.au3>
#include <String.au3>

Local $scriptSearchFolderName	= 	"Framework"
Local $pathMainScriptFull		= 	@ScriptDir & "\Internal Framework.au3"
Local $excludes					=	"Framework\#.DEPRECATED|" & _
									"Framework\#unused yet|" & _
									"Framework\AutoItObject\Examples|" & _
									"Framework\AutoItObject\Interfaces|" & _
									"Framework\AutoItObject\Source|" & _
									"Framework\MULTI_PROCESS\thread.au3|" & _
									"Framework\MULTI_PROCESS\test|" & _
									"Framework\MULTI_PROCESS\SingleTaskVsMultiTask(With-ping)|" & _
									"Framework\MULTI_PROCESS\rh_self_run_test|" & _
									"Framework\MULTI_PROCESS\Examples|" & _
									"Framework\MULTI_PROCESS\BackUp|" & _
									"Framework\MULTI_PROCESS\Autoit|" & _
									"Framework\MULTI_PROCESS\Ascend4nt|" & _
									"Framework\MULTI_PROCESS\blub|"


Local $out = _findAndCombineAllIncludesToFile( $pathMainScriptFull, $scriptSearchFolderName, Default, Default, Default, $excludes, Default, Default, True)
ConsoleWrite("+[RESULT]" & @CRLF & "+total time:		" & @error & "s" & @CRLF & "+found+merged:		" & @extended & @CRLF & "!found+notmerged:	" & $out[0][0] & @CRLF & @CRLF )



ConsoleWrite( "![NOTFOUND]" & @CRLF )
For $i = 1 To $out[0][0]

	ConsoleWrite( "-" & $out[$i][1] & @CRLF )

Next




Func _findAndCombineAllIncludesToFile( $mainScriptFullPath, $scriptSearchFolderNam=Default, $outPutScriptName=Default, $defaultIncludesPath=Default, $searchmask=Default, $EXCLUDE_FILES=Default, $EXCLUDE_BEFORE_SEARCH=Default, $EXCLUDE_FILES_DELIM=Default, $OVERWRITE=False )

	#Region	---	FUNCTION HEADER AND DECLARATIONS	---
		Local $AutoItExe 			= @AutoItExe, $mainIncludes, $userIncludesq, $userIncludes, $fileread, $includeCarrier, $includeNameCarrier, $aTime = TimerInit(), $includeNameFileFoundCarrier, $curName

		Local $scriptMainDir		= StringLeft		($mainScriptFullPath,	StringInStr($mainScriptFullPath,"\",0,-1))
		Local $mainScriptName		= StringTrimLeft	($mainScriptFullPath,	StringInStr($mainScriptFullPath,"\",0,-1))
		If ($scriptSearchFolderNam	= Default)	Then	$scriptSearchFolderNam	=			$scriptMainDir
		If Not (StringRight($scriptSearchFolderNam,1)="\") 							Then 	$scriptSearchFolderNam &= "\"
		If ($EXCLUDE_FILES			= Default)	Then	$EXCLUDE_FILES			=	False										; MAINSCRIPTPATH + SCRIPTSEARCHFOLDER + EXCLUDE_FILES
		If (($EXCLUDE_FILES <> False) And (StringRight($EXCLUDE_FILES,1)="|"))		Then	$EXCLUDE_FILES = StringTrimRight($EXCLUDE_FILES,1)			; safety check
		If ($EXCLUDE_BEFORE_SEARCH	= Default)	Then	$EXCLUDE_BEFORE_SEARCH	=	True
		If ($EXCLUDE_FILES_DELIM	= Default) 	Then	$EXCLUDE_FILES_DELIM	=	"|"
		If ($searchmask				= Default) 	Then	$searchmask				= 	"*.au3"
		If ($defaultIncludesPath 	= Default) 	Then	$defaultIncludesPath	= 	StringLeft($AutoItExe,		StringInStr($AutoItExe,"\",0,-1)-1) 	&	"\Include\"
		If ($outPutScriptName 		= Default) 	Then	$outPutScriptName 		= 	StringLeft($mainScriptName,	StringInStr($mainScriptName,".",0,-1)-1)&	"_PLUS_ALL_INCLUDES.au3"
		Local $outPutScriptPath		= $scriptMainDir 	& $outPutScriptName
		Local $allScriptFiles		= _FileListToArrayRec( $scriptMainDir & $scriptSearchFolderNam, $searchmask, $FLTAR_FILES, 1, 0, 1 )
		Local $defaultIncludes 		= _FileListToArrayRec( $defaultIncludesPath, $searchmask, $FLTAR_FILES )

		ConsoleWrite( "![Starting conversion with following parameters]" & @CRLF & _
						"- Main Script Name: 	" & $mainScriptName & @CRLF & _
						"- Main Script Dir: 	" & $scriptMainDir & @CRLF & _
						"- Search Folder Name:	" & $scriptSearchFolderNam & @CRLF & _
						"- Default Includes P:	" & $defaultIncludesPath & @CRLF & _
						"- Output Script Name:	" & $outPutScriptName & @CRLF & _
						"- Search Mask:		" & $searchmask & @CRLF & _
						"- Exclude:		" & $EXCLUDE_FILES & @CRLF & _
						"- Exclude b4 search:	" & $EXCLUDE_BEFORE_SEARCH & @CRLF & _
						"- Exclude delim:	" & $EXCLUDE_FILES_DELIM & @CRLF & @CRLF )
	#EndRegion
;read all files and gather all includes needet
	Local $excluder=$EXCLUDE_FILES, $found_trigger=False, $filetrigger=Default, $curAtt, $stmp, $fsP, $tex
	If StringInStr($excluder,$EXCLUDE_FILES_DELIM) Then $excluder = StringSplit($EXCLUDE_FILES,$EXCLUDE_FILES_DELIM)
	For $i = 1 To $allScriptFiles[0]
		$fsP = $scriptMainDir & $scriptSearchFolderNam & $allScriptFiles[$i]
;$found_trigger = False
		If IsArray($excluder) Then ;more than 1 exlude to check for
			For $c = 1 To $excluder[0]
				$tex = $scriptMainDir & $excluder[$c]
				$curAtt = FileGetAttrib($tex)
				If (($curAtt = "") And Not (FileExists($tex))) Then ConsoleWrite( "![ERROR]: [" & $tex & "] is not existend. Please check filepath." & @CRLF )
				If ($curAtt = "D") Then ;directory - to compare directory we have to remove the name of the current file, cause the search is only returning files.
					$stmp = StringLeft($fsP,StringLen($tex))
				Else ; its no directoy
					$stmp = $fsP;file
				EndIf
				If (StringRight($stmp,1)="\") Then 	$tmp 	= StringTrimRight($stmp,1)			; just for
				If (StringRight($tex,1)="\") Then 	$tex 	= StringTrimRight($tex,1)	; safety
				If ($stmp = $tex) Then
					$found_trigger = True
				Else
					$found_trigger = False
				EndIf
;If $found_trigger Then ConsoleWrite( "+[(i:"&$i&"/"&$allScriptFiles[0]&")(c:"&$c&"/"&$excluder[0]&")FOUND_TRIGGER = " & $found_trigger & "][CURRENT_ATTRIBUTE = " & $curAtt & "]" & @CRLF &  "*$allScriptFiles:	" & $fsP & @CRLF & "-STMP:			" & $stmp & @CRLF & "-EXCLUDER:		" & $tex & @CRLF)
				If ($found_trigger) Then ExitLoop
			Next
		Else ; only 1 exclude
			$tex = $scriptMainDir & $excluder
			$curAtt = FileGetAttrib($tex)
			If ($curAtt = "D") Then ;directory - to compare directory we have to remove the name of the current file, cause the search is only returning files.
				$stmp = StringLeft($fsP,	StringInStr($fsP,"\",0,-1))
			Else ; its no directoy
				$stmp = $fsP;file
			EndIf
			If (StringRight($stmp,1)="\") Then 	$stmp	= StringTrimRight($stmp,1)	; just for
			If (StringRight($tex,1)="\") Then 	$tex 	= StringTrimRight($tex,1)	; safety
			If ($tex=$stmp) Then $found_trigger = True
		EndIf
		If ($found_trigger) Then ;skip - exclude this
;ConsoleWrite( "![TRIGGER] - skipping: " & $i  & " (found_trigger:"&$found_trigger&")" & @CRLF & "- " & $stmp& @CRLF & "- " & $tex & @CRLF )
			$found_trigger = False ; reset trigger & do nothing
		Else ; no skip - continue
			$curPath 	= $fsP;$scriptMainDir & $scriptSearchFolderNam & $allScriptFiles[$i]
			$curName	= StringTrimLeft( $curPath, StringInStr($fsP,"\",0,-1) )
			$fileread = FileRead( $curPath )
		#Region		---  FILTERING INCLUDES  ---

				Local $a, $exp = "#include (?:<[^>]+>|['][^']+[']|[""][^""]+"")"
				$a = StringRegExp($fileread, $exp, 3)
				;ConsoleWrite( "regexp: " & $a & @CRLF & "@error: " & @error & @CRLF & "@extended: " & @extended & @CRLF )
			Local $t = "", $e = ""
			For $regC = 0 To UBound($a)-1

				If (StringInStr($a[$regC],'"') Or StringInStr($a[$regC],"'")) Then ; user include

					$t = _StringBetween( $a[$regC], '"', '"')
					If StringInStr($a[$regC],"'") Then $t = _StringBetween( $a[$regC], "'", "'")
					If (StringInStr($allScriptFiles[$i], "\")) Then $e = StringLeft($allScriptFiles[$i],StringInStr($allScriptFiles[$i],"\",0,-1))
					If IsArray($t) Then
						$t = $t[0]
						$includeCarrier 	&= $scriptMainDir & $scriptSearchFolderNam & $e & $t & "|"
						$includeNameCarrier &= $t & "|"
						$includeNameFileFoundCarrier &= StringTrimLeft( $t, StringInStr($t,"\",0,-1) ) & "|"
					EndIf
				ElseIf (StringInStr($a[$regC], "<") And StringInStr($a[$regC],">")) Then ; main autoit includes

					$t = _StringBetween( $a[$regC], '<', '>')
					If IsArray($t) Then
						$t = $t[0]
						$includeCarrier 	&= $defaultIncludesPath & $t & "|"
						$includeNameCarrier &= $t & "|"
						$includeNameFileFoundCarrier &= StringTrimLeft( $t, StringInStr($t,"\",0,-1) ) & "|"
					EndIf
				EndIf
			Next

		#EndRegion

		#Region 	--- DEPRECATED	---	 (FILTERING INCLUDES)
#cs
			$mainIncludes	= _StringBetween( $fileread, '#include <', '>' ) ; main autoit includes
			$userIncludesq	= _StringBetween( $fileread, '#include "', '"' ) ; user includes "
			$userIncludes	= _StringBetween( $fileread, "#include '", "'" ) ; user includes '
			Local $t
			If (StringInStr($allScriptFiles[$i], "\")) Then $t = StringLeft($allScriptFiles[$i],StringInStr($allScriptFiles[$i],"\",0,-1))
			If IsArray($mainIncludes) Then
				For $e = 1 To UBound($mainIncludes)-1
					$includeCarrier 	&= $defaultIncludesPath & $mainIncludes[$e] & "|"
					$includeNameCarrier &= $mainIncludes[$e] & "|"
				Next
			EndIf
			If IsArray($userIncludesq) Then
				For $f = 1 To UBound($userIncludesq)-1
					$includeCarrier 	&= $scriptMainDir & $scriptSearchFolderNam & $t & $userIncludesq[$f] & "|"
					$includeNameCarrier &= $userIncludesq[$f] & "|"
				Next
			EndIf
			If IsArray($userIncludes) Then
				For $x = 1 To UBound($userIncludes)-1
					$includeCarrier 	&= $scriptMainDir & $scriptSearchFolderNam & $t & $userIncludes[$x] & "|"
					$includeNameCarrier &= $userIncludes[$x] & "|"
				Next
			EndIf

#ce
		#EndRegion
		EndIf
	Next

;remove too much charackters from right side
	If (StringRight( $includeCarrier, 1 ) = "|") 				Then $includeCarrier 				= StringTrimRight($includeCarrier,1)
	If (StringRight( $includeNameFileFoundCarrier, 1 ) = "|") 	Then $includeNameFileFoundCarrier 	= StringTrimRight($includeNameFileFoundCarrier,1)

;remove duplicates
	Local $includeCarrierArray 		= 	StringSplit( $includeCarrier, "|" )
	Local $includeFFCarrierArray 	= 	StringSplit( $includeNameFileFoundCarrier, "|" )
	;ConsoleWrite( "! INCLUDE CARRIER	: " & StringReplace($includeCarrier,"|",@CRLF) & @CRLF & "+ INCLUDE FFCARRIER	: " & $includeNameFileFoundCarrier & @CRLF )
	;MsgBox(0, UBound($includeCarrierArray), UBound($includeFFCarrierArray))

	_ArrayDisplay($includeCarrierArray)
	$myarrayunique = __removeAllDuplicatesArr($includeCarrierArray)
	_ArrayDisplay($includeCarrierArray)

	$includeCarrierArray			=	_ArrayUnique($includeCarrierArray,0,1)
	;$includeFFCarrierArray			=	_ArrayUnique($includeFFCarrierArray,0,1)

	;ConsoleWrite( "! INCLUDE CARRIER	: " & StringReplace($includeCarrier,"|",@CRLF) & @CRLF & "+ INCLUDE FFCARRIER	: " & StringReplace($includeNameFileFoundCarrier,"|",@CRLF) & @CRLF )
	;_ArrayDisplay($includeCarrierArray)
	;_ArrayDisplay($includeFFCarrierArray)

	;MsgBox(0, UBound($includeCarrierArray), UBound($includeFFCarrierArray))
	Exit

;create a path carrier for the include paths for not found includes
	Local $path_carrier = $includeCarrierArray
	For $i = 1 To $path_carrier[0]
		$path_carrier[$i] = StringLeft($path_carrier[$i],StringInStr($path_carrier[$i],"\",0,-1)) ; get all paths and store em
	Next
	$path_carrier = _ArrayUnique($path_carrier,0,1)

;read all files to buffer
	Local $r, $szBuffer = FileRead($mainScriptFullPath)&@CRLF&@CRLF, $h, $s, $rep=_ArrayUnique(StringSplit($includeNameCarrier,"|")), $prefix = '#include', $count=0, $nfc=0
	Dim	$notfoundcount[$rep[0]+1][2]
	For $i = 1 To $includeCarrierArray[0]
		If FileExists($includeCarrierArray[$i]) Then
			$h	=	FileOpen($includeCarrierArray[$i],0)
			$s	=	FileGetSize($includeCarrierArray[$i])
			$r	=	FileRead($h,$s)
			FileClose($h)
			$r	=	StringReplace($r, '#include-once', '' )
;			For $x = 1 To $rep[0]
;				$r	=	StringReplace($r, $prefix & ' <'&$rep[$x]&'>', '', 0, 1 )
;ConsoleWrite( "replace 1 : " & @error & " / " & @extended & " - " & $prefix & ' <'&$rep[$x]&'>' & @CRLF )
;				$r	=	StringReplace($r, $prefix & ' "'&$rep[$x]&'"', '', 0, 1  )
;ConsoleWrite( "replace 2 : " & @error & " / " & @extended & " - " & $prefix & ' "'&$rep[$x]&'"' & @CRLF )
;				$r	=	StringReplace($r, $prefix & " '"&$rep[$x]&"'", '', 0, 1  )
;ConsoleWrite( "replace 3 : " & @error & " / " & @extended & " - " & $prefix & " '"&$rep[$x]&"'" & @CRLF )
;			Next
			$szBuffer &= "; ### INCLUDE FROM :	" & $includeCarrierArray[$i] & @CRLF & @CRLF & $r & @CRLF
		Else
			$nfc += 1
			$notfoundcount[$nfc][0] = $nfc
			$notfoundcount[$nfc][1] = $includeCarrierArray[$i] & "	:[ - HAS BEEN INCLUDED IN FILE	- ]:	" & $includeFFCarrierArray[$i] ; not found - try to search again in all other available dir's

			;MsgBox(0,"not found:", $notfoundcount[$nfc][1] & @CRLF & "searching now in: " &@CRLF & @CRLF & _ArrayToString($path_carrier,@CRLF) )
			Local $tmp_not_found_name = StringTrimLeft($includeCarrierArray[$i],StringInStr($includeCarrierArray[$i],"\",0,-1))

			For $search_other_paths = 1 To $path_carrier[0]

				;MsgBox(0,FileExists( $path_carrier[$search_other_paths] & "" & $tmp_not_found_name),  $path_carrier[$search_other_paths] & "" & $tmp_not_found_name )

				If FileExists( $path_carrier[$search_other_paths] & "" & $tmp_not_found_name ) Then ;found

					$notfoundcount[$nfc][1] = $includeCarrierArray[$i] & "	:[ - HAS BEEN FOUND IN - ]:	" & $path_carrier[$search_other_paths]
					ExitLoop
				EndIf

			Next



			$szBuffer &= "; ### INCLUDE FROM : 	" & $includeCarrierArray[$i] & @CRLF & @CRLF & ";<FILE NOT FOUND>" & @CRLF & @CRLF
;~retry? with swapped pref
		EndIf
	Next
	ReDim $notfoundcount[$nfc+2][2]
	$notfoundcount[0][0] = $nfc
	$count = $includeCarrierArray[0]

;clean code from includes, comments and regions
#Region --- new method
	Local $temp_buffer = StringSplit($szBuffer,@CRLF), $cur_line_stripped,$count=0

	For $i = 1 To $temp_buffer[0]
		$cur_line_stripped = StringStripWS($temp_buffer[$i],8)
		$cur_line_stripped = StringLower(StringReplace($cur_line_stripped,@TAB,""))
		If StringLeft($cur_line_stripped,1)=";" Then ;remove line
			$temp_buffer[$i] = ""
		Else
			If StringLeft($cur_line_stripped,8)="#include" Then
				$temp_buffer[$i] = ";" & $temp_buffer[$i] & "; REMOVED INCLUDE"
				$count += 1
			EndIf
		EndIf
	Next
	Dim $nBuf = $temp_buffer
	Local $c=0
	For $i = 1 To $nBuf[0]
		If ($temp_buffer[$i] <> "") Then
			$nBuf[$c] = $temp_buffer[$i]
			$c += 1
		EndIf
	Next
	ReDim $nBuf[$c+1]
	$temp_buffer = ""
	$szBuffer = $nBuf
	$szBuffer = _ArrayToString($szBuffer, @CRLF, 1)
#EndRegion

#Region --- old method
#cs
	Local $results, $tmp
	$results	= _StringBetween( $szBuffer, '#include <', '>' ) ; main autoit includes
	If IsArray($results) Then
		$tmp		&= _ArrayToString( __addToEach($results, "#include <", ">" ), -1, 0 )
		$count 		+= UBound($results)-1
	EndIf
;If IsArray($results) Then _ArrayDisplay( $results, "1" )
	$results	= _StringBetween( $szBuffer, '#include "', '"' ) ; user includes "
	If IsArray($results) Then
		$tmp		&= _ArrayToString( __addToEach($results, '#include "', '"' ), -1, 0 )
		$count 		+= UBound($results)-1
	EndIf
;If IsArray($results) Then _ArrayDisplay( $results, "2" )
	$results	= _StringBetween( $szBuffer, "#include '", "'" ) ; user includes '
	If IsArray($results) Then
		$tmp		&= _ArrayToString( __addToEach($results, "#include '", "'" ), -1, 0 )
		$count 		+= UBound($results)-1
	EndIf
;If IsArray($results) Then _ArrayDisplay( $results, "3" )
;Exit
#ce
#EndRegion


#cs

	Local $aCS=StringSplit($szBuffer,"#cs",1), $aCE=StringSplit($szBuffer,"#ce",1)
	If Not ($aCS[0] = $aCE[0]) Then Return SetError(-2,-2,"Error! unbalanced #comments")

	Local $check, $begin

	$check = StringSplit($szBuffer,"#cs",1)
	$begin = $check[1]
	;While Not @error

		If Not IsArray($check) Then Return SetError(-2,-2,"Error - should not happen?" )

		Local $full_string
		$full_string = _ArrayToString($check,@CRLF,2)

		Local $tmp
		Local $count = 0
		Local $aCE = StringSplit($full_string, "#ce", 1)
		Local $encounter = $aCE[0]

		$tmp = StringSplit($aCE[1], "#cs", 1 )
		$count = $tmp[0]+1 ; $tmp[0] OPEN CS - +1 cause the first one -.-

		Local $remove = ""
		For $i = 1 To $count
			;$remove &= $aCE[$i] & @CRLF
			$szBuffer = StringReplace($szBuffer, $aCE[$i],"",0,1)

		Next
		#cs
		While 1

			For $i = 1 To $count
				$remove &= $aCE[$i] & @CRLF
			Next

			$full_string = _ArrayToString($aCS, @CRLF, $count)


		WEnd
#ce

		;ConsoleWrite("!REMOVE:" &@CRLF& $remove )

		Local $from_to 		= StringSplit($remove,@CRLF,1)
		Local $current_file = StringSplit($szBuffer,@CRLF,1)
		$check = ""

		For $i = 1 To $current_file[0]

			For $x = 1 To $from_to[0]
				If ($current_file[$i] = $from_to[$x]) Then
					;ConsoleWrite("HIT")
					$current_file[$i] = ""
				EndIf
			Next

			$check &= $current_file[$i] & @CRLF
		Next


		;ConsoleWrite( $check )

		$check = __removeAllSpecific($check,";")

		;ConsoleWrite( $check )

		$check = StringSplit($check, @CRLF, 1)




	;WEnd

	;ConsoleWrite($szBuffer)

;Exit


	Local $cs, $ce, $t

	Local $lc = StringSplit($szBuffer,@CRLF), $remI = StringSplit($tmp, "|"), $comment_toggle=False, $extra_comment=0, $ldelcount=0
ConsoleWrite( "!Searching for rest in: " & $lc[0] & " lines" & @CRLF & @CRLF )
	For $i = 1 To $lc[0]
;ConsoleWrite( "-"&$i & "-" & $extra_comment &"	]" & $lc[$i] & @CRLF )

		If (StringInStr($lc[$i],"#cs")) Then
;$comment_toggle = True
			$extra_comment += 1
			ConsoleWrite( "#cs found: " & $lc[$i] & @CRLF )
		EndIf

		If (StringInStr($lc[$i],"#ce")) Then
;$extra_comment -= 1
			ConsoleWrite( "#ce found: " & $lc[$i] & @CRLF )
			;If ($extra_comment <= 1) Then $comment_toggle = False
		EndIf

;ConsoleWrite( "ct: " & $comment_toggle & " line: " & $i &@CRLF )
		If ($comment_toggle > 0) Then
				ConsoleWrite( "!SKIP: " & $lc[$i] & @CRLF )
			$ldelcount += 1
;If (StringInStr($lc[$i],"#cs")) Then $extra_comment += 1 ; found another #cs before #ce
			$lc[$i] = ""

		Else

			If (StringLeft(StringStripWS($lc[$i],8),1) = ";") Then ; comment - skip
				$lc[$i] = ""
				$ldelcount += 1
		;	ElseIf (StringLower(StringLeft(StringStripWS($lc[$i],8),StringLen("#Region"))) = "#region") Then ; region skip
		;		$lc[$i] = ""
		;		$ldelcount +=1
		;	ElseIf (StringLower(StringLeft(StringStripWS($lc[$i],8),StringLen("#EndRegion"))) = "#EndRegion") Then ; endregion skip
		;		$lc[$i] = ""
		;		$ldelcount +=1
			Else
				For $x = 1 To $remI[0]
					If (StringInStr($lc[$i],$remI[$x])) Then
	ConsoleWrite( "+Found rest: " & $remI[$x] & "	-	@line:	" & $i &  @CRLF )
						$lc[$i] = "; ######### TAKEN OUT OF THE EQUATION - " & $remI[$x]
						ExitLoop
					EndIf
				Next
			EndIf

		EndIf

;ConsoleWrite( "" & $i & "] " & $lc[$i] &  @CRLF )
;ConsoleWrite( "+"&$i & "-" & $extra_comment &"	]" & $lc[$i] & @CRLF )

	Next
	ConsoleWrite( "!Deleted lines: " & $ldelcount & @CRLF & @CRLF )
	Local $r = ""
	For $i = 1 To $lc[0]
		If (StringStripWS($lc[$i],8)="") Then
		Else
			If Not (StringInStr($lc[$i],"#include")) Then $r &= $lc[$i] & @CRLF
		EndIf
	Next
	$szBuffer = $r

	;$lc = _ArrayUnique($lc,0,1)
	;$szBuffer = _ArrayToString($lc,@CRLF,1)

;get all function names and all sub functions

#ce

;write new entire file
	If (FileExists( $outPutScriptName ) And ($OVERWRITE = False)) Then
		$notfoundcount[0][0] = @CRLF & "![ERROR]" & @CRLF & "-File [" & $outPutScriptPath & "] does already exist." & @CRLF & "-Please delete it manually before script creates the new file."
		Return SetError(-1, -1, $notfoundcount )
	EndIf
	__fileWrite($outPutScriptName,$szBuffer)
	Return SetError(Round(TimerDiff($aTime)/1000), $count, $notfoundcount)
EndFunc

Func __removeAllDuplicatesArr($arr,$ub=0) ; CONTINUE HEREEEEEEEEEEEEEEEEEEEE
	Local $start = 1
	If Not $ub Then $size = $arr[0]
	If $ub Then
		$size	= UBound($arr)-1
		$start	= 0
	EndIf

	Local $retArr[$size+1], $curCheck, $dont_add_again[$size+1], $c=0, $addNOW = 0
	For $i = $start To $size

		;$curCheck = $arr[$i]

		If $c = 0 Then
			$retArr[$c] = $arr[$i]
			$dont_add_again[$c] = $arr[$i]
			$c += 1

		Else

			$addNOW = 1
			For $full_loop = $start To $size
				If ($full_loop <> $i) Then
					If ($dont_add_again[$c-1] = $arr[$full_loop]) Then
						$addNOW = 0
						ExitLoop
					EndIf
				EndIf
			Next

				ConsoleWrite( "! $I("&$i&") - $C("&$c&") - ADDNOW="&$addNOW&":	" & $dont_add_again[$c-1] &" = "& $arr[$i] & @CRLF)

			If ($addNOW = 1) Then
				ConsoleWrite( "! ADDING:	" & $dont_add_again[$c-1] &" = "& $arr[$full_loop] & @CRLF)
				$retArr[$c] = $arr[$i]
				$dont_add_again[$c] = $arr[$i]
				$c += 1
			EndIf

		EndIf

	Next
	ReDim $retArr[$c]
	Return $retArr

EndFunc

Func __removeAllSpecific($str, $r)
	Local $t = StringSplit($str,@CRLF),$c
	Local $n[$t[0]+1]
	If @error Then Return -1

	For $i = 1 To $t[0]
		$c = StringStripWS($t[$i],8)
		If (StringLeft($t[$i],StringLen($r)) = $r ) Then $t[$i] = ""
	Next
	;rebuild
	Local $cleanCount = 0
	For $i = 1 To $t[0]
		If ($t[$i] <> "") Then
			$n[$cleanCount]=$t[$i]
			$cleanCount += 1
		EndIf
	Next
	ReDim $n[$cleanCount+1]
	Return _ArrayToString($n,@CRLF)
EndFunc

Func __addToEach($a, $l, $r, $base=0)
	Local $m = $a[0]
	If $base = 0 Then $m = UBound($a)-1
	For $x = $base To $m
		$a[$x] = $l & $a[$x] & $r
	Next
	Return $a
EndFunc

Func __fileWrite($f,$t)
	If FileExists($f) Then FileDelete($f)
	$f =  FileOpen($f,1)
	FileWrite($f, $t)
	Return FileClose($f)
EndFunc

Func __multiRemToString($s,$l,$r)
	Local $x
	For $i = 1 To $s[0]
		If ($i <= $l) Or ($i >= $r) Then $x &= $s[$i]&@CRLF
	Next
	Return $x
EndFunc



