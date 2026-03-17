# AGENTS.md

This file is for coding agents and maintainers working inside this repository.

## Project intent

This repo is a **Railway-first FastAPI + React starter**.

It is not a generic upstream mirror and it is not optimized for self-hosted Docker + Traefik production setups. The point is to make Railway deployment, upkeep, and branch-based staging/production usage straightforward.

## Deployment model

- `main` -> production
- `develop` -> staging

Expected Railway layout inside one project:

1. `Postgres`
2. `backend`
3. `frontend`

## First places to read

1. `README.md`
2. `docs/README.md`
3. `docs/railway-quickstart.md`
4. `docs/deployment.md`
5. `docs/development.md`

Then inspect:

- `backend/README.md`
- `frontend/README.md`
- `scripts/railway-bootstrap.sh`
- `railway.backend.json`
- `railway.frontend.json`

## Setup expectations

For a real Railway deployment:

- create/link a Railway project
- create `Postgres`, `backend`, and `frontend` services
- use `./scripts/railway-bootstrap.sh` to wire vars per environment
- verify backend docs, backend health endpoint, and frontend load/login after deploy

Versioned examples:

- `.env.railway.production.example`
- `.env.railway.staging.example`
- `.env.example`
- `frontend/.env.example`

## Maintenance policy

This is a living public template, not a one-off dump.

Maintain it for:

- ease of use
- Railway deployment correctness
- staging/production branch clarity
- dependency upkeep
- docs matching reality

## PR policy

Default policy:

- accept dependency-update PRs
- do not accept outside feature/fix PRs unless explicitly requested by the maintainer

## Guardrails

- Do not reintroduce self-hosted production assumptions as the default deployment story.
- Do not let docs drift away from the actual working Railway flow.
- Prefer fewer, clearer docs over many scattered partial guides.
- If you change deployment behavior, update docs in the same change.
- If you change frontend/backend Railway behavior, validate both branch/environment expectations.

## When making changes

Prefer this order:

1. fix real deployment/runtime correctness
2. reduce setup friction
3. simplify maintenance/governance
4. improve docs and agent guidance
