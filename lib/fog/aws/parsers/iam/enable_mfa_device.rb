module Fog
  module Parsers
    module AWS
      module IAM

        class EnableMfaDevice < Fog::Parsers::Base

          def reset
            @response = { 'EnableMFADevice' => {} }
          end

          def end_element(name)
            case name
            when 'RequestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
