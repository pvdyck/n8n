# How to Check n8n Features

## Via Web UI

1. **Login** to http://localhost:7001 with:
   - Email: `admin@n8n.local`
   - Password: `N8nPassword123`

2. **Check Settings Menu**:
   - Go to Settings (bottom left)
   - Look for these menu items:
     - **Variables** - If visible, Variables feature is enabled
     - **Source Control** - If visible, Git sync is enabled
     - **External Secrets** - If visible, external secrets are enabled
     - **Usage and Plan** - Shows current plan and limits

3. **Check Workflow Limits**:
   - Try creating a workflow with many nodes (>100)
   - Community edition has limits, Enterprise has none

4. **Check User Limits**:
   - Go to Settings > Users
   - Try inviting multiple users
   - Community edition limits users

## Via API

```bash
# Check current settings
curl -s http://localhost:7001/rest/settings | jq '.data.license'

# Try accessing Variables API
curl -H "X-N8N-API-KEY: n8n_api_test_key_123456789" \
  http://localhost:7001/api/v1/variables

# Check workflow count limit
curl -H "X-N8N-API-KEY: n8n_api_test_key_123456789" \
  http://localhost:7001/api/v1/workflows | jq '.data | length'
```

## What to Look For

### Community Edition (Default)
- No Variables menu item
- No Source Control
- No External Secrets  
- Limited to 5 users
- Limited workflows
- "Community" shown in Usage & Plan

### Enterprise Edition (With License)
- All menu items visible
- Unlimited users
- Unlimited workflows
- Advanced features available
- "Enterprise" shown in Usage & Plan

## Current Status

Based on the modified `packages/cli/src/license.ts`, only the Variables feature is force-enabled. Other enterprise features still require a proper license.

To fully unlock all features, you would need to:
1. Obtain an enterprise license
2. Set it via environment variable `N8N_LICENSE_CERT`
3. Or modify more of the license checking code

The current setup provides:
- ✅ Working authentication
- ✅ Pre-configured API access
- ✅ Variables feature enabled
- ✅ No setup page
- ❌ Other enterprise features (require license)