module Fog
  module Parsers
    module AWS
      module KMS
        class ScheduleKeyDeletion < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'DeletionDate'
              @response[name] = Time.parse(value)
            when 'KeyId', 'KeyState'
              @response[name] = value
            when 'PendingWindowInDays'
              @response[name] = value.to_i
            end
          end
        end
      end
    end
  end
end
