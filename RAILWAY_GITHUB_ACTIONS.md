# Railway Deployment via GitHub Actions

This template includes two workflow examples:

- `.github/workflows/deploy-staging.yml`
- `.github/workflows/deploy-production.yml`

## Branch mapping

- `develop` → staging deploy
- `main` → production deploy

## Required secrets

### Shared

- `RAILWAY_TOKEN`

### Staging

- `RAILWAY_PROJECT_ID_STAGING`
- `RAILWAY_ENVIRONMENT_ID_STAGING`
- `RAILWAY_BACKEND_SERVICE_ID_STAGING`
- `RAILWAY_FRONTEND_SERVICE_ID_STAGING`

### Production

- `RAILWAY_PROJECT_ID_PRODUCTION`
- `RAILWAY_ENVIRONMENT_ID_PRODUCTION`
- `RAILWAY_BACKEND_SERVICE_ID_PRODUCTION`
- `RAILWAY_FRONTEND_SERVICE_ID_PRODUCTION`

## How it works

Each workflow:

1. checks out the repo
2. installs the Railway CLI
3. deploys the backend service
4. deploys the frontend service

## Recommendation

Start with manual Railway UI or CLI deploys first.

Once staging and production service IDs are verified, enable GitHub Actions deployment.

Automation is useful. Blind automation is how people create very elegant outages.
