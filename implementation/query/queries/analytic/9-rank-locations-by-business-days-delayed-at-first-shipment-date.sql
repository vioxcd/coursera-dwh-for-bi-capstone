with
    calculated_annual_first_shipment_delay_by_location as (
        select
            location_name
             ,w_time_d.time_year as year_by_date_ship_by
             ,sum(first_shipment_delay_days) as annual_first_shipment_delay
        from base_first_shipment_delays_involving_shipped_by_date base
            inner join w_time_d
                on base.date_ship_by = w_time_d.time_id
        group by 1, 2
    )

select
    *
     ,rank() over (partition by year_by_date_ship_by order by annual_first_shipment_delay)
from calculated_annual_first_shipment_delay_by_location
