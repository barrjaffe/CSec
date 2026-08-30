# RBAC Matrix

## Roles

| Role | Purpose | Scope |
|---|---|---|
| **Platform Admin** | Manage platform, all clients, users, configuration | Platform-wide |
| **Client Admin** | Manage their client's data, projects, users | Single client |
| **Security Analyst** | Run scans, execute scenarios, view reports | Assigned client(s) |
| **Auditor** | Read-only access to reports and audit logs | All or assigned clients |

---

## Permission Matrix

### Client Management

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| List clients | ✅ | ❌ (own only) | ❌ | ❌ |
| Create client | ✅ | ❌ | ❌ | ❌ |
| View client | ✅ | ✅ (own) | ✅ (own) | ✅ |
| Edit client | ✅ | ✅ (own) | ❌ | ❌ |
| Delete client | ✅ | ❌ | ❌ | ❌ |

### User Management

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| List users (platform) | ✅ | ❌ | ❌ | ❌ |
| List users (client) | ✅ | ✅ (own) | ❌ | ❌ |
| Create user | ✅ | ✅ (own client) | ❌ | ❌ |
| Edit user | ✅ | ✅ (own client) | ❌ (self only) | ❌ (self only) |
| Delete user | ✅ | ✅ (own client) | ❌ | ❌ |
| Assign role | ✅ | ✅ (within own client) | ❌ | ❌ |

### Projects

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| List projects | ✅ | ✅ (own) | ✅ (own) | ✅ |
| Create project | ✅ | ✅ (own) | ❌ | ❌ |
| View project | ✅ | ✅ (own) | ✅ (own) | ✅ |
| Edit project | ✅ | ✅ (own) | ❌ | ❌ |
| Delete project | ✅ | ✅ (own) | ❌ | ❌ |
| View timeline | ✅ | ✅ (own) | ✅ (own) | ✅ |

### Scans and Execution

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| List scans | ✅ | ✅ (own) | ✅ (own) | ✅ |
| Create/run scan | ✅ | ✅ (own) | ✅ (own) | ❌ |
| View scan | ✅ | ✅ (own) | ✅ (own) | ✅ |
| Cancel scan | ✅ | ✅ (own) | ✅ (own, if owner) | ❌ |
| Download findings | ✅ | ✅ (own) | ✅ (own) | ✅ |

### Reports and Evidence

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| List reports | ✅ | ✅ (own) | ✅ (own) | ✅ |
| View report | ✅ | ✅ (own) | ✅ (own) | ✅ |
| Generate report | ✅ | ✅ (own) | ✅ (own) | ❌ |
| Approve report | ✅ | ✅ (own) | ❌ | ❌ |
| Download report | ✅ | ✅ (own) | ✅ (own) | ✅ |
| Archive report | ✅ | ✅ (own) | ❌ | ❌ |

### Scenarios and Custom Logic

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| List scenarios | ✅ | ✅ (own) | ✅ (own) | ❌ |
| Create scenario | ✅ | ✅ (own) | ❌ | ❌ |
| Edit scenario | ✅ | ✅ (own) | ❌ | ❌ |
| Delete scenario | ✅ | ✅ (own) | ❌ | ❌ |
| Run scenario | ✅ | ✅ (own) | ✅ (own) | ❌ |

### Agents and Webhooks

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| List agents | ✅ | ✅ (own) | ✅ (own) | ❌ |
| Register agent | ✅ | ✅ (own) | ❌ | ❌ |
| Edit agent | ✅ | ✅ (own) | ❌ | ❌ |
| Delete agent | ✅ | ✅ (own) | ❌ | ❌ |
| Test agent | ✅ | ✅ (own) | ❌ | ❌ |

### Audit and Logging

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| View audit logs (all) | ✅ | ❌ | ❌ | ✅ |
| View audit logs (client) | ✅ | ✅ (own) | ❌ | ✅ |
| Export audit logs | ✅ | ✅ (own) | ❌ | ✅ |
| View activity timeline | ✅ | ✅ (own) | ✅ (own) | ✅ |

### Settings and Configuration

| Resource | Platform Admin | Client Admin | Analyst | Auditor |
|---|---|---|---|---|
| Platform settings | ✅ | ❌ | ❌ | ❌ |
| Client settings | ✅ | ✅ (own) | ❌ | ❌ |
| Personal settings | ✅ | ✅ | ✅ | ✅ |

---

## Implementation Notes

- **Scope:** All permission checks are scoped by client. An analyst for Client A cannot view Client B's data.
- **Delegation:** Client admins can assign roles to other users within their client only.
- **Self-service:** All users can view and edit their own account settings and change password.
- **API tokens:** Users can generate and revoke API tokens for external integrations (all roles).
- **Audit trail:** All permission-gated actions are logged with actor, resource, and timestamp.

---

## Extension Points

- Custom roles can be added in Phase 2+ (e.g., "Report Approver", "Scan Scheduler")
- Fine-grained permissions can be introduced per resource type in future versions
- Temporary elevation (request approval to run privileged action) can be added later
