module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/enable_mfa_device.rb'
        #http://docs.aws.amazon.com/IAM/latest/APIReference/API_EnableMFADevice.html

        def enable_mfa_device(user_name, serial_number, authentication_code1, authentication_code2, options = {})
          request({
            'Action'    => 'EnableMFADevice',
            'UserName' => user_name,
            'SerialNumber' => serial_number,
            'AuthenticationCode1' => authentication_code1,
            'AuthenticationCode2' => authentication_code2,
            :parser     => Fog::Parsers::AWS::IAM::EnableMfaDevice.new
          }.merge!(options))
        end

      end
    end
  end
end
