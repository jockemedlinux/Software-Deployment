try {
    # Define the list of variables to exclude
    $excludeList = @(
        "_SMSTSTaskSequence", 
        "", 
        ""
    ) # Add the variable names you want to exclude

    # Attempt to create the COM object
    $tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment

    # Determine where to do the logging
    $logFile = "$($tsenv.Value("DEPLOYROOT"))\DumpedVars.log"

    # Start the logging
    Start-Transcript $logFile

    # Prompt the user for a specific variable to search for
    $searchVariable = Read-Host -Prompt "Enter a variable name to search for (leave blank to log all variables)"

    # Write all the variables and their values, excluding those in the exclude list
    $tsenv.GetVariables() | ForEach-Object {
        $varName = $_
        if ($excludeList -notcontains $varName) {
            # If a search variable is provided, check if it matches
            if (-not [string]::IsNullOrEmpty($searchVariable)) {
                if ($varName -like "*$searchVariable*") {
                    Write-Host "$varName = $($tsenv.Value($varName))"
                }
            } else {
                # If no search variable is provided, log all variables
                Write-Host "$varName = $($tsenv.Value($varName))"
            }
        }
    }

    # Stop logging
    Stop-Transcript
    Read-Host -Prompt "Press Enter to exit"
} catch {
    # Handle the error
    Write-Host "Microsoft.SMS.TSEnvironment är inte laddad ännu." -ForegroundColor RED
    Read-Host -Prompt "Press Enter to exit"
}
