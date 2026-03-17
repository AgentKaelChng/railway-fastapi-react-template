"""add password reset version to user

Revision ID: 5f9dd60141d4
Revises: 1a31ce608336
Create Date: 2026-03-17 17:15:00.000000

"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "5f9dd60141d4"
down_revision = "1a31ce608336"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "user",
        sa.Column(
            "password_reset_version",
            sa.Integer(),
            nullable=False,
            server_default="0",
        ),
    )
    op.alter_column("user", "password_reset_version", server_default=None)


def downgrade() -> None:
    op.drop_column("user", "password_reset_version")
