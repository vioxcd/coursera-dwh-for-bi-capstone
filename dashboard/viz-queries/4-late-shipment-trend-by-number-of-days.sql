select
    job_shipment_id
    ,getbusdaysdiff(date1 := actual_ship_date, date2 := requested_ship_date) as days_late
from w_job_shipment_f
