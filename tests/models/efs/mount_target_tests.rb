Shindo.tests("AWS::EFS | mount target", ["aws", "efs"]) do
  if ENV['FILE_SYSTEM_ID']
    @file_system = Fog::AWS[:efs].file_systems.get(ENV["FILE_SYSTEM_ID"])
  else
    @file_system = Fog::AWS[:efs].file_systems.create(:creation_token => "fogtoken#{rand(999).to_s}")
  end

  @file_system.wait_for { ready? }

  if Fog.mocking?
    vpc = Fog::Compute[:aws].vpcs.create(cidr_block: "10.0.0.0/16")
    Fog::Compute[:aws].subnets.create(vpc_id: vpc.id, cidr_block: "10.0.1.0/24")
  end

  mount_target_params = {
    :file_system_id => @file_system.identity,
    :subnet_id      => Fog::Compute[:aws].vpcs.first.subnets.first.identity
  }

  model_tests(Fog::AWS[:efs].mount_targets, mount_target_params, true)

  unless ENV["LEAVE_FILE_SYSTEM"] = 'true'
    @file_system.destroy
  end
end
