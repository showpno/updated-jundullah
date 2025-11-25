# Server Starter Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Jundullah Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to server directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$serverPath = Join-Path (Split-Path -Parent $scriptPath) "server_side"

if (-not (Test-Path $serverPath)) {
    Write-Host "ERROR: Server directory not found at: $serverPath" -ForegroundColor Red
    Write-Host "Please make sure the server_side folder exists." -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "Server directory: $serverPath" -ForegroundColor Green
Write-Host ""

# Check if node_modules exists
if (-not (Test-Path "$serverPath\node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    Set-Location $serverPath
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to install dependencies!" -ForegroundColor Red
        pause
        exit 1
    }
}

# Check if server is already running
$portCheck = Test-NetConnection -ComputerName localhost -Port 5000 -InformationLevel Quiet -WarningAction SilentlyContinue
if ($portCheck) {
    Write-Host "Server is already running on port 5000!" -ForegroundColor Yellow
    Write-Host "Stopping existing server..." -ForegroundColor Yellow
    
    # Find and stop all processes using port 5000
    Write-Host "Finding processes using port 5000..." -ForegroundColor Yellow
    $netstatOutput = netstat -ano | findstr ":5000" | Select-String "LISTENING"
    
    if ($netstatOutput) {
        $pids = @()
        foreach ($line in $netstatOutput) {
            $lineStr = $line.ToString().Trim()
            # Parse the line: TCP    0.0.0.0:5000   0.0.0.0:0   LISTENING   2432
            $parts = $lineStr -split '\s+'
            if ($parts.Length -ge 5) {
                # PID is the last element
                $processPid = $parts[-1]
                if ($processPid -match '^\d+$') {
                    $pids += $processPid
                    Write-Host "Found process using port 5000: PID $processPid" -ForegroundColor Cyan
                }
            }
        }
        
        $pids = $pids | Select-Object -Unique
        
        if ($pids.Count -gt 0) {
            foreach ($processId in $pids) {
                try {
                    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
                    if ($process) {
                        Write-Host "Stopping process $processId ($($process.ProcessName))..." -ForegroundColor Yellow
                        Stop-Process -Id $processId -Force -ErrorAction Stop
                        Start-Sleep -Seconds 1  # Wait a moment after stopping
                        Write-Host "[OK] Stopped process $processId" -ForegroundColor Green
                    } else {
                        Write-Host "[OK] Process $processId already terminated" -ForegroundColor Green
                    }
                } catch {
                    Write-Host "[X] Could not stop process $processId - trying taskkill..." -ForegroundColor Yellow
                    # Try alternative method
                    taskkill /PID $processId /F 2>&1 | Out-Null
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "[OK] Stopped process $processId using taskkill" -ForegroundColor Green
                        Start-Sleep -Seconds 1
                    } else {
                        Write-Host "[X] Failed to stop process $processId" -ForegroundColor Red
                    }
                }
            }
            
            # Wait for port to be released
            Write-Host "Waiting for port to be released..." -ForegroundColor Yellow
            $maxWait = 10
            $waited = 0
            $portFree = $false
            
            while ($waited -lt $maxWait) {
                Start-Sleep -Seconds 2
                $waited += 2
                
                # Check if port is free
                $stillInUse = $false
                try {
                    $stillInUse = Test-NetConnection -ComputerName localhost -Port 5000 -InformationLevel Quiet -WarningAction SilentlyContinue
                } catch {
                    # If test fails, port might be free
                    $stillInUse = $false
                }
                
                if (-not $stillInUse) {
                    Write-Host "[OK] Port 5000 is now free!" -ForegroundColor Green
                    $portFree = $true
                    break
                } else {
                    Write-Host "  Still waiting... ($waited seconds)" -ForegroundColor Gray
                }
            }
            
            if (-not $portFree) {
                Write-Host "[X] Port 5000 is still in use after $waited seconds" -ForegroundColor Red
                Write-Host "Please stop it manually:" -ForegroundColor Yellow
                Write-Host "  .\scripts\stop_server.ps1" -ForegroundColor White
                Write-Host "Or run: netstat -ano | findstr :5000" -ForegroundColor White
                exit 1
            }
        } else {
            Write-Host "[X] Could not find process ID" -ForegroundColor Red
            Write-Host "Please stop it manually: .\scripts\stop_server.ps1" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "[X] Could not find process using port 5000" -ForegroundColor Red
        Write-Host "Please stop it manually: .\scripts\stop_server.ps1" -ForegroundColor Yellow
        exit 1
    }
    Write-Host ""
}

# Get local IP for display
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
    $_.IPAddress -notlike "127.*" -and 
    $_.IPAddress -notlike "169.254.*" -and 
    $_.InterfaceAlias -notlike "*Loopback*"
} | Select-Object -First 1).IPAddress

Write-Host "Starting server on port 5000..." -ForegroundColor Green
Write-Host ""
Write-Host "Server will be accessible at:" -ForegroundColor Yellow
Write-Host "  - Localhost: http://localhost:5000" -ForegroundColor White
if ($localIP) {
    Write-Host "  - Network: http://$localIP:5000" -ForegroundColor White
}
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Cyan
Write-Host ""

# Start the server
Set-Location $serverPath
$env:PORT = 5000
node index.js
