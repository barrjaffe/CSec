# Scanner Engine Strategy

## Overview

The scanner engine is not a from-scratch detection engine. It is an **orchestration and normalization layer** that wraps and extends proven open-source tools and custom detection logic.

## Primary Tools

### 1. OWASP ZAP
- **Purpose:** API and web application vulnerability scanning
- **Integration:** REST API calls to ZAP proxy or passive scan
- **Output:** Vulnerabilities, authentication issues, weak configurations
- **Normalization:** Map ZAP findings to CSec internal finding format with CWE, severity, component

### 2. Semgrep
- **Purpose:** Static application security testing (SAST) and configuration analysis
- **Integration:** CLI invocation, custom rule bundling
- **Output:** Code-level issues, insecure patterns, policy violations
- **Normalization:** Map Semgrep findings to CSec format with source location and remediation guidance

### 3. Custom Detection Rules
- **Purpose:** Extend detection beyond what ZAP and Semgrep cover
- **Focus Areas:**
  - Client-specific API authentication patterns
  - Custom business logic flaws
  - Industry-specific compliance checks
  - Integration with internal tooling

## Tool Pluggability Strategy

The client admin portal allows clients to:

- enable or disable ZAP, Semgrep, or custom rules
- select which rule sets or templates to run
- add custom detection logic or modify existing rules
- define which tools run on a per-project or per-scan basis

**Implementation:**
- `tool_config` table in the main app DB
- scanner orchestrator reads config and loads/chains tools dynamically
- normalized findings converge in the session database
- report engine produces unified output

## Findings Normalization

All scanner outputs are mapped to a unified format:

```
{
  finding_id: UUID,
  scan_run_id: UUID,
  tool_source: "ZAP" | "Semgrep" | "custom",
  component: string,
  title: string,
  severity: "critical" | "high" | "medium" | "low",
  cwe: string,
  description: text,
  remediation: text,
  evidence: string or URI,
  timestamp: datetime
}
```

## Scanner Execution Flow

1. Job starts, loads scan config (tools, rules, targets)
2. Orchestrator spawns ZAP, Semgrep, or custom detectors in parallel or sequence
3. Each tool produces output in its native format
4. Normalizer maps findings to unified schema
5. Session database stores raw and normalized findings
6. Report engine consumes normalized findings for report generation

## Custom Detection Approach

Custom detection is added through:

- YAML or JSON rule files (Semgrep-compatible format)
- Python helper scripts for tool-specific extensions
- Webhook agents that call external detection endpoints
- Client-provided detection modules (vetted and sandboxed)

## Out of Scope for MVP

- Machine learning-based findings (add in Phase 2+)
- Integration with commercial tools (Burp Pro, SentinelOne, etc.) beyond open-source equivalents
- Real-time continuous scanning (batch-based only)

## Success Criteria

- Scanner can normalize findings from ZAP and Semgrep into unified format in <1 min per tool
- Custom rules can be added/modified without restarting the platform
- False positive rate <5% for standard rules
- Support for adding new tools via pluggable architecture within 2 weeks
