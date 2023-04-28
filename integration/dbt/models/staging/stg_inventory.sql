{{ config(materialized = "view", tags = "staging") }}

WITH non_null_entries AS (
	SELECT *
	FROM {{ source('inventory','inventory_fact_raw') }}
	WHERE branchplantkey IS NOT NULL
		AND date IS NOT NULL
		AND itemmasterkey IS NOT NULL
		AND transtypekey IS NOT NULL
		AND custvendorkey IS NOT NULL
		AND unitcost IS NOT NULL
		AND currency IS NOT NULL
		AND quantity IS NOT NULL
),

converted_to_dtypes_entries AS (
	SELECT SPLIT_PART(branchplantkey, '.', 1)::INTEGER AS branchplantkey,
		date::DATE,
		SPLIT_PART(itemmasterkey, '.', 1)::INTEGER AS itemmasterkey,
		SPLIT_PART(transtypekey, '.', 1)::INTEGER AS transtypekey,
		SPLIT_PART(custvendorkey, '.', 1)::INTEGER AS custvendorkey,
		unitcost::NUMERIC AS source_unitcost,  -- rename as source to avoid "ambiguous" error on `SELECT *`
		currency,
		SPLIT_PART(quantity, '.', 1)::INTEGER AS quantity
	FROM non_null_entries
),

valid_dates AS (
	SELECT datekey,
		MAKE_DATE(calyear, calmonth, calday) AS _date_dim
	FROM {{ source('inventory','date_dim') }}
),

keep_entries_with_valid_dates AS (
	SELECT c.*,
		v.datekey
	FROM converted_to_dtypes_entries c
	JOIN valid_dates v
	ON c.date = v._date_dim  -- JOIN on a non-key column
),

keep_entries_with_valid_fk_references AS (
	SELECT *
	FROM keep_entries_with_valid_dates
	WHERE branchplantkey IN (SELECT branchplantkey FROM inventory.branch_plant_dim)
		AND itemmasterkey IN (SELECT itemmasterkey FROM inventory.item_master_dim)
		AND transtypekey IN (SELECT transtypekey FROM inventory.trans_type_dim)
		AND custvendorkey IN (SELECT custvendorkey FROM inventory.cust_vendor_dim)
),

-- Should've been in an intermediate layer along with the JOIN actually
compute_unitcost_and_extcost AS (
	SELECT t.*,
		t.source_unitcost * cd.exchange_rate AS unitcost,
		(t.source_unitcost  * cd.exchange_rate) * quantity AS extcost
	FROM keep_entries_with_valid_fk_references AS t
	JOIN {{ source('inventory','currency_dim') }} AS cd
	ON t.currency = cd.currency_id
),

-- Reorder columns
final AS (
	SELECT
		branchplantkey,
		datekey,
		itemmasterkey,
		transtypekey,
		custvendorkey,
		unitcost,
		quantity,
		extcost
	FROM compute_unitcost_and_extcost
)

SELECT * FROM final
