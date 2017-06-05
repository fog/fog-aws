module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_attributes'

        class DescribeLoadBalancerAttributes < DescribeAttributes
          RESULT_KEY = 'DescribeLoadBalancerAttributesResult'
        end
      end
    end
  end
end
