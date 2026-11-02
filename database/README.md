# Database

PostgreSQL 16, started with `docker compose up -d` from the repository root.

## Folders

| Folder | Content |
|--------|---------|
| `schema/` | Table definitions (`CREATE TABLE`), constraints, indexes |
| `migrations/` | Ordered change scripts applied after the first schema (`V002__add_xxx.sql`) |
| `seeds/` | Sample data for development. Keep it clearly fake |
| `views/` | `CREATE VIEW` scripts |
| `functions/` | Stored functions |
| `triggers/` | Trigger definitions |
| `queries/` | Useful reporting / test queries |

## Naming

- Files are numbered so the run order is obvious: `001_create_users.sql`, `002_create_projects.sql`, ...
- Tables and columns use `snake_case`.
- One purpose per file.

## Running a script

```bash
docker compose exec -T postgres psql -U project_collab_user -d project_collab < database/schema/001_example.sql
```

(Replace the user/database name if you changed them in `.env`.)

## Rules

- Schema changes go through Member 1 and a Pull Request.
- Never put real personal data or real passwords in `seeds/`.
- Document each table in `docs/database/data-dictionary/`.

Currently there are no SQL scripts yet.
