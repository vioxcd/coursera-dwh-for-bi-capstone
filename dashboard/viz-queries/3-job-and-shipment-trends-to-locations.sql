select
    w_location_d.location_id
    ,w_location_d.location_name
    ,w_time_d.time_year
    ,w_time_d.time_month
    ,w_time_d.time_week
    ,round(avg(w_sales_class_d.base_price), 3) as total_base_price
from dw_job_f
    inner join w_location_d
        on dw_job_f.location_id = w_location_d.location_id
    inner join w_customer_d
        on dw_job_f.cust_id_ordered_by = w_customer_d.cust_key
    inner join w_sales_class_d
        on dw_job_f.sales_class_id = w_sales_class_d.sales_class_id
    inner join w_sales_agent_d
        on dw_job_f.sales_agent_id = w_sales_agent_d.sales_agent_id
    inner join w_time_d
        on dw_job_f.date_ship_by = w_time_d.time_id
group by 1, 2, 3, 4, 5
order by 1, 2, 3, 4, 5
