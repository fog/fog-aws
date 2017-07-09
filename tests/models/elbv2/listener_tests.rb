Shindo.tests('AWS::elbv2 | listener', ['aws', 'elbv2', 'models']) do
  Fog::Compute::AWS::Mock.reset if Fog.mocking?


  @az = "us-east-1a"
  @vpc = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.0.0/16')
  @subnet1 = Fog::Compute[:aws].subnets.create('vpc_id' => @vpc.id, 'cidr_block' => '10.0.16.0/20', "availability_zone" => @az)
  @subnet2 = Fog::Compute[:aws].subnets.create('vpc_id' => @vpc.id, 'cidr_block' => '10.0.0.0/20', "availability_zone" => @az)
  @security_group = Fog::Compute[:aws].security_groups.create('name' => 'sg_name', 'description' => 'sg_desc', 'vpc_id' => @vpc.id)

  ELBV2 = Fog::AWS[:elbv2]

  @server1 = Fog::Compute[:aws].servers.create
  @server1.wait_for { ready? }

  @server2 = Fog::Compute[:aws].servers.create
  @server2.wait_for { ready? }

  tests('success') do
    @lb = ELBV2.load_balancers.create(
      :name => "lb-test-2",
      :subnet_ids => [@subnet1.subnet_id, @subnet2.subnet_id],
      :security_group_ids => [@security_group.group_id],
      :tags_set => {'tag1' => 'value1'}
    )
    @tg1 = ELBV2.target_groups.create(:name => "test-tg-1")
    @tg2 = ELBV2.target_groups.create(:name => "test-tg-2")
    @listener = @lb.create_listener(3000, @tg1.id)

    tests('empty rules').returns(0) { @listener.rules.size }

    tests('create path rule') do
      @listener.add_path_rule('/test1', @server1.id)
      @listener.add_path_rule('/test2', @server2.id)
      tests('rule path 1').returns(['/test1']) { @listener.rules.first.paths }
      tests('rule path 2').returns(['/test2']) { @listener.rules[1].paths }
    end

    tests('destroy rules') do
      @listener.rules.map(&:destroy)
      tests('empty').returns(0) { @listener.rules.size }
    end

    tests('create host rule') do
      @listener.add_host_rule('test1.example.com', @server1.id)
      @listener.add_host_rule('test2.example.com', @server2.id)
      tests('rule host 1').returns(['test1.example.com']) { @listener.rules.first.hosts }
      tests('rule host 2').returns(['test2.example.com']) { @listener.rules[1].hosts }
    end

    tests('#update') do
      @listener.update(:target_group_ids => [@tg2.id])
      tests('default actions').returns([{'Type' => 'forward', 'TargetGroupArn' => @tg2.id}]) do
        @listener.reload.default_actions
      end
    end

    @listener.rules.map(&:destroy)
    [@listener, @tg1, @tg2, @lb].map(&:destroy)
  end

  [@vpc, @subnet1, @subnet2, @server1, @server2, @security_group].map(&:destroy)
end
