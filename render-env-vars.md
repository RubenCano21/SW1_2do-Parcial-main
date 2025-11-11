# Variables de Entorno para Render

## Backend (uml-diagram-backend)
Configura estas variables en el panel de Render para el backend:

### URLs y CORS
- `FRONTEND_URL` = `https://sw1-2do-parcial-main-1.onrender.com`
- `CORS_ORIGIN` = `https://sw1-2do-parcial-main-1.onrender.com`

### API Keys (necesarias para las funciones de IA)
- `GROQ_API_KEY` = `[TU_GROQ_API_KEY]`
- `GEMINI_API_KEY` = `[TU_GEMINI_API_KEY]`

## Frontend
No necesita variables adicionales ya que usará automáticamente:
- `VITE_API_URL` = `https://sw1-2do-parcial-main.onrender.com`

## Pasos para configurar:

1. Ve al dashboard de Render
2. Selecciona el servicio backend "uml-diagram-backend" 
3. Ve a la pestaña "Environment"
4. Agrega las variables FRONTEND_URL y CORS_ORIGIN
5. Agrega las API keys si las tienes
6. Guarda y redeploy

## Verificación
Después de configurar, verifica que:
- ✅ El frontend puede conectarse al backend
- ✅ Los WebSockets funcionan
- ✅ No hay errores de CORS en la consola