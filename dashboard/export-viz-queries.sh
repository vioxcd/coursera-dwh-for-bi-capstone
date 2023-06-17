#!/bin/bash

ARGS_LEN=$#
[ $ARGS_LEN == 0 ] && { echo "Missing parameters"; exit 1; }

source_sql=$1
target_csv="$(pwd)/dump/$(basename -s .sql "$1").csv"
tmp_file=tmp.sql

echo "DROP VIEW IF EXISTS tmp_view;" > "$tmp_file"
echo "CREATE OR REPLACE VIEW tmp_view AS" >> "$tmp_file"
cat "$source_sql" >> "$tmp_file"

PGPASSWORD=postgres psql \
	-h localhost -U postgres -d coursera_dwh \
	-c 'SET search_path = cpi_card' -f "$tmp_file"
PGPASSWORD=postgres psql \
	-h localhost -U postgres -d coursera_dwh \
	-c "\copy (select * from cpi_card.tmp_view) to '$target_csv' with (format csv, header);"

rm "$tmp_file"

