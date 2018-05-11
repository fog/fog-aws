module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_rules'

        # Describes the specified rules or the rules for the specified listener. You must specify either a listener or one or more rules.
        #
        # ==== Parameters
        # * listener_id<~String> - The Amazon Resource Name (ARN) of the listener.
        # * rule_ids<~Array> - The Amazon Resource Names (ARN) of the rules. Array of strings.
        # * options<~Hash>
        #   * :marker<~String> - The marker for the next set of results.
        #   * :page_size<~Integer> - The maximum number of results to return with this call. Range is 1...400.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeRulesResult'<~Hash>:
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
        #     * 'NextMarker'<~String> - Marker to specify for next page
        def describe_rules(listener_id = nil, rule_ids = [], options = {})
          rule_ids = [*rule_ids]
          params = {}
          params['Marker'] = options[:marker] if options[:marker]
          params['PageSize'] = options[:page_size] if options[:page_size]
          params.merge!(Fog::AWS.serialize_keys('RuleArns', rule_ids)) if rule_ids.any?
          params.merge!('ListenerArn' => listener_id) if listener_id
          request({
            'Action' => 'DescribeRules',
            :parser => Fog::Parsers::AWS::ELBV2::DescribeRules.new
          }.merge(params))
        end
      end

      class Mock
        def describe_rules(listener_id = nil, rule_ids = [], options = {})
          listener = self.data[:load_balancer_listeners][listener_id]
          raise Fog::AWS::ELBV2::NotFound if listener_id && !listener

          rules = self.data[:load_balancer_listener_rules].select { |rule|
            rule_ids.any? && rule_ids.include?(rule['RuleArn']) || listener_id && rule['ListenerArn'] == listener_id
          }

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeRulesResult' => {
              'Rules' => rules
            }
          }
          response
        end
      end
    end
  end
end
