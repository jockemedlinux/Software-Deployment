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
DISM /Umount-Image /MountDir:C:\WIM\$wimfile.wim /Commit
DISM /Umount-Image /MountDir:C:\WIM\$wimfile.wim /Discard
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
```



# PUBLIC GUIDES
#### Manually create WinPEIso Media
```
https://4sysops.com/archives/create-a-winpe-bootable-disk-with-windows-11/
```