with
calculated_sales_class_returns as (
    select
        sales_class_description
        ,year_of_invoice_sent_date
        ,sum(sum_of_quantity_returned) as annual_quantity_returned
    from base_returns_by_location_and_sales_class
    group by
        1, 2
)

-- ratio to report calculation
-- https://stackoverflow.com/a/35976447
select
    *
    ,1.0 * annual_quantity_returned / NULLIF(SUM(annual_quantity_returned) over (partition by year_of_invoice_sent_date)
        , 0) as annual_quantity_returned_ratio_to_report
from calculated_sales_class_returns
order by year_of_invoice_sent_date, annual_quantity_returned_ratio_to_report
