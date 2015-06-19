Shindo.tests('AWS::Kinesis | stream requests', ['aws', 'kinesis']) do
  @stream_id = 'fog-test-stream'

  tests('success') do
    wait_for_delete = lambda {
      begin
        while Fog::AWS[:kinesis].describe_stream("StreamName" => @stream_id).body["StreamDescription"]["StreamStatus"] == "DELETING"
          sleep 1
          print '.'
        end
      rescue Excon::Errors::BadRequest; end
    }

    # ensure we start from a clean slate
    if Fog::AWS[:kinesis].list_streams.body["StreamNames"].include?(@stream_id)
      wait_for_delete.()
      begin
        Fog::AWS[:kinesis].delete_stream("StreamName" => @stream_id)
        wait_for_delete.()
      rescue Excon::Errors::BadRequest; end
    end

    @list_streams_format = {
      "HasMoreStreams" => Fog::Boolean,
      "StreamNames" => [
        String
      ]
    }

    # optional keys are commented out
    @describe_stream_format = {
      "StreamDescription" => {
        "HasMoreShards" => Fog::Boolean,
        "Shards" => [
          {
            #"AdjacentParentShardId" => String,
            "HashKeyRange" => {
              "EndingHashKey" => String,
              "StartingHashKey" => String
            },
            #"ParentShardId" => String,
            "SequenceNumberRange" => {
              # "EndingSequenceNumber" => String,
              "StartingSequenceNumber" => String
            },
            "ShardId" => String
          }
        ],
        "StreamARN" => String,
        "StreamName" => String,
        "StreamStatus" => String
      }
    }

    tests("#create_stream").returns("") do
      Fog::AWS[:kinesis].create_stream("StreamName" => @stream_id).body
    end

    tests("#list_streams").formats(@list_streams_format, false) do
      Fog::AWS[:kinesis].list_streams.body
    end

    tests("#describe_stream").formats(@describe_stream_format) do
      Fog::AWS[:kinesis].describe_stream("StreamName" => @stream_id).body
    end

    tests("#delete_stream").returns("") do
      Fog::AWS[:kinesis].delete_stream("StreamName" => @stream_id).body
    end

  end
end
