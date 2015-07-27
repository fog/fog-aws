module Fog
  module Parsers
    module AWS
      module IAM

        class CreateVirtualMfaDevice < Fog::Parsers::Base

          def reset
            @response = { 'VirtualMFADevice' => {} }
          end

          def end_element(name)
            case name
            when 'Path','SerialNumber', 'Base32StringSeed','QRCodePNG'
              @response['VirtualMFADevice'][name] = value
            when 'RequestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
