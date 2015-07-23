module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/list_mfa_devices.rb'

        #http://docs.aws.amazon.com/IAM/latest/APIReference/API_ListMFADevices.html
        def list_mfa_devices( options = {})
          request({
              'Action'    => 'ListMFADevices',
              :parser     => Fog::Parsers::AWS::IAM::ListMfaDevices.new
            }.merge!(options))
        end

      end
    end
  end
end
