module Fog
  module AWS
    class CloudTrail

      class Real
        require 'fog/aws/parsers/cloudtrail/get_trail_status'

        def get_trail_status(name)
          request({
              'Action' => 'GetTrailStatus',
              'Name' => name,
              :parser => Fog::Parsers::CloudTrail::AWS::GetTrailStatus.new
            })
        end

      end

      class Mock
        def get_trail_status(name)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end