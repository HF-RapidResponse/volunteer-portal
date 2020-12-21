.PHONY: up

up:
	docker-compose up
down:
	docker-compose-down
test:
	docker run --rm api "python -m pytest tests/"
validate:
	docker run --rm api "mypy ."
shell-client:
	docker-compose run --rm client bash
