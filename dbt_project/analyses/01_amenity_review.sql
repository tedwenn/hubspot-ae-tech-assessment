/*

#1 - Amenity Revenue
Write a query to find the total revenue and percentage of revenue by month segmented by whether or not air conditioning exists on the listing.
Tip: For example, only 21.2% of revenue in July 2022 came from listings without air conditioning.

*/

SELECT
  month
  ,total_revenue
  ,revenue_with_air_conditioning / total_revenue AS percent_revenue_air_conditioning
  ,1 - (revenue_with_air_conditioning / total_revenue) AS percent_revenue_no_air_conditioning
FROM
  (
  SELECT
    month
    ,SUM(revenue) AS total_revenue
    ,SUM(IF(has_air_conditioning, revenue, 0)) AS revenue_with_air_conditioning
  FROM
    `hopeful-theorem-413815.dbt_hubspot_ae_tech_assessment.listings_daily`
  GROUP BY
    month
  )
ORDER BY
  month ASC