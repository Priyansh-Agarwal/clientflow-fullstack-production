# ClientFlow AI Suite - Simple Development Script (PowerShell)
Write-Host "🚀 Starting ClientFlow AI Suite development servers..." -ForegroundColor Green

# Function to start a service
function Start-Service {
    param(
        [string]$Name,
        [string]$Directory,
        [string]$Command
    )
    
    Write-Host "📦 Starting $Name..." -ForegroundColor Yellow
    Set-Location $Directory
    Start-Process -NoNewWindow -FilePath "powershell" -ArgumentList "-Command", $Command
    Set-Location ..
}

# Start services
Start-Service "Web App" "apps/web" "npm run dev"
Start-Service "API Server" "apps/api" "npm run dev" 
Start-Service "Worker" "apps/worker" "npm run dev"

Write-Host "✅ All services started!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Web App: http://localhost:3000" -ForegroundColor Cyan
Write-Host "🔌 API Server: http://localhost:4000" -ForegroundColor Cyan
Write-Host "⚙️  Worker: Background processing" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop all services" -ForegroundColor Yellow

# Keep script running
Read-Host "Press Enter to stop all services"
