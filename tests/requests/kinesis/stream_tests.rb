Shindo.tests('AWS::Kinesis | stream requests', ['aws', 'kinesis']) do
  tests('success') do
    @list_streams_format = {
      "HasMoreStreams" => Fog::Boolean,
      "StreamNames" => [
        String
      ]
    }

    tests("#list_streams").formats(@list_streams_format) do
      Fog::AWS[:kinesis].list_streams.body
    end
  end
end
