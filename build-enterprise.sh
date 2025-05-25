#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🏗️  n8n Enterprise Unlocked Builder${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "This will build n8n from source with all enterprise features enabled."
echo "Expected build time: 10-15 minutes"
echo ""

# Check if docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

# Clean up any existing builds
echo -e "${YELLOW}🧹 Cleaning up any existing containers...${NC}"
docker-compose -f docker-compose.enterprise.yml down 2>/dev/null || true

# Start the build
echo -e "${YELLOW}🚀 Starting build process...${NC}"
echo "This will:"
echo "  1. Clone your fork with license modifications"
echo "  2. Build n8n from source"
echo "  3. Create a Docker image with all features enabled"
echo ""

# Enable BuildKit for better performance
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Build with progress
echo -e "${YELLOW}📦 Building Docker image...${NC}"
if docker-compose -f docker-compose.enterprise.yml build --progress=plain; then
    echo -e "${GREEN}✅ Build completed successfully!${NC}"
    echo ""
    
    # Start the container
    echo -e "${YELLOW}🚀 Starting n8n Enterprise Unlocked...${NC}"
    docker-compose -f docker-compose.enterprise.yml up -d
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}✅ n8n Enterprise Unlocked is starting!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "📍 URL: http://localhost:6666"
    echo "📧 Email: admin@n8n.local"
    echo "🔐 Password: N8nPassword123"
    echo "🔑 API Key: n8n_api_enterprise_key_6666"
    echo ""
    echo "⏳ Please wait 30-60 seconds for initialization..."
    echo ""
    echo "To check logs: docker logs -f n8n-enterprise-unlocked"
    echo "To stop: docker-compose -f docker-compose.enterprise.yml down"
else
    echo -e "${RED}❌ Build failed. Check the error messages above.${NC}"
    exit 1
fi