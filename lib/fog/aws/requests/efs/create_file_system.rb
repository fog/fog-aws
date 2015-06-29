module Fog
  module AWS
    class EFS
      class Real
        require 'fog/aws/parsers/efs/base'

        # Creates a new, empty file system.
        # http://docs.aws.amazon.com/efs/latest/ug/API_CreateFileSystem.html
        # ==== Parameters
        # * CreationToken <~String> - String of up to 64 ASCII characters. Amazon EFS uses this to ensure idempotent creation.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'CreationTime' <~Date> - time at which the file system was created, in seconds, since 1970-01-01T00:00:00Z.
        #     * 'CreationToken' <~String> - opaque string specified in the request.
        #     * 'FileSystemId' <~String> - file system ID assigned by Amazon EFS.
        #     * 'LifeCycleState' <~String> - predefined string value that indicates the lifecycle phase of the file system.
        #     * 'Name' <~String> - you can add tags to a file system (see CreateTags) including a "Name" tag.
        #     * 'NumberOfMountTargets' <~Integer> - current number of mount targets (see CreateMountTarget) the file system has.
        #     * 'OwnerId' <~String> - AWS account that created the file system.
        #     * 'SizeInBytes' <~Hash> - provides the latest known metered size of data stored in the file system.
        def create_file_system(params={})
          creation_token = params.delete('CreationToken')
          fs_data = { 'CreationToken' => creation_token }

          request({
            :method  => 'POST',
            :path    => '/file-systems',
            :expects => 201,
            :body    => Fog::JSON.encode(fs_data),
            :parser  => Fog::AWS::Parsers::EFS::Base.new
          }.merge(params))
        end
      end

      class Mock
        def create_file_system(params={})
          response = Excon::Response.new

          creation_token = params.delete('CreationToken')
          unless creation_token
            message = 'ValidationException: CreationToken cannot be blank.'
            raise Fog::AWS::EFS::Error, message
          end

          now            = Time.now.utc.to_f
          file_system_id = "fs-#{Fog::Mock.random_hex(8)}"

          file_system = {
            'creationTime'         => now,
            'creationToken'        => creation_token,
            'fileSystemId'         => file_system_id,
            'lifeCycleState'       => 'creating',
            'numberOfMountTargets' => 0,
            'ownerId'              => self.account_id,
            'sizeInBytes'          => {
              'value'              => 1024,
              'timestamp'          => now
            }
          }

          self.data[:file_systems][file_system_id] = file_system
          response.body   = file_system
          response.status = 201
          response
        end
      end
    end
  end
end
