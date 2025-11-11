# 🚀 Deployment Guide - UML Collaborative Diagrams

## 📦 Estructura del Proyecto

```
SW1_2do-Parcial-main/
├── backend/          # NestJS API + WebSockets
├── frontend/         # React + Vite SPA
└── docs/            # Documentación de deployment
```

## 🌐 URLs de Producción

### Backend (API + WebSocket)
- **Render URL**: `https://sw1-backend.onrender.com`
- **API Base**: `https://sw1-backend.onrender.com/api`
- **WebSocket**: `wss://sw1-backend.onrender.com/socket.io`
- **Health Check**: `https://sw1-backend.onrender.com/api/health`

### Frontend (Static Site)
- **Render URL**: `https://sw1-frontend.onrender.com`
- **Custom Domain**: (Opcional) `app.tudominio.com`

---

## 📚 Documentación de Deployment

### Backend (NestJS)
- 📖 **[RENDER_DEPLOYMENT.md](./RENDER_DEPLOYMENT.md)** - Guía completa de deployment del backend
- ✅ **[PRODUCTION_CHECKLIST.md](./PRODUCTION_CHECKLIST.md)** - Checklist de deployment backend
- 📘 **[backend/PRODUCTION_README.md](./backend/PRODUCTION_README.md)** - Documentación de API
- 🔧 **[backend/production-setup.sh](./backend/production-setup.sh)** - Script de ayuda

### Frontend (React + Vite)
- 📖 **[FRONTEND_DEPLOYMENT.md](./FRONTEND_DEPLOYMENT.md)** - Guía completa de deployment del frontend
- ✅ **[FRONTEND_CHECKLIST.md](./FRONTEND_CHECKLIST.md)** - Checklist de deployment frontend
- 📘 **[frontend/PRODUCTION_README.md](./frontend/PRODUCTION_README.md)** - Documentación técnica
- 🔧 **[frontend/production-setup.sh](./frontend/production-setup.sh)** - Script de ayuda

---

## ⚡ Quick Start - Deployment Completo

### 1️⃣ Preparación Local

```bash
# Clonar el repositorio
git clone https://github.com/RubenCano21/SW1_2do-Parcial-main.git
cd SW1_2do-Parcial-main

# Verificar que todo compila localmente
cd backend
npm install
npm run build

cd ../frontend
npm install
npm run build
```

### 2️⃣ Deploy Backend en Render

```bash
# 1. Crear cuenta en Render.com
# 2. New + → Web Service
# 3. Conectar repositorio: RubenCano21/SW1_2do-Parcial-main
# 4. Configurar:
#    - Name: sw1-backend
#    - Root Directory: backend
#    - Build Command: npm install && npm run build
#    - Start Command: npm run start:prod
```

**Variables de Entorno del Backend**:
```env
DATABASE_URL=<PostgreSQL connection string>
JWT_SECRET=<generar con: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))">
GROQ_API_KEY=<obtener en https://console.groq.com/keys>
GEMINI_API_KEY=<obtener en https://ai.google.dev/>
REDIS_URL=<Redis internal URL de Render>
PORT=3000
NODE_ENV=production
FRONTEND_URL=https://sw1-frontend.onrender.com
CORS_ORIGIN=https://sw1-frontend.onrender.com
```

📖 **Guía detallada**: [RENDER_DEPLOYMENT.md](./RENDER_DEPLOYMENT.md)

### 3️⃣ Deploy Frontend en Render

```bash
# 1. New + → Static Site
# 2. Conectar mismo repositorio
# 3. Configurar:
#    - Name: sw1-frontend
#    - Root Directory: frontend
#    - Build Command: npm install && npm run build
#    - Publish Directory: dist
```

**Variables de Entorno del Frontend**:
```env
VITE_API_URL=https://sw1-backend.onrender.com
VITE_WS_URL=https://sw1-backend.onrender.com
```

📖 **Guía detallada**: [FRONTEND_DEPLOYMENT.md](./FRONTEND_DEPLOYMENT.md)

---

## 🔄 Workflow de Deployment

### Desarrollo → Staging → Producción

```bash
# 1. Desarrollo local
git checkout -b feature/nueva-funcionalidad

# 2. Hacer cambios y commit
git add .
git commit -m "feat: nueva funcionalidad"

# 3. Push a GitHub
git push origin feature/nueva-funcionalidad

# 4. Crear Pull Request
# GitHub → Pull Request → Comparar feature/nueva-funcionalidad con master

# 5. Render automáticamente crea Preview Environment
# Probar en: https://sw1-backend-pr-XX.onrender.com

# 6. Merge a master
# Render automáticamente redespliega producción
```

---

## 🧪 Testing en Producción

### Health Check del Backend
```bash
curl https://sw1-backend.onrender.com/api/health
# Debería responder:
# {
#   "status": "ok",
#   "timestamp": "...",
#   "uptime": 12345,
#   "environment": "production"
# }
```

### Test del Frontend
1. Abre: https://sw1-frontend.onrender.com
2. F12 → Console (no debe haber errores)
3. Intenta login/registro
4. Crea un proyecto y diagrama
5. Verifica colaboración en tiempo real

### Test de WebSocket
```bash
# En browser console (F12)
# Debería ver:
# "Socket.IO connected"
# "Transport: websocket"
```

---

## 🔧 Mantenimiento

### Ver Logs

**Backend**:
```
Render Dashboard → sw1-backend → Logs
```

