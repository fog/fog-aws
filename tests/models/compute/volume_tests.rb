Shindo.tests("Fog::Compute[:aws] | volume", ['aws']) do

  @server = Fog::Compute[:aws].servers.create
  @server.wait_for { ready? }

  model_tests(Fog::Compute[:aws].volumes, {:availability_zone => @server.availability_zone, :size => 1, :device => '/dev/sdz1', :tags => {"key" => "value"}, :type => 'gp2'}, true) do

    @instance.wait_for { ready? }

    tests('#server = @server').succeeds do
      @instance.server = @server
    end

    @instance.wait_for { state == 'in-use' }

    tests('#server').succeeds do
      @instance.server.id == @server.id
    end

    tests('#server = nil').succeeds do
      (@instance.server = nil).nil?
    end

    @instance.wait_for { ready? }

    @instance.server = @server
    @instance.wait_for { state == 'in-use' }

    tests('#force_detach').succeeds do
      @instance.force_detach
    end

    @instance.wait_for { ready? }

    @instance.type = 'io1'
    @instance.iops = 5000
    @instance.size = 100
    @instance.save

    returns(true) { @instance.modification_in_progress? }
    @instance.wait_for { !modification_in_progress? }

    # avoid weirdness with merge_attributes
    @instance = Fog::Compute[:aws].volumes.get(@instance.identity)

    returns('io1') { @instance.type }
    returns(5000)  { @instance.iops }
    returns(100)   { @instance.size }

    tests('@instance.reload.tags').returns({'key' => 'value'}) do
      @instance.reload.tags
    end

  end

  @server.destroy

end
