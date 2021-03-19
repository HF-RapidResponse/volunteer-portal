#!/bin/bash

# must run
# export DB_IP=34.69.153.217
# export PGPASSWORD=[password]

echo Stopping. Are you sure you want to run this? The test sql db file may contain DROP queries.
echo Be sure you know what youre doing before running this.
exit 1

# create empty db setup script without _test suffix
sed 's/hf_volunteer_portal_test/hf_volunteer_portal/g' ../db/data/test/data.test.sql > /tmp/tmp.sql
if [[ -z $DB_IP || -z $PGPASSWORD ]]; then
    echo IP or password not set. exiting.
    exit 1
fi

psql -h $DB_IP -U admin -d postgres < /tmp/tmp.sql
