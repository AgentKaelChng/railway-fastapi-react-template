# Documentation

This repo is a **Railway-first full-stack template** with a two-branch deployment model:

- `main` -> production
- `develop` -> staging

## Start here

- **First-time deploy on Railway:** [railway-quickstart.md](./railway-quickstart.md)
- **Full Railway deployment guide:** [deployment.md](./deployment.md)
- **Local development:** [development.md](./development.md)
- **Backend details:** [../backend/README.md](../backend/README.md)
- **Frontend details:** [../frontend/README.md](../frontend/README.md)

## Maintainer files

- **Agent/operator instructions:** [../AGENTS.md](../AGENTS.md)
- **Contribution policy:** [../CONTRIBUTING.md](../CONTRIBUTING.md)
- **Security policy:** [../SECURITY.md](../SECURITY.md)

## Recommended setup flow

1. Clone the repo into your own project/repository.
2. Create one Railway project with `Postgres`, `backend`, and `frontend` services.
3. Use `main` for production and `develop` for staging.
4. Run `./scripts/railway-bootstrap.sh` once per environment to wire variables and queue deploys.
5. Verify:
   - backend docs at `/docs`
   - backend health at `/api/v1/utils/health-check/`
   - frontend loads and can log in
