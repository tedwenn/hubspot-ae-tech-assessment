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
      m.listing_id
      ,m.date
      ,DATE_ADD(m.date, INTERVAL c.maximum_nights DAY) AS default_max_end_date
      ,ROW_NUMBER() OVER(PARTITION BY m.listing_id ORDER BY m.date ASC)
      - ROW_NUMBER() OVER(PARTITION BY m.listing_id, m.available ORDER BY m.date ASC) AS sequence_id
    FROM
      `hopeful-theorem-413815.dbt_hubspot_ae_tech_assessment.mart` AS m
    LEFT JOIN
      `hopeful-theorem-413815.dbt_hubspot_ae_tech_assessment.stg_calendar` AS c
    ON
      m.listing_id = c.listing_id
      AND m.date = c.date
    QUALIFY
      m.available -- needed unavailable for sequence calcs, but we don't need them going forward
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