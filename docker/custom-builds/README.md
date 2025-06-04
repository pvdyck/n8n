# n8n Custom Build - Enterprise Features Enabled

This directory contains a Docker solution for running n8n with all enterprise features enabled for testing and development purposes.

## Overview

This solution builds n8n from a fork that applies runtime modifications to bypass license checks, enabling full enterprise functionality without requiring a license. The build process automatically applies necessary fixes during Docker image creation.

## Features

- ✅ **All Enterprise Features Enabled**
  - Variables
  - Source Control
  - LDAP/SAML Authentication
  - External Secrets
  - Workflow History
  - Advanced Permissions
  - Projects (Unlimited)
  - API with full scopes
  - Debug in Editor
  - Binary Data S3
  - And more...

- ✅ **Optimized Build**
  - 21.9% smaller image size (1.57GB vs 2.01GB)
  - Removed dev files, test files, docs
  - Multi-stage build with cache optimization
  
- ✅ **Privacy Focused**
  - No telemetry or diagnostics
  - No license server connections
  - No auto-renewal attempts
  - No external "phone home" calls

## Quick Start

### Using Docker Compose (Recommended)

```bash
docker-compose -f docker-compose.unlicensed.yml up -d
```

### Direct Docker Run

```bash
docker run -d \
  --name n8n-unlicensed \
  -p 5678:5678 \
  -v n8n-unlicensed-data:/home/node/.n8n \
  -e N8N_DIAGNOSTICS_ENABLED=false \
  -e N8N_LICENSE_AUTO_RENEW_ENABLED=false \
  n8n-unlicensed:latest
```

### Build From Source

```bash
docker build -t n8n-unlicensed:latest -f Dockerfile.source-unlicensed .
```

## Access & Credentials

- **URL**: `http://localhost:5678`
- **Port**: 5678

### Default Admin Account (auto-created)
- **Email**: `admin@n8n.local`
- **Password**: `N8nPassword123`

### API Key (auto-created)
- **Key**: `n8n_api_test_key_123456789`
- **Scopes**: Full access to all API endpoints

## Files in This Directory

1. **`Dockerfile.source-unlicensed`** (652 lines)
   - Main Dockerfile that builds n8n from source
   - Applies license bypass and API key creation fixes
   - Multi-stage build for optimized image size (1.01GB)
   - Includes health checks and initialization scripts

2. **`docker-compose.unlicensed.yml`** (21 lines)
   - Simple deployment configuration
   - Pre-configured with optimal environment variables
   - Manages data persistence via Docker volumes
   - Exposes n8n on port 5678

3. **`license-unlicensed.ts`** (475 lines)
   - Modified license.ts file with all checks bypassed
   - Returns "Enterprise" plan with unlimited features
   - Disables license renewal and validation
   - Core component for enabling all features

4. **`README.md`** (This file)
   - Complete documentation for the solution
   - Usage instructions and troubleshooting

## Environment Variables

Key variables set in the build:

```yaml
N8N_DIAGNOSTICS_ENABLED: false         # No telemetry
N8N_LICENSE_AUTO_RENEW_ENABLED: false  # No renewal attempts
N8N_VERSION_NOTIFICATIONS_ENABLED: false # No update checks
N8N_TEMPLATES_ENABLED: true            # Templates work locally
N8N_SECURE_COOKIE: false               # For local development
```

## How It Works

### Technical Implementation

1. **Source Code Base**: 
   - Clones from https://github.com/pvdyck/n8n (branch: n8n-unlicensed)
   - Stays synchronized with upstream n8n for latest features

2. **License Bypass Method**:
   - Replaces `packages/cli/src/license.ts` with modified version
   - Key modifications:
     ```typescript
     isLicensed() { return true; }  // All features enabled
     getValue() { return -1; }       // Unlimited quotas
     getPlanName() { return 'Enterprise'; }
     ```
   - Disables license renewal and validation checks

3. **Build-time Fixes**:
   - Fixes TypeScript imports via sed commands
   - Corrects `ExecutionsPruningService` import
   - Updates `UserRepository` import path
   - Ensures compatibility with latest n8n code

4. **API Key Auto-creation**:
   - Modified `start.ts` includes `createDefaultApiKeyIfNeeded()`
   - Creates full-access API key on first startup
   - Enables immediate API access for testing

5. **Docker Optimization**:
   - Multi-stage build reduces image size
   - Uses `pnpm deploy` for production dependencies
   - Removes source files, tests, and dev dependencies
   - Final image: ~1GB (vs 2GB+ for standard builds)

## Maintenance

To update when n8n releases new versions:

1. Update your fork with latest n8n changes
2. Re-apply license modifications if needed
3. Rebuild the Docker image

## Important Notes

- **For Testing/Development Only** - Not for production use
- **Respect n8n Licensing** - Consider purchasing a license for production
- **No Support** - This is an unofficial modification
- **Use at Your Own Risk** - No warranties provided

## Troubleshooting

**Container won't start?**
- Check logs: `docker logs n8n-unlicensed`
- Ensure port 5678 is free

**Features not enabled?**
- Verify with: `curl http://localhost:5678/rest/settings | jq '.data.enterprise'`
- All values should be `true`

**API key not working?**
- Check it was created: `docker exec n8n-unlicensed cat /home/node/.n8n/config`
- Use in header: `X-N8N-API-KEY: n8n_api_test_key_123456789`