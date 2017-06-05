module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeAccountLimits < Fog::Parsers::Base
          def reset
            @limits = {}
            @response = { 'DescribeAccountLimitsResult' => {}, 'ResponseMetadata' => {} }
          end

          def end_element(name)
            case name
            when 'member'
              @limits[@key] = @max
            when 'Name'
              @key = value
            when 'Max'
              @max = value.to_i
            when 'Limits'
              @response['DescribeAccountLimitsResult']['Limits'] = @limits
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end
