
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
