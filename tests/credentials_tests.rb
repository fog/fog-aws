# frozen_string_literal: true

Shindo.tests('AWS | credentials', ['aws']) do
  unchecked_constants = [:CredentialFetcher, :VERSION, :Errors, :Mock, :ServiceMapper, :Federation, :STS, :SignatureV4, :EFS]

  test_services = Fog::AWS.constants.delete_if { |service| unchecked_constants.include?(service) }

  target_services = test_services.each_with_object([]) do |name, services|
    services << Class.const_get("Fog::AWS::#{name}")
  end
  require_credential_parameters = [:aws_access_key_id, :aws_secret_access_key]
  recognized_credential_parameters = [:aws_session_token, :aws_credentials_expire_at, :region, :sts_endpoint]

  # ex: target_services = [Fog::AWS::Compute, Fog:AWS::DNS...]
  target_services.each do |service|
    require_credential_parameters.each do |parameter|
      tests("required credentials parameter #{parameter} is included @requirements of #{service}") do
        returns(true) { service.instance_variable_get("@requirements").include?(parameter) }
      end
    end

    recognized_credential_parameters.each do |parameter|
      tests("recognized credentials parameter #{parameter} is included @recognized of #{service}") do
        returns(true) { service.instance_variable_get("@recognized").include?(parameter) }
      end
    end
  end

  old_mock_value = Excon.defaults[:mock]
  fog_was_mocked = Fog.mocking?
  Excon.stubs.clear
  Fog.unmock!
  begin
    Excon.defaults[:mock] = true
    Excon.stub({ method: :put, path: '/latest/api/token' }, { status: 200, body: 'token1234' })

    Excon.stub({ method: :get, path: '/latest/meta-data/iam/security-credentials/' }, { status: 200, body: 'arole' })
    Excon.stub({ method: :get, path: '/latest/meta-data/placement/availability-zone/' }, { status: 200, body: 'us-west-1a' })

    expires_at = Time.at(Time.now.to_i + 500)
    credentials = {
      'AccessKeyId' => 'dummykey',
      'SecretAccessKey' => 'dummysecret',
      'Token' => 'dummytoken',
      'Expiration' => expires_at.xmlschema
    }

    Excon.stub({ method: :get, path: '/latest/meta-data/iam/security-credentials/arole' }, { status: 200, body: Fog::JSON.encode(credentials) })

    tests('#fetch_credentials') do
      returns(aws_access_key_id: 'dummykey',
              aws_secret_access_key: 'dummysecret',
              aws_session_token: 'dummytoken',
              region: 'us-west-1',
              aws_credentials_expire_at: expires_at) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true) }
    end

    tests('#fetch_credentials when the v2 token 404s') do
      Excon.stub({ method: :put, path: '/latest/api/token' }, { status: 404, body: 'not found' })
      returns(aws_access_key_id: 'dummykey',
              aws_secret_access_key: 'dummysecret',
              aws_session_token: 'dummytoken',
              region: 'us-west-1',
              aws_credentials_expire_at: expires_at) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true) }
    end

    tests('#fetch_credentials when the v2 disabled') do
      returns(aws_access_key_id: 'dummykey',
              aws_secret_access_key: 'dummysecret',
              aws_session_token: 'dummytoken',
              region: 'us-west-1',
              aws_credentials_expire_at: expires_at) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true, disable_imds_v2: true) }
    end

    ENV['AWS_CONTAINER_CREDENTIALS_RELATIVE_URI'] = '/v1/credentials?id=task_id'
    Excon.stub({ method: :get, path: '/v1/credentials?id=task_id' }, { status: 200, body: Fog::JSON.encode(credentials) })

    tests('#fetch_credentials') do
      returns(aws_access_key_id: 'dummykey',
              aws_secret_access_key: 'dummysecret',
              aws_session_token: 'dummytoken',
              region: 'us-west-1',
              aws_credentials_expire_at: expires_at) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true) }
    end

    ENV['AWS_CONTAINER_CREDENTIALS_RELATIVE_URI'] = nil

    ENV['AWS_WEB_IDENTITY_TOKEN_FILE'] = File.dirname(__FILE__) + '/lorem.txt'
    ENV['AWS_ROLE_ARN'] = "dummyrole"
    ENV['AWS_ROLE_SESSION_NAME'] = "dummyrolesessionname"
    document = 
      '<AssumeRoleWithWebIdentityResponse xmlns="https://sts.amazonaws.com/doc/2011-06-15/">'\
        '<AssumeRoleWithWebIdentityResult>'\
          '<Credentials>'\
            '<SessionToken>dummytoken</SessionToken>'\
            '<SecretAccessKey>dummysecret</SecretAccessKey>'\
            "<Expiration>#{expires_at.xmlschema}</Expiration>"\
            '<AccessKeyId>dummykey</AccessKeyId>'\
          '</Credentials>'\
        '</AssumeRoleWithWebIdentityResult>'\
      '</AssumeRoleWithWebIdentityResponse>'
    
    Excon.stub({method: :get, path: "/", idempotent: true}, { status: 200, body: document})

    tests('#fetch_credentials token based') do
      returns(
        aws_access_key_id: 'dummykey',
        aws_secret_access_key: 'dummysecret',
        aws_session_token: 'dummytoken',
        region: 'us-west-1',
        sts_endpoint: "https://sts.amazonaws.com",
        aws_credentials_expire_at: expires_at
      ) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true) }
    end

    ENV['AWS_ROLE_SESSION_NAME'] = nil

    tests('#fetch_credentials token based without session name') do
      returns(
        aws_access_key_id: 'dummykey',
        aws_secret_access_key: 'dummysecret',
        aws_session_token: 'dummytoken',
        region: 'us-west-1',
        sts_endpoint: "https://sts.amazonaws.com",
        aws_credentials_expire_at: expires_at
      ) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true, region: 'us-west-1') }
    end

    ENV["AWS_STS_REGIONAL_ENDPOINTS"] = "regional"

    tests('#fetch_credentials with no region specified') do
      returns(
        aws_access_key_id: 'dummykey',
        aws_secret_access_key: 'dummysecret',
        aws_session_token: 'dummytoken',
        region: 'us-west-1',
        sts_endpoint: "https://sts.amazonaws.com",
        aws_credentials_expire_at: expires_at
      ) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true) }
    end

    tests('#fetch_credentials with regional STS endpoint') do
      returns(
        aws_access_key_id: 'dummykey',
        aws_secret_access_key: 'dummysecret',
        aws_session_token: 'dummytoken',
        region: 'us-west-1',
        sts_endpoint: "https://sts.us-west-1.amazonaws.com",
        aws_credentials_expire_at: expires_at
      ) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true, region: 'us-west-1') }
    end

    ENV["AWS_DEFAULT_REGION"] = "us-west-1"

    tests('#fetch_credentials with regional STS endpoint with region in env') do
      returns(
        aws_access_key_id: 'dummykey',
        aws_secret_access_key: 'dummysecret',
        aws_session_token: 'dummytoken',
        region: 'us-west-1',
        sts_endpoint: "https://sts.us-west-1.amazonaws.com",
        aws_credentials_expire_at: expires_at
      ) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true) }
    end

    ENV["AWS_STS_REGIONAL_ENDPOINTS"] = nil
    ENV["AWS_DEFAULT_REGION"] = nil
    ENV['AWS_WEB_IDENTITY_TOKEN_FILE'] = nil

    storage = Fog::Storage.new(
      :provider => 'AWS',
      :region => 'us-east-1',
      :use_iam_profile => true,
      :aws_credentials_refresh_threshold_seconds => 30)

    tests('#credentials_refresh_threshold') do
      returns(30) { storage.send(:credentials_refresh_threshold) }
    end

    Fog::Time.now = storage.instance_variable_get(:@aws_credentials_expire_at) - 31
    tests('#refresh_credentials_if_expired before credentials have expired and before refresh threshold') do
      returns(nil) { storage.refresh_credentials_if_expired }
      returns('dummykey') { storage.instance_variable_get(:@aws_access_key_id) }
      returns('dummysecret') { storage.instance_variable_get(:@aws_secret_access_key) }
      returns(expires_at) { storage.instance_variable_get(:@aws_credentials_expire_at) }
    end
    Fog::Time.now = Time.now

    credentials['AccessKeyId'] = 'newkey-1'
    credentials['SecretAccessKey'] = 'newsecret-1'
    credentials['Expiration'] = (expires_at + 10).xmlschema

    Excon.stub({ method: :get, path: '/latest/meta-data/iam/security-credentials/arole' }, { status: 200, body: Fog::JSON.encode(credentials) })

    Fog::Time.now = storage.instance_variable_get(:@aws_credentials_expire_at) - 29
    tests('#refresh_credentials_if_expired after refresh threshold is crossed but before expiration') do
      returns(true) { storage.refresh_credentials_if_expired }
      returns('newkey-1') { storage.instance_variable_get(:@aws_access_key_id) }
      returns('newsecret-1') { storage.instance_variable_get(:@aws_secret_access_key) }
      returns(expires_at + 10) { storage.instance_variable_get(:@aws_credentials_expire_at) }
    end
    Fog::Time.now = Time.now

    credentials['AccessKeyId'] = 'newkey-2'
    credentials['SecretAccessKey'] = 'newsecret-2'
    credentials['Expiration'] = (expires_at + 20).xmlschema

    Excon.stub({ method: :get, path: '/latest/meta-data/iam/security-credentials/arole' }, { status: 200, body: Fog::JSON.encode(credentials) })

    Fog::Time.now = storage.instance_variable_get(:@aws_credentials_expire_at) + 1
    tests('#refresh_credentials_if_expired after credentials have expired') do
      returns(true) { storage.refresh_credentials_if_expired }
      returns('newkey-2') { storage.instance_variable_get(:@aws_access_key_id) }
      returns('newsecret-2') { storage.instance_variable_get(:@aws_secret_access_key) }
      returns(expires_at + 20) { storage.instance_variable_get(:@aws_credentials_expire_at) }
    end
    Fog::Time.now = Time.now

    compute = Fog::AWS::Compute.new(use_iam_profile: true)

    tests('#credentials_refresh_threshold when "aws_credentials_refresh_threshold_seconds" is unspecified') do
      returns(15) { compute.send(:credentials_refresh_threshold) }
    end

    default_credentials = Fog::AWS::Compute.fetch_credentials({})
    tests('#fetch_credentials when the url 404s') do
      Excon.stub({ method: :put, path: '/latest/api/token' }, { status: 404, body: 'not found' })
      Excon.stub({ method: :get, path: '/latest/meta-data/iam/security-credentials/' }, { status: 404, body: 'not bound' })
      Excon.stub({ method: :get, path: '/latest/meta-data/placement/availability-zone/' }, { status: 400, body: 'not found' })
      returns(default_credentials) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true) }
    end

    mocked_credentials = {
      aws_access_key_id: 'access-key-id',
      aws_secret_access_key: 'secret-access-key',
      aws_session_token: 'session-token',
      aws_credentials_expire_at: Time.at(Time.now.to_i + 500).xmlschema
    }
    tests('#fetch_credentials when mocking') do
      Fog.mock!
      Fog::AWS::Compute::Mock.data[:iam_role_based_creds] = mocked_credentials
      returns(mocked_credentials) { Fog::AWS::Compute.fetch_credentials(use_iam_profile: true) }
    end
  ensure
    ENV['AWS_CONTAINER_CREDENTIALS_RELATIVE_URI'] = nil
    ENV['AWS_WEB_IDENTITY_TOKEN_FILE'] = nil
    Excon.stubs.clear
    Excon.defaults[:mock] = old_mock_value
    Fog.mock! if fog_was_mocked
  end
end
