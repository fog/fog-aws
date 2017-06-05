module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_attributes'

        class ModifyLoadBalancerAttributes < DescribeAttributes
          RESULT_KEY = 'ModifyLoadBalancerAttributesResult'
        end
      end
    end
  end
end
