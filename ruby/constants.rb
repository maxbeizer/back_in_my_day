module Constants
  SECURITY_GROUP_NAME = 'back_in_my_day'
  SECURITY_GROUP_DESCRIPTION = 'back_in_my_day group from Ruby'
  SECURITY_GROUP_INGRESS_OPTIONS = {
    group_name: SECURITY_GROUP_NAME,
    ip_protocol: 'tcp',
    to_port: 22,
    from_port: 22,
    cidr_ip: '0.0.0.0/0'
  }
  KEY_NAME = 'back_in_my_day_key_pair'
  KEY_PAIR_OPTIONS = {
    key_name: KEY_NAME
  }
  AMI_ID = 'ami-08111162'
  INSTANCE_PRIVATE_KEY_FILE = './back_in_my_day.pem'
end
