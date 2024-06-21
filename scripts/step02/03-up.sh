#!/bin/sh
ecs-cli compose --project-name tutorial  --file docker-compose.yml \
 --debug service up \
 --deployment-max-percent 100 --deployment-min-healthy-percent 0 \
  --region eu-west-2 --ecs-profile tutorial --cluster-config tutorial \
  --create-log-groups --force-deployment 
  # added force-deployment
