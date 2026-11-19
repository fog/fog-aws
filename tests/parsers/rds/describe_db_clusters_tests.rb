require 'fog/xml'
require 'fog/aws/parsers/rds/describe_db_clusters'

DESCRIBE_DB_CLUSTERS_RESULT = <<-EOF
<DescribeDBClustersResponse xmlns="http://rds.amazonaws.com/doc/2014-10-31/">
  <DescribeDBClustersResult>
    <DBClusters>
      <DBCluster>
        <DBClusterIdentifier>fog-test-cluster</DBClusterIdentifier>
        <Engine>aurora-mysql</Engine>
        <Status>creating</Status>
        <VpcSecurityGroups>
          <VpcSecurityGroupMembership>
            <VpcSecurityGroupId>sg-0123456789abcdef0</VpcSecurityGroupId>
            <Status>active</Status>
          </VpcSecurityGroupMembership>
        </VpcSecurityGroups>
      </DBCluster>
    </DBClusters>
  </DescribeDBClustersResult>
  <ResponseMetadata>
    <RequestId>6f2f1b2e-4a5b-4c6d-8e9f-0a1b2c3d4e5f</RequestId>
  </ResponseMetadata>
</DescribeDBClustersResponse>
EOF

Shindo.tests('AWS::RDS | parsers | describe_db_clusters', %w[aws rds parser]) do
  parser = Nokogiri::XML::SAX::Parser.new(Fog::Parsers::AWS::RDS::DescribeDBClusters.new)
  parser.parse(DESCRIBE_DB_CLUSTERS_RESULT)
  cluster = parser.document.response['DescribeDBClustersResult']['DBClusters'].first

  tests('cluster Status').returns('creating') do
    cluster['Status']
  end

  tests('VpcSecurityGroups').returns([{ 'VpcSecurityGroupId' => 'sg-0123456789abcdef0', 'Status' => 'active' }]) do
    cluster['VpcSecurityGroups']
  end
end
