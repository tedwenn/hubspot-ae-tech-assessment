# HubSpot Analytics Engineer Technical Assessment

## Overview

This repository contains my solutions to the HubSpot Analytics Engineer Technical Assessment. Data modeling is implemented via `dbt` with data stored in `BigQuery`.

## Data Modeling

1. **Pre-processing**: Provided CSVs are stored in the [seeds_raw](dbt_project/seeds_raw/) directory. [preprocess_csv.py](dbt_project/scripts/preprocess_csv.py) does a little bit of light cleaning to prepare the files for `BigQuery` and moves the CSVs into the [seeds](dbt_project/seeds/) directory.
1. **Seed**: `dbt seed` loads the data from [seeds](dbt_project/seeds/) to `BigQuery`. Seeds are defined in [dbt_project.yml](dbt_project/dbt_project.yml) and can be accessed as refs.
1. **Staging**: Input data is staged in [staging](dbt_project/models/staging/), where models are materialized as views with light transformations applied, such as changing column names to lowercase and converting json strings to `ARRAY<STRING>` columns.
1. **Intermediate**: Intermediate transformations are materialized as ephemerals defined in [intermediate](dbt_project/models/intermediate/). These are common ways data might need to get transformed, so the SQL logic is defined in one central location.
    *   [int_amenities_daily](dbt_project/models/intermediate/int_amenities_daily.sql) looks at the amenities changelog to get the latest amenities for a listing on any given day of the calendar.
    *   [int_amenity_encoding](dbt_project/models/intermediate/int_amenity_encoding.sql) dynamically creates hot-coded embeddings of every amenity in the data. This allows ease of access for analysts while staying robust to new amenities being added. This is materialized as a table to avoid adding long code snippets to queries
    *   [int_availability_daily](dbt_project/models/intermediate/int_availability_daily.sql) updates the `minimum_nights` and `maximum_nights` values in the calendar to reflect actual current availability, not just the listed requirements.
    *   [int_reviews_daily](dbt_project/models/intermediate/int_reviews_daily.sql) aggregates running review data, showing count/average of all reviews as of day prior to date.
1. **Marts**: One mart model is defined in [marts](dbt_project/models/marts/). The [listings_daily](dbt_project/models/marts/listings_daily.sql) model provides analysis-friendly data at the listing/date level.

These processes and models can all be run with the script [run_workflow.sh](dbt_project/run_workflow.sh), which can be run in the command line as `./run_workflow.sh`.

## Analysis

- **[Amenity Revenue](dbt_project/analyses/01_amenity_review.sql)**: Total revenue and revenue percentage by month, segmented by air conditioning presence.
- **[Neighborhood Pricing](dbt_project/analyses/02_neighborhood_pricing.sql)**: Average price increase per neighborhood over a specified period.
- **Long Stay / Picky Renter**: Maximum duration stay per listing and variation for listings with specific amenities.
    - **[Long Stay](dbt_project/analyses/03A_longstay.sql)**: The longest someone could stay at a listing.
    - **[Long Stay - picky renter (basic)](dbt_project/analyses/03B_picky_renter__basic.sql)**: The logest someone could stay at a listing if they required a lockbox and first aid kit.
        - **[Long Stay - picky renter (advanced)](dbt_project/analyses/03B_picky_renter_advanced.sql)**: Same as the basic version but handles case where amenities are changing throughout stay.