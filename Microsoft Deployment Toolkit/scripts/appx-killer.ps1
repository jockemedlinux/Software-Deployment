<#
AppX killer
#>

<#
.SYNOPSIS
Kör igenom sysprep och kontrollerar paket som kommer stoppa sysprep.

.PARAMETER arguments
Argumenten att köra sysprep med. Spelar egentligen ingen roll eftersom skriptet dödar sysprep processen direkt efter start.

.PARAMETER setupactlog
setupact.log sökvägen

.PARAMETER trasigapaket
Leta reda på trasiga paket

.PARAMETER loggfil
En fil för att spara loggar. specificera med "-loggfil"

.EXAMPLE
'.\appx.ps1' -Verbose -Confirm:$false
'.\appx.ps1' -Verbose -Confirm:$false -loggfil .\appx.log
'.\appx.ps1' -Verbose -Confirm:$false -verbose -loggfil .\appx.log
#>

[CmdletBinding(SupportsShouldProcess=$True, ConfirmImpact='High')]
Param
(   
    [string]$arguments = '/generalize /oobe /quiet /quit',
    [string]$setupactlog = (Join-Path ([environment]::getfolderpath('system')) 'Sysprep\Panther\setupact.log'),
    [string]$trasigapaket = ',\s+Error\s+SYSPRP Package (.*) was installed for a user, but not provisioned for all users\. This package will not function properly in the sysprep image\.',
    [string]$loggfil
)

if (! [string]::IsNullOrEmpty($loggfil)) 
{
    Start-Transcript -Path $loggfil
}

try {
    Import-Module Appx, Dism -verbose:$false
    [string]$lastError = $null
    
        While ($true) 
            {
                #Write-Verbose "$counter : $(Get-Date -Format G)"
                $sysprep = Start-Process -FilePath (Join-Path ([environment]::getfolderpath('system')) 'Sysprep\sysprep.exe') -ArgumentList $arguments -PassThru -ErrorAction Stop
                Start-Sleep 5
                $sysprep | Stop-Process -Force  
                          
                if ($sysprep.HasExited -eq $false) 
                    {
                        $sysprep | Stop-Process -Force
                    }

                if (!(Test-Path -Path $setupactlog -PathType Leaf -ErrorAction SilentlyContinue)) 
                    {
                        Throw "Hittade inte sysprep loggen. Startade progremmet ordentligt? $setupactlog"
                    }
        
                $sysprepError = Get-Content $setupactlog | Where-Object { $_ -match $trasigapaket } | Select -Last 1
                
                if ([string]::IsNullOrEmpty($sysprepError)) 
                    {
                        Throw "Hittade inga paket i loggen `"$regex`""
                    }
        
                if (![string]::IsNullOrEmpty($matches[1])) 
                    {
                    if ($lastError -eq $Matches[1]) 

                    {
                        if ($sysprep.HasExited -eq $false) 
                            {
                                $sysprep | Stop-Process -Force
                            }
                    
                    Throw "Kunde inte ta bort paket... $($matches[1])"
                    
                    }
            
                if ($PSCmdlet.ShouldProcess($matches[1], 'Rensar AppX-paket')) 
                    {
                        Write-Verbose "Tar bort paket: $($matches[1]) ..."
                        Remove-AppXPackage -Package $Matches[1] -AllUser
                        $lastError = $Matches[1]    
                        echo "$($matches[1])" >> ".\felande-paket.log"
                    }
                }   
            } #END OF WHILE LOOP
        } #END TRY LOOP

catch 
{
    Throw $_
}

Finally
{
    if (! [string]::IsNullOrEmpty($loggfil)) 
        {
            Stop-Transcript
        }
}