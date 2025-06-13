ARG NODE_VERSION=22

# This Dockerfile replicates EXACTLY what we did for the local build
FROM node:${NODE_VERSION}-alpine

# Install all dependencies just like we did locally
RUN apk add --no-cache \
    bash \
    git \
    python3 \
    make \
    g++ \
    libc6-compat \
    ca-certificates \
    jq \
    curl \
    sqlite \
    su-exec \
    tini \
    tzdata

# Install pnpm (same version as local)
RUN corepack enable && corepack prepare pnpm@10.11.1 --activate

# Copy the entire repository (just like local build)
WORKDIR /app
COPY . /app

# Install ALL dependencies (not just production) - exactly like we did locally
RUN DOCKER_BUILD=true pnpm install --frozen-lockfile

# Build everything - exactly like we did locally
RUN DOCKER_BUILD=true pnpm build

# Create necessary directories
RUN mkdir -p /home/node/.n8n /data && \
    chown -R node:node /home/node /data

# Set environment
ENV NODE_ENV=production \
    N8N_PORT=5678 \
    N8N_PROTOCOL=http \
    N8N_USER_FOLDER=/home/node \
    SHELL=/bin/sh

# Copy our simple entrypoint
COPY docker/custom-builds/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 5678
WORKDIR /app/packages/cli

# Run n8n exactly like we do locally
USER node
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["node", "bin/n8n"]