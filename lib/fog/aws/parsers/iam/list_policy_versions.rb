module Fog
  module Parsers
    module AWS
      module IAM
        class ListPolicyVersions < Fog::Parsers::Base
          def reset
            super
            @version = {}
            @response = { 'Versions' => [] }
          end

          def end_element(name)
            case name
            when 'member'
              @response['Versions'] << @version
              @version = {}
            when 'IsTruncated'
              response[name] = (value == 'true')
            when 'Marker', 'RequestId'
              @response[name] = value
            end
            super
          end
        end
      end
    end
  end
end
