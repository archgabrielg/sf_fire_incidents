{% macro extract_code(string) %}
    
    CASE 
    WHEN POSITION('-' IN {{ string }}) > 0 THEN LEFT({{ string }}, POSITION('-' IN {{ string }}) - 1)
    ELSE NULL
    END

{% endmacro %}