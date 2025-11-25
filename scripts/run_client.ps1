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

# Auto-detect and run - simple text-based parsing (proven to work)
$emulatorFound = $false
$phoneFound = $false
$emulatorId = $null
$phoneId = $null
$phoneName = $null

# Get devices output - use exact same method as working code
$devicesOutput = flutter devices 2>&1 | Out-String
$lines = $devicesOutput -split "`n"

foreach ($line in $lines) {
    # Check for emulator
    if ($line -match "emulator-(\d+)") {
        $emulatorFound = $true
        $emulatorId = $matches[0]
    }
    # Check for connected Android phone (not emulator) - exact pattern from working code
    if ($line -match "android" -and $line -notmatch "emulator" -and $line -match "mobile") {
        if ($line -match "([^(]+)\s+\(mobile\)\s+•\s+([a-f0-9]+)") {
            $phoneFound = $true
            $phoneName = $matches[1].Trim()
            $phoneId = $matches[2].Trim()
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
