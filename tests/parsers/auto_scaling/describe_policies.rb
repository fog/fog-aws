require 'fog/xml'
require 'fog/aws/parsers/auto_scaling/describe_policies'

DESCRIBE_POLICIES_RESULT = <<-EOF
<DescribePoliciesResponse xmlns="http://autoscaling.amazonaws.com/doc/2011-01-01/">
  <DescribePoliciesResult>
    <ScalingPolicies>
      <member>
        <PolicyARN>arn:aws:autoscaling:us-east-1:123456789012:scalingPolicy:c322761b-3172-4d56-9a21-0ed9dEXAMPLE:autoScalingGroupName/my-asg:policyName/MyScaleDownPolicy</PolicyARN>
        <AdjustmentType>ChangeInCapacity</AdjustmentType>
        <ScalingAdjustment>-1</ScalingAdjustment>
        <PolicyName>MyScaleDownPolicy</PolicyName>
        <PolicyType>SimpleScaling</PolicyType>
        <AutoScalingGroupName>my-asg</AutoScalingGroupName>
        <Cooldown>60</Cooldown>
        <Alarms>
          <member>
            <AlarmName>TestQueue</AlarmName>
            <AlarmARN>arn:aws:cloudwatch:us-east-1:123456789012:alarm:TestQueue</AlarmARN>
          </member>
        </Alarms>
      </member>
      <member>
        <PolicyARN>arn:aws:autoscaling:us-east-1:123456789012:scalingPolicy:c55a5cdd-9be0-435b-b60b-a8dd3EXAMPLE:autoScalingGroupName/my-asg:policyName/MyScaleUpPolicy</PolicyARN>
        <AdjustmentType>ChangeInCapacity</AdjustmentType>
        <StepAdjustments>
          <member>
            <MetricIntervalLowerBound>0</MetricIntervalLowerBound>
            <ScalingAdjustment>1</ScalingAdjustment>
          </member>
        </StepAdjustments>
        <PolicyName>MyScaleUpPolicy</PolicyName>
        <PolicyType>StepScaling</PolicyType>
        <AutoScalingGroupName>my-asg</AutoScalingGroupName>
        <EstimatedInstanceWarmup>120</EstimatedInstanceWarmup>
        <MetricAggregationType>Average</MetricAggregationType>
        <Alarms>
          <member>
            <AlarmName>TestQueue</AlarmName>
            <AlarmARN>arn:aws:cloudwatch:us-east-1:123456789012:alarm:TestQueue</AlarmARN>
          </member>
        </Alarms>
      </member>
      <member>
        <PolicyARN>arn:aws:autoscaling:us-east-1:123456789012:scalingPolicy:c55a5cdd-9be0-435b-b23b-a8dd3EXAMPLE:autoScalingGroupName/my-asg:policyName/MyScaleUpTargetPolicy</PolicyARN>
        <PolicyName>MyScaleUpTargetPolicy</PolicyName>
        <PolicyType>TargetTrackingScaling</PolicyType>
        <AutoScalingGroupName>my-asg</AutoScalingGroupName>
        <EstimatedInstanceWarmup>120</EstimatedInstanceWarmup>
        <TargetTrackingConfiguration>
          <PredefinedMetricSpecification>
            <PredefinedMetricType>ASGAverageCPUUtilization</PredefinedMetricType>
          </PredefinedMetricSpecification>
          <TargetValue>50</TargetValue>
          <DisableScaleIn>true</DisableScaleIn>
        </TargetTrackingConfiguration>
      </member>
    </ScalingPolicies>
  </DescribePoliciesResult>
  <ResponseMetadata>
    <RequestId>a6ea2117-fac1-11e2-abd3-1740ab4ef14e</RequestId>
  </ResponseMetadata>
</DescribePoliciesResponse>
EOF

Shindo.tests('AWS::Autoscaling | parsers | describe_policies', ['aws', 'auto_scaling', 'parser']) do
  tests('parses the xml').formats(AWS::AutoScaling::Formats::DESCRIBE_POLICIES) do
    parser = Nokogiri::XML::SAX::Parser.new(Fog::Parsers::AWS::AutoScaling::DescribePolicies.new)
    parser.parse(DESCRIBE_POLICIES_RESULT)
    parser.document.response
  end
end
