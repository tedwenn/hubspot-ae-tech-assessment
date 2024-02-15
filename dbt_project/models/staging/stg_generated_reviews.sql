SELECT
  ID AS review_id
  ,LISTING_ID AS listing_id
  ,REVIEW_SCORE AS review_score
  ,REVIEW_DATE AS review_date
FROM
  {{ ref('seed_generated_reviews') }}
