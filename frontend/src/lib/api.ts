// src/lib/api.ts
import axios from "axios";

// Construcción correcta de la baseURL para producción y desarrollo
const getBaseURL = () => {
  const apiUrl = import.meta.env.VITE_API_URL;
  if (apiUrl) {
    // En producción: https://backend.onrender.com + /api
    return `${apiUrl}/api`;
  }
  // En desarrollo local: fallback al proxy de Vite
  return "/api";
};

export const api = axios.create({
  baseURL: getBaseURL(),
  withCredentials: false,
});

export type ApiError = { message?: string; error?: string };

export const getErrorMessage = (e: unknown) => {
  if (axios.isAxiosError(e)) {
    return (
      (e.response?.data as ApiError)?.message ||
      (e.response?.data as ApiError)?.error ||
      e.message
    );
  }
  return "Error inesperado";
};
