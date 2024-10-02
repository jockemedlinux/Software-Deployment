# MECM
## Microsoft Endpoint Configuration Manager

### Bypass TaskSequence selection for "Offline Media"
-> Create Task Sequence Media
-> Go throuh the GUI
-> Add a prestart command.

```powershell
// WITH CMD
cmd.exe /c set SMSTSPreferredAdvertID=Deploy Windows 11

// WITH POWERSHELL
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& { $tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment; $tsenv.Value('SMSTSPreferredAdvertID') = 'Deploy Windows 11' }"


https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/using-task-sequence-variables
https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/task-sequence-variables
```

### Create a custom Unattend.xml file.
-> Use Windows Image System Manager   
-> Open your .wim media   
-> Create new unattend.xml file in the middle window   
-> Drag to middle window:   
```
---> amd64_Microsoft-Windows-Shell-Setup_10.0.<Build-Nummer>_neutral   
---> amd64_Microsoft-Windows-International-Core_10.0.<Build-Nummer>_neutral   
```
-> Mount WIM.   
-> Apply unattend.xml to mounted wim.   
-> Commit.   

```powershell
DISM /Mount-Wim /WimFile:<Path to .WIM file> /index:<your install index> MountDir:<path to mount dir>
DISM /image:<path to mounted image> /Apply-Unattend:<path to unattend.xml>
DISM /Unmount-Wim:<path to mounted image> /MountDir:<path to mounted image> /Commit 

https://4sysops.com/archives/use-unattendxml-to-skip-out-of-box-experience-oobe-when-installing-windows-11/
```
