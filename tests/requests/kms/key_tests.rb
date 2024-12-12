Shindo.tests('AWS::KMS | key requests', %w[aws kms]) do
  key_id = nil
  public_key = nil
  pkey = nil
  data = 'sign me'

  tests('#create_key').data_matches_schema(AWS::KMS::Formats::DESCRIBE_KEY) do
    result = Fog::AWS[:kms].create_key(
      'KeySpec' => 'RSA_2048',
      'KeyUsage' => 'SIGN_VERIFY'
    ).body
    key_id = result['KeyMetadata']['KeyId']

    result
  end

  tests('#describe_key').data_matches_schema(AWS::KMS::Formats::DESCRIBE_KEY) do
    result = Fog::AWS[:kms].describe_key(key_id).body
    returns(key_id) { result['KeyMetadata']['KeyId'] }
    result
  end

  tests('#get_public_key').data_matches_schema(AWS::KMS::Formats::GET_PUBLIC_KEY) do
    result = Fog::AWS[:kms].get_public_key(key_id).body
    public_key = Base64.decode64(result['PublicKey'])
    pkey = OpenSSL::PKey::RSA.new(public_key)
    returns(key_id) { result['KeyId'] }
    result
  end

  tests('#list_keys').data_matches_schema(AWS::KMS::Formats::LIST_KEYS) do
    Fog::AWS[:kms].list_keys.body
  end

  tests('#sign').data_matches_schema(AWS::KMS::Formats::SIGN) do
    Fog::AWS[:kms].sign(key_id, data, 'RSASSA_PSS_SHA_256', 'MessageType' => 'RAW').body
  end

  tests('#sign RAW') do
    sign_response = Fog::AWS[:kms].sign(key_id, data, 'RSASSA_PSS_SHA_256', 'MessageType' => 'RAW').body
    signature = Base64.decode64(sign_response['Signature'])

    pkey.verify('SHA256', signature, data, { rsa_padding_mode: 'pss' })
  end

  tests('#sign DIGEST') do
    hash = OpenSSL::Digest.digest('SHA256', data)
    sign_response = Fog::AWS[:kms].sign(key_id, hash, 'RSASSA_PSS_SHA_256', 'MessageType' => 'DIGEST').body
    signature = Base64.decode64(sign_response['Signature'])

    pkey.verify_raw('SHA256', signature, hash, { rsa_padding_mode: 'pss' })
  end

  tests('#schedule_key_deletion').data_matches_schema(AWS::KMS::Formats::SCHEDULE_KEY_DELETION) do
    Fog::AWS[:kms].schedule_key_deletion(key_id, 7).body
  end
end
