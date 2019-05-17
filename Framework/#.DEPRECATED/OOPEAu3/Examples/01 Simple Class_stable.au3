#Region 

#AutoIt3Wrapper_UseX64=n

OnAutoItExitRegister("__cleanup")
#EndRegion 

#include '../OOPE.au3'



#forcedef $oTest
If UBound(Execute("$oTest")) Then
	For $n = 0 To UBound(Execute("$oTest"))-1
		$oTest[$n] = __OOPE_InstantiateClass("int64 iValue", "SetValue int64(int64);GetValue int64()", Default, Default)
	Next
Else
	$oTest = __OOPE_InstantiateClass("int64 iValue", "SetValue int64(int64);GetValue int64()", Default, Default)
EndIf


$oTest.SetValue(42)
MsgBox(0, 0, "The answer to everything is " & $oTest.GetValue & ".")


Func SetValue($___selfObjRef,$iNewValue)
$This = DllStructCreate(__PointerToString(DllStructCreate($__OOPE_ObjectInstanceVariables, $___selfObjRef).psVarsString), $___selfObjRef + $__OOPE_ObjectVariableOffset)

		$This.iValue = $iNewValue
	
EndFunc
Func GetValue($___selfObjRef)
$This = DllStructCreate(__PointerToString(DllStructCreate($__OOPE_ObjectInstanceVariables, $___selfObjRef).psVarsString), $___selfObjRef + $__OOPE_ObjectVariableOffset)

		Return $This.iValue
	
EndFunc


Func __cleanup()

#forcedef $oTest

If UBound(Execute("$oTest")) Then
	For $n = 0 To UBound(Execute("$oTest"))-1
	$oTest[$n] = 0
	Next
Else
	$oTest = 0
EndIf
EndFunc
