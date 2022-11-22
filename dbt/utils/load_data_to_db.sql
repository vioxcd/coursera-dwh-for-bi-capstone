CREATE SCHEMA IF NOT EXISTS inventory;

DROP TABLE IF EXISTS inventory.inventory_fact_raw;

-- Use VARCHAR for all column assuming data type errors could happen if
-- copying directly from main fact table 
CREATE TABLE inventory.inventory_fact_raw (
  BranchPlantKey VARCHAR(10),
  Date VARCHAR(20),
  ItemMasterKey VARCHAR(10),
  TransTypeKey VARCHAR(10),
  CustVendorKey VARCHAR(10),
  UnitCost VARCHAR(10),
  Currency VARCHAR(10),
  Quantity VARCHAR(10)
);