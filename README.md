# Administrator-Group-User-Monitoring-and-Security-Actions
This PowerShell script monitors Windows security events in real-time, specifically looking for events where a user is added to the "Administrators" group. When such an event is detected, the script takes several security actions, including deleting the user from the system and capturing a photo via the webcam.


How It Works
Monitoring Security Events:
The script continuously monitors the Windows event log for Event ID 4732, which indicates that a user has been added to the "Administrators" group.

Actions Upon Detection:
When a user is added to the group, the script performs the following actions:

Logs a warning message to a log file.
Displays a popup alert on the screen.
Captures a photo via the computer’s webcam.
Saves the photo in a predefined folder.
Deletes the user from the system.
Powers off the computer.

Scheduling via Windows Task Scheduler:
The script can be scheduled via Windows Task Scheduler to run automatically at regular intervals or upon system startup, ensuring continuous monitoring.

Log File Management:
Each detected event is logged in a file located at C:\Users\pino\Desktop\utentinonautorizzati.txt, providing a record of the system’s actions.

Dependencies
FFmpeg: The script uses FFmpeg to capture photos from the webcam.
Ensure that FFmpeg is installed and that its executable path is correct. 
You can download FFmpeg from the official website.
Make sure the FFmpeg path is correctly set in the script (C:\ffmpeg\bin\ffmpeg.exe).

How to Use the Script
Configuration:

Set the log file path and the photo folder path within the script.
Make sure FFmpeg is installed at the correct path, or modify the path in the script.


Execution:
Run the PowerShell script as an administrator.
The script will begin monitoring the security event log and take action when a user is added to the "Administrators" group.
Scheduling:

You can schedule the script using Windows Task Scheduler:
Open the Task Scheduler.
Create a new task to run the script on system startup or at regular intervals.
Set the script’s path as the program to execute.
Example Execution
When a user is added to the "Administrators" group, the following actions will occur:

A new entry is added to the log file:

2025-02-24 14:30:00 - ALERT: User JohnDoe added to the Administrators group!
A popup alert will be shown on the screen:
"You’ve been tricked by the system administrator (dummy)".

A photo will be saved in the designated folder

C:\Users\pino\Desktop\photo\photo_2025-02-24_14_30_00.jpg.

The user "JohnDoe" will be deleted from the system, and the following log entry will be added:

2025-02-24 14:30:10 - User JohnDoe removed from the system.

Security Considerations
Make sure to test this script in a controlled environment before using it on a production system, as deleting users is irreversible. The shutdown functionality is currently disabled for testing purposes but can be activated by uncommenting the appropriate line in the script.

Final Thoughts
This script is a practical example of PowerShell automation for monitoring real-time security events. While the user deletion feature may seem drastic, it can be useful in environments where administrative system security needs to be guaranteed.

