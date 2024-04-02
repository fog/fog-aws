module Fog
  module Parsers
    module AWS
      module RDS
        class ModifyDBSubnetGroup < Fog::Parsers::Base
          def reset
            @response = { 'ModifyDBSubnetGroupAttributeResult' => {}, 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end