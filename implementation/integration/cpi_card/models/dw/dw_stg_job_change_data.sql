
WITH
validation_rule_reject_null_values AS (
  SELECT *
  FROM {{ source('cpi_card', 'w_job_change_data') }}
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

create_date_fk_from_date_format AS (
  SELECT
    change_id,
    REPLACE(contract_date, '-', '')::INTEGER AS contract_date,
    sales_agent_id,
    sales_class_id,
    location_id,
    cust_id_ordered_by,
    REPLACE(date_promised, '-', '')::INTEGER AS date_promised,
    REPLACE(date_ship_by, '-', '')::INTEGER AS date_ship_by,
    number_of_subjobs,
    unit_price,
    quantity_ordered,
    quote_qty,
    lead_id
  FROM validation_rule_reject_invalid_fk_references
),

validation_rule_reject_invalid_date_references AS (
  SELECT *
  FROM create_date_fk_from_date_format
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

business_day_numbering AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY time_id) AS business_day_number
  FROM {{ source('cpi_card', 'w_time_d') }}
),

validation_rule_reject_invalid_business_day_differences AS (
  SELECT
    v.*
  FROM validation_rule_reject_invalid_date_references v
    INNER JOIN business_day_numbering bd_contract
      ON v.contract_date = bd_contract.time_id
    INNER JOIN business_day_numbering bd_promised
      ON v.date_promised = bd_promised.time_id
    INNER JOIN business_day_numbering bd_ship
      ON v.date_ship_by = bd_ship.time_id
  WHERE
    bd_promised.business_day_number - bd_contract.business_day_number BETWEEN 14 AND 30
    AND
    bd_promised.business_day_number - bd_ship.business_day_number BETWEEN 2 AND 7
),

validation_rule_reject_invalid_lead_id_references AS (
  SELECT *
  FROM validation_rule_reject_invalid_business_day_differences
  WHERE
    lead_id IN (
      SELECT lead_id FROM {{ source('cpi_card', 'w_lead_f') }}
    )
)

SELECT *
FROM validation_rule_reject_invalid_lead_id_references 
