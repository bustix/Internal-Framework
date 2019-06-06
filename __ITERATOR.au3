
#include <File.au3>
#include <Array.au3>
#include <String.au3>

Local $scriptMainDir 			= @ScriptDir & "\"
Local $scriptSearchFolderName	= "Framework\"
Local $mainScriptName			= "Internal Framework.au3"


											; scriptdir		|Internal Framework.au3| Framework\				|	autoit includes dir	| NEW_FILE.au3		|SEARCH MASK	|	EXCLUDE		| BEFORE OR AFTER SEARCH	| DELIM

Local $out = _findAndCombineAllIncludesToFile( $scriptMainDir, $mainScriptName, 	$scriptSearchFolderName, 	Default, 				Default, 			Default, 		Null, 				True,					Default)



ConsoleWrite("!FOUND:" &@CRLF& StringReplace($out,"|",@CRLF) & @CRLF & "found: " & @extended & @CRLF & @CRLF )




Func _findAndCombineAllIncludesToFile( $scriptMainDir, $mainScriptName, $scriptSearchFolderNam, $defaultIncludesPath=Default, $outPutScriptName=Default, $searchmask=Default, $EXCLUDE_FILES=Null, $EXCLUDE_BEFORE_SEARCH=True, $EXCLUDE_FILES_DELIM="|" )
	Local $AutoItExe 			= @AutoItExe, $mainIncludes, $userIncludesq, $userIncludes, $fileread, $includeCarrier, $includeNameCarrier

	If ($EXCLUDE_FILES_DELIM	= Default) Then	$EXCLUDE_FILES_DELIM	=	"|"
	If ($searchmask				= Default) Then	$searchmask				= 	"*.au3"
	If ($defaultIncludesPath 	= Default) Then	$defaultIncludesPath	= 	StringLeft($AutoItExe,		StringInStr($AutoItExe,"\",0,-1)-1) 	&	"\Include\"
	If ($outPutScriptName 		= Default) Then	$outPutScriptName 		= 	StringLeft($mainScriptName,	StringInStr($mainScriptName,".",0,-1)-1)&	"_PLUS_ALL_INCLUDES.au3"
	Local $outPutScriptPath		= $scriptMainDir & $outPutScriptName
	Local $allScriptFiles		= _FileListToArrayRec( $scriptMainDir & $scriptSearchFolderNam, $searchmask, $FLTAR_FILES, 1, 0, 1 )
	Local $defaultIncludes 		= _FileListToArrayRec( $defaultIncludesPath, $searchmask, $FLTAR_FILES )

;read all files and gather all includes needet
	For $i = 1 To $allScriptFiles[0]
		$curPath = $scriptMainDir & $scriptSearchFolderNam & $allScriptFiles[$i]
		$fileread = FileRead( $curPath )
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
	Next
	If (StringRight( $includeCarrier, 1 ) = "|") Then $includeCarrier = StringTrimRight($includeCarrier,1)

;remove duplicates
	Local $includeCarrierArray 	= 	StringSplit( 	$includeCarrier, "|" )
	$includeCarrierArray		=	_ArrayUnique($includeCarrierArray,0,1)

;read all files to buffer
	Local $r, $szBuffer, $h, $s, $rep=StringSplit($includeNameCarrier,"|"), $prefix = '#include '
	For $i = 1 To $includeCarrierArray[0]
		If FileExists($includeCarrierArray[$i]) Then
			$h	=	FileOpen($includeCarrierArray[$i],0)
			$s	=	FileGetSize($includeCarrierArray[$i])
			$r	=	FileRead($h,$s)
			FileClose($h)
			$r	=	StringReplace($r, '#include-once', '' )
			For $x = 1 To $rep[0]
				$r	=	StringReplace($r, $prefix & ' <'&$rep[$x]&'>', '', 0, 1 )
				$r	=	StringReplace($r, $prefix & ' "'&$rep[$x]&'"', '', 0, 1  )
				$r	=	StringReplace($r, $prefix & " '"&$rep[$x]&"'", '', 0, 1  )
			Next
			$szBuffer &= "; ### INCLUDE FROM :	" & $includeCarrierArray[$i] & @CRLF & @CRLF & $r & @CRLF
		Else
			$szBuffer &= "; ### INCLUDE FROM : 	" & $includeCarrierArray[$i] & @CRLF & @CRLF & ";<FILE NOT FOUND>" & @CRLF & @CRLF
		EndIf
	Next

;write new entire file
	If FileExists( $outPutScriptName ) Then Return MsgBox(0, "Error", "File [" & $outPutScriptPath & "] does already exist." & @CRLF & "Please delete it manually before script creates the new file." )
	Return FileWrite( $outPutScriptName, $szBuffer )
EndFunc






















