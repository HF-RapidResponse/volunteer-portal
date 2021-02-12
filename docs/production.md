## Running the portal on GCP

This document describes the differences between the docker configs for development and production serving and describes the steps to reproduce the cloud configuration necessary for serving the portal.

### Docker vs. docker-compose
The root directory of the repo contains a `Dockerfile`. This file is used to create a single image that is used in production and staging for serving the client and api on a single machine. 

This configuration is intended to be as similar as possible to the configuration used for development defined in the docker-compose*.yml and Dockerfiles in the api, client, and nginx directories. These Dockerfiles aling with docker-compose define 3 separate serivces that can be run independently in their own containers.

### Cloud Setup

The `cloud_serving` directory contains utilities for running the portal in GCP for staging and production. 

**  `db_init.sh` is not a part of any automation, it is just a one time script for setting up the production db to match the dev/test db.

** `setup_base_image.sh` is used by docker to install the packages required by the production image, such as Node and Nginx.

** `start.sh` starts the client, api, and nginx proxy in parallel.

#### Cloud Run
The configuration for running the production and staging image can be inspected in the Cloud Run console on GCP. This configuration defines Cloud Build job that is triggered when code is pushed or merged into production or a release.* branch.
