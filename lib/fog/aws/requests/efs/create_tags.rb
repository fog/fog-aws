module Fog
  module AWS
    class EFS
      class Real
        # Creates or overwrites tags associated with a file system.
        # http://docs.aws.amazon.com/efs/latest/ug/API_CreateTags.html
        # ==== Parameters
        # * FileSystemId <~String> - ID of the file system whose tags you want to modify.
        # * Tags <~Array> - array of Tag objects to add.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String>:
        def create_tags(params={})
          file_system_id = params.delete('FileSystemId')
          _tags = params.delete('Tags')

          if _tags.is_a?(Hash)
            tags = []
            _tags.each_pair do |k,v|
              tags << {
                'Key'   => k,
                'Value' => v,
              }
            end
          else
            tags = _tags
          end

          request({
            :method  => 'POST',
            :path    => "/create-tags/#{file_system_id}",
            :expects => 204,
            :body    => Fog::JSON.encode('Tags' => tags)
          }.merge(params))
        end
      end

      class Mock
        def create_tags(params={})
          response = Excon::Response.new

          file_system_id = params.delete('FileSystemId')
          tags = params.delete('Tags') || {}

          fs_params = { 'FileSystemId' => file_system_id }
          result = self.describe_file_systems(fs_params).body
          file_system = result['FileSystems'].first

          self.data[:tags][file_system_id] ||= {}
          tags.each_pair do |k,v|
            self.data[:tags][file_system_id][k] = v
          end

          response.body   = ''
          response.status = 204
          response
        end
      end
    end
  end
end
