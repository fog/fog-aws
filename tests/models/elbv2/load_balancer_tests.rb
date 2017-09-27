require 'fog/aws/elbv2/default_lb_attributes'

Shindo.tests('AWS::elbv2 | load_balancer', ['aws', 'elbv2', 'models']) do
  Fog::Compute::AWS::Mock.reset if Fog.mocking?

  ELBV2 = Fog::AWS[:elbv2]

  @az = "us-east-1a"
  @vpc = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.0.0/16')
  @subnet1 = Fog::Compute[:aws].subnets.create('vpc_id' => @vpc.id, 'cidr_block' => '10.0.16.0/20', "availability_zone" => @az)
  @subnet2 = Fog::Compute[:aws].subnets.create('vpc_id' => @vpc.id, 'cidr_block' => '10.0.0.0/20', "availability_zone" => @az)
  @security_group = Fog::Compute[:aws].security_groups.create('name' => 'sg_name', 'description' => 'sg_desc', 'vpc_id' => @vpc.id)

  @load_balancer1 = ELBV2.load_balancers.create(
    :name => "lb-test-1",
    :subnet_ids => [@subnet1.subnet_id, @subnet2.subnet_id],
    :security_group_ids => [@security_group.group_id]
  )

  tests('tagging') do
    tags1 = {'key1' => 'val1'}
    tags2 = {'key2' => 'val2'}

    tests "add and remove tags from an ELBv2" do
      returns({})                 { @load_balancer1.tags }
      returns(tags1)              { @load_balancer1.add_tags tags1 }
      returns(tags1.merge tags2)  { @load_balancer1.add_tags tags2 }
      returns(tags2)              { @load_balancer1.remove_tags tags1.keys  }
      returns(tags2)              { @load_balancer1.tags }
    end
  end

  @load_balancer2 = ELBV2.load_balancers.create(
    :name => "lb-test-2",
    :subnet_ids => [@subnet1.subnet_id, @subnet2.subnet_id],
    :security_group_ids => [@security_group.group_id],
    :tags_set => {'key1' => 'value1'}
  )
  tests('#ready?').returns(true) { @load_balancer2.ready? }
  tests('#provisioning?').returns(true) { @load_balancer2.provisioning? }
  tests('tags').returns({'key1' => 'value1'}) { @load_balancer2.reload.tags }

  tests('#lb_attributes') do
    tests("defaults").returns(Fog::AWS::ELBV2::Mock.default_lb_attributes) { @load_balancer2.lb_attributes }
    tests('#idle_timeout=').returns(600) do
      @load_balancer2.idle_timeout = 600
      @load_balancer2.idle_timeout
    end
    tests('#enable_deletion_protection').returns(true) do
      @load_balancer2.enable_deletion_protection
      @load_balancer2.deletion_protection_enabled?
    end
    tests('#disable_deletion_protection').returns(false) do
      @load_balancer2.disable_deletion_protection
      @load_balancer2.deletion_protection_enabled?
    end
    tests('#enable_s3_access_logs').returns(true) do
      @load_balancer2.enable_s3_access_logs("test-bucket", "test")
      tests('changed').returns(["test-bucket", "test"]) { [@load_balancer2.s3_access_logs_bucket, @load_balancer2.s3_asset_logs_prefix] }
      @load_balancer2.s3_access_logs_enabled?
    end
    tests('#disable_s3_access_logs').returns(false) do
      @load_balancer2.disable_s3_access_logs
      @load_balancer2.s3_access_logs_enabled?
    end
  end

  tests("#set_ip_address_type").returns('dualstack') do
    @load_balancer2.set_ip_address_type('dualstack')
    @load_balancer2.ip_address_type
  end

  tests("#set_security_groups").returns(['sg-456']) do
    @load_balancer2.set_security_groups(['sg-456'])
    @load_balancer2.security_group_ids
  end

  tests("#set_subnets").returns([@subnet1.subnet_id, @subnet2.subnet_id]) do
    @load_balancer2.set_subnets([@subnet1.subnet_id, @subnet2.subnet_id])
    @load_balancer2.reload.subnet_ids
  end

  [@load_balancer1, @load_balancer2, @subnet1, @subnet2, @security_group, @vpc].map(&:destroy)
end
