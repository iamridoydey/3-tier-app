# ====================================================
#              STAGE 1: client build
#=====================================================
FROM node:lts-alpine3.24 AS client-builder
WORKDIR /app/client
COPY client/package*.json ./
RUN npm ci
COPY ./client ./
RUN npm run build

# ====================================================
#              STAGE 2: server run
#=====================================================
FROM node:lts-alpine3.24 AS server-runner
WORKDIR /app/server
COPY server/package*.json ./
RUN npm ci --omit=dev
COPY ./server ./

# Create public dir
RUN mkdir -p public
COPY --from=client-builder /app/client/public/ ./public
ENV NODE_ENV=production

# Create a group in alpine and add a user to this group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# Provide the dir perimission to the user 
RUN chown -R appuser:appgroup /app/

USER appuser

EXPOSE 5000
CMD ["npm", "start"]
