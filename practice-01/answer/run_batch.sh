#!/bin/bash
start_date=$1

CONTAINER=sql-batch-practice-db
DB_USER=postgres
DB_NAME=practice_db
docker exec -i $CONTAINER psql -U $DB_USER -d $DB_NAME -c "SELECT public.summarize_daily_sales('$start_date');"
docker exec -i $CONTAINER psql -U $DB_USER -d $DB_NAME -c "\COPY daily_sales_summary TO STDOUT WITH CSV HEADER" >"daily_sales_summary.csv"
