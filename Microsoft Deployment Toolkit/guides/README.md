# MDT Boot-file process
### Make changes to boot images.
```
1. Mount WIM-file (LiteTouch_x64.wim)
2. Make changes
3. Commit.
4. Fool MDT
5. Done.

For changes to ACTUALLY take effect you need to fool MDT to update your "LiteTouch_x64.iso" as well. 
If you only made changes to the .wim file but not the DeploymentShare, nothing will actually be commited into the boot.wim imagefile inside of your "LiteTouch_x64.iso"
To work around this problem you can open up any script in \Scripts\* and make any irrelevant changes to a file. This will give it a new hash, which in turn when updating image file MDT will find and then recreate the ISO image and thus updating the Boot.wim file inside \Sources\ of the ISO file.
Such a hassle.

So this is a 3-4 step process...

"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\en-us\winpe.wim" = template file for creating LiteTouch_x64.wim
"D:\SoftwareDeployment\MDT\SHARE$\Boot\LiteTouchPE_x64.wim" =  WIM-file to be copied into Boot.wim inside the ISO.
"<MOUNTEDISOIMAGE>:\Sources\Boot.wim" = The actual Boot.wim file which will Deploy onto the system.

To update "<MOUNTEDISOIMAGE>:\Sources\Boot.wim" you need to either fool MDT by editing files in the share and throw off the HASH or do it manually with steps like

1. cd: "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment"
2. copype amd64 C:\WinPE_amd64
3. MakeWinPEMedia /ISO C:\WinPE_amd64 C:\LiteTouch_x64.iso
```

# DISM
### Enable VirtualMachinePlatform and Hyper-V in a Windows environment.
```
#Enable
dism.exe /online /enable-feature /all /featurename:microsoft-hyper-v
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /norestart

#Disable
dism.exe /online /disable-feature /featurename:microsoft-hyper-v
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /norestart
```

### Working with WIM-files (pwsh)
```
DISM /Get-ImageInfo /ImageFile:$wimfile.wim
DISM /Mount-Wim /WimFile:$wimfile.wim /MountDir:C:\WIM\$wimfile.wim /Index:1
DISM /Mount-Wim /WimFile:$wimfile.wim /MountDir:C:\WIM\$wimfile.wim /Name:WindowsServer2019
DISM /Unmount-Image /MountDir:C:\WIM\$wimfile.wim /Commit
DISM /Unmount-Image /MountDir:C:\WIM\$wimfile.wim /Discard

DISM /Image:.\mounted /Add-Driver /Driver:<path-to-drivers> /Recurse
DISM /Image:.\mounted /Add-Driver /Driver:<path-to-drivers> /Recurse /ForceUnsigned
```
### Manually add specific drivers to the WinPE.wim file
```
DISM /mount-wim /WimFile:<PATH TO WIM-FILE> /index:1 /MountDir:C:\<PATH TO MOUNT-LOCATION>
DISM /Image:C:\<PATH TO MOUNT-LOCATION> /Add-Driver /Driver:C:\<PATH TO DRIVERS>\ /Recurse
DISM /Unmount-Wim /MountDir:C:\<PATH TO MOUNT-LOCATION> /Commit
```
### Check health and repair with DISM
```
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /RestoreHealth /Source:C:\path\to\sources\install.wim /LimitAccess
```

# CMD
### Add CMD-keys to you session to access remote places.
```
cmdkey /add:$HOST /user:$USER /pass:$PASS
cmdkey /del:$HOST 
```
### Bypass adding a microsoft account when installing a new instance of Windows.
```
Shift+F10
OOBE\BYPASSNRO
```
# Powershell
### Online / Offline a External HDD
```
Set-Disk -Number 5 -Offline $true
Set-Disk -Number 5 -Offline $false
```
### Disable Default Switch for WSL
```
Get-NetAdapter -IncludeHidden | Where-Object -Property Name -Like "*Default*" | Disable-NetAdapter
Get-NetAdapter -IncludeHidden | Where-Object -Property Name -Like "*Default*" | Enable-NetAdapter
```

