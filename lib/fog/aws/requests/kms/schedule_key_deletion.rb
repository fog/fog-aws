module Fog
  module AWS
    class KMS
      class Real
        require 'fog/aws/parsers/kms/schedule_key_deletion'

        def schedule_key_deletion(identifier, pending_window_in_days)
          request(
            'Action' => 'ScheduleKeyDeletion',
            'KeyId' => identifier,
            'PendingWindowInDays' => pending_window_in_days,
            :parser => Fog::Parsers::AWS::KMS::ScheduleKeyDeletion.new
          )
        end
      end

      class Mock
        def schedule_key_deletion(identifier, pending_window_in_days)
          response = Excon::Response.new
          key = self.data[:keys][identifier]

          key['DeletionDate'] = Time.now + (60 * 60 * 24 * pending_window_in_days)
          key['Enabled'] = false
          key['KeyState'] = 'PendingDeletion'

          response.body = {
            'DeletionDate' => key['DeletionDate'],
            'KeyId' => key['KeyId'],
            'KeyState' => key['KeyState'],
            'PendingWindowInDays' => pending_window_in_days
          }
          response
        end
      end
    end
  end
end
