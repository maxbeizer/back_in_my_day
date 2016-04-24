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
    create_security_group
  end

  private
    def create_security_group
      client.create_security_group({
        group_name: Constants::SECURITY_GROUP_NAME,
        description: Constants::SECURITY_GROUP_DESCRIPTION
      })
    rescue Aws::EC2::Errors::InvalidGroupDuplicate
      puts 'security group already exists'
    end
end


if ARGV.length == 0 || %w(--help -h).include?(ARGV[0])
  puts 'usage create_instances.rb num_instances'
else
  InstanceCreator.new(Aws::EC2::Client.new(region: 'us-east-1'), ARGV[0]).call!
end
