#!/usr/bin/env bash
# set -e
set -u
set -o pipefail

# variables
source vars.sh

# util functions
source util.sh

delete_key () {
  aws ec2 delete-key-pair --key-name $key_name
  report_success_or_failure $? 'key deleted' 'key not deleted'
  rm $key_file_name
}

revoke_security_group () {
  #not really neccessary if the group gets deleted, but left to informational purposes
  revoke_group_ingress="$(aws ec2 revoke-security-group-ingress --group-name $security_group_name --protocol tcp --port 22 --cidr 0.0.0.0/0)"
  report_success_or_failure $? 'ingress revoked' 'ingress not revoked'
}

delete_security_group () {
  delete_security_group="$(aws ec2 delete-security-group --group-name devenv-sg)"
  report_success_or_failure $? 'group deleted' 'group not deleted'
}

# main
delete_key
revoke_security_group
delete_security_group
