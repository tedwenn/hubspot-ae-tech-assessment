{% macro create_udf_json_string_to_array() %}
CREATE OR REPLACE FUNCTION `{{ target.project }}`.`{{ target.dataset }}`.JsonStringToArray(json_str STRING) RETURNS ARRAY<STRING> LANGUAGE js AS '''
  return JSON.parse(json_str).map(String);
''';
{% endmacro %}
