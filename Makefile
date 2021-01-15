.PHONY: up

# Dev is the default config
TEST = -f docker-compose.yml -f docker-compose.test.yml
PROD = -f docker-compose.yml -f docker-compose.prod.yml

up:
	docker-compose up
down:
	docker-compose down

up-prod:
	docker-compose $(PROD) up -d

# Api
shell-api:
	docker-compose run --rm api bash
test:
	docker-compose $(TEST) run --rm api python -m pytest tests/
validate:
	docker-compose run --rm api mypy /api
db-reload:
	docker-compose run --rm api python bootstrap.py

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
