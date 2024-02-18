/*

#3 - Long Stay / Picky Renter

(B)
  Write a variation of the maximum duration query above for listings
  that have both a lockbox and a first aid kit listed in the amenities.

Tip:
  For example, listing 10986 has a lockbox. The correct result should
  show that across the results, the longest possible stay is much shorter
  than the answer to #3.

Limitation of solution:
  This only works for availability periods that include the desired amenities
  at the start date. If amenities were changing throughout the availability
  period, it's possible to return a listing that doesn't have the desired
  amenities throughout.

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
  AND has_first_aid_kit
  AND has_lockbox
QUALIFY
  ROW_NUMBER() OVER(PARTITION BY listing_id ORDER BY maximum_nights DESC, date ASC) = 1
ORDER BY
  available_days DESC
  ,listing_id ASC
