select
    location_name
     ,year_of_job_contract_date
     ,month_of_job_contract_date
     ,sum(sum_of_job_amount) over (partition by location_name, year_of_job_contract_date
                                    order by month_of_job_contract_date
                                    rows between unbounded preceding and current row
         ) as sum_of_job_amount_ordered
from base_location_and_sales_class_summary_for_job
