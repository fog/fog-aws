module Fog
  module Parsers
    module AWS
      module ELBV2
        class SetSubnets < Fog::Parsers::Base
          def reset
            @availability_zones = {}
            @response = { 'SetSubnetsResult' => {}, 'ResponseMetadata' => {} }
          end

          def end_element(name)
            case name
            when 'member'
              # One subnet per availability zone, at least two subnets
              @availability_zones[@zone_name] = @subnet_id
            when 'SubnetId'
              @subnet_id = value
            when 'ZoneName'
              @zone_name = value
            when 'AvailabilityZones'
              @response['SetSubnetsResult']['AvailabilityZones'] = @availability_zones
            end
          end
        end
      end
    end
  end
end
