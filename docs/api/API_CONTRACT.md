# API Contract (DRAFT)

> **Status:** initial template. Endpoints below are *suggestions* derived from the feature list.
> Anything marked `TODO` is **undecided** and must be agreed by the team before implementation.
> Change this file in a small PR **before** implementing or consuming an endpoint.

## Conventions

- Base URL (development): `http://localhost:8080` (`TODO`: confirm port and prefix, e.g. `/api/v1`)
- Format: JSON (`Content-Type: application/json`)
- Authentication: JWT sent as `Authorization: Bearer <token>` (`TODO`: token lifetime / refresh)
- Common response envelope: `TODO` (see `backend/.../common/response`)
- Common error body: `TODO`
- Pagination / sorting query parameters: `TODO`
- Auth column meaning: `Public` = no token, `Required` = valid token, `Required (owner)` = token of the project owner, `TODO` = undecided.

## Common error status codes

| Code | Meaning |
|------|---------|
| 400 | Validation error / malformed request |
| 401 | Missing or invalid token |
| 403 | Authenticated but not allowed |
| 404 | Resource not found |
| 409 | Conflict (for example duplicate data) |
| 500 | Unexpected server error |

Each endpoint lists the codes that are *possibly* relevant. `TODO`: confirm per endpoint.


---

## 1. Authentication

### POST `/api/auth/register`

Register a new user

| Item | Value |
|------|-------|
| HTTP method | POST |
| URL | `/api/auth/register` |
| Authentication | Public |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### POST `/api/auth/login`

Log in and receive a JWT

| Item | Value |
|------|-------|
| HTTP method | POST |
| URL | `/api/auth/login` |
| Authentication | Public |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/auth/me`

Get the currently authenticated user

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/auth/me` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 2. Users and profiles

### GET `/api/users/{userId}`

Get a user profile

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/users/{userId}` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PUT `/api/users/me`

Update my profile

| Item | Value |
|------|-------|
| HTTP method | PUT |
| URL | `/api/users/me` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/users`

Search users (TODO: decide if needed)

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/users` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 3. Skills

### GET `/api/skills`

List available skills

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/skills` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/users/me/skills`

List my skills

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/users/me/skills` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PUT `/api/users/me/skills`

Update my skills

| Item | Value |
|------|-------|
| HTTP method | PUT |
| URL | `/api/users/me/skills` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 4. Projects

### POST `/api/projects`

Create a project

| Item | Value |
|------|-------|
| HTTP method | POST |
| URL | `/api/projects` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/projects`

Search and filter projects (query params: TODO)

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/projects` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/projects/{projectId}`

Get project details

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/projects/{projectId}` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PUT `/api/projects/{projectId}`

Edit a project

| Item | Value |
|------|-------|
| HTTP method | PUT |
| URL | `/api/projects/{projectId}` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/projects/{projectId}/progress`

Get project progress

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/projects/{projectId}/progress` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 5. Positions

### POST `/api/projects/{projectId}/positions`

Create a position

| Item | Value |
|------|-------|
| HTTP method | POST |
| URL | `/api/projects/{projectId}/positions` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/projects/{projectId}/positions`

List positions of a project

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/projects/{projectId}/positions` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PUT `/api/projects/{projectId}/positions/{positionId}`

Edit a position

| Item | Value |
|------|-------|
| HTTP method | PUT |
| URL | `/api/projects/{projectId}/positions/{positionId}` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### DELETE `/api/projects/{projectId}/positions/{positionId}`

Delete / close a position (TODO: decide which)

| Item | Value |
|------|-------|
| HTTP method | DELETE |
| URL | `/api/projects/{projectId}/positions/{positionId}` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 6. Applications

### POST `/api/positions/{positionId}/applications`

Apply for a position

| Item | Value |
|------|-------|
| HTTP method | POST |
| URL | `/api/positions/{positionId}/applications` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/users/me/applications`

List my applications

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/users/me/applications` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/projects/{projectId}/applications`

List applications of a project

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/projects/{projectId}/applications` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PATCH `/api/applications/{applicationId}/review`

Approve or reject an application

| Item | Value |
|------|-------|
| HTTP method | PATCH |
| URL | `/api/applications/{applicationId}/review` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 7. Project members

### GET `/api/projects/{projectId}/members`

List members

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/projects/{projectId}/members` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PATCH `/api/projects/{projectId}/members/{memberId}`

Change position assignment

| Item | Value |
|------|-------|
| HTTP method | PATCH |
| URL | `/api/projects/{projectId}/members/{memberId}` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### DELETE `/api/projects/{projectId}/members/{memberId}`

Remove a member (TODO: also allow leaving?)

| Item | Value |
|------|-------|
| HTTP method | DELETE |
| URL | `/api/projects/{projectId}/members/{memberId}` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 8. Tasks

### POST `/api/projects/{projectId}/tasks`

Create a task (TODO: who is allowed?)

| Item | Value |
|------|-------|
| HTTP method | POST |
| URL | `/api/projects/{projectId}/tasks` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### GET `/api/projects/{projectId}/tasks`

List tasks

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/projects/{projectId}/tasks` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PUT `/api/projects/{projectId}/tasks/{taskId}`

Edit a task

| Item | Value |
|------|-------|
| HTTP method | PUT |
| URL | `/api/projects/{projectId}/tasks/{taskId}` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PATCH `/api/projects/{projectId}/tasks/{taskId}/assignee`

Assign a task to a member

| Item | Value |
|------|-------|
| HTTP method | PATCH |
| URL | `/api/projects/{projectId}/tasks/{taskId}/assignee` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```

### PATCH `/api/projects/{projectId}/tasks/{taskId}/status`

Update task status

| Item | Value |
|------|-------|
| HTTP method | PATCH |
| URL | `/api/projects/{projectId}/tasks/{taskId}/status` |
| Authentication | Required |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 9. Project history

### GET `/api/projects/{projectId}/history`

List project activity history

| Item | Value |
|------|-------|
| HTTP method | GET |
| URL | `/api/projects/{projectId}/history` |
| Authentication | TODO |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```


---

## 10. Owner handover

### POST `/api/projects/{projectId}/handover`

Hand the project over to another member

| Item | Value |
|------|-------|
| HTTP method | POST |
| URL | `/api/projects/{projectId}/handover` |
| Authentication | Required (owner) |
| Possible error codes | 400, 401, 403, 404 (`TODO`: confirm) |

Request body:

```json
{
  "TODO": "define fields"
}
```

Response body:

```json
{
  "TODO": "define fields"
}
```
