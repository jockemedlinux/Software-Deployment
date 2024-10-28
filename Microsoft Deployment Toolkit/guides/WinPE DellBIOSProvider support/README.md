# Support DellBIOSProvider in Win-PE

In order to make DellBIOSProvider powershell module to work in a WinPE environment you need to do a few things.   

1. Copy the DellBIOSProvider Module folder to: ${env:ProgramFiles}\WindowsPowerShell\Modules\DellBIOSProvider   
2. copy the dll files from the DLL folder into: ${env:ProgramFiles}\WindowsPowerShell\Modules\DellBIOSProvider   

This is to be done inside of the WinPE image. That is for example. LiteTouchPE_x64.wim.   

After this is done. You can load up a Powershell, Run "Import-Module DellBIOSProvider".    
Then you can access all BIOS settings from "DellSmbios:\" created SmbShare.    
More info on how to navigate and use the tool on Dells homepage.   