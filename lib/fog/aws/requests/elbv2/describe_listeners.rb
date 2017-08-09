module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_listeners'

        # Describes the specified listeners or the listeners for the specified Application Load Balancer. You must specify either a load balancer or one or more listeners.
        #
        # ==== Parameters
        # * lb_id<~String> - The Amazon Resource Name (ARN) of the load balancer.
        # * listener_ids<~Array> - The Amazon Resource Names (ARN) of the listeners.
        # * options<~Hash>
        #   * :marker<~String> - The marker for the next set of results.
        #   * :page_size<~Integer> - The maximum number of results to return with this call. Range is 1...400.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeListenersResult'<~Hash>:
        #       * 'Listeners'<~Array>:
        #         * 'Certificates'<~Array>: The SSL server certificate.
        #           * 'CertificateArn'<~String> - The Amazon Resource Name (ARN) of the certificate.
        #         * 'DefaultActions'<~Array>: The default actions for the listener.
        #           * 'Type'<~String> - The type of action, value is always "forward"
        #           * 'TargetGroupArn'<~String> - The Amazon Resource Name (ARN) of the target group.
        #         * 'ListenerArn'<~String> - The Amazon Resource Name (ARN) of the listener.
        #         * 'LoadBalancerArn'<~String> - The Amazon Resource Name (ARN) of the load balancer.
        #         * 'Port'<~Integer> - The port on which the load balancer is listening.
        #         * 'Protocol'<~String> - The protocol for connections from clients to the load balancer.
        #         * 'SslPolicy'<~String> - The security policy that defines which ciphers and protocols are supported. The default is the current predefined security policy.
        #     * 'NextMarker'<~String> - Marker to specify for next page
        def describe_listeners(lb_id = nil, listener_ids = [], options = {})
          listener_ids = Array(listener_ids)
          params = {}
          params['Marker'] = options[:marker] if options[:marker]
          params['PageSize'] = options[:page_size] if options[:page_size]

          params['LoadBalancerArn'] = lb_id if lb_id
          params.merge!(Fog::AWS.serialize_keys('ListenerArns', listener_ids)) if listener_ids.any?
          request({
            'Action' => 'DescribeListeners',
            :parser => Fog::Parsers::AWS::ELBV2::DescribeListeners.new
          }.merge(params))
        end
      end

      class Mock
        def describe_listeners(lb_id = nil, listener_ids = [], options = {})
          listener_ids = [*listener_ids]
          listeners = self.data[:load_balancer_listeners]
          listeners = listener_ids.any? ? listeners.values_at(*listener_ids) : listeners.values
          raise Fog::AWS::ELBV2::ListenerNotFound if listener_ids && listeners.none?

          listeners = listeners.select { |listener|
            listener['LoadBalancerArn'] == lb_id
          } if lb_id

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeListenersResult' => {
              'Listeners' => listeners
            }
          }
          response
        end
      end
    end
  end
end
