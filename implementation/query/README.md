# Data Warehouse Query Assignment

## Big Picture

There are three tasks that needs to be completed

1. Building base tables for query (views) (BQ)
2. Building the analytic queries (AQ)
3. Fill the *'base query specification matrix'* and questions about materialized views (follow the table already given in the doc)

There's also an extra (4) challenge problems in the background document

## Working

1. Use the data from [integration](../integration)

## Result

### Base Queries

![all base query views in Datagrip's database explorer pane](https://github.com/vioxcd/coursera-dwh-etl-elt/assets/31486724/e7953d36-5cbe-417a-b99d-1ef61abfbe21)

### Example Result for BQ

![example query result from one of the base query](https://github.com/vioxcd/coursera-dwh-etl-elt/assets/31486724/344e5763-a2e8-4a6a-9be7-9578af182b01)

### Example Result for AQ

![example query result from one of the analytic query](https://github.com/vioxcd/coursera-dwh-etl-elt/assets/31486724/0ee724dc-fbaf-4a84-a65d-bbeac9e4ff75)

### Base Query Specification Matrix

![the base query specification matrix where measure are defined and which dimension needed are crossed out](https://github.com/vioxcd/coursera-dwh-etl-elt/assets/31486724/6037cba1-c3de-4106-8f83-670e9e30950e)

## Further Notes

I skip the materialized view analysis because there doesn't seem to be much hint about what to do.

For the challenges, I intend to do them at first, but after seeing the questions, I think the first two (forecasting and budgeting) are relatively easy, while the other two (data quality concerns) is a bit tough as it doesn't give much hints and a bit ambiguous (for example, this data quality concerns exist in the current data, and not like with the fictitious shipment values in the table, right?) - anyway, to solve the other two would require further investigation into the dataset

