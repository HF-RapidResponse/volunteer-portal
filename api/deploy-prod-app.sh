#!/bin/bash

branch_name=$(git symbolic-ref --short -q HEAD)
if [ "$branch_name" = "production" ]; then
    gcloud app deploy --quiet app.yaml
else
    echo "Please deploy the prod api from the production branch only"
fi
