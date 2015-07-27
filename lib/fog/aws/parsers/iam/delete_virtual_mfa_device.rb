module Fog
  module Parsers
    module AWS
      module IAM

        class DeleteVirtualMfaDevice < Fog::Parsers::Base
          def reset
            @response = { 'DeleteVirtualMfaResult' => {} }
          end

          def end_element(name)
            case name
            when 'Path','SerialNumber'
              @response['DeleteVirtualMfaResult'][name] = value
            when 'RequestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
