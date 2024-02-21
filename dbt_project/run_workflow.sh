#!/bin/bash

# Step 1: Preprocess CSV
python3 scripts/preprocess_csv.py

# Step 2: Run dbt seed to load the preprocessed CSV into BigQuery
dbt seed

# Step 3: Continue with the rest of your dbt workflow
dbt run --full-refresh
# dbt test

# dbt docs generate