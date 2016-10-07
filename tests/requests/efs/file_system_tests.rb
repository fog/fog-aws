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

    file_system_id = Fog::AWS[:efs].describe_file_systems(:creation_token => @creation_token).body["FileSystems"].first["FileSystemId"]
    file_system = Fog::AWS[:efs].file_systems.get(file_system_id)

    tests("#describe_file_systems(id: #{file_system_id})").formats(AWS::EFS::Formats::DESCRIBE_FILE_SYSTEMS_RESULT) do
      Fog::AWS[:efs].describe_file_systems(:id => file_system_id).body
    end

    if Fog.mocking?
      vpc = Fog::Compute[:aws].vpcs.create(:cidr_block => "10.0.0.0/16")
      Fog::Compute[:aws].subnets.create(
        :vpc_id     => vpc.id,
        :cidr_block => "10.0.1.0/24"
      )
    else
      vpc = Fog::Compute[:aws].vpcs.first
    end

    security_group = Fog::Compute[:aws].security_groups.create(
      :vpc_id      => vpc.id,
      :name        => "fog#{suffix}",
      :description => "fog#{suffix}"
    )

    subnet_id = vpc.subnets.first.identity

    raises(Fog::AWS::EFS::InvalidSubnet, "invalid subnet ID: foobar#{suffix}") do
      Fog::AWS[:efs].create_mount_target(:file_system_id => file_system_id, :subnet_id => "foobar#{suffix}")
    end

    raises(Fog::AWS::EFS::NotFound, "invalid file system ID: foobar#{suffix}") do
      Fog::AWS[:efs].create_mount_target(:file_system_id => "foobar#{suffix}", :subnet_id => subnet_id)
    end

    if Fog.mocking?
      tests("#create_mount_target") do
        Fog::AWS[:efs].data[:file_systems][file_system_id]["LifeCycleState"] = 'creating'
        raises(Fog::AWS::EFS::IncorrectFileSystemLifeCycleState) do
          Fog::AWS[:efs].create_mount_target(:file_system_id => file_system_id, :subnet_id => subnet_id)
        end

        Fog::AWS[:efs].data[:file_systems][file_system_id]["LifeCycleState"] = 'available'
      end
    end

    raises(Fog::AWS::EFS::NotFound, "invalid security group ID: foobar#{suffix}") do
      Fog::AWS[:efs].create_mount_target(
        :file_system_id  => file_system_id,
        :subnet_id       => subnet_id,
        'SecurityGroups' => ["foobar#{suffix}"]
      )
    end

    tests("#create_mount_target(file_system_id: #{file_system_id}, subnet_id: #{subnet_id})").formats(AWS::EFS::Formats::MOUNT_TARGET_FORMAT) do
      Fog::AWS[:efs].create_mount_target(
        :file_system_id  => file_system_id,
        :subnet_id       => subnet_id,
        'SecurityGroups' => [security_group.group_id]
      ).body
    end

    tests("#describe_mount_targets(file_system_id: #{file_system_id})").formats(AWS::EFS::Formats::DESCRIBE_MOUNT_TARGETS_RESULT) do
      Fog::AWS[:efs].describe_mount_targets(:file_system_id => file_system_id).body
    end

    mount_target_id = Fog::AWS[:efs].describe_mount_targets(:file_system_id => file_system_id).body["MountTargets"].first["MountTargetId"]

    tests("#describe_mount_targets(id: #{mount_target_id})").formats(AWS::EFS::Formats::DESCRIBE_MOUNT_TARGETS_RESULT) do
      Fog::AWS[:efs].describe_mount_targets(:id => mount_target_id).body
    end

    raises(Fog::AWS::EFS::Error, 'file system ID or mount target ID must be specified') do
      Fog::AWS[:efs].describe_mount_targets
    end

    raises(Fog::AWS::EFS::NotFound, "invalid mount target id: foobar#{suffix}") do
      Fog::AWS[:efs].delete_mount_target(:id => "foobar#{suffix}")
    end

    tests("#delete_mount_target(id: #{mount_target_id})") do
      returns(true) do
        result = Fog::AWS[:efs].delete_mount_target(:id => mount_target_id)
        result.body.empty?
      end
    end

    file_system.wait_for { number_of_mount_targets == 0 }

    if Fog.mocking?
      Fog::AWS[:efs].data[:file_systems][file_system_id]["NumberOfMountTargets"] = 1
      raises(Fog::AWS::EFS::FileSystemInUse) do
        Fog::AWS[:efs].delete_file_system(:id => file_system_id)
      end
      Fog::AWS[:efs].data[:file_systems][file_system_id]["NumberOfMountTargets"] = 0
    end

    raises(Fog::AWS::EFS::NotFound, "invalid file system ID: foobar#{suffix}") do
      Fog::AWS[:efs].delete_file_system(:id => "foobar#{suffix}")
    end

    tests("#delete_file_system") do
      returns(true) do
        result = Fog::AWS[:efs].delete_file_system(:id => file_system_id)
        result.body.empty?
      end
    end

    security_group.destroy
  end
end
