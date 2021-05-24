FROM python:3.8
ENV PYTHONUNBUFFERED 1

WORKDIR /api

COPY config.yaml requirements.txt gcp_credentials.json* ./
RUN pip install -r requirements.txt

# set up to run jupyter notebook from dev instance
RUN pip install jupyterlab