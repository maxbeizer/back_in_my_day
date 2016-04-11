#!/usr/bin/env bash
set -e
set -u
set -o pipefail

list_instances () {
  aws ec2 describe-instances  \
    --query 'Reservations[*].Instances[*].{ state:State.Name, instance_id:InstanceId, public_dns:PublicDnsName, ami:ImageId, key_name:KeyName, instance_type:InstanceType }' \
    --output table
}

# main
list_instances
