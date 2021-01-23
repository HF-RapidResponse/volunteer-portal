
# To create a development database dump:

```
make db-save-dev
```

This will update the `db/data/data.development.sql` file with whatever is in your db container's development database and all of it's data.

# To create a development database dump:

```
make db-save-test
```

This will update the `db/data/data.test.sql` file with whatever is in your db container's test database. This will take a snapshot of the ***schema only*** not the data. Tests should create their own data then roll it back after – leaving the database itself empty when tests aren't actively running.
