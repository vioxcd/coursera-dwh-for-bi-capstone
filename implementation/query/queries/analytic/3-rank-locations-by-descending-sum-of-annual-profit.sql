with
calculated_annual_profit as (
    select
        bq2.location_name
         ,bq2.year_of_job_contract_date
         ,sum(sum_of_invoice_amount - sum_of_total_cost) as annual_profit
    from base_location_invoice_revenue_summary bq2
             inner join base_location_subjob_cost_summary bq3
                        using (job_id, location_id, year_of_job_contract_date, month_of_job_contract_date)
    group by 1, 2
)

select
    *,
    rank() over (partition by year_of_job_contract_date
                 order by annual_profit desc
        ) as annual_rank_by_profit
from calculated_annual_profit
