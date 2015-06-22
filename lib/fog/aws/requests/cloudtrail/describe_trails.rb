module Fog
  module AWS
    class CloudTrail

      class Real
        require 'fog/aws/parsers/cloudtrail/describe_trails'

        def describe_trails(options = {})
          request({
              'Action' => 'DescribeTrails',
              :parser => Fog::Parsers::CloudTrail::AWS::DescribeTrails.new
            }.merge(options))
        end

      end

      class Mock
        def describe_trails(trail_names)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end
