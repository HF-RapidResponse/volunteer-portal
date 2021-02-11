#!/bin/bash

# Run the api and client in parallel
cd /api; uvicorn --host 0.0.0.0 --port 8081 api:app --app-dir . --port 8081 --reload &
cd /client; PORT=8080 npm run start -n &

# give the client and api a chance to start so nginx doesnt fail
sleep 10; nginx;
