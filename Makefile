.PHONY: up

ORANGE=\033[0;33m
NC=\033[0m # No Color

# Dev is the default config
TEST = -f docker-compose.yml -f docker-compose.test.yml

up:
	docker-compose up
down:
	docker-compose down
recreate-all:
	docker-compose build --no-cache 

# Api
shell-api:
	docker-compose run --rm api bash
test:
	@echo "${ORANGE}If you're getting errors with configuration/database settings, try running \`make down\` first${NC}"
	docker-compose $(TEST) run --rm api python -m pytest tests/
test-debug:
	docker-compose $(TEST) run --rm api python -m pytest tests/  -s --capture=no -vv
# Not currently working.
# validate:
# 	docker-compose run --rm api-test mypy /api
db-reload-dev:
	docker-compose run --rm api python bootstrap.py
recreate-api:
	docker-compose build --no-cache api

# Database
shell-db:
	docker-compose run --rm db bash
db-save-dev:
	docker-compose exec db pg_dump --create -U admin hf_volunteer_portal_development > db/data/dev/data.development.sql
db-save-test-from-dev:
	docker-compose exec db pg_dump --create --schema-only -U admin hf_volunteer_portal_development | sed 's/hf_volunteer_portal_development/hf_volunteer_portal_test/g' > db/data/test/data.test.sql
db-reset-all-from-python:
	db-reload-dev db-save-dev db-save-test-from-dev
recreate-db:
	docker-compose build --no-cache db

# Client
shell-client:
	docker-compose run --rm client bash
test-client:
	docker-compose run --rm client npm test -- --passWithNoTests --ci --watchAll=false
test-client-watch:
	docker-compose run --rm client npm test -- --passWithNoTests
recreate-client:
	docker-compose build --no-cache client
