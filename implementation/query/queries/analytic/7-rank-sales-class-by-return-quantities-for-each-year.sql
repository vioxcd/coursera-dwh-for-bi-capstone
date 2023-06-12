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

select
    *
    ,rank() over (partition by year_of_invoice_sent_date
                    order by annual_quantity_returned desc
        ) as annual_quantity_returned_rank
from calculated_sales_class_returns
