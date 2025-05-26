# License Renewal Fix for n8n Unlicensed Version

## Problem
The Docker logs showed the error:
```
Failed to renew license: renewal failed because current cert is not initialized
```

This error occurred because the unlicensed version was still attempting to renew a license that doesn't exist.

## Solution

### 1. Source Code Modifications (license-unlicensed.ts)
Modified the following in `packages/cli/src/license.ts`:

- **Line 83**: Set `shouldRenew = false` to always disable renewal
- **Lines 94-95**: Set `autoRenewEnabled: false` and `renewOnInit: false` in LicenseManager config
- **Lines 186-189**: Modified `renew()` method to just log a message and return
- **Lines 435-444**: Modified `enableAutoRenewals()` and `disableAutoRenewals()` to just log messages

### 2. Docker Configuration Updates
Added environment variables to `docker-compose.unlicensed.yml`:
```yaml
- N8N_LICENSE_AUTO_RENEW_ENABLED=false
- N8N_LICENSE_SERVER_URL=
```

### 3. Dockerfile Updates
Modified `Dockerfile.source-unlicensed` to:
- Copy the modified `license-unlicensed.ts` file during build
- Verify the modifications are present with additional grep checks

## Result
The unlicensed version will no longer attempt any license renewal operations:
- No renewal on startup
- No automatic renewal timers
- No renewal on leadership changes
- No manual renewal attempts

This eliminates the "cert is not initialized" error while maintaining all enterprise features in unlocked state.

## Building and Running
```bash
cd docker/custom-builds
docker-compose -f docker-compose.unlicensed.yml build --no-cache
docker-compose -f docker-compose.unlicensed.yml up -d
```

## Verification
Check logs to ensure no license renewal errors:
```bash
docker logs n8n-unlicensed 2>&1 | grep -i "license"
```

You should see:
- "License renewal is disabled in unlicensed version"
- "Auto-renewals are disabled in unlicensed version"
- No "Failed to renew license" errors