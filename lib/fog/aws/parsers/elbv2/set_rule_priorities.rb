module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_rules'

        class SetRulePriorities < DescribeRules
          RESULT_KEY = 'SetRulePrioritiesResult'
        end
      end
    end
  end
end
