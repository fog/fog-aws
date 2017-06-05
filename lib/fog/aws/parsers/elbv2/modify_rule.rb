module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_rules'

        class ModifyRule < DescribeRules
          RESULT_KEY = 'ModifyRuleResult'
        end
      end
    end
  end
end
