module Fog
  module AWS
    class EFS
      class Real
        # Deletes the specified mount target.
        # http://docs.aws.amazon.com/efs/latest/ug/API_DeleteMountTarget.html
        # ==== Parameters
        # * MountTargetId <~String> - The ID of the mount target to delete.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String>:
        def delete_mount_target(params={})
          mount_target_id = params.delete('MountTargetId')

          request({
            :method  => 'DELETE',
            :path    => "/mount-targets/#{file_system_id}",
            :expects => 204
          }.merge(params))
        end
      end

      class Mock
        def delete_mount_target(params={})
          response = Excon::Response.new

          mount_target_id = params.delete('MountTargetId')
          unless mount_target_id
            message = 'ValidationException: MountTargetId cannot be blank.'
            raise Fog::AWS::EFS::Error, message
          end

          self.data[:mount_targets].each_pair do |fs,mts|
            mts.delete_if { |mt| mt['MountTargetId'].eql?(mount_target_id) }
          end

          response.body   = ''
          response.status = 204
          response
        end
      end
    end
  end
end
