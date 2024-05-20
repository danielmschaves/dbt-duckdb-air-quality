{{ config(materialized='table', location='output/stg_air_quality.csv', format='csv')}}
SELECT 
    country_name,
    city,
    year,
    pm10_concentration,
    pm25_concentration,
    no2_concentration,
    population
FROM 
    {{ source('external_source', 'who_ambient_air_quality_database_version_v6_april_2023') }}