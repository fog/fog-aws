module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_attributes'

        class DescribeTargetGroupAttributes < DescribeAttributes
          RESULT_KEY = 'DescribeTargetGroupAttributesResult'
        end
      end
    end
  end
end
