#!/bin/bash
branch_name=$(git symbolic-ref --short -q HEAD)
if [ "$branch_name" = "master" ]; then
    npm ci
    npm run build
    gcloud app deploy --quiet prod-client.yaml
else
    echo "Please deploy the prod client from the master branch only"
fi
