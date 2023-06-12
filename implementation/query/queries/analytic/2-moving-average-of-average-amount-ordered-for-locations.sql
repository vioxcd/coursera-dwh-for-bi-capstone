select
    location_name
     ,year_of_job_contract_date
     ,month_of_job_contract_date
     ,avg(sum_of_job_amount) over (partition by location_name
									order by year_of_job_contract_date, month_of_job_contract_date
									rows between 11 preceding and current row
    ) as avg_job_amount_ordered
from base_location_and_sales_class_summary_for_job
