{% macro create_udf_amenities_to_str() %}
CREATE OR REPLACE FUNCTION `{{ target.project }}`.`{{ target.dataset }}`.AMENITIES_TO_STRING(amenities ARRAY<STRING>) RETURNS STRING AS (
  ARRAY_TO_STRING(ARRAY(SELECT DISTINCT amenity FROM UNNEST(amenities) AS amenity ORDER BY amenity ASC), ',')
);
{% endmacro %}
