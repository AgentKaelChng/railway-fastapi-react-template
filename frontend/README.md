# Frontend

React + Vite frontend for the Railway-first starter.

## Stack

- React
- Vite
- TypeScript
- TanStack Query
- TanStack Router
- Tailwind CSS
- shadcn/ui

## Local setup

```bash
cd frontend
bun install
bun run dev
```

Open <http://localhost:5173>.

## API base URL

The frontend uses `VITE_API_URL`.

## Auth model

The frontend uses backend-issued **HttpOnly auth cookies** by default.

That means:
- no auth token is stored in `localStorage`
- requests are sent with credentials enabled
- a readable CSRF cookie is mirrored into the `X-CSRF-Token` header for state-changing requests

If you change auth behavior, update both the backend cookie settings and the frontend request/auth helpers together.

Example:

```env
VITE_API_URL=https://api.example.com
```

For local work, copy the example file:

```bash
cp .env.example .env
```

## Regenerate the API client

Whenever the backend OpenAPI schema changes:

```bash
bash ../scripts/generate-client.sh
```

Commit the generated changes under `src/client`.

## Tests

Run Playwright tests once the backend stack is up:

```bash
bunx playwright test
```

UI mode:

```bash
bunx playwright test --ui
```

## Deployment note

The frontend Docker build bakes `VITE_API_URL` at build time.

If you change the backend domain in Railway, rebuild/redeploy the frontend service.
