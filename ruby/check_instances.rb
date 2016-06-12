require 'aws-sdk'
require_relative 'constants'

class InstanceChecker
  attr_reader :client,
              :resource

  def self.get_public_ips_running
    new.send :build_ip_array
  end

  def initialize(client = Aws::EC2::Client.new(region: 'us-east-1'))
    @client = client
    @resource = Aws::EC2::Resource.new(client: client)
  end

  def call!
    resource.instances.each do |instance|
      puts <<-RES
        id: #{instance.instance_id}
        state: #{instance.state.name}
        public_ip_address: #{instance.public_ip_address}
        public_dns: #{instance.public_dns_name}
        ---
      RES
    end
  end

  private
    def build_ip_array
      Array(resource.instances)
        .select { |instance| instance.state.name == 'running' }
        .map(&:public_ip_address)
    end
end

if ARGV[0] == 'ips'
  InstanceChecker.get_public_ips_running
else
  InstanceChecker.new.call!
end
