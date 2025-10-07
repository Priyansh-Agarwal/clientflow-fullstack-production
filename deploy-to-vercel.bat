@echo off
REM ClientFlow AI Suite - One-Click Vercel Deployment (Windows)
echo 🚀 ClientFlow AI Suite - Vercel Deployment
echo ==========================================

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Installing Vercel CLI...
    npm install -g vercel
)

REM Navigate to api-server directory
cd api-server

echo 🔍 Checking production configuration...
if not exist "index-production.js" (
    echo ❌ Error: index-production.js not found!
    pause
    exit /b 1
)

if not exist "vercel.json" (
    echo ❌ Error: vercel.json not found!
    pause
    exit /b 1
)

echo ✅ Production files found

REM Login to Vercel (if not already logged in)
echo 🔐 Checking Vercel authentication...
vercel whoami >nul 2>&1
if %errorlevel% neq 0 (
    echo Please login to Vercel:
    vercel login
)

REM Deploy to Vercel
echo 🚀 Deploying to Vercel...
vercel --prod --yes

echo.
echo 🎉 Deployment complete!
echo.
echo 📋 Next steps:
echo 1. Set environment variables in Vercel dashboard:
echo    - SUPABASE_URL
echo    - SUPABASE_SERVICE_ROLE_KEY
echo    - JWT_SECRET
echo.
echo 2. Test your API endpoints
echo 3. Set up n8n workflows
echo.
echo 📚 See VERCEL_DEPLOYMENT_GUIDE.md for detailed instructions
pause
