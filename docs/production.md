## Running the portal on GCP

This document describes the differences between the docker configs for development and production serving and describes the steps to reproduce the cloud configuration necessary for serving the portal.

### Docker vs. docker-compose
The root directory of the repo contains a `Dockerfile`. This file is used to create a single image that is used in production and staging for serving the client and api on a single machine. <br>
This configura is intended to be as similar as possible to the configuration used for development defined in the docker-compose*.yml and Dockerfiles in the api, client, and nginx directories.
The `cloud_serving` directory are utilities for running the portal in GCP for staging and production.
The Dockerfile in the root directory of this repository is used for building the prod and staging images to be run on cloud run.
