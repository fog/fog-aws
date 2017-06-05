module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeListeners < Fog::Parsers::Base
          RESULT_KEY = 'DescribeListenersResult'
          def reset
            @listeners = []
            @default_actions = []
            @response = { self.class::RESULT_KEY => {}, 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'Listeners'
              @in_listeners = true
            when 'DefaultActions'
              @in_default_actions = true
            when 'member'
              if @in_default_actions
                @default_action = {}
              else
                @listener = {}
              end
            end
          end

          def end_element(name)
            case name
            when 'member'
              if @in_default_actions
                @default_actions << @default_action
                @default_action = nil
              elsif @in_listeners
                @listeners << @listener
                @listener = nil
              end

            when 'DefaultActions'
              @listener['DefaultActions'] = @default_actions
              @default_actions = []
              @in_default_actions = false

            when 'Listeners'
              @response[self.class::RESULT_KEY]['Listeners'] = @listeners

            when 'LoadBalancerArn', 'Protocol', 'Port', 'ListenerArn'
              @listener[name] = value if @listener

            when 'TargetGroupArn', 'Type'
              @default_action[name] = value if @default_action

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
