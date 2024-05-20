{{ config(materialized='table', location='output/air_quality_trends_major_cities.csv', format='csv')}}
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
