# Data Warehouse Integration Assignment

I'm using `dbt` because the data already lives in the same `postgres` database

## Before Starting the Assignment

### Given SQL files

- [Test DW Postgre Create](./sqls/create-initial-job-tables.sql)
- [Prod DW Postgre Create](./sqls/create-job-change-tables.sql)
- [400k-2012-2013-2014.sql](./sqls/insert-initial-job-tables.sql)
- [4000Change-2015.sql](./sqls/insert-job-change-tables.sql)

### Missing Create SQL Statement from Given SQL files

Some `CREATE TABLE` statements that are missing from `Test DW Postgre Create.sql` and have to be created manually

- W_SALES_AGENT_D
- W_MACHINE_TYPE_D
- W_CUST_LOCATION_D
- W_SUB_JOB_F
- W_JOB_SHIPMENT_F
- W_INVOICELINE_F
- W_FINANCIAL_SUMMARY_SALES_F
- W_FINANCIAL_SUMMARY_COST_F

## Doing the Assignment

### Big Picture Steps

1. Create all missing SQL create statements
2. Modify inserts statements to be fast (use `clean-sql.sh`)
3. Create database and insert the data
4. Initialize `dbt` project
5. Create models from sources (as `incremental`)
6. Add modifiers to the model as instructed in `assignment.doc` (`schema.yml`)
7. Follow the instruction for validation and loading in `assignment.doc`
8. Add sanity tests

### How to Reproduce

0. Create a database and its schema that you can use, I use this with [Postgres docker image](https://hub.docker.com/_/postgres)
1. Run the [create initial job tables](sqls/create-initial-job-tables.sql) to create the tables
2. Unzip the `data.zip` file
3. Import all the insert statements
4. Install required package for `dbt`: `pip install dbt-core==1.4.5 dbt-postgres==1.4.5`
5. Go to `cpi_card` directory and setup your config in `profiles.yml` (make sure it matches what's in `dbt_project.yml`)
6. Uncomment the `initial query` line in [job facts](./cpi_card/models/dw/dw_job_f.sql) and [lead facts](./cpi_card/models/dw/dw_lead_f.sql) and comment the rest of the file
7. Run `dbt run --full-refresh` to load initial data
8. Do the reverse of step 6 (comment the `initial query` and uncomment the rest)
9. Run `dbt run` to load incremental data
10. Run `dbt test` to check whether your run is correct

Step 6 and 7 are needed because `dbt` incremental model needs the table to exist beforehand

## Other Things

### Pictures

See [PICTURES.md](./PICTURES.md)

### Caveats

- It's a bit tricky to make the assignment work for ELT case (`dbt` is an ELT tool) because it's designed for ETL workload (using `pentaho`). I still try to use `dbt` because the use-case fits nicely (e.g. transforming data that already exist in warehouse)
- The trickiness clearly visible from [step 6 and 7 uncomment and commenting lines to initially load the data](#how-to-reproduce)
- Need to be careful when loading the data because of the point above

### TODO

- Create intermediate table where `job_id` is available for use by both `dw_job_f` and `dw_lead_f` (currently `dw_lead_f` do JOINs to all `dw_int_` column)
