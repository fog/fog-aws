module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/empty'
        # Deletes the specified rule.
        #
        # ==== Parameters
        # * rule_id<~String> - The Amazon Resource Name (ARN) of the rule.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def delete_rule(rule_id)
          request({
            'Action'          => 'DeleteRule',
            'RuleArn'         => rule_id,
            :parser           => Fog::Parsers::AWS::ELBV2::Empty.new
          })
        end
      end

      class Mock
        def delete_rule(rule_id)
          rules = self.data[:load_balancer_listener_rules]
          self.data[:load_balancer_listener_rules] = rules.delete_if { |rule| rule['RuleArn'] == rule_id }

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            }
          }

          response
        end
      end
    end
  end
end
