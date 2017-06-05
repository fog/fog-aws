module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_target_groups'

        class ModifyTargetGroup < DescribeTargetGroups
          RESULT_KEY = 'ModifyTargetGroupResult'
        end
      end
    end
  end
end
