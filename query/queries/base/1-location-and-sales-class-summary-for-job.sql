CREATE VIEW base_location_and_sales_class_summary_for_job
AS
SELECT
    location_id
     ,location_name
     ,sales_class_id
     ,sales_class_desc AS sales_class_description
     ,time_year AS year_of_job_contract_date
     ,time_month AS month_of_job_contract_date
     ,base_price AS base_price_of_sales_class
     ,SUM(quantity_ordered) AS sum_of_quantity_ordered
     ,SUM(quantity_ordered * unit_price) AS sum_of_job_amount
FROM dw_job_f
    INNER JOIN w_location_d
        USING (location_id)
    INNER JOIN w_sales_class_d
        USING (sales_class_id)
    INNER JOIN w_time_d
        ON w_time_d.time_id = dw_job_f.contract_date
GROUP BY
    1, 2, 3, 4, 5, 6, 7
