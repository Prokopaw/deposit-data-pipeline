-- Apply only the most recent version from staging per TransactionID.
-- Tie-breakers for identical UpdatedAt must be defined in production.
MERGE INTO DEPOSIT_DB.CORE.TRANSACTIONS AS t
USING (
    SELECT TransactionID, StoreID, Amount, Status, UpdatedAt
    FROM DEPOSIT_DB.RAW.TRANSACTIONS_STAGING
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY TransactionID
        ORDER BY UpdatedAt DESC
    ) = 1
) AS s
ON t.TransactionID = s.TransactionID
WHEN MATCHED AND s.UpdatedAt > t.UpdatedAt THEN
    UPDATE SET
        t.StoreID = s.StoreID,
        t.Amount = s.Amount,
        t.Status = s.Status,
        t.UpdatedAt = s.UpdatedAt
WHEN NOT MATCHED THEN
    INSERT (TransactionID, StoreID, Amount, Status, UpdatedAt)
    VALUES (s.TransactionID, s.StoreID, s.Amount, s.Status, s.UpdatedAt);

-- Check the merged current state:
SELECT * FROM DEPOSIT_DB.CORE.TRANSACTIONS ORDER BY TransactionID;
