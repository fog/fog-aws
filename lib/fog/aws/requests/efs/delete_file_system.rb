module Fog
  module AWS
    class EFS
      class Real
        # Delete a file system
        # http://docs.aws.amazon.com/efs/latest/ug/API_DeleteFileSystem.html
        # ==== Parameters
        # * FileSystemId <~String> - ID of the file system you want to delete.
        # ==== Response
        # * response<~Excon::Response>
        #   * body - Empty
        #   * status - 204
        def delete_file_system(options={})
          id = options.delete(:id)
          request({
            :path             => "file-systems/#{id}",
            :method           => 'DELETE',
            :expects          => 204,
            'CreationToken'   => options[:creation_token],
            'PerformanceMode' => options[:performance_mode] || 'generalPurpose'
          })
        end
      end

      class Mock
        def delete_file_system(options={})
          id = options.delete(:id)

          unless file_system = self.data[:file_systems][id]
            raise Fog::AWS::EFS::NotFound.new("invalid file system ID: #{id}")
          end

          if file_system["NumberOfMountTargets"] > 0
            raise Fog::AWS::EFS::FileSystemInUse.new("file system still has active mount targets")
          end

          self.data[:file_systems].delete(id)

          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
