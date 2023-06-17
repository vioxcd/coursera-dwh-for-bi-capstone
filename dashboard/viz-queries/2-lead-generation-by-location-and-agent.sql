select
    w_location_d.location_id
     ,w_location_d.location_name
     ,w_sales_agent_d.sales_agent_id
     ,w_sales_agent_d.sales_agent_name
     ,round(avg(dw_lead_f.quote_price), 2) as avg_quote_price
     ,sum(dw_lead_f.quote_qty) as total_quote_qty
     ,count(1) as total_jobs_booked
from dw_lead_f
         inner join w_sales_agent_d
                    on w_sales_agent_d.sales_agent_id = dw_lead_f.sales_agent_id
         inner join w_sales_class_d
                    on w_sales_class_d.sales_class_id = dw_lead_f.sales_class_id
         inner join w_location_d
                    on w_location_d.location_id = dw_lead_f.location_id
group by 1, 2, 3, 4
order by 1, 3
