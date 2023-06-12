
{{ config(
    materialized='incremental',
    unique_key='lead_id',
    merge_update_columns=['job_id', 'lead_success'],
  )
}}

--  ' initial query
--  as incremental model requires that the table exist beforehand
--
--  WITH
--  get_source_data AS (
  --  SELECT *
  --  FROM {{ source('cpi_card', 'w_lead_f') }}
--  )
--  SELECT *
--  FROM get_source_data

WITH
most_recent_jobs AS (
  -- TODO
  -- create the incremental as intermediate table before dw_job_f
  -- that can be used both by by dw_job_f and dw_lead_f
  -- end result: incremental table are UNION'd to source w_job_f
  SELECT *
  FROM {{ ref('dw_job_f') }} j
  INNER JOIN {{ ref('dw_int_job_change_data') }} ij
    USING (
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
    )
),

new_records_not_exist_in_current_lead_table AS (
  -- making sure it's safe to do `dbt run` again without having to think about the incremental model
  SELECT *
  FROM most_recent_jobs

  {% if is_incremental() %}

  WHERE
    -- doesn't check for `NOT IN` because this is an  update operation, and not insert
    lead_id
      IN (
        SELECT lead_id
        FROM {{ this }}
        WHERE job_id IS NULL  -- for specifically update the job_id
      )

  {% endif %}

)

SELECT
  s.lead_id,
  s.quote_qty,
  s.quote_price,
  'Y' AS lead_success,
  v.job_id,
  s.created_date,
  s.cust_id,
  s.location_id,
  s.sales_agent_id,
  s.sales_class_id
FROM new_records_not_exist_in_current_lead_table v
INNER JOIN {{ this }} s
  USING (lead_id)

