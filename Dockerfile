# Production docker file
# runs frontend, client, and nginx on a single container

#===============================================================================#
# Set up a python image with node and nginx.
# The below python version and packages installed in setup_base_image.sh should
# align with the versions in the Dockerfiles used by docker-compose for local dev
FROM python:3.8
ENV PYTHONUNBUFFERED 1

COPY cloud_serving/setup_base_image.sh .
RUN ./setup_base_image.sh


#===============================================================================#
# Set up client
# This deviates slightly from the commands in client/Dockerfile in that it
# produces a production optimized build.
WORKDIR /client
COPY client/ ./
RUN npm cache verify \
     && npm install -g serve \
     && npm install --quiet \
     && npm run build --quiet


#===============================================================================#
# Set up api
# This should mirror the commands in api/Dockerfile
WORKDIR /api
ENV PYTHONUNBUFFERED 1
COPY api/ ./
RUN pip install -r requirements.txt

#===============================================================================#
# Set up nginx
COPY nginx/cloud_release_config /etc/nginx/nginx.conf

#===============================================================================#
# Run client, API, and nginx
WORKDIR /
COPY cloud_serving/start.sh ./

# Environment Variable for settings.py ENV=development,staging,production
# is set in Cloud Run

CMD /start.sh