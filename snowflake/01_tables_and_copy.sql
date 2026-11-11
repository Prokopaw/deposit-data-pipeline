-- Snowflake example; review permissions and object names before execution.
-- Stages and data loads require access to an actual Azure Storage location.
CREATE DATABASE IF NOT EXISTS DEPOSIT_DB;
CREATE SCHEMA IF NOT EXISTS DEPOSIT_DB.RAW;
CREATE SCHEMA IF NOT EXISTS DEPOSIT_DB.CORE;

CREATE TABLE IF NOT EXISTS DEPOSIT_DB.RAW.TRANSACTIONS_STAGING (
    TransactionID NUMBER(38,0),
    StoreID NUMBER(38,0),
    Amount NUMBER(12,2),
    Status VARCHAR(20),
    UpdatedAt TIMESTAMP_NTZ
);

CREATE TABLE IF NOT EXISTS DEPOSIT_DB.CORE.TRANSACTIONS (
    TransactionID NUMBER(38,0),
    StoreID NUMBER(38,0),
    Amount NUMBER(12,2),
    Status VARCHAR(20),
    UpdatedAt TIMESTAMP_NTZ
);

-- EXAMPLE ONLY: replace the placeholder with your own configured external stage.
-- Review the sample CSV format and mapping before running COPY INTO.
-- CREATE STAGE DEPOSIT_DB.RAW.DEPOSIT_STAGE ...;
-- COPY INTO DEPOSIT_DB.RAW.TRANSACTIONS_STAGING
-- FROM @DEPOSIT_DB.RAW.DEPOSIT_STAGE/transactions_incremental.csv
-- FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"')
-- ON_ERROR = ABORT_STATEMENT;
--
-- A separate process should clear or batch-scope staging after successful application.
