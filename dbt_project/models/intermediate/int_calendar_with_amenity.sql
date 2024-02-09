SELECT
  c.listing_id
  ,c.date
  ,c.price
  ,c.available
  ,c.reservation_id
  ,a.amenities
FROM
  {{ ref('stg_calendar') }} AS c
LEFT JOIN
  {{ ref('stg_amenities_changelog') }} AS a
ON
  c.listing_id = a.listing_id
  AND c.date >= DATE(a.change_at)
QUALIFY
  /* get most recent update of amenities as of reservation start date */
  ROW_NUMBER() OVER(PARTITION BY listing_id, reservation_id, date ORDER BY a.change_at DESC) = 1