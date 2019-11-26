class AWS
  module ELBV2
    module Formats
      BASIC = {
        'ResponseMetadata' => {'RequestId' => String}
      }

      LOAD_BALANCER = {
        "AvailabilityZones" => [{
          "SubnetId" => String, "ZoneName" => String,
          "LoadBalancerAddresses" => [Fog::Nullable::Hash]
        }],
        "LoadBalancerArn" => String,
        "DNSName" => String,
        "CreatedTime" => Time,
        "LoadBalancerName" => String,
        "VpcId" => String,
        "CanonicalHostedZoneId" => String,
        "Scheme" => String,
        "Type" => String,
        "State" => {"Code" => String},
        "SecurityGroups" => [Fog::Nullable::String]
      }

      DESCRIBE_LOAD_BALANCERS = BASIC.merge({
        'DescribeLoadBalancersResult' => {'LoadBalancers' => [LOAD_BALANCER], 'NextMarker' => Fog::Nullable::String}
      })

      CREATE_LOAD_BALANCER = BASIC.merge({
        'CreateLoadBalancerResult' => {'LoadBalancers' => [LOAD_BALANCER], 'NextMarker' => Fog::Nullable::String}
      })

      LISTENER = {
        "LoadBalancerArn" => String,
        "Protocol" => String,
        "Port" => String,
        "ListenerArn" => String,
        "DefaultActions" => [{"Type" => String, "TargetGroupArn" => String}],
        "Certificates" => [{"CertificateArn" => String}]
      }

      DESCRIBE_LISTENERS = BASIC.merge({
        'DescribeListenersResult' => {'Listeners' => [LISTENER], 'NextMarker' => Fog::Nullable::String}
      })
    end
  end
end
