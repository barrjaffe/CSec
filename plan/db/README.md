# Database and Privacy Design

This document defines the data storage model for the pentest platform with privacy-first handling and strict separation between operational metadata and sensitive execution data.

## 1. Core Storage Model

### 1.1 Main App Database
The main application database stores operational and control-plane data that is required to manage the platform itself.

It includes:
- accounts
- projects
- clients
- roles
- scan metadata
- audit metadata

This database must not contain raw sensitive test payloads, secrets, exploit code, or unredacted evidence payloads.

### 1.2 Session Database
Each pentest run creates an isolated, ephemeral, encrypted session database or schema.

It is used for:
- raw findings generated during active execution
- intermediate results
- temporary artifacts before sanitization
- execution logs tied to a single session
- temporary workspace state for the pentest engine

The session database is short-lived and auto-deleted after retention expiry or after the report is finalized and archived.

### 1.3 Artifact Store
The artifact store holds encrypted evidence and final approved documents.

It includes:
- encrypted evidence vault
- final report files
- sanitized artifacts
- redacted screenshots or extracts
- export packages

Artifacts must be protected by storage policies and access controls.

### 1.4 Audit Log Store
The audit log store is append-only and tamper-evident.

It records:
- who performed actions
- which process initiated execution
- when the action occurred
- what object was affected
- whether the action was approved or rejected

It must avoid storing raw sensitive payloads and sensitive secrets.

### 1.5 Report Index Database
The report index database keeps the final summary and reporting metadata needed for access, governance, and timeline display.

It stores:
- report id
- status
- summary
- links to artifact storage
- hash values for integrity
- retention rules
- project and client relationship metadata

## 2. Design Principle
The platform must follow strict separation between:

- sensitive execution data and raw evidence
- approved, sanitized final report objects
- operational metadata required for product management
- audit and compliance records

This avoids embedding sensitive client data into the system-of-record database and significantly reduces breach impact.

## 3. Data Retention Strategy
- Temporary session databases should be auto-deleted after the report is closed or the retention window is reached
- Report summaries should remain in the permanent index database according to approved retention policies
- Evidence artifacts should have controlled lifecycle rules and secure deletion phases
- Audit logs should be retained for compliance and accountability, but must remain minimal and redacted

## 4. Privacy-Safe Rule
If data could reveal client secrets, source code, exploit path details, or internal architecture details, it should not live permanently in the main application database unless it has been sanitized, classified, and approved for retention.

## 5. Recommended Pattern
A strong design for this platform is:

- Main app DB: operational metadata only
- Session DB: temp, encrypted, per-run, auto-delete
- Artifact store: encrypted evidence + final reports
- Audit log store: append-only, access-controlled
- Report index DB: final summaries, references, and retention metadata

This is the safest and most scalable pattern for a security assessment platform.

## 6. Structure

- `main-app-db/` — operational platform database
- `session-db/` — per-run encrypted temporary execution database
- `artifact-store/` — encrypted evidence and final report objects
- `audit-log-store/` — append-only audit trail
- `schema/` — schema definitions for the persistent system
  - `schema/preliminary-db-schema.md`
  - `schema/reports/` — reports and evidence metadata schema
- `retention-policy.md` — retention, deletion, and privacy policy
