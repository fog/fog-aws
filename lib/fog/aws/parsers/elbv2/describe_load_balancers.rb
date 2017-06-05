module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeLoadBalancers < Fog::Parsers::Base
          RESULT_KEY = 'DescribeLoadBalancersResult'

          def reset
            @load_balancers = []
            @availability_zones = []
            @security_groups = []

            @load_balancer = nil
            @availability_zone = nil
            @security_group = nil

            @response = { self.class::RESULT_KEY => {}, 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'LoadBalancers'
              @in_load_balancers = true
            when 'AvailabilityZones'
              @in_availability_zones = true
            when 'SecurityGroups'
              @in_security_groups = true
            when 'State'
              @in_state = true
            when 'member'
              if @in_availability_zones
                @availability_zone = {}
              elsif @in_security_groups
              elsif @in_load_balancers
                @load_balancer = {}
              end
            end
          end

          def end_element(name)
            case name
            when 'member'
              if @in_availability_zones
                @availability_zones << @availability_zone
                @availability_zone = nil
              elsif @in_security_groups
                @security_groups << value
              elsif @in_load_balancers
                @load_balancers << @load_balancer
                @load_balancer = nil
              end

            when 'AvailabilityZones'
              @load_balancer['AvailabilityZones'] = @availability_zones
              @availability_zones = []
              @in_availability_zones = false

            when 'SecurityGroups'
              @load_balancer['SecurityGroups'] = @security_groups
              @security_groups = []
              @in_security_groups = false

            when 'State'
              @in_state = false

            when 'Code'
              @load_balancer['State'] = { 'Code' => value } if @in_state

            when 'LoadBalancerArn', 'Scheme', 'DNSName', 'Type', 'IpAddressType', 'LoadBalancerName', 'VpcId', 'CanonicalHostedZoneId', 'CreatedTime'
              @load_balancer[name] = value if @load_balancer

            when 'SubnetId', 'ZoneName'
              @availability_zone[name] = value if @availability_zone

            when 'LoadBalancers'
              @response[self.class::RESULT_KEY]['LoadBalancers'] = @load_balancers

            when 'RequestId'
              @response['ResponseMetadata'][name] = value

            when 'NextMarker'
              @results['NextMarker'] = value

            end
          end
        end
      end
    end
  end
end
