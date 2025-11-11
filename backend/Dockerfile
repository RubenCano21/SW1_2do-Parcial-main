# ============================
# 1) Builder image
# ============================
FROM node:20-alpine AS builder

WORKDIR /app

# Copiamos package.json y lock
COPY package*.json ./

# Instalamos dependencias (incluye dev)
RUN npm install

# Copiamos el código fuente
COPY . .

# Generamos Prisma Client
RUN npx prisma generate

# Compilamos Nest
RUN npm run build


# ============================
# 2) Production image
# ============================
FROM node:20-alpine AS production

WORKDIR /app

# Copiar package.json y lock
COPY package*.json ./

# Copiar Prisma schema ANTES de instalar dependencias
COPY --from=builder /app/prisma ./prisma

# Instalar dependencias de producción
RUN npm install --omit=dev

# Generar Prisma Client en producción
RUN npx prisma generate

# Copiar dist compilado
COPY --from=builder /app/dist ./dist

# Render asigna este puerto vía env
ENV PORT=3000
EXPOSE 3000

# Comando para migraciones + ejecutar app
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]
