select
    wld.location_id
     ,wld.location_name
     ,wtd.time_year
     ,unnest(array['sales', 'forecast']) as label
     ,unnest(array[round(sum(actual_amount)), round(sum(forcast_amount))]) as amount
from w_financial_summary_sales_f
    inner join w_location_d wld on w_financial_summary_sales_f.location_id = wld.location_id
    inner join w_time_d wtd on w_financial_summary_sales_f.report_begin_date_id = wtd.time_id
group by 1, 2, 3
order by 1, 2, 3
-- select
--     wld.location_id
--      ,wld.location_name
--      ,wtd.time_year
--      ,sum(actual_amount) as total_sales_amount
--      ,sum(forcast_amount) as total_forecast_amount
-- from w_financial_summary_sales_f
--     inner join w_location_d wld on w_financial_summary_sales_f.location_id = wld.location_id
--     inner join w_time_d wtd on w_financial_summary_sales_f.report_begin_date_id = wtd.time_id
-- group by 1, 2, 3
-- order by 1, 2, 3

