.PHONY: up

up:
	docker-compose up
down:
	docker-compose-down

# Python
shell-api:
	docker-compose run --rm api bash
test:
	docker-compose exec api python -m pytest tests/
validate:
	docker-compose exec api mypy /api

# Database
shell-db:
	docker-compose run --rm db bash
db-save-dev:
	docker-compose exec db pg_dump --create -U admin hf_volunteer_portal_development > db/data/data.development.sql
db-save-test:
	docker-compose exec db pg_dump --create --schema-only -U admin hf_volunteer_portal_test > db/data/data.test.sql

# Client
shell-client:
	docker-compose run --rm client bash
