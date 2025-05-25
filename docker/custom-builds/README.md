# Custom n8n Docker Builds

This directory contains custom Docker builds for n8n with specific modifications.

## Available Builds

### 1. Source Unlicensed (`Dockerfile.source-unlicensed`)

Builds n8n from source with the following modifications:
- ✅ All enterprise features enabled without license
- ✅ License validation bypassed
- ✅ Telemetry and diagnostics disabled
- ✅ Auto-renewal disabled
- ✅ No external "phone home" calls

**Build command:**
```bash
# From the n8n root directory
docker build -t n8n-unlicensed:latest -f docker/custom-builds/Dockerfile.source-unlicensed .
```

**Run with docker-compose:**
```bash
cd docker/custom-builds
docker-compose -f docker-compose.unlicensed.yml up -d
```

**Direct run:**
```bash
docker run -d \
  --name n8n-unlicensed \
  -p 5678:5678 \
  -v n8n-unlicensed-data:/home/node/.n8n \
  -e N8N_DIAGNOSTICS_ENABLED=false \
  -e N8N_LICENSE_AUTO_RENEW_ENABLED=false \
  n8n-unlicensed:latest
```

## Default Credentials

After first run, the following credentials are automatically created:
- **Email**: admin@n8n.local
- **Password**: N8nPassword123
- **API Key**: n8n_api_test_key_123456789

## Port Configuration

- **Internal port**: n8n always runs on port 5678 inside the container
- **Docker Compose**: Maps external port 7001 → internal 5678
- **Direct Docker run**: Default maps 5678 → 5678

Access URLs:
- With docker-compose: `http://localhost:7001`
- With docker run: `http://localhost:5678`

## Environment Variables

Key environment variables set in these builds:
- `N8N_DIAGNOSTICS_ENABLED=false` - Disables all telemetry
- `N8N_LICENSE_AUTO_RENEW_ENABLED=false` - Disables license renewal
- `N8N_VERSION_NOTIFICATIONS_ENABLED=false` - Disables update checks
- `N8N_TEMPLATES_ENABLED=true` - Templates still work locally

## Notes

- These builds are for testing and development purposes
- All enterprise features are available without a license
- No external connections for telemetry or license validation
- Based on the fork at https://github.com/pvdyck/n8n