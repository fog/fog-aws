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
