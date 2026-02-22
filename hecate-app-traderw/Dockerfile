# Hecate Trader Web Dockerfile
# Build SvelteKit SPA + serve with nginx

# Build stage
FROM node:22-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .
RUN npm run build

# Runtime stage
FROM nginx:alpine

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy built SPA
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx config (replaces main config to run as root for socket access)
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 5174

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -sf http://localhost:5174/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
