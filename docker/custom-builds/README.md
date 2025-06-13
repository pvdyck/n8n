# n8n Custom Build - Unlicensed Version

This directory contains the Docker configuration for building and running n8n without license restrictions.

## Quick Start

```bash
# Build and run
docker-compose up -d

# Access n8n
open http://localhost:5678
```

## Files

- `Dockerfile`: Builds n8n with all features unlocked
- `docker-compose.yml`: Container configuration
- `docker-entrypoint.sh`: Simple entrypoint script
- `license-unlicensed.ts`: Modified license file (reference only - not used in build)

## Features

All enterprise features are enabled:
- ✅ Unlimited workflows
- ✅ All node types
- ✅ No execution limits
- ✅ Advanced features
- ✅ API access
- ✅ User management

## Build Details

This build replicates the exact local development process that works:
1. Installs ALL dependencies (not just production)
2. Builds the complete n8n monorepo
3. Runs from the built packages/cli directory

The license modifications are already applied in the parent repository.

## Adding Community Nodes (e.g., Telepilot)

To add community nodes like Telepilot:

```bash
# Build n8n with Telepilot
docker-compose -f docker-compose.telepilot.yml build

# Run n8n with Telepilot
docker-compose -f docker-compose.telepilot.yml up -d

# Access on port 5680
open http://localhost:5680
```

The Telepilot build uses the base unlicensed image and adds the community node.