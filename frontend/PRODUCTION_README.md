# Frontend - Guía de Producción

## 📋 Descripción
Frontend de la aplicación de diagramas UML colaborativos, construido con React + Vite + TypeScript.

## 🏗️ Stack Tecnológico
- **Framework**: React 19.1.1
- **Build Tool**: Vite 7.1.2
- **Language**: TypeScript 5.8.3
- **UI Library**: Lucide React (iconos)
- **Form Management**: React Hook Form + Zod
- **HTTP Client**: Axios
- **Real-time**: Socket.IO Client
- **Diagramming**: AntV X6
- **Styling**: Tailwind CSS

## 🚀 Deployment en Render

### Opción 1: Static Site (Recomendado - Gratis)

1. **Crear Static Site en Render**:
   - Ve a [Render Dashboard](https://dashboard.render.com/)
   - Click en "New +" → "Static Site"
   - Conecta tu repositorio: `RubenCano21/SW1_2do-Parcial-main`
   - Selecciona la rama: `master`

2. **Configuración del Static Site**:
   ```yaml
   Name: sw1-frontend
   Branch: master
   Root Directory: frontend
   Build Command: npm install && npm run build
   Publish Directory: dist
   ```

3. **Variables de Entorno**:
   ```bash
   VITE_API_URL=https://sw1-backend.onrender.com
   VITE_WS_URL=https://sw1-backend.onrender.com
   ```

4. **Deploy**:
   - Click en "Create Static Site"
   - Render construirá y desplegará automáticamente

### Opción 2: Usando Blueprint (render.yaml)

Si ya usaste Blueprint para el backend, puedes agregar el frontend al mismo archivo `render.yaml` en la raíz del proyecto, o usar el archivo `frontend/render.yaml` específico para el frontend.

## 🔧 Configuración de Producción

### Variables de Entorno

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `VITE_API_URL` | URL del backend en producción | `https://sw1-backend.onrender.com` |
| `VITE_WS_URL` | URL de WebSocket (normalmente igual al API) | `https://sw1-backend.onrender.com` |

### Headers de Seguridad

El archivo `render.yaml` incluye headers de seguridad:
- `X-Frame-Options: SAMEORIGIN`
- `X-Content-Type-Options: nosniff`
- `Referrer-Policy: strict-origin-when-cross-origin`

### SPA Routing

Configurado en `render.yaml` para que todas las rutas redirijan a `index.html`, permitiendo el routing del lado del cliente.

## 🏃‍♂️ Scripts Disponibles

```bash
# Desarrollo local
npm run dev

# Build de producción
npm run build

# Preview del build
npm run preview

# Linting
npm run lint

# Servir en producción (usado por Render)
npm run start
```

## 🔍 Verificación Post-Deployment

### 1. Verificar Build Exitoso
```bash
# En tu máquina local
cd frontend
npm run build

# Debería crear el directorio dist/ sin errores
```

### 2. Test de Conexión al Backend
Abre el navegador en tu URL de Render y verifica:
- La aplicación carga correctamente
- No hay errores 404 en las rutas
- La conexión WebSocket se establece
- Las llamadas API funcionan

### 3. Verificar en Developer Tools
```javascript
// En la consola del navegador
console.log(import.meta.env.VITE_API_URL)
// Debería mostrar la URL de producción del backend
```

## 🐛 Troubleshooting

### Problema: 404 en Rutas de React Router

**Solución**: Asegúrate de que el archivo `render.yaml` tiene la configuración de rewrite:
```yaml
routes:
  - type: rewrite
    source: /*
    destination: /index.html
```

### Problema: CORS Errors

**Solución**: Verifica que el backend tenga configurado correctamente el CORS:
```typescript
// backend/src/main.ts
app.enableCors({
  origin: ['https://sw1-frontend.onrender.com'],
  credentials: true,
});
```

### Problema: Variables de Entorno No Funcionan

**Síntomas**: `import.meta.env.VITE_API_URL` es `undefined`

**Soluciones**:
1. Las variables DEBEN empezar con `VITE_`
2. Configúralas en Render Dashboard → Environment
3. Reconstruye la aplicación después de cambiar variables

### Problema: WebSocket No Conecta

**Solución**:
1. Verifica que `VITE_WS_URL` esté configurado
2. Asegúrate de usar `https://` (no `http://`) en producción
3. Verifica que el backend tenga CORS configurado para WebSockets

### Problema: Build Falla en Render

**Errores Comunes**:
```bash
# Error: Out of memory
# Solución: Usa el plan de pago de Render o reduce el tamaño del bundle

# Error: TypeScript errors
# Solución: Ejecuta npm run build localmente y corrige errores
npm run build
```

## 📦 Optimización de Build

### Reducir Tamaño del Bundle

1. **Lazy Loading de Componentes**:
```typescript
// En vez de:
import { HeavyComponent } from './HeavyComponent'

// Usa:
const HeavyComponent = lazy(() => import('./HeavyComponent'))
```

2. **Análisis del Bundle**:
```bash
npm install --save-dev rollup-plugin-visualizer
```

Agrega a `vite.config.ts`:
```typescript
import { visualizer } from 'rollup-plugin-visualizer'

export default defineConfig({
  plugins: [
    react(),
    visualizer({ open: true })
  ]
})
```

### Configuración de Cache

Render automáticamente cachea `node_modules` entre builds, pero puedes optimizar:
```yaml
# En render.yaml
buildCommand: |
  if [ ! -d "node_modules" ]; then
    npm ci
  fi
  npm run build
```

## 🔐 Seguridad

### Headers de Seguridad

Ya configurados en `render.yaml`, pero puedes agregar más:
```yaml
headers:
  - path: /*
    name: Content-Security-Policy
    value: default-src 'self'; script-src 'self' 'unsafe-inline'
```

### Variables Sensibles

⚠️ **NUNCA** commitees archivos `.env` con información sensible.
✅ Usa siempre las variables de entorno de Render.

## 🔄 CI/CD Automático

Render detecta automáticamente pushes a la rama `master` y redespliega:

```bash
# Workflow típico
git add .
git commit -m "feat: nueva funcionalidad"
git push origin master

# Render detecta el push y redespliega automáticamente
```

## 📊 Monitoreo

### Logs en Render

1. Ve a tu servicio en Render Dashboard
2. Click en "Logs" en el menú lateral
3. Verás los logs del build y del servidor

### Performance

Usa Lighthouse en Chrome DevTools:
1. F12 → Lighthouse tab
2. Click "Generate report"
3. Revisa Performance, Accessibility, Best Practices, SEO

## 🌐 Dominio Personalizado

1. Ve a tu servicio en Render
2. Settings → Custom Domain
3. Agrega tu dominio (ej: `app.tudominio.com`)
4. Configura el DNS según las instrucciones de Render

## 📝 Checklist de Deployment

- [ ] Build local exitoso (`npm run build`)
- [ ] Variables de entorno configuradas en Render
- [ ] Backend desplegado y funcionando
- [ ] CORS configurado en backend para frontend URL
- [ ] WebSocket probado en producción
- [ ] Routing de SPA configurado
- [ ] Headers de seguridad agregados
- [ ] SSL/HTTPS funcionando
- [ ] Test en diferentes navegadores
- [ ] Performance optimizado (Lighthouse > 80)

## 🆘 Soporte

Si encuentras problemas:
1. Revisa los logs en Render Dashboard
2. Verifica la consola del navegador (F12)
3. Comprueba la pestaña Network para errores API
4. Consulta [Render Docs](https://docs.render.com/static-sites)

---

**Última actualización**: 2025-01-11
**Versión**: 1.0.0
