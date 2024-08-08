@echo off
setlocal

:: Create a temporary VBScript file to show a Yes/No dialog
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %tmp%\tmp.vbs
echo response = WshShell.Popup("Do you want to create a clean disk instruction file?", 0, "Confirmation", 4 + 32) >> %tmp%\tmp.vbs
echo WScript.Quit response >> %tmp%\tmp.vbs

:: Run the VBScript and capture the response
cscript //nologo %tmp%\tmp.vbs
set "response=%errorlevel%"

:: Clean up the temporary VBScript file
del %tmp%\tmp.vbs

:: Check the response
if %response%==6 (
    echo Cleaning disk 0.

    :: Create the instruction file in %tmp%
    (
        diskpart
        select disk 0
        clean     
        exit

    ) > "%tmp%\pre-clean-disk-PE.txt"

    echo Instruction file created at: %tmp%\pre-clean-disk-PE.txt
) else (
    echo Closing script.
    exit /b
)

endlocal
