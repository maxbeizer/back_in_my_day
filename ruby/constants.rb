require 'base64'

module Constants
  SECURITY_GROUP_NAME = 'back_in_my_day'
  SECURITY_GROUP_DESCRIPTION = 'back_in_my_day group from Ruby'
  SECURITY_GROUP_EGRESS_OPTIONS = {
    ip_protocol: 'tcp',
    to_port: 80,
    from_port: 80,
    cidr_ip: '0.0.0.0/0'
  }
  SECURITY_GROUP_INGRESS_OPTIONS = {
    group_name: SECURITY_GROUP_NAME,
    ip_permissions: [
      {
        ip_protocol: 'tcp',
        from_port: 22,
        to_port: 22,
        user_id_group_pairs: [
          {
            group_name: SECURITY_GROUP_NAME,
          },
        ],
        ip_ranges: [
          {
            cidr_ip: '0.0.0.0/0',
          },
        ]
      },
      {
        ip_protocol: 'tcp',
        from_port: 80,
        to_port: 80,
        user_id_group_pairs: [
          {
            group_name: SECURITY_GROUP_NAME,
          },
        ],
        ip_ranges: [
          {
            cidr_ip: '0.0.0.0/0',
          },
        ]
      }
    ]
  }
  KEY_NAME = 'back_in_my_day_key_pair'
  KEY_PAIR_OPTIONS = {
    key_name: KEY_NAME
  }
  AMI_ID = 'ami-08111162'
  INSTANCE_PRIVATE_KEY_FILE = './back_in_my_day.pem'
  USER_DATA_SCRIPT = <<-RUBY
    #!/bin/bash
    yum install -y nginx
    chkconfig nginx on
    service nginx start
    ip=$(/bin/hostname -i)
    sed -i.bkp "/This page/i "$ip"" /usr/share/nginx/html/index.html
  RUBY
  ENCODED_USER_DATA = Base64.encode64 USER_DATA_SCRIPT
end
