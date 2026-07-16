# ====================================================
#              STAGE 1: client build
#=====================================================
FROM node:lts-alpine3.24 AS client-builder
WORKDIR /app/client
COPY client/package*.json ./
RUN npm ci
COPY ./client ./
# webpack now writes directly to ../server/public,
# i.e. /app/server/public inside this build stage
RUN npm run build

# ====================================================
#              STAGE 2: server run
#=====================================================
FROM node:lts-alpine3.24 AS server-runner
WORKDIR /app/server
COPY server/package*.json ./
RUN npm ci --omit=dev
COPY ./server ./

# Pull the already-built client assets straight from where
# webpack put them in stage 1 — no path renaming needed.
COPY --from=client-builder /app/server/public/ ./public

ENV NODE_ENV=production

RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /app/
USER appuser

EXPOSE 5000
CMD ["npm", "start"]
