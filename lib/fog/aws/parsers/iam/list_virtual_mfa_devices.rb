module Fog
  module Parsers
    module AWS
      module IAM

        class ListVirtualMfaDevices < Fog::Parsers::Base

          def reset
            @device = {}
            @response = { 'Devices' => [] }
          end

          def end_element(name)
           case name
            when 'SerialNumber','UserId', 'Arn', 'EnableDate','UserName', 'CreateDate'
              @device[name] = value
            when 'member'
              @response['Devices'] << @device
              @device = {}
            when 'IsTruncated'
              response[name] = (value == 'true')
            when 'Marker', 'RequestId'
              response[name] = value
            end
          end
        end
      end
    end
  end
end
