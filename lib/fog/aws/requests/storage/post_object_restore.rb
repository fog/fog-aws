module Fog
  module AWS
    class Storage
      class Real
        # Restore an object from Glacier to its original S3 path
        #
        # @param bucket_name [String] Name of bucket containing object
        # @param object_name [String] Name of object to restore
        # @param options [Hash] Optional parameters
        # @option options [Integer] :days Number of days to restore object for. Defaults to 100000 (a very long time)
        # @option options [String] :tier Glacier retrieval tier. Can be 'Standard', 'Bulk', or 'Expedited'
        #
        # @return [Excon::Response] response:
        #   * status [Integer] 200 (OK) Object is previously restored
        #   * status [Integer] 202 (Accepted) Object is not previously restored
        #   * status [Integer] 409 (Conflict) Restore is already in progress
        #
        # @see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPOSTrestore.html
        #
        def post_object_restore(bucket_name, object_name, options = {})
          raise ArgumentError.new('bucket_name is required') unless bucket_name
          raise ArgumentError.new('object_name is required') unless object_name

          unless options.is_a?(Hash)
            Fog::Logger.deprecation("post_object_restore with a bare days parameter is deprecated, use post_object_restore(bucket_name, object_name, :days => days) instead [light_black](#{caller.first})[/]")
            options = { :days => options }
          end

          days = options[:days] || 100000
          tier = options[:tier]

          data = '<RestoreRequest xmlns="http://s3.amazonaws.com/doc/2006-03-01/">'
          data += '<Days>' + days.to_s + '</Days>'
          if tier
            data += '<GlacierJobParameters><Tier>' + tier + '</Tier></GlacierJobParameters>'
          end
          data += '</RestoreRequest>'

          headers = {}
          headers['Content-MD5'] = Base64.encode64(OpenSSL::Digest::MD5.digest(data)).strip
          headers['Content-Type'] = 'application/xml'
          headers['Date'] = Fog::Time.now.to_date_header

          request({
            :headers  => headers,
            :bucket_name => bucket_name,
            :expects  => [200, 202, 409],
            :body     => data,
            :method   => 'POST',
            :query    => {'restore' => nil},
            :object_name  => object_name
          })
        end
      end

      class Mock # :nodoc:all
        def post_object_restore(bucket_name, object_name, options = {})
          unless options.is_a?(Hash)
            Fog::Logger.deprecation("post_object_restore with a bare days parameter is deprecated, use post_object_restore(bucket_name, object_name, :days => days) instead [light_black](#{caller.first})[/]")
            options = { :days => options }
          end
          
          response = get_object(bucket_name, object_name)
          response.body = nil
          response
        end
      end
    end
  end
end
