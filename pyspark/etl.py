import os

from dotenv import load_dotenv

from pyspark.sql import SparkSession, Window
from pyspark.sql.functions import monotonically_increasing_id, row_number

# Instantiate spark
spark = (SparkSession.builder
         .master("local[*]")
         .appName('SSStores_ETL')
         .getOrCreate()
         )

# Load source data
SSExcelData = (spark.read
               .option("header", "true")
               .csv('../data/SSExcelSource.csv')
               )

# Correct column names
SSExcelData = SSExcelData.withColumnRenamed("Month ", "Month")

# Correct data types
SSExcelData = (SSExcelData.withColumn("SalesUnits",SSExcelData.SalesUnits.cast('int'))
               .withColumn("SalesDollar",SSExcelData.SalesDollar.cast('int'))
               .withColumn("SalesCost",SSExcelData.SalesCost.cast('int'))
               .withColumn("Day",SSExcelData.Day.cast('int'))
               .withColumn("Month",SSExcelData.Month.cast('int'))
               .withColumn("Year",SSExcelData.Year.cast('int'))
               )

# Filter rows step
SSExcelData = SSExcelData.na.drop("any")

# Sort rows step
SSExcelData = SSExcelData.sort("Year","Month","Day")

# Load target credentials and other data
load_dotenv()

DB_URI = os.getenv("DB_URI")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

assert DB_URI != '', "Error: DB_URI is empty"
assert DB_USER != '', "Error: DB_USER is empty"
assert DB_PASS != '', "Error: DB_PASS is empty"

SSTimeDim = (spark.read
                .format("jdbc")
                .option("url", DB_URI)
                .option("dbtable", "ssstores.sstimedim")
                .option("user", DB_USER)
                .option("password", DB_PASS)
                .load()
                )

SSItem = (spark.read
          .format("jdbc")
          .option("url", DB_URI)
          .option("dbtable", "ssstores.ssitem")
          .option("user", DB_USER)
          .option("password", DB_PASS)
          .load()
         )

SSCustomer = (spark.read
              .format("jdbc")
              .option("url", DB_URI)
              .option("dbtable", "ssstores.sscustomer")
              .option("user", DB_USER)
              .option("password", DB_PASS)
              .load()
             )

SSStore = (spark.read
           .format("jdbc")
           .option("url", DB_URI)
           .option("dbtable", "ssstores.ssstore")
           .option("user", DB_USER)
           .option("password", DB_PASS)
           .load()
          )

SSSales = (spark.read
           .format("jdbc")
           .option("url", DB_URI)
           .option("dbtable", "ssstores.sssales")
           .option("user", DB_USER)
           .option("password", DB_PASS)
           .load())

# Sort the data before joining
SSTimeDim = SSTimeDim.sort("timeyear","timemonth","timeday")
SSItem = SSItem.sort("itemid")
SSCustomer = SSCustomer.sort('custid')
SSStore = SSStore.sort('storeid')

# Join all the data
joined = (SSExcelData.join(SSTimeDim,
                            (SSExcelData.Day == SSTimeDim.timeday) &
                            (SSExcelData.Month == SSTimeDim.timemonth) &
                            (SSExcelData.Year == SSTimeDim.timeyear),
                            'inner'
                        )
                    .sort("ItemID")
                    .join(SSItem, ['ItemID'])
                    .sort('CustID')
                    .join(SSCustomer, ['CustID'], 'inner')
                    .sort('StoreID')
                    .join(SSStore, ['StoreID'], 'inner')
        )

# Assign PK
sequence_start = SSSales.count()
final_df = joined.withColumn("salesno",
                                row_number().over(Window.orderBy(monotonically_increasing_id())) + sequence_start
                            )

# Select only column that match target
target_table_cols = [col.name for col in SSSales.schema]
final_df = final_df.select(target_table_cols)

# Load to target
(final_df
    .write
    .format("jdbc")
    .mode('append')
    .option("url", DB_URI)
    .option("dbtable", "ssstores.sssales")
    .option("user", DB_USER)
    .option("password", DB_PASS)
    .save()
)
