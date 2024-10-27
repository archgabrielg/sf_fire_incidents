WITH fire_incidents AS (
    SELECT *
    FROM {{ref('fire_incidents')}}
),

null_record AS (
    SELECT
        '-1' AS city_pk,
        NULL AS city_name
),

unique_cities AS (
    SELECT city
    FROM fire_incidents
    WHERE city IS NOT NULL
    GROUP BY city
),

dim_cities AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['city']) }} AS city_pk,
        city AS city_name,
        CURRENT_TIMESTAMP AS audit_date
    FROM unique_cities
    UNION
    SELECT
        city_pk,
        city_name,
        CURRENT_TIMESTAMP AS audit_date
    FROM null_record
)
SELECT *
FROM dim_cities