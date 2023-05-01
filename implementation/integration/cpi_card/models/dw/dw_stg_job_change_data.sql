
WITH
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
  FROM {{ source('cpi_card', 'w_job_change_data') }}
),

business_day_numbering AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY time_id) AS business_day_number
  FROM {{ source('cpi_card', 'w_time_d') }}
),

extra_date_number_columns AS (
  SELECT
    v.*,
    bd_contract.business_day_number AS contract_business_day_number,
    bd_promised.business_day_number AS promised_business_day_number,
    bd_ship.business_day_number AS ship_by_business_day_number,
    bd_created_date.business_day_number AS created_date_business_day_number
  FROM create_date_fk_from_date_format v
    LEFT JOIN {{ source('cpi_card', 'w_lead_f') }} l
      USING (lead_id)
    LEFT JOIN business_day_numbering bd_contract
      ON v.contract_date = bd_contract.time_id
    LEFT JOIN business_day_numbering bd_promised
      ON v.date_promised = bd_promised.time_id
    LEFT JOIN business_day_numbering bd_ship
      ON v.date_ship_by = bd_ship.time_id
    LEFT JOIN business_day_numbering bd_created_date
      ON l.created_date = bd_created_date.time_id
)

SELECT *
FROM extra_date_number_columns
