#!/usr/bin/env bash
set -e
set -u
set -o pipefail

# util functions
source util.sh

# arg1: instance_id
terminate_instance_by_id () {
  aws ec2 terminate-instances --instance-ids $1 > /dev/null
  report_success_or_failure $? 'terminating instance' 'not terminating instance'
  while true ; do
    if [ $(get_instance_state_by_id $1) = 'terminated' ]; then
      echo 'instance stopped'
      break
    fi
  done
}

# main
terminate_instance_by_id $1
