FROM python:3.8

COPY ./ /api
COPY ./config.yaml.example /api/config.yaml
WORKDIR /api
RUN pip install -r ./requirements.txt

CMD ["uvicorn", "--host", "0.0.0.0", "api:app", "--app-dir", ".", "--reload"]
