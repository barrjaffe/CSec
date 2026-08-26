# Main App Database

## Purpose
The main application database stores operational and control-plane data required to run the pentest platform itself.

## Content
This database is intended to retain only platform metadata and business records, including:

- accounts
- clients
- projects
- roles and permissions
- scan run metadata
- audit metadata
- report references and status metadata

## Exclusions
This database must not hold:

- raw source code
- full request/response payloads
- API secrets or credentials
- database credentials
- tokens or session secrets
- unredacted exploit traces
- raw evidence payloads requiring privacy-safe handling

## Design Rule
The main app database is the system-of-record for platform operations, not the repository for sensitive testing data.

## Recommended Tables
- `clients`
- `projects`
- `accounts`
- `roles`
- `scan_runs`
- `audit_events`

## Privacy and Security Notes
- Access must be strictly RBAC-controlled
- Data should be encrypted at rest and in transit
- Retention should follow operational policy, not raw testing retention
- Long-lived sensitive artifacts should not be stored here
