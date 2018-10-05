#!/usr/bin/ruby
# vim:  sw=4 ai ts=4 expandtab

require 'open-uri'
require 'json'
require 'erb'

# the following project is at https://github.com/powdahound/ec2instances.info
DEFAULT_EC2_INSTANCES = 'https://www.ec2instances.info/instances.json'
TEMPLATE_FILE = File.dirname(__FILE__) + "/flavors.erb"

STDERR.puts("Reading template file #{TEMPLATE_FILE}")

if ARGV.length < 1
    abort("Usage: #{__FILE__} outputfile [ input_url ]");
end #outputfile

OUTPUT_FILE = ARGV[0]
IN_FILE = ARGV.length > 1 ? ARGV[1] : DEFAULT_EC2_INSTANCES
STDERR.puts("Reading instance data from #{IN_FILE}")
file = open(IN_FILE)

STDERR.puts("Parsing json instance data")
instance_data = JSON.parse(file.read())

instances = {}
instance_data.each do |item|
    if item['vCPU'] == 'N/A'
        next
    end
    h = {
      :id                   => item['instance_type'],
      :name                 => item['pretty_name'],
      :bits                 => item['arch'].include?("x86_64")? 64 : ( item['arch'].include?('i386')? 32 : nil ),
      :cores                => item['vCPU'],
      :disk                 => item['storage'] == nil ? 0 : item['storage']['size'],
      :ram                  => (item['memory'] * 1024.0 * 1024.0 * 1024.0 / 1000000).floor,
      :ebs_optimized_available => item['ebs_optimized'],
      :instance_store_volumes  => item['storage'] == nil ? 0 : item['storage']['devices']
      }
    instances[h[:id]] = h
end #instance_data

class FlavorsErb
    attr_accessor :instances
    def initialize(instances)
        @instances = instances.values().sort! { |x,y| x[:id] <=> y[:id] }
        @template  = File.read(TEMPLATE_FILE)
    end # initialize

    def render
        ERB.new(@template).result( binding )
    end # render
end # FlavorsErb

STDERR.puts("Writing out to #{OUTPUT_FILE}")
flavors = FlavorsErb.new(instances)
File.open(OUTPUT_FILE, 'w') { |file| file.write(flavors.render()) }
