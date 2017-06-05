module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/set_ip_address_type'

        IP_ADDRESS_TYPES = ['ipv4', 'dualstack']

        # Sets the type of IP addresses used by the subnets of the specified Application Load Balancer.
        #
        # ==== Parameters
        # * lb_id<~String> - The Amazon Resource Name (ARN) of the load balancer.
        # * ip_address_type<~String> - The IP address type. The possible values are ipv4 (for IPv4 addresses) and dualstack (for IPv4 and IPv6 addresses). Internal load balancers must use ipv4.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'SetIpAddressTypeResult'<~Hash>:
        #       * 'IpAddressType'<~String> - The IP address type.
        def set_ip_address_type(lb_id, type)
          request({
                    'Action'            => 'SetIpAddressType',
                    'LoadBalancerArn'   => lb_id,
                    'IpAddressType'     => type,
                    :parser             => Fog::Parsers::AWS::ELBV2::SetIpAddressType.new
                  })
        end
      end

      class Mock
        def set_ip_address_type(lb_id, type)
          response = Excon::Response.new
          response.status = 200

          load_balancer = self.data[:load_balancers][lb_id]
          raise Fog::AWS::ELBV2::NotFound unless load_balancer

          load_balancer['IpAddressType'] = type

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'SetIpAddressTypeResult' => {
              'IpAddressType' => type
            }
          }
          response
        end
      end
    end
  end
end
