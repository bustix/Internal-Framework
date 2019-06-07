#include 'NomadMemory.au3'


; Code how to get the pointer for NORMAL AUTOIT variable (native variable)

Global Const $iIdentifyingMark = -1234562457

$hMem = _MemoryOpen(@AutoItPID) ; Open the memory of this Autoit
If @error Then Exit ConsoleWrite(@ScriptLineNumber & @CRLF) ; Error opening the memory

ConsoleWrite('Declaring the $variable...' & @CRLF)
$variable = DllStructCreate('int') ; Create variable as struct to get its pointer
$variable_pointer = DllStructGetPtr($variable) ; Get the pointer for the struct variable
$variable = $iIdentifyingMark ; Change the variable "back" to normal autoit variable

ConsoleWrite('Looking for the true pointer of $variable' & @CRLF)
; Look for the pointer for the normal autoit variable with the help of $variable_pointer
Local $data_from_memread, $variable_updated_pointer_found
For $variable_updated_pointer = Int(Number($variable_pointer)*0.999) To Int(Number($variable_pointer)*1.001)
    $data_from_memread = _MemoryRead($variable_updated_pointer, $hMem,'int')
    ; Check if the value of the pointer is equal to $variable. If so then there is high chance that we found it
    If $data_from_memread <> $variable Then ContinueLoop
    ; If this area executed then $variable must be equal to $data_from_memread
    ; next: Check if the founded pointer is correct one
    $variable = 1 ; Set the $variable to be 1
    $data_from_memread = _MemoryRead($variable_updated_pointer, $hMem,'int') ; Now read the the $variable through the pointer
    If $data_from_memread = $variable Then ; Check again if the value we got using this pointer is equal to $variable
        ; YES!! we found it! this is the correct pointer
        $variable_updated_pointer_found = 1
        $variable = $iIdentifyingMark
        ExitLoop ; Exit now to continue to the magic
    Else
        ; if not then this is the worng one :( so we try again and reset...
        $variable = $iIdentifyingMark
    EndIf
Next


If Not $variable_updated_pointer_found Then Exit ConsoleWrite("Sorry, I didn't found the pointer :(" & @CRLF)
; If this area executed then this is very good news. Because you're going to see here magic
$variable_updated_pointer = Ptr($variable_updated_pointer)
ConsoleWrite('The pointer for $variable (Autoit native variable) is: '& $variable_updated_pointer & @CRLF & @CRLF)


ConsoleWrite('Reading the $variable using Autoit native ---> ')
ConsoleWrite('$variable is equal to: '&$variable & @CRLF)

ConsoleWrite('Reading the $variable using _MemoryRead ---> ')
ConsoleWrite('$variable is equal to: '&_MemoryRead($variable_updated_pointer, $hMem, 'int') & @CRLF&@CRLF)



$iNewValue = Random(1,10000,1)
ConsoleWrite('Changing the $variable to '&$iNewValue&' with _MemoryWrite(*) -> ')
_MemoryWrite($variable_updated_pointer, $hMem, $iNewValue, 'int')
ConsoleWrite('Reading the $variable using Autoit native -> $variable is equal to: '&$variable & @CRLF )