Shindo.tests('Aws::RDS | describe DB events requests',['aws', 'rds']) do

  tests('success') do
    pending if Fog.mocking?

    tests(
    '#describe_events'
    ).formats(Aws::RDS::Formats::EVENT_LIST) do
      Aws[:rds].describe_events().body['Events']
    end
  end

  tests('failure') do
    #TODO: What constitutes a failure here?
  end
end
