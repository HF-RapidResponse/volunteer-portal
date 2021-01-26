
# To create a development database dump:

```
make db-save-dev
```

This will update the `db/data/dev/data.development.sql` file with whatever is in your db container's development database and all of it's data.

# To create a test database dump:

```
make db-save-test-from-dev
```

This will update the `db/data/test/data.test.sql` file with whatever is in your db container's dev database, changing the db name to `hf_volunteer_portal_test`. This will take a snapshot of the ***schema only*** not the data. Tests should create their own data then roll it back after – leaving the database itself empty when tests aren't actively running.

# Switching Environment Databases
The developement and test environments set up the database using the .sql files in the `db/data/[env]` directories. Prod uses and external db and therefor has no db service in the docker-compose.prod.yml file. Running `docker-compose run/up ...` sets up the DB if no DB is currently set up. If the DB is set up already, from a previous `docker-compose run/up ...` call, you will need to call `docker-compose down` to ensure that the next `up/run` will create a new DB instance with the appropriate .sql file for the new environment.
