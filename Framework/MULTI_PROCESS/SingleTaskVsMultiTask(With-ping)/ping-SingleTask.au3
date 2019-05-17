#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include<array.au3>

$init=TimerInit()
local $finalresult[254][2]
local $result=""
for $i=0 to 253
	ToolTip($i)
	$result="Offline"
	$address="192.168.1."&$i+1
	$time=Ping($address,2000)
	if $time>0 Then $result="Online"
	$finalresult[$i][0]=$address
	$finalresult[$i][1]=$result
Next
$totaltime=TimerDiff($init)
_ArrayDisplay($finalresult)
MsgBox(0,"","Totaltime= "&$totaltime)