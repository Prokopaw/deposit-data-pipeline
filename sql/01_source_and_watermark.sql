-- SQL Server practice script; execute only in a disposable practice database.
-- Historical versions are illustrative: an operational table typically stores only current rows.
CREATE TABLE dbo.Transactions (
    TransactionID int NOT NULL PRIMARY KEY,
    StoreID int NOT NULL,
    Amount decimal(12,2) NOT NULL,
    Status varchar(20) NOT NULL,
    UpdatedAt datetime2(0) NOT NULL
);

INSERT INTO dbo.Transactions (TransactionID, StoreID, Amount, Status, UpdatedAt)
VALUES
    (101, 10, 50.00, 'Completed', '2026-11-11T10:00:00'),
    (102, 10, 30.00, 'Completed', '2026-11-11T10:10:00'),
    (103, 20, 80.00, 'Completed', '2026-11-11T10:20:00');

CREATE TABLE dbo.PipelineWatermarks (
    PipelineName varchar(100) NOT NULL PRIMARY KEY,
    LastWatermark datetime2(0) NOT NULL
);
INSERT INTO dbo.PipelineWatermarks (PipelineName, LastWatermark)
VALUES ('PL_IncrementalTransactions', '2026-11-11T10:00:00');

-- Practice: consistent half-open interval with exclusive upper bound.
-- @OldWatermark is included; @NewWatermark is excluded. The stored watermark
-- therefore represents the exclusive START of the next batch, not its last copied row.
DECLARE @OldWatermark datetime2(0) = '2026-11-11T10:00:00';
DECLARE @NewWatermark datetime2(0) = '2026-11-11T12:00:00';

SELECT TransactionID, StoreID, Amount, Status, UpdatedAt
FROM dbo.Transactions
WHERE UpdatedAt >= @OldWatermark
  AND UpdatedAt < @NewWatermark;

-- This example assumes a stable source snapshot / no late backdated UpdatedAt values.
-- Never advance the watermark after a failed or unvalidated export.
