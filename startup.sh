#!/bin/bash
DOCKER_IMAGE="allenday/bwa-http-docker"
BWA_FILES="gs://aligner-deployment/reference/Os-Nipponbare-Reference-IRGSP-1.0/*"
apt-get update && apt-get -y install docker.io
gcloud docker -- pull $DOCKER_IMAGE
docker run -p 80:80 -e BWA_FILES=$BWA_FILES $DOCKER_IMAGE
