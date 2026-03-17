# Railway UI Deployment

This template supports manual setup through the Railway web UI.

## Recommended environment strategy

Use separate Railway projects for:

- staging
- production

Map them to branches like this:

- `develop` → staging
- `main` → production

## Create services

In each Railway project, create:

1. Postgres
2. backend
3. frontend

## Configure backend

Set:

- source Dockerfile: `backend/Dockerfile`
- variables from the matching example env file
  - staging: `.env.railway.staging.example`
  - production: `.env.railway.production.example`

## Configure frontend

Set:

- source Dockerfile: `frontend/Dockerfile`
- `VITE_API_URL` to the correct backend URL

## Recommended domains

### Staging
- `staging-app.example.com`
- `staging-api.example.com`

### Production
- `app.example.com`
- `api.example.com`

## Verify after deploy

- frontend loads
- backend docs load at `/docs`
- login works
- staging points to staging backend, not production
- production points to production backend, not staging
