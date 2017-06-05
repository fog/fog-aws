class AWS
  module ELBV2
    module Formats
      BASIC = {
        'ResponseMetadata' => {'RequestId' => String}
      }

      DESCRIBE_ACCOUNT_LIMITS = BASIC.merge(
        'DescribeAccountLimitsResult' => {
          'Limits' => Hash
        }
      )

      SSL_POLICY = {
        'Ciphers' => [{ 'Name' => String, 'Priority' => Integer }],
        'Name' => String,
        'SslProtocols' => [String]
      }
      DESCRIBE_SSL_POLICIES = BASIC.merge(
        'DescribeSSLPoliciesResult' => { 'SslPolicies' => [SSL_POLICY] }
      )

      TARGET_GROUP = {
        'TargetGroupArn' => String,
        'TargetGroupName' => String,
        'Protocol' => String,
        'Port' => Integer,
        'VpcId' => String,
        'Matcher.HttpCode' => String,
        'HealthCheckIntervalSeconds' => Integer,
        'HealthCheckPath' => String,
        'HealthCheckPort' => String,
        'HealthCheckProtocol' => String,
        'HealthCheckTimeoutSeconds' => Integer,
        'HealthyThresholdCount' => Integer,
        'UnhealthyThresholdCount' => Integer,
        'LoadBalancerArns' => [String]
      }

      CREATE_TARGET_GROUP = BASIC.merge(
        'CreateTargetGroupResult' => { 'TargetGroups' => [TARGET_GROUP] }
      )
      DESCRIBE_TARGET_GROUPS = BASIC.merge(
        'DescribeTargetGroupsResult' => { 'TargetGroups' => [TARGET_GROUP] }
      )
      DESCRIBE_TARGET_GROUP_ATTRIBUTES = BASIC.merge(
        'DescribeTargetGroupAttributesResult' => { 'Attributes' => Hash }
      )

      LOAD_BALANCER = {
        'LoadBalancerArn' => String,
        'AvailabilityZones' => Hash,
        'CanonicalHostedZoneId' => String,
        'CreatedTime' => String,
        'DNSName' => String,
        'IpAddressType' => String,
        'LoadBalancerName' => String,
        'Scheme' => String,
        'SecurityGroups' => [String],
        'State' => {
          'Code' => String,
          'Reason' => Fog::Nullable::String
        },
        'Type' => String,
        'VpcId' => String
      }

      ACTION = {
        'Type' => String,
        'TargetGroupArn' => String
      }

      CONDITION = {
        'Field' => String,
        'Values' => [String]
      }

      LISTENER = {
        'ListenerArn' => String,
        'Certificates' => [{'CertificateArn' => String}],
        'DefaultActions' => [ACTION],
        'LoadBalancerArn' => String,
        'Port' => String,
        'Protocol' => String,
        'SslPolicy' => Fog::Nullable::String
      }

      DESCRIBE_LISTENERS = BASIC.merge(
        'DescribeListenersResult' => { 'Listeners' => [LISTENER] }
      )

      RULE = {
        'RuleArn' => String,
        'IsDefault' => Fog::Boolean,
        'Priority' => String,
        'Actions' => [ACTION],
        'Conditions' => [CONDITION]
      }

      TARGET_HEALTH_DESCRIPTION = {
        'HealthCheckPort' => String,
        'Target' => { 'Id' => String, 'Port' => Integer },
        'TargetHealth' => {
          'Description' => Fog::Nullable::String,
          'Reason' => Fog::Nullable::String,
          'State' => String
        }
      }

      DESCRIBE_TARGET_HEALTH = BASIC.merge(
        'DescribeTargetHealthResult' => { 'TargetHealthDescriptions' => [TARGET_HEALTH_DESCRIPTION] }
      )

      CREATE_LOAD_BALANCER = BASIC.merge(
        'CreateLoadBalancerResult' => { 'LoadBalancers' => [LOAD_BALANCER] }
      )

      DESCRIBE_LOAD_BALANCERS = BASIC.merge(
        'DescribeLoadBalancersResult' => {'LoadBalancers' => [LOAD_BALANCER], 'NextMarker' => Fog::Nullable::String}
      )
      DESCRIBE_LOAD_BALANCER_ATTRIBUTES = BASIC.merge(
        'DescribeLoadBalancerAttributesResult' => {'Attributes' => Hash}
      )

      DELETE_LOAD_BALANCER = BASIC.merge(
        'DeleteLoadBalancerResult' =>  NilClass
      )
    end
  end
end
