module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/create_listener'

        # Creates a listener for the specified Application Load Balancer.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateListener.html
        #
        # ==== Parameters
        # * lb_id<~String> - The Amazon Resource Name (ARN) of the load balancer.
        # * port<~Integer> - The port on which the load balancer is listening.
        # * default_actions<~Array> - The default action for the listener
        #   * 'Type'<~String> - The type of action, value is always "forward"
        #   * 'TargetGroupArn'<~String> - The Amazon Resource Name (ARN) of the target group.
        #
        # ==== Optional parameters
        # * protocol<~String> - The protocol for connections from clients to the load balancer. Valid values: "HTTP", "HTTPS". Default is "HTTP".
        # * ssl_policy<~String> - The security policy that defines which ciphers and protocols are supported. The default is the current predefined security policy.
        # * certificates<~Array> - Array of SSL server certificates. You must provide exactly one certificate if the protocol is HTTPS. Default is empty Array.
        #   * 'CertificateArn'<~String> - The Amazon Resource Name (ARN) of the certificate.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'CreateListenerResult'<~Hash>:
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
        def create_listener(lb_id, port, default_actions, protocol = 'HTTP', ssl_policy = nil, certificates = [])
          params = {}
          params.merge!(Fog::AWS.indexed_param('DefaultActions.member', default_actions))
          params.merge!(Fog::AWS.indexed_param('Certificates.member', certificates)) if certificates.any?

          params['SslPolicy'] = ssl_policy if ssl_policy

          request({
            'Action'            => 'CreateListener',
            'LoadBalancerArn'   => lb_id,
            'Port'              => port,
            'Protocol'          => protocol,
            :parser             => Fog::Parsers::AWS::ELBV2::CreateListener.new
          }.merge(params))
        end
      end

      class Mock
        def create_listener(lb_id, port, default_actions, protocol = 'HTTP', ssl_policy = nil, certificates = [])
          raise Fog::AWS::ELBV2::NotFound unless load_balancer = self.data[:load_balancers][lb_id]

          if certificates.any?
            existing_certificate_ids = Fog::AWS::IAM::Mock.data[@aws_access_key_id][:server_certificates].map {|n, c| c['Arn'] }

            certificate_id = certificates.first['CertificateArn']
            unless existing_certificate_ids.include?(certificate_id)
              raise Fog::AWS::IAM::NotFound.new('CertificateNotFound')
            end
          elsif protocol == 'HTTPS'
            raise Fog::AWS::ELBV2::ValidationError
          end

          unless %w(HTTP HTTPS).include?(protocol)
            raise Fog::AWS::ELBV2::ValidationError
          end

          listener_id = Fog::AWS::Mock.arn('elasticloadbalancing', self.data[:owner_id], "listener/app/#{load_balancer['Name']}", @region)

          listener = {
            'LoadBalancerArn' => lb_id,
            'ListenerArn' => listener_id,
            'Port' => port.to_s,
            'Protocol' => protocol,
            'SslPolicy' => ssl_policy,
            'Certificates' => certificates,
            'DefaultActions' => default_actions
          }
          self.data[:load_balancer_listeners][listener_id] = listener

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'CreateListenerResult' => {
              'Listeners' => [listener]
            }
          }
          response
        end
      end
    end
  end
end
