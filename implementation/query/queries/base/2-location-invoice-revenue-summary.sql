CREATE VIEW base_location_invoice_revenue_summary
AS
SELECT
    dw_job_f.job_id
     ,w_location_d.location_id
     ,w_location_d.location_name
     ,dw_job_f.unit_price
     ,dw_job_f.quantity_ordered AS job_order_quantity_ordered
     ,time_year AS year_of_job_contract_date
     ,time_month AS month_of_job_contract_date
     ,SUM(invoice_amount) AS sum_of_invoice_amount
     ,SUM(invoice_quantity) AS sum_of_invoice_quantity
FROM dw_job_f
         -- JOIN needed dim tables
    INNER JOIN w_location_d
        USING (location_id)
    INNER JOIN w_time_d
        ON w_time_d.time_id = dw_job_f.contract_date
    -- JOIN other fact tables
    INNER JOIN w_sub_job_f
        USING(job_id)
    INNER JOIN w_job_shipment_f
        USING(sub_job_id)
    INNER JOIN w_invoiceline_f
        USING(invoice_id)
GROUP BY
    1, 2, 3, 4, 5, 6, 7
