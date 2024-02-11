SELECT
  c.*
  ,l.neighborhood
FROM
  {{ ref('int_calendar_with_amenity') }} AS c
LEFT JOIN
  {{ ref('stg_listings') }} AS l
ON
  c.listing_id = l.id