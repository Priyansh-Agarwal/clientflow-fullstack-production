# ClientFlow AI Suite - Complete Vercel Deployment with Environment Variables

echo "🚀 ClientFlow AI Suite - Complete Vercel Deployment"
echo "=================================================="

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

# Get the deployment URL
DEPLOYMENT_URL=$(vercel ls --json | jq -r '.[0].url' 2>/dev/null || echo "https://clientflow-ai-suite.vercel.app")

echo ""
echo "🎉 Deployment complete!"
echo "🌐 Your API is live at: $DEPLOYMENT_URL"
echo ""

# Set environment variables
echo "🔧 Setting up environment variables..."

# Required environment variables
vercel env add SUPABASE_URL production <<< "https://gmpsdeenhdtvbxjungxl.supabase.co"
vercel env add SUPABASE_SERVICE_ROLE_KEY production <<< "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtcHNkZWVuaGR0dmJ4anVuZ3hsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUzMDY2OCwiZXhwIjoyMDc1MTA2NjY4fQ.qIXgTLe10v3gRLtEYfeEJz8dHXZMuWARnUty6wNItHI"
vercel env add SUPABASE_ANON_KEY production <<< "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtcHNkZWVuaGR0dmJ4anVuZ3hsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1MzA2NjgsImV4cCI6MjA3NTEwNjY2OH0.C5sWEGKxDuSaD3xsui4YUKgGPhWrsDQ_C26yJMtkJc"
vercel env add JWT_SECRET production <<< "production_jwt_secret_key_minimum_32_characters_long"
vercel env add NODE_ENV production <<< "production"

echo "✅ Environment variables configured"

# Redeploy with environment variables
echo "🔄 Redeploying with environment variables..."
vercel --prod --yes

echo ""
echo "🎉 Complete deployment successful!"
echo ""
echo "📋 Your production API is ready:"
echo "🌐 URL: $DEPLOYMENT_URL"
echo "🔍 Health Check: $DEPLOYMENT_URL/health"
echo "📚 API Docs: $DEPLOYMENT_URL/"
echo "🧪 Test Endpoint: $DEPLOYMENT_URL/test"
echo ""
echo "📋 Next steps:"
echo "1. Test your API endpoints"
echo "2. Set up n8n workflows from the n8n/ folder"
echo "3. Configure webhooks in external services"
echo ""
echo "🧪 Test your API:"
echo "curl $DEPLOYMENT_URL/health"
echo "curl $DEPLOYMENT_URL/test"
