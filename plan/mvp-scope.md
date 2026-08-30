# MVP Scope and Roadmap

## MVP (Phase 1) — Target: Q4 2026

The MVP is a tightly scoped, deployable pentest platform that covers the core workflow: client/project setup → scan → report → timeline.

### MVP Features

#### Core Platform
- [x] Multi-tenant architecture (clients, projects, users)
- [x] Role-based access control (Platform Admin, Client Admin, Analyst, Auditor)
- [x] Authentication via Entra ID or equivalent
- [x] Basic dashboard and navigation

#### Scan Orchestration
- [x] Start a scan against a target (API or web app)
- [x] Wrap OWASP ZAP for automated scanning
- [x] Wrap Semgrep for static analysis
- [x] Normalize findings from both tools into a unified format
- [x] Display scan results and finding list

#### Custom Scenarios
- [x] Scripted scenario format (YAML-based)
- [x] Execute scenarios against targets
- [x] Variable injection at runtime (targets, credentials from Key Vault)
- [x] Score-based assessment from scenario steps

#### Webhook Agents
- [x] Register external agent endpoints
- [x] Invoke agents from scenarios
- [x] Receive and store agent findings
- [x] Ephemeral agent lifecycle (lightweight, no platform management)

#### Reporting
- [x] Generate final report from scan + scenario results
- [x] Store report in artifact store (encrypted)
- [x] Report approval workflow (analyst → admin)
- [x] Download report (PDF/HTML)

#### Timeline and History
- [x] Project-level timeline view (chronological list of scans/reports)
- [x] Client-level timeline view (all projects)
- [x] Filter timeline by date, score, status
- [x] Expand event detail from timeline

#### Evidence Storage
- [x] Session database for temporary execution data
- [x] Report index database for sanitized metadata
- [x] Artifact store for final reports and evidence
- [x] Append-only audit log
- [x] Auto-delete session data after retention window

#### UI
- [x] Angular SPA
- [x] Login and dashboard
- [x] Project list and detail
- [x] Scan results view
- [x] Report view and approval
- [x] Timeline view (main differentiator)
- [x] Scenario editor (basic)
- [x] Agent management (register/delete)
- [x] Basic settings/user management

#### DevOps and Deployment
- [x] Terraform IaC for Azure
- [x] GitHub Actions CI/CD pipeline
- [x] Dev/Test/Demo environments
- [x] PostgreSQL and Storage for data
- [x] Key Vault for secrets
- [x] Log Analytics for observability

### MVP Out of Scope (Deferred to Phase 2+)

- Advanced scenario templating (parameterized scenarios, branching logic)
- Custom detection rules (start with ZAP + Semgrep only)
- Cloud sandbox validation and IaaS/PaaS exploitation
- Agent versioning and marketplace
- Advanced audit log with hash chaining and cryptographic proof
- Multi-cloud deployment (AWS, GCP)
- Advanced timeline analytics (trend analysis, comparison views)
- API rate limiting and advanced security controls
- Mobile app (mobile web UI only)
- Integrations with external tools (Slack, Jira, etc.)
- Penetration testing of containerized workloads
- Machine learning-based findings
- Continuous scanning and monitoring

---

## Phase 2 (Post-MVP)

### Advanced Scenarios
- Parameterized scenario templates
- Conditional branching and loops in scenarios
- Scenario composition (call one scenario from another)
- Scenario version management and rollback

### Enhanced Detection
- Custom detection rule engine
- Integration with additional tools (Nuclei, Trivy, etc.)
- Machine learning-based anomaly detection (optional)

### Cloud Validation
- Azure sandbox environment setup
- IaaS/PaaS exploitation scenarios
- Network and IAM posture checks
- Multi-cloud support (AWS, GCP)

### Advanced Reporting
- Custom report templates
- Multi-scan comparison and trend analysis
- Executive summary generation
- Risk score evolution tracking

### Integrations
- Slack notifications
- Jira ticketing
- Email delivery
- Webhook notifications for external systems

---

## Phase 3 (Long-term Vision)

- Agent marketplace and community contributions
- Containerized workload pentesting
- Advanced threat modeling and attack tree generation
- Automated remediation suggestions
- Continuous pentesting (scheduled, recurring scans)
- Real-time collaboration and live scenario editing
- AI-powered scenario generation from vulnerability descriptions

---

## MVP Success Criteria

1. Can create a client and project in <5 minutes
2. Can run a scan against an API in <10 minutes
3. Can author and execute a custom scenario in <15 minutes
4. Can generate and download a report in <2 minutes
5. Timeline view clearly shows progression and status
6. All findings are traceable to actor, time, and evidence
7. Session data is auto-deleted after retention window
8. Platform can handle 5 concurrent scans without degradation
9. Zero unplanned downtime in test environment for 1 week
10. All critical security controls are in place and audited

---

## Effort Estimation (Rough)

| Component | Effort (weeks) |
|---|---|
| Backend API (CRUD, auth, orchestration) | 4-5 |
| Scanner integration (ZAP + Semgrep) | 2-3 |
| Scenario engine | 2-3 |
| Agent webhook handler | 1-2 |
| Reporting and evidence store | 2-3 |
| Frontend (Angular, all screens) | 4-5 |
| Terraform and DevOps | 1-2 |
| Testing and QA | 2-3 |
| **Total** | **18-26 weeks** |

Assuming 2-3 developers and parallel work, MVP is achievable in 12-16 weeks.

---

## Acceptance Criteria

### Functional
- [ ] All MVP features work as designed
- [ ] Timeline view correctly reflects scan/report progression
- [ ] Reports can be generated, approved, and downloaded
- [ ] RBAC is enforced on all endpoints
- [ ] Scenarios can be authored and executed
- [ ] Agents can be registered and invoked

### Non-Functional
- [ ] 95th percentile scan completion time < 5 minutes
- [ ] 95th percentile report generation time < 2 minutes
- [ ] API response time (p95) < 500ms
- [ ] Zero data loss for critical records
- [ ] All secrets are stored in Key Vault
- [ ] Audit trail is tamper-evident

### Security
- [ ] OWASP Top 10 controls in place
- [ ] RBAC enforced on all data access
- [ ] No secrets in logs or error messages
- [ ] Session data auto-deleted after retention
- [ ] TLS 1.2+ for all traffic
- [ ] Key rotation enabled for secrets
