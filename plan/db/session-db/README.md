# Session Database

## Purpose
The session database is a short-lived, isolated workspace created for each pentest run. It stores the active execution state, intermediate raw findings, and temporary evidence generated during the scan lifecycle.

## Contents
This database should hold:

- active execution metadata
- raw findings before sanitization
- intermediate scan results
- temporary working artifacts
- per-run log output
- runtime state for custom scenario and agent execution

## Design Rules
- created per run or per project job
- encrypted at rest and in transit
- isolated from the main application database
- automatically deleted after retention expiry or after final report approval
- not used for long-term business records

## Typical Tables
- `session_metadata`
- `raw_findings`
- `session_logs`
- `session_artifacts`
- `execution_status`

## Exclusions
This database must not be the long-term source of truth for:

- client accounts
- user roles
- report summaries
- retained audit records
- approved findings metadata

## Lifecycle
1. Job starts
2. Session database is provisioned
3. Raw evidence is written during execution
4. Findings are sanitized and normalized
5. Final report is generated and approved
6. Session is closed and deleted or archived according to policy

## Security Notes
- Use isolated storage or a dedicated tenant-scoped schema
- Access should be restricted to the orchestrator, scanning engine, and authorized report service
- Data expiration should be automatic and auditable
- Ensure the database is destroyed or wiped after retention expiry
