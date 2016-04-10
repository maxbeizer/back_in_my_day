#!/usr/bin/env bash
# set -e
set -u
set -o pipefail

source util.sh

security_group_create="$(aws ec2 create-security-group --group-name devenv-sg --description 'security group for development environment in EC2')"
report_success_or_failure $? 'group created' 'group not created'
