.PHONY: test

test:
	mypy .
bootstrap:
	python bootstrap.py
setup:
	virtualenv dev-env && source dev-env/bin/activate && pip install -r requirements.txt
setup-conva:
	conda env create -f environment.yml && conda activate volunteer-portal
dev:
	ENV=development uvicorn api:app --app-dir . --reload
