#!/bin/bash
branch_name=$(git symbolic-ref --short -q HEAD)
if [ "$branch_name" = "staging" ]; then
    npm ci
    npm run build
    gcloud app deploy --quiet --version staging --no-promote appengine.yaml
else
    echo "Please deploy the staging client from the staging branch only"
fi
