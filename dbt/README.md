# Mostly T using Inventory Dataset

## Usage

1. [Install dbt and configure](https://docs.getdbt.com/docs/get-started/getting-started-dbt-core) your `profiles.yml` (run `dbt debug` to check connection)
2. Rename `sample-setup` to `setup` and fill out `DB_USER`, `DB_PASS`, `DB_HOST` and `DB_NAME`. This file is used to create schema and insert dataset
3. Make it executable (`chmod +x setup`) and execute it (`./setup`) -- this operation might take several minutes
4. Peek out the data by doing `SELECT COUNT(1) FROM inventory.inventory_fact` -- would print out 18300 rows initially
5. Use `dbt run` to load new data to the inventory fact table
6. Run the `COUNT` as (4) and there are 10 new rows added

The code are in `models` directory

## Caveats

Running the model again and again using `dbt run` would replace the newly added rows by a new one

## Useful Links

- [Incremental Models](https://docs.getdbt.com/docs/build/incremental-models)
- [dbt Project Structure](https://docs.getdbt.com/guides/best-practices/how-we-structure/2-staging)
