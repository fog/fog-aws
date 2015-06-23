module Fog
  module Parsers
    module CloudTrail
      module AWS
        class GetTrailStatus < Fog::Parsers::Base

          def reset
            @response = {
              'TrailStatus' => {
                'LatestNotificationAttemptSucceeded' => nil,
                'LatestCloudWatchLogsDeliveryError' => nil,
                'LatestCloudWatchLogsDeliveryTime' => nil,
                'LatestDeliveryError' => nil,
                'LatestDeliveryTime' => nil,
                'LatestNotificationError' => nil,
                'LatestNotificationTime' => nil,
                'StartLoggingTime' => nil,
                'StopLoggingTime' => nil
              }
            }
          end

          def end_element(name)
            case name
              when 'IsLogging', 'LatestCloudWatchLogsDeliveryError', 'LatestCloudWatchLogsDeliveryTime', 'LatestDeliveryError',
                'LatestDeliveryTime', 'LatestNotificationError', 'LatestNotificationTime', 'StartLoggingTime', 'StopLoggingTime'
                @response['TrailStatus'][name] = value
              when 'RequestId'
                @response[name] = value
            end
          end

        end
      end
    end
  end
end