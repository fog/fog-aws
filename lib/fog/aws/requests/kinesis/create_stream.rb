module Fog
  module AWS
    class Kinesis
      class Real
        # Creates a Amazon Kinesis stream.
        #
        # ==== Options
        # * ShardCount<~Number>: The number of shards that the stream will use.
        # * StreamName<~String>: A name to identify the stream.
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # https://docs.aws.amazon.com/kinesis/latest/APIReference/API_CreateStream.html
        #
        def create_stream(options={})
          body = {
            "ShardCount" => options.delete("ShardCount") || 1,
            "StreamName" => options.delete("StreamName")
          }.reject{ |_,v| v.nil? }

          response = request({
                               'X-Amz-Target' => 'Kinesis_#{@version}.CreateStream',
                               :body          => body,
                             }.merge(options))
          # response.body = Fog::JSON.decode(response.body) unless response.body.nil?
          response
        end
      end

      class Mock
        def create_streams(options={})
          raise Fog::Mock::NotImplementedError
        end
      end
    end
  end
end
