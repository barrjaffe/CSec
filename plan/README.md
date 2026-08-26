# Plan Overview

This folder contains the planning artifacts for the pentest platform, including system design, database model, and operational guidance.

## Included sections
- `db/` — database design and privacy-safe storage model
- `architecture/` — architecture planning and design references

## High-level design direction
- Azure-first platform design
- Python backend and Angular frontend
- GitHub Actions delivery pipeline
- per-run temporary session data with controlled retention
- privacy-safe metadata persistence in the permanent database
- encrypted artifact store for evidence and reports
- append-only audit log for accountability
