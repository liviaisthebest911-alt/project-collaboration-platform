import axios from "axios";

// Shared Axios instance. All API calls in src/services should use it.
export const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: { "Content-Type": "application/json" },
});

// TODO (Member 4): attach the JWT from the auth context as "Authorization: Bearer <token>".
