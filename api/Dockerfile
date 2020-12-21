FROM python:3.8
ENV PYTHONUNBUFFERED 1

WORKDIR /api

RUN pwd
RUN ls -la


COPY config.yaml.example config.yaml
RUN pip install -r requirements.txt
