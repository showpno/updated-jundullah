# PowerShell script to get your local IP address for physical device testing
# This IP should be used in client_side\lib\utility\server_config.dart -> manualPhysicalDeviceIP

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Getting Local IP Address" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get network adapters with active connections
$adapters = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
    $_.IPAddress -notlike "127.*" -and 
    $_.IPAddress -notlike "169.254.*" -and
    $_.InterfaceAlias -notlike "*Loopback*"
} | Sort-Object InterfaceIndex

if ($adapters.Count -eq 0) {
    Write-Host "No active network adapters found!" -ForegroundColor Red
    exit 1
}

Write-Host "Active Network Adapters:" -ForegroundColor Yellow
Write-Host ""

$index = 1
$adaptersInfo = @()

foreach ($adapter in $adapters) {
    $interfaceAlias = $adapter.InterfaceAlias
    $ipAddress = $adapter.IPAddress
    $interfaceIndex = $adapter.InterfaceIndex
    
    Write-Host "[$index] $interfaceAlias" -ForegroundColor Green
    Write-Host "    IP Address: $ipAddress" -ForegroundColor White
    Write-Host "    Interface Index: $interfaceIndex" -ForegroundColor Gray
    Write-Host ""
    
    $adaptersInfo += @{
        Index = $index
        IP = $ipAddress
        Name = $interfaceAlias
    }
    
    $index++
}

# If multiple adapters, let user choose
$selectedIP = $null
if ($adaptersInfo.Count -gt 1) {
    Write-Host "Multiple adapters found. Usually Wi-Fi is the correct one." -ForegroundColor Yellow
    Write-Host ""
    
    do {
        $choice = Read-Host "Enter the number of the adapter you're using (usually Wi-Fi)"
        try {
            $choiceNum = [int]$choice
            if ($choiceNum -ge 1 -and $choiceNum -le $adaptersInfo.Count) {
                $selectedIP = $adaptersInfo[$choiceNum - 1].IP
                break
            } else {
                Write-Host "Invalid choice. Please enter a number between 1 and $($adaptersInfo.Count)" -ForegroundColor Red
            }
        } catch {
            Write-Host "Invalid input. Please enter a number." -ForegroundColor Red
        }
    } while ($true)
} else {
    $selectedIP = $adaptersInfo[0].IP
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Your Local IP Address" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IP Address: $selectedIP" -ForegroundColor Green
Write-Host ""
Write-Host "Instructions:" -ForegroundColor Yellow
Write-Host "1. Copy this IP address: $selectedIP" -ForegroundColor White
Write-Host "2. Open: client_side\lib\utility\server_config.dart" -ForegroundColor White
Write-Host "3. Set: manualPhysicalDeviceIP = '$selectedIP';" -ForegroundColor White
Write-Host "4. Make sure your phone is on the same Wi-Fi network" -ForegroundColor White
Write-Host "5. Make sure your server is running and accessible" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to copy the IP to clipboard..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Copy to clipboard
Set-Clipboard -Value $selectedIP
Write-Host "IP address copied to clipboard!" -ForegroundColor Green
Write-Host ""

