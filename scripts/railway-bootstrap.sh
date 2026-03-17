#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<'EOF'
Bootstrap or update Railway environments for this template.

Required:
  --project-name NAME
  --frontend-domain DOMAIN      e.g. app.example.com
  --backend-domain DOMAIN       e.g. api.example.com
  --admin-email EMAIL
  --admin-password PASSWORD
  --secret-key KEY

Optional:
  --environment NAME            production|staging (default: production)
  --project-id ID               use existing Railway project instead of linked/current
  --workspace NAME_OR_ID        workspace for new project creation
  --project-slug NAME           if no linked/current project exists, create one with this name
  --backend-service NAME        default: backend
  --frontend-service NAME       default: frontend
  --skip-deploy                 only wire variables; do not deploy services
  --help

Notes:
  - Run `railway login` first.
  - This script wires variables for one environment at a time.
  - It expects the Railway project to already have Postgres, backend, and frontend services.
EOF
}

ENVIRONMENT="production"
BACKEND_SERVICE="backend"
FRONTEND_SERVICE="frontend"
PROJECT_ID=""
WORKSPACE=""
PROJECT_SLUG=""
PROJECT_NAME=""
FRONTEND_DOMAIN=""
BACKEND_DOMAIN=""
ADMIN_EMAIL=""
ADMIN_PASSWORD=""
SECRET_KEY=""
SKIP_DEPLOY=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --environment) ENVIRONMENT="$2"; shift 2 ;;
    --project-id) PROJECT_ID="$2"; shift 2 ;;
    --workspace) WORKSPACE="$2"; shift 2 ;;
    --project-slug) PROJECT_SLUG="$2"; shift 2 ;;
    --project-name) PROJECT_NAME="$2"; shift 2 ;;
    --frontend-domain) FRONTEND_DOMAIN="$2"; shift 2 ;;
    --backend-domain) BACKEND_DOMAIN="$2"; shift 2 ;;
    --admin-email) ADMIN_EMAIL="$2"; shift 2 ;;
    --admin-password) ADMIN_PASSWORD="$2"; shift 2 ;;
    --secret-key) SECRET_KEY="$2"; shift 2 ;;
    --backend-service) BACKEND_SERVICE="$2"; shift 2 ;;
    --frontend-service) FRONTEND_SERVICE="$2"; shift 2 ;;
    --skip-deploy) SKIP_DEPLOY=1; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
done

[[ -n "$PROJECT_NAME" ]] || { echo "--project-name is required" >&2; exit 1; }
[[ -n "$FRONTEND_DOMAIN" ]] || { echo "--frontend-domain is required" >&2; exit 1; }
[[ -n "$BACKEND_DOMAIN" ]] || { echo "--backend-domain is required" >&2; exit 1; }
[[ -n "$ADMIN_EMAIL" ]] || { echo "--admin-email is required" >&2; exit 1; }
[[ -n "$ADMIN_PASSWORD" ]] || { echo "--admin-password is required" >&2; exit 1; }
[[ -n "$SECRET_KEY" ]] || { echo "--secret-key is required" >&2; exit 1; }
[[ "$ENVIRONMENT" == "production" || "$ENVIRONMENT" == "staging" ]] || {
  echo "--environment must be production or staging" >&2; exit 1;
}

if [[ -n "$PROJECT_ID" ]]; then
  railway link --project "$PROJECT_ID" >/dev/null
fi

if ! railway status --json >/dev/null 2>&1; then
  if [[ -z "$PROJECT_SLUG" ]]; then
    echo "No linked Railway project found. Provide --project-id or --project-slug." >&2
    exit 1
  fi
  if [[ -n "$WORKSPACE" ]]; then
    railway init --name "$PROJECT_SLUG" --workspace "$WORKSPACE" >/dev/null
  else
    railway init --name "$PROJECT_SLUG" >/dev/null
  fi
fi

if ! railway environment --json 2>/dev/null | grep -q '"name":"'"$ENVIRONMENT"'"'; then
  if [[ "$ENVIRONMENT" == "production" ]]; then
    echo "Production environment not found. Create it in Railway first." >&2
    exit 1
  fi
  railway environment new "$ENVIRONMENT" --duplicate production >/dev/null
fi

FRONTEND_URL="https://${FRONTEND_DOMAIN}"
BACKEND_URL="https://${BACKEND_DOMAIN}"
WEB_CONCURRENCY=2
if [[ "$ENVIRONMENT" == "staging" ]]; then
  WEB_CONCURRENCY=1
fi

railway variable set \
  --environment "$ENVIRONMENT" \
  --service "$BACKEND_SERVICE" \
  --skip-deploys \
  "ENVIRONMENT=$ENVIRONMENT" \
  "PROJECT_NAME=$PROJECT_NAME" \
  "SECRET_KEY=$SECRET_KEY" \
  "FIRST_SUPERUSER=$ADMIN_EMAIL" \
  "FIRST_SUPERUSER_PASSWORD=$ADMIN_PASSWORD" \
  "FRONTEND_HOST=$FRONTEND_URL" \
  "BACKEND_CORS_ORIGINS=[\"$FRONTEND_URL\"]" \
  "WEB_CONCURRENCY=$WEB_CONCURRENCY"

railway variable set \
  --environment "$ENVIRONMENT" \
  --service "$FRONTEND_SERVICE" \
  --skip-deploys \
  "VITE_API_URL=$BACKEND_URL"

cat <<EOF
Railway variables wired for $ENVIRONMENT.

Backend service:  $BACKEND_SERVICE
Frontend service: $FRONTEND_SERVICE
Frontend URL:     $FRONTEND_URL
Backend URL:      $BACKEND_URL

IMPORTANT:
- Ensure the project has a Postgres service and that DATABASE_URL is referenced by the backend service.
- Ensure Railway custom/public domains for backend/frontend match the URLs above.
EOF

if [[ "$SKIP_DEPLOY" -eq 1 ]]; then
  exit 0
fi

tmp_cleanup() {
  rm -f "$ROOT_DIR/railway.json"
}
trap tmp_cleanup EXIT

cp railway.backend.json railway.json
railway up --environment "$ENVIRONMENT" --service "$BACKEND_SERVICE" --detach --message "bootstrap $ENVIRONMENT backend"
cp railway.frontend.json railway.json
railway up --environment "$ENVIRONMENT" --service "$FRONTEND_SERVICE" --detach --message "bootstrap $ENVIRONMENT frontend"
rm -f railway.json

cat <<EOF

Deploys queued for $ENVIRONMENT.
Next checks:
- $BACKEND_URL/docs
- $BACKEND_URL/api/v1/utils/health-check/
- $FRONTEND_URL/
EOF
