#!/bin/bash
set -e

echo "▶️ ===== STARTING APPLICATION ====="

# Navigate to application directory
cd /home/ubuntu/fastfood-app

# Install production dependencies
echo "📦 Installing production dependencies..."
npm install --production

# Set environment variables
export NODE_ENV=production
export PORT=3000

# Kill any existing PM2 processes
echo "🛑 Stopping existing PM2 processes..."
pm2 delete all || true

# Start application with PM2 in FORK mode (not cluster)
echo "🚀 Starting Fast Food App with PM2..."
pm2 start server.js \
    --name fastfood-app \
    --time

# Save PM2 configuration
pm2 save

# Display PM2 status
echo "📊 Application Status:"
pm2 list

echo "✅ Application started successfully!"

# Get public IP dynamically from EC2 metadata
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo "localhost")

if [ "$PUBLIC_IP" != "localhost" ]; then
    echo "🌐 Application URL: http://$PUBLIC_IP:3000"
else
    echo "🌐 Application URL: http://localhost:3000"
fi
