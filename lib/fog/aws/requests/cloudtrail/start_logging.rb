module Fog
  module AWS
    class CloudTrail

      class Real
        require 'fog/aws/parsers/cloudtrail/start_logging'

        def start_logging(name)
          request({
              'Action' => 'StartLogging',
              'Name' => name,
              :parser => Fog::Parsers::CloudTrail::AWS::StartLogging.new
            })
        end
      end

      class Mock
        def start_logging(name)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end
