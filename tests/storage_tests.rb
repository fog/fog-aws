# encoding: utf-8

Shindo.tests('AWS Storage | escape', ['aws']) do
  tests('Keys can contain a hierarchical prefix which should not be escaped') do
    returns(Fog::AWS::Storage.new.send(:escape, 'key/with/prefix')) { 'key/with/prefix' }
  end
end

Shindo.tests('AWS Storage | Host header', ['aws']) do
  def capture_host_header(storage)
    captured_host = nil
    storage.define_singleton_method(:_request) do |scheme, host, port, params, original_params, &block|
      captured_host = params[:headers]['Host']
      response = Excon::Response.new
      response.status = 200
      response
    end
    storage.put_object('testbucket', 'testkey', 'testbody')
    captured_host
  end

  tests('includes port in Host header for non-standard port') do
    storage = Fog::AWS::Storage::Real.new(
      :aws_access_key_id    => 'test_key',
      :aws_secret_access_key => 'test_secret',
      :host                 => 'storage.example.com',
      :port                 => 9000,
      :scheme               => 'http',
      :path_style           => true
    )
    returns('storage.example.com:9000') { capture_host_header(storage) }
  end

  tests('omits port in Host header for standard HTTP port') do
    storage = Fog::AWS::Storage::Real.new(
      :aws_access_key_id    => 'test_key',
      :aws_secret_access_key => 'test_secret',
      :host                 => 'storage.example.com',
      :port                 => 80,
      :scheme               => 'http',
      :path_style           => true
    )
    returns('storage.example.com') { capture_host_header(storage) }
  end

  tests('omits port in Host header for standard HTTPS port') do
    storage = Fog::AWS::Storage::Real.new(
      :aws_access_key_id    => 'test_key',
      :aws_secret_access_key => 'test_secret',
      :host                 => 'storage.example.com',
      :port                 => 443,
      :scheme               => 'https',
      :path_style           => true
    )
    returns('storage.example.com') { capture_host_header(storage) }
  end
end

Shindo.tests('AWS Storage | Content-MD5 header', ['aws']) do
  def capture_put_object_params(storage, data, options = {})
    captured_params = nil
    storage.define_singleton_method(:_request) do |scheme, host, port, params, original_params, &block|
      captured_params = params
      response = Excon::Response.new
      response.status = 200
      response
    end
    storage.put_object('testbucket', 'testkey', data, options)
    captured_params
  end

  def real_storage(extra_options = {})
    Fog::AWS::Storage::Real.new({
      :aws_access_key_id     => 'test_key',
      :aws_secret_access_key => 'test_secret'
    }.merge(extra_options))
  end

  tests('omits Content-MD5 by default') do
    params = capture_put_object_params(real_storage, 'testbody')
    returns(nil) { params[:headers]['Content-MD5'] }
  end

  tests('adds Content-MD5 for String body when enable_put_object_content_md5 is true') do
    body = 'testbody'
    expected_md5 = Base64.strict_encode64(OpenSSL::Digest::MD5.digest(body))
    params = capture_put_object_params(real_storage(:enable_put_object_content_md5 => true), body)
    returns(expected_md5) { params[:headers]['Content-MD5'] }
    returns(true) { params[:headers]['Authorization'].include?('content-md5') }
  end

  tests('adds Content-MD5 for empty String body when enable_put_object_content_md5 is true') do
    expected_md5 = Base64.strict_encode64(OpenSSL::Digest::MD5.digest(''))
    params = capture_put_object_params(real_storage(:enable_put_object_content_md5 => true), '')
    returns(expected_md5) { params[:headers]['Content-MD5'] }
  end

  tests('adds Content-MD5 for seekable IO body and preserves position') do
    io = StringIO.new('prefix:payload')
    io.pos = 7
    expected_md5 = Base64.strict_encode64(OpenSSL::Digest::MD5.digest('payload'))
    params = capture_put_object_params(real_storage(:enable_put_object_content_md5 => true), io)
    returns(expected_md5) { params[:headers]['Content-MD5'] }
    returns(7) { io.pos }
    returns('payload') { io.read }
  end

  tests('omits Content-MD5 for non-seekable IO without consuming it') do
    stream = Object.new
    consumed = false
    stream.define_singleton_method(:read) do |*_args|
      consumed = true
      'streamed'
    end
    params = capture_put_object_params(real_storage(:enable_put_object_content_md5 => true), stream)
    returns(nil) { params[:headers]['Content-MD5'] }
    returns(false) { consumed }
  end

  tests('preserves caller-supplied Content-MD5 header regardless of case') do
    params = capture_put_object_params(
      real_storage(:enable_put_object_content_md5 => true),
      'testbody',
      { 'content-md5' => 'custom-md5' }
    )
    returns('custom-md5') { params[:headers]['content-md5'] }
    returns(nil) { params[:headers]['Content-MD5'] }
  end

  tests('omits Content-MD5 when disable_content_md5_validation is also true') do
    params = capture_put_object_params(
      real_storage(:enable_put_object_content_md5 => true, :disable_content_md5_validation => true),
      'testbody'
    )
    returns(nil) { params[:headers]['Content-MD5'] }
  end

  tests('mock storage recognizes enable_put_object_content_md5 and stores Content-MD5') do
    pending unless Fog.mocking?
    storage = Fog::AWS::Storage.new(
      :aws_access_key_id            => 'test_key',
      :aws_secret_access_key        => 'test_secret',
      :enable_put_object_content_md5 => true
    )
    bucket_name = 'fog-md5-test-' + Time.now.to_i.to_s(32)
    storage.put_bucket(bucket_name)
    body = 'mockbody'
    expected_md5 = Base64.strict_encode64(OpenSSL::Digest::MD5.digest(body))
    storage.put_object(bucket_name, 'md5_object', body)
    response = storage.get_object(bucket_name, 'md5_object')
    returns(expected_md5) { response.headers['Content-MD5'] }
  end
end
