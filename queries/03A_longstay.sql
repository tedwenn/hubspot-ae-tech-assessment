/*

#3 - Long Stay / Picky Renter

(A)
  Write a query to find the maximum duration one could stay in each of
  these listings, based on the availability and what the owner allows.

Tip:
  For example, listing 863788 is heavily booked. The largest timespan for
  which it is available is four days from September 18th to 21st in 2021.
  The correct solution should show that three listings are tied for the
  longest possible stay.

*/

WITH

  sequences AS (
    SELECT
      listing_id
      ,date
      ,DATE_ADD(date, INTERVAL minimum_nights DAY) AS default_min_end_date
      ,DATE_ADD(date, INTERVAL maximum_nights DAY) AS default_max_end_date
      ,ROW_NUMBER() OVER(PARTITION BY listing_id ORDER BY date ASC)
      - ROW_NUMBER() OVER(PARTITION BY listing_id, available ORDER BY date ASC) AS sequence_id
    FROM
      `hopeful-theorem-413815.dbt_hubspot_ae_tech_assessment.listings_daily`
    QUALIFY
      available -- needed unavailable for sequence calcs, but we don't need them going forward
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