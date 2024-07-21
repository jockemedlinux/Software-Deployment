#DEFINERA KÄLLA OCH DESTINATION
$sourcePath = "\\#REDACTED#\KALI WSL\*"
$destinationPath = "C:\Program Files\WSL\kali"

# DEFINERA NÖDVÄNDIGA FEATURES
$vmPlatformFeature = "VirtualMachinePlatform"
$wslFeature = "Microsoft-Windows-Subsystem-Linux"

# FUNKTION FÖR ATT KOLLA FEATURES
function IsFeatureEnabled($featureName) {
    $featureStatus = Get-WindowsOptionalFeature -Online -FeatureName $featureName
    return $featureStatus.State -eq "Enabled"
}

# VMP
if (-not (IsFeatureEnabled $vmPlatformFeature)) {
    Write-Host -ForegroundColor Green "Aktiverar Virtual Machine Platform..."
    dism.exe /online /enable-feature /featurename:$vmPlatformFeature /all /norestart
}

# WSL
if (-not (IsFeatureEnabled $wslFeature)) {
    Write-Host -ForegroundColor Green "Aktiverar Microsoft-Windows-Subsystem-Linux feature..."
    dism.exe /online /enable-feature /featurename:$wslFeature /all /norestart
    Write-Host -ForegroundColor Red       "[!] VIKTIGT: STARTA OM DATORN OCH EXEKVERA SKRIPTET IGEN SEN."
    Write-Host -ForegroundColor Red       "[!] Din dator startas automatiskt om inom 5 sekunder..."
    Start-Sleep 5
    Restart-Computer -Force
    exit 1
}


#####

Write-Host "Microsoft-Windows-Subsystem-Linux redan aktiverad.."
Write-Host "VirtualMachinePlatform redan aktiverad.."
Write-Host "Startar procedur.."
Start-Sleep 5

Write-Host "Installerar WSL2.."
wsl --update

Write-Host "Skapar mapp om den saknas.."
# SKAPA KALI MAPP OM DEN INTE REDAN FINNS.
if (-not (Test-Path -Path $destinationPath -PathType Container)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

Write-Host "Plockar fil-lista.."
#HÄMTA ALLA FILER I KÄLLMAPPEN
$items = Get-ChildItem -Path $sourcePath

#VISA EN PROGRESS-BAR FÖR INDIKERING PÅ AATT SRKIPTET FAKTISKT GÖR NÅGOT
$progressParams = @{
    Activity = 'Kopierar filer. Detta kan ta en liten stund..'
    Status = 'Kopierar...'
    PercentComplete = 0
}

Write-Progress @progressParams

#KOPIERA FILER TILL DESTINATION
foreach ($item in $items) {
    Copy-Item -Path $item.FullName -Destination $destinationPath -Force
    $progressParams.PercentComplete = ($items.IndexOf($item) + 1) / $items.Count * 100
    Write-Progress @progressParams
}

#FÄRDIGSTÄLL PROGRESS-BAR
$progressParams.Status = 'Kopiering klar..'
$progressParams.PercentComplete = 100
Write-Progress @progressParams

################################
###YTTERLIGGARE INSTÄLLNINGAR###
################################

#INSTALLERA POWERSHELL 7
Write-Host "Installerar Powershell 7. Startar eget window. Kontrollera att det blir klart."
Start-Process "C:\Program Files\WSL\kali\choco_install_powershell_7.exe"
start-sleep 10

Write-Host "Skapar variabel till WSL och KALI i \$PATH"
#LÄGG TILL SÖKVÄGEN TILL RÄTT LINUX-KÄRNA I ANVÄNDARENS "PATH"
[System.Environment]::SetEnvironmentVariable("PATH", "C:\Program Files\WSL\;$($env:PATH)", [System.EnvironmentVariableTarget]::Machine)

#KOPIERA WSL.exe till KALI.exe så att kali i cmd funkar.
copy "C:\Program Files\WSL\wsl.exe" "C:\Program Files\WSL\kali.exe"

Write-Host "Ordnar ikon i startmenyn"
#SKAPA NY GENVÄG TILL START-MENYN
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WSL.lnk"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\KALI.lnk")
$shortcut.TargetPath = "C:\Program Files\WSL\kali.exe"
$shortcut.Save()

Write-Host "Skapar kommando i kontextmenyn. 'KALI Terminal och KALI Desktop'"
#KÖR IGÅNG KONTEXT-MENY-CMD FILEN FÖR HÖGERKLICK TILL KALI.
Start-Process "C:\Program Files\WSL\kali\kali-kontext-meny.cmd"

Write-Host "Skriptet klart!"
Start-Sleep 3