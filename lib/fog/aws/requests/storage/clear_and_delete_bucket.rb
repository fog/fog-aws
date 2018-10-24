module Fog
  module AWS
    class Storage
      class Real
        # Deletes all objects and versioned objects from this bucket and then deletes the bucket.
        #
        # @param bucket_name [String] name of bucket to delete cors rules from
        # @param options [Hash] (defaults to: { }) — a customizable set of options
        # Options Hash (options):
        # :max_attempts (Integer) — default: 3 — Maximum number of times to attempt to delete the empty bucket before raising Aws::S3::Errors::BucketNotEmpty.
        # :initial_wait (Float) — default: 1.3 — Seconds to wait before retrying the call to delete the bucket, exponentially increased for each attempt.

        def clear_and_delete_bucket(bucket_name, options = {})
          options = {
            initial_wait: 1.3,
            max_attempts: 3,
          }.merge(options)

          attempts = 0
          begin
            clear!(bucket_name)
            Fog::Storage[:aws].delete_bucket(bucket_name)
          rescue Errors::BucketNotEmpty
            attempts += 1
            if attempts >= options[:max_attempts]
              raise
            else
              Kernel.sleep(options[:initial_wait] ** attempts)
              retry
            end
          end
        end

        def clear!(bucket_name)
          Fog::Storage[:aws].get_bucket_object_versions(bucket_name).body['Versions'].each do |version|
            object = version[version.keys.first]
            Fog::Storage[:aws].delete_object(bucket_name, object['Key'], 'versionId' => object['VersionId'])
          end
        end
      end
    end
  end
end
