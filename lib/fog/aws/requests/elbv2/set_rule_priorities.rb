module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/set_rule_priorities'

        # Sets the priorities of the specified rules.
        # You can reorder the rules as long as there are no priority conflicts in the new order. Any existing rules that you do not specify retain their current priority.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_SetRulePriorities.html
        #
        # ==== Parameters
        # * rule_priorities<~Hash> - The rule priorities. Rule ARN => Priority.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'SetRulePrioritiesResult'<~Hash>:
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
        def set_rule_priorities(rule_priorities)
          params = {}
          rule_priority_pairs = rule_priorities.map { |rule_id, priority|
            { 'RuleArn' => rule_id, 'Priority' =>  priority}
          }
          params.merge!(Fog::AWS.serialize_keys('RulePriorities', rule_priority_pairs))
          request({
                    'Action'            => 'SetRulePriorities',
                    :parser             => Fog::Parsers::AWS::ELBV2::SetRulePriorities.new
                  }.merge!(params))
        end
      end

      class Mock
        def set_rule_priorities(rule_priorities)
          changed_rules = self.data[:load_balancer_listener_rules].select { |rule|
            new_priority = rule_priorities[rule['RuleArn']]
            if new_priority
              rule['Priority'] = new_priority
            end
            new_priority
          }
          if changed_rules.size != rule_priorities.size
            raise Fog::AWS::ELBV2::NotFound
          end

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'SetRulePrioritiesResult' => {
              'Rules' => changed_rules
            }
          }
          response
        end
      end
    end
  end
end
