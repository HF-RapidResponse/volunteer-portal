#!/bin/bash
branch_name=$(git symbolic-ref --short -q HEAD)
if [ "$branch_name" = "staging" ]; then
    gcloud app deploy --quiet staging-app.yaml
else
    echo "Please deploy the staging api from the staging branch only"
fi


