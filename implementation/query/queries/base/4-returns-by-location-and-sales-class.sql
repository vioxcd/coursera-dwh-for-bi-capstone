CREATE VIEW base_returns_by_location_and_sales_class
AS
WITH
    base AS (
        SELECT
            location_id
             ,location_name
             ,sales_class_id
             ,sales_class_desc AS sales_class_description
             ,time_year AS year_of_invoice_sent_date
             ,time_month AS month_of_invoice_sent_date
             ,quantity_shipped - invoice_quantity AS returns
             ,ROUND((invoice_amount::DECIMAL / invoice_quantity), 2) AS unit_price
        FROM w_invoiceline_f
            INNER JOIN w_location_d
                USING (location_id)
            INNER JOIN w_sales_class_d
                USING (sales_class_id)
            INNER JOIN w_time_d
                ON w_time_d.time_id = w_invoiceline_f.invoice_sent_date
        WHERE
            quantity_shipped - invoice_quantity > 0
    )

SELECT
    location_id
     ,location_name
     ,sales_class_id
     ,sales_class_description
     ,year_of_invoice_sent_date
     ,month_of_invoice_sent_date
     ,SUM(returns) AS sum_of_quantity_returned
     ,SUM(returns * unit_price) AS sum_of_dollar_amount_of_returns
FROM base
GROUP BY
    1, 2, 3, 4, 5, 6
