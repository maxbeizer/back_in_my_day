require 'pry'
require 'aws-sdk'
require_relative 'constants'

class InstanceChecker
  attr_reader :client,
              :resource

  def initialize(client)
    @client = client
    @resource = Aws::EC2::Resource.new(client: client)
  end

  def call!
    resource.instances.each do |instance|
      puts <<-RES
        id: #{instance.instance_id}
        state: #{instance.state.name}
        public_ip_address: #{instance.public_ip_address}
        ---
      RES
    end
  end
end

if ARGV.length > 0 || %w(--help -h).include?(ARGV[0])
  puts 'usage destroy_all_instances.rb'
else
  InstanceChecker.new(Aws::EC2::Client.new(region: 'us-east-1')).call!
end
