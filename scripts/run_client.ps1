# Client Side Runner - Run Flutter Mobile App (Auto-detect)
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Jundullah - Android Runner (Auto)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to Client_side directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootPath = Split-Path -Parent $scriptPath
# Try both case variations
$clientPath = Join-Path $rootPath "Client_side"
if (-not (Test-Path $clientPath)) {
    $clientPath = Join-Path $rootPath "client_side"
}

if (-not (Test-Path $clientPath)) {
    Write-Host "ERROR: Client side directory not found at: $clientPath" -ForegroundColor Red
    pause
    exit 1
}

Set-Location $clientPath

# Auto-detect and run - use Flutter's machine-readable output for reliable parsing
$emulatorFound = $false
$phoneFound = $false
$emulatorId = $null
$phoneId = $null
$phoneName = $null

# Try to get devices in JSON format (more reliable)
try {
    $devicesJson = flutter devices --machine 2>&1 | Out-String
    $devices = $devicesJson | ConvertFrom-Json
    
    foreach ($device in $devices) {
        # Skip non-Android devices
        if ($device.platform -ne "android") { continue }
        
        # Check if it's an emulator
        if ($device.id -match "emulator-(\d+)") {
            $emulatorFound = $true
            $emulatorId = $device.id
            continue
        }
        
        # This is a physical Android device
        if (-not $phoneFound) {
            $phoneFound = $true
            $phoneName = $device.name
            $phoneId = $device.id
        }
    }
} catch {
    # Fallback to text parsing if JSON fails
    $devicesOutput = flutter devices 2>&1 | Out-String
    $lines = $devicesOutput -split "`r?`n"
    
    foreach ($line in $lines) {
        $trimmedLine = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmedLine)) { continue }
        if ($trimmedLine -notmatch "\(mobile\)") { continue }
        
        # Check for emulator
        if ($trimmedLine -match "emulator-(\d+)") { 
            $emulatorFound = $true
            $emulatorId = $matches[0]
            continue 
        }
        
        # Extract phone info - flexible pattern
        if ($trimmedLine -match "([^\s].+?)\s+\(mobile\).*?•\s+([a-f0-9]+)") {
            $phoneFound = $true
            $phoneName = $matches[1].Trim()
            $phoneId = $matches[2].Trim()
            break
        }
    }
}

if ($phoneFound) {
    Write-Host "[AUTO] Phone: $phoneName ($phoneId)" -ForegroundColor Green
    Write-Host "Running on phone..." -ForegroundColor Yellow
    Write-Host "Device ID: $phoneId" -ForegroundColor Cyan
    flutter run -d $phoneId
} elseif ($emulatorFound) {
    Write-Host "[AUTO] Emulator: $emulatorId" -ForegroundColor Yellow
    Write-Host "Running on emulator..." -ForegroundColor Yellow
    Write-Host "NOTE: Phone not detected, using emulator instead" -ForegroundColor Red
    flutter run -d $emulatorId
} else {
    Write-Host "[AUTO] No devices found - Launching emulator..." -ForegroundColor Yellow
    flutter emulators --launch Medium_Phone_API_36.1
    
    Write-Host "Waiting for emulator to boot..." -ForegroundColor Yellow
    $maxWait = 60
    $waited = 0
    
    while ($waited -lt $maxWait) {
        Start-Sleep -Seconds 3
        $waited += 3
        $checkOutput = flutter devices 2>&1 | Out-String
        if ($checkOutput -match "emulator-(\d+)") {
            $emulatorId = $matches[0]
            Write-Host "[OK] Emulator started: $emulatorId" -ForegroundColor Green
            Write-Host "Running on emulator..." -ForegroundColor Yellow
            flutter run -d $emulatorId
            exit
        }
    }
    
    Write-Host "[X] Emulator failed to start" -ForegroundColor Red
    exit 1
}
