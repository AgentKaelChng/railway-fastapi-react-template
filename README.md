# Railway FastAPI React Template

A Railway-first full-stack starter based on `fastapi/full-stack-fastapi-template`, cleaned up for managed hosting instead of self-hosted Docker + Traefik.

## Why this exists

The original FastAPI template is excellent, but its production story assumes:

- Docker Compose as the deploy primitive
- Traefik as the ingress layer
- self-hosted infrastructure and wildcard subdomains

That is the wrong default for Railway.

This repo keeps the good parts of the app scaffold and replaces the deployment opinion.

## Stack

- **Backend:** FastAPI, SQLModel, Alembic, PostgreSQL
- **Frontend:** React, Vite, TypeScript, Tailwind CSS, shadcn/ui
- **Auth:** JWT + password recovery flow
- **DX:** generated OpenAPI client, Playwright, GitHub Actions

## What changed from the original template

- Railway-first deployment docs
- backend startup binds to **`$PORT`**
- backend supports **`DATABASE_URL`** for Railway Postgres
- production story no longer depends on Traefik, Adminer, or wildcard subdomains
- `.env.example` files added and real `.env` files ignored
- local Docker Compose retained for development only

## Architecture

In Railway, create one project with:

1. **Postgres** service
2. **backend** service using `backend/Dockerfile`
3. **frontend** service using `frontend/Dockerfile`

The backend container:

- waits for Postgres
- runs Alembic migrations
- seeds the initial admin user
- starts Uvicorn on Railway's injected port

## Quick start

### 1) Clone and prepare env files

```bash
git clone git@github.com:AgentKaelChng/railway-fastapi-react-template.git
cd railway-fastapi-react-template
cp .env.example .env
cp frontend/.env.example frontend/.env
```

### 2) Local development with Docker Compose

```bash
docker compose watch
```

Local URLs:

- frontend: <http://localhost:5173>
- backend: <http://localhost:8000>
- Swagger UI: <http://localhost:8000/docs>
- MailCatcher: <http://localhost:1080>
- Adminer: <http://localhost:8080>

### 3) Local development without Docker

**Backend**

```bash
cd backend
uv sync
source .venv/bin/activate
fastapi run --reload app/main.py
```

**Frontend**

```bash
cd frontend
bun install
bun run dev
```

## Deploy on Railway

- Fastest path: [RAILWAY_QUICKSTART.md](./RAILWAY_QUICKSTART.md)
- Full guide: [deployment.md](./deployment.md)
- Bootstrap helper: [`scripts/railway-bootstrap.sh`](./scripts/railway-bootstrap.sh)

The bootstrap script wires environment variables consistently for either `production` or `staging` and can queue deploys for backend/frontend using the correct Railway config file for each service.

## Recommended next steps after deploy

- set custom domains for frontend and backend
- set `FRONTEND_HOST` and `BACKEND_CORS_ORIGINS` correctly
- rotate all default secrets
- configure SMTP if you want password recovery emails
- add Sentry if you want error monitoring

## Local dev vs production

- `compose.yml` and `compose.override.yml` are for **local development**
- Railway services are the **production** deployment model
- do not treat the Docker Compose topology as the production reference architecture

## Credit

This project is adapted from <https://github.com/fastapi/full-stack-fastapi-template>.

The original template is excellent. This fork simply changes the infrastructure opinion from self-hosted to Railway-first.
