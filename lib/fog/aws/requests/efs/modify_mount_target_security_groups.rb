module Fog
  module AWS
    class EFS
      class Real
        def modify_mount_target_security_groups(id, security_groups)
          request({
            :path            => "mount-targets/#{id}/security-groups",
            :method          => "PUT",
            :expects         => 204,
            'SecurityGroups' => security_groups
          })
        end
      end

      class Mock
        def modify_mount_target_security_groups(id, security_groups)
          response = Excon::Response.new

          unless self.data[:mount_targets][id]
            raise Fog::AWS::EFS::NotFound.new("invalid mount target ID: #{id}")
          end

          security_groups.each do |sg|
            raise Fog::AWS::EFS::NotFound.new("invalid security group ID: #{sg}") unless Fog::Compute[:aws].data[:security_groups].values.detect { |sgd| sgd["groupId"] == sg }
          end

          self.data[:security_groups][id] = security_groups

          response.status = 204
          response
        end
      end
    end
  end
end
