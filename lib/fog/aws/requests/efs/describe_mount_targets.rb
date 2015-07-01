module Fog
  module AWS
    class EFS
      class Real
        # Returns the descriptions of the current mount targets for a file system.
        # http://docs.aws.amazon.com/efs/latest/ug/API_DescribeMountTargets.html
        # ==== Parameters
        # * FileSystemId <~String> - ID of the file system whose mount targets you want to list.
        # * Marker <~String> - Opaque pagination token returned from a previous DescribeMountTargets operation.
        # * MaxItems <~Integer> - Maximum number of mount targets to return in the response.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'MountTargets' <~Array> - file system's mount targets as an array of MountTargetDescription objects.
        #     * 'Marker' <~String> - if the request included the Marker, the response returns that value in this field.
        #     * 'NextMarker' <~String> - if a value is present, there are more mount targets to return. 
        def describe_mount_targets(params={})
          query = {}

          file_system_id = params.delete('FileSystemId')
          query.merge!('FileSystemId' => file_system_id)

          marker = params.delete('Marker')
          query.merge!('Marker' => marker)

          max_items = params.delete('MaxItems')
          query.merge!('MaxItems' => max_items)

          request({
            :method  => 'GET',
            :path    => '/mount-targets',
            :query   => query,
          }.merge(params))
        end
      end

      class Mock
        def describe_mount_targets(params={})
          response = Excon::Response.new

          file_system_id = params.delete('FileSystemId')

          # update mount targets status
          self.data[:mount_targets].each_pair do |fs,mts|
            mts.each do |mt|
              if mt['LifeCycleState'].eql?('creating')
                mt['LifeCycleState'] = 'available' 
              end
            end
          end

          file_system_params = { 'FileSystemId' => file_system_id }
          result = self.describe_file_systems(file_system_params).body
          file_system = result['FileSystems'].first

          mount_targets = self.data[:mount_targets][file_system_id] || []

          response.body = { 'MountTargets' => mount_targets }
          response.status = 200
          response
        end
      end
    end
  end
end
