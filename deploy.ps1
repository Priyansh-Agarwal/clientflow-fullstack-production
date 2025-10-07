# ClientFlow AI Suite - PowerShell Deployment Script
Write-Host "🚀 ClientFlow AI Suite - Vercel Deployment" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Check if we're in the right directory
if (-not (Test-Path "index-production.js")) {
    Write-Host "❌ Error: index-production.js not found!" -ForegroundColor Red
    Write-Host "Please run this script from the api-server directory" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path "vercel.json")) {
    Write-Host "❌ Error: vercel.json not found!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Production files found" -ForegroundColor Green

# Check if Vercel CLI is installed
try {
    $vercelVersion = vercel --version 2>$null
    Write-Host "✅ Vercel CLI found: $vercelVersion" -ForegroundColor Green
} catch {
    Write-Host "📦 Installing Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}

# Login to Vercel
Write-Host "🔐 Checking Vercel authentication..." -ForegroundColor Yellow
try {
    vercel whoami 2>$null
    Write-Host "✅ Already logged in to Vercel" -ForegroundColor Green
} catch {
    Write-Host "Please login to Vercel:" -ForegroundColor Yellow
    vercel login
}

# Deploy to Vercel
Write-Host "🚀 Deploying to Vercel..." -ForegroundColor Yellow
vercel --prod --yes

Write-Host ""
Write-Host "🎉 Deployment complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Go to your Vercel dashboard" -ForegroundColor White
Write-Host "2. Set environment variables:" -ForegroundColor White
Write-Host "   - SUPABASE_URL: https://gmpsdeenhdtvbxjungxl.supabase.co" -ForegroundColor Gray
Write-Host "   - SUPABASE_SERVICE_ROLE_KEY: [your service key]" -ForegroundColor Gray
Write-Host "   - SUPABASE_ANON_KEY: [your anon key]" -ForegroundColor Gray
Write-Host "   - JWT_SECRET: production_jwt_secret_key_minimum_32_characters_long" -ForegroundColor Gray
Write-Host "   - NODE_ENV: production" -ForegroundColor Gray
Write-Host "3. Redeploy after setting environment variables" -ForegroundColor White
Write-Host "4. Test your API endpoints" -ForegroundColor White
Write-Host ""
Write-Host "📚 See COMPLETE_DEPLOYMENT_GUIDE.md for detailed instructions" -ForegroundColor Cyan
