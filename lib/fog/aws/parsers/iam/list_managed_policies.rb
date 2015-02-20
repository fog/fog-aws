module Fog
  module Parsers
    module AWS
      module IAM
        require 'fog/aws/parsers/iam/policy_parser'
        class ListManagedPolicies < Fog::Parsers::AWS::IAM::PolicyParser
          def reset
            super
            @response = { 'Policies' => [] , 'Marker' => '', 'IsTruncated' => false}
          end

          def finished_policy(policy)
            @response['Policies'] << policy
          end

          def end_element(name)
            case name
            when 'RequestId', 'Marker'
              @response[name] = value
            when 'IsTruncated'
              @response[name] = (value == 'true')
            end
            super
          end
        end
      end
    end
  end
end
