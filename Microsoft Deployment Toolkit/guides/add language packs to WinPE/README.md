# Add language packs to WinPE.

Steps taken:

1. Mount Boot WIM
2. Install / Add desired langpack
3. Close and commit image.

```
dism /mount-wim /WimFile:.\LiteTouchPE_x64.wim /index:1 /MountDir:C:\WIM-MOUNT
dism /Image:"C:\mount" /Add-Package /PackagePath="C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\sv-se\lp.cab"
dism /Unmount-Wim /MountDir:C:\WIM-MOUNT /Commit
```

## Set the InputLocale (for CMD) in WinPE
```
dism /mount-wim /WimFile:.\LiteTouchPE_x64.wim /index:1 /MountDir:C:\WIM-MOUNT
dism /image:C:\WIM-MOUNT /Set-InputLocale:sv-SE
dism /Unmount-Wim /MountDir:C:\WIM-MOUNT /Commit
```