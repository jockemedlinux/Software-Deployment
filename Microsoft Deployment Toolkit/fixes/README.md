# MDT Specifics
### Fix error when entering "Windows PE" x86
```
xcopy /E /H /I "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64" "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\x86"
```

### Install DaRT-tools
```
Get the file "DaRT_FILES_mu_microsoft_desktop_optimization_pack_2015_x86_x64_dvd_5975282.iso"

Open up 
Install DaRT V10
Take .cab files and put into Share\Tools\x86 Share\Tools\x64
```

### Change information in deployment windown
```
In LiteTouch.wsf.

change:
oEnvironment.Item("_SMSTSPackageName") = oEnvironment.Item("TaskSequenceName") 
```

### Set logfiles to date/time
```
https://www.deploymentresearch.com/naming-logs-folder-in-mdt-after-date-and-time/

SLSHARE=MDT01Logs$#month(date) & "-" & day(date) & "-" & year(date) & "__" & hour(now) & "-" & minute(now)#
```