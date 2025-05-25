# Current Status - n8n Unlicensed

## 🟢 Working Now: Simple Version

**Running on port 7001**

### Access:
- **URL**: http://localhost:7001
- **Email**: admin@n8n.local
- **Password**: N8nPassword123
- **API Key**: n8n_api_test_key_123456789

### Features:
- ✅ Automatic setup (no manual configuration)
- ✅ Pre-configured admin account
- ✅ Pre-created API key
- ✅ Persistent data storage
- ❌ Enterprise features (Variables, Source Control, etc.)

### Test Commands:
```bash
# Check if running
docker ps | grep n8n-unlicensed

# Test API
wget -qO- --header="X-N8N-API-KEY: n8n_api_test_key_123456789" \
  http://localhost:7001/api/v1/workflows

# View logs
docker logs n8n-unlicensed

# Test features
./test-license-features.sh
```

## 🟡 Building: Source Version

**Build in progress (10-15 minutes total)**

### What it does:
1. Clones your fork with modified license.ts
2. Builds n8n from source
3. Enables ALL enterprise features through code

### Modified in license.ts:
```typescript
isLicensed() { return true; }
getValue() { return UNLIMITED_LICENSE_QUOTA; }
getPlanName() { return 'Enterprise'; }
```

### To check build status:
```bash
# See if image is ready
docker images | grep n8n-unlicensed-source

# Once built, run it
docker-compose -f docker-compose.n8n-source.yml up -d
```

## 📊 Comparison

| Feature | Simple Version | Source Version |
|---------|---------------|----------------|
| Build Time | < 1 minute | 10-15 minutes |
| Auto Setup | ✅ | ✅ |
| API Key | ✅ | ✅ |
| Variables | ❌ | ✅ |
| Source Control | ❌ | ✅ |
| External Secrets | ❌ | ✅ |
| All Enterprise | ❌ | ✅ |

## 🚀 Next Steps

1. **Use Simple Version** - For basic n8n with auth
2. **Wait for Source Build** - For full enterprise features
3. **Check your fork** - https://github.com/pvdyck/n8n/tree/n8n-unlicensed