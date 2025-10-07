#!/bin/bash

# ClientFlow AI Suite - Simple Development Script
echo "🚀 Starting ClientFlow AI Suite development servers..."

# Function to start a service in background
start_service() {
    local name=$1
    local dir=$2
    local command=$3
    
    echo "📦 Starting $name..."
    cd "$dir"
    $command &
    local pid=$!
    echo "$name started with PID: $pid"
    cd - > /dev/null
}

# Start services
start_service "Web App" "apps/web" "npm run dev"
start_service "API Server" "apps/api" "npm run dev"
start_service "Worker" "apps/worker" "npm run dev"

echo "✅ All services started!"
echo ""
echo "🌐 Web App: http://localhost:3000"
echo "🔌 API Server: http://localhost:4000"
echo "⚙️  Worker: Background processing"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for user interrupt
trap 'echo "🛑 Stopping all services..."; kill $(jobs -p); exit' INT
wait
