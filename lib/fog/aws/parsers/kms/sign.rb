module Fog
  module Parsers
    module AWS
      module KMS
        class Sign < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'KeyId', 'Signature', 'SigningAlgorithm'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
