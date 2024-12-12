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

  tests('#describe_key') do
    result = Fog::AWS[:kms].describe_key(key_id).body

    tests('format').data_matches_schema(AWS::KMS::Formats::DESCRIBE_KEY) { result }

    tests('result_contains correct key_id').returns(key_id) { result['KeyMetadata']['KeyId'] }
  end

  tests('#get_public_key') do
    result = Fog::AWS[:kms].get_public_key(key_id).body
    public_key = Base64.decode64(result['PublicKey'])
    pkey = OpenSSL::PKey::RSA.new(public_key)

    tests('format').data_matches_schema(AWS::KMS::Formats::GET_PUBLIC_KEY) { result }

    tests('result contains correct key_id').returns(key_id) { result['KeyId'] }
  end

  tests('#list_keys') do
    result = Fog::AWS[:kms].list_keys.body

    tests('format').data_matches_schema(AWS::KMS::Formats::LIST_KEYS) { result }

    tests('result contains correct key_id').returns(true) { result['Keys'].map { |k| k['KeyId'] }.include?(key_id) }
  end

  tests('#sign') do
    sign_response = Fog::AWS[:kms].sign(key_id, data, 'RSASSA_PSS_SHA_256', 'MessageType' => 'RAW').body

    tests('format').data_matches_schema(AWS::KMS::Formats::SIGN) { sign_response }

    tests('#verify').returns(true) do
      signature = Base64.decode64(sign_response['Signature'])
      pkey.verify('SHA256', signature, data, { rsa_padding_mode: 'pss' })
    end
  end

  tests('#sign RAW').returns(true) do
    sign_response = Fog::AWS[:kms].sign(key_id, data, 'RSASSA_PSS_SHA_256', 'MessageType' => 'RAW').body
    signature = Base64.decode64(sign_response['Signature'])

    pkey.verify('SHA256', signature, data, { rsa_padding_mode: 'pss' })
  end

  tests('#sign DIGEST').returns(true) do
    hash = OpenSSL::Digest.digest('SHA256', data)
    sign_response = Fog::AWS[:kms].sign(key_id, hash, 'RSASSA_PSS_SHA_256', 'MessageType' => 'DIGEST').body
    signature = Base64.decode64(sign_response['Signature'])

    pkey.verify_raw('SHA256', signature, hash, { rsa_padding_mode: 'pss' })
  end

  tests('#schedule_key_deletion').data_matches_schema(AWS::KMS::Formats::SCHEDULE_KEY_DELETION) do
    Fog::AWS[:kms].schedule_key_deletion(key_id, 7).body
  end
end
