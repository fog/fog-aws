module Fog
  module AWS
    class CloudTrail

      class Real
        require 'fog/aws/parsers/cloudtrail/stop_logging'

        def stop_logging(name)
          request({
              'Action' => 'StopLogging',
              'Name' => name,
              :parser => Fog::Parsers::CloudTrail::AWS::StopLogging.new
            })
        end
      end

      class Mock
        def stop_logging(name)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end
