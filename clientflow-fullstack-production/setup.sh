#!/bin/bash

# ClientFlow AI Suite - Setup Script
echo "🚀 Setting up ClientFlow AI Suite..."

# Install root dependencies
echo "📦 Installing root dependencies..."
npm install

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd frontend
npm install
cd ..

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd backend
npm install
cd ..

# Copy environment file
echo "⚙️ Setting up environment..."
if [ ! -f .env ]; then
    cp env.example .env
    echo "✅ Created .env file from template"
    echo "⚠️  Please update .env with your actual values"
else
    echo "✅ .env file already exists"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env with your Supabase credentials"
echo "2. Run 'npm run dev' to start development servers"
echo "3. Open http://localhost:5173 for frontend"
echo "4. Open http://localhost:3001/api/health for backend"
echo ""
echo "For production deployment:"
echo "1. Push to GitHub"
echo "2. Import to Vercel"
echo "3. Add environment variables in Vercel dashboard"
echo "4. Deploy!"
