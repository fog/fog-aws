module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/modify_target_group_attributes'

        # Modifies the specified attributes of the specified target group.
        #
        # ==== Parameters
        # * tg_id<~String> - The Amazon Resource Name (ARN) of the target group.
        # * attributes<~Hash> - The attributes to apply.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'ModifyTargetGroupAttributesResult'<~Hash>:
        #       * 'Attributes'<~Hash> - Information about the target group attributes
        #         * 'deregistration_delay.timeout_seconds'<~Integer> - The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds.
        #         * 'stickiness.enabled'<~Boolean> - Indicates whether sticky sessions are enabled.
        #         * 'stickiness.type'<~String> - The type of sticky sessions. The possible value is lb_cookie.
        #         * 'stickiness.lb_cookie.duration_seconds'<~Integer> - The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds).
        def modify_target_group_attributes(tg_id, attributes)
          params = {}
          params.merge!(Fog::AWS.indexed_param('Attributes.member', attributes))
          request({
            'Action' => 'ModifyTargetGroupAttributes',
            'TargetGroupArn' => tg_id,
            :parser => Fog::Parsers::AWS::ELBV2::ModifyTargetGroupAttributes.new
          }.merge(params))
        end
      end

      class Mock
        def modify_target_group_attributes(tg_id, attributes)
          target_group = self.data[:target_groups][tg_id]
          raise Fog::AWS::ELBV2::NotFound unless target_group

          target_group[:attributes].merge!(attributes.inject({}) { |acc, pair| acc[pair['Key']] = pair['Value']; acc })

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'ModifyTargetGroupAttributesResult' => {
              'Attributes' => target_group[:attributes]
            }
          }
          response
        end
      end
    end
  end
end
