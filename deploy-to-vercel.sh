#!/bin/bash

# ClientFlow AI Suite - One-Click Vercel Deployment
echo "🚀 ClientFlow AI Suite - Vercel Deployment"
echo "=========================================="

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm install -g vercel
fi

# Navigate to api-server directory
cd api-server

echo "🔍 Checking production configuration..."
if [ ! -f "index-production.js" ]; then
    echo "❌ Error: index-production.js not found!"
    exit 1
fi

if [ ! -f "vercel.json" ]; then
    echo "❌ Error: vercel.json not found!"
    exit 1
fi

echo "✅ Production files found"

# Login to Vercel (if not already logged in)
echo "🔐 Checking Vercel authentication..."
if ! vercel whoami &> /dev/null; then
    echo "Please login to Vercel:"
    vercel login
fi

# Deploy to Vercel
echo "🚀 Deploying to Vercel..."
vercel --prod --yes

echo ""
echo "🎉 Deployment complete!"
echo ""
echo "📋 Next steps:"
echo "1. Set environment variables in Vercel dashboard:"
echo "   - SUPABASE_URL"
echo "   - SUPABASE_SERVICE_ROLE_KEY"
echo "   - JWT_SECRET"
echo ""
echo "2. Test your API endpoints"
echo "3. Set up n8n workflows"
echo ""
echo "📚 See VERCEL_DEPLOYMENT_GUIDE.md for detailed instructions"