**Frontend**:
```
Render Dashboard → sw1-frontend → Logs
```

### Rollback

Si algo sale mal:
```
Render Dashboard → Service → Manual Deploy → Seleccionar commit anterior
```

### Actualizar Variables de Entorno

```
Render Dashboard → Service → Environment → Edit → Save Changes
# Nota: Requiere redeploy automático
```

---

## 🛠️ Scripts de Ayuda

### Backend
```bash
cd backend
chmod +x production-setup.sh
./production-setup.sh

# Opciones:
# 1) Instalar dependencias
# 2) Build
# 3) Run migrations
# 4) Health check
# 5) Generar JWT secret
# ... y más
```

### Frontend
```bash
cd frontend
chmod +x production-setup.sh
./production-setup.sh

# Opciones:
# 1) Instalar dependencias
# 2) Build para producción
# 3) Preview del build
# 4) Verificar configuración
# ... y más
```

---

## 🔐 Seguridad

### Antes de Desplegar

✅ **Checklist de Seguridad**:
- [ ] No hay API keys en código
- [ ] `.env` en `.gitignore`
- [ ] Nuevos API keys generados (no usar los del repo)
- [ ] JWT_SECRET único y seguro (32+ caracteres)
- [ ] CORS configurado correctamente
- [ ] HTTPS habilitado (Render lo hace automático)
- [ ] Headers de seguridad configurados

### Generar API Keys

```bash
# JWT Secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Groq API
# https://console.groq.com/keys

# Gemini API
# https://ai.google.dev/
```

---

## 📊 Monitoreo

### Métricas de Render

Render Dashboard muestra:
- CPU usage
- Memory usage
- Request count
- Response time
- Build time

### Custom Monitoring (Opcional)

Puedes integrar:
- Sentry (error tracking)
- LogRocket (session replay)
- Google Analytics (usage analytics)

---

## 🌍 Dominios Personalizados

### Configurar Custom Domain

```
Render Dashboard → Service → Settings → Custom Domain
→ Add Custom Domain: app.tudominio.com
→ Seguir instrucciones de DNS
```

**DNS Configuration**:
```
Type: CNAME
Name: app
Value: sw1-frontend.onrender.com
```

Render automáticamente genera certificado SSL.

---

## 💰 Costos

### Render Free Tier
- ✅ **Backend (Web Service)**: Gratis
  - Sleep después de 15 min de inactividad
  - 750 horas/mes gratis
  
- ✅ **Frontend (Static Site)**: Gratis
  - Sin límites de tráfico
  - CDN global incluido

- ✅ **PostgreSQL**: Gratis
  - 1GB storage
  - Expira después de 90 días (hay que recrear)

- ✅ **Redis**: Gratis
  - 25MB storage
  - Expira después de 90 días

### Render Paid Plans (Opcional)
- **Starter ($7/mes)**: Sin sleep, mejor performance
- **Standard ($25/mes)**: Auto-scaling, más recursos
- **PostgreSQL Starter ($7/mes)**: Sin expiración, backups

---

## 🐛 Troubleshooting

### Backend No Responde

1. **Verificar que esté corriendo**:
   ```
   Render Dashboard → sw1-backend → Status = "Live"
   ```

2. **Revisar logs**:
   ```
   Render Dashboard → sw1-backend → Logs
   ```

3. **Health check**:
   ```bash
   curl https://sw1-backend.onrender.com/api/health
   ```

### Frontend con Errores CORS

1. **Verificar CORS_ORIGIN en backend**:
   ```
   CORS_ORIGIN=https://sw1-frontend.onrender.com
   ```

2. **Redeploy backend** después de cambiar variables

### Build Falla

1. **Test local**:
   ```bash
   npm run build
   ```

2. **Revisar logs de build en Render**

3. **Clear cache y rebuild**:
   ```
   Render Dashboard → Manual Deploy → Clear build cache & deploy
   ```

### Database Connection Error

1. **Verificar DATABASE_URL**:
   - Debe ser el Internal URL de Render PostgreSQL
   
2. **Verificar que PostgreSQL está corriendo**:
   ```
   Render Dashboard → PostgreSQL → Status = "Available"
   ```

3. **Reconnect**:
   ```
   Render Dashboard → PostgreSQL → Restart
   ```

---

## 📞 Soporte

### Recursos

- 📖 **Render Docs**: https://docs.render.com/
- 💬 **Render Community**: https://community.render.com/
- 📧 **Support**: support@render.com
- 🐛 **GitHub Issues**: https://github.com/RubenCano21/SW1_2do-Parcial-main/issues

### Contacto del Equipo

- **Desarrollador**: RubenCano21
- **Repository**: https://github.com/RubenCano21/SW1_2do-Parcial-main

---

## 📄 Licencia

Este proyecto es parte del curso Software I - UAGRM.

---

## 🎉 ¡Deployment Completado!

Si seguiste todos los pasos:
- ✅ Backend desplegado y funcionando
- ✅ Frontend desplegado y conectado
- ✅ Base de datos PostgreSQL configurada
- ✅ Redis funcionando
- ✅ WebSockets operativos
- ✅ SSL/HTTPS habilitado
- ✅ CI/CD automático configurado

**URLs de Producción**:
- Frontend: `https://sw1-frontend.onrender.com`
- Backend: `https://sw1-backend.onrender.com`
- API: `https://sw1-backend.onrender.com/api`

---

**Última actualización**: 2025-01-11  
**Versión**: 2.0.0
