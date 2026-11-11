# PL_IncrementalTransactions — architecture sketch

**Status:** design only; not deployed or end-to-end tested in Azure Data Factory.

Source: on-prem SQL Server, via Self-hosted Integration Runtime.
Destination: Azure Blob Storage, staged by business interval and RunId.

1. Read **OldWatermark** from a control table (Lookup).
2. Establish **NewWatermark** from a consistent source boundary (Lookup).
3. Copy `OldWatermark <= UpdatedAt < NewWatermark` into a run-specific staging path (Copy Activity).
4. Reconcile counts and business totals against the same stable source snapshot.
5. Publish a validated batch through a versioned path / committed manifest.
6. Atomically register the published batch and approved watermark in control metadata.
7. On failure, preserve prior approved watermark; alert and mark the pipeline failed.

Important limitations:
- Timestamp watermarks do not detect physical DELETE operations.
- A plain current-time upper bound does not guarantee consistency for concurrent writes.
- Files in Blob Storage are not rolled back automatically if Copy Activity fails.
- Publishing to Blob and updating SQL metadata are not automatically one transaction.
- Retried batch processing must be idempotent. Downstream tables use keyed MERGE.

Suggested production extensions: monitor failure/lag, late arrivals, CDC, overlapping windows,
retention, deterministic ties, secrets management, tests and reconciled audit log.
