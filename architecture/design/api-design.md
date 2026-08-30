# API Design (Markdown List)

## Overview

The CSec API is a REST API consumed by the Angular frontend and external integrations. It follows standard REST conventions and returns JSON.

Authentication: Bearer token (JWT or similar) issued at login.

Base URL: `https://{instance}/api/v1`

---

## Authentication & User Management

### POST /auth/login
**Description:** Authenticate with email and password, receive access token

**Request:**
```json
{
  "email": "analyst@company.com",
  "password": "secure_password"
}
```

**Response:**
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "eyJhbGc..."
}
```

### POST /auth/refresh
**Description:** Refresh an access token using refresh_token

**Request:**
```json
{
  "refresh_token": "eyJhbGc..."
}
```

### POST /auth/logout
**Description:** Invalidate current session

---

## Client Management (Platform Admin Only)

### GET /clients
**Description:** List all clients

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Acme Corp",
      "status": "active",
      "created_at": "2026-08-30T10:00:00Z",
      "project_count": 5
    }
  ],
  "pagination": {limit: 20, offset: 0}
}
```

### POST /clients
**Description:** Create a new client

**Request:**
```json
{
  "name": "Acme Corp",
  "description": "Enterprise customer"
}
```

### GET /clients/{client_id}
**Description:** Get client details

### PUT /clients/{client_id}
**Description:** Update client info

### DELETE /clients/{client_id}
**Description:** Archive/delete a client

---

## Projects (Client Admin + Analyst)

### GET /clients/{client_id}/projects
**Description:** List projects for a client

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "API Gateway Pentest",
      "status": "active",
      "created_at": "2026-08-30T10:00:00Z",
      "scan_count": 12,
      "last_scan_at": "2026-08-30T15:30:00Z"
    }
  ]
}
```

### POST /clients/{client_id}/projects
**Description:** Create a new project

**Request:**
```json
{
  "name": "Mobile App Security Review",
  "description": "Pentest for iOS and Android mobile backends"
}
```

### GET /clients/{client_id}/projects/{project_id}
**Description:** Get project details and summary

### PUT /clients/{client_id}/projects/{project_id}
**Description:** Update project metadata

---

## Scans and Execution

### POST /clients/{client_id}/projects/{project_id}/scans
**Description:** Initiate a new scan or pentest

**Request:**
```json
{
  "name": "Weekly API Scan",
  "scan_type": "api" | "code" | "scenario" | "custom",
  "target": "https://api.example.com",
  "scenario_id": "uuid (if scan_type=scenario)",
  "tools": ["owasp_zap", "semgrep", "custom"],
  "custom_config": {}
}
```

**Response:**
```json
{
  "scan_run_id": "uuid",
  "status": "queued",
  "created_at": "2026-08-30T16:00:00Z",
  "estimated_duration_seconds": 600
}
```

### GET /clients/{client_id}/projects/{project_id}/scans
**Description:** List scans for a project (supports filtering by status, date range)

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "status": "completed",
      "started_at": "2026-08-30T16:00:00Z",
      "ended_at": "2026-08-30T16:15:00Z",
      "score": 7,
      "finding_count": 5
    }
  ]
}
```

### GET /clients/{client_id}/projects/{project_id}/scans/{scan_run_id}
**Description:** Get scan status, results, and summary

**Response:**
```json
{
  "id": "uuid",
  "status": "completed",
  "score": 7,
  "summary": "5 findings detected, 2 critical, 3 high",
  "started_at": "2026-08-30T16:00:00Z",
  "ended_at": "2026-08-30T16:15:00Z",
  "report_id": "uuid"
}
```

### POST /clients/{client_id}/projects/{project_id}/scans/{scan_run_id}/cancel
**Description:** Cancel a running scan

---

## Scenarios and Custom Logic

### GET /clients/{client_id}/scenarios
**Description:** List custom scenarios for a client

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "API Authentication Bypass Test",
      "version": "1.0",
      "created_by": "user@company.com",
      "created_at": "2026-08-30T10:00:00Z",
      "used_count": 3
    }
  ]
}
```

### POST /clients/{client_id}/scenarios
**Description:** Upload or create a new scenario (YAML file)

**Request:** multipart form data
```
file: <scenario.yaml>
name: "Auth Bypass Test"
version: "1.0"
```

### GET /clients/{client_id}/scenarios/{scenario_id}
**Description:** Get scenario definition

### PUT /clients/{client_id}/scenarios/{scenario_id}
**Description:** Update scenario

### DELETE /clients/{client_id}/scenarios/{scenario_id}
**Description:** Archive/delete scenario

---

## Agents and Webhooks

### GET /clients/{client_id}/agents
**Description:** List registered agents for a client

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Custom Auth Validator",
      "webhook_url": "https://...",
      "tags": ["auth", "custom"],
      "created_at": "2026-08-30T10:00:00Z"
    }
  ]
}
```

### POST /clients/{client_id}/agents
**Description:** Register a new agent

**Request:**
```json
{
  "name": "Custom Validator",
  "webhook_url": "https://my-tool.company.com/pentest",
  "auth_type": "bearer",
  "auth_secret": "secret_stored_in_kv"
}
```

### DELETE /clients/{client_id}/agents/{agent_id}
**Description:** Deregister an agent

---

## Reports

### GET /clients/{client_id}/projects/{project_id}/reports
**Description:** List reports for a project

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "scan_run_id": "uuid",
      "status": "approved",
      "score": 7,
      "generated_at": "2026-08-30T16:30:00Z",
      "report_uri": "s3://...",
      "finding_count": 5
    }
  ]
}
```

### GET /clients/{client_id}/projects/{project_id}/reports/{report_id}
**Description:** Get report metadata and download link

**Response:**
```json
{
  "id": "uuid",
  "status": "approved",
  "score": 7,
  "summary": "5 findings detected...",
  "report_uri": "https://artifact-store/...",
  "findings": [
    {
      "id": "uuid",
      "title": "Broken Authentication",
      "severity": "high",
      "component": "/api/login"
    }
  ]
}
```

### POST /clients/{client_id}/projects/{project_id}/reports/{report_id}/approve
**Description:** Approve a report (analyst or admin only)

### POST /clients/{client_id}/projects/{project_id}/reports/{report_id}/download
**Description:** Download full report (PDF/HTML)

---

## Timeline and History

### GET /clients/{client_id}/timeline
**Description:** Get timeline of all scans and reports for a client

**Response:**
```json
{
  "data": [
    {
      "timestamp": "2026-08-30T16:30:00Z",
      "event_type": "report_generated",
      "project_id": "uuid",
      "scan_run_id": "uuid",
      "score": 7,
      "actor": "analyst@company.com"
    }
  ],
  "pagination": {limit: 50, offset: 0}
}
```

### GET /clients/{client_id}/projects/{project_id}/timeline
**Description:** Get timeline for a specific project

---

## Errors

All errors return JSON with a standard format:

```json
{
  "error": "unauthorized",
  "message": "User does not have permission to access this resource",
  "status_code": 403,
  "timestamp": "2026-08-30T16:00:00Z"
}
```

Common status codes:
- 200 OK
- 201 Created
- 400 Bad Request
- 401 Unauthorized
- 403 Forbidden
- 404 Not Found
- 500 Internal Server Error

---

## RBAC Notes

Each endpoint enforces role-based access control:
- **Platform Admin:** Full access to all clients, users, configuration
- **Client Admin:** Full access to their client, can manage projects and users
- **Security Analyst:** Can create and run scans, view reports
- **Auditor:** Read-only access to reports and timeline

See `rbac-matrix.md` for detailed permission map.
