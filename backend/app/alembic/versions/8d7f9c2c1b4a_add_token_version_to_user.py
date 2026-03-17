"""add token version to user

Revision ID: 8d7f9c2c1b4a
Revises: 5f9dd60141d4
Create Date: 2026-03-17 18:55:00.000000

"""

from alembic import op
import sqlalchemy as sa


revision = "8d7f9c2c1b4a"
down_revision = "5f9dd60141d4"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "user",
        sa.Column("token_version", sa.Integer(), nullable=False, server_default="0"),
    )
    op.alter_column("user", "token_version", server_default=None)


def downgrade() -> None:
    op.drop_column("user", "token_version")
