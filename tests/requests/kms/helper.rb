class AWS
  module KMS
    module Formats
      BASIC = {
        'ResponseMetadata' => { 'RequestId' => String }
      }.freeze

      DESCRIBE_KEY = {
        'KeyMetadata' => {
          'Arn' => String,
          'AWSAccountId' => String,
          'CreationDate' => Time,
          'DeletionDate' => Fog::Nullable::Time,
          'Description' => Fog::Nullable::String,
          'Enabled' => Fog::Boolean,
          'KeyId' => String,
          'KeyState' => String,
          'KeyUsage' => String
        }
      }.freeze

      LIST_KEYS = {
        'Keys' => [{ 'KeyArn' => String, 'KeyId' => String }],
        'Marker' => Fog::Nullable::String,
        'Truncated' => Fog::Boolean
      }.freeze

      SCHEDULE_KEY_DELETION = {
        'DeletionDate' => Time,
        'KeyId' => String,
        'KeyState' => String,
        'PendingWindowInDays' => Integer
      }.freeze
    end
  end
end
