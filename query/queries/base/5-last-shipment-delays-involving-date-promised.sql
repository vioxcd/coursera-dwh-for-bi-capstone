-- A job is a contract with two important dates:
-- 1) date promised in which the entire job quantity should be shipped
-- 2) ship by date in which the first shipment of a job should occur.
--
-- The date promised provides a constraint about the last shipment date,
-- while the shipped by date provides a constraint on the first shipment date
--
-- Both of them relates to (service) quality control
-- 
-- This query reflects the first part, where all shipment should be done by date promised
-- The first query details is in the `job` table, where the date promised is recorded
-- and in the `shipment` table, where actual ship date are recorded
CREATE OR REPLACE VIEW base_last_shipment_delays_involving_date_promised
AS
SELECT
    job_id
     ,dw_job_f.location_id
     ,location_name
     ,dw_job_f.sales_class_id
     ,sales_class_desc
     ,date_promised
     ,last_shipment_date
     ,quantity_ordered
     ,total_shipped_amount as total_delayed_ship_amount
     ,getbusdaysdiff(last_shipment_date, date_promised) AS last_shipment_delay_days
FROM (
	-- determine last shipment date
    SELECT
        job_id
        ,MAX(actual_ship_date) as last_shipment_date
        ,SUM(actual_quantity) AS total_shipped_amount
    FROM dw_job_f
        -- needed fact tables
        INNER JOIN w_sub_job_f
            USING(job_id)
        INNER JOIN w_job_shipment_f
            USING(sub_job_id)
    WHERE
        actual_ship_date > date_promised
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
