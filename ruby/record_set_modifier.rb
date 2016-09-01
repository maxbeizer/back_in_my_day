require 'aws-sdk'
require_relative 'constants'
require_relative 'check_instances'

class RecordSetModifier
  attr_reader :client,
              :action,
              :ips

  def self.call!(args)
    action = args.slice!(0)
    new(Aws::Route53::Client.new(region: 'us-east-1'), action, args).change_record_sets
  end

  def initialize(client, action, ips)
    @client = client
    @action = action
    @ips    = Array(ips)
  end

  def change_record_sets
    res = client.change_resource_record_sets({
      hosted_zone_id: Constants::HOSTED_ZONE_ID,
      change_batch: {
        changes: [
          {
            action: action,
            resource_record_set: {
              name: Constants::TARGET_SUBDOMAIN,
              type: 'A',
              ttl: 1,
              resource_records: records
            }
          }
        ]
      }
    })
    puts "DNS change status: #{res.change_info.status}"
  end

  private
    def records
      ips.map do |ip|
        {
          value: ip
        }
      end
    end
end


if ARGV.length == 0 || %w(--help -h).include?(ARGV[0])
  puts 'usage record_set_modifier.rb action ip'
  puts 'actions: UPSERT, DELETE'
elsif ARGV[1] == 'all'
  args = Array(ARGV[0]) + InstanceChecker.get_public_ips_running
  RecordSetModifier.call!(args)
else
  RecordSetModifier.call!(ARGV)
end
