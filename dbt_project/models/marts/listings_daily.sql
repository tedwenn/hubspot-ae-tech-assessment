SELECT
  c.listing_id
  /* grouping things that don't change by date */
  ,STRUCT(
    l.host_id
    ,l.neighborhood
    ,l.property_type
    ,l.room_type
    ,l.accommodates
    ,l.bathrooms_text
    ,l.bedrooms
    ,l.beds
  ) AS listing
  ,c.date
  ,c.minimum_nights
  ,c.maximum_nights
  ,COALESCE(ad.amenities, l.amenities) AS amenities
  ,c.price
  ,c.available
  ,c.reservation_id
FROM
  {{ ref('stg_calendar') }} AS c
LEFT JOIN
  {{ ref('int_amenities_daily') }} AS ad
ON
  c.listing_id = ad.listing_id
  AND c.date = ad.date
LEFT JOIN
  {{ ref('stg_listings') }} AS l
ON
  c.listing_id = l.id
