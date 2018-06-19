#!/bin/bash

gcloud compute instance-templates \
create ${NAME}-template \
--image-family=debian-8 \
--image-project=debian-cloud \
--tags http-server,http \
--scopes=storage-ro,logging-write \
--preemptible \
--machine-type=$MACHINE_TYPE \
--metadata-from-file startup-script=startup.sh

gcloud compute instance-groups managed \
create ${NAME}-managed-instance-group \
--base-instance-name ${NAME} \
--size 1 \
--template ${NAME}-template \
--zone $ZONE

gcloud compute instance-groups managed \
set-named-ports ${NAME}-managed-instance-group \
--named-ports http:80 \
--zone $ZONE

gcloud compute instance-groups managed \
set-autoscaling ${NAME}-managed-instance-group \
--max-num-replicas $MAX_REPLICAS \
--min-num-replicas $MIN_REPLICAS \
--target-cpu-utilization $TARGET_CPU_UTILIZATION \
--cool-down-period 120 \
--zone $ZONE

gcloud compute http-health-checks \
create ${NAME}-health-check \
--request-path /cgi-bin/bwa.cgi

gcloud beta compute instance-groups managed \
set-autohealing ${NAME}-managed-instance-group \
--http-health-check ${NAME}-health-check \
--initial-delay 180 \
--zone $ZONE

gcloud compute backend-services \
create ${NAME}-backend-service \
--http-health-checks ${NAME}-health-check \
--global

gcloud compute backend-services \
add-backend ${NAME}-backend-service \
--instance-group ${NAME}-managed-instance-group \
--balancing-mode UTILIZATION \
--max-utilization 0.8 \
--instance-group-zone $ZONE \
--global

gcloud compute url-maps \
create ${NAME}-url-map \
--default-service ${NAME}-backend-service

gcloud compute target-http-proxies \
create ${NAME}-target-proxy \
--url-map ${NAME}-url-map

gcloud compute forwarding-rules \
create ${NAME}-forward \
--global \
--ports 80 \
--target-http-proxy ${NAME}-target-proxy

#after up and running, enable http-server (port 80).
#may need to do this on a cron to prevent gce-enforcer
#from auto-harvesting firewall rules. also: https-server
gcloud compute firewall-rules \
create allow-http \
--allow tcp:80 \
--target-tags http-server
