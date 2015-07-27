module Fog
  module Parsers
    module AWS
      module IAM

        class DeactivateMfaDevice < Fog::Parsers::Base

          def reset
            @response = { 'DeactivateMFADevice' => {} }
          end

          def end_element(name)
            case name
            when 'RequestId'
              response[name] = value
            end
          end
        end
      end
    end
  end
end
