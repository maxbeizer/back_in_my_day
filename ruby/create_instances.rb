require 'pry'
require 'aws-sdk'
require_relative 'constants'

class InstanceCreator
  attr_reader :client,
              :num_instances

  def initialize(client, num_instances)
    @client = client
    @num_instances = num_instances
  end

  def call!
    create_security_group; puts 'security group created'
    authorize_security_group; puts 'security group authorized'
    create_key_pair; puts 'key pair created'
    launch_instances; puts "#{num_instances} #{pluralize(num_instances, 'instance')} launched"
  end

  private
    def launch_instances
      res = client.run_instances({
        image_id: Constants::AMI_ID,
        min_count: 1,
        max_count: num_instances,
        key_name: Constants::KEY_NAME,
        security_groups: [Constants::SECURITY_GROUP_NAME],
        instance_type: 't2.micro',
        instance_initiated_shutdown_behavior: 'terminate'
      })
    end

    def create_key_pair
      client.create_key_pair(
        Constants::KEY_PAIR_OPTIONS
      )
    rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
      nil
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
