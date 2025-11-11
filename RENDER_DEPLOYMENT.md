# Render Deployment Guide - UML Diagram Collaboration Tool

## 🚀 Despliegue en Render

Este proyecto está configurado para desplegarse automáticamente en Render usando el archivo `render.yaml`.

### Servicios Incluidos

1. **Backend API** (Node.js)
   - Framework: NestJS
   - Puerto: 3000
   - Base de datos: PostgreSQL
   - Caché: Redis

2. **PostgreSQL Database**
   - Plan: Free
   - Región: Oregon

3. **Redis**
   - Para WebSockets y caché
   - Plan: Free

---

## 📋 Pasos para Desplegar

### 1. Preparación del Repositorio

Asegúrate de que tu código está en GitHub:

```bash
git add .
git commit -m "feat: prepare for Render deployment"
git push origin master
```

### 2. Crear Cuenta en Render

1. Ve a [https://render.com](https://render.com)
2. Regístrate con tu cuenta de GitHub
3. Autoriza a Render para acceder a tu repositorio

### 3. Crear Blueprint desde render.yaml

1. En Render Dashboard, haz clic en **"New +"** → **"Blueprint"**
2. Conecta tu repositorio: `RubenCano21/SW1_2do-Parcial-main`
3. Render detectará automáticamente el archivo `render.yaml`
4. Haz clic en **"Apply"**

### 4. Configurar Variables de Entorno

Render creará los servicios automáticamente. Debes configurar estas variables manualmente:

#### En el servicio `uml-diagram-backend`:

| Variable | Valor | Descripción |
|----------|-------|-------------|
| `GROQ_API_KEY` | `gsk_...` | Tu API key de Groq (obtén una nueva en https://console.groq.com/keys) |
| `GEMINI_API_KEY` | `AIza...` | Tu API key de Gemini (obtén una nueva en https://aistudio.google.com/apikey) |
| `FRONTEND_URL` | `https://tu-frontend.onrender.com` | URL de tu frontend desplegado |
| `CORS_ORIGIN` | `https://tu-frontend.onrender.com` | Mismo que FRONTEND_URL |

**⚠️ IMPORTANTE:** Genera nuevas API keys, no uses las del código anterior que fueron expuestas.

---

## 🔧 Configuración Manual Alternativa

Si prefieres crear los servicios manualmente en lugar de usar Blueprint:

### Crear PostgreSQL Database

1. **New +** → **PostgreSQL**
2. Nombre: `uml-diagram-db`
3. Database: `uml_diagram`
4. User: `uml_user`
5. Plan: **Free**
6. Haz clic en **Create Database**

### Crear Redis

1. **New +** → **Redis**
2. Nombre: `uml-diagram-redis`
3. Plan: **Free**
4. Maxmemory Policy: **allkeys-lru**
5. Haz clic en **Create Redis**

### Crear Web Service (Backend)

1. **New +** → **Web Service**
2. Conecta tu repositorio
3. Configuración:
   - **Name:** `uml-diagram-backend`
   - **Region:** Oregon
   - **Branch:** `master`
   - **Root Directory:** `backend`
   - **Runtime:** Node
   - **Build Command:**
     ```bash
     npm install && npx prisma generate && npm run build
     ```
   - **Start Command:**
     ```bash
     npx prisma migrate deploy && npm run start:prod
     ```
   - **Plan:** Free

4. Variables de entorno (agregar manualmente):
   ```
   NODE_ENV=production
   DATABASE_URL=[Internal Connection String from PostgreSQL]
   REDIS_URL=[Internal Connection String from Redis]
   JWT_SECRET=[Auto-generated or custom]
   JWT_EXPIRES=7d
   GROQ_API_KEY=[Your new API key]
   GEMINI_API_KEY=[Your new API key]
   GEMINI_API_URL=https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent
   GEMINI_MODEL=gemini-2.0-flash
   FRONTEND_URL=[Your frontend URL]
   CORS_ORIGIN=[Your frontend URL]
   ```

---

## 🔐 Seguridad

### Renovar API Keys

Antes de desplegar, **genera nuevas API keys**:

1. **Groq API:**
   - Ve a: https://console.groq.com/keys
   - Crea una nueva API key
   - Cópiala y guárdala en Render como `GROQ_API_KEY`

2. **Gemini API:**
   - Ve a: https://aistudio.google.com/apikey
   - Crea una nueva API key
   - Cópiala y guárdala en Render como `GEMINI_API_KEY`

### JWT Secret

Render puede auto-generar un JWT_SECRET seguro. O genera uno manualmente:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

## 🗃️ Migraciones de Base de Datos

Las migraciones se ejecutan automáticamente con el comando:

```bash
npx prisma migrate deploy
```

Este comando se ejecuta antes de iniciar el servidor en el `startCommand`.

---

## 📊 Monitoreo

Una vez desplegado, puedes monitorear tu aplicación en:

- **Logs:** Render Dashboard → Tu servicio → Logs
- **Métricas:** Render Dashboard → Tu servicio → Metrics
- **Shell:** Render Dashboard → Tu servicio → Shell (para ejecutar comandos)

### Comandos útiles desde el Shell:

```bash
# Ver estado de la base de datos
npx prisma studio

# Ejecutar migraciones manualmente
npx prisma migrate deploy

# Ver logs de Redis
redis-cli ping
```

---

## 🌐 URLs de Acceso

Después del despliegue, tendrás:

- **Backend API:** `https://uml-diagram-backend.onrender.com/api`
- **PostgreSQL:** Conexión interna automática
- **Redis:** Conexión interna automática

**Ejemplo de endpoint:**
```
GET https://uml-diagram-backend.onrender.com/api/users/me
```

---

## 🐛 Troubleshooting

### El servicio no inicia

1. Revisa los logs en Render Dashboard
2. Verifica que todas las variables de entorno estén configuradas
3. Asegúrate de que `DATABASE_URL` y `REDIS_URL` apunten a los servicios correctos

### Error de migraciones

Si las migraciones fallan, puedes ejecutarlas manualmente desde el Shell:

```bash
cd backend
npx prisma migrate deploy
```

### WebSockets no funcionan

Verifica que:
1. Redis esté corriendo
2. `REDIS_URL` esté configurado correctamente
3. El frontend use la URL correcta del backend

### CORS Errors

Actualiza `FRONTEND_URL` y `CORS_ORIGIN` con la URL exacta de tu frontend desplegado.

---

## 📝 Notas Importantes

1. **Plan Free de Render:**
   - Los servicios gratuitos se "duermen" después de 15 minutos de inactividad
   - El primer request después de dormir puede tardar ~30 segundos
   - Considera upgradearlo a plan de pago para producción real

2. **PostgreSQL Free:**
   - 90 días de almacenamiento
   - 1 GB de espacio
   - Después de 90 días, deberás migrar a un plan de pago

3. **Redis Free:**
   - 25 MB de memoria
   - Datos volátiles (se borran al reiniciar)

---

## 🔄 Auto-Deploy

Render hace auto-deploy cada vez que haces push a la rama `master`:

```bash
git add .
git commit -m "feat: new feature"
git push origin master
```

Render detectará el cambio y redesplegará automáticamente.

---

## 📧 Soporte

Si tienes problemas:
- Documentación de Render: https://render.com/docs
- Documentación de NestJS: https://docs.nestjs.com
- Documentación de Prisma: https://www.prisma.io/docs

---

## ✅ Checklist de Despliegue

- [ ] Código pusheado a GitHub
- [ ] Nuevas API keys generadas (Groq y Gemini)
- [ ] Archivo `.env.prod` en `.gitignore`
- [ ] Servicios creados en Render (PostgreSQL, Redis, Web Service)
- [ ] Variables de entorno configuradas
- [ ] Primer despliegue exitoso
- [ ] Migraciones ejecutadas
- [ ] Endpoints de API funcionando
- [ ] WebSockets conectados
- [ ] CORS configurado correctamente

---

¡Listo! Tu backend estará disponible en `https://uml-diagram-backend.onrender.com` 🚀
