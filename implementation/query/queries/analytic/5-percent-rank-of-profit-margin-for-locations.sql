with
calculated_location_profit_margin as (
    select
        bq2.location_name
         ,sum(sum_of_invoice_amount - sum_of_total_cost) / sum(sum_of_invoice_amount) as location_profit_margin
    from base_location_invoice_revenue_summary bq2
        inner join base_location_subjob_cost_summary bq3
            using (job_id, location_id, year_of_job_contract_date, month_of_job_contract_date)
    group by 1
)

select
    *,
    percent_rank() over (order by location_profit_margin desc) as location_profit_margin_pct_rank
from calculated_location_profit_margin
