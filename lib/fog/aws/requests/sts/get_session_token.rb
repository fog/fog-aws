module Fog
  module AWS
    class STS
      class Real
        require 'fog/aws/parsers/sts/get_session_token'

        def get_session_token(duration=43200, serial_number = nil, token_code = nil)
          request({
              'Action' => 'GetSessionToken',
              'DurationSeconds' => duration,
              'SerialNumber' => serial_number,
              'TokenCode' => token_code,
              :idempotent => true,
              :parser => Fog::Parsers::AWS::STS::GetSessionToken.new
            })
        end
      end
    end
  end
end
