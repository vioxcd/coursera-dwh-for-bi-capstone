{{
    config(
        materialized='incremental'
    )
}}

WITH
error_rows_after_validated AS (
  SELECT
    *
  FROM {{ ref('dw_stg_job_change_data') }}
  WHERE
      change_id NOT IN (
          SELECT change_id FROM {{ ref('dw_int_job_change_data') }}
      )
),

null_errors AS (
  SELECT
    change_id,
    NULL::INT AS job_id,
    'Null value errors' AS note,
    1 AS ordering
  FROM error_rows_after_validated
  WHERE
    contract_date IS NULL
    OR sales_agent_id IS NULL
    OR sales_class_id IS NULL
    OR location_id IS NULL
    OR cust_id_ordered_by IS NULL
    OR date_promised IS NULL
    OR date_ship_by IS NULL
    OR number_of_subjobs IS NULL
    OR unit_price IS NULL
    OR quantity_ordered IS NULL
    OR quote_qty IS NULL
    OR lead_id IS NULL
),

fk_references_errors AS (
  SELECT
    change_id,
    NULL::INT AS job_id,
    'Foreign key errors' AS note,
    2 AS ordering
  FROM error_rows_after_validated  -- one record can have more than one errors
  WHERE
    location_id NOT IN (
      SELECT location_id FROM {{ source('cpi_card', 'w_location_d') }}
    )
    OR
    cust_id_ordered_by NOT IN (
      SELECT cust_key FROM {{ source('cpi_card', 'w_customer_d') }}
    )
    OR
    sales_agent_id NOT IN (
      SELECT sales_agent_id FROM {{ source('cpi_card', 'w_sales_agent_d') }}
    )
    OR
    sales_class_id NOT IN (
      SELECT sales_class_id FROM {{ source('cpi_card', 'w_sales_class_d') }}
    )
),

contract_date_references_errors AS (
  SELECT
    change_id,
    NULL::INT AS job_id,
    'Date FK errors' AS note,
    3 AS ordering
  FROM error_rows_after_validated
  WHERE
    contract_date NOT IN (
      SELECT time_id FROM {{ source('cpi_card', 'w_time_d') }}
    )
),

date_promised_references_errors AS (
  SELECT
    change_id,
    NULL::INT AS job_id,
    'Date FK errors' AS note,
    3 AS ordering
  FROM error_rows_after_validated
  WHERE
    date_promised NOT IN (
      SELECT time_id FROM {{ source('cpi_card', 'w_time_d') }}
    )
),

date_ship_by_references_errors AS (
  SELECT
    change_id,
    NULL::INT AS job_id,
    'Date FK errors' AS note,
    3 AS ordering
  FROM error_rows_after_validated
  WHERE
    date_ship_by NOT IN (
      SELECT time_id FROM {{ source('cpi_card', 'w_time_d') }}
    )
),

date_differences_errors AS (
  SELECT
    change_id,
    NULL::INT AS job_id,
    'Date difference errors' AS note,
    4 AS ordering
  FROM error_rows_after_validated
  WHERE
    promised_business_day_number - contract_business_day_number BETWEEN 14 AND 30
    AND
    promised_business_day_number - ship_by_business_day_number BETWEEN 2 AND 7
),

lead_does_not_exist_in_lead_f_table_errors AS (
  SELECT
    change_id,
    NULL::INT AS job_id,
    'Lead update errors' AS note,
    5 AS ordering
  FROM error_rows_after_validated
  WHERE
    lead_id NOT IN (
      SELECT lead_id FROM {{ source('cpi_card', 'w_lead_f') }}
    )
),

lead_created_and_contract_date_does_not_chronologically_match_errors AS (
  SELECT
    e.change_id,
    l.job_id AS job_id,
    'Lead update errors' AS note,
    5 AS ordering
  FROM error_rows_after_validated e
  INNER JOIN {{ source('cpi_card', 'w_lead_f') }} l
    USING (lead_id)
  WHERE
    created_date_business_day_number < contract_business_day_number
),

all_errors AS (
  SELECT *
  FROM null_errors

  UNION
  SELECT *
  FROM fk_references_errors

  UNION
  SELECT *
  FROM contract_date_references_errors

  UNION
  SELECT *
  FROM date_promised_references_errors

  UNION
  SELECT *
  FROM date_ship_by_references_errors

  UNION
  SELECT *
  FROM date_differences_errors

  UNION
  SELECT *
  FROM lead_does_not_exist_in_lead_f_table_errors

  UNION
  SELECT *
  FROM lead_created_and_contract_date_does_not_chronologically_match_errors

  ORDER BY ordering
)

SELECT
  ROW_NUMBER() OVER (ORDER BY ordering, change_id) AS log_id,
  change_id,
  job_id,
  note
FROM all_errors

{% if is_incremental() %}

WHERE change_id > (
  SELECT MAX(change_id) FROM {{ this }}
)

{% endif %}
