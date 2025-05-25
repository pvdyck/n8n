# n8n Enterprise Unlocked - Full Source Build

## 🎯 Overview

This is a complete source build of n8n with all enterprise features enabled through code modifications. Unlike other approaches that try to patch compiled code, this builds directly from your fork with modified license.ts.

## ✨ Features

- ✅ **ALL Enterprise Features Enabled**
  - Variables
  - Source Control
  - External Secrets
  - LDAP/SAML
  - Audit Logs
  - Advanced Permissions
  - Workflow History
  - Debug in Editor
  - And more!

- ✅ **Pre-configured Setup**
  - No manual configuration required
  - Owner account created automatically
  - Static API key ready to use
  - Runs on port 6666

## 🚀 Quick Start

```bash
# One command to build and run
./build-enterprise.sh
```

Or manually:

```bash
# Build the image (10-15 minutes)
docker-compose -f docker-compose.enterprise.yml build

# Run it
docker-compose -f docker-compose.enterprise.yml up -d
```

## 🔑 Access Credentials

| Type | Value |
|------|-------|
| **URL** | http://localhost:6666 |
| **Email** | admin@n8n.local |
| **Password** | N8nPassword123 |
| **API Key** | n8n_api_enterprise_key_6666 |

## 🏗️ Build Process

### What happens during build:

1. **Clone Repository** (30 seconds)
   - Clones your fork: https://github.com/pvdyck/n8n/tree/n8n-unlicensed
   - Verifies license modifications are present

2. **Install Dependencies** (5-7 minutes)
   - Uses pnpm for faster installation
   - Installs all workspace dependencies

3. **Build from Source** (5-7 minutes)
   - Compiles TypeScript
   - Builds all packages
   - Creates production bundle

4. **Create Runtime Image** (1 minute)
   - Copies built artifacts
   - Adds runtime dependencies
   - Sets up initialization scripts

### Total time: ~15 minutes first build

## 📁 Architecture

```
Dockerfile.n8n-enterprise-unlocked
├── Stage 1: Builder
│   ├── Clone fork with modifications
│   ├── Verify license.ts changes
│   ├── Install dependencies
│   └── Build from source
│
└── Stage 2: Runtime
    ├── Copy built n8n
    ├── Add runtime deps only
    ├── Configure auto-setup
    └── Final image (~500MB)
```

## 🔧 How It Works

### License Bypass
Your fork modifies `packages/cli/src/license.ts`:
```typescript
isLicensed() { return true; }
getValue() { return UNLIMITED_LICENSE_QUOTA; }
getPlanName() { return 'Enterprise'; }
```

### Auto-Setup Process
1. n8n starts in background
2. Wait for database initialization
3. Create owner account via API
4. Insert API key into database
5. Verify all features enabled

## 📊 Verification

After startup, check features:

```bash
# Check logs
docker logs n8n-enterprise-unlocked

# Test API
curl -H "X-N8N-API-KEY: n8n_api_enterprise_key_6666" \
  http://localhost:6666/api/v1/workflows

# Check settings via API
curl http://localhost:6666/rest/settings | jq '.data.enterprise'
```

Expected output should show all features as `true`.

## 🛠️ Management Commands

```bash
# View logs
docker logs -f n8n-enterprise-unlocked

# Stop
docker-compose -f docker-compose.enterprise.yml down

# Stop and remove data
docker-compose -f docker-compose.enterprise.yml down -v

# Rebuild (if you update the fork)
docker-compose -f docker-compose.enterprise.yml build --no-cache

# Check resource usage
docker stats n8n-enterprise-unlocked
```

## 📈 Resource Requirements

- **Build**: 4GB RAM, 10GB disk space
- **Runtime**: 1-2GB RAM, 1GB disk space
- **CPU**: 2+ cores recommended

## 🔍 Troubleshooting

### Build fails with "out of memory"
Increase Docker memory allocation to 4GB+

### Container exits immediately
Check logs: `docker logs n8n-enterprise-unlocked`

### Features still show as disabled
1. Wait 60 seconds after startup
2. Clear browser cache
3. Check that build used correct branch

### Port 6666 already in use
Change port in docker-compose.enterprise.yml

## 🚨 Important Notes

1. **First build takes 10-15 minutes** - This is normal
2. **Subsequent builds are faster** - Docker caches layers
3. **For development only** - Not for production use
4. **Your fork required** - Won't work with official n8n repo

## 📝 License

This build bypasses n8n's license checks for development/testing purposes only. For production use, please purchase a proper license from n8n.