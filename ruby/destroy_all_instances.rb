require 'aws-sdk'
require_relative 'constants'

class InstanceDestroyer
  attr_reader :client,
              :resource

  def initialize(client)
    @client = client
    @resource = Aws::EC2::Resource.new(client: client)
  end

  def call!
    terminate_instances; puts 'instances terminated'
    delete_key_pair; puts 'key pair deleted'
    revoke_security_group; puts 'group revoked'
    delete_security_group; puts 'group destroyed'
  end

  private
    def terminate_instances
      @instance_ids = []
      resource.instances.each do |instance|
        @instance_ids << instance.instance_id
      end
      client.terminate_instances({
        instance_ids: @instance_ids
      })
    end

    def delete_key_pair
      client.delete_key_pair(
        Constants::KEY_PAIR_OPTIONS
      )
    end

    def revoke_security_group
      client.revoke_security_group_ingress(
        Constants::SECURITY_GROUP_INGRESS_OPTIONS
      )
    rescue Aws::EC2::Errors::InvalidGroupNotFound
      nil
    end

    def delete_security_group
      client.delete_security_group({
        group_name: Constants::SECURITY_GROUP_NAME
      })
    rescue Aws::EC2::Errors::InvalidGroupNotFound
      nil
    end
end

if ARGV.length > 0 || %w(--help -h).include?(ARGV[0])
  puts 'usage destroy_all_instances.rb'
else
  InstanceDestroyer.new(Aws::EC2::Client.new(region: 'us-east-1')).call!
end
