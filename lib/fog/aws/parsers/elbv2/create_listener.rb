module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_listeners'

        class CreateListener < DescribeListeners
          RESULT_KEY = 'CreateListenerResult'
        end
      end
    end
  end
end
