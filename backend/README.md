# Backend

FastAPI backend for the Railway-first starter.

## Stack

- FastAPI
- SQLModel
- Alembic
- PostgreSQL
- Pydantic settings

## Local setup

```bash
cd backend
uv sync
source .venv/bin/activate
```

Run the app locally:

```bash
fastapi run --reload app/main.py
```

## Environment model

The backend supports two database configuration styles:

### Preferred for Railway

```env
DATABASE_URL=postgresql://...
```

### Fallback for local/manual setups

```env
POSTGRES_SERVER=localhost
POSTGRES_PORT=5432
POSTGRES_DB=app
POSTGRES_USER=postgres
POSTGRES_PASSWORD=...
```

If `DATABASE_URL` is present, it wins.

## Startup behavior in production

The backend container startup script does this:

1. wait for database readiness
2. run migrations
3. seed the initial admin user
4. launch Uvicorn on `$PORT`

That makes Railway deployment straightforward.

## Common commands

Run migrations:

```bash
alembic upgrade head
```

Create a migration:

```bash
alembic revision --autogenerate -m "describe your change"
```

Run tests:

```bash
bash scripts/test.sh
```

## Important env vars

- `ENVIRONMENT`
- `PROJECT_NAME`
- `SECRET_KEY`
- `FIRST_SUPERUSER`
- `FIRST_SUPERUSER_PASSWORD`
- `FRONTEND_HOST`
- `BACKEND_CORS_ORIGINS`
- `DATABASE_URL`
- optional SMTP / Sentry settings
