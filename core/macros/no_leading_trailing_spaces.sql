{% test no_leading_trailing_spaces(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} != TRIM({{ column_name }})

{% endtest %}