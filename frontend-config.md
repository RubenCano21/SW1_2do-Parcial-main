# Frontend Configuration for Production

## Environment Variables for Frontend Service

Add this environment variable in Render for the frontend service:

```
VITE_API_URL=https://sw1-2do-parcial-main.onrender.com
```

## Automatic Configuration

The frontend is already configured to:
1. Use `VITE_API_URL` if set (production)
2. Fall back to `/api` proxy if not set (development)
3. Automatically append `/api` path to the backend URL

## Current URLs
- Frontend: https://sw1-2do-parcial-main-1.onrender.com  
- Backend: https://sw1-2do-parcial-main.onrender.com
- API Endpoints: https://sw1-2do-parcial-main.onrender.com/api/*
- WebSocket: https://sw1-2do-parcial-main.onrender.com/socket.io/

## Next Steps
1. Configure backend environment variables (see render-env-vars.md)
2. Add VITE_API_URL to frontend service
3. Both services will redeploy automatically
4. Test the connection