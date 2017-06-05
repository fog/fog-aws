require 'fog/aws/elbv2/default_tg_attributes'

Shindo.tests('AWS::elbv2 | target_group', ['aws', 'elbv2', 'models']) do
  Fog::Compute::AWS::Mock.reset if Fog.mocking?

  ELBV2 = Fog::AWS[:elbv2]

  @server1 = Fog::Compute[:aws].servers.create
  @server1.wait_for { ready? }

  @server2 = Fog::Compute[:aws].servers.create
  @server2.wait_for { ready? }

  tests('success') do
    @target_group = ELBV2.target_groups.create(:name => "test-tg-1")

    tests('defaults').returns(Fog::AWS::ELBV2::Mock.default_tg_attributes) do
      @target_group.tg_attributes
    end

    tests('#register_targets') do
      @target_group.register_targets(@server1.id)

      tests('target health') do
        tests('#healthy?').returns(true) { @target_group.target_health.first.healthy? }
      end

      @target_group.register_targets(@server2.id)
      tests('target health second') do
        tests('#target_health').returns(1) { @target_group.target_health([@server2.id]).size }
      end
    end

    tests('#deregister_targets') do
      tests('number of targets before destroy').returns(2) { @target_group.target_health.size }
      @target_group.deregister_targets(@server1.id)
      tests('number of targets').returns(1) { @target_group.target_health.size }
      @target_group.deregister_targets(@server2.id)
      tests('number of targets after destroy').returns(0) { @target_group.target_health.size }
    end

    tests('stickiness') do
      tests('#stickiness_enabled?').returns(false) { @target_group.stickiness_enabled? }
      tests('#stickiness_type').returns('lb_cookie') { @target_group.stickiness_type }
      tests('#stickiness_duration').returns(3600*24) { @target_group.stickiness_duration }

      tests('#deregistration_delay_timeout').returns(300) { @target_group.deregistration_delay_timeout }

      tests('#enable_stickiness').returns(true) do
        @target_group.enable_stickiness
        @target_group.stickiness_enabled?
      end

      tests('#deregistration_delay_timeout=').returns(600) do
        @target_group.deregistration_delay_timeout = 600
        @target_group.deregistration_delay_timeout
      end
    end

    tests('modify').returns('200-299') do
      @target_group.update(:matcher => '200-299')
      @target_group.reload.matcher
    end

    @target_group.destroy
  end

  [@server1, @server2].map(&:destroy)
end
