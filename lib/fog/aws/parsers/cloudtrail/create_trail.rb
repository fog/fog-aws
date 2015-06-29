module Fog
  module Parsers
    module CloudTrail
      module AWS
        class CreateTrail < Fog::Parsers::Base
          def reset
            @response = { 'Trail' => {} }
          end

          def end_element(name)
            case name
              when 'CloudWatchLogsLogGroupArn', 'CloudWatchLogsRoleArn', 'IncludeGlobalServiceEvents', 'Name', 'S3BucketName', 'S3KeyPrefix', 'SnsTopicName'
                @response['Trail'][name] = value
              when 'RequestId'
                @response[name] = value
            end
          end

        end
      end
    end
  end
end