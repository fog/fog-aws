module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_load_balancers'

        class CreateLoadBalancer < DescribeLoadBalancers
          RESULT_KEY = 'CreateLoadBalancerResult'
        end
      end
    end
  end
end
