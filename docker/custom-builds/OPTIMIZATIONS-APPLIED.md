# Optimizations Applied from Official n8n Dockerfiles

This document lists all the optimizations that were safely incorporated from the official n8n Dockerfiles into the custom unlicensed build.

## 1. Build Stage Optimizations

### Cache Mounts for pnpm (from n8n/Dockerfile)
```dockerfile
RUN --mount=type=cache,id=pnpm-store,target=/root/.local/share/pnpm/store \
    --mount=type=cache,id=pnpm-metadata,target=/root/.cache/pnpm/metadata \
    pnpm install --frozen-lockfile
```
**Benefit**: Speeds up rebuilds by caching pnpm store between builds

### Virtual Package for Build Dependencies (from n8n-base/Dockerfile)
```dockerfile
RUN apk add --no-cache --virtual .build-deps \
    bash git python3 make g++ libc6-compat ca-certificates
# Later removed with:
apk del .build-deps
```
**Benefit**: Easy cleanup of build dependencies in one command

## 2. Source Code Cleanup

### Aggressive TypeScript/Source File Removal (from n8n/Dockerfile)
```dockerfile
find . -type f -name "*.ts" -o -name "*.vue" -o -name "tsconfig.json" -o -name "*.tsbuildinfo" | xargs rm -rf
```
**Benefit**: Removes all TypeScript files after build

### Multi-stage Cleanup
- Stage 1: Build
- Stage 2: Clean source
- Stage 3: Runtime
**Benefit**: Each stage starts fresh, reducing layer size

## 3. Runtime Optimizations

### Cache Cleanup (from multiple official Dockerfiles)
```dockerfile
rm -rf /tmp/* /var/tmp/* /root/.npm /root/.cache /root/.local
rm -rf /tmp/v8-compile-cache*
```
**Benefit**: Removes all temporary files and caches

### Environment Variables (from n8n/Dockerfile)
```dockerfile
ENV SHELL=/bin/sh
```
**Benefit**: Ensures consistent shell environment

### APK Cache Removal
```dockerfile
rm -rf /var/cache/apk/*
```
**Benefit**: Removes package manager cache immediately after installation

## 4. File System Cleanup Patterns

### Find and Delete Patterns
- `*.d.ts` files (TypeScript declarations)
- `*.map` files (source maps)
- `*.md` files (documentation)
- Test directories (`__tests__`, `test`, `tests`)
- Example directories
- Coverage directories
- Config files (`.eslintrc*`, `.prettierrc*`)
- Duplicate licenses (keep only at root)

## 5. Additional Optimizations Applied

### From Official Patterns
- Single RUN commands to minimize layers
- Immediate cleanup after operations
- Use of `--no-cache` with apk
- Cleanup of `.cache` directories throughout the filesystem
- Removal of build artifacts before copying to final stage

## Results

These optimizations contributed to:
- **21.9% size reduction** (from 2.01GB to 1.57GB)
- **Faster builds** due to cache mounts
- **Cleaner runtime** with no development artifacts
- **Maintained functionality** with all features intact

## Future Considerations

Additional optimizations from official builds that could be explored:
1. Using `pnpm deploy` for production-only dependencies
2. Implementing the `trim-fe-packageJson.js` script
3. Using a custom base image like `n8nio/base`
4. Platform-specific builds with `--platform` flag