{{ config(
    materialized='incremental'
  )
}}

SELECT *
FROM {{ source('cpi_card', 'w_lead_f') }}
