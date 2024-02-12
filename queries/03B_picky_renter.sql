/*

#3 - Long Stay / Picky Renter

(B)
  Write a variation of the maximum duration query above for listings
  that have both a lockbox and a first aid kit listed in the amenities.

Tip:
  For example, listing 10986 has a lockbox. The correct result should
  show that across the results, the longest possible stay is much shorter
  than the answer to #3.

*/

WITH

  sequences AS (
    SELECT
      listing_id
      ,date
      ,DATE_ADD(date, INTERVAL minimum_nights DAY) AS default_min_end_date
      ,DATE_ADD(date, INTERVAL maximum_nights DAY) AS default_max_end_date
      ,ROW_NUMBER() OVER(PARTITION BY listing_id ORDER BY date ASC)
      - ROW_NUMBER() OVER(PARTITION BY listing_id, picky_available ORDER BY date ASC) AS sequence_id
    FROM
      `hopeful-theorem-413815.dbt_hubspot_ae_tech_assessment.listings_daily`
    CROSS JOIN
      UNNEST([
        available
        AND 'first aid kit' IN UNNEST(amenities)
        AND 'lockbox' IN UNNEST(amenities)
      ]) AS picky_available
    QUALIFY
      picky_available -- needed unavailable for sequence calcs, but we don't need them going forward
  )

  ,sequence_end_dates AS (
    SELECT
      listing_id
      ,sequence_id
      ,date AS start_date
      ,LEAST(
        default_max_end_date
        ,MAX(date) OVER(PARTITION BY listing_id, sequence_id)
      ) AS end_date
    FROM
      sequences
    QUALIFY
      end_date >= default_min_end_date
  )

SELECT
  listing_id
  ,start_date
  ,end_date
  ,DATE_DIFF(end_date, start_date, DAY) + 1 AS available_days
FROM
  sequence_end_dates
QUALIFY
  ROW_NUMBER() OVER(PARTITION BY listing_id ORDER BY available_days DESC, start_date ASC) = 1
ORDER BY
  available_days DESC