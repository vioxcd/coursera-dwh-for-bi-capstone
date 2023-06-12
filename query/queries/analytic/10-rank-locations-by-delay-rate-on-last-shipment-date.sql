with
calculated_annual_last_shipment_delay_by_location as (
    select
        location_name
         ,w_time_d.time_year as year_by_date_promised
		-- is this actually correct? I thought rate would mean total_delayed / total_ordered
         ,sum(quantity_ordered - total_delayed_ship_amount) / sum(quantity_ordered) as delay_rate
         ,sum(last_shipment_delay_days) as annual_last_shipment_delay
    from base_last_shipment_delays_involving_date_promised base
        inner join w_time_d
            on base.date_promised = w_time_d.time_id
    group by 1, 2
)

select
    *
    ,rank() over (partition by year_by_date_promised order by delay_rate)
from calculated_annual_last_shipment_delay_by_location
