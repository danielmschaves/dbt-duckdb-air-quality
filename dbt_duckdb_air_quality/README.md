# Air Quality Analysis with dbt and DuckDB

## Overview

This project leverages dbt (data build tool) and DuckDB to analyze air quality data sourced from the World Health Organization (WHO). The goal is to create a structured data model that provides insights into air quality trends, comparisons, and rankings across various cities and countries.

### References

1. **dbt-duckdb Project**
   - The dbt-duckdb adapter allows the use of DuckDB with dbt. DuckDB is an in-process SQL OLAP database management system. It is designed to support analytical query workloads, such as large-scale data transformation and analysis.
   - The project is inspired by the [dbt-duckdb tutorial by Mehdi](https://github.com/mehd-io/dbt-duckdb-tutorial).

2. **Dataset**
   - The dataset used in this project is the WHO Ambient Air Quality Database (version 6, April 2023). This dataset includes measurements of PM2.5, PM10, and NO2 concentrations for various cities worldwide.

3. **World Health Organization (WHO)**
   - WHO is a specialized agency of the United Nations responsible for international public health. The WHO air quality database compiles air quality measurements to help monitor and address air pollution globally.

## Data Models

The project consists of two main data models: **staging** and **core**.

### Staging Model

The staging model consolidates all necessary columns from the source data into a single table. This table serves as a reference for the core model queries.

### Query

~~~sql

SELECT 
    city, 
    country, 
    year, 
    date, 
    pm25_concentration, 
    pm10_concentration, 
    no2_concentration
FROM 
    {{ source('external_source', 'who_ambient_air_quality_database_version_v6_april_2023') }}
~~~

### Core Model

The core model uses the staging table to create various structured queries that provide insights into air quality.

### Queries

1. **Air Quality Ranking:**
~~~sql
SELECT 
    city, 
    year, 
    CASE
        WHEN AVG(pm25_concentration) <= 10 AND AVG(pm10_concentration) <= 20 AND AVG(no2_concentration) <= 40 THEN 'Good'
        WHEN AVG(pm25_concentration) > 10 AND AVG(pm10_concentration) > 20 AND AVG(no2_concentration) > 40 THEN 'Poor'
        ELSE 'Moderate'
    END as air_quality_rating
FROM 
    {{ ref('stg_air_quality') }}
GROUP BY 
    city, 
    year
ORDER BY 
    city, 
    year
~~~

2. **Air Quality in Berlin:**
~~~sql
SELECT
    year, AVG(pm25_concentration) AS avg_pm25, AVG(pm10_concentration) AS avg_pm10, AVG(no2_concentration) AS avg_no2 
FROM 
    {{ ref('stg_air_quality') }}
    WHERE
        city = 'Berlin' 
GROUP BY 
    year 
ORDER BY 
    year DESC
~~~

3. **Annual Average Air Quality by Country:**

~~~sql

SELECT 
    country_name, 
    year, 
    AVG(pm25_concentration) AS avg_pm25, 
    AVG(pm10_concentration) AS avg_pm10, 
    AVG(no2_concentration) AS avg_no2,
    CASE
        WHEN AVG(pm25_concentration) <= 10 AND AVG(pm10_concentration) <= 20 AND AVG(no2_concentration) <= 40 THEN 'Good'
        WHEN AVG(pm25_concentration) > 10 AND AVG(pm10_concentration) > 20 AND AVG(no2_concentration) > 40 THEN 'Poor'
        ELSE 'Moderate'
    END as air_quality_rating
FROM 
    {{ ref('stg_air_quality') }}
GROUP BY 
    country_name, 
    year
ORDER BY 
    country_name, 
    year
~~~

4. **Top 10 Cities with the Highest PM2.5 Concentration:**
~~~sql
SELECT 
    country_name, 
    year, 
    AVG(pm25_concentration) AS avg_pm25, 
    AVG(pm10_concentration) AS avg_pm10, 
    AVG(no2_concentration) AS avg_no2,
    CASE
        WHEN AVG(pm25_concentration) <= 10 AND AVG(pm10_concentration) <= 20 AND AVG(no2_concentration) <= 40 THEN 'Good'
        WHEN AVG(pm25_concentration) > 10 AND AVG(pm10_concentration) > 20 AND AVG(no2_concentration) > 40 THEN 'Poor'
        ELSE 'Moderate'
    END as air_quality_rating
FROM 
    {{ ref('stg_air_quality') }}
GROUP BY 
    country_name, 
    year
ORDER BY 
    country_name, 
    year
~~~

5. **Air Quality Trends in Major Cities:**
~~~sql
SELECT 
    city, 
    year, 
    AVG(pm25_concentration) AS avg_pm25, 
    AVG(pm10_concentration) AS avg_pm10, 
    AVG(no2_concentration) AS avg_no2 
FROM 
    {{ ref('stg_air_quality') }}
WHERE 
    city IN ('New York', 'London', 'Beijing')
GROUP BY 
    city, 
    year
ORDER BY 
    city, 
    year
~~~

## Conclusion
This project demonstrates the power of dbt and DuckDB in transforming and analyzing large-scale air quality data. By creating structured data models, we can gain valuable insights into air quality trends and comparisons across different regions. The models and queries presented here provide a comprehensive framework for analyzing air quality data and can be easily extended to include additional analyses and visualizations.