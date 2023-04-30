{{ config(
    materialized='incremental'
  )
}}

SELECT *
FROM {{ source('cpi_card', 'w_error_log') }}
