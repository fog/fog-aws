module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/modify_listener'

        # Modifies the specified properties of the specified listener.
        # Any properties that you do not specify retain their current values. However, changing the protocol from HTTPS to HTTP removes the security policy and SSL certificate properties. If you change the protocol from HTTP to HTTPS, you must add the security policy and server certificate.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_ModifyListener.html

        #
        # ==== Parameters
        # * listener_id<~String> - :description
        #
        # ==== Optional parameters
        # * port<~Integer> - The port for connections from clients to the load balancer.
        # * default_actions<~Array> - The default action for the listener
        #   * 'Type'<~String> - The type of action, value is always "forward"
        #   * 'TargetGroupArn'<~String> - The Amazon Resource Name (ARN) of the target group.
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
        #     * 'ModifyListenerResult'<~Hash>:
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
        def modify_listener(listener_id, port = nil, default_actions = [], protocol = 'HTTP', ssl_policy = nil, certificates = [])
          params = {}

          params.merge!(Fog::AWS.serialize_keys('DefaultActions', default_actions)) if default_actions.any?
          params.merge!(Fog::AWS.serialize_keys('Certificates', certificates)) if certificates.any?

          params['Port'] = port if port
          params['Protocol'] = protocol if protocol
          params['SslPolicy'] = ssl_policy if ssl_policy

          request({
            'Action' => 'ModifyListener',
            'ListenerArn'       => listener_id,
            :parser => Fog::Parsers::AWS::ELBV2::ModifyListener.new
          }.merge(params))
        end
      end

      class Mock
        def modify_listener(listener_id, port, default_actions, protocol = 'HTTP', ssl_policy = nil, certificates = [])
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

          listener_data = self.data[:load_balancer_listeners][listener_id]
          raise Fog::AWS::ELBV2::NotFound unless listener_data

          merge_data = {
            'DefaultActions' => default_actions,
            'Port' => port,
            'Protocol' => protocol
          }
          merge_data['Certificates'] = certificates if certificates.any?
          merge_data['SslPolicy'] = ssl_policy if ssl_policy

          listener_data.merge!(merge_data)

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'ModifyListenerResult' => {
              'Listeners' => [listener_data]
            }
          }
          response
        end
      end
    end
  end
end
