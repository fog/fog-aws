module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeListeners < Fog::Parsers::Base
          def reset
            reset_listener
            @default_action = {}
            @certificate = {}
            @redirect_config = {}
            @results = { 'Listeners' => [] }
            @response = { 'DescribeListenersResult' => {}, 'ResponseMetadata' => {} }
          end

          def reset_listener
            @listener= { 'DefaultActions' => [], 'Certificates' => [] }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'DefaultActions'
              @in_default_actions = true
            when 'Certificates'
              @in_certificates = true
            end
          end

          def end_element(name)
            if @in_default_actions
              case name
              when 'member'
                @listener['DefaultActions'] << @default_action
                @default_action = {}
              when 'Type', 'TargetGroupArn'
                @default_action[name] = value
              when 'Path', 'Protocol', 'Port', 'Query', 'Host', 'StatusCode'
                @redirect_config[name] = value
              when 'RedirectConfig'
                @default_action[name] = @redirect_config
                @redirect_config = {}
              when 'DefaultActions'
                @in_default_actions = false
              end
            else
              case name
              when 'member'
                if @in_certificates
                  @listener['Certificates'] << @certificate
                  @certificate = {}
                else
                  @results['Listeners'] << @listener
                  reset_listener
                end
              when 'LoadBalancerArn', 'Protocol', 'Port', 'ListenerArn'
                @listener[name] = value
              when 'CertificateArn'
                @certificate[name] = value
              when 'Certificates'
                @in_certificates = false

              when 'RequestId'
                @response['ResponseMetadata'][name] = value

              when 'NextMarker'
                @results['NextMarker'] = value

              when 'DescribeListenersResponse'
                @response['DescribeListenersResult'] = @results
              end
            end
          end
        end
      end
    end
  end
end