# Hyper-V
### Enable nested virtualization for VM's
```
//Enable
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true

//Disable
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $false
```

### Hot plug a external HDD drive to Hyper-V VM.
```
1.Connect USB-drive
2.Make sure its offline
3.Link it to a VM
```

### Enable Remote Desktop with Enhanced Session Mode
```
//Enable
Set-VM <VMName> -EnhancedSessionTransportType HVSocket

//Disable
Set-VM <VMName> -EnhancedSessionTransportType VMBus

## This step also requires editing the xrdp.ini file inside the linux system
more info: https://www.kali.org/docs/virtualization/install-hyper-v-guest-enhanced-session-mode/
```

# VirtualBox
### Enable / Disable hypervisor (also known as turtle Icon)
```
#Make sure to remove Hyper-V from Windows. Type 1 HyperVisor (Hyper-V) cannot coexist with type 2 HyperVisor VirtualBox in a windows environment.

//Disable
bcdedit /set hypervisorlaunchtype off

//Enable
bcdedit /set hypervisorlaunchtype auto 
```

### Map a RAW disk (a usb for instance)
```
.\VBoxManage.exe createmedium disk --filename usb1.vmdk --format=VMDK --variant RawDisk --property RawDrive=\\.\PhysicalDrive2
```

### Create a dhcp-server or internal network for labs
```
# Go to "C:\Program Files\Oracle\Virtualbox\"
// List current dhcpservers
.\vboxmanage.exe list dhcpservers

// Create a network with dhcp-server
.\vboxmanage.exe dhcpserver add --network=<name> --server-ip=192.168.10.1 --lower-ip=192.168.10.1 --upper-ip=192.168.10.100 --netmask=255.255.255.0 --enable

//Remove dhcpserver network
.\vboxmanage.exe dhcpserver remove --network=<name>
```

### Use VirtualBox to clone/format virtual disks.
```
//Reformat VHDX to VDI
./VBoxManage.exe clonehd C:\Users\redpill\Desktop\$NAME.vhdx C:\Users\redpill\Desktop\$NAME.vdi --format VDI

//Shrink existing vdi
./VBoxManage.exe modifymedium disk "C:\path\to\disk.vdi" --compact
```

# QEMU
### Use QEMU to reformat between multiple Virtual Disks Formats.
```
# https://www.qemu.org/download/

//VHDX to VHD:
qemu convert -p -f vhdx -O vpc image.vhdx image.vhd

//VMDK to RAW:
qemu convert -p -f vmdk -O raw image.vmdk image.img

//RAW to VMDK:
qemu convert -p -f raw -O vmdk image.img image.vmdk

//VMDK to VHD
qemu convert -p -f vmdk -O vpc image.vmdk image.vhd

//VMDK to VHDX
qemu convert -f vmdk -O vhdx image.vmdk image.vhdx
```

# WMIC
### Get product key of a windows instance
```
wmic path SoftwareLicensingService get OA3xOriginalProductKey
```

# GROUP POLICY KEYS
### Admin Approval Mode
#### Set admin users to actually admin, not restricted admins. (warning, never do this.)
```
User Account Control: Admin Approval Mode for the Built-in Administrator account 	| Disabled (standard)
User Account Control: Run all admiistrators in Admin Approval Mode 					| Disable
Now your admin user is actually admin.

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "FilterAdministratorToken" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0

```

# NETWORKING
### Set Up NAT VM-Switch
New-VMSwitch -Name "VM-net" -SwitchType Internal
New-NetIPAddress -InterfaceAlias "vEthernet (VM-net)" -IPAddress 192.168.17.1 -PrefixLength 24
New-NetNat -Name "VM-net" -InternalIPInterfaceAddressPrefix 192.168.17.0/24

# PUBLIC GUIDES
#### Manually create WinPEIso Media
```
https://4sysops.com/archives/create-a-winpe-bootable-disk-with-windows-11/
```