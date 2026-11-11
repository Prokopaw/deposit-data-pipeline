# deposit-data-pipeline

A small **educational Data Engineering portfolio project** simulating transaction ingestion for a deposit-return system.
All example data are synthetic. No employer or customer data.

## Architecture (proposed)

SQL Server -> Azure Data Factory (Self-hosted IR) -> Azure Blob Storage -> Snowflake RAW -> Snowflake CORE (MERGE)

## Contents

- `sql/01_source_and_watermark.sql` — disposable SQL Server source and watermark example.
- `sample-data/transactions_incremental.csv` — fictional incremental batch including two versions of ID 105.
- `snowflake/01_tables_and_copy.sql` — Snowflake schemas/tables and an illustrative `COPY INTO` template.
- `snowflake/03_local_practice.sql` — data setup allowing practice inside Snowflake without Azure Blob.
- `snowflake/02_merge_latest.sql` — deduplicate staging with `ROW_NUMBER` + `QUALIFY`, then guarded `MERGE`.
- `adf/pipeline-design.md` — conceptual incremental pipeline, controls and failure recovery.

## How to practice Snowflake

1. In a **disposable Snowflake environment** with permissions, run `snowflake/01_tables_and_copy.sql`.
2. Run `snowflake/03_local_practice.sql` (once per empty practice setup).
3. Run `snowflake/02_merge_latest.sql` and inspect `CORE.TRANSACTIONS`.
4. Run step 3 again: expect no further changes to current state for the same versions.

For a real Azure Blob load, first provision a secure storage integration and external stage, then adapt the commented `COPY INTO` example. Do not enable `FORCE=TRUE` casually.

## Expected current-state result

| TransactionID | Amount | Status |
|---:|---:|---|
| 101 | 60.00 | Completed |
| 102 | 30.00 | Cancelled |
| 103 | 80.00 | Completed |
| 104 | 40.00 | Completed |
| 105 | 27.00 | Completed |

## Scope and limitations

This repository contains design notes and example SQL; **it has not been deployed or end-to-end verified** against Azure Data Factory and Azure Blob Storage. SQL scripts should be reviewed and run only in isolated training environments. Timestamp-based incrementals require a consistent source boundary and late-arrival strategy. No production secrets are included.
