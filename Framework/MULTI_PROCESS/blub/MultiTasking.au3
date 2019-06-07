#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.5
	Author:         Network_Guy

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once
#include <Array.au3>
#include <MailSlot.au3>


;##################          Constants   #########################
Global $__Tsk_PIDstring = StringFormat("%05i", @AutoItPID)
Global $__Tsk_SlotName = "\\.\mailslot\" & $__Tsk_PIDstring
Global $__Tsk_SlotHWnd = 0 ;
Global $__Tsk_BoolMainTask = True
Global $__Tsk_TaskName = ""
Global $__Tsk_TaskFunc = ""
Global $__Tsk_ParentPID = 0
Global $__Tsk_CorePID = 0
Global $__Tsk_SlotTarget = ""
Global $__Tsk_Preventcorecongestion = 0
Global $__Tsk_Genratetaskname = 1
;######################## ON startUP      ###########################
OnAutoItExitRegister("_Tsk_OnExit")
;#OnAutoItStartRegister "_TskInitiateModule"
_TskInitiateModule()

;##################################################################

#Region intiate
Func _TskInitiateModule()
	$__Tsk_SlotHWnd = _MailSlotCreate($__Tsk_SlotName)
	If $CmdLine[0] > 0 Then
		If $CmdLine[1] = "T@$k" Then
			$__Tsk_BoolMainTask = False
			TraySetState(2)

			$__Tsk_TaskName = $CmdLine[2]
			;MsgBox(0,"",$__Tsk_TaskName&"   "&AutoItWinGetTitle())
			If WinExists($__Tsk_TaskName) = 1 Then _TskError("Error : Dublicate Process with the same Name is not Allowed !")
			AutoItWinSetTitle($__Tsk_TaskName)

			$__Tsk_TaskFunc = $CmdLine[3]

			$__Tsk_ParentPID = $CmdLine[4]
			AdlibRegister("_Isbackground", 500)

			$__Tsk_CorePID = $CmdLine[5]
			$__Tsk_SlotTarget = "\\.\mailslot\" & StringFormat("%05i", $__Tsk_CorePID)

			Local $callstring = "call(" & $__Tsk_TaskFunc
			If $CmdLine[0] > 5 Then
				For $i = 6 To $CmdLine[0]
					$callstring &= ",$CmdLine[" & $i & "]"
				Next
			EndIf
			$callstring &= ")"
			;Call($__Tsk_TaskFunc)
			;MsgBox(0,"",$callstring)
			Execute($callstring)
			If @error Then _TskError("Error : Createing process has been faild  cause function does not exist or invalid number of parameters !")
			Exit
		EndIf

	EndIf
	$__Tsk_CorePID = _Task_Create($__Tsk_TaskName & "-Core", "_TskCore")
	$__Tsk_SlotTarget = "\\.\mailslot\" & StringFormat("%05i", $__Tsk_CorePID)
	Sleep(200)
EndFunc   ;==>_TskInitiateModule
#EndRegion intiate


Func _Task_Create($name, $Funcname, $param1 = "", $param2 = "", $param3 = "", $param4 = "", $param5 = "", $param6 = "", $param7 = "", $param8 = "")
	Local $currentname = AutoItWinGetTitle()
	If $name = $currentname Then _TskError("Error: Task has the same Name as The main executable !")

	If $name = "" Then
		$name = $currentname & "-Task" & $__Tsk_Genratetaskname
		$__Tsk_Genratetaskname += 1
	EndIf

	If $Funcname = "" Then _TskError("Error: Invaild Function name !")
	Local $CmdlineforTask = ' T@$k "' & $name & '" ' & $Funcname & ' ' & @AutoItPID & ' ' & $__Tsk_CorePID & ' '



	If $__Tsk_BoolMainTask = False Then _TskError("Error: task can be start  from Main task only !")
	If @NumParams > 2 Then
		For $i = 1 To @NumParams - 2
			Local $param = Eval("param" & $i)

			If $param = "" Then $param = 0
			$CmdlineforTask &= $param & " "
		Next
	EndIf
	Local $PID = 0
	If @Compiled = 1 Then
		$PID = Run(@ScriptFullPath & $CmdlineforTask, "", @SW_HIDE, 7)
	Else
		;MsgBox(0,"",@ScriptFullPath & $CmdlineforTask)

		$PID = Run(@AutoItExe & ' /ErrorStdOut "' & @ScriptFullPath & '" ' & $CmdlineforTask, "", @SW_HIDE, 7)
	EndIf
	Sleep(100)
	Return $PID
