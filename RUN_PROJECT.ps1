# Main Menu Script - Run All Projects
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Jundullah Project Runner" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Select a project to run:" -ForegroundColor Yellow
Write-Host ""
Write-Host "[1] Run Client Side (Mobile App)" -ForegroundColor Green
Write-Host "[2] Run Admin Panel (Chrome)" -ForegroundColor Green
Write-Host "[3] Run Server (Backend)" -ForegroundColor Green
Write-Host "[4] Check Devices (Emulator/Phone)" -ForegroundColor Cyan
Write-Host "[5] Get Local IP Address" -ForegroundColor Cyan
Write-Host "[q] Quit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Enter your choice"

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$scriptsPath = Join-Path $scriptPath "scripts"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Starting Client Side App..." -ForegroundColor Green
        & (Join-Path $scriptsPath "run_client.ps1")
    }
    "2" {
        Write-Host ""
        Write-Host "Starting Admin Panel..." -ForegroundColor Green
        & (Join-Path $scriptsPath "run_admin.ps1")
    }
    "3" {
        Write-Host ""
        Write-Host "Starting Server..." -ForegroundColor Green
        & (Join-Path $scriptsPath "run_server.ps1")
    }
    "4" {
        Write-Host ""
        & (Join-Path $scriptsPath "check_devices.ps1")
        Write-Host ""
        pause
        & $MyInvocation.MyCommand.Path
    }
    "5" {
        Write-Host ""
        & (Join-Path $scriptsPath "get_local_ip.ps1")
        Write-Host ""
        pause
        & $MyInvocation.MyCommand.Path
    }
    "q" {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit
    }
    "Q" {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit
    }
    default {
        Write-Host "Invalid choice. Please try again." -ForegroundColor Red
        Start-Sleep -Seconds 2
        & $MyInvocation.MyCommand.Path
    }
}

