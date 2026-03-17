# Branching and Environment Strategy

This template uses a simple two-environment default:

- `develop` → **staging**
- `main` → **production**

## Why

This keeps the release flow explicit:

1. feature work lands on feature branches
2. merge into `develop`
3. deploy and verify in staging
4. promote to `main`
5. deploy to production

## Recommended domains

### Staging

- frontend: `staging-app.example.com`
- backend: `staging-api.example.com`

### Production

- frontend: `app.example.com`
- backend: `api.example.com`

## Environment files

Use these example files as starting points:

- `.env.railway.staging.example`
- `.env.railway.production.example`

## Deployment control planes

This template is designed to work with:

- Railway UI
- Railway CLI
- GitHub Actions

You do not have to use all three, but the repo should be compatible with each.
