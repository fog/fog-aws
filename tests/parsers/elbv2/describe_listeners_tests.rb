require 'fog/xml'
require 'fog/aws/parsers/elbv2/describe_listeners'

DESCRIBE_LISTENERS_RESULT = <<-EOF
<DescribeListenersResponse xmlns="http://elasticloadbalancing.amazonaws.com/doc/2015-12-01/">
  <DescribeListenersResult>
    <Listeners>
      <member>
        <LoadBalancerArn>arn:aws:elasticloadbalancing:us-west-2:123456789012:loadbalancer/app/my-load-balancer/50dc6c495c0c9188</LoadBalancerArn>
        <Protocol>HTTP</Protocol>
        <Port>80</Port>
        <ListenerArn>arn:aws:elasticloadbalancing:us-west-2:123456789012:listener/app/my-load-balancer/50dc6c495c0c9188/f2f7dc8efc522ab2</ListenerArn>
        <DefaultActions>
          <member>
            <Type>forward</Type>
            <TargetGroupArn>arn:aws:elasticloadbalancing:us-west-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067</TargetGroupArn>
          </member>
        </DefaultActions>
      </member>
    </Listeners>
  </DescribeListenersResult>
  <ResponseMetadata>
    <RequestId>18e470d3-f39c-11e5-a53c-67205c0d10fd</RequestId>
  </ResponseMetadata>
</DescribeListenersResponse>
EOF

Shindo.tests('AWS::ELBV2 | parsers | describe_listeners', %w[aws elb parser]) do
  tests('parses the xml').formats(AWS::ELBV2::Formats::DESCRIBE_LISTENERS) do
    parser = Nokogiri::XML::SAX::Parser.new(Fog::Parsers::AWS::ELBV2::DescribeListeners.new)
    parser.parse(DESCRIBE_LISTENERS_RESULT)
    parser.document.response
  end
end
