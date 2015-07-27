module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/create_virtual_mfa_device.rb'

        # Create a access keys for user (by default detects user from access credentials)
        #<CreateVirtualMFADeviceResponse>
        #  <CreateVirtualMFADeviceResult>
        #    <VirtualMFADevice>
        #      <SerialNumber>arn:aws:iam::123456789012:mfa/ExampleName</SerialNumber>
        #        <Base32StringSeed>2K5K5XTLA7GGE75TQLYEXAMPLEEXAMPLEEXAMPLECHDFW4KJYZ6UFQ75LL7COCYKM</Base32StringSeed>
        #      <QRCodePNG>89504E470D0A1A0AASDFAHSDFKJKLJFKALSDFJASDF</QRCodePNG> <!-- byte array of png file -->
        #    </VirtualMFADevice>
        #  </CreateVirtualMFADeviceResult>
        #  <ResponseMetadata>
        #    <RequestId>7a62c49f-347e-4fc4-9331-6e8eEXAMPLE</RequestId>
        #  </ResponseMetadata>
        # </CreateVirtualMFADeviceResponse> 
        #http://docs.aws.amazon.com/IAM/latest/APIReference/API_CreateVirtualMFADevice.html

        def create_virtual_mfa_device(device_name, options = {})
          request({
            'Action'    => 'CreateVirtualMFADevice',
            'VirtualMFADeviceName' => device_name,
            :parser     => Fog::Parsers::AWS::IAM::CreateVirtualMfaDevice.new
          }.merge!(options))
        end

      end
    end
  end
end
