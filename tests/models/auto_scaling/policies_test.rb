Shindo.tests('AWS::AutoScaling | policies', ['aws', 'auto_scaling_m', 'models']) do
  params = {
    auto_scaling_group_name: 'test',
    id: 'test_policy',
    type: 'SimpleScaling',
    scaling_adjustment: 1
  }

  lc_params = {
    :id => 'lc',
    :image_id => 'image-id',
    :instance_type => 'instance-type',
  }

  group_params = {
    :id => 'test',
    :availability_zones => [],
    :launch_configuration_name => 'lc'
  }

  Fog::AWS[:auto_scaling].configurations.new(lc_params).save

  Fog::AWS[:auto_scaling].groups.new(group_params).save

  collection_tests(Fog::AWS[:auto_scaling].policies, params, true)
end
