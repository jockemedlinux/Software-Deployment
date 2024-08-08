Add-Type -AssemblyName PresentationCore,PresentationFramework
Add-Type -AssemblyName System.Windows.Forms  # Add this line to use Windows Forms

# Define message box parameters
$ButtonType = [System.Windows.MessageBoxButton]::YesNo
$MessageIcon = [System.Windows.MessageBoxImage]::Warning
$MessageBody = "Do you want to manually erase disk 0?"
$MessageTitle = "Erase root Disk?!"

# Show the message box and capture the result
$Result = [System.Windows.MessageBox]::Show($MessageBody, $MessageTitle, $ButtonType, $MessageIcon)




function commands {

    
}

# Function to erase Disk 0
function CleanDisk { 

    if ($disk) {
        # Uncomment the next line to actually erase the disk
        # echo ""
        $ButtonType = [System.Windows.Forms.MessageBoxButtons]::OK
        $MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Information
        $MessageBody = "Disk 0 has been completely wiped."
        $MessageTitle = "No turning back"
        [System.Windows.Forms.MessageBox]::Show($MessageBody, $MessageTitle, $ButtonType, $MessageIcon)

    } else {
        $ButtonType = [System.Windows.Forms.MessageBoxButtons]::OK
        $MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Information
        $MessageBody = "Disk 0 has been left alone."
        $MessageTitle = "Phew"
        [System.Windows.Forms.MessageBox]::Show($MessageBody, $MessageTitle, $ButtonType, $MessageIcon)
    }
}

# Check the result of the message box
if ($Result -eq [System.Windows.MessageBoxResult]::Yes) {
    CleanDisk  # Call the function to erase Disk 0
} else {

}
