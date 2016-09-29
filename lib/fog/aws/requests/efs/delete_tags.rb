module Fog
  module AWS
    class EFS
      class Real
        # Deletes the specified tags from a file system. 
        # http://docs.aws.amazon.com/efs/latest/ug/API_DeleteTags.html
        # ==== Parameters
        # * FileSystemId <~String> - ID of the file system whose tags you want to delete.
        # * TagKeys <~Array> - ist of tag keys to delete.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String>:
        def delete_tags(params={})
          file_system_id = params.delete('FileSystemId')
          tagkeys = Array(params.delete('TagKeys'))

          request({
            :method  => 'POST',
            :path    => "/delete-tags/#{file_system_id}",
            :body    => Fog::JSON.encode("TagKeys" => tagkeys),
            :expects => 204
          }.merge(params))
        end
      end

      class Mock
        def delete_tags(params={})
          response = Excon::Response.new

          file_system_id = params.delete('FileSystemId')
          tagkeys = Array(params.delete('TagKeys'))

          fs_params = { 'FileSystemId' => file_system_id }
          result = self.describe_file_systems(fs_params).body
          file_system = result['FileSystems'].first

          tagkeys.each do |k|
            self.data[:tags][file_system_id].delete(k)
          end

          response.body   = ''
          response.status = 204
          response
        end
      end
    end
  end
end
