#KONFIGURERA KALI-WSL PÅ KLIENT
#JOCKE 2023-12-20
#AFRY
Start-Transcript -Path "$env:USERPROFILE\Desktop\kali-wsl-del1.txt" -Append

#DEFINERA KÄLLA OCH DESTINATION
$sourcePath = "<REDACTED>"
$destinationPath = "C:\Program Files\WSL\kali"

# DEFINERA NÖDVÄNDIGA FEATURES
$vmPlatformFeature = "VirtualMachinePlatform"
$wslFeature = "Microsoft-Windows-Subsystem-Linux"

# FUNKTION FÖR ATT KOLLA FEATURES
function IsFeatureEnabled($featureName) {
    $featureStatus = Get-WindowsOptionalFeature -Online -FeatureName $featureName
    return $featureStatus.State -eq "Enabled"
}

# FUNKTION FÖR STARTA OM DATORN OCH VIDTA SCRIPT AUTOMATISKT
function RestartScript {
    Write-Host -ForegroundColor Red "[!] SKJUTER IN OMSTARTSFUNKTION"
    $value = "powershell.exe -WindowStyle Maximized -NoExit -File $env:USERPROFILE\Desktop\kali-RefInst.ps1 -Verb RunAs"
    $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
    New-ItemProperty -Path $regPath -Name "kali-auto-resume-wsl-script" -Value $value -PropertyType String -Force
    Stop-Transcript
    Start-Sleep 10
    Restart-Computer
    exit 0
}

Write-Host -ForegroundColor Yellow "[?] Kollar Virtual Machine Platform..."
Write-Host -ForegroundColor Yellow "[?] Kollar Microsoft-Windows-Subsystem-Linux.."

# VMP
if (-not (IsFeatureEnabled $vmPlatformFeature)) {
    Write-Host -ForegroundColor Red "[!] VMP inte aktiverad"
    Write-Host -ForegroundColor Green "[+] Aktiverar Virtual Machine Platform..."
    dism.exe /online /enable-feature /featurename:$vmPlatformFeature /all /norestart
}

# WSL
if (-not (IsFeatureEnabled $wslFeature)) {
    Write-Host -ForegroundColor Red "[!] WSL inte aktiverad"
    Write-Host -ForegroundColor Green "[+] Aktiverar Microsoft-Windows-Subsystem-Linux feature..."
    dism.exe /online /enable-feature /featurename:$wslFeature /all /norestart
    Write-Host -ForegroundColor Red "[!] VIKTIGT: DIN DATOR STARTAS AUTOMATISKT OM STRAX"
    RestartScript
}

Start-Transcript -Path "$env:USERPROFILE\Desktop\kali-wsl-del2.txt" -Append

Write-Host -ForegroundColor Green "[+] Microsoft-Windows-Subsystem-Linux redan aktiverad.."
Write-Host -ForegroundColor Green "[+] VirtualMachinePlatform redan aktiverad.."

Write-Host ""
Read-Host  "[?] REDO? [Tryck ENTER]"
Write-Host ""
Write-Host ""

Write-Host -ForegroundColor Green "[+] Startar procedur om 10 sekunder.."
Write-Host -ForegroundColor Green "[+] Skjuter in MDT-credentials.."
Start-Sleep 10

#LÄGGER TILL RÄTT RÄTTIGHETER EFTER OMSTART.
Start-Process "$env:USERPROFILE\Desktop\Skapa_MDT-credentials.cmd"

#INSTALLERAR SENASTE WSL
Write-Host -ForegroundColor Green "[+] Installerar WSL2.."
wsl --update

Write-Host -ForegroundColor Green "[+] Startar fil-kopiering m.m.."
Write-Host -ForegroundColor Green "[+] Skapar mapp om den saknas.."
# SKAPA KALI MAPP OM DEN INTE REDAN FINNS.
if (-not (Test-Path -Path $destinationPath -PathType Container)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}

Write-Host -ForegroundColor Green "[+] Plockar hem fil-lista.."

#HÄMTA ALLA FILER I KÄLLMAPPEN
$items = Get-ChildItem -Path $sourcePath

#VISA EN PROGRESS-BAR FÖR INDIKERING PÅ ATT SRKIPTET FAKTISKT GÖR NÅGOT
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
#Write-Host -ForegroundColor Green "[+] Installerar Powershell 7. Startar egen ruta. Kontrollera att det blir klart."
#Start-Process "C:\Program Files\WSL\kali\choco_install_powershell_7.exe"
#Start-sleep 10

#LÄGG TILL SÖKVÄGEN TILL RÄTT LINUX-KÄRNA I ANVÄNDARENS "PATH"
Write-Host "Skapar variabel till WSL och KALI i \$PATH"
[System.Environment]::SetEnvironmentVariable("PATH", "C:\Program Files\WSL\;$($env:PATH)", [System.EnvironmentVariableTarget]::Machine)

#KOPIERA WSL.exe till KALI.exe så att "kali" i cmd funkar.
copy "C:\Program Files\WSL\wsl.exe" "C:\Program Files\WSL\kali.exe"

#SKAPA NY GENVÄG TILL START-MENYN
Write-Host -ForegroundColor Green "[+] Ordnar ikon i startmenyn"
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\WSL.lnk"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\KALI.lnk")
$shortcut.TargetPath = "C:\Program Files\WSL\kali.exe"
$shortcut.Save()

#KÖR IGÅNG KONTEXT-MENY-CMD FILEN FÖR HÖGERKLICK TILL KALI.
Write-Host -ForegroundColor Green "[+] Skapar kommando i kontextmenyn. 'KALI Terminal och KALI Desktop'"
Start-Process "C:\Program Files\WSL\kali\kali-kontext-meny.cmd"

Write-Host -ForegroundColor Green "[+] Skriptet klart! Se till att powershell choco blir klart."
Stop-Transcript
Start-Sleep 3
exit 0