EndFunc   ;==>_Task_Create








#Region functions

Func _Task_Join($name)

	If IsArray($name) = 1 Then
		If UBound($name, 2) <> 0 Then _TskError("Error: Task_join accept 1D array only")
		For $t = 0 To UBound($name) - 1
			$func = WinWaitClose
			If StringIsDigit($name[$t]) = 1 Then $func = ProcessWaitClose
			$func($name[$t])
			;MsgBox(0,"",$name&"="&$t)
		Next
	Else
		Local $func = WinWaitClose
		If StringIsDigit($name) = 1 Then $func = ProcessWaitClose
		$func($name)
	EndIf
	$__Tsk_Preventcorecongestion = _Task_GetVar("__Tsk_Preventcorecongestion")

EndFunc   ;==>_Task_Join


Func _Task_IsAlive($name)
	If IsArray($name) = 1 Then _TskError("Error: Task_IsAlive dont accept arrays As INPUT")
	;sleep(100)
	Local $func = WinExists
	If StringIsDigit($name) = 1 Then $func = ProcessExists

	Local $stat = False
	If $func($name) = 1 Then $stat = True
	Return $stat
EndFunc   ;==>_Task_IsAlive

Func _Task_Kill($name)
	If IsArray($name) = 1 Then _TskError("Error: Task_Kill dont accept arrays As INPUT")

	Local $func = WinClose
	If StringIsDigit($name) = 1 Then $func = ProcessClose

	Local $stat = $func($name)
	Return $stat
EndFunc   ;==>_Task_Kill


Func _Task_Info()
	Local $arr[3]
	$arr[0] = $__Tsk_TaskName
	$arr[1] = $__Tsk_TaskFunc
	$arr[2] = $__Tsk_ParentPID
	Return $arr
EndFunc   ;==>_Task_Info

#EndRegion functions


#Region Set

Func _Task_SetVar($var, $value)

	If IsArray($value) = 1 Then
		Local $str = StringInStr($var, "_TskArr_", 2)
		If $str > 0 Then $var = StringMid($var, 1, $str - 1) & "   Array"
		_TskError("Error:  invalid '" & $var & "' input value ")
	EndIf
	If $value = "" Then $value = 0
	StringReplace($var, "$", "")
	Local $query = 0 & $var & "&*" & $value
	;MsgBox(0,"",$query)
	_MailSlotWrite($__Tsk_SlotTarget, String($query))
	$__Tsk_Preventcorecongestion += 1
	If $__Tsk_Preventcorecongestion >= 10 Then
		$__Tsk_Preventcorecongestion = _Task_GetVar("__Tsk_Preventcorecongestion")
	EndIf
EndFunc   ;==>_Task_SetVar


Func _Task_SetVarEX($var, $opreator, $value)
	Local $error = True
	If IsArray($value) = 1 Then _TskError("Error:  invalid '" & $var & "' input value ")
	If $value = "" Then $value = 0
	StringReplace($var, "$", "")
	Local $safeopreation = ["+=", "-=", "/=", "*=", "&="]
	For $op In $safeopreation

		If $op = $opreator Then
			Local $query = 3 & $var & "&*$" & $var & StringReplace($opreator, "=", "") & "'" & $value & "'"
			;MsgBox(0,"",$query)
			_MailSlotWrite($__Tsk_SlotTarget, String($query))
			Local $error = False
			ExitLoop
		EndIf
	Next
	If $error = True Then
		Local $str = StringInStr($var, "_TskArr_", 2)
		If $str > 0 Then $var = StringMid($var, 1, $str - 1)
		_TskError("Error:  invalid '" & $var & "'  opreator ")
	EndIf
	$__Tsk_Preventcorecongestion += 1
	If $__Tsk_Preventcorecongestion >= 10 Then
		$__Tsk_Preventcorecongestion = _Task_GetVar("__Tsk_Preventcorecongestion")
	EndIf
