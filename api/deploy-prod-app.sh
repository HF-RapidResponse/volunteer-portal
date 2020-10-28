#!/bin/bash

branch_name=$(git symbolic-ref --short -q HEAD)
if [ "$branch_name" = "master" ]; then
    gcloud app deploy --quiet prod-app.yaml
else
    echo "Please deploy the prod api from the master branch only"
fi
