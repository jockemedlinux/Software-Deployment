;################################
;#MDT-verkstans tips and tricks##
;################################
;######## JML 2024-10-26 ########
;################################

;##########################
;####### SKRIPT-SETTINGS ##
;##########################

#Persistent
#SingleInstance Force

;##########################
;####### FUNKTIONER #######
;##########################

^r:: ; Ctrl+R - Starta om datorn.
   MsgBox, 0,, Din dator startas nu om
   Run, powershell.exe -ExecutionPolicy Bypass -Command "Restart-Computer -Force", ,Hide
return

;#############################

;#############################
;### STANDARD APPLIKATIONER###
;#############################

!e:: ; Alt+E hotkey - Öppna Explorer
    Run, "%SystemDrive%\Windows\System32\Explorer.exe"
return

!n:: ; Alt+N hotkey - Öppna notepad
    Run, "%SystemDrive%\Windows\notepad.exe"
return

!r:: ; Alt+R hotkey
    Run, "%SystemDrive%\Windows\regedit.exe"
return

;##########################

;##########################
;###### CUSTOM APPS #######
;##########################

^l:: ; Ctrl+L - Öppna BDD liveloggen med CMtrace
   Run, cmd.exe /c reg.exe ADD "HKU\winpe\Software\Classes\.lo_" /ve /d "Log.File" /f, , Hide
   Run, cmd.exe /c reg.exe ADD "HKU\winpe\Software\Classes\.log" /ve /d "Log.File" /f, , Hide
   Run, %SystemRoot%\System32\mm\utilities\cmtrace.exe %SystemDrive%\MININT\SMSOSD\OSDLOGS\BDD.log
return

!x:: ; Alt+X hotkey - Starta ProcessExplorer
    Run, reg.exe ADD "HKCU\Software\Sysinternals\Process Explorer" /v EulaAccepted /t REG_DWORD /d 1 /f, , Hide
    Run, "%SystemRoot%\System32\mm\utilities\procexp64.exe"
return

!l:: ; Alt+L hotkey - Ändra Keyboard-inställningar i CMD
    Run, "%SystemRoot%\System32\mm\utilities\ChangeKeyboardLayout.cmd"
return

!s:: ; Alt+S hotkey - Starta screenme och ta en screenshot
    Run, "%SystemRoot%\System32\mm\utilities\screenme.exe"
return

!t:: ; Alt+T hotkey - Starta TCP-View
    Run, "%SystemRoot%\System32\mm\utilities\tcpview64.exe"
return

!v:: ; Alt+V hotkey - Kör ett skript som enumerarer installerade .NET versioner
    Run, "%SystemRoot%\System32\mm\utilities\DotNetVer.exe"
return

!w:: ; Alt+W hotkey - Starta sysinternals WinObject
    Run, "%SystemRoot%\System32\mm\utilities\Winobj64.exe"
return

F7:: ; F7 hotkey - Starta 7zip
    Run, "%SystemRoot%\System32\mm\utilities\7-Zip\7zFM.exe"
return

F9:: ; F9 hotkey - Öpnna powershell
    Run, cmd /c "color 8F & powershell.exe -ExecutionPolicy Bypass"
return

F10:: ; F10 hotkey - Dumpa alla TaskSequence variabler. (OBS! Fungerar först när BDD kört sitt ZTIutility and ZTIGather skript.)
    Run, powershell.exe -NoProfile -ExecutionPolicy Bypass %SystemRoot%\System32\mm\utilities\DumpVar.ps1
return

F5:: ; F5 hotkey - Starta om din Deploy
    Run, cmd.exe /c X:\Windows\System32\BDDRUN.exe /bootstrap
Return

;##########################
;### VARIABLES TO ALTER ###
;##########################
;(OBS! Fungerar först när BDD kört sitt ZTIutility and ZTIGather skript.)

!d:: ; Alt+D hotkey - Toggla TSDebugMode
    Run, powershell.exe -Command "$TSEnv = New-Object -comobject Microsoft.SMS.TSEnvironment; $TSEnv.Value('TSDebugMode') = 'TRUE'", , Hide
return

!p:: ; Alt+P - Pausa din TS.
    Run, powershell.exe -Command "$TSEnv = New-Object -COMobject Microsoft.SMS.TSEnvironment; $TSEnv.Value('pause') = 'TRUE'", , Hide
return

;##########################
;##########################
;##########################

Esc::ExitApp  ; Emergency Exit
    Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Stop-Process -Name WallpaperHost -Force -ErrorAction SilentlyContinue", , Hide
    Sleep, 2000
    Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Copy-Item $env:SystemRoot\System32\winpe.bmp.bak $env:SystemRoot\System32\winpe.bmp -Force", , Hide
    Sleep, 2000
    Run, cmd.exe /c "%SystemRoot%\System32\WallpaperHost.exe" &, , Hide
return