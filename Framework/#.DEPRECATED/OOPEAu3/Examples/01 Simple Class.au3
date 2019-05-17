#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include '../OOPE.au3'

; Create a variable $oTest of type "Test"
#classdef <Test> $oTest

$oTest.SetValue(42)
MsgBox(0, 0, "The answer to everything is " & $oTest.GetValue & ".")

#Region Class Test
	Local $iValue

	Func SetValue($iNewValue)
		$This.iValue = $iNewValue
	EndFunc

	Func GetValue()
		Return $This.iValue
	EndFunc
#EndRegion