require 'aws-sdk'
require_relative 'constants'

class InstanceDestroyer
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def call!
    delete_security_group
  end

  private
    def delete_security_group
      client.delete_security_group({
        group_name: Constants::SECURITY_GROUP_NAME,
        description: Constants::SECURITY_GROUP_DESCRIPTION
      })
    end
end

if ARGV.length == 0 || %w(--help -h).include?(ARGV[0])
  puts 'usage destroy_all_instances.rb'
else
  InstanceDestroyer.new(Aws::EC2::Client.new(region: 'us-east-1')).call!
end
