module Fog
  module AWS
    class Storage
      class Real
        require 'fog/aws/parsers/storage/list_objects_v2'

        # List information about objects in an S3 bucket using ListObjectsV2
        #
        # @param bucket_name [String] name of bucket to list object keys from
        # @param options [Hash] config arguments for list.  Defaults to {}.
        # @option options delimiter [String] causes keys with the same string between the prefix
        #     value and the first occurrence of delimiter to be rolled up
        # @option options continuation-token [String] continuation token from a previous request
        # @option options fetch-owner [Boolean] specifies whether to return owner information
        # @option options max-keys [Integer] limits number of object keys returned
        # @option options prefix [String] limits object keys to those beginning with its value
        # @option options start-after [String] starts listing after this specified key
        #
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * Delimiter [String] - Delimiter specified for query
        #     * IsTruncated [Boolean] - Whether or not the listing is truncated
        #     * ContinuationToken [String] - Token specified in the request
        #     * NextContinuationToken [String] - Token to use in subsequent requests
        #     * KeyCount [Integer] - Number of keys returned
        #     * MaxKeys [Integer] - Maximum number of keys specified for query
        #     * Name [String] - Name of the bucket
        #     * Prefix [String] - Prefix specified for query
        #     * StartAfter [String] - StartAfter specified in the request
        #     * CommonPrefixes [Array] - Array of strings for common prefixes
        #     * Contents [Array]:
        #       * ETag [String] - Etag of object
        #       * Key [String] - Name of object
        #       * LastModified [String] - Timestamp of last modification of object
        #       * Owner [Hash]:
        #         * DisplayName [String] - Display name of object owner
        #         * ID [String] - Id of object owner
        #       * Size [Integer] - Size of object
        #       * StorageClass [String] - Storage class of object
        #
        # @see https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectsV2.html

        def list_objects_v2(bucket_name, options = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          
          # Add list-type=2 to indicate ListObjectsV2
          options = options.merge('list-type' => '2')
          
          request({
            :expects  => 200,
            :headers  => {},
            :bucket_name => bucket_name,
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::AWS::Storage::ListObjectsV2.new,
            :query    => options
          })
        end
      end

      class Mock # :nodoc:all
        def list_objects_v2(bucket_name, options = {})
          prefix = options['prefix']
          continuation_token = options['continuation-token']
          delimiter = options['delimiter']
          max_keys = options['max-keys']
          start_after = options['start-after']
          fetch_owner = options['fetch-owner']
          common_prefixes = []

          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          
          response = Excon::Response.new
          if bucket = self.data[:buckets][bucket_name]
            contents = bucket[:objects].values.map(&:first).sort {|x,y| x['Key'] <=> y['Key']}.reject do |object|
                (prefix    && object['Key'][0...prefix.length] != prefix) ||
                (start_after && object['Key'] <= start_after) ||
                (continuation_token && object['Key'] <= continuation_token) ||
                (delimiter && object['Key'][(prefix ? prefix.length : 0)..-1].include?(delimiter) \
                           && common_prefixes << object['Key'].sub(/^(#{prefix}[^#{delimiter}]+.).*/, '\1')) ||
                object.key?(:delete_marker)
              end.map do |object|
                data = object.reject {|key, value| !['ETag', 'Key', 'StorageClass'].include?(key)}
                data.merge!({
                  'LastModified' => Time.parse(object['Last-Modified']),
                  'Owner'        => fetch_owner ? bucket['Owner'] : nil,
                  'Size'         => object['Content-Length'].to_i
                })
              data
            end
            
            max_keys = max_keys || 1000
            size = [max_keys, 1000].min
            truncated_contents = contents[0...size]
            next_token = truncated_contents.size != contents.size ? truncated_contents.last['Key'] : nil

            response.status = 200
            common_prefixes_uniq = common_prefixes.uniq
            response.body = {
              'CommonPrefixes'  => common_prefixes_uniq,
              'Contents'        => truncated_contents,
              'IsTruncated'     => truncated_contents.size != contents.size,
              'ContinuationToken' => continuation_token,
              'NextContinuationToken' => next_token,
              'KeyCount'        => truncated_contents.size + common_prefixes_uniq.size,
              'MaxKeys'         => max_keys,
              'Name'            => bucket['Name'],
              'Prefix'          => prefix,
              'StartAfter'      => start_after
            }
            if max_keys && max_keys < response.body['Contents'].length
                response.body['IsTruncated'] = true
                response.body['Contents'] = response.body['Contents'][0...max_keys]
                response.body['KeyCount'] = response.body['Contents'].size + response.body['CommonPrefixes'].size
            end
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end
      end
    end
  end
end 