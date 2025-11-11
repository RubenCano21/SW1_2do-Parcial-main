# Variables de Entorno para Render

## Backend (uml-diagram-backend)
Configura estas variables en el panel de Render para el backend:

### URLs y CORS (REQUERIDAS PARA RESOLVER ERRORES CORS)
- `FRONTEND_URL` = `https://sw1-2do-parcial-main-1.onrender.com`
- `CORS_ORIGIN` = `https://sw1-2do-parcial-main-1.onrender.com`

### API Keys para funciones de IA (OPCIONALES - Sin estas, las funciones de IA usan fallbacks)
- `GROQ_API_KEY` = `[TU_GROQ_API_KEY]`
- `GEMINI_API_KEY` = `[TU_GEMINI_API_KEY]`

## Frontend
Configura en el panel de Render para el frontend:
- `VITE_API_URL` = `https://sw1-2do-parcial-main.onrender.com`

## Pasos para configurar:

### URGENTE - Para resolver CORS:
1. Ve al dashboard de Render
2. Selecciona el servicio backend "uml-diagram-backend" 
3. Ve a la pestaña "Environment"
4. **Agrega FRONTEND_URL y CORS_ORIGIN** (esto resuelve los errores CORS)
5. Guarda y espera el redeploy automático

### Para el frontend:
1. Selecciona el servicio frontend
2. Ve a la pestaña "Environment"  
3. **Agrega VITE_API_URL**
4. Guarda y espera el redeploy automático

### Opcional - Para funciones de IA completas:
- Agrega las API keys si quieres funcionalidad completa de IA
- Sin las API keys, las funciones de IA funcionarán con análisis básico

## Estado Actual:
- ✅ Backend desplegado y funcionando
- ✅ Frontend desplegado
- ❌ CORS bloqueando conexiones (necesita FRONTEND_URL configurado)
- ⚠️ Funciones de IA usando fallbacks (necesita GROQ_API_KEY para funcionalidad completa)

## Verificación
Después de configurar las variables de CORS:
- ✅ No habrá errores "Access to XMLHttpRequest blocked by CORS policy"  
- ✅ Los WebSockets se conectarán correctamente
- ✅ Las APIs funcionarán entre frontend y backend