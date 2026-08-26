# Audit Log Store

## Purpose
The audit log store records the control-plane activity of the pentest platform for accountability, traceability, and forensic readiness.

## Contents
This store should record:

- who performed an action
- which process or job executed the action
- when the action occurred
- what object was changed or accessed
- whether the action was approved or rejected
- integrity hashes for tamper detection

## Design Rules
- append-only
- access-controlled
- tamper-evident
- minimal and redacted whenever possible
- separate from the operational database and temporary session stores

## Typical Event Types
- account created
- project created
- scan started
- scan completed
- report generated
- report approved
- artifact archived
- session expired
- access denied
- suspicious action detected

## What Not to Store
- raw source code
- developer secrets
- token values
- database credentials
- customer private content
- unredacted exploit payloads

## Security Notes
- Use cryptographic integrity checks or hash chaining where possible
- Store metadata rather than full payloads
- Retain logs according to internal compliance and retention policies
- Restrict write access to the platform core services only
