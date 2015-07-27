module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/list_virtual_mfa_devices.rb'

        #http://docs.aws.amazon.com/IAM/latest/APIReference/API_DeleteVirtualMFADevices.html
        def list_virtual_mfa_devices( options = {})
          request({
            'Action'    => 'ListVirtualMFADevices',
            :parser     => Fog::Parsers::AWS::IAM::ListVirtualMfaDevices.new
          }.merge!(options))
        end

      end
    end
  end
end
