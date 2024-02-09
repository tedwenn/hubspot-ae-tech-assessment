{{ config(
    pre_hook="{{ create_udf_json_string_to_array() }}"
) }}

SELECT
  * EXCEPT(host_since, host_verifications, amenities)
  ,PARSE_DATETIME('%Y-%m-%d %H:%M:%S', host_since) AS host_since
  ,`{{ target.project }}`.`{{ target.dataset }}`.JsonStringToArray(host_verifications) AS host_verifications
  ,`{{ target.project }}`.`{{ target.dataset }}`.JsonStringToArray(amenities) AS amenities
FROM
  `hopeful-theorem-413815.source_hubspot_ae_tech_assessment.listings`
