# Agent Specification

## Purpose

Agents are external, ephemeral processes that extend CSec with custom pentest logic. They are invoked via webhooks and are stateless, short-lived, and sandboxed.

## Agent Model

### Webhook-Based

Agents are HTTP endpoints that CSec invokes with a request payload. The agent processes the request, performs testing or analysis, and returns a response.

**Agent Lifecycle:**
1. CSec orchestrator determines an agent needs to run (from scenario or custom config)
2. Orchestrator fetches agent endpoint URL and credentials from policy store
3. Orchestrator makes HTTP POST request to agent webhook
4. Agent processes request asynchronously or synchronously
5. Agent responds with findings, score, and evidence
6. Orchestrator stores response in session database and continues

### Lightweight and Ephemeral

- Agents are not managed or versioned by the platform
- Agents can be hosted anywhere (customer's own infra, cloud function, container, on-prem tool)
- Agents can be created, modified, or deleted without platform deployment
- No persistent agent registry in CSec beyond the webhook endpoint URL and auth

## Agent Interface

### Request Format

```json
{
  "agent_id": "uuid",
  "scenario_execution_id": "uuid",
  "scan_run_id": "uuid",
  "client_id": "uuid",
  "action": "pentest" | "check" | "validate",
  "target": {
    "url": "https://api.example.com",
    "method": "GET" | "POST",
    "headers": {Authorization: "Bearer token"},
    "body": {}
  },
  "context": {
    "variables": {API_KEY: "...", USER_ID: 123},
    "previous_findings": [{finding_id: "...", score: 7}]
  },
  "timeout_seconds": 300
}
```

### Response Format

```json
{
  "agent_id": "uuid",
  "scenario_execution_id": "uuid",
  "status": "success" | "error" | "timeout",
  "findings": [
    {
      "title": "API Key Exposure",
      "severity": "high",
      "component": "auth_endpoint",
      "description": "API key found in response headers",
      "evidence": "Authorization header contains hardcoded key",
      "remediation": "Remove key from response, use proper token handling"
    }
  ],
  "score_adjustment": 2,  // + or - adjustment to overall score
  "execution_time_ms": 1234,
  "raw_log": "optional debug output"
}
```

## Example Agent

### Python Webhook Agent

```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/pentest", methods=["POST"])
def pentest():
    payload = request.json
    target = payload["target"]
    
    # Perform custom pentest logic
    findings = []
    
    # Example: Check for exposed API keys
    response = make_request(target)
    if "api_key" in response.headers or "secret" in response.text:
        findings.append({
            "title": "Potential Secret Exposure",
            "severity": "critical",
            "component": target["url"],
            "description": "Suspicious string patterns detected in response",
            "evidence": "Response contains 'api_key' or 'secret' keywords",
            "remediation": "Audit response content and remove sensitive data"
        })
    
    return jsonify({
        "agent_id": payload["agent_id"],
        "status": "success",
        "findings": findings,
        "score_adjustment": len(findings) * 2
    })

def make_request(target):
    # Use requests library to call target
    pass

if __name__ == "__main__":
    app.run(port=5000)
```

## Agent Registration

Agents are registered in the CSec portal per client:

**Endpoint:**
```
POST /api/v1/clients/{client_id}/agents
{
  "name": "Custom Auth Validator",
  "webhook_url": "https://my-tool.company.com/pentest",
  "auth_type": "bearer" | "api_key" | "basic",
  "auth_secret": "{{ STORED_IN_KEY_VAULT }}",
  "timeout_seconds": 300,
  "tags": ["auth", "custom"]
}
```

## Execution from Scenarios

Agents can be invoked from scenario files:

```yaml
steps:
  - name: "Run custom auth validator"
    method: agent
    action: invoke
    agent_name: "Custom Auth Validator"
    target: login_endpoint
    on_error: "continue"
```

## Security and Sandboxing

- Agents receive only the data they need (target, context, variables)
- Agents cannot access other client data or findings
- Credentials are passed at invocation time, never stored in the agent
- Agent responses are sanitized before storage
- CSec enforces request/response size limits (e.g., <10MB)
- Execution time is bounded (timeout enforced)

## Monitoring and Audit

- Each agent invocation is logged with actor, timestamp, and outcome
- Agent latency and error rates are tracked
- Agents that fail repeatedly are flagged for review

## Out of Scope for MVP

- Agent versioning and rollback
- Mutual TLS or advanced auth schemes
- Agent marketplace or public registry
- Metrics and analytics per agent
