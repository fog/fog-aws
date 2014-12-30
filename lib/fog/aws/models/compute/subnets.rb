require 'fog/core/collection'
require 'fog/aws/models/compute/subnet'

module Fog
  module Compute
    class Aws
      class Subnets < Fog::Collection
        attribute :filters

        model Fog::Compute::AWS::Subnet

        # Creates a new subnet
        #
        # Aws.subnets.new
        #
        # ==== Returns
        #
        # Returns the details of the new Subnet
        #
        #>> Aws.subnets.new
        # <Fog::AWS::Compute::Subnet
        # subnet_id=subnet-someId,
        # state=[pending|available],
        # vpc_id=vpc-someId
        # cidr_block=someIpRange
        # available_ip_address_count=someInt
        # tagset=nil
        # >
        #

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # Returns an array of all Subnets that have been created
        #
        # Aws.subnets.all
        #
        # ==== Returns
        #
        # Returns an array of all VPCs
        #
        #>> Aws.subnets.all
        # <Fog::AWS::Compute::Subnet
        # filters={}
        # [
        # subnet_id=subnet-someId,
        # state=[pending|available],
        # vpc_id=vpc-someId
        # cidr_block=someIpRange
        # available_ip_address_count=someInt
        # tagset=nil
        # ]
        # >
        #

        def all(filters_arg = filters)
          unless filters_arg.is_a?(Hash)
            Fog::Logger.warning("all with #{filters_arg.class} param is deprecated, use all('subnet-id' => []) instead [light_black](#{caller.first})[/]")
            filters_arg = {'subnet-id' => [*filters_arg]}
          end
          filters = filters_arg
          data = service.describe_subnets(filters).body
          load(data['subnetSet'])
        end

        # Used to retrieve a Subnet
        # subnet-id is required to get the associated VPC information.
        #
        # You can run the following command to get the details:
        # Aws.subnets.get("subnet-12345678")
        #
        # ==== Returns
        #
        #>> Aws.subnets.get("subnet-12345678")
        # <Fog::AWS::Compute::Subnet
        # subnet_id=subnet-someId,
        # state=[pending|available],
        # vpc_id=vpc-someId
        # cidr_block=someIpRange
        # available_ip_address_count=someInt
        # tagset=nil
        # >
        #

        def get(subnet_id)
          if subnet_id
            self.class.new(:service => service).all('subnet-id' => subnet_id).first
          end
        end
      end
    end
  end
end
