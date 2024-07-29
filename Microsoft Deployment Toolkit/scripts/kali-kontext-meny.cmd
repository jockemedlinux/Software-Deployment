@echo off

reg add "HKEY_CLASSES_ROOT\Directory\background\shell\KALI Desktop"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\KALI Desktop" /f /v Icon /d "C:\Program Files\WSL\kali\kali.ico"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\KALI Desktop\command"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\KALI Desktop\command" /f /ve /d "C:\Program Files\WSL\kali.exe -d kali-linux -- bash --rcfile ~/.bashrc2"

reg add "HKEY_CLASSES_ROOT\Directory\background\shell\KALI Terminal"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\KALI Terminal" /f /v Icon /d "C:\Program Files\WSL\kali\kali.ico"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\KALI Terminal\command"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\KALI Terminal\command" /f /ve /d "C:\Program Files\WSL\kali.exe -d kali-linux"

REM Lägger till administratör rättigheter för WSL.exe & KALI.exe
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /f /v "C:\Program Files\WSL\wsl.exe" /d "^ RUNASADMIN"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /f /v "C:\Program Files\WSL\kali.exe" /d "^ RUNASADMIN"