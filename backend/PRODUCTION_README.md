# UML Diagram Collaboration Backend

API backend para la aplicación de colaboración en diagramas UML en tiempo real.

## 🚀 Tech Stack

- **Framework:** NestJS
- **Base de datos:** PostgreSQL (Prisma ORM)
- **Caché/WebSockets:** Redis + Socket.IO
- **Autenticación:** JWT
- **AI:** Groq SDK, Google Gemini
- **Procesamiento de imágenes:** Tesseract.js, Sharp

## 📋 Requisitos Previos

- Node.js 20.x o superior
- PostgreSQL 14+
- Redis 7+
- npm o yarn

## 🛠️ Configuración Local

### 1. Instalar Dependencias

```bash
npm install
```

### 2. Configurar Variables de Entorno

Crea un archivo `.env` basado en `env.example`:

```bash
cp env.example .env
```

Edita `.env` con tus valores:

```env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/dbname"

# JWT
JWT_SECRET="your-secret-key-here"
JWT_EXPIRES="7d"

# AI APIs
GROQ_API_KEY="your-groq-api-key"
GEMINI_API_KEY="your-gemini-api-key"
GEMINI_API_URL="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
GEMINI_MODEL="gemini-2.0-flash"

# Server
PORT=3000
NODE_ENV=development

# Frontend
FRONTEND_URL="http://localhost:5173"
CORS_ORIGIN="http://localhost:5173"

# Redis
REDIS_URL="redis://localhost:6379"
```

### 3. Configurar Base de Datos

```bash
# Generar Prisma Client
npm run prisma:generate

# Ejecutar migraciones
npx prisma migrate dev

# (Opcional) Abrir Prisma Studio
npm run prisma:studio
```

### 4. Iniciar Servidor de Desarrollo

```bash
npm run start:dev
```

El servidor estará disponible en `http://localhost:3000`

## 🏗️ Scripts Disponibles

```bash
# Desarrollo
npm run start:dev          # Modo desarrollo con hot-reload
npm run start:debug        # Modo debug

# Producción
npm run build              # Compilar para producción
npm run start:prod         # Ejecutar versión de producción
npm run deploy             # Build + migrate + start

# Prisma
npm run prisma:generate    # Generar Prisma Client
npm run prisma:migrate     # Ejecutar migraciones en producción
npm run prisma:studio      # Abrir Prisma Studio

# Testing
npm run test               # Ejecutar tests
npm run test:watch         # Tests en modo watch
npm run test:cov           # Tests con cobertura
npm run test:e2e           # Tests end-to-end

# Calidad de Código
npm run lint               # Ejecutar ESLint
npm run format             # Formatear código con Prettier
```

## 🌐 Endpoints Principales

### Autenticación
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/users/register` - Registrar usuario
- `GET /api/users/me` - Obtener usuario actual

### Proyectos
- `POST /api/projects` - Crear proyecto
- `GET /api/projects` - Listar proyectos del usuario
- `GET /api/projects/:id` - Obtener proyecto específico
- `DELETE /api/projects/:id` - Eliminar proyecto

### Diagramas
- `GET /api/projects/:projectId/diagram` - Obtener diagrama
- `PUT /api/projects/:projectId/diagram` - Actualizar diagrama
- `GET /api/public/projects/:projectId/diagram` - Ver diagrama público

### Colaboración
- `POST /api/projects/:projectId/request-edit` - Solicitar permisos de edición
- `POST /api/projects/:projectId/share` - Compartir proyecto
- `GET /api/projects/:projectId/share` - Obtener enlace de compartir

### AI
- `POST /api/ai/analyze-uml` - Analizar diagrama UML
- `POST /api/ai/suggest-cardinality` - Sugerir cardinalidad
- `POST /api/ai/analyze-image` - Analizar imagen con OCR
- `POST /api/ai/scan-diagram` - Escanear diagrama
- `POST /api/ai/asistente` - Asistente de chat

### Health Check
- `GET /api/health` - Verificar estado del servidor

## 🔌 WebSockets

El servidor utiliza Socket.IO para colaboración en tiempo real:

- **Namespace:** `/diagram`
- **Eventos:**
  - `join` - Unirse a una sala de diagrama
  - `patch` - Aplicar cambios al diagrama
  - `requestEdit` - Solicitar permisos de edición
  - `approveEdit` - Aprobar solicitud de edición
  - `y:sync:pull` / `y:sync:push` - Sincronización Yjs
  - `awareness:update` - Actualizar presencia de usuarios

## 🚀 Despliegue en Producción

### Render

Para desplegar en Render, consulta [RENDER_DEPLOYMENT.md](../RENDER_DEPLOYMENT.md) en la raíz del proyecto.

### Docker

```bash
# Construir imagen
docker build -t uml-backend .

# Ejecutar contenedor
docker run -d \
  --name uml-backend \
  -p 3000:3000 \
  --env-file .env \
  uml-backend
```

### Variables de Entorno Requeridas en Producción

```env
NODE_ENV=production
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
JWT_SECRET=<strong-secret>
GROQ_API_KEY=<your-key>
GEMINI_API_KEY=<your-key>
FRONTEND_URL=<your-frontend-url>
CORS_ORIGIN=<your-frontend-url>
```

## 🗄️ Estructura de Base de Datos

- **User** - Usuarios del sistema
- **Project** - Proyectos de diagramas
- **Diagram** - Datos de diagramas UML
- **DiagramVersion** - Historial de versiones
- **CollabLink** - Enlaces de colaboración
- **EditRequest** - Solicitudes de edición

Ver esquema completo en `prisma/schema.prisma`

## 📊 Monitoreo

### Health Check

```bash
curl http://localhost:3000/api/health
```

Respuesta esperada:
```json
{
  "status": "ok",
  "timestamp": "2025-11-11T12:00:00.000Z",
  "uptime": 123.45,
  "environment": "development"
}
```

## 🔐 Seguridad

- Las contraseñas se hashean con bcrypt
- JWT para autenticación stateless
- CORS configurado para dominios específicos
- Validación de inputs con class-validator
- API keys nunca se commitean (ver `.gitignore`)

## 🐛 Troubleshooting

### Error: Prisma Client no generado

```bash
npm run prisma:generate
```

### Error: Conexión a PostgreSQL

Verifica `DATABASE_URL` en `.env` y que PostgreSQL esté corriendo:

```bash
psql -h localhost -U user -d dbname
```

### Error: Conexión a Redis

Verifica `REDIS_URL` en `.env` y que Redis esté corriendo:

```bash
redis-cli ping
# Debe responder: PONG
```

## 📚 Documentación Adicional

- [NestJS](https://docs.nestjs.com)
- [Prisma](https://www.prisma.io/docs)
- [Socket.IO](https://socket.io/docs/v4/)
- [Groq API](https://console.groq.com/docs)
- [Gemini API](https://ai.google.dev/docs)

---

### 🎯 MI PARTE (RUBEN) -> LA IA PARA EDICION DEL DIAGRAMA 
 - CASOS DE PRUEBA DE POSTMAN

**Desarrollado con ❤️ usando NestJS**
