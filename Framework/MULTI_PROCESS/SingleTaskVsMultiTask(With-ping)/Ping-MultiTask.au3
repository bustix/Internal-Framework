#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>
#include <MultiTasking.au3>
$init=TimerInit()
local $result[254][2]
_task_setvar("TotalDone",0)
_task_setarray("Sharedarray",$result)


for $i=0 to 253 step 10
_task_create("","pin",$i)

next
_Task_PauseUntilVar("TotalDone","=",254)

$resultarr=_task_getarray("Sharedarray")
$timeresult=TimerDiff($init)
_ArrayDisplay($resultarr)
MsgBox(0,"","Total time "&$timeresult)



func pin($y)
	for $i=$y to $y+9
$result="Offline"
	$address="192.168.2."&$i+1
	$time=Ping($address,2000)
	if $time>0 Then $result="Online"
	_task_setarrayelement("Sharedarray",$address,$i,0)
	_task_setarrayelement("Sharedarray",$result,$i,1)
	_task_setvarex("TotalDone","+=",1)
	if $i=253 then ExitLoop
	next
EndFunc