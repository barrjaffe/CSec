# Security Controls

## 1. Identity and Access
- Use Microsoft Entra ID or equivalent enterprise identity controls
- Enforce MFA and privilege separation
- Use managed identities for service-to-service communication
- Apply least privilege for all platform services and pipelines

## 2. Network and Isolation
- Restrict ingress to approved endpoints only
- Use private networking for internal services and sensitive data stores
- Keep cloud validation in isolated Azure sandbox environments
- Use gateways, WAF, or similar controls only where required by the deployment stage

## 3. Secrets and Data Protection
- Store secrets in Key Vault
- Prevent long-lived credentials in workflow files and source code
- Encrypt data at rest and in transit
- Enforce retention and access review policies for report evidence

## 4. Monitoring and Auditability
- Record all significant platform actions through logs and audit trails
- Track actor identity, execution context, and result generation
- Monitor unusual execution patterns, suspicious access, and excess permissions
