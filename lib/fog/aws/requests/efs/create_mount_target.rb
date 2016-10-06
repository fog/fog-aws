module Fog
  module AWS
    class EFS
      class Real
        # Create a mount target for a specified file system
        # http://docs.aws.amazon.com/efs/latest/ug/API_CreateMountTarget.html
        # ==== Parameters
        # * FileSystemId <~String> - ID of the file system for which to create the mount target.
        # * IpAddress <~String> - Valid IPv4 address within the address range of the specified subnet.
        # * SecurityGroups <~Array> - Up to five VPC security group IDs, of the form sg-xxxxxxxx. These must be for the same VPC as subnet specified.
        # * SubnetId <~String> - ID of the subnet to add the mount target in.
        # ==== Returns
        # * response<~Excon::Response>
        #   * body<~Hash>
        def create_mount_target(options={})
          request({
            :path          => "mount-targets",
            :method        => "POST",
            'FileSystemId' => options[:file_system_id],
            'SubnetId'     => options[:subnet_id]
          }.merge(options))
        end
      end

      class Mock
        def create_mount_target(options={})
          response       = Excon::Response.new
          file_system_id = options[:file_system_id]
          subnet_id      = options[:subnet_id]

          unless file_system = self.data[:file_systems][file_system_id]
            raise Fog::AWS::EFS::NotFound.new("invalid file system ID: #{file_system_id}")
          end

          unless file_system["LifeCycleState"] == 'available'
            # this error doesn't include a message for some reason
            raise Fog::AWS::EFS::IncorrectFileSystemLifeCycleState.new("")
          end

          unless subnet = Fog::Compute[:aws].subnets.get(subnet_id)
            raise Fog::AWS::EFS::InvalidSubnet.new("invalid subnet ID: #{subnet_id}")
          end

          id = "fsmt-#{Fog::Mock.random_letters(8)}"

          mount_target = {
            'MountTargetId'      => id,
            'FileSystemId'       => file_system_id,
            'IpAddress'          => Fog::AWS::Mock.ip_address,
            'OwnerId'            => Fog::AWS::Mock.owner_id,
            'LifeCycleState'     => 'creating',
            'NetworkInterfaceId' => "eni-#{Fog::Mock.random_hex(8)}",
            'SubnetId'           => subnet.identity,
          }

          self.data[:mount_targets][id] = mount_target

          response.body = mount_target
          response
        end
      end
    end
  end
end
