# Based on https://jdlm.info/articles/2019/09/06/lessons-building-node-app-docker.html

# Use gcloud nodejs image.
FROM launcher.gcr.io/google/nodejs

WORKDIR /client

COPY . ./

RUN rm -rf node_modules \
    && npm install -g serve \
    && NODE_ENV=development npm install --quiet
