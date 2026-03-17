from collections.abc import Awaitable, Callable

from fastapi import Request, Response, status
from starlette.responses import JSONResponse

from app.core.config import settings

SAFE_METHODS = {"GET", "HEAD", "OPTIONS", "TRACE"}
CSRF_EXEMPT_PATHS = {
    f"{settings.API_V1_STR}/login/access-token",
    f"{settings.API_V1_STR}/users/signup",
    f"{settings.API_V1_STR}/password-recovery",
    f"{settings.API_V1_STR}/reset-password/",
}


async def csrf_protect(
    request: Request,
    call_next: Callable[[Request], Awaitable[Response]],
) -> Response:
    if request.method in SAFE_METHODS:
        return await call_next(request)

    if any(request.url.path.startswith(path) for path in CSRF_EXEMPT_PATHS):
        return await call_next(request)

    auth_cookie = request.cookies.get(settings.AUTH_COOKIE_NAME)
    if not auth_cookie:
        return await call_next(request)

    csrf_cookie = request.cookies.get(settings.CSRF_COOKIE_NAME)
    csrf_header = request.headers.get("x-csrf-token")
    if not csrf_cookie or not csrf_header or csrf_cookie != csrf_header:
        return JSONResponse(
            status_code=status.HTTP_403_FORBIDDEN,
            content={"detail": "CSRF validation failed"},
        )

    return await call_next(request)
