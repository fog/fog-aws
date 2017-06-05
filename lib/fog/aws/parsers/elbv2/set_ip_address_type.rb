module Fog
  module Parsers
    module AWS
      module ELBV2
        class SetIpAddressType < Fog::Parsers::Base
          def reset
            @response = { 'SetIpAddressTypeResult' => {}, 'ResponseMetadata' => {} }
          end

          def end_element(name)
            case name
            when 'IpAddressType'
              @response['SetIpAddressTypeResult'][name] = value
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end
