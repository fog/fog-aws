module Fog
  module AWS
    class CloudTrail

      # {
      #   "CloudWatchLogsLogGroupArn": "string",
      #   "CloudWatchLogsRoleArn": "string",
      #   "IncludeGlobalServiceEvents": boolean,
      #   "Name": "string",
      #   "S3BucketName": "string",
      #   "S3KeyPrefix": "string",
      #   "SnsTopicName": "string"
      # }

      class Real
        require 'fog/aws/parsers/cloudtrail/create_trail'

        def create_trail(name, s3_bucket_name, s3_key_prefix=nil, sns_topic_name=nil, include_global_service_events=nil, cloud_watch_logs_log_group_arn=nil, cloud_watch_logs_role_arn=nil)
          request({
              'Action' => 'CreateTrail',
              'Name' => name,
              'S3BucketName' => s3_bucket_name,
              'S3KeyPrefix' => s3_key_prefix,
              'SnsTopicName' => sns_topic_name,
              'IncludeGlobalServiceEvents' => include_global_service_events,
              'CloudWatchLogsLogGroupArn' => cloud_watch_logs_log_group_arn,
              'CloudWatchLogsRoleArn' => cloud_watch_logs_role_arn,
              :parser => Fog::Parsers::CloudTrail::AWS::CreateTrail.new
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
