FROM python:3.14

ENV PYTHONUNBUFFERED=1

COPY --from=ghcr.io/astral-sh/uv:0.9.26 /uv /uvx /bin/
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

WORKDIR /app/
ENV PATH="/app/.venv/bin:$PATH"

COPY pyproject.toml uv.lock /app/
COPY ./backend/pyproject.toml ./backend/alembic.ini /app/backend/
COPY ./backend/scripts /app/backend/scripts
COPY ./backend/app /app/backend/app

RUN uv sync --frozen --package app

WORKDIR /app/backend/

CMD ["bash", "scripts/start.sh"]
