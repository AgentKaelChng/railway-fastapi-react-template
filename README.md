# Railway FastAPI React Template

A Railway-first full-stack starter based on the excellent FastAPI full-stack template, but cleaned up for managed hosting instead of self-hosted Docker + Traefik.

## Stack

- FastAPI
- SQLModel + Alembic
- PostgreSQL
- React + Vite + TypeScript
- Tailwind CSS + shadcn/ui
- OpenAPI-generated frontend client

## What changed from the original template

- Removed Traefik-first production assumptions
- Removed Adminer from the production story
- Switched backend startup to Railway-compatible `$PORT` binding
- Added `DATABASE_URL` support for Railway Postgres
- Simplified frontend deployment around a direct `VITE_API_URL`
- Rewrote deployment docs for Railway

## Deploy on Railway

Create a Railway project with:

- Postgres service
- backend service using `backend/Dockerfile`
- frontend service using `frontend/Dockerfile`

See [deployment.md](./deployment.md) for exact variables.

## Local development

The original Docker Compose workflow is still useful for local development.

```bash
docker compose watch
```

Frontend local dev:

```bash
cd frontend
bun install
bun run dev
```

Backend local dev:

```bash
cd backend
uv sync
source .venv/bin/activate
fastapi run --reload app/main.py
```

## Credit

This project is adapted from `fastapi/full-stack-fastapi-template`. The original template is excellent; this repo simply changes the deployment opinion from self-hosted to Railway-first.
