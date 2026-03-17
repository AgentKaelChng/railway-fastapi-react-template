# Railway Quickstart

This is the fastest path to a working deploy.

## Recommended repo model

- `main` -> production
- `develop` -> staging

## Create services

In one Railway project, create:

1. **Postgres**
2. **backend** (from `backend/Dockerfile`)
3. **frontend** (from `frontend/Dockerfile`)

## Fastest repeatable path: bootstrap script

After creating the Railway project/services, use:

```bash
./scripts/railway-bootstrap.sh \
  --environment production \
  --project-name "Your App Name" \
  --frontend-domain app.example.com \
  --backend-domain api.example.com \
  --admin-email you@example.com \
  --admin-password 'replace-with-a-strong-password' \
  --secret-key 'replace-with-a-long-random-secret'
```

For staging, run the same script from the `develop` branch:

```bash
git checkout develop
./scripts/railway-bootstrap.sh \
  --environment staging \
  --project-name "Your App Name (Staging)" \
  --frontend-domain staging-app.example.com \
  --backend-domain staging-api.example.com \
  --admin-email you@example.com \
  --admin-password 'replace-with-a-strong-password' \
  --secret-key 'replace-with-a-long-random-secret'
```

The script:

- wires backend/frontend variables for the chosen environment
- creates `staging` by duplicating `production` if needed
- deploys backend/frontend using the correct service-specific Railway config

What it does **not** do for you:

- create the Postgres/backend/frontend services
- assign custom domains automatically
- guess your secrets for you

## Backend variables

Copy-paste these into the backend service and replace the placeholders:

```env
ENVIRONMENT=production
PROJECT_NAME=Your App Name
SECRET_KEY=replace-with-a-long-random-secret
FIRST_SUPERUSER=you@example.com
FIRST_SUPERUSER_PASSWORD=replace-with-a-strong-password
DATABASE_URL=${{Postgres.DATABASE_URL}}
FRONTEND_HOST=https://app.example.com
BACKEND_CORS_ORIGINS=["https://app.example.com"]
```

Optional:

```env
WEB_CONCURRENCY=2
SMTP_HOST=
SMTP_USER=
SMTP_PASSWORD=
EMAILS_FROM_EMAIL=
SMTP_PORT=587
SMTP_TLS=true
SMTP_SSL=false
SENTRY_DSN=
```

## Frontend variables

Copy-paste this into the frontend service:

```env
VITE_API_URL=https://api.example.com
```

## Recommended domains

- frontend: `app.example.com`
- backend: `api.example.com`

Then make sure the variables line up:

- `FRONTEND_HOST=https://app.example.com`
- `BACKEND_CORS_ORIGINS=["https://app.example.com"]`
- `VITE_API_URL=https://api.example.com`

## What the backend does on deploy

On startup it will:

1. wait for the database
2. run migrations
3. seed the first admin user
4. start the API on Railway's `$PORT`

## Sanity checklist after deploy

- frontend loads
- backend docs load at `/docs`
- login works
- backend logs show migrations completed successfully
- password reset links point to the frontend domain, not localhost
