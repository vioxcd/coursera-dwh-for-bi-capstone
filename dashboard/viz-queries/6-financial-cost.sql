with
all_costs as (
    select
        wld.location_id
         ,wld.location_name
         ,wmtd.machine_type_id
         ,wmtd.machine_model
         ,sum(actual_labor_cost) as total_labor_cost
         ,sum(actual_machine_cost) as total_machine_cost
         ,sum(budget_overhead_cost) as total_budget_overhead_cost
         ,dense_rank() over (order by sum(budget_overhead_cost) desc) as rank_of_budget_overhead_cost
         ,sum(wmtd.number_of_machines) as total_number_of_machines
    from w_financial_summary_cost_f
             inner join w_location_d wld on w_financial_summary_cost_f.location_id = wld.location_id
             inner join w_machine_type_d wmtd on w_financial_summary_cost_f.machine_type_id = wmtd.machine_type_id
    group by 1, 2, 3, 4
),

max_rank_of_budget_overhead as (
    select max(rank_of_budget_overhead_cost) as max_budget_overhead_rank from all_costs
),

calculated_budget_overhead_bins as (
    select
        *
         ,width_bucket(rank_of_budget_overhead_cost, 1, max_budget_overhead_rank, 5) as budget_overhead_bins
    from all_costs, max_rank_of_budget_overhead
    order by 1, 3
)

select
    location_id
     ,location_name
     ,machine_type_id
     ,machine_model
     ,total_labor_cost
     ,total_machine_cost
     ,total_budget_overhead_cost
     ,rank_of_budget_overhead_cost
     ,total_number_of_machines
     ,budget_overhead_bins
from calculated_budget_overhead_bins
order by 1, 3
