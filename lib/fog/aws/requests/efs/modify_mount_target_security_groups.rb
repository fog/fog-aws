module Fog
  module AWS
    class EFS
      class Real
        # Modifies the set of security groups in effect for a mount target.
        # http://docs.aws.amazon.com/efs/latest/ug/API_ModifyMountTargetSecurityGroups.html
        # ==== Parameters
        # * MountTargetId <~String> - ID of the mount target whose security groups you want to modify.
        # * SecurityGroups <~Array> - array of up to five VPC security group IDs.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String>:
        def modify_mount_target_security_groups(params={})
          mount_target_id = params.delete('MountTargetId')
          security_groups = Array(params.delete('SecurityGroups'))

          request({
            :method  => 'PUT',
            :path    => "/mount-targets/#{mount_target_id}/security-groups",
            :expects => 204,
            :body    => Fog::JSON.encode('SecurityGroups' => security_groups)
          }.merge(params))
        end
      end

      class Mock
        def modify_mount_target_security_groups(params={})
          response = Excon::Response.new

          mount_target_id = params.delete('MountTargetId')
          security_groups = Array(params.delete('SecurityGroups'))

          # to-do: handle nonexistent mount_target_id
          self.data[:security_groups][mount_target_id] = security_groups

          response.status = 204
          response.body = ''
          response
        end
      end
    end
  end
end
