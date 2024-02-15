{{ config(
    pre_hook="{{ create_udf_json_string_to_array() }}"
) }}

SELECT
  LISTING_ID AS listing_id
  ,PARSE_DATETIME('%Y-%m-%d %H:%M:%E*S', change_at) AS change_at
  ,`{{ target.project }}`.`{{ target.dataset }}`.JsonStringToArray(amenities) AS amenities
FROM
  {{ ref('seed_amenities_changelog') }}