EndFunc   ;==>_Task_SetVarEX


Func _Task_SetArrayElement($var, $value, $row, $colum = 0)
	If IsArray($value) = 1 Then _TskError("Error:  invalid '" & $var & "'  input value ")
	If $value = "" Then $value = 0
	StringReplace($var, "$", "")
	_Task_SetVar(_TskArrayElement($var, $row, $colum), $value)

EndFunc   ;==>_Task_SetArrayElement

Func _Task_SetArrayElementEX($var, $opreator, $value, $row, $colum = 0)
	If IsArray($value) = 1 Then _TskError("Error:  invalid '" & $var & "'  input value ")
	If $value = "" Then $value = 0
	StringReplace($var, "$", "")
	_Task_SetVarEX(_TskArrayElement($var, $row, $colum), $opreator, $value)

EndFunc   ;==>_Task_SetArrayElementEX


Func _Task_SetArray($var, ByRef $array)
	If IsArray($array) = 0 Then _TskError("Error:  invalid '" & $var & "'  input value ")
	StringReplace($var, "$", "")
	Local $arraystr = ""
	Local $rowNumber = UBound($array)
	Local $columNumber = UBound($array, 2)

	_Task_SetVar($var & "_TskArr_R", $rowNumber)
	_Task_SetVar($var & "_TskArr_C", $columNumber)

	If $columNumber = 0 Then

		For $r = 0 To $rowNumber - 1
			If $array[$r] = "" Then $array[$r] = 0
			$arraystr &= $array[$r] & "$" & Chr(28)
		Next
		$arraystr = StringTrimRight($arraystr, 2)
	Else

		For $r = 0 To $rowNumber - 1
			For $c = 0 To $columNumber - 1
				If $array[$r][$c] = "" Then $array[$r][$c] = 0
				$arraystr &= $array[$r][$c] & "|" & Chr(29)
			Next
			$arraystr = StringTrimRight($arraystr, 2)
			$arraystr &= "$" & Chr(28)
		Next
		$arraystr = StringTrimRight($arraystr, 2)
	EndIf
	Local $query = 4 & $var & "&*" & $arraystr
	;msgbox(0,"",$arraystr)
	_MailSlotWrite($__Tsk_SlotTarget, String($query))
	$__Tsk_Preventcorecongestion += 1
	If $__Tsk_Preventcorecongestion >= 10 Then
		$__Tsk_Preventcorecongestion = _Task_GetVar("$__Tsk_Preventcorecongestion")
	EndIf

EndFunc   ;==>_Task_SetArray

#EndRegion Set


#Region Get

Func _Task_GetVar($var)
	StringReplace($var, "$", "")
	Local $query = 1 & $__Tsk_PIDstring & $var
	_MailSlotWrite($__Tsk_SlotTarget, String($query))
	Local $result = _ReadMessagewithTimeout($__Tsk_SlotHWnd)
	;MsgBox(0,"",$result)
	If $result = "0xErr0r" Then
		Local $str = StringInStr($var, "_TskArr_", 2)
		If $str > 0 Then $var = StringMid($var, 1, $str - 1) & "' element Array"
		_TskError("Error : Requested  '" & $var & "' not exist ")
	ElseIf $result = "False" Then
		Local $result = 0
	EndIf
	Return $result
EndFunc   ;==>_Task_GetVar

Func _Task_GetArrayElement($var, $r, $c = 0)
	Local $result = _Task_GetVar(_TskArrayElement($var, $r, $c))
	Return $result
