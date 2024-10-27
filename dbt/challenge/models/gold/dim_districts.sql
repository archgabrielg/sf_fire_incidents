WITH fire_incidents AS (
    SELECT *
    FROM {{ref('fire_incidents')}}
),

null_record AS (
    SELECT
        '-1' AS district_pk,
        NULL AS district_name
),

unique_districts AS (
    SELECT neighborhood_district
    FROM fire_incidents
    WHERE neighborhood_district IS NOT NULL
    GROUP BY neighborhood_district
),

dim_districts AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['neighborhood_district']) }} AS district_pk,
    neighborhood_district AS district_name,
    CURRENT_TIMESTAMP AS audit_date
    FROM unique_districts
    UNION
    SELECT
        district_pk,
        district_name,
        CURRENT_TIMESTAMP AS audit_date
    FROM null_record
)
SELECT *
FROM dim_districts