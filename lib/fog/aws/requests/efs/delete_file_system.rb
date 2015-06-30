module Fog
  module AWS
    class EFS
      class Real
        # Deletes a file system, permanently severing access to its contents.
        # http://docs.aws.amazon.com/efs/latest/ug/API_DeleteFileSystem.html
        # ==== Parameters
        # * FileSystemId <~String> - ID of the file system you want to delete.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String>:
        def delete_file_system(params={})
          file_system_id = params.delete('FileSystemId')

          request({
            :method  => 'DELETE',
            :path    => "/file-systems/#{file_system_id}",
            :expects => 204
          }.merge(params))
        end
      end

      class Mock
        def delete_file_system(params={})
          response = Excon::Response.new

          file_system_id = params.delete('FileSystemId')
          unless file_system_id
            message = 'ValidationException: FileSystemId cannot be blank.'
            raise Fog::AWS::EFS::Error, message
          end

          #mount_target_params = { 'FileSystemId' => file_system_id }
          #result = self.describe_mount_targets(mount_target_params).body
          #mount_targets = result['MountTargets']
          mount_targets = []

          message = 'FileSystemInUse'
          raise Fog::AWS::EFS::Error, message if !mount_targets.empty?

          self.data[:file_systems].delete(file_system_id)
          response.body   = ''
          response.status = 204
          response
        end
      end
    end
  end
end
