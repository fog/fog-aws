module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/modify_rule'

        # Modifies the specified rule. Any existing properties that you do not modify retain their current values.
        #
        # ==== Parameters
        # * rule_id<~String> - The Amazon Resource Name (ARN) of the rule.
        # * actions<~Array> - List of actions. Each action has the type forward and specifies a target group.
        #   * 'Type'<~String> - The type of action, value is always "forward"
        #   * 'TargetGroupArn'<~String> - The Amazon Resource Name (ARN) of the target group.
        # * conditions<~Array> - List of conditions. Each condition specifies a field name and a single value.
        #   * 'Field'<~String> - Valid values are: "host-header", "path-pattern"
        #   * 'Values'<~Array> - Array of String values.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'ModifyRuleResult'<~Hash>:
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
        def modify_rule(rule_id, actions, conditions)
          params = {}

          params.merge!(Fog::AWS.serialize_keys('Actions', actions))
          params.merge!(Fog::AWS.serialize_keys('Conditions', conditions))

          request({
            'Action' => 'ModifyRule',
            'RuleArn' => rule_id,
            :parser => Fog::Parsers::AWS::ELBV2::ModifyRule.new
          }.merge(params))
        end
      end

      class Mock
        def modify_rule(rule_id, actions, conditions)
          response = Excon::Response.new
          response.status = 200

          changed_rule = nil
          self.data[:load_balancer_listener_rules].map! do |rule|
            if rule['RuleArn'] == rule_id
              rule['Actions'] = actions
              rule['Conditions'] = conditions
              changed_rule = rule
            end
            rule
          end
          raise Fog::AWS::ELB::NotFound unless changed_rule

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'ModifyRuleResult' => {
              'Rules' => [changed_rule]
            }
          }
          response
        end
      end
    end
  end
end
