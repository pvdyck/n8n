# Build Plan: n8n Enterprise Unlocked from Source

## Requirements
- ✅ Build from source (your fork with license.ts modifications)
- ✅ Static API key pre-configured
- ✅ User password already set (no manual setup)
- ✅ Run on port 6666
- ✅ New Docker image name: `n8n-enterprise-unlocked`

## Architecture Plan

### 1. Multi-Stage Docker Build
```
Stage 1: Builder
- Base: node:20-alpine
- Clone your fork (n8n-unlicensed branch)
- Verify license modifications
- Install dependencies with pnpm
- Build all packages
- ~15 minute build time

Stage 2: Runtime
- Base: node:20-alpine (minimal)
- Copy built artifacts from Stage 1
- Add runtime dependencies only
- Configure auto-setup scripts
- Final image ~500MB
```

### 2. Initialization Strategy
```
1. Start n8n in background
2. Wait for database initialization
3. Create owner account via API
4. Insert API key directly into database
5. Verify all features enabled
```

### 3. Key Design Decisions

**Why build from source?**
- Your fork has modified license.ts that bypasses all checks
- Runtime patching doesn't work with minified code
- Source modifications are the only reliable method

**Why multi-stage?**
- Reduces final image size (build deps not included)
- Faster subsequent builds (cache layers)
- Cleaner separation of concerns

**Why port 6666?**
- Avoids conflicts with other n8n instances
- Easy to remember
- Clearly different from default 5678

### 4. Implementation Steps

1. **Dockerfile.n8n-enterprise-unlocked**
   - Multi-stage build
   - Optimized for caching
   - Includes verification steps

2. **docker-compose.enterprise.yml**
   - Port mapping 6666:5678
   - Volume persistence
   - Environment configuration

3. **init-enterprise.sh**
   - Database initialization
   - Account creation
   - API key insertion

### 5. Expected Results

- **Build time**: 10-15 minutes (first build)
- **Image size**: ~500MB
- **Start time**: 30-60 seconds
- **Features**: ALL enterprise features enabled
- **Access**: http://localhost:6666

### 6. Credentials

- **Email**: admin@n8n.local
- **Password**: N8nPassword123
- **API Key**: n8n_api_enterprise_key_6666

### 7. Verification

After startup, should see:
- Plan: "Enterprise" 
- All features: true
- No license warnings
- Full access to Variables, Source Control, etc.