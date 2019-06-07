; To extract the source code from a EXE file with saved source code.

#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#AutoIt3Wrapper_Res_SaveSource=y
#include <ResourcesEx.au3>
#include <WinAPISysWin.au3>
Global $InputEXE = FileOpenDialog("Select file to extract source from", @ScriptDir, "EXE (*.EXE)", $FD_FILEMUSTEXIST, StringTrimRight(@ScriptName, 3) & "exe")
If @error Then Exit MsgBox($MB_ICONINFORMATION + $MB_TOPMOST, Default, " No source file selected.", 0)
If Not (StringRight($InputEXE, 4) = ".exe") Then Exit MsgBox($MB_ICONINFORMATION + $MB_TOPMOST, Default, " The selected source file" & @LF & @LF & $InputEXE & @LF & @LF & "is NO *.EXE file.", 0)
Global $sFilePath = $InputEXE & ".extracted_source.au3"
_Resource_SaveToFile($sFilePath, 999, $RT_RCDATA, Default, Default, $InputEXE)
If Not @error Then
    ShellExecute("NotePad.exe", $sFilePath)
    MsgBox($MB_ICONINFORMATION + $MB_TOPMOST, Default, $sFilePath & @LF & @LF & " created." & @LF & @LF & "A NotePad window with the code has been opened.", 0)
Else
    MsgBox($MB_ICONINFORMATION + $MB_TOPMOST, Default, $InputEXE & @LF & @LF & " has NO included source." & @LF & @LF & "Add the following line to the source code:" & @LF & @LF & "#AutoIt3Wrapper_Res_SaveSource=y", 0)
EndIf