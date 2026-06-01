{% test no_leading_trailing_spaces(model, column_name) %}
-- Fails if any row has a value that differs from its trimmed version.
SELECT *
FROM {{ model }}
WHERE {{ column_name }} != TRIM({{ column_name }})
{% endtest %}