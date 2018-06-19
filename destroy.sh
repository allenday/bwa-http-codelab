#!/bin/bash
yes | gcloud compute forwarding-rules delete ${NAME}-forward --global
yes | gcloud compute target-http-proxies delete ${NAME}-target-proxy
yes | gcloud compute url-maps delete ${NAME}-url-map
yes | gcloud compute backend-services delete ${NAME}-backend-service --global
yes | gcloud compute http-health-checks delete ${NAME}-health-check
yes | gcloud compute instance-groups managed delete ${NAME}-managed-instance-group --zone $ZONE
yes | gcloud compute instance-templates delete ${NAME}-template
