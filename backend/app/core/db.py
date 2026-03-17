from sqlalchemy.engine import make_url
from sqlmodel import Session, create_engine, select

from app import crud
from app.core.config import settings
from app.models import User, UserCreate


def _connect_args() -> dict[str, str]:
    ssl_mode = settings.DATABASE_SSL_MODE
    if settings.ENVIRONMENT == "local" and ssl_mode == "require":
        ssl_mode = "disable"
    return {"sslmode": ssl_mode}


def _engine_kwargs() -> dict[str, object]:
    database_url = make_url(str(settings.SQLALCHEMY_DATABASE_URI))
    kwargs: dict[str, object] = {
        "pool_pre_ping": True,
        "pool_recycle": settings.DATABASE_POOL_RECYCLE_SECONDS,
    }

    if database_url.get_backend_name().startswith("postgresql"):
        kwargs["connect_args"] = _connect_args()
        kwargs["pool_size"] = settings.DATABASE_POOL_SIZE
        kwargs["max_overflow"] = settings.DATABASE_MAX_OVERFLOW

    return kwargs


engine = create_engine(str(settings.SQLALCHEMY_DATABASE_URI), **_engine_kwargs())


def init_db(session: Session) -> None:
    user = session.exec(
        select(User).where(User.email == settings.FIRST_SUPERUSER)
    ).first()
    if not user:
        user_in = UserCreate(
            email=settings.FIRST_SUPERUSER,
            password=settings.FIRST_SUPERUSER_PASSWORD,
            is_superuser=True,
        )
        user = crud.create_user(session=session, user_create=user_in)
