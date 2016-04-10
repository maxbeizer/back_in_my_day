#!/usr/bin/env bash
# set -e
set -u
set -o pipefail

# variables
source vars.sh

# util functions
source util.sh

security_group_info="$(aws ec2 create-security-group --group-name $security_group_name --description 'security group for development environment in EC2')"
report_success_or_failure $? 'group created' 'group not created'

security_group_id=`echo $security_group_info | awk -F[\"\"] '{print $4}'`

authorize_group_ingress="$(aws ec2 authorize-security-group-ingress --group-name $security_group_name --protocol tcp --port 22 --cidr 0.0.0.0/0)"
report_success_or_failure $? 'ingress authorized' 'ingress not authorized'
