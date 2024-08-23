###################################
###################################
###################################
###################################
############Created by#############
##@jockemedlinux 2023-11-25 18:54##
###################################
###################################
###################################
###################################
###################################
#
# exit code 1 = Wrong HYPER-V configuration version.
# exit code 2 = Too many virtual disks are already mounted.
# exit code 3 = Something else went wrong in the code.
#

do {
cls
Write-Host -ForegroundColor DarkYellow "   ___           __          __  ___        "
Write-Host -ForegroundColor DarkYellow "  / _ \___ ___  / /__  __ __/  |/  /__ ____ "
Write-Host -ForegroundColor DarkYellow " / // / -_) _ \/ / _ \/ // / /|_/ / _ `/  _ \"
Write-Host -ForegroundColor DarkYellow "/____/\__/ .__/_/\___/\_, /_/  /_/\_,_/_//_/"
Write-Host -ForegroundColor DarkYellow "        /_/          /___/                  "
Write-Host -ForegroundColor DarkYellow "================================================."
Write-Host -ForegroundColor DarkYellow "     .-.   .-.     .--.                         |"
Write-Host -ForegroundColor DarkYellow "    | OO| | OO|   / _.-' .-.   .-.  .-.   .''.  |"
Write-Host -ForegroundColor DarkYellow "    |   | |   |   \  '-. '-'   '-'  '-'   '..'  |"
Write-Host -ForegroundColor DarkYellow "    '^^^' '^^^'    '--'                         |"
Write-Host -ForegroundColor DarkYellow "===============.  .-.  .================.  .-.  |"
Write-Host -ForegroundColor DarkYellow "               | |   | |                |  '-'  |"
Write-Host -ForegroundColor DarkYellow "               | |   | |                |       |"
Write-Host -ForegroundColor DarkYellow "               | ':-:' |                |  .-.  |"
Write-Host -ForegroundColor DarkYellow "               |  '-'  |                |  '-'  |"
Write-Host -ForegroundColor DarkYellow "==============='       '================'       |"
Write-Host                              "[*] INFORMATION WRITTEN IN [BRACKETS] ARE DEFAULT VALUES"
Write-Host                              "[*] X's represent sequencing numbers"
Write-Host                              "--------------------------------------------------------------"
Write-Host -ForegroundColor Green       "[+] <- MEANS GOOD JOB"
Write-Host -ForegroundColor DarkYellow  "[?] <- MEANS HEADS-UP"
Write-Host -ForegroundColor Red         "[!] <- NO BUENO, AMIGO"
Write-Host                              "--------------------------------------------------------------"
Write-Host                              "[*] NOW LET'S CREATE A HYPER-V VIRTUAL MACHINE"




#FUNCTIONS
function FolderChecks {
    do {
        # CHECK FOR EXISTING FOLDERS
        $VMHDDpath = "D:\Virtualization\Hyper-V\Virtual Hard Disks\$VMname"
        $VMPath = "D:\Virtualization\Hyper-V\Virtual Machines\$VMname"
        
        $TestVMHDDpath = Test-Path $VMPath
        $TestVMPath = Test-Path $VMHDDpath
        
        if ($TestVMPath -or $TestVMHDDpath) {
            cls
            Write-Host -ForegroundColor DarkYellow "[?] Leftover folders with the same name already exists in VMHDDpath or VMPath"
            Write-Host
            Write-Host                              "--------------------------------------------------------------------------------------"
            Write-Host -ForegroundColor Red "Look here: -> $VMHDDpath"
            Write-Host -ForegroundColor Red "Look here: -> $VMPath"           
            Write-Host                              "--------------------------------------------------------------------------------------"
            Write-Host
            
            $userResponse = Read-Host "[*] Press enter when folders are deleted"
            
            $TestVMHDDpath = Test-Path $VMPath
            $TestVMPath = Test-Path $VMHDDpath
        } 

    } until (-not ($TestVMPath -or $TestVMHDDpath))
}

$VMname = Read-Host -Prompt " -> Name of VM? [WIN11-REF_XXX]"
if ($VMname -eq "") {
    $existingInstances = Get-VM -Name "WIN11-REF*" -ErrorAction SilentlyContinue
    if ($existingInstances -eq $null) {
        # If no existing instances, start with 1
        Write-Host -ForegroundColor Green "[+] NO DUPLICATE VM PRESENT IN HYPER-V" 
        $sequence = 1
        $VMname = "WIN11-REF_$('{0:D3}' -f $sequence)"
        
} else {
        # If there are existing instances, count them and add 1
        Write-Host -ForegroundColor DarkYellow "[?] DUPLICATE VM INSTANCE ALREADY EXISTS. ADDING SEQUENCE NUMBER"
        $sequence = $existingInstances.Count + 1
        $VMname = "WIN11-REF_$('{0:D3}' -f $sequence)"        
    }
}

#CHECK FOR EXISTING FOLDERS
FolderChecks


# Display the generated VM name
Write-Host "[?] Generated VM Name: $VMname" -ForegroundColor DarkYellow

Write-Host "--------------------------------------------------------------"

    $version = Read-Host -Prompt " -> Version? `t`t`t[9.0]"
    if ($version -eq "") {
        $version = "9.0"
    } elseif ($version -gt "11.0" -or $version -lt "8.0") {
        Write-Host -ForegroundColor Red "[!] There is an issue with the Hyper-V configuration version"
        Write-Host -ForegroundColor Red "[!] These are the supported versions for this system." 
        Write-Host -ForegroundColor Red "[!] Exiting" 
        
        Get-VMHostSupportedVersion
        exit 1
    }
    
    $generation = Read-Host -Prompt " -> Generation? `t`t[2]"
        if ($generation -eq "") { $generation = 2 }
    
    $processes = Read-Host -Prompt " -> Processors? `t`t[4]"
        if ($processes -eq "") { $processes = 4 }
    
    $net = Read-Host -Prompt " -> NetworkAdapter? `t`t[Not connected]"
        if ($net -eq "") { $net = "Not connected" }

    $iso = Read-Host -Prompt " -> Set ISO boot image? `t[Not attached]"
        if ($iso -eq "") { $iso = $null }
    
    $size = Read-Host -Prompt " -> VHDX Size? `t`t`t[100GB]"
        if ($size -eq "") { 
            $size = 100
        } else {
            $size = [int]$size
        }
    
    # Convert MB to Bytes
    $sizeinBytes = $size * 1GB
    
    $memory = Read-Host -Prompt " -> Memory? `t`t`t[4096MB]"
        if ($memory -eq "") { 
            $memory = 4096
        } else {
            $memory = [int]$memory
        }
    
    # Convert MB to Bytes
    $memoryInBytes = $memory * 1MB
    
    #DEFINE LOCATION TO HYPER-V MACHINES AND DISKS
    $VMHDDpath = "D:\Virtualization\Hyper-V\Virtual Hard Disks\$VMname"
    $VMPath = "D:\Virtualization\Hyper-V\Virtual Machines\$VMname"   
    $rootpath = (Get-VM).Path[0]
    # Continue with the rest of your script...
    Write-Host ""
    
    Write-Host -ForegroundColor Green "[+] Your machine will be placed here: `t`t'$rootpath'"
    Write-Host -ForegroundColor Green "[+] Your disk will be placed here: `t`t'$VMHDDpath.vhdx'"
    Write-Host -ForegroundColor Green "[+] Boot ISO location: `t`t`t`t'$iso'"
    Write-Host -ForegroundColor Green "[+] Configuration version: `t`t`t'$version'"
    Write-Host -ForegroundColor Green "[+] Generation version: `t`t`t'$generation'"
    Write-Host -ForegroundColor Green "[+] Memory amount [MB]: `t`t`t'$memory'"
    Write-Host -ForegroundColor Green "[+] HDD Size [GB]: `t`t`t`t'$size'"
    Write-Host -ForegroundColor Green "[+] NetAdapter: `t`t`t`t'$net'"
    Write-Host ""
    Write-Host -ForegroundColor DarkYellow "[?] THE SCRIPT WILL RESTART IF 'Y' IS NOT PRESSED. CHECK IT THOROUGHLY" 
} until (($control = Read-Host " -> Are the settings correct? [Y/N]") -eq "Y" -or $control -eq "y")


