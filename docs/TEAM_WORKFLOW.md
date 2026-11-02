# Team Workflow

Five members, one repository. This document describes who is responsible for what and how the modules connect.

## 1. Responsibilities

| # | Role | Owns | Main folders |
|---|------|------|--------------|
| 1 | Database Developer & Business Analyst | Requirements, ERD, schema, constraints, indexes, triggers, sample data, data dictionary | `docs/requirements`, `docs/database`, `database/` |
| 2 | Backend Developer A | Authentication, Users, Projects, Positions, Applications | `backend/.../auth`, `user`, `skill`, `project`, `position`, `application`, `security`, `config` |
| 3 | Backend Developer B | Members, Tasks, Progress, History, Owner Handover | `backend/.../member`, `task`, `handover` |
| 4 | Frontend Developer A | Authentication, Profiles, Project Discovery, Search, Applications | `frontend/src/pages/auth`, `profile`, `projects` (discovery), `applications` (apply) |
| 5 | Frontend Developer B & Deployment | Project Management UI, Applicants, Members, Tasks, Deployment | `frontend/src/pages/projects` (management), `members`, `tasks`, `deployment/`, `.github/workflows`, `docker-compose.yml` |

Skills management and project history have no single owner in the list above. Suggestion: the backend side belongs to Member 2 (skills) and Member 3 (history), the UI to Member 4 (skills in profile) and Member 5 (history in project management). **TODO: confirm in the first team meeting.**

## 2. How the work connects

```text
Member 1 (database)  ──schema──▶  Member 2 + Member 3 (backend)  ──API contract──▶  Member 4 + Member 5 (frontend)
        ▲                                                                                      │
        └────────────── requirements / questions ◀─────────────────────────────────────────────┘
Member 5 (deployment) supports everybody: Docker, CI, environments.
```

- **Member 1 → Members 2 and 3:** the schema, constraints and sample data are the source of truth for JPA entities. Backend members request schema changes from Member 1 instead of editing SQL files on their own.
- **Member 2 → Member 3:** Member 3's modules depend on Member 2's `user`, `project` and `position` entities, and on authentication. Agree on shared entity names early. An accepted application (Member 2) leads to a project member (Member 3).
- **Backend → Frontend:** the contract in `docs/api/API_CONTRACT.md` is agreed first. Frontend members can build against it before the backend is finished.
- **Member 4 ↔ Member 5:** share the same `components/`, `services/`, `routes/` and `contexts/` (for example the auth context and the Axios instance). Member 4 creates the auth context and Axios setup; Member 5 reuses them. The application flow connects both sides: Member 4 builds "apply", Member 5 builds "review applicants".
- **Member 5 → everyone:** keeps `docker-compose.yml`, CI and deployment scripts working and supports setup problems.

## 3. Working agreement

1. Plan: the team leader creates one GitHub issue per task and assigns it.
2. Contract first: change `docs/api/API_CONTRACT.md` in a small PR before implementing an endpoint.
3. Branch from `develop` using the naming rules in `CONTRIBUTING.md`.
4. Commit small, push often, open a PR into `develop`, get 1 review.
5. Weekly meeting: write notes in `docs/meeting-notes/` (file name `YYYY-MM-DD.md`).
6. `develop` is merged into `main` only for stable demo milestones.

## 4. Suggested starting branches

- `feature/database-schema` (Member 1)
- `feature/user-authentication` (Members 2 and 4)
- `feature/project-management` (Members 2 and 5)
- `feature/application-management` (Members 2 and 4)
- `feature/task-management` (Members 3 and 5)
