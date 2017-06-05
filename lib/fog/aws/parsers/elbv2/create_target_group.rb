module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_target_groups'

        class CreateTargetGroup < DescribeTargetGroups
          RESULT_KEY = 'CreateTargetGroupResult'
        end
      end
    end
  end
end
