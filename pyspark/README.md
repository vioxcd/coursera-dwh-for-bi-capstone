# ETL using SSStores Dataset

## Usage

1. Run `pip install -r requirements.txt` or [install spark/pyspark](https://spark.apache.org/docs/latest/api/python/getting_started/install.html)
2. Ensure you have [postgres.jar](https://stackoverflow.com/a/1911487) in your PATH. Either put it inside Spark `jars` or `CLASSPATH`
3. Rename `sample-setup` to `setup` and the `.env.example` to `.env` and fill out the needed variables. This file is used to create schema, insert dataset, and connect to database from Spark
4. Make it executable (`chmod +x setup`) and execute it (`./setup`) -- this operation might take several minutes
5. Peek out the data by doing `SELECT COUNT(1) FROM ssstores.sssales` -- would print out 192 rows initially
6. Run `python etl.py` to load new data to the sales table
7. Run the `COUNT` as (4) and there are 8 new rows added
8. [optional] Check out the Spark Web UI on `localhost:4040` when executing the job
