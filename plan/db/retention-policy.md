# Data Retention and Privacy Policy

## Purpose
This document defines the retention and privacy rules for the database layers used by the pentest platform.

## 1. Main App Database
Retention:
- operational data retained for platform lifetime or business need
- user and account records retained according to account lifecycle policies
- project and scan metadata retained according to client and platform policy

Sensitive data rule:
- no raw sensitive test data, source code, or secrets should be stored here

## 2. Session Database
Retention:
- short-lived, per-run only
- default auto-delete after completion or after a defined retention window such as 24–72 hours
- extendable only with explicit approval and legal review

Sensitive data rule:
- raw findings, runtime artifacts, and interim execution data remain here only during the active or post-run review window

## 3. Artifact Store
Retention:
- preserve finalized, sanitized evidence and reports according to approved client policy
- apply structured retention windows with encryption and deletion controls

Sensitive data rule:
- keep only redacted, approved artifacts
- remove or purge unapproved payloads immediately

## 4. Audit Log Store
Retention:
- retain according to compliance and accountability policy
- preserve tamper-evident logs for regulated review scenarios

Sensitive data rule:
- keep log metadata minimal and redacted
- avoid logging raw secrets or sensitive request content

## 5. Report Index Database
Retention:
- retain report metadata, status, and references according to configured retention rules
- support lifecycle states such as active, archived, deleted, and expired

Sensitive data rule:
- store summary-level and sanitized records only
- keep detailed findings separate from the core report index when needed

## 6. General Principle
If the data could expose client secrets, private source code, internal infrastructure, or exploit details, it should not be retained in the main operational database without explicit sanitization and policy approval.

## 7. Recommended Defaults
- Session DB: 24–72 hours max, then auto-delete
- Artifact Store: retention aligned to client contract and compliance policy
- Audit Logs: longer-term retention for accountability, but minimal metadata only
- Report Index: long enough for client review and historical access, based on approved retention rules
