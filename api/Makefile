.PHONY: test

validate:
	mypy .
test:
	ENV=test python -m pytest tests/
bootstrap:
	python bootstrap.py
activate:
	source dev-env/bin/activate
setup:
	virtualenv dev-env && source dev-env/bin/activate && pip install -r requirements.txt
setup-conva:
	conda env create -f environment.yml && conda activate volunteer-portal
dev:
	uvicorn api:app --app-dir . --reload
