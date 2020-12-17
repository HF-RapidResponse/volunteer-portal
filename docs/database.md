
# To create a development database dump:

```
pg_dump --create hf_volunteer_portal_development > data.development.sql
```

# To create a test database schema :

```
pg_dump --create --schema-only hf_volunteer_portal_test > data.sql
```
