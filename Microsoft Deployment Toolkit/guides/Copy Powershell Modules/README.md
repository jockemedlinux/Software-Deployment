# Copy Powershell Modules

```
//Mount the LiteTouch Boot Wim file
dism /mount-wim /WimFile:.\LiteTouchPE_x64.wim /index:1 /MountDir:C:\MOUNT

//Copy the powershell moduel to the bootiles psmodulepath
xcopy C:\Users\admin\Desktop\GIT\PUBLIC\DHCPClient-PS C:\MOUNT\Windows\System32\WindowsPowerShell\v1.0\Modules\DHCPClient-PS\

//Unmount the wim boot file
dism /Unmount-Wim /MountDir:C:\MOUNT /Commit

Go to MDT and genereate a new Boot-ISO
```