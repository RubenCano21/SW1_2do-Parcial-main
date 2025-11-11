# ✅ Checklist de Producción - Render

## Pre-Despliegue

### 1. Seguridad
- [ ] Generar nueva `GROQ_API_KEY` en https://console.groq.com/keys
- [ ] Generar nueva `GEMINI_API_KEY` en https://aistudio.google.com/apikey
- [ ] Generar `JWT_SECRET` seguro (usar: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`)
- [ ] Verificar que `.env`, `.env.prod` y archivos sensibles estén en `.gitignore`
- [ ] Confirmar que no hay secrets en el historial de Git

### 2. Código
- [ ] Compilación exitosa (`npm run build`)
- [ ] Tests pasando (`npm run test`)
- [ ] Sin errores de lint (`npm run lint`)
- [ ] Código pusheado a GitHub en rama `master`

### 3. Base de Datos
- [ ] Schema de Prisma actualizado
- [ ] Migraciones creadas
- [ ] `prisma generate` funciona correctamente

### 4. Configuración
- [ ] `render.yaml` configurado
- [ ] `Dockerfile` optimizado
- [ ] Scripts de producción en `package.json`
- [ ] CORS configurado para dominio de producción

## Despliegue en Render

### 5. Crear Servicios
- [ ] Cuenta de Render creada
- [ ] Repositorio conectado a Render
- [ ] PostgreSQL Database creado
- [ ] Redis creado
- [ ] Web Service creado (o Blueprint aplicado)

### 6. Variables de Entorno
Configurar en Render Dashboard → Backend Service → Environment:

**Obligatorias:**
- [ ] `DATABASE_URL` (desde PostgreSQL interno)
- [ ] `REDIS_URL` (desde Redis interno)
- [ ] `JWT_SECRET` (generado)
- [ ] `JWT_EXPIRES` = `7d`
- [ ] `GROQ_API_KEY` (nueva key)
- [ ] `GEMINI_API_KEY` (nueva key)
- [ ] `NODE_ENV` = `production`

**Opcionales (completar después del deploy de frontend):**
- [ ] `FRONTEND_URL` = URL del frontend en Render
- [ ] `CORS_ORIGIN` = URL del frontend en Render

**Pre-configuradas:**
- [ ] `GEMINI_API_URL` = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent`
- [ ] `GEMINI_MODEL` = `gemini-2.0-flash`
- [ ] `PORT` = `3000` (o auto-asignado por Render)

### 7. Primer Despliegue
- [ ] Trigger manual deploy en Render
- [ ] Build exitoso (ver logs)
- [ ] Migraciones ejecutadas
- [ ] Servicio iniciado correctamente

## Post-Despliegue

### 8. Verificación
- [ ] Health check: `curl https://tu-backend.onrender.com/api/health`
- [ ] Response esperado: `{"status":"ok","timestamp":"...","uptime":...,"environment":"production"}`
- [ ] Logs sin errores críticos
- [ ] Base de datos accesible (verificar en Prisma Studio si es necesario)

### 9. Testing de Endpoints
- [ ] `POST /api/auth/login` funciona
- [ ] `POST /api/users/register` funciona
- [ ] `GET /api/users/me` requiere autenticación
- [ ] `GET /api/projects` requiere autenticación
- [ ] WebSockets conectan correctamente

### 10. Configurar Frontend
- [ ] Actualizar `FRONTEND_URL` en backend
- [ ] Actualizar `CORS_ORIGIN` en backend
- [ ] Actualizar API base URL en frontend
- [ ] Redesplegar backend si cambió configuración

### 11. Monitoreo
- [ ] Configurar alertas en Render (opcional)
- [ ] Bookmark del dashboard de Render
- [ ] Revisar logs regularmente

## Mantenimiento

### 12. Actualizaciones
- [ ] Proceso de CI/CD configurado (auto-deploy en push a master)
- [ ] Plan de backups de base de datos
- [ ] Documentación de rollback

### 13. Performance
- [ ] Considerar upgrade del plan Free si hay mucho tráfico
- [ ] Monitorear uso de PostgreSQL (límite 90 días en Free)
- [ ] Monitorear uso de Redis (límite 25 MB en Free)

## Comandos Útiles

### Generar JWT Secret
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### Verificar Health Check
```bash
curl https://tu-backend.onrender.com/api/health
```

### Ver Logs en Tiempo Real
Dashboard → Tu servicio → Logs

### Ejecutar Migraciones Manualmente
Dashboard → Tu servicio → Shell
```bash
cd backend
npx prisma migrate deploy
```

### Abrir Prisma Studio (local contra DB de Render)
```bash
# Copiar DATABASE_URL de Render
DATABASE_URL="postgresql://..." npx prisma studio
```

## Troubleshooting Común

### ❌ Build falla
- Verificar que `node_modules` no esté en Git
- Verificar versión de Node en `render.yaml` (debe ser 20)
- Revisar logs de build en Render

### ❌ Migraciones fallan
- Verificar `DATABASE_URL`
- Ejecutar migraciones manualmente desde Shell
- Verificar que schema.prisma esté sincronizado

### ❌ App no inicia
- Verificar todas las variables de entorno requeridas
- Revisar logs de startup
- Verificar que `PORT` esté correctamente configurado

### ❌ CORS errors
- Actualizar `FRONTEND_URL` y `CORS_ORIGIN`
- Redesplegar backend
- Verificar URL exacta del frontend (con/sin trailing slash)

### ❌ WebSockets no conectan
- Verificar `REDIS_URL`
- Verificar que Redis esté corriendo
- Revisar configuración de Socket.IO en frontend

---

## 🎯 Estado Actual

**Fecha:** 2025-11-11

**Completado:**
- ✅ Código preparado para producción
- ✅ `render.yaml` creado
- ✅ Documentación completa
- ✅ `.gitignore` actualizado
- ✅ Health check implementado
- ✅ Scripts de producción agregados
- ✅ Código pusheado a GitHub

**Pendiente:**
- ⏳ Crear servicios en Render
- ⏳ Configurar variables de entorno
- ⏳ Primer despliegue
- ⏳ Testing en producción
- ⏳ Configurar frontend

---

**Última actualización:** 11 de noviembre de 2025
