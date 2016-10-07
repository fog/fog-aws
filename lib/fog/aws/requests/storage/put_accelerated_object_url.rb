module Fog
  module Storage
    class AWS
      module PutAcceleratedObjectUrl
        def put_accelerated_object_url(object_name, expires, headers = {}, options = {})
          unless object_name
            raise ArgumentError.new('object_name is required')
          end
          signed_url(options.merge({
            :object_name => object_name,
            :method   => 'PUT',
            :headers  => headers,
          }), expires)
        end
      end

      class Real
        # Get an expiring object url from S3 for putting an object using
        # AWS Transfer Acceleration
        #
        # @param object_name [String] Name of object to get expiring url for
        # @param expires [Time] An expiry time for this url
        #
        # @return [Excon::Response] response:
        #   * body [String] url for object
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/dev/S3_QSAuth.html
        # @see https://aws.amazon.com/blogs/aws/aws-storage-update-amazon-s3-transfer-acceleration-larger-snowballs-in-more-regions/

        include PutAcceleratedObjectUrl
      end

      class Mock # :nodoc:all
        include PutAcceleratedObjectUrl
      end

    end
  end
end
