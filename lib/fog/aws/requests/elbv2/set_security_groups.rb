module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/set_security_groups'

        # Associates the specified security groups with the specified load balancer. The specified security groups override the previously associated security groups.
        #
        # ==== Parameters
        # * lb_id<~String> - The Amazon Resource Name (ARN) of the load balancer.
        # * security_group_ids<~Array> - The IDs of the security groups. Array of strings.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'SetSecurityGroupsResult'<~Hash>:
        #       * 'SecurityGroupIds'<~Array> - The IDs of the security groups associated with the load balancer. Array of strings.
        def set_security_groups(lb_id, security_group_ids)
          params = {}

          params.merge!(Fog::AWS.serialize_keys('SecurityGroups', security_group_ids))
          request({
                    'Action'            => 'SetSecurityGroups',
                    'LoadBalancerArn'   => lb_id,
                    :parser             => Fog::Parsers::AWS::ELBV2::SetSecurityGroups.new
                  }.merge!(params))
        end
      end

      class Mock
        def set_security_groups(lb_id, security_group_ids)
          load_balancer = self.data[:load_balancers][lb_id]
          raise Fog::AWS::ELBV2::NotFound unless load_balancer

          load_balancer.merge!('SecurityGroups' => security_group_ids)

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'SetSecurityGroupsResult' => {
              'SecurityGroups' => security_group_ids
            }
          }
          response
        end
      end
    end
  end
end
