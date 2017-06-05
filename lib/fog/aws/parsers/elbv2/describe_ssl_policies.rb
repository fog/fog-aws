module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeSslPolicies < Fog::Parsers::Base
          # {
          #   SslPolicies => [
          #     {
          #       Ciphers: [ {Name, Priority} ],
          #       Name,
          #       SslProtocols: [ String ]
          #     }
          #   ]
          # }
          def reset
            @ssl_policies = []
            @ssl_protocols = []
            @ciphers = []
            @response = { 'DescribeSSLPoliciesResult' => {}, 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'SslPolicies'
              @in_ssl_policies = true
            when 'SslProtocols'
              @in_ssl_protocols = true
            when 'Ciphers'
              @in_ciphers = true
            when 'member'
              if @in_ciphers
                @cipher = {}
              elsif @in_ssl_protocols
              elsif @in_ssl_policies
                @ssl_policy = {}
              end
            end
          end

          def end_element(name)
            case name
            when 'member'
              if @in_ciphers
                @ciphers << @cipher
                @cipher = nil
              elsif @in_ssl_protocols
                @ssl_protocols << value
              elsif @in_ssl_policies
                @ssl_policies << @ssl_policy
              end

            when 'Name'
              if @in_ciphers
                @cipher[name] = value
              else
                @ssl_policy[name] = value
              end

            when 'Priority'
              @cipher['Priority'] = value.to_i if @in_ciphers

            when 'Ciphers'
              @ssl_policy['Ciphers'] = @ciphers
              @in_ciphers = false

            when 'SslProtocols'
              @ssl_policy['SslProtocols'] = @ssl_protocols
              @ssl_protocols = []
              @in_ssl_protocols = false

            when 'SslPolicies'
              @response['DescribeSSLPoliciesResult']['SslPolicies'] = @ssl_policies

            when 'RequestId'
              @response['ResponseMetadata'][name] = value

            when 'NextMarker'
              @results['NextMarker'] = value

            end
          end
        end
      end
    end
  end
end
