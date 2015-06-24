module Fog
  module AWS
    class Kinesis
      class Real
        # Gets data records from a shard.
        #
        # ==== Options
        # * Limit<~Number>: he maximum number of records to return.
        # * ShardIterator<~String>: The position in the shard from which you want to start sequentially reading data records.
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # https://docs.aws.amazon.com/kinesis/latest/APIReference/API_GetRecords.html
        #
        def get_records(options={})
          body = {
            "Limit" => options.delete("Limit"),
            "ShardIterator" => options.delete("ShardIterator")
          }.reject{ |_,v| v.nil? }

          response = request({
                               :idempotent    => true,
                               'X-Amz-Target' => 'Kinesis_#{@version}.GetRecords',
                               :body          => body,
                             }.merge(options))
          response.body = Fog::JSON.decode(response.body) unless response.body.nil?
          response
        end
      end

      class Mock
        def get_records(options={})
          raise Fog::Mock::NotImplementedError
        end
      end
    end
  end
end
