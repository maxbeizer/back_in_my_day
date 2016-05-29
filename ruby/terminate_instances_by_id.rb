require 'aws-sdk'

class InstanceTerminatorById
  attr_reader :client,
              :id_array

  def initialize(client, ids)
    @client = client
    @id_array = Array(ids)
  end

  def call!
    res = client.terminate_instances({
      instance_ids: id_array
    })

    if res.successful?
      puts 'Instances terminating'
      puts 'Use check_instances.rb to get updates on instance state'
    else
      puts 'Error terminating instances'
    end

  rescue Aws::EC2::Errors::InvalidInstanceIDMalformed
    puts 'Invalid id'
  end
end

if ARGV.length == 0 || %w(--help -h).include?(ARGV[0])
  puts 'usage terminate_instances_by_id.rb id'
else
  InstanceTerminatorById.new(Aws::EC2::Client.new(region: 'us-east-1'), ARGV).call!
end
