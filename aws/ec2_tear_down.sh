#!/usr/bin/env bash
# set -e
set -u
set -o pipefail

# variables
source vars.sh

# util functions
source util.sh

#not really neccessary if the group gets deleted, but left to informational purposes
revoke_group_ingress="$(aws ec2 revoke-security-group-ingress --group-name $security_group_name --protocol tcp --port 22 --cidr 0.0.0.0/0)"
report_success_or_failure $? 'ingress revoked' 'ingress not revoked'

delete_security_group="$(aws ec2 delete-security-group --group-name devenv-sg)"
report_success_or_failure $? 'group deleted' 'group not deleted'
