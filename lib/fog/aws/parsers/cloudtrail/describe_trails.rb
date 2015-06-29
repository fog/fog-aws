module Fog
  module Parsers
    module CloudTrail
      module AWS
        class DescribeTrails < Fog::Parsers::Base
          def reset
            @trail = {}
            @response = { 'trailList' => [] }
          end

          def end_element(name)
            case name
              when 'CloudWatchLogsLogGroupArn', 'CloudWatchLogsRoleArn', 'IncludeGlobalServiceEvents', 'Name', 'S3BucketName', 'S3KeyPrefix', 'SnsTopicName'
                @trail[name] = value
              when 'member'
                @response['trailList'] << @trail
                @trail = {}
              when 'RequestId'
                @response[name] = value
            end
          end
        end
      end
    end
  end
end
