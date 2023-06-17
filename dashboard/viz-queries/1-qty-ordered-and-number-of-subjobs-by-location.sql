select
	w_location_d.location_id
	,w_location_d.location_name
	,sum(dw_job_f.number_of_subjobs) as total_subjobs
	,sum(dw_job_f.quantity_ordered) as total_quantities
from dw_job_f
	inner join w_location_d
		on dw_job_f.location_id = w_location_d.location_id
	inner join w_customer_d
		on dw_job_f.cust_id_ordered_by = w_customer_d.cust_key
	inner join w_sales_class_d
		on dw_job_f.sales_class_id = w_sales_class_d.sales_class_id
	inner join w_sales_agent_d
		on dw_job_f.sales_agent_id = w_sales_agent_d.sales_agent_id
group by 1, 2
