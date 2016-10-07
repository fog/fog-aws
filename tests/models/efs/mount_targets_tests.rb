Shindo.tests("AWS::EFS | mount targets", ["aws", "efs"]) do
  @file_system = Fog::AWS[:efs].file_systems.create(:creation_token => "fogtoken#{rand(999).to_s}")
  @file_system.wait_for { ready? }

  mount_target_params = {
    :file_system_id => @file_system.identity,
    :subnet_id      => Fog::Compute[:aws].vpcs.first.subnets.first.identity
  }

  collection_tests(Fog::AWS[:efs].mount_targets(:file_system_id => @file_system.identity), mount_target_params, true)

  @file_system.destroy
end
