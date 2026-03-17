# Security Policy

## Supported scope

The actively maintained template state on the default branches is the supported scope.

## Reporting a vulnerability

Please do **not** open a public issue for a potential vulnerability.

Instead, use GitHub Security Advisories for this repository:

<https://github.com/AgentKaelChng/railway-fastapi-react-template/security/advisories/new>

If that path is unavailable, contact the maintainer privately first.

## Security expectations for this template

If you use this template in a real project, you should at minimum:

- replace all example secrets before deployment
- review and rotate `SECRET_KEY`
- set a strong `FIRST_SUPERUSER_PASSWORD`
- keep dependencies updated
- verify Railway environment variables match your real frontend/backend domains
- avoid exposing staging with production secrets by accident

## Notes

This template tries to provide safe defaults for Railway-based deployment, but it is still a starter. You are responsible for final app security, domain setup, secret handling, and production hardening in downstream projects.
