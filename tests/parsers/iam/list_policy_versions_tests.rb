require 'fog/xml'
require 'fog/aws/parsers/iam/list_policy_versions'

LIST_POLICY_VERSIONS_RESULT = <<-EOF
<ListPolicyVersionsResponse xmlns="https://iam.amazonaws.com/doc/2010-05-08/">
  <ListPolicyVersionsResult>
    <Versions>
      <member>
        <VersionId>v3</VersionId>
        <IsDefaultVersion>true</IsDefaultVersion>
        <CreateDate>2014-09-17T19:58:34Z</CreateDate>
      </member>
      <member>
        <VersionId>v2</VersionId>
        <IsDefaultVersion>false</IsDefaultVersion>
        <CreateDate>2014-09-15T20:31:58Z</CreateDate>
      </member>
    </Versions>
    <IsTruncated>true</IsTruncated>
    <Marker>EXAMPLEkakv9BCuUNFDtxWSyfzetYwEx2ADc8dnzfvERF5S6YMvXKx41t6gCl</Marker>
  </ListPolicyVersionsResult>
  <ResponseMetadata>
    <RequestId>a8709b2c-3eb4-11e4-8e6e-4d9cfEXAMPLE</RequestId>
  </ResponseMetadata>
</ListPolicyVersionsResponse>
EOF

Shindo.tests('AWS::IAM | parsers | list_policy_versions', %w[aws iam parser]) do
  parser = Nokogiri::XML::SAX::Parser.new(Fog::Parsers::AWS::IAM::ListPolicyVersions.new)
  parser.parse(LIST_POLICY_VERSIONS_RESULT)
  response = parser.document.response

  tests('Versions').returns(%w[v3 v2]) do
    response['Versions'].map { |version| version['VersionId'] }
  end

  tests('IsTruncated').returns(true) do
    response['IsTruncated']
  end

  tests('Marker').returns('EXAMPLEkakv9BCuUNFDtxWSyfzetYwEx2ADc8dnzfvERF5S6YMvXKx41t6gCl') do
    response['Marker']
  end

  tests('RequestId').returns('a8709b2c-3eb4-11e4-8e6e-4d9cfEXAMPLE') do
    response['RequestId']
  end
end
