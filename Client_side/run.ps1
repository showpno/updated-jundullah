Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Juldullah - Android Runner" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Detect available Android devices
$devicesOutput = flutter devices 2>&1 | Out-String
$lines = $devicesOutput -split "`n"

$emulatorFound = $false
$phoneFound = $false
$emulatorId = $null
$phoneId = $null
$phoneName = $null

foreach ($line in $lines) {
    # Check for emulator
    if ($line -match "emulator-(\d+)") {
        $emulatorFound = $true
        $emulatorId = $matches[0]
    }
    # Check for connected Android phone (not emulator)
    if ($line -match "android" -and $line -notmatch "emulator" -and $line -match "mobile") {
        if ($line -match "([^(]+)\s+\(mobile\)\s+•\s+([a-f0-9]+)") {
            $phoneFound = $true
            $phoneName = $matches[1].Trim()
            $phoneId = $matches[2].Trim()
        }
    }
}

Write-Host "Select Android device to run:" -ForegroundColor Yellow
$optionNum = 1
$options = @()

if ($emulatorFound) {
    Write-Host "[$optionNum] Android Emulator ($emulatorId)" -ForegroundColor Green
    $options += @{Type="emulator"; Id=$emulatorId}
    $optionNum++
}

if ($phoneFound) {
    Write-Host "[$optionNum] $phoneName ($phoneId)" -ForegroundColor Green
    $options += @{Type="phone"; Id=$phoneId; Name=$phoneName}
    $optionNum++
}

if ($options.Count -eq 0) {
    Write-Host ""
    Write-Host "No Android devices found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Available devices:" -ForegroundColor Yellow
    Write-Host $devicesOutput
    Write-Host ""
    Write-Host "For emulator: Make sure it's running or use 'flutter emulators --launch Medium_Phone_API_36.1'" -ForegroundColor Yellow
    Write-Host "For phone: Make sure USB debugging is enabled and device is connected" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "[q] Quit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Enter your choice"

if ($choice -eq "q" -or $choice -eq "Q") {
    Write-Host "Exiting..." -ForegroundColor Yellow
    exit
}

$selectedIndex = [int]$choice
if ($selectedIndex -ge 1 -and $selectedIndex -le $options.Count) {
    $selectedDevice = $options[$selectedIndex - 1]
    
    if ($selectedDevice.Type -eq "emulator") {
        # Check if emulator is already running
        $devicesCheck = flutter devices 2>&1 | Out-String
        if ($devicesCheck -notmatch $selectedDevice.Id) {
            Write-Host ""
            Write-Host "Emulator not running. Launching Android emulator..." -ForegroundColor Green
            flutter emulators --launch Medium_Phone_API_36.1
            
            Write-Host "Waiting for emulator to start..." -ForegroundColor Yellow
            Start-Sleep -Seconds 15
            
            # Re-detect emulator ID
            $devicesOutput = flutter devices 2>&1 | Out-String
            if ($devicesOutput -match "emulator-(\d+)") {
                $selectedDevice.Id = $matches[0]
            }
        }
        
        Write-Host ""
        Write-Host "Running Flutter app on emulator ($($selectedDevice.Id))..." -ForegroundColor Green
        flutter run -d $selectedDevice.Id
    } elseif ($selectedDevice.Type -eq "phone") {
        Write-Host ""
        Write-Host "Running Flutter app on $($selectedDevice.Name) ($($selectedDevice.Id))..." -ForegroundColor Green
        flutter run -d $selectedDevice.Id
    }
} else {
    Write-Host "Invalid choice. Please run the script again." -ForegroundColor Red
    exit 1
}

