module Fog
  module AWS
    class EFS
      class Real
        require 'fog/aws/parsers/efs/base'

        # Returns the description of a specific Amazon EFS file systems.
        # http://docs.aws.amazon.com/efs/latest/ug/API_DescribeFileSystems.html
        # ==== Parameters
        # * CreationToken <~String> - Restricts the list to the file system with this creation token.
        # * FileSystemId <~String> - File system ID whose description you want to retrieve.
        # * Marker <~String> - Opaque pagination token returned from a previous DescribeFileSystems operation.
        # * MaxItems <~Integer> - Specifies the maximum number of file systems to return in the response.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'FileSystems' <~Array> - array of file system descriptions.
        #     * 'Marker' <~String> - present if provided by caller in the request.
        #     * 'NextMarker' <~String> - present if there are more file systems than returned in the response.
        def describe_file_systems(params={})
          query = {}

          creation_token = params.delete('CreationToken')
          query.merge!('CreationToken' => creation_token)

          file_system_id = params.delete('FileSystemId')
          query.merge!('FileSystemId' => file_system_id)

          marker = params.delete('Marker')
          query.merge!('Marker' => marker)

          max_items = params.delete('MaxItems')
          query.merge!('MaxItems' => max_items)

          request({
            :method  => 'GET',
            :path    => '/file-systems',
            :query   => query,
            :expects => 200,
            :parser  => Fog::AWS::Parsers::EFS::Base.new
          }.merge(params))
        end
      end

      class Mock
        def describe_file_systems(params={})
          response = Excon::Response.new

          creation_token = params.delete('CreationToken')
          file_system_id = params.delete('FileSystemId')

          # update file systems status
          self.data[:file_systems].values.each do |fs|
            if fs['LifeCycleState'].eql?('creating')
              fs['LifeCycleState'] = 'available' 
            end
          end

          file_systems = []

          # if no filters are provided, return inmediately all filesystems
          if creation_token.nil? && file_system_id.nil?
            file_systems  = self.data[:file_systems].values
            response.status = 200
            response.body = { 'FileSystems' => file_systems }
            return response
          end

          fs = {}

          fs = self.data[:file_systems][file_system_id] if file_system_id
          message = 'Filesystem not found'
          raise Fog::AWS::EFS::Error, message unless fs

          if creation_token
            if !fs.empty? && fs['CreationToken'].eql?(creation_token)
              file_systems << fs
            end
            if fs.empty?
              fs = self.data[:file_systems].select do |fsid,fsdata|
                fsdata['CreationToken'].eql?(creation_token)
              end
              file_systems = file_systems + fs.values
            end
          end

          response.body = { 'FileSystems' => file_systems }
          response.status = 200
          response
        end
      end
    end
  end
end
