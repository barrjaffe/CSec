# UI Screens and Wireframes

## Screen Inventory

### 1. Login / Auth
- **Route:** `/login`
- **Actors:** all users
- **Flow:** email → password → 2FA (optional) → dashboard

### 2. Dashboard / Main View
- **Route:** `/dashboard`
- **Actors:** analyst, admin, auditor
- **Key Elements:**
  - Recent scans (card list)
  - Quick start (new scan button)
  - Stats summary (total projects, active scans, critical findings)
  - Timeline feed (recent activity across all accessible projects)
  - Quick links to frequently used projects

### 3. Client List (Platform Admin)
- **Route:** `/admin/clients`
- **Actors:** platform admin only
- **Key Elements:**
  - Table of clients (name, status, project count, created date)
  - Search and filter
  - Actions: create client, view detail, archive
  - User management per client

### 4. Project List (Client Admin / Analyst)
- **Route:** `/clients/{client_id}/projects`
- **Actors:** client admin, analyst
- **Key Elements:**
  - Table of projects (name, status, scan count, last scan date)
  - Search and filter by status or date
  - Actions: create project, view detail, run scan
  - Quick links to latest report

### 5. Project Detail / Dashboard
- **Route:** `/clients/{client_id}/projects/{project_id}`
- **Actors:** client admin, analyst
- **Key Elements:**
  - Project overview (name, description, created date)
  - **Timeline tab** — Vertical timeline of all scans and reports for this project (THE DIFFERENTIATOR)
    - Each event shows: date, actor, scan/report status, score, finding count, action buttons
    - Ability to expand event and see details
    - Filter by date range, score, status
  - Scan history table
  - Latest report summary
  - Actions: run new scan, view reports, manage scenarios, manage agents

### 6. Timeline View (Project Level) — DIFFERENTIATOR
- **Route:** `/clients/{client_id}/projects/{project_id}/timeline`
- **Key Elements:**
  - Vertical timeline (chronological)
  - Each entry shows:
    - Date and time
    - Event type (scan_started, scan_completed, report_generated, report_approved, agent_executed)
    - Scan/report score (visual indicator, color-coded by severity)
    - Finding count
    - Actor (who initiated)
    - Quick action buttons (view report, view details, download)
  - Expandable detail pane
  - Filter by: date range, score range, event type, actor
  - Comparison view (show progression from scan A to scan B)
  - Export timeline as image or CSV

### 7. Timeline View (Client Level) — DIFFERENTIATOR
- **Route:** `/clients/{client_id}/timeline`
- **Key Elements:**
  - Multi-project timeline (all projects for the client)
  - Same structure as project timeline but spans all projects
  - Group by project option
  - Advanced filters (project, date range, score)

### 8. Scan Detail / Results
- **Route:** `/clients/{client_id}/projects/{project_id}/scans/{scan_run_id}`
- **Actors:** analyst, admin
- **Key Elements:**
  - Scan metadata (status, start/end time, duration, score, finding count)
  - Raw findings list (title, severity, component, status)
  - Findings by category/severity breakdown (chart)
  - Evidence artifacts (links to logs, screenshots)
  - Retry or edit scan option
  - Actions: generate report, download findings, archive scan

### 9. Report View
- **Route:** `/clients/{client_id}/projects/{project_id}/reports/{report_id}`
- **Actors:** analyst, admin, auditor
- **Key Elements:**
  - Report metadata (status, generated date, score, approved by)
  - Executive summary
  - Finding list (title, severity, component, remediation)
  - Charts (findings by severity, findings by category)
  - Evidence section (links to artifacts)
  - Action buttons: download PDF, download HTML, approve, archive
  - Comments/notes section

### 10. Scenario Management
- **Route:** `/clients/{client_id}/scenarios`
- **Actors:** client admin, analyst
- **Key Elements:**
  - List of scenarios (name, version, created date, used count)
  - Search and filter
  - Create new scenario (upload YAML)
  - Edit scenario (inline editor with syntax highlighting)
  - Versions/history
  - Test scenario (run against a target)
  - Actions: run, edit, delete, export

### 11. Scenario Editor
- **Route:** `/clients/{client_id}/scenarios/{scenario_id}/edit`
- **Key Elements:**
  - YAML code editor with syntax highlighting
  - Preview pane (visual representation of steps)
  - Variable reference panel (available variables, credentials)
  - Save, cancel, test buttons
  - Validation feedback (syntax errors highlighted)

### 12. Agent Management
- **Route:** `/clients/{client_id}/agents`
- **Actors:** client admin
- **Key Elements:**
  - List of agents (name, webhook URL, tags, status, created date)
  - Register new agent (form: name, webhook URL, auth type, secret)
  - Edit agent
  - Test agent (send test request)
  - Usage count (how many scenarios use this agent)
  - Actions: edit, delete, test

