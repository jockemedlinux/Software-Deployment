# FUC - Frequently Used Commands

### connect share from inside PE:
```
net use Z: \\10.25.0.1\share$ /user:RAMbunctious\mdt mdt
```

### compile .exe
```
Invoke-PS2EXE -inputFile .\pre-clean-disk.ps1 -outputFile .\pre-clean-disk.exe -NoConsole -Icon D:\system\icons\mdt.ico

Invoke-PS2EXE -inputFile .\pre-clean-disk.ps1 -outputFile .\pre-clean-disk.exe -NoOutput -NoConsole -Icon D:\system\icons\mdt.ico
```

### Mess with WIM
```
dism /mount-wim /wimfile:LiteTouchPE_x64.wim /mountdir:C:\WIM-MOUNT\ /index:1
dism /Unmount-Wim /MountDir:C:\WIM-MOUNT /Commit
dism /image:C:\WIM-MOUNT /Set-InputLocale:sv-SE
```

### DeploymentShare via Powershell
```
net share \\RAMBUNCTIOUS\share$ /REMARK:"DeploymentShare" /GRANT:mdt FULL /GRANT:admin FULL /add
net share D:\SoftwareDeployment\MDT\RAMbunctious /delete
```