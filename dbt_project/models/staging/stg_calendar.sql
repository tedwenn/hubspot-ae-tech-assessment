SELECT
  * EXCEPT(available, reservation_id)
  ,CASE WHEN available = 't' THEN TRUE
  WHEN available = 'f' THEN FALSE
  END AS available
  ,SAFE_CAST(reservation_id AS INT64) AS reservation_id
FROM
  `hopeful-theorem-413815.source_hubspot_ae_tech_assessment.calendar`