EndFunc   ;==>_Task_GetArrayElement

Func _Task_GetArray($var)
	StringReplace($var, "$", "")
	Local $rowNumber = _Task_GetVar($var & "_TskArr_R")
	Local $columNumber = _Task_GetVar($var & "_TskArr_C")

	Local $query = 5 & $__Tsk_PIDstring & $var
	_MailSlotWrite($__Tsk_SlotTarget, String($query))
	Local $result = _ReadMessagewithTimeout($__Tsk_SlotHWnd)


	If $columNumber = 0 Then
		$resultarray = StringSplit($result, "$" & Chr(28), 3)

	Else
		Local $resultarray[$rowNumber][$columNumber]
		$arr1 = StringSplit($result, "$" & Chr(28), 3)
		For $r = 0 To $rowNumber - 1
			$arr2 = StringSplit($arr1[$r], "|" & Chr(29), 3)
			For $c = 0 To $columNumber - 1
				$resultarray[$r][$c] = $arr2[$c]
			Next
		Next

	EndIf


	Return $resultarray
EndFunc   ;==>_Task_GetArray
#EndRegion Get

#Region misc
Func _Task_PauseUntilVar($var, $operator, $value)
	Local $error = True
	If IsArray($value) = 1 Then _TskError("Error:  invalid '" & $var & "' input value ")
	If $value = "" Then $value = 0
	StringReplace($var, "$", "")
	Local $safeopreation = ["=", "==", "<>", ">", ">=", "<", "<="]


	For $op In $safeopreation

		If $op = $operator Then

			Local $error = False
			ExitLoop
		EndIf
	Next
	If $error = True Then
		Local $str = StringInStr($var, "_TskArr_", 2)
		If $str > 0 Then $var = StringMid($var, 1, $str - 1)
		_TskError("Error:  invalid '" & $var & "'  opreator ")

	Else
		Local $chk = _Task_GetVar($var)
		Local $localquery = Execute($chk & $operator & "'" & $value & "'")
		If $localquery = 0 Then
			Local $query = 6 & $__Tsk_PIDstring & "$" & $var & $operator & "'" & $value & "'"
			_MailSlotWrite($__Tsk_SlotTarget, String($query))
			_ReadMessagewithTimeout($__Tsk_SlotHWnd, -1)
		EndIf
	EndIf

EndFunc   ;==>_Task_PauseUntilVar

Func _Task_PauseUntilArrayelement($var, $operator, $value, $row, $colum = 0)
	If IsArray($value) = 1 Then _TskError("Error:  invalid '" & $var & "' input value ")
	_Task_PauseUntilVar(_TskArrayElement($var, $row, $colum), $operator, $value)
EndFunc   ;==>_Task_PauseUntilArrayelement


Func _Task_Query($queryx)
	Local $query = 2 & $__Tsk_PIDstring & $queryx
	_MailSlotWrite($__Tsk_SlotTarget, String($query))
	Local $result = _ReadMessagewithTimeout($__Tsk_SlotHWnd)
	;MsgBox(0,"",$result)

	If $result = "False" Then Local $result = 0
	Return $result
EndFunc   ;==>_Task_Query

#EndRegion misc



#Region Internal functions
Func _TskCore()
	Global $__Tsk_ListenList = [""]
	ProcessSetPriority(@AutoItPID, 4)
	;_MailSlotSetTimeout($__Tsk_SlotHWnd, 0)
	While 1
		Local $iSize = _MailSlotCheckForNextMessage($__Tsk_SlotHWnd)
		If $iSize > 0 Then
			Local $sData = _MailSlotRead($__Tsk_SlotHWnd, $iSize, 1)

			Local $type = StringMid($sData, 1, 1)
			Local $data = StringMid($sData, 2)
			Switch $type
				Case 0
					_TskCoreSet($data)
				Case 1
					_TskCoreGet($data)
				Case 2
					_TskCoreQuery($data)
				Case 3
					_TskCoreSetEX($data)
				Case 4
					_TskCoreArraySet($data)
				Case 5
					_TskCoreArrayGet($data)
				Case 6
					_TskCoreListen($data)


			EndSwitch

		Else
			Sleep(1)
		EndIf
		_TskCoreProcessListenerList()

	WEnd
