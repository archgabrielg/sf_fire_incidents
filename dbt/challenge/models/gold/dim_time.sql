WITH dates AS (
    SELECT '2000-01-01'::DATE + sequence.day AS datum
	FROM generate_series(0,11000) AS sequence(day)
	GROUP BY sequence.day
),

null_record AS (
    SELECT
        '-1' AS date_pk,
        NULL::date AS date,
        NULL::int AS year,
        NULL::int AS month,
        NULL AS month_name,
        NULL::int AS day,
        NULL::int AS day_of_year,
        NULL AS weekday_name,
        NULL::int AS calendar_week,
        NULL AS year_month
),

dim_time AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['datum']) }} AS date_pk,
        datum as date,
        EXTRACT(year from datum) AS year,
        EXTRACT(month from datum) AS month,
        -- Localized month name
        to_char(datum, 'TMMonth') AS month_name,
        EXTRACT(day from datum) AS day,
        EXTRACT(doy from datum) AS day_of_year,
        -- Localized weekday
        to_char(datum, 'TMDay') AS weekday_name,
        -- ISO calendar week
        EXTRACT(week from datum) AS calendar_week,
        to_char(datum, 'yyyy/mm') AS year_month,
        CURRENT_TIMESTAMP AS audit_date
    FROM dates
    UNION
    SELECT
        date_pk,
        date,
        year,
        month,
        month_name,
        day,
        day_of_year,
        weekday_name,
        calendar_week,
        year_month,
        CURRENT_TIMESTAMP AS audit_date
    FROM null_record
)
SELECT *
FROM dim_time