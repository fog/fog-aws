module Fog
  module Parsers
    module AWS
      module ELBV2
        require 'fog/aws/parsers/elbv2/describe_listeners'

        class ModifyListener < DescribeListeners
          RESULT_KEY = 'ModifyListenerResult'
        end
      end
    end
  end
end