EndFunc   ;==>_TskCore


Func _TskCoreSet(ByRef $data)
	Local $split = StringInStr($data, "&*", 2)
	Local $var = StringMid($data, 1, $split - 1)
	Local $value = StringMid($data, $split + 2)
	$isarray = StringInStr($var, "_TskArr_")
	If $isarray = 0 Then
		Assign($var, $value, 2)
	Else
		$chk = StringMid($var, $isarray + 8, 1)
		;MsgBox(0,"",$chk)
		If IsDeclared($var) = 1 Or $chk = "R" Or $chk = "C" Then Assign($var, $value, 2)
	EndIf
EndFunc   ;==>_TskCoreSet

Func _TskCoreSetEX(ByRef $data)
	Local $split = StringInStr($data, "&*", 2)
	Local $var = StringMid($data, 1, $split - 1)
	Local $value = StringMid($data, $split + 2)
	If IsDeclared($var) <> 0 Then
		Assign($var, Execute($value))
	Else
		Local $str = StringInStr($var, "_TskArr_", 2)
		If $str > 0 Then $var = StringMid($var, 1, $str - 1)
		_TskError("Error : Requested  '" & $var & "' not exist ")
	EndIf
EndFunc   ;==>_TskCoreSetEX

Func _TskCoreGet(ByRef $data)
	;$split=stringinstr($data,"&")
	Local $process = StringMid($data, 1, 5)
	Local $query = StringMid($data, 6)
	Local $sDataToSend = Eval($query)
	If @error <> 0 Then $sDataToSend = "0xErr0r"
	If $sDataToSend = "" Then $sDataToSend = 0
	Local $targetslot = "\\.\mailslot\" & $process
	;msgbox(0,"",$targetslot&" "&$sDataToSend)
	_MailSlotWrite($targetslot, String($sDataToSend))
EndFunc   ;==>_TskCoreGet


Func _TskCoreQuery(ByRef $data)
	Local $process = StringMid($data, 1, 5)
	Local $query = StringMid($data, 6)
	Local $sDataToSend = Execute($query)
	;msgbox(0,"",$query&" "&$sDataToSend)
	If @error <> 0 Then $sDataToSend = "0xErr0r"
	$sDataToSend = Int($sDataToSend)
	Local $targetslot = "\\.\mailslot\" & $process

	_MailSlotWrite($targetslot, String($sDataToSend))
EndFunc   ;==>_TskCoreQuery



Func _TskCoreArraySet(ByRef $data)

	Local $split = StringInStr($data, "&*", 2)
	Local $var = StringMid($data, 1, $split - 1)
	Local $value = StringMid($data, $split + 2)


	Local $r = $var & "_TskArr_R"
	Local $c = $var & "_TskArr_C"


	If IsDeclared($r) = 1 Then
		$r = Eval($var & "_TskArr_R")
		$c = Eval($var & "_TskArr_C")


		If $c = 0 Then

			$arr = StringSplit($value, "$" & Chr(28), 3)
			;MsgBox(0,"",$r)
			For $i = 0 To $r - 1
				;MsgBox(0,"",_TskArrayElement($var,$i))
				Assign(_TskArrayElement($var, $i), $arr[$i], 2)

			Next

		Else
			$arr1 = StringSplit($value, "$" & Chr(28), 3)
			For $i = 0 To $r - 1
				$arr2 = StringSplit($arr1[$i], "|" & Chr(29), 3)
				For $y = 0 To $c - 1
					Assign(_TskArrayElement($var, $i, $y), $arr2[$y], 2)
				Next
			Next
		EndIf
	EndIf
EndFunc   ;==>_TskCoreArraySet