# CREATE AND PREP PRIMARY VHDXs
$VHDXPath = "$VMHDDPath.vhdx"
New-VHD -Path $VHDXPath -SizeBytes $sizeinBytes -Dynamic | Out-Null
    Write-Host
    Write-Host -ForegroundColor DarkYellow "[?] Preparing new VHDX."
    $VolumeLabel = "AUTOGENERATED"
    Write-Host -ForegroundColor DarkYellow "[?] Preparing new VHDX.."
    Mount-VHD -Path $VHDXPath
    Write-Host -ForegroundColor DarkYellow "[?] Preparing new VHDX..."
    $Disk = Get-Disk | Where-Object { $_.Model -like "*Virtual*" } | Select-Object -ExpandProperty DiskNumber
    #FAILSAFE TO NOT CONFUSE VIRTUAL DISKS.
    if ($Disk.Count -gt 1 ) {
        Write-Host -Foreground Red "[!] Too many virtual disks found. Shutting down as precaution."
        exit 2
    }
    Initialize-Disk $Disk -PartitionStyle GPT
    Write-Host -ForegroundColor DarkYellow "[?] Preparing new VHDX...."
    $Partition = New-Partition -DiskNumber $Disk -UseMaximumSize
    Write-Host -ForegroundColor DarkYellow "[?] Preparing new VHDX....."
    $Volume = Format-Volume -Partition $Partition -FileSystem NTFS -NewFileSystemLabel $VolumeLabel -Confirm:$false
    Write-Host -ForegroundColor DarkYellow "[?] Preparing new VHDX......"  
    Dismount-VHD -Path $VHDXPath
    Write-Host -ForegroundColor DarkYellow "[?] Preparing new VHDX......."
    Write-Host 


