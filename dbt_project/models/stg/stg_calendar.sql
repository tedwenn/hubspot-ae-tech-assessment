SELECT
  * EXCEPT(reservation_id)
  ,SAFE_CAST(reservation_id AS INT64) AS reservation_id
FROM
  `hopeful-theorem-413815.source_hubspot_ae_tech_assessment.calendar`
