Shindo.tests('AWS::AutoScaling | model_tests', ['aws', 'auto_scaling']) do

  tests('success') do
    lc = nil
    asg = nil
    lc_id = 'fog-model-lc'
    asg_id = 'fog-model-asg'

    tests('configurations') do
      tests('getting a missing configuration') do
        returns(nil) { Fog::AWS[:auto_scaling].configurations.get('fog-no-such-lc') }
      end

      tests('create configuration') do
        lc = Fog::AWS[:auto_scaling].configurations.create(:id => lc_id, :image_id => 'ami-8c1fece5', :instance_type => 't1.micro')
        #tests("dns names is set").returns(true) { lc.dns_name.is_a?(String) }
        tests("created_at is set").returns(true) { Time === lc.created_at }
        #tests("policies is empty").returns([]) { lc.policies }
      end

      tests('all configurations') do
        lc_ids = Fog::AWS[:auto_scaling].configurations.all.map{|e| e.id}
        tests("contains lc").returns(true) { lc_ids.include? lc_id }
      end

      tests('get configuration') do
        lc2 = Fog::AWS[:auto_scaling].configurations.get(lc_id)
        tests('ids match').returns(lc_id) { lc2.id }
      end

      tests('creating a duplicate configuration') do
        raises(Fog::AWS::AutoScaling::IdentifierTaken) do
          Fog::AWS[:auto_scaling].configurations.create(:id => lc_id, :image_id => 'ami-8c1fece5', :instance_type => 't1.micro')
        end
      end
    end

    tests('groups') do
      tests('getting a missing group') do
        returns(nil) { Fog::AWS[:auto_scaling].groups.get('fog-no-such-asg') }
      end

      tests('create') do
        asg = Fog::AWS[:auto_scaling].groups.create(:id => asg_id, :availability_zones => ['us-east-1d'], :launch_configuration_name => lc_id)
        #tests("dns names is set").returns(true) { asg.dns_name.is_a?(String) }
        tests("created_at is set").returns(true) { Time === asg.created_at }
        #tests("policies is empty").returns([]) { asg.policies }
      end

      tests('all') do
        asg_ids = Fog::AWS[:auto_scaling].groups.all.map{|e| e.id}
        tests("contains asg").returns(true) { asg_ids.include? asg_id }
      end

      tests('get') do
        asg2 = Fog::AWS[:auto_scaling].groups.get(asg_id)
        tests('ids match').returns(asg_id) { asg2.id }
      end

      tests('suspend processes') do
        asg.suspend_processes()
        if Fog.mocking?
          tests('processes suspended').returns([]) { asg.suspended_processes }
        end
      end

      tests('resume processes') do
        asg.resume_processes()
        tests('no processes suspended').returns([]) { asg.suspended_processes }
      end

      tests('creating a duplicate group') do
        raises(Fog::AWS::AutoScaling::IdentifierTaken) do
          Fog::AWS[:auto_scaling].groups.create(:id => asg_id, :availability_zones => ['us-east-1d'], :launch_configuration_name => lc_id)
        end
      end

      #tests('registering an invalid instance') do
      #  raises(Fog::AWS::AutoScaling::InvalidInstance) { asg.register_instances('i-00000000') }
      #end

      #tests('deregistering an invalid instance') do
      #  raises(Fog::AWS::AutoScaling::InvalidInstance) { asg.deregister_instances('i-00000000') }
      #end
    end

    #server = Fog::AWS[:compute].servers.create
    #tests('register instance') do
    #  begin
    #    elb.register_instances(server.id)
    #  rescue Fog::AWS::ELB::InvalidInstance
    #    # It may take a moment for a newly created instances to be visible to ELB requests
    #    raise if @retried_registered_instance
    #    @retried_registered_instance = true
    #    sleep 1
    #    retry
    #  end
    #
    #  returns([server.id]) { elb.instances }
    #end

    #tests('instance_health') do
    #  returns('OutOfService') do
    #    elb.instance_health.detect{|hash| hash['InstanceId'] == server.id}['State']
    #  end
    #
    #  returns([server.id]) { elb.instances_out_of_service }
    #end

    #tests('deregister instance') do
    #  elb.deregister_instances(server.id)
    #  returns([]) { elb.instances }
    #end
    #server.destroy

    #tests('disable_availability_zones') do
    #  elb.disable_availability_zones(%w{us-east-1c us-east-1d})
    #  returns(%w{us-east-1a us-east-1b}) { elb.availability_zones.sort }
    #end

    #tests('enable_availability_zones') do
    #  elb.enable_availability_zones(%w{us-east-1c us-east-1d})
    #  returns(%w{us-east-1a us-east-1b us-east-1c us-east-1d}) { elb.availability_zones.sort }
    #end

    #tests('default health check') do
    #  default_health_check = {
    #    "HealthyThreshold"=>10,
    #    "Timeout"=>5,
    #    "UnhealthyThreshold"=>2,
    #    "Interval"=>30,
    #    "Target"=>"TCP:80"
    #  }
    #  returns(default_health_check) { elb.health_check }
    #end

    #tests('configure_health_check') do
    #  new_health_check = {
    #    "HealthyThreshold"=>5,
    #    "Timeout"=>10,
    #    "UnhealthyThreshold"=>3,
    #    "Interval"=>15,
    #    "Target"=>"HTTP:80/index.html"
    #  }
    #  elb.configure_health_check(new_health_check)
    #  returns(new_health_check) { elb.health_check }
    #end

    #tests('listeners') do
    #  default_listener_description = [{"Listener"=>{"InstancePort"=>80, "Protocol"=>"HTTP", "LoadBalancerPort"=>80}, "PolicyNames"=>[]}]
    #  tests('default') do
    #    returns(1) { elb.listeners.size }
    #
    #    listener = elb.listeners.first
    #    returns([80,80,'HTTP', []]) { [listener.instance_port, listener.lb_port, listener.protocol, listener.policy_names] }
    #
    #  end
    #
    #  tests('#get') do
    #    returns(80) { elb.listeners.get(80).lb_port }
    #  end
    #
    #  tests('create') do
    #    new_listener = { 'InstancePort' => 443, 'LoadBalancerPort' => 443, 'Protocol' => 'TCP'}
    #    elb.listeners.create(:instance_port => 443, :lb_port => 443, :protocol => 'TCP')
    #    returns(2) { elb.listeners.size }
    #    returns(443) { elb.listeners.get(443).lb_port }
    #  end
    #
    #  tests('destroy') do
    #    elb.listeners.get(443).destroy
    #    returns(nil) { elb.listeners.get(443) }
    #  end
    #end

    tests('policies') do
      simple_policy_id = 'fog-model-asg-policy-simple'
      step_policy_id = 'fog-model-asg-policy-step'
      target_policy_id = 'fog-model-asg-policy-target'

      tests 'create simple' do
        asg_policy = Fog::AWS[:auto_scaling].policies.create({ id: simple_policy_id, scaling_adjustment: 1, auto_scaling_group_name: asg_id })
        tests('arn not nil').returns(false) { asg_policy.arn.nil? }
        tests('adjustment is set').returns(true) { asg_policy.scaling_adjustment == 1 }
        tests('alarms are not set').returns([]) { asg_policy.alarms }
      end

      tests('create step') do
        asg_policy = Fog::AWS[:auto_scaling].policies.create({
                                                               id: step_policy_id,
                                                               type: 'StepScaling',
                                                               step_adjustments: [{
                                                                                    'MetricIntervalLowerBound' => 0,
                                                                                    'MetricIntervalUpperBound' => nil,
                                                                                    'ScalingAdjustment'        => 1
                                                                                  }],
                                                               auto_scaling_group_name: asg_id })
        tests('arn not nil').returns(false) { asg_policy.arn.nil? }
        tests('nested attributes are available with snake case').returns(true) { asg_policy.step_adjustments[0][:metric_interval_lower_bound] == 0 }
      end

      tests('create target') do
        asg_policy = Fog::AWS[:auto_scaling].policies.create({
                                                               id: target_policy_id,
                                                               type: 'TargetTrackingScaling',
                                                               target_tracking_configuration: {
                                                                 predefined_metric_specification: {
                                                                   predefined_metric_type: 'ASGAverageCPUUtilization'
                                                                 },
                                                                 target_value: 50
                                                               },
                                                               auto_scaling_group_name: asg_id })
        tests('arn not nil').returns(false) { asg_policy.arn.nil? }
        tests('nested attributes are available with snake case').returns(true) { asg_policy.target_tracking_configuration[:target_value] == 50 }
      end

      tests('destroy') do
        policy = Fog::AWS[:auto_scaling].policies.get(simple_policy_id, asg_id)
        policy.destroy
        returns(nil) { Fog::AWS[:auto_scaling].policies.get(simple_policy_id, asg_id) }
      end
    end

    tests('groups') do
      tests('destroy group') do
        asg.destroy
        asg = nil
      end
    end

    tests('configurations') do
      tests('destroy configuration') do
        lc.destroy
        lc = nil
      end
    end
  end
end
