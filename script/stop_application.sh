#!/bin/bash
set -e

echo "🛑 ===== STOPPING APPLICATION ====="

# Stop PM2 managed process
if pm2 list | grep -q "fastfood-app"; then
    echo "⏹️ Stopping PM2 process..."
    pm2 stop fastfood-app || true
    pm2 delete fastfood-app || true
    echo "✅ PM2 process stopped"
else
    echo "ℹ️ No PM2 process found"
fi

# Kill any remaining Node.js processes
echo "🔍 Checking for remaining processes..."
if pgrep -f "node server.js" > /dev/null; then
    echo "⏹️ Killing remaining Node processes..."
    pkill -f "node server.js" || true
    sleep 2
fi

# Verify no process is running on port 3000
if lsof -ti:3000 > /dev/null 2>&1; then
    echo "⚠️ Port 3000 is still in use, forcefully killing process..."
    kill -9 $(lsof -ti:3000) || true
fi

echo "✅ Application stopped successfully!"
