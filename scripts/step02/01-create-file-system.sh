#!/bin/sh

# NOTES:
# as far as it was possible to understand 24 06 21:
#     FILESYS needs to be created and recorded manually
#     SUBNET is a variable, leave alone
#     vpc_sg was empty as the project:tutorial-cluster tag was not there

# ALSO NOTE:
#       THIS IS A ONE TIME ONLY SCRIPT AND FAILS WHERE INGRESS ETC IS EXTANT

FILESYS="fs-027a8594c30ceddd6"

aws ec2 describe-subnets --filters Name=tag:project,Values=tutorial-cluster \
 | jq ".Subnets[].SubnetId" | \ 
 xargs -ISUBNET  aws efs create-mount-target \
 --file-system-id $FILESYS --subnet-id SUBNET

aws ec2 describe-subnets --filters Name=tag:project,Values=tutorial-cluster \
 | jq ".Subnets[].SubnetId" | \
xargs -ISUBNET  aws efs create-mount-target \
 --file-system-id $FILESYS --subnet-id SUBNET

efs_sg=$(aws efs describe-mount-targets --file-system-id $FILESYS \
| jq ".MountTargets[0].MountTargetId" \
  | xargs -IMOUNTG aws efs describe-mount-target-security-groups \
  --mount-target-id MOUNTG | jq ".SecurityGroups[0]" | xargs echo )

vpc_sg="$(aws ec2 describe-security-groups  \
--filters Name=tag:project,Values=tutorial-cluster \
| jq '.SecurityGroups[].GroupId' | xargs echo)"

aws ec2 authorize-security-group-ingress \
--group-id $efs_sg \
--protocol tcp \
--port 2049 \
--source-group $vpc_sg \
--region eu-west-2
