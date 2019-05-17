#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <WinAPISys.au3>
#include <Array.au3>
#include <MultiTasking.au3>       ;====> always last include

Opt("WinWaitDelay",100)                 	        ;====> _Task_Join use win&process , decreasing "winwaitdelay" from its default values increase things up

MsgBox(0,"Main Process PID: "&@AutoItPID,"Calling Func without parameters")

sleep(1000)
_Task_Create("Task1","Func_WITHOUT_parameters")      ;====> Only main process can use _Task_Create to prevent Process Loop
_Task_Create("Task2","Func_WITHOUT_parameters")
local $tasks[2]=["Task1","Task2"]
_TasK_Join($tasks)                                   ;====> Accept single name or Process ID or array contain both of them

sleep(2000)
MsgBox(0,"Main Process","Calling Func with parameters ")
local $Htimer=TimerInit()
 local $PID=_Task_Create("","Func_WITH_parameters",10,$Htimer);====> _Task_Create always return child process ID ( SToutread,STinwrite,STerrRead work with this PID )
_TasK_Join($PID)

sleep(2000)
msgBox(0,"Main Process","Lets call Endless Task")
_Task_Create("EndlessTask","FinalTask")


Sleep(2000)
local $state=_Task_IsAlive("EndlessTask")
MsgBox(0,"Main Process","EndlessTask live status is "&$state&" lets kill it")
_Task_kill("EndlessTask")                                       ;====>Not Recommended

sleep(2000)
$state=_Task_IsAlive("EndlessTask")
MsgBox(0,"Main Process","Now EndlessTask status is "&$state)

sleep(1000)
MsgBox(0,"Main Process","Thanx and Good Bye")


func Func_WITHOUT_parameters()
	local $infoarray=_Task_info()
	$Str="Hello I'm "&$infoarray[0]&@CRLF
	$Str&="I Executing "&$infoarray[1]&@CRLF
	$Str&="And my parent Process PID is :"&$infoarray[2]
	MsgBox(0,"Task : "&@AutoItPID,$Str)

EndFunc


func  Func_WITH_parameters($parameter1,$parameter2) ;====> $parameters always received as Strings
	$timetoexecutetask=TimerDiff($parameter2)
	sleep(2000)
	$Str="Hello my first parameter is "&$parameter1&" and its type is "&VarGetType($parameter1)&@CRLF
	$Str&="my second parameter is "&$parameter2&" and its type is "&VarGetType($parameter1)&@CRLF
	$Str&="and i tooked  "&$timetoexecutetask&" Msec after calling _Task_create function to start." ;====> Dont spam Task creation use it Wisly
	MsgBox(0,"Task: "&@AutoItPID,$Str)
EndFunc

Func FinalTask ()                               ;====> if Main process exit this task will exit too even if it has infinte loop
	While 1
	Sleep(100)
	Wend
	EndFunc

