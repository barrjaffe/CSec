# Architecture Specification

## 1. Overview
This platform is an internal pentest and security assessment system for APIs and application tooling. It is designed to:

- detect security risks in APIs and application code
- identify authentication and authorization weaknesses
- run exploit and scenario-based validation for common application threats
- generate evidence-backed findings reports
- store execution metadata and report references in a dedicated database
- support client-level customization through custom scenarios, agents, and test definitions

The solution is Azure-first and built to support future multi-cloud portability.

## 2. Primary Goals
1. Source and API Security Review
   - Analyze source code, API definitions, and application configuration artifacts
   - Identify security misconfigurations and exploitable patterns

2. Attack Simulation
   - Execute built-in pentest logic and custom scenario flows
   - Validate exploit paths in a controlled, non-production sandbox when applicable

3. Reporting and Auditability
   - Generate a detailed report for each test or execution
   - Persist evidence including:
     - time of execution
     - executing process
     - requesting user
     - score (1-10)
     - tested component
     - path to report

4. Client Customization
   - Allow clients to create custom `.md` scenarios
   - Add custom agents and test logic beyond the default engine
   - View progression across timeline-based test history

## 3. Architectural Scope
The system is composed of the following major areas:

- Client portal and user interface
- Python backend and orchestration services
- Scanner and scenario execution engine
- Cloud validation layer for Azure sandbox testing
- Findings and evidence storage
- Reporting engine and timeline analytics

## 4. Core Architecture Principles
- Keep the platform secure by default
- Isolate security testing from production workloads
- Use RBAC and managed identities for access control
- Prefer private networking and centralized monitoring
- Store findings and reports in a governed and auditable store
- Keep custom client scenarios flexible without breaking core scanning logic

## 5. Design Documentation
This overview is intentionally short. Detailed design documents are organized in architecture subfolders:

- `architecture/c4/` - C4 diagrams for context, container, and component views
- `architecture/design/` - detailed design and requirements documents

## 6. Initial Target Stack
- Frontend: Angular
- Backend: Python
- CI/CD: GitHub Actions
- Cloud: Azure-first
- Runtime: Azure Container Apps as the initial target
- Database: Azure SQL / PostgreSQL for execution metadata and findings
- Storage: Azure Storage for evidence and report files
- Secrets: Azure Key Vault

## 7. High-Level Flow
1. Security analyst or client admin initiates a scan or test
2. The platform pulls source, API, or config inputs
3. The scanner checks for risks and weak controls
4. Scenario engine runs built-in and custom tests
5. Results are normalized and stored with execution metadata
6. The reporting engine produces a detailed findings report
7. The UI presents the result and timeline view

## 8. Key Constraints
- Internal use for the MVP stage
- Public exposure planned only after appropriate governance and compliance review
- Testing should remain isolated from production systems and live customer workloads
- Custom test and agent logic must not compromise platform integrity

## 9. Detailed Design Files
- `architecture/c4/README.md`
- `architecture/design/functional-requirements.md`
- `architecture/design/security-controls.md`
- `architecture/design/reporting-and-evidence.md`
- `architecture/flows/README.md`
