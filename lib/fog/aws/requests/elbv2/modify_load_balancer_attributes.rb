module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/modify_load_balancer_attributes'

        # Modifies the specified attributes of the specified Application Load Balancer.
        # If any of the specified attributes can't be modified as requested, the call fails. Any existing attributes that you do not modify retain their current values.
        #
        # ==== Parameters
        # * lb_id<~String> - The Amazon Resource Name (ARN) of the load balancer.
        # * attributes<~Hash> - The attributes to apply.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'ModifyLoadBalancerAttributesResult'<~Hash>:
        #       * 'Attributes'<~Hash> - Information about the load balancer attributes.
        #         * 'access_logs.s3.enabled'<~Boolean> - Indicates whether access logs stored in Amazon S3 are enabled.
        #         * 'access_logs.s3.bucket'<~String> - The name of the S3 bucket for the access logs. This attribute is required if access logs in Amazon S3 are enabled. The bucket must exist in the same region as the load balancer and have a bucket policy that grants Elastic Load Balancing permission to write to the bucket.
        #         * 'access_logs.s3.prefix'<~String> - The prefix for the location in the S3 bucket. If you don't specify a prefix, the access logs are stored in the root of the bucket.
        #         * 'deletion_protection.enabled'<~Boolean> - Indicates whether deletion protection is enabled.
        #         * 'idle_timeout.timeout_seconds'<~Integer> - The idle timeout value, in seconds. The valid range is 1-3600. The default is 60 seconds.
        def modify_load_balancer_attributes(lb_id, attributes)
          attributes = Fog::AWS.serialize_keys 'Attributes', attributes.map{ |property, value| { :Key => property, :Value => value } }
          request(attributes.merge(
            'Action'           => 'ModifyLoadBalancerAttributes',
            'LoadBalancerArn'  => lb_id,
            :parser            => Fog::Parsers::AWS::ELBV2::ModifyLoadBalancerAttributes.new
          ))
        end
      end

      class Mock
        def modify_load_balancer_attributes(lb_id, attributes)
          load_balancer = self.data[:load_balancers][lb_id]
          raise Fog::AWS::ELBV2::NotFound unless load_balancer

          load_balancer[:attributes].merge!(attributes)

          response = Excon::Response.new

          response.status = 200
          response.body = {
            "ResponseMetadata" => {
              "RequestId" => Fog::AWS::Mock.request_id
            },
            'ModifyLoadBalancerAttributesResult' => {
              'Attributes' => load_balancer[:attributes]
            }
          }

          response
        end
      end
    end
  end
end
