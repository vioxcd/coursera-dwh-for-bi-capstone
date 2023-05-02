{{ config(
    materialized='incremental'
  )
}}

-- ' initial query
-- as incremental model requires that the table exist beforehand
--
--  WITH
--  get_source_data AS (
  --  SELECT *
  --  FROM {{ source('cpi_card', 'w_job_f') }}
--  )
--  SELECT *
--  FROM get_source_data

WITH
new_records_not_exist_in_current_job_table AS (
  -- making sure it's safe to do `dbt run` again without having to think about the incremental model
  SELECT *
  FROM {{ ref('dw_int_job_change_data') }}

  {% if is_incremental() %}

  WHERE
      contract_date || ' ' ||
      sales_agent_id || ' ' ||
      sales_class_id || ' ' ||
      location_id || ' ' ||
      cust_id_ordered_by || ' ' ||
      date_promised || ' ' ||
      date_ship_by || ' ' ||
      number_of_subjobs || ' ' ||
      unit_price || ' ' ||
      quantity_ordered || ' ' ||
      quote_qty
      NOT IN (
        SELECT
          contract_date || ' ' ||
          sales_agent_id || ' ' ||
          sales_class_id || ' ' ||
          location_id || ' ' ||
          cust_id_ordered_by || ' ' ||
          date_promised || ' ' ||
          date_ship_by || ' ' ||
          number_of_subjobs || ' ' ||
          unit_price || ' ' ||
          quantity_ordered || ' ' ||
          quote_qty
        FROM {{ this }}
      )

  {% endif %}
),

current_max_job_id AS (
  SELECT MAX(job_id) AS max_job_id
  FROM {{ this }}
)

SELECT
  m.max_job_id + ROW_NUMBER() OVER (ORDER BY contract_date) AS job_id,
  contract_date,
  sales_agent_id,
  sales_class_id,
  location_id,
  cust_id_ordered_by,
  date_promised,
  date_ship_by,
  number_of_subjobs,
  unit_price,
  quantity_ordered,
  quote_qty
FROM
  new_records_not_exist_in_current_job_table v,
  current_max_job_id m
