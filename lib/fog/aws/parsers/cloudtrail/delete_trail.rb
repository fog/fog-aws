module Fog
  module Parsers
    module CloudTrail
      module AWS
        class DeleteTrail < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def end_element(name)
            case name
              when 'RequestId'
                @response[name] = @value
            end
          end
        end
      end
    end
  end
end