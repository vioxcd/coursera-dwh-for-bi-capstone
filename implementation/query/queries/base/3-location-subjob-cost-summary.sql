CREATE VIEW base_location_subjob_cost_summary
AS
WITH
    base AS (
        SELECT
            dw_job_f.job_id
             ,w_location_d.location_id
             ,w_location_d.location_name
             ,time_year AS year_of_job_contract_date
             ,time_month AS month_of_job_contract_date
             ,SUM(cost_labor) AS sum_of_labor_cost
             ,SUM(cost_material) AS sum_of_material_cost
             ,SUM(machine_hours * rate_per_hour) AS sum_of_machine_cost
             ,SUM(cost_overhead) AS sum_of_overhead_cost
             ,SUM(quantity_produced) AS sum_of_quantity_produced
        FROM w_sub_job_f
            INNER JOIN w_location_d
                USING (location_id)
            INNER JOIN dw_job_f
                USING (job_id)
            INNER JOIN w_time_d
                ON w_time_d.time_id = dw_job_f.contract_date
            INNER JOIN w_machine_type_d
                USING (machine_type_id)
        GROUP BY
            1, 2, 3, 4, 5
    )

SELECT
    *
     ,(sum_of_labor_cost + sum_of_material_cost + sum_of_machine_cost + sum_of_overhead_cost) AS sum_of_total_cost
     ,(sum_of_labor_cost + sum_of_material_cost + sum_of_machine_cost + sum_of_overhead_cost) / sum_of_quantity_produced AS unit_cost
FROM base
