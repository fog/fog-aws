Shindo.tests('Fog::Compute[:aws] | describe_instance_attribute request', ['aws']) do
  @instance_attributes = [
    'instanceType',
    'kernel',
    'ramdisk',
    'userData',
    'disableApiTermination',
    'instanceInitiatedShutdownBehavior',
    'rootDeviceName',
    'blockDeviceMapping',
    'productCodes',
    'groupSet',
    'ebsOptimized',
    'sourceDestCheck',
    'sriovNetSupport'
  ]

  @instance_attribute_common_format = {
    "requestId"                         => String,
    "instanceId"                        => String
  }

  @instance_attribute_format = {
    "instanceType"                      => Fog::Nullable::String,
    "kernelId"                          => Fog::Nullable::String,
    "ramdiskId"                         => Fog::Nullable::String,
    "userData"                          => Fog::Nullable::String,
    "disableApiTermination"             => Fog::Nullable::Boolean,
    "instanceInitiatedShutdownBehavior" => Fog::Nullable::String,
    "rootDeviceName"                    => Fog::Nullable::String,
    "blockDeviceMapping"                => [Fog::Nullable::Hash],
    "productCodes"                      => Fog::Nullable::Array,
    "ebsOptimized"                      => Fog::Nullable::Boolean,
    "sriovNetSupport"                   => Fog::Nullable::String,
    "sourceDestCheck"                   => Fog::Nullable::Boolean,
    "groupSet"                          => [Fog::Nullable::Hash]
  }

  tests('success') do

    @instance_id = nil
    @ami = 'ami-79c0ae10'
    if Fog.mocking?
      @instance_attribute_format["groupSet"] = Fog::Nullable::Array
    end
    key_name = 'fog-test-key'
    @key = Fog::Compute[:aws].key_pairs.create(:name => key_name)
    instance_type = "t1.micro"
    @az = "us-east-1a"
    vpc = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/16')
    subnet = Fog::Compute[:aws].subnets.create('vpc_id' => vpc.id, 'cidr_block' => '10.0.10.0/16', "availability_zone" => @az)
    security_groups = Fog::Compute[:aws].security_groups.all
    @launch_config = {
      :image_id => @ami,
      :flavor_id => instance_type,
      :key_name => key_name,
      :subnet_id => subnet.subnet_id,
      :disable_api_termination => false
    }
    if !Fog.mocking?
      security_group = security_groups.select { |group| group.vpc_id == vpc.id }
      security_group_ids = security_group.collect { |group| group.group_id }
      @launch_config[:security_group_ids] = security_group_ids
      block_device_mapping = [{"DeviceName" => "/dev/sdp1", "VirtualName" => nil, "Ebs.VolumeSize" => 15}]
      @launch_config[:block_device_mapping] = block_device_mapping
    else
      security_group_ids = [nil]
      block_device_mapping = [{"DeviceName" => "/dev/sda1", "VirtualName" => nil, "Ebs.VolumeSize" => 15},{"DeviceName" => "/dev/sdp1", "VirtualName" => nil, "Ebs.VolumeSize" => 15}]
      @launch_config[:block_device_mapping] = block_device_mapping
    end



    server = Fog::Compute[:aws].servers.create(@launch_config)
    server.wait_for { ready? }
    server.reload
    @instance_id = server.id

    @instance_attributes.each do |attrib|
      describe_instance_attribute_format = @instance_attribute_common_format.clone
      if attrib == "kernel"
        key = "kernelId"
      elsif attrib == "ramdisk"
        key = "ramdiskId"
      else
        key = attrib
      end
      describe_instance_attribute_format[key] = @instance_attribute_format[key]

      tests("#describe_instance_attribute('#{@instance_id}', #{attrib})").formats(describe_instance_attribute_format,false) do
        Fog::Compute[:aws].describe_instance_attribute(@instance_id, attrib).body
      end
      tests("#describe_instance_attribute('#{@instance_id}', #{attrib})").returns(@instance_id) do
        Fog::Compute[:aws].describe_instance_attribute(@instance_id, attrib).body['instanceId']
      end
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'instanceType')").returns(instance_type) do
      Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'instanceType').body["instanceType"]
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'disableApiTermination')").returns(false) do
      Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'disableApiTermination').body["disableApiTermination"]
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'instanceInitiatedShutdownBehavior')").returns('stop') do
      Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'instanceInitiatedShutdownBehavior').body["instanceInitiatedShutdownBehavior"]
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'rootDeviceName')").returns('/dev/sda1') do
      Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'rootDeviceName').body["rootDeviceName"]
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'blockDeviceMapping')").returns(2) do
      Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'blockDeviceMapping').body["blockDeviceMapping"].count
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'blockDeviceMapping')").returns("/dev/sdp1") do
      Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'blockDeviceMapping').body["blockDeviceMapping"].last["deviceName"]
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'groupSet')").returns(security_group_ids) do
      group_set = Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'groupSet').body["groupSet"]
      group_set.collect { |g| g["groupId"]}
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'sourceDestCheck')").returns(true) do
      Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'sourceDestCheck').body["sourceDestCheck"]
    end

    tests("#describe_instance_attribute(#{@instance_id}, 'ebsOptimized')").returns(false) do
      Fog::Compute[:aws].describe_instance_attribute(@instance_id, 'ebsOptimized').body["ebsOptimized"]
    end

    if !Fog.mocking?
      @key.destroy
      server.destroy
      until server.state == "terminated"
        sleep 5 #Wait for the server to be terminated
        server.reload
      end
      subnet.destroy
      vpc.destroy
    end

  end

  tests('failure') do
    @instance_attributes.each do |attrib|
      tests("#describe_instance_attribute('i-00000000', #{attrib})").raises(Fog::Compute::AWS::NotFound) do
        Fog::Compute[:aws].describe_instance_attribute('i-00000000', attrib)
      end
    end
  end

end
