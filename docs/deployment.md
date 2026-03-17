# Deployment on Railway

This starter is designed for Railway, not for self-hosted Docker + Traefik.

## Target layout

Create a single Railway project with these services:

1. **Postgres**
2. **backend**
3. **frontend**

## Service setup

If you just want the shortest working path, use [railway-quickstart.md](./railway-quickstart.md) first and come back here for the fuller reference.

There is also a helper script at [`scripts/railway-bootstrap.sh`](../scripts/railway-bootstrap.sh) that standardizes variable wiring and deploys for either `production` or `staging`.

### Postgres

- Add a Railway PostgreSQL service.
- Keep the generated credentials private.
- You will use Railway's provided `DATABASE_URL` in the backend service.

### Backend service

Use `backend/Dockerfile`.

The backend startup sequence is:

1. wait for Postgres
2. run `alembic upgrade head`
3. seed the initial admin user
4. start Uvicorn on `$PORT`

#### Required backend variables

Set these in Railway:

- `ENVIRONMENT=production`
- `PROJECT_NAME=Your App Name`
- `SECRET_KEY=<generated secret>`
- `FIRST_SUPERUSER=<your email>`
- `FIRST_SUPERUSER_PASSWORD=<generated password>`
- `DATABASE_URL=${{Postgres.DATABASE_URL}}`
- `FRONTEND_HOST=https://<your-frontend-domain>`
- `BACKEND_CORS_ORIGINS=["https://<your-frontend-domain>"]`

#### Optional backend variables

- `SMTP_HOST`
- `SMTP_USER`
- `SMTP_PASSWORD`
- `EMAILS_FROM_EMAIL`
- `SMTP_PORT`
- `SMTP_TLS`
- `SMTP_SSL`
- `SENTRY_DSN`
- `WEB_CONCURRENCY` (defaults to `2`)

### Frontend service

Use `frontend/Dockerfile`.

#### Required frontend variables

- `VITE_API_URL=https://<your-backend-domain>`

Because Vite bakes variables at build time, changing `VITE_API_URL` requires a rebuild/redeploy.

## Recommended Railway custom domains

Use separate domains or subdomains, for example:

### Production

- frontend: `app.example.com`
- backend: `api.example.com`

### Staging

- frontend: `staging-app.example.com`
- backend: `staging-api.example.com`

Then set the variables to match the chosen environment:

- `FRONTEND_HOST=https://<frontend-domain>`
- `BACKEND_CORS_ORIGINS=["https://<frontend-domain>"]`
- `VITE_API_URL=https://<backend-domain>`

## Secrets

Do not deploy with the defaults from `.env.example`.

Generate strong values for:

- `SECRET_KEY`
- `FIRST_SUPERUSER_PASSWORD`

If you are not using `DATABASE_URL`, also generate a strong `POSTGRES_PASSWORD` for local or non-Railway environments.

## Health and logs

After deploy, verify:

- backend root is reachable through Railway
- Swagger UI loads at `/docs`
- frontend can log in against the backend
- migrations ran successfully in backend logs

## Common failure modes

### Frontend can’t reach backend

Usually one of these:

- wrong `VITE_API_URL`
- backend has no public domain yet
- CORS missing the frontend domain

### Password reset links point to localhost

`FRONTEND_HOST` is wrong.

### Backend fails on startup

Check backend logs for:

- invalid `DATABASE_URL`
- migration failure
- bad secrets / invalid env values

## Local development

Use `compose.yml` and `compose.override.yml` only for local development.

Production on Railway does **not** require:

- Traefik
- Adminer
- wildcard subdomains
- a self-hosted Docker host

