# Admin Panel Runner - Run Flutter Admin Dashboard on Chrome
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Admin Panel - Chrome Runner" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to admin_panel directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$adminPath = Join-Path (Split-Path -Parent $scriptPath) "admin_panel"

if (-not (Test-Path $adminPath)) {
    Write-Host "ERROR: Admin panel directory not found at: $adminPath" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Starting admin panel on Chrome..." -ForegroundColor Green
Write-Host ""
Write-Host "The app will open in Chrome browser automatically." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server." -ForegroundColor Yellow
Write-Host ""

# Navigate to admin panel and run
Set-Location $adminPath
flutter run -d chrome