Func _TskCoreArrayGet(ByRef $data)

	Local $process = StringMid($data, 1, 5)
	Local $val = StringMid($data, 6)
	Local $r = Eval($val & "_TskArr_R")
	Local $c = Eval($val & "_TskArr_C")
	Local $datatosend = ""
	Local $temp = ""
	If $c = 0 Then
		For $i = 0 To $r - 1
			$temp = Eval(_TskArrayElement($val, $i))
			If $temp = "" Then $temp = 0
			$datatosend &= $temp & "$" & Chr(28)
		Next
		$datatosend = StringTrimRight($datatosend, 2)

	Else
		;MsgBox(0,"",$r&$c)
		For $i = 0 To $r - 1
			For $y = 0 To $c - 1
				$temp = Eval(_TskArrayElement($val, $i, $y))
				If $temp = "" Then $temp = 0
				$datatosend &= $temp & "|" & Chr(29)
			Next
			$datatosend = StringTrimRight($datatosend, 2)
			$datatosend &= "$" & Chr(28)
		Next
		$datatosend = StringTrimRight($datatosend, 2)
	EndIf

	Local $targetslot = "\\.\mailslot\" & $process
	_MailSlotWrite($targetslot, String($datatosend))
EndFunc   ;==>_TskCoreArrayGet




Func _TskCoreProcessListenerList()
	Local $rowcount = UBound($__Tsk_ListenList)

	If $rowcount > 1 Then
		Local $temparr = [""]
		For $i = 1 To $rowcount - 1

			Local $process = StringMid($__Tsk_ListenList[$i], 1, 5)
			Local $query = StringMid($__Tsk_ListenList[$i], 6)
			;MsgBox(0,"",int(Execute($query))&" "&$query&"  "&eval("shared_var"))
			If Execute($query) = True Then
				Local $datatosend = "Resume"
				Local $targetslot = "\\.\mailslot\" & $process
				_MailSlotWrite($targetslot, String($datatosend))
			Else
				_ArrayAdd($temparr, $__Tsk_ListenList[$i])
			EndIf
		Next
		$__Tsk_ListenList = $temparr
	EndIf

EndFunc   ;==>_TskCoreProcessListenerList



Func _TskCoreListen(ByRef $data)
	$i = _ArrayAdd($__Tsk_ListenList, $data)

EndFunc   ;==>_TskCoreListen


Func _ReadMessagewithTimeout(ByRef $hHandle, $timeout = 3000)
	;Sleep(2)
;~ _MailSlotSetTimeout($hHandle, 20)
	If $timeout <> -1 Then
		Local $timer = TimerInit()
	EndIf

	While 1
		Local $iSize = _MailSlotCheckForNextMessage($hHandle)

		If $iSize > 0 Then
			Local $sData = _MailSlotRead($hHandle, $iSize, 1)
;~ 			MsgBox(0, "", $i)
			$timer = 0
			ExitLoop
		Else
			Sleep(1)
		EndIf

		If $timeout <> -1 And TimerDiff($timer) > $timeout Then
			_TskError("Error : Memory Buffer queue overload .")
		EndIf
	WEnd
	Return $sData
EndFunc   ;==>_ReadMessagewithTimeout



Func _TskArrayElement($var, $r, $c = 0)
	Local $str = $var & "_TskArr_" & $r
	If $c <> 0 Then $str &= "_" & $c
	Return $str
EndFunc   ;==>_TskArrayElement

Func _TskError($error)
	MsgBox(16, $__Tsk_TaskName & " Terminated", $error)
	Exit
EndFunc   ;==>_TskError

Func _Isbackground()
	If ProcessExists($__Tsk_ParentPID) = 0 Then Exit
EndFunc   ;==>_Isbackground



Func _Tsk_OnExit()
	_MailSlotClose($__Tsk_SlotHWnd)
	;	DllClose($__Tsk_DLL_HWnd)
EndFunc   ;==>_Tsk_OnExit

#EndRegion Internal functions
