# Reporting and Evidence Model

## 1. Report Generation
The system should generate a detailed report for every run that includes:

- summary of findings
- risk score and severity
- tested component and target details
- attack scenario or test path description
- evidence references and attachments
- recommendations and remediation guidance

## 2. Execution Metadata Record
Each execution record should persist the following fields:

- execution timestamp
- process or engine name
- requesting user
- score (1-10)
- affected component
- report path or artifact reference
- related client or project ID
- test scenario name or template ID

## 3. Evidence Storage
Stored artifacts should include:

- generated report files
- raw scan output
- scenario execution log
- evidence summary metadata
- historical result snapshots

## 4. Timeline Usage
The UI should render a chronological view of activities so the client can see:

- when a scan ran
- which user initiated it
- what scenario or agent was used
- what score was assigned
- how the status evolved over time
