FROM python:3.8
ENV PYTHONUNBUFFERED 1

WORKDIR /api

COPY config.yaml ./config.yaml
COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

COPY . ./
