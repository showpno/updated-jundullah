# Stop Server Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Stopping Jundullah Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$port = 5000

# Find processes using port 5000
Write-Host "Finding processes using port $port..." -ForegroundColor Yellow
$connections = netstat -ano | findstr ":$port" | Select-String "LISTENING"

if ($connections) {
    $pids = @()
    foreach ($conn in $connections) {
        $parts = $conn.ToString().Trim() -split '\s+'
        if ($parts.Length -gt 0) {
            $pid = $parts[-1]
            if ($pid -match '^\d+$') {
                $pids += $pid
            }
        }
    }
    
    $pids = $pids | Select-Object -Unique
    
    if ($pids.Count -gt 0) {
        Write-Host ""
        Write-Host "Found processes using port $port:" -ForegroundColor Yellow
        foreach ($processId in $pids) {
            $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
            if ($process) {
                Write-Host "  PID: $processId - $($process.ProcessName)" -ForegroundColor White
            } else {
                Write-Host "  PID: $processId" -ForegroundColor White
            }
        }
        Write-Host ""
        
        $choice = Read-Host "Stop these processes? (y/n)"
        if ($choice -eq "y" -or $choice -eq "Y") {
            foreach ($processId in $pids) {
                try {
                    Stop-Process -Id $processId -Force -ErrorAction Stop
                    Write-Host "[OK] Stopped process $processId" -ForegroundColor Green
                } catch {
                    Write-Host "[X] Could not stop process $processId: $_" -ForegroundColor Red
                }
            }
            Write-Host ""
            Write-Host "Server stopped successfully!" -ForegroundColor Green
        } else {
            Write-Host "Cancelled." -ForegroundColor Yellow
        }
    } else {
        Write-Host "No processes found using port $port" -ForegroundColor Green
    }
} else {
    Write-Host "No processes found using port $port" -ForegroundColor Green
}

Write-Host ""

