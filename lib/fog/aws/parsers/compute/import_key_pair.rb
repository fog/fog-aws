module Fog
  module Parsers
    module AWS
      module AWS
        class ImportKeyPair < Fog::Parsers::Base
          def end_element(name)
            case name
            when 'keyFingerprint', 'keyName', 'requestId'
              @response[name] = value
            end
          end
        end
      end
    end
  end
end
