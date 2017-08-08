module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/empty'
        # Delete an existing Elastic Load Balancer
        #
        # ==== Parameters
        # * lb_id<~String> - ARN of the ELB to be deleted
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def delete_load_balancer(lb_id)
          request({
            'Action'           => 'DeleteLoadBalancer',
            'LoadBalancerArn'  => lb_id,
            :parser            => Fog::Parsers::AWS::ELBV2::Empty.new
          })
        end
      end

      class Mock
        def delete_load_balancer(lb_id)
          raise lb_id.inspect+self.data[:load_balancers].inspect unless self.data[:load_balancers][lb_id]
          raise Fog::AWS::ELBV2::NotFound unless self.data[:load_balancers].delete(lb_id)

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DeleteLoadBalancerResult' => nil
          }

          response
        end
      end
    end
  end
end
