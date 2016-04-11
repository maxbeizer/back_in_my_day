#!/usr/bin/env bash
# set -e
set -u
set -o pipefail

# variables
source vars.sh

# util functions
source util.sh

create_security_group () {
  security_group_info="$(aws ec2 create-security-group --group-name $security_group_name --description 'security group for development environment in EC2')"
  report_success_or_failure $? 'group created' 'group not created'
  security_group_id=`echo $security_group_info | awk -F[\"\"] '{print $4}'`
}

authorize_security_group () {
  authorize_group_ingress="$(aws ec2 authorize-security-group-ingress --group-name $security_group_name --protocol tcp --port 22 --cidr 0.0.0.0/0)"
  report_success_or_failure $? 'ingress authorized' 'ingress not authorized'
}

create_key () {
  aws ec2 create-key-pair --key-name $key_name --query 'KeyMaterial' --output text > $key_file_name
  report_success_or_failure $? 'key-pair created' 'key-pair not created'
  chmod 400 $key_file_name
}

launch_instances () {
  instance_id="$(aws ec2 run-instances --image-id $ami_id --security-group-ids $security_group_id --count $instance_count --instance-type $instance_type --key-name $key_name --query 'Instances[0].InstanceId' --output text)"
  report_success_or_failure $? 'instance spinning up' 'instance not created'
}

get_public_ip () {
  instance_public_ip="$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)"
  report_success_or_failure $? 'public ip acquired' 'public ip not acquired'
}

ssh_into_instance () {
  ssh -i $key_file_name $instance_user_name@$instance_public_ip
}

# main
create_security_group
authorize_security_group
create_key
launch_instances
get_public_ip
ssh_into_instance
