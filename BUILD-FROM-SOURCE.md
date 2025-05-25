# Building n8n from Source with License Bypass

This guide explains how to build and run n8n from source with all license checks bypassed.

## 🚀 Quick Start

```bash
# Build the image (this will take 10-15 minutes)
docker-compose -f docker-compose.n8n-source.yml build

# Run the container
docker-compose -f docker-compose.n8n-source.yml up -d

# Check logs
docker logs -f n8n-unlicensed-source
```

## 📋 What This Does

1. **Clones** your fork from https://github.com/pvdyck/n8n/tree/n8n-unlicensed
2. **Verifies** the license modifications are present
3. **Builds** n8n from source with all packages
4. **Creates** a production-ready image
5. **Sets up** automatic owner account and API key

## 🔧 Build Process

### Stage 1: Builder
- Uses Node.js 20 Alpine
- Installs all build dependencies
- Clones your modified fork
- Runs `pnpm install` and `pnpm build`
- Prunes dev dependencies

### Stage 2: Runtime
- Creates minimal runtime image
- Copies built n8n from builder
- Sets up user permissions
- Includes initialization script

## 📊 Expected Results

After starting, you should see:
```
✅ License modifications confirmed!
✅ Owner account created!
✅ API key created!

📊 License Status:
  Plan: Enterprise
  Variables: true
  Source Control: true
  External Secrets: true
```

## 🔐 Access Credentials

- **URL**: http://localhost:7001
- **Email**: `admin@n8n.local`
- **Password**: `N8nPassword123`
- **API Key**: `n8n_api_test_key_123456789`

## 🧪 Verify Enterprise Features

1. **Via UI**:
   - Login and go to Settings
   - Check for Variables, Source Control, External Secrets menu items
   - Check Usage & Plan shows "Enterprise"

2. **Via API**:
   ```bash
   # Check settings
   curl -s http://localhost:7001/rest/settings | jq '.data.enterprise'
   
   # Test Variables API
   curl -H "X-N8N-API-KEY: n8n_api_test_key_123456789" \
     http://localhost:7001/api/v1/variables
   ```

## 🛠️ Troubleshooting

### Build Fails
- Ensure Docker has enough memory (4GB+)
- Check internet connection for git clone
- Try building with `--no-cache` flag

### Features Not Enabled
- Check container logs for verification messages
- Ensure the build used the correct branch
- Verify modifications in license.ts

### Container Crashes
- Check logs: `docker logs n8n-unlicensed-source`
- Ensure port 7001 is not in use
- Try removing volumes and starting fresh

## 📦 Image Details

- **Base**: node:20-alpine
- **Size**: ~500MB (optimized multi-stage build)
- **User**: Runs as non-root user 'n8n'
- **Data**: Stored in Docker volumes

## 🔄 Updating

To update with new changes:
```bash
# Stop and remove container
docker-compose -f docker-compose.n8n-source.yml down

# Rebuild with latest changes
docker-compose -f docker-compose.n8n-source.yml build --no-cache

# Start updated container
docker-compose -f docker-compose.n8n-source.yml up -d
```

## ⚠️ Important Notes

1. **Build Time**: First build takes 10-15 minutes
2. **Resources**: Requires ~4GB RAM during build
3. **Cache**: Docker caches layers for faster rebuilds
4. **Volumes**: Data persists in Docker volumes

## 🎯 What's Modified

In `packages/cli/src/license.ts`:
```typescript
isLicensed() { return true; }
getValue() { return UNLIMITED_LICENSE_QUOTA; }
getPlanName() { return 'Enterprise'; }
```

These modifications bypass all license checks at the core level.