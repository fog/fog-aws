Shindo.tests('Aws::Elasticache | describe cache cluster events',
  ['aws', 'elasticache']) do

  tests('success') do
    pending if Fog.mocking?

    tests(
    '#describe_events'
    ).formats(Aws::Elasticache::Formats::EVENT_LIST) do
      Aws[:elasticache].describe_events().body['Events']
    end
  end

  tests('failure') do
    # TODO:
  end
end
