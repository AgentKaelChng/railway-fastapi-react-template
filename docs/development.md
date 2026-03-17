# Development

This repo is Railway-first for production, but Docker Compose is still useful for local development.

## Local stack

Start the local stack:

```bash
docker compose watch
```

Local URLs:

- frontend: <http://localhost:5173>
- backend: <http://localhost:8000>
- Swagger UI: <http://localhost:8000/docs>
- ReDoc: <http://localhost:8000/redoc>
- Adminer: <http://localhost:8080>
- MailCatcher: <http://localhost:1080>

## Logs

View all logs:

```bash
docker compose logs
```

View a single service:

```bash
docker compose logs backend
```

## Working locally without Docker

The app is also friendly to a mixed workflow.

### Backend

```bash
cd backend
uv sync
source .venv/bin/activate
fastapi run --reload app/main.py
```

### Frontend

```bash
cd frontend
bun install
bun run dev
```

## MailCatcher

MailCatcher is included for local email testing.

- SMTP: `localhost:1025`
- UI: <http://localhost:1080>

That lets you test password recovery and account emails without touching a real provider.

## Environment files

Create local env files from the examples:

```bash
cp .env.example .env
cp frontend/.env.example frontend/.env
```

These are intentionally ignored by git.

## Migrations

When you change database models:

```bash
cd backend
source .venv/bin/activate
alembic revision --autogenerate -m "describe your change"
alembic upgrade head
```

Commit the generated migration files.

## OpenAPI client regeneration

When backend API schemas change:

```bash
bash ./scripts/generate-client.sh
```

Commit the generated client changes in `frontend/src/client`.

## Backend tests

Run backend tests:

```bash
bash ./scripts/test.sh
```

Or against a running stack:

```bash
docker compose exec backend bash scripts/tests-start.sh
```

## Frontend tests

Run Playwright tests after the stack is up:

```bash
bunx playwright test
```

UI mode:

```bash
bunx playwright test --ui
```

## Production note

The local Docker stack is for development convenience only.

Production is expected to run on Railway with:

- Railway Postgres
- separate backend service
- separate frontend service
