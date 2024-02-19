SELECT
  c.listing_id
  ,c.date
  ,COUNT(*) AS n_reviews
  ,AVG(r.review_score) AS avg_review_score
FROM
  {{ ref('stg_calendar') }} AS c
INNER JOIN
  {{ ref('generated_reviews') }} AS r
ON
  c.listing_id = r.listing_id
  AND c.date > r.review_date
GROUP BY
  listing_id
  ,date
