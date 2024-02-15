SELECT
  c.listing_id
  ,c.date
  ,a.amenities
  ,ae.* EXCEPT(amenities, amenities_str)
FROM
  {{ ref('stg_calendar') }} AS c
LEFT JOIN
  {{ ref('stg_amenities_changelog') }} AS a
ON
  c.listing_id = a.listing_id
  AND c.date >= DATE(a.change_at)
LEFT JOIN
  {{ ref('int_amenity_encoding') }} AS ae
ON
   `{{ target.project }}`.`{{ target.dataset }}`.AMENITIES_TO_STRING(a.amenities)
   =
   `{{ target.project }}`.`{{ target.dataset }}`.AMENITIES_TO_STRING(ae.amenities)
QUALIFY
  /* get most recent update of amenities as of reservation start date */
  ROW_NUMBER() OVER(PARTITION BY listing_id, reservation_id, date ORDER BY a.change_at DESC) = 1
