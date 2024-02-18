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

SELECT
  listing_id
  ,date AS start_date
  ,DATE_ADD(date, INTERVAL maximum_nights DAY) AS end_date
  ,maximum_nights + 1 AS available_days
FROM
  `hopeful-theorem-413815.dbt_hubspot_ae_tech_assessment.listings_daily`
WHERE
  maximum_nights IS NOT NULL
QUALIFY
  ROW_NUMBER() OVER(PARTITION BY listing_id ORDER BY maximum_nights DESC, date ASC) = 1
ORDER BY
  available_days DESC
  ,listing_id ASC
