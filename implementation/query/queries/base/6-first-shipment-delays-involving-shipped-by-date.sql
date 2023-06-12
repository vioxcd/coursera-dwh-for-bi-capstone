-- A job is a contract with two important dates:
-- 1) date promised in which the entire job quantity should be shipped
-- 2) ship by date in which the first shipment of a job should occur.
--
-- The date promised provides a constraint about the last shipment date,
-- while the shipped by date provides a constraint on the first shipment date
--
-- Both of them relates to (service) quality control
-- 
-- This query reflects the second part, where one shipment should be done by shipped by date
-- The second query details is in the `job` table, where the date ship by is recorded
-- and in the `shipment` table, where actual ship date are recorded
CREATE OR REPLACE VIEW base_first_shipment_delays_involving_shipped_by_date
AS
SELECT
    job_id
     ,dw_job_f.location_id
     ,location_name
     ,dw_job_f.sales_class_id
     ,sales_class_desc
     ,date_ship_by
     ,first_shipment_date
     ,quantity_ordered
     ,total_shipped_amount
     ,getbusdaysdiff(first_shipment_date, date_ship_by) AS first_shipment_delay_days
FROM (
    SELECT
        job_id
        ,MIN(actual_ship_date) as first_shipment_date
        ,SUM(actual_quantity) AS total_shipped_amount
    FROM dw_job_f
        -- needed fact tables
        INNER JOIN w_sub_job_f
            USING(job_id)
        INNER JOIN w_job_shipment_f
            USING(sub_job_id)
    WHERE
        actual_ship_date > date_ship_by
    GROUP BY
        1
) t
    INNER JOIN dw_job_f
        USING (job_id)
     -- needed dim tables
     INNER JOIN w_location_d
         USING (location_id)
     INNER JOIN w_sales_class_d
         USING (sales_class_id)
