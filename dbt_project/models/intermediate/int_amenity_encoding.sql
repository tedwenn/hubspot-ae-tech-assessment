{{ config(
    materialized='table'
    ,pre_hook="{{ create_udf_amenities_to_str() }}"
) }}

-- depends_on: {{ ref('stg_amenities_changelog') }}

{{ create_amenity_encoding() }}