# Based on https://jdlm.info/articles/2019/09/06/lessons-building-node-app-docker.html

# Use gcloud nodejs image.
FROM node:14.15.5

WORKDIR /client

COPY . ./

ENV NODE_ENV development
RUN rm -rf node_modules \
    && npm install --quiet
