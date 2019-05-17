#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>
#include <MultiTasking.au3>

MsgBox(0,"Main Process","Lets Assign some shared variables "&@crlf&"My PID is :"&@AutoItPID)

_Task_SetVar("Shared_Var",0)
local $temparray[4]=[31,32,"String",True]
_Task_SetArray("Shared_Array",$temparray)


_Task_Create("Task1","GetSharedValues")
_Task_join("Task1")


msgbox(0,"Main Process","now we will start 5 Tasks of function 'RacingWrite_EXP'  same time which use _Task_SetVar , each one will loop 10 times, each loop increase 'shared_value' by 1")
MsgBox(0,"Main Process","So 'Shared_Value' should equal : 5 process * 10 loops = 50 "&@CRLF&"pls Check 'RacingWrite_EXP' function")
local $PIDarray[5]
for $i=0 to 4
$PIDarray[$i]=_Task_Create("","RacingWrite_EXP")
next
_Task_join($PIDarray)
MsgBox(0,"Main process","Tasks Finished But 'Shared_Value' = "&_Task_GetVar("Shared_Var"))


MsgBox(0,"Main process","Now lets Set 'Shared_value' to zero again and do the same but this time useing function 'SafeWrite_EXP' Which use _TasK_SetVarEX ,pls Check 'SafeWrite_EXP' function")
_Task_SetVar("Shared_Var",0)



local $PIDarray[5]
for $i=0 to 4
$PIDarray[$i]=_Task_Create("","SafeWrite_EXP")
next
_Task_join($PIDarray)
MsgBox(0,"Main process","Tasks Finished and Now 'Shared_Value' = "&_Task_GetVar("Shared_Var"))

MsgBox(0,"Main process","Finaly i will start 'Sync_EXP' function and will calculate how much time till 'Shared_Value' will Equal 100 ,pls Check 'Sync_EXP' function")
$hTimer=TimerInit()
_Task_Create("","Sync_EXP")
_Task_PauseUntilVar("Shared_Var","=",100)     					;======>supported operator ["=", "==", "<>", ">", ">=", "<", "<="]
MsgBox(0,"Main process","Shared_Value Reached 100 in "&TimerDiff($hTimer))

MsgBox(0,"Main process","Thank you and Good bye")


func GetSharedValues()
	local $str="I'M Task with PID  : "&@AutoItPID&" lets retrieve those variables"&@CRLF
	$str&="Shared_Var ="&_Task_GetVar("Shared_Var")&@CRLF
	$str&="Shared_Array[0] ="&_Task_GetArrayElemenT("Shared_Array",0)&@CRLF
	$str&="Shared_Array[1] ="&_Task_GetArrayElemenT("Shared_Array",1)&@CRLF
	$str&="Shared_Array[2] ="&_Task_GetArrayElemenT("Shared_Array",2)&@CRLF
	$str&="Shared_Array[3] ="&_Task_GetArrayElemenT("Shared_Array",3)&@CRLF
	MsgBox(0,"Task1",$str)

	MsgBox(0,"Task1","Now we will Change Shared_Array[3] to :False  and will show all Array with _ArrayDispaly()" )
	_Task_SetArrayElement("Shared_Array",false,3)       ;====> false alway converted to 0
	local $temparray=_Task_GetArray("Shared_Array")
	_ArrayDisplay($temparray)

EndFunc

Func RacingWrite_EXP()

	for $i =0 to 9
	$tempint=_Task_GetVar("Shared_Var")
	_Task_SetVar("Shared_Var",$tempint+1)
	next

EndFunc

Func SafeWrite_EXP()

for $i =0 to 9
	_TasK_SetVarEX("Shared_Var","+=",1) ;===>supported opreators=["+=", "-=", "/=", "*=", "&="]
	next

endfunc

func Sync_EXP()
	sleep(3000)
	_Task_SetVar("Shared_Var","100")
	sleep(10000)
	endfunc
