Shindo.tests('AWS::KMS | key requests', %w[aws kms]) do
  key_id = nil

  tests('success') do
    tests('#create_key').data_matches_schema(AWS::KMS::Formats::DESCRIBE_KEY) do
      result = Fog::AWS[:kms].create_key.body
      key_id = result['KeyMetadata']['KeyId']

      result
    end
  end

  tests('#describe_key').data_matches_schema(AWS::KMS::Formats::DESCRIBE_KEY) do
    result = Fog::AWS[:kms].describe_key(key_id).body
    returns(key_id) { result['KeyMetadata']['KeyId'] }
    result
  end

  tests('#list_keys').data_matches_schema(AWS::KMS::Formats::LIST_KEYS) do
    Fog::AWS[:kms].list_keys.body
  end

  tests('#schedule_key_deletion').data_matches_schema(AWS::KMS::Formats::SCHEDULE_KEY_DELETION) do
    Fog::AWS[:kms].schedule_key_deletion(key_id, 7)
  end
end
