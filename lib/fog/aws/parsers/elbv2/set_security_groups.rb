module Fog
  module Parsers
    module AWS
      module ELBV2
        class SetSecurityGroups < Fog::Parsers::Base
          def reset
            @security_group_ids = []
            @response = { 'SetSecurityGroupsResult' => {}, 'ResponseMetadata' => {} }
          end

          def end_element(name)
            case name
            when 'member'
              @security_group_ids << value
            when 'SecurityGroupIds'
              @response['SetSecurityGroupsResult']['SecurityGroupIds'] = @security_group_ids
            end
          end
        end
      end
    end
  end
end
