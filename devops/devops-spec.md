# DevOps Specification

## 1. Objective
This document defines the DevOps operating model for a cyber-security assessment platform that scans source code, validates database configuration patterns, simulates attack scenarios, and produces evidence-backed findings reports.

The design is Azure-first with multi-cloud readiness, GitHub Actions-based delivery, and a secure, isolated environment model for internal development and future public exposure.

## 2. Operating Principles
- infrastructure as code for all environments
- security checks as part of the delivery pipeline
- immutable infrastructure where feasible
- least-privilege access and managed identities
- isolated and governed environments for development and testing
- traceable, evidence-backed findings and operational records

## 3. DevOps Lifecycle
### 3.1 Source Control
Recommended branch model:

- `main` for release-ready code
- `develop` for integrated work
- `feature/*` for new features
- `bugfix/*` for issue resolution
- `hotfix/*` for emergency changes

### 3.2 Environment Model
- Dev: internal development and sandbox validation
- Test: automated validation and regression checks
- Demo: stakeholder / demonstration environments
- Pre-Prod: future release-grade environment (planned later)

### 3.3 Deployment Model
- Terraform-managed Azure infrastructure
- GitHub Actions pipeline for CI/CD
- Container-based app deployment preferred for portability and consistency
- Blue/green or rolling deployment strategy for future production-like stages

## 4. Security in the Pipeline
### 4.1 Mandatory Gates
The pipeline will include, at minimum:

- linting and static analysis
- dependency vulnerability checks
- secret scanning
- IaC validation
- unit and integration tests
- security review approval for sensitive changes

### 4.2 Required Controls
- Use OIDC or managed identity instead of long-lived cloud credentials
- Store sensitive values in GitHub Actions secrets or Azure Key Vault
- Protect `main` and release branches with required reviews
- Require approvals for demo or production-like environments
- Log all infrastructure changes and application deployments
- Maintain versioned approval trails for security-relevant changes

## 5. Terraform IaC Baseline
Infrastructure is defined through Terraform and provisioned in a controlled, repeatable manner.

### 5.1 Core Azure Resources
Baseline infrastructure should include:

- Resource Group
- Virtual Network and subnets
- Key Vault for secrets and certificates
- Log Analytics Workspace
- Application Insights
- Container Apps environment
- Storage account for artifacts and evidence
- Azure PostgreSQL / SQL database for metadata and report persistence
- Managed identity for service-to-service authentication
- Private endpoints or network restrictions for sensitive services

### 5.2 State Management
- Use a remote Terraform backend in Azure Storage with locking enabled
- Keep state protected via RBAC and storage controls
- Avoid storing long-lived secrets in Terraform state files
- Separate state per environment (dev, test, demo, pre-prod)

### 5.3 IaC Policy Requirements
- Tag all resources with ownership, environment, and cost metadata
- Use reusable modules for common patterns
- Validate drift and configuration changes regularly
- Avoid hardcoded credentials or secrets in IaC files

## 6. Operational Runbooks
### 6.1 Deployment Runbook
1. Confirm project branch and target environment
2. Run linting, code checks, and dependency validation
3. Run Terraform validation and plan
4. Approve environment-specific deployment workflow
5. Apply infrastructure changes via Terraform
6. Deploy application workloads through GitHub Actions
7. Verify service health, logs, and security telemetry
8. Record release details and post-deployment checks

### 6.2 Incident Response Runbook
1. Identify the impacted service, environment, or data set
2. Freeze deployment activity and isolate the affected workload
3. Review logs, alerts, and network telemetry
4. Rotate any leaked or compromised credentials
5. Validate the blast radius and determine whether rollback is required
6. Record the incident and update remediation tasks

### 6.3 Backup and Recovery
- Protect Terraform state, app configuration, and runtime artifacts
- Maintain database backup policies appropriate to the environment type
- Define restore steps for application deployment and stored findings
- Test recovery flow periodically

## 7. Monitoring and Observability
- centralize application, infrastructure, and security logs
- alert on failed deployments, secret usage anomalies, suspicious access, and unusual scan activity
- track application health, error rates, and dependency drift
- provide dashboards for operational and security visibility across all active environments

## 8. Access Model
- Platform admin: infrastructure and environment access
- Developer: application feature and code work
- Security analyst: findings review and report review access
- Auditor: read-only access to approved evidence

Use RBAC and separate Azure/GitHub role groups for each persona.

## 9. GitHub Actions Delivery Pipeline
Recommended stages:

1. `lint`
2. `unit-test`
3. `dependency-scan`
4. `secret-scan`
5. `terraform-validate`
6. `terraform-plan`
7. `integration-test`
8. `deploy-dev`
9. `deploy-test`
10. `deploy-demo`
11. `manual-approval`
12. `deploy-preprod` (future)

## 10. Tooling Recommendation
- Source control: GitHub
- CI/CD: GitHub Actions
- IaC: Terraform
- Frontend: Angular
- Backend: Python
- Containerization: Docker
- Runtime: Azure Container Apps (initial recommendation)
- Logging: Log Analytics and Application Insights
- Secret management: Azure Key Vault
- Security scanning: dependency analyzers, secret scanners, static analysis, IaC validation, and custom rules

## 11. Risks and Constraints
- This platform processes security-relevant data and should remain internal while development is ongoing
- Attack scenarios must remain isolated from production assets and real customer workloads
- Cloud permission scopes must be tightly controlled and environment-specific
- Future compliance requirements must be incorporated before broad public exposure or regulated customer usage

## 12. Open Questions / Deferred Decisions
- final runtime choice: Container Apps vs App Service vs AKS
- exact storage and database sizing for the MVP
- whether demo environments are fully ephemeral or persistent
- exact compliance roadmap for public release and audit requirements
- how much cloud validation will be included in Phase 1 versus later phases

## 13. Initial Recommendation
Use a secure MVP delivery model with:

- GitHub-based source management
- Terraform-based Azure provisioning
- Angular frontend and Python backend
- Azure Container Apps as the preferred runtime for the first release
- managed identity, Key Vault, and centralized monitoring
- strong environment separation between Dev, Test, and Demo

This is the minimum viable foundation for secure platform delivery with a safe path to expanded scanning, cloud validation, and later public exposure.
