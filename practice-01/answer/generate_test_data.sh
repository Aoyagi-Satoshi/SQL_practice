#!/bin/bash
start_date=$1
end_date=$2

CONTAINER=sql-batch-practice-db
DB_USER=postgres
DB_NAME=practice_db
docker exec -i $CONTAINER psql -U $DB_USER -d $DB_NAME -c "SELECT public.create_testdate('$start_date', '$end_date');"