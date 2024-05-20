{{ config(materialized='table', location='output/annual_air_quality_by_country.csv', format='csv')}}
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

