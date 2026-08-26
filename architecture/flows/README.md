# Flow Diagrams

This folder contains sequence diagrams that describe the core business flows of the pentest platform.

## 1. Scan Execution Flow
```mermaid
sequenceDiagram
    actor Analyst as Security Analyst
    participant Portal as Client Portal
    participant API as Pentest API
    participant Orchestrator as Job Orchestrator
    participant Scanner as API/App Scanner
    participant Scenario as Scenario Engine
    participant Report as Reporting Service
    participant DB as Execution Evidence Store
    participant Storage as Artifact Store

    Analyst->>Portal: Request a scan / test execution
    Portal->>API: Send scan configuration and target metadata
    API->>Orchestrator: Create execution job
    Orchestrator->>Scanner: Start built-in security scan
    Orchestrator->>Scenario: Start custom/customized testing flow
    Scanner-->>Orchestrator: Findings and raw evidence
    Scenario-->>Orchestrator: Scenario results and execution notes
    Orchestrator->>Report: Compile findings and produce report
    Report->>DB: Store execution metadata (time, user, score, component, report path)
    Report->>Storage: Save report artifacts and evidence bundle
    Report-->>Portal: Return report summary and references
    Portal-->>Analyst: Show result and timeline update
```

## 2. Custom Scenario Flow
```mermaid
sequenceDiagram
    actor ClientAdmin as Client Admin
    participant Portal as Client Portal
    participant API as Pentest API
    participant Policy as Client Policy Manager
    participant Agent as Agent Runtime
    participant Orchestrator as Job Orchestrator
    participant Report as Reporting Service
    participant DB as Execution Evidence Store

    ClientAdmin->>Portal: Create custom .md scenario
    Portal->>API: Save scenario definition
    API->>Policy: Store scenario metadata and rules
    ClientAdmin->>Portal: Trigger scenario execution
    Portal->>API: Execute custom scenario request
    API->>Orchestrator: Queue job
    Orchestrator->>Agent: Run custom agent logic
    Agent-->>Orchestrator: Scenario outcome and evidence
    Orchestrator->>Report: Build scenario report
    Report->>DB: Persist time, user, score, component, report path
    Report-->>Portal: Return custom test result
    Portal-->>ClientAdmin: Display timeline and findings
```

## 3. Timeline Progression Flow
```mermaid
sequenceDiagram
    actor User as Analyst or Client Admin
    participant Portal as Client Portal
    participant API as Pentest API
    participant Orchestrator as Job Orchestrator
    participant Timeline as Timeline Service
    participant DB as Execution Evidence Store

    User->>Portal: Open scan timeline dashboard
    Portal->>API: Request execution history
    API->>Orchestrator: Fetch jobs and status for client/project
    Orchestrator->>Timeline: Aggregate progress data
    Timeline->>DB: Query execution records and status metadata
    DB-->>Timeline: Records including time, score, component, user, report path
    Timeline-->>Portal: Timeline entries and progression details
    Portal-->>User: Display status progression and test history
```

## 4. Report Generation Flow
```mermaid
sequenceDiagram
    participant Scanner as Scanner / Scenario Engine
    participant Report as Reporting Service
    participant DB as Execution Evidence Store
    participant Storage as Artifact Store
    participant Portal as Client Portal

    Scanner->>Report: Send findings, score, tested component, test metadata
    Report->>Report: Normalize evidence and generate final report
    Report->>DB: Store execution record
    Report->>Storage: Save final report file and evidence bundle
    Report-->>Portal: Send summary and links to report artifacts
    Portal-->>User: Present final findings and timeline update
```

## 5. Cloud Sandbox Validation Flow
```mermaid
sequenceDiagram
    actor Analyst as Security Analyst
    participant Portal as Client Portal
    participant API as Pentest API
    participant Orchestrator as Job Orchestrator
    participant Sandbox as Azure Sandbox Validation
    participant Cloud as Azure Environment
    participant Report as Reporting Service

    Analyst->>Portal: Trigger cloud validation or exploratory check
    Portal->>API: Send validation request
    API->>Orchestrator: Create sandbox-based test job
    Orchestrator->>Sandbox: Run targeted validation workflow
    Sandbox->>Cloud: Validate posture, exposure, and permissions
    Cloud-->>Sandbox: Findings and validation results
    Sandbox-->>Orchestrator: Sanitized test outcomes
    Orchestrator->>Report: Package findings for report
    Report-->>Portal: Return results and recommendations
    Portal-->>Analyst: Display validated cloud findings
```

## 6. Notes
These flows capture the platform’s main lifecycle:

- start a scan or custom test
- run built-in or custom logic
- produce structured evidence
- save execution metadata in the database
- render the result and progression timeline to the client portal
