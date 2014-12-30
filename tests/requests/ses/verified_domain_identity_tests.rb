Shindo.tests('Aws::SES | verified domain identity requests', ['aws', 'ses']) do

  tests('success') do

    tests("#verify_domain_identity('example.com')").formats(Aws::SES::Formats::BASIC) do
      pending if Fog.mocking?
      Fog::AWS[:ses].verify_domain_identity('example.com').body
    end

  end

  tests('failure') do

  end

end
