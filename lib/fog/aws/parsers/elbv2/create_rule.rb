module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_rules'

        class CreateRule < DescribeRules
          RESULT_KEY = 'CreateRuleResult'
        end
      end
    end
  end
end
