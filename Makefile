.PHONY: up

up:
	docker-compose up
down:
	docker-compose-down

# Python
shell-api:
	docker-compose run --rm api bash
test:
	docker-compose run --rm api-test python -m pytest tests/
test-debug:
	docker-compose run --rm api-test python -m pytest tests/ -s --capture=no -vv
# Not currently working.
# validate:
# 	docker-compose run --rm api-test mypy /api
db-reload-dev:
	docker-compose run --rm api python bootstrap.py
db-reload-test:
	docker-compose run --rm api-test python bootstrap.py

# Database
shell-db:
	docker-compose run --rm db bash
db-save-dev:
	docker-compose exec db pg_dump --create -U admin hf_volunteer_portal_development > db/data/data.development.sql
db-push-dev:
	psql -h 127.0.0.1 -p 8082 -U admin < db/data/data.development.sql
db-save-test:
	docker-compose exec db pg_dump --create --schema-only -U admin hf_volunteer_portal_test > db/data/data.test.sql
db-save-test-from-dev:
	docker-compose exec db pg_dump --create --schema-only -U admin hf_volunteer_portal_development | sed 's/hf_volunteer_portal_development/hf_volunteer_portal_test/g' > db/data/data.test.sql

# Client
shell-client:
	docker-compose run --rm client bash
test-client:
	docker-compose run --rm client npm test -- --passWithNoTests --ci --watchAll=false
test-client-watch:
	docker-compose run --rm client npm test -- --passWithNoTests
