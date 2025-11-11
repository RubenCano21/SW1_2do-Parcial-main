# ✅ Frontend Production Deployment Checklist

## 📋 Pre-Deployment

### Verificaciones Locales
- [ ] **Build local exitoso**
  ```bash
  cd frontend
  npm install
  npm run build
  # Verifica que se cree dist/ sin errores
  ```

- [ ] **Linting sin errores**
  ```bash
  npm run lint
  # Corrige cualquier error antes de desplegar
  ```

- [ ] **Test de preview local**
  ```bash
  npm run preview
  # Abre http://localhost:4173 y prueba la app
  ```

### Código y Repositorio
- [ ] **Backend ya desplegado**
  - URL del backend anotada (ej: `https://sw1-backend.onrender.com`)
  
- [ ] **Variables de entorno preparadas**
  - `VITE_API_URL`: URL del backend
  - `VITE_WS_URL`: URL del backend (mismo valor)
  
- [ ] **Archivos sensibles ignorados**
  - `.env` en `.gitignore`
  - `.env.prod` en `.gitignore`
  - Solo `.env.example` committeado

- [ ] **Código en rama master actualizado**
  ```bash
  git status
  git push origin master
  ```

---

## 🚀 Deployment

### 1. Crear Static Site en Render

- [ ] **Acceder a Render Dashboard**
  - https://dashboard.render.com/
  - Iniciar sesión con GitHub

- [ ] **Crear nuevo Static Site**
  - Click "New +" → "Static Site"
  - Repositorio: `RubenCano21/SW1_2do-Parcial-main`
  - Rama: `master`

- [ ] **Configurar build settings**
  ```
  Name: sw1-frontend
  Branch: master
  Root Directory: frontend
  Build Command: npm install && npm run build
  Publish Directory: dist
  ```

- [ ] **Configurar variables de entorno**
  - Click "Advanced" → "Add Environment Variable"
  - `VITE_API_URL` = `https://tu-backend.onrender.com`
  - `VITE_WS_URL` = `https://tu-backend.onrender.com`

- [ ] **Habilitar Pull Request Previews**
  - Settings → Pull Request Previews → Enable

- [ ] **Iniciar deployment**
  - Click "Create Static Site"
  - Esperar a que el build complete (2-5 minutos)

### 2. Configurar Routing de SPA

- [ ] **Verificar rewrites configurados**
  - Si usaste `render.yaml`: Ya está configurado ✅
  - Si creaste manualmente: Ve a Settings → Redirects/Rewrites
  - Agrega: `/*` → `/index.html` (Type: Rewrite)

### 3. Headers de Seguridad (Opcional)

- [ ] **Agregar headers** (Settings → Headers):
  ```
  Path: /*
  Name: X-Frame-Options
  Value: SAMEORIGIN
  
  Path: /*
  Name: X-Content-Type-Options
  Value: nosniff
  
  Path: /*
  Name: Referrer-Policy
  Value: strict-origin-when-cross-origin
  ```

---

## 🔧 Post-Deployment

### Verificación Básica

- [ ] **Frontend accesible**
  - Abre la URL de Render (ej: `https://sw1-frontend.onrender.com`)
  - La página debe cargar sin errores

- [ ] **Sin errores en consola**
  - F12 → Console
  - No debe haber errores críticos

- [ ] **Routing funciona**
  - Navega a diferentes rutas (ej: `/projects`, `/diagrams`)
  - Refresh en cualquier ruta debe funcionar (no 404)

### Verificación de Conexión Backend

- [ ] **Variables de entorno correctas**
  - F12 → Console
  ```javascript
  console.log(import.meta.env.VITE_API_URL)
  // Debería mostrar tu URL de backend
  ```

- [ ] **Actualizar CORS en Backend**
  - Render Dashboard → Backend Service → Environment
  - `CORS_ORIGIN` = `https://sw1-frontend.onrender.com`
  - `FRONTEND_URL` = `https://sw1-frontend.onrender.com`
  - Click "Save Changes"
  - Manual Deploy → "Deploy latest commit"

- [ ] **Llamadas API funcionan**
  - Intenta login o cualquier acción
  - F12 → Network
  - Verifica llamadas a `https://tu-backend.onrender.com/api/*`
  - Status 200 (no errores CORS)

### Verificación WebSocket

- [ ] **WebSocket conecta**
  - Abre un diagrama colaborativo
  - F12 → Console
  - Busca mensajes de Socket.IO: "Transport: websocket"
  - No debe haber errores de conexión

- [ ] **Colaboración en tiempo real funciona**
  - Abre el mismo diagrama en 2 pestañas
  - Edita en una, verifica cambios en la otra

### Testing de Funcionalidades

- [ ] **Autenticación**
  - Registro de usuario funciona
  - Login funciona
  - JWT se guarda y persiste

- [ ] **CRUD de Proyectos**
  - Crear proyecto
  - Editar proyecto
  - Eliminar proyecto

- [ ] **CRUD de Diagramas**
  - Crear diagrama
  - Editar diagrama
  - Exportar diagrama
  - Eliminar diagrama

