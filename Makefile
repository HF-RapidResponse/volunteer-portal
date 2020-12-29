.PHONY: up

up:
	docker-compose up
down:
	docker-compose-down
test:
	docker-compose exec api python -m pytest tests/
validate:
	docker-compose exec api mypy /api
shell-api:
	docker-compose run --rm api bash
shell-client:
	docker-compose run --rm client bash
