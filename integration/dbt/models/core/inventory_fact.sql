{{
    config(
        materialized='incremental',
        unique_key=['branchplantkey','datekey','itemmasterkey','transtypekey',
                    'custvendorkey','unitcost','quantity','extcost']
    )
}}

-- Generate PK
SELECT (SELECT MAX(inventorykey) FROM {{ this }}) + ROW_NUMBER()
    OVER(ORDER BY datekey ASC) AS inventorykey,
  *
FROM {{ ref('stg_inventory') }} 