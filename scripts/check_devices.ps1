# Device Checker Script - Checks for Emulator and Samsung Phone
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Android Device Checker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Flutter devices
Write-Host "Checking for Android devices..." -ForegroundColor Yellow
Write-Host ""

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

# Display results
Write-Host "Device Status:" -ForegroundColor Cyan
Write-Host ""

if ($emulatorFound) {
    Write-Host "[OK] Emulator: $emulatorId" -ForegroundColor Green
} else {
    Write-Host "[X] Emulator: Not running" -ForegroundColor Red
    Write-Host "  To launch: flutter emulators --launch Medium_Phone_API_36.1" -ForegroundColor Yellow
}

if ($phoneFound) {
    Write-Host "[OK] Samsung Phone: $phoneName ($phoneId)" -ForegroundColor Green
} else {
    Write-Host "[X] Samsung Phone: Not detected" -ForegroundColor Red
    Write-Host ""
    Write-Host "To connect your Samsung phone:" -ForegroundColor Yellow
    Write-Host "  1. Connect phone to computer via USB" -ForegroundColor White
    Write-Host "  2. On phone: Settings > About Phone > Tap Build Number 7 times" -ForegroundColor White
    Write-Host "  3. On phone: Settings > Developer Options > Enable USB Debugging" -ForegroundColor White
    Write-Host "  4. Authorize this computer when prompted on phone" -ForegroundColor White
    Write-Host "  5. Run: adb devices (should show your phone)" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Check ADB devices for more details
Write-Host ""
Write-Host "ADB Device List:" -ForegroundColor Cyan
$adbOutput = adb devices 2>&1
Write-Host $adbOutput

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Summary and next steps
if ($emulatorFound -and $phoneFound) {
    Write-Host ""
    Write-Host "[OK] Both devices are available!" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now run:" -ForegroundColor Yellow
    Write-Host "  .\scripts\run_client.ps1" -ForegroundColor White
} elseif ($emulatorFound) {
    Write-Host ""
    Write-Host "[!] Only emulator is available" -ForegroundColor Yellow
    Write-Host "  Connect your Samsung phone to see both options" -ForegroundColor White
} elseif ($phoneFound) {
    Write-Host ""
    Write-Host "[!] Only phone is available" -ForegroundColor Yellow
    Write-Host "  Launch emulator to see both options" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "[X] No Android devices available" -ForegroundColor Red
    Write-Host "  Launch emulator or connect your phone" -ForegroundColor White
}

Write-Host ""

