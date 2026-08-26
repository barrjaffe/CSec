# Artifact Store

## Purpose
The artifact store is the secure location for generated and retained evidence that has been reviewed, redacted, and approved for retention.

## Contents
This store should hold:

- final report files
- sanitized evidence bundles
- HTML/PDF export files
- redacted screenshots or excerpts
- generated analysis outputs
- archived report objects and references

## Storage Rules
- encrypted at rest
- restricted access by role and policy
- write-once or append-mostly pattern where possible
- separated from the main operational database
- linked through a report index or report metadata record

## Not Stored Here
- raw secrets
- active session payloads
- unapproved exploit code
- source code snapshots that are not explicitly allowed
- full customer data dumps

## Recommended Layout
- `clients/{client_id}/projects/{project_id}/runs/{run_id}/reports/`
- `clients/{client_id}/projects/{project_id}/runs/{run_id}/evidence/`
- `clients/{client_id}/projects/{project_id}/reports/`

## Retention and Governance
The artifact store must be managed with:

- retention windows
- access reviews
- integrity hashes for artifacts
- deletion workflows after expiry
- secure archival handling for compliance scenarios
