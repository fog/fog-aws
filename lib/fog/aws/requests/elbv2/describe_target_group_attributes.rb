module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_target_group_attributes'

        # Describes the attributes for the specified target group.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_DescribeTargetGroupAttributes.html
        #
        # ==== Parameters
        # * tg_id<~String> - The Amazon Resource Name (ARN) of the target group.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeTargetGroupAttributesResult'<~Hash>:
        #       * 'Attributes'<~Hash> - Information about the target group attributes
        #         * 'deregistration_delay.timeout_seconds'<~Integer> - The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds.
        #         * 'stickiness.enabled'<~Boolean> - Indicates whether sticky sessions are enabled.
        #         * 'stickiness.type'<~String> - The type of sticky sessions. The possible value is lb_cookie.
        #         * 'stickiness.lb_cookie.duration_seconds'<~Integer> - The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds).
        def describe_target_group_attributes(tg_id)
          request({
            'Action' => 'DescribeTargetGroupAttributes',
            'TargetGroupArn' => tg_id,
            :parser => Fog::Parsers::AWS::ELBV2::DescribeTargetGroupAttributes.new
          })
        end
      end

      class Mock
        def describe_target_group_attributes(tg_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeTargetGroupAttributesResult' => {
              'Attributes' => self.data[:target_groups][tg_id][:attributes]
            }
          }
          response
        end
      end
    end
  end
end
