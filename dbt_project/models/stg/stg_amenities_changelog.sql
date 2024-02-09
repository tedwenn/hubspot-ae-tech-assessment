{{ config(
    pre_hook="{{ create_udf_json_string_to_array() }}"
) }}

SELECT
  * EXCEPT(change_at, amenities)
  ,PARSE_DATETIME('%Y-%m-%d %H:%M:%S', change_at) AS change_at
  ,`{{ target.project }}`.`{{ target.dataset }}`.JsonStringToArray(amenities) AS amenities
FROM
  `hopeful-theorem-413815.source_hubspot_ae_tech_assessment.amenities_changelog`
