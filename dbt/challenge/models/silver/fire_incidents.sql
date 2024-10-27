WITH raw_fire_incidents AS (
    SELECT *
    FROM {{ source('API','fire_incidents') }}
),
last_data AS (
    SELECT *
    FROM raw_fire_incidents
    WHERE data_loaded_at = (SELECT MAX(data_loaded_at) FROM raw_fire_incidents)
),
clean_data AS (
    SELECT
        CAST(incident_number AS BIGINT) AS incident_number,
        CAST(exposure_number AS INT) AS exposure_number,
	    address,
	    CAST(incident_date AS DATE) AS incident_date,
	    call_number,
	    CAST(alarm_dttm AS TIMESTAMP) AS alarm_datetime,
	    CAST(arrival_dttm AS TIMESTAMP) AS arrival_datetime,
	    CAST(close_dttm AS TIMESTAMP) AS close_datetime,
        CASE
            WHEN city IN ('SF', 'SFO', 'SAN FRANCISCO') THEN 'San Francisco'
            WHEN city IN ('PR', 'PRESIDIO') THEN 'Presidio'
            WHEN city IN ('TI', 'Treasure Isla', 'TREASURE ISLAND') THEN 'Treasure Island'
            WHEN city IN ('FM', 'FORT MASON') THEN 'Fort Mason'
            WHEN city IN ('HP') THEN 'Hunters Point'
            WHEN city IN ('YB') THEN 'Yerba Buena'
            WHEN city IN ('BN') THEN 'Brisbane'
            WHEN city IN ('DC') THEN 'Daly City'
            WHEN city IN ('OAK') THEN 'Oakland'
            WHEN city IN ('AI') THEN 'Angel Island'
            ELSE city
        END AS city,
	    zipcode AS zip_code,
	    battalion,
	    station_area,
	    CAST(suppression_units AS INT) AS suppression_units,
	    CAST(suppression_personnel AS INT) AS suppression_personnel,
	    CAST(ems_units AS INT) AS ems_units,
	    CAST(ems_personnel AS INT) AS ems_personnel,
	    CAST(other_units AS INT) AS other_units,
	    CAST(other_personnel AS INT) AS other_personnel,
	    first_unit_on_scene,
	    CAST(estimated_property_loss AS FLOAT) AS estimated_property_loss,
	    CAST(estimated_contents_loss AS FLOAT) AS estimated_contents_loss,
	    CAST(fire_fatalities AS INT) AS fire_fatalities,
	    CAST(fire_injuries AS INT) AS fire_injuries,
	    CAST(civilian_fatalities AS INT) AS civilian_fatalities,
	    CAST(civilian_injuries AS INT) AS civilian_injuries,
	    CAST(number_of_alarms AS INT) AS number_of_alarms,
        {{ extract_code('primary_situation') }} AS primary_situation_code,
        {{ extract_description('primary_situation') }} AS primary_situation_description,
	    CASE
            WHEN mutual_aid = 'None' THEN NULL
            ELSE mutual_aid
        END AS mutual_aid,
        {{ extract_code('action_taken_primary') }} AS action_taken_primary_code,
        {{ extract_description('action_taken_primary') }} AS action_taken_primary_description,
        {{ extract_code('property_use') }} AS property_use_code,
        {{ extract_description('property_use') }} AS property_use_description,
	    CAST(supervisor_district AS INT) AS supervisor_district,
	    neighborhood_district,
        REPLACE(point, '''', '"')::json->>'type' AS point_type,
        REPLACE(point, '''', '"')::json->>'coordinates' AS point_coordinates,
	    CAST(data_as_of AS TIMESTAMP) AS data_as_of,
        CAST(data_loaded_at AS TIMESTAMP) AS data_loaded_at,
        {{ extract_code('action_taken_secondary') }} AS action_taken_secondary_code,
        {{ extract_description('action_taken_secondary') }} AS action_taken_secondary_description,
	    {{ extract_code('action_taken_other') }} AS action_taken_other_code,
        {{ extract_description('action_taken_other') }} AS action_taken_other_description,
        {{ extract_code('area_of_fire_origin') }} AS area_of_fire_origin_code,
        {{ extract_description('area_of_fire_origin') }} AS area_of_fire_origin_description,
        {{ extract_code('ignition_cause') }} AS ignition_cause_code,
        {{ extract_description('ignition_cause') }} AS ignition_cause_description,
        {{ extract_code('ignition_factor_primary') }} AS ignition_factor_primary_code,
        {{ extract_description('ignition_factor_primary') }} AS ignition_factor_primary_description,
        {{ extract_code('heat_source') }} AS heat_source_code,
        {{ extract_description('heat_source') }} AS heat_source_description,
	    {{ extract_code('item_first_ignited') }} AS item_first_ignited_code,
        {{ extract_description('item_first_ignited') }} AS item_first_ignited_description,
        {{ extract_code('human_factors_associated_with_ignition') }} AS human_factors_associated_with_ignition_code,
        {{ extract_description('human_factors_associated_with_ignition') }} AS human_factors_associated_with_ignition_description,
	    {{ extract_code('structure_type') }} AS structure_type_code,
        {{ extract_description('structure_type') }} AS structure_type_description,
        {{ extract_code('structure_status') }} AS structure_status_code,
        {{ extract_description('structure_status') }} AS structure_status_description,
	    CAST(floor_of_fire_origin AS INT) AS floor_of_fire_origin,
        {{ extract_code('fire_spread') }} AS fire_spread_code,
        {{ extract_description('fire_spread') }} AS fire_spread_description,
	    no_flame_spread,
	    CAST(number_of_floors_with_minimum_damage AS INT) AS number_of_floors_with_minimum_damage,
	    CAST(number_of_floors_with_significant_damage AS INT) AS number_of_floors_with_significant_damage,
	    CAST(number_of_floors_with_heavy_damage AS INT) AS number_of_floors_with_heavy_damage,
	    CAST(number_of_floors_with_extreme_damage AS INT) AS number_of_floors_with_extreme_damage,
	    {{ extract_code('detectors_present') }} AS detectors_present_code,
        {{ extract_description('detectors_present') }} AS detectors_present_description,
        {{ extract_code('detector_type') }} AS detector_type_code,
        {{ extract_description('detector_type') }} AS detector_type_description,
        {{ extract_code('detector_operation') }} AS detector_operation_code,
        {{ extract_description('detector_operation') }} AS detector_operation_description,
        {{ extract_code('detector_failure_reason') }} AS detector_failure_reason_code,
        {{ extract_description('detector_failure_reason') }} AS detector_failure_reason_description,
        {{ extract_code('automatic_extinguishing_system_present') }} AS automatic_extinguishing_system_present_code,
        {{ extract_description('automatic_extinguishing_system_present') }} AS automatic_extinguishing_system_present_description,
	    CAST(number_of_sprinkler_heads_operating AS INT) AS number_of_sprinkler_heads_operating,
	    {{ extract_code('detector_alerted_occupants') }} AS detector_alerted_occupants_code,
        {{ extract_description('detector_alerted_occupants') }} AS detector_alerted_occupants_description,
        {{ extract_code('detector_effectiveness') }} AS detector_effectiveness_code,
        {{ extract_description('detector_effectiveness') }} AS detector_effectiveness_description,
        {{ extract_code('automatic_extinguishing_sytem_type') }} AS automatic_extinguishing_sytem_type_code,
        {{ extract_description('automatic_extinguishing_sytem_type') }} AS automatic_extinguishing_sytem_type_description,
        {{ extract_code('automatic_extinguishing_sytem_perfomance') }} AS automatic_extinguishing_sytem_perfomance_code,
        {{ extract_description('automatic_extinguishing_sytem_perfomance') }} AS automatic_extinguishing_sytem_perfomance_description,
	    box,
	    {{ extract_code('ignition_factor_secondary') }} AS ignition_factor_secondary_code,
        {{ extract_description('ignition_factor_secondary') }} AS ignition_factor_secondary_description,
	    automatic_extinguishing_sytem_failure_reason,
        CURRENT_TIMESTAMP AS audit_date
    FROM last_data
)
SELECT *
FROM clean_data