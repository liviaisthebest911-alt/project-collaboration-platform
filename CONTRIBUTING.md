# Contributing Guide

## 1. Branch strategy

| Branch | Purpose | Who can push |
|--------|---------|--------------|
| `main` | Stable code for the final demonstration | Team leader merges from `develop` only |
| `develop` | Integrated development branch | Via Pull Request only |
| `feature/*` | New functionality | The branch owner |
| `fix/*` | Bug fixes | The branch owner |

### Branch naming

Use lowercase words separated by hyphens: `<type>/<short-description>`.

- `feature/user-authentication`
- `feature/project-management`
- `feature/application-management`
- `feature/task-management`
- `fix/database-constraints`

Create a branch:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/user-authentication
```

## 2. Commit message convention

Format: `<type>(<scope>): <short summary in imperative mood>`

| Type | Use for |
|------|---------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `refactor` | Code change that is neither a fix nor a feature |
| `test` | Adding or fixing tests |
| `chore` | Build, config, dependencies |

Scopes: `db`, `backend`, `frontend`, `docs`, `deploy`, `api`.

Examples:

```text
feat(backend): add user registration endpoint
fix(db): add missing unique constraint on user email
docs(api): describe application endpoints
```

Keep commits small and focused. One commit should do one thing.

## 3. Pull request process

1. Update your branch with the latest `develop`:

   ```bash
   git fetch origin
   git merge origin/develop
   ```

2. Make sure the code builds and tests pass locally (`mvn test`, `npm run build`).
3. Push your branch: `git push -u origin feature/your-branch`.
4. Open a Pull Request **into `develop`** and fill in the PR template.
5. Request a review from at least one teammate.
6. Fix review comments by pushing more commits to the same branch.
7. After approval, merge (squash merge is recommended) and delete the branch.
8. The team leader merges `develop` into `main` when a stable milestone is reached.

## 4. Code review rules

- Every PR needs **at least 1 approval** from someone who is not the author.
- Review within 24 hours when possible. Be polite and specific. Review the code, not the person.
- Check: does it match the API contract? Is it readable? Are there tests for important logic? No secrets or `.env` files? No unrelated changes?
- The author resolves every comment before merging.
- Do not approve a PR you did not read.
- Changes to the database schema must be reviewed by Member 1; changes to `docs/api/API_CONTRACT.md` must be reviewed by both a backend and a frontend member.
