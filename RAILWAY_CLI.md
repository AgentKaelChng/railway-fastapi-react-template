# Railway CLI Deployment

This template supports Railway CLI as a first-class deployment path.

## Install

```bash
npm install -g @railway/cli
railway login
```

## Recommended model

Use separate Railway projects for:

- staging
- production

Or, if you strongly prefer, separate services/environments in a single Railway setup. Separate projects are usually cleaner.

## Link a local repo

Example for staging:

```bash
railway link
```

Then select the Railway project and environment/service you want.

## Backend deploy

Deploy backend from the repo root using the backend config file in Railway or the service settings:

```bash
railway up --service backend
```

## Frontend deploy

```bash
railway up --service frontend
```

## Suggested workflow

### Staging from `develop`

```bash
git checkout develop
railway environment staging
railway up --service backend
railway up --service frontend
```

### Production from `main`

```bash
git checkout main
railway environment production
railway up --service backend
railway up --service frontend
```

## Variables

Use the matching example files as references:

- staging: `.env.railway.staging.example`
- production: `.env.railway.production.example`

## Notes

- `VITE_API_URL` is baked at build time, so frontend deploys must rebuild when backend domain changes.
- Backend startup will run migrations and seed the first admin user.
- Keep staging and production secrets separate.
