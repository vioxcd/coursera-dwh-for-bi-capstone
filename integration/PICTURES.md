# Some Pictures

### dbt docs for `error_log`

![dw error log page in dbt docs](./assets/1-dbt-docs.png)

### dbt lineage for `error_log`

![dbt lineage (dag) for dw error log](./assets/2-lineage-graph-of-error-logs.png)

### dbt lineage for `intermediate table`

![dbt lineage (dag) for dw intermediate job change table](./assets/3-lineage-graph-of-intermediate-table.png)

### dbt lineage for `job facts`

![dbt lineage (dag) for job facts table](./assets/4-lineage-graph-of-final-job-table.png)

### dbt lineage for `lead facts`

![dbt lineage (dag) for lead facts table](./assets/5-lineage-graph-of-final-lead-table.png)

### Total errors by group

![5 different errors as described in assignment and their count, calculated in databricks](./assets/6-total-errors-by-group.png)

### Reproduce initial load

![CLI interface running dbt run --full-refresh command and its result. Pay attention to the green `SELECT` in the middle, that's the amount of data loaded](./assets/7-reproduce-initial-load-step.png)

### Reproduce incremental load

![CLI interface running dbt run command and its result. Pay attention to the green `INSERT` in the middle, that's the amount of data inserted](./assets/8-reproduce-incremental-load-step.png)

### Validation rule implementation

![Folded validation rules code in intermediate table](./assets/9-validation-rules.png)
