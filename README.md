# Air Quality Analysis with dbt and DuckDB

This is a simple project using DuckDB and dbt. The repository contains two models based on the [WHO Air Quality Dataset](https://www.who.int/data/gho/data/themes/air-pollution/who-air-quality-database) that is hosted on a public S3 bucket as a parquet file. The `dbt` pipelines output two CSVs in the `output/` folder. While the bucket is public, you would be required to set up `S3_ACCESS_KEY_ID` and `S3_SECRET_ACCESS_KEY` environment variables (can be dummy values) to run the pipeline.

## Development

### Install Dependencies

This project uses the [dbt-duckdb](https://github.com/jwills/dbt-duckdb) adapter for DuckDB. You can install it by running:

~~~bash
poetry install
~~~

This will include dbt, the dbt-duckdb adapter, and duckdb.

### Running the Pipeline

1. In the root directory of the project, run:
~~~bash
poetry shell
~~~

2. Inside the dbt project directory /dbt_duckdb_air_quality, run:
~~~bash
dbt run
~~~
