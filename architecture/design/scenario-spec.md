# Scenario Specification

## Purpose

Scenarios are scripted pentest workflows that clients can author, version, and execute via the CSec platform. They enable repeatable attack flows without requiring Python or platform code changes.

## Scenario Format

Scenarios are written in a simple, imperative YAML-based scripting language. Each scenario file defines a sequence of test steps that are executed serially or in parallel.

## Example Scenario

```yaml
scenario:
  name: "API Authentication Bypass Test"
  description: "Attempts common auth bypass patterns against API endpoints"
  version: "1.0"
  tags: [auth, api, critical]
  
targets:
  - name: "auth_endpoint"
    url: "{{API_BASE_URL}}/auth/login"
    
  - name: "protected_endpoint"
    url: "{{API_BASE_URL}}/api/user/profile"

steps:
  - name: "Test 1: Missing Auth Header"
    method: HTTP
    action: request
    target: protected_endpoint
    headers: {}
    expect_status: 401
    score_if_fail: 5  # Penalizes if we don't see a 401
    
  - name: "Test 2: Invalid Token"
    method: HTTP
    action: request
    target: protected_endpoint
    headers:
      Authorization: "Bearer invalid_token_12345"
    expect_status: 401
    score_if_fail: 4
    
  - name: "Test 3: Token Replay"
    method: HTTP
    action: request
    target: protected_endpoint
    headers:
      Authorization: "Bearer {{STORED_VALID_TOKEN}}"
    expect_status: 200
    assert: "response.statusCode == 200"
    capture_var: "auth_valid"
    
  - name: "Test 4: JWT Manipulation"
    method: HTTP
    action: jwt_decode
    token_source: "{{STORED_VALID_TOKEN}}"
    capture_var: "decoded_jwt"
    
  - name: "Test 5: Check JWT Signature"
    method: validation
    action: check_signature
    token: "{{decoded_jwt}}"
    expect: "signature_valid"
    score_if_fail: 8  # High score if signature check is missing
    
scoring:
  initial_score: 5
  max_score: 10
  deductions:
    - test: "Test 1"
      if_pass: -2
    - test: "Test 2"
      if_pass: -2
    - test: "Test 3"
      if_pass: -1
  final_score_logic: "min(10, initial_score - total_deductions)"

report:
  title: "Authentication Bypass Assessment"
  finding_category: "broken-authentication"
  severity_if_score_above_7: "critical"
  severity_if_score_above_5: "high"
  severity_if_score_below_5: "medium"
```

## Step Types

### HTTP Request
```yaml
- name: "step name"
  method: HTTP
  action: request
  target: endpoint_name
  headers: {Authorization: "Bearer token"}
  body: {key: value}  # optional
  expect_status: 200
  assert: "response.statusCode == 200"  # optional
  capture_var: "variable_name"  # optional, captures response
  retry: 3  # optional, retry count
```

### JWT Operations
```yaml
- name: "Decode JWT"
  method: HTTP
  action: jwt_decode
  token_source: "{{TOKEN_VAR}}"
  capture_var: "decoded_payload"
```

### Validation
```yaml
- name: "Check assertion"
  method: validation
  action: assert
  expression: "{{decoded_payload.aud}} == 'my-app'"
  expect: true
  score_impact: 3  # if assertion fails, impact score
```

### Wait/Delay
```yaml
- name: "Wait for eventual consistency"
  method: control
  action: wait
  seconds: 5
```

### Conditional
```yaml
- name: "If auth_valid, proceed"
  method: control
  action: if_then
  condition: "{{auth_valid}} == true"
  then:
    - name: "Privileged action"
      method: HTTP
      action: request
      target: admin_endpoint
```

## Variable Injection

Variables are injected at runtime from:
- Client configuration (credentials, URLs, API keys)
- Environment variables
- Previous step outputs
- Scenario parameters

Example:
```yaml
# Defined in project settings or passed at runtime
# API_BASE_URL=https://api.example.com
# ADMIN_TOKEN=eyJhbGc...
# USER_ID=12345

steps:
  - name: "Call admin endpoint"
    target: "{{API_BASE_URL}}/admin/users/{{USER_ID}}"
    headers:
      Authorization: "Bearer {{ADMIN_TOKEN}}"
```

## Assertions and Scoring

Each step can define assertions and score impacts:

```yaml
assert: "response.statusCode == 403"  # boolean expression
score_if_pass: 2      # reduce final score if assertion passes (finding is good)
score_if_fail: 5      # increase final score if assertion fails (finding is bad)
```

Final score calculation:
```
initial_score = 5
for each step:
  if step passes and score_if_pass defined:
    score -= score_if_pass
  if step fails and score_if_fail defined:
    score += score_if_fail
final_score = clamp(score, 1, 10)
```

## Execution Context

- Scenarios run in isolated execution contexts with no access to platform internals
- Credentials are fetched from Key Vault at runtime, never logged or stored
- HTTP requests go through a proxy/controlled channel for inspection
- Steps execute in order unless marked as parallel

## Error Handling

```yaml
on_error: "continue" | "stop" | "skip_remaining"
# continue: log error and continue to next step
# stop: fail scenario and stop execution
# skip_remaining: skip remaining steps, mark scenario as incomplete
```

## Scenario Versioning and Storage

- Scenarios stored in `clients/{client_id}/scenarios/`
- Filenames: `scenario-name-v1.0.yaml`
- Version history retained for audit
- Client can rollback to previous versions

## Security Boundaries

- Scenarios cannot access other client data or secrets
- Scenarios cannot modify platform configuration
- Scenario execution is logged with actor and timestamp
- Scenarios are parsed and validated before execution
- No shell command execution or code evaluation allowed
