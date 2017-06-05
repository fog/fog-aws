module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_attributes'

        class ModifyTargetGroupAttributes < DescribeAttributes
          RESULT_KEY = 'ModifyTargetGroupAttributesResult'
        end
      end
    end
  end
end
