{{ config(
    pre_hook="{{ create_udf_json_string_to_array() }}"
) }}

SELECT
  ID AS id
  ,NAME AS name
  ,HOST_ID AS host_id
  ,HOST_NAME AS host_name
  ,PARSE_DATETIME('%Y-%m-%d %H:%M:%S', HOST_SINCE) AS host_since
  ,HOST_LOCATION AS host_location
  ,`{{ target.project }}`.`{{ target.dataset }}`.JsonStringToArray(HOST_VERIFICATIONS) AS host_verifications
  ,NEIGHBORHOOD AS neighborhood
  ,PROPERTY_TYPE AS property_type
  ,ROOM_TYPE AS room_type
  ,ACCOMMODATES AS accommodates
  ,BATHROOMS_TEXT AS bathrooms_text
  ,BEDROOMS AS bedrooms
  ,BEDS AS beds
  ,`{{ target.project }}`.`{{ target.dataset }}`.JsonStringToArray(AMENITIES) AS amenities
  ,PRICE AS price
  ,NUMBER_OF_REVIEWS AS number_of_reviews
  ,FIRST_REVIEW AS first_review
  ,LAST_REVIEW AS last_review
  ,REVIEW_SCORES_RATING AS review_scores_rating
FROM
  {{ ref('seed_listings') }}
