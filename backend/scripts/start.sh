#! /usr/bin/env bash
set -euo pipefail

python app/backend_pre_start.py

if [ "${RUN_MIGRATIONS_ON_START:-0}" = "1" ]; then
  alembic upgrade head
  python app/initial_data.py
fi

exec uvicorn app.main:app --host 0.0.0.0 --port "${PORT:-8000}" --workers "${WEB_CONCURRENCY:-2}"
