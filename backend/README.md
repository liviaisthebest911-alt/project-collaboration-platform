# Backend

Spring Boot 3.x REST API, built with Maven.

## Package layout (`com.projectcollab`)

| Package | Purpose |
|---------|---------|
| `config` | Spring configuration (CORS, beans) |
| `security` | Spring Security and JWT |
| `common` | Shared `exception`, `response`, `util` classes |
| `auth`, `user`, `skill` | Authentication, users/profiles, skills |
| `project`, `position`, `application` | Projects, positions, applications |
| `member`, `task`, `handover` | Members, tasks and progress, owner handover |

Inside each feature package use the sub-packages `controller`, `service`, `repository`, `entity`, `dto` when you add code.

## Run

```bash
# from the repository root, with the database running and .env created
set -a; source .env; set +a
cd backend
mvn spring-boot:run -Dspring-boot.run.profiles=dev
mvn test
```

## Notes

- Configuration comes from environment variables (see `.env.example`). Never hardcode secrets.
- The database schema is managed by the SQL scripts in `database/`, so Hibernate `ddl-auto` is `none`.
- Spring Security is on the classpath, so by default **all endpoints require authentication** until the security configuration is written.
- Java version: `pom.xml` uses `java.version` = 21. Change it to 24 only if every teammate has JDK 24 and your Spring Boot version supports it.
