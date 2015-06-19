module Fog
  module AWS
    class Kinesis
      class Real
        # Deletes a stream and all its shards and data.
        #
        # ==== Options
        # * StreamName<~String>: A name to identify the stream.
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # https://docs.aws.amazon.com/kinesis/latest/APIReference/API_DeleteStream.html
        #
        def delete_stream(options={})
          body = {
            "StreamName" => options.delete("StreamName")
          }.reject{ |_,v| v.nil? }

          response = request({
                               'X-Amz-Target' => 'Kinesis_20131202.DeleteStream',
                               :body          => body,
                             }.merge(options))
          # response.body = Fog::JSON.decode(response.body) unless response.body.nil?
          response
        end
      end

      class Mock
        def delete_streams(options={})
          raise Fog::Mock::NotImplementedError
        end
      end
    end
  end
end
