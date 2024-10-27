CREATE SCHEMA IF NOT EXISTS data_bronze;

CREATE TABLE data_bronze.fire_incidents (
	incident_number TEXT,
	exposure_number TEXT,
	id TEXT,
	address TEXT,
	incident_date TEXT,
	call_number TEXT,
	alarm_dttm TEXT,
	arrival_dttm TEXT,
	close_dttm TEXT,
	city TEXT,
	zipcode TEXT,
	battalion TEXT,
	station_area TEXT,
	suppression_units TEXT,
	suppression_personnel TEXT,
	ems_units TEXT,
	ems_personnel TEXT,
	other_units TEXT,
	other_personnel TEXT,
	first_unit_on_scene TEXT,
	estimated_property_loss TEXT,
	estimated_contents_loss TEXT,
	fire_fatalities TEXT,
	fire_injuries TEXT,
	civilian_fatalities TEXT,
	civilian_injuries TEXT,
	number_of_alarms TEXT,
	primary_situation TEXT,
	mutual_aid TEXT,
	action_taken_primary TEXT,
	property_use TEXT,
	supervisor_district TEXT,
	neighborhood_district TEXT,
	point TEXT,
	data_as_of TEXT,
	data_loaded_at TEXT,
	action_taken_secondary TEXT,
	action_taken_other TEXT,
	area_of_fire_origin TEXT,
	ignition_cause TEXT,
	ignition_factor_primary TEXT,
	heat_source TEXT,
	item_first_ignited TEXT,
	human_factors_associated_with_ignition TEXT,
	structure_type TEXT,
	structure_status TEXT,
	floor_of_fire_origin TEXT,
	fire_spread TEXT,
	no_flame_spread TEXT,
	number_of_floors_with_minimum_damage TEXT,
	number_of_floors_with_significant_damage TEXT,
	number_of_floors_with_heavy_damage TEXT,
	number_of_floors_with_extreme_damage TEXT,
	detectors_present TEXT,
	detector_type TEXT,
	detector_operation TEXT,
	detector_failure_reason TEXT,
	automatic_extinguishing_system_present TEXT,
	number_of_sprinkler_heads_operating TEXT,
	detector_alerted_occupants TEXT,
	detector_effectiveness TEXT,
	automatic_extinguishing_sytem_type TEXT,
	automatic_extinguishing_sytem_perfomance TEXT,
	box TEXT,
	ignition_factor_secondary TEXT,
	automatic_extinguishing_sytem_failure_reason TEXT,
    audit_date TIMESTAMPTZ
);