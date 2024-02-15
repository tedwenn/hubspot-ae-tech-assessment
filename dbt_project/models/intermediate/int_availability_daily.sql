WITH

  sequences AS (
    SELECT
      listing_id
      ,date
      ,minimum_nights
      ,maximum_nights
      ,ROW_NUMBER() OVER(PARTITION BY listing_id ORDER BY date ASC)
      - ROW_NUMBER() OVER(PARTITION BY listing_id, available ORDER BY date ASC) AS sequence_id
    FROM
      {{ ref('stg_calendar') }}
    QUALIFY
      available -- needed unavailable for sequence calcs, but we don't need them going forward
  )

SELECT
  listing_id
  ,date
  ,minimum_nights
  ,LEAST(
    DATE_DIFF(MAX(date) OVER(PARTITION BY listing_id, sequence_id), date, DAY)
    ,maximum_nights
  ) AS maximum_nights
FROM
  sequences
QUALIFY
  maximum_nights >= minimum_nights
