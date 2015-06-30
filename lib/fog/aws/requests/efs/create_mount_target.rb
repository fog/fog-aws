module Fog
  module AWS
    class EFS
      class Real
        # Creates a mount target for a file system.
        # http://docs.aws.amazon.com/efs/latest/ug/API_CreateMountTarget.html
        # ==== Parameters
        # * FileSystemId <~String> - ID of the file system for which to create the mount target.
        # * IpAddress <~String> - valid IPv4 address within the address range of the specified subnet.
        # * SecurityGroups <~Array> - up to 5 VPC security group IDs.
        # * SubnetId <~Array> - ID of the subnet to add the mount target in.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'FileSystemId' <~String> - ID of the file system for which the mount target is intended.
        #     * 'IpAddress' <~String> - address at which the file system may be mounted via the mount target.
        #     * 'LifeCycleState' <~String> - lifecycle state the mount target is in.
        #     * 'MountTargetId' <~String> - system-assigned mount target ID.
        #     * 'NetworkInterfaceId' <~String> - ID of the network interface that Amazon EFS created when it created the mount target.
        #     * 'OwnerId' <~String> - AWS account ID that owns the resource.
        #     * 'SubnetId' <~String> - ID of the subnet that the mount target is in.
        def create_mount_target(params={})
          file_system_id  = params.delete('FileSystemId')
          subnet_id       = params.delete('SubnetId')
          ip_address      = params.delete('IpAddress')
          security_groups = params.delete('SecurityGroups')

          mount_target_data = {}
          mount_target_data.merge!('FileSystemId' => file_system_id)
          mount_target_data.merge!('SubnetId'     => subnet_id)
          mount_target_data.merge!('IpAddress'    => ip_address) if ip_address

          if security_groups
            mount_target_data.merge!('SecurityGroups' => Array(security_groups))
          end

          request({
            :method  => 'POST',
            :path    => '/mount-targets',
            :expects => 200,
            :body    => Fog::JSON.encode(mount_target_data)
          }.merge(params))
        end
      end

      class Mock
        def create_mount_target(params={})
          response = Excon::Response.new

          file_system_id  = params.delete('FileSystemId')
          subnet_id       = params.delete('SubnetId')
          ip_address      = params.delete('IpAddress')
          security_groups = params.delete('SecurityGroups')

          unless file_system_id
            message = 'ValidationException: FileSystemId cannot be blank.'
            raise Fog::AWS::EFS::Error, message
          end

          unless subnet_id
            message = 'ValidationException: SubnetId cannot be blank.'
            raise Fog::AWS::EFS::Error, message
          end

          mount_target = {
            'FileSystemId'       => file_system_id,
            'IpAddress'          => ip_address || Fog::AWS::Mock.private_ip_address,
            'LifeCycleState'     => 'creating',
            'MountTargetId'      => "fsmt-#{Fog::Mock.random_hex(8)}",
            'NetworkInterfaceId' => "eni-#{Fog::Mock.random_hex(8)}",
            'OwnerId'            => self.account_id,
            'SubnetId'           => subnet_id,
          }

          self.data[:mount_targets][file_system_id] = mount_target
          response.body   = mount_target
          response.status = 200
          response
        end
      end
    end
  end
end
