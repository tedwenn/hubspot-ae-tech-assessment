{% macro create_amenity_encoding() %}
    
  {% if execute %}

    {% set query %}
      SELECT
        DISTINCT
        amenity
        ,'has_' || REGEXP_REPLACE(amenity, r"[^a-zA-Z0-9]", "_") AS amenity_field_name
      FROM
        {{ ref('stg_amenities_changelog') }}
      CROSS JOIN
        UNNEST(amenities) AS amenity
      ORDER BY
        amenity ASC
    {% endset %}
    
    {% set amenity_results = run_query(query) %}
        
    -- Begin constructing the SELECT statement with dynamic columns for amenities
    {% set select_query %}
      SELECT
        amenities
        ,`{{ target.project }}`.`{{ target.dataset }}`.AMENITIES_TO_STRING(amenities) AS amenities_str
        {% for row in amenity_results %}
          ,'{{ row.amenity }}' IN UNNEST(amenities) AS {{ row.amenity_field_name }}
        {% endfor %}
      FROM
        {{ ref('stg_amenities_changelog') }}
      QUALIFY
        ROW_NUMBER() OVER(PARTITION BY amenities_str) = 1
    {% endset %}

    {{ select_query }}
        
  {% endif %}
    
{% endmacro %}
