# Docker Build Files

This directory contains Docker-related files for n8n.

## Directory Structure

```
docker/
├── images/          # Official n8n Docker images
│   ├── n8n/         # Main n8n image
│   └── n8n-base/    # Base image
└── custom-builds/   # Custom builds with modifications
    ├── Dockerfile.source-unlicensed
    └── docker-compose.unlicensed.yml
```

## Official Images

The `images/` directory contains the official n8n Docker builds used for releases.

## Custom Builds

The `custom-builds/` directory contains modified versions of n8n:
- **source-unlicensed**: Built from source with all enterprise features enabled and telemetry disabled

See [custom-builds/README.md](custom-builds/README.md) for detailed information.

## Quick Start

For the unlicensed build:
```bash
# Build from root directory
docker build -t n8n-unlicensed:latest -f docker/custom-builds/Dockerfile.source-unlicensed .

# Run with docker-compose
cd docker/custom-builds
docker-compose -f docker-compose.unlicensed.yml up -d
```