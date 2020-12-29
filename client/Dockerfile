# Based on https://jdlm.info/articles/2019/09/06/lessons-building-node-app-docker.html

# Use gcloud nodejs image.
FROM launcher.gcr.io/google/nodejs

RUN mkdir /client
WORKDIR /client

COPY . ./

RUN npm install -g serve && npm install --quiet
RUN npm run build
