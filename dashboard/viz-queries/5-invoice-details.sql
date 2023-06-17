select
    invoice_id
    ,invoice_amount
    ,wscd.sales_class_desc
    ,wld.location_name
    ,invoice_due_date
    ,wtd.time_day
    ,wtd.time_month
    ,wtd.time_year
    ,wcd.cust_key
    ,wcd.cust_name
from w_invoiceline_f
    inner join w_sales_class_d wscd
        on w_invoiceline_f.sales_class_id = wscd.sales_class_id
    inner join w_location_d wld
        on w_invoiceline_f.location_id = wld.location_id
    inner join w_customer_d wcd
        on w_invoiceline_f.cust_key = wcd.cust_key
    inner join w_time_d wtd
        on w_invoiceline_f.invoice_due_date = wtd.time_id
