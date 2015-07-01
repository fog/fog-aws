module Fog
  module AWS
    class EFS
      class Real
        # Returns the tags associated with a file system.
        # http://docs.aws.amazon.com/efs/latest/ug/API_DescribeTags.html
        # ==== Parameters
        # * FileSystemId <~String> - ID of the file system whose tag set you want to retrieve.
        # * Marker <~String> - Opaque pagination token returned from a previous DescribeTags operation.
        # * MaxItems <~Integer> - Maximum number of file system tags to return in the response.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'MountTargets' <~Array> - file system's mount targets as an array of MountTargetDescription objects.
        #     * 'Marker' <~String> - if the request included the Marker, the response returns that value in this field.
        #     * 'NextMarker' <~String> - if a value is present, there are more mount targets to return. 
        def describe_tags(params={})
          query = {}

          file_system_id = params.delete('FileSystemId')
          query.merge!('FileSystemId' => file_system_id)

          marker = params.delete('Marker')
          query.merge!('Marker' => marker)

          max_items = params.delete('MaxItems')
          query.merge!('MaxItems' => max_items)

          request({
            :method  => 'GET',
            :path    => "/tags/#{file_system_id}/",
            :query   => query,
          }.merge(params))
        end
      end

      class Mock
        def describe_tags(params={})
          response = Excon::Response.new

          file_system_id = params.delete('FileSystemId')

          file_system_params = { 'FileSystemId' => file_system_id }
          result = self.describe_file_systems(file_system_params).body
          file_system = result['FileSystems'].first

          tags = []
          self.data[:tags][file_system_id].each_pair do |k,v|
            tags << { "Key" => k, "Value" => v }
          end

          response.body = { 'Tags' => tags }
          response.status = 200
          response
        end
      end
    end
  end
end
