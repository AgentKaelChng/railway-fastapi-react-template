# Deployment on Railway

This starter is designed for Railway, not for self-hosted Docker + Traefik.

## Branch and environment model

- `develop` → **staging**
- `main` → **production**

Read [BRANCHING.md](./BRANCHING.md) for the short version.

## Deployment interfaces

This template is intentionally compatible with three deployment control planes:

1. **Railway UI**
2. **Railway CLI**
3. **GitHub Actions**

Use whichever fits the team and the stage of the project.

## Target layout

Recommended default: **one Railway project per environment**.

### Staging project
- Postgres
- backend
- frontend

### Production project
- Postgres
- backend
- frontend

This is cleaner than trying to be overly clever with one project doing everything.

## Service setup

If you just want the shortest working path, use [RAILWAY_QUICKSTART.md](./RAILWAY_QUICKSTART.md) first and come back here for the fuller reference.

### Postgres

- Add a Railway PostgreSQL service.
- Keep the generated credentials private.
- Use Railway's provided `DATABASE_URL` in the backend service.
- Keep staging and production databases separate.

### Backend service

Use `backend/Dockerfile`.

The backend startup sequence is:

1. wait for Postgres
2. run `alembic upgrade head`
3. seed the initial admin user
4. start Uvicorn on `$PORT`

#### Staging backend variables

- `ENVIRONMENT=staging`
- `PROJECT_NAME=Your App Name (Staging)`
- `SECRET_KEY=<generated secret>`
- `FIRST_SUPERUSER=<your email>`
- `FIRST_SUPERUSER_PASSWORD=<generated password>`
- `DATABASE_URL=${{Postgres.DATABASE_URL}}`
- `FRONTEND_HOST=https://staging-app.example.com`
- `BACKEND_CORS_ORIGINS=["https://staging-app.example.com"]`
- `WEB_CONCURRENCY=1`

#### Production backend variables

- `ENVIRONMENT=production`
- `PROJECT_NAME=Your App Name`
- `SECRET_KEY=<generated secret>`
- `FIRST_SUPERUSER=<your email>`
- `FIRST_SUPERUSER_PASSWORD=<generated password>`
- `DATABASE_URL=${{Postgres.DATABASE_URL}}`
- `FRONTEND_HOST=https://app.example.com`
- `BACKEND_CORS_ORIGINS=["https://app.example.com"]`
- `WEB_CONCURRENCY=2`

#### Optional backend variables

- `SMTP_HOST`
- `SMTP_USER`
- `SMTP_PASSWORD`
- `EMAILS_FROM_EMAIL`
- `SMTP_PORT`
- `SMTP_TLS`
- `SMTP_SSL`
- `SENTRY_DSN`

### Frontend service

Use `frontend/Dockerfile`.

#### Staging frontend variables

- `VITE_API_URL=https://staging-api.example.com`

#### Production frontend variables

- `VITE_API_URL=https://api.example.com`

Because Vite bakes variables at build time, changing `VITE_API_URL` requires a rebuild/redeploy.

## Recommended custom domains

### Staging

- frontend: `staging-app.example.com`
- backend: `staging-api.example.com`

### Production

- frontend: `app.example.com`
- backend: `api.example.com`

## Railway UI / CLI / Actions references

- UI guide: [RAILWAY_UI.md](./RAILWAY_UI.md)
- CLI guide: [RAILWAY_CLI.md](./RAILWAY_CLI.md)
- GitHub Actions guide: [RAILWAY_GITHUB_ACTIONS.md](./RAILWAY_GITHUB_ACTIONS.md)

## Secrets

Do not deploy with the defaults from any example env file.

Generate strong values for:

- `SECRET_KEY`
- `FIRST_SUPERUSER_PASSWORD`

If you are not using `DATABASE_URL`, also generate a strong `POSTGRES_PASSWORD` for local or non-Railway environments.

Keep staging and production secrets separate.

## Health and logs

After deploy, verify:

- backend is reachable
- Swagger UI loads at `/docs`
- frontend can log in against the matching backend
- migrations ran successfully in backend logs
- staging points to staging services only
- production points to production services only

## Common failure modes

### Frontend can’t reach backend

Usually one of these:

- wrong `VITE_API_URL`
- backend has no public domain yet
- CORS missing the frontend domain
- staging and production URLs got crossed

### Password reset links point to localhost or wrong environment

`FRONTEND_HOST` is wrong.

### Backend fails on startup

Check backend logs for:

- invalid `DATABASE_URL`
- migration failure
- bad secrets / invalid env values

## Promotion flow

Recommended release flow:

1. feature branch
2. merge to `develop`
3. staging deploy
4. verify
5. merge/promote to `main`
6. production deploy

## Local development

Use `compose.yml` and `compose.override.yml` only for local development.

Hosted environments on Railway do **not** require:

- Traefik
- Adminer as production infra
- wildcard subdomains
- a self-hosted Docker host
