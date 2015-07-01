module Fog
  module AWS
    class Kinesis
      class Real
        def put_record(options={})
          body = {
            "Data" => options.delete("Data"),
            "ExplicitHashKey" => options.delete("ExplicitHashKey"),
            "PartitionKey" => options.delete("PartitionKey"),
            "SequenceNumberForOrdering" => options.delete("SequenceNumberForOrdering"),
            "StreamName" => options.delete("StreamName")
          }.reject{ |_,v| v.nil? }

          response = request({
                               'X-Amz-Target' => "Kinesis_#{@version}.PutRecord",
                               :body          => body,
                             }.merge(options))
          response.body = Fog::JSON.decode(response.body) unless response.body.nil?
          response
        end
      end
      class Mock
        def put_record(options={})
          stream_name = options.delete("StreamName")

          unless stream = data[:kinesis_streams].detect{ |s| s["StreamName"] == stream_name }
            raise 'unknown stream'
          end

          sequence_number = next_sequence_number.to_s
          data = options.delete("Data")
          partition_key = options.delete("PartitionKey")

          sample_method = RUBY_VERSION == "1.8.7" ? :choice : :sample
          shard_id = stream["Shards"].send(sample_method)["ShardId"]
          shard = stream["Shards"].detect{ |shard| shard["ShardId"] == shard_id }
          # store the records on the shard(s)
          shard["Records"] << {
            "SequenceNumber" => sequence_number,
            "Data" => data,
            "PartitionKey" => partition_key
          }

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "SequenceNumber" => sequence_number,
            "ShardId" => shard_id
          }
          response
        end
      end
    end
  end
end
