{% macro create_udf_json_string_to_array() %}
CREATE OR REPLACE FUNCTION `{{ target.project }}`.`{{ target.dataset }}`.JsonStringToArray(json_str STRING) RETURNS ARRAY<STRING> LANGUAGE js AS '''
  // Parse the JSON string and convert each element to lowercase
  const lowercaseArray = JSON.parse(json_str).map(item => String(item).toLowerCase());
  
  // Remove duplicates by converting the array to a Set and then back to an array
  const uniqueLowercaseArray = [...new Set(lowercaseArray)];
  
  return uniqueLowercaseArray;
''';
{% endmacro %}
