cls
Set-ExecutionPolicy Bypass

function prompt {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$time PS $PWD> "
}

Write-Host -ForeGroundColor Yellow "+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+"
Write-Host -ForeGroundColor Yellow "|W|i|n|P|E| |P|o|w|e|r|S|h|e|l|l|"
Write-Host -ForeGroundColor Yellow "+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+"

# Attempt to create the COM object and handle errors
try {
    $TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment
    # Output the value of DEPLOYROOT
    Write-Host "DeployRoot:       $($TSEnv.Value(`"DEPLOYROOT`"))`n" -ErrorAction SilentlyContinue -ForegroundColor GREEN
} catch {
    Write-Host "Error: Microsoft.SMS.TSEnvironment har inte laddats in ännu. Vänta på TaskSequence.`n" -ForegroundColor Red
}

# Get the current execution policy
$currentPolicy = Get-ExecutionPolicy
$powerschema = powercfg /getactivescheme

# Output the execution policy to the host
Write-Host "Execution Policy: $currentPolicy" -ForegroundColor GREEN
Write-Host "Du är:            $env:USERNAME" -ForegroundColor GREEN
Write-Host "Prestanda-schema  $powerschema" -ForegroundColor GREEN
