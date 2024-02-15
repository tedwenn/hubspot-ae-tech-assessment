SELECT
  LISTING_ID AS listing_id
  ,DATE AS date
  ,CASE WHEN AVAILABLE = 't' THEN TRUE
  WHEN AVAILABLE = 'f' THEN FALSE
  END AS available
  ,SAFE_CAST(RESERVATION_ID AS INT64) AS reservation_id
  ,PRICE AS price
  ,MINIMUM_NIGHTS AS minimum_nights
  ,MAXIMUM_NIGHTS AS maximum_nights
FROM
  {{ ref('seed_calendar') }}
