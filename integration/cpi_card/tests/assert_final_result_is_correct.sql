
-- 3479
SELECT 1
WHERE
  (
    SELECT COUNT(1)
    FROM {{ ref('dw_lead_f') }}
    WHERE job_id IS NULL
  ) != 3479

UNION

SELECT 1
WHERE
  (
    SELECT COUNT(1)
    FROM {{ ref('dw_lead_f') }}
  ) != 24000

UNION

SELECT 1
WHERE
  (
    SELECT COUNT(1)
    FROM {{ ref('dw_job_f') }}
  ) != 20521

UNION

SELECT 1
WHERE
  (
    SELECT COUNT(1)
    FROM {{ ref('dw_error_log') }}
  ) != 993

