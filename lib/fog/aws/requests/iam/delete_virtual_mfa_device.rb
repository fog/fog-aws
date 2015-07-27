module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/delete_virtual_mfa_device.rb'

        #http://docs.aws.amazon.com/IAM/latest/APIReference/API_DeleteVirtualMFADevices.html
        def delete_virtual_mfa_device(serial_number, options = {})
          request({
            'Action'    => 'DeleteVirtualMFADevice',
            'SerialNumber' => serial_number,
            :parser     => Fog::Parsers::AWS::IAM::DeleteVirtualMfaDevice.new
          }.merge!(options))
        end

      end
    end
  end
end
