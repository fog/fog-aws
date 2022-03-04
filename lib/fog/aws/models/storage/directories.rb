require 'fog/aws/models/storage/directory'

module Fog
  module AWS
    class Storage
      class Directories < Fog::Collection
        model Fog::AWS::Storage::Directory

        def all
          data = service.get_service.body['Buckets']
          load(data)
        end

        def get(key, options = {})
          remap_attributes(options, {
            :delimiter  => 'delimiter',
            :marker     => 'marker',
            :max_keys   => 'max-keys',
            :prefix     => 'prefix'
          })
          data = service.get_bucket(key, options).body
          directory = new(:key => data['Name'], :is_persisted => true)
          options = {}
          for k, v in data
            if ['CommonPrefixes', 'Delimiter', 'IsTruncated', 'Marker', 'MaxKeys', 'Prefix'].include?(k)
              options[k] = v
            end
          end
          directory.files.merge_attributes(options)
          directory.files.load(data['Contents'])
          directory
        rescue Excon::Errors::NotFound
          nil
        end
        # **Warning!** `s3.directories.get` retrieves and caches meta data for the first 10,000 objects in the bucket, which can be very expensive. When possible use `s3.directories.new`.
      end
    end
  end
end
