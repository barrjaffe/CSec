# Functional Requirements

## 1. Core Platform Functions
The platform must allow a user to:

- start a security assessment for APIs and application components
- submit code or configuration artifacts for analysis
- run built-in security tests and exploit scenario checks
- define and run custom `.md` scenarios
- configure custom agents and testing logic
- review results in a timeline-based interface
- generate a final report and secure evidence record

## 2. Reporting Requirements
Each execution must generate a structured record with the following values:

- time of execution
- executing process
- requesting user
- score of the test (1-10)
- tested component
- path to report

The result should be persistently stored in a designated database and linked to the related report artifact.

## 3. Client Management Requirements
Clients should be able to:

- manage internal users and roles
- define custom scenarios in Markdown format
- add custom agents and test modules
- track test progression over time
- review historical activity by timeline or report list

## 4. Security and Controls Requirements
- no production exposure during MVP testing stages
- restricted sandboxing for cloud validation
- RBAC for analyst, admin, and auditor roles
- logging of all execution actions and report generation events