# CREATE MACHINE
if ($net -eq "Not connected") {
    New-VM -Name "$VMname" -MemoryStartupBytes "$memoryInBytes" -Generation "$generation" -Version "$version" | Out-Null
}
else {
    New-VM -Name "$VMname" -MemoryStartupBytes "$memoryInBytes" -Generation "$generation" -Version "$version" -SwitchName "$net" | Out-Null
}
Set-VM -Name "$VMname" -ProcessorCount "$processes" -DynamicMemory -EnhancedSessionTransportType HvSocket

if ($generation -eq 2) {
    # IF GENERATION 2
    Set-VMFirmware -VMName "$VMname" -EnableSecureBoot Off
    Add-VMHardDiskDrive -VMName "$VMname" -Path "$VHDXPath" -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0
    
    #Allow nested Virtualization
    Set-VMProcessor -VMname "$VMName" -ExposeVirtualizationExtensions $true

    # Create another SCSI controller with no drive attached
    Add-VMScsiController -VMName "$VMname"
    Add-VMHardDiskDrive -VMName "$VMname" -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 0

    # Create a DVD drive under the second SCSI controller
    Add-VMScsiController -VMName "$VMname"

if ($iso -eq $null) {
    Add-VMDvdDrive -VMName "$VMname" -ControllerNumber 2 -ControllerLocation 0
}
else {
    Add-VMDvdDrive -VMName "$VMname" -ControllerNumber 2 -ControllerLocation 0 -Path "$iso"
}
    
    $vm = Get-VM -Name "$VMname"
    $vmDVDDrive = Get-VMDvdDrive -VM $vm
    Set-VMFirmware -VM $vm -FirstBootDevice $vmDVDDrive
    Set-VMFirmware -VM $vm -FirstBootDevice $vmDVDDrive
    Get-VM "$VMname" | Set-VM -AutomaticCheckpointsEnabled $false
    }

if ($generation -ne 2) {
    # IF GENERATION 1
    Add-VMHardDiskDrive -VMName "$VMname" -Path "$VHDXPath"
    # Create another IDE controller with no drive attached
    Add-VMHardDiskDrive -VMName "$VMname"
    # Create a DVD-Drive
    Set-VMDvdDrive -VMName "$VMname" -Path "$iso"
    }

if ($exit -lt 1) {
    Write-Host -ForegroundColor Green "[+] All done. You are good to go."
    Write-Host -ForegroundColor Green "[+] Remember to change the order of your boot-devices."
    Write-Host -ForegroundColor Green "[+] and add a physical device to boot from if needed."
    exit 0
} else {
    Write-Host "Something went wrong in the script."
    exit 3
}