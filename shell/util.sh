#!/usr/bin/env bash

# arg1: $?
# arg2: success_message
# arg3: failure_message
report_success_or_failure () {
  if [ $1 -eq 0 ]
  then
    echo
    echo $2
  else
    echo
    echo $3 >&2
  fi
}

err_report() {
  echo "Error on line $0:$1"
}
trap 'err_report $LINENO' ERR

# arg1: instance_id
get_instance_state_by_id () {
  aws ec2 describe-instances --instance-ids $1 --query 'Reservations[*].Instances[*].[State.Name]' --output text
}

get_shutting_down_instance_id () {
  aws ec2 describe-instances --query 'Reservations[*].Instances[*].[State.Name, InstanceId]' --output text |
  grep 'shutting-down' |
  awk '{print $2}'
}
