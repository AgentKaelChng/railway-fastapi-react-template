# Railway Quickstart

This is the fastest path to a working deploy.

## Branch and environment model

- `develop` → staging
- `main` → production

If this template becomes your standard app starter, keep that mapping consistent.

## Create services

For each environment, create a Railway project with:

1. **Postgres**
2. **backend** (from `backend/Dockerfile`)
3. **frontend** (from `frontend/Dockerfile`)

## Staging backend variables

```env
ENVIRONMENT=staging
PROJECT_NAME=Your App Name (Staging)
SECRET_KEY=replace-with-a-long-random-secret
FIRST_SUPERUSER=you@example.com
FIRST_SUPERUSER_PASSWORD=replace-with-a-strong-password
DATABASE_URL=${{Postgres.DATABASE_URL}}
FRONTEND_HOST=https://staging-app.example.com
BACKEND_CORS_ORIGINS=["https://staging-app.example.com"]
WEB_CONCURRENCY=1
```

## Staging frontend variables

```env
VITE_API_URL=https://staging-api.example.com
```

## Production backend variables

```env
ENVIRONMENT=production
PROJECT_NAME=Your App Name
SECRET_KEY=replace-with-a-long-random-secret
FIRST_SUPERUSER=you@example.com
FIRST_SUPERUSER_PASSWORD=replace-with-a-strong-password
DATABASE_URL=${{Postgres.DATABASE_URL}}
FRONTEND_HOST=https://app.example.com
BACKEND_CORS_ORIGINS=["https://app.example.com"]
WEB_CONCURRENCY=2
```

## Production frontend variables

```env
VITE_API_URL=https://api.example.com
```

## Optional variables

```env
SMTP_HOST=
SMTP_USER=
SMTP_PASSWORD=
EMAILS_FROM_EMAIL=
SMTP_PORT=587
SMTP_TLS=true
SMTP_SSL=false
SENTRY_DSN=
```

## Recommended domains

### Staging
- frontend: `staging-app.example.com`
- backend: `staging-api.example.com`

### Production
- frontend: `app.example.com`
- backend: `api.example.com`

## What the backend does on deploy

On startup it will:

1. wait for the database
2. run migrations
3. seed the first admin user
4. start the API on Railway's `$PORT`

## Deployment interfaces

This template is designed to be configurable through:

- Railway UI
- Railway CLI
- GitHub Actions

## Sanity checklist after deploy

- frontend loads
- backend docs load at `/docs`
- login works
- backend logs show migrations completed successfully
- password reset links point to the correct frontend domain
- staging does not point at production
- production does not point at staging
