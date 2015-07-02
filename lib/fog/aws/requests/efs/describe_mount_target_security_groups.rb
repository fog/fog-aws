module Fog
  module AWS
    class EFS
      class Real
        # Returns the security groups currently in effect for a mount target.
        # http://docs.aws.amazon.com/efs/latest/ug/API_DescribeMountTargetSecurityGroups.html
        # ==== Parameters
        # * MountTargetId <~String> - ID of the mount target whose security groups you want to retrieve.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'SecurityGroups' <~Array> - array of security groups.
        def describe_mount_target_security_groups(params={})
          mount_target_id = params.delete('MountTargetId')

          request({
            :method  => 'GET',
            :path    => "/mount-targets/#{mount_target_id}/security-groups",
          }.merge(params))
        end
      end

      class Mock
        def describe_mount_target_security_groups(params={})
          response = Excon::Response.new

          mount_target_id = params.delete('MountTargetId')

          self.data[:security_groups][mount_target_id] ||= []
          security_groups = self.data[:security_groups][mount_target_id]

          response.body = { 'SecurityGroups' => security_groups }
          response.status = 200
          response
        end
      end
    end
  end
end
