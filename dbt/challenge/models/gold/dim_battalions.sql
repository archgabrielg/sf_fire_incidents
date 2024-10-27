WITH fire_incidents AS (
    SELECT *
    FROM {{ref('fire_incidents')}}
),

null_record AS (
    SELECT
        '-1' AS battalion_pk,
        NULL::int AS battalion_number,
        NULL AS battalion_description
),

unique_batallions AS (
    SELECT battalion
    FROM fire_incidents
    WHERE battalion IS NOT NULL
    GROUP BY battalion
),

batallions_data AS (
    SELECT
        CAST(SUBSTR(battalion, 2, 3) AS INT) AS battalion_number,
        CONCAT('Batallion ', SUBSTR(battalion, 2, 3)) AS battalion_description
    FROM unique_batallions
),

dim_battalion AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['battalion_number']) }} AS battalion_pk,
        battalion_number,
        battalion_description,
        CURRENT_TIMESTAMP AS audit_date
    FROM batallions_data
    UNION
    SELECT
        battalion_pk,
        battalion_number,
        battalion_description,
        CURRENT_TIMESTAMP AS audit_date
    FROM null_record
)

SELECT *
FROM dim_battalion
