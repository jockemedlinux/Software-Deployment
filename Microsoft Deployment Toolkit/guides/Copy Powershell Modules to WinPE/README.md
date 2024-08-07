# Copy Powershell Modules

```
//Mount the LiteTouch Boot Wim file
dism /mount-wim /WimFile:.\LiteTouchPE_x64.wim /index:1 /MountDir:C:\WIM-MOUNT

//Copy the powershell moduel to the bootiles psmodulepath
xcopy /E /H /I D:\_MDT\_shares\_poweshell-modules\* C:\WIM-MOUNT\Windows\System32\WindowsPowerShell\v1.0\Modules\

//Unmount the wim boot file
dism /Unmount-Wim /MountDir:C:\WIM-MOUNT /Commit

Go to MDT and generate a new Boot-ISO
```