module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/empty'
        # Delete an existing Elastic Load Balancer listener
        #
        # ==== Parameters
        # * listener_id<~String> - ARN of the listener to be deleted
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def delete_listener(listener_id)
          request({
            'Action'          => 'DeleteListener',
            'ListenerArn'     => listener_id,
            :parser           => Fog::Parsers::AWS::ELBV2::Empty.new
          })
        end
      end

      class Mock
        def delete_listener(listener_id)
          raise Fog::AWS::ELBV2::NotFound unless self.data[:load_balancer_listeners].delete(listener_id)

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DeleteListenerResult' => nil
          }

          response
        end
      end
    end
  end
end
