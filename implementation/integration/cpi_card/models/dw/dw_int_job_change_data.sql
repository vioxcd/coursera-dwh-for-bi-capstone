
WITH
validation_rule_reject_null_values AS (
  SELECT *
  FROM {{ ref('dw_stg_job_change_data') }}
  WHERE
    contract_date IS NOT NULL
    AND sales_agent_id IS NOT NULL
    AND sales_class_id IS NOT NULL
    AND location_id IS NOT NULL
    AND cust_id_ordered_by IS NOT NULL
    AND date_promised IS NOT NULL
    AND date_ship_by IS NOT NULL
    AND number_of_subjobs IS NOT NULL
    AND unit_price IS NOT NULL
    AND quantity_ordered IS NOT NULL
    AND quote_qty IS NOT NULL
    AND lead_id IS NOT NULL
),

validation_rule_reject_invalid_fk_references AS (
  SELECT *
  FROM validation_rule_reject_null_values
  WHERE
    location_id IN (
      SELECT location_id FROM {{ source('cpi_card', 'w_location_d') }}
    )
    AND
    cust_id_ordered_by IN (
      SELECT cust_key FROM {{ source('cpi_card', 'w_customer_d') }}
    )
    AND
    sales_agent_id IN (
      SELECT sales_agent_id FROM {{ source('cpi_card', 'w_sales_agent_d') }}
    )
    AND
    sales_class_id IN (
      SELECT sales_class_id FROM {{ source('cpi_card', 'w_sales_class_d') }}
    )
),

validation_rule_reject_invalid_date_references AS (
  SELECT *
  FROM validation_rule_reject_invalid_fk_references
  WHERE
    contract_date IN (
      SELECT time_id FROM {{ source('cpi_card', 'w_time_d') }}
    )
    AND
    date_promised IN (
      SELECT time_id FROM {{ source('cpi_card', 'w_time_d') }}
    )
    AND
    date_ship_by IN (
      SELECT time_id FROM {{ source('cpi_card', 'w_time_d') }}
    )
),

validation_rule_reject_invalid_business_day_differences AS (
  SELECT *
  FROM validation_rule_reject_invalid_date_references
  WHERE
    promised_business_day_number - contract_business_day_number BETWEEN 14 AND 30
    AND
    promised_business_day_number - ship_by_business_day_number BETWEEN 2 AND 7
),

validation_rule_reject_invalid_lead_id_references AS (
  SELECT
    *
  FROM validation_rule_reject_invalid_business_day_differences
  WHERE
    created_date_business_day_number < contract_business_day_number
)

SELECT *
FROM validation_rule_reject_invalid_lead_id_references 
