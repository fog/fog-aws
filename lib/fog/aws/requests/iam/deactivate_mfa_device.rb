module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/deactivate_mfa_device.rb'

        # http://docs.amazonwebservices.com/IAM/latest/APIReference/API_DeactivateMFADevice.html
        def deactivate_mfa_device(serial_number, user_name, options = {})
          request({
            'Action'  => 'DeactivateMFADevice',
            'SerialNumber' => serial_number,
            'UserName' => user_name,
            :parser   => Fog::Parsers::AWS::IAM::DeactivateMfaDevice.new
          }.merge!(options))
        end

      end

    end
  end
end
