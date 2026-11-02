# Frontend

React + Vite + TypeScript, styled with Tailwind CSS.

## Run

```bash
cp .env.example .env     # Windows: copy .env.example .env
npm install
npm run dev              # http://localhost:5173
npm run build            # production build into dist/
```

## Folders (`src/`)

| Folder | Purpose |
|--------|---------|
| `components/common`, `layout`, `ui` | Reusable components |
| `pages/*` | One folder per feature area |
| `services` | Axios instance and API calls |
| `routes` | React Router configuration |
| `contexts` | React contexts (for example auth) |
| `hooks`, `types`, `utils` | Shared hooks, TypeScript types, helpers |

The backend URL is read from `VITE_API_BASE_URL`.
