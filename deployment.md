# Deployment on Railway

This starter is designed for Railway, not for self-hosted Docker + Traefik.

## Services

Create three Railway services in one project:

1. **Postgres** — Railway PostgreSQL
2. **backend** — deploy from `backend/Dockerfile`
3. **frontend** — deploy from `frontend/Dockerfile`

## Backend variables

Set these on the backend service:

- `ENVIRONMENT=production`
- `PROJECT_NAME=Your App Name`
- `SECRET_KEY=<generated secret>`
- `FIRST_SUPERUSER=<your email>`
- `FIRST_SUPERUSER_PASSWORD=<generated password>`
- `DATABASE_URL=${{Postgres.DATABASE_URL}}`
- `FRONTEND_HOST=https://<your-frontend-domain>`
- `BACKEND_CORS_ORIGINS=["https://<your-frontend-domain>"]`
- optional SMTP / Sentry variables

The backend container waits for the database, runs migrations, seeds the initial admin user, and then starts Uvicorn on Railway's `$PORT`.

## Frontend variables

Set these on the frontend service:

- `VITE_API_URL=https://<your-backend-domain>`

Because Vite bakes env vars at build time, redeploy frontend after changing `VITE_API_URL`.

## Local development

Use `compose.yml` and `compose.override.yml` for local development only. Production is Railway-first.

## Notes

- No Traefik required
- No Adminer in production
- No wildcard subdomains required
- Prefer Railway Postgres via `DATABASE_URL`
