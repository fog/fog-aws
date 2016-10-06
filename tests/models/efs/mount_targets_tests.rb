Shindo.tests("AWS::EFS | mount targets", ["aws", "efs"]) do
  if ENV['FILE_SYSTEM_ID']
    @file_system = Fog::AWS[:efs].file_systems.get(ENV["FILE_SYSTEM_ID"])
  else
    @file_system = Fog::AWS[:efs].file_systems.create(:creation_token => "fogtoken#{rand(999).to_s}")
  end

  @file_system.wait_for { ready? }

  mount_target_params = {
    :file_system_id => @file_system.identity,
    :subnet_id      => Fog::Compute[:aws].vpcs.first.subnets.first.identity
  }

  collection_tests(Fog::AWS[:efs].mount_targets(:file_system_id => @file_system.identity), mount_target_params, true)

  unless ENV["LEAVE_FILE_SYSTEM"] = 'true'
    @file_system.destroy
  end
end
