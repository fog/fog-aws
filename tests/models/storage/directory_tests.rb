Shindo.tests("Storage[:aws] | directory", ["aws"]) do
  tests('Fog::Storage[:aws]', "#request_params") do
    def slice(hash, *args)
      hash.select { |k, _| args.include?(k) }
    end

    instance = Fog::Storage[:aws]
    method = instance.method(:request_params)

    params = {bucket_name: 'profile-uploads', host: 'profile-uploads.s3.us-west-2.amazonaws.com'}
    tests("given #{params}, request_params[:host]").returns("profile-uploads.s3.us-west-2.amazonaws.com") do
      method.call(params)[:host]
    end

    params = {bucket_name: 'profile-uploads.johnsmith.net', cname: 'profile-uploads.johnsmith.net', virtual_host: true}
    tests("given #{params}, request_params[:host]").returns("profile-uploads.johnsmith.net") do
      method.call(params)[:host]
    end

    params = {bucket_name: 'profile-uploads.johnsmith.net', cname: 'profile-uploads.johnsmith.net', virtual_host: false}
    tests("given #{params}, request_params[:host], request_params[:path]").
      returns({host: "s3.amazonaws.com", path: "/profile-uploads.johnsmith.net/"}) do
      slice(method.call(params), :host, :path)
    end

    params = {bucket_name: 'profile-uploads.johnsmith.net', bucket_cname: 'profile-uploads.johnsmith.net'}
    tests("given #{params}, request_params[:host]").returns("profile-uploads.johnsmith.net") do
      method.call(params)[:host]
    end

    params = {bucket_name: 'profile-uploads'}
    tests("given #{params}, request_params[:path], request_params[:host]").
      returns({path: "/", host: "profile-uploads.s3.amazonaws.com"}) do
        slice(method.call(params), :path, :host)
      end

    params = {bucket_name: 'profile-uploads', path_style: true}
    tests("given #{params}, request_params[:path], request_params[:host]").
      returns({path: "/profile-uploads/", host: "s3.amazonaws.com"}) do
        slice(method.call(params), :path, :host)
      end

    params = {bucket_name: 'profile-uploads', path_style: false}
    tests("given #{params}, request_params[:path], request_params[:host]").
      returns({path: "/", host: "profile-uploads.s3.amazonaws.com"}) do
        slice(method.call(params), :path, :host)
      end

    params = {scheme: 'https', bucket_name: 'profile.uploads', path_style: false}
    tests("given #{params}, request_params[:path], request_params[:host]").
      returns(path: "/profile.uploads/", host: "s3.amazonaws.com") do
        slice(method.call(params), :path, :host)
      end

    params = {:headers=>{:"Content-Type"=>"application/json"}}
    tests("given #{params}, request_params[:headers]").returns({:"Content-Type"=>"application/json"}) do
      method.call(params)[:headers]
    end

    params = {headers: {}}
    tests("given #{params}, request_params[:headers]").returns({}) do
      method.call(params)[:headers]
    end

    params = {scheme: 'http'}
    tests("given #{params}, request_params[:scheme]").returns('http') do
      method.call(params)[:scheme]
    end

    params = {}
    tests("given #{params}, request_params[:scheme]").returns('https') do
      method.call(params)[:scheme]
    end

    params = {scheme: 'http', port: 8080}
    tests("given #{params} (default scheme), request_params[:port]").returns(8080) do
      method.call(params)[:port]
    end

    params = {scheme: 'https', port: 443}
    tests("given #{params}, request_params[:port]").returns(nil) do
      method.call(params)[:port]
    end

    params = {}
    tests("given #{params}, request_params[:host]").returns("s3.amazonaws.com") do
      method.call(params)[:host]
    end

    params = {region: 'us-east-1'}
    tests("given #{params}, request_params[:host]").returns("s3.amazonaws.com") do
      method.call(params)[:host]
    end

    params = {region: 'us-west-2'}
    tests("given #{params}, request_params[:host]").returns("s3.us-west-2.amazonaws.com") do
      method.call(params)[:host]
    end

    params= {region: 'us-east-1', host: 's3.us-west-2.amazonaws.com'}
    tests("given #{params}, request_params[:host]").returns("s3.us-west-2.amazonaws.com") do
      method.call(params)[:host]
    end

    params = {object_name: 'image.png'}
    tests("given #{params}, request_params[:host]").returns("/image.png") do
      method.call(params)[:path]
    end

    params = {object_name: 'image.png', path: '/images/image.png'}
    tests("given #{params}, request_params[:host]").returns("/images/image.png") do
      method.call(params)[:path]
    end
  end

  directory_attributes = {
    :key => uniq_id('fogdirectorytests')
  }

  model_tests(Fog::Storage[:aws].directories, directory_attributes, Fog.mocking?) do
    tests("#public_url").returns(nil) do
      @instance.public_url
    end

    tests('#location').returns('us-east-1') do # == Fog::AWS::Storage::DEFAULT_REGION
      @instance.location
    end

    @instance.acl = 'public-read'
    @instance.save

    tests("#public_url").returns(true) do
      if @instance.public_url =~ %r[\Ahttps://fogdirectorytests-[\da-f]+\.s3\.amazonaws\.com/\z]
        true
      else
        @instance.public_url
      end
    end
  end

  directory_attributes = {
    :key => uniq_id('different-region'),
    :location => 'eu-west-1',
  }

  model_tests(Fog::Storage[:aws].directories, directory_attributes, Fog.mocking?) do
    tests("#location").returns('eu-west-1') do
      @instance.location
    end

    tests("#location").returns('eu-west-1') do
      Fog::Storage[:aws].directories.get(@instance.identity).location
    end
  end

  directory_attributes = {
    :key => uniq_id('fogdirectorytests')
  }

  model_tests(Fog::Storage[:aws].directories, directory_attributes, Fog.mocking?) do

    tests("#versioning=") do
      tests("#versioning=(true)").succeeds do
        @instance.versioning = true
      end

      tests("#versioning=(true) sets versioning to 'Enabled'").returns('Enabled') do
        @instance.versioning = true
        @instance.service.get_bucket_versioning(@instance.key).body['VersioningConfiguration']['Status']
      end

      tests("#versioning=(false)").succeeds do
        (@instance.versioning = false).equal? false
      end

      tests("#versioning=(false) sets versioning to 'Suspended'").returns('Suspended') do
        @instance.versioning = false
        @instance.service.get_bucket_versioning(@instance.key).body['VersioningConfiguration']['Status']
      end
    end

  end

  model_tests(Fog::Storage[:aws].directories, directory_attributes, Fog.mocking?) do

    tests("#versioning?") do
      tests("#versioning? false if not enabled").returns(false) do
        @instance.versioning?
      end

      tests("#versioning? true if enabled").returns(true) do
        @instance.service.put_bucket_versioning(@instance.key, 'Enabled')
        @instance.versioning?
      end

      tests("#versioning? false if suspended").returns(false) do
        @instance.service.put_bucket_versioning(@instance.key, 'Suspended')
        @instance.versioning?
      end
    end
  end
end
