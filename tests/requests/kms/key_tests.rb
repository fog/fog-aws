KEY_SPECS = %w[RSA_2048 RSA_3072 RSA_4096 ECC_NIST_P256 ECC_NIST_P384 ECC_NIST_P521 ECC_SECG_P256K1].freeze
SIGNING_ALGORITHMS = %w[RSASSA_PSS_SHA_256 RSASSA_PSS_SHA_384 RSASSA_PSS_SHA_512 RSASSA_PKCS1_V1_5_SHA_256 RSASSA_PKCS1_V1_5_SHA_384 RSASSA_PKCS1_V1_5_SHA_512 ECDSA_SHA_256 ECDSA_SHA_384 ECDSA_SHA_512]

Shindo.tests('AWS::KMS | key requests', %w[aws kms]) do
  key_id = nil
  key_arn = nil
  pkey = nil
  data = 'sign me'

  tests('#create_key').data_matches_schema(AWS::KMS::Formats::DESCRIBE_KEY) do
    result = Fog::AWS[:kms].create_key(
      'KeySpec' => 'RSA_2048',
      'KeyUsage' => 'SIGN_VERIFY'
    ).body
    key_id = result['KeyMetadata']['KeyId']
    key_arn = result['KeyMetadata']['Arn']

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

    tests('result contains correct key_id (arn)').returns(key_arn) { result['KeyId'] }
  end

  tests('#list_keys') do
    result = Fog::AWS[:kms].list_keys.body

    tests('format').data_matches_schema(AWS::KMS::Formats::LIST_KEYS) { result }

    tests('result contains correct key_id').returns(true) { result['Keys'].map { |k| k['KeyId'] }.include?(key_id) }
  end

  tests('#sign') do
    sign_response = Fog::AWS[:kms].sign(key_id, data, 'RSASSA_PKCS1_V1_5_SHA_256', 'MessageType' => 'RAW').body

    tests('format').data_matches_schema(AWS::KMS::Formats::SIGN) { sign_response }

    tests('#verify').returns(true) do
      signature = Base64.decode64(sign_response['Signature'])
      pkey.verify('SHA256', signature, data)
    end
  end

  tests('#schedule_key_deletion').data_matches_schema(AWS::KMS::Formats::SCHEDULE_KEY_DELETION) do
    Fog::AWS[:kms].schedule_key_deletion(key_id, 7).body
  end

  tests('mock sign') do
    pending unless Fog.mock?

    KEY_SPECS.each do |key_spec|
      SIGNING_ALGORITHMS.select { |sa| sa.start_with?(key_spec[0...2]) }.each do |signing_algorithm|
        key_id = Fog::AWS[:kms].create_key(
          'KeySpec' => key_spec,
          'KeyUsage' => 'SIGN_VERIFY'
        ).body['KeyMetadata']['KeyId']

        result = Fog::AWS[:kms].get_public_key(key_id).body
        public_key = Base64.decode64(result['PublicKey'])
        pkey = if key_spec.start_with?('RSA')
                 OpenSSL::PKey::RSA.new(public_key)
               elsif key_spec.start_with?('EC')
                 OpenSSL::PKey::EC.new(public_key)
               end
        sha = "SHA#{signing_algorithm.split('_SHA_').last}"
        sign_opts = if signing_algorithm.include?('_PSS_')
                      { rsa_padding_mode: 'pss' }
                    else
                      {}
                    end

        tests("#sign #{key_spec} #{signing_algorithm} DIGEST").returns(true) do
          hash = OpenSSL::Digest.digest(sha, data)
          sign_response = Fog::AWS[:kms].sign(key_id, hash, signing_algorithm, 'MessageType' => 'DIGEST').body
          signature = Base64.decode64(sign_response['Signature'])

          pkey.verify_raw(sha, signature, hash, sign_opts)
        end

        tests("#sign #{key_spec} #{signing_algorithm} RAW").returns(true) do
          sign_response = Fog::AWS[:kms].sign(key_id, data, signing_algorithm, 'MessageType' => 'RAW').body
          signature = Base64.decode64(sign_response['Signature'])

          pkey.verify(sha, signature, data, sign_opts)
        end

        Fog::AWS[:kms].schedule_key_deletion(key_id, 7)
      end
    end
  end
end
