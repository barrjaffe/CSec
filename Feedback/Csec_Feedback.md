# Feedback on CSec Platform Plan

Hey Bar,

Went through everything you have in the repo — architecture spec, functional requirements, DB schema, flows, devops, terraform, the whole thing. Solid planning work overall. The data model is thoughtful, the separation between session/artifact/audit stores shows you're thinking about this the right way, and the flows are clear.

Before we move to execution, there are a few things that need to be tightened up or added. I'm listing them below so you can run them through your tooling and update the docs before we start writing code.

---

## 1. Positioning and Differentiation — Needs a Clear Statement

The plan doesn't have a positioning document. Right now the architecture reads like "we're building a security scanner," which puts you in direct competition with Microsoft Defender for APIs, Defender for Cloud, Security Exposure Management, and a dozen other products that already do passive scanning and posture management with massive detection libraries.

What actually makes CSec different:
- **Offensive pentest orchestration**, not just passive detection
- **Custom `.md` scenarios and pluggable agents** — clients define their own attack logic
- **Multi-client/multi-project model** — built for security consultancies, not just internal teams
- **Self-hosted, controllable** — data stays on your infra
- **Unified pentest lifecycle** — scan → attack → evidence → report → timeline in one workflow

Your real competitors are Pentera, PlexTrac, Cobalt, AttackIQ, and Cymulate — not Microsoft Defender.

**Action:** Add a `positioning.md` or update the architecture overview to explicitly state what CSec is and isn't. The scanner engine should be framed as an orchestration layer that wraps and extends existing tools, not as a from-scratch detection engine competing with billion-dollar products.

---

## 2. Scanner Engine Strategy — Build vs. Wrap

The architecture talks about a "Scanner Engine" and "Scenario Engine" but doesn't define what the scanner actually does under the hood. Are you writing detection rules from scratch? Wrapping OWASP ZAP? Integrating Semgrep? Using Nuclei templates?

This is the single biggest risk in the project. Writing a scanner engine from scratch that produces meaningful, low-false-positive results is a multi-year effort by itself.

**Action:** Add a `scanner-strategy.md` that defines:
- Which open-source tools you plan to wrap/integrate (ZAP, Semgrep, Nuclei, etc.)
- What custom detection logic you plan to write (if any) and why
- How the scanner engine normalizes output from different tools into a unified findings format
- How the scenario engine parses and executes `.md` scenario files (this needs a spec — what's the markdown structure? what commands/steps are valid?)

---

## 3. `.md` Scenario Spec — Undefined

Custom markdown scenarios are one of the strongest differentiators, but there's no spec for what a scenario file looks like. What's the structure? What steps can it contain? How does it reference targets, credentials, assertions? Is it declarative or does it have control flow?

**Action:** Create a `scenario-spec.md` with:
- Example `.md` scenario file(s)
- Supported step types (HTTP request, auth check, assertion, wait, etc.)
- How variables/targets are injected
- How results are captured and scored
- Limitations and security boundaries

---

## 4. Agent/Plugin Architecture — Undefined

"Custom agents and test logic" is mentioned repeatedly but never specified. How does a client create a custom agent? Is it a Python module with a known interface? A container? A webhook?

**Action:** Add an `agent-spec.md` defining:
- What an agent is (runtime, interface, lifecycle)
- How agents are registered, versioned, and sandboxed
- Security boundaries (what can an agent access, what can't it)
- Example agent implementation

---

## 5. API Design — Missing

There's no API contract. The flows show a "Pentest API" but there's no OpenAPI spec, no endpoint list, no request/response examples. You can't start backend development without this.

**Action:** Create an initial `api-spec.yaml` (OpenAPI 3.x) or at minimum an `api-design.md` covering:
- Auth endpoints (login, token refresh, logout)
- Client/project/account CRUD
- Scan initiation and status
- Scenario and agent management
- Report retrieval
- Timeline/history queries

---

## 6. Frontend Wireframes or Screen Map — Missing

The architecture says Angular with timeline-based UI, but there's no screen inventory, no wireframes, no component breakdown. "Timeline dashboard" could mean a hundred different things.

**Action:** Add at minimum a `ui-screens.md` listing:
- Main screens/routes (dashboard, client list, project detail, scan detail, timeline, report view, scenario editor, settings)
- Key interactions per screen
- Rough wireframes or mockups if possible

---

## 7. Auth and RBAC Detail — Thin

The security controls mention Entra ID and RBAC with analyst/admin/auditor roles, but there's no permission matrix. What can an analyst do that an auditor can't? Can a client admin create agents but not approve reports?

**Action:** Add a permission matrix to the security controls doc:
- Roles: platform admin, client admin, security analyst, auditor (and any others)
- Resources: clients, projects, scans, scenarios, agents, reports, settings
- Permissions: create, read, update, delete, execute, approve

---

## 8. MVP Scope Cut — Not Defined

The plan describes the full vision but doesn't draw a line around what's in the MVP and what's deferred. Cloud sandbox validation, custom agents, advanced timeline analytics — are these Phase 1 or later?

**Action:** Add a `roadmap.md` or `mvp-scope.md` that explicitly lists:
- Phase 1 (MVP): exactly which features ship first
- Phase 2: what's next
- Deferred: what's intentionally out of scope for now

My suggestion for MVP scope:
- Client/project management + RBAC
- Scan orchestration wrapping 1-2 open-source tools
- Basic `.md` scenario execution
- Report generation with evidence storage
- Timeline view
- Core CI/CD and Azure deployment

Deferred to Phase 2+:
- Custom agent runtime
- Cloud sandbox validation
- Advanced audit log with hash chaining
- Multi-cloud support

---

## 9. Terraform Gaps

The Terraform is a good start but has a few issues:
- `variables.tf` has a default password (`ChangeMe123!`) — this should be removed, use Key Vault or pipeline secrets only
- No private endpoint configuration for PostgreSQL or Storage (the security controls doc says "use private networking for internal services")
- No WAF or front-door for the Container App ingress
- No database for the session DB or report index DB — only one PostgreSQL instance is defined
- Backend config has hardcoded placeholder values (`tfstateaccount`, `tfstate-rg`)

**Action:** Update the Terraform to align with the security controls doc, remove default secrets, and add TODO comments for the resources that aren't provisioned yet.

---

## 10. CI/CD Pipelines Are Stubs

Both the GitHub Actions and Azure Pipelines files are placeholder `echo` statements. That's fine for planning, but they should have TODO markers so it's clear what needs to be implemented.

**Action:** Add explicit TODO comments in the pipeline files for each stub step, referencing what tool or script should replace it.

---

## Summary

The planning foundation is strong. The main gaps are:
1. **Positioning** — say what this is and isn't, who it's for
2. **Scanner strategy** — wrap existing tools, don't build from scratch
3. **Scenario spec** — define the `.md` format
4. **Agent spec** — define the plugin model
5. **API contract** — can't code without it
6. **UI screen map** — can't build a frontend without it
7. **RBAC matrix** — can't implement auth without it
8. **MVP scope** — draw the line
9. **Terraform hardening** — align with security controls
10. **Pipeline TODOs** — mark the stubs

Once these are addressed, we're in a good position to start building. Let me know when you've updated and I'll start on the foundation.

Cheers
