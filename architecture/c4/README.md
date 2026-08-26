# C4 Architecture

This folder contains the C4-based architecture model for the pentest platform.

## 1. System Context
```mermaid
C4Context
    title Pentest Platform - System Context

    Person(user, "Security Analyst", "Creates scans, reviews findings, and approves pentest actions")
    Person(admin, "Client Admin", "Manages clients, users, scenarios, agents, and portfolios")
    System(pentest, "Pentest Platform", "Finds risks and exploitable paths in APIs and applications, generates reports, and stores execution evidence")
    System_Ext(repo, "Source Repository", "Application code, API definitions, and config assets under assessment")
    System_Ext(db, "Target Database", "Application database under evaluation in sandbox or controlled test scope")
    System_Ext(cloud, "Cloud Environment", "Azure sandbox or test environment for workload validation")

    Rel(user, pentest, "Runs scans and reviews results")
    Rel(admin, pentest, "Defines users, custom scenarios, and agent policies")
    Rel(pentest, repo, "Fetches and analyzes source and config")
    Rel(pentest, db, "Tests configuration and access patterns in sandbox mode")
    Rel(pentest, cloud, "Validates cloud posture and target workloads")
```

## 2. Container View
```mermaid
C4Container
    title Pentest Platform - Container View

    Person(user, "Security Analyst", "Runs scans and reviews evidence")
    Person(admin, "Client Admin", "Manages scenarios, agents, and client settings")

    System_Boundary(c1, "Pentest Platform") {
        Container(web, "Client Portal", "Angular", "Client management, timeline views, scan orchestration, and reporting dashboard")
        Container(api, "Pentest API", "Python", "Handles authentication, project orchestration, API scan requests, and job dispatch")
        Container(scanner, "Scanner Engine", "Python", "Detects API risks, auth gaps, bad patterns, and exploit candidates")
        Container(scenario, "Scenario Engine", "Python", "Runs custom client-defined scenarios, agent workflows, and test templates")
        Container(report, "Reporting Service", "Python", "Builds reports and evidence packages")
        Container(data, "Findings Database", "PostgreSQL / Azure SQL", "Stores evidence, test metadata, execution history, scores, and report metadata")
        Container(store, "Artifact Store", "Azure Storage", "Stores report files, logs, generated evidence packages, and test outputs")
        Container(queue, "Execution Queue", "Message Broker / Background Jobs", "Manages async test execution")
    }

    System_Ext(repo, "Source Repository", "API definitions, code, and configuration under review")
    System_Ext(cloud, "Azure Sandbox", "Isolated environment for workload validation")

    Rel(user, web, "Uses portal to initiate pentests and view progress")
    Rel(admin, web, "Defines custom .md scenarios and user or client settings")
    Rel(web, api, "Sends scan requests and retrieves results")
    Rel(api, queue, "Schedules scan jobs")
    Rel(queue, scanner, "Dispatches scan and evaluation tasks")
    Rel(queue, scenario, "Dispatches client-defined scenario sequences")
    Rel(scanner, repo, "Reads source, config, and API definitions")
    Rel(scenario, cloud, "Executes test flows against isolated target workloads")
    Rel(scanner, report, "Publishes raw findings")
    Rel(scenario, report, "Publishes scenario results")
    Rel(report, data, "Writes execution metadata, score, component, path to report, and user context")
    Rel(report, store, "Stores PDF/HTML reports and evidence bundles")
    Rel(data, web, "Displays timeline and historical scan records")
```

## 3. Component View
```mermaid
C4Component
    title Pentest Platform - Component View

    Container_Boundary(c1, "Pentest Platform") {
        Component(portal, "Client Portal", "Angular SPA", "Manages clients, custom scenarios, agents, and execution timeline")
        Component(gateway, "API Gateway", "Python REST API", "Authenticates users, routes requests, and enforces RBAC")
        Component(jobsvc, "Job Orchestrator", "Python Service", "Creates test jobs, queues executions, and tracks status")
        Component(policy, "Client Policy Manager", "Python Service", "Stores client-specific scenario definitions, agent definitions, and test policies")
        Component(scanner, "API / App Scanner", "Python Service", "Finds insecure endpoints, auth gaps, weak configs, and exploit candidates")
        Component(agent, "Agent Runtime", "Python Service", "Executes custom agent logic and scenario workflows")
        Component(reportgen, "Report Generator", "Python Service", "Compiles findings, scorecards, and evidence into final reports")
        Component(db, "Execution Evidence Store", "PostgreSQL", "Stores: timestamp, execution process, requesting user, score, tested component, and path to report")
        Component(artifact, "Artifact Vault", "Azure Storage", "Stores generated report files and evidence bundles")
        Component(timeline, "Timeline Service", "Python Service", "Aggregates execution history for progression and status visualization")
    }

    Rel(portal, gateway, "Sends scan requests, scenario definitions, and dashboard queries")
    Rel(gateway, jobsvc, "Creates and dispatches pentest jobs")
    Rel(policy, agent, "Provides custom .md scenarios, agents, and test modules")
    Rel(jobsvc, scanner, "Runs default security checks")
    Rel(jobsvc, agent, "Runs client-defined or custom agent logic")
    Rel(scanner, reportgen, "Sends findings and metadata")
    Rel(agent, reportgen, "Sends custom scenario results")
    Rel(reportgen, db, "Writes execution record with time, process, user, score, component, and report path")
    Rel(reportgen, artifact, "Stores final reports and attachments")
    Rel(timeline, db, "Reads chronology of tests and progression")
    Rel(portal, timeline, "Shows advancement across time")
```

## 4. Design Notes
- The portal is the user-facing control plane for managing tests, clients, and scenarios.
- The backend orchestrates jobs and routes results to the reporting and evidence services.
- Custom `.md` scenarios and agent definitions are first-class extensions to the default pentest engine.
- Execution history is tracked by timeline and stored in a structured evidence database.
- All results must be attributable to a user, process, and time of execution for audit purposes.
