module Fog
  module AWS
    class Kinesis
      class Real
        # Describes the specified stream.
        #
        # ==== Options
        # * ExclusiveStartShardId<~String>: The shard ID of the shard to start with.
        # * Limit<~Number>: The maximum number of shards to return.
        # * StreamName<~String>: The name of the stream to describe.
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # https://docs.aws.amazon.com/kinesis/latest/APIReference/API_DescribeStream.html
        #
        def describe_stream(options={})
          body = {
            "ExclusiveStartShardId" => options.delete("ExclusiveStartShardId"),
            "Limit" => options.delete("Limit"),
            "StreamName" => options.delete("StreamName")
          }.reject{ |_,v| v.nil? }

          response = request({
                               'X-Amz-Target' => 'Kinesis_20131202.DescribeStream',
                               :body          => body,
                             }.merge(options))
          response.body = Fog::JSON.decode(response.body) unless response.body.nil?
          response
        end
      end

      class Mock
        def describe_streams(options={})
          raise Fog::Mock::NotImplementedError
        end
      end
    end
  end
end
