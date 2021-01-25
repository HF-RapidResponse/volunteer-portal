#!/bin/bash

npm ci
npm run build
gcloud app deploy --quiet app-staging.yaml

