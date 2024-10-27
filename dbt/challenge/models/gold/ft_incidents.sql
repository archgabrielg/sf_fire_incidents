WITH fire_incidents AS (
    SELECT *
    FROM {{ref('fire_incidents')}}
),

incidents_data AS (
    SELECT
        incident_number,
        exposure_number,
        incident_date,
        call_number,
        city,
        zip_code,
        CAST(SUBSTR(battalion, 2, 3) AS INT) AS battalion_number,
        station_area,
        suppression_units,
        suppression_personnel,
        ems_units,
        ems_personnel,
        other_units,
        other_personnel,
        first_unit_on_scene,
        estimated_property_loss,
        estimated_contents_loss,
        fire_fatalities,
        fire_injuries,
        civilian_fatalities,
        civilian_injuries,
        number_of_alarms,
        primary_situation_code,
        primary_situation_description,
        action_taken_primary_code,
        action_taken_primary_description,
        property_use_code,
        property_use_description,
        supervisor_district,
        neighborhood_district,
        point_coordinates,
        data_loaded_at
    FROM fire_incidents
),

fact_incidents AS (
    SELECT
        incident_number,
        exposure_number,
        CASE
            WHEN incident_date IS NOT NULL THEN {{dbt_utils.generate_surrogate_key(['incident_date']) }}
            ELSE '-1'
        END AS date_fk,
        CASE
            WHEN city IS NOT NULL THEN {{dbt_utils.generate_surrogate_key(['city']) }}
            ELSE '-1'
        END AS city_fk,
        CASE
            WHEN neighborhood_district IS NOT NULL THEN {{dbt_utils.generate_surrogate_key(['neighborhood_district']) }}
            ELSE '-1'
        END AS district_fk,
        CASE
            WHEN battalion_number IS NOT NULL THEN {{dbt_utils.generate_surrogate_key(['battalion_number']) }}
            ELSE '-1'
        END AS battalion_fk,
        call_number,
        zip_code,
        station_area,
        suppression_units,
        suppression_personnel,
        ems_units,
        ems_personnel,
        other_units,
        other_personnel,
        first_unit_on_scene,
        estimated_property_loss,
        estimated_contents_loss,
        fire_fatalities,
        fire_injuries,
        civilian_fatalities,
        civilian_injuries,
        number_of_alarms,
        primary_situation_code,
        primary_situation_description,
        action_taken_primary_code,
        action_taken_primary_description,
        property_use_code,
        property_use_description,
        supervisor_district,
        point_coordinates,
        data_loaded_at AS last_update,
        CURRENT_TIMESTAMP AS audit_date
    FROM incidents_data
)

SELECT *
FROM fact_incidents