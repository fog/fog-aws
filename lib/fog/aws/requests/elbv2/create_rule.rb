module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/create_rule'
        # Creates a rule for the specified listener.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateRule.html
        #
        # ==== Parameters
        # * listener_id<~:type> - The Amazon Resource Name (ARN) of the listener.
        # * actions<~Array> - List of actions. Each action has the type forward and specifies a target group.
        #   * 'Type'<~String> - The type of action, value is always "forward"
        #   * 'TargetGroupArn'<~String> - The Amazon Resource Name (ARN) of the target group.
        # * conditions<~Array> - List of conditions. Each condition specifies a field name and a single value.
        #   * 'Field'<~String> - Valid values are: "host-header", "path-pattern"
        #   * 'Values'<~Array> - Array of String values.
        #
        # ==== Optional parameters
        # * options<~Hash>:
        #   * :priority<~String> - The priority for the rule. A listener can't have multiple rules with the same priority. Valid Range: Minimum value of 1. Maximum value of 99999.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'CreateRuleResult'<~Hash>:
        #       * 'Rules'<~Array>:
        #         * 'Actions'<~Array> - List of actions. Each action has the type forward and specifies a target group.
        #           * 'Type'<~String> - The type of action, value is always "forward"
        #           * 'TargetGroupArn'<~String> - The Amazon Resource Name (ARN) of the target group.
        #         * 'Conditions'<~Array> - List of conditions. Each condition specifies a field name and a single value.
        #           * 'Field'<~String> - Valid values are: "host-header", "path-pattern"
        #           * 'Values'<~Array> - Array of String values.
        #         * 'IsDefault'<~Boolean> - Indicates whether this is the default rule.
        #         * 'Priority'<~String> - The priority of the rule.
        #         * 'RuleArn'<~String> - The Amazon Resource Name (ARN) of the rule.
        def create_rule(listener_id, actions, conditions, options = {})
          params = {}

          params.merge!(Fog::AWS.serialize_keys('Actions', actions))
          params.merge!(Fog::AWS.serialize_keys('Conditions', conditions))

          request({
                    'Action'      => 'CreateRule',
                    'Priority'    => options[:priority] || 1,
                    'ListenerArn' => listener_id,
                    :parser       => Fog::Parsers::AWS::ELBV2::CreateRule.new
                  }.merge!(params))
        end
      end

      class Mock
        def create_rule(listener_id, actions, conditions, options = {})
          listener = self.data[:load_balancer_listeners][listener_id]
          raise Fog::AWS::ELBV2::NotFound unless listener

          load_balancer = self.data[:load_balancers][listener['LoadBalancerArn']]

          rule_id = Fog::AWS::Mock.arn('elasticloadbalancing', self.data[:owner_id], "listener-rule/app/#{load_balancer['Name']}", @region)
          rule_data = {
            'RuleArn'     => rule_id,
            'Priority'    => options[:priority] || 1,
            'ListenerArn' => listener_id,
            'Actions'     => actions,
            'Conditions'  => conditions
          }

          self.data[:load_balancer_listener_rules] << rule_data

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'CreateRuleResult' => {
              'Rules' => [rule_data]
            }
          }
          response
        end
      end
    end
  end
end