### 13. Account Settings / User Management
- **Route:** `/settings` or `/admin/users` (platform admin)
- **Actors:** all users (account) / platform admin (user management)
- **Key Elements:**
  - User profile (name, email, role, last login)
  - Change password
  - Account preferences (notifications, timeline view options)
  - API token management (create/revoke tokens for external integrations)
  - (Admin) User list, manage roles, enable/disable accounts

### 14. Audit Log (Platform Admin / Auditor)
- **Route:** `/admin/audit-logs`
- **Actors:** platform admin, auditor
- **Key Elements:**
  - Table of audit events (actor, action, object, timestamp, status)
  - Filter by: date range, actor, action type, object type
  - Search by object ID or description
  - Event detail view (full context and parameters)

---

## Wireframe: Project Timeline (Differentiator)

```
┌────────────────────────────────────────────────────────────┐
│ CSec — Project Timeline: API Gateway Pentest                │
│ Client: Acme Corp | Project: API Gateway Pentest            │
├────────────────────────────────────────────────────────────┤
│                                                              │
│ Filter: [Date Range] [Score] [Status] [Actor] [Search]      │
│                                                              │
│ 2026-08-30 16:30:00 ──────► Report Generated (Approved)     │
│         ↓                    Score: 7/10 | 5 findings       │
│         │ By: analyst@company.com                           │
│         │ [View] [Download PDF] [Expand]                    │
│         │                                                   │
│ 2026-08-30 16:15:00 ◄──────► Scan Completed                │
│         ↓                    Score: 7/10 | 5 findings       │
│         │ Duration: 15m | Tools: ZAP, Semgrep              │
│         │ [View Results] [Generate Report] [Expand]         │
│         │                                                   │
│ 2026-08-30 16:00:00 ──────► Scan Started                   │
│         ↓                    By: analyst@company.com        │
│         │ Target: https://api.example.com                   │
│         │ [Cancel] [Details]                                │
│         │                                                   │
│ 2026-08-28 14:30:00 ──────► Report Generated (Draft)       │
│         ↓                    Score: 6/10 | 4 findings       │
│         │ By: analyst@company.com                           │
│         │ [View] [Approve] [Archive] [Expand]               │
│         │                                                   │
│ 2026-08-28 14:20:00 ◄──────► Scan Completed                │
│                              Score: 6/10 | 4 findings       │
│                              Duration: 12m                  │
│                                                              │
│                          ← scroll for older events           │
│                                                              │
└────────────────────────────────────────────────────────────┘

Timeline Legend:
█ Critical Finding
● High Risk
○ Medium Risk
+ Approved Report
≈ Draft Report
→ Scan Completed
← Scan Started
```

---

## Wireframe: Dashboard

```
┌────────────────────────────────────────────────────────────┐
│ CSec Dashboard                                   [Settings] │
├────────────────────────────────────────────────────────────┤
│                                                              │
│ Welcome back, analyst@company.com                            │
│                                                              │
│ ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│ │ 12 Projects │  │ 3 Running   │  │ 8 Critical  │            │
│ │             │  │ Scans       │  │ Findings    │            │
│ └─────────────┘  └─────────────┘  └─────────────┘            │
│                                                              │
│ ┌──────────────────────────────────────────────────────────┐ │
│ │ Quick Start: New Scan                        [+] [>]     │ │
│ │ ┌──────────────────────────────────────────────────────┐ │ │
│ │ │ Project: [Select Project ▼]                        │ │ │
│ │ │ Target: [https://api.example.com]                  │ │ │
│ │ │ Scenario: [Basic API Scan ▼]                       │ │ │
│ │ │ [Start Scan]                                       │ │ │
│ │ └──────────────────────────────────────────────────────┘ │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                              │
│ ┌──────────────────────────────────────────────────────────┐ │
│ │ Recent Activity Timeline                               │ │
│ │                                                          │ │
│ │ 2026-08-30 16:30 ► Report: Acme API Audit (7/10)        │ │
│ │ 2026-08-30 16:15 ► Scan Done: Mobile Auth (7/10)        │ │
│ │ 2026-08-29 14:45 ► Report: Internal Pentest (6/10)      │ │
│ │ 2026-08-29 10:20 ► Scan Done: Admin API (5/10)          │ │
│ │                                                          │ │
│ │ [View Full Timeline]                                     │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                              │
│ ┌──────────────────────────────────────────────────────────┐ │
│ │ My Projects                                            │ │
│ │ API Gateway Pentest    | 3 scans, 5/10 avg  | [Open]   │ │
│ │ Mobile App Backend     | 2 scans, 7/10 avg  | [Open]   │ │
│ │ Admin Portal Review    | 1 scan,  6/10 avg  | [Open]   │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                              │
└────────────────────────────────────────────────────────────┘
```

---

## Key Interaction Patterns

1. **Timeline Navigation** — Click event to expand and see details in a side panel
2. **Quick Actions** — Buttons on each card for common actions (view, download, approve)
3. **Filtering** — Dropdowns and date pickers for filtering timeline and list views
4. **Progress Indicators** — Color-coded score/severity for quick visual scanning
5. **Breadcrumbs** — Client > Project > Scan/Report for context navigation
