#!/bin/sh
set -e

echo "🚀 n8n UNLICENSED - Starting..."

# Ensure proper permissions
chown -R node:node /home/node/.n8n /data 2>/dev/null || true

# Start n8n
exec "$@"