{{ config(materialized='table', location='output/top_10_cities_pm25.csv', format='csv')}}

WITH latest_year AS (
    SELECT MAX(year) AS year
    FROM {{ ref('stg_air_quality') }}
)
SELECT 
    city, 
    country_name, 
    stg_air_quality.year, 
    AVG(pm25_concentration) AS avg_pm25 
FROM 
    {{ ref('stg_air_quality') }},
    latest_year
WHERE 
    stg_air_quality.year = latest_year.year
GROUP BY 
    city, 
    country_name, 
    stg_air_quality.year
ORDER BY 
    avg_pm25 DESC
LIMIT 10
