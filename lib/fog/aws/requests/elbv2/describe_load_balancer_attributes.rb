module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_load_balancer_attributes'

        # Describes the attributes for the specified Application Load Balancer.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_DescribeLoadBalancerAttributes.html
        #
        # ==== Parameters
        # * lb_id<~String> - The Amazon Resource Name (ARN) of the load balancer.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeLoadBalancerAttributesResult'<~Hash>:
        #       * 'Attributes'<~Hash>: Information about the load balancer attributes.
        #         * 'access_logs.s3.enabled'<~Boolean> - Indicates whether access logs stored in Amazon S3 are enabled.
        #         * 'access_logs.s3.bucket'<~String> - The name of the S3 bucket for the access logs. This attribute is required if access logs in Amazon S3 are enabled. The bucket must exist in the same region as the load balancer and have a bucket policy that grants Elastic Load Balancing permission to write to the bucket.
        #         * 'access_logs.s3.prefix'<~String> - The prefix for the location in the S3 bucket. If you don't specify a prefix, the access logs are stored in the root of the bucket.
        #         * 'deletion_protection.enabled'<~Boolean> - Indicates whether deletion protection is enabled.
        #         * 'idle_timeout.timeout_seconds'<~Integer> - The idle timeout value, in seconds. The valid range is 1-3600. The default is 60 seconds.
        def describe_load_balancer_attributes(lb_id)
          request({
            'Action'  => 'DescribeLoadBalancerAttributes',
            'LoadBalancerArn' => lb_id,
            :parser   => Fog::Parsers::AWS::ELBV2::DescribeLoadBalancerAttributes.new
          })
        end
      end

      class Mock
        def describe_load_balancer_attributes(lb_id = nil, names = [])
          load_balancer = self.data[:load_balancers][lb_id]
          raise Fog::AWS::ELBV2::NotFound unless load_balancer

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeLoadBalancerAttributesResult' => {
              'Attributes' => load_balancer[:attributes]
            }
          }

          response
        end
      end
    end
  end
end
