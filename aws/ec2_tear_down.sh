#!/usr/bin/env bash
# set -e
set -u
set -o pipefail

source util.sh

delete_security_group="$(aws ec2 delete-security-group --group-name devenv-sg)"
report_success_or_failure $? 'group deleted' 'group not deleted'
