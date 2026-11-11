-- Optional isolated practice data without an external Azure stage.
-- Run 01_tables_and_copy.sql first, then these statements, then 02_merge_latest.sql.
INSERT INTO DEPOSIT_DB.CORE.TRANSACTIONS VALUES
    (101, 10, 50.00, 'Completed', '2026-11-11 10:00:00'),
    (102, 10, 30.00, 'Completed', '2026-11-11 10:10:00'),
    (103, 20, 80.00, 'Completed', '2026-11-11 10:20:00');

INSERT INTO DEPOSIT_DB.RAW.TRANSACTIONS_STAGING VALUES
    (101, 10, 60.00, 'Completed', '2026-11-11 11:00:00'),
    (102, 10, 30.00, 'Cancelled', '2026-11-11 11:10:00'),
    (104, 20, 40.00, 'Completed', '2026-11-11 11:20:00'),
    (105, 20, 25.00, 'Completed', '2026-11-11 11:30:00'),
    (105, 20, 27.00, 'Completed', '2026-11-11 11:40:00');

-- Expected after MERGE: 101=60 Completed, 102=30 Cancelled,
-- 103=80 Completed, 104=40 Completed, 105=27 Completed.
-- Scripts insert data; use a fresh disposable schema to repeat from scratch.
