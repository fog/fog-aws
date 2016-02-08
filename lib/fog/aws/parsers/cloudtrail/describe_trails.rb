module Fog
  module Parsers
    module CloudTrail
      module AWS
        class DescribeTrails < Fog::Parsers::Base

          def reset
            @trail    = {}
            @response = { 'trailList' => [] }
          end

          def end_element(name)
            case name
              when 'Name',
                  'IncludeGlobalServiceEvents',
                  'S3BucketName',
                  'S3KeyPrefix',
                  'SnsTopicName',
                  'CloudWatchLogsLogGroupArn',
                  'CloudWatchLogsRoleArn',
                  'HomeRegion',
                  'IsMultiRegionTrail',
                  'KmsKeyId',
                  'LogFileValidationEnabled',
                  'TrailARN'
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
