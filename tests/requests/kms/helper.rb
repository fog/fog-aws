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
          'KeySpec' => String,
          'KeyState' => String,
          'KeyUsage' => String
        }
      }.freeze

      GET_PUBLIC_KEY = {
        'EncryptionAlgorithms' => Fog::Nullable::Array,
        'KeyAgreementAlgorithms' => Fog::Nullable::Array,
        'KeyId' => String,
        'KeySpec' => String,
        'KeyUsage' => String,
        'PublicKey' => String,
        'SigningAlgorithms' => Fog::Nullable::Array
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
