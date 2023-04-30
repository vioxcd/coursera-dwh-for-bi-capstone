# Data Warehouse Integration Assignment

I'm using `dbt` because the data already lives in the same `postgres` database

## Before Starting the Assignment

### Given SQL files

- [Test DW Postgre Create](./sqls/create-initial-job-tables.sql)
- [Prod DW Postgre Create](./sqls/create-job-change-tables.sql)
- [400k-2012-2013-2014.sql](./sqls/insert-initial-job-tables.sql)
- [4000Change-2015.sql](./sqls/insert-job-change-tables.sql)

### Missing Create SQL Statement from Given SQL files

Some `CREATE TABLE` statements that are missing from `Test DW Postgre Create.sql`

- W_SALES_AGENT_D
- W_MACHINE_TYPE_D
- W_CUST_LOCATION_D
- W_SUB_JOB_F
- W_JOB_SHIPMENT_F
- W_INVOICELINE_F
- W_FINANCIAL_SUMMARY_SALES_F
- W_FINANCIAL_SUMMARY_COST_F

## Steps

1. Create all missing SQL create statements
2. Modify inserts statements to be fast (use `clean-sql.sh`)
3. Create database and insert the data
4. Initialize `dbt` project
5. Create models from sources (as `incremental`)
6. Add modifiers to the model as instructed in `assignment.doc` (`schema.yml`)
7. Follow the instruction for validation and loading in `assignment.doc`
8. Add sanity tests

