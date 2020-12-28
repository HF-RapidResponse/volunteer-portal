# Based on https://jdlm.info/articles/2019/09/06/lessons-building-node-app-docker.html

# Use gcloud nodejs image.
#FROM launcher.gcr.io/google/nodejs
FROM node

WORKDIR /srv/client

COPY . ./

RUN npm install
#RUN npm run build
