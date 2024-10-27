{% macro extract_description(string) %}
    
    CASE 
    WHEN POSITION('-' IN {{ string }}) > 0 THEN TRIM(RIGHT({{ string }}, length({{ string }}) - POSITION('-' IN {{ string }})))
    ELSE {{ string }}
    END

{% endmacro %}