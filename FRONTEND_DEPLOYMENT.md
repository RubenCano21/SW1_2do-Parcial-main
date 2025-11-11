# 🚀 Guía de Deployment del Frontend en Render

## 📌 Resumen Rápido

El frontend es una Single Page Application (SPA) construida con React + Vite que se desplegará como **Static Site** en Render (GRATIS).

## 🎯 Pasos para Desplegar

### 1️⃣ Pre-requisitos

✅ Backend ya desplegado en Render (ej: `https://sw1-backend.onrender.com`)  
✅ Repositorio en GitHub actualizado  
✅ Node.js 20.x instalado localmente (para testing)

### 2️⃣ Crear Static Site en Render

1. **Accede a Render Dashboard**:
   - Ve a [https://dashboard.render.com/](https://dashboard.render.com/)
   - Inicia sesión con tu cuenta de GitHub

2. **Crear Nuevo Static Site**:
   ```
   Click en "New +" → "Static Site"
   ```

3. **Conectar Repositorio**:
   ```
   Repository: RubenCano21/SW1_2do-Parcial-main
   Branch: master
   ```

4. **Configuración del Build**:
   ```yaml
   Name: sw1-frontend
   Branch: master
   Root Directory: frontend
   Build Command: npm install && npm run build
   Publish Directory: dist
   ```

5. **Variables de Entorno** (Click en "Advanced"):
   
   Agrega estas variables:
   
   | Variable | Valor |
   |----------|-------|
   | `VITE_API_URL` | `https://sw1-backend.onrender.com` |
   | `VITE_WS_URL` | `https://sw1-backend.onrender.com` |
   
   ⚠️ **IMPORTANTE**: Reemplaza `sw1-backend` con el nombre real de tu servicio backend en Render.

6. **Deploy**:
   ```
   Click en "Create Static Site"
   ```

### 3️⃣ Configurar Backend para Aceptar Frontend

Una vez que el frontend esté desplegado, necesitas actualizar el backend:

1. **Obtén la URL del Frontend**:
   ```
   Ejemplo: https://sw1-frontend.onrender.com
   ```

2. **Actualiza Variables de Entorno del Backend** en Render Dashboard:
   
   ```bash
   CORS_ORIGIN=https://sw1-frontend.onrender.com
   FRONTEND_URL=https://sw1-frontend.onrender.com
   ```

3. **Redespliega el Backend**:
   ```
   Render → Backend Service → Manual Deploy → "Deploy latest commit"
   ```

### 4️⃣ Verificación Post-Deployment

#### Test 1: Verificar que el Frontend Carga
```
1. Abre: https://sw1-frontend.onrender.com
2. Debería cargar la página principal sin errores
```

#### Test 2: Verificar Conexión al Backend
```javascript
// Abre Developer Tools (F12) → Console
console.log(import.meta.env.VITE_API_URL)
// Debería mostrar: https://sw1-backend.onrender.com
```

#### Test 3: Verificar Llamadas API
```
1. Intenta hacer login o cualquier acción que llame al backend
2. Abre Developer Tools → Network tab
3. Verifica que las llamadas API se hagan a https://sw1-backend.onrender.com
4. No debería haber errores CORS
```

#### Test 4: Verificar WebSocket
```
1. Abre un diagrama colaborativo
2. Developer Tools → Console
3. Busca mensajes de Socket.IO conectando
4. No debería haber errores de conexión WebSocket
```

## 🔧 Configuración Avanzada

### Opción A: Usar Blueprint (Automático)

Si prefieres configuración como código, usa el archivo `frontend/render.yaml`:

```bash
# En Render Dashboard
New + → Blueprint

# Conecta el repositorio y selecciona:
Blueprint Path: frontend/render.yaml
```

### Opción B: Custom Domain

1. Ve a tu Static Site en Render
2. Settings → Custom Domain
3. Agrega tu dominio (ej: `app.midominio.com`)
4. Configura DNS según las instrucciones

### Opción C: Pull Request Previews

Ya está habilitado en `render.yaml`:
```yaml
pullRequestPreviewsEnabled: true
```

Cada PR creará un preview environment automáticamente.

## 🐛 Troubleshooting

### ❌ Error: 404 en Rutas de React Router

**Síntoma**: Al navegar directamente a `/projects` o cualquier ruta, obtienes 404.

**Solución**: Render ya está configurado con rewrite rules en `render.yaml`:
```yaml
routes:
  - type: rewrite
    source: /*
    destination: /index.html
```

Si usaste configuración manual, agrega esto en Settings → Redirects/Rewrites.

---

### ❌ Error: CORS en Llamadas API

**Síntoma**: 
```
Access to XMLHttpRequest at 'https://sw1-backend.onrender.com/api/...' 
from origin 'https://sw1-frontend.onrender.com' has been blocked by CORS policy
```

**Solución**:
1. Verifica que `CORS_ORIGIN` en el backend incluya la URL del frontend
2. Redespliega el backend
3. Verifica en backend logs que CORS esté habilitado:
   ```
   CORS enabled for: https://sw1-frontend.onrender.com
   ```

---

### ❌ Error: Variables de Entorno No Funcionan

**Síntoma**: `import.meta.env.VITE_API_URL` es `undefined`

**Causas y Soluciones**:
1. **Falta el prefijo VITE_**:
   - ❌ `API_URL=...`
   - ✅ `VITE_API_URL=...`

2. **No reconstruiste después de cambiar variables**:
   ```
   Render Dashboard → Manual Deploy → "Clear build cache & deploy"
   ```

3. **Variables no configuradas en Render**:
   - Ve a Settings → Environment
   - Verifica que las variables existan

---

### ❌ Error: Build Falla en Render

**Síntoma**: Build logs muestran errores de TypeScript o npm

**Solución**:
```bash
# Test local del build
cd frontend
npm install
npm run build

# Si falla localmente, corrige los errores primero
# Luego commit y push
git add .
git commit -m "fix: corrige errores de build"
git push origin master
```

---

### ❌ Error: WebSocket No Conecta

**Síntoma**: 
```
WebSocket connection to 'wss://sw1-backend.onrender.com/socket.io/...' failed
```

**Solución**:
1. Verifica que `VITE_WS_URL` esté configurado
2. Asegúrate de usar `wss://` (WebSocket Secure) en producción
3. Verifica que el backend esté corriendo y acepte conexiones WebSocket
4. Revisa backend logs para errores de WebSocket

---

### ❌ Error: Slow Loading / Performance

**Síntomas**: La aplicación tarda mucho en cargar

**Soluciones**:

1. **Optimizar Imágenes**:
   ```bash
   # Usa formatos modernos y compresión
   npm install --save-dev vite-plugin-imagemin
   ```

2. **Code Splitting**:
   ```typescript
   // Lazy load componentes pesados
   const HeavyComponent = lazy(() => import('./HeavyComponent'))
   ```

3. **Analizar Bundle Size**:
   ```bash
   npm install --save-dev rollup-plugin-visualizer
   npm run build
   # Abre stats.html para ver qué está ocupando espacio
   ```

4. **Habilitar Compression**:
   - Render automáticamente sirve archivos con gzip/brotli
   - No necesitas configuración adicional

## 📊 Monitoreo y Logs

### Ver Logs de Build
```
Render Dashboard → Static Site → Logs

# Busca:
✅ "Build succeeded"
✅ "Publish directory: dist"
✅ "Your site is live at https://..."
```

### Verificar Performance
```bash
# Usa Lighthouse en Chrome
1. Abre tu sitio en Chrome
2. F12 → Lighthouse tab
3. Generate report

# Metas:
- Performance: > 90
- Accessibility: > 90
- Best Practices: > 90
- SEO: > 80
```

## 🔄 CI/CD Automático

Render detecta automáticamente cambios en `master`:

```bash
# Workflow típico
cd frontend
# Haz cambios en el código
git add .
git commit -m "feat: nueva funcionalidad"
git push origin master

# Render automáticamente:
# 1. Detecta el push
# 2. Ejecuta npm install && npm run build
# 3. Publica el nuevo dist/
# 4. Tu sitio se actualiza (sin downtime)
```

## 🔐 Seguridad

### Headers de Seguridad (Ya Configurados)

El archivo `render.yaml` incluye:
```yaml
headers:
  - path: /*
    name: X-Frame-Options
    value: SAMEORIGIN
  - path: /*
    name: X-Content-Type-Options
    value: nosniff
  - path: /*
    name: Referrer-Policy
    value: strict-origin-when-cross-origin
```

### Configuración Adicional (Opcional)

Puedes agregar más headers en Render Dashboard → Settings → Headers:
```
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'
Permissions-Policy: geolocation=(), microphone=(), camera=()
```

## 📝 Checklist de Deployment

### Pre-Deployment
- [ ] Backend desplegado y funcionando
- [ ] Variables de entorno preparadas
- [ ] Build local exitoso (`npm run build`)
- [ ] Tests pasando (`npm run lint`)
- [ ] Código en rama `master` actualizado

### Durante Deployment
- [ ] Static Site creado en Render
- [ ] Root Directory configurado: `frontend`
- [ ] Build Command: `npm install && npm run build`
- [ ] Publish Directory: `dist`
- [ ] Variables `VITE_API_URL` y `VITE_WS_URL` configuradas
- [ ] Build completado exitosamente

### Post-Deployment
- [ ] Sitio accesible en URL de Render
- [ ] Sin errores en consola del navegador
- [ ] Routing de SPA funcionando
- [ ] Llamadas API funcionando sin CORS errors
- [ ] WebSocket conectando correctamente
- [ ] Backend CORS actualizado con URL del frontend
- [ ] Performance Lighthouse > 80
- [ ] Test en móvil y desktop

### Opcional
- [ ] Custom domain configurado
- [ ] Pull Request Previews habilitados
- [ ] Headers de seguridad verificados
- [ ] Monitoreo configurado

## 🎉 Deployment Completado

Una vez que todos los checks estén ✅, tu aplicación estará completamente funcional en producción:

```
Frontend: https://sw1-frontend.onrender.com
Backend:  https://sw1-backend.onrender.com
```

## 📚 Recursos Adicionales

- [Render Static Sites Docs](https://docs.render.com/static-sites)
- [Vite Production Build](https://vitejs.dev/guide/build.html)
- [React Router on Render](https://docs.render.com/deploy-create-react-app#using-client-side-routing)
- [Environment Variables in Vite](https://vitejs.dev/guide/env-and-mode.html)

---

**¿Necesitas ayuda?** Revisa los logs en Render Dashboard o la consola del navegador (F12).

**Última actualización**: 2025-01-11
