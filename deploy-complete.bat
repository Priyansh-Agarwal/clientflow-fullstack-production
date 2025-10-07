@echo off
REM ClientFlow AI Suite - Complete Vercel Deployment with Environment Variables
echo 🚀 ClientFlow AI Suite - Complete Vercel Deployment
echo ==================================================

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

REM Set environment variables
echo 🔧 Setting up environment variables...
echo.
echo Setting SUPABASE_URL...
echo https://gmpsdeenhdtvbxjungxl.supabase.co | vercel env add SUPABASE_URL production

echo Setting SUPABASE_SERVICE_ROLE_KEY...
echo eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtcHNkZWVuaGR0dmJ4anVuZ3hsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUzMDY2OCwiZXhwIjoyMDc1MTA2NjY4fQ.qIXgTLe10v3gRLtEYfeEJz8dHXZMuWARnUty6wNItHI | vercel env add SUPABASE_SERVICE_ROLE_KEY production

echo Setting SUPABASE_ANON_KEY...
echo eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtcHNkZWVuaGR0dmJ4anVuZ3hsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1MzA2NjgsImV4cCI6MjA3NTEwNjY2OH0.C5sWEGKxDuSaD3xsui4YUKgGPhWrsDQ_C26yJMtkJc | vercel env add SUPABASE_ANON_KEY production

echo Setting JWT_SECRET...
echo production_jwt_secret_key_minimum_32_characters_long | vercel env add JWT_SECRET production

echo Setting NODE_ENV...
echo production | vercel env add NODE_ENV production

echo ✅ Environment variables configured

REM Redeploy with environment variables
echo 🔄 Redeploying with environment variables...
vercel --prod --yes

echo.
echo 🎉 Complete deployment successful!
echo.
echo 📋 Your production API is ready!
echo 🌐 Check your Vercel dashboard for the live URL
echo.
echo 📋 Next steps:
echo 1. Test your API endpoints
echo 2. Set up n8n workflows from the n8n/ folder
echo 3. Configure webhooks in external services
echo.
echo 🧪 Test your API (replace YOUR_URL with actual Vercel URL):
echo curl YOUR_URL/health
echo curl YOUR_URL/test
echo.
pause
