# Based on https://jdlm.info/articles/2019/09/06/lessons-building-node-app-docker.html

# Use gcloud nodejs image.
FROM launcher.gcr.io/google/nodejs

RUN mkdir /srv/client

WORKDIR /srv/client

COPY . ./

RUN npm install --quiet
RUN npm run build
