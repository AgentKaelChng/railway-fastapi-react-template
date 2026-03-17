from collections import defaultdict, deque
from time import monotonic

from fastapi import HTTPException, Request, status

RequestBucket = deque[float]


class SimpleRateLimiter:
    def __init__(self) -> None:
        self._buckets: dict[str, RequestBucket] = defaultdict(deque)

    def check(self, *, key: str, limit: int, window_seconds: int) -> None:
        now = monotonic()
        window_start = now - window_seconds
        bucket = self._buckets[key]

        while bucket and bucket[0] <= window_start:
            bucket.popleft()

        if len(bucket) >= limit:
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail="Too many requests. Please try again later.",
            )

        bucket.append(now)


def get_rate_limit_key(request: Request, scope: str, identifier: str = "") -> str:
    client_host = request.client.host if request.client else "unknown"
    suffix = f":{identifier}" if identifier else ""
    return f"{scope}:{client_host}{suffix}"


limiter = SimpleRateLimiter()
