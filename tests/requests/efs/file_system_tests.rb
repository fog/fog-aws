Shindo.tests('AWS::EFS | file systems', ['aws', 'efs']) do
  suffix = rand(65535).to_s(16)

  @creation_token = "fogtest#{suffix}"

  tests('success') do
    tests("#create_file_system").formats(AWS::EFS::Formats::FILE_SYSTEM_FORMAT) do
      result = Fog::AWS[:efs].create_file_system(:creation_token => @creation_token).body
      returns('creating') { result['LifeCycleState'] }
      result
    end

    tests("#describe_file_systems").formats(AWS::EFS::Formats::DESCRIBE_FILE_SYSTEMS_RESULT) do
      Fog::AWS[:efs].describe_file_systems.body
    end

    tests("#describe_file_systems(creation_token: #{@creation_token})").formats(AWS::EFS::Formats::DESCRIBE_FILE_SYSTEMS_RESULT) do
      result = Fog::AWS[:efs].describe_file_systems(:creation_token => @creation_token).body
      returns(@creation_token) { result["FileSystems"].first["CreationToken"] }
      result
    end

    file_system = Fog::AWS[:efs].describe_file_systems(:creation_token => @creation_token).body["FileSystems"].first

    tests("#describe_file_systems(id: #{file_system["FileSystemId"]})").formats(AWS::EFS::Formats::DESCRIBE_FILE_SYSTEMS_RESULT) do
      Fog::AWS[:efs].describe_file_systems(:id => file_system["FileSystemId"]).body
    end

    tests("#delete_file_system") do
      returns(true) do
        result = Fog::AWS[:efs].delete_file_system(:id => file_system["FileSystemId"])
        result.body.empty?
      end
    end
  end
end
