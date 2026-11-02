# Project Collaboration Platform

A platform that connects users who have skills with software projects that need additional contributors.

> **Scope note:** this system only provides matchmaking and project management. It does **not** integrate
> automatically with GitHub or GitLab. A project can store an external repository URL for reference only.

## Features

- User registration, login and authentication
- User profiles and skills management
- Create, edit, search and filter projects
- Create and manage project positions
- Apply for project positions
- Project owners review and approve/reject applications
- Manage project members and position assignments
- Create and assign tasks
- Track project progress
- Project activity history
- Project owner handover

> This repository currently contains the **project skeleton only**. Features are implemented by the team
> branch by branch (see `docs/TEAM_WORKFLOW.md`).

## Technology Stack

| Layer | Technologies |
|-------|--------------|
| Database | PostgreSQL 16, plain SQL scripts (schema, constraints, indexes, triggers, sample data) |
| Backend | Java 21+ (24 works too), Spring Boot 3.x, Maven, Spring Web, Spring Data JPA, Spring Security, Spring Validation, PostgreSQL driver, JWT, JUnit 5, Mockito |
| Frontend | React, Vite, TypeScript, React Router, Axios, Tailwind CSS, Lucide React |
| Tooling | Git + GitHub, Docker + Docker Compose, Postman |

## Repository Structure

```text
project-collaboration-platform/
├── README.md, CONTRIBUTING.md, docker-compose.yml, .env.example
├── docs/          # requirements, architecture, database docs/ERD, API contract, meeting notes, reports
├── database/      # SQL scripts: migrations, schema, seeds, views, functions, triggers, queries
├── backend/       # Spring Boot application (Maven)
├── frontend/      # React + Vite + TypeScript application
├── deployment/    # Docker files and helper scripts
├── postman/       # Postman collections for API testing
└── .github/       # CI workflow, issue templates, pull request template
```

## Prerequisites

| Tool | Version | Check |
|------|---------|-------|
| Git | any recent | `git --version` |
| Docker + Docker Compose | Docker 24+ | `docker --version` and `docker compose version` |
| JDK | 21 or newer (24 supported) | `java -version` |
| Maven | 3.9+ (or use an IDE) | `mvn -v` |
| Node.js | 20 LTS or newer | `node -v` |
| npm | 10+ | `npm -v` |

## Installation

1. Clone the repository:

   ```bash
   git clone <REPOSITORY_URL>
   cd project-collaboration-platform
   ```

2. Create your local environment file and **edit the placeholders** (at least the passwords and `JWT_SECRET`):

   ```bash
   cp .env.example .env
   ```

   The real `.env` file is ignored by Git. Never commit it.

## How to run the database

```bash
docker compose up -d
docker compose ps          # STATUS should become "healthy"
docker compose logs -f postgres
```

Connect with `psql` inside the container:

```bash
docker compose exec postgres psql -U project_collab_user -d project_collab
```

Stop the database (data is kept in the Docker volume):

```bash
docker compose down
```

Delete the database **including all data**:

```bash
docker compose down -v
```

How SQL scripts are organised and executed: see [`database/README.md`](database/README.md).

## How to run the backend

1. Make sure the database is running and `.env` exists.
2. Load the environment variables into your terminal, then start Spring Boot.

   Linux / macOS / Git Bash:

   ```bash
   set -a; source .env; set +a
   cd backend
   mvn spring-boot:run -Dspring-boot.run.profiles=dev
   ```

   Windows PowerShell:

   ```powershell
   Get-Content .env | Where-Object { $_ -match '^\s*[^#]\S+=' } | ForEach-Object {
     $name, $value = $_ -split '=', 2
     [Environment]::SetEnvironmentVariable($name.Trim(), $value.Trim(), 'Process')
   }
   cd backend
   mvn spring-boot:run "-Dspring-boot.run.profiles=dev"
   ```

   In IntelliJ IDEA you can instead add the variables to the Run Configuration (Environment variables).

3. Run tests: `cd backend && mvn test`

More details: [`backend/README.md`](backend/README.md).

## How to run the frontend

```bash
cd frontend
cp .env.example .env      # Windows: copy .env.example .env
npm install
npm run dev
```

Open <http://localhost:5173>. More details: [`frontend/README.md`](frontend/README.md).

## Team Contribution Guidelines

- Everybody works in this **same repository** (monorepo). Do not create separate repositories.
- Never push directly to `main` or `develop`. Create a branch and open a Pull Request.
- Branch names: `feature/<name>` and `fix/<name>`. Targets: PRs go to `develop`.
- Read [`CONTRIBUTING.md`](CONTRIBUTING.md) and [`docs/TEAM_WORKFLOW.md`](docs/TEAM_WORKFLOW.md) before your first commit.
- API changes must be written in [`docs/api/API_CONTRACT.md`](docs/api/API_CONTRACT.md) **before** coding them.
