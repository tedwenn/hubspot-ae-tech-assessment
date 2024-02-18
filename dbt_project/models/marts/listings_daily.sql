SELECT
  c.listing_id
  ,l.host_id
  ,l.neighborhood
  ,l.property_type
  ,l.room_type
  ,l.accommodates
  ,l.bathrooms_text
  ,l.bedrooms
  ,l.beds
  ,c.date
  ,FORMAT_DATE('%Y-%m', c.date) AS month
  ,av.minimum_nights
  ,av.maximum_nights
  ,c.price
  ,IF(c.reservation_id IS NULL, 0, c.price) AS revenue
  ,c.available
  ,c.reservation_id IS NOT NULL AS is_booked
  ,c.reservation_id
  ,am.* EXCEPT(listing_id, date)
FROM
  {{ ref('stg_calendar') }} AS c
LEFT JOIN
  {{ ref('stg_listings') }} AS l
ON
  c.listing_id = l.id
LEFT JOIN
  {{ ref('int_availability_daily') }} AS av
ON
  c.listing_id = av.listing_id
  AND c.date = av.date
LEFT JOIN
  {{ ref('int_amenities_daily') }} AS am
ON
  c.listing_id = am.listing_id
  AND c.date = am.date
