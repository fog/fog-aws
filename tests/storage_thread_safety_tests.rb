Shindo.tests('AWS | storage thread safety', ['aws']) do
  # Regression test for the IAM credential refresh race.
  #
  # Fog::AWS::Storage::Real#request must read the session token and the
  # signer as one consistent snapshot. Before the fix they were separate
  # instance variables, so a credential refresh landing between the two
  # reads produced a request carrying generation N's session token signed
  # by generation N+1's signer, which S3 rejects with a 403.
  #
  # Each credential generation is tagged: the access key id (which the
  # signer embeds in the Authorization "Credential=" field) and the session
  # token (sent as x-amz-security-token) both carry the same number. A
  # consistent snapshot always pairs equal numbers; a torn read does not.

  gen_lock  = Mutex.new
  generation = 0

  # Stands in for IMDS/STS: hands back a fresh generation-tagged credential
  # set on every call, with no network.
  fake_imds = Module.new do
    define_method(:fetch_credentials) do |options|
      next super(options) unless options[:use_iam_profile]

      n = gen_lock.synchronize { generation += 1 }
      {
        :aws_access_key_id         => "AKIAGEN#{n}",
        :aws_secret_access_key     => "secret#{n}",
        :aws_session_token         => "token#{n}",
        :aws_credentials_expire_at => Time.now + 3600,
        :region                    => 'us-east-1'
      }
    end
  end

  observations = Queue.new

  # Capture the signed request just before the (never made) HTTP call and
  # record the generation seen in the token vs. the signer.
  capture = Module.new do
    define_method(:_request) do |scheme, host, port, params, original_params, &block|
      token_gen  = params[:headers]['x-amz-security-token'].to_s[/token(\d+)/, 1]
      signer_gen = params[:headers]['Authorization'].to_s[/Credential=AKIAGEN(\d+)/, 1]
      observations << [token_gen, signer_gen]
      Struct.new(:status, :body, :headers).new(200, '', {})
    end
  end

  # Force the interleaving the timeslice scheduler produces on its own by
  # yielding inside the window between the two reads. request_params is a
  # real call already in that window, so only a scheduling hint is added.
  interleave = Module.new do
    define_method(:request_params) do |params|
      Thread.pass
      super(params)
    end
  end

  Fog::AWS::Storage.singleton_class.prepend(fake_imds)
  Fog::AWS::Storage::Real.prepend(capture)
  Fog::AWS::Storage::Real.prepend(interleave)

  # Instantiate Real directly: the race lives in the real connection, and
  # this test stubs _request so it never touches the network, so it runs the
  # same way whether or not FOG_MOCK is set. Seed initial (generation 0)
  # credentials so the first signer builds; a refresh then fires on every
  # request because no expiry is set.
  storage = Fog::AWS::Storage::Real.new(
    :use_iam_profile => true,
    :region => 'us-east-1',
    :aws_access_key_id => 'AKIAGEN0',
    :aws_secret_access_key => 'secret0',
    :aws_session_token => 'token0',
    # Force a refresh on every request so the reader window is maximally
    # exposed to a concurrent credential swap.
    :aws_credentials_refresh_threshold_seconds => 10**9
  )

  # The Fog::Service factory normally wires up #service; supply it here since
  # we built Real directly. refresh_credentials calls service.fetch_credentials.
  storage.define_singleton_method(:service) { Fog::AWS::Storage }

  tests('#request pairs the session token with a matching signer under concurrency') do
    threads    = 8
    per_thread = 500

    workers = threads.times.map do
      Thread.new do
        per_thread.times do
          storage.send(:request, {
                       :method => 'PUT', :expects => 200,
                       :bucket_name => 'bucket', :path => 'tmp/0.log',
                       :body => 'x'
                       })
        end
      end
    end
    workers.each(&:join)

    seen = []
    seen << observations.pop until observations.empty?

    torn = seen.count { |token_gen, signer_gen| token_gen && signer_gen && token_gen != signer_gen }
    distinct_gens = seen.map(&:last).uniq.size

    returns(threads * per_thread) { seen.size }
    # Every request forces a refresh, so many distinct generations must show
    # up; otherwise the reader window was never exercised and the torn-read
    # assertion below would be vacuous.
    returns(true, "refreshes actually interleaved (#{distinct_gens} distinct generations)") { distinct_gens > 1 }
    returns(0, "no torn (token, signer) pairs across #{seen.size} concurrent requests") { torn }
  end
end
