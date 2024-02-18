/*

#2 - Neighborhood Pricing

Write a query to find the average price increase for each neighborhood from July 12th 2021 to July 11th 2022.

Tip:
  For example, the Back Bay neighborhood only has one listing, so the difference of $44
  is the average for the whole neighborhood based solely on listing 10813.

*/

SELECT
  date
  ,neighborhood
  ,COUNT(*) AS n_listings
  ,AVG(price - price_364_days_prior) AS avg_price_increase_vs_364_days_prior
FROM
  (
  SELECT
    date
    ,neighborhood
    ,price
    ,ANY_VALUE(price) OVER(PARTITION BY neighborhood, listing_id ORDER BY UNIX_DATE(date) ASC RANGE BETWEEN 364 PRECEDING AND 364 PRECEDING) AS price_364_days_prior
  FROM
    `hopeful-theorem-413815.dbt_hubspot_ae_tech_assessment.listings_daily`
  QUALIFY
    date = '2022-07-11'
    AND price_364_days_prior IS NOT NULL -- only include listings that had a price on both days
  )
GROUP BY
  date
  ,neighborhood
ORDER BY
  date
  ,neighborhood