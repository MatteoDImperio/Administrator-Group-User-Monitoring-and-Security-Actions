$logFile = "C:\Users\pino\Desktop\utentinonautorizzati.txt"
$photoFolder = "C:\Users\pino\Desktop\photo"

# Create the folder if it doesn't exist
if (!(Test-Path $photoFolder)) {
    New-Item -ItemType Directory -Path $photoFolder | Out-Null
}

Write-Host "[INFO] Monitoring active. Waiting for events..." -ForegroundColor Cyan

$lastEvent = ""

while ($true) {
    # Look for event 4732 (user added to a group)
    $events = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=4732)]]" -ErrorAction SilentlyContinue

    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()

        # Check if the event relates to the "Administrators" group
        $groupName = ($xml.Event.EventData.Data | Where-Object { $_.'#text' -match "Administrators" }).'#text'
        
        if ($groupName -eq "Administrators") {
            # Find the username (usually the fourth field in the log)
            $addedUser = $xml.Event.EventData.Data[3].'#text'

            # Avoid processing the same event multiple times
            if ($lastEvent -ne "$addedUser-$event.TimeCreated") {
                $lastEvent = "$addedUser-$event.TimeCreated"
                
                $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                $message = "$timestamp - ALERT: User $addedUser added to the Administrators group!"
                
                # Save the log to the file
                $message | Out-File -Append -FilePath $logFile
                Write-Host "[ALERT] $message" -ForegroundColor Red

                # Show the popup
                Add-Type -AssemblyName "System.Windows.Forms"
                [System.Windows.Forms.MessageBox]::Show("You’ve been tricked by the system administrator (dummy)", "Warning", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)

                # Take a photo and save it
                $imagePath = "$photoFolder\photo_$($timestamp -replace '[: ]', '_').jpg"
                C:\ffmpeg\bin\ffmpeg.exe -f dshow -i video="USB2.0 HD UVC WebCam" -vframes 1 -q:v 2 $imagePath

                # Open the photo just taken
                Start-Process $imagePath
                Start-Sleep -Seconds 5

                # Completely remove the user from the system
                Start-Process -FilePath "cmd.exe" -ArgumentList "/c net user $addedUser /delete" -Verb RunAs -WindowStyle Hidden
                "$timestamp - User $addedUser removed from the system." | Out-File -Append -FilePath $logFile

                # Shutdown the computer (currently commented for testing)
                 #Stop-Computer -Force
            }
        }
    }

    # Wait 5 seconds before checking again
    Start-Sleep -Seconds 5
}
