class AWS
  module KMS
    module Formats
      BASIC = {
        'ResponseMetadata' => { 'RequestId' => String }
      }.freeze

      DESCRIBE_KEY = {
        'KeyMetadata' => {
          'KeyUsage' => String,
          'AWSAccountId' => String,
          'KeyId' => String,
          'Description' => Fog::Nullable::String,
          'CreationDate' => Time,
          'Arn' => String,
          'Enabled' => Fog::Boolean
        }
      }.freeze

      LIST_KEYS = {
        'Keys' => [{ 'KeyId' => String, 'KeyArn' => String }],
        'Truncated' => Fog::Boolean,
        'Marker' => Fog::Nullable::String
      }.freeze
    end
  end
end
