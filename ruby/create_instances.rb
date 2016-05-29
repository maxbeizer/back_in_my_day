require 'aws-sdk'
require_relative 'constants'

class InstanceCreator
  attr_reader :client,
              :num_instances

  def initialize(client, num_instances)
    @client        = client
    @num_instances = num_instances
  end

  def call!
    create_security_group; puts 'security group created'
    authorize_security_group; puts 'security group authorized'
    create_key_pair; puts 'key pair created'
    chmod_key
    launch_instances; puts "#{num_instances} instance launch requested"
    print_post_script
  end

  private
    def print_post_script
      puts <<-DOC
        Use check_instances.rb to get ip addresses and then
        ssh -i back_in_my_day_key_pair ec2-user@ip_address
      DOC
    end

    def launch_instances
      client.run_instances({
        image_id: Constants::AMI_ID,
        min_count: 1,
        max_count: num_instances,
        key_name: Constants::KEY_NAME,
        security_groups: [Constants::SECURITY_GROUP_NAME],
        instance_type: 't2.micro',
        instance_initiated_shutdown_behavior: 'terminate',
        user_data: Constants::ENCODED_USER_DATA
      })
    end

    def chmod_key
      if File.exist? Constants::INSTANCE_PRIVATE_KEY_FILE
        system "chmod 400 #{Constants::INSTANCE_PRIVATE_KEY_FILE}"
      else
        raise 'No private key found. Consider destroying all instances'
      end
    end

    def create_key_pair
      res = client.create_key_pair(
        Constants::KEY_PAIR_OPTIONS
      )
      File.open(Constants::INSTANCE_PRIVATE_KEY_FILE, 'w') do |f|
        f.write res.key_material
      end
    rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
      nil
    rescue Errno::EACCES
      File.delete(Constants::INSTANCE_PRIVATE_KEY_FILE)
    end

    def authorize_security_group
      client.authorize_security_group_ingress(
        Constants::SECURITY_GROUP_INGRESS_OPTIONS
      )
    rescue Aws::EC2::Errors::InvalidPermissionDuplicate
      nil
    end

    def create_security_group
      client.create_security_group({
        group_name: Constants::SECURITY_GROUP_NAME,
        description: Constants::SECURITY_GROUP_DESCRIPTION
      })
    rescue Aws::EC2::Errors::InvalidGroupDuplicate
      nil
    end
end


if ARGV.length == 0 || %w(--help -h).include?(ARGV[0])
  puts 'usage create_instances.rb num_instances'
else
  InstanceCreator.new(Aws::EC2::Client.new(region: 'us-east-1'), ARGV[0]).call!
end
