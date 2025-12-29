# SCRIPT: INSTALL-SERVICE (DAEMON REGISTRATION)
# IDENTITY: SAKSHI
# RUN AS: ADMIN (Recommended)

# --- CONFIGURATION ---
$NewTaskName = "Sakshi"
$OldTaskName = "Shakshi Overwatch" # We target this to delete it
$BrainPath   = "$env:USERPROFILE\Void\Automation\Sakshi.ps1"

Write-Host " [SYSTEM] Initializing Sakshi Daemon Registration..." -ForegroundColor Cyan

# 1. PURGE OLD SERVICES
# We remove the old task if it exists to prevent duplicates.
if (Get-ScheduledTask -TaskName $OldTaskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $OldTaskName -Confirm:$false
    Write-Host " [PURGE] Removed obsolete task: $OldTaskName" -ForegroundColor Yellow
}

# We also remove the current task name if it exists (to update settings).
if (Get-ScheduledTask -TaskName $NewTaskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $NewTaskName -Confirm:$false
    Write-Host " [UPDATE] Unregistered existing instance of $NewTaskName" -ForegroundColor Yellow
}

# 2. DEFINE TRIGGER (At Logon)
$Trigger = New-ScheduledTaskTrigger -AtLogon

# 3. DEFINE ACTION (Run Sakshi Hidden)
$Action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$BrainPath`""

# 4. DEFINE SETTINGS (Resilience)
$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Days 365) `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1)

# 5. REGISTER NEW SERVICE
try {
    Register-ScheduledTask -TaskName $NewTaskName `
        -Action $Action `
        -Trigger $Trigger `
        -Settings $Settings `
        -RunLevel Highest `
        -Description "The Witness (Sakshi) Overwatch System. Monitors discipline protocols." `
        -Force

    Write-Host " [SUCCESS] Daemon Registered: $NewTaskName" -ForegroundColor Green
    
    # Start it immediately so you don't have to reboot
    Start-ScheduledTask -TaskName $NewTaskName
    Write-Host " [ACTIVE] Sakshi is now watching." -ForegroundColor Green
}
catch {
    Write-Host " [ERROR] Failed. Run PowerShell as Administrator." -ForegroundColor Red
    Write-Host $_
}
