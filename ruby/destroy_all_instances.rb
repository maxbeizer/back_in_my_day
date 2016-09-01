require 'aws-sdk'
require_relative 'constants'
require_relative 'record_set_modifier'
require_relative 'check_instances'

class InstanceDestroyer
  attr_reader :client,
              :resource

  def initialize(client)
    @client   = client
    @resource = Aws::EC2::Resource.new(client: client)
  end

  def call!
    ensure_dns_updated; puts 'Updating DNS'
    terminate_instances; puts 'instances terminated'
    delete_key_pair; puts 'key pair deleted'
    delete_local_key; puts 'local destroyed'
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

    def ensure_dns_updated
      args = Array('DELETE') + InstanceChecker.get_public_ips_running
      RecordSetModifier.call!(args)
    end

    def delete_local_key
      if File.exist? Constants::INSTANCE_PRIVATE_KEY_FILE
        File.delete(Constants::INSTANCE_PRIVATE_KEY_FILE)
      end
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
    rescue Aws::EC2::Errors::DependencyViolation
      puts 'Still terminating instances...'
      sleep 2
      delete_security_group
    end
end

if ARGV.length > 0 || %w(--help -h).include?(ARGV[0])
  puts 'usage destroy_all_instances.rb'
else
  InstanceDestroyer.new(Aws::EC2::Client.new(region: 'us-east-1')).call!
end