- [ ] **Características AI**
  - Asistente AI responde
  - Sugerencias de cardinalidad funcionan
  - Análisis de diagrama funciona

- [ ] **Colaboración**
  - Invitar colaboradores
  - Compartir diagramas
  - Edición simultánea

---

## 📊 Performance y Optimización

### Lighthouse Audit

- [ ] **Ejecutar Lighthouse**
  - F12 → Lighthouse → Generate Report
  
- [ ] **Performance Score > 80**
  - Si está bajo, considera lazy loading

- [ ] **Accessibility Score > 90**
  - Corrige issues de contraste, alt text, etc.

- [ ] **Best Practices Score > 90**
  - Verifica HTTPS, headers de seguridad

- [ ] **SEO Score > 80**
  - Agrega meta tags si es necesario

### Bundle Size

- [ ] **Verificar tamaño del bundle**
  ```bash
  # Local
  npm run build
  # Revisa dist/ size
  ```

- [ ] **Optimizar si es necesario**
  - Code splitting
  - Lazy loading
  - Tree shaking
  - Compresión de imágenes

### Caché y CDN

- [ ] **Verificar headers de caché**
  - F12 → Network → Selecciona un asset
  - Verifica `Cache-Control` headers
  - Render automáticamente agrega caché

---

## 🔐 Seguridad

### Variables de Entorno

- [ ] **Sin variables hardcodeadas**
  - Busca en código: `http://localhost`
  - Todo debe usar `import.meta.env.VITE_*`

- [ ] **No hay secrets en frontend**
  - API keys, tokens, etc. deben estar en backend

### HTTPS y SSL

- [ ] **HTTPS habilitado**
  - URL debe ser `https://` (Render lo hace automático)
  - Sin warnings de certificado

- [ ] **Mixed Content resuelto**
  - No debe haber llamadas `http://` desde `https://`

### Headers de Seguridad

- [ ] **Headers configurados** (ya hecho en deploy):
  - `X-Frame-Options`
  - `X-Content-Type-Options`
  - `Referrer-Policy`

---

## 📱 Cross-Browser Testing

- [ ] **Chrome** (Desktop)
- [ ] **Firefox** (Desktop)
- [ ] **Safari** (macOS)
- [ ] **Edge** (Windows)
- [ ] **Chrome Mobile** (Android)
- [ ] **Safari Mobile** (iOS)

---

## 🌐 Dominio Personalizado (Opcional)

- [ ] **Configurar custom domain**
  - Settings → Custom Domain
  - Agregar dominio (ej: `app.tudominio.com`)
  
- [ ] **Configurar DNS**
  - Agregar CNAME según instrucciones de Render
  - Esperar propagación (hasta 24h)

- [ ] **Verificar SSL en custom domain**
  - Render genera certificado automáticamente
  - Verificar que `https://` funcione

- [ ] **Actualizar CORS en backend**
  - Agregar custom domain a `CORS_ORIGIN`

---

## 🔄 CI/CD y Monitoreo

### Auto-Deployment

- [ ] **Verificar auto-deploy**
  - Push a `master` debe triggear deploy automático
  - Verificar en Render Dashboard → Events

### Monitoreo

- [ ] **Configurar notificaciones**
  - Settings → Notifications
  - Email para deploy failures

- [ ] **Verificar logs**
  - Logs → Build Logs (exitosos)
  - No errores en deploy

### Rollback Plan

- [ ] **Saber cómo hacer rollback**
  - Render Dashboard → Service
  - Manual Deploy → Seleccionar commit anterior

---

## 📝 Documentación

- [ ] **README actualizado**
  - URLs de producción documentadas
  - Instrucciones de deployment

- [ ] **Variables de entorno documentadas**
  - `.env.example` actualizado
  - Documentación de cada variable

- [ ] **Guías de troubleshooting**
  - `FRONTEND_DEPLOYMENT.md` revisado
  - Errores comunes documentados

---

## 🎉 Final Checks

- [ ] **URL de producción funcional**
  - Frontend: `https://sw1-frontend.onrender.com`
  - Backend: `https://sw1-backend.onrender.com`

- [ ] **Todas las funcionalidades probadas**
  - Auth, CRUD, WebSocket, AI

- [ ] **Performance aceptable**
  - Load time < 3s
  - Lighthouse > 80

- [ ] **Sin errores en consola o logs**
  - Browser console limpia
  - Render logs sin errors

- [ ] **Equipo notificado**
  - URLs compartidas
  - Credenciales de test (si aplica)

---

## 🆘 Troubleshooting

Si algo falla, revisa:

1. **Logs de Build**: Render Dashboard → Logs
2. **Browser Console**: F12 → Console
3. **Network Tab**: F12 → Network
4. **Backend Logs**: Verifica que backend esté corriendo
5. **Guía de Deployment**: `FRONTEND_DEPLOYMENT.md`

---

**Deployment completado exitosamente cuando todos los checks estén ✅**

**Fecha**: _______________  
**Deployed by**: _______________  
**Frontend URL**: _______________  
**Backend URL**: _______________
