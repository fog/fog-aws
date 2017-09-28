Shindo.tests('AWS::elbv2 | application_load_balancer_tests', ['aws', 'elbv2']) do
  @vpc            = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.0.0/16')
  @subnet1        = Fog::Compute[:aws].subnets.create('vpc_id' => @vpc.id, 'cidr_block' => '10.0.16.0/20')
  @subnet2        = Fog::Compute[:aws].subnets.create('vpc_id' => @vpc.id, 'cidr_block' => '10.0.0.0/20')
  @security_group = Fog::Compute[:aws].security_groups.create('name' => 'sg_name', 'description' => 'sg_desc', 'vpc_id' => @vpc.id)

  @vpc_id = @vpc.id

  @server1 = Fog::Compute[:aws].servers.create
  @server1.wait_for { ready? }

  @server2 = Fog::Compute[:aws].servers.create
  @server2.wait_for { ready? }

  ELBV2 = Fog::AWS[:elbv2]

  tests('#describe_account_limits').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_ACCOUNT_LIMITS) do
    ELBV2.describe_account_limits.body
  end

  tests('#describe_ssl_policies').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_SSL_POLICIES) do
    ELBV2.describe_ssl_policies.body
  end

  tests('target groups') do
    tests('create target group').data_matches_schema(AWS::ELBV2::Formats::CREATE_TARGET_GROUP) do
      ELBV2.create_target_group('test-tg-1', 3000, @vpc_id).body
    end

    tests('targets') do
      tg = ELBV2.target_groups.create(:name => 'test-tg-1', :port => 3000, :vpc_id => @vpc_id)
      tests('#register_targets') do
        ELBV2.register_targets(tg.id, [@server1.id])
      end
      tests('#deregister_targets') do
        ELBV2.deregister_targets(tg.id, [@server1.id])
      end
    end

    tests('create target group with healthcheck options').data_matches_schema(AWS::ELBV2::Formats::CREATE_TARGET_GROUP) do
      ELBV2.create_target_group('test-tg-2', 3000, @vpc_id,
        :matcher => '200-299',
        :healthy_threshold_count => 6,
        :unhealthy_threshold_count => 2,
        :health_check_interval_seconds => 15,
        :health_check_timeout_seconds => 5,
        :health_check_path => '/i_am_healthy',
        :health_check_port => '80',
        :health_check_protocol => 'HTTP'
      ).body
    end

    tests('existing target group') do
      resp = ELBV2.create_target_group('test-tg-4', 3000, @vpc_id)
      @target_group_id = resp.body['CreateTargetGroupResult']['TargetGroups'].first['TargetGroupArn']
      @instance_id = Fog::Compute[:aws].servers.create.id

      tests('#describe_target_groups').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_TARGET_GROUPS) do
        ELBV2.describe_target_groups.body
      end

      tests('#describe_target_group_attributes').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_TARGET_GROUP_ATTRIBUTES) do
        ELBV2.describe_target_group_attributes(@target_group_id).body
      end

      tests('#describe_target_health').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_TARGET_HEALTH) do
        ELBV2.register_targets(@target_group_id, @instance_id)
        ELBV2.describe_target_health(@target_group_id).body
      end

      tests('#modify_target_group') do
      end

      tests('#modify_target_group_attributes') do
      end

      tests('#delete_target_group') do
      end
    end
  end

  tests('load balancers') do

    tests('create load balancer').data_matches_schema(AWS::ELBV2::Formats::CREATE_LOAD_BALANCER) do
      ELBV2.create_load_balancer("my-test-#{SecureRandom.urlsafe_base64[0..5]}",
        :subnet_ids => [@subnet1.subnet_id, @subnet2.subnet_id],
        :security_group_ids => [@security_group.group_id],
        :tags => { 'hello' => 'world' }
      ).body
    end

    tests('existing load balancer') do
      resp = ELBV2.create_load_balancer("my-test-#{SecureRandom.urlsafe_base64[0..5]}",
        :subnet_ids => [@subnet1.subnet_id, @subnet2.subnet_id],
        :security_group_ids => [@security_group.group_id],
        :tags => { 'hello' => 'world' }
      )
      tg = ELBV2.target_groups.create(:name => 'test-tg-1', :port => 3000, :vpc_id => @vpc_id)
      @tg_id = tg.id
      @load_balancer_id = resp.body['CreateLoadBalancerResult']['LoadBalancers'].first['LoadBalancerArn']

      tests('#describe_load_balancers').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_LOAD_BALANCERS) do
        ELBV2.describe_load_balancers.body
      end

      tests('listeners') do
        resp = ELBV2.create_listener(@load_balancer_id, 3000, [{'Type' => 'forward', 'TargetGroupArn' => @tg_id}])
        @listener_id = resp.body['CreateListenerResult']['Listeners'].first['ListenerArn']
        tests('#create_listener') do
        end

        tests('#modify_listener') do
        end

        tests('#describe_rules') do
        end

        tests('#create_rule') do
        end

        tests('#modify_rule') do
        end

        tests('#delete_rule') do
        end

        tests('#describe_listeners').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_LISTENERS) do
          ELBV2.describe_listeners(@load_balancer_id).body
        end

        tests('#describe_listeners').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_LISTENERS) do
          ELBV2.describe_listeners(@load_balancer_id, [@listener_id]).body
        end

        tests('#modify_listener') do
        end

        tests('#delete_listener') do
        end
      end

      tests('#describe_load_balancer_attributes').data_matches_schema(AWS::ELBV2::Formats::DESCRIBE_LOAD_BALANCER_ATTRIBUTES) do
        ELBV2.describe_load_balancer_attributes(@load_balancer_id).body
      end

      tests("modify_load_balancer_attributes") do
        attributes = {
          "deletion_protection.enabled" => false,
          "access_logs.s3.bucket" => nil,
          "access_logs.s3.prefix" => nil,
          "idle_timeout.timeout_seconds" => 60,
          "access_logs.s3.enabled" => false
        }
        ELBV2.modify_load_balancer_attributes(@load_balancer_id, attributes).body
      end

      tests('#set_ip_address_type') do
      end

      tests('#set_security_groups') do
      end

      tests('#set_subnets') do
      end
    end
  end

  [@vpc, @subnet1, @subnet2, @security_group, @server1, @server2].map(&:destroy)
end